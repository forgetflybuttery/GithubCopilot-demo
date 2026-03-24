# Plan Mode Demo

## 场景
在开始编码前，让 Copilot 制定执行计划。这个演示展示了如何用 Plan Mode 规划一个完整的 Bash 工具脚本并配套 GitHub Actions 工作流。

## Plan Mode 与 Agent Mode 的区别

| 特性 | Plan Mode | Agent Mode |
|------|-----------|------------|
| 主要操作 | 制定计划、列出步骤 | 直接执行任务 |
| 交互方式 | 展示计划，等待用户确认 | 自动完成，中间汇报进度 |
| 适用场景 | 项目设计、任务拆解 | 执行任务、自动化脚本 |

---

## 步骤演示

### 演示 1: 规划一个 Bash 工具脚本
在 Copilot 聊天输入:
```
规划一个 Bash 自动化工具脚本，需要支持多个子命令、日志记录和错误处理
```
Copilot 会过出计划然后等待您确认。

### Copilot 输出的计划
```
计划: Bash 自动化工具

步骤 1: 定义脚本结构
  - shebang + set -euo pipefail
  - 配置变量和日志函数
  - 使用方法函数 (usage)

步骤 2: 参数解析
  - 支持 --help、--verbose、--dry-run
  - getopts 处理短参数

步骤 3: 实现子命令
  - cmd_check、cmd_build、cmd_deploy
  - 路由函数

步骤 4: 错误处理和清理
  - trap 设置退出时清理
  - 统一错误返回码

是否继续？ [y/N]
```

### 演示 2: 规划 CI/CD 工作流
在 Copilot 聊天输入:
```
基于这个脚本，设计一个 GitHub Actions 工作流，包含 lint、test、和 deploy 三个阶段
```

---

## 完整 Bash 工具脚本

查看 [tool.sh](tool.sh) 获取完整实现。

```bash
#!/bin/bash
set -euo pipefail

# 子命令用法
usage() {
    cat <<EOF
用法: $(basename "$0") <命令> [选项]

命令:
  check     检查环境和依赖
  build     构建项目
  deploy    部署项目

选项:
  -v, --verbose   详细输出
  -n, --dry-run   模拟执行不实际运行
  -h, --help      显示帮助
EOF
}

# 主要入口
main() {
    local cmd=${1:-""}
    shift || true
    case "$cmd" in
        check)  cmd_check "$@" ;;
        build)  cmd_build "$@" ;;
        deploy) cmd_deploy "$@" ;;
        *)      usage; exit 1 ;;
    esac
}

main "$@"
```

---

## GitHub Actions Workflow 例子

```yaml
name: Plan Mode - Multi-Stage Pipeline

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  check:
    name: Check Environment
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run check
        run: |
          chmod +x demos/plan-mode/tool.sh
          ./demos/plan-mode/tool.sh check

  build:
    name: Build
    runs-on: ubuntu-latest
    needs: check          # 依赖 check job
    steps:
      - uses: actions/checkout@v4
      - name: Run build
        run: ./demos/plan-mode/tool.sh build

  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    needs: build          # 依赖 build job
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Run deploy
        run: ./demos/plan-mode/tool.sh deploy
```

---

## Plan Mode 最佳实践

- **先计划再执行**: 对复杂任务刚选择 Plan Mode
- **速不放板**: 确认计划后再让 Copilot 执行
- **步骤拆解**: 让 Copilot 设计有依赖的多个 job
