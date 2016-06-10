# Code analysis and style checking

In addition to unit and integration testing, it's highly recommended to utilize static code analysis and linting to further ensure the correctness, efficiency, and cleanliness of your code.


## Static code analysis

Xcode has a built-in mechanism for statically analyzing your code -- the `Build > Analyze` command. It utilizes the Clang compiler to analyze source code and detect bugs and identify code smells.


## Style checking

Having a consistent and clean style across a team has many benefits:

1. easier to spot bugs and code smells
2. less friction and time wasted during code reviews
3. better code comprehension and increase programmer effectiveness

There are third-party tools that can automatically format Objective-C code to adhere to a given set of code style rules.


## Tools

### [OCLint](http://oclint.org/)

> OCLint is a static code analysis tool for improving quality and reducing defects by inspecting C,
> C++ and Objective-C code and looking for potential problems like:
>
> * Possible bugs - empty if/else/try/catch/finally statements
> * Unused code - unused local variables and parameters
> * Complicated code - high cyclomatic complexity, NPath complexity and high NCSS
> * Redundant code - redundant if statement and useless parentheses
> * Code smells - long method and long parameter list
> * Bad practices - inverted logic and parameter reassignment

There are [60+ rules](http://docs.oclint.org/en/stable/rules/index.html) that it can check your code with, and you can even write [custom rules](http://docs.oclint.org/en/stable/devel/rules.html) for it to use.

### [clang-format](http://clang.llvm.org/docs/ClangFormat.html)

> A tool to format C/C++/Obj-C code

Supports approximately [60 rules](http://clang.llvm.org/docs/ClangFormatStyleOptions.html#configurable-format-style-options) for formatting the style of code. Somewhat limited in use.

### [uncrustify](http://uncrustify.sourceforge.net/)

> Source Code Beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA
>
> * Indent code, aligning on parens, assignments, etc
> * Align on '=' and variable definitions
> * Align structure initializers
> * Align `#define` stuff
> * Align backslash-newline stuff
> * Reformat comments (a little bit)
> * Fix inter-character spacing
> * Add or remove parens on return statements
> * Add or remove braces on single-statement `if/do/while/for` statements
> * Supports embedded SQL `EXEC SQL` stuff
> * Highly configurable - 454 configurable options as of version 0.60

*"There are currently 489 options and minimal documentation."*


# Recommended project setup

## Prerequisites

```bash
# install oclint
$ brew cask install oclint

# install clang-format
$ brew install clang-format
```

## Setup

1. Create folder at project root called `scripts/`
2. Code analysis
    * Automatically run Xcode's Analyze tool during every compile
        * Build Settings
            * [x] Analyze During 'Build' (**Yes**)
            * [x] Mode of Analysis for 'Analyze' (**Deep**)
            * [x] Mode of Analysis for 'Build' (**Shallow** / **Deep** if build times are still reasonable)
            * [x] Treat Warnings as Errors (**Yes**)
    * Further analysis with OCLint
        * Add [`oclint.sh`](../files/oclint.sh) to `scripts/`
        * Create an OCLint target ([detailed instructions](http://docs.oclint.org/en/stable/guide/xcode.html))
        * Add new target (Aggregate type), named **OCLint**
            * Add a Run Script to the Build Phases:
            ```bash
            source "${SRCROOT}/scripts/oclint.sh"
            ```

3. Code style
    * Create [.clang-format](../files/.clang-format) and [.uncrustify.cfg](../files/.uncrustify.cfg) at the project root
    * Add [`clang-format.sh`](../files/clang-format.sh) and [`uncrustify.sh`](../files/uncrustify.sh) to `scripts/`
    * Add new target (Aggregate type), named **Format code style**
        * Add a Run Script to the Build Phases:
        ```bash
        source "${SRCROOT}/scripts/clang-format.sh"
        source "${SRCROOT}/scripts/uncrustify.sh"
        ```


## Notes

### _OCLint_ target

The oclint script provided here is based off [this gist](https://gist.github.com/gavrix/5054182).

This script will:

1. Ensure that `oclint` exists (assumed to be installed via homebrew-cask)
2. Use `xcodebuild` → `oclint-xcodebuild` to generate the `compile_commands.json` that `oclint` requires for understanding the project hierarchy
3. Run `oclint`

By default, some of the oclint rules have been disabled and some directories excluded from analysis. These may need to be modified on a per-project basis.

As of this writing, the way oclint is being used here by Xcode (via oclint-json-compilation-database) doesn't provide a mechanism for importing a [.oclint configuration file](https://github.com/lqi/oclint-docs/blob/master/howto/rcfile.rst), which is why the config flags must be added to the invocation of oclint within this script.


### _Format code style_ target

`clang-format` has a limited set of code style options, so `uncrustify` runs after it as part of the **Format code style** process.
