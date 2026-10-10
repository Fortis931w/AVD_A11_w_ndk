#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need git
need curl
need sha256sum

mkdir -p "$REPO_ROOT/.cache/src" "$REPO_ROOT/downloads"

fetch_git() {
  local name=$1 url=$2 commit=$3 target
  target="$REPO_ROOT/.cache/src/$name"
  if [[ ! -d "$target/.git" ]]; then
    git clone --filter=blob:none --no-checkout "$url" "$target"
  fi
  git -C "$target" fetch --depth 1 origin "$commit"
  git -C "$target" checkout --detach --force "$commit"
}

fetch_git rootAVD https://github.com/newbit1/rootAVD.git c8638d0ee386017d9f1a0ed5247bb6f0749bbcff
fetch_git libhoudini-package https://github.com/natsumerinchan/libhoudini-package.git 4ff59840c8734603e3ebe525a6d2947bde6fef4e
fetch_git test_libnb https://github.com/qwerty12356-wart/test_libnb.git 4f89b1f622d83082bc644fc216a9d6c70d7df8f7

MAGISK="$REPO_ROOT/downloads/Magisk-v25.2.apk"
curl -fL --retry 3 -o "$MAGISK" \
  https://github.com/topjohnwu/Magisk/releases/download/v25.2/Magisk-v25.2.apk
printf '%s  %s\n' \
  0bdc32918b6ea502dca769b1c7089200da51ea1def170824c2812925b426d509 \
  "$MAGISK" | sha256sum -c -

printf 'Dependencies are ready.\n'
