# GitHub Copilot 导入介绍

> 面向研发团队和 SRE 工程师的 GitHub Copilot 全面导入指南，涵盖背景、模型选择、各模式使用技巧、Instruction/Skills 配置，以及与 CI/CD 的集成最佳实践。

## 目录

1. [AI Agent 背景及 Copilot 发展](#1-ai-agent-利用背景及-copilot-发展)
2. [Copilot 具体功能介绍](#2-copilot-的具体介绍)
   - [可用模型](#21-copilot-可用模型)
   - [Mode 对比](#22-copilot-mode-使用方法技巧及演变)
   - [MCP 说明](#23-mcp-model-context-protocol)
   - [Instruction & Skills](#24-copilot-功能instruction--skills)
   - [使用推荐](#25-使用推荐)
3. [Demo 目录](#3-demo-目录)

---

## 1. AI Agent 利用背景及 Copilot 发展

### 1.1 AI 发展及 Agent 介绍

人工智能（AI）的发展经历了三个阶段的演变：

| 阶段 | 代表技术 | 特点 |
|------|---------|------|
| 自动化工具 | 规则引擎、脚本 | 固定流程，无法适应变化 |
| 机器学习模型 | GPT、BERT | 理解上下文，生成内容 |
| **AI Agent** | Copilot、AutoGPT | 自主规划、调用工具、迭代执行 |

AI Agent 的核心能力：
- **感知**: 理解代码上下文、读取文件、搜索代码库
- **规划**: 将复杂任务拆分为可执行步骤
- **执行**: 调用工具（终端、浏览器、API）完成任务
- **反馈**: 根据结果自动调整策略

对于 SRE 和 DevOps 团队，AI Agent 能够大幅减少重复性工作，将精力集中于系统设计和可靠性改进。

### 1.2 GitHub Copilot 介绍

GitHub Copilot 是由 GitHub 和 OpenAI 合作开发的 AI 编程助手，也是目前最广泛使用的 AI 编程工具之一。

**核心能力**:
- 📝 **代码补全**: 根据上下文实时建议后续代码
- 💬 **多轮对话**: 在聊天面板中进行多轮交互
- 🔧 **代码编辑**: 选中代码后直接下达修改指令
- 🤖 **自主执行**: Agent Mode 可自主完成完整任务
- 📋 **规划先行**: Plan Mode 先制定计划再执行
- 🔍 **代码审查**: 自动审查 PR 并给出改进建议

**与同类工具对比**:

| 工具 | 优势 | 劣势 |
|------|------|------|
| GitHub Copilot | GitHub 深度集成、Agent 模式强 | 订阅费用 |
| Cursor | 编辑器体验好 | 与 GitHub 生态集成弱 |
| Codeium | 免费 | 功能较少 |

### 1.3 Copilot 的 Enterprise 及 Pro 版本

| 版本 | 价格 | 目标用户 | 主要差异 |
|------|------|---------|---------|
| **Free** | 免费 | 个人开发者 | 每月 2000 次补全、50 次聊天，自动模型选择 |
| **Pro** | $10/月 | 个人开发者 | 无限补全和聊天，访问高级模型 |
| **Pro+** | $19/月 | 重度用户 | 更多 Premium 请求配额，优先访问新模型 |
| **Business** | $19/用户/月 | 企业团队 | 团队管理、使用统计、IP 保护、SAML SSO |
| **Enterprise** | $39/用户/月 | 大型企业 | 自定义模型微调、知识库集成、合规审计 |

**Premium 请求说明**:
高级模型（如 GPT-5、Claude Opus）每次调用消耗 Premium 请求配额。普通模型（自动选择）不消耗配额。在高峰期，Premium 请求还能获得更高优先级的响应。

---

## 2. Copilot 的具体介绍

### 2.1 Copilot 可用模型

截至 2026 年 3 月，Copilot 支持以下模型（可在聊天面板顶部切换）：

| 模型 | 特点 | 适用场景 | Premium 消耗 |
|------|------|---------|-------------|
| **Auto** (自动) | 自动匹配最优模型 | 日常使用推荐 | 无 |
| **GPT-5.4 mini** | 超快速度、低成本 | 简单补全、快速问答 | 无 |
| **GPT-5.3-Codex LTS** | 代码专项优化、稳定版 | 生产环境、稳定性要求高 | 有 |
| **GPT-5.4** | 最新旗舰模型 | 复杂架构、高质量代码 | 有 |
| **Claude Sonnet 4.5** | 超长上下文 (200k)、推理强 | 大型文件分析、复杂逻辑 | 有 |
| **Gemini 2.0 Pro** | 多模态支持 | 含图像的任务 | 有 |
| **Grok Code Fast 1** | 快速代码补全 | Free 计划自动选择 | 无 |

> **SRE 推荐**: 日常脚本使用 Auto 模式；架构设计或代码审查使用 Claude Sonnet；生产关键脚本使用 GPT-5.3-Codex LTS（稳定）。

### 2.2 Copilot Mode 使用方法、技巧及演变

Copilot 提供四种主要模式，适用于不同工作场景：

```
提问/生成  →  Ask Mode     (Ctrl+I)
修改代码   →  Edit Mode    (Ctrl+K / 内联编辑)
自主执行   →  Agent Mode   (聊天面板选择 Agent)
先规划后做 →  Plan Mode    (Agent 模式中选择 Plan)
```

---

#### Ask Mode

**核心理念**: 自然语言对话，多轮交互生成代码。

| 项目 | 内容 |
|------|------|
| 快捷键 | Ctrl + I (Win/Linux) / Cmd + I (Mac) |
| 触发方式 | 编辑器内联 / 侧边聊天面板 |
| 典型用途 | 生成函数、解释代码、单元测试 |

**提问技巧**:
- ✅ `用 Bash 写一个带日志记录和错误处理的文件检查函数`
- ✅ `解释这段代码的作用，并指出潜在问题`
- ✅ `为这个函数生成单元测试，覆盖边界条件`
- ❌ `写代码`（太模糊，结果质量差）

**演练 Demo** → 详见 [demos/ask-mode/](demos/ask-mode/README.md)

1. 打开 `demos/ask-mode/check_file.sh`，按 Ctrl + I
2. 输入: `"写一个检查文件是否存在且可读的函数，加上日志记录"`
3. 继续追问: `"添加批量检查多个文件的功能"`
4. 最终生成包含日志、错误处理、批量处理的完整脚本

---

#### Edit Mode

**核心理念**: 选中已有代码，直接下达改造指令。

| 项目 | 内容 |
|------|------|
| 快捷键 | Ctrl + K (Win/Linux) / Cmd + K (Mac) |
| 触发方式 | 选中代码后触发 |
| 典型用途 | 重构、添加功能、修复 bug |

**指令模板**:
- `添加 <功能>`：如"添加除零错误处理"
- `重构为 <风格>`：如"重构为更符合 SRE 规范的版本"
- `将 <语言A> 转换为 <语言B>`
- `优化性能：减少循环嵌套`

**演练 Demo** → 详见 [demos/edit-mode/](demos/edit-mode/README.md)

1. 打开 `demos/edit-mode/divide.sh`，选中 `divide()` 函数
2. 按 Ctrl + K，输入: `"添加输入验证、除零检查和日志记录"`
3. 观察 Copilot 如何将简单函数扩展为生产级代码

**改造前后对比**:

```bash
# 改造前（3行）
divide() {
    echo $(( $1 / $2 ))
}

# 改造后（35行，含日志、验证、错误处理）
divide() {
    log_info "执行除法: $1 / $2"
    [[ "$1" =~ ^-?[0-9]+$ ]] || { log_error "无效被除数"; return 1; }
    [[ "$2" =~ ^-?[0-9]+$ ]] || { log_error "无效除数"; return 1; }
    [ "$2" -eq 0 ] && { log_error "除零错误"; return 1; }
    local result=$(( $1 / $2 ))
    log_info "结果: $result"
    echo $result
}
```

---

#### Agent Mode

**核心理念**: Copilot 自主执行完整任务，包括读文件、运行命令、修复问题。

| 项目 | 内容 |
|------|------|
| 激活方式 | 聊天面板顶部切换到 "Agent" |
| 典型用途 | 自动化检查、端到端任务、跨文件修改 |
| 与 Ask 的区别 | Agent 会主动调用工具，Ask 只生成文本 |

**典型任务示例**:
```
检查 demos/ 目录下所有 .sh 文件的语法，修复发现的问题，并生成测试报告
```

Copilot Agent 会自动：
1. 扫描所有 `.sh` 文件
2. 对每个文件运行 `shellcheck`
3. 修复发现的问题
4. 汇总报告

**演练 Demo** → 详见 [demos/agent-mode/](demos/agent-mode/README.md)

---

#### Plan Mode

**核心理念**: 先展示执行计划，用户确认后再执行，避免意外修改。

| 项目 | 内容 |
|------|------|
| 激活方式 | Agent 模式中选择 "Plan" |
| 典型用途 | 复杂任务、不确定影响范围时 |
| 与 Agent 的区别 | Plan 先展示步骤等待确认，Agent 直接执行 |

**适用场景**:
- 重构多个文件时
- 设计新的 CI/CD 流程时
- 不清楚改动范围时

**演练 Demo** → 详见 [demos/plan-mode/](demos/plan-mode/README.md)

**模式选择决策树**:
```
需要生成/解释代码？    → Ask Mode
需要改进现有代码？     → Edit Mode
需要先看计划？         → Plan Mode
直接自动完成任务？     → Agent Mode
```

---

### 2.3 MCP (Model Context Protocol)

MCP 是一种让 AI 模型连接外部工具和数据源的开放协议，允许 Copilot 直接与数据库、API、文件系统等集成。

**MCP 能做什么**:
- 直接查询数据库并生成代码
- 读取外部 API 文档后生成调用代码
- 与 Jira、Slack 等工具集成

**为什么目前不推荐在生产中广泛使用**:

| 问题 | 说明 |
|------|------|
| 安全风险 | MCP Server 可能被注入恶意指令（Prompt Injection） |
| 权限范围难控制 | AI 代理获得的权限可能过大 |
| 审计困难 | 自动执行的操作难以追溯 |
| 复杂性高 | 需要自行搭建和维护 MCP Server |

**替代方案（推荐）**:
- 使用 **Skills** 定义标准化任务（安全、可审计）
- 使用 **Instructions** 设定行为规范
- 在 Agent Mode 中手动授权工具调用

> MCP 在受控环境下（如内部工具箱）仍有价值，但不建议给予 AI 不受限的外部访问权限。

---

### 2.4 Copilot 功能：Instruction & Skills

#### Instruction —— 全局行为规范

**原理**: 在 `.github/copilot-instructions.md` 中定义角色和规范，所有 Copilot 对话都会自动遵循。

**文件位置**: `.github/copilot-instructions.md`（本项目已配置）

**当前项目 Instruction（SRE Pipeline Team Member）**:

```markdown
# Role: SRE Pipeline Team Member

- 优先考虑可观测性、自动化和可靠性。
- 在代码中添加日志和监控。
- 确保 CI/CD 管道的健壮性。
- 使用最佳实践编写脚本和配置。
- 关注性能和安全性。
```

**效果对比**（同一个提问，有无 Instruction 的区别）:

| | 无 Instruction | 有 SRE Instruction |
|--|---------------|-------------------|
| 生成的脚本 | 简单实现 | 含日志、错误处理、`set -euo pipefail` |
| 变量命名 | 随意 | 使用环境变量，避免硬编码 |
| 错误处理 | 无或简单 | 完整的 trap、回滚逻辑 |
| CI/CD 建议 | 无 | 自动建议 shellcheck、健康检查 |

**Instruction 编写技巧**:
- 用简洁的 bullet point，不要写长段文字
- 明确角色（`Role: ...`）设定上下文
- 列出必须遵守的约束（如 `set -euo pipefail`）
- 可以用 `applyTo` 限定适用的文件类型

**演练 Demo** → 详见 [demos/instruction/](demos/instruction/README.md)

---

#### Skills —— 可复用自定义任务

**原理**: 在 `.github/skills/` 下定义任务模板，通过 `/skill <名称> <参数>` 触发执行。

**文件位置**: `.github/skills/skill.md`（本项目已定义 `github-changelog` 技能）

**触发方式**:
```
/skill github-changelog last-week
```

**使用示例 — 获取本周 GitHub 更新**:
1. 查看 `.github/skills/skill.md` 了解技能定义
2. 在 Copilot 聊天中输入 `/skill github-changelog last-week`
3. Copilot 访问 GitHub Changelog，提取 Copilot 和 Actions 相关更新
4. 输出保存到 `work/log/github_changelog_YYYYMMDD~YYYYMMDD.md`

**已生成的 Changelog 示例** → 见 `work/log/` 目录

**Skills vs Instruction 对比**:

| | Skills | Instruction |
|--|--------|-------------|
| 触发方式 | 显式调用 `/skill` | 自动应用于所有对话 |
| 参数支持 | ✅ 支持动态参数 | ❌ 静态规则 |
| 适用场景 | 特定的一次性任务 | 全局行为规范 |
| 典型用途 | 获取数据、执行检查 | 代码风格、角色设定 |

---

### 2.5 使用推荐

#### 模型选择指南

```
简单补全 / 快速问答     → GPT-5.4 mini (快速、省配额)
日常开发 / 代码审查     → Auto (自动选择最优)
大型文件 / 复杂推理     → Claude Sonnet 4.5 (200k 上下文)
生产级代码 / 稳定优先   → GPT-5.3-Codex LTS
架构设计 / 最高质量     → GPT-5.4
```

#### Premium Request 消耗说明（重点）

Premium Request 是否消耗，核心取决于**你选的模型**，而不是单纯取决于 Ask/Edit/Agent/Plan 模式。

通用规则（以当前 Copilot 版本为准，具体以产品界面计费提示为最终标准）：

- 使用 **Auto / GPT-5.4 mini / Free 自动模型**：通常不消耗或极少消耗 Premium 配额。
- 使用 **GPT-5.3-Codex LTS / GPT-5.4 / Claude Sonnet / Gemini Pro**：会消耗 Premium 配额。
- 同一任务中，调用次数越多、上下文越长（长对话、长文件、多轮重试），Premium 消耗越高。
- Agent Mode/Plan Mode 常因步骤更多、调用更频繁，整体消耗通常高于一次性 Ask/Edit。

**省配额策略**：

1. 先用 `Auto` 或 `GPT-5.4 mini` 明确需求与边界。
2. 仅在关键步骤（复杂重构、核心 Debug、正式报告）切换到高级模型。
3. 大任务先 Plan 再执行，减少反复返工与无效调用。
4. 多文件任务先限定范围（目录、文件、函数），降低上下文长度。

#### 场景推荐：平常对话/改代码/Debug/测试式样书/调查报告/手顺

| 工作类型 | 推荐 Mode | 推荐 Model | Premium 建议 | 说明 |
|---------|-----------|------------|--------------|------|
| 平常对话（概念问答） | Ask | Auto / GPT-5.4 mini | 低 | 响应快，适合日常知识问答 |
| 查询问题（定位思路） | Ask → Agent（必要时） | Auto 起步，复杂时 Claude Sonnet | 中 | 先问思路，再让 Agent 做精确定位 |
| 修改代码（小范围） | Edit | Auto / GPT-5.4 mini | 低 | 局部改动优先低成本模型 |
| 修改代码（跨文件重构） | Plan → Agent/Edit | GPT-5.3-Codex LTS / GPT-5.4 | 中-高 | 先规划依赖，降低改坏风险 |
| 做 Debug（疑难问题） | Agent | Claude Sonnet / GPT-5.4 | 中-高 | 需要读日志、跑命令、迭代验证 |
| 写测试式样书（测试设计文档） | Ask（结构）→ Edit（润色） | Claude Sonnet（长文）/ GPT-5.3-Codex LTS | 中 | 先产大纲，再细化测试点和边界 |
| 写测试代码（单测/集成） | Edit / Agent | GPT-5.3-Codex LTS | 中 | 代码一致性和稳定性更重要 |
| 写调查报告（技术调研） | Ask → Agent | Claude Sonnet / GPT-5.4 | 中-高 | 长上下文整合能力更关键 |
| 写手顺（运维/发布操作步骤） | Ask → Edit | GPT-5.3-Codex LTS / Auto | 低-中 | 强调可执行性、步骤清晰、回滚说明 |

#### 一套实用的“先省后准”工作流

```text
第1步：Ask + Auto（明确问题）
第2步：Edit/Ask + mini（快速草稿）
第3步：关键环节切高级模型（GPT-5.3-Codex LTS / Claude Sonnet）
第4步：Agent 做验证（测试、lint、运行）
第5步：回到 mini 做文档整理与收尾
```

#### 按角色的使用建议

**后端 / SRE 工程师**:
- 使用 Agent Mode 自动化 Bash 脚本检查和修复
- 配置 SRE 角色的 Instruction 获得更规范的代码
- 用 Plan Mode 规划复杂的 CI/CD 流程改动

**前端工程师**:
- Ask Mode 生成组件、Hook、测试用例
- Edit Mode 重构样式和逻辑
- 配置前端规范 Instruction（TypeScript、a11y 等）

**DevOps / Platform 工程师**:
- Agent Mode 分析和修复 Workflow 失败
- Skills 定期抓取工具升级日志
- Instruction 强制 IaC 和安全规范

#### 效率提升路线图

```
第 1 周: 掌握 Ask Mode 和 Edit Mode 基础用法
第 2 周: 配置项目 Instruction，统一团队代码规范
第 3 周: 使用 Agent Mode 自动化重复性任务
第 4 周: 创建自定义 Skills，标准化团队工作流
持续:   定期查看 GitHub Changelog，跟进新功能
```

#### 安全注意事项

- **不要**在聊天/指令中粘贴真实的密钥、密码、Token
- **审查** Agent Mode 的执行计划，确认无破坏性操作后再执行
- **使用 Plan Mode** 处理生产环境的重要变更
- **定期**检查 `.github/copilot-instructions.md`，防止规则被意外修改

---

## 3. Demo 目录

所有演示已整理在 `demos/` 目录下，每个 Demo 包含详细说明、Bash 脚本和配套 Workflow：

| Demo | 说明 | 脚本 | Workflow |
|------|------|------|---------|
| [ask-mode](demos/ask-mode/README.md) | 多轮对话生成代码 | `check_file.sh` | File Check Pipeline |
| [edit-mode](demos/edit-mode/README.md) | 改进现有代码 | `divide.sh` | SRE Testing Pipeline |
| [agent-mode](demos/agent-mode/README.md) | 自主执行任务 | `test.sh` | Automated Health Check |
| [plan-mode](demos/plan-mode/README.md) | 先规划再执行 | `tool.sh` | Multi-Stage Pipeline |
| [instruction](demos/instruction/README.md) | 全局行为定制 | deploy 示例 | SRE Deploy Pipeline |
| [skills](demos/skills/README.md) | 可复用自定义技能 | skill-runner 示例 | Weekly Changelog |
| [model-comparison](demos/model-comparison/README.md) | 模型选择指南 | 三档质量对比 | Quality Gate |

查看 [demos/INDEX.md](demos/INDEX.md) 获取完整索引和快速运行命令。