#!/system/bin/sh

LOGDIR=/data/adb/avd_houdini
mkdir -p "$LOGDIR"
mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc 2>/dev/null

if [ -w /proc/sys/fs/binfmt_misc/register ]; then
  echo ':arm_exe:M::\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28::/system/bin/houdini:P' > /proc/sys/fs/binfmt_misc/register 2>/dev/null
  echo ':arm_dyn:M::\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x28::/system/bin/houdini:P' > /proc/sys/fs/binfmt_misc/register 2>/dev/null
  echo ':arm64_exe:M::\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7::/system/bin/houdini64:P' > /proc/sys/fs/binfmt_misc/register 2>/dev/null
  echo ':arm64_dyn:M::\x7f\x45\x4c\x46\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\xb7::/system/bin/houdini64:P' > /proc/sys/fs/binfmt_misc/register 2>/dev/null
fi

{
  date
  getprop ro.product.cpu.abilist
  getprop ro.dalvik.vm.native.bridge
  ls -l /system/bin/houdini /system/bin/houdini64
} > "$LOGDIR/status.log" 2>&1
