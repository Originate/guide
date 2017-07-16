# Android Continuous Integration

The following is a guide on how to integrate your Android app with [CircleCI](https://circleci.com/). Although not covered in this guide, [Travis CI](https://travis-ci.org) is an alternative continuous integration option that can be used with Android.

## CircleCI Project Setup

1. Login to [CircleCI](https://circleci.com/)
2. [Add a new project](https://circleci.com/add-projects)
3. Select Team
4. Browse to your git repo and select **Build Project**. If the project has already been setup, click **Watch Project** to add in to their CircleCI Dashboard (in place of **Build Project**)
5. Add a file called `circle.yml` to the root of your project. Below we will configure **CircleCI** by adding necessary elements to this file.

## CircleCI Configuration

Some initial configuration is required to get CircleCI working with your Android project. The majority of this configuration is handled via the [circle.yml file](../files/code/CI/circle.yml), however occasionally [bash scripts](../files/code/CI/scripts/environmentSetup.sh) are needed to help get the job done. [Here are CircleCI's official Android docs](https://circleci.com/docs/android), but note the guide below is built from Originate's collective experience and better tailored towards our typical needs.

By the end of this section, you'll be ready run an integration (build your project & run unit tests) on CircleCI.

### Machine

```yml
machine:
  environment:
    ANDROID_HOME: /usr/local/android-sdk-linux
```
The setting of the `ANDROID_HOME` environment variable is necessary for the Android SDKs to function properly. It'll also be useful for booting up the emulator in later steps.

### Dependencies

```yml
dependencies:
  override:
    - source scripts/environmentSetup.sh && getAndroidSDK
```
Due to limitations in gradle and yaml, bash scripting is needed to install the proper Android dependencies.

```bash
# scripts/environmentSetup.sh

function getAndroidSDK {
  export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

  DEPS="$ANDROID_HOME/installed-dependencies"

  if [ ! -e $DEPS ]; then
    echo y | android update sdk -u -a -t android-19 &&
    echo y | android update sdk -u -a -t platform-tools &&
    echo y | android update sdk -u -a -t build-tools-21.1.2 &&
    echo y | android update sdk -u -a -t extra-android-m2repository &&
    echo y | android update sdk -u -a -t extra-android-support &&
    echo y | android update sdk -u -a -t extra-google-m2repository &&
    echo no | android create avd -n testAVD -f -t android-19 --abi default/armeabi-v7a &&
    touch $DEPS
  fi
}
```
Notes:

* The `export PATH` line is to ensure we have access to all of the Android CLI tools we'll need later in the script.
* The `DEPS=...` is used in the `if/then` block to determine if CircleCI has already provided us with cached dependencies. If so, there's no to download anything!
* We update the needed tools, sdks and support libraries with `android update sdk ...`. It is recommended that you use API 19 (Android 4.4 Jelly Bean) as it's faster and works better on CircleCI than newer API levels. The first 3 sdk updates are necessary for all Android projects, while the following 3 are only needed if your project utilizes the Android Support Libraries. Note: Although the [CircleCI docs](https://circleci.com/docs/android#dependencies) state that many of these packages come preinstalled, we've found that manually installation is often needed to get certain libraries to function correctly.
* We create the AVD with the line `android create avd ...`, with a `target` of Android 19 and a name of `testAVD`. Unfortunately Intel x86 is not currently supported by CircleCI, so use of slower ARM-based emulator is necessary.

### Tests

```yml
test:
  pre:
    - $ANDROID_HOME/tools/emulator -avd testAVD -no-skin -no-audio -no-window:
        background: true
    - ./gradlew assembleDebug:
        timeout: 360
    - source scripts/environmentSetup.sh && waitForAVD
  override:
    - ./gradlew connectedAndroidTest --info:
        timeout: 360
```

Notes:

* The `$ANDROID_HOME/tools/emulator` starts a "headless" emulator - namely the one we just created. Running the emulator from the terminal is a blocking command. That's why we are setting the `background: true` attribute on the emulator command.
* The subsequent `./gradlew` command uses the [Gradle wrapper](http://www.gradle.org/docs/current/userguide/gradle_wrapper.html) to build the code and generate a debug apk.
* After building the apk, we cannot continue without the emulator being ready. So we use bash scripting to wait for it to start, as seen below.
* Once the emulator is up and running, we run `gradlew connectedAndroidTest`, which, as its name suggests, run the tests on the connected Android device. Note: If you're using Espresso, Appium or other test libraries, those commands would go here.

```bash
# scripts/environmentSetup.sh

function waitForAVD {
  local bootanim=""
  export PATH=$(dirname $(dirname $(which android)))/platform-tools:$PATH
  until [[ "$bootanim" =~ "stopped" ]]; do
    sleep 5
    bootanim=$(adb -e shell getprop init.svc.bootanim 2>&1)
    echo "emulator status=$bootanim"
  done
}
```
This script was originally adopted [from this script](http://blog.crowdint.com/2013/05/17/android-builds-on-travis-ci-with-maven.html).

### Build Artifacts

The following code snippets should be added to your circle file to ensure that apks and test results are saved as build artifacts, which allows them to be viewed after the build has completed.

```yml
general:
  artifacts:
    - "~/build_output.zip" # Save APK's, Lint Results, and Test Results

test:
  override:
    - zip -r ~/build_output.zip app/build/outputs/
```

## Conclusion

The above steps should be enough to get you up and running with CircleCI. As long as the `circle.yml` file is in the root of your project, running an integration on CircleCI will initiate automatically when you push to GitHub. Hopefully, if all goes well, you will be seeing green!

![circleCISuccessfulIntegration](../files/images/circleCISuccessfulIntegration.png

### Additional Resources

* The complete `circle.yml` & `scripts/environmentSetup.sh` built from this example can be found [here](../files/code/CI)
* [Originate Blog Post](http://blog.originate.com/blog/2015/03/22/android-and-ci-and-gradle-a-how-to/) on Android, CI and Gradle serves as inspiration for a large portion of this guide. Beware though as parts of the blog post, such as use of x86 emulators, are outdated and no longer applicable.
* [Official CircleCI Configuration Docs](https://circleci.com/docs/configuration)
* [Official CircleCI Android Docs](https://circleci.com/docs/android)

