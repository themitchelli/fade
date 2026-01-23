#!/bin/bash
# Test: Test generation uses correct Claude invocation for file creation
# AC: Test files are actually created after ALL_COMPLETE (via proper Claude invocation)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract the claude invocation line from run_test_generation
claude_line=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH" | grep 'claude.*--' | head -1)

if [[ -z "$claude_line" ]]; then
    echo "FAIL: Cannot find claude invocation in run_test_generation"
    exit 1
fi

# Check that --print flag is used (for non-interactive mode)
if ! echo "$claude_line" | grep -q '\-\-print'; then
    echo "FAIL: Claude invocation missing --print flag"
    echo "Expected: --print for non-interactive mode"
    echo "Actual: $claude_line"
    exit 1
fi

# Check that --dangerously-skip-permissions is used (for autonomous file creation)
if ! echo "$claude_line" | grep -q '\-\-dangerously-skip-permissions'; then
    echo "FAIL: Claude invocation missing --dangerously-skip-permissions flag"
    echo "Expected: --dangerously-skip-permissions for autonomous file creation"
    echo "Actual: $claude_line"
    exit 1
fi

# Verify the order: --print should come before --dangerously-skip-permissions
# This is the correct invocation for non-interactive autonomous mode
if ! echo "$claude_line" | grep -q '\-\-print.*\-\-dangerously-skip-permissions'; then
    echo "FAIL: Claude flags in wrong order"
    echo "Expected: --print --dangerously-skip-permissions"
    echo "Actual: $claude_line"
    exit 1
fi

echo "PASS: Test generation uses correct Claude invocation (--print --dangerously-skip-permissions)"
exit 0
