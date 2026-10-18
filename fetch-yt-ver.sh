#!/bin/bash
set -euo pipefail

VARIANT="${VARIANT:-revanced}"
. "$(dirname "$0")/variants/${VARIANT}.env"

latest=$(java -jar $CLI_JAR list-patches $LIST_FLAGS \
  --filter-package-name=com.google.android.youtube $LIST_EXTRA \
  | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+\s*$' \
  | tr -d ' \t' \
  | sort -uV \
  | tail -n1)

[ -n "$latest" ] || { echo "❌ No YT version found" >&2; exit 1; }

echo "Found YT version: $latest" >&2
echo "$latest"
