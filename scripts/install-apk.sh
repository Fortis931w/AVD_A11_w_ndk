#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk
APP_APK=${APP_APK:-${1:-}}
APP_ABI=${APP_ABI:-arm64-v8a}
[[ -f "$APP_APK" ]] || die 'set APP_APK or pass an APK path as the first argument'
adb_for_avd install --abi "$APP_ABI" "$APP_APK"
