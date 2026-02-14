#!/bin/bash
set -euo pipefail

API="https://api.github.com/repos/MorpheApp/morphe-patches/releases?per_page=10"

# Get releases (no retry, just fail if broken)
releases=$(curl -s "$API" | jq '.')

# Latest release by publish date (stable + prerelease)
latest_tag=$(echo "$releases" \
  | jq -r 'sort_by(.published_at) | last | .tag_name')


[ -n "$latest_tag" ] || { echo "❌ No release found"; exit 1; }

# Version-only mode
if [[ "${1:-}" == "--version-only" ]]; then
  echo "ReVanced Patches dev version: $latest_tag" >&2 # log to console
  echo "$latest_tag"
  exit 0
fi

echo "Found prerelease: $latest_tag" >&2

# Download the .mpp file
download_url=$(echo "$releases" \
  | jq -r --arg tag "$latest_tag" '
    .[] | select(.tag_name == $tag) | .assets[]
    | select(.name | test("^patches-.*\\.mpp$"))
    | .browser_download_url' | head -n1)

[ -n "$download_url" ] || { echo "❌ No .mpp found for $latest_tag"; exit 1; }

curl -L "$download_url" -o "${download_url##*/}"
echo "Downloaded: ${download_url##*/}"
