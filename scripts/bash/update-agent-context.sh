#!/usr/bin/env bash

# 使用 plan.md 中的信息更新代理上下文文件
#
# 此脚本通过解析功能规范
# 并使用项目信息更新特定于代理的配置文件来维护 AI 代理上下文文件。
#
# 主要功能:
# 1. 环境验证
#    - 验证 git 仓库结构和分支信息
#    - 检查所需的 plan.md 文件和模板
#    - 验证文件权限和可访问性
#
# 2. 计划数据提取
#    - 解析 plan.md 文件以提取项目元数据
#    - 识别语言/版本、框架、数据库和项目类型
#    - 优雅地处理缺失或不完整的规范数据
#
# 3. 代理文件管理
#    - 在需要时从模板创建新的代理上下文文件
#    - 使用新项目信息更新现有代理文件
#    - 保留手动添加和自定义配置
#    - 支持多种 AI 代理格式和目录结构
#
# 4. 内容生成
#    - 生成特定于语言的构建/测试命令
#    - 创建适当的项目目录结构
#    - 更新技术栈和最近更改部分
#    - 维护一致的格式和时间戳
#
# 5. 多代理支持
#    - 处理特定于代理的文件路径和命名约定
#    - 支持: Claude, Gemini, Copilot, Cursor, Qwen, opencode, Codex, Windsurf, Kilo Code, Auggie CLI, Roo Code, CodeBuddy CLI, Qoder CLI, Amp, SHAI, 或 Amazon Q Developer CLI
#    - 可以更新单个代理或所有现有代理文件
#    - 如果不存在代理文件，则创建默认 Claude 文件
#
# 用法: ./update-agent-context.sh [agent_type]
# 代理类型: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|shai|q|bob|qoder
# 留空以更新所有现有代理文件

set -e

# 启用严格错误处理
set -u
set -o pipefail

#==============================================================================
# 配置和全局变量
#==============================================================================

# 获取脚本目录并加载公共函数
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 从公共函数获取所有路径和变量
eval $(get_feature_paths)

NEW_PLAN="$IMPL_PLAN"  # 与现有代码兼容的别名
AGENT_TYPE="${1:-}"

# 特定于代理的文件路径
CLAUDE_FILE="$REPO_ROOT/CLAUDE.md"
GEMINI_FILE="$REPO_ROOT/GEMINI.md"
COPILOT_FILE="$REPO_ROOT/.github/agents/copilot-instructions.md"
CURSOR_FILE="$REPO_ROOT/.cursor/rules/specify-rules.mdc"
QWEN_FILE="$REPO_ROOT/QWEN.md"
AGENTS_FILE="$REPO_ROOT/AGENTS.md"
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
KILOCODE_FILE="$REPO_ROOT/.kilocode/rules/specify-rules.md"
AUGGIE_FILE="$REPO_ROOT/.augment/rules/specify-rules.md"
ROO_FILE="$REPO_ROOT/.roo/rules/specify-rules.md"
CODEBUDDY_FILE="$REPO_ROOT/CODEBUDDY.md"
QODER_FILE="$REPO_ROOT/QODER.md"
AMP_FILE="$REPO_ROOT/AGENTS.md"
SHAI_FILE="$REPO_ROOT/SHAI.md"
Q_FILE="$REPO_ROOT/AGENTS.md"
BOB_FILE="$REPO_ROOT/AGENTS.md"

# 模板文件
TEMPLATE_FILE="$REPO_ROOT/.intent/templates/agent-file-template.md"

# 已解析计划数据的全局变量
NEW_LANG=""
NEW_FRAMEWORK=""
NEW_DB=""
NEW_PROJECT_TYPE=""

#==============================================================================
# 实用函数
#==============================================================================

log_info() {
    echo "信息: $1"
}

log_success() {
    echo "✓ $1"
}

log_error() {
    echo "错误: $1" >&2
}

log_warning() {
    echo "警告: $1" >&2
}

# 临时文件的清理函数
cleanup() {
    local exit_code=$?
    rm -f /tmp/agent_update_*_$$
    rm -f /tmp/manual_additions_$$
    exit $exit_code
}

# 设置清理陷阱
trap cleanup EXIT INT TERM

#==============================================================================
# 验证函数
#==============================================================================

