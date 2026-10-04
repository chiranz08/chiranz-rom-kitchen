#!/bin/bash
# Generate a fresh release key set for a ROM from its keys template. Usage: KEY_SUBJECT='/O=me/CN=me' make-keys.sh <rom>
# Keys stay in the tree only. Back them up encrypted somewhere else; never commit them.
# Changing keys on a phone needs a data wipe once.
set -e
source "$(dirname "$0")/common.sh"
load_rom "$1"
[ -n "$KEY_SUBJECT" ] || { echo "set KEY_SUBJECT, e.g. '/O=name/CN=name'" >&2; exit 2; }
cd "$TREE"
[ -e "$KEYS_DIR" ] && { echo "$KEYS_DIR already exists; not touching it" >&2; exit 1; }
umask 077
git clone -q "$KEYS_TEMPLATE" "$KEYS_DIR"
cd "$KEYS_DIR"
# The template ships a public releasekey: never sign with it.
rm -rf .git releasekey.pk8 releasekey.x509.pem
sed -i "s#'/C=US/[^']*'#'$KEY_SUBJECT'#" make_key.sh
./keys.sh </dev/null >/dev/null 2>&1 || true
./make_key.sh releasekey </dev/null >/dev/null 2>&1 || true
echo "$(ls ./*.pk8 | wc -l) keys in $TREE/$KEYS_DIR"
