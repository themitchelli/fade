#!/bin/bash
# Test: verify quick mode only commits if changes were made
# AC: Only commits if changes were made

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

# Assert 1 - verify conditional commit instruction exists
if ! echo "$cmd_quick_content" | grep -qiE "only commit.*if|commit.*if.*change|skip commit"; then
    echo "FAIL: No conditional commit instruction"
    echo "Expected: instruction to only commit if changes were made"
    exit 1
fi

# Assert 2 - verify explicit mention of skipping commit when no changes
if ! echo "$cmd_quick_content" | grep -qiE "skip commit|no files.*modified|actually made changes"; then
    echo "FAIL: No instruction about skipping commit when no changes"
    echo "Expected: instruction about what to do if no changes"
    exit 1
fi

echo "PASS: quick mode only commits if changes were made"
exit 0
