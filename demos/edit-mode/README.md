# Edit Mode Demo

## 场景
为现有 Bash 函数添加错误处理。这个演示展示了如何使用 GitHub Copilot 的 Edit Mode 来改进代码质量，添加健壮的错误处理和日志记录，符合 SRE（Site Reliability Engineering）原则。

## 现有代码

```bash
divide() {
    echo $(( $1 / $2 ))
}
```

## 步骤

1. 在 VS Code 中打开 `divide.sh` 文件。
2. 选中 `divide()` 函数的代码块。
3. 按 Ctrl + K（Windows/Linux）或 Cmd + K（Mac）进入 Edit Mode。
4. 输入编辑指令: "添加除零错误处理，并添加日志记录以提高可观测性"
5. Copilot 会建议修改后的代码。

## Copilot 修改后的代码

```bash
divide() {
    # 添加日志记录
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: 执行除法运算: $1 / $2" >&2

    if [ "$2" -eq 0 ]; then
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: 除零错误 - 除数不能为零" >&2
        return 1
    fi

    local result=$(( $1 / $2 ))
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: 除法结果: $result" >&2
    echo $result
}
```

## 使用方法
- **快捷键**: Ctrl + K (Windows/Linux) 或 Cmd + K (Mac)
- **技巧**: 提供清晰的编辑指令，如 "重构这个函数以提高性能" 或 "添加输入验证和错误处理"
- **演变**: 支持更复杂的重构和代码优化，从简单的语法修复到架构改进

## 修改亮点
编辑后的代码包含：
- **参数验证**: 检查除数是否为零
- **边界条件检查**: 防止运行时错误
- **错误处理**: 返回非零值表示失败
- **日志记录**: 添加时间戳的日志输出，提高可观测性
- **返回值指示**: 0 表示成功，1 表示失败

## 详细的 Bash 例子

### 基础版本（无错误处理）
```bash
#!/bin/bash

divide_basic() {
    echo $(( $1 / $2 ))
}

# 测试
echo "基础版本测试:"
divide_basic 10 2   # 输出: 5
divide_basic 10 0   # 错误: 除零导致脚本崩溃
```

### 改进版本（带错误处理）
```bash
#!/bin/bash

LOG_FILE="/tmp/divide.log"

log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG_FILE" >&2
}

divide_improved() {
    log_info "开始除法运算: $1 / $2"

    # 输入验证
    if ! [[ "$1" =~ ^-?[0-9]+$ ]]; then
        log_error "无效的被除数: $1"
        return 1
    fi

    if ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
        log_error "无效的除数: $2"
        return 1
    fi

    if [ "$2" -eq 0 ]; then
        log_error "除零错误: 除数不能为零"
        return 1
    fi

    local result=$(( $1 / $2 ))
    log_info "除法结果: $result"
    echo $result
    return 0
}

# 测试
echo "改进版本测试:"
divide_improved 10 2   # 输出: 10 / 2 = 5
echo "退出码: $?"

divide_improved 10 0   # 输出错误信息
echo "退出码: $?"

divide_improved "abc" 2  # 输出错误信息
echo "退出码: $?"
```

### 高级版本（带重试机制）
```bash
#!/bin/bash

divide_advanced() {
    local dividend=$1
    local divisor=$2
    local max_retries=3
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        if divide_improved "$dividend" "$divisor"; then
            return 0
        else
            retry_count=$((retry_count + 1))
            log_info "重试 $retry_count/$max_retries"
            sleep 1
        fi
    done

    log_error "达到最大重试次数，操作失败"
    return 1
}
```

## GitHub Actions Workflow 例子

### 基本 CI 工作流
```yaml
name: Bash Script Testing

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test-bash-scripts:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Bash
      run: |
        chmod +x demos/edit-mode/divide.sh

    - name: Run divide function tests
      run: |
        cd demos/edit-mode
        echo "测试正常情况:"
        ./divide.sh 10 2
        echo "退出码: $?"

        echo "测试除零情况:"
        ./divide.sh 10 0
        echo "退出码: $?"

    - name: Check logs
      run: |
        if [ -f /tmp/divide.log ]; then
          echo "日志内容:"
          cat /tmp/divide.log
        fi
```

### 高级 CI/CD 工作流（带自动化测试）
```yaml
name: SRE Pipeline - Bash Script Validation

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Install shellcheck
      run: |
        sudo apt-get update
        sudo apt-get install -y shellcheck

    - name: Lint Bash scripts
      run: |
        shellcheck demos/edit-mode/divide.sh

    - name: Run unit tests
      run: |
        cd demos/edit-mode

        # 创建测试脚本
        cat > test_divide.sh << 'EOF'
        #!/bin/bash

        source divide.sh

        test_passed=0
        test_failed=0

        run_test() {
            local expected_exit=$1
            local expected_output=$2
            shift 2

            echo "运行测试: divide $@"
            output=$(divide "$@" 2>&1)
            exit_code=$?

            if [ $exit_code -eq $expected_exit ]; then
                echo "✓ 测试通过"
                test_passed=$((test_passed + 1))
            else
                echo "✗ 测试失败 - 期望退出码: $expected_exit, 实际: $exit_code"
                test_failed=$((test_failed + 1))
            fi
        }

        # 测试用例
        run_test 0 5 10 2      # 正常情况
        run_test 1 "" 10 0     # 除零
        run_test 1 "" abc 2    # 无效输入

        echo "测试结果: $test_passed 通过, $test_failed 失败"
        [ $test_failed -eq 0 ]
        EOF

        chmod +x test_divide.sh
        ./test_divide.sh

    - name: Upload test results
      uses: actions/upload-artifact@v4
      if: always()
      with:
        name: test-results
        path: /tmp/divide.log

    - name: Deploy on success
      if: success()
      run: |
        echo "所有测试通过，可以部署"
        # 这里可以添加部署步骤
```

## SRE 最佳实践

- **可观测性**: 添加详细日志记录，便于监控和调试
- **自动化**: 使用脚本自动化测试和部署
- **可靠性**: 实施错误处理和重试机制
- **安全性**: 验证输入，防止注入攻击
- **性能**: 考虑缓存和优化计算

## 运行示例

```bash
# 切换到 demo 目录
cd demos/edit-mode

# 运行脚本
./divide.sh 10 2
./divide.sh 10 0

# 查看日志
cat /tmp/divide.log
```

这个扩展的 demo 展示了如何从简单的代码改进到完整的 CI/CD 集成，体现了 SRE 原则在 Bash 脚本开发中的应用。
