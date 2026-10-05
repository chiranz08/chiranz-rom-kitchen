# Infinity X (17) on Pixel 8 (shiba) — fixes

Format: error → cause → fix → where.

## Build fixes
1. `bad TARGET_BUILD_VARIANT: cp2a-userdebug` → Infinity's lunch adds the release itself → lunch `infinity_shiba-<variant>` → build script.
2. Kernel step would sync a non-existent branch → vendor/infinity has no PRODUCT_VERSION_MAJOR/MINOR → set 24/0 in `infinity_shiba.mk` → device/google/shusky.
3. `soong.variables did not parse` → PRODUCT_SYSTEM_PROPERTIES values with spaces → move about-phone props to `shiba/system.prop` → device/google/shusky.
4. `undefined module *.google.contributions.prebuilt` → GApps ship com.google.android.extservices → `PRODUCT_BUILD_IGNORE_APEX_CONTRIBUTION_CONTENTS := true` → infinity_shiba.mk.
5. Duplicate Soong modules (AICore, DeviceIntelligenceNetwork) in blobs and vendor/pixel/gms → identical APKs → drop from blobs → vendor/google/shiba.
6. Artifact path requirement (9 system files) → GApps/Infinity extras in system → explicit allowlist → infinity_shiba.mk.
7. Duplicate GlanceableHub RROs (zuma vs vendor/extras) → vendor/extras is a superset → drop zuma copies → device/google/zuma.
8. Reserved-size include pointed at vendor/lineage → use vendor/infinity path → device/google/zuma.

## Device / feature fixes
- BUILD_ID: CP2A.260605.016 → CP2A.260805.005 to match blobs/fingerprint → build/make.
- Face unlock: ROM software FaceUnlock hijacked the Google face HAL → `TARGET_FACE_UNLOCK_SUPPORTED := false` + crDroid faceunlock 17.0 → product makefile + local manifest.
- Face HAL `/metadata` read denial → sepolicy rule → device/google/shusky.
- Face enroll callback, camera data subdir create, gxp_logging spam → 3 sepolicy lines → device/google/shusky.
- Now Playing: PCS association blocked by zuma allowlist → narrow allow-association for nowplaying/latin/tts → vendor_chiranz.
- Pixel Launcher, TalkBack/Switch Access removal, Google Camera → vendor_chiranz + local manifest.
- JamesDSP: own audio_effects_config.xml listing exactly the 13 software effects the AoC HAL loads by default + jdsp (JamesDSP's generic config would drop effects); no extra sepolicy needed. README's `audioserver default_android_service find` violates an AOSP neverallow → not used.
- PowerInsight (from Pixelify): service reads battery data via HealthServiceWrapper instead of sysfs (system/sepolicy neverallow on sysfs_batteryinfo for platform) → frameworks/base + Settings + vendor_chiranz sepolicy.
- Pure black power menu (blur off): fallback colour is system_accent1_800 → use black when surface container is black → SystemUI GlobalActionsLayout.
- Pure black blur surfaces: system_surface_effect_0_dark, shade_panel_fg (app drawer + shade over blur), system_surface_dark → AndroidBlackTheme overlay.
- Blur intensity slider: SystemUI already applies BLUR_INTENSITY; port Pixelify's BlurSettings screen → Settings.
- Nav pill hide: Pixel Launcher ignores LineageSettings NAVIGATION_BAR_HINT → runtime overlay on the launcher toggled from Gesture settings (Evolution X approach) → vendor_chiranz + Settings.
- Datura firewall (from Pixelify-AOSP): CalyxOS Datura prebuilt, platform-signed, own module names; "Datura Firewall" row in App data usage opens Datura for that UID (Infinity's own per-app switches kept; same NetworkPolicyManager policies) → vendor_chiranz (`CHIRANZ_FIREWALL`) + Settings.
- Standard Google app set (`CHIRANZ_GAPPS_SET` + Google Phone, Messages, DocumentsUIGoogle, Pixel live/2025 wallpapers in `infinity_shiba.mk`; DocumentsUIGoogle added to the system artifact allowlist). Files icon: DocumentsUIGoogle disables its own launcher activities → `component-override` in system_ext → vendor_chiranz + device/google/shusky.
- Smooth Display default: shiba overlay sets peak 60 Hz (stock ships it off) → 120 → device/google/shusky.
- Clear Calling missing from Sound settings: Google's Device Connectivity Service (`com.google.android.apps.pixel.dcservice`) isn't in Infinity's GApps → prebuilt + privapp/default permissions (`CHIRANZ_CLEAR_CALLING`); it injects its own switch → vendor_chiranz.
- Now Playing missing from Sound settings: Android System Intelligence disables its own settings activity after a Play update → own entry that opens ASI's `NowPlayingAmbientMusicSettingsActivity` (or the split app's settings), hidden when neither resolves → Settings.
- Clock fonts never reached custom clock faces: the InfinitySuite font picker reset `LOCK_SCREEN_CUSTOM_CLOCK_FACE` to 0 on apply → keep the face (25 of 94 faces use `config_clockFontFamily`) → InfinitySuite.
- iOS clock font: `ios.ttf` / family `ios` already shipped, no clock-font overlay used it; `SFPro-SemiboldStencil` pointed at an undefined family → `ClockFontIosOverlay` + alias `sanfrancisco-sb-stencil-clock` → `ios` → packages/overlays/Themes.
- Lock screen fingerprint icon / back arrow: filled "background protection" circle and the back-arrow pill removed → SystemUI DeviceEntryBackgroundViewModel, BackPanel.
- "Vibrate on gesture" for tap / lift / double-tap wake (from Pixelify-AOSP): 3 hidden Secure settings, AmbientDisplayConfiguration helpers, DozeTriggers + PulsingGestureListener haptic, switches on the three gesture pages → frameworks/base + Settings.
- High brightness mode: HighBrightnessModeController honours `hbm_force`, `auto_hbm`, `auto_hbm_threshold`, `auto_hbm_no_time_limit`; GoogleParts page (Settings → Display) and QS tile write them → frameworks/base + device/google/zuma parts.
- Custom lock screen clocks replaced with Pixelify-AOSP's: ClockStyle engine + 92 layouts (SystemUI), 10 new settings (framework), the Compose clock customizer (Settings, opened from InfinitySuite's "Custom clock style"), preview layouts and fonts (InfinitySuite), colorpicker-compose (skydoves, Apache-2.0) for its colour picker. Kept Infinity's AODStyle, weather/widget areas, device name.
  - Port fixes: Infinity's MediaDataListener signature; Infinity's SystemUI restart helper; the customizer now applies Infinity's custom-clock overlays (hide stock clock + smartspace, centred offset) — without them the stock date rode up into the status bar.
  - Side padding: the start-margin setting overwrote the frame's left padding (default 0) → start margin is extra on top of the normal padding, end padding restored.
  - Style 2 (oos2): its preview used the clock font but the lock screen layout had OnePlus Slate hard-coded → follows the clock font; big digits use font padding so any font keeps its spacing.
  - Customizer: scroll collapses the Settings toolbar and has bottom room; Colour/Misc tabs crashed (nested verticalScroll inside the scrollable page) → inner scrolls removed; "See all" gallery (two columns, wallpaper, clock laid out at phone width then scaled, category filters); clock font row (fonts drawn in their own face, applied via OverlayManager), locked when SystemUI's layout for the style doesn't use config_clockFontFamily.
  - Tried and dropped: forcing the picked font on every face (broke layouts designed around their own fonts).
