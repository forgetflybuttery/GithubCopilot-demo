#!/bin/bash

# 这是一个简单的 Bash 脚本演示
# 使用 GitHub Copilot 可以快速生成此类脚本

echo "Hello, GitHub Copilot!"

# 简单的错误处理函数：检查文件是否存在
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

# 计算斐波那契数列的前 10 个数
fib() {
    n=$1
    if [ $n -le 1 ]; then
        echo $n
    else
        echo $(( $(fib $((n-1))) + $(fib $((n-2))) ))
    fi
}

for i in {0..9}; do
    echo "Fib($i) = $(fib $i)"
done

# 测试错误处理函数
check_file "demo.sh"
check_file "nonexistent.txt"