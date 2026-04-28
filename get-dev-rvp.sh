#!/bin/bash
set -euo pipefail

API="https://api.revanced.app/v5/patches/prerelease"

# Get release info
release=$(curl -sL "$API")

# Extract version tag
latest_tag=$(echo "$release" | jq -r '.version')

[ -n "$latest_tag" ] || { echo "❌ No release found"; exit 1; }

# Version-only mode
if [[ "${1:-}" == "--version-only" ]]; then
  echo "ReVanced Patches dev version: $latest_tag" >&2
  echo "$latest_tag"
  exit 0
fi

echo "Found prerelease: $latest_tag" >&2

# Extract download URL
download_url=$(echo "$release" | jq -r '.download_url')

[ -n "$download_url" ] || { echo "❌ No .rvp found for $latest_tag"; exit 1; }

filename="patches-${latest_tag#v}.rvp"
curl -L "$download_url" -o "$filename"
echo "Downloaded: $filename"