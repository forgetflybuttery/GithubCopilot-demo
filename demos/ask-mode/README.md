# Ask Mode Demo

## 场景
生成简单的 Bash 脚本和错误处理函数。

## 步骤

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

## 使用方法
- **快捷键**: Ctrl + I (Windows/Linux) 或 Cmd + I (Mac)
- **技巧**: 使用自然语言描述问题，Copilot 会生成相关代码
- **演变**: 从简单的问答演变为支持多轮对话和上下文理解

## 输出结果
生成的函数包含：
- 参数处理
- 文件存在性检查
- 错误提示输出
- 返回状态码
