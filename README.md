# Android 11 x86_64 AVD Houdini Builder

在 Linux/AMD64 主机上建立 Android 11（API 30）x86_64 AOSP AVD，并通过
Magisk/systemless 模块加入 ARM64/ARM Houdini native bridge。该流程已验证可以让
只提供 `arm64-v8a` native library 的 APK 安装到 x86_64 AVD。

> 本项目不会绕过应用本身的完整性校验、反作弊或服务端限制。Houdini 也不保证
> 每个 ARM 应用都能运行；应用升级后仍可能因为 native code、DRM 或签名策略崩溃。

## 默认 AVD

- Android 11 / API 30 / `default;x86_64`
- 2 vCPU、2048 MB RAM、10 GB userdata
- 1280×720、240 dpi、landscape
- 快照完全关闭
- 启动 DNS：`223.5.5.5,119.29.29.29`

复制 `.env.example` 为 `.env` 即可修改全部参数。不要提交 `.env`（如果其中含本机路径）。

## 前置条件

- Linux x86_64，KVM 可用，带正常桌面显示会话
- Bash、Git、curl、unzip、zip、sha256sum
- Android command-line tools；设置 `ANDROID_SDK_ROOT`
- 至少约 15 GB 临时空间

不建议在已包含重要数据的 system-image 上执行修补。`rootAVD` 修改的是共享
`ramdisk.img`，所有引用同一 system-image 的 AVD 都会受到影响。

## 构建顺序

```bash
cp .env.example .env
./scripts/fetch-dependencies.sh
./scripts/install-sdk-and-create-avd.sh
./scripts/patch-system-image.sh
./scripts/build-libnb.sh
./scripts/build-module.sh
./scripts/make-launcher.sh
```

`patch-system-image.sh` 运行时不要启动任何引用该镜像的 AVD。修补完成后，通过带窗口
的启动器启动模拟器（不要加 `-no-window`）：

```bash
./dist/start-Touken.sh
```

首次进入桌面后，在另一个终端执行：

```bash
./scripts/install-houdini.sh
./scripts/configure-network.sh
./scripts/verify.sh
```

安装 ARM64 APK，但不自动启动应用：

```bash
APP_APK=/path/to/app.apk APP_ABI=arm64-v8a ./scripts/install-apk.sh
```

正常关闭：

```bash
adb -s emulator-5560 emu kill
```

## 发布前清理

执行：

```bash
./scripts/clean.sh
git status --short --ignored
```

清理脚本仅删除仓库内的以下可再生成内容：

- `.cache/`：固定提交的上游源码 checkout
- `downloads/`：Magisk APK 等下载文件
- `build/`：解包后的 Magisk 文件和组装中的模块目录
- `dist/`：生成的模块 ZIP 和启动器
- 日志以及常见系统缩略图文件

它不会删除 Android SDK、system-image、任何 AVD 或 userdata。仓库的 `.gitignore`
还排除了 APK、ZIP、IMG、QCOW2 和日志，避免误提交应用、用户数据或大型二进制。

## 第三方来源与许可证

- [rootAVD](https://github.com/newbit1/rootAVD)，固定提交
  `c8638d0ee386017d9f1a0ed5247bb6f0749bbcff`，GPL-3.0。
- [libhoudini-package](https://github.com/natsumerinchan/libhoudini-package/tree/Android11-x86_64)，
  固定提交 `4ff59840c8734603e3ebe525a6d2947bde6fef4e`；其集成源码声明为 Unlicense，
  但其中 Houdini/WSA 二进制仍可能受原权利人条款约束。
- [test_libnb](https://github.com/qwerty12356-wart/test_libnb)，固定提交
  `4f89b1f622d83082bc644fc216a9d6c70d7df8f7`，BSD-2-Clause；使用 NDK r28c
  从源码编译 Android 30 的 x86 与 x86_64 `libnb.so`。
- [Magisk 25.2](https://github.com/topjohnwu/Magisk/releases/tag/v25.2)，GPL-3.0。
- Android SDK/system-image 由 Google SDK Manager 下载，受各自 SDK 许可约束。

本仓库不再分发上述第三方二进制，只记录来源、固定版本和校验值。发布者和使用者
需要自行确认所在地区及发布平台允许下载、提取和使用 Houdini/WSA 文件。本仓库自身
编写的集成脚本使用 MIT License；该许可证不覆盖第三方组件。

## 已知边界

- 只针对 Android 11 / API 30 / x86_64 测试。
- 此方案依赖 Magisk 25.2 与特定 rootAVD/libhoudini 提交，不应静默升级依赖。
- `-gpu host` 需要可用的图形会话；远程机器请在实际桌面会话中启动。
- 多个 AVD 可以复用同一 system-image，但必须拥有各自 userdata 和模块安装状态。
