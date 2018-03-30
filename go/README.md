# Originate Guides - Go

*[Golang](https://golang.org/) is a programming language
with focus on pragmatism, wisdom instead of cleverness,
and engineering in the large.*

Go is great choice for CLI tools, API servers,
code that is getting deployed into external environments (e.g. agents),
and other network services,
be it extremely small (micro-services) or large (in terms of code or team size).


## Introduction to the language

* [overview](overview.md)
* [advantages](advantages.md)
* [installation](install.md)


## Learn

__Beginners__
* start with [A tour of Go](https://tour.golang.org/welcome/1)
* [The Go Blog](https://blog.golang.org) describes lots of best practices
* in case you need it, [solutions](https://github.com/golang/tour/tree/master/solutions) to the Go tour

__Advanced__
* use [Effective Go](https://golang.org/doc/effective_go.html) as a reference later
* [GoDoc](https://godoc.org) for information on Go packages
* [Security Guidelines](https://www.gitbook.com/book/checkmarx/go-scp/details)
* [Go at Google: Language Design in the Service of Software Engineering](https://talks.golang.org/2012/splash.article):
  overview of the philosophy behind Go
* [Building web applications with Golang](https://github.com/astaxie/build-web-application-with-golang) ebook


## Guidelines

* use `goimports` to automatically manage import statements and format the code for you
* follow the idiomatic code style of Go's standard library,
  the [naming conventions](https://talks.golang.org/2014/names.slide),
  the documented best practices in the [Go Blog](https://blog.golang.org),
  and the [code review comments](https://github.com/golang/go/wiki/CodeReviewComments)
* vendor dependencies using [glide](https://github.com/Masterminds/glide),
  at least until the [official package manager](https://github.com/golang/dep)
  is stable
* Only vendor dependencies for binaries, not for libraries ([learn more](vendoring.md))
* Use pure functions if possible
* provide dependencies explicitly, as small and tightly-scoped interfaces
* [make the zero value useful](zero-value.md)


## Tools

* [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports):
  configure your editor to run this after each file save
* [gorename](https://godoc.org/golang.org/x/tools/cmd/gorename):
  performs precise type-safe renaming of identifiers in Go source code
* [gofix](https://blog.golang.org/introducing-gofix)
* [gometalinter](https://github.com/alecthomas/gometalinter):
  runs dozens of linters in parallel over your source code,
  normalizing their output

### Always set a sane value for timeouts when using http.Client

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
  [github.com/gin-gonic/gin](https://github.com/gin-gonic/gin)

__Testing__
* end-to-end testing: [godog](https://github.com/DATA-DOG/godog)
* unit testing: [Ginkgo](https://github.com/onsi/ginkgo) and [Gomega](https://onsi.github.io/gomega/)

__Debugging__
* [go tooling in action](https://youtu.be/uBjoTxosSys) (video):
  explains how to compile, test, profile, and optimize Go code using flame graphs

__Smaller libraries__
* Postgres: [github.com/lib/pq](https://github.com/lib/pq)
* logging: [github.com/Sirupsen/logrus](https://github.com/Sirupsen/logrus)
* generate UUIDs: [github.com/satori/go.uuid](https://github.com/satori/go.uuid)
* parse CLI flags: [github.com/jessevdk/go-flags](https://github.com/jessevdk/go-flags)
* rate limiting: [golang.org/x/time/rate](https://golang.org/x/time/rate)
* HTTP middleware: [github.com/urfave/negroni](https://github.com/urfave/negroni)

Find more in the [awesome Go list](https://github.com/avelino/awesome-go)


## Editor Plugins

* Vim: [vim-go](https://github.com/fatih/vim-go)
* Emacs: [go-mode](https://github.com/dominikh/go-mode.el)
* Sublime: [go-sublime](https://packagecontrol.io/packages/GoSublime)
* Jetbrains: [Gogland](https://www.jetbrains.com/go)
* [Visual Studio Code](https://code.visualstudio.com) with the [Go plugin](https://marketplace.visualstudio.com/items?itemName=lukehoban.Go)


## Alternatives

* use Bash for simple scripts that don't need to run on Windows
* consider [Electron](https://electron.atom.io) if your application needs a GUI,
  especially when you want to reuse an existing web UI
