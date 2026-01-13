# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作时提供指导。

## Python 环境

本项目使用 **uv** 进行 Python 包管理，要求 Python 3.11+。

```bash
# 安装依赖
uv sync

# 运行 CLI
uv run intent --help

# 本地开发测试
uv run intent init test-project --ai claude
```

**核心依赖:**
- `typer` - CLI 框架
- `rich` - 终端 UI 美化
- `httpx[socks]` - HTTP 客户端（支持代理）
- `platformdirs` - 跨平台目录管理
- `readchar` - 跨平台键盘输入
- `truststore` - SSL/TLS 证书管理

## 用户上下文和工作流要求

在此项目上工作时，请遵循以下指南：
- 所有回答必须使用中文；如需修改或引用既有英文技术文档，可保持其原文或在中文说明后附英文
- 使用意图驱动开发工作流进行功能开发
- 保持与现有模板结构的一致性

## 项目概述

**Intent Forge** 是一个意图驱动开发工具包，它颠覆了传统软件开发流程：规范变成可执行的，直接生成可工作的实现。

### 核心理念

1. **规范优先**: 规范是主要工件，而非临时文档
2. **意图与实现分离**: 明确区分"做什么"(意图)和"怎么做"(实现)
3. **渐进式细化**: 多阶段细化而非一次性代码生成
4. **模板约束**: 使用结构化模板确保 AI 输出一致性
5. **宪法治理**: 项目宪法作为架构权威指导所有开发决策

### 开发阶段

| 阶段 | 命令 | 输出 |
|------|------|------|
| 宪法 | `/intent.constitution` | `memory/constitution.md` |
| 规范 | `/intent.specify` | `specs/###-feature/spec.md` |
| 澄清 | `/intent.clarify` | 更新后的 `spec.md` |
| 规划 | `/intent.plan` | `plan.md`, `research.md`, `data-model.md`, `contracts/` |
| 任务 | `/intent.tasks` | `tasks.md` |
| 分析 | `/intent.analyze` | 一致性分析报告 |
| 实现 | `/intent.implement` | 工作代码 |

## 关键命令

### CLI 命令

```bash
# 初始化新项目
intent init <项目名称>
intent init . --ai claude
intent init --here --ai copilot

# 检查已安装工具
intent check

# 显示版本信息
intent version
```

### 开发命令

```bash
# 安装依赖
uv sync

# 运行 CLI
uv run intent --help

# 本地测试 CLI
uv run intent init my-test-project --ai claude

# 创建发布包
./.github/workflows/scripts/create-release-packages.sh v1.0.0
```

## 项目架构

### 目录结构

```
intent-forge/
├── src/intent_cli/           # 核心 CLI 模块
│   └── __init__.py           # 主入口点 (1368行)
├── templates/                 # 意图驱动模板
│   ├── commands/              # 斜杠命令定义
│   │   ├── constitution.md    # /intent.constitution
│   │   ├── specify.md         # /intent.specify
│   │   ├── plan.md            # /intent.plan
│   │   ├── tasks.md           # /intent.tasks
│   │   ├── implement.md       # /intent.implement
│   │   ├── analyze.md         # /intent.analyze
│   │   ├── clarify.md         # /intent.clarify
│   │   ├── checklist.md       # /intent.checklist
│   │   └── taskstoissues.md   # /intent.taskstoissues
│   ├── spec-template.md       # 规范模板
│   ├── plan-template.md       # 计划模板
│   ├── tasks-template.md      # 任务模板
│   └── agent-file-template.md # 代理文件模板
├── scripts/                   # 自动化脚本
│   ├── bash/                  # POSIX shell 脚本
│   └── powershell/            # PowerShell 脚本
├── memory/                    # 项目记忆
│   └── constitution.md        # 项目宪法模板
├── docs/                      # 文档
├── pyproject.toml             # 项目配置
└── README.md                  # 项目说明
```

### 数据流

```
用户需求
    ↓
/intent.constitution → constitution.md (项目原则)
    ↓
/intent.specify → spec.md (功能规范)
    ↓
/intent.clarify → 更新的 spec.md (澄清歧义)
    ↓
/intent.plan → plan.md, research.md, data-model.md, contracts/
    ↓
/intent.tasks → tasks.md (可执行任务列表)
    ↓
/intent.analyze → 分析报告 (一致性验证)
    ↓
/intent.implement → 工作代码
```

## 核心模块和类

### src/intent_cli/__init__.py

**主要组件:**

| 组件 | 描述 |
|------|------|
| `AGENT_CONFIG` | 15+ AI 代理配置字典 |
| `StepTracker` | 分层步骤跟踪器（类似树形输出） |
| `BannerGroup` | 自定义 Typer 组，显示 ASCII 横幅 |
| `app` | Typer 应用实例 |

**关键函数:**

