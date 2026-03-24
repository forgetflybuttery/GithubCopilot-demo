#!/bin/bash

# 改进的除法函数，添加了除零错误处理和日志记录
# 符合 SRE 原则：可观测性、自动化和可靠性

LOG_FILE="/tmp/divide.log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

divide() {
    log_info "执行除法运算: $1 / $2"

    # 输入验证
    if ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
        log_error "无效的被除数: $1"
        return 1
    fi

    if ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
        log_error "无效的除数: $2"
        return 1
    fi

    if [ "$2" -eq 0 ]; then
        log_error "除零错误: 除数不能为零"
        return 1
    fi

    local result=$(( $1 / $2 ))
    log_info "除法结果: $result"
    echo $result
    return 0
}

# 测试示例调用
echo "=== 除法函数测试 ==="

echo "测试正常情况 (10 / 2):"
divide 10 2
echo "退出码: $?"
echo

echo "测试除零情况 (10 / 0):"
divide 10 0
echo "退出码: $?"
echo

echo "测试无效输入 (abc / 2):"
divide "abc" 2
echo "退出码: $?"
echo

echo "=== 日志内容 ==="
if [ -f "$LOG_FILE" ]; then
    cat "$LOG_FILE"
else
    echo "日志文件不存在"
fi
