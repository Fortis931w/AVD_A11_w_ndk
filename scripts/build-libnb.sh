#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/common.sh"
need_sdk

SOURCE="$REPO_ROOT/.cache/src/test_libnb"
NDK="$ANDROID_SDK_ROOT/ndk/28.2.13676358"
CMAKE="$ANDROID_SDK_ROOT/cmake/3.22.1/bin/cmake"
NINJA="$ANDROID_SDK_ROOT/cmake/3.22.1/bin/ninja"
[[ -f "$SOURCE/CMakeLists.txt" ]] || die 'run scripts/fetch-dependencies.sh first'
[[ -x "$CMAKE" ]] || die 'install SDK package cmake;3.22.1 first'
[[ -x "$NINJA" ]] || die 'install SDK package cmake;3.22.1 first'
[[ -f "$NDK/build/cmake/android.toolchain.cmake" ]] || die 'install SDK package ndk;28.2.13676358 first'

for arch in x86 x86_64; do
  out="$REPO_ROOT/build/libnb/$arch"
  rm -rf -- "$out"
  "$CMAKE" -S "$SOURCE" -B "$out" -G Ninja \
    -DANDROID_NDK_HOME="$NDK" \
    -DCOMPILE_ARCH="$arch" \
    -DNATIVEBRIDGE=houdini \
    -DNB_VERSION=11_38765 \
    -DCMAKE_BUILD_TYPE=Release
  "$CMAKE" --build "$out"
  [[ -f "$out/src/libnb.so" ]] || die "libnb output missing for $arch"
  cp "$out/src/libnb.so" "$out/libnb.so"
  sha256sum "$out/libnb.so"
done
