# 为 Intent Forge 做贡献

您好！我们很高兴您愿意为 Intent Forge 做出贡献。对本项目的贡献将在项目的[开源许可证](LICENSE)下[发布](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)给公众。

请注意，本项目发布时附带了[贡献者行为准则](CODE_OF_CONDUCT.md)。参与本项目即表示您同意遵守其条款。

## 运行和测试代码的先决条件

这些是一次性安装要求，能够让您在拉取请求 (PR) 提交过程中在本地测试您的更改。

1. 安装 [Python 3.11+](https://www.python.org/downloads/)
1. 安装 [uv](https://docs.astral.sh/uv/) 用于包管理
1. 安装 [Git](https://git-scm.com/downloads)
1. 准备一个[可用的 AI 编码代理](README.md#支持的-ai-代理)

<details>
<summary><b>💡 如果您使用 <code>VSCode</code> 或 <code>GitHub Codespaces</code> 作为 IDE 的提示</b></summary>

<br>

假设您的机器上已安装 [Docker](https://docker.com)，您可以通过此 [VSCode 扩展](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)利用 [Dev Containers](https://containers.dev)，轻松设置开发环境，前述工具已通过位于项目根目录的 `.devcontainer/devcontainer.json` 文件安装和配置。

只需：

- 检出仓库
- 使用 VSCode 打开
- 打开[命令面板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette)并选择 "Dev Containers: Open Folder in Container..."

在 [GitHub Codespaces](https://github.com/features/codespaces) 上更简单，因为它在打开 codespace 时会自动利用 `.devcontainer/devcontainer.json`。

</details>

## 提交拉取请求

> [!NOTE]
> 如果您的拉取请求引入了实质性影响 CLI 或仓库其余部分工作的大型更改（例如，您正在引入新模板、参数或其他重大更改），请确保项目维护者已**讨论并同意**。未经事先讨论和同意的大型更改的拉取请求将被关闭。

1. Fork 并克隆仓库
1. 配置并安装依赖项：`uv sync`
1. 确保 CLI 在您的机器上工作：`uv run intent --help`
1. 创建新分支：`git checkout -b my-branch-name`
1. 进行更改，添加测试，并确保一切仍然正常工作
1. 如果相关，使用示例项目测试 CLI 功能
1. 推送到您的 fork 并提交拉取请求
1. 等待您的拉取请求被审查和合并。

以下是一些可以提高您的拉取请求被接受可能性的事项：

- 遵循项目的编码约定。
- 为新功能编写测试。
- 如果您的更改影响面向用户的功能，请更新文档（`README.md`、`intent-driven.md`）。
- 尽可能保持您的更改专注。如果您想进行多个彼此不依赖的更改，请考虑将它们作为单独的拉取请求提交。
- 编写[良好的提交消息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用意图驱动开发工作流测试您的更改以确保兼容性。

## 开发工作流

在 intent-forge 上工作时：

1. 在您选择的编码代理中使用 `intent` CLI 命令（`/intent.specify`、`/intent.plan`、`/intent.tasks`）测试更改
2. 验证 `templates/` 目录中的模板是否正常工作
3. 测试 `scripts/` 目录中的脚本功能
4. 如果进行了重大流程更改，请确保更新记忆文件（`memory/constitution.md`）

### 在本地测试模板和命令更改

运行 `uv run intent init` 会拉取已发布的包，这不会包含您的本地更改。
要在本地测试您的模板、命令和其他更改，请按照以下步骤操作：

1. **创建发布包**

   运行以下命令生成本地包：

   ```bash
   ./.github/workflows/scripts/create-release-packages.sh v1.0.0
   ```

2. **将相关包复制到测试项目**

   ```bash
   cp -r .genreleases/idd-copilot-package-sh/. <测试项目路径>/
   ```

3. **打开并测试代理**

   导航到测试项目文件夹并打开代理以验证您的实现。

## Intent Forge 中的 AI 贡献

> [!IMPORTANT]
>
> 如果您使用**任何类型的 AI 辅助**为 Intent Forge 做贡献，
> 必须在拉取请求或问题中披露。

我们欢迎并鼓励使用 AI 工具来帮助改进 Intent Forge！许多有价值的贡献都通过 AI 辅助进行了增强，用于代码生成、问题检测和功能定义。

也就是说，如果您在为 Intent Forge 做贡献时使用任何类型的 AI 辅助（例如，代理、ChatGPT），
**必须在拉取请求或问题中披露**，以及使用 AI 辅助的程度（例如，文档注释与代码生成）。

如果您的 PR 响应或评论是由 AI 生成的，也请披露。

作为例外，琐碎的间距或拼写错误修复不需要披露，只要更改仅限于代码的小部分或短语。

披露示例：

> 此 PR 主要由 GitHub Copilot 编写。

或更详细的披露：

> 我咨询了 ChatGPT 以了解代码库，但解决方案
> 完全由我自己手动编写。

不披露这一点首先对拉取请求另一端的人类操作员不礼貌，但也使得很难
确定对贡献应用多少审查。

在理想的世界中，AI 辅助将产生与任何人类相同或更高质量的工作。这不是我们今天生活的世界，在大多数情况下
如果没有人类监督或专业知识参与，它会生成无法合理维护或演化的代码。

### 我们正在寻找什么

提交 AI 辅助贡献时，请确保它们包括：

- **清楚披露 AI 使用** - 您对 AI 使用及使用程度保持透明
- **人类理解和测试** - 您已亲自测试更改并理解它们的作用
- **清晰的理由** - 您可以解释为什么需要更改以及它如何符合 Intent Forge 的目标
- **具体证据** - 包括展示改进的测试用例、场景或示例
- **您自己的分析** - 分享您对端到端开发者体验的想法

### 我们会关闭什么

我们保留关闭以下贡献的权利：

- 未经验证就提交的未测试更改
- 不解决 Intent Forge 特定需求的通用建议
- 显示没有人类审查或理解的批量提交

### 成功指南

关键是展示您理解并验证了您提议的更改。如果维护者可以轻易判断贡献完全由 AI 生成，没有人类输入或测试，那么在提交之前可能需要更多工作。

持续提交低质量 AI 生成更改的贡献者可能会被维护者酌情限制进一步贡献。

请尊重维护者并披露 AI 辅助。

## 资源

- [意图驱动开发方法论](./intent-driven.md)
- [如何为开源做贡献](https://opensource.guide/how-to-contribute/)
- [使用拉取请求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 帮助](https://help.github.com)
