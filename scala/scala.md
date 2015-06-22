Originate's Scala Style Guide
=============================

Introduction
------------

In this guide, we leverage mainly two documents which contain the bulk of our recommendations:

0. The official [Scala Style Guide] for formatting conventions.

0. Twitter's "[Effective Scala]" for coding style and best practices.

We will highlight any cases where we diverge from the original documents and include reasons for doing so.

### Organization

This guide is organized as follows:

0. The first section, "[Code Formatting](#code-formatting)", covers only formatting style, i.e., guidelines that should not produce any different bytecode:
    1. The section itself is a highlight of the main points of the official Scala Style Guide.Reading the official guide completely is still required.
    1. The subsection "[Additions and Deviations from the Official Style Guide](#additions-and-deviations-from-the-official-style-guide)" contains the points were we differ from the official guide, plus some topics that are not covered by it. To ease onboarding and favor consistency, we tried to deviate as little as possible from the official guide.
0. The second section, "[Best Practices](#best-practices)" cover rules that usually produce different bytecode:
    1. "[Additional recommendations](#additional-recommendations)" are, for the most part, required to be followed, unless there is a very good reason not to.
    1. "[Tips & Tricks](#tips--tricks)" are mostly "reminders", they do not apply everywhere. Keep them in mind and use your best judgement.
    1. "[Additional Remarks](#additional-remarks)" are more general, broad, and subjective remarks. It is a little of boiler plate advice.

A skeleton project accompanies this guide. It encodes and enforces as many best practices as currently available tools allow. Try to use as much of the companion configuration as you can on your Scala projects.

Code Formatting
---------------

Please read the [Scala Style Guide] carefully. The main points to consider are:

0. Use **two spaces** indentation.

0. Omit unnecessary blocks to reduce excessive nesting:

    ```scala
    if (condition) {
      bad()
    }

    if (condition) good()
    ```

0. Avoid wrapping lines. Split long lines into multiple expressions, assigning intermediate results to `val`s. When inevitable, indent wrapped lines once (two spaces).

0. Use lower camel case for `valName`, `varName`, `methodName`, `functionObject`, `packageObject`, and `annotationName`.

0. Use upper camel case for `ConstantName`, `ClassName`, `ObjectName`, `TypeParameter`.

0. No `UPPERCASE_UNDERSCORE`, not even for constants or type parameters.

0. No `get`/`set` prefixes for accessors and mutators.

0. Always use empty parentheses when, and only when, declaring or calling methods with side-effects.

0. Unless a clear convention already exists (e.g, mathematical symbols), avoid symbolic method names (*"operators"*).

0. Use type inference where possible. But put clarity first and favor explicitness when an inferred type may not be obvious.

    ```scala
    val good = 1 // Int, obviously

    val bad = config.get("key") // What does it return?
    val better: Option[String] = config.get("key")
    ```

0. Public methods must always have explicit return types.

0. Opening curly braces (`{`) must be on the same line as the declaration.

0. Constructors should be declared all on one line. If not possible, put each constructor argument on its own line, indented **four** spaces.

0. Extensions follow the same rule above, but indent **two** spaces to provide visual separation between constructor arguments and extensions:

    ```scala
    class Platypus (
        name: String,
        age: Int)
      extends Beaver
      with Duck
    ```

0. Favor short, single-expression, single-line method bodies.

0. No procedure syntax.

    ```scala
    def bad() { ??? }
    def worse { ??? }

    def good(): Unit = { ??? }
    ```

0. Postfix operator notation is unsafe and shall not be used. Consider it deprecated. Never import `scala.language.postfix`!

    ```scala
    val bad = seq mkString

    val good = seq.mkString
    ```

0. Always use infix notation for methods with symbolic names or higher-order functions (`map`, `foreach`, etc.).

    ```scala
    val bad = seq.map(_ * 2)

    val good = seq map (_ * 2)
    ```

    When the syntax does not allow it, stick to traditional method invocation syntax:

    ```scala
    val bad = (seq map f).toSet // Starts to read like LISP

    val good = seq.map(f).toSet
    ```

