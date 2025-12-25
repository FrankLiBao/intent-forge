# 实现计划：[FEATURE]

**分支**：`[###-feature-name]` | **日期**：[DATE] | **规范**：[link]
**输入**：来自 `/specs/[###-feature-name]/spec.md` 的功能规范

**注意**：此模板由 `/intent.plan` 命令填写。有关执行工作流程，请参阅 `.intent/templates/commands/plan.md`。

## 摘要

[从功能规范中提取：主要需求 + 来自研究的技术方法]

## 技术上下文

<!--
  需要的操作：用项目的技术细节替换本节中的内容。
  此处的结构以咨询的方式呈现，以指导迭代过程。
-->

**Language/Version**：[例如，Python 3.11、Swift 5.9、Rust 1.75 或 NEEDS CLARIFICATION]
**Primary Dependencies**：[例如，FastAPI、UIKit、LLVM 或 NEEDS CLARIFICATION]
**Storage**：[如果适用，例如，PostgreSQL、CoreData、文件 或 N/A]
**Testing**：[例如，pytest、XCTest、cargo test 或 NEEDS CLARIFICATION]
**Target Platform**：[例如，Linux 服务器、iOS 15+、WASM 或 NEEDS CLARIFICATION]
**Project Type**：[single/web/mobile - 确定源代码结构]
**Performance Goals**：[特定于领域，例如，1000 req/s、10k lines/sec、60 fps 或 NEEDS CLARIFICATION]
**Constraints**：[特定于领域，例如，<200ms p95、<100MB 内存、离线功能 或 NEEDS CLARIFICATION]
**Scale/Scope**：[特定于领域，例如，10k 用户、1M LOC、50 个屏幕 或 NEEDS CLARIFICATION]

## 宪法检查

*门控：必须在阶段 0 研究之前通过。在阶段 1 设计之后重新检查。*

[根据宪法文件确定的门控]

## 项目结构

### 文档（此功能）

```text
specs/[###-feature]/
├── plan.md              # 此文件（/intent.plan 命令输出）
├── research.md          # 阶段 0 输出（/intent.plan 命令）
├── data-model.md        # 阶段 1 输出（/intent.plan 命令）
├── quickstart.md        # 阶段 1 输出（/intent.plan 命令）
├── contracts/           # 阶段 1 输出（/intent.plan 命令）
└── tasks.md             # 阶段 2 输出（/intent.tasks 命令 - 不由 /intent.plan 创建）
```

### 源代码（仓库根目录）
<!--
  需要的操作：用此功能的具体布局替换下面的占位符树。
  删除未使用的选项，并使用真实路径（例如，apps/admin、packages/something）扩展所选结构。
  交付的计划不得包含选项标签。
-->

```text
# [如果未使用则删除] 选项 1：单项目（默认）
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [如果未使用则删除] 选项 2：Web 应用（当检测到"frontend" + "backend"时）
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [如果未使用则删除] 选项 3：移动 + API（当检测到"iOS/Android"时）
api/
└── [与上面的 backend 相同]

ios/ or android/
└── [特定于平台的结构：功能模块、UI 流程、平台测试]
```

**结构决策**：[记录所选结构并引用上面捕获的真实目录]

## 复杂度追踪

> **仅在宪法检查有必须证明的违规时填写**

| 违规 | 为什么需要 | 被拒绝的更简单替代方案及原因 |
|-----------|------------|-------------------------------------|
| [例如，第4个项目] | [当前需求] | [为什么3个项目不足] |
| [例如，仓储模式] | [具体问题] | [为什么直接数据库访问不足] |
