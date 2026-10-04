# chiranz rom kitchen

Notes, settings and tooling for building custom Android ROMs, kept server-agnostic and reproducible.

## Devices

| Device | Codename | Notes |
|---|---|---|
| Google Pixel 8 | `shiba` | [devices/shiba](devices/shiba/) |

## ROMs

| ROM | Base | Device | Status |
|---|---|---|---|
| _none finalised yet_ | | | |

## Layout

| Path | What it holds |
|---|---|
| `docs/` | Build guide, test checklist, conventions |
| `devices/<codename>/` | Device notes and fixes every ROM needs on that device |
| `roms/<rom>/` | One folder per ROM: settings (`rom.conf`), pinned manifest, fixes, test log, patches |
| `scripts/` | Build, apply, verify — driven by `rom.conf`, no hard-coded paths |

Related repos: `vendor_chiranz` (shared additions layer) and device-tree forks with one branch per ROM.
