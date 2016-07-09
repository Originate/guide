#!/usr/bin/env bash

#
# OCLint script for Xcode
# (based off of: https://gist.github.com/gavrix/5054182)
#
# This script will:
#   1. ensure that oclint exists (assumed to be installed via homebrew-cask)
#   2. use xcodebuild --> oclint-xcodebuild to generate the compile_commands.json
#      that oclint requires for understanding the project hierarchy
#   3. run oclint
#
# By default, some of the oclint rules have been disabled and some directories
# excluded from analysis. These may need to be modified on a per-project basis.
#
# As of 2015/4/22, the way oclint is being used here by Xcode (via oclint-json-compilation-database)
# doesn't have a way to import an .oclint configuration file.
#

export PATH="/usr/local/bin:$PATH"

if ! hash oclint 2>/dev/null; then
  echo "oclint not found, analyzing stopped"
  exit 1
fi

echo "[OCLint] Preparing..."

cd "${SRCROOT}"
echo "[OCLint] Cleaning Xcode project..."
xcodebuild clean

echo "[OCLint] Creating xcodebuild.log..."
xcodebuild | tee "${TARGET_TEMP_DIR}/xcodebuild.log"

cd "${TARGET_TEMP_DIR}"
echo "[OCLint] Creating compile_commands.json for OCLint consumption..."
oclint-xcodebuild


echo "[OCLint] Linting..."
oclint-json-compilation-database -exclude Pods \
                                 -exclude Third-Party \
  -- \
  -p "${TARGET_TEMP_DIR}"             \
  -disable-rule=LongLine              \
  -disable-rule=LongVariableName      \
  -disable-rule=LongMethod            \
  -disable-rule=UnusedMethodParameter \
  | sed -E 's/(.*\.(c|m{1,2}):[0-9]*:[0-9]*:)/\1 warning:/'
