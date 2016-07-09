#!/usr/bin/env bash

#
# clang-format script for Xcode
#
# clang-format will use the .clang-format settings defined at
# the project root. All rules customization should be done there
#
# Third-party code shouldn't be formatted, so make sure to define
# the correct set of files for clang-format to process (the -i flag)
#

export PATH="/usr/local/bin:$PATH"

if ! hash clang-format 2>/dev/null; then
  echo "clang-format not found, skipping code formatting"
  exit 1
fi

cd "${SRCROOT}"
echo "[clang-format] Formatting code..."
clang-format -style=file -i *.[hm]
