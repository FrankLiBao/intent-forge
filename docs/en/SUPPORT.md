# Support

## How to Submit Issues and Get Help

This project uses GitHub issues to track bugs and feature requests. Before submitting a new issue, please search existing issues to avoid duplicates. For new issues, submit your bug or feature request as a new issue.

For help or questions about using this project, please:

- Open a new [GitHub issue](../../issues/new) for bug reports, feature requests, or questions about the Intent-Driven Development methodology
- Check the [comprehensive guide](./intent-driven.md) for detailed documentation on the Intent-Driven Development process
- Review the [README](./README.md) for getting started instructions and troubleshooting tips
- Check [CONTRIBUTING](./CONTRIBUTING.md) to learn how to contribute to the project

## Project Status

**Intent Forge** is under active development and maintained by the community. We will do our best to respond to support, feature requests, and community issues in a timely manner.

## Community Resources

- **Issue Tracking**: [GitHub Issues](../../issues)
- **Feature Discussions**: [GitHub Discussions](../../discussions) (if enabled)
- **Contribution Guide**: [CONTRIBUTING.md](./CONTRIBUTING.md)
- **Code of Conduct**: [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md)
- **Security Policy**: [SECURITY.md](../../SECURITY.md)

## Frequently Asked Questions

### Installation and Setup

**Q: How do I install Intent CLI?**

A: Use the uv package manager:
```bash
uv tool install intent-cli --from git+https://github.com/FrankLiBao/intent-forge.git
```

**Q: Which AI agents are supported?**

A: Intent Forge supports 15+ AI coding agents, including Claude Code, Gemini CLI, GitHub Copilot, Cursor, Windsurf, and more. See the [README](./README.md#supported-ai-agents) for the complete list.

### Usage Issues

**Q: What if `/intent.*` commands are not available in my AI agent?**

A: Ensure you've run `intent init` in your project and that `.claude/commands/` or the corresponding agent configuration directory contains the command files.

**Q: How do I update to the latest version?**

A: Use the following command:
```bash
uv tool install intent-cli --force --from git+https://github.com/FrankLiBao/intent-forge.git
```

### Workflow Questions

**Q: In what order should I use the commands?**

A: The recommended workflow is:
1. `/intent.constitution` - Establish project principles
2. `/intent.specify` - Define functional requirements
3. `/intent.clarify` - Clarify ambiguities (optional)
4. `/intent.plan` - Create technical plan
5. `/intent.tasks` - Generate task list
6. `/intent.analyze` - Analyze consistency (optional)
7. `/intent.implement` - Execute implementation

**Q: Can I use only some of the commands?**

A: Yes, but the core commands (constitution, specify, plan, tasks, implement) form a complete workflow. Skipping steps may lead to inconsistencies.

## Best Ways to Get Help

1. **Search existing issues**: Your question may already be answered
2. **Review the documentation**: README and intent-driven_en.md contain detailed information
3. **Provide details**: When submitting an issue, include:
   - Intent Forge version (`intent version`)
   - AI agent being used
   - Error messages or unexpected behavior
   - Steps to reproduce
   - Relevant configuration files

## Support Policy

Support for this project is limited to the resources listed above. We are a community-driven project, and response times may vary.

Thank you for using Intent Forge!
