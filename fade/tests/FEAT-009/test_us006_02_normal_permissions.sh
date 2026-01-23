#!/bin/bash
# Test: verify fade quick (without --yolo) uses normal permission model
# AC: fade quick (without --yolo) uses normal permission model

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

# Assert 1 - verify yolo_mode defaults to false
if ! echo "$cmd_quick_content" | grep -qE 'yolo_mode=false|local yolo_mode=false'; then
    echo "FAIL: yolo_mode doesn't default to false"
    echo "Expected: yolo_mode=false as default"
    exit 1
fi

# Assert 2 - verify claude_cmd is just "claude" when not yolo
if ! echo "$cmd_quick_content" | grep -qE 'claude_cmd="claude"'; then
    echo "FAIL: claude_cmd not set to plain 'claude'"
    echo "Expected: claude_cmd=\"claude\" for non-yolo mode"
    exit 1
fi

# Assert 3 - verify conditional structure (if yolo then add flag, else plain)
if ! echo "$cmd_quick_content" | grep -qE 'if.*yolo_mode.*true'; then
    echo "FAIL: No conditional check for yolo_mode"
    echo "Expected: conditional to add --dangerously-skip-permissions only when yolo"
    exit 1
fi

echo "PASS: fade quick without --yolo uses normal permission model"
exit 0
