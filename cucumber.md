# Originate Guides - Cucumber

Feature specifications written using Cucumber fulfill many roles in modern agile development teams:

* It is _living documentation_ of the product
  that never becomes outdated because it is updated together with code changes.
  This documentation gives an overview of an application's behavior
  at the same high-level end-user perspective
  with which we think about products and their features in real life,
  thereby allowing teams to use common sense in addition to technical thinking.
  [Gherkin](https://cucumber.io/docs/reference) lists the value proposition of a feature as a user story,
  the cornerstones and rules of it,
  as well as concrete examples ([specification by example](https://en.wikipedia.org/wiki/Specification_by_example)) how these rules are implemented in the product.
* Cucumber is a _communication vehicle_
  between the product, development, testing, and
  [design](https://ustwo.com/blog/why-designers-should-care-about-behaviour-driven-development)
  teams.
  It reflects the team's understanding and expectations of the product,
  and helps remove process, for example, to replace boring meetings with online collaboration.
* It is a form of _automated testing_ that makes collaborative TDD
  easy, intuitive, and efficient.

All of these things together make Cucumber a tool that supports the collaborative agile
development process in the most seamless way on many levels,
from defining over building to testing the product.


Cucumber is available in all stacks used at Originate:
* [Cucumber-Ruby](https://github.com/cucumber/cucumber-ruby) as well as [Cucumber-Rails](https://github.com/cucumber/cucumber-rails)
* [Cucumber-JS](https://github.com/cucumber/cucumber-js)
* [Cucumber-JVM](https://github.com/cucumber/cucumber-jvm) with support for [Scala](https://github.com/cucumber/cucumber-jvm/tree/master/examples/scala-calculator)
* [and more...](https://cucumber.io/docs)

This guide provides a number of tips and best practices for writing Cucumber specs.


## Folder hierarchy

* the feature specs are located in a folder called `features`
* folders represent epics
* files with extension `.feature` represent individual features


## Gherkin

[Gherkin](https://cucumber.io/docs/reference) is the language in which Cucumber specs are written.
It is an industry standard
for expressing feature specifications
in a compact and complete format.
Gherkin provides information about the feature
in varying levels of aggregration:

1. __feature name:__
  the most concise summary of the feature -
  if you had to explain it in as few words as possible.

2. __user story:__
  context for the feature:
  * _where_: the use case for which the feature provides value
  * _what_ functionality provided by the feature
  * _why_: what relevant benefit / business metric is improved by this feature
           (if nothing gets improved, it shouldn't exist)

  These questions are important.
  A good product only contains features that are relevant and provide value.
  Understanding what value each feature provides to whom
  is not only important for product managers,
  but also for developers and testers
  in order to build and test the feature correctly.

3. __rules:__ how the feature works in generic, abstract terms
              as a bullet point list.
              Rules use (and thereby define) the correct terminology for domain concepts.

4. __notes:__ (optional) auxillary information about this feature,
              like open questions about it

5. __scenarios:__ concrete examples of how exactly the feature works
                  in different situations.
                  Typically there is a happy path scenario
                  that describes the workflow in more detail,
                  followed by a number of more concise scenarios
                  that describe the behavior of the feature in edge cases.


## Example

This example will be discussed in detail below.

```cucumber
Feature: Updating account information

  When changing my name or email address
  I want to be able to update these fields in my user account
  So that I can keep my account details up to date.

  Rules:
  - normal users can update the first and last name of their own account
  - normal users cannot change other accounts
  - admins can update any account
  - when an account is updated, an email is sent to the account's primary email
    to confirm the changes

  Notes:
  - if an admin changes an account, should it send a different email?


  Background:
    Given I am logged in as John Doe


  @web
  Scenario: a user updates their own account information via the UI
    When clicking on the "my account" menu item
    And selecting "change account details" from the dropdown menu
    And updating the field "last name" to "Connor"
    Then I see "account information updated"
    And my name is now John Connor


  @api
  Scenario: a user updates their own account information via the API
    When receiving a PUT request to "/users/<user id>" with the payload:
      """
      { "last_name": "Connor" }
      """
    Then a GET request to "/users/<user id>" returns:
      """
      {
        "id": 12,
        "first_name": "John",
        "last_name": "Connor"
      }
      """


  @web @api
  Scenario: a user tries to update another account
    When trying to update the account of Dorian Gray
    Then I get the error "You cannot change this account"
    And that account is unchanged


  @web @api
  Scenario: an administrator updates another account
    Given I am logged in as an admin
    When updating the last name of John Doe to "Connor"
    Then that account new has the name John Connor


  @web @api
  Scenario: missing required information
    When trying to update my last name to ""
    Then I get the error "The last name is required"
    And my name is still John Connor
  ```


### Scenarios

Each Scenario describes how the respective feature works or is used
in a particular situation.
It should sound close to real English,
similar to how you would describe the feature
to a normal person in a casual but focussed conversation.

Write Gherkin from the top down:
start with the feature name,
then the user story,
then the rules.
Once you have the rules for the feature,
the scenarios will fall out naturally from them:
start with one scenario per rule, then add edge cases.
As you discover more edge cases, add them to the rules section.

A good way to determine the scenario name is how [Friends](http://www.imdb.com/title/tt0108778)
episodes are named: _"(the one where) ..."_

In the example, scenario #1 and #2 are happy path scenarios.
They specify details that make up the feature and how it is used,
like how the fields are named or how the data payload of the API looks like.
Scenarios #3-5 describe edge cases.
They rely that it is clear from the happy path scenarios how a feature is used,
and just run on a single line it with different values.

Step definitions should sound like basic English.
Use `And` for consecutive steps of the same type (Given, When, Then)
When you extract data from a Cucumber string,
you should wrap the extracted data in double quotes.
This can be omitted if it is obvious what exactly is getting extracted,
i.e. a number.


## Setting up test data

Each test runs with a completely empty system.
So if your feature requires data to exist,
you need to declare which one in `Given` steps.
Common `Given` steps
at the beginning of all scenarios
can (and should) be extracted
into a `Background` block.
Steps in that block get executed before each scenario.


## Feature size

As a rule of thumb,
if a feature ends up with more than 6 scenarios,
it is probably too big and should be broken up
into more specific features.
If it has only one scenario,
think harder about edge cases
like user errors, user roles, access rights,
or different ways of using the feature.


## Cucumber Anti-Patterns

These are typical poor uses of Cucumber.
They don't always have to be bad, but indicate an area that should be reviewed
because very often there is a better way of doing things.


* __Writing the scenario after you've written the code:__
  Most of the value Cucumber provides occurs before the code is written.
  If you write Cucumber after the feature is build,
  Cucumber is just a relatively pointless and boring exercise that doesn't provide much value.

* __BA/Product Owner creating scenarios in isolation:__
  Cucumber is supposed to be a communication tool.
  The product owner can draft a Cucumber spec,
  but it should result in a conversation with other team members.

* __Developers or testers write their scenarios without talking to business people:__
  Cucumber is not a testing tool, but a communication tool between all stakeholders.

* __Incidental details:__
  they are great for discovering the product domain,
  but should be cleaned up in the final feature spec if they don't add value.

* __Noisy scenarios:__
  each step in a scenario should add meaningful value.

* __Testing several rules at the same time:__
  make sure that each rule is clearly described,
  ideally in its own scenario.

* __Scenario with either a bad name or no name at all:__
  the name of a scenario gives important information what this scenario describes.
  This helps navigate the Cucumber spec efficiently
  without having to read through all the scenarios.

* __Adding pointless scenario descriptions:__
  the scenario should speak for itself,
  no need for comments or
  prolonged descriptions in its name.

* __Testing every scenario through the UI:__
  this end-to-end testing is the slowest and most brittle form of testing.
  Some scenarios should run against the UI, but not all of them.
  Follow the [testing pyramid](https://martinfowler.com/bliki/TestPyramid.html).

* __Overuse of scenario outlines:__
  they increase the number of tests run.
  Use them only when the scenarios are very fast.

* __No clear separation between Given, When, and Then:__
  _Given_ is for setting up the test environment,
  _When_ is for running the code under test,
  _Then_ is for verifying the outcome.

* __High-level and vague scenarios:__

  Too high-level version of the example above,
  doesn't explain how the feature works:

  ```cucumber
  When updating my account information
  Then my account information is updated
  ```

* __Egocentric scenarios:__

  Avoid having every step begin with "I".
  The subject in your step definition should be
  who is actually doing the described thing
  in real life.

  __bad example__

  ```cucumber
  Given I have a user account with name "foo" and password "bar"
  When I log in as "foo" with password "bar"
  Then I see "welcome foo!"
  ```

  __good example__

  ```cucumber
  Given a user account with name "foo" and password "bar"
  When logging in as "foo" with password "bar"
  Then the application greets me with "welcome foo!"
  ```

More information:
* [Cucumber anti-patterns (part one)](https://cucumber.io/blog/2016/07/01/cucumber-antipatterns-part-one)
* [Cucumber anti-patterns (part two)](https://cucumber.io/blog/2016/08/31/cucumber-anti-patterns-part-two)


## Further reading:

* [Kevin's Uncubed Edge class for Cucumber](http://edge.uncubed.com/course/originate-cucumber)
  for a practical example
  of how this collaboration could look like,
* [User-level feature specs with Cucumber](http://blog.originate.com/blog/2014/12/02/high-level-cucumber)
  for a more developer-centric visualization
  of how much more powerful and expressive
  a well written Cucumber spec is
  over source code
  when it comes to describing application features
  on a high level.
* [the world's most misunderstood collaboration tool](https://cucumber.io/blog/2014/03/03/the-worlds-most-misunderstood-collaboration-tool)
* [three amigos meeting - agree on the tests before development starts](http://itsadeliverything.com/three-amigos-meeting-agree-the-tests-before-development-starts)

