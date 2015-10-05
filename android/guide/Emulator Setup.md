# Android Emulators for Non-Developers

Using and managing Android Virtual Devices (AVDs) without Android Studio can be a pain. This document aims to fix that problem by providing easy to follow instructions for non-developers to setup an Android emulator for testing.

## Emulator Setup

1. [Under SDK Tools Only](http://developer.android.com/sdk/index.html#Other), download your OS's appropriate Android SDK zip file.
2. Once downloaded, unzip and move the resulting file structure to a directory of your choosing. For the purposes of this example, I put it in `~/Library`.
3. Open up a terminal window and `cd` into your SDK directory. 
	
	`cd ~/Library/android-sdk-macosx` 
4. Open up the SDK manager.

	`tools/android`
5. Inside the SDK manager there will be a lot of items preselected that you won't need unless you plan on doing Android development, so deselect all of the preselected items. Select and install **Intel x86 Atom System Image** under the header Android 4.4.2 (API 19) & **Intel x86 Emulator Accelerator (HAXM installer)** under the header Extras. API 19 isn't the latest version of Android, however it's emulator seems a lot more stable than the ones that come with API 20 and above.
6. Once the SDK manager has finished installing the system image and all of its dependencies, close the SDK manager and install the dmg or exe found under `android-sdk-macosx/extras/intel/Hardware_Accelerated_Execution_Manager`.
7. Once finished, open up the virtual device manager.

	`tools/android avd`
8. Inside the device manager, create a new device with a name of your choosing (no spaces allowed) and the following settings:
	1. Device: Nexus 5
	2. Target: Android 4.4.2 - API Level 19
	3. CPU/ABI: Intel Atom (x86)
	4. Skin: No Skin
	5. Emulator Options: Use Host GPU (This will make the notoriously slow Android emulators slightly less slow)

Note: If your computer does not support [Intel's hardware acceleration](https://software.intel.com/en-us/android/articles/intel-hardware-accelerated-execution-manager), install API 19's ARM EABI v7a System Image instead and skip step 6 of the above instructions.

## Emulator Usage

Now that you have an emulator setup, you can launch it at any time via the device manager (which can be accessed via steps 3 & 6 in the setup list above). 

Once the emulator has fully booted to the Android home screen, you can install an app on the emulator by giving `adb install` the path to your apk.

`platform-tools/adb install ~/Downloads/app-release.apk`

If all went well, you should now find the newly installed app in the app drawer of your Android emulator. Your newly installed app can be uninstalled at anytime via either your phone settings or with the application's package name through adb. Uninstalling via adb can prove useful if you run into any installation errors.

`platform-tools/adb uninstall com.originate.feedapp`