# 支持

## 如何提交问题和获得帮助

本项目使用 GitHub issues 来跟踪错误和功能请求。在提交新问题之前，请搜索现有问题以避免重复。对于新问题，请将您的错误或功能请求作为新 issue 提交。

如需有关使用本项目的帮助或问题，请：

- 为错误报告、功能请求或有关意图驱动开发方法论的问题打开新的 [GitHub issue](../../issues/new)
- 查看[综合指南](./intent-driven.md)以获取有关意图驱动开发流程的详细文档
- 查看 [README](./README.md) 以获取入门说明和故障排除提示
- 查看 [CONTRIBUTING](./CONTRIBUTING.md) 以了解如何为项目做贡献

## 项目状态

**Intent Forge** 正在积极开发中，由社区维护。我们将尽最大努力及时响应支持、功能请求和社区问题。

## 社区资源

- **问题跟踪**：[GitHub Issues](../../issues)
- **功能讨论**：[GitHub Discussions](../../discussions)（如果启用）
- **贡献指南**：[CONTRIBUTING.md](./CONTRIBUTING.md)
- **行为准则**：[CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)
- **安全政策**：[SECURITY.md](./SECURITY.md)

## 常见问题

### 安装和设置

**Q: 如何安装 Intent CLI？**

A: 使用 uv 包管理器：
```bash
uv tool install intent-cli --from git+https://github.com/FrankLiBao/intent-forge.git
```

**Q: 支持哪些 AI 代理？**

A: Intent Forge 支持 15+ AI 编码代理，包括 Claude Code、Gemini CLI、GitHub Copilot、Cursor、Windsurf 等。请参阅 [README](./README.md#支持的-ai-代理) 获取完整列表。

### 使用问题

**Q: `/intent.*` 命令在我的 AI 代理中不可用怎么办？**

A: 确保您已在项目中运行 `intent init` 并且 `.claude/commands/` 或相应的代理配置目录包含命令文件。

**Q: 如何更新到最新版本？**

A: 使用以下命令：
```bash
uv tool install intent-cli --force --from git+https://github.com/FrankLiBao/intent-forge.git
```

### 工作流问题

**Q: 我应该按什么顺序使用命令？**

A: 推荐的工作流程是：
1. `/intent.constitution` - 建立项目原则
2. `/intent.specify` - 定义功能需求
3. `/intent.clarify` - 澄清歧义（可选）
4. `/intent.plan` - 创建技术计划
5. `/intent.tasks` - 生成任务列表
6. `/intent.analyze` - 分析一致性（可选）
7. `/intent.implement` - 执行实施

**Q: 我可以只使用部分命令吗？**

A: 可以，但核心命令（constitution、specify、plan、tasks、implement）构成了完整的工作流。跳过步骤可能会导致不一致。

## 获得帮助的最佳方式

1. **搜索现有问题**：您的问题可能已经被解答
2. **查阅文档**：README 和 intent-driven.md 包含详细信息
3. **提供详细信息**：提交问题时，包括：
   - Intent Forge 版本（`intent version`）
   - 使用的 AI 代理
   - 错误消息或意外行为
   - 重现步骤
   - 相关配置文件

## 支持政策

对本项目的支持仅限于上面列出的资源。我们是一个社区驱动的项目，响应时间可能会有所不同。

感谢您使用 Intent Forge！
