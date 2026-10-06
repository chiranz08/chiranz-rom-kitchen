# ASCP — test log

All on Pixel 8 (shiba), clean flash every time.

## 2026-10-04 — first release-keys build (13:31 UTC)
### Hands-on (owner)
- Navigation hint switch hides/shows the Pixel Launcher pill: works.
- PowerInsight, Datura, blur slider (ASCP's own): work.
- Circle to Search, face unlock, fingerprint, calls: work.
- Power menu black. With blur off: QS panel, notification background, volume panel and lock screen still Monet → fixed below.
- Now Playing: recognised in the app and notifications, not on the lock screen → fixed below.

## 2026-10-04 — build 14:26 UTC
- Now Playing on the lock screen and AOD: works (AOD picks up a new song at its next redraw, about a minute).
- QS, volume panel, power menu pure black; notification background and PIN screen still Monet → fixed below.

## 2026-10-04 — build 15:25 UTC (standard app set)
### From logs (boot + 10 min)
- No crashes, ANRs, tombstones; dropbox only storage_trim + SYSTEM_BOOT.
- StrongBox retry storm (~1,300 "could not find IRemotelyProvisionedComponent/strongbox" in 10 min, keystore watchdog stalls) → fixed below.
- Binder burst from Android System Intelligence while Play updated apps; app kills were package updates — normal.
- Colours measured: drawer and USB sheet `#1d333b` (= `system_accent2_800`), panel behind notifications `#001b21` (= `system_accent1_800` at 50%) → fixed below.

## 2026-10-04 — build 16:32 UTC (final)
### From logs and screenshots
- StrongBox: 0 lookups in boot and 10-min logs; one normal key fetch at boot.
- No crashes, ANRs, tombstones.
- Surfaces neutral: surface effects 0–3 `#80000000 / #8a121212 / #26e0e0e0 / #1ae0e0e0`, surface `#000000`, container low `#0a0a0a`, container highest `#1e1e1e`, `system_accent2_800` `#000000`.
- Blur off: shade, cards, app drawer pure black. Blur on: shade shows the blurred wallpaper through a 50 % black layer (expected).
- Known: app drawer doesn't blur with blur on (left as is).

## Pending (in source, not built yet)
- BCR built in (vendor_chiranz `CHIRANZ_BCR`). Before flashing that build: remove the BCR Magisk/KernelSU module and reboot, so the two copies don't clash.
- ASCP: LDAC default, offload switch fix, nav pill fix and BCR are in source; last ASCP builds predate them.
