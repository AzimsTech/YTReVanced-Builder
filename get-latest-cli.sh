#!/bin/bash
set -euo pipefail

GH_API="https://api.github.com/repos/MorpheApp/morphe-desktop/releases"

# Sort by published_at descending to guarantee newest release (including prereleases)
jar_url=$(curl -sL "$GH_API" | jq -r '
  sort_by(.published_at) | reverse
  | .[0].assets[]
  | select(.name | test("^(morphe-cli|morphe-desktop)-.*-all\\.jar$"))
  | .browser_download_url' | head -n1)

[ -n "$jar_url" ] || { echo "❌ No morphe cli/desktop jar found" >&2; exit 1; }

filename="${jar_url##*/}"
version=$(echo "$filename" | sed -E 's/^(morphe-cli|morphe-desktop)-(.+)-all\.jar$/\2/')

# Version-only mode
if [[ "${1:-}" == "--version-only" ]]; then
  echo "Morphe CLI latest version: $version" >&2
  echo "$version"
  exit 0
fi

echo "Downloading: $jar_url" >&2
curl -L "$jar_url" -o "$filename"
echo "✅ Saved as $filename" >&2
echo "$version"