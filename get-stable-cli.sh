#!/bin/bash
set -euo pipefail

API="https://api.github.com/repos/MorpheApp/morphe-cli/releases/latest"

release=$(curl -s "$API")
latest_tag=$(echo "$release" | jq -r '.tag_name')

[ -n "$latest_tag" ] && [ "$latest_tag" != "null" ] || { echo "❌ No stable release found"; exit 1; }

if [[ "${1:-}" == "--version-only" ]]; then
  echo "ReVanced Patches dev version: $latest_tag" >&2
  echo "$latest_tag"
  exit 0
fi

echo "Found stable release: $latest_tag" >&2

download_url=$(echo "$release" \
  | jq -r '.assets[]
    | select(.name | test("^morphe-cli-.*-all\\.jar$"))
    | .browser_download_url' | head -n1)

[ -n "$download_url" ] || { echo "❌ No .jar found for $latest_tag"; exit 1; }

curl -L "$download_url" -o "${download_url##*/}"
echo "Downloaded: ${download_url##*/}"