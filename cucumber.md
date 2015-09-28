# Cucumber

Cucumber offers the capability to create feature specs
with the same high level end-user perspective
with which we think about products and their features
in real life.
This gives everybody working on a product
a chance to look at what they build
with common sense, intuition, and structure.

Cucumber's primary ability is to communicate
all necessary details
about how a product is supposed to work
through source code
that is understood by the product, development, and testing teams
as well as the CI server.
This allows efficient collaboration of the whole team,
with a minimal requirement for meetings.

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


### Features

Each feature should be in its own file or folder.
Each epic should have its own folder,
which contains the features for that epic.
Features should optimally contain the user story 
as a comment on top of it either 
using [persona user story](http://www.boost.co.nz/blog/2010/09/acceptance-criteria/)
or [feature injection syntax](http://lizkeogh.com/2008/09/10/feature-injection-and-handling-technical-stories/).

```cucumber
Feature: logging in

  As a user of Acme
  I want to be able to sign into my account
  So that I can enjoy the application personalized to my interests.

  Scenario: ...
```


## Scenarios

Each Scenario describes a particular way of using the respective feature,
in a particular situation.
A good structure is to have one scenario describe the happy path of the feature,
and then a number of scenarios to cover optional edge cases.

The scenario title should describe the situation that is tested
and should be easily understood.

__example__

```cucumber
Feature: Sign-In

  Scenario: with correct credentials

  Scenario: with wrong password

  Scenario: with non-existing username

  Scenario: with missing password

  Scenario: with missing username
```

If a feature has more than 10 scenarios,
its probably too big and should be broken up
into more specific features.

Common `Given` steps
at the beginning of all scenarios
can (and should) be extracted
into a `Background` block.


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

* don't use helper libraries like
  [websteps](https://github.com/kucaahbe/cucumber-websteps).
* you Cucumber
  [shouldn't](http://aslakhellesoy.com/post/11055981222/the-training-wheels-came-off)
  be based on generic low-level steps.
  That's what Selenium is for.
* Use appropriately high-level steps.

__bad example__

```cucumber
Background:
  Given a user account with name "foo" and password "bar"
  And I go to page "login"
  And I enter "foo" into the "username" field
  And I enter "bar" into the "password" field
  And I click the button "Login"
```

__good example__

```cucumber
Background:
  Given I am logged in as user "foo"
```

