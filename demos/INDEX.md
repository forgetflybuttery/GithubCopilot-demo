# Demo 索引

所有演示已按功能分类放在独立文件夹中，每个 demo 包含详细的 Bash 脚本示例和对应的 GitHub Actions Workflow。

## 文件夹结构

```
demos/
├── ask-mode/              # Ask Mode: 自然语言提问生成代码
│   ├── README.md          ← 多轮对话示例 + Workflow
│   └── check_file.sh      ← 文件检查工具（含批量处理）
├── edit-mode/             # Edit Mode: 修改和改进现有代码
│   ├── README.md          ← 改进步骤 + Workflow
│   └── divide.sh          ← 带日志和验证的除法脚本
├── agent-mode/            # Agent Mode: 自主执行任务
│   ├── README.md          ← 自动化场景 + Workflow
│   └── test.sh            ← 系统健康检查脚本
├── plan-mode/             # Plan Mode: 制定计划再执行
│   ├── README.md          ← 规划流程 + 多 job Workflow
│   └── tool.sh            ← 多子命令工具（check/build/deploy）
├── instruction/           # Instruction: 全局行为规范
│   └── README.md          ← 效果对比 + SRE Workflow
├── skills/                # Skills: 可复用自定义任务
│   └── README.md          ← 自定义技能 + 定时 Workflow
└── model-comparison/      # 模型对比: 不同模型的输出差异
    └── README.md          ← 各模型代码质量对比
```

## 快速导航

| Demo | 核心功能 | Bash 脚本 | Workflow |
|------|---------|-----------|---------|
| [ask-mode](ask-mode/README.md) | 多轮对话生成代码 | ✅ check_file.sh | ✅ File Check Pipeline |
| [edit-mode](edit-mode/README.md) | 改进现有代码 | ✅ divide.sh | ✅ SRE Testing Pipeline |
| [agent-mode](agent-mode/README.md) | 自主执行任务 | ✅ test.sh | ✅ Automated Health Check |
| [plan-mode](plan-mode/README.md) | 先规划再执行 | ✅ tool.sh | ✅ Multi-Stage Pipeline |
| [instruction](instruction/README.md) | 全局行为定制 | ✅ deploy.sh 示例 | ✅ SRE Deploy Pipeline |
| [skills](skills/README.md) | 可复用自定义技能 | ✅ skill-runner.sh | ✅ Weekly Changelog |
| [model-comparison](model-comparison/README.md) | 模型选择指南 | ✅ 三档质量对比 | ✅ Quality Gate |

## 运行所有脚本

```bash
# 赋予执行权限
chmod +x demos/**/*.sh

# 运行各 demo 脚本
./demos/ask-mode/check_file.sh /etc/hosts
./demos/edit-mode/divide.sh
./demos/agent-mode/test.sh
./demos/plan-mode/tool.sh check
./demos/plan-mode/tool.sh build --dry-run
./demos/plan-mode/tool.sh deploy --dry-run
```
