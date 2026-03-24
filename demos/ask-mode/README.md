# Ask Mode Demo

## 场景
通过自然语言提问，让 Copilot 生成 Bash 脚本和工具函数。这个演示展示了 Ask Mode 的多轮对话能力。

## 使用方法
- **快捷键**: Ctrl + I (Windows/Linux) 或 Cmd + I (Mac)
- **技巧**: 使用自然语言描述需求，Copilot 会生成完整代码；可以继续追问优化
- **演变**: 从简单的问答演变为支持多轮对话和上下文理解

---

## 步骤演示

### 第一轮: 基础提问
1. 在 VS Code 中打开 `check_file.sh`
2. 按 Ctrl + I，输入: `"写一个检查文件是否存在的函数"`
3. Copilot 生成:

```bash
check_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "错误: 文件 '$file' 不存在。" >&2
        return 1
    else
        echo "文件 '$file' 存在。"
        return 0
    fi
}
```

### 第二轮: 追问增强功能
继续输入: `"添加日志记录和权限检查"`，Copilot 扩展为:

```bash
LOG_FILE="/tmp/file_check.log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

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
```

### 第三轮: 追问批量处理
继续输入: `"添加一个批量检查多个文件的函数"`:

```bash
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
        log_error "批量检查完成: $failed 个文件失败"
        return 1
    fi

    log_info "批量检查完成: 全部通过"
    return 0
}

# 示例调用
check_files_batch "/etc/hosts" "/etc/passwd" "/tmp/missing.txt"
```

---

## 完整 Bash 脚本

查看 [check_file.sh](check_file.sh) 获取完整的实现代码。

```bash
# 运行方式
chmod +x check_file.sh
./check_file.sh /etc/hosts
./check_file.sh /tmp/does_not_exist.txt
```

---

## GitHub Actions Workflow 例子

```yaml
name: File Check Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  validate-scripts:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install shellcheck
        run: sudo apt-get install -y shellcheck

      - name: Lint Bash scripts
        run: shellcheck demos/ask-mode/check_file.sh

      - name: Test check_file function
        run: |
          cd demos/ask-mode
          chmod +x check_file.sh

          echo "=== 测试存在的文件 ==="
          ./check_file.sh /etc/hosts && echo "✓ 通过" || echo "✗ 失败"

          echo "=== 测试不存在的文件 ==="
          ./check_file.sh /tmp/not_exist.txt && echo "✗ 应该失败" || echo "✓ 正确检测到不存在"

      - name: Upload logs
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: file-check-logs
          path: /tmp/file_check.log
```

---

## Ask Mode 提问技巧

| 提问方式 | 示例 |
|----------|------|
| 功能描述 | "写一个检查文件是否存在的函数" |
| 限定语言 | "用 Bash 写一个..." |
| 追问改进 | "添加错误处理" / "加上日志记录" |
| 指定场景 | "适用于 CI/CD 环境的..." |
| 要求注释 | "加上详细注释" |
