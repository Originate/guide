name := "PROJECT"

version := "0.1"

organization := "com.originate"

organizationName := " Originate, Inc."

organizationHomepage := Some(url("http://originate.com"))

// homepage := Some(url("http://"))

// startYear := Some(2015)

// description := ""

// licenses += "GPLv2" -> url("http://www.gnu.org/licenses/gpl-2.0.html")

scalaVersion := "2.11.7"

scalacOptions ++= Seq(
  "-deprecation", // Emit warning and location for usages of deprecated APIs
  "-encoding", "UTF-8", // Specify character encoding used by source files
  "-feature", // Emit warning and location for usages of features that should be imported explicitly
  "-g:vars", // Set level of generated debugging info: none, source, line, vars, notailcalls
//"-language:_", // Enable or disable language features (see list below)
  "-optimise", // Generates faster bytecode by applying optimisations to the program
  "-target:jvm-1.8", // Target platform for object files
  "-unchecked", // Enable additional warnings where generated code depends on assumptions
  "-Xexperimental", // Enable experimental extensions
  "-Xfatal-warnings", // Fail the compilation if there are any warnings
  "-Xfuture", // Turn on future language features
  "-Xlint:_", // Enable or disable specific warnings (see list below)
  "-Xstrict-inference", // Don't infer known-unsound types
  "-Yinline-warnings", // Emit inlining warnings
  "-Yno-adapted-args", // Do not adapt an argument list to match the receiver
//"-Yno-imports", // Compile without importing scala.*, java.lang.*, or Predef
//"-Yno-predef", // Compile without importing Predef
  "-Yopt:_", // Enable optimizations
  "-Ywarn-dead-code", // Warn when dead code is identified
//"-Ywarn-numeric-widen", // Warn when numerics are widened (Not really useful)
  "-Ywarn-unused", // Warn when local and private vals, vars, defs, and types are unused
  "-Ywarn-unused-import", // Warn when imports are unused
  "-Ywarn-value-discard" // Warn when non-Unit expression results are unused
)

/*
scalac -language:help

dynamics             Allow direct or indirect subclasses of scala.Dynamic
existentials         Existential types (besides wildcard types) can be written and inferred
experimental.macros  Allow macro defintion (besides implementation and application)
higherKinds          Allow higher-kinded types
implicitConversions  Allow definition of implicit functions called views
postfixOps           Allow postfix operator notation, such as `1 to 10 toList'
reflectiveCalls      Allow reflective access to members of structural types

*//*

scalac -Xlint:help

adapted-args               Warn if an argument list is modified to match the receiver
by-name-right-associative  By-name parameter of right associative operator
delayedinit-select         Selecting member of DelayedInit
doc-detached               A ScalaDoc comment appears to be detached from its element
inaccessible               Warn about inaccessible types in method signatures
infer-any                  Warn when a type argument is inferred to be `Any`
missing-interpolator       A string literal appears to be missing an interpolator id
nullary-override           Warn when non-nullary `def f()' overrides nullary `def f'
nullary-unit               Warn when nullary methods return Unit
option-implicit            Option.apply used implicit view
package-object-classes     Class or object defined in package object
poly-implicit-overload     Parameterized overloaded implicit methods are not visible as view bounds
private-shadow             A private field (or class parameter) shadows a superclass field
stars-align                Pattern sequence wildcard must align with sequence component
type-parameter-shadow      A local type parameter shadows a type already in scope
unsound-match              Pattern match may not be typesafe

*//*

scalac -Yopt:help

compact-locals      Eliminate empty slots in the sequence of local variables
empty-labels        Eliminate and collapse redundant labels in the bytecode
empty-line-numbers  Eliminate unnecessary line number information
inline-global       Inline methods from any source, including classfiles on the compile classpath
inline-project      Inline only methods defined in the files being compiled
nullness-tracking   Track nullness / non-nullness of local variables and apply optimizations
simplify-jumps      Simplify branching instructions, eliminate unnecessary ones
unreachable-code    Eliminate unreachable code, exception handlers protecting no instructions, debug information of eliminated variables
l:none              Don't enable any optimizations
l:default           Enable default optimizations: unreachable-code
l:method            Enable intra-method optimizations: unreachable-code,simplify-jumps,empty-line-numbers,empty-labels,compact-locals,nullness-tracking
l:project           Enable cross-method optimizations within the current project: l:method,inline-project
l:classpath         Enable cross-method optimizations across the entire classpath: l:project,inline-global
*/

