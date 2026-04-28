#!/bin/bash
set -euo pipefail

# Requires GITHUB_REPOSITORY and KEYSTORE_NAME as arguments or env vars
REPO="${1:-${GITHUB_REPOSITORY:-}}"
KEYSTORE="${2:-${KEYSTORE_NAME:-yt-patched.keystore}}"

[ -z "$REPO" ] && { echo "❌ GITHUB_REPOSITORY not set" >&2; exit 1; }

API="https://api.github.com/repos/${REPO}/releases"

# Get latest revanced-tagged release (exclude morphe and other branches)
latest_tag=$(curl -s "$API" | jq -r '[.[] | select(.tag_name | endswith("-revanced"))] | .[0].tag_name // empty')

if [ -z "$latest_tag" ]; then
    echo "No revanced release found" >&2
    exit 1
fi

echo "Found release: $latest_tag" >&2

# Find keystore download URL from that release
keystore_url=$(curl -s "$API" | jq -r \
  --arg tag "$latest_tag" \
  '.[] | select(.tag_name==$tag) | .assets[] | select(.name | endswith(".keystore")) | .browser_download_url' \
  | head -n1)

if [ -n "$keystore_url" ]; then
    echo "Downloading keystore from: $keystore_url" >&2
    curl -sL "$keystore_url" -o "$KEYSTORE"
    echo "✅ Keystore downloaded: $KEYSTORE" >&2
else
    echo "❌ No keystore found in release" >&2
    exit 1
fi