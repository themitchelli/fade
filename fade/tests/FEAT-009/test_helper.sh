#!/bin/bash
# Test helper functions for FEAT-009 tests

# Find the fade CLI script path
find_fade_cli() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local cli_path="${FADE_CLI_PATH:-$(which fade 2>/dev/null)}"

    # If fade is a symlink, resolve to actual script
    if [[ -L "$cli_path" ]]; then
        cli_path=$(readlink "$cli_path")
    fi

    # Find the bin/fade-cli in the repo
    if [[ ! -f "$cli_path" ]]; then
        cli_path="$script_dir/../../../bin/fade-cli"
    fi

    if [[ ! -f "$cli_path" ]]; then
        echo ""
        return 1
    fi

    echo "$cli_path"
}

# Extract the cmd_quick function from the CLI script
# Uses line numbers for portability across macOS and Linux
extract_cmd_quick() {
    local cli_path="$1"

    if [[ ! -f "$cli_path" ]]; then
        echo ""
        return 1
    fi

    local start_line=$(grep -n "^cmd_quick()" "$cli_path" | head -1 | cut -d: -f1)
    local end_line=$(grep -n "^cmd_new()" "$cli_path" | head -1 | cut -d: -f1)

    if [[ -z "$start_line" ]] || [[ -z "$end_line" ]]; then
        echo ""
        return 1
    fi

    sed -n "${start_line},${end_line}p" "$cli_path"
}

# Extract the cmd_run function from the CLI script
extract_cmd_run() {
    local cli_path="$1"

    if [[ ! -f "$cli_path" ]]; then
        echo ""
        return 1
    fi

    local start_line=$(grep -n "^cmd_run()" "$cli_path" | head -1 | cut -d: -f1)
    local end_line=$(grep -n "^cmd_yolo()" "$cli_path" | head -1 | cut -d: -f1)

    if [[ -z "$start_line" ]] || [[ -z "$end_line" ]]; then
        echo ""
        return 1
    fi

    sed -n "${start_line},${end_line}p" "$cli_path"
}
