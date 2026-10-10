#!/system/bin/sh

resetprop -n ro.product.cpu.abilist x86_64,arm64-v8a,x86
resetprop -n ro.product.cpu.abilist32 x86
resetprop -n ro.product.cpu.abilist64 x86_64,arm64-v8a
resetprop -n ro.system.product.cpu.abilist x86_64,arm64-v8a
resetprop -n ro.system.product.cpu.abilist32 x86
resetprop -n ro.system.product.cpu.abilist64 x86_64,arm64-v8a
resetprop -n ro.vendor.product.cpu.abilist x86_64,arm64-v8a
resetprop -n ro.vendor.product.cpu.abilist32 x86
resetprop -n ro.vendor.product.cpu.abilist64 x86_64,arm64-v8a
resetprop -n ro.odm.product.cpu.abilist x86_64,arm64-v8a
resetprop -n ro.odm.product.cpu.abilist32 x86
resetprop -n ro.odm.product.cpu.abilist64 x86_64,arm64-v8a
resetprop -n ro.dalvik.vm.native.bridge libnb.so
resetprop -n ro.enable.native.bridge.exec 1
resetprop -n ro.enable.native.bridge.exec64 1
resetprop -n ro.vendor.enable.native.bridge.exec64 1
resetprop -n ro.dalvik.vm.isa.arm64 x86_64
resetprop -n ro.zygote zygote64_32

LINKER_SRC=/linkerconfig/ld.config.txt
LINKER_DIR=/data/adb/avd_houdini
LINKER_DST=$LINKER_DIR/ld.config.txt

if [ -f "$LINKER_SRC" ]; then
  mkdir -p "$LINKER_DIR"
  cp "$LINKER_SRC" "$LINKER_DST"
  sed -i '/^namespace.default.permitted.paths =/a namespace.default.permitted.paths += /system/lib64/arm64\
namespace.default.permitted.paths += /system/lib/arm' "$LINKER_DST"
  chown root:root "$LINKER_DST"
  chmod 0644 "$LINKER_DST"
  chcon u:object_r:linkerconfig_file:s0 "$LINKER_DST"
  mount -o bind "$LINKER_DST" "$LINKER_SRC"
fi
