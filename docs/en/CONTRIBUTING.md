# Contributing to Intent Forge

Hi there! We're excited that you're interested in contributing to Intent Forge. Contributions to this project will be [released](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) to the public under the project's [open source license](../../LICENSE).

Please note that this project is released with a [Contributor Code of Conduct](../../CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Prerequisites for Running and Testing Code

These are one-time installation requirements that enable you to test your changes locally during the pull request (PR) submission process.

1. Install [Python 3.11+](https://www.python.org/downloads/)
1. Install [uv](https://docs.astral.sh/uv/) for package management
1. Install [Git](https://git-scm.com/downloads)
1. Have a [supported AI coding agent](README.md#supported-ai-agents) ready

<details>
<summary><b>💡 Tip if you're using <code>VSCode</code> or <code>GitHub Codespaces</code> as your IDE</b></summary>

<br>

Assuming you have [Docker](https://docker.com) installed on your machine, you can leverage [Dev Containers](https://containers.dev) via this [VSCode extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) to easily set up a development environment with the aforementioned tools installed and configured via the `.devcontainer/devcontainer.json` file located at the project root.

Simply:

- Check out the repository
- Open with VSCode
- Open the [Command Palette](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) and select "Dev Containers: Open Folder in Container..."

On [GitHub Codespaces](https://github.com/features/codespaces) it's even simpler, as it automatically leverages `.devcontainer/devcontainer.json` when opening a codespace.

</details>

## Submitting a Pull Request

> [!NOTE]
> If your pull request introduces substantial changes that materially affect how the CLI or the rest of the repository works (for example, you're introducing new templates, parameters, or other significant changes), ensure that project maintainers have **discussed and agreed** to it. Pull requests with large changes without prior discussion and agreement will be closed.

1. Fork and clone the repository
1. Configure and install dependencies: `uv sync`
1. Ensure the CLI works on your machine: `uv run intent --help`
1. Create a new branch: `git checkout -b my-branch-name`
1. Make your changes, add tests, and ensure everything still works
1. If relevant, test CLI functionality with a sample project
1. Push to your fork and submit a pull request
1. Wait for your pull request to be reviewed and merged.

Here are a few things you can do to increase the likelihood of your pull request being accepted:

- Follow the project's coding conventions.
- Write tests for new features.
- If your changes affect user-facing functionality, update the documentation (`README_EN.md`, `intent-driven_en.md`).
- Keep your changes as focused as possible. If you want to make multiple changes that don't depend on each other, consider submitting them as separate pull requests.
- Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
- Test your changes using the Intent-Driven Development workflow to ensure compatibility.

## Development Workflow

When working on intent-forge:

1. Test changes using the `intent` CLI commands (`/intent.specify`, `/intent.plan`, `/intent.tasks`) in your coding agent of choice
2. Verify that templates in the `templates/` directory work correctly
3. Test script functionality in the `scripts/` directory
4. If making significant process changes, ensure memory files (`memory/constitution.md`) are updated

### Testing Template and Command Changes Locally

Running `uv run intent init` pulls the published package, which won't include your local changes.
To test your templates, commands, and other changes locally, follow these steps:

1. **Create Release Package**

   Run the following command to generate a local package:

   ```bash
   ./.github/workflows/scripts/create-release-packages.sh v1.0.0
   ```

2. **Copy Relevant Package to Test Project**

   ```bash
   cp -r .genreleases/idd-copilot-package-sh/. <test-project-path>/
   ```

3. **Open and Test Agent**

   Navigate to the test project folder and open the agent to verify your implementation.

## AI Contributions in Intent Forge

> [!IMPORTANT]
>
> If you use **any type of AI assistance** to contribute to Intent Forge,
> it must be disclosed in the pull request or issue.

We welcome and encourage using AI tools to help improve Intent Forge! Many valuable contributions have been enhanced through AI assistance for code generation, issue detection, and feature definition.

That said, if you use any type of AI assistance (e.g., agents, ChatGPT) when contributing to Intent Forge,
**it must be disclosed in the pull request or issue**, along with the extent to which AI assistance was used (e.g., documentation comments vs. code generation).

If your PR response or comment is AI-generated, please disclose that as well.

As an exception, trivial spacing or typo fixes do not require disclosure, as long as the changes are limited to a small portion of code or phrases.

Example disclosures:

> This PR was primarily written by GitHub Copilot.

Or a more detailed disclosure:

> I consulted ChatGPT to understand the codebase, but the solution
> was entirely hand-written by myself.

Failing to disclose this is first and foremost disrespectful to the human operator on the other end of the pull request, but also makes it difficult
to determine how much scrutiny to apply to the contribution.

In an ideal world, AI assistance would produce work of the same or higher quality than any human. That is not the world we live in today, and in most cases
without human oversight or expertise involved, it generates code that cannot be reasonably maintained or evolved.

### What We're Looking For

When submitting AI-assisted contributions, please ensure they include:

- **Clear disclosure of AI usage** - You're transparent about your AI use and the extent of its use
- **Human understanding and testing** - You've personally tested the changes and understand what they do
- **Clear rationale** - You can explain why the change is needed and how it aligns with Intent Forge's goals
- **Concrete evidence** - Include test cases, scenarios, or examples demonstrating the improvement
- **Your own analysis** - Share your thoughts on the end-to-end developer experience

### What We'll Close

We reserve the right to close contributions that:

- Submit untested changes without verification
- Generic suggestions that don't address Intent Forge-specific needs
- Show no human review or understanding with bulk submissions

### Guide to Success

The key is demonstrating that you understand and have validated your proposed changes. If maintainers can easily tell the contribution is entirely AI-generated with no human input or testing, it may need more work before submission.

Contributors who consistently submit low-quality AI-generated changes may be restricted from further contributions at the discretion of maintainers.

Please respect the maintainers and disclose AI assistance.

## Resources

- [Intent-Driven Development Methodology](./intent-driven.md)
- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
