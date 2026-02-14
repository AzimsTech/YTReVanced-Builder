#!/bin/bash
set -euo pipefail

# Get the latest YT version from Morphe patches
latest=$(java -jar morphe-cli-*-all.jar list-patches --with-packages --with-versions --with-options patches-*-dev.*.mpp | \
awk '
/Package name: com\.google\.android\.youtube$/ { in_yt_block=1 }
/^Index: [0-9]+$/ { in_yt_block=0 }
in_yt_block && /^[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+$/ { 
  gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
  versions[$0] = 1 
}
END {
  for (v in versions) print v
}' | sort -V | tail -n1)

[ -n "$latest" ] || { echo "❌ No YT version found"; exit 1; }

# Version-only mode
if [[ "${1:-}" == "--version-only" ]]; then
  echo "YouTube version: $latest" >&2  # log to console
  echo "$latest"
  exit 0
fi

echo "Found YT version: $latest" >&2
echo "$latest"