- USB mode sheet / drawer with blur off: system_accent2_800 overridden in the black theme and the accent overlay — no visible effect on the sheet; left as is.
- Pixel 8 Pro: `infinity_husky` product (screen 1344×2992, husky fingerprint), husky blobs with the same AICore/DeviceIntelligence duplicates dropped, Aperture RRO only without GCam → device/google/shusky, vendor/google/husky.
- Release signing: fresh key set from the Infinity keys template (template's public releasekey deleted before generating; own subject) → `vendor/infinity-priv/keys` (never committed; encrypted backup kept off-repo). Switching from test-keys needs a data wipe once.

## Circle to Search — root cause
Pixel Launcher reads `config_defaultContextualSearchPackageName` by numeric ID `0x01040276`. Infinity's extra framework strings shifted the four contextual search configs by one, so the launcher read `"omni.enable_vis"` as the package, its intent query returned nothing ("no matching CSS intent filter"), and it reported Circle to Search unavailable. Fix: pin the four IDs in `core/res/res/values/symbols.xml` (as Evolution X does) and teach aapt2 to honour `<java-symbol id=...>` for private resources (ResourceParser + TableMerger) → frameworks/base.
Also aligned the Google setup with stock Pixel 8 (GeminiShell + Gemini features, Google's initial package stopped-state list, missing privapp grants, PIXEL_2024/2025 features removed) → vendor_chiranz `CHIRANZ_GOOGLE_STOCK`.
Ruled out along the way: framework config values, intent resolver/non-exported filtering, AppsFilter visibility, spoof hooks, assist screen-content settings.
