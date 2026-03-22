# Instruction Demo

## 文件位置
`.github/copilot-instructions.md`

## 使用方法
创建自定义指令文件，定义 Copilot 的行为。

## 示例内容

```markdown
# Role: SRE Pipeline Team Member

- 始终添加日志记录。
- 确保代码的可观测性。
- 使用自动化工具。
- 优先考虑可观测性、自动化和可靠性。
- 在代码中添加日志和监控。
- 确保 CI/CD 管道的健壮性。
```

## 使用效果
在代码编写时，Copilot 会自动建议添加日志。

## 示例应用

当用户编写 Bash 脚本时，Copilot 会根据 instruction 自动建议：

```bash
#!/bin/bash

# 添加日志记录
LOG_FILE="/var/log/script.log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

# 主逻辑
log_info "脚本开始执行"

# ... 业务逻辑 ...

log_info "脚本执行完成"
```

## 优势
- 统一的代码风格
- 自动应用最佳实践
- 提高代码质量
- 团队协作更高效
