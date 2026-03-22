# GitHub Copilot Demo 示例

本文件提供具体的演示示例，基于 README.md 中的要点。

## Ask Mode Demo

**场景**: 生成简单的 Bash 脚本和错误处理函数。

1. 在 VS Code 中打开一个 Bash 文件 (.sh)。
2. 输入注释: `# 这是一个简单的 Bash 脚本演示`
3. 按 Ctrl + I 打开聊天，输入: "写一个检查文件是否存在的函数"
4. Copilot 建议:

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

## Edit Mode Demo

**场景**: 为现有 Bash 函数添加错误处理。

现有代码:
```bash
divide() {
    echo $(( $1 / $2 ))
}
```

1. 选中函数。
2. 按 Ctrl + K，输入: "添加除零错误处理"
3. Copilot 修改为:

```bash
divide() {
    if [ "$2" -eq 0 ]; then
        echo "Error: Division by zero" >&2
        return 1
    fi
    echo $(( $1 / $2 ))
}
```

## Agent Mode Demo

**场景**: 运行 Bash 脚本测试。

1. 在聊天中输入: "/run bash test.sh"
2. Copilot 执行脚本并返回结果。

## Plan Mode Demo

**场景**: 规划一个 Bash 脚本工具。

1. 输入: "规划一个简单的 Bash 脚本工具"
2. Copilot 输出:
   - 定义脚本功能
   - 添加参数解析
   - 实现核心逻辑
   - 添加帮助信息

## Instruction Demo

**文件**: .github/copilot-instructions.md

```
# Role: SRE Pipeline Team Member
- 始终添加日志记录。
- 确保代码的可观测性。
- 使用自动化工具。
```

**使用**: 在代码编写时，Copilot 会自动建议添加日志。

## Skills Demo

**场景**: 获取 GitHub 最近一周的重大更新日志。

1. 创建 .github/skills/skill.md 文件定义技能。
2. 输入: "/skill github-changelog last-week"
3. Copilot 使用 Skills 从 GitHub 官方 changelog 中提取并格式化输出。

## 模型对比示例

- 使用 GPT-3.5: 快速生成简单 Bash 函数。
- 使用 GPT-4: 生成带注释和错误处理的完整脚本。

这些演示展示了 Copilot 的实际应用。