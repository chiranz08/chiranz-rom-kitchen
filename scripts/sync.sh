#!/bin/bash
# Sync a ROM tree with our device manifests. Usage: sync.sh <rom> [--pinned]
#   --pinned  use roms/<rom>/manifest/pinned.xml (exact commits) instead of the ROM's branch heads
set -e
source "$(dirname "$0")/common.sh"
load_rom "$1"
mkdir -p "$TREE" && cd "$TREE"
repo init -u "$MANIFEST_URL" -b "$MANIFEST_BRANCH" --git-lfs
if [ "$2" = --pinned ]; then
    cp "$ROM_KITCHEN/manifest/pinned.xml" .repo/manifests/chiranz-pinned.xml
    repo init -m chiranz-pinned.xml
fi
mkdir -p .repo/local_manifests
cp "$ROM_KITCHEN"/manifest/local_manifests/*.xml .repo/local_manifests/
repo sync -c -j"$(nproc)" --force-sync --no-tags --no-clone-bundle
echo "synced $ROM_NAME in $TREE; next: scripts/apply.sh $ROM"
