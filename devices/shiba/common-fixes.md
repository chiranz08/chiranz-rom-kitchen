# Pixel 8 (`shiba`) — fixes every ROM needs

Found while finalising Infinity X 17. Format: problem → cause → fix → where it lives.

## Device tree (`android_device_google_shusky`)
- Google face HAL can't read `/metadata` → missing sepolicy → allow rule in `sepolicy/vendor/hal_face_default.te`.
- Face enrolment callback denied (`hal_face_default` → `system_app` binder) → `binder_call` rule, same file.
- Google Camera video modes: `hal_camera_default` can't create dirs in its data dir → `create` on `vendor_camera_data_file:dir`.
- `gxp_logging` spams `traced_producer_socket` denials (~50/10 min) → `dontaudit`.
- Google face unlock: a ROM's software FaceUnlock takes over the face HAL → `TARGET_FACE_UNLOCK_SUPPORTED := false` and ship crDroid's Google faceunlock.

- StrongBox retry storm on ROMs that set `ro.product.first_api_level` below 33 (e.g. ASCP, Evolution X): the citadel
  KeyMint HAL then registers only `IKeyMintDevice/strongbox`, but the zuma VINTF manifest declares
  `IRemotelyProvisionedComponent/strongbox` → servicemanager retries the lazy start ~2/s forever → drop that declaration on
  those ROMs' branches only (Infinity X keeps 34 and registers it).
- Smooth Display: the shiba overlay sets `config_defaultPeakRefreshRate` 60 (stock ships it off) → 120.

## Build identity
- `BUILD_ID` must match the blobs' fingerprint (CP2A.260805.005 for the pinned blobs), or the build id and fingerprint disagree.

## Google apps
- Now Playing: the zuma allowlist blocks the PCS association → narrow `allow-association` for Now Playing, keyboard and TTS (`vendor_chiranz/sysconfig`).
- Circle to Search: Pixel Launcher reads `config_defaultContextualSearchPackageName` by numeric resource ID (`0x01040276`).
  Any ROM that adds framework strings before it shifts the ID → pin the four contextual search IDs in
  `core/res/res/values/symbols.xml` and let aapt2 honour `<java-symbol id=...>` (see `roms/infinity/patches/frameworks/base`).
- Pixel Launcher ignores the ROM's navigation hint setting → runtime overlay on the launcher toggled from Gesture settings.

## Audio and battery
- JamesDSP: use a config listing exactly the 13 software effects the AoC audio HAL loads plus `jdsp`; the generic
  config drops effects. The upstream sepolicy suggestion violates an AOSP neverallow — not needed.
- PowerInsight: platform code may not read `sysfs_batteryinfo` (neverallow) → read battery data from the health HAL.
