#!/bin/bash
set -euo pipefail

API="https://api.github.com/repos/MorpheApp/morphe-cli/releases?per_page=10"

# Get releases (no retry, just fail if broken)
releases=$(curl -s "$API" | jq '.')

# Latest stable release by publish date
latest_tag=$(echo "$releases" \
  | jq -r '
      map(select(.prerelease == false and .draft == false))
      | sort_by(.published_at)
      | last
      | .tag_name
    ')


[ -n "$latest_tag" ] || { echo "❌ No release found"; exit 1; }

# Version-only mode
if [[ "${1:-}" == "--version-only" ]]; then
  echo "ReVanced Patches dev version: $latest_tag" >&2 # log to console
  echo "$latest_tag"
  exit 0
fi

echo "Found stable release: $latest_tag" >&2

# Download the .jar file
download_url=$(echo "$releases" \
  | jq -r --arg tag "$latest_tag" '
    .[] | select(.tag_name == $tag) | .assets[]
    | select(.name | test("^morphe-cli-.*-all\\.jar$"))
    | .browser_download_url' | head -n1)

[ -n "$download_url" ] || { echo "❌ No .jar found for $latest_tag"; exit 1; }

curl -L "$download_url" -o "${download_url##*/}"
echo "Downloaded: ${download_url##*/}"
