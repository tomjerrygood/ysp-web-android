# ysp-web-rs (Android ARM)

央视频 CMG 直播解密服务 - Android ARM 盒子版本

## 文件说明

| 文件 | 说明 |
|------|------|
| `iptv-rust-arm` | 编译好的 ARM32 (armv7) 可执行二进制文件 |
| `iptv-rust-arm64` | 编译好的 ARM64 (aarch64) 可执行二进制文件 |
| `channels.yaml` | 频道列表配置文件 |

> **注意**：已关闭 UPX 压缩并内置 WebPKI 根证书，优化了 WASM 算法并支持相对切片路径，确保在 Android 系统上运行时解密高效且网络地址自适应。

## 在 Android 9+ 盒子后台运行

### 1. 将文件推送到盒子

```bash
# 通过 adb 推送（根据盒子系统位数选择 iptv-rust-arm 或 iptv-rust-arm64）
adb push iptv-rust-arm /data/local/iptv-rust/iptv-rust-arm
adb push channels.yaml /data/local/iptv-rust/channels.yaml
```

### 2. 授权并启动 (作为后台 Daemon 常驻)

```bash
# 进入盒子 shell
adb shell

# 给二进制执行权限
chmod +x /data/local/iptv-rust/iptv-rust-arm

# 使用 start-stop-daemon 启动常驻后台（方式一，推荐）
busybox start-stop-daemon -S -b -x /data/local/iptv-rust/iptv-rust-arm -- --channels /data/local/iptv-rust/channels.yaml --host 0.0.0.0 --port 8787

# 或使用 nohup 启动（方式二）
nohup /data/local/iptv-rust/iptv-rust-arm --channels /data/local/iptv-rust/channels.yaml --host 0.0.0.0 --port 8787 > /data/local/iptv-rust/iptv-rust.log 2>&1 &
```

### 3. 验证运行状态

```bash
# 查看进程 (Android 9 上请使用 ps -A)
ps -A | grep iptv

# 测试接口
curl http://127.0.0.1:8787/health
curl http://127.0.0.1:8787/list.m3u
```

## API 接口

| 接口 | 说明 |
|------|------|
| `GET /list.m3u` | 返回完整 m3u 播放列表 |
| `GET /live/{channel}.m3u8` | 返回单个频道 m3u8 流 |
| `GET /segment/{ch}/{id}.ts` | 返回 ts 切片（解密后） |
| `GET /health` | 服务健康检查 |
| `GET /channels` | 频道列表（JSON） |

## 在 TVBox 中使用

TVBox 配置中添加接口地址：

```json
{
  "name": "央视频",
  "api": "http://你的盒子IP:8787",
  "url": "http://你的盒子IP:8787/list.m3u"
}
```

## 编译说明

GitHub Actions 会在每次 push 到 master 时自动编译，编译产物可通过以下方式获取：

1. 进入仓库 Actions 页面，选择最新 workflow run
2. 在 Artifacts 中下载 `iptv-rust-arm` (32位) 或 `iptv-rust-arm64` (64位)
3. 或直接访问 GitHub Releases 下载（workflow_dispatch 触发时生成）
