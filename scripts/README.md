# 定时任务脚本

本目录包含用于替代 Vercel Cron 功能的脚本。

## 脚本说明

- `cron.js`: 主要的定时任务脚本，使用 node-cron 定时运行 API 接口
- `setup-service.sh`: Linux 系统下设置 systemd 服务的脚本
- `setup-launchd.sh`: macOS 系统下设置 launchd 服务的脚本

## 环境变量配置

请确保在根目录 `.env` 文件中设置以下环境变量：

```
NEXT_PUBLIC_APP_URL="http://your-domain.com"  # 应用 URL
CRON_SECRET="your-secret-key"                 # 安全密钥
CRON_SCHEDULE="0 * * * *"                     # 可选，Cron 调度表达式，默认每小时运行一次
```

## 使用方法

### 1. 安装依赖

```bash
npm install
# 或
pnpm install
```

### 2. 手动运行（测试）

```bash
# 使用 npm
npm run cron -- --run-now

# 使用 pnpm
pnpm cron --run-now

# 直接使用 node
node scripts/cron.js --run-now
```

### 3. 设置为系统服务

#### Linux（systemd）:

```bash
sudo ./scripts/setup-service.sh
```

启动后，可以使用以下命令查看状态：
```bash
systemctl status hackernews-cn-cron.service
```

#### macOS（launchd）:

```bash
./scripts/setup-launchd.sh
```

启动后，日志会保存在 `./logs/` 目录。

### 自定义 Cron 调度

可以在 `.env` 文件中设置 `CRON_SCHEDULE` 环境变量来自定义调度表达式。默认为 `0 * * * *`（每小时运行一次）。

Cron 表达式格式如下：
```
┌────────────── 分钟 (0-59)
│ ┌──────────── 小时 (0-23)
│ │ ┌────────── 日 (1-31)
│ │ │ ┌──────── 月 (1-12)
│ │ │ │ ┌────── 星期 (0-7) (0 或 7 表示星期日)
│ │ │ │ │
│ │ │ │ │
* * * * *
```

常用例子：
- `*/15 * * * *` - 每 15 分钟运行一次
- `0 */2 * * *` - 每 2 小时运行一次
- `0 0 * * *` - 每天午夜运行