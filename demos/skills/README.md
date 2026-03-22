# Skills Demo

## 场景
获取 GitHub 最近一周的重大更新日志。

## 步骤

1. 创建 `.github/skills/skill.md` 文件定义技能。
2. 输入: `/skill github-changelog last-week`
3. Copilot 使用 Skills 从 GitHub 官方 changelog 中提取并格式化输出。

## 使用方法
- **激活方式**: 使用预定义或自定义技能执行任务
- **技巧**: 用于获取信息或执行操作
- **优势**: 可重复使用的功能集合

## 技能定义示例

```markdown
# GitHub Changelog Skill

## 描述
此技能获取最新的 GitHub changelog，包括 GitHub 官方 changelog 中的重大更新和新功能。

## 参数
- `period`: 时间周期，从发出请求的时间往前追溯（例如，"last-week"）

## 实现
从 GitHub 的 changelog 页面获取最新条目，并总结重大更新。

## 输出格式
Markdown 格式，包含 GitHub Actions 和 GitHub Copilot 更新的分类总结。
```

## 输出示例

```
# GitHub Changelog (最近一周)

## GitHub Actions 更新
### 更新日期: 2026-03-20
**标题**: 更新标题
**描述**: 简要描述，控制在 150 字以内
**影响**: 对用户的影响
**链接**: [相关链接]

## GitHub Copilot 更新
### 更新日期: 2026-03-19
**标题**: 更新标题
**描述**: 简要描述
**影响**: 对用户的影响
**链接**: [相关链接]
```

## 优势
- 快速获取信息
- 自动化信息收集
- 标准化输出格式
- 提高效率和一致性