// Commonly used libraries. Remove what is not needed.
libraryDependencies ++= Seq(
  "commons-codec"                     % "commons-codec"                    % "1.10",
  "commons-io"                        % "commons-io"                       % "2.4",
  "commons-validator"                 % "commons-validator"                % "1.4.1",
  "joda-time"                         % "joda-time"                        % "2.8.1",
  "mysql"                             % "mysql-connector-java"             % "5.1.36",
  "ch.qos.logback"                    % "logback-classic"                  % "1.1.3",
  "com.github.t3hnar"                %% "scala-bcrypt"                     % "2.4",
  "com.google.guava"                  % "guava"                            % "18.0",
  "com.ibm.icu"                       % "icu4j"                            % "55.1",
  "com.typesafe"                      % "config"                           % "1.3.0",
  "com.typesafe.scala-logging"       %% "scala-logging"                    % "3.1.0",
  "com.typesafe.slick"               %% "slick"                            % "3.0.0",
  "com.univocity"                     % "univocity-parsers"                % "1.5.6",
  "org.apache.commons"                % "commons-compress"                 % "1.9",
  "org.apache.commons"                % "commons-lang3"                    % "3.4",
  "org.apache.commons"                % "commons-math3"                    % "3.5",
  "org.apache.httpcomponents"         % "httpclient"                       % "4.5",
  "org.joda"                          % "joda-money"                       % "0.10.0",
  "org.jsoup"                         % "jsoup"                            % "1.8.2",
  "org.scalactic"                    %% "scalactic"                        % "2.2.5",
  "org.mockito"                       % "mockito-core"                     % "1.10.19"      % Test,
  "org.scalamock"                    %% "scalamock-scalatest-support"      % "3.2.2"        % Test,
  "org.scalatest"                    %% "scalatest"                        % "2.2.5"        % Test,
  "org.seleniumhq.selenium"           % "selenium-java"                    % "2.46.0"       % Test
)

// Improved incremental compilation
incOptions := incOptions.value.withNameHashing(true)

// Improved dependency management
updateOptions := updateOptions.value.withCachedResolution(true)

/*
 * Scalastyle
 */

// Create a default Scala style task to run with tests
scalastyleConfig := baseDirectory.value / "project" / "scalastyle-config.xml"

scalastyleFailOnError := true

lazy val testScalastyle = taskKey[Unit]("testScalastyle")

testScalastyle := org.scalastyle.sbt.ScalastylePlugin.scalastyle.in(Test).toTask("").value

(test in Test) <<= (test in Test) dependsOn testScalastyle

/*
 * WartRemover
 */

wartremoverErrors ++= Seq(
  Wart.Any,
  Wart.Any2StringAdd,
  Wart.AsInstanceOf,
  Wart.EitherProjectionPartial,
  Wart.IsInstanceOf,
  Wart.ListOps,
  // Wart.NonUnitStatements,
  Wart.Nothing,
  Wart.Null,
  Wart.OptionPartial,
  Wart.Product,
  Wart.Return,
  Wart.Serializable,
  Wart.Throw,
  Wart.Var
)

/*
 * scoverage
 */

import ScoverageSbtPlugin.ScoverageKeys._

coverageMinimum := 90

coverageFailOnMinimum := true

coverageOutputCobertua := false

coverageOutputHTML := true

coverageOutputXML := false

// Uncomment to enable offline mode
// offline := true

showSuccess := true

showTiming := true

shellPrompt := { state =>
  import scala.Console.{CYAN, RESET}
  val p = Project.extract(state)
  val name = p.getOpt(sbt.Keys.name) getOrElse p.currentProject.id
  s"[$CYAN$name$RESET] $$ "
}
