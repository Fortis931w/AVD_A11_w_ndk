#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk
need unzip

MAGISK="$REPO_ROOT/downloads/Magisk-v25.2.apk"
MODULE="$REPO_ROOT/build/houdini-module"
ASSETS="$REPO_ROOT/build/magisk-assets"
[[ -f "$MAGISK" ]] || die 'run scripts/fetch-dependencies.sh first'
[[ -d "$MODULE/system" ]] || die 'run scripts/build-module.sh first'

rm -rf -- "$ASSETS"
mkdir -p "$ASSETS"
unzip -q "$MAGISK" 'assets/*' 'lib/x86_64/*' -d "$ASSETS"

ADB=$(sdk_tool adb)
SERIAL="emulator-${EMULATOR_PORT}"
"$ADB" -s "$SERIAL" wait-for-device
until [[ $("$ADB" -s "$SERIAL" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r') == 1 ]]; do sleep 1; done
"$ADB" -s "$SERIAL" install -r "$MAGISK"
"$ADB" -s "$SERIAL" shell am start -n com.topjohnwu.magisk/.ui.MainActivity >/dev/null 2>&1 || true
sleep 3
"$ADB" -s "$SERIAL" root
"$ADB" -s "$SERIAL" wait-for-device
"$ADB" -s "$SERIAL" shell 'mkdir -p /data/adb/magisk /data/adb/modules/avd_houdini'
"$ADB" -s "$SERIAL" push "$ASSETS/assets/." /data/adb/magisk/
"$ADB" -s "$SERIAL" push "$ASSETS/lib/x86_64/libbusybox.so" /data/adb/magisk/busybox
"$ADB" -s "$SERIAL" push "$ASSETS/lib/x86_64/libmagiskboot.so" /data/adb/magisk/magiskboot
"$ADB" -s "$SERIAL" push "$ASSETS/lib/x86_64/libmagiskinit.so" /data/adb/magisk/magiskinit
"$ADB" -s "$SERIAL" push "$ASSETS/lib/x86_64/libmagiskpolicy.so" /data/adb/magisk/magiskpolicy
"$ADB" -s "$SERIAL" push "$MODULE/." /data/adb/modules/avd_houdini/
"$ADB" -s "$SERIAL" shell 'chmod 0755 /data/adb/magisk/* /data/adb/modules/avd_houdini/*.sh; chmod 0644 /data/adb/modules/avd_houdini/module.prop; sync'
"$ADB" -s "$SERIAL" reboot
"$ADB" -s "$SERIAL" wait-for-device
until [[ $("$ADB" -s "$SERIAL" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r') == 1 ]]; do sleep 1; done

BRIDGE=$("$ADB" -s "$SERIAL" shell getprop ro.dalvik.vm.native.bridge | tr -d '\r')
ABILIST=$("$ADB" -s "$SERIAL" shell getprop ro.product.cpu.abilist | tr -d '\r')
[[ "$BRIDGE" == libnb.so ]] || die "native bridge is not active: $BRIDGE"
[[ "$ABILIST" == *arm64-v8a* ]] || die "arm64-v8a missing from ABI list: $ABILIST"
printf 'Houdini active: bridge=%s ABI=%s\n' "$BRIDGE" "$ABILIST"
