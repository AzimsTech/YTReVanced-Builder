#!/bin/bash
set -euo pipefail

# Resolve the *variant* page URL (as opposed to the release page URL) for a
# given YouTube version.
#
# The "-N-" inside a variant slug (…-youtube-21-43-523-3-android-apk-download)
# is assigned by the source site per upload and cannot be derived from the
# version, so the release page's variants table is scraped and the row matching
# what apkmd actually downloads is selected (arch + nodpi + APK type, mirroring
# apkmd's getFilteredVariant() with its DEFAULT_APP_OPTIONS).
#
# Prints the URL on stdout; logs go to stderr. Never fails the caller: if the
# page is Cloudflare-challenged, python3 is missing, or no row matches, it
# falls back to the release page, whose slug is derived from the version
# (same construction as apkmd's makeVariantsUrl()).
#
# Usage: get-apk-url.sh 21.43.523
# Env:   ARCH          arch apkmd was asked for   (default: universal)
#        FALLBACK_ARCH apkmd's fallbackArch       (default: arm64-v8a)

VERSION="${1:-}"
[ -n "$VERSION" ] || { echo "❌ Usage: $0 <version>" >&2; exit 1; }

# Dots -> dashes, e.g. 21.43.523 -> youtube-21-43-523-release
version_dash="${VERSION//./-}"
release_url="https://www.apkmirror.com/apk/google-inc/youtube/youtube-${version_dash}-release/"

url=$(python3 - "$release_url" "${ARCH:-universal}" "${FALLBACK_ARCH:-arm64-v8a}" <<'PY'
import re
import sys
from html.parser import HTMLParser

RELEASE_URL, ARCH, FALLBACK_ARCH = sys.argv[1], sys.argv[2], sys.argv[3]
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36")
CHALLENGE = ("Enable JavaScript and cookies to continue",
             "Just a moment...", "<title>Just a moment")


def fail(msg):
    print(f"⚠️ {msg}; falling back to the release page", file=sys.stderr)
    print(RELEASE_URL)
    sys.exit(0)


def fetch(url):
    """Return (html, final_url) following redirects (apkmd does the same)."""
    try:
        from curl_cffi import requests
    except ImportError:
        import urllib.request
        req = urllib.request.Request(
            url, headers={"User-Agent": UA, "Accept-Language": "en-US,en;q=0.9"})
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.read().decode("utf-8", "replace"), resp.geturl()

    resp = requests.get(url, impersonate="chrome", timeout=30,
                        headers={"Accept-Language": "en-US,en;q=0.9"})
    if resp.status_code != 200:
        raise RuntimeError(f"HTTP {resp.status_code}")
    return resp.text, str(resp.url)


def norm(text):
    return " ".join("".join(text).split())


class VariantsTable(HTMLParser):
    """Extracts .variants-table rows as {href, cells:[variant, arch, min, dpi]}.

    Regex slicing of this table is unreliable (rows contain nested markup and
    the table itself is truncated by non-greedy matches), so walk the tags.
    """

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.in_table = False
        self.depth = 0
        self.row = None
        self.cell = None
        self.rows = []

    @staticmethod
    def _classes(attrs):
        return dict(attrs).get("class", "").split()

    def handle_starttag(self, tag, attrs):
        if tag == "div":
            if not self.in_table:
                if "variants-table" in self._classes(attrs):
                    self.in_table = True
                    self.depth = 1
                return
            self.depth += 1
            if self.row is None:
                if "table-row" in self._classes(attrs):
                    self.row = {"href": None, "cells": [], "depth": self.depth}
                return
            if self.cell is None and "table-cell" in self._classes(attrs):
                self.cell = {"text": [], "depth": self.depth}
                return
        elif tag == "a" and self.cell is not None and self.row["href"] is None:
            href = dict(attrs).get("href")
            if href:
                self.row["href"] = href

    def handle_endtag(self, tag):
        if not self.in_table or tag != "div":
            return
        if self.cell is not None and self.depth == self.cell["depth"]:
            self.row["cells"].append(norm(self.cell["text"]))
            self.cell = None
        if self.row is not None and self.depth == self.row["depth"]:
            self.rows.append(self.row)
            self.row = None
        self.depth -= 1
        if self.depth == 0:
            self.in_table = False

    def handle_data(self, data):
        if self.cell is not None:
            self.cell["text"].append(data)

    def finish(self):
        """Close anything left dangling by unclosed tags."""
        if self.cell is not None and self.row is not None:
            self.row["cells"].append(norm(self.cell["text"]))
            self.cell = None
        if self.row is not None:
            self.rows.append(self.row)
            self.row = None
        self.in_table = False


def variant_type(cell_text):
    if "BUNDLE" in cell_text:
        return "bundle"
    if re.search(r"\bAPK\b", cell_text):
        return "apk"
    return "unknown"


def parse(html):
    parser = VariantsTable()
    parser.feed(html)
    parser.close()
    parser.finish()

    variants = []
    for row in parser.rows:
        cells = row["cells"]
        if not row["href"] or len(cells) < 4:
            continue
        variants.append({
            "url": row["href"],
            "type": variant_type(cells[0]),
            # "arm64-v8a + armeabi-v7a" style cells split like apkmd does
            "arches": [a.strip() for a in cells[1].split("+")],
            "dpi": cells[3].lower(),
        })
    return variants


def pick(variants, arch):
    """apkmd's getFilteredVariant(): arch -> dpi -> type, first match wins."""
    universal = ("universal", "noarch")
    if arch in universal:
        step = [v for v in variants if any(a in universal for a in v["arches"])]
    elif any(arch in v["arches"] for v in variants):
        step = [v for v in variants if arch in v["arches"]]
    else:  # apkmd falls back to universal when the arch isn't offered
        step = [v for v in variants if any(a in universal for a in v["arches"])]
    step = [v for v in step if v["dpi"] == "nodpi"]
    step = [v for v in step if v["type"] == "apk"]
    return step[0] if step else None


try:
    html, final_url = fetch(RELEASE_URL)
except Exception as exc:
    fail(f"could not fetch {RELEASE_URL} ({exc})")

if any(challenge in html for challenge in CHALLENGE):
    fail("the site served a Cloudflare challenge instead of the release page")

# Single-variant apps redirect straight to the variant page (apkmd's
# RedirectError path): the final URL is then already the answer.
if final_url.rstrip("/") != RELEASE_URL.rstrip("/") and "android-apk-download" in final_url:
    print(final_url)
    sys.exit(0)

variants = parse(html)
if not variants:
    fail("no rows found in the variants table")

selected = pick(variants, ARCH) or pick(variants, FALLBACK_ARCH)
if selected is None:
    fail(f"no universal/nodpi/APK variant among {len(variants)} row(s)")

print(f"Selected variant: {selected['url']}", file=sys.stderr)
print("https://www.apkmirror.com" + selected["url"]
      if selected["url"].startswith("/")
      else selected["url"])
PY
) || url=""

# Never emit anything but a plausible source link.
case "$url" in
  https://www.apkmirror.com/apk/*) ;;
  *) url="$release_url" ;;
esac

echo "$url"
