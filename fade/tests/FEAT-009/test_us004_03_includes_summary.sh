#!/bin/bash
# Test: verify quick mode log includes brief summary of what was done
# AC: Includes brief summary of what was done

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

# Assert 1 - verify summary instruction in log template
if ! echo "$cmd_quick_content" | grep -qiE "summary|what was done"; then
    echo "FAIL: No summary instruction in log template"
    echo "Expected: instruction to include summary"
    exit 1
fi

# Assert 2 - verify files changed is part of log format
if ! echo "$cmd_quick_content" | grep -qiE "files changed|files.*list"; then
    echo "FAIL: 'Files changed' not in log format"
    echo "Expected: list of files changed in log"
    exit 1
fi

echo "PASS: quick mode log includes brief summary"
exit 0
