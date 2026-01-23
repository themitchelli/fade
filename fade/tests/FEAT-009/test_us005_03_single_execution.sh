#!/bin/bash
# Test: verify quick mode does not run in loop (single execution)
# AC: Quick mode does not run in loop (single execution)

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

# Assert 1 - verify exec is used (replaces process, no return = no loop)
if ! echo "$cmd_quick_content" | grep -qE 'exec.*\$claude_cmd|exec.*claude'; then
    echo "FAIL: Quick mode doesn't use exec for Claude command"
    echo "Expected: exec to replace process (ensures single execution)"
    exit 1
fi

# Assert 2 - verify no infinite loop or restart loop constructs
# Note: while [[ $# -gt 0 ]] is acceptable for argument parsing
# We're looking for patterns that indicate restarting/looping execution
if echo "$cmd_quick_content" | grep -qE 'while.*true.*do|infinite loop|restart loop'; then
    echo "FAIL: Quick mode contains infinite loop constructs"
    echo "Expected: no execution loops in quick mode"
    exit 1
fi

# Assert 3 - verify comment mentions single execution
if ! echo "$cmd_quick_content" | grep -qiE "single execution|no loop"; then
    echo "FAIL: No mention of single execution in code"
    echo "Expected: comment about single execution"
    exit 1
fi

echo "PASS: quick mode does not run in loop (single execution)"
exit 0
