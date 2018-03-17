# Originate Guides - Go - Advantages

The Go designers put a lot of thought into the language design
to emphasize and achieve the following qualities:

* [easy to learn](#easy-to-learn)
* [one way to do things](#one-way-to-do-things)
* [standardized formatting](#standardized-formatting)
* [code maintenance automation](#code-maintenance-automation)
* [fast compilation](#fast-compilation)
* [execution speed](#execution-speed)
* [small memory footprint](#small-memory-footprint)
* [Self-contained deployment](#self-contained-deployment)
* [Package management](#package-management)
* [Small deployment](#small-deployment)
* [Built-in concurrency](#built-in-concurrency)
* [Server-native language primitives](#server-native-language)
* [Cross-compilation](#cross-compilation)
* [Industry-leading](#industry-leading)


## Easy to learn

Golang is the equivalent of [Simple English](https://simple.wikipedia.org/wiki/Main_Page)
for programming languages.
It is intentionally simple, both in structure and vocabulary.
This has several positive effects:
- new people on the team ramp up faster and can contribute earlier (within days)
- code written by a Go master can be read, understood, and contributed to by a novice


## One way to do things

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
but because the person taking it over doesn't understand or like its structure.
This can be managed with strong tech leadership and/or well-thought conventions that determine the code style to be followed.
In practice, these decisions are often arbitrary and subjective,
not consistent between teams,
and not every team in the world has great tech leadership.

Go intentionally does not enable artistic freedom,
but encourages simple, straightforward code that gets to the point.
There is often exactly one way to do something,
and one way of formatting the code that does it.
This means Go code written by different developers
looks much more similar than is typical in other languages.
Different people feel more at home in each others Go code bases.
Even a novice beginner can read, understand, and fix
Go code written by a seasoned veteran,
without having to spend months learning "advanced features" of the language,
and without mental gymnastics understanding overly abstract concepts.
This is incredibly important in real life;
it's the essence of collaborative software development.


## Standardized formatting

There is one single way of formatting Go,
enforced by the Go toolchain.
It is not the prettiest way of formatting,
but the simplest possible one,
the one which causes the least amount of
[bike-shed](https://en.wikipedia.org/wiki/Law_of_triviality) or academic debates.
This enforces that everybody uses the same code style,
and is therefore more familiar with other people's code.


## Code maintenance automation

Go is built from the ground up to make it easy to modify code via automated tools
without irrelevant formatting or whitespace changes.
One part of that is the standardized formatting,
which guarantees that code expressions always look exactly the same,
allowing more efficient search-and-replace
and guaranteeing that file changes only reflect the actual code change,
and not for example whitespace or indentation changes.
Go also makes parsers, the AST, and serialization of the AST available to third-party developers,
which has led to a rich ecosystem of automated code maintenance tools.

An example is the [gorename](https://godoc.org/golang.org/x/tools/cmd/gorename)
tool, which performs precise type-safe renaming of identifiers in Go source code.
This tool can be used from any text editor including Vim, Emacs, Sublime, Atom, or any IDE.

Another example is the [go fix](https://blog.golang.org/introducing-gofix) command,
which allows to perform repetitive code updates
in an automated way
on a massive scale.
This helps prevent
[technical drift](http://blog.codeclimate.com/blog/2013/12/19/are-you-experiencing-technical-drift),
which inevitably bring every large code base down.

There are many dozens of other third-party refactoring tools, linters, and other little helpers.
It is not uncommon to use dozens of them on Go projects,
to keep the code base in good shape without having to burn too much human bandwidth.
An overview is given in the [tools section](README.md#tools)


## Fast compilation

This in combination with structural typing
makes Go feel as productive as working with a dynamically typed language,
because there are almost no noticeable compile times,
but with the safeties and conveniences of static type checking.


## Execution speed

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


## Small memory footprint

Unlike the JVM (which often requires gigabytes of RAM),
a small Go process only takes up 10-25 MB RAM.
This is important in cloud environments
where memory is limited and expensive,
as well as on developer machines
where we want to boot up an entire stack on a single machine
while leaving memory for other processes.


## Self-contained deployment

Go applications are deployed as a single executable file that includes all dependencies.
No changes to the machine running the Go binary have to be made.
No frameworks or libraries of a particular version have to be installed,
inadvertently in parallel to other existing versions of the same frameworks that are required for other tools.
The server doesn't even need an active internet connection
to download and compile dependencies as part of the installation of the tool.
This is beneficial in production
where changes to the server environment often require maintenance windows, extensive approval and auditing,
and on developer machines
where there is no need to install frameworks in order to run your software anymore.
Go executables will keep working unchanged in the future
no matter what version of Go they, and other tools running on that machine, have been written in,
independent of changes to the software setup of the OS or package managers,
as long as the [ABIs](https://en.wikipedia.org/wiki/Application_binary_interface) of the OS remain the same.

The only exception to the above statement is dynamic linking against glibc
when using the `net` and `os/user` packages.
See [this article](https://dominik.honnef.co/posts/2015/06/go-musl)
for more infomation.


## Package Management

Go does not use a central repository for third-party libraries,
but links directly to the respective repositories and downloads (vendors)
them into the code base using [glide](https://github.com/Masterminds/glide).
This has many advantages:
- no need to configure different repositories
  (various public repos, internal caches like Artifactory, etc).
  Get your modules from anywhere, including private Git repos.
- there is no global namespace for package names anymore.
  Library authors can pick the most appropriate name for their library,
  independently of whether this name is used elsewhere already
- the code base compiles on its own after checkout,
  without further downloads of dependencies.
- deployments never break,
  even if hosted packages or entire package repositories
  slow down or cease to exist
  (which has happened in the past)
- no floating version madness
  or uncertainty whether a version was changed after publishing
- no reliance that every library author properly follows semantic versioning
  (which many don't)
- third-party code can be reviewed, analyzed, linted, and tested
  before being checked into the code base and used.
  This ensures that quality third-party libraries are used
- a slow or unavailable package server does not prevent setups and deploys
- no bit rot since packages are bundled into a stand-alone binary that
  keep running all just by itself


## Small deployment

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


## Built-in concurrency

Modern hardware achieves speed through parallelization.
Golang has high-level concurrency primitives built right into the language.
This not only makes sure that Go programs scale well over cores.
Unlike approaches that use libraries to achieve concurrency,
all Go code is based on the same concurrency mechanism,
concurrency is achieved with the least amount of boilerplate and overhead,
and with tool support built into the languge toolchain.


## Server-native language primitives

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


## Cross-compilation

Using [gox](https://github.com/mitchellh/gox) you can create binaries for
macOS, Linux, Windows, BSD, ARM, and other platforms.


## Industry-leading

Go is leading the DevOps/Cloud space.
Many modern projects are written in Go:
- [Docker](https://www.docker.com)
- [Kubernetes](https://kubernetes.io)
- [Terraform](https://www.terraform.io)
