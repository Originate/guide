Originate's Scala Style Guide
=============================

Code Formatting
---------------

Please read the [Scala Style Guide] carefully. The main points to consider are:

0. Use **two-space** indentation. No tabs.

0. Omit unnecessary blocks to reduce excessive nesting:

    ```scala
    if (condition) {
      bad()
    }

    if (condition) good()
    ```

0. Avoid wrapping lines. Split long lines into multiple expressions, assigning intermediate results to `val`s. When inevitable, indent wrapped lines with two spaces:

    ```scala
    val iAm = aVeryLong + expression + thatTakes +
      multipleLines
    ```

0. Use lower camel case for `valName`, `varName`, `methodName`, `functionObject`, `packageObject`, and `annotationName`.

0. Use upper camel case for `ConstantName`, `EnumerationValue`, `ClassName`, `TraitName`, `ObjectName`, `TypeParameter`.

0. No `UPPERCASE_UNDERSCORE`, not even for constants or type parameters.

0. No `get`/`set` prefixes for accessors and mutators.

0. Always use empty parentheses when, and only when, declaring or calling methods with side-effects.

0. Unless an established convention already exists (e.g, mathematical symbols), avoid symbolic method names (*"operators"*).

0. Use type inference where possible. But put clarity first and favor explicitness when an inferred type may not be obvious.

    ```scala
    val good = 1 // Int, obviously

    val bad = config.get("key") // What does it return?
    val better: Option[String] = config.get("key")
    ```

0. Opening curly braces (`{`) must be on the same line as the declaration.

0. Constructors should be declared all on one line. If not possible, put each constructor argument on its own line, indented **four** spaces.

0. Extensions follow the same rule above, but indent **two** spaces to provide visual separation between constructor arguments and extensions:

    ```scala
    class Platypus(
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

### Additions and Deviations

0. Text file format: UTF-8, no BOM, Unix line endings (LF, '\n'), newline at EOF. Use the `.editorconfig` ([http://editorconfig.org/](http://editorconfig.org/)) profile inside the `skeleton` folder to configure your editor.

0. 100 characters maximum line length.

0. One blank line between method, class, and object definitions.

0. Use blank lines between statements and declarations to create logical groupings.

0. No double blank lines, anywhere.

0. No trailing whitespace at the end of lines, they cause problems when diffing between files or between versions. Configure your text editor to do this for you automatically.

0. In general, obey English rules and mathematical conventions for punctuation:

    1. A single space after and no space before `,`, `:`, `;`, `)`, etc.

    1. A single space before `(`, except for method invocation or declaration. Never a space after.

    1. Single spaces around `=`, `+`, `-`, `*`, `{`, `}`, `=>`, `<-`, etc.

    1. No spaces between consecutive `(` or `)`.

0. Do not align vertically: it requires constant realignments, making diffs longer.

0. Methods must always have explicit return types. Explicitly declaring the return type allows the compiler to verify correctness.

0. Modifiers should be declared in the following order: `override`, `abstract`, `private` or `protected`, `final`, `sealed`, `implicit`, `lazy`.

0. Put imports at the top of the file. Imports should be grouped from most to least specific:
    1. The project's own classes
    1. Frameworks and libraries: `com.*`, `net.*`, `org.*`, etc.
    1. `scala.*`
    1. `java.*` and `javax.*`

    Inside each group, packages and classes must be sorted alphabetically. Separate groups with blank lines:

    ```scala
    import myapp.util.StringUtils

    import org.joda.time.DateTime

    import play.api.Configuration

    import scala.concurrent.Future

    import java.net.URI
    ```

    The script `fix-imports.go` in the skeleton project folder can be used to help you organize your imports.

0. Do not use relative imports. Full imports are easier to search, and never ambiguous:

    ```scala
    package foo.bar

    // Bad
    import baz.Qux

    // Good
    import foo.bar.baz.Qux
    ```

0. Do not wildcard-import entire packages: `import bad._`

0. The bigger the scope, the more descriptive the name. Only for very small, local scopes may single-letter mnemonics be used.

0. Use `_` for simple, single line functions:

    ```scala
    val bad = seq filter (number => number % 2 == 0)

    val good = seq filter (_ % 2 == 0)
    ```

0. Omit the `_` for functions that take a single argument:

    ```scala
    bad foreach println(_)

    good foreach println
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

0. For single-line functions and for-comprehensions, use parentheses. For multiline ones, use brackets:

    ```scala
    for (i <- 1 to 3) println(i)

    seq map (_ * 2)

    seq map { a =>
      if (a < 0) -a
      else a
    }
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

0. When passing functions, do not use inner block syntax:

    ```scala
    (bad => {
      ???
    })

    { good =>
      ???
    }
    ```

0. For documentation comments, use Javadoc left-hand margin style instead of the Scaladoc convention:

    ```scala
    /** Bad
      * convention
      */

    /**
     * Good
     * convention
     */
    ```

0. **Optimize for readability.** Readability trumps consistency (but not by much). Consistency trumps everything else.

[Scala Style Guide]: http://docs.scala-lang.org/style/
