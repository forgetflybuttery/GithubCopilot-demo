# Edit Mode Demo

## 场景
为现有 Bash 函数添加错误处理。

## 现有代码

```bash
divide() {
    echo $(( $1 / $2 ))
}
```

## 步骤

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

## 使用方法
- **快捷键**: Ctrl + K (Windows/Linux) 或 Cmd + K (Mac)
- **技巧**: 提供清晰的编辑指令，如 "重构这个函数以提高性能"
- **演变**: 支持更复杂的重构和代码优化

## 修改亮点
编辑后的代码包含：
- 参数验证
- 边界条件检查
- 错误处理
- 返回值指示成功/失败
