#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)

if [[ -f "$REPO_ROOT/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$REPO_ROOT/.env"
  set +a
fi

ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}
AVD_NAME=${AVD_NAME:-Touken}
API_LEVEL=${API_LEVEL:-30}
SYSTEM_IMAGE_TAG=${SYSTEM_IMAGE_TAG:-default}
SYSTEM_IMAGE_ABI=${SYSTEM_IMAGE_ABI:-x86_64}
CPU_CORES=${CPU_CORES:-2}
RAM_MB=${RAM_MB:-2048}
DATA_SIZE=${DATA_SIZE:-10G}
LCD_WIDTH=${LCD_WIDTH:-1280}
LCD_HEIGHT=${LCD_HEIGHT:-720}
LCD_DENSITY=${LCD_DENSITY:-240}
EMULATOR_PORT=${EMULATOR_PORT:-5560}
SYSTEM_IMAGE_PACKAGE="system-images;android-${API_LEVEL};${SYSTEM_IMAGE_TAG};${SYSTEM_IMAGE_ABI}"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }
need_sdk() { [[ -n "$ANDROID_SDK_ROOT" ]] || die 'set ANDROID_SDK_ROOT or ANDROID_HOME'; }

sdk_tool() {
  local name=$1 candidate
  for candidate in \
    "$ANDROID_SDK_ROOT/platform-tools/$name" \
    "$ANDROID_SDK_ROOT/emulator/$name" \
    "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/$name" \
    "$ANDROID_SDK_ROOT/cmdline-tools/bin/$name" \
    "$ANDROID_SDK_ROOT/tools/bin/$name" \
    "$ANDROID_SDK_ROOT/$name/$name"; do
    [[ -x "$candidate" ]] && { printf '%s\n' "$candidate"; return; }
  done
  command -v "$name" 2>/dev/null || die "cannot find Android SDK tool: $name"
}

adb_for_avd() {
  "$(sdk_tool adb)" -s "emulator-${EMULATOR_PORT}" "$@"
}
