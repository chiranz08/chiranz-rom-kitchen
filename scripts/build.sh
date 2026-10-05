#!/bin/bash
# Build a ROM and copy the zip to $RELEASE_DIR. Usage: build.sh <rom> [variant] [jobs]
#   FORCE_KERNEL=1  rebuild the kernel even if prebuilts exist
set -o pipefail
source "$(dirname "$0")/common.sh"
load_rom "$1"
VARIANT=${2:-$DEFAULT_VARIANT}; JOBS=${3:-$(nproc)}
cd "$TREE" || exit 1
[ -f "$KERNEL_DIR/Image.lz4" ] && [ -z "$FORCE_KERNEL" ] && export SKIP_KERNEL_BUILD=true
source build/envsetup.sh
lunch "$LUNCH_TARGET-$VARIANT" || { echo "== LUNCH FAILED"; exit 1; }
START=$(date +%s)
m "$MAKE_TARGET" -j"$JOBS" || { echo "== BUILD FAILED"; exit 1; }
ZIP=$(find "$OUT" -maxdepth 1 -name '*.zip' -newermt "@$START" ! -name '*target_files*' ! -name '*-ota-*' | head -1)
[ -n "$ZIP" ] || { echo "== no new zip in $OUT"; exit 1; }
mkdir -p "$RELEASE_DIR"
# Release name ends with the build start time (UTC) = the build date shown in About phone.
STAMP=$(date -u -d "@$START" +%Y%m%d-%H%M)
NAME="$(basename "$ZIP" .zip | sed -E 's/-[0-9]{8}-[0-9]{4}$//')-${STAMP}.zip"
cp -v "$ZIP" "$RELEASE_DIR/$NAME" && (cd "$RELEASE_DIR" && sha256sum "$NAME" | tee -a SHA256SUMS)
