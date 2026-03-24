#!/bin/bash
# Agent Mode Demo: 系统健康检查脚本
# Copilot Agent 可自动执行此脚本并分析结果

LOG_FILE="/tmp/agent_health.log"
FAILURES=0
PASSED=0

# ── 日志函数 ──────────────────────────────────────
log_info()  { echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO:  $*" | tee -a "$LOG_FILE"; }
log_ok()    { echo "[$(date +'%Y-%m-%d %H:%M:%S')] OK:    $*" | tee -a "$LOG_FILE"; }
log_fail()  { echo "[$(date +'%Y-%m-%d %H:%M:%S')] FAIL:  $*" | tee -a "$LOG_FILE" >&2; }

# ── 检查项封装 ─────────────────────────────────
run_check() {
    local name=$1
    local cmd=$2

    if eval "$cmd" &>/dev/null; then
        log_ok "$name"
        PASSED=$((PASSED + 1))
    else
        log_fail "$name"
        FAILURES=$((FAILURES + 1))
    fi
}

# ── 检查项目 ────────────────────────────────────
log_info "Agent Mode 系统健康检查开始"
log_info "时间: $(date)"
log_info "主机: $(hostname)"
log_info "用户: $(whoami)"
log_info "工作目录: $(pwd)"

echo ""
log_info "--- 基础环境检查 ---"
run_check "/tmp 可写"           "[ -w /tmp ]"
run_check "Bash 版本 >= 4"       "[ \"${BASH_VERSINFO[0]}\" -ge 4 ]"
run_check "内存可用"             "free -m | awk '/^Mem:/{exit ($4<50)}'" 
run_check "磁盘空间充足"         "[ \"$(df / | awk 'NR==2{print $5}' | tr -d '%')\" -lt 90 ]"

echo ""
log_info "--- 脚本文件检查 ---"
run_check "ask-mode/check_file.sh 存在"  "[ -f demos/ask-mode/check_file.sh ]"
run_check "edit-mode/divide.sh 存在"     "[ -f demos/edit-mode/divide.sh ]"
run_check "agent-mode/test.sh 存在"      "[ -f demos/agent-mode/test.sh ]"

# ── 汇总 ──────────────────────────────────────────
echo ""
log_info "=== 检查结果: $PASSED 通过, $FAILURES 失败 ==="

[ $FAILURES -eq 0 ] && exit 0 || exit 1
