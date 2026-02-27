![cover](cover.svg)

# YTReVanced-Builder :hammer: <img src="qrcode.png" width="24%" align="right" />

[![Downloads][downloads-shield]][downloads-url]
[![GitHub Workflow Status][ci-status-shield]][ci-url]  
[![Release][release-shield-revanced]][downloads-url]
[![Release][release-shield-morphe]][downloads-url]


| **YTReVanced**<br>[![badge][badge-img]][revanced-link] | **YTMorphe**<sup>New</sup><br>[![badge][badge-img]][morphe-link] |
|---|---|

🤖 Automate the process of downloading, patching, and releasing a patched YTReVanced APK.

| Script              | Description                                                                                                                                                         |
|:--------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `get-latest-cli.sh` | Retrieves and downloads the latest [revanced-cli][cli-url] JAR URL from the Revanced API                                                                            |
| `get-dev-rvp.sh`    | Retrieves and downloads the latest pre-release of the [revanced-patches][patches-url] .RVP patch file.                                                              |
| `fetch-yt-ver.sh`   | Uses [revanced-cli][cli-url] to extract and print the latest supported YT version from [revanced-patches][patches-url]                                              |
| `get-apkmd.sh`      | Fetch the latest apkmd binary release from the [tanishqmanuja/apkmirror-downloader][apkmd-url] GitHub repo , download it, save it as apkmd, and make it executable. |
| `get-keystore.sh`      | Fetch the existing keystore from the release, download it and store in cache. |


<!-- Shields -->

[ci-status-shield]: https://img.shields.io/github/actions/workflow/status/azimstech/YTReVanced-Builder/build-revanced.yml?style=for-the-badge
[ci-url]:https://github.com/AzimsTech/YTReVanced-Builder/actions/workflows/build-revanced.yml
[downloads-shield]: https://img.shields.io/github/downloads/azimstech/YTReVanced-Builder/total?style=for-the-badge&logo=github
[downloads-url]: https://github.com/azimstech/YTReVanced-Builder/releases/latest
[release-shield-revanced]: https://img.shields.io/github/v/release/AzimsTech/YTReVanced-Builder?filter=*-revanced&style=for-the-badge
[release-shield-morphe]: https://img.shields.io/github/v/release/AzimsTech/YTReVanced-Builder?filter=*-morphe&style=for-the-badge

<!-- Urls -->

[patches-url]:https://github.com/revanced/revanced-patches
[apkmd-url]:https://github.com/tanishqmanuja/apkmirror-downloader
[cli-url]:https://github.com/revanced/revanced-cli

<!-- Obtainium -->
[badge-img]: ./badge_obtainium.png

[revanced-link]: https://apps.obtainium.imranr.dev/redirect?r=obtainium://app/%7B%22id%22%3A%22app.revanced.android.youtube%22%2C%22url%22%3A%22https%3A%2F%2Fgithub.com%2FAzimsTech%2FYTReVanced-Builder%22%2C%22author%22%3A%22AzimsTech%22%2C%22name%22%3A%22YouTube%20ReVanced%22%2C%22preferredApkIndex%22%3A0%2C%22additionalSettings%22%3A%22%7B%5C%22includePrereleases%5C%22%3Afalse%2C%5C%22fallbackToOlderReleases%5C%22%3Atrue%2C%5C%22filterReleaseTitlesByRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22filterReleaseNotesByRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22verifyLatestTag%5C%22%3Afalse%2C%5C%22sortMethodChoice%5C%22%3A%5C%22date%5C%22%2C%5C%22useLatestAssetDateAsReleaseDate%5C%22%3Afalse%2C%5C%22releaseTitleAsVersion%5C%22%3Afalse%2C%5C%22trackOnly%5C%22%3Afalse%2C%5C%22versionExtractionRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22matchGroupToUse%5C%22%3A%5C%22%5C%22%2C%5C%22versionDetection%5C%22%3Afalse%2C%5C%22releaseDateAsVersion%5C%22%3Afalse%2C%5C%22useVersionCodeAsOSVersion%5C%22%3Afalse%2C%5C%22apkFilterRegEx%5C%22%3A%5C%22%5EYTReVanced_%5C%22%2C%5C%22invertAPKFilter%5C%22%3Afalse%2C%5C%22autoApkFilterByArch%5C%22%3Atrue%2C%5C%22appName%5C%22%3A%5C%22%5C%22%2C%5C%22appAuthor%5C%22%3A%5C%22%5C%22%2C%5C%22shizukuPretendToBeGooglePlay%5C%22%3Afalse%2C%5C%22allowInsecure%5C%22%3Afalse%2C%5C%22exemptFromBackgroundUpdates%5C%22%3Afalse%2C%5C%22skipUpdateNotifications%5C%22%3Afalse%2C%5C%22about%5C%22%3A%5C%22%5C%22%2C%5C%22refreshBeforeDownload%5C%22%3Afalse%2C%5C%22includeZips%5C%22%3Afalse%2C%5C%22zippedApkFilterRegEx%5C%22%3A%5C%22%5C%22%7D%22%2C%22overrideSource%22%3A%22GitHub%22%7D

[morphe-link]: https://apps.obtainium.imranr.dev/redirect?r=obtainium://app/%7B%22id%22%3A%22app.morphe.android.youtube%22%2C%22url%22%3A%22https%3A%2F%2Fgithub.com%2FAzimsTech%2FYTReVanced-Builder%22%2C%22author%22%3A%22AzimsTech%22%2C%22name%22%3A%22YouTube%20Morphe%22%2C%22preferredApkIndex%22%3A0%2C%22additionalSettings%22%3A%22%7B%5C%22includePrereleases%5C%22%3Afalse%2C%5C%22fallbackToOlderReleases%5C%22%3Atrue%2C%5C%22filterReleaseTitlesByRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22filterReleaseNotesByRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22verifyLatestTag%5C%22%3Afalse%2C%5C%22sortMethodChoice%5C%22%3A%5C%22date%5C%22%2C%5C%22useLatestAssetDateAsReleaseDate%5C%22%3Afalse%2C%5C%22releaseTitleAsVersion%5C%22%3Afalse%2C%5C%22trackOnly%5C%22%3Afalse%2C%5C%22versionExtractionRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22matchGroupToUse%5C%22%3A%5C%22%5C%22%2C%5C%22versionDetection%5C%22%3Afalse%2C%5C%22releaseDateAsVersion%5C%22%3Afalse%2C%5C%22useVersionCodeAsOSVersion%5C%22%3Afalse%2C%5C%22apkFilterRegEx%5C%22%3A%5C%22%5EYTMorphe_%5C%22%2C%5C%22invertAPKFilter%5C%22%3Afalse%2C%5C%22autoApkFilterByArch%5C%22%3Atrue%2C%5C%22appName%5C%22%3A%5C%22%5C%22%2C%5C%22appAuthor%5C%22%3A%5C%22%5C%22%2C%5C%22shizukuPretendToBeGooglePlay%5C%22%3Afalse%2C%5C%22allowInsecure%5C%22%3Afalse%2C%5C%22exemptFromBackgroundUpdates%5C%22%3Afalse%2C%5C%22skipUpdateNotifications%5C%22%3Afalse%2C%5C%22about%5C%22%3A%5C%22%5C%22%2C%5C%22refreshBeforeDownload%5C%22%3Afalse%2C%5C%22includeZips%5C%22%3Afalse%2C%5C%22zippedApkFilterRegEx%5C%22%3A%5C%22%5C%22%7D%22%2C%22overrideSource%22%3A%22GitHub%22%7D
