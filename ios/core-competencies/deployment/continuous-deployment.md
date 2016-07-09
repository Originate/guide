# Setting up iOS Continuous Delivery with CircleCI and HockeyApp

**Prerequisites:** Project should be set up for [continuous integration with CircleCI](continuous-integration.md).

**Goals:** Branches that are marked for deployment will automatically be archived and packaged, uploaded to HockeyApp, and distributed to a pre-specified list of users.

This guide assumes that the builds will use an enterprise provisioning profile, though ad hoc builds should work as well.

[ProvisionQL](https://github.com/ealeksandrov/ProvisionQL) may be useful when obtaining the necessary code signing files.

## Gather code signing files

Ensure this folder structure exists for your project. The files listed here need to be gathered.
```
YourApp/
├── ...
└── scripts/
    └── CircleCI/
        ├── apple.cer
        ├── deploy_hockeyapp.sh
        ├── dist.cer
        ├── dist.p12
        ├── install_certificates_and_profiles.sh
        ├── profile
        │   └── <YOUR_APP_DISTRIBUTION_PROFILE>.mobileprovision
        └── remove_certificates_and_profiles.sh
```

1. **apple.cer**
  1. Open **OS X Keychain Access**
  2. Keychain: **login**
  3. Category: **Certificates**
  4. Name: **Apple Worldwide Developer Relations Certification Authority**
  5. Export as **apple.cer**
2. **.mobileprovision**
  * Obtain the distribution provisioning profile for your app
     * It can be downloaded directly from the [Apple Developer Center](https://developer.apple.com/membercenter/)
     * Or if it has already been setup in Xcode
        1. Xcode Preferences > Accounts
        2. Select your team
        3. View Details...
        4. Find the provisioning profile of interest > right click > Show in Finder
3. **dist.cer**
  1. Open **OS X Keychain Access**
  2. Find the certificate used to sign the provisioning profile (ProvisionQL is helpful here).
    * This may need to be downloaded from the [Apple Developer Center](https://developer.apple.com/membercenter/) if not already present on your machine.
  3. Export as **dist.cer**
4. **dist.p12**
  1. Same as **dist.cer**, but export as **dist.p12**
  2. Provide a secure password for the file. This will be referenced later as `$KEY_PASSWORD`. This will be known and guarded by CircleCI.
5. [**deploy_hockeyapp.sh**](../../files/deploy_hockeyapp.sh) — uploads app binary to HockeyApp
6. [**install_certificates_and_profiles.sh**](../../files/install_certificates_and_profiles.sh) — installs code signing files on CircleCI
7. [**remove_certificates_and_profiles.sh**](../../files/remove_certificates_and_profiles.sh) — clean up code signing


## Xcode setup

Ensure that the Xcode Build Settings for **Release** are configured to use the **iOS distribution certificate** and **distribution provisioning profile** that you exported above.


## HockeyApp configuration

**Prerequisites:**

* an app has already been created on HockeyApp (an admin might be required for this)
* an [active API token](https://rink.hockeyapp.net/manage/auth_tokens) exists for the app
* a [team](https://rink.hockeyapp.net/manage/teams) has been created for the app
* users that are part of the internal development team should be tagged with `$HOCKEYAPP_PRIVATE_RELEASE_TAGS`
  * they will receive frequent build notifications (each deployment)
* users that are part of the external development team should be tagged with `$HOCKEYAPP_PUBLIC_RELEASE_TAGS`
  * they will receive semi-frequent build notifications (typically end of sprints, when `$HOCKEYAPP_PUBLIC_RELEASE_BRANCH` is updated)


## CircleCI configuration

**Project Settings** > **Tweaks** > **Environment variables**

1. `HOCKEYAPP_APP_IDENTIFIER`
   * **App ID** from HockeyApp
2. `HOCKEYAPP_EXPORT_IPA_PATH`
   * use this string literally: `/Users/$USER/$CIRCLE_PROJECT_REPONAME.ipa`
3. `HOCKEYAPP_PRIVATE_RELEASE_TAGS`
   * comma-separated list of HockeyApp tags - users with these tags will be notified for "private" (internal to Originate) builds. E.g. `originate`
4. `HOCKEYAPP_PUBLIC_RELEASE_BRANCH`
   * the branch from which to deploy publicly (typically `master`)
5. `HOCKEYAPP_PUBLIC_RELEASE_TAGS`
   * comma-separated list of HockeyApp tags - users with these tags will be notified for "public" (for partners) builds. E.g. `acme`
6. `HOCKEYAPP_TEAM_ID`
   * **Team ID** for the app's team
7. `HOCKEYAPP_TOKEN`
   * [**API token**](https://rink.hockeyapp.net/manage/auth_tokens) for the app
8. `KEY_PASSWORD`
   * password for the exported **dist.p12** file

### circle.yml

The `deployment` key within the circle.yml file configures app deployment. The `branch` subkey specifies which branches should be deployed. All other branches are built and tested by CircleCI, but won't be pushed out to HockeyApp.

```ruby
...

deployment:
  hockey:
    branch: [dev, master]
    commands:
      - ./scripts/CircleCI/install_certificates_and_profiles.sh
      - xcodebuild archive -workspace YourApp.xcworkspace -scheme YourApp -archivePath YourApp.xcarchive
      - xcodebuild -exportArchive -archivePath YourApp.xcarchive -exportPath ./ -exportFormat ipa -exportProvisioningProfile "YourApp Enterprise Distribution"
      - ./scripts/CircleCI/remove_certificates_and_profiles.sh
      - ./scripts/CircleCI/deploy_hockeyapp.sh

...
```