### Additions and Deviations from the Official Style Guide

0. Text file format: UTF-8, no BOM, Unix line endings (LF, '\n'), newline at EOF.

0. 100 characters maximum line length.

0. One blank line between method, class, and object definitions.

0. Use blank lines between fields to create logical groupings.

0. No double blank lines, anywhere.

0. No trailing whitespace at the end of lines, they cause problems when diffing between files or between versions. Configure your text editor to do this for you.

0. Avoid vertical alignment, they make commit diffs longer.

0. Modifiers should be declared in the following order: `override`, `abstract`, `private` or `protected`, `final`, `sealed`, `implicit`, `lazy`.

0. Put imports at the top of the file. Imports should be grouped in the following order:
    1. The project own classes
    1. Main framework (e.g, Play, Spray, etc.)
    1. Secondary frameworks (e.g, Slick, Akka, etc.)
    1. `scala.*`
    1. `java.*` and `javax.*`
    1. Third-party libraries: `com.*`, `net.*`, `org.*`, etc.

    Inside each group, packages and classes must be sorted alphabetically. Separate groups with blank lines.

    Use the following mnemonic to remember package order: your project is built on top of the frameworks, which is built on Scala, which is built on top of Java. Third-party libraries are less important, therefore come last.

    The script `fix-imports.go` in the skeleton project folder can be used to help you organize your imports.

0. Avoid relative imports. Full imports are easier to search, and never ambiguous:

    ```scala
    package foo.bar

    // bad
    import baz.Qux

    // good
    import foo.bar.baz.Qux
    ```

0. The bigger the scope, the more descriptive the name. Only for very small, local scopes may single-letter mnemonics be used.

0. Use `_` for simple, single line functions:

    ```scala
    seq filter (_ % 2 == 0)
    ```

0. Omit the `_` for functions that take a single argument:

    ```scala
    seq foreach println(_) // bad

    seq foreach println // good
    ```

0. The formatting rules for constructors (four-space double indent) also apply to method declarations:

    ```scala
    def delta(
        a: Int,
        b: Int,
        c: Int): Int = {
      b * b - 4 * a * c
    }
    ```

0. Use infix notation for single argument methods on monadic types (`contains`, `getOrElse`, etc.)

0. When passing function blocks, avoid "inner block" syntax:

    ```scala
    (bad => {
      ???
    })

    { good =>
      ???
    }
    ```

0. When passing single line function blocks, use parens. For multiline, use brackets:

    ```scala
    seq map (_ * 2)

    seq map { a =>
      a * 2
    }
    ```

0. In general, obey English rules and mathematical conventions for punctuation:

    1. A single space after (no space before) `,`, `:`, `;`, `)`, etc.

    1. A single space before (no space after) `(`, except for method invocation or declaration.

    1. Single spaces around `=`, `+`, `-`, `*`, `{`, `}`, `=>`, `<-`, etc.

    1. No spaces between consecutive `(` or `)`.

0. For documentation comments, use Javadoc left-hand margin style. Scaladoc convention is silly.

0. **Optimize for readability.** Readability trumps consistency (but not by much). Consistency trumps everything else.

Best Practices
--------------

It is definitely recommended to read the full Twitter's "[Effective Scala]" guide. The following sections highlight areas most often seen in our applications:

0. [_Return type annotations_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Return%20type%20annotations)

0. [_Type aliases_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Type%20aliases)

0. [_Implicits_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Implicits)

