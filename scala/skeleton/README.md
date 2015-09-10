Scala Skeleton Project
======================

Skeleton project based on https://github.com/marconilanna/scala-boilerplate/

Scalastyle
----------

The `scalastyle` and `test:scalastyle` sbt tasks are used to check source and test code with Scalastyle. The error list is saved to Checkstyle-compatible files `target/scalastyle-result.xml` and `target/scalastyle-test-result.xml` respectively.

Scalastyle runs automatically against source and test code with the sbt `test` task.

It is not recommended to make the `compile` task dependent on Scalastyle. Since Scalastyle runs first and fails if the code does not compile, one would not get the Scala compiler error messages.

scoverage
---------

To execute tests with code coverage enabled run the following sbt tasks in order: `clean` `coverage` `test` `coverageReport`. Coverage reports are saved to `target/scala-2.11/scoverage-report/`.

Scalariform
-----------

To format source and test code run the `scalariformFormat` and `test:scalariformFormat` sbt tasks.

Scalariform is provided as a convenience and starting point; it is not sufficient to be fully compliant with [Originate's Scala Style Guide](https://github.com/Originate/guide/tree/master/scala).
