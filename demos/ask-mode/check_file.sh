#!/bin/bash
# Ask Mode Demo: 由 Copilot 根据自然语言提问生成
# 场景: 文件检查工具，包含日志记录、权限验证和批量处理

LOG_FILE="/tmp/file_check.log"

# ── 日志函数 ──────────────────────────────────────
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

# ── 单文件检查 ───────────────────────────────────
# 检查文件是否存在且可读
# 用法: check_file <文件路径>
check_file() {
    local file=$1
    log_info "检查文件: $file"

    if [ -z "$file" ]; then
        log_error "未提供文件名"
        return 1
    fi

    if [ ! -f "$file" ]; then
        log_error "文件 '$file' 不存在"
        return 1
    fi

    if [ ! -r "$file" ]; then
        log_error "文件 '$file' 无读取权限"
        return 1
    fi

    log_info "文件 '$file' 检查通过"
    return 0
}

# ── 批量检查 ─────────────────────────────────────
# 批量检查多个文件，返回失败数量
# 用法: check_files_batch <文件1> <文件2> ...
check_files_batch() {
    local files=("$@")
    local failed=0

    log_info "开始批量检查 ${#files[@]} 个文件"

    for file in "${files[@]}"; do
        if ! check_file "$file"; then
            failed=$((failed + 1))
        fi
    done

    if [ $failed -gt 0 ]; then
        log_error "批量检查完成: $failed/${#files[@]} 个文件失败"
        return 1
    fi

    log_info "批量检查完成: 全部 ${#files[@]} 个文件通过"
    return 0
}

# ── 主逻辑 ───────────────────────────────────────
echo "=== 文件检查工具 ==="

if [ $# -gt 0 ]; then
    # 命令行指定文件时，批量检查
    check_files_batch "$@"
else
    # 默认演示
    echo "\n--- 测试单文件 ---"
    check_file "/etc/hosts"
    echo "退出码: $?\n"

    check_file "/tmp/not_exist.txt"
    echo "退出码: $?\n"

    echo "--- 测试批量文件 ---"
    check_files_batch "/etc/hosts" "/etc/passwd" "/tmp/missing.txt"
    echo "退出码: $?\n"
fi

echo "\n=== 日志内容 ==="
[ -f "$LOG_FILE" ] && cat "$LOG_FILE" || echo "(无日志)"
