#!/bin/bash
# Show what a flashable zip is: build fingerprint, signing certificate, hash. Usage: verify-zip.sh <zip>
set -e
ZIP=$1; [ -f "$ZIP" ] || { echo "usage: $0 <zip>" >&2; exit 2; }
unzip -p "$ZIP" META-INF/com/android/metadata | grep -E '^(post-build|post-sdk-level|post-security-patch-level|pre-device)='
echo -n "signed by: "; unzip -p "$ZIP" META-INF/com/android/otacert | openssl x509 -noout -subject
echo -n "sha256: "; sha256sum "$ZIP" | cut -d' ' -f1
