#!/bin/bash
set -euo pipefail

latest=$(java -jar morphe-*-all.jar list-patches \
  --with-packages --with-versions --patches patches-*.mpp \
  --filter-package-name=com.google.android.youtube \
  --include-experimental \
  | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+\s*$' \
  | tr -d ' \t' \
  | sort -uV \
  | tail -n1)

[ -n "$latest" ] || { echo "❌ No YT version found" >&2; exit 1; }

echo "Found YT version: $latest" >&2
echo "$latest"
