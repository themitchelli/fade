#!/bin/bash
# FADE Dashboard Library
# Extracted from fade-cli for maintainability
# Provides dashboard commands for multi-repo monitoring

# Color definitions (needed by dashboard functions)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get dashboard config directory
get_dashboard_config_dir() {
    echo "${HOME}/.fade-dashboard"
}

# Get dashboard config file path
get_dashboard_config_file() {
    local config_dir
    config_dir=$(get_dashboard_config_dir)
    echo "${config_dir}/config.json"
}

# Initialize dashboard config directory
init_dashboard_config() {
    local config_dir
    config_dir=$(get_dashboard_config_dir)

    if [[ ! -d "$config_dir" ]]; then
        mkdir -p "$config_dir"
    fi
}

# Read dashboard config (returns JSON or empty object if not exists)
read_dashboard_config() {
    local config_file
    config_file=$(get_dashboard_config_file)

    if [[ -f "$config_file" ]]; then
        cat "$config_file"
    else
        echo '{"repos":[],"port":8080,"refreshInterval":30}'
    fi
}

# Write dashboard config (accepts JSON string)
write_dashboard_config() {
    local json="$1"
    local config_file
    config_file=$(get_dashboard_config_file)

    init_dashboard_config

    # Atomic write
    local temp_file="${config_file}.tmp.$$"
    echo "$json" > "$temp_file"
    mv "$temp_file" "$config_file"
}

# Check if path is a FADE repo
is_fade_repo() {
    local repo_path="$1"

    if [[ ! -d "$repo_path" ]]; then
        return 1
    fi

    # Check for FADE.md or fade/ directory
    if [[ -f "$repo_path/FADE.md" ]] || [[ -d "$repo_path/fade" ]]; then
        return 0
    fi

    return 1
}

# Get repo display name from path
get_repo_display_name() {
    local repo_path="$1"

    # Try to extract name from FADE.md first line (after # )
    if [[ -f "$repo_path/FADE.md" ]]; then
        local first_heading
        first_heading=$(grep -m 1 "^# " "$repo_path/FADE.md" 2>/dev/null | sed 's/^# //')
        if [[ -n "$first_heading" ]] && [[ "$first_heading" != "Project Name" ]]; then
            echo "$first_heading"
            return
        fi
    fi

    # Fallback to directory name
    basename "$repo_path"
}

# Add repo to dashboard config
dashboard_add_repo() {
    local repo_path="$1"
    local display_name="$2"

    # Resolve to absolute path
    repo_path=$(cd "$repo_path" 2>/dev/null && pwd) || {
        echo -e "${RED}Error: Path does not exist: $1${NC}" >&2
        return 1
    }

    # Validate it's a FADE repo
    if ! is_fade_repo "$repo_path"; then
        echo -e "${RED}Error: Not a FADE repository (no FADE.md or fade/ found): $repo_path${NC}" >&2
        return 1
    fi

    # Auto-detect display name if not provided
    if [[ -z "$display_name" ]]; then
        display_name=$(get_repo_display_name "$repo_path")
    fi

    # Read current config
    local config
    config=$(read_dashboard_config)

    # Check if repo already exists
    if echo "$config" | grep -q "\"path\":\"$repo_path\""; then
        echo -e "${YELLOW}Repository already configured: $repo_path${NC}" >&2
        return 0
    fi

    # Add repo to config (simple JSON manipulation using jq-like bash)
    # Extract current repos array, add new repo, rebuild config
    local new_repo="{\"path\":\"$repo_path\",\"name\":\"$display_name\"}"

    # Simple JSON append (works without jq)
    local repos_json
    repos_json=$(echo "$config" | grep -o '"repos":\[.*\]' | sed 's/"repos":\[//' | sed 's/\]$//')

    if [[ -z "$repos_json" ]] || [[ "$repos_json" == "null" ]]; then
        # Empty repos array
        config="{\"repos\":[$new_repo],\"port\":8080,\"refreshInterval\":30}"
    else
        # Append to existing repos
        config="{\"repos\":[$repos_json,$new_repo],\"port\":8080,\"refreshInterval\":30}"
    fi

    # Write updated config
    write_dashboard_config "$config"

    echo -e "${GREEN}Added repository: $display_name${NC}"
    echo "  Path: $repo_path"
}

# List configured repos
dashboard_list_repos() {
    local config
    config=$(read_dashboard_config)

    # Extract repos count
    local repos_count
    repos_count=$(echo "$config" | grep -o '"path"' | wc -l | tr -d ' ')

    if [[ "$repos_count" -eq 0 ]]; then
        echo -e "${YELLOW}No repositories configured${NC}"
        echo ""
        echo "Add repositories with: fade dashboard --add /path/to/repo"
        return
    fi

    echo -e "${CYAN}Configured Repositories:${NC}"
    echo ""

    # Parse and display repos (without jq dependency)
    # Extract each repo entry and display
    local i=1
    while true; do
        local repo_path
        local repo_name

        # Extract path for repo $i
        repo_path=$(echo "$config" | grep -o "\"path\":\"[^\"]*\"" | sed -n "${i}p" | sed 's/"path":"//' | sed 's/"$//')

        if [[ -z "$repo_path" ]]; then
            break
        fi

        # Extract name for repo $i
        repo_name=$(echo "$config" | grep -o "\"name\":\"[^\"]*\"" | sed -n "${i}p" | sed 's/"name":"//' | sed 's/"$//')

        # Validate path still exists
        if [[ -d "$repo_path" ]]; then
            echo -e "${GREEN}✓${NC} $repo_name"
            echo "  Path: $repo_path"
        else
            echo -e "${RED}✗${NC} $repo_name ${YELLOW}(path not found)${NC}"
            echo "  Path: $repo_path"
        fi
        echo ""

        i=$((i + 1))
    done
}

