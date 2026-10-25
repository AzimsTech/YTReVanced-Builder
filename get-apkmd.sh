#!/bin/bash
set -euo pipefail

# Uses AzimsTech's fork of the downloader (routes HTTP through curl to
# bypass the site's Cloudflare fingerprinting of Node/Bun fetch).
API="https://api.github.com/repos/AzimsTech/apkmirror-downloader/releases?per_page=1"

# Get latest tag
latest_tag=$(curl -s "$API" | jq -r '.[0].tag_name // empty')
[ -n "$latest_tag" ] || { echo "❌ No release found" >&2; exit 1; }

# Version-only flag
if [[ "${1:-}" == "--version-only" ]]; then
  echo "ReVanced APKMD version: ${latest_tag#v}" >&2 # log to console
  echo "${latest_tag#v}"
  exit 0
fi

# Find download URL
download_url=$(curl -s "$API" | jq -r \
  --arg tag "$latest_tag" '.[] | select(.tag_name==$tag).assets[] | select(.name=="apkmd").browser_download_url' | head -n1)

[ -n "$download_url" ] || { echo "❌ No apkmd asset for $latest_tag" >&2; exit 1; }

echo "Downloading: $download_url" >&2
curl -L "$download_url" -o apkmd
chmod +x apkmd
echo "✅ Saved apkmd" >&2

# Print version without "v"
echo "${latest_tag#v}"
