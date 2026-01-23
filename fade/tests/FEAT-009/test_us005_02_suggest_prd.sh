#!/bin/bash
# Test: verify quick mode suggests creating PRD for large tasks
# AC: If task seems large, Claude should suggest creating a PRD instead

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

# Assert 1 - verify PRD suggestion for large tasks
if ! echo "$cmd_quick_content" | grep -qiE "too large.*quick|suggest.*prd|recommend.*prd|create.*prd"; then
    echo "FAIL: No PRD suggestion for large tasks"
    echo "Expected: instruction to suggest PRD for large tasks"
    exit 1
fi

# Assert 2 - verify fade new command is mentioned
if ! echo "$cmd_quick_content" | grep -q "fade new"; then
    echo "FAIL: 'fade new' command not mentioned"
    echo "Expected: mention of 'fade new' to create PRD"
    exit 1
fi

# Assert 3 - verify STOP instruction for large tasks
if ! echo "$cmd_quick_content" | grep -qiE "STOP.*recommend|too large.*quick.*STOP"; then
    echo "FAIL: No STOP instruction for large tasks"
    echo "Expected: instruction to STOP if task is too large"
    exit 1
fi

echo "PASS: quick mode suggests creating PRD for large tasks"
exit 0
