# Android Continuous Deployment

Now that you have your Android app setup to use CircleCI for integrations, it is time to modify it to add automatic deployment. CircleCI provides support for numerous methods of [deployment](https://circleci.com/docs/configuration#deployment). Below we'll focus on deploying to [HockeyApp](http://hockeyapp.net) for beta testing. The Google Play Developer Console also offers support for [alpha and beta testing](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en), however we prefer to use HockeyApp since it offers cross platform support for both our Android and iOS apps.

## HockeyApp Team Setup

In order to upload our build to HockeyApp, we need to generate an **access token** and create an **App ID**.
We need to perform these steps inside the **app owner's account**.

1. Upload an apk for your app to HockeyApp (make sure that it works, manually)
2. Add your app to a team. 
   1. Go to **Teams Page**
   2. Select your desired team or create a new one.
   3. Select **Apps** from left-hand menu
   4. Select App from dropdown and press **Add to Team** button
3. Go to **Account Settings > Manage Account**
4. Click on **API Tokens** on the left-hand menu
5. Check under **Active API Tokens** --- if there isn't an existing token for your app, add one and note the value.
6. Also note the **App ID**, shown at the top of the **App Detail Page**, to be saved as an environment variable on circle.

## CircleCI Environment Variables

Go to **Project Settings > Environment Variables (under Tweaks)** on CircleCI and set up the following environment variables :

* `HOCKEYAPP_TOKEN`: 
  * The access token, described above in **Getting started with HockeyApp**.
* `HOCKEYAPP_EXPORT_APK_PATH`: 
  * May vary slightly from project to project, but a common example is ***app/build/outputs/apk/app-debug.apk***.
* `HOCKEYAPP_TAGS`: 
  * Any tags that you'd like to be associated with your app version. We use *ocloud-android* in our example.
* `HOCKEYAPP_TEAM_ID`: 
  * The identifier for the app's **HockeyApp Team** can be found by checking the url when you click on the **Organization Profile** in the team owner's account. For example : https://rink.HockeyApp.net/manage/teams/**12345**/team_users
* `HOCKEYAPP_APP_IDENTIFIER`: 
  * You can find the App ID inside HockeyApp, in the main dashboard for your app, seen here:
  ![HockeyAppAppId](/android/files/images/hockeyAppAppId.png)

## HockeyApp Deploy Script

[scripts/deployHockeyApp.sh:](/android/files/code/CD/scripts/deployHockeyApp.sh)

```bash
function uploadToHockeyApp {

  GIT_COMPARE_KEY=${CIRCLE_COMPARE_URL##*/}
  GIT_PRETTY_COMMIT_LOG=$(echo "<ul>$(git log ${GIT_COMPARE_KEY} --pretty=format:'<li>[%ad] %s (%an)</li>' --date=short)</ul>" | tr -d '\n')

  HOCKEYAPP_NOTES_HEADER="**Built on:** $(date +"%a %d-%b-%Y %I:%M %p")
  **Branch:** $(git rev-parse --abbrev-ref HEAD)
  **Commit:** $(git rev-parse --short HEAD)"

  HOCKEYAPP_NOTES_HEADER_HTML=${HOCKEYAPP_NOTES_HEADER//$'\n'/<br>}
  HOCKEYAPP_NOTES="${HOCKEYAPP_NOTES_HEADER_HTML} ${GIT_PRETTY_COMMIT_LOG}"

  curl --verbose \
       --fail \
       --form "status=2" \
       --form "notify=1" \
       --form "notes=${HOCKEYAPP_NOTES}" \
       --form "platform=Android" \
       --form "notes_type=0" \
       --form "ipa=@${HOCKEYAPP_EXPORT_APK_PATH}" \
       --form "tags=${HOCKEYAPP_TAGS}" \
       --form "teams=${HOCKEYAPP_TEAM_ID}" \
       --form "release_type=2" \
       --header "X-HockeyAppToken: ${HOCKEYAPP_TOKEN}" \
       "https://upload.hockeyapp.net/api/2/apps/${HOCKEYAPP_APP_IDENTIFIER}/app_versions/upload"
}
```

The above curl command uses the CircleCI environment variables that we previously set to upload a new apk to HockeyApp with the Git commit history as the version notes. To get CircleCI to run the script, we need to add the below segment to the bottom of our circle file.

```yml
deployment:
  hockey:
    branch: master
    commands:
      - source scripts/deployHockeyApp.sh && uploadToHockeyApp
```

In the example above, our app lives on the `master` branch. The name of your app's main branch should go here. That way deploys are only made when code is committed to the main branch.

## Conclusion

The above steps should be enough to get your app deploying to HockeyApp. Hopefully, if all goes well, you will be getting emails from HockeyApp about your successful app version deployment.

![hockeyAppSuccessfulDeployment](/android/files/images/hockeyAppSuccessfulDeployment.png)


### Additional Resources

* The complete `circle.yml` & `scripts/deployHockeyApp.sh` built from this example can be found [here](/android/files/code/CD).
* [Official CircleCI Deployment Docs](https://circleci.com/docs/configuration#deployment)
* [Official HockeyApp API Docs](http://support.hockeyapp.net/kb/api)
