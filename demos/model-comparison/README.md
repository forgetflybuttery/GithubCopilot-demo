# Model Comparison Demo

## 说明
不同模型在代码生成质量、速度和成本上有显著差异。这个演示通过一个相同的 Bash 任务，对比不同模型的输出质量。

---

## 任务: "写一个部署脚本，包含错误处理"

### 轻量模型 (GPT-4o mini / GPT-5.4 mini)
**特点**: 快速、低成本，适合简单任务

```bash
#!/bin/bash
deploy() {
    echo "部署中..."
    scp build/* server:/app/
    if [ $? -ne 0 ]; then
        echo "Error: deploy failed" >&2
        return 1
    fi
    echo "完成"
}
deploy
```

> 优点: 响应快、Token 消耗少  
> 缺点: 缺少日志、无回滚、无健康检查

---

### 标准模型 (GPT-4o / Claude Sonnet)
**特点**: 准确度高、上下文理解强，适合日常开发

```bash
#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/deploy.log"

log_info()  { echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO:  $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2; }

deploy() {
    local target_server=${1:-"server"}
    local deploy_dir=${2:-"/app"}

    log_info "开始部署 -> $target_server:$deploy_dir"

    if [ ! -d "build" ]; then
        log_error "build 目录不存在，请先执行构建"
        return 1
    fi

    scp -r build/* "$target_server:$deploy_dir/" || {
        log_error "文件传输失败"
        return 1
    }

    log_info "部署完成"
}

deploy "$@"
```

> 优点: 有日志、参数化、基础错误处理  
> 缺点: 无自动回滚

---

### 高级模型 (GPT-5 / Claude Opus)
**特点**: 最高质量，适合复杂架构和生产级代码

```bash
#!/bin/bash
# deploy.sh — 生产级部署脚本
# 包含: 日志、备份、回滚、健康检查、通知
set -euo pipefail

# ── 配置（避免硬编码，使用环境变量）─────────────────────
TARGET_SERVER="${DEPLOY_SERVER:-server}"
DEPLOY_DIR="${DEPLOY_DIR:-/app}"
BACKUP_DIR="${BACKUP_DIR:-/app/backup}"
HEALTH_URL="${HEALTH_URL:-http://server/health}"
LOG_FILE="${LOG_FILE:-/var/log/deploy.log}"
MAX_HEALTH_RETRIES=5

# ── 日志 ─────────────────────────────────────────────────
log_info()  { echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO:  $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2; }
log_ok()    { echo "[$(date +'%Y-%m-%d %H:%M:%S')] OK:    $*" | tee -a "$LOG_FILE"; }

# ── 回滚 ─────────────────────────────────────────────────
rollback() {
    log_error "部署失败，尝试回滚..."
    if ssh "$TARGET_SERVER" "[ -d $BACKUP_DIR ] && cp -r $BACKUP_DIR/* $DEPLOY_DIR/"; then
        log_ok "回滚成功"
    else
        log_error "回滚失败！请手动检查 $TARGET_SERVER:$DEPLOY_DIR"
    fi
}
trap rollback ERR

# ── 健康检查 ─────────────────────────────────────────────
health_check() {
    log_info "健康检查: $HEALTH_URL"
    local retries=0
    while [ $retries -lt $MAX_HEALTH_RETRIES ]; do
        if curl -sf "$HEALTH_URL" &>/dev/null; then
            log_ok "健康检查通过 (尝试 $((retries+1))/$MAX_HEALTH_RETRIES)"
            return 0
        fi
        retries=$((retries + 1))
        log_info "健康检查失败，等待重试 ($retries/$MAX_HEALTH_RETRIES)..."
        sleep 5
    done
    log_error "健康检查最终失败"
    return 1
}

# ── 部署 ─────────────────────────────────────────────────
deploy() {
    log_info "部署开始 (提交: ${GIT_SHA:-未知}, 操作者: $(whoami))"

    # 备份
    log_info "备份当前版本..."
    ssh "$TARGET_SERVER" "mkdir -p $BACKUP_DIR && cp -r $DEPLOY_DIR/* $BACKUP_DIR/ 2>/dev/null || true"
    log_ok "备份完成"

    # 传输
    log_info "传输文件..."
    scp -r build/* "$TARGET_SERVER:$DEPLOY_DIR/"
    log_ok "文件传输完成"

    # 验证
    health_check

    log_ok "部署成功完成 ✓"
}

deploy
```

> 优点: 生产级质量，包含所有 SRE 最佳实践

---

## 模型选择建议

| 场景 | 推荐模型 | 原因 |
|------|---------|------|
| 快速原型、简单 Bash 函数 | GPT-5.4 mini | 速度快、成本低 |
| 日常开发、代码审查 | GPT-4o / Claude Sonnet | 准确性好 |
| 复杂架构、生产代码 | GPT-5 / Claude Opus | 最高质量 |
| 长文件理解 | Claude Sonnet (200k context) | 超长上下文 |
| 实时代码补全 | 自动选择 (Auto) | 自动匹配最优 |

---

