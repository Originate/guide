# Originate Guides - Ruby on Rails

Rails is best for
* quick prototypes
* small to medium sized projects (< 1 million users)
* projects that have to iterate a lot
* and many other types of projects!


## Recommended Setup

Unless there are good reasons to do otherwise, please use these libraries:
* [RSpec](http://rspec.info) for unit testing
* [Cucumber](https://cucumber.io) or [RSpec](http://rspec.info) for integration testing,
  using [Capybara](https://github.com/jnicklas/capybara) to remote-control the browser
* Authorization using [Pundit](https://github.com/elabs/pundit)


## Architectural Guidelines
* Skinny Controllers:
  they should only receive request data,
  decode it,
  and call other layers (models, services) to perform business logic
* Skinny Models:
  they should only represent domain objects (data, relationships between them),
  validations
* Service Layers:
  any business logic,
  especially logic that includes more than one model type,
  should be extracted into a service layer


## Linters and Checkers

Use these tools copiously to make your life as a developer easier!

* [Rubocop](http://batsov.com/rubocop): scans for Ruby code smells
* [Code Climate](https://codeclimate.com): scans for code smells
  * they also provide [command-line tools](https://codeclimate.com/platform)
* [Brakeman](http://brakemanscanner.org): scans for security issues in Rails
* [CoffeeLint](http://www.coffeelint.org): lints your CoffeeScript
