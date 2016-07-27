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
  between the product, development, and testing teams.
  It reflects the team's understanding and expectations of the product,
  and helps remove process, for example, to replace boring meetings with online collaboration.
* It is a form of _automated executable testing_ that makes collaborative TDD
  easy, intuitive, and efficient.

All of these things together make Cucumber a tool that supports the collaborative agile
development process on many levels,
from defining over building to testing the product.


Cucumber is available in all stacks used at Originate:
* [Cucumber-Ruby](https://github.com/cucumber/cucumber-ruby) as well as [Cucumber-Rails](https://github.com/cucumber/cucumber-rails)
* [Cucumber-JS](https://github.com/cucumber/cucumber-js)
* [Cucumber-JVM](https://github.com/cucumber/cucumber-jvm)
* [and more...](https://cucumber.io/docs)

----

This guide provides a number of tips and best practices for writing Cucumber specs.


## Folder hierarchy

* each epic is its own folder
* each feature is in its own file or folder inside an epic folder


## Gherkin

[Gherkin](https://cucumber.io/docs/reference) is the language in which Cucumber specs are written in.
It should end up sounding close to real English,
similar to how you would describe the product
to a normal person in a casual and focussed conversation.
Ideally, somebody with no detailed knowledge about the product
should understand how a particular feature works
after reading the Gherkin in the Cucumber spec for it.

Gherkin files contain:

1. __feature name:__
  the most concise summary of the feature -
  if you had to explain it in as few words as possible.

2. __user story:__
  important context for the feature:
  * _who_ it is for: if it doesn't benefit an important stakeholder, it shouldn't exist
  * _what_ functionality it provides
  * _why_: what relevant benefit / business metric is improved by this feature
           (if nothing gets improved, it shouldn't exist)

  These questions are important.
  
  A good product only contains features that are relevant and provide value.
  Understanding what value we try to provide to whom
  is important for developers and testers
  for building and testing the feature correctly.
  This also helps with re-evaluating features as part of product maintenance later.
  The user story documents these aspects and provides context in a concise format.

3. __rules:__ key data points and acceptance criteria about this feature,
              as a bullet point list.
              Rules use (and thereby define) the correct terminology for domain concepts.

4. __notes:__ (optional) implementation-specific notes about this featurs,
              like open questions about it

5. __scenarios:__ demonstrate how the rules are implemented in the product.


```cucumber
Feature: Updating account information

  As a user of FooBar
  I want to be able to update my account's details
  So that I can correct typing mistakes and keep my account details accurate.

  Rules:
  - normal users can update the first and last name of their own account
  - normal users cannot update other accounts
  - admins can update any account
  - when an account is updated, an email is sent to the account's primary email
    to confirm the changes

  Notes:
  - if an admin changes an account, should it send a different email?


  Scenario: a user updates their last name
    Given I am logged in as "John Doe"
    When updating my last name to "Connor"
    Then my name is "John Connor"


  Scenario: a user tries to update another account's details
    ...


  Scenario: an admin updates another account
    ...
  ```

### Writing Scenarios

Each Scenario describes how the respective feature is used
in a particular situation.
If you work out the rules for the feature,
the scenarios fall out naturally:
start with one scenario per rule, then add edge cases.

A good way to determine the scenario name is how [Friends](http://www.imdb.com/title/tt0108778)
episodes are named: _"(the one where) ..."_

Common `Given` steps
at the beginning of all scenarios
can (and should) be extracted
into a `Background` block.

If a feature ends up with more than 10 scenarios,
it is probably too big and should be broken up
into more specific features.

Gherkin should be written __declarative__ instead of imperative.
Describe _what_ the product provides,
not _how_ exactly we are testing it.
Test mechanics should live in the step implementations.

__bad example__
```cucumber
Given a user account called "Mike"
And the user logs in as "Mike"
When the users clicks on "Products"
And the page reloads
And the user clicks on "milk"
And the user enters "2"
And the user clicks on "checkout"
```

__good example__
```cucumber
When Mike purchases 2 cartons of milk
```


## Multi-level Cucumber

Cucumber enforce consistent behavior of an application on several levels,
implementing several levels of the _testing pyramid_:
* __model layer:__ against the domain models or service layer.
  This allows to create the core of the application and its business logic first,
  without having to worry how it is exposed to the outside world
* __controller layer:__ against the APIs that expose the business logic.
  This allows amongst other things to verify access controls.
* __view layer:__ against the UI. This allows to verify that the app works as a whole.

To make this possible,
scenarios must be free from implementation details of one particular layer.
As an example, here is the scenario from above loaded with implementation details
about the API. Don't do this.

```cucumber
When I send a PATCH request to "/users/1" with the payload:
  """
  { "last_name": "Connor" }
  """
Then a GET request to "/users/1" returns:
  """
  {
    "first_name": "John",
    "last_name": "Connor"
  }
  """
```

As another example, here is the same scenario loaded with implementation details
of the web UI. Don't do this either.

```cucumber
When I go to "/users/1"
And I enter "Connor" into the "Last name" text field
And I click the button "SUBMIT"
And I wait until I see "User updated"
Then the page contains "John Connor"
```

Don't mix different levels in your specs.


## Step definitions

Step definitions should sound like basic English.
Use `And` for consecutive steps of the same type (Given, When, Then)
When you extract data from a Cucumber string,
you should wrap the extracted data in double quotes.
This can be omitted if it is obvious what exactly is getting extracted,
i.e. a number.

Avoid "ego-centric" Cucumber where each step starts with "I".
The subject in your step definition should be
what is actually doing the described thing
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

