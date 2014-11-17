#Android Best Practices

Writing performant Javacode for Android essentially boils down to two main rules - 

(1) Don't do work that you don't have to, and <br>
(2) don't make the JVM do work that it doesn't have to. 

In this vein, read, learn, and memorize this page: [http://developer.android.com/training/articles/perf-tips.html](http://developer.android.com/training/articles/perf-tips.html)

Otherwise, look below for an inexhaustive compendium of ways you can make your Android code better.

### The UI Thread

There are two simple rules for doing work on the UI thread:

1. Don't block the UI thread.
2. Don't do UI work when you aren't on the UI thread.

A short list of stuff that might block the UI thread:

- pulling a bitmap of any size into memory
- **ANY NETWORK CALLS **(your app will crash on API 3+ if you try this)
- downloading a 10 MB file from your server
- large (`LIMIT>20` rows) DB operation
- using [ImageView.setImageResource(resId)](http://developer.android.com/reference/android/widget/ImageView.html#setImageResource(int))
- recursively computing the first 200 digits of Fibonacci 

If you're doing a short task that will involve a blocking operation, consider using an [AsyncTask](http://developer.android.com/reference/android/os/AsyncTask.html). This kicks off a background thread (from a thread pool) using the initialization parameters you provide, does the computation, and returns back onto the UI thread with the result. Easy!

For longer-running actions, consider a [Thread](http://developer.android.com/reference/java/lang/Thread.html) or [Service](http://developer.android.com/reference/android/app/Service.html). For a more complete guide to worker threads, check out the developer docs [page on threading](http://developer.android.com/guide/components/processes-and-threads.html#WorkerThreads). 

###Strings and Object Creation

It's a basic rule of Java, but people still forget - **String is an immutable class**. This means that when you concat two strings, you're _creating a brand new object_.  So, for example:

```java
String container = "";
for (String item : list){
    container += item; // don't do this!
}
return container;
```

If `list` is 100 elements, suddenly, the GC has to collect 100 useless objects. Do this instead:
```java
//bonus points for initializing the StringBuilder with an appropriate size.
StringBuilder container = new StringBuilder(); 
    for (String item : list){
    container.append(item); // much better!
}
return container.toString();
```

Now, instead of creating 100 objects, we're creating 1. 

Another thing to note - most String methods, or many methods that involve Strings, are O(n) operations. 

```java 
Set<String> set = new HashSet<String>();
for(int i = 0; i<9999; i++){ 
    set.contains(aReallyLongString);
}
```

Each of the 9,999 times you do the `set.contains(...)`, the JVM has to iterate over _the entire String_ in order to hash it. When your String is "hello world", that's not a problem. When your String is a 50KB JSON payload, it gets a bit more costly. 

Obviously, use a `HashSet<String>` when necessary - but always be aware of the code that you write and the impact it has on the system. 

###Autoboxing/Unboxing

While hardly a requirement, consider using Android's hand-written SparseArray classes ([SparseArray](http://developer.android.com/reference/android/util/SparseArray.html), [SparseBooleanArray](http://developer.android.com/reference/android/util/SparseBooleanArray.html), [SparseIntArray](http://developer.android.com/reference/android/util/SparseIntArray.html), and [SparseLongArray](http://developer.android.com/reference/android/util/SparseLongArray.html)). These classes map a primitive int to Objects, booleans, ints, and longs, respectively.

These avoid the slightly costly problem of the JVM having to autobox/unbox primitives when inserting/obtaining them from Sets and Maps. The tradeoff is that these data structures are not random access - they use binary search, so access is O(log n) versus a HashMap's O(1).

###Images and Bitmaps

Images are a special beast in Android. [The Android Docs](http://developer.android.com/training/displaying-bitmaps/index.html), accurately summarizing the problem, says:

>Mobile devices typically have constrained system resources. **Android devices can have as little as 16MB of memory available to a single application**. The [Android Compatibility Definition Document](http://source.android.com/compatibility/downloads.html) (CDD), _Section 3.7. Virtual Machine Compatibility_ gives the required minimum application memory for various screen sizes and densities. Applications should be optimized to perform under this minimum memory limit. However, keep in mind many devices are configured with higher limits.
>
>Bitmaps take up a lot of memory, especially for rich images like photographs. For example, the camera on the [Galaxy Nexus](http://www.android.com/devices/detail/galaxy-nexus) takes photos up to 2592x1936 pixels (5 megapixels). If the bitmap configuration used is [ARGB_8888](http://developer.android.com/reference/android/graphics/Bitmap.Config.html) (the default from the Android 2.3+) then loading this image into memory takes about 19MB of memory (2592*1936*4 bytes), immediately exhausting the per-app limit on some devices.
>
>Android UIs frequently require several bitmaps to be loaded at once. Components such as [ListView](http://developer.android.com/reference/android/widget/ListView.html), [GridView](http://developer.android.com/reference/android/widget/GridView.html) and [ViewPager](http://developer.android.com/reference/android/support/v4/view/ViewPager.html) commonly include multiple bitmaps on-screen at once with many more potentially off-screen ready to show at the flick of a finger.  
  
(emphasis added)

Loading _just one_ photo taken on a Galaxy Nexus could conceivably blow through the app's entire heap! How do we protect against this?

In most cases, the best answer is to *not* reinvent the wheel - [Ion](https://github.com/koush/ion), [Universal Image Uploader](https://github.com/nostra13/Android-Universal-Image-Loader),  [Picasso](http://square.github.io/picasso/), and most image loading libraries allow images/bitmaps to be dynamically resized prior to being pulled into memory and inserted into a view. There's no need to try to load a 1920x1080px image (8MB), just to put it into a 20x20dp (3KB) thumbnail! These libraries are written by some very talented developers, and there's a good chance that someone out there has already solved the problem you're facing. Check if the image-loading lib you're using can load your bitmap from disk for you -- it saves you the headache of `OutOfMemory` errors without the hassle of having to code it yourself.

If you find yourself absolutely required to manipulate images _sans_ library, remember to 

1. always do the heavy lifting on a [background thread](http://developer.android.com/reference/android/os/AsyncTask.html)
2. [downsample like your app depends on it](http://developer.android.com/training/displaying-bitmaps/load-bitmap.html)

### Logs - Expensive and Insecure

Logs are an incredibly useful debugging tool -- you can see exactly what line fails, and even what the state of a variable was at that time. Logging, however, can take a toll on the system.

Something you may not have realized is that unless you specifically turn it off (with a manual DEBUG flag or using ProGuard), your app will continue to generate logs in production!

#### Logging can be expensive

Take the (slightly contrived) example:
```java
//returns a JsonObject (with children) of all the lists associated with a user
private String whyWouldYouDoThis(){
    JsonObject result = API.getReallyBigComplexJsonList(authToken, url).asJsonObject().commit();
    Log.d("OriginateTestClass", result.toString());
    return result;
}
```

This might seem like a completely benign code snippet. But if that result object is complex JSON tree (as the API call suggests), Android now has to traverse the entire JSON tree to stringify the object. Which is fine when you're debugging - but there's no need to log your JSON in production. 

Consider creating a LogUtility class that wraps the various Log levels (e.g., Log.d(), Log.e()) and checking a DEBUG flag. A great example is in the [Google I/O 2014 LogUtils](https://github.com/google/iosched/blob/b6cd1b2aec3c6777afac4d42e3567ca8774d3e7a/android/src/main/java/com/google/samples/apps/iosched/util/LogUtils.java) class - 

```java
public static void LOGD(final String tag, String message) {
    if(BuildConfig.DEBUG || Log.isLoggable(tag, Log.DEBUG)) {
        Log.d(tag, message);
    }
}
```
By checking if you're in Prod, you could conceivably save a ton of CPU cycles that could be better spent smoothly displaying your UI! :D

####Logs can be a security risk!

If you decide to ignore the previous section, at the very least **don't log any information that presents a security risk**. 

This includes

- passwords (obvious, but easy to forget)
- authTokens ([MITM](http://en.wikipedia.org/wiki/Man-in-the-middle_attack) potential)
- credit card info (don't laugh - a major travel app did this for a while)
- user's address, phone number, SSN, favorite ice cream flavor, etc.

Yet another reason to only log in Debug mode. 

### Fragments

The following section may be filed under the heading "Everything you should already be doing with fragments, but probably aren't because you're lazy."

####The private constructor

In order to facilitate passing information to a Fragment, you might be tempted to override the default private constructor:

```java
public class MyFragment extends Fragment{
    private String arg1;
    
    public MyFragment (String arg1){ //everything about this is bad!
        this.arg1 = arg1;
    }
}
```

This is a **bad idea** - Android needs `MyFragment` to have a plain vanilla constructor. That way, if the system needs to kill and restore your instance of `MyFragment`, it has a clear path to do so.   

Instead, set information in a Bundle using a static method in the Fragment:
```java
public class MyFragment extends Fragment{
    String arg1;
    private static final String key1 = "ARG_KEY_1";

    public static MyFragment newInstance(String arg1){
        Bundle b = new Bundle();
        b.putString(key1, arg1); //set using key1
        MyFragment fragment = new MyFragment(); //default constructor!
        fragment.setArguments(b);
        return fragment;
    }

    // get arguments from Bundle here using getArguments()
    public void onCreate (Bundle instance){
        arg1 = getArguments().getStringExtra(key1); //get using key1
    }
}
```
```java
//in Activity
public void onCreate(Bundle instance){
    MyFragment fragment = MyFragment.newInstance("Hello Android!");
    //add fragment to FragmentManager, etc.
}
```
The Android runtime will remember the information that you sent in the Bundle. In the case where your fragment is destroyed and recreated (e.g., the phone is rotated from portrait to landscape), the system will be able to provide the necessary initialization params to your fragment. 

Remember to access your Bundle in `Fragment.onCreate(...)` with `getArguments()`!

####Fragment/Activity Communication

Ideally, there should be little reason for a Fragment to call methods in the parent Activity. The Activity should merely handle lifecycle methods and the ActionBar, and leave all of the View logic to the Fragment. 

However, if you do decide to house some methods in the parent Activity and call them in the Fragment, **don't do this:**

```java
//inside MyActivity
public void doSomething(){}
```
```java
// inside MyFragment
public void fragmentMethod(){
    //need to call Activity!
    ((MyActivity) getActivity()).doSomething();
}
```
This is bad for a few reasons:

1. It limits `MyFragment` to only accepting `MyActivity` as a parent. If any other activity tries to use `MyFragment`, the app will crash. Hardly reusable. 
2. There is no clear indication to any potential parent Activities (nor any reader) that `MyFragment` calls a method in its parent. 

Instead, create an Interface, with the Fragment casting the Activity to the interface type, and the Activity implementing the interface. Like so:

```java
//inside MyActivity
public class MyActivity implements MyFragmentInterface {
    @Override
    public void doSomething(){}
}
```
```java
// inside MyFragment
public class MyFragments extends Fragment {
    private MyFragmentInterface interfaceToActivity;
    
    public interface MyFragmentInterface{
        public void doSomething();
    }

    @Override
    public void onAttach(Activity activity){
        if (activity instanceof MyFragmentInterface){
            interfaceToActivity = (MyFragmentInterface) activity; //cast activity to Interface class
        } else throw new ClassCastException(activity.getSimpleName().toString() + " doesn't implement MyFragmentInterface!");
    }
}
```
Then, when you need to call the parent Activity's method, you can just call:
```java
// inside MyFragment
public void fragmentMethod(){
    interfaceToActivity.doSomething();  //need to call Activity!
}
```

This way, _any _ Activity can use MyFragment - as long as it implements `MyFragmentInterface`! 

#### The Fragment Lifecycle and `OnSaveInstanceState`

Go read [this Android Design Patterns article](http://www.google.com/url?q=http%3A%2F%2Fwww.androiddesignpatterns.com%2F2013%2F04%2Fretaining-objects-across-config-changes.html&sa=D&sntz=1&usg=AFrqEzfYdusgFlKs7BVvEclj7_aoebj_aQ) about `OnSaveInstanceState`. 

### Layouts and `ListViews`

You will be inflating a lot of XML - make sure you do it efficiently. Ensure that you're [optimizing your layouts](http://developer.android.com/training/improving-layouts/optimizing-layout.html) by not nesting too deeply; and remember to [reuse layouts when possible](http://developer.android.com/training/improving-layouts/reusing-layouts.html) with `<include>` and `<merge>`. 

####Optimizing `ListViews`

If you aren't already using the ViewHolder pattern, you should start. It's incredibly easy and makes scrolling a lot faster, especially on phones that don't have quad-core 3.0GHz processors.

(the following excellent code samples are, weirdly, from [developer.samsung.com](http://developer.samsung.com/android/technical-docs/Android-UI-Tips-and-Tricks), who managed to have better documentation than Google...)

Take care when implementing [`BaseAdapter.getView(...)`](http://developer.android.com/reference/android/widget/Adapter.html#getView)....

```java
//naïve implementation of BaseAdapter#getView
@Override
public View getView(int position, View convertView, ViewGroup parent) {
    convertView = mInflater.inflate(R.layout.list_item, null);
    ((TextView) convertView.findViewById(R.id.text)).setText(DATA[position]);
    ((ImageView) convertView.findViewById(R.id.icon)).setImageBitmap(mIcon);
    .
    .
    return convertView;
}
```

In the naïve example, we are inflating the XML into `convertView` without regard for what already exists. This is unnecessary; `ListView` (and other container views, like `GridView`) is pretty smart about recycling the `View` to minimize superfluous XML inflation. We should be smart about it too!
```java
static class ViewHolder {
    TextView text;
    ImageView icon;
}

@Override
public View getView(int position, View convertView, ViewGroup parent) {
    ViewHolder holder;
    if (convertView == null) {
        //the recycled view is null, so inflate the XML
        convertView = mInflater.inflate(R.layout.list_item, null);
        holder = new ViewHolder();
        holder.text = (TextView) convertView.findViewById(R.id.text);
        holder.icon = (ImageView) convertView.findViewById(R.id.icon);
        convertView.setTag(holder);
    } else { //the View already exists, now we just need to set the right info
        holder = (ViewHolder) convertView.getTag();
    } 
    //set the info, since, in either case, the View has been created
    holder.text.setText(DATA[position]);
    holder.icon.setImageBitmap(mIcon);
    return convertView;
}
```
Here, we check if the convertView has been recycled or if it needs to be initialized. If it's a fresh copy, we can set it with all the proper information. Conversely, if it's been recycled, we obtain the ViewHolder (essentially, a carrier-class with pointers to the various child Views) and we carry on.

This is performant for two reason:

1. We avoid inflating XML on every call to `Adapter.getView()`. This is excellent because `getView` is called every time a particular row needs to be drawn OR redrawn! So we save lot of unnecessary inflation.
2. We avoid unnecessary calls to `view.findViewById(int)`, which unfortunately, is a recursive [BFS](http://en.wikipedia.org/wiki/Breadth-first_search). So if you have a deep layout (inadvisable for many reason), each `findViewById()` can be relatively expensive - and worse, slow!. 

_**Untested Alternative:**  _

Creating a custom `ViewGroup` that always keeps references to its children

[http://blog.xebia.com/2013/07/22/viewholder-considered-harmful/ ](http://blog.xebia.com/2013/07/22/viewholder-considered-harmful/)  

###Miscellaneous Tidbits and Android Gotchas

#### Bridge Methods

Be aware that the Android Runtime (ART or Dalvik) is occasionally affected by the code you write. 

For example...

```java
public class Foo {
    private String enclosingPrivateField = "sadness";

    private class FooInner{
        public String doSomething(){
            return enclosingPrivateField; //this could be a problem
        }
    }
}
```

Even thought this code compiles, the JVM considers `FooInner`'s access of `Foo.privateField` to be illegal, since `enclosingPrivateField` is marked _private_, and `FooInner` is technically a different class (`Foo$FooInner` != `Foo`). In this case, the JVM will have to generate a few [synthetic methods](http://www.javaworld.com/article/2073578/java-s-synthetic-methods.html) to bridge the gap.

[Android's Developer docs](http://developer.android.com/training/articles/perf-tips.html#PackageInner) has more specific information as to the potential performance costs, and the above link briefly discusses the possible security risks.

The **TL;DR solution** is to not mark `enclosingPrivateField` as `private`; package-level access will allow the JVM to proceed as expected. If package access is too broad for your specific use case, consider passing the private field as a parameter in a constructor or method to `FooInner`. 

#### Application Context vs. Activity Context

If you think there are only two kinds of Contexts, you should read [this article](http://www.doubleencore.com/2013/06/context/). 

If you know that there are more than two kinds of contexts, you should [read this article anyway](http://www.doubleencore.com/2013/06/context/). 

#### Custom Typefaces from file

Prior to Android ICS (4.0), repeatedly creating a custom Typeface from assets would [result in a memory leak](http://stackoverflow.com/questions/16901930/memory-leaks-with-custom-font-for-set-custom-font). 

In general, though, if you're using custom Typefaces and repeatedly shoving them into TextViews, it's a good idea to be caching them anyway - it's less work for the GC and the Android system.  

```java
public class TypefaceCache {
    private static final String TAG = "Typefaces";
    private static final Hashtable<String, Typeface> cache = new Hashtable<String, Typeface>();

    public static Typeface get(Context c, String assetPath) {
        synchronized (cache) {
            if (!cache.containsKey(assetPath)) {
                try {
                    Typeface t =  Typeface.createFromAsset(c.getApplicationContext().getAssets(), assetPath);
                    cache.put(assetPath, t);
                } catch (Exception e) {
                    Log.e(TAG, "Could not get typeface '" + assetPath + "' because " + e.getMessage());
                    return null;
                }
            } 
            return cache.get(assetPath);
        }
    }
}
```

Extra credit for converting the `Hashtable` to a `synchronized EnumMap`, with an `Enum` entry for every `Typeface` you intend to use. 
