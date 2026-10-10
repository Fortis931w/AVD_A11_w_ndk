#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk

ROOTAVD="$REPO_ROOT/.cache/src/rootAVD"
MAGISK="$REPO_ROOT/downloads/Magisk-v25.2.apk"
RAMDISK="system-images/android-${API_LEVEL}/${SYSTEM_IMAGE_TAG}/${SYSTEM_IMAGE_ABI}/ramdisk.img"
[[ -x "$ROOTAVD/rootAVD.sh" ]] || die 'run scripts/fetch-dependencies.sh first'
[[ -f "$MAGISK" ]] || die 'run scripts/fetch-dependencies.sh first'
[[ -f "$ANDROID_SDK_ROOT/$RAMDISK" ]] || die "missing $ANDROID_SDK_ROOT/$RAMDISK"

cp -f "$MAGISK" "$ROOTAVD/Apps/Magisk.apk"
cp -f "$MAGISK" "$ROOTAVD/Magisk.zip"

printf 'Patching the shared system-image ramdisk. Stop every AVD using it first.\n'
(cd "$ROOTAVD" && ANDROID_HOME="$ANDROID_SDK_ROOT" ./rootAVD.sh "$RAMDISK")
