#!/bin/bash

# 改进的除法函数，添加了除零错误处理

divide() {
    if [ "$2" -eq 0 ]; then
        echo "Error: Division by zero" >&2
        return 1
    fi
    echo $(( $1 / $2 ))
}

# 测试函数
divide 10 2
divide 10 0
