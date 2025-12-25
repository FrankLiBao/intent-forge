# Intent Forge

<p align="center">
  <a href="README.md">中文</a> | <a href="docs/en/README.md">English</a>
</p>

<div align="center">
    <h3><em>更快地构建高质量软件</em></h3>
</div>

<p align="center">
    <strong>一个开源工具包,让您专注于产品场景和可预测的结果,而不是从零开始编写每一段代码。</strong>
</p>

---

## 目录

- [什么是意图驱动开发?](#什么是意图驱动开发)
- [快速开始](#快速开始)
- [支持的 AI 代理](#支持的-ai-代理)
- [Intent CLI 参考](#intent-cli-参考)
- [核心理念](#核心理念)
- [开发阶段](#开发阶段)
- [先决条件](#先决条件)
- [许可证](#许可证)

## 什么是意图驱动开发?

意图驱动开发**颠覆了**传统软件开发流程。几十年来,代码一直是王道——规范只是我们构建的脚手架,一旦"真正的工作"(编码)开始就被丢弃。意图驱动开发改变了这一点:**规范变成可执行的**,直接生成可工作的实现,而不仅仅是指导它们。

## 快速开始

### 1. 安装 Intent CLI

选择您喜欢的安装方式:

#### 方式 1: 持久化安装 (推荐)

一次安装,随处使用:

```bash
uv tool install intent-cli --from git+https://github.com/FrankLiBao/intent-forge.git
```

然后直接使用工具:

```bash
# 创建新项目
intent init <项目名称>

# 或在现有项目中初始化
intent init . --ai claude
# 或
intent init --here --ai claude

# 检查已安装的工具
intent check
```

升级 Intent 工具:

```bash
uv tool install intent-cli --force --from git+https://github.com/YOUR_ORG/intent-forge.git
```

#### 方式 2: 一次性使用

无需安装直接运行:

```bash
uvx --from git+https://github.com/FrankLiBao/intent-forge.git intent init <项目名称>
```

**持久化安装的好处:**

- 工具保持安装状态并在 PATH 中可用
- 无需创建 shell 别名
- 使用 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 更好地管理工具
- 更清晰的 shell 配置

### 2. 建立项目原则

在项目目录中启动您的 AI 助手。`/intent.*` 命令在助手中可用。

使用 **`/intent.constitution`** 命令创建项目的治理原则和开发指南,这将指导所有后续开发。

```bash
/intent.constitution 创建专注于代码质量、测试标准、用户体验一致性和性能要求的原则
```

### 3. 创建规范

使用 **`/intent.specify`** 命令描述您想要构建什么。专注于**做什么**和**为什么**,而不是技术栈。

```bash
/intent.specify 构建一个应用程序,帮助我在单独的相册中整理照片。相册按日期分组,可以在主页面上通过拖放重新组织。相册永远不会嵌套在其他相册中。在每个相册中,照片以平铺界面预览。
```

### 4. 创建技术实施计划

使用 **`/intent.plan`** 命令提供您的技术栈和架构选择。

```bash
/intent.plan 该应用程序使用 Vite,库数量最少。尽可能使用原生 HTML、CSS 和 JavaScript。图片不上传到任何地方,元数据存储在本地 SQLite 数据库中。
```

### 5. 分解任务

使用 **`/intent.tasks`** 从实施计划创建可执行的任务列表。

```bash
/intent.tasks
```

### 6. 执行实施

使用 **`/intent.implement`** 执行所有任务并根据计划构建功能。

```bash
/intent.implement
```

## 支持的 AI 代理

| 代理 | 支持状态 | 备注 |
| --- | --- | --- |
| [Claude Code](https://www.anthropic.com/claude-code) | ✅ | |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ | |
| [GitHub Copilot](https://code.visualstudio.com/) | ✅ | |
| [Cursor](https://cursor.sh/) | ✅ | |
| [Windsurf](https://windsurf.com/) | ✅ | |
| [Qwen Code](https://github.com/QwenLM/qwen-code) | ✅ | |
| 其他代理 | ✅ | 支持 15+ AI 代理 |

## Intent CLI 参考

`intent` 命令支持以下选项:

### 命令

| 命令 | 描述 |
| --- | --- |
| `init` | 从最新模板初始化新的 Intent 项目 |
| `check` | 检查已安装的工具 (`git`、`claude`、`gemini` 等) |
| `version` | 显示版本和系统信息 |

### `intent init` 参数和选项

| 参数/选项 | 类型 | 描述 |
| --- | --- | --- |
| `<项目名称>` | 参数 | 新项目目录的名称(如果使用 `--here` 则可选,或使用 `.` 表示当前目录) |
| `--ai` | 选项 | 要使用的 AI 助手:`claude`、`gemini`、`copilot`、`cursor-agent` 等 |
| `--script` | 选项 | 要使用的脚本变体:`sh`(bash/zsh)或 `ps`(PowerShell) |
| `--ignore-agent-tools` | 标志 | 跳过对 AI 代理工具的检查 |
| `--no-git` | 标志 | 跳过 git 仓库初始化 |
| `--here` | 标志 | 在当前目录中初始化项目,而不是创建新目录 |
| `--force` | 标志 | 在当前目录初始化时强制合并/覆盖(跳过确认) |
| `--github-token` | 选项 | 用于 API 请求的 GitHub token |

### 示例

```bash
# 基本项目初始化
intent init my-project

# 使用特定 AI 助手初始化
intent init my-project --ai claude

# 在当前目录中初始化
intent init . --ai copilot
# 或使用 --here 标志
intent init --here --ai copilot

# 强制合并到当前(非空)目录而不确认
intent init . --force --ai copilot

# 检查系统要求
intent check
```

### 可用的斜杠命令

运行 `intent init` 后,您的 AI 编码代理将可以访问这些用于结构化开发的斜杠命令:

#### 核心命令

意图驱动开发工作流的基本命令:

| 命令 | 描述 |
| --- | --- |
| `/intent.constitution` | 创建或更新项目治理原则和开发指南 |
| `/intent.specify` | 定义您想要构建什么(需求和用户故事) |
| `/intent.plan` | 使用您选择的技术栈创建技术实施计划 |
| `/intent.tasks` | 生成实施的可执行任务列表 |
| `/intent.implement` | 执行所有任务以根据计划构建功能 |

#### 可选命令

用于增强质量和验证的附加命令:

| 命令 | 描述 |
| --- | --- |
| `/intent.clarify` | 澄清未充分指定的区域(建议在 `/intent.plan` 之前) |
| `/intent.analyze` | 跨工件一致性和覆盖率分析(在 `/intent.tasks` 之后,`/intent.implement` 之前运行) |
| `/intent.checklist` | 生成验证需求完整性、清晰度和一致性的自定义质量检查清单 |

## 核心理念

意图驱动开发是一个结构化流程,强调:

- **意图驱动的开发**,其中规范在实现之前定义"*做什么*"
- **丰富的规范创建**,使用护栏和组织原则
- **多步骤细化**,而不是从提示一次性生成代码
- **严重依赖**高级 AI 模型能力进行规范解释

## 开发阶段

| 阶段 | 重点 | 关键活动 |
| --- | --- | --- |
| **0-to-1 开发**("绿地") | 从零开始生成 | <ul><li>从高级需求开始</li><li>生成规范</li><li>规划实施步骤</li><li>构建生产就绪的应用程序</li></ul> |
| **创意探索** | 并行实施 | <ul><li>探索多样化的解决方案</li><li>支持多种技术栈和架构</li><li>试验 UX 模式</li></ul> |
| **迭代增强**("棕地") | 棕地现代化 | <ul><li>迭代添加功能</li><li>现代化遗留系统</li><li>调整流程</li></ul> |

## 先决条件

- **Linux/macOS/Windows**
- [支持的](#支持的-ai-代理) AI 编码代理
- [uv](https://docs.astral.sh/uv/) 用于包管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 许可证

本项目根据 MIT 开源许可证的条款获得许可。有关完整条款,请参阅 [LICENSE](./LICENSE) 文件。
