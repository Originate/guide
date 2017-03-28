Originate's Scala Guide
=======================

Tips & Tricks
-------------

0. Avoid naked base types, such as `String`, `Int`, or `Date`. Those unwrapped "primitive" types have no semantic meaning and provide little type safety (e.g., mixing `firstName` and `lastName`). Instead, make plentiful use of value classes to enforce stronger typing:

    ```scala
    case class Email(email: String) extends AnyVal // No extra object allocation at runtime

    val email = Email("joe@example.com") // Never gets mixed with other strings
    ```

    ![Population 562 Elevation 2150 Established 1951 Total 4663](baretypes.jpg "Population 562 Elevation 2150 Established 1951 Total 4663")

0. Combine value classes with implicit classes to define extension methods:

    ```scala
    implicit class IntOps(private val n: Int) extends AnyVal {
      def stars = "*" * n
    }

    5.stars // Equivalent to a static method call, no implicit conversion actually takes place
    ```

0. Whenever possible, use `private[this]` instead of `private` and `final val` instead of `val` as they enable the Scala compiler and the JVM to perform additional optimizations: direct field access vs. accessor method, or inlined constant vs. field access, respectively. (If `final val` surprised you, remember that it is not redundant, because in Scala `final` means "cannot be overridden", while in Java it may mean both that as well as "cannot be reassigned").

0. Leverage parallel collections, use `.par` judiciously.

0. `import System.{currentTimeMillis => now}` or `import System.{nanoTime => now}` are very useful to have around.

0. Use the `@tailrec` annotation to ensure the compiler can recognize a recursive method is tail-recursive.

0. You can use the `@scala.beans.BeanProperty` and `@BooleanBeanProperty` annotations to automatically generate JavaBeans style getter and setter methods.

0. You can use the following syntax to pass a sequence as a parameter to a variable length argument list method:

    ```scala
    def foo(args: Int*) = ???

    val seq = Seq(1, 2, 3)

    foo(seq: _*)
    ```

0. There are some really neat tricks we can do with pattern matching:

    ```scala
    val tuple = ("foo", 1, false)
    val (x, y, z) = tuple
    assert((x, y, z) == (("foo", 1, false)))

    case class Foo(x: String, y: Int)
    val foo = Foo("foo", 1)
    val Foo(a, b) = foo
    assert((a, b) == (("foo", 1)))

    val seq = Seq(1, 2, 3, 4, 5, 6)
    val x :: xs = seq
    assert((x, xs) == ((1, Seq(2, 3, 4, 5, 6))))

    // Same as above
    val Seq(y, ys@_*) = seq
    assert((y, ys) == ((1, Seq(2, 3, 4, 5, 6))))

    // Skipping elements
    val _ :: a :: b :: _ :: zs = seq
    assert((a, b, zs) == ((2, 3, Seq(5, 6))))

    // Works with other collections, too
    val vector = Vector(1, 2, 3, 4, 5, 6)
    val Vector(_, a, b, _, ws@_*) = vector
    assert((a, b, ws) == ((2, 3, Vector(5, 6))))

    val Array(key, value) = "key:value".split(':')

    // Regular expressions
    val regex = """(.)(.)(.)""".r
    val regex(a, b, c) = "xyz" // Matches and extracts regex against "xyz"
    assert((a, b, c) == (("x", "y", "z")))
    ```

    Please note that the extra parentheses are needed due to the `-Yno-adapted-args` compiler option.

0. Java `enum`s are very powerful and flexible. Enumeration types in Java can include methods and fields, and enum constants are able to specialize their behavior. For more information, refer to the awesome "Effective Java, 2nd Edition" by Joshua Bloch, in particular Chapter 6, "Enums and Annotations", Item 30: "Use enums instead of int constants".

    Unfortunately, Scala enums are not at feature parity with their Java counterparts. They do not, by default, offer the same flexibility and power. They do not interoperate with Java. They have the same type after erasure (see below). Pattern matching is not exhaustively checked. Play JSON and Scala Pickling do not support enumerations. [Do not expect](https://groups.google.com/forum/#!msg/scala-internals/8RWkccSRBxQ/U4y0XpRJfdQJ) the [situation to change](https://www.reddit.com/r/scala/comments/3aqlhu/is_there_a_voting_mechanism_for_new_scala_features/csgy8i0).

    ```scala
    object A extends Enumeration { val Abc = Value }
    object X extends Enumeration { val Xyz = Value }

    object DoesNotCompile {
      def f(v: A.Value) = "I'm A"
      def f(v: X.Value) = "I'm X"
    }
    ```

    The following idioms bring a little more power to Scala enums:

    ```scala
    // Custom properties
    object Suit extends Enumeration {
      import scala.language.implicitConversions

      type Suit = SuitVal

      implicit def toVal(v: Value) = v.asInstanceOf[SuitVal]

      case class SuitVal private[Suit] (symbol: Char) extends Val

      val Spades   = SuitVal('♠')
      val Hearts   = SuitVal('♥')
      val Diamonds = SuitVal('♦')
      val Clubs    = SuitVal('♣')
    }

    // Behaviour specialization and exhaustiveness checking
    object Lang extends Enumeration {
      import scala.language.implicitConversions

      type Lang = LangVal

      implicit def toVal(v: Value) = v.asInstanceOf[LangVal]

      sealed abstract class LangVal extends Val {
        def greet(name: String): String
      }

      case object English extends LangVal {
        def greet(name: String) = s"Welcome, $name."
      }

      case object French extends LangVal {
        def greet(name: String) = s"Bienvenue, $name."
      }
    }
    ```

0. Instead of running sbt tasks directly from the command line (`$ sbt compile`, for instance), it is better to open an sbt prompt (just type `$ sbt`) and never leave it. Running all your sbt tasks (`clean`, `update`, `compile`, `test`, etc.) inside the sbt prompt is a lot faster since you only have to start sbt, load the JVM, and wait for it to warm up (if ever) once. If your `build.sbt` file changes, just run the `reload` task and you are good to go again.

    Having an sbt instance running `~test` in the background is one of the best ways to develop in Scala. You can run some sbt tasks and be left inside the prompt by using the `shell` task: `$ sbt clean update compile test:compile shell`.

0. The following shorthand trick works in the Scala REPL:

    ```scala
    scala> "The quick brown fox jumps over the lazy dog!"
    res0: String = The quick brown fox jumps over the lazy dog!

    scala> .toLowerCase
    res1: String = the quick brown fox jumps over the lazy dog!

    scala> .distinct
    res2: String = the quickbrownfxjmpsvlazydg!

    scala> .filter(_.isLetter)
    res3: String = thequickbrownfxjmpsvlazydg

    scala> .sorted
    res4: String = abcdefghijklmnopqrstuvwxyz

    scala> .size
    res5: Int = 26
    ```

0. Learn you a few Scala tricks for great good: https://github.com/marconilanna/ScalaUpNorth2015
