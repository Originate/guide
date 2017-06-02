# Originate Guides - Go

Golang is a great choice for CLI tools, API servers,
code that is getting deployed into external environments (e.g. agents),
and other network (micro) services.


## Advantages

_Bad programmers create complicated solutions for simple problems.
Good programmers create complex solutions for complex problems.
Geniuses create simple solutions for complex problems._

Go is an ingeniously simple solution
for the many complex problems encountered in modern,
large-scale, high-quality and high-velocity software engineering.
The genius underlying its simplicity isn't immediately obvious,
but is often confused for crudeness.
Nonetheless, Go addresses most of the issues found in large software projects
better than other languages:

* __Easy to learn:__
  Golang is the equivalent of [Simple English](https://simple.wikipedia.org/wiki/Main_Page)
  for programming languages.
  It is intentionally simple, both in structure and vocabulary.
  This has several positive effects:
  - new people on the team ramp up faster, and can contribute
  - all code can be read and understood by everybody at any skill level

* __One way to do things:__
  Other languages -
  especially the ones that have several ways of solving issues and formatting code -
  encourage limitless artistic expression of oneself in code.
  Ask 10 developers to solve the same problem,
  and you get 10 different programs.
  This is beautiful to some degree.
  The problem starts when there are several "artists" on the team,
  and they don't agree with each others styles.
  Too often good code is dismissed as "messy" and rewritten,
  not because it is bad,
  but because the person taking it over doesn't understand or like it's structure.
  This can be managed with strong tech leadership that determines the code style to be followed.
  In practice, these decisions are often arbitrary and subjective,
  not consistent between teams,
  and not every team in the world even has great tech leadership.

  Go intentionally does not enable artistic freedom,
  but encourages simple, straightforward code that gets to the point.
  There is often exactly one way to do something,
  and one way of formatting the code that does it.
  This means Go code written by different developers
  looks much more similar than is typical in other languages.
  Different people feel more at home in each others Go code bases.
  Even a bloody beginner can read, understand, and fix
  Go code written by a seasoned veteran,
  without having to spend months learning "advanced features" of the language,
  and without mental gymnastics understanding overly abstract concepts.
  This is incredibly important in real life,
  it's the essence of collaborative software development.

* __Standardized formatting:__
  There is one single way of formatting Go,
  enforced by the Go toolchain.
  It is not the prettiest way of formatting,
  but the simplest possible one,
  the one which causes the least amount of bikeshed or academic debates.
  It also allows heavily automated modification of code bases
  without irrelevant formatting or whitespace changes.
  For example, tools that parse source code into an AST,
  change the AST,
  and serialize the modified AST back into source code.
  An example is the `go fix` command,
  which allows to perform repetitive code changes
  in an automated way
  on a massive scale.

* __Fast compilation:__
  This in combination with structural typing
  makes Go feel as productive as working with a dynamically typed language,
  because there are almost no noticeable compile times.
  But with the safeties and conveniences of static type checking.

* __Speed:__
  Go runs very fast, leading to great interactive user experiences
  and efficient hardware utilization at scale.
  * no startup time because it ships as precompiled native code
  * sustained C-like speeds with negligible GC pauses that only take microseconds
  * a programming model close to the metal,
    meaning close to how CPU's actually work and how they manage memory
  * utilizes all cores on the user's machine via a simple
    [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) mechanism
    similar to the [Actor Model](https://en.wikipedia.org/wiki/Actor_model),
    on top of extremely inexpensive green threads.

* __Memory footprint:__
  Unlike the JVM (which often requires Gigabytes of RAM),
  a small Go processes only takes up 10-25 MB RAM.
  This is important in cloud environments
  where memory is limited and expensive,
  as well as on developer machines
  where we want to boot up an entire stacks on a single machine
  while leaving memory for other processes.

* __Self-contained deployment:__
  Go applications are deployed as a single executable file that includes all dependencies.
  No changes to the machine running the Go binary have to be made.
  No frameworks or libraries of a particular version have to be installed,
  possibly parallel to other existing versions of the same frameworks that are required for other tools,
  the server doesn't even need an active internet connection
  to download and compile dependencies as part of the installation of the tool.
  This is beneficial in production
  where changes to the server environment often require extensive approval and auditing,
  as well as on developer machines
  where users don't have to install frameworks in order to run your software anymore.
  Go executables will keep working unchanged in the future
  no matter what version of Go they and other tools running on that machine have been written in,
  independent of changes to the software setup of the OS or package managers,
  as long as the ABIs of the OS remain the same.

  The only exception to the above statement is dynamic linking against glibc
  when using the `net` and `os/user` packages.
  See [this article](https://dominik.honnef.co/posts/2015/06/go-musl)
  for more infomation.

* __Small deployment:__
  Go binaries are very concise in size.
  A Docker image for a small Go application is 15-25 MB in size,
  compared to >400 MB for Node/JVM.
  This matters when deploying a micro-service based application.
  Imagine deploying an application consisting of 50+ Docker images.
  With Node/JVM services, we have to upload 25 GB into the cloud,
  which will take a long time.
  With Go services the entire app is only 1 GB.
  This means it can be deployed much faster and more frequently,
  allowing important updates to reach production faster.

* __Built-in concurrency:__
  Modern hardware achieves speed through parallelization.
  Golang has high-level concurrency primitives built right into the language.
  This not only makes sure that Go programs scale well over cores.
  Unlike approaches that use libraries to achieve concurrency,
  all Go code is based on the same concurrency mechanism,
  concurrency is achieved with the least amount of boilerplate and overhead,
  and with tool support built into the languge toolchain.

* __Server-native language primitives:__
  On a fundamental level,
  cloud systems receive data, massage it (often in serveral steps), and then send it out again.
  Unlike OO or functional languages,
  which provide generic abstractions
  out of which one has to build custom systems that implement this workflow,
  Go provides language primitives
  that support the input-processing-output paradigm more directly:
  - readers and writers for streaming IO
  - functions for processing data
  - goroutines for concurrency
  - channels for piping data through a processing pipeline of concurrent goroutines

  Because all necessary primitives are provided by the language,
  Go programs express what they do very directly,
  without detours into abstractions that obfuscate the intent and degrade performance.

* __Cross-compilation__ to all major platforms:
  macOS, Linux, Windows, BSD, ARM

* __Industry-leading in the cloud/devops space:__
  Most Ops toolkits and libraries
  as well as a lot of the modern network technologies
  like HTTP/2
  are supported in Go first.


## Learn

__Beginners__
* start with [A tour of Go](https://tour.golang.org/welcome/1)
* [The Go Blog](https://blog.golang.org) describes lots of best practices
* in case you need it, [solutions](https://github.com/golang/tour/tree/master/solutions) to the Go tour

__Advanced__
* use [Effective Go](https://golang.org/doc/effective_go.html) as a reference later
* [GoDoc](https://godoc.org) for information on Go packages
* [Security Guidelines](https://www.gitbook.com/book/checkmarx/go-scp/details)


## Guidelines

* use `goimports` to automatically manage import statements and format the code for you
* follow the idiomatic code style of Go's standard library,
  the [naming conventions](https://talks.golang.org/2014/names.slide),
  the documented best practices in the [Go Blog](https://blog.golang.org),
  and the [code review comments](https://github.com/golang/go/wiki/CodeReviewComments)
* vendor dependencies using [glide](https://github.com/Masterminds/glide),
  at least until the [official package manager](https://github.com/golang/dep)
  is stable
* Only vendor dependencies for binaries, not for libraries.
  This means code bases that can be included into other code bases
  should not have a `vendor` folder.
  If several libraries vendor the same dependency,
  Go's type checker sees several copies of the source code of the dependency,
  in different import paths,
  possibly in different versions.
  This forces it to treat them as different types
  and causes all sorts of compiler errors.
  More info [here](https://peter.bourgon.org/go-best-practices-2016/#dependency-management).
* Use pure functions if possible,
  and provide dependencies explicitly,
  as small and tightly-scoped interfaces.


### Make the zero value useful

Go tries hard to make the zero value of variables useful.
For example, an empty string is a better zero value for strings than `nil`,
because you can use empty strings like any other string
without having litter your code base with nil checks.
When printed, it simply displays nothing if printed.
That's all you need in most situations.
Go cannot do this for your own custom types,
so it has to use `nil` as their zero value.
This doesn't mean that `nil` is always the best zero value, though.
Use the [null object pattern](https://en.wikipedia.org/wiki/Null_Object_pattern)
to save yourself and your users from having to litter their code with nil checks.
The Go library provides null implementations for many of it's elements, for example:
- [ioutil.Discard](https://golang.org/pkg/io/ioutil/#pkg-variables)
  for streams

__Example:__
Let's say cars have doors, but some toy cars don't.
We want to use doors in our code without having to check each time whether a car has doors.

```go
type Car struct {
  door Door
}

type Door interface {
  open() error
}

// NoDoor is a Door implementation that represents no door.
// You can use it like a normal door, it simply does nothing.
type NoDoor struct{}

func (d NoDoor) open() error {
  return nil
}

// NewCar creates a new car instance with the given door.
// If no door is given, it creates a car with a NoDoor.
func NewCar(d Door) Car {
  if d == nil {
  	d = NoDoor{}
  }
  return Car{Door: d}
}
```

Let's create a car with no door,
for example in a test where we don't care about the door:

```go
c := NewCar(nil)
```

Now our code can simply use the door, whether it is there or not:

```go
c.Door.open()
```

Instead of pervasive nil checks for every attribute each time we call it:

```go
if c.Door != nil {
  c.Door.open()
}
```

## Always set a sane value for timeouts when using http.Client

When initializing a HTTP Client generally people use

```go

client := &http.Client{}
```

However, this allows someone to hijack your goroutines. Look at this simple example:

```go
  svr := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    time.Sleep(time.Hour)
  }))
```

When you use

```go
http.Get(svr.URL)
```

Your client will hang for an hour and then terminate. In order to remedy this _always specify a sane timeout_:

```go
client := &http.Client{
  Timeout: time.second * 10,
}
```

Reference: [Don't use Go's default HTTP client (in production)](https://medium.com/@nate510/don-t-use-go-s-default-http-client-4804cb19f779)


## Recommended libaries

These libraries are considered the best ones for their intended purpose
and should be used unless there are justifiable reasons to do otherwise.
Trying a more modern alternative with clear benefits is a good reason here.
This is a living list, please suggest better ones via a PR.

__Larger frameworks__
* build CLI apps: [Cobra](https://github.com/spf13/cobra)
* simple [Sinatra](http://www.sinatrarb.com) or [Flask](http://flask.pocoo.org) like server:
  github.com/gin-gonic/gin

__Testing__
* end-to-end testing: [godog](https://github.com/DATA-DOG/godog)
* unit testing: [Ginkgo](https://github.com/onsi/ginkgo) and [Gomega](https://onsi.github.io/gomega/)

__Debugging__
* [go tooling in action](https://youtu.be/uBjoTxosSys) (video):
  explains how to compile, test, profile, and optimize Go code using flame graphs

__Smaller libraries__
* Postgres: github.com/lib/pq
* logging: github.com/Sirupsen/logrus
* generate UUIDs: github.com/satori/go.uuid
* parse CLI flags: github.com/jessevdk/go-flags
* rate limiting: golang.org/x/time/rate
* HTTP middleware: github.com/urfave/negroni

Find more in the [awesome Go list](https://github.com/avelino/awesome-go)


## Installation

see the dedicated [Go installation guide](go/install.md)


## Editors

* Vim: [vim-go](https://github.com/fatih/vim-go)
* Emacs: [go-mode](https://github.com/dominikh/go-mode.el)
* Sublime: [go-sublime](https://packagecontrol.io/packages/GoSublime)
* Jetbrains: [Gogland](https://www.jetbrains.com/go)
* [Visual Studio Code](https://code.visualstudio.com) with the [Go plugin](https://marketplace.visualstudio.com/items?itemName=lukehoban.Go)


## Alternatives

* use Bash for simple scripts that don't need to run on Windows
* consider [Electron](https://electron.atom.io) if your application needs a GUI,
  especially when you want to reuse an existing web UI
