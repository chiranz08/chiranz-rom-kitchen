#!/bin/bash
# Apply roms/<rom>/patches/<project path>/*.patch to a synced tree, then any post-*.sh steps.
# Usage: apply.sh <rom>
# Each patch series records its base commit; a project whose HEAD differs is reported, not forced.
set -e
source "$(dirname "$0")/common.sh"
load_rom "$1"
cd "$ROM_KITCHEN/patches"
find . -name '*.patch' -printf '%h\n' | sort -u | sed 's#^\./##' | while read -r path; do
    git_dir=$TREE/$path
    first=$(ls "$path"/*.patch | head -1)
    base=$(sed -n 's/^base-commit: //p' "$first")
    subject=$(git mailinfo /dev/null /dev/null < "$first" | sed -n 's/^Subject: //p')
    if git -C "$git_dir" log --format=%s "$base"..HEAD 2>/dev/null | grep -qxF "$subject"; then
        echo "= $path: already applied"; continue
    fi
    if [ "$(git -C "$git_dir" rev-parse HEAD)" != "$base" ]; then
        echo "! $path: HEAD is not the base commit $base (sync pinned, or rebase the patches)"; exit 1
    fi
    git -C "$git_dir" checkout -q -B "$(basename "$ROM_KITCHEN")-local"
    git -C "$git_dir" am -q -3 "$PWD/$path"/*.patch
    echo "+ $path: $(ls "$path"/*.patch | wc -l) patch(es)"
done

# Then post-*.sh steps (changes kept out of patches, e.g. binary deletions); each is idempotent.
find . -name 'post-*.sh' | sort | while read -r step; do
    path=$(dirname "${step#./}")
    (cd "$TREE/$path" && bash "$ROM_KITCHEN/patches/${step#./}") && echo "+ $path: ran $(basename "$step")"
done
