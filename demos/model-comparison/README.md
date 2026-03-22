# Model Comparison Demo

## 场景
比较不同模型在代码生成中的表现。

## 模型对比

### GPT-3.5
- **特性**: 快速、成本低
- **适用场景**: 简单 Bash 脚本
- **示例任务**: 生成简单函数

```bash
divide() {
    echo $(( $1 / $2 ))
}
```

### GPT-4
- **特性**: 更准确、上下文理解强
- **适用场景**: 复杂脚本
- **示例任务**: 生成带注释和错误处理的完整脚本

```bash
# 除法函数
# 参数: $1 - 被除数, $2 - 除数
# 返回: 0 成功, 1 失败
divide() {
    local dividend=$1
    local divisor=$2
    
    # 验证参数
    if [[ ! $dividend =~ ^-?[0-9]+$ ]]; then
        echo "错误: 被除数必须是整数" >&2
        return 1
    fi
    
    if [[ ! $divisor =~ ^-?[0-9]+$ ]]; then
        echo "错误: 除数必须是整数" >&2
        return 1
    fi
    
    # 检查除零
    if [ "$divisor" -eq 0 ]; then
        echo "错误: 不能被零整除" >&2
        return 1
    fi
    
    # 执行除法
    echo $(( $dividend / $divisor ))
    return 0
}
```

## 推荐使用

### 个人开发
- 推荐使用 Pro 计划
- 从简单任务开始，逐步使用高级模式

### 企业使用
- 推荐使用 Enterprise 计划获得安全和定制
- 支持自定义模型和 Premium 请求
- 确保快速响应和高优先级处理

## 总体建议
1. 从简单任务开始
2. 逐步使用高级模式
3. 结合快捷键提高效率
4. 定期更新 Copilot 以利用最新功能