validate_environment() {
    # 检查是否有当前分支/功能（git 或非 git）
    if [[ -z "$CURRENT_BRANCH" ]]; then
        log_error "无法确定当前功能"
        if [[ "$HAS_GIT" == "true" ]]; then
            log_info "确保您在功能分支上"
        else
            log_info "设置 INTENT_FEATURE 环境变量或首先创建功能"
        fi
        exit 1
    fi

    # 检查 plan.md 是否存在
    if [[ ! -f "$NEW_PLAN" ]]; then
        log_error "在 $NEW_PLAN 未找到 plan.md"
        log_info "确保您正在处理具有相应 spec 目录的功能"
        if [[ "$HAS_GIT" != "true" ]]; then
            log_info "使用: export INTENT_FEATURE=your-feature-name 或首先创建新功能"
        fi
        exit 1
    fi

    # 检查模板是否存在（新文件需要）
    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_warning "在 $TEMPLATE_FILE 未找到模板文件"
        log_warning "创建新代理文件将失败"
    fi
}

#==============================================================================
# 计划解析函数
#==============================================================================

extract_plan_field() {
    local field_pattern="$1"
    local plan_file="$2"

    grep "^\*\*${field_pattern}\*\*: " "$plan_file" 2>/dev/null | \
        head -1 | \
        sed "s|^\*\*${field_pattern}\*\*: ||" | \
        sed 's/^[ \t]*//;s/[ \t]*$//' | \
        grep -v "NEEDS CLARIFICATION" | \
        grep -v "^N/A$" || echo ""
}

parse_plan_data() {
    local plan_file="$1"

    if [[ ! -f "$plan_file" ]]; then
        log_error "未找到计划文件: $plan_file"
        return 1
    fi

    if [[ ! -r "$plan_file" ]]; then
        log_error "计划文件不可读: $plan_file"
        return 1
    fi

    log_info "正在从 $plan_file 解析计划数据"

    NEW_LANG=$(extract_plan_field "Language/Version" "$plan_file")
    NEW_FRAMEWORK=$(extract_plan_field "Primary Dependencies" "$plan_file")
    NEW_DB=$(extract_plan_field "Storage" "$plan_file")
    NEW_PROJECT_TYPE=$(extract_plan_field "Project Type" "$plan_file")

    # 记录我们找到的内容
    if [[ -n "$NEW_LANG" ]]; then
        log_info "找到语言: $NEW_LANG"
    else
        log_warning "在计划中未找到语言信息"
    fi

    if [[ -n "$NEW_FRAMEWORK" ]]; then
        log_info "找到框架: $NEW_FRAMEWORK"
    fi

    if [[ -n "$NEW_DB" ]] && [[ "$NEW_DB" != "N/A" ]]; then
        log_info "找到数据库: $NEW_DB"
    fi

    if [[ -n "$NEW_PROJECT_TYPE" ]]; then
        log_info "找到项目类型: $NEW_PROJECT_TYPE"
    fi
}

