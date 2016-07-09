# Feature Specs Example

Since feature specs may vary from app to app, we'll be using the following generic two screen feed app as an example app for this guide. For example, let's say that our app has the following two screens and we want to build a feature spec that describes the flow of getting to the Feed Page.

* Splash Screen with "Feed Me" button (which loads the Feed Page when clicked)
* Feed Page which contains a list of feed items

The complete feature spec code built from this example can be found [here](/android/files/code/featureSpecs).

## Environment Setup

In order to setup the Android emulator and selenium, we'll put the following `env.rb` script in our app's features/support directory.

**features/support/env.rb:**

```ruby
require 'appium_lib'
require 'cucumber'

# get latest APP_PATH for USER & APPNAME
APP_PATH = "#{Dir.pwd}/app/build/outputs/apk/app-debug.apk"
puts "Using App Path : %s" % APP_PATH

# set the app package which will be needed for some Appium commands
APP_PACKAGE = "com.originate.feedapp"
APP_ACTIVITY = "#{APP_PACKAGE}.activity.SplashScreenActivity"

Before do
  setup_emulator
end

After do
  driver_quit
end

# Create a custom World class so we don't pollute `Object` with Appium methods
class AppiumWorld
end

# Create a new Appium session for testing apps.
def setup_emulator
  capabilities = {
  	'appium-version': '1.0',
  	'platformName': 'Android',
  	'platformVersion': '4.4',
  	'deviceName': 'testAVD',
  	'app': APP_PATH,
  	'appPackage': APP_PACKAGE,
  	'appActivity': APP_ACTIVITY
  }
  Appium::Driver.new(caps: capabilities).start_driver
  Appium.promote_appium_methods AppiumWorld
end

World do
  AppiumWorld.new
end
```

Notes:

* Adjust **APP_PATH** as necessary. Note: `Dir.pwd` ensures that correct path will be used both locally and on CircleCI.
* Change **APP_PACKAGE** and **APP_ACTIVITY** to match your application's appropriate app package and main activity.

## Appium Helper Methods

**features/support/appium_helpers.rb:**

```ruby
# Clicks the element with the given id
def click_id id
  wait { find_element(:id, id).click }
end

# Clicks the element at the given XPath
def click_xpath path
  wait { find_element(:xpath, path).click }
end

# finds the element with the given id
def find_id id
  wait { find_element(:id, id) }
end

# finds the element at the given XPath
def find_xpath path
  wait { find_element(:xpath, path) }
end

# Waits the given number of times for the given block to become true
def wait timeout: 3, &block
  wait = Selenium::WebDriver::Wait.new timeout: timeout
  wait.until(&block)
end
```

Notes:

* The `wait` function defined above errors out if the given code block doesn't become true within 3 seconds.
* The `find` functions return the element with the given `:id` or `:xpath` and errors out if no element is found.
* The `click` functions click on the given element thus invoking any OnClickListeners that might be attached.
* Additional Appium methods that can be used here can be found [here](https://github.com/appium/ruby_lib/blob/master/docs/android_docs.md).

## Ruby Helper Methods

**features/support/feed_helpers.rb:**

```ruby
def click_feed_me_button
  click_id "#{APP_PACKAGE}:id/splash_button"
end

def feed_me_button_exists
  find_id "#{APP_PACKAGE}:id/splash_button"
end

def feed_is_visible
  find_id "#{APP_PACKAGE}:id/feed_list"
end
```

The above helper methods simply invoke Appium helper methods defined in the section above. It should be noted that Appium ids are longer than the standard Android resource id. They are prefixed with `the.app.package:id/` as seen above.

## Cucumber Feature Script

**features/feed.feature:**

```cucumber
Feature: Feed

  Scenario: Getting to the Feed Page
    Given I am on the Home Screen
    When I press the Feed Me button
    Then I end up on the Feed Page
```

Notes:

* Each `.feature` file is meant to describe a single **Feature** of the system.
* A **Scenario** is a concrete example that illustrates a business rule. A single feature can have multiple scenarios.
*  Scenario's are typically defined by a set of **Given**, **When** and **Then** steps.
	*  **Given** steps describe the initial context of the application.
	*  **When** steps describe an action or event that takes place.
	*  **Then** steps describe the outcome or result of the previous action.

## Cucumber Step Definitions

**features/step_definitions:**

```ruby
Given(/^I am on the Home Screen$/) do
  feed_me_button_exists
end

When(/^I press the Feed Me button$/) do
  click_feed_me_button
end

Then(/^I end up on the Feed Page$/) do
  feed_is_visible
end

```

Step definitions are small pieces of code that define what happens when a Gherkin step is executed. In the example above, each step definition simply calls the applicable Ruby helper method. Note: Step definitions and helper methods can be combined if desired, however separating them out allows the same step definitions to be used across both Android and iOS.
