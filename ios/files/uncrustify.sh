#!/usr/bin/env bash

#
# uncrustify script for Xcode
#
# clang-format will use the .uncrustify.cfg settings defined at
# the project root. All rules customization should be done there
#
# Third-party code shouldn't be formatted, so make sure to define
# the correct set of files for uncrustify to format (-F flag)
#

export PATH="/usr/local/bin:$PATH"

if ! hash uncrustify 2>/dev/null; then
  echo "uncrustify not found, skipping code formatting"
  exit 1
fi

cd "${SRCROOT}"
echo "[uncrustify] Formatting code..."
uncrustify -l OC -c "${SRCROOT}/.uncrustify.cfg" --no-backup -F <(find . -name "*.[hm]")
