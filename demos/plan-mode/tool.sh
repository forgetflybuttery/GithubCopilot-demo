#!/bin/bash
# Plan Mode Demo: 多子命令 Bash 工具脚本
# 由 Copilot Plan Mode 规划，Agent Mode 生成
set -euo pipefail

LOG_FILE="/tmp/tool.log"
VERBOSE=false
DRY_RUN=false

# ── 日志函数 ─────────────────────────────────────────────
log_info()  { echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO:  $*" | tee -a "$LOG_FILE"; }
log_ok()    { echo "[$(date +'%Y-%m-%d %H:%M:%S')] OK:    $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2; }
log_debug() { $VERBOSE && echo "[$(date +'%Y-%m-%d %H:%M:%S')] DEBUG: $*" >&2 || true; }

# ── 退出清理 ─────────────────────────────────────────────
cleanup() {
    log_debug "清理临时文件..."
}
trap cleanup EXIT

# ── 使用说明 ─────────────────────────────────────────────
usage() {
    cat <<EOF
用法: $(basename "$0") <命令> [选项]

命令:
  check     检查运行环境和依赖
  build     构建/打包项目
  deploy    部署项目

选项:
  -v, --verbose   详细输出
  -n, --dry-run   模拟执行，不实际运行
  -h, --help      显示帮助

示例:
  $(basename "$0") check
  $(basename "$0") build --verbose
  $(basename "$0") deploy --dry-run
EOF
}

# ── 子命令: check ────────────────────────────────────────
cmd_check() {
    log_info "开始环境检查..."
    local failed=0

    check_item() {
        local name=$1; local cmd=$2
        if $DRY_RUN; then
            log_info "[DRY-RUN] 跳过检查: $name"
        elif eval "$cmd" &>/dev/null; then
            log_ok "$name"
        else
            log_error "$name 检查失败"
            failed=$((failed + 1))
        fi
    }

    check_item "Bash >= 4"       "[ \"${BASH_VERSINFO[0]}\" -ge 4 ]"
    check_item "/tmp 可写"       "[ -w /tmp ]"
    check_item "git 已安装"      "command -v git"
    check_item "curl 已安装"     "command -v curl"

    if [ $failed -gt 0 ]; then
        log_error "环境检查失败: $failed 项不通过"
        return 1
    fi
    log_ok "所有环境检查通过"
}

# ── 子命令: build ────────────────────────────────────────
cmd_build() {
    log_info "开始构建..."
    if $DRY_RUN; then
        log_info "[DRY-RUN] 模拟构建步骤"
        return 0
    fi
    log_info "执行构建步骤 1/3: 验证源文件..."
    log_info "执行构建步骤 2/3: 编译/打包..."
    log_info "执行构建步骤 3/3: 生成产物..."
    log_ok "构建成功"
}

# ── 子命令: deploy ───────────────────────────────────────
cmd_deploy() {
    log_info "开始部署..."
    if $DRY_RUN; then
        log_info "[DRY-RUN] 模拟部署步骤（不会实际部署）"
        return 0
    fi
    log_info "执行部署步骤 1/2: 推送构建产物..."
    log_info "执行部署步骤 2/2: 重启服务..."
    log_ok "部署成功"
}

# ── 参数解析 ─────────────────────────────────────────────
CMD=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        check|build|deploy) CMD="$1"; shift ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -n|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *) log_error "未知参数: $1"; usage; exit 1 ;;
    esac
done

[ -z "$CMD" ] && { usage; exit 1; }

case "$CMD" in
    check)  cmd_check ;;
    build)  cmd_build ;;
    deploy) cmd_deploy ;;
esac
