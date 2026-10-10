#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk
SDKMANAGER=$(sdk_tool sdkmanager)
AVDMANAGER=$(sdk_tool avdmanager)

yes | "$SDKMANAGER" --licenses >/dev/null || true
"$SDKMANAGER" emulator platform-tools 'ndk;28.2.13676358' 'cmake;3.22.1' "$SYSTEM_IMAGE_PACKAGE"

if "$AVDMANAGER" list avd | grep -Fq "Name: $AVD_NAME"; then
  die "AVD $AVD_NAME already exists; remove it explicitly before rebuilding"
fi

printf 'no\n' | "$AVDMANAGER" create avd \
  --name "$AVD_NAME" --package "$SYSTEM_IMAGE_PACKAGE" --force

CONFIG="${ANDROID_AVD_HOME:-$HOME/.android/avd}/${AVD_NAME}.avd/config.ini"
[[ -f "$CONFIG" ]] || die "AVD config not found: $CONFIG"

set_key() {
  local key=$1 value=$2
  if grep -q "^${key}=" "$CONFIG"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$CONFIG"
  else
    printf '%s=%s\n' "$key" "$value" >> "$CONFIG"
  fi
}

set_key hw.cpu.ncore "$CPU_CORES"
set_key hw.ramSize "$RAM_MB"
set_key disk.dataPartition.size "$DATA_SIZE"
set_key hw.lcd.width "$LCD_WIDTH"
set_key hw.lcd.height "$LCD_HEIGHT"
set_key hw.lcd.density "$LCD_DENSITY"
set_key hw.initialOrientation landscape
set_key hw.gpu.enabled yes
set_key hw.gpu.mode auto
set_key PlayStore.enabled false
set_key fastboot.forceColdBoot yes
set_key fastboot.forceFastBoot no
set_key fastboot.forceChosenSnapshotBoot no
set_key fastboot.forceDefaultSnapshotBoot no
set_key snapshot.present no
set_key userdata.useQcow2 yes

printf 'Created %s using %s\n' "$AVD_NAME" "$SYSTEM_IMAGE_PACKAGE"
