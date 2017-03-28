Originate's Scala Guide
=======================

Best Practices
--------------

We recommended you read Twitter's "[Effective Scala]" guide. The following sections highlight areas most often seen in our applications:

0. [_Return type annotations_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Return%20type%20annotations)

0. [_Type aliases_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Type%20aliases)

0. [_Implicits_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Implicits)

0. [_Collections_](http://twitter.github.io/effectivescala/#Collections) - Pay special attention to [performance](http://twitter.github.io/effectivescala/#Collections-Performance)

0. [_Functional programming_](http://twitter.github.io/effectivescala/#Functional%20programming)

0. [_Pattern matching_](http://twitter.github.io/effectivescala/#Functional%20programming-Pattern%20matching)

### Additional recommendations

0. Avoid [pattern matching on Options](http://blog.originate.com/blog/2014/06/15/idiomatic-scala-your-options-do-not-match/).

0. Never use `return`: [http://tpolecat.github.io/2014/05/09/return.html](http://tpolecat.github.io/2014/05/09/return.html)

0. Parentheses in Scala are not optional. Be aware of extraneous parentheses:

    ```scala
    val bad = Set.empty() // expands to Set.empty.apply(), evaluates to false

    val evil = Seq(1,2,3).toSet() // same as above
    ```

0. Always use the most generic collection type possible, typically one of: `Iterable[T]`, `Seq[T]`, `Set[T]`, or `Map[T]`.

0. Use `Seq[T]`, not `List[T]` (see: [http://stackoverflow.com/a/10866807/410286](http://stackoverflow.com/a/10866807/410286)) except where you specifically need to force one implementation over another. The most common exception is that Play form mappers require `List[T]`, so you have to use it there. `Seq` is the interface, `List` the implementation, analogous to `Map` and `HashMap` in Java.

0. When possible, use `scala.collection.breakOut` to avoid producing and converting intermediate collections with `.toMap`, `.toSeq`, `.toSet`, etc.

    ```scala
    // Produces an intermediate Seq[(String, Int)] and converts it to Map[String, Int]
    val bad = Seq("Toronto", "New York", "San Francisco").map(s => (s, s.length)).toMap

    // No intermediate values or conversions involved
    val good: Map[String, Int] = Seq("Toronto", "New York", "San Francisco").map(s => (s, s.length))(breakOut)
    ```

    Please note that the type annotation is required or `breakOut` will not be able to infer and use the proper builder. To know when `breakOut` can be used, check in the Scaladoc if the higher-order function (`map` in the example above) takes an implicit `CanBuildFrom` parameter. The attentive reader may notice that `breakOut` is in fact being passed in lieu of the implicit `CanBuildFrom` parameter.

0. Do not overuse tuples, decompose them or better, use case classes:

    ```scala
    val paul = Some(("Paul", 42))

    // Bad
    paul map (p => s"Name: ${p._1}, Age: ${p._2}")

    // Good
    paul map { case (name, age) =>
      s"Name: $name, Age: $age"
    }

    // Better
    case class Person(name: String, age: Int)

    val paul = Some(Person("Paul", 42))

    paul map (p => s"Name: ${p.name}, Age: ${p.age}")
    ```

0. Do not overdo method chaining, use `val`s to name intermediate steps:

    ```scala
    val bad = xs.filter(...).map(...).exists(...)

    val filteredXs = xs filter (...)
    val ys = filteredXs map xToY
    val answer = ys exists (...)
    ```

0. Avoid implicit conversions. Instead, use implicit value classes ([extension methods](http://docs.scala-lang.org/overviews/core/value-classes.html#extension-methods)), they are more efficient:

    ```scala
    class Bad(n: Int) {
      def stars = "*" * n
    }
    implicit def bad(n: Int) = new Bad(n)

    implicit class Good(private val n: Int) extends AnyVal {
      def stars = "*" * n
    }
    ```

Be sure to make the wrapped parameter `private`! Otherwise you end up exposing an additional method that just returns the same object. You do have to state `private val` explicitly, otherwise it defaults to `private[this]` which is too strong for `AnyVal` wrappers.

0. Whenever possible, avoid matching on `case _`. Try to be specific and thorough, favor exhaustive matches. Do not let unforeseen conditions silently fall through.

0. Never use `null`, use `Option` instead. If dealing with legacy APIs, wrap possible `null`s:

    ```scala
    Option(javaClass.returnsNull())

    javaClass.takesNull(opt.orNull)
    ```

0. Avoid `Some.apply`, use `Option.apply` instead. `Option.apply` protects against `null`, while `Some.apply` is perfectly happy to return `Some(null)`, eventually raising an NPE. Also note that `Some.apply` is type-inferred as `Some[T]`, not `Option[T]`.

    ```scala
    val bad = Some(System.getenv("a")) // NPE waiting to happen

    val good = Option(System.getenv("a")) // Would return None
    ```

    By the principle of least astonishment, use `Option.apply` even if you "know" your reference can never be null. By being consistent, we avoid wondering whether a `Some.apply` in the code was intentional or something the developer overlooked:

    ```scala
    val bad = Some(math.random())

    val good = Option(math.random()) // And never have to worry about it again
    ```

0. Do not abuse `Option`. Some types already provide a good default to represent "nothing". For instance, before declaring an `Option[Seq[T]]`, ask yourself whether there is any semantic difference between `Some(Nil)` and `None`. If not (and usually, there isn't), use `Seq[T]` and return the empty list.

0. Never extend a case class. Extending a case class with another case class is forbidden by the compiler. Extending a case class with a regular class, while permitted, produces nasty results:

    ```scala
    case class A(a: Int)

    // error: case class B has case ancestor A, but case-to-case inheritance is prohibited.
    case class B(a: Int, val b: String) extends A(a)

    class C(a: Int, c: Int) extends A(a)

    val a = A(1)
    val c = new C(1, 2)
    assert(a == c)
    assert(a.hashCode == c.hashCode)
    assert(c.toString == "A(1)") // Wat

    val d = new C(1, 3)
    assert(c.hashCode == d.hashCode)

    val e = c.copy(4) // note there is no C#copy(Int, Int) method
    assert(!e.isInstanceOf[C]) // e is a proper instance of A
    ```

0. Do not use [`JavaConversions`](http://www.scala-lang.org/api/current/scala/collection/JavaConversions$.html), use [`JavaConverters`](http://www.scala-lang.org/api/current/scala/collection/JavaConverters$.html) and its multiple `asScala` and `asJava` methods. While `JavaConversions` may happen "automagically" at unexpected times, usually masquerading type errors, `JavaConverters` gives you explicit control of when conversions happen (only as dangerous as you want). You can then transparently use Java collections as if they were Scala collections, usually for performance or interoperability reasons:

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
    m.contains("") // Fails to compile: type mismatch

    import collection.JavaConversions._
    m.contains("") // false
    ```

0. Instead of throwing exceptions, use [a more suitable type](http://tersesystems.com/2012/12/27/error-handling-in-scala/): `Option`, `Either`, or `Try`. Exceptions are not functional. Functions that throw exceptions are not total functions, they do not return a value for all possible inputs.

0. Do not `try` to `catch` exceptions, `Try` to catch exceptions! `Try` does for exceptions what `Option` does for `null`.

0. Remember that `Future` already encapsulates a `Try`. Instead of `Future[Try[T]]`, use `Future.failed`, `Future.fromTry`, and `Future.successful`.

0. No matter what, never use a "catch-all" exception handler. Some features in Scala are implemented relying on exceptions. Use `NonFatal` instead:

    ```scala
    import scala.util.control.NonFatal

    try {
      1 / 0
    } catch {
      case e: Exception => // Bad
      case _: Throwable => // Worse
      case _ =>            // Worst, scalac will warn and "recommend" the expression above
      case NonFatal(e) =>  // The only acceptable way to catch all exceptions
    }
    ```

    Please note that `NonFatal` is not needed when pattern matching `Future` or `Try` since they already filter for it.

0. Make judicious use of the various assertions (contracts) offered by Scala. See [scala.Predef](http://www.scala-lang.org/api/current/index.html#scala.Predef$) for the complete reference.

    1. Assertions (`assert(b != 0)`) are used to document and check design-by-contract invariants in code. They can be disabled at runtime with the `-Xdisable-assertions` command line option.

    1. `require` is used to check pre-conditions, blaming the caller of a method for violating them. Unlike other assertions, `require` throws `IllegalArgumentException` instead of `AssertionError` and can never be disabled at runtime.

        Make ample and liberal use of `require`, specially in constructors. Do not allow invalid state to ever be created:

        ```scala
        case class Person(name: String, age: Int) {
          require(name.trim.nonEmpty, "name cannot be empty")
          require(age >= 0, "age cannot be negative")
          require(age <= 130, "oldest unambiguously documented human was 122")
        }
        ```

        Please note that even though `require` throws an exception, this is not a violation of the previous recommendations. Constructors are not methods, they cannot return `Try[Person]`.

    1. `ensuring` is used on a method return value to check post-conditions:

        ```scala
        def square(a: Int) = {a * a} ensuring (_ > 0)
        ```

0. Know well and make good use of the standard Scala collections library classes and methods:

    1. Never test for `c.length == 0` (may be O(n)), use `c.isEmpty` instead.

    1. Instead of `c.filter(_ > 0).headOption`, use `c find(_ > 0)`.

    1. Instead of `c.find(_ > 0).isDefined`, use `c exists (_ > 0)`.

    1. Instead of `c exists (_ == 0)`, use `c contains 0`.

    This is not only a matter of style: for some collections, the recommendations above can be algorithmically more efficient than the naive approach.

0. Do not import `scala.collection.mutable._` or even any single mutable collection directly. Instead, import the `mutable` package itself and use it explicitly as a namespace prefix to denote mutability, which also avoids name conflicts if using both mutable and immutable structures in the same scope:

    ```scala
    import scala.collection.mutable.Set
    val bad = Set(1, 2, 3) // Too subtle and risky for the inattentive reader

    import scala.collection.mutable
    val good = mutable.Set(1, 2, 3)
    ```

0. Prefer a mutable `val` over an immutable `var`:

    ```scala
    import scala.collection.mutable

    var bad = Set(1, 2, 3)
    bad += 4

    val good = mutable.Set(1, 2, 3)
    good += 4

    assert(good.sameElements(bad))
    ```

0. No "stringly" typed code. Use `Enumeration` or `sealed` types with `case` objects. `Enumeration` and `sealed` types have similar purpose and usage, but they do not fully overlap. `Enumeration`, for instance, does not check for exhaustive matching while `sealed` types do not, well, enumerate.

    ```scala
    object Season extends Enumeration {
      type Season = Value
      val Spring, Summer, Autumn, Winter = Value
    }

    sealed trait Gender
    case object Male extends Gender
    case object Female extends Gender
    ```

0. When creating new `Enumeration`s, always define a type alias (as above). Never use `MyEnum.Value` to refer to the type of enumeration values:

    ```scala
    def bad(a: Season.Value) = ???

    import Season.Season
    def good(a: Season) = ???
    ```

0. If a function takes multiple arguments of the same type, use named parameters to ensure values are not passed in the wrong order:

    ```scala
    def geo(latitude: Double, longitude: Double) = ???

    val bad = geo(a, b)

    val good = geo(latitude = a, longitude = b)
    ```

0. Always use named parameters with booleans, even when they are the only parameter:

    ```scala
    // Bad
    Utils.delete(true)

    // Good
    Utils.delete(recursively = true)
    ```

0. Avoid declaring functions with boolean arguments ("magic booleans"). Do not model any two possible states as boolean:

    ```scala
    // Bad
    case class Person(male: Boolean)
    case class Car(isAutomatic: Boolean, isElectric: Boolean, isFourDoor: Boolean)

    // Good
    case class Person(gender: Gender)

    // Bad
    def findPeople(filterMales: Boolean): Seq[People]

    // Good
    def findMales: Seq[People]
    def findFemales: Seq[People]
    ```

0. Do not define abstract `val`s in traits or abstract classes. Abstract `val`s are a source of headaches and unexpected behavior in Scala:

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

    Always define abstract `def`s, they are more general and safer:

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

0. Avoid `lazy val`. `lazy val` is *not* free, or even cheap. Use it only when you absolutely need laziness semantics for correctness, never for "optimization". The initialization of a `lazy val` is super-expensive due to monitor acquisition cost, while every access is expensive due to `volatile`. Worse, `lazy val` [may deadlock](http://axel22.github.io/2013/06/10/on-lazy-vals.html) even when there are no circular dependencies between them.

    > `lazy val`s are compiled into a double-checked locking instance with a dedicated `volatile` guard. Notably, this compilation template yields a source of significant performance woes: we need to pass through the `volatile` read on the guard boolean for every read of the `lazy val`. This creates write barriers, cache invalidation and general mayhem with a lot of the optimizations that HotSpot tries to perform. All for a value that may or may not even care about asynchronous access, and even more importantly, is guaranteed to be true only once and is false indefinitely thereafter (baring hilarious tricks with reflection). Contrary to what is commonly believed, this guard isn't simply optimized away by HotSpot (evidence for this comes from benchmarks on warm code and assembly dumps). - Daniel Spiewak

    ![You keep using that word, I do not think it means what you think it means](lazyval.jpg "You keep using that word, I do not think it means what you think it means")

0. `object`s are lazily initialized. If an object is defined at the top level or inside another `object`, then that initialization is relatively cheap, done via Java's static initializer blocks. **However** if an `object` is defined inside a `class` or `trait` then it compiles the same as a `lazy val`! That means it suffers all the same problems described in the above section. There are probably no cases where an `object` inside a `class` definition is necessary anyway, so just avoid it. But feel free to define them inside other `object`s!

    ```scala
    trait T { def x: Int }

    class Bad {
      object Inner extends T {
        val x = 10
      }
    }

    class Good {
      val inner: T = new T {
        val x = 10
      }
    }

    object ThisIsFine {
      object Inner extends T {
        val x = 10
      }
    }
    ```

0. Secondary constructors: with default parameters, secondary constructors are a lot less frequently needed in Scala than in Java. But they can still be quite useful, use them when needed. Just avoid pathological cases:

    ```scala
    class Bad(a: Int, b: Int) {
      def this(a: Int) = this(a, 0)
    }

    class Good(a: Int, b: Int = 0)
    ```

0. If you need to wrap a value that can be immediately computed into a `Future`, use `Future.successful`, which returns an already completed `Future`. Calling `Future.apply` incurs all the overhead of starting an asynchronous computation, no matter if the computation is a simple, immediate result:

    ```scala
    val bad = Future(0)

    val good = Future.successful(str.trim)
    ```

0. When combining `Future`s in for-comprehensions, do not use the following idiom:

    ```scala
    for {
      a <- futureA
      b <- futureB
      c <- futureC
    } yield a + b + c
    ```

    Unless `futureB` depends on `a` and `futureC` depends on `b`, that will unnecessarily chain (serialize) the `Future`s, starting a future only after the previous one has finished, which most likely defeats its purpose. To properly start `Future`s in parallel and combine their results, use the following idiom:

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

0. Avoid `isInstanceOf` or `asInstanceOf`. Safe casting is actually one of the best use cases for pattern matching. It is more flexible, guarantees that a cast will only happen if it can succeed, and allows you, for instance, to use different branches to carry out multiple conditional casts at the same time for various types, perform conversions, or fallback to a default value instead of throwing an exception:

    ```scala
    val bad = if (a.isInstanceOf[Int]) x else y

    val good = a match {
      case _: Int => x
      case _ => y
    }

    val bad = a.asInstanceOf[Int]

    val good = a match {
      case i: Int => i
      case d: Double => d.toInt
      case _ => 0 // Or just throw new ClassCastException
    }
    ```

0. Avoid structural types, do not import `scala.language.reflectiveCalls`. Structural types are implemented with reflection at runtime, and are inherently less performant than nominal types.

[Effective Scala]: http://twitter.github.io/effectivescala/