# Auto-discover FADE repos in parent directory
dashboard_auto_discover() {
    local current_dir
    current_dir=$(pwd)
    local parent_dir
    parent_dir=$(dirname "$current_dir")

    echo -e "${CYAN}Scanning for FADE repositories in: $parent_dir${NC}"
    echo ""

    local found_count=0
    local config
    config=$(read_dashboard_config)

    # Find directories with FADE.md or fade/ folder
    while IFS= read -r repo_dir; do
        # Resolve to absolute path
        repo_dir=$(cd "$repo_dir" 2>/dev/null && pwd) || continue

        # Skip current directory
        if [[ "$repo_dir" == "$current_dir" ]]; then
            continue
        fi

        # Check if already configured
        if echo "$config" | grep -q "\"path\":\"$repo_dir\""; then
            continue
        fi

        local display_name
        display_name=$(get_repo_display_name "$repo_dir")

        echo -e "${GREEN}Found:${NC} $display_name"
        echo "  Path: $repo_dir"

        # Prompt to add
        read -p "Add to dashboard? [y/N] " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            dashboard_add_repo "$repo_dir" "$display_name"
            # Reload config after adding
            config=$(read_dashboard_config)
            found_count=$((found_count + 1))
        fi

        echo ""
    done < <(find "$parent_dir" -maxdepth 1 -type d -exec sh -c 'test -f "$1/FADE.md" || test -d "$1/fade"' _ {} \; -print 2>/dev/null)

    if [[ $found_count -eq 0 ]]; then
        echo "No new FADE repositories found."
    else
        echo -e "${GREEN}Added $found_count repositor$([ $found_count -eq 1 ] && echo "y" || echo "ies")${NC}"
    fi
}

dashboard_start_server() {
    local remote_flag="${1:-}"
    local password_flag="${2:-}"
    local cert_flag="${3:-}"
    local key_flag="${4:-}"

    local config_path="$HOME/.fade-dashboard/config.json"

    # Check if config exists
    if [[ ! -f "$config_path" ]]; then
        echo -e "${RED}ERROR: Dashboard not configured${NC}"
        echo ""
        echo "Run 'fade dashboard --add /path/to/repo' to add repositories"
        exit 1
    fi

    # Check if Python 3 is available
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}ERROR: Python 3 is required to run the dashboard server${NC}"
        echo ""
        echo "Please install Python 3 and try again"
        exit 1
    fi

    # Find dashboard server script
    local server_script
    # Try to find it relative to this script
    local script_dir
    script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
    server_script="$script_dir/fade/lib/dashboard-server.py"

    if [[ ! -f "$server_script" ]]; then
        echo -e "${RED}ERROR: Dashboard server script not found${NC}"
        echo "Expected location: $server_script"
        exit 1
    fi

    # Make server script executable
    chmod +x "$server_script" 2>/dev/null || true

    # Launch server with flags
    echo -e "${CYAN}Starting FADE Dashboard...${NC}"
    echo ""
    exec python3 "$server_script" $remote_flag $password_flag $cert_flag $key_flag
}

cmd_dashboard() {
    local action=""
    local repo_path=""
    local repo_name=""
    local remote_flag=""
    local password_flag=""
    local cert_flag=""
    local key_flag=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --add)
                action="add"
                shift
                if [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-- ]]; then
                    repo_path="$1"
                    shift
                else
                    echo -e "${RED}Error: --add requires a path argument${NC}"
                    echo ""
                    echo "Usage: fade dashboard --add /path/to/repo [--name \"Display Name\"]"
                    exit 1
                fi
                ;;
            --name)
                shift
                if [[ $# -gt 0 ]]; then
                    repo_name="$1"
                    shift
                else
                    echo -e "${RED}Error: --name requires a value${NC}"
                    exit 1
                fi
                ;;
            --list)
                action="list"
                shift
                ;;
            --discover)
                action="discover"
                shift
                ;;
            --remote)
                remote_flag="--remote"
                shift
                ;;
            --password)
                shift
                if [[ $# -gt 0 ]]; then
                    password_flag="--password $1"
                    shift
                else
                    echo -e "${RED}Error: --password requires a value${NC}"
                    exit 1
                fi
                ;;
            --cert)
                shift
                if [[ $# -gt 0 ]]; then
                    cert_flag="--cert $1"
                    shift
                else
                    echo -e "${RED}Error: --cert requires a path to certificate file${NC}"
                    exit 1
                fi
                ;;
            --key)
                shift
                if [[ $# -gt 0 ]]; then
                    key_flag="--key $1"
                    shift
                else
                    echo -e "${RED}Error: --key requires a path to key file${NC}"
                    exit 1
                fi
                ;;
            -*)
                echo -e "${RED}Error: Unknown option '$1'${NC}"
                echo ""
                echo "Usage: fade dashboard [--add <path>] [--list] [--discover] [--remote] [--password <pass>] [--cert <file>] [--key <file>]"
                exit 1
                ;;
            *)
                # Unknown argument
                echo -e "${RED}Error: Unknown argument '$1'${NC}"
                echo ""
                echo "Usage: fade dashboard [--add <path>] [--list] [--discover] [--remote] [--password <pass>] [--cert <file>] [--key <file>]"
                exit 1
                ;;
        esac
    done

    # Execute action
    case "$action" in
        add)
            dashboard_add_repo "$repo_path" "$repo_name"
            ;;
        list)
            dashboard_list_repos
            ;;
        discover)
            dashboard_auto_discover
            ;;
        "")
            # No action specified - start dashboard server
            dashboard_start_server "$remote_flag" "$password_flag" "$cert_flag" "$key_flag"
            ;;
    esac
}
