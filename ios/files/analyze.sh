#!/usr/bin/env bash

# This script is necessary because `xcodebuild` doesn't fail when reporting static analyzer warnings,
# which defeats its purpose. Someday when Apple fixes this, this script will be unnecessary and the
# `analyze` build action can simply be added to the same `xcodebuild` invocation that runs unit tests.
#
# Filed rdar://21518310, which is a duplicate of rdar://19200339
#
# - allen.wu@originate.com / 6/30/2015

patternsForFailure="following commands produced analyzer issues
ANALYZE FAILED"

! ({ xcodebuild -workspace <YOUR_APP>.xcworkspace \
                -scheme <YOUR_APP> \
                clean \
                analyze CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO | xcpretty --color; } 2>&1 | tee /dev/tty | fgrep -q "${patternsForFailure}")
