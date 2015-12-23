# Cucumber

Cucumber fulfills many roles in modern agile development teams:

* It is _living documentation_ of the application
  that never becomes outdated because is updated together with code changes.
  This documentation gives an overview of an application's behavior
  on the same high-level end-user perspective
  with which we think about products and their features in real life,
  thereby allowing to use common sense in addition to technical thinking.
  Gherkin lists the value propesition of a feature as a user story,
  the cornerstones and rules of it,
  as well as concrete examples how these rules are implemented in the product.
* Cucumber is also a _communication vehicle_ between the product, development, and testing teams
  that helps remove process and replaces boring meetings with online collaboration.
* Finally, it is a form of automated testing that makes TDD
  easy, intuitive, and efficient.

All of these things together make Cucumber a tool that supports the collaborative agile
development process on many levels,
from defining over building to testing the product.


Please check out:

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

Cucumber is available in all stacks used at Originate:
* [Cucumber-Ruby](https://github.com/cucumber/cucumber-ruby) as well as [Cucumber-Rails](https://github.com/cucumber/cucumber-rails)
* [Cucumber-JS](https://github.com/cucumber/cucumber-js)
* [Cucumber-JVM](https://github.com/cucumber/cucumber-jvm)


## Guidelines for writing Cucumber

Cucumber specs should end up sounding close to real English,
similar to how you would describe the product
to a normal person.
Ideally, somebody with no detailed knowledge about the product
should understand how a particular feature works
after reading a Cucumber spec for it.


### Folder hierarchy

* each feature is in its own file or folder
* each epic has its own folder
* features contain the user story, rules, and scenarios that demonstrate how the
  rules apply within the product.

```cucumber
Feature: Updating user details

  As a user of FooBar
  I want to be able to update my account's details
  So that I can correct typing mistakes and keep my account details accurate.

  Rules:
  - normal users can update the first and last name of their own account
  - normal users cannot update other accounts
  - admins can update any account
  - when an account is updated, an email is sent to the account's primary email 
    to confirm the changes


  Scenario: a user updates their last name
    Given am logged in as "John Doe"
    When I update my last name to "Connor"
    Then my name is "John Connor"


  Scenario: a user tries to update another account's details
    ...


  Scenario: an admin updates another account
    ...
  ```


## Scenarios

Each Scenario describes a particular way of using the respective feature
in a particular situation.
If you write down the rules of the feature first,
the scenarios fall out naturally.

If a feature has more than 10 scenarios,
its probably too big and should be broken up
into more specific features.

Common `Given` steps
at the beginning of all scenarios
can (and should) be extracted
into a `Background` block.


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
When I log in as "foo" with password "bar"
Then the application greets me with "welcome foo!"
```
