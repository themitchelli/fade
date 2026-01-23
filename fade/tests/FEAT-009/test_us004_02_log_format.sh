#!/bin/bash
# Test: verify quick mode log format matches expected pattern
# AC: Log format: '## YYYY-MM-DD HH:MM - QUICK: task description - COMPLETE'

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

# Assert 1 - verify date format is included (YYYY-MM-DD HH:MM)
if ! echo "$cmd_quick_content" | grep -qE '%Y-%m-%d %H:%M|YYYY-MM-DD HH:MM'; then
    echo "FAIL: Date format not found in log template"
    echo "Expected: YYYY-MM-DD HH:MM date format"
    exit 1
fi

# Assert 2 - verify QUICK: prefix in format
if ! echo "$cmd_quick_content" | grep -q 'QUICK:'; then
    echo "FAIL: 'QUICK:' prefix not found in log format"
    echo "Expected: 'QUICK:' prefix in log entries"
    exit 1
fi

# Assert 3 - verify COMPLETE marker in format
if ! echo "$cmd_quick_content" | grep -qE 'COMPLETE|complete'; then
    echo "FAIL: 'COMPLETE' marker not found in log format"
    echo "Expected: 'COMPLETE' status in log entries"
    exit 1
fi

# Assert 4 - verify ## header format
if ! echo "$cmd_quick_content" | grep -qE '##.*QUICK'; then
    echo "FAIL: Log entry doesn't use ## header format"
    echo "Expected: ## markdown header for log entries"
    exit 1
fi

echo "PASS: quick mode log format matches expected pattern"
exit 0