0. [_Collections_](http://twitter.github.io/effectivescala/#Collections) - Pay special attention to [performance](http://twitter.github.io/effectivescala/#Collections-Performance)

0. [_Functional programming_](http://twitter.github.io/effectivescala/#Functional%20programming)

0. [_Pattern matching_](http://twitter.github.io/effectivescala/#Functional%20programming-Pattern%20matching)

### Additional recommendations

0. [Error handling](http://tersesystems.com/2012/12/27/error-handling-in-scala/).

0. Using [Options](http://blog.originate.com/blog/2014/06/15/idiomatic-scala-your-options-do-not-match/).

0. Do not use `return`: http://tpolecat.github.io/2014/05/09/return.html

0. Always use the most generic collection type possible, typically one of: `Iterable[T]`, `Seq[T]`, `Set[T]`, or `Map[T]`.

0. Use `Seq[T]`, not `List[T]` (see: [http://stackoverflow.com/a/10866807/410286](http://stackoverflow.com/a/10866807/410286)) except where you specifically need to force one implementation over another. The most common exception is that Play form mappers require `List[T]`, so you have to use it there. `Seq` is the interface, `List` the implementation, analogous to `Map` and `HashMap` in Java.

0. Do not overuse tuples, decompose them or better, use case classes:

    ```scala
    val paul = Some(("Paul", 42))

    // Bad
    paul map { p => s"Name: ${p._1}, Age: ${p._2}")

    // Better
    paul map { case (name, age) => s"Name: $name, Age: $age")

    // Best
    case class Person(name: String, age: Int)

    val paul = Some(Person("Paul", 42))

    paul map { p => s"Name: ${p.name}, Age: ${p.age}")
    ```

0. Do not overdo method chaining, use `val`s to name intermediate steps:

    ```scala
    val bad = xs.filter(...).map(...).exists(...)

    val filteredXs = xs filter (...)
    val ys = filteredXs map xToY
    val answer = ys exists (...)
    ```

0. Avoid wildcard-importing entire packages: `import package._`

0. Avoid implicit conversions (`implicit def`), use implicit classes instead. In other words, do not import `scala.language.implicitConversions`.

0. Avoid matching on `case _`. Be specific and thorough, favor exhaustive matches. Do not let unforeseen conditions simply and silently fall through.

0. Never use `null`, use `Option` instead. If dealing with legacy APIs, encapsulate it: `Option(OldJava.mayBeNull())`

0. Avoid `Some.apply`, use `Option.apply` instead. `Option.apply` protects against `null`, while `Some.apply` is perfectly happy to return `Some(null)`, eventually raising your code an NPE. Also note that `Some.apply` is type-inferred as `Some[T]`, not `Option[T]`.

    ```scala
    val bad = Some(System.getenv("a")) // NPE waiting to happen

    val good = Option(System.getenv("a")) // Would return None
    ```

    By the principle of least astonishment, use `Option.apply` even if you "know" your reference can never be null. By being consistent, we avoid wondering whether a `Some.apply` in the code was intentional or something the developer overlooked:

    ```scala
    val bad = Some(math.random())

    val good = Option(math.random()) // and never have to worry about it again
    ```

0. Avoid [`JavaConversions`](http://www.scala-lang.org/api/current/scala/collection/JavaConversions$.html), use [`JavaConverters`](http://www.scala-lang.org/api/current/scala/collection/JavaConverters$.html) and its multiple `asScala` and `asJava` methods. While `JavaConversions` may happen "automagically" at unexpected times, usually masquerading type errors, `JavaConverters` gives you explicit control of when conversions happen (only as dangerous as you want). You can then transparently use Java collections as if they were Scala collections, usually for performance or interoperability reasons:

    ```scala
    import scala.collection.JavaConverters.mapAsScalaMapConverter
    import scala.collection.mutable

    val map: mutable.Map[String, String] = new java.util.HashMap[String, String].asScala
    map += "foo" -> "bar"
    assert(map("foo") == "bar")
    ```

    ```scala
    // Counter-example
    val m = Map(1 -> "one")
    m.contains("") // type mismatch

    import collection.JavaConversions._
    m.contains("") // false
    ```
0. Instead of throwing exceptions, return a more suitable type: `Option`, `Either`, or `Try`. Exceptions are not functional. Functions that throw exceptions are not total functions, they do not return a value for all possible inputs.

0. Do not `try` to `catch` exceptions, `Try` to catch exceptions! `Try` does for exceptions what `Option` does for `null`.

0. Remember that `Future` already encapsulates a `Try`. Avoid `Future[Try[T]]`, instead use `Future.failed`, `Future.fromTry`, and `Future.successful`.

0. No matter what, never use a "catch-all" exception handler. Some features in Scala are implemented relying on exceptions. Use `NonFatal` instead:

    ```scala
    import scala.util.control.NonFatal

    try {
      1 / 0
    } catch {
      case e: Exception => // Bad
      case _: Throwable => // Worse
      case _ =>            // Worst! Compiler will warn and "recommend" the line above.
      case NonFatal(e) =>  // The only acceptable way to catch all exceptions.
    }
    ```

0. Make judicious use of the various assertion types offered by Scala. See http://www.scala-lang.org/api/current/index.html#scala.Predef$ for the complete reference.

    1. Assertions (`assert(1 > 0)`) are used to document and check design-by-contract invariants in code. They can be disabled at runtime with the `-Xdisable-assertions` command line option.

    1. `require` is used to check pre-conditions, blaming the caller of a method for violating them. Unlike other assertions, `require` throws `IllegalArgumentException` instead of `AssertionError` and can never be disabled at runtime.

        Make ample and liberal use of `require`, specially in constructors. Do not allow invalid state to ever be created:

        ```scala
        case class Person(name: String, age: Int) {
          require(name.trim.nonEmpty)
          require(age >= 0)
          require(age <= 130)
        }
        ```

        Please note that even though `require` throws an exception, this is not a violation of the previous recommendations. Constructors are not methods, they cannot return `Try[Person]`.

    1. `ensuring` is used on a method return value to check post-conditions:

        ```scala
        def square(a: Int) = {a * a} ensuring (_ > 0)
        ```

0. Know well and make good use of the standard Scala collections library classes and methods:

    1. Never test if `c.length == 0` (may be O(n)), use `c.isEmpty` instead.

    1. Instead of `c.filter(_ > 0).headOption`, use `c find(_ > 0)`.

    1. Instead of `c.find(_ > 0).isDefined`, use `c exists (_ > 0)`.

    1. Instead of `c exists (_ == 0)`, use `c contains 0`.

0. Do not import `scala.collection.mutable._` or even a single mutable collection directly. Instead, import the `mutable` package and use it explicitly as a namespace prefix to denote mutability:

    ```scala
    // Bad, too subtle and risky for the inattentive reader.
    import scala.collection.mutable.Set
    val set = Set(1, 2, 3)

    // Better
    import scala.collection.mutable
    val set = mutable.Set(1, 2, 3)
    ```

0. No "stringly" typed code. Use `Enumeration` or `sealed` types and `case object`s. In many cases, `Enumeration` and `sealed` types are interchangeable, but they do not fully overlap. `Enumeration`, for instance, does not check for exhaustive matching while `sealed` types do not, well, enumerate.

0. If an API is not 100% "typesafe" (for instance, all parameters are of type `Int` or `String`), always use named parameters to disambiguate:

    ```scala
    def geo(latitude: Double, longitude: Double) = ???

    val bad = geo(a, b)

    val good = geo(latitude = a, longitude = b)
    ```

0. Whenever possible, simplify pattern matching expressions by omitting the `match` keyword and using partial functions:

    ```scala
    bad map {
      _ match {
        case 1 => "one"
        case _ => "not one"
      }
    }

    good map {
      case 1 => "one"
      case _ => "not one"
    }
    ```

0. Avoid boolean arguments or "magic booleans". Do not model any arbitrary two possible states as booleans:

    ```scala
    // Bad
    case class Person(male: Boolean)
    case class Car(isAutomatic: Boolean, isEletric: Boolean, isFourDoor: Boolean)

    // Good
    sealed trait Gender
    case object Male extends Gender
    case object Female extends Gender

    case class Person(gender: Gender)

    // Bad
    def findPeople(filterMales: Boolean): Seq[People]

    // Good
    def findMales: Seq[People]
    def findFemales: Seq[People]
    ```

0. Do not define abstract `val`s in traits and abstract classes. Abstract `val`s are a source of headaches and unexpected behavior in Scala:

    ```scala
    trait Bad {
      val bad: Int
      val worse = bad + bad
    }

    object ImBad extends Bad {
      val bad = 1
    }

    assert(ImBad.worse == 2)
    assert(ImBad.worse == 0)
    ```

    Always prefer abstract `def`: they are more general, abstract, and safer:

    ```scala
    trait Good {
      def good: Int
      val better = good + good
    }

    object ImGood extends Good {
      def good = 1
    }

    assert(ImGood.better == 2)
    ```

    Note: beware that overriding the abstract `def` with a concrete `val` also suffers from the problem above.

0. Avoid `lazy val`. `lazy val` is *not* free, or even cheap. Use it only if you absolutely need laziness semantics for correctness, not for "optimization". The init of a `lazy val` is super-expensive due to monitor acquisition cost, while every access is expensive due to `volatile`. Worse, `lazy val` [may deadlock](http://axel22.github.io/2013/06/10/on-lazy-vals.html).

    > `lazy val`s are compiled into a double-checked locking instance with a dedicated `volatile` guard. Notably, this compilation template yields a source of significant performance woes: we need to pass through the `volatile` read on the guard boolean for every read of the `lazy val`. This creates write barriers, cache invalidation and general mayhem with a lot of the optimizations that HotSpot tries to perform. All for a value that may or may not even care about asynchronous access, and even more importantly, is guaranteed to be true only once and is false indefinitely thereafter (baring hilarious tricks with reflection). Contrary to what is commonly believed, this guard isn't simply optimized away by HotSpot (evidence for this comes from benchmarks on warm code and assembly dumps).

    ![You keep using that word, I do not think it means what you think it means](lazyval.jpg "You keep using that word, I do not think it means what you think it means")

0. Secondary constructors: with default parameters, secondary constructors are a lot less frequently needed in Scala than in Java. But they can still be quite useful, use them when needed. Just avoid pathological cases:

    ```scala
    class Bad(a: Int, b: Int) {
      def this(a: Int) = this(a, 0)
    }

    class Good(a: Int, b: Int = 0)
    ```

0. If you need to wrap a value that can be immediately computed into a `Future`, use `Future.successful`, which returns an already completed `Future`. Calling `Future.apply` incurs all the overhead of starting an asynchronous computation, no matter if the computation is a simple, immediate result:

    ```scala
    if (bad) Future(0)

    if (good) Future.successful(str.trim)
    ```

0. When combining `Future`s in for-comprehensions, do not use the following idiom:

    ```scala
    for {
      a <- futureA
      b <- futureB
      c <- futureC
    } yield a + b + c
    ```

    Unless `futureB` depends on `a` and `futureC` depends on `b`, that will unnecessarily chain the `Future`s, only starting one after the previous one has finished, which most likely defeats its purpose. To properly combine the results of `Future`s started in parallel, using the following idiom:

    ```scala
    val fa = futureA
    val fb = futureB
    val fc = futureC

    for {
      a <- fa
      b <- fb
      c <- fc
    } yield a + b + c
    ```

0. Avoid structural types, do not import `scala.language.reflectiveCalls`. Structural types are implemented with reflection at runtime, and are inherently less performant than nominal types.

Tips & Tricks
-------------

0. Make plentiful use of value classes to enforce stronger typing. Combine them with implicit classes to define extension methods.

    ```scala
    // Value classes
    case class Email(email: String) extends AnyVal // no extra object allocation at runtime

    val email = Email("no@one.com") // never gets mixed with regular strings

    // Extension methods
    implicit class IntOps(val n: Int) extends AnyVal {
      def stars = "*" * n
    }

    5.stars // equivalent to a static method call, no implicit conversion actually takes place
    ```

0. Leverage parallel collections, use `.par` judiciously.

0. Use the `@tailrec` annotation to ensure the compiler can recognize a recursive method is tail-recursive.

0. Whenever possible, prefer `private[this]` over `private` and `final val` over `val` as they enable the Scala compiler and the JVM to perform additional optimizations. (If `final val` surprised you, remember that it is not redundant, as in Scala `final` means "cannot be overridden", while in Java it may mean both that as well as "cannot be reassigned").

0. `import System.{currentTimeMillis => now}` or `import System.{nanoTime => now}` are very useful to have around.

Additional Remarks
------------------

0. Program in Scala. You are not writing Java, Haskell, or Python.

0. Leverage type safety. Let the compiler and the type system do the grunt work for you. Type early, type often.

0. Favor immutability, avoid mutability whenever possible. Mutability encapsulated in small scopes internal to functions is acceptable.

0. Obey the principle of least astonishment.

0. Always favor readability.

0. Brevity enhances clarity.

0. Favor generic code but not at the expensive of clarity.

0. Be always aware of the trade offs you make.

0. Premature optimization yada yada is not an excuse to do stupid things on purpose!

0. Do not leave unreachable ("dead") code behind.

0. Do not comment out code, that is what version control is for.

0. Take advantage of simple language features that afford great power but avoid the esoteric ones, especially in the type system.

0. Learn and use the most advanced features of your favorite text editor. Make sure to configure it to perform as many formatting functions for you as possible, so that you do not have to think about it: remove whitespace at end of lines, add a newline at end of file, etc. If your editor does not support even those "basic" advanced features, find yourself a better one. :-)

0. Functions should communicate purpose and intent.

    Kent Beck tells the history of a piece of code, a single line method in a word processor, that astonished him the first time he saw it, something like `def highlight(x: X) = underline(x)`. Why write a straightforward alias for the `underline` function, he asked himself? Then he realized the power of this simple abstraction.

    It just so happened that highlights, at that particular point in time, were implemented with underlinings, but that does not mean that highlights and underlines are the same thing, serve the same purpose. Highlights are semantic, underlines are presentational.

    It could be that, in the future, it were decided a highlight should have, say, a yellow background. That would be a trivial change using the method above, taking only but a few seconds. Had they instead used `underline(x)` interchangeably everywhere across the code, one could spend hours looking at each usage site, trying to infer whether the intention of that particular `underline` call was to underline or to highlight.

    That is one of the reasons why simple methods like `def isEmpty = this.length == 0` are extremely valuable. No matter how short the equivalent code they capture may be, abstractions that better express intent and purpose are invaluable.

0. A word about _thin_ models. In object-oriented design, a object is an implementation of an [abstract data type (ADT)](http://en.wikipedia.org/wiki/Abstract_data_type). Objects must define both a set of values _and_ the operations on them. Objects are not Pascal records or C structs glorified with getters and setters. Classes are not just namespaces for methods.

    "Domain Model: An object model of the domain that incorporates both **behavior and data**. [...] there is hardly any behavior on [thin] objects, making them little more than bags of getters and setters. The fundamental horror of this anti-pattern is that it is so contrary to the basic idea of object-oriented design; which is to combine data and process together. The anemic domain model is really just a procedural style design."

    [Martin Fowler](http://www.martinfowler.com/bliki/AnemicDomainModel.html)

0. Always remember Tip 4: "Do not Live with Broken Windows: Fix each as soon as it is discovered." - The Pragmatic Programmer, Andrew Hunt and David Thomas.

Static Analysis Tools & Configuration
-------------------------------------

See skeleton project files.

Reference
---------

0. [Scala Style Guide]
0. [Effective Scala]
0. [Scala School]
0. [Scalariform]
0. [Scalastyle]
0. [WartRemover]
0. [HairyFotr Linter]
0. [Scapegoat]
0. [Snif]
0. [Linter]
0. [abide]
0. [cpd4sbt]
0. [obey]

[Scala Style Guide]: http://docs.scala-lang.org/style/
[Effective Scala]: http://twitter.github.io/effectivescala/
[Scala School]: http://twitter.github.io/scala_school/
[Scalariform]: http://github.com/mdr/scalariform
[Scalastyle]: http://www.scalastyle.org/
[WartRemover]: http://github.com/typelevel/wartremover
[HairyFotr Linter]: http://github.com/HairyFotr/linter
[Scapegoat]: http://github.com/sksamuel/scalac-scapegoat-plugin
[Snif]: http://github.com/arosien/sniff
[Linter]: http://github.com/jorgeortiz85/linter
[abide]: https://github.com/scala/scala-abide
[cpd4sbt]: https://github.com/sbt/cpd4sbt
[obey]: https://github.com/aghosn/Obey
