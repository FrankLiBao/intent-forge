# Intent Forge

<p align="center">
  <a href="../../README.md">中文</a> | <a href="README.md">English</a>
</p>

<div align="center">
    <h3><em>Build high-quality software faster</em></h3>
</div>

<p align="center">
    <strong>An open-source toolkit that lets you focus on product scenarios and predictable outcomes, rather than writing every line of code from scratch.</strong>
</p>

---

## Table of Contents

- [What is Intent-Driven Development?](#what-is-intent-driven-development)
- [Quick Start](#quick-start)
- [Supported AI Agents](#supported-ai-agents)
- [Intent CLI Reference](#intent-cli-reference)
- [Core Philosophy](#core-philosophy)
- [Development Stages](#development-stages)
- [Prerequisites](#prerequisites)
- [License](#license)

## What is Intent-Driven Development?

Intent-Driven Development **inverts** the traditional software development process. For decades, code has been king—specifications were just scaffolding we built and discarded once the "real work" (coding) began. Intent-Driven Development changes this: **specifications become executable**, directly generating working implementations rather than merely guiding them.

## Quick Start

### 1. Install Intent CLI

Choose your preferred installation method:

#### Method 1: Persistent Installation (Recommended)

Install once, use everywhere:

```bash
uv tool install intent-cli --from git+https://github.com/FrankLiBao/intent-forge.git
```

Then use the tool directly:

```bash
# Create a new project
intent init <project-name>

# Or initialize in an existing project
intent init . --ai claude
# or
intent init --here --ai claude

# Check installed tools
intent check
```

Upgrade the Intent tool:

```bash
uv tool install intent-cli --force --from git+https://github.com/FrankLiBao/intent-forge.git
```

#### Method 2: One-Time Use

Run directly without installation:

```bash
uvx --from git+https://github.com/FrankLiBao/intent-forge.git intent init <project-name>
```

**Benefits of persistent installation:**

- Tool stays installed and available in PATH
- No need to create shell aliases
- Better tool management with `uv tool list`, `uv tool upgrade`, `uv tool uninstall`
- Cleaner shell configuration

### 2. Establish Project Principles

Launch your AI assistant in the project directory. The `/intent.*` commands are available in the assistant.

Use the **`/intent.constitution`** command to create the project's governance principles and development guidelines, which will guide all subsequent development.

```bash
/intent.constitution Create principles focusing on code quality, testing standards, user experience consistency, and performance requirements
```

### 3. Create Specifications

Use the **`/intent.specify`** command to describe what you want to build. Focus on **what to do** and **why**, not the tech stack.

```bash
/intent.specify Build an application that helps me organize photos in separate albums. Albums are grouped by date and can be reorganized on the main page through drag-and-drop. Albums are never nested within other albums. In each album, photos are previewed in a tile interface.
```

### 4. Create Technical Implementation Plan

Use the **`/intent.plan`** command to provide your tech stack and architectural choices.

```bash
/intent.plan The application uses Vite with minimal libraries. Use native HTML, CSS, and JavaScript wherever possible. Images are not uploaded anywhere, metadata is stored in a local SQLite database.
```

### 5. Break Down Tasks

Use **`/intent.tasks`** to create an executable task list from the implementation plan.

```bash
/intent.tasks
```

### 6. Execute Implementation

Use **`/intent.implement`** to execute all tasks and build the feature according to the plan.

```bash
/intent.implement
```

## Supported AI Agents

| Agent | Support Status | Notes |
| --- | --- | --- |
| [Claude Code](https://www.anthropic.com/claude-code) | ✅ | |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | ✅ | |
| [GitHub Copilot](https://code.visualstudio.com/) | ✅ | |
| [Cursor](https://cursor.sh/) | ✅ | |
| [Windsurf](https://windsurf.com/) | ✅ | |
| [Qwen Code](https://github.com/QwenLM/qwen-code) | ✅ | |
| Other agents | ✅ | Supports 15+ AI agents |

## Intent CLI Reference

The `intent` command supports the following options:

### Commands

| Command | Description |
| --- | --- |
| `init` | Initialize a new Intent project from the latest template |
| `check` | Check installed tools (`git`, `claude`, `gemini`, etc.) |
| `version` | Display version and system information |

### `intent init` Arguments and Options

| Argument/Option | Type | Description |
| --- | --- | --- |
| `<project-name>` | Argument | Name of the new project directory (optional if using `--here`, or use `.` for current directory) |
| `--ai` | Option | AI assistant to use: `claude`, `gemini`, `copilot`, `cursor-agent`, etc. |
| `--script` | Option | Script variant to use: `sh` (bash/zsh) or `ps` (PowerShell) |
| `--ignore-agent-tools` | Flag | Skip checks for AI agent tools |
| `--no-git` | Flag | Skip git repository initialization |
| `--here` | Flag | Initialize project in current directory instead of creating a new one |
| `--force` | Flag | Force merge/overwrite when initializing in current directory (skip confirmation) |
| `--github-token` | Option | GitHub token for API requests |

### Examples

```bash
# Basic project initialization
intent init my-project

# Initialize with specific AI assistant
intent init my-project --ai claude

# Initialize in current directory
intent init . --ai copilot
# or use the --here flag
intent init --here --ai copilot

# Force merge into current (non-empty) directory without confirmation
intent init . --force --ai copilot

# Check system requirements
intent check
```

### Available Slash Commands

After running `intent init`, your AI coding agent will have access to these slash commands for structured development:

#### Core Commands

Essential commands for the Intent-Driven Development workflow:

| Command | Description |
| --- | --- |
| `/intent.constitution` | Create or update project governance principles and development guidelines |
| `/intent.specify` | Define what you want to build (requirements and user stories) |
| `/intent.plan` | Create technical implementation plan with your chosen tech stack |
| `/intent.tasks` | Generate executable task list for implementation |
| `/intent.implement` | Execute all tasks to build the feature according to plan |

#### Optional Commands

Additional commands for enhancing quality and validation:

| Command | Description |
| --- | --- |
| `/intent.clarify` | Clarify under-specified areas (recommended before `/intent.plan`) |
| `/intent.analyze` | Cross-artifact consistency and coverage analysis (run after `/intent.tasks`, before `/intent.implement`) |
| `/intent.checklist` | Generate custom quality checklists to validate requirement completeness, clarity, and consistency |

## Core Philosophy

Intent-Driven Development is a structured process that emphasizes:

- **Intent-driven development**, where specifications define "*what to do*" before implementation
- **Rich specification creation**, using guardrails and organizing principles
- **Multi-step refinement**, rather than generating code from prompts in one shot
- **Heavy reliance** on advanced AI model capabilities for specification interpretation

## Development Stages

| Stage | Focus | Key Activities |
| --- | --- | --- |
| **0-to-1 Development** ("Greenfield") | Generate from scratch | <ul><li>Start with high-level requirements</li><li>Generate specifications</li><li>Plan implementation steps</li><li>Build production-ready applications</li></ul> |
| **Creative Exploration** | Parallel implementations | <ul><li>Explore diverse solutions</li><li>Support multiple tech stacks and architectures</li><li>Experiment with UX patterns</li></ul> |
| **Iterative Enhancement** ("Brownfield") | Brownfield modernization | <ul><li>Iteratively add features</li><li>Modernize legacy systems</li><li>Adjust processes</li></ul> |

## Prerequisites

- **Linux/macOS/Windows**
- [Supported](#supported-ai-agents) AI coding agent
- [uv](https://docs.astral.sh/uv/) for package management
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## License

This project is licensed under the terms of the MIT open-source license. For complete terms, see the [LICENSE](../../LICENSE) file.
