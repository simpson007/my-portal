#!/bin/bash
set -e

# SmartMarks 部署脚本
# 使用方法: ./deploy.sh

echo "=========================================="
echo "  SmartMarks 部署脚本"
echo "=========================================="

# 配置变量 (根据实际情况修改)
SERVER_IP="101.43.42.250"
SERVER_USER="root"
DEPLOY_PATH="/opt/SmartMarks"

# 提交代码
echo "[1/4] 提交代码到 Git..."
git add .
git commit -m "deploy: update" || echo "没有新的更改需要提交"
git push || echo "推送失败，请检查远程仓库配置"

# SSH 到服务器执行部署
echo "[2/4] 连接服务器并部署..."
ssh ${SERVER_USER}@${SERVER_IP} << 'EOF'
cd /opt/SmartMarks

echo "[3/4] 拉取最新代码..."
git pull

echo "[4/4] 重新构建并启动容器..."
docker compose down
docker compose build --no-cache
docker compose up -d

# 等待服务启动
sleep 10

# 健康检查
echo "执行健康检查..."
if curl -f http://localhost:3001/health > /dev/null 2>&1; then
    echo "✅ 部署成功! 服务已启动"
    echo "访问地址: https://tools.yushenjian.com/SmartMarks"
else
    echo "❌ 健康检查失败，请检查日志"
    docker compose logs --tail=50
    exit 1
fi
EOF

echo "=========================================="
echo "  部署完成!"
echo "=========================================="
