Originate's Scala Style Guide
=============================

Introduction
------------

In this guide, we leverage mainly two documents which contain the bulk of our recommendations:

- The official [Scala Style Guide] contains many code formatting guidelines.
- Twitter's "[Effective Scala]" has several coding style recommendations.

We will highlight any cases where we diverge from the original documents and include reasons for doing so.

Formatting Guidelines
---------------------

Best Practices
--------------

It is definitely recommended to read the full Twitter's "[Effective Scala]" document. The following sections highlight areas most often seen in our applications:

- [_Return type annotations_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Return%20type%20annotations)
- [_Type aliases_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Type%20aliases)
- [_Implicits_](http://twitter.github.io/effectivescala/#Types%20and%20Generics-Implicits)
- [_Collections_](http://twitter.github.io/effectivescala/#Collections) - Pay special attention to [this](http://twitter.github.io/effectivescala/#Collections-Performance) paragraph
- [_Functional programming_](http://twitter.github.io/effectivescala/#Functional%20programming)

### Additional recommendations

- [Error handling](http://tersesystems.com/2012/12/27/error-handling-in-scala/)
- Using [Options](http://blog.originate.com/blog/2014/06/15/idiomatic-scala-your-options-do-not-match/)
- use Seq, not List (see: [http://stackoverflow.com/a/10866807/410286](http://stackoverflow.com/a/10866807/410286)) except where you specifically need to force one implementation over another... the most common exception is that Play form mappers require List, so you have to use it there
- use infix notation for single argument methods on monad types: map flatMap foreach filter collect exists getOrElse
- if continuing an expression to the next line, indent once. if the expression is a method signature or class signature, double indent so that the following lines are visually separated
- single space after comma
- space after colon in type annotations
- use _ for small simple functions, as in: Seq(1, 2, 3, 4, 5, 6) filter (_ % 2 == 0)
- single space after method names, before brackets, as in: someSequence map { item => ... }
- do not commit your comments/TODO's, but leave them in your working tree if you'd like
- when passing function blocks, use { arg1 => ... } over (arg1 => { ... }) (avoid "inner block" syntax)
- when passing function blocks, for single line, prefer parens: something map (_.name) and something map (a => a + a) ...for multiline, prefer brackets (shown above)

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
