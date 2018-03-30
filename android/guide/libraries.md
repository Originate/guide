# Android Libraries

Here at Originate, we encourage the use of (and contribution to) open source libraries. However, be careful to review the license associated with all libraries before you use them. Some open source licenses (such as [GNU GPL](http://en.wikipedia.org/wiki/GNU_General_Public_License)) contractually obligate you to open source any code that uses it.

This list is not intended to be exhaustive; rather, it is a useful starting point for green-field applications or alternatives to current solutions.

## Event Bus

* [EventBus](http://greenrobot.github.io/EventBus/) - is an Android optimized publish/subscribe event bus.
* [Otto](http://square.github.io/otto/) - forked from [Google Guava](https://github.com/google/guava), this event bus allows different parts of the application to communicate through a unified interface.

## ReactiveX

* [RxAndroid](https://github.com/ReactiveX/RxAndroid) - Android specific bindings for RxJava.
* [RxJava](https://github.com/ReactiveX/RxJava) - is a Java VM implementation of [Reactive Extensions](http://reactivex.io/): a library for composing asynchronous and event-based programs by using observable sequences.

## Dependency/View Injection

* [ButterKnife](http://jakewharton.github.io/butterknife/) - Annotation-based dynamic view and resource injection along with annotated OnClick Listener injection by resource ID.
* [Dagger](http://square.github.io/dagger/) - Annotation-based dependency-injection; useful for setting up your code for testing.
* [Dagger 2](http://google.github.io/dagger/) - Google's fork of Square's original Dagger. Dagger 2 is a compile-time evolution approach to dependency injection. Taking the approach started in Dagger 1.x to its ultimate conclusion, Dagger 2.0 eliminates all reflection, and improves code clarity by removing the traditional ObjectGraph/Injector in favor of user-specified @Component interfaces.

## Network/Image Libraries

Wrapping HTTP calls in AsyncTask is a [limiting and possibly error-prone](http://blog.danlew.net/2014/06/21/the-hidden-pitfalls-of-asynctask/) method of handling network calls in Android. Luckily, there exist numerous viable networking libraries to handle network requests.

In general, we've found a combo of Square's OkHttp, Retrofit and Picasso to be sufficiently powerful and easy to use for many of the applications that we build. Alternatively, Ion is a great all purpose library for those looking for single image & networking solution. With that said, it's hard to go wrong with any of the options listed below.

### Networking

* [OkHttp](http://square.github.io/okhttp/) is an HTTP & SPDY client for Android and Java applications.
* [Retrofit](http://square.github.io/retrofit/) is a type-safe REST client for Android and Java.

### Image Loading

* [Android Universal Image Loader](https://github.com/nostra13/Android-Universal-Image-Loader) - features async loading of both local and web images, caching, automatic resizing, etc.
* [Fresco](http://frescolib.org/) - is a powerful system for displaying images in Android and is developed and utilized by [Facebook](https://code.facebook.com/projects/).
* [Glide](https://github.com/bumptech/glide) - is a media management and image loading framework that focuses on making scrolling across images as smooth and fast as possible.
* [Picasso](http://square.github.io/picasso/) - is a powerful image downloading and caching library made by the great developers over at [Square](http://square.github.io/).

### All-in-One

* [Ion](https://github.com/koush/ion) - uses a Builder pattern, has built-in caching, and can be used for long-running background tasks. Also has all of the features of Universal Image Loader and the added benefit that you don't have to add another library.
* [Volley](https://android.googlesource.com/platform/frameworks/volley) - more "low level" than Ion, but consequently gives you more control. For images it uses a custom `NetworkImageView` instead of the classic `ImageView`, but does better handling of whether an image is visible or not. Available through Gradle/Maven, via an [unofficial mirror](https://github.com/mcxiaoke/android-volley).


## Utility Libraries

* [Android Priority Job Queue](https://github.com/path/android-priority-jobqueue) - is an implementation of a [Job Queue](https://en.wikipedia.org/wiki/Job_queue) specifically written for Android to easily schedule jobs (tasks) that run in the background, improving UX and application stability.
* [Download Progress Bar](https://github.com/panwrona/DownloadProgressBar) - is an animated Android progress bar.
* [Gson](https://github.com/google/gson) - is a Java library for converting between Java Objects and JSON representation.
* [Hugo](https://github.com/JakeWharton/hugo) - is an annotation-triggered method call logging for debug builds.
* [LeakCanary](https://github.com/square/leakcanary) - is a memory leak detection library for Android and Java.
* [Material View Pager](https://github.com/florent37/MaterialViewPager) - is an easy to use Material Design ViewPager.
* [Pocket Knife](http://hansenji.github.io/pocketknife/) - is an Intent and Bundle utility library for Android.
* [Saguaro](https://github.com/willowtreeapps/saguaro) - is an Android library to make it easier to add version information and licensing information, and facilitate sending feedback.
* [SDK Manager Plugin](https://github.com/JakeWharton/sdk-manager-plugin) - is a Gradle plugin which downloads and manages your Android SDK.
* [Segment](https://segment.com/docs/libraries/android/quickstart/) - is a customer data hub that allows you to collect data from single API and send it to multiple integrations.
* [Timber](https://github.com/JakeWharton/timber) - A logger with a small, extensible API which provides utility on top of Android's normal Log class. Allows you to switch out logger instances so that logs can be treated differently in release and debug builds.
* [TourGuide](https://github.com/worker8/TourGuide) - is an Android library that aims to provide an easy way to add pointers with animations over a desired Android View