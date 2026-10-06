# Infinity X — test log

## 2026-10-04 — build `Project_Infinity-X-4.0-shiba-03.10.2026-GAPPS-UNOFFICIAL` (userdebug, test-keys)

Device: Pixel 8 (shiba). Clean flash with data wipe. Firmware from the zip: bootloader
`ripcurrent-17.0-15199481`, modem `g5300i-260317-260505-B-15346003`.

### Hands-on (owner)
| Area | Result |
|---|---|
| Boot | OK, `boot_completed` 38 s after reboot |
| Face unlock (Google, re-enrolled) | Works |
| Fingerprint | Works |
| Now Playing | Works (lock screen, app, notifications). Odd only during first boot setup |
| SIM / mobile data | 5G SA (NR_SA), in service |
| VoLTE / VoNR | Working |
| NFC | Works |
| GPS | Works |
| Charging | Works |
| Display | Works |
| Vibration | Works |

### From logs (bugreports: one run without SIM, two runs with SIM 12 min apart)
- No app crashes, native crashes, ANRs, tombstones or crash-loops; dropbox holds only boot/trim entries.
- No service restarts or watchdog events.
- Biometrics: fingerprint and face both strength 15 (BIOMETRIC_STRONG), 0 HAL deaths.
- Now Playing: 0 "association not allowed" (PCS allowlist fix works).
- StrongBox `IRemotelyProvisionedComponent/strongbox` found; no retry loop.
- Face HAL `/metadata` denial gone (sepolicy fix works).
- Carrier config loaded for the SIM. VoLTE available/enabled/provisioned,
  IMS registered, VoNR available and enabled. Wi-Fi calling supported by carrier but off (user setting).
- Data: one connect, no drops in 12 min; NR_SA throughout. Signal ssRsrp -111 dBm (indoors).
- RIL "errors" are SIM_IO 0x6A (optional EFs absent on the card) — same as stock.
- No modem resets.

### Known noise (not faults)
- RIL logs every response at E level (~200/20 min) — stock behaviour.
- CS40L26 haptics I2C `NO ACK` at 0x43 (~28/20 min): wake-from-hibernate retry ("Applying delay"); vibration works.
- `hal_face_default -> default_prop` read (Google bug b/487141902).

### Open / to fix (all fixed in the 2026-10-04 builds below)
- `hal_camera_default -> vendor_camera_data_file:dir create` (10/boot) — likely GCam video bokeh; add allow rule.
- `hal_face_default -> system_app:binder call` (2, during enroll) — add binder_call.
- `gxp_logging -> traced_producer_socket write` (~50/10 min) — add dontaudit.
- Not yet tested: calls/SMS in detail, Wi-Fi calling, camera video modes, audio routes, 24 h battery/deep sleep.

## 2026-10-04 — build `…-04.10.2026` (10:10 UTC, sha256 fc3cfab5…2e91)

### Hands-on (owner)
- Circle to Search: works (pill long-press and 3-button home long-press).
- Nav pill hide switch: works (Pixel Launcher pill hidden/shown).
- Power menu: pure black with blur off.
- PowerInsight: works. JamesDSP: works.

### From logs (earlier build of the same day)
- No crashes, ANRs or tombstones; JamesDSP effect loaded in audio_flinger with no audio denials.
- Fixed denials confirmed gone: camera data dir create, face enroll callback, gxp_logging.

## 2026-10-04 — build `…-04.10.2026` (11:45 UTC, sha256 b9bf5dd7…217c) — release-signed, clean flash

### Hands-on (owner)
- Datura: app opens; Settings → app → Mobile data & Wi-Fi → Datura Firewall opens it for that app; blocking an app's internet works and restores.
- PowerInsight, face unlock, fingerprint, calls, Circle to Search: all work.
- Earlier on this build line, also confirmed by the owner: calls, SMS, Wi-Fi calling, audio routes (speaker, earpiece, wired/Bluetooth), camera video modes.
- Verdict: everything tested works → final Infinity X build.

## 2026-10-04 — build 18:02 UTC (standard app set, 120 Hz) — clean flash

### Hands-on (owner)
- Files icon opens Google's file picker; calls and SMS work in Google Phone and Messages; Smooth Display on by default.

### Colours (blur / pure black)
- Blur on, black off or on: QS and notification background dark and see-through; drawer shows the wallpaper darkened (compositor blur is off in Infinity, `persist.sys.sf.disable_blurs=1`). Blur off, black on: QS, notification background, volume panel, power menu, PIN screen pure black; drawer `system_accent2_800` grey. Owner: no change wanted.

## 2026-10-05 — shiba build 04:04 UTC — clean flash

### Hands-on (owner)
- Clear Calling switch in Sound & vibration; Now Playing entry opens its settings.
- Clock font applies with a custom clock face on; iOS clock font in the picker.
- No circle behind the lock screen fingerprint icon; back arrow has no pill.
- "Vibrate on gesture" for tap / lift wake works.
- High brightness mode page and HBM tile work.
- Verdict: all new items work.

## 2026-10-05 — shiba builds 07:21 → 11:32 UTC (clock styles)

### Hands-on (owner)
- Pixelify-AOSP clock styles and customizer work; side padding fixed; stock date no longer overlaps the status bar.
- Style 2 with the iOS font matches its preview, with clean spacing.
- Customizer scrolls fully; Colour/Misc tabs open (crash fixed, confirmed with the crash log); "See all" gallery and category filters work.
- Clock font row works and is locked for fixed-font styles.
- USB mode sheet still not black with pure black (left as is).

## 2026-10-06 — shiba build 07:18 UTC

### Hands-on (owner)
- LDAC plays on Nothing Ear (A2DP offload off by default).
- 3-button navigation: still broken — all three buttons drawn stacked in the centre by Pixel Launcher's taskbar (taps register). No errors in launcher/system logs; not the hide-pill overlay, not setup/kids mode, same with Nova or Pixel Launcher as home. Left as is (owner uses gesture navigation).
