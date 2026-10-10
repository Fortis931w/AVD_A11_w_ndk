#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk
adb_for_avd shell settings put global captive_portal_mode 1
adb_for_avd shell settings put global captive_portal_use_https 0
adb_for_avd shell settings put global captive_portal_http_url http://connect.rom.miui.com/generate_204
adb_for_avd shell settings put global captive_portal_https_url https://connect.rom.miui.com/generate_204
adb_for_avd shell settings put global captive_portal_fallback_url http://connectivitycheck.platform.hicloud.com/generate_204
adb_for_avd shell svc data disable
