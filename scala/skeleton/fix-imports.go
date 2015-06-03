package main

import (
	"bufio"
	"bytes"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"sort"
	"strings"
	"sync"

	"github.com/Bowbaq/pool"
)

var (
	external = []string{"play", "org", "com", "net"}
	lang     = []string{"scala", "java"}
	rewrites = map[string]string{
		" _root_.util":        " util",
		" Tap._":              " util.Tap._",
		" DataPoint.DataType": " models.DataPoint.DataType",
		" action.":            " controllers.action.",
		" helpers.":           " controllers.helpers.",
		" concurrent.":        " scala.concurrent.",
		" collection.":        " scala.collection.",
	}
	removes = []string{
		"import scala.Some",
	}
)

type comparator func(string, string) int

var (
	compare_lang     = compare_prefix(lang)
	compare_external = compare_prefix(external)
	comparators      = []comparator{compare_lang, compare_external, lexicographical}
)

var fixall bool
var optimize_wildcard bool

func init() {
	flag.BoolVar(&fixall, "all", false, "Use -all if you want to fix the whole project")
	flag.BoolVar(&optimize_wildcard, "optimize", false, "Use -optimize if you want to fix wildcard imports (slow)")
}

func main() {
	flag.Parse()

	runtime.GOMAXPROCS(8)

	if fixall {
		for _, project := range []string{"common", "processor", "ess"} {
			for _, folder := range []string{"app", "test"} {
				dir := project + "/" + folder
				clean(dir)
				if optimize_wildcard {
					in, out := make(chan string, 1), make(chan string, 10)
					p := play(in, out, project)
					app_files := find_scala_files(dir)
					optimize(app_files, in, out)

					in <- "exit"
					p.Wait()
				}
			}
		}
	} else {
		modified := find_modified_scala_files()
		clean_files(modified)
	}
}

func clean(root string) {
	paths := find_scala_files(root)
	clean_files(paths)
}

func clean_files(paths []string) {
	var wg sync.WaitGroup
	wg.Add(len(paths))

	p := pool.NewPool(8, func(id uint, payload interface{}) interface{} {
		process(payload.(string))
		wg.Done()

		return nil
	})

	for _, path := range paths {
		p.Submit(pool.NewJob(path))
	}

	wg.Wait()
}

func find_scala_files(root string) []string {
	paths := make([]string, 0)
	filepath.Walk(root, func(path string, f os.FileInfo, err error) error {
		if is_valid_scala_file(path) {
			paths = append(paths, path)
		}
		return nil
	})

	return paths
}

func find_modified_scala_files() []string {
	modified_files := make([]string, 0)

	modified, err := exec.Command("git", "ls-files", "-m").Output()
	if err != nil {
		log.Println(err)
		return modified_files
	}

	for _, path := range strings.Split(strings.TrimSpace(string(modified)), "\n") {
		if is_valid_scala_file(path) {
			modified_files = append(modified_files, path)
		}
	}

	return modified_files
}

func is_valid_scala_file(path string) bool {
	return strings.HasSuffix(path, ".scala") && !strings.HasSuffix(path, "package.scala")
}

func process(path string) {
	log.Println("Processing", path)
	package_line, imports, code, err := analyse_file(path)
	if err != nil {
		log.Println(err)
		return
	}

	err = rewrite_file(path, package_line, imports.Clean(code), code)
	if err != nil {
		log.Println(err)
	}
}

func play(in, out chan string, project string) *exec.Cmd {
	cmd := exec.Command("play")
	stdin, _ := cmd.StdinPipe()
	go func() {
		io.WriteString(stdin, "project "+project+"\n")
		for c := range in {
			io.WriteString(stdin, c+"\n")
		}
	}()

	stdout, _ := cmd.StdoutPipe()
	go func() {
		scanner := bufio.NewScanner(stdout)
		for scanner.Scan() {
			if strings.Contains(scanner.Text(), "Set current project to "+project) {
				break
			}
		}

		output := make([]string, 0)
		for scanner.Scan() {
			line := scanner.Text()
			output = append(output, line)
			if strings.Contains(line, "Total time:") {
				out <- strings.Join(output, "\n")
				output = make([]string, 0)
			}
		}
	}()

	cmd.Start()

	return cmd
}

func optimize(paths []string, in, out chan string) {
	for _, path := range paths {
		log.Println("Processing", path)
		package_line, imports, code, err := analyse_file(path)
		if err != nil {
			log.Println(err)
			return
		}

		additions := make([]string, 0)
		removals := make([]string, 0)

		imports.Expand()
		for x, imp := range imports.imports {
			if strings.HasSuffix(imp, "._") {
				add, err := optimize_import(path, package_line, imports.imports, code, x, in, out)
				if err == nil {
					log.Println("Success", imp, add)
					additions = append(additions, add...)
					removals = append(removals, imp)
				} else {
					log.Println("Failure", imp)
				}
			}
		}

		for _, r := range removals {
			imports.Remove(r)
		}
		imports.imports = append(imports.imports, additions...)
		rewrite_file(path, package_line, imports.Clean(code), code)
	}
}

