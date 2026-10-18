#!/bin/bash
set -euo pipefail

VARIANT="${VARIANT:-revanced}"
. "$(dirname "$0")/variants/${VARIANT}.env"

GH_API="https://api.github.com/repos/${CLI_REPO}/releases"

# Sort by published_at descending to guarantee newest release (including prereleases)
jar_url=$(curl -sL "$GH_API" | jq -r --arg re "$CLI_JAR_REGEX" '
  sort_by(.published_at) | reverse
  | .[0].assets[]
  | select(.name | test($re))
  | .browser_download_url' | head -n1)

[ -n "$jar_url" ] || { echo "❌ No CLI jar found (variant: $VARIANT)" >&2; exit 1; }

filename="${jar_url##*/}"
version=$(echo "$filename" | sed -E "$CLI_VERSION_SED")

# Version-only mode
if [[ "${1:-}" == "--version-only" ]]; then
  echo "$BRAND CLI latest version: $version" >&2
  echo "$version"
  exit 0
fi

echo "Downloading: $jar_url" >&2
curl -L "$jar_url" -o "$filename"
echo "✅ Saved as $filename" >&2
echo "$version"
