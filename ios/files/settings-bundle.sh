# App settings
#
# For AppStore builds, the standard iOS settings page for the app will only show the version number
# For all other builds, the server toggle switch and server URL override options are additionally shown

APP_VERSION="`/usr/libexec/PlistBuddy -c \"Print :CFBundleShortVersionString\" \"$CODESIGNING_FOLDER_PATH/Info.plist\"`"
SETTINGS_BUNDLE_PATH="$CODESIGNING_FOLDER_PATH/Settings.bundle/Root.plist"
GIT_HASH="$(git rev-parse --short HEAD)"
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"


if [ "AppStore" = "${CONFIGURATION}" ]; then
  /usr/libexec/PlistBuddy -c "Delete :PreferenceSpecifiers" "${SETTINGS_BUNDLE_PATH}"

  /usr/libexec/PlistBuddy -c "Add :StringsTable string 'Root'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers array" "${SETTINGS_BUNDLE_PATH}"

  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0 dict" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0:Type string 'PSGroupSpecifier'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:0:Title string 'Version Information'" "${SETTINGS_BUNDLE_PATH}"

  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Type string 'PSTitleValueSpecifier'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Title string 'Release'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:Key string 'settings_app_version'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:1:DefaultValue string '${APP_VERSION}'" "${SETTINGS_BUNDLE_PATH}"

  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Type string 'PSTitleValueSpecifier'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Title string 'Build'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:Key string 'settings_git_hash'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Add :PreferenceSpecifiers:2:DefaultValue string '${GIT_HASH}'" "${SETTINGS_BUNDLE_PATH}"
else
  /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:1:DefaultValue '${APP_VERSION}'" "${SETTINGS_BUNDLE_PATH}"
  /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:2:DefaultValue '${GIT_HASH}'" "${SETTINGS_BUNDLE_PATH}"

  # update bundle version
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${TIMESTAMP}.${GIT_HASH}.${GIT_BRANCH}" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${TIMESTAMP}.${GIT_HASH}.${GIT_BRANCH}" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}.dSYM/Contents/Info.plist"
fi
