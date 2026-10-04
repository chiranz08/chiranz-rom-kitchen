# chiranz rom kitchen

Notes, settings and tooling for building custom Android ROMs, kept server-agnostic and reproducible.

## Devices

| Device | Codename | Notes |
|---|---|---|
| Google Pixel 8 | `shiba` | [devices/shiba](devices/shiba/) |

## ROMs

| ROM | Base | Device | Status |
|---|---|---|---|
| Project Infinity X 17 | LineageOS device trees, GApps | Pixel 8 | Finalised 2026-10-04 — [roms/infinity](roms/infinity/) |

## Layout

| Path | What it holds |
|---|---|
| `docs/` | Build guide, test checklist, conventions |
| `devices/<codename>/` | Device notes and fixes every ROM needs on that device |
| `roms/<rom>/` | One folder per ROM: settings (`rom.conf`), pinned manifest, fixes, test log, patches |
| `scripts/` | Build, apply, verify — driven by `rom.conf`, no hard-coded paths |

Related repos:
- [android_device_google_shusky](https://github.com/chiranz08/android_device_google_shusky) and [android_device_google_zuma](https://github.com/chiranz08/android_device_google_zuma): LineageOS forks, one branch per ROM (`infinity-17`)
- `vendor_chiranz`: the features layer, private because it carries prebuilt APKs
