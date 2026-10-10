# Contributing

提交前运行 `./scripts/clean.sh`，然后确认 `git status --short --ignored` 中不存在 APK、
system-image、userdata、日志、下载缓存或构建目录。不要提交游戏 APK、账号数据、密钥、
`.env`、AVD 快照和第三方 Houdini/WSA 二进制。

依赖升级必须同步更新 `dependencies.lock`、下载脚本中的固定提交或版本、SHA-256，
并重新完成 libnb 双架构编译、API 30 x86_64 AVD 的启动、native bridge、ABI 列表和
ARM64 APK 安装测试。
