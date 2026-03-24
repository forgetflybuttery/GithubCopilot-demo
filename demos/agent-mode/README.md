# Agent Mode Demo

## 场景
让 Copilot 代理自主执行任务：运行 Bash 脚本、自动化验证、分析输出并修复问题。Agent Mode 是 Copilot 的最强功能，能够自动完成完整的工作流。

## 与其他模式的区别

| 模式 | 核心作用 |
|------|----------|
| Ask Mode | 回答问题，生成代码片段 |
| Edit Mode | 修改选中的现有代码 |
| Plan Mode | 制定执行计划，等待确认 |
| **Agent Mode** | **自主执行、调用工具、解决问题** |

---

## 步骤演示

### 演示 1: 运行脚本并分析结果
1. 在 Copilot 聊天中输入:
   ```
   运行 demos/agent-mode/test.sh 并告诉我系统状态
   ```
2. Copilot 会自动执行脚本并总结结果。

### 演示 2: 自动化一整套工作流
在 Copilot 聊天输入:
```
检查 demos/ 目录下所有 .sh 文件的语法错误并汇报结果
```
Copilot 会目动:
- 查找所有 `.sh` 文件
- 对每个文件运行 `shellcheck`
- 汇总迎错误并给出修复建议

### 演示 3: 调试失败的脚本
在 Copilot 聊天输入:
```
test.sh 运行失败了，帮我分析原因
```
Copilot 会读取文件、运行调试命令并提出修复方案。

---

## 完整 Bash 脚本

查看 [test.sh](test.sh) 获取系统状态检查脚本。

```bash
# 运行方式
chmod +x demos/agent-mode/test.sh
./demos/agent-mode/test.sh
```

---

## GitHub Actions Workflow 例子

```yaml
name: Agent Mode - Automated System Check

on:
  schedule:
    - cron: '0 8 * * 1-5'   # 工作日每早 8 点自动执行
  workflow_dispatch:          # 支持手动触发

jobs:
  system-health-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run system check script
        id: health_check
        run: |
          chmod +x demos/agent-mode/test.sh
          ./demos/agent-mode/test.sh 2>&1 | tee /tmp/health_report.txt
          echo "exit_code=$?" >> $GITHUB_OUTPUT

      - name: Check for failures
        run: |
          if grep -q 'FAIL\|ERROR' /tmp/health_report.txt; then
            echo "⚠️  检测到错误，请查看日志"
            cat /tmp/health_report.txt
            exit 1
          else
            echo "✅ 所有检查通过"
          fi

      - name: Upload health report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: health-report-${{ github.run_id }}
          path: /tmp/health_report.txt

      - name: Notify on failure
        if: failure()
        run: |
          echo "系统健康检查失败！请监控告警。"
          # 可添加 Slack/钉钉通知
```

---

## Agent Mode 特性

- **工具调用**: 可读取文件、运行命令、搜索代码
- **自动迭代**: 扫描错误 → 修复 → 验证
- **实时反馈**: 运行时展示进度和中间结果
- **永久记忆**: 可配置 `.github/copilot-instructions.md` 引导行为
