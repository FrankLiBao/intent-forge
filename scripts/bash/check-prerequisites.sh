#!/usr/bin/env bash

# 统一的先决条件检查脚本
#
# 此脚本为规范驱动开发工作流提供统一的先决条件检查。
# 它替代了以前分散在多个脚本中的功能。
#
# 用法: ./check-prerequisites.sh [OPTIONS]
#
# 选项:
#   --json              以 JSON 格式输出
#   --require-tasks     要求 tasks.md 存在（用于实现阶段）
#   --include-tasks     在 AVAILABLE_DOCS 列表中包含 tasks.md
#   --paths-only        仅输出路径变量（无验证）
#   --help, -h          显示帮助消息
#
# 输出:
#   JSON 模式: {"FEATURE_DIR":"...", "AVAILABLE_DOCS":["..."]}
#   文本模式: FEATURE_DIR:... \n AVAILABLE_DOCS: \n ✓/✗ file.md
#   仅路径: REPO_ROOT: ... \n BRANCH: ... \n FEATURE_DIR: ... 等。

set -e

# 解析命令行参数
JSON_MODE=false
REQUIRE_TASKS=false
INCLUDE_TASKS=false
PATHS_ONLY=false

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --require-tasks)
            REQUIRE_TASKS=true
            ;;
        --include-tasks)
            INCLUDE_TASKS=true
            ;;
        --paths-only)
            PATHS_ONLY=true
            ;;
        --help|-h)
            cat << 'EOF'
用法: check-prerequisites.sh [OPTIONS]

用于规范驱动开发工作流的统一先决条件检查。

选项:
  --json              以 JSON 格式输出
  --require-tasks     要求 tasks.md 存在（用于实现阶段）
  --include-tasks     在 AVAILABLE_DOCS 列表中包含 tasks.md
  --paths-only        仅输出路径变量（无先决条件验证）
  --help, -h          显示此帮助消息

示例:
  # 检查任务先决条件（需要 plan.md）
  ./check-prerequisites.sh --json

  # 检查实现先决条件（需要 plan.md + tasks.md）
  ./check-prerequisites.sh --json --require-tasks --include-tasks

  # 仅获取功能路径（无验证）
  ./check-prerequisites.sh --paths-only

EOF
            exit 0
            ;;
        *)
            echo "错误: 未知选项 '$arg'。使用 --help 获取用法信息。" >&2
            exit 1
            ;;
    esac
done

# 获取公共函数
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 获取功能路径并验证分支
eval $(get_feature_paths)
check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

# 如果是仅路径模式，输出路径并退出（支持 JSON + paths-only 组合）
if $PATHS_ONLY; then
    if $JSON_MODE; then
        # 最小 JSON 路径有效负载（未执行验证）
        printf '{"REPO_ROOT":"%s","BRANCH":"%s","FEATURE_DIR":"%s","FEATURE_SPEC":"%s","IMPL_PLAN":"%s","TASKS":"%s"}\n' \
            "$REPO_ROOT" "$CURRENT_BRANCH" "$FEATURE_DIR" "$FEATURE_SPEC" "$IMPL_PLAN" "$TASKS"
    else
        echo "REPO_ROOT: $REPO_ROOT"
        echo "BRANCH: $CURRENT_BRANCH"
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo "FEATURE_SPEC: $FEATURE_SPEC"
        echo "IMPL_PLAN: $IMPL_PLAN"
        echo "TASKS: $TASKS"
    fi
    exit 0
fi

# 验证所需的目录和文件
if [[ ! -d "$FEATURE_DIR" ]]; then
    echo "错误: 未找到功能目录: $FEATURE_DIR" >&2
    echo "首先运行 /intent.specify 以创建功能结构。" >&2
    exit 1
fi

if [[ ! -f "$IMPL_PLAN" ]]; then
    echo "错误: 在 $FEATURE_DIR 中未找到 plan.md" >&2
    echo "首先运行 /intent.plan 以创建实现计划。" >&2
    exit 1
fi

# 如果需要，检查 tasks.md
if $REQUIRE_TASKS && [[ ! -f "$TASKS" ]]; then
    echo "错误: 在 $FEATURE_DIR 中未找到 tasks.md" >&2
    echo "首先运行 /intent.tasks 以创建任务列表。" >&2
    exit 1
fi

# 构建可用文档列表
docs=()

# 始终检查这些可选文档
[[ -f "$RESEARCH" ]] && docs+=("research.md")
[[ -f "$DATA_MODEL" ]] && docs+=("data-model.md")

# 检查 contracts 目录（仅当它存在且有文件时）
if [[ -d "$CONTRACTS_DIR" ]] && [[ -n "$(ls -A "$CONTRACTS_DIR" 2>/dev/null)" ]]; then
    docs+=("contracts/")
fi

[[ -f "$QUICKSTART" ]] && docs+=("quickstart.md")

# 如果请求且存在，包含 tasks.md
if $INCLUDE_TASKS && [[ -f "$TASKS" ]]; then
    docs+=("tasks.md")
fi

# 输出结果
if $JSON_MODE; then
    # 构建文档的 JSON 数组
    if [[ ${#docs[@]} -eq 0 ]]; then
        json_docs="[]"
    else
        json_docs=$(printf '"%s",' "${docs[@]}")
        json_docs="[${json_docs%,}]"
    fi

    printf '{"FEATURE_DIR":"%s","AVAILABLE_DOCS":%s}\n' "$FEATURE_DIR" "$json_docs"
else
    # 文本输出
    echo "FEATURE_DIR:$FEATURE_DIR"
    echo "AVAILABLE_DOCS:"

    # 显示每个潜在文档的状态
    check_file "$RESEARCH" "research.md"
    check_file "$DATA_MODEL" "data-model.md"
    check_dir "$CONTRACTS_DIR" "contracts/"
    check_file "$QUICKSTART" "quickstart.md"

    if $INCLUDE_TASKS; then
        check_file "$TASKS" "tasks.md"
    fi
fi