func optimize_import(path, package_line string, imports, code []string, x int, in, out chan string) ([]string, error) {
	finder, _ := regexp.Compile("not found: (value|type) ([A-Z][A-Za-z_]+)")
	imp := imports[x]

	imports_copy := make([]string, len(imports))
	copy(imports_copy, imports)
	imports = imports_copy

	imports = append(imports[:x], imports[x+1:]...)
	rewrite_file(path, package_line, imports, code)

	needed_set := make(map[string]bool)
	var needed []string

	for i := 0; i < 5; i++ {
		log.Println("Attempt", i)
		in <- "test:compile"
		output := <-out
		log.Println(string(output))
		if !strings.Contains(string(output), "error") {
			return needed, nil
		}

		for _, line := range strings.Split(string(output), "\n") {
			matches := finder.FindStringSubmatch(line)
			if len(matches) == 3 {
				needed_set[matches[2]] = true
			}
		}

		needed = make([]string, 0)
		for k, _ := range needed_set {
			needed = append(needed, imp[:len(imp)-1]+k)
		}

		imports = append(imports, needed...)
		rewrite_file(path, package_line, imports, code)
	}

	return nil, errors.New("couldn't resolve imports")
}

func analyse_file(path string) (string, *Imports, []string, error) {
	content, err := ioutil.ReadFile(path)
	if err != nil {
		return "", nil, nil, err
	}

	scanner := bufio.NewScanner(bytes.NewReader(content))

	// First line of file is package declaration
	scanner.Scan()
	package_line := scanner.Text()

	imports := &Imports{make([]string, 0)}
	code := make([]string, 0)
	all_imports_found := false
	for scanner.Scan() {
		line := scanner.Text()

		switch {
		case strings.HasPrefix(line, "import"):
			imports.Add(line)

		case len(strings.TrimSpace(line)) == 0 && !all_imports_found:
			// Ignore blank lines in the import section
			continue

		default:
			if !all_imports_found {
				all_imports_found = true
			}
			code = append(code, line)
		}
	}

	return package_line, imports, code, nil
}

func rewrite_file(path, package_line string, imports, code []string) error {
	file, err := os.OpenFile(path, os.O_WRONLY|os.O_TRUNC, 0666)
	if err != nil {
		return err
	}
	defer file.Close()

	// Write package line + newline
	file.WriteString(package_line + "\n\n")

	// Write clean imports
	if len(imports) > 0 {
		file.WriteString(strings.Join(imports, "\n") + "\n\n")
	}

	// Write back rest of file
	file.WriteString(strings.Join(code, "\n") + "\n")

	return nil
}

type Imports struct {
	imports []string
}

func (i *Imports) String() string {
	return strings.Join(i.imports, "\n")
}

func (i *Imports) Add(imp string) {
	i.imports = append(i.imports, imp)
}

func (i *Imports) Clean(code []string) []string {
	i.Expand()
	for from, to := range rewrites {
		i.Rewrite(from, to)
	}
	for _, r := range removes {
		i.Remove(r)
	}
	i.Sort()
	i.Dedup()
	i.RemoveUnused(code)
	i.Compact()

	return i.imports
}

func (i *Imports) Expand() {
	expanded := make([]string, 0)
	for _, imp := range i.imports {
		if i := strings.Index(imp, "{"); i != -1 && !strings.Contains(imp, "=>") {
			prefix, group := imp[:i], imp[i+1:len(imp)-1]
			for _, item := range strings.Split(group, ",") {
				expanded = append(expanded, prefix+strings.TrimSpace(item))
			}
		} else {
			expanded = append(expanded, imp)
		}
	}
	i.imports = expanded
}

func (i *Imports) Rewrite(from, to string) {
	for x, imp := range i.imports {
		if strings.Contains(imp, from) {
			i.imports[x] = strings.Replace(imp, from, to, 1)
		}
	}
}

func (i *Imports) Remove(needle string) {
	for x, imp := range i.imports {
		if imp == needle {
			i.imports = append(i.imports[:x], i.imports[x+1:]...)
		}
	}
}

func (i *Imports) Sort() {
	sort.Sort(i)
}

func (i *Imports) Dedup() {
	seen := make(map[string]bool)
	unique := make([]string, 0)

	for _, imp := range i.imports {
		if _, in := seen[imp]; !in {
			unique = append(unique, imp)
			seen[imp] = true
		}
	}

	i.imports = unique
}

