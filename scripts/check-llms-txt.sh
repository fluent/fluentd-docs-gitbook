#!/bin/bash

#
# Check that every page llms.txt links to exists in the build.
#

set -eu

BOOK="$(cd "$(dirname "$0")/.." && pwd)/_book"

if [ ! -f "$BOOK/llms.txt" ]; then
    echo "$BOOK/llms.txt is missing" >&2
    exit 1
fi

missing="$(sed -n 's|.*](https://docs\.fluentd\.org/\([^)]*\)).*|\1|p' "$BOOK/llms.txt" \
    | while read -r path; do
          [ -f "$BOOK/$path" ] || echo "  $path"
      done)"

if [ -n "$missing" ]; then
    echo "llms.txt links to pages that are not in the build:" >&2
    echo "$missing" >&2
    exit 1
fi
