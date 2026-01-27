#!/bin/bash
# FADE Workspace Library
# Extracted from fade-cli for maintainability
# Provides workspace/multi-repo management

# Color definitions (needed by workspace functions)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Optionally copy key learnings from repo-level learned.md to workspace-level learned.md
# This implements AC #3 from FEAT-024 US-002: record learnings at workspace level
copy_learnings_to_workspace() {
    local workspace_dir="${1:-}"
    local repo_learned_file="${2:-}"

    if [[ -z "$workspace_dir" ]] || [[ ! -d "$workspace_dir" ]]; then
        return 1
    fi

    if [[ -z "$repo_learned_file" ]] || [[ ! -f "$repo_learned_file" ]]; then
        return 1
    fi

    local workspace_learned="$workspace_dir/learned.md"
    if [[ ! -f "$workspace_learned" ]]; then
        return 1
    fi

    # Extract new learnings from repo learned.md since last session
    # (This is a simple implementation - production would use more sophisticated tracking)
    # For now, just append a summary if learnings were added
    local repo_name=$(basename "$(pwd)")
    local new_entries=$(tail -20 "$repo_learned_file" 2>/dev/null | grep "^## " | head -5)

    if [[ -n "$new_entries" ]]; then
        echo "" >> "$workspace_learned"
        echo "### Learnings from $repo_name" >> "$workspace_learned"
        echo "" >> "$workspace_learned"
        echo "$new_entries" | while read -r line; do
            echo "- $line" >> "$workspace_learned"
        done
    fi

    return 0
}

workspace_init() {
    local workspace_name="$1"
    local workspace_dir="$HOME/.fade/workspaces/$workspace_name"

    # Check if workspace already exists
    if [[ -d "$workspace_dir" ]]; then
        echo -e "${YELLOW}Workspace '$workspace_name' already exists at $workspace_dir${NC}"
        return 1
    fi

    # Create workspace directory structure
    mkdir -p "$workspace_dir"
    mkdir -p "$workspace_dir/standards"

    # Create workspace.json with empty repos array
    cat > "$workspace_dir/workspace.json" << EOF
{
  "name": "$workspace_name",
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "repos": []
}
EOF

    # Create learned.md for workspace-level learnings
    cat > "$workspace_dir/learned.md" << EOF
# Workspace Learnings: $workspace_name

Shared learnings across all repos in this workspace.

---

EOF

    # Create standards README
    cat > "$workspace_dir/standards/README.md" << EOF
# Workspace Standards

This directory contains standards that apply to all repos in the workspace.

Standards placed here will be loaded before repo-specific standards, with repo standards taking precedence.

EOF

    echo -e "${GREEN}✓ Workspace created: $workspace_dir${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Add repos: fade repo add <path>"
    echo "  2. Add workspace-level standards to $workspace_dir/standards/"
    echo "  3. Run commands: fade --repo <name> status"
}

workspace_list() {
    local workspaces_dir="$HOME/.fade/workspaces"

    if [[ ! -d "$workspaces_dir" ]]; then
        echo "No workspaces found. Create one with: fade workspace init <name>"
        return 0
    fi

    local workspace_count=0
    echo -e "${CYAN}Workspaces:${NC}"
    echo ""

    for workspace_dir in "$workspaces_dir"/*; do
        if [[ -d "$workspace_dir" ]] && [[ -f "$workspace_dir/workspace.json" ]]; then
            local workspace_name=$(basename "$workspace_dir")
            local repo_count=0

            # Count repos in workspace
            if command -v jq >/dev/null 2>&1; then
                repo_count=$(jq -r '.repos | length' "$workspace_dir/workspace.json" 2>/dev/null || echo "0")
            else
                # Fallback: count lines with "path" field
                repo_count=$(grep -c '"path"' "$workspace_dir/workspace.json" 2>/dev/null || echo "0")
            fi

            echo "  $workspace_name"
            echo "    Path: $workspace_dir"
            echo "    Repos: $repo_count"
            echo ""
            ((workspace_count++))
        fi
    done

    if [[ $workspace_count -eq 0 ]]; then
        echo "No workspaces found. Create one with: fade workspace init <name>"
    fi
}

workspace_path() {
    # Check if we're in a repo that's part of a workspace
    local current_workspace=$(get_current_workspace)

    if [[ -n "$current_workspace" ]]; then
        echo "$current_workspace"
    else
        echo "Not in a workspace. Create one with: fade workspace init <name>"
        return 1
    fi
}

get_current_workspace() {
    # Look for workspace by checking if current repo is registered
    local workspaces_dir="$HOME/.fade/workspaces"

    if [[ ! -d "$workspaces_dir" ]]; then
        return 1
    fi

    local current_dir=$(pwd)

    for workspace_dir in "$workspaces_dir"/*; do
        if [[ -f "$workspace_dir/workspace.json" ]]; then
            # Check if current directory matches any repo path
            if grep -q "\"path\": \"$current_dir\"" "$workspace_dir/workspace.json" 2>/dev/null; then
                echo "$workspace_dir"
                return 0
            fi
        fi
    done

    return 1
}

cmd_workspace() {
    local action="${1:-}"

    if [[ -z "$action" ]]; then
        echo "Usage: fade workspace <init|list|path>"
        echo ""
        echo "Actions:"
        echo "  init <name>  - Create a new workspace"
        echo "  list         - List all workspaces"
        echo "  path         - Show current workspace path"
        return 1
    fi

    case "$action" in
        init)
            local workspace_name="${2:-}"
            if [[ -z "$workspace_name" ]]; then
                echo "Error: Workspace name required"
                echo "Usage: fade workspace init <name>"
                return 1
            fi
            workspace_init "$workspace_name"
            ;;
        list)
            workspace_list
            ;;
        path)
            workspace_path
            ;;
        *)
            echo "Unknown workspace action: $action"
            echo "Usage: fade workspace <init|list|path>"
            return 1
            ;;
    esac
}
