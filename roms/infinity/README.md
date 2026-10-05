# Project Infinity X 17 — Pixel 8 (`shiba`) and Pixel 8 Pro (`husky`)

**Status:** shiba build `Project_Infinity-X-4.0-shiba-05.10.2026-GAPPS-UNOFFICIAL.zip` (2026-10-05 04:04 UTC) tested; husky product `infinity_husky` added 2026-10-04
(userdebug, release-keys with our own keys, Android 17, security patch 2026-09-01, `BUILD_ID` CP2A.260805.005).

## What's in it
| | |
|---|---|
| Base | Project Infinity X 17 (GApps), manifest `ebfe200` |
| Device | LineageOS `lineage-24.0` shusky/zuma (our forks, branch `infinity-17`), TheMuppets blobs |
| Kernel | LineageOS GKI 6.1, built at lunch |
| Biometrics | Google face unlock (crDroid faceunlock), fingerprint |
| Google | Standard app set (same in every ROM): Google Phone, Messages, Google file picker (Files icon), Pixel live/2025 wallpapers; Pixel Launcher, Google Camera, stock-Pixel-8 Gemini setup, Now Playing, Circle to Search |
| Removed | TalkBack, Switch Access, search selector, partner setup, AI/emoji/Magic Portrait wallpapers, LineageOS Recorder |
| Added | JamesDSP, PowerInsight (battery screens), Datura per-app firewall, blur intensity slider, Pixel Launcher pill toggle, Clear Calling, Now Playing entry in Sound, high brightness mode (page + QS tile), "Vibrate on gesture" for tap/lift/double-tap wake, iOS clock font |
| Look | Pure black power menu and blur surfaces with the black theme; no circle behind the lock screen fingerprint icon; no pill behind the back arrow; Smooth Display (120 Hz) on by default |
| Lock screen clocks | Pixelify-AOSP clock styles (92) with its customizer: colour/gradient/album-art, scale, margins, AOD animation, wobble on charge; clock font picker (locked for styles with their own font); "See all" gallery of mini lock screens with category filters |

## Files
| File | What |
|---|---|
| [rom.conf](rom.conf) | Settings the scripts read |
| [manifest/pinned.xml](manifest/pinned.xml) | Every ROM project pinned |
| [manifest/local_manifests/](manifest/local_manifests/) | Device trees, blobs, extras (`chiranz-vendor.xml` is private) |
| [patches/](patches/) | Our changes to ROM source, one folder per project, base commit recorded |
| [FIXES.md](FIXES.md) | Every fix: error → cause → fix → where |
| [TESTS.md](TESTS.md) | Dated test passes |

## Feature switches (product makefile, `vendor_chiranz`)
`CHIRANZ_PIXEL_LAUNCHER`, `CHIRANZ_JAMESDSP`, `CHIRANZ_POWERINSIGHT`, `CHIRANZ_GOOGLE_STOCK`, `CHIRANZ_FIREWALL`, `CHIRANZ_GAPPS_SET`, `CHIRANZ_CLEAR_CALLING` — all `true` here.

Blur: Infinity sets `persist.sys.sf.disable_blurs=1` (compositor blur off), so the blur switch gives dark see-through surfaces rather than real blur. Left as Infinity ships it.

## Flashing
First flash of a release-keys build over anything else (including our own test-keys builds) needs a data wipe.
Later builds signed with the same keys can be flashed over it.