format_technology_stack() {
    local lang="$1"
    local framework="$2"
    local parts=()

    # 添加非空部分
    [[ -n "$lang" && "$lang" != "NEEDS CLARIFICATION" ]] && parts+=("$lang")
    [[ -n "$framework" && "$framework" != "NEEDS CLARIFICATION" && "$framework" != "N/A" ]] && parts+=("$framework")

    # 使用适当的格式连接
    if [[ ${#parts[@]} -eq 0 ]]; then
        echo ""
    elif [[ ${#parts[@]} -eq 1 ]]; then
        echo "${parts[0]}"
    else
        # 用" + "连接多个部分
        local result="${parts[0]}"
        for ((i=1; i<${#parts[@]}; i++)); do
            result="$result + ${parts[i]}"
        done
        echo "$result"
    fi
}

#==============================================================================
# 模板和内容生成函数
#==============================================================================

get_project_structure() {
    local project_type="$1"

    if [[ "$project_type" == *"web"* ]]; then
        echo "backend/\\nfrontend/\\ntests/"
    else
        echo "src/\\ntests/"
    fi
}

get_commands_for_language() {
    local lang="$1"

    case "$lang" in
        *"Python"*)
            echo "cd src && pytest && ruff check ."
            ;;
        *"Rust"*)
            echo "cargo test && cargo clippy"
            ;;
        *"JavaScript"*|*"TypeScript"*)
            echo "npm test \\&\\& npm run lint"
            ;;
        *)
            echo "# 为 $lang 添加命令"
            ;;
    esac
}

get_language_conventions() {
    local lang="$1"
    echo "$lang: 遵循标准约定"
}

create_new_agent_file() {
    local target_file="$1"
    local temp_file="$2"
    local project_name="$3"
    local current_date="$4"

    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_error "在 $TEMPLATE_FILE 未找到模板"
        return 1
    fi

    if [[ ! -r "$TEMPLATE_FILE" ]]; then
        log_error "模板文件不可读: $TEMPLATE_FILE"
        return 1
    fi

    log_info "正在从模板创建新的代理上下文文件..."

    if ! cp "$TEMPLATE_FILE" "$temp_file"; then
        log_error "复制模板文件失败"
        return 1
    fi

    # 替换模板占位符
    local project_structure
    project_structure=$(get_project_structure "$NEW_PROJECT_TYPE")

    local commands
    commands=$(get_commands_for_language "$NEW_LANG")

    local language_conventions
    language_conventions=$(get_language_conventions "$NEW_LANG")

    # 使用更安全的方法执行替换并进行错误检查
    # 通过使用不同的分隔符或转义来转义 sed 的特殊字符
    local escaped_lang=$(printf '%s\n' "$NEW_LANG" | sed 's/[\[\.*^$()+{}|]/\\&/g')
    local escaped_framework=$(printf '%s\n' "$NEW_FRAMEWORK" | sed 's/[\[\.*^$()+{}|]/\\&/g')
    local escaped_branch=$(printf '%s\n' "$CURRENT_BRANCH" | sed 's/[\[\.*^$()+{}|]/\\&/g')

    # 有条件地构建技术栈和最近更改字符串
    local tech_stack
    if [[ -n "$escaped_lang" && -n "$escaped_framework" ]]; then
        tech_stack="- $escaped_lang + $escaped_framework ($escaped_branch)"
    elif [[ -n "$escaped_lang" ]]; then
        tech_stack="- $escaped_lang ($escaped_branch)"
    elif [[ -n "$escaped_framework" ]]; then
        tech_stack="- $escaped_framework ($escaped_branch)"
    else
        tech_stack="- ($escaped_branch)"
    fi

    local recent_change
    if [[ -n "$escaped_lang" && -n "$escaped_framework" ]]; then
        recent_change="- $escaped_branch: 添加了 $escaped_lang + $escaped_framework"
    elif [[ -n "$escaped_lang" ]]; then
        recent_change="- $escaped_branch: 添加了 $escaped_lang"
    elif [[ -n "$escaped_framework" ]]; then
        recent_change="- $escaped_branch: 添加了 $escaped_framework"
    else
        recent_change="- $escaped_branch: 已添加"
    fi

    local substitutions=(
        "s|\[PROJECT NAME\]|$project_name|"
        "s|\[DATE\]|$current_date|"
        "s|\[从所有 PLAN.MD 文件中提取\]|$tech_stack|"
        "s|\[来自计划的实际结构\]|$project_structure|g"
        "s|\[仅活跃技术的命令\]|$commands|"
        "s|\[特定于语言的，仅适用于正在使用的语言\]|$language_conventions|"
        "s|\[最后 3 个功能及其添加的内容\]|$recent_change|"
    )

    for substitution in "${substitutions[@]}"; do
        if ! sed -i.bak -e "$substitution" "$temp_file"; then
            log_error "执行替换失败: $substitution"
            rm -f "$temp_file" "$temp_file.bak"
            return 1
        fi
    done

    # 将 \n 序列转换为实际换行符
    newline=$(printf '\n')
    sed -i.bak2 "s/\\\\n/${newline}/g" "$temp_file"

    # 清理备份文件
    rm -f "$temp_file.bak" "$temp_file.bak2"

    return 0
}




update_existing_agent_file() {
    local target_file="$1"
    local current_date="$2"

    log_info "正在更新现有代理上下文文件..."

    # 使用单个临时文件进行原子更新
    local temp_file
    temp_file=$(mktemp) || {
        log_error "创建临时文件失败"
        return 1
    }

    # 一次性处理文件
    local tech_stack=$(format_technology_stack "$NEW_LANG" "$NEW_FRAMEWORK")
    local new_tech_entries=()
    local new_change_entry=""

    # 准备新技术条目
    if [[ -n "$tech_stack" ]] && ! grep -q "$tech_stack" "$target_file"; then
        new_tech_entries+=("- $tech_stack ($CURRENT_BRANCH)")
    fi

    if [[ -n "$NEW_DB" ]] && [[ "$NEW_DB" != "N/A" ]] && [[ "$NEW_DB" != "NEEDS CLARIFICATION" ]] && ! grep -q "$NEW_DB" "$target_file"; then
        new_tech_entries+=("- $NEW_DB ($CURRENT_BRANCH)")
    fi

    # 准备新更改条目
    if [[ -n "$tech_stack" ]]; then
        new_change_entry="- $CURRENT_BRANCH: 添加了 $tech_stack"
    elif [[ -n "$NEW_DB" ]] && [[ "$NEW_DB" != "N/A" ]] && [[ "$NEW_DB" != "NEEDS CLARIFICATION" ]]; then
        new_change_entry="- $CURRENT_BRANCH: 添加了 $NEW_DB"
    fi

    # 检查文件中是否存在部分
    local has_active_technologies=0
    local has_recent_changes=0

    if grep -q "^## 活跃技术" "$target_file" 2>/dev/null; then
        has_active_technologies=1
    fi

    if grep -q "^## 最近的更改" "$target_file" 2>/dev/null; then
        has_recent_changes=1
    fi

    # 逐行处理文件
    local in_tech_section=false
    local in_changes_section=false
    local tech_entries_added=false
    local changes_entries_added=false
    local existing_changes_count=0
    local file_ended=false

    while IFS= read -r line || [[ -n "$line" ]]; do
        # 处理活跃技术部分
        if [[ "$line" == "## 活跃技术" ]]; then
            echo "$line" >> "$temp_file"
            in_tech_section=true
            continue
        elif [[ $in_tech_section == true ]] && [[ "$line" =~ ^##[[:space:]] ]]; then
            # 在关闭部分之前添加新技术条目
            if [[ $tech_entries_added == false ]] && [[ ${#new_tech_entries[@]} -gt 0 ]]; then
                printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"
                tech_entries_added=true
            fi
            echo "$line" >> "$temp_file"
            in_tech_section=false
            continue
        elif [[ $in_tech_section == true ]] && [[ -z "$line" ]]; then
            # 在技术部分的空行之前添加新技术条目
            if [[ $tech_entries_added == false ]] && [[ ${#new_tech_entries[@]} -gt 0 ]]; then
                printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"
                tech_entries_added=true
            fi
            echo "$line" >> "$temp_file"
            continue
        fi

        # 处理最近更改部分
        if [[ "$line" == "## 最近的更改" ]]; then
            echo "$line" >> "$temp_file"
            # 在标题后立即添加新更改条目
            if [[ -n "$new_change_entry" ]]; then
                echo "$new_change_entry" >> "$temp_file"
            fi
            in_changes_section=true
            changes_entries_added=true
            continue
        elif [[ $in_changes_section == true ]] && [[ "$line" =~ ^##[[:space:]] ]]; then
            echo "$line" >> "$temp_file"
            in_changes_section=false
            continue
        elif [[ $in_changes_section == true ]] && [[ "$line" == "- "* ]]; then
            # 仅保留前 2 个现有更改
            if [[ $existing_changes_count -lt 2 ]]; then
                echo "$line" >> "$temp_file"
                ((existing_changes_count++))
            fi
            continue
        fi

        # 更新时间戳
        if [[ "$line" =~ 最后更新:.*[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]]; then
            echo "$line" | sed "s/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/$current_date/" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$target_file"

    # 循环后检查：如果我们仍在活跃技术部分且尚未添加新条目
    if [[ $in_tech_section == true ]] && [[ $tech_entries_added == false ]] && [[ ${#new_tech_entries[@]} -gt 0 ]]; then
        printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"
        tech_entries_added=true
    fi

    # 如果部分不存在，在文件末尾添加它们
    if [[ $has_active_technologies -eq 0 ]] && [[ ${#new_tech_entries[@]} -gt 0 ]]; then
        echo "" >> "$temp_file"
        echo "## 活跃技术" >> "$temp_file"
        printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"
        tech_entries_added=true
    fi

    if [[ $has_recent_changes -eq 0 ]] && [[ -n "$new_change_entry" ]]; then
        echo "" >> "$temp_file"
        echo "## 最近的更改" >> "$temp_file"
        echo "$new_change_entry" >> "$temp_file"
        changes_entries_added=true
    fi

    # 原子地移动临时文件到目标
    if ! mv "$temp_file" "$target_file"; then
        log_error "更新目标文件失败"
        rm -f "$temp_file"
        return 1
    fi

    return 0
}
#==============================================================================
# 主代理文件更新函数
#==============================================================================

update_agent_file() {
    local target_file="$1"
    local agent_name="$2"

    if [[ -z "$target_file" ]] || [[ -z "$agent_name" ]]; then
        log_error "update_agent_file 需要 target_file 和 agent_name 参数"
        return 1
    fi

    log_info "正在更新 $agent_name 上下文文件: $target_file"

    local project_name
    project_name=$(basename "$REPO_ROOT")
    local current_date
    current_date=$(date +%Y-%m-%d)

    # 如果目录不存在，创建它
    local target_dir
    target_dir=$(dirname "$target_file")
    if [[ ! -d "$target_dir" ]]; then
        if ! mkdir -p "$target_dir"; then
            log_error "创建目录失败: $target_dir"
            return 1
        fi
    fi

    if [[ ! -f "$target_file" ]]; then
        # 从模板创建新文件
        local temp_file
        temp_file=$(mktemp) || {
            log_error "创建临时文件失败"
            return 1
        }

        if create_new_agent_file "$target_file" "$temp_file" "$project_name" "$current_date"; then
            if mv "$temp_file" "$target_file"; then
                log_success "已创建新的 $agent_name 上下文文件"
            else
                log_error "将临时文件移动到 $target_file 失败"
                rm -f "$temp_file"
                return 1
            fi
        else
            log_error "创建新代理文件失败"
            rm -f "$temp_file"
            return 1
        fi
    else
        # 更新现有文件
        if [[ ! -r "$target_file" ]]; then
            log_error "无法读取现有文件: $target_file"
            return 1
        fi

        if [[ ! -w "$target_file" ]]; then
            log_error "无法写入现有文件: $target_file"
            return 1
        fi

        if update_existing_agent_file "$target_file" "$current_date"; then
            log_success "已更新现有的 $agent_name 上下文文件"
        else
            log_error "更新现有代理文件失败"
            return 1
        fi
    fi

    return 0
}

#==============================================================================
# 代理选择和处理
#==============================================================================

update_specific_agent() {
    local agent_type="$1"

    case "$agent_type" in
        claude)
            update_agent_file "$CLAUDE_FILE" "Claude Code"
            ;;
        gemini)
            update_agent_file "$GEMINI_FILE" "Gemini CLI"
            ;;
        copilot)
            update_agent_file "$COPILOT_FILE" "GitHub Copilot"
            ;;
        cursor-agent)
            update_agent_file "$CURSOR_FILE" "Cursor IDE"
            ;;
        qwen)
            update_agent_file "$QWEN_FILE" "Qwen Code"
            ;;
        opencode)
            update_agent_file "$AGENTS_FILE" "opencode"
            ;;
        codex)
            update_agent_file "$AGENTS_FILE" "Codex CLI"
            ;;
        windsurf)
            update_agent_file "$WINDSURF_FILE" "Windsurf"
            ;;
        kilocode)
            update_agent_file "$KILOCODE_FILE" "Kilo Code"
            ;;
        auggie)
            update_agent_file "$AUGGIE_FILE" "Auggie CLI"
            ;;
        roo)
            update_agent_file "$ROO_FILE" "Roo Code"
            ;;
        codebuddy)
            update_agent_file "$CODEBUDDY_FILE" "CodeBuddy CLI"
            ;;
        qoder)
            update_agent_file "$QODER_FILE" "Qoder CLI"
            ;;
        amp)
            update_agent_file "$AMP_FILE" "Amp"
            ;;
        shai)
            update_agent_file "$SHAI_FILE" "SHAI"
            ;;
        q)
            update_agent_file "$Q_FILE" "Amazon Q Developer CLI"
            ;;
        bob)
            update_agent_file "$BOB_FILE" "IBM Bob"
            ;;
        *)
            log_error "未知代理类型 '$agent_type'"
            log_error "期望: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|amp|shai|q|bob|qoder"
            exit 1
            ;;
    esac
}

update_all_existing_agents() {
    local found_agent=false

    # 检查每个可能的代理文件，如果存在则更新
    if [[ -f "$CLAUDE_FILE" ]]; then
        update_agent_file "$CLAUDE_FILE" "Claude Code"
        found_agent=true
    fi

    if [[ -f "$GEMINI_FILE" ]]; then
        update_agent_file "$GEMINI_FILE" "Gemini CLI"
        found_agent=true
    fi

    if [[ -f "$COPILOT_FILE" ]]; then
        update_agent_file "$COPILOT_FILE" "GitHub Copilot"
        found_agent=true
    fi

    if [[ -f "$CURSOR_FILE" ]]; then
        update_agent_file "$CURSOR_FILE" "Cursor IDE"
        found_agent=true
    fi

    if [[ -f "$QWEN_FILE" ]]; then
        update_agent_file "$QWEN_FILE" "Qwen Code"
        found_agent=true
    fi

    if [[ -f "$AGENTS_FILE" ]]; then
        update_agent_file "$AGENTS_FILE" "Codex/opencode"
        found_agent=true
    fi

    if [[ -f "$WINDSURF_FILE" ]]; then
        update_agent_file "$WINDSURF_FILE" "Windsurf"
        found_agent=true
    fi

    if [[ -f "$KILOCODE_FILE" ]]; then
        update_agent_file "$KILOCODE_FILE" "Kilo Code"
        found_agent=true
    fi

    if [[ -f "$AUGGIE_FILE" ]]; then
        update_agent_file "$AUGGIE_FILE" "Auggie CLI"
        found_agent=true
    fi

    if [[ -f "$ROO_FILE" ]]; then
        update_agent_file "$ROO_FILE" "Roo Code"
        found_agent=true
    fi

    if [[ -f "$CODEBUDDY_FILE" ]]; then
        update_agent_file "$CODEBUDDY_FILE" "CodeBuddy CLI"
        found_agent=true
    fi

    if [[ -f "$SHAI_FILE" ]]; then
        update_agent_file "$SHAI_FILE" "SHAI"
        found_agent=true
    fi

    if [[ -f "$QODER_FILE" ]]; then
        update_agent_file "$QODER_FILE" "Qoder CLI"
        found_agent=true
    fi

    if [[ -f "$Q_FILE" ]]; then
        update_agent_file "$Q_FILE" "Amazon Q Developer CLI"
        found_agent=true
    fi

    if [[ -f "$BOB_FILE" ]]; then
        update_agent_file "$BOB_FILE" "IBM Bob"
        found_agent=true
    fi

    # 如果不存在代理文件，创建默认 Claude 文件
    if [[ "$found_agent" == false ]]; then
        log_info "未找到现有代理文件，正在创建默认 Claude 文件..."
        update_agent_file "$CLAUDE_FILE" "Claude Code"
    fi
}
print_summary() {
    echo
    log_info "更改摘要:"

    if [[ -n "$NEW_LANG" ]]; then
        echo "  - 添加了语言: $NEW_LANG"
    fi

    if [[ -n "$NEW_FRAMEWORK" ]]; then
        echo "  - 添加了框架: $NEW_FRAMEWORK"
    fi

    if [[ -n "$NEW_DB" ]] && [[ "$NEW_DB" != "N/A" ]]; then
        echo "  - 添加了数据库: $NEW_DB"
    fi

    echo

    log_info "用法: $0 [claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|codebuddy|shai|q|bob|qoder]"
}

#==============================================================================
# 主执行
#==============================================================================

main() {
    # 在继续之前验证环境
    validate_environment

    log_info "=== 正在更新功能 $CURRENT_BRANCH 的代理上下文文件 ==="

    # 解析计划文件以提取项目信息
    if ! parse_plan_data "$NEW_PLAN"; then
        log_error "解析计划数据失败"
        exit 1
    fi

    # 根据代理类型参数处理
    local success=true

    if [[ -z "$AGENT_TYPE" ]]; then
        # 未提供特定代理 - 更新所有现有代理文件
        log_info "未指定代理，正在更新所有现有代理文件..."
        if ! update_all_existing_agents; then
            success=false
        fi
    else
        # 提供了特定代理 - 仅更新该代理
        log_info "正在更新特定代理: $AGENT_TYPE"
        if ! update_specific_agent "$AGENT_TYPE"; then
            success=false
        fi
    fi

    # 打印摘要
    print_summary

    if [[ "$success" == true ]]; then
        log_success "代理上下文更新成功完成"
        exit 0
    else
        log_error "代理上下文更新完成，但存在错误"
        exit 1
    fi
}

# 如果脚本直接运行，执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

