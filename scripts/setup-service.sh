#!/bin/bash

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

# 获取项目路径
PROJECT_DIR=$(pwd)
echo "项目路径: $PROJECT_DIR"

# 创建 systemd 服务文件
cat > /etc/systemd/system/hackernews-cn-cron.service << EOL
[Unit]
Description=HackerNews CN Cron Service
After=network.target

[Service]
Type=simple
User=$(logname)
WorkingDirectory=$PROJECT_DIR
ExecStart=$(which node) $PROJECT_DIR/node_modules/.bin/ts-node --project $PROJECT_DIR/tsconfig.json $PROJECT_DIR/scripts/cron.ts
Restart=on-failure
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOL

# 重新加载 systemd
systemctl daemon-reload

# 启用并启动服务
systemctl enable hackernews-cn-cron.service
systemctl start hackernews-cn-cron.service

echo "服务已创建并启动。可以使用以下命令检查状态："
echo "systemctl status hackernews-cn-cron.service" 