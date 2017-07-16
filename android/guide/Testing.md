# Android Testing

## Integration Tests

Integration tests (aka feature specifications) are an essential part of [test-driven development (TDD)](http://en.wikipedia.org/wiki/Test-driven_development). To verify that our application as a whole works, we simulate user interaction with our app and check that our app, as a black box, exhibits the correct behaviors. This allows us to catch regressions that might arise from refactoring and reduces the need for repetitive manual testing on the slow Android emulators. Integration tests can also help ensure that requirements are met by acting as acceptance criteria.

In order to create integration tests on Android, we write feature specs with [Cucumber](https://cucumber.io) and [Appium](http://appium.io). [Checkout Originate's complete guide for writing and running Android feature specs.](feature_specifications.md)

## Popular Testing Frameworks

A number of testing options are available for Android applications. Some of the most popular/widely used frameworks are listed below.

* [Mockito](https://code.google.com/p/mockito/) - A java mocking framework that now supports Android! We've used this on the Newaer project with good results.
* [Espresso](https://google.github.io/android-testing-support-library/docs/espresso/) - UI/Automation tests. It's [faster than Robotium](http://www.stevenmarkford.com/android-espresso-vs-robotium-benchmarks/) and the API is simpler.
* [Robolectric](http://robolectric.org) - Android unit test framework that decouples the the android-sdk.jar so you can test within your JVM on your workstation.
* [Robotium](https://code.google.com/p/robotium/) - Another automation framework that seems to be popular. We haven't used this on any of our projects yet.
* [UI Automator](http://developer.android.com/training/testing/ui-testing/index.html) - Google's newly released UI functional testing framework.
* [RoboSpock](http://robospock.org) - JVM-based unit-tests.
* [Appium](http://appium.io) - based on the Selenium web-driver. Useful for UI tests and integration tests.
