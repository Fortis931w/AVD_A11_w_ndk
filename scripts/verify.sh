#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk
printf 'boot_completed=%s\n' "$(adb_for_avd shell getprop sys.boot_completed | tr -d '\r')"
printf 'native_bridge=%s\n' "$(adb_for_avd shell getprop ro.dalvik.vm.native.bridge | tr -d '\r')"
printf 'abilist=%s\n' "$(adb_for_avd shell getprop ro.product.cpu.abilist | tr -d '\r')"
adb_for_avd shell wm size
adb_for_avd shell wm density
adb_for_avd shell nproc
adb_for_avd shell awk '/MemTotal/ { print }' /proc/meminfo
