# Originate Guides - Go

Golang is used for Ops, CLI tools, small API servers,
code that is getting deployed into external environments (e.g. agents),
and other network (micro) services at Originate.


## Advantages

Go has a number of unique advantages that make it a very attractive option
for a variety of use cases.

* Go runs very fast, leading to great interactive user experiences
  and efficient hardware utilization at scale.
  Reasons:
  * no startup time because it ships as precompiled native code
  * sustained C-like speeds with negligible GC pauses that only take milliseconds
  * utilizes all cores on the user's machine via a simple
    [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) mechanism
    similar to the [Actor Model](https://en.wikipedia.org/wiki/Actor_model),
    on top of extremely inexpensive green threads.

* Go applications are deployed as a single executable file that includes all dependencies.
  * small file size (15-25 MB Docker image vs >400 MB for Node/JVM)
  * small runtime footprint (10-25 MB RAM for a small server vs 512-1024 for JVM)

  This means no changes to the machine the tool is running on have to be made,
  like installing frameworks or libraries in a particular version,
  or an active internet connection to download dependencies as part of the installation of the tool.
  Also, the executable will keep working unchanged in the future
  independent of changes to the software setup of the OS or package managers,
  as long as the ABIs of the OS remain the same.

  The only exception to the above statement is dynamic linking against glibc
  when using the `net` and `os/user` packages.
  See [this article](https://dominik.honnef.co/posts/2015/06/go-musl)
  for more infomation.

* Easy cross-compilation to all major platforms: macOS, Linux, Windows, BSD, ARM

* Most Ops toolkits and libraries
  as well as a lot of the modern network technologies
  like HTTP/2
  are being developed on and are therefore available in Go first.

* Easy to learn.
  Golang is the equivalent of [Simple English](https://simple.wikipedia.org/wiki/Main_Page)
  for programming languages.
  It is intentionally simple, both in structure and vocabulary,
  and there is often only one (very simple) way to do and format things.
  This means Go code written by different developers looks very similar,
  it is clear and unambiguous,
  and people at all skill levels can read and understand it all the same.

  Go code bases might not be the prettiest or most artistic examples of computer programming,
  but they work, are robust, performant,
  and maintainable by everybody.
  Go is relatively easy to learn even for non-developers
  (comparable to JavaScript and Ruby, and far ahead of Scala or Haskell).
  Code reviews for Go code bases rarely end up in academic debates
  about which language feature or developer preference is the most appropriate,
  elegant, or idiomatic in a particular situation.
  All of this is tremendously valuable when
  a variety of different developers
  at different skillsets
  collaborate,
  and to get work done that is more interesting
  than the programming language used to implement it.


## Learn

* [A tour of Go](https://tour.golang.org/welcome/1):
  quick intro for Go beginners, start here
* [Effective Go](https://golang.org/doc/effective_go.html):
  read through this to get fully up to speed
* [The Go Blog](https://blog.golang.org):
  a lot of the documentation of best practices
* [Go Playground](https://play.golang.org):
  to try out Go in the browser
* [go tooling in action](https://youtu.be/uBjoTxosSys) (video):
  explains how to compile, test, profile, and optimize Go code using flame graphs
* [GoDoc](https://godoc.org) for information on Go packages


## Guidelines

* use `goimports` to automatically manage import statements and format the code for you
* follow the documented best practices in the
  [Go Blog](https://blog.golang.org) and the
  [code review comments](https://github.com/golang/go/wiki/CodeReviewComments)
* vendor dependencies using [glide](https://github.com/Masterminds/glide),
  at least until the [official package manager](https://github.com/golang/dep)
  is stable


## Recommended libaries

These libraries are considered the best ones for their intended purpose
and should be used unless there are justifiable reasons to do otherwise.
Trying a more modern alternative with clear benefits is a good reason here.
This is a living list, please suggest better ones via a PR.

Larger frameworks:
* build CLI apps: [Cobra](https://github.com/spf13/cobra)
* simple [Sinatra](http://www.sinatrarb.com) or [Flask](http://flask.pocoo.org) like server:
  github.com/gin-gonic/gin

Testing:
* end-to-end testing: [godog](https://github.com/DATA-DOG/godog)
* unit testing: [Ginkgo](https://github.com/onsi/ginkgo) and [Gomega](https://onsi.github.io/gomega/)


Smaller libraries:
* Postgres: github.com/lib/pq
* logging: github.com/Sirupsen/logrus
* generate UUIDs: github.com/satori/go.uuid
* parse CLI flags: github.com/jessevdk/go-flags
* rate limiting: golang.org/x/time/rate

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