func (i *Imports) RemoveUnused(lines []string) {
	code := strings.Join(lines, "\n")

	used := make([]string, 0)
	for _, imp := range i.imports {
		if import_is_used(imp, &code) {
			used = append(used, imp)
		}
	}

	i.imports = used
}

var special_cases = []string{
	"scala.collection.JavaConversions",
	"scala.concurrent.ExecutionContext.Implicits",
	"scala.language.implicitConversions",
	"scala.sys.process",
	"play.api.Play.current",
}

func import_is_used(imp string, code *string) bool {
	i := strings.LastIndex(imp, ".")
	suffix := imp[i+1:]

	if suffix == "_" {
		return true
	}

	if strings.Contains(suffix, "=>") {
		return true
	}

	if strings.Contains(*code, suffix) {
		return true
	}

	for _, special_case := range special_cases {
		if strings.Contains(imp, special_case) {
			return true
		}
	}

	return false
}

func (i *Imports) Compact() {
	groups := make(map[string][]string)
	prefixes := make([]string, 0)

	// Group imports
	for _, imp := range i.imports {
		i := strings.LastIndex(imp, ".")
		prefix, item := imp[:i], imp[i+1:]

		if items, ok := groups[prefix]; ok {
			groups[prefix] = append(items, item)
		} else {
			groups[prefix] = []string{item}
		}

		if !contains(prefixes, prefix) {
			prefixes = append(prefixes, prefix)
		}
	}

	grouped := make([]string, 0)
	previous := ""
	for _, prefix := range prefixes {
		// Insert newline to separate groups if needed
		if previous != "" && compare_external(previous, prefix[7:]) == -1 {
			grouped = append(grouped, "")
		}

		if previous != "" && compare_lang(previous, prefix[7:]) == -1 {
			grouped = append(grouped, "")
		}

		previous = prefix[7:]

		// Compact group
		group := groups[prefix]
		if len(group) == 1 {
			grouped = append(grouped, prefix+"."+group[0])
		} else {
			items, renames := make([]string, 0), make([]string, 0)
			for _, g := range group {
				if strings.Contains(g, "=>") {
					renames = append(renames, g)
				} else {
					items = append(items, g)
				}
			}

			if len(items) < 8 {
				grouped = append(grouped, prefix+".{"+strings.Join(items, ", ")+"}")
			} else {
				grouped = append(grouped, prefix+"._")
			}
			for _, r := range renames {
				grouped = append(grouped, prefix+"."+r)
			}
		}
	}

	i.imports = grouped
}

// Sort interface

func (i *Imports) Len() int {
	return len(i.imports)
}

func (i *Imports) Less(x, y int) bool {
	a, b := i.imports[x][7:], i.imports[y][7:]

	for _, comp := range comparators {
		switch comp(a, b) {
		case -1:
			return true
		case 1:
			return false
		}
	}

	return false
}

func (i *Imports) Swap(x, y int) {
	i.imports[x], i.imports[y] = i.imports[y], i.imports[x]
}

func lexicographical(a, b string) int {
	if a < b {
		return -1
	}

	return 1
}

func compare_prefix(prefixes []string) comparator {
	return func(a, b string) int {
		aHasPrefix, bHasPrefix := has_prefix(a, b, prefixes)
		switch {
		case !aHasPrefix && bHasPrefix:
			return -1
		case aHasPrefix && !bHasPrefix:
			return 1
		default:
			return 0
		}
	}
}

func has_prefix(a, b string, prefixes []string) (bool, bool) {
	aPrefixed, bPrefixed := false, false
	for _, prefix := range prefixes {
		if !aPrefixed && strings.HasPrefix(a, prefix) {
			aPrefixed = true
		}
		if !bPrefixed && strings.HasPrefix(b, prefix) {
			bPrefixed = true
		}
	}

	return aPrefixed, bPrefixed
}

func contains(haystack []string, needle string) bool {
	for _, straw := range haystack {
		if straw == needle {
			return true
		}
	}

	return false
}

// Not currently used, keeping for reference
var need_import = []string{"Reads", "Writes", "Format", "JsObject", "JsPath", "JsValue", "JsSuccess", "JsError", "__"}

func cleanup_json() {
	filenames, _ := exec.Command("ack", "-l", "play.api.libs.json.Json", "ess/app", "ess/test").Output()
	files := strings.Split(strings.Trim(string(filenames), "\n"), "\n")

	for _, file := range files {
		imports := []string{"Json"}
		for _, s := range need_import {
			import_needed, _ := exec.Command("ack", "-ci", s, file).Output()
			if strings.Trim(string(import_needed), "\n") != "0" {
				imports = append(imports, s)
			}
		}
		if len(imports) > 1 {
			replace := fmt.Sprintf("s/libs.json.Json/libs.json.\\{%s\\}/", strings.Join(imports, ", "))
			exec.Command("sed", "-i", "", replace, file).Run()
		}
	}
}