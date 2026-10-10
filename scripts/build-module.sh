#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need zip

UPSTREAM="$REPO_ROOT/.cache/src/libhoudini-package/src/system"
[[ -d "$UPSTREAM" ]] || die 'run scripts/fetch-dependencies.sh first'
[[ -f "$REPO_ROOT/build/libnb/x86/libnb.so" ]] || die 'run scripts/build-libnb.sh first'
[[ -f "$REPO_ROOT/build/libnb/x86_64/libnb.so" ]] || die 'run scripts/build-libnb.sh first'

OUT="$REPO_ROOT/build/houdini-module"
rm -rf -- "$OUT"
mkdir -p "$OUT"
cp -a "$REPO_ROOT/module/." "$OUT/"
cp -a "$UPSTREAM" "$OUT/system"
cp "$REPO_ROOT/build/libnb/x86/libnb.so" "$OUT/system/lib/libnb.so"
cp "$REPO_ROOT/build/libnb/x86_64/libnb.so" "$OUT/system/lib64/libnb.so"
chmod 0755 "$OUT/post-fs-data.sh" "$OUT/service.sh"
mkdir -p "$REPO_ROOT/dist"
rm -f "$REPO_ROOT/dist/houdini-magisk-module.zip"
(cd "$OUT" && zip -qr "$REPO_ROOT/dist/houdini-magisk-module.zip" .)
sha256sum "$REPO_ROOT/dist/houdini-magisk-module.zip"