| 函数 | 用途 |
|------|------|
| `init()` | 初始化新项目主流程 |
| `check()` | 检查工具安装状态 |
| `version()` | 显示版本信息 |
| `download_template_from_github()` | 从 GitHub 下载模板 |
| `download_and_extract_template()` | 下载并解压模板 |
| `init_git_repo()` | 初始化 git 仓库 |
| `check_tool()` | 检查工具是否安装 |
| `select_with_arrows()` | 箭头键交互选择 |

**支持的 AI 代理:**

| 代理 | 键名 | 需要 CLI |
|------|------|----------|
| Claude Code | `claude` | 是 |
| Gemini CLI | `gemini` | 是 |
| GitHub Copilot | `copilot` | 否 (IDE) |
| Cursor | `cursor-agent` | 否 (IDE) |
| Qwen Code | `qwen` | 是 |
| OpenCode | `opencode` | 是 |
| Codex CLI | `codex` | 是 |
| Windsurf | `windsurf` | 否 (IDE) |
| Kilo Code | `kilocode` | 否 (IDE) |
| Auggie CLI | `auggie` | 是 |
| CodeBuddy | `codebuddy` | 是 |
| Qoder CLI | `qoder` | 是 |
| Roo Code | `roo` | 否 (IDE) |
| Amazon Q | `q` | 是 |
| Amp | `amp` | 是 |
| SHAI | `shai` | 是 |
| IBM Bob | `bob` | 否 (IDE) |

## 开发指南

### 添加新 AI 代理

1. 在 `src/intent_cli/__init__.py` 的 `AGENT_CONFIG` 中添加配置:
```python
AGENT_CONFIG["new-agent"] = {
    "name": "New Agent Name",
    "folder": ".intent/agents/new-agent/",
    "install_url": "https://...",
    "requires_cli": True,  # 或 False（IDE 类型）
}
```

2. 在 `templates/` 目录中创建对应的代理模板文件

### 添加新斜杠命令

1. 在 `templates/commands/` 创建 `new-command.md`
2. 使用标准 YAML 前端格式：
```yaml
---
description: 命令描述
handoffs:
  - label: 下一步
    agent: intent.xxx
    prompt: 提示文本
    send: true
---
```
3. 定义执行流程和输出规范

### 代码风格约定

- 使用 `rich` 进行终端输出美化
- 使用 `typer` 定义 CLI 命令
- 网络操作使用 `httpx` 客户端
- 跨平台键盘输入使用 `readchar`
- 错误信息使用 `Panel` 组件展示

## 测试指南

### 本地测试 CLI

```bash
# 直接运行
uv run intent --help
uv run intent check
uv run intent version

# 测试初始化
uv run intent init test-project --ai claude

# 测试当前目录初始化
cd /tmp && mkdir test && cd test
uv run intent init . --ai copilot
```

### 测试模板更改

```bash
# 1. 创建发布包
./.github/workflows/scripts/create-release-packages.sh v1.0.0

# 2. 复制到测试项目
cp -r .genreleases/idd-claude-package-sh/. ~/test-project/

# 3. 在测试项目中验证斜杠命令
```

## 工作流程说明

### 意图驱动开发工作流

```
1. 宪法阶段 (Constitution)
   └── 建立项目原则和约束
   └── 输出: memory/constitution.md

2. 规范阶段 (Specify)
   └── 定义功能需求和用户故事
   └── 输出: specs/###-feature/spec.md

3. 澄清阶段 (Clarify) [可选]
   └── 解决规范中的歧义
   └── 输出: 更新的 spec.md

4. 规划阶段 (Plan)
   └── 创建技术实现计划
   └── 输出: plan.md, research.md, data-model.md, contracts/

5. 任务阶段 (Tasks)
   └── 生成可执行任务列表
   └── 输出: tasks.md

6. 分析阶段 (Analyze) [可选]
   └── 验证跨工件一致性
   └── 输出: 分析报告

7. 实现阶段 (Implement)
   └── 执行任务生成代码
   └── 输出: 工作代码
```

### 任务格式规范

```text
- [ ] [TaskID] [P?] [Story?] 描述，包含文件路径

示例:
- [ ] T001 根据实现计划创建项目结构
- [ ] T005 [P] 在 src/middleware/auth.py 中实现认证中间件
- [ ] T012 [P] [US1] 在 src/models/user.py 中创建 User 模型
```

- `[P]`: 可并行执行（不同文件，无依赖）
- `[US#]`: 所属用户故事

## 故障排除

### GitHub API 限流

```bash
# 使用 token 增加限额（从 60/小时 到 5000/小时）
intent init my-project --github-token YOUR_TOKEN

# 或设置环境变量
export GH_TOKEN=YOUR_TOKEN
```

### SSL/TLS 问题

```bash
# 跳过 TLS 验证（不推荐）
intent init my-project --skip-tls
```

### Claude 迁移后找不到

Claude `migrate-installer` 命令会将可执行文件移到 `~/.claude/local/claude`，CLI 会自动检测此路径。

## 相关资源

- [意图驱动开发方法论](./intent-driven.md)
- [贡献指南](./CONTRIBUTING.md)
- [项目 README](./README.md)
