#!/bin/bash

# 获取项目路径
PROJECT_DIR=$(pwd)
echo "项目路径: $PROJECT_DIR"

# 创建 launchd plist 文件
cat > ~/Library/LaunchAgents/com.hackernews-cn.cron.plist << EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hackernews-cn.cron</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which node)</string>
        <string>${PROJECT_DIR}/node_modules/.bin/ts-node</string>
        <string>--project</string>
        <string>${PROJECT_DIR}/tsconfig.json</string>
        <string>${PROJECT_DIR}/scripts/cron.ts</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>${PROJECT_DIR}</string>
    <key>StandardErrorPath</key>
    <string>${PROJECT_DIR}/logs/cron-error.log</string>
    <key>StandardOutPath</key>
    <string>${PROJECT_DIR}/logs/cron-output.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        <key>NODE_ENV</key>
        <string>production</string>
    </dict>
</dict>
</plist>
EOL

# 创建日志目录
mkdir -p ${PROJECT_DIR}/logs

# 加载 launchd 服务
launchctl load ~/Library/LaunchAgents/com.hackernews-cn.cron.plist

echo "服务已创建并启动。"
echo "查看日志: tail -f ${PROJECT_DIR}/logs/cron-output.log"
echo "停止服务: launchctl unload ~/Library/LaunchAgents/com.hackernews-cn.cron.plist" 