# Objective-C


## Style guide

Please follow [**Originate's Objective-C style guide**](objective-c-style.md).

Other popular style guides for reference:
* [GitHub](https://github.com/github/objective-c-style-guide)
* [NYTimes](https://github.com/NYTimes/objective-c-style-guide)
* [raywenderlich](https://github.com/raywenderlich/objective-c-style-guide)
* [Google](https://google-styleguide.googlecode.com/svn/trunk/objcguide.xml)


## Historical matters


### Introduction of ARC

In 2011, Apple introduced automatic reference counting (ARC) as the memory management model for Objective-C code. ARC is available beginning with Xcode 4.2 / iOS 5.

All new codebases should use ARC, but older/legacy code may still utilize manual retain-release (MRR).

* [Apple - About Memory Management](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html)
* [Apple - Transitioning to ARC](https://developer.apple.com/library/ios/releasenotes/ObjectiveC/RN-TransitioningToARC/RN-TransitioningToARC.pdf)
