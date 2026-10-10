#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk
mkdir -p "$REPO_ROOT/dist"
LAUNCHER="$REPO_ROOT/dist/start-${AVD_NAME}.sh"
cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash
exec "$ANDROID_SDK_ROOT/emulator/emulator" -avd "$AVD_NAME" -port "$EMULATOR_PORT" \\
  -gpu host -memory "$RAM_MB" -dns-server 223.5.5.5,119.29.29.29 \\
  -no-snapshot -no-snapshot-save -no-snapshot-load "\$@"
EOF
chmod +x "$LAUNCHER"
printf '%s\n' "$LAUNCHER"
