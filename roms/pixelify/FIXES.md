# ASCP (Pixelify-AOSP 17) on Pixel 8 (shiba) — fixes

Format: problem → cause → fix → where.

## Build fixes
1. Lunch target → `ascp_shiba-cp2a-<variant>` (release added explicitly) → rom.conf.
2. Generic system partition enforced on shiba → ASCP version props and blur props moved to product; duplicate `ro.ascp.device` dropped (gen_build_prop.py already writes it) → vendor/custom, vendor/extra.
3. Kati "overriding commands" for 25 fonts → `fonts/imported/` copies duplicate `prebuilt_font` modules → removed (`post-remove-duplicate-fonts.sh`) → vendor/extra.
4. ViPER hook doesn't compile → ASCP's system/media never defines its UUIDs → hook dropped (JamesDSP used instead) → hardware/interfaces.
5. Duplicate AICore / DeviceIntelligence modules → blobs and GApps ship the same APKs → dropped from blobs → vendor/google/shiba.
6. Artifact path requirement (11 system files) and GApps apex contributions → explicit allowlist + `PRODUCT_BUILD_IGNORE_APEX_CONTRIBUTION_CONTENTS` → ascp_shiba.mk.
7. Reserved-size include and Aperture RRO → ASCP paths; Aperture RRO only without Google Camera → device trees.
8. Install path clash on Datura files → our optional Datura copy used ASCP's file names → own file names → vendor_chiranz.

## Device / feature fixes
- BUILD_ID → CP2A.260805.005 to match blobs/fingerprint → build/make.
- Google face unlock: `TARGET_FACE_UNLOCK_SUPPORTED := false` + crDroid faceunlock; face HAL `/metadata` read, enroll callback, camera data subdirs, gxp_logging dontaudit → device/google/shusky.
- Now Playing recognition: PCS association blocked by the zuma allowlist → narrow allow-association → vendor_chiranz.
- Navigation hint (pill) switch did nothing with Pixel Launcher → ASCP's switch toggles `com.google.android.apps.nexuslauncher.overlay.nogesturehint`, which no module provided → overlay with that name → vendor_chiranz (`CHIRANZ_PIXEL_LAUNCHER`).
- JamesDSP and the stock Pixel 8 Google setup → vendor_chiranz switches.
- Standard Google app set (`CHIRANZ_GAPPS_SET`): drops Photos, Gmail, Maps, Calendar, Files by Google, Safety Hub, Sound Amplifier, Scribe, search selector, partner setup, AI/emoji/Magic Portrait wallpapers. Files icon: DocumentsUIGoogle disables its launcher activities (GApps sysconfig + its PreBootReceiver) → `component-override` in system_ext (read last) → vendor_chiranz.
- Smooth Display default: shiba overlay sets peak 60 Hz (stock Pixel 8 ships it off) → 120 → device/google/shusky.
- Now Playing on the lock screen / AOD: ASCP's SystemUI has no ambient indication → Pixel's `ambientmusic` (AmbientIndicationContainer/Service) hosted in the Compose scene-container lock screen by filling AOSP's empty `AmbientIndicationAreaProvider`; container seeds its bar state on attach (`addCallback()` doesn't replay it, so it stayed INVISIBLE); dead `keyguard_bottom_area` copy removed → frameworks/base. AOD shows a new song at the next AOD redraw (about once a minute) — expected.
- Pure black power menu (blur off): fallback is an accent colour → black when the surface container is black → SystemUI GlobalActionsLayout.
- Pure black shade, PIN screen, volume panel, notification scrim with blur off: `shade_panel_fallback`, `bouncer_fallback_bg`, `volume_dialog_view_background_blur_fallback`, `notification_scrim_base` are accent colours → follow the black theme → SystemUI ShadeColors / BouncerColors / volume binders.
- Monet tint with the pure black theme on (panel behind notifications, launcher drawer, USB mode sheet, blur layers): SystemUI's dynamic (wallpaper) palette overlay is applied above the black theme (LineageBlackTheme), so every surface it defines stayed Monet (measured: drawer and USB sheet = `system_accent2_800`, panel = `system_accent1_800` at 50%). In black mode ThemeOverlayController now writes neutral surfaces into the dynamic overlay (surface-effect layers keep their alpha) and makes `system_accent2_800` black; LineageBlackTheme gets an untinted `shade_panel_fg` → frameworks/base, vendor/custom.
- StrongBox retry storm (~1,300 failed lookups / 10 min, 1–2 s keystore stalls): ASCP sets `ro.product.first_api_level=32` (its own integrity setting, left untouched), so the citadel KeyMint HAL registers only `IKeyMintDevice/strongbox`, but the zuma VINTF manifest declared `IRemotelyProvisionedComponent/strongbox` → declaration removed → device/google/zuma. Verified: 0 lookups afterwards, no crashes.
- Release signing: fresh ASCP key set from the LineageOS-style keys template (template's public releasekey deleted first) → `vendor/custom-priv/keys` (never committed).
- Clock customizer: scroll collapses the Settings toolbar with bottom room; Colour/Misc tabs crashed (nested verticalScroll) → fixed; "See all" gallery of mini lock screens with category filters; clock font row (locked for styles with their own font; hidden here since ASCP ships no lockscreen clock-font overlays).
- Clock style padding: start margin is extra on top of the normal side padding; end padding kept. Style 2 (oos2) follows the clock font with font padding on the big digits.
- Pixel 8 Pro (husky): ascp_husky product added.
- Clear Calling (Google Device Connectivity Service) shipped and enabled; Now Playing entry in Sound settings.
- High brightness mode: manual HBM and Auto HBM threshold page and QS tile (device parts).

- LDAC silent (AAC fine), Nothing Ear: the A2DP offload path on this hardware only takes SBC/AAC/Opus, so the Bluetooth stack encodes LDAC in software, but the audio HAL still routed LDAC to the offload device ("bt-a2dp device port not found", output open -19) and playback stayed on the speaker path → A2DP (and LE audio) hardware offload off by default in device/google/zuma vendor.prop.
- Developer options "Disable Bluetooth A2DP hardware offload" never stuck: the Bluetooth developer page rebooted without calling the switches' save step → it now applies A2DP offload / LE audio offload / LE audio mode changes before rebooting → Settings.
- 3-button navigation cut off: Pixel Launcher's hide-pill overlay stayed on after leaving gesture mode and shrank the taskbar window that hosts the nav buttons → turned off outside gesture mode (restored from the pill setting on return) → Settings.
## Left as ASCP ships it
- Pixel Launcher's app drawer doesn't blur with blur on (the home screen shows faintly through).
- USB debugging comes on during setup (Android trade-in mode on a debuggable-type build).
