#!/usr/bin/env bash

#==========================================================================================
# Originate iOS CircleCI Continuous Deployment
# deploy_hockeyapp.sh
#
# This script uploads an exported .ipa file for RedditFeed app to Hockeyapp using
#    HockeyAppToken : $HOCKEYAPP_TOKEN
#    Team ID        : $HOCKEYAPP_TEAM_ID
#    Notes          : $HOCKEYAPP_VERSION_NOTES
#    ipa            : $HOCKEYAPP_EXPORT_IPA_PATH
#    App            : $HOCKEYAPP_APP_IDENTIFIER
#    tags           : $HOCKEYAPP_TAGS
#
#
#==========================================================================================

###########################################################################################
# upload to App $HOCKEYAPP_APP_IDENTIFIER
#
# Using HockeyApp API: Apps http://support.hockeyapp.net/kb/api/api-apps
#
# status=2        # make version available for download
# notify=1        # notify all testers that can install this app
# notes_type=0    # for Textile
# ipa             # .ipa export path set in the circle.yml
# tags            # app tag
# teams           # team number
# release_type=2  # for alpha, change to 3 for enterprise
# X-HockeyAppToken: token of app owner

GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
GIT_COMPARE_KEY=${CIRCLE_COMPARE_URL##*/}
GIT_PRETTY_COMMIT_LOG=$(echo "<ul>$(git log ${GIT_COMPARE_KEY} --pretty=format:'<li>[%ad] %s (%an)</li>' --date=short)</ul>" | tr -d '\n')

HOCKEYAPP_NOTES_HEADER="**Built on:** $(date +"%a %d-%b-%Y %I:%M %p")
**Branch:** ${GIT_BRANCH_NAME}
**Commit:** $(git rev-parse --short HEAD)"

HOCKEYAPP_NOTES_HEADER_HTML=${HOCKEYAPP_NOTES_HEADER//$'\n'/<br>}
HOCKEYAPP_NOTES="${HOCKEYAPP_NOTES_HEADER_HTML} ${GIT_PRETTY_COMMIT_LOG}"

echo "HockeyApp notes:\n${HOCKEYAPP_NOTES}\n"


CURL_NOTIFY="1"
CURL_TAGS="${HOCKEYAPP_PRIVATE_RELEASE_TAGS}"

# settings for public releases (i.e. for partners)
if [[ "${GIT_BRANCH_NAME}" = "${HOCKEYAPP_PUBLIC_RELEASE_BRANCH}" ]]; then
  CURL_NOTIFY="0"
  CURL_TAGS="${HOCKEYAPP_PUBLIC_RELEASE_TAGS}"
fi

curl --verbose \
     --fail \
     --form "status=2" \
     --form "notify=${CURL_NOTIFY}" \
     --form "notes=${HOCKEYAPP_NOTES}" \
     --form "notes_type=1" \
     --form "ipa=@${HOCKEYAPP_EXPORT_IPA_PATH}" \
     --form "tags=${CURL_TAGS}" \
     --form "release_type=2" \
     --header "X-HockeyAppToken: ${HOCKEYAPP_TOKEN}" \
     "https://upload.hockeyapp.net/api/2/apps/${HOCKEYAPP_APP_IDENTIFIER}/app_versions/upload"
