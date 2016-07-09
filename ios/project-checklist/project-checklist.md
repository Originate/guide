# Project Checklists

All iOS projects should strive to follow these guidelines.

1. [Project setup](#project-setup)
2. [Submitting to App Store](#submitting-to-app-store)


## Project setup

1. Project should include a useful _README.md_ document
    * ideally any question a developer would need for onboarding should be answered here
    * efforts should be taken to keep this document up-to-date - a stale README is arguably worse than no README
2. Add a _.gitignore_ file
    * [GitHub's .gitignore collection](https://github.com/github/gitignore)
        * [Objective-C.gitignore](https://github.com/github/gitignore/blob/master/Objective-C.gitignore)
        * [Swift.gitignore](https://github.com/github/gitignore/blob/master/Swift.gitignore)
        * [Xcode.gitignore](https://github.com/github/gitignore/blob/master/Global/Xcode.gitignore)
3. Follow version control best practices. `master`, `dev`, and feature branches are commonly used.
4. Ensure the team is using the same version of Xcode (the most recent version, if possible)
5. Setup [static code analysis and linting](static-analysis.md)
6. Create and use a [localization file](https://www.objc.io/issues/9-strings/string-localization/) for user-facing strings
7. Set up crash reporting with [Crashlytics](https://crashlytics.com)
8. Add a [Settings.bundle](settings-bundle.md)
9. Set up [continuous integration](../core-competencies/deployment.md)
10. [CocoaPods](https://cocoapods.org/) is the current standard for adding third-party libraries and frameworks to a project


## Submitting to App Store

Releasing an app to the App Store should not be taken lightly. Steps must be taken to ensure what you submit is correct and will work once published to the store. Allocate at least 4 hours to make sure everything is working properly before submitting.

1. Scan and understand [Apple's App Distribution Guide](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/AppDistributionGuide.pdf)
2. Understand the app's responsibility for securing data. ([Software Security](https://developer.apple.com/library/ios/documentation/Security/Conceptual/Security_Overview/Introduction/Introduction.html#//apple_ref/doc/uid/TP30000976-CH1-SW1)).
3. Ensure final code commits pass all tests and are pushed out
4. Update the app's public version number in the Info.plist file (`CFBundleShortVersionString`)
    * For every new public version number, reset the private version back to 1.0 (`CFBundleVersion`). This number is only incremented in rare cases, such as when iTunes Connect requires a new build. This isn't user-facing, so the exact values are not too important.
5. If using Core Data, ensure that a database migration is handled appropriately by the app
6. Ensure debugging statements and development-only code are not built when making a release build
7. Ensure the app uses the correct production server endpoints for release builds
