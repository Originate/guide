# Frameworks

*Framework* is an overloaded term that can generally refer to some unit of modularized code or a [software framework](https://en.wikipedia.org/wiki/Software_framework).

## iOS Device Frameworks

The iOS SDK consists of [dozens of device frameworks](https://developer.apple.com/library/ios/documentation/Miscellaneous/Conceptual/iPhoneOSTechOverview/iPhoneOSFrameworks/iPhoneOSFrameworks.html). These frameworks are typically suffixed with "Kit" and provide developers with the classes needed to build different aspects of their applications.

`Foundation` and `UIKit` provide the basic classes for all iOS apps.

Here are some common and more specialized frameworks:

* `AddressBook`
* `AVFoundation`
* `CoreGraphics`
* `CoreLocation`
* `iAd`
* `MapKit`
* `MediaPlayer`
* `SpriteKit`
* `WebKit`

## Third-Party Libraries

Frameworks can also generally refer to "libraries" or modules.

The open-source community thrives with many libraries and modules that all developers can utilize and benefit from quickly. Some popular and commonly used ones are listed here (and this list is by no means exhaustive):

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)
* [FormatterKit](https://github.com/mattt/FormatterKit)
* [Mantle](https://github.com/Mantle/Mantle)
* [Masonry](https://github.com/SnapKit/Masonry)
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* [NYTPhotoViewer](https://github.com/NYTimes/NYTPhotoViewer)
* [OCMock](http://ocmock.org/ios/)
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [SDWebImage](https://github.com/rs/SDWebImage)
* [YLTableView](https://github.com/Yelp/YLTableView)

A much more complete list is available at [vsouza/awesome-ios](https://github.com/vsouza/awesome-ios).

### Dependency Management

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is the de facto tool used by iOS developers to manage their code dependencies. Most popular frameworks (such as the ones listed above) are available as *pods*. The CocoaPods tools and ecosystem is very actively maintained and developed.

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a newer iOS dependency manager with a different philosophy to adding frameworks to your codebase (with some [limitations](https://github.com/Carthage/Carthage#supporting-carthage-for-your-framework)).

## Open-source Originate Frameworks

We have a private [CocoaPods specs repo](https://github.com/Originate/CocoaPods) for our growing list of internally-spawned modules.
