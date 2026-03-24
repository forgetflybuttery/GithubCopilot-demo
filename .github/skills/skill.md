# GitHub Changelog Skill

## 描述
此技能获取最新的 GitHub changelog，包括 GitHub 官方 changelog 中的重大更新和新功能。将 GitHub Actions 和 GitHub Copilot 的更新分开总结。

## 参数
- `period`: 时间周期，从发出请求的时间往前追溯一周（例如，"last-week" 表示最近一周）。

## 实现
从 GitHub 的 changelog 页面 (https://github.blog/changelog/) 获取最新条目，并总结重大更新。每个更新控制在 150 字左右。输出为 Markdown 格式，保存到 work/log/github_changelog_YYYYMMDD~YYYYMMDD.md 文件中，其中 YYYYMMDD 为起始和结束日期。

## 使用方法
调用方式：`/skill github-changelog last-week`

## 输出模板
输出文件：work/log/github_changelog_[起始日期]~[结束日期].md

```
# GitHub Changelog (最近一周)

## GitHub Actions 更新
### 更新日期: [日期]
**标题**: [更新标题]
**描述**: [简要描述，控制在 150 字以内]
**影响**: [对用户的影响]
**链接**: [相关链接]

[更多 Actions 更新...]

## GitHub Copilot 更新
### 更新日期: [日期]
**标题**: [更新标题]
**描述**: [简要描述，控制在 150 字以内]
**影响**: [对用户的影响]
**链接**: [相关链接]

[更多 Copilot 更新...]
```
## 注意事项
- 确保输出文件命名正确，包含正确的日期范围。
- 只总结重大更新，避免冗长描述。
- 输出格式必须为 Markdown，以便于阅读和分享。
- 语言使用中文，确保描述清晰易懂。

# 打印
- 将结果输出

