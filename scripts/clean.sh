#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
for target in "$REPO_ROOT/.cache" "$REPO_ROOT/build" "$REPO_ROOT/dist" "$REPO_ROOT/downloads"; do
  case "$target" in "$REPO_ROOT"/*) rm -rf -- "$target" ;; *) exit 1 ;; esac
done
find "$REPO_ROOT" -type f \( -name '*.log' -o -name '.DS_Store' -o -name 'Thumbs.db' \) -delete
printf 'Removed downloaded dependencies, build output, caches and logs.\n'
