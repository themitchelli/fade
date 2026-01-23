#!/bin/bash
# Test: verify fade quick --yolo passes --dangerously-skip-permissions to Claude
# AC: fade quick --yolo passes --dangerously-skip-permissions to Claude

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helper.sh"

# Setup
FADE_CLI_PATH=$(find_fade_cli)
if [[ -z "$FADE_CLI_PATH" ]]; then
    echo "FAIL: Could not locate fade-cli script"
    exit 1
fi

# Act - extract the cmd_quick function
cmd_quick_content=$(extract_cmd_quick "$FADE_CLI_PATH")
if [[ -z "$cmd_quick_content" ]]; then
    echo "FAIL: Could not extract cmd_quick function"
    exit 1
fi

# Assert 1 - verify --yolo flag parsing
if ! echo "$cmd_quick_content" | grep -q '\-\-yolo'; then
    echo "FAIL: --yolo flag not parsed in cmd_quick"
    echo "Expected: --yolo flag handling"
    exit 1
fi

# Assert 2 - verify --dangerously-skip-permissions is used
if ! echo "$cmd_quick_content" | grep -q '\-\-dangerously-skip-permissions'; then
    echo "FAIL: --dangerously-skip-permissions not in cmd_quick"
    echo "Expected: --dangerously-skip-permissions flag for yolo mode"
    exit 1
fi

# Assert 3 - verify yolo_mode variable controls the flag
if ! echo "$cmd_quick_content" | grep -qE 'yolo_mode.*true|if.*yolo_mode.*true'; then
    echo "FAIL: yolo_mode variable not used"
    echo "Expected: yolo_mode variable to control permission flag"
    exit 1
fi

# Assert 4 - verify conditional claude command based on yolo
if ! echo "$cmd_quick_content" | grep -qE 'claude.*--dangerously-skip-permissions'; then
    echo "FAIL: Claude command doesn't include --dangerously-skip-permissions"
    echo "Expected: claude --dangerously-skip-permissions when yolo mode"
    exit 1
fi

echo "PASS: fade quick --yolo passes --dangerously-skip-permissions to Claude"
exit 0
