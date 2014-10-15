Originate's Scala Style Guide
=============================

Introduction
------------

In this guide, we leverage mainly two documents which contain the bulk of our recommendations:

- The official [Scala Style Guide] for formatting conventions.
- Twitter's "[Effective Scala]" for coding style and best practices.

We will highlight any cases where we diverge from the original documents and include reasons for doing so.

Code Formatting
---------------

Please read the [Scala Style Guide] carefully. The main points to consider are:

- Use **two spaces** indentation.
- Omit unnecessary blocks to avoid excessive nesting:

    ``` scala
    // Wrong
    if (condition) {
      magicHappens()
    }
    
    // Better
    if (condition) magicHappens()
    ```

- Avoid line wrapping. If possible, split long lines into multiple expressions and assign intermediate results to `val`s. Otherwise, indent wrapped lines once (two spaces).
- Use lower camel case for `valName`, `varName`, `methodName`, `functionObject`, `packageObject`, and `annotationName`.
- Use upper camel case for `ConstantName`, `ClassName`, `ObjectName`, `TypeParameter`.
- No `UPPERCASE_UNDERSCORE`, not even for constants or type parameters!
- No `get`/`set` prefixes for accessors and mutators.
- Always use empty parentheses when (and only for) declaring and calling methods with side-effects.
- Avoid symbolic method names (*"operators"*)!
- Use type inference where possible. But put clarity first and favor explicitness when an inferred type may not be obvious.
- Public methods must always have explicit return types.
- Opening curly braces (`{`) must be on the same line as the declaration.
- Constructors should be declared all on one line. If not possible, put each constructor argument on its own line, indented **four** spaces.
- Extensions follow the same rule above, but indent **two** spaces to provide visual separation between constructor arguments and extensions:

    ``` scala
    class Platypus (
        name: String,
        age: Int)
      extends Beaver
      with Duck
    ```

- Favor short, single-expression, single-line method bodies.
- No procedure syntax.
- No suffix operator notation.
- Always use infix notation for methods with symbolic names or higher-order functions (`map`, `foreach`, etc.).

### Additions and Deviations from the Official Style Guide

- Text file format: UTF-8, no BOM, Unix line endings (LF, '\n'), newline at EOF.
- 120 characters maximum line length.
- The bigger the scope, the more descriptive the name. Only for very small, local scopes may single-letter mnemonics be used.
- The formatting rules for constructors also apply to method declarations.
- Use infix notation for single argument methods on monadic types (`contains`, `getOrElse`, etc.)
- In general, obey English rules for punctuation:
    - A single space after (no space before) `,`, `:`, `;`, `)`, etc.
    - A single space before (no space after) `(`, except for method invocation or declaration;
    - Single spaces around `=`, `+`, `-`, `*`, `{`, `}`, `=>`, `<-`, etc.
    - No spaces between consecutive `(` or `)`.
- For documentation comments, follow Javadoc style. Scaladoc left-hand margin convention is silly.
- **Favor readability, favor readability, favor readability.**

Best Practices
--------------

It is definitely recommended to read the full Twitter's "[Effective Scala]" guide. The following sections highlight areas most often seen in our applications:

- [_Return type annotations_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Return%20type%20annotations)
- [_Type aliases_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Type%20aliases)
- [_Implicits_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Implicits)
- [_Collections_](http://twitter.github.io/effectivescala/#Collections) - Pay special attention to [performance](http://twitter.github.io/effectivescala/#Collections-Performance)
- [_Functional programming_](http://twitter.github.io/effectivescala/#Functional%20programming)

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
