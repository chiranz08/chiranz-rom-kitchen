# ASCP (Pixelify-AOSP 17) — Pixel 8 (`shiba`)

**Status:** finalised 2026-10-04. Build `ASCP-v6.3-ascp_shiba-UNOFFICIAL-…` from 16:32 UTC
(userdebug, release-keys with our own ASCP keys, Android 17, security patch 2026-09-01, `BUILD_ID` CP2A.260805.005).

## What's in it
| | |
|---|---|
| Base | Pixelify-AOSP 17 (`ascp_shiba`), manifest `3d6c1ba` |
| Device | LineageOS `lineage-24.0` shusky/zuma (our forks, branch `pixelify-17`), TheMuppets blobs |
| Kernel | LineageOS GKI 6.1, built at lunch |
| Biometrics | Google face unlock (crDroid faceunlock), fingerprint |
| Google | Standard app set (same in every ROM), Pixel Launcher, Google Camera, stock-Pixel-8 Gemini setup, Now Playing (incl. lock screen / AOD), Circle to Search |
| From ASCP itself | PowerInsight, Datura firewall, blur intensity, navigation-hint switch, advanced restart |
| Added | JamesDSP, Files icon for Google's file picker |
| Look | Pure black theme with no Monet tint anywhere (blur on or off); Smooth Display (120 Hz) on by default |

## Files
| File | What |
|---|---|
| [rom.conf](rom.conf) | Settings the scripts read |
| [manifest/pinned.xml](manifest/pinned.xml) | Every ROM project pinned |
| [manifest/local_manifests/](manifest/local_manifests/) | Device trees, blobs, extras (`chiranz-vendor.xml` is private) |
| [patches/](patches/) | Our changes to ROM source, one folder per project, base commit recorded; `post-*.sh` steps run after |
| [FIXES.md](FIXES.md) | Every fix: problem → cause → fix → where |
| [TESTS.md](TESTS.md) | Dated test passes |

## Feature switches (`ascp_shiba.mk`, `vendor_chiranz`)
`CHIRANZ_PIXEL_LAUNCHER`, `CHIRANZ_JAMESDSP`, `CHIRANZ_GOOGLE_STOCK`, `CHIRANZ_GAPPS_SET` — all `true`.
Not used here because ASCP ships its own: `CHIRANZ_POWERINSIGHT`, `CHIRANZ_FIREWALL`.

## Good to know
- Advanced restart is off by default: Settings → System → Gestures → Press & hold power button → Enable advanced restart.
- Google Recorder isn't preloaded (no source); install it from the Play Store.
- First flash with these keys needs a data wipe.
