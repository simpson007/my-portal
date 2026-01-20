#!/bin/bash
set -e

# ==========================================
#  SmartMarks 服务器一键部署脚本
#  用法: 
#    首次部署: ./server-deploy.sh --init
#    更新部署: ./server-deploy.sh
#    仅构建:   ./server-deploy.sh --build-only
# ==========================================

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量 (根据实际情况修改)
APP_NAME="smartmarks"
DEPLOY_PATH="/opt/SmartMarks"
GIT_REPO="https://github.com/your-username/SmartMarks.git"  # 修改为你的仓库地址
DOMAIN="tools.yushenjian.com"
PORT=3001

# 日志函数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查必要工具
check_dependencies() {
    log_info "检查系统依赖..."
    
    local missing=()
    
    if ! command -v docker &> /dev/null; then
        missing+=("docker")
    fi
    
    if ! command -v git &> /dev/null; then
        missing+=("git")
    fi
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "缺少必要工具: ${missing[*]}"
        log_info "请先安装: apt update && apt install -y ${missing[*]}"
        exit 1
    fi
    
    # 检查 docker compose
    if ! docker compose version &> /dev/null; then
        log_error "Docker Compose 未安装或版本过低"
        log_info "请安装 Docker Compose V2"
        exit 1
    fi
    
    log_success "依赖检查通过"
}

# 首次部署初始化
init_deploy() {
    log_info "========== 首次部署初始化 =========="
    
    check_dependencies
    
    # 创建部署目录
    if [ -d "$DEPLOY_PATH" ]; then
        log_warn "目录 $DEPLOY_PATH 已存在"
        read -p "是否删除并重新克隆? (y/N): " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            rm -rf "$DEPLOY_PATH"
        else
            log_info "跳过克隆，使用现有目录"
            cd "$DEPLOY_PATH"
            git pull
            build_and_start
            return
        fi
    fi
    
    # 克隆仓库
    log_info "克隆代码仓库..."
    git clone "$GIT_REPO" "$DEPLOY_PATH"
    cd "$DEPLOY_PATH"
    
    # 配置 Nginx (如果需要)
    setup_nginx
    
    # 构建并启动
    build_and_start
    
    log_success "========== 首次部署完成 =========="
}

# 配置宿主机 Nginx
setup_nginx() {
    log_info "配置 Nginx..."
    
    if [ -f "/etc/nginx/sites-available/${APP_NAME}.conf" ]; then
        log_warn "Nginx 配置已存在，跳过"
        return
    fi
    
    if [ ! -d "/etc/nginx/sites-available" ]; then
        log_warn "Nginx 未安装或目录结构不同，跳过 Nginx 配置"
        return
    fi
    
    # 复制配置文件
    cp deploy/nginx/smartmarks.conf /etc/nginx/sites-available/${APP_NAME}.conf
    
    # 创建软链接
    if [ ! -f "/etc/nginx/sites-enabled/${APP_NAME}.conf" ]; then
        ln -s /etc/nginx/sites-available/${APP_NAME}.conf /etc/nginx/sites-enabled/
    fi
    
    # 测试并重载 Nginx
    nginx -t && systemctl reload nginx
    log_success "Nginx 配置完成"
}

# 构建并启动容器
build_and_start() {
    log_info "构建 Docker 镜像..."
    docker compose build --no-cache
    
    log_info "停止旧容器..."
    docker compose down 2>/dev/null || true
    
    log_info "启动新容器..."
    docker compose up -d
    
    # 等待服务启动
    log_info "等待服务启动..."
    sleep 8
    
    # 健康检查
    health_check
}

# 健康检查
health_check() {
    log_info "执行健康检查..."
    
    local max_retries=5
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        if curl -sf http://localhost:${PORT}/health > /dev/null 2>&1; then
            log_success "健康检查通过!"
            log_success "服务已启动: http://localhost:${PORT}"
            [ -n "$DOMAIN" ] && log_success "域名访问: https://${DOMAIN}/SmartMarks"
            return 0
        fi
        
        retry=$((retry + 1))
        log_warn "健康检查失败，重试 ($retry/$max_retries)..."
        sleep 3
    done
    
    log_error "健康检查失败!"
    log_info "查看日志: docker compose logs --tail=50"
    docker compose logs --tail=30
    exit 1
}

# 更新部署
update_deploy() {
    log_info "========== 更新部署 =========="
    
    if [ ! -d "$DEPLOY_PATH" ]; then
        log_error "部署目录不存在: $DEPLOY_PATH"
        log_info "请先运行: ./server-deploy.sh --init"
        exit 1
    fi
    
    cd "$DEPLOY_PATH"
    
    # 拉取最新代码
    log_info "拉取最新代码..."
    git fetch origin
    git reset --hard origin/main  # 或 master，根据你的分支名
    
    # 构建并启动
    build_and_start
    
    # 清理旧镜像
    log_info "清理旧镜像..."
    docker image prune -f
    
    log_success "========== 更新部署完成 =========="
}

# 仅构建（不拉取代码）
build_only() {
    log_info "========== 仅构建模式 =========="
    
    if [ ! -d "$DEPLOY_PATH" ]; then
        log_error "部署目录不存在: $DEPLOY_PATH"
        exit 1
    fi
    
    cd "$DEPLOY_PATH"
    build_and_start
    
    log_success "========== 构建完成 =========="
}

# 显示状态
show_status() {
    log_info "========== 服务状态 =========="
    docker compose ps
    echo ""
    log_info "最近日志:"
    docker compose logs --tail=20
}

# 显示帮助
show_help() {
    echo "SmartMarks 服务器部署脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --init        首次部署（克隆仓库、配置环境）"
    echo "  --build-only  仅重新构建（不拉取代码）"
    echo "  --status      查看服务状态"
    echo "  --logs        查看实时日志"
    echo "  --stop        停止服务"
    echo "  --restart     重启服务"
    echo "  -h, --help    显示帮助"
    echo ""
    echo "默认（无参数）: 拉取最新代码并重新部署"
}

# 主入口
case "${1:-}" in
    --init)
        init_deploy
        ;;
    --build-only)
        build_only
        ;;
    --status)
        cd "$DEPLOY_PATH" 2>/dev/null || { log_error "部署目录不存在"; exit 1; }
        show_status
        ;;
    --logs)
        cd "$DEPLOY_PATH" 2>/dev/null || { log_error "部署目录不存在"; exit 1; }
        docker compose logs -f
        ;;
    --stop)
        cd "$DEPLOY_PATH" 2>/dev/null || { log_error "部署目录不存在"; exit 1; }
        docker compose down
        log_success "服务已停止"
        ;;
    --restart)
        cd "$DEPLOY_PATH" 2>/dev/null || { log_error "部署目录不存在"; exit 1; }
        docker compose restart
        health_check
        ;;
    -h|--help)
        show_help
        ;;
    "")
        update_deploy
        ;;
    *)
        log_error "未知选项: $1"
        show_help
        exit 1
        ;;
esac
