# Originate Guides - Haskell Tool Stack

## Introduction to Stack

The goal of this guide is to give you a relatively quick overview of Stack, the one-stop shop for organizing a Haskell application. 

It should be enough to get you started, but if you want more details, you should read this more [in-depth guide](https://www.fpcomplete.com/blog/2015/08/new-in-depth-guide-stack) on FP Complete. You should also get familiar with the official [Stack website](https://docs.haskellstack.org/en/stable/README/).

In a nutshell, Stack is a package manager, project organizer, and script runner all wrapped into one program. It determines the versions of which libraries you need, compiles and builds your code against these libraries, creates your own library and executable files, runs your tests, and does this all in an isolated sandbox environment. Stack uses [Cabal](https://www.haskell.org/cabal/), an older Haskell package manager under the hood. It is for a number of reasons, a better option than using Cabal by itself, and thus it is the preferred tool of Originate Haskell developers. We will discuss these reasons at the end of the guide once we have a better picture of what is going on with Stack.

## Installation
To install stack you should go to their [official website](https://docs.haskellstack.org/en/stable/README/) and download the correct version for your OS. Follow the directions, and make sure the stack executable is on your path (so running the command `stack` from the terminal should do something). 

## Project Setup
Now that we have stack installed, let’s set up a new project with it. Let’s go to our home directory and run `stack new my-haskell-app && cd my-haskell-app`. This created 7 files. We will ignore the license file and `Setup.hs`, which is a short boilerplate file used by Cabal. 

We will look a bit at the stack.yaml file, the .cabal file, and then consider how the remaining files fit together with those.

## stack.yaml

This file is used by Stack to determine how to compile and build your application. The first (non-commented) field we see is the resolver. The resolver’s job is to figure out which packages to use in order to resolve all the package dependencies. Stack uses a number of different resolvers. Using a particular one will ensure that your builds are reproducible. By default, this should use the newest version of the `lts` resolver available on [stackage](https://www.stackage.org). The comment in the file also list a couple other possible resolvers. For instance `nightly-2015-09-21` was a particular resolver generated on a particular night. 

The next section lists the different packages which are included in the application. These can be subdirectories of the application, URLs to zip files on a file server, or Git repositories with relevant code. For now, our application simply uses its home directory `.` as a package. 

Next up we have a list of extra dependencies that our application needs. It currently doesn’t need any, but we’ll explore this more in a bit. Finally, we have an empty dictionary of flags used by [ghc](https://www.haskell.org/ghc) when compiling our project.

## my-haskell-app.cabal

This file is used by Cabal as a sort of manifest for your application. The top section contains keys for important project information (author, description, version, license, etc.). There is then a Library section describing parameters of your application’s library: the public API available to anyone (or any other module) which uses your program. You can only have 1 library per .cabal file. For larger projects, you will want to use multiple .cabal files to break it into different modules, each with their own library. The Library section contains information such as the public modules of the library, what directories they can be found in, which packages they depend on, and what Haskell language version should be used.

There are two other main types of sections: executables and test suites. The generated .cabal file contains one of each of these. Executables are the binary files which are exported and can be run when you install your program. They can each be given a particular list of compiler options and have the language version specified (you can pretty much always use [Haskell2010](https://hackage.haskell.org/package/haskell2010) for now). As with the library, they also include a directory for where to find the source code, as well as the name of the file which contains the Main module. We’ll go into this in more detail later in the tutorial. Like the library, they also contain a list of packages which they depend on. Notice that my-haskell-app is included as a build-depends item! This means that your executable depends on your library, which is perfectly sensible. 

The next section is a test-suite. A test suite is in fact a special type of executable. Rather than being installed on the user’s system following the `stack install` command (described later), these executables are automatically run by the `stack test` command, typically running a sequence of tests that you specify. The .cabal section contains all the attributes of an executable, as well as a type field, specifying what the command line should do if a test fails. As a note, both `stack install` and `stack test` are effectively modifications on the [stack build](https://docs.haskellstack.org/en/stable/build_command/) command, which you can explore for more details.

There is one more file section of the .cabal file. This simply describes the source control for the project, so we will ignore it. 

## Trying Things Out

Let’s try to get a better understanding of our project organization by looking at some of the basic actions we can take to change it. 

## Extending Our Library
Right now, our application’s library consists of a single module, called Lib, which exports a single function. The Main executable calls this function, which just prints a string. 

```
-- src/Lib.hs
...
someFunc :: IO ()
someFunc = putStrLn "someFunc"
```
```
>> stack install
...
>> my-haskell-app-exe
someFunc
```

We can make this a bit more interesting by adding a new function which takes a string as an argument, and adds to it:

```
-- src/Lib.hs
module Lib
    ( someFunc
    , sayYo
    ) where
...
sayYo :: String -> String
sayYo input = "Yo " ++ input ++ "!"
```

Then we can call this from our executable:
```
-- app/Main.hs
module Main where

import Lib

main :: IO ()
main = do
  someFunc
  print (sayYo "Haskellers")

```
```
>> stack install
...
>> my-haskell-app-exe
someFunc
“Yo Haskellers!”
```

To get a bit fancier, we can add a new module to our library. Let’s call this module MathLib, and put it in the same directory as Lib.hs.

```
-- src/MathLib.hs
module MathLib
  ( add5
  ) where

add5 :: Int -> Int
add5 x = x + 5
```

Now we want to call this new library from our main executable. 

```
-- app/Main.hs
...
import Lib
import MathLib

main :: IO ()
main = do
  someFunc
  print (sayYo "Haskellers")
  print (add5 4)
```

Now when we try to run `stack install` however, we get an error. This is because stack doesn’t know that the MathLib module is part of our library yet. To fix this, we must go into `my-haskell-app.cabal` and add MathLib as an exposed module of the library, so that it can be imported by the executable. 

```
-- my-haskell-app.cabal
library
  hs-source-dirs:    src
  exposed-modules:   Lib
                   , MathLib
...
```
Now we can install the app:
```
>> stack install
...
>> my-haskell-app.exe
someFunc
"Yo Haskellers!"
9
```

Note that in order to put the new module in a different folder from src, we would also need to add that directory to the hs-source-dirs portion of the library section in the .cabal file:

```
library
  hs-source-dirs:   src
                  , src/MathLibDir
```

## Adding Executables
Now that we know how to extend our library, let’s explore adding a new executable to our application. Let’s build an executable that actually takes some user input and does something with it. We’ll make it use both of our library functions:

```
-- app/InputExec.hs
module Main where

import Lib
import MathLib

main :: IO ()
main = do
  print "Hello, what is your name?"
  name <- getLine
  print $ sayYo name 
  print "What is your favorite number?"
  numberStr <- getLine
  print "Let's add 5!"
  print $ add5 (read numberStr :: Int) 
```

We ask the user for their name, send them a greeting, ask them for a number, and then add 5 to it. Notice that we need to import both of our Library modules. Also, since it is an executable, it must be in a module called `Main` and have a method called `main` of type `IO ()`. In order to add this executable to our program, we’ll also have to add a section for it in our Cabal file. 

```
executable my-haskell-app-input
  hs-source-dirs:      app
  main-is:             InputExec.hs
  ghc-options:         -threaded -rtsopts -with-rtsopts=-N
  build-depends:       base
                     , my-haskell-app
  default-language     Haskell2010
```

Now when we run `stack install`, we will also get the `my-haskell-app-input` executable. We can run it and observe the behavior:

```
>> stack install
...
>> my-haskell-app-input
"Hello, what is your name?"
James
"Yo James!"
"What is your favorite number?"
5
"Let's add 5!"
10
```

## Adding Test Suites
Now that we know how to add an executable, let’s figure out how to add a second test suite to test our library. We’ll run a couple tests for our `sayYo` function and our `add5` function. And we’ll also use an external testing library, which will show how easy it is to add dependencies to the different elements of our application. 

We’ll add the following file to the test directory:

```
-- test/LibTests.hs
module Main where

import Test.Tasty
import Test.Tasty.HUnit

import Lib
import MathLib

main :: IO ()
main = do
  defaultMain (testGroup "Our Library Tests" [sayYoTest, add5Test])

sayYoTest :: TestTree
sayYoTest = testCase "Testing sayYo"
  (assertEqual "Should say Yo to Friend!" "Yo Friend!" (sayYo "Friend"))

add5Test :: TestTree
add5Test = testCase "Testing add5"
  (assertEqual "Should add 5 to get 10" 10 (add5 5))
```

Like an executable, the test suite has a `Main` module with a `main :: IO ()` function. In this case we use a `defaultMain` function from `Test.Tasty`, which will run the tests we give it. Here we use the library `Test.Tasty.HUnit` to write a couple basic unit tests on the behavior of our functions. Now we also have to add the proper section to our .cabal file:

```
test-suite lib-test
  type:                exitcode-stdio-1.0
  hs-source-dirs:      test
  main-is:             LibTests.hs
  build-depends:       base
                     , tasty
                     , tasty-hunit
                     , my-haskell-app
  ghc-options:         -threaded -rtsopts -with-rtsopts=-N
  default-language:    Haskell2010
```

Notice that our dependencies section contains the package names for Tasty and Tasty.HUnit. That’s all we need to do to ensure we can use them. Stack will handle downloading and installing the proper versions. For any particular library you find on hackage, the lowercase name at the top left of the page (in the navigation bar) is what you will want to use in the .cabal file, as you can tell from [the Tasty website](http://hackage.haskell.org/package/tasty-hunit-0.9.2/docs/Test-Tasty-HUnit.html). Now we can run `stack test`, which will (after installing the necessary dependencies), run our new test suite:

```
>> stack test
...
my-haskell-app-0.1.0.0: test (suite: lib-test)

Our Library Tests
  Testing sayYo: OK
  Testing add5:  OK

All 2 tests passed (0.00s)
```

Now that we have a good overview of the main features of Stack, we can compare it to Cabal, the other big name in Haskell application organization.

## Stack vs. Cabal
So for a long time before stack, cabal was the go-to build tool for Haskell projects. In fact, Stack still uses Cabal for many things. However, Stack addresses many of Cabal’s shortcomings. Stack emphasizes repeatable builds. To this end, all building and compilation work is done in sandbox folders on a per project basis (notice the .stack-work folder in my-haskell-app). A particular library of source code, compiled with the same list of libraries, and the same resolver, will always result in the same build. No more worrying about whether or not library updates broke your code. Stack will know to use the older versions. 

Stack also works to develop curated lists of package versions which are known to work well with each other. With Cabal, it was very easy to install some package, only to find that the version you got did not compile against other libraries in your program due to conflicting dependencies. Worse, the default behavior was that packages were installed system wide, meaning that if you had multiple Haskell projects with conflicting dependencies, resolving it and getting either to build could be a total nightmare, a condition referred to as “Cabal Hell.”

Stack’s package lists and resolvers help alleviate the first problem, and the sandbox-as-default behavior stops the second problem from cropping up. Thus it is the new standard as far as Haskell application managers. 
