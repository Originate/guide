Originate's Scala Style Guide
=============================

Introduction
------------

In this guide, we leverage mainly two documents which contain the bulk of our recommendations:

0. The official [Scala Style Guide] for formatting conventions.
0. Twitter's "[Effective Scala]" for coding style and best practices.

We will highlight any cases where we diverge from the original documents and include reasons for doing so.

Code Formatting
---------------

Please read the [Scala Style Guide] carefully. The main points to consider are:

0. Use **two spaces** indentation.
0. Omit unnecessary blocks to reduce excessive nesting:

        ```scala
        // Wrong
        if (condition) {
          magic()
        }

        // Better
        if (condition) magic()
        ```

0. Avoid wrapping lines. Split long lines into multiple expressions, assigning intermediate results to `val`s. When inevitable, indent wrapped lines once (two spaces).
0. Use lower camel case for `valName`, `varName`, `methodName`, `functionObject`, `packageObject`, and `annotationName`.
0. Use upper camel case for `ConstantName`, `ClassName`, `ObjectName`, `TypeParameter`.
0. No `UPPERCASE_UNDERSCORE`, not even for constants or type parameters!
0. No `get`/`set` prefixes for accessors and mutators.
0. Always use empty parentheses when (and only when) declaring or calling methods with side-effects.
0. Unless a clear convention already exists (e.g, mathematical symbols), avoid symbolic method names (*"operators"*).
0. Use type inference where possible. But put clarity first and favor explicitness when an inferred type may not be obvious.
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
0. Postfix operator notation is unsafe and shall not be used. Consider it deprecated. Do not `import scala.language.postfix`.
0. Always use infix notation for methods with symbolic names or higher-order functions (`map`, `foreach`, etc.).

### Additions and Deviations from the Official Style Guide

0. Text file format: UTF-8, no BOM, Unix line endings (LF, '\n'), newline at EOF.
0. 100 characters maximum line length.
0. One blank line between method, class, and object definitions.
0. Avoid vertical alignment.
0. Put imports at the top of the file, sorted alphabetically.
0. Do not use `return`.
0. The bigger the scope, the more descriptive the name. Only for very small, local scopes may single-letter mnemonics be used.
0. The formatting rules for constructors also apply to method declarations.
0. Use infix notation for single argument methods on monadic types (`contains`, `getOrElse`, etc.)
0. In general, obey English rules and mathematical conventions for punctuation:
    1. A single space after (no space before) `,`, `:`, `;`, `)`, etc.
    1. A single space before (no space after) `(`, except for method invocation or declaration;
    1. Single spaces around `=`, `+`, `-`, `*`, `{`, `}`, `=>`, `<-`, etc.
    1. No spaces between consecutive `(` or `)`.
0. For documentation comments, use Javadoc left-hand margin style. Scaladoc convention is silly.
0. **Optimize for readability, optimize for readability, optimize for readability.** Readability trumps consistency (but not by much). Consistency trumps everything else.

Best Practices
--------------

It is definitely recommended to read the full Twitter's "[Effective Scala]" guide. The following sections highlight areas most often seen in our applications:

0. [_Return type annotations_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Return%20type%20annotations)
0. [_Type aliases_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Type%20aliases)
0. [_Implicits_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Implicits)
0. [_Collections_](http://twitter.github.io/effectivescala/#Collections) - Pay special attention to [performance](http://twitter.github.io/effectivescala/#Collections-Performance)
0. [_Functional programming_](http://twitter.github.io/effectivescala/#Functional%20programming)

### Additional recommendations

- [Error handling](http://tersesystems.com/2012/12/27/error-handling-in-scala/)
- Using [Options](http://blog.originate.com/blog/2014/06/15/idiomatic-scala-your-options-do-not-match/)
- use Seq, not List (see: [http://stackoverflow.com/a/10866807/410286](http://stackoverflow.com/a/10866807/410286)) except where you specifically need to force one implementation over another... the most common exception is that Play form mappers require List, so you have to use it there
- use _ for small simple functions, as in: Seq(1, 2, 3, 4, 5, 6) filter (_ % 2 == 0)
- single space after method names, before brackets, as in: someSequence map { item => ... }
- do not commit your comments/TODO's, but leave them in your working tree if you'd like
- when passing function blocks, use { arg1 => ... } over (arg1 => { ... }) (avoid "inner block" syntax)
- when passing function blocks, for single line, prefer parens: something map (_.name) and something map (a => a + a) ...for multiline, prefer brackets (shown above)
- Avoid structural types. Structural types are implemented with reflection at runtime, and are inherently less performant than nominal types.

Static Analysis Tools & Configuration
-------------------------------------

Tips & Tricks
-------------

Additional Remarks
------------------

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
[abide]: https://github.com/scala/scala-abide
[Scapegoat]: http://github.com/sksamuel/scalac-scapegoat-plugin
[Snif]: http://github.com/arosien/sniff
[Linter]: http://github.com/jorgeortiz85/linter
[cpd4sbt]: https://github.com/sbt/cpd4sbt
[obey]: https://github.com/aghosn/Obey
