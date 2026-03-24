# Instruction Demo

## 说明
通过在 `.github/copilot-instructions.md` 中定义角色和规范，让 Copilot 在整个项目中自动遵循 SRE 最佳实践。

## 使用方法
在项目根目录创建 `.github/copilot-instructions.md`，所有聊天和代码建议都会遵循这些指令。

---

## 当前项目的 Instruction 文件

`.github/copilot-instructions.md` 内容:

```markdown
# Role: SRE Pipeline Team Member

- 优先考虑可观测性、自动化和可靠性。
- 在代码中添加日志和监控。
- 确保 CI/CD 管道的健壮性。
- 使用最佳实践编写脚本和配置。
- 关注性能和安全性。
```

---

## Instruction 的效果对比

### 无 Instruction 时，Copilot 生成:
```bash
#!/bin/bash
deploy() {
    echo "部署中..."
    scp build/* server:/app/
    echo "完成"
}
deploy
```

### 有 SRE Instruction 时，Copilot 自动生成:
```bash
#!/bin/bash
# deploy.sh — SRE 规范部署脚本
set -euo pipefail

LOG_FILE="/var/log/deploy.log"
DEPLOY_DIR="/app"
BACKUP_DIR="/app/backup"

log_info()  { echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO:  $*" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2; }

# 退出时自动回滚
rollback() {
    log_error "部署失败，执行回滚..."
    cp -r "$BACKUP_DIR"/* "$DEPLOY_DIR"/ && log_info "回滚成功" || log_error "回滚失败！"
}
trap rollback ERR

deploy() {
    log_info "开始部署 (用户: $(whoami), 主机: $(hostname))"

    # 备份当前版本
    mkdir -p "$BACKUP_DIR"
    cp -r "$DEPLOY_DIR"/* "$BACKUP_DIR"/ 2>/dev/null || true
    log_info "备份完成"

    # 执行部署
    scp build/* "server:$DEPLOY_DIR/"
    log_info "文件同步完成"

    # 健康检查
    sleep 2
    if curl -sf "http://server/health" &>/dev/null; then
        log_info "健康检查通过 ✓"
    else
        log_error "健康检查失败"
        return 1
    fi

    log_info "部署成功完成"
}

deploy
```

> Instruction 让 Copilot 自动添加：日志记录、错误处理、备份回滚、健康检查。

---

## GitHub Actions Workflow 例子

```yaml
name: Instruction Demo - SRE Deploy Pipeline

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      # Copilot 根据 instruction 建议在 workflow 中也加入可观测性
      - name: Log deploy metadata
        run: |
          echo "=== 部署信息 ==="
          echo "提交: ${{ github.sha }}"
          echo "分支: ${{ github.ref_name }}"
          echo "触发者: ${{ github.actor }}"
          echo "时间: $(date -u)"

      - name: Pre-deploy health check
        run: |
          echo "执行部署前检查..."
          # 检查必要工具
          command -v curl && echo "curl OK" || exit 1

      - name: Deploy
        run: |
          echo "[模拟] 执行部署..."
          # 这里是实际部署命令

      - name: Post-deploy validation
        run: |
          echo "执行部署后验证..."
          echo "验证通过 ✓"

      - name: Notify on success
        if: success()
        run: echo "✅ 部署成功: ${{ github.sha }}"

      - name: Notify on failure
        if: failure()
        run: echo "❌ 部署失败，请检查日志"
```

---

## 如何为不同角色定制 Instruction

```markdown
# 前端工程师
- 使用 TypeScript 而非 JavaScript
- 添加无障碍 (a11y) 属性

# 数据工程师
- SQL 查询需要添加注释说明业务逻辑
- 避免 SELECT *

# SRE 工程师（本项目当前配置）
- 所有脚本必须有 set -euo pipefail
- 添加日志函数 log_info / log_error
- 关键操作前后记录耗时
```
