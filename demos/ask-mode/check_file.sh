#!/bin/bash

# 这是一个简单的 Bash 脚本演示

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

# 测试函数
check_file "$1"
