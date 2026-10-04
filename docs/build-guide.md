# Build guide

From nothing to a flashable zip. Example ROM: `infinity`. Needs a Linux build host (≥ 64 GB RAM, ~400 GB free per ROM tree), `repo`, `git-lfs`.

1. **Clone this repo** and choose where trees go: `export ROMS_DIR=~/roms`.
2. **Sync:** `scripts/sync.sh infinity --pinned`. This sets up the ROM manifest pinned to exact commits, plus our device
   manifests (`roms/infinity/manifest/local_manifests/`). `chiranz-vendor.xml` needs access to the private `vendor_chiranz`.
3. **Apply our ROM-source patches:** `scripts/apply.sh infinity`.
4. **Keys (once per ROM):** `KEY_SUBJECT='/O=you/CN=you' scripts/make-keys.sh infinity`. Back up the key folder
   encrypted (for example `tar czf - keys | gpg --symmetric`), somewhere that isn't a repo.
5. **Build:** `scripts/build.sh infinity userdebug` (or queue it: add `infinity userdebug 96 60` to the queue
   file and run `scripts/queue.sh`).
6. **Check the zip:** `scripts/verify-zip.sh <zip>`. It should say `release-keys` and your own subject.
7. **Flash:** boot to the ROM's recovery, `adb sideload <zip>`. First flash with new keys: wipe data.
8. **Test** with [test-checklist.md](test-checklist.md) and log the result in `roms/<rom>/TESTS.md`.
