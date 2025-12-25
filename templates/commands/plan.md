---
description: 使用计划模板执行实现规划工作流程以生成设计工件
handoffs:
  - label: Create Tasks
    agent: intent.tasks
    prompt: Break the plan into tasks
    send: true
  - label: Create Checklist
    agent: intent.checklist
    prompt: Create a checklist for the following domain...
---

## 用户输入

```text
$ARGUMENTS
```

在继续之前，您**必须**考虑用户输入（如果不为空）。

## 概述

1. **设置**：从仓库根目录运行 `scripts/bash/setup-plan.sh --json` 并解析 JSON 以获取 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。对于参数中的单引号（如 "I'm Groot"），使用转义语法：例如 'I'\''m Groot'（或者如果可能，使用双引号："I'm Groot"）。

2. **加载上下文**：读取 FEATURE_SPEC 和 `memory/constitution.md`。加载 IMPL_PLAN 模板（已复制）。

3. **执行计划工作流**：遵循 IMPL_PLAN 模板中的结构以：
   - 填写技术上下文（将未知项标记为"NEEDS CLARIFICATION"）
   - 从宪法填写宪法检查部分
   - 评估门控（如果违规未经证明则错误）
   - 阶段 0：生成 research.md（解决所有 NEEDS CLARIFICATION）
   - 阶段 1：生成 data-model.md、contracts/、quickstart.md
   - 阶段 1：通过运行代理脚本更新代理上下文
   - 设计后重新评估宪法检查

4. **停止并报告**：命令在阶段 2 规划后结束。报告分支、IMPL_PLAN 路径和生成的工件。

## 阶段

### 阶段 0：大纲与研究

1. **从上面的技术上下文中提取未知项**：
   - 对于每个 NEEDS CLARIFICATION → 研究任务
   - 对于每个依赖项 → 最佳实践任务
   - 对于每个集成 → 模式任务

2. **生成并派发研究代理**：

   ```text
   对于技术上下文中的每个未知项：
     任务："为 {功能上下文} 研究 {未知项}"
   对于每个技术选择：
     任务："在 {领域} 中查找 {技术} 的最佳实践"
   ```

3. **在 `research.md` 中整合发现**，使用格式：
   - 决策：[选择了什么]
   - 理由：[为什么选择]
   - 考虑的替代方案：[还评估了什么]

**输出**：research.md，所有 NEEDS CLARIFICATION 已解决

### 阶段 1：设计与契约

**先决条件：** `research.md` 完成

1. **从功能规范中提取实体** → `data-model.md`：
   - 实体名称、字段、关系
   - 来自需求的验证规则
   - 状态转换（如果适用）

2. **从功能需求生成 API 契约**：
   - 对于每个用户操作 → 端点
   - 使用标准 REST/GraphQL 模式
   - 将 OpenAPI/GraphQL 架构输出到 `/contracts/`

3. **代理上下文更新**：
   - 运行 `scripts/bash/update-agent-context.sh claude`
   - 这些脚本检测正在使用的 AI 代理
   - 更新适当的特定于代理的上下文文件
   - 仅从当前计划添加新技术
   - 保留标记之间的手动添加内容

**输出**：data-model.md、/contracts/*、quickstart.md、特定于代理的文件

## 关键规则

- 使用绝对路径
- 门控失败或未解决的澄清时错误
