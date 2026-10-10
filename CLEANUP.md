# 清理与发布检查

## 自动清理

在仓库根目录执行：

```bash
./scripts/clean.sh
```

脚本只会删除仓库目录内可重新生成的 `.cache/`、`downloads/`、`build/`、`dist/`，
以及日志和系统缩略图。它不会访问或删除 Android SDK、`~/.android/avd`、userdata、
system-image 或仓库以外的文件。

## 发布前人工检查

```bash
git status --short --ignored
git ls-files '*.apk' '*.zip' '*.img' '*.qcow2' '*.log'
git diff --cached --check
```

第二条命令应无输出。确认没有提交以下内容：

- 游戏或 Magisk APK
- Houdini/WSA 二进制和生成的模块 ZIP
- Android SDK、system-image、ramdisk 和 userdata
- AVD snapshot、cache、日志、账号数据或 SSH/签名密钥
- 本机 `.env`

`.gitignore` 是最后一道防线，不能替代发布前检查。若将来确实需要发布大型构建产物，
应使用 GitHub Release 并同时发布来源、版本与 SHA-256，不应直接放入 Git 历史。

## 删除实际 AVD 或镜像

本仓库故意不提供自动删除 AVD/system-image 的命令，因为一个 system-image 可以被多个
AVD 共用。删除前必须检查每个 `config.ini` 的 `image.sysdir.1`；只在确认没有任何 AVD
引用后，才使用 SDK Manager 卸载对应 package。
