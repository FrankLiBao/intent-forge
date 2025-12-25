# 更新日志

本文档记录 Intent Forge 项目的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [未发布]

### 新增
- 完整的意图驱动开发工作流支持
- 九个核心命令：constitution、specify、clarify、plan、tasks、analyze、implement、checklist、taskstoissues
- 支持 15+ AI 编码代理（Claude Code、Gemini CLI、GitHub Copilot、Cursor、Windsurf 等）
- 跨平台脚本支持（Bash 和 PowerShell）
- 结构化模板系统，包含规范、计划、任务模板
- Python CLI 工具 `intent`
- 宪法驱动的架构治理
- 自动化任务依赖排序
- 跨工件一致性分析
- 自定义质量检查清单生成

### 变更
- 基于 Spec Kit 完全重构
- 全面中文化（用户界面、文档、模板）
- 目录结构：`.specify` → `.intent`
- 命令前缀：`/speckit.*` → `/intent.*`
- Python 包名：`specify-cli` → `intent-cli`
- 方法论：规范驱动开发 → 意图驱动开发

## [0.1.0] - 2025-12-25

### 新增
- 初始版本发布
- 项目基础设施
  - MIT 许可证
  - 贡献指南
  - 行为准则
  - 安全政策
- 核心文档
  - README.md（中文）
  - intent-driven.md（意图驱动开发方法论）
  - 模板文档
- Python CLI 实现
  - `intent init` - 初始化新项目
  - `intent check` - 检查系统先决条件
  - `intent version` - 显示版本信息
- 脚本系统
  - Bash 脚本（Linux/macOS）
  - PowerShell 脚本（Windows/跨平台）
- 模板系统
  - agent-file-template.md
  - spec-template.md
  - plan-template.md
  - tasks-template.md
  - checklist-template.md
  - vscode-settings.json
- AI 代理命令
  - 九个核心 `/intent.*` 命令
  - 自动上下文更新
  - 先决条件检查

---

## 版本说明

### 版本号格式

采用语义化版本号：`主版本号.次版本号.修订号`

- **主版本号**：不兼容的 API 变更
- **次版本号**：向后兼容的功能新增
- **修订号**：向后兼容的问题修正

### 变更类型

- **新增** - 新功能
- **变更** - 现有功能的变更
- **弃用** - 即将移除的功能
- **移除** - 已移除的功能
- **修复** - 错误修复
- **安全** - 安全漏洞修复
