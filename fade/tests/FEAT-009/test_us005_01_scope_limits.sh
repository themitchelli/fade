#!/bin/bash
# Test: verify quick mode prompt limits scope to single-file or few-file changes
# AC: Quick mode prompt limits scope to single-file or few-file changes

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

# Assert 1 - verify Scope Limits section exists
if ! echo "$cmd_quick_content" | grep -q 'Scope Limits'; then
    echo "FAIL: No 'Scope Limits' section found"
    echo "Expected: dedicated scope limits section"
    exit 1
fi

# Assert 2 - verify single file or few files mentioned
if ! echo "$cmd_quick_content" | grep -qiE "single file|few.*file|small.*change|focused"; then
    echo "FAIL: Scope limit doesn't mention file count"
    echo "Expected: mention of single file or few files"
    exit 1
fi

# Assert 3 - verify explicit file count boundary (3+ files)
if ! echo "$cmd_quick_content" | grep -qE '3\+.*file|3.*unrelated'; then
    echo "FAIL: No explicit file count boundary"
    echo "Expected: mention of 3+ files as boundary"
    exit 1
fi

# Assert 4 - verify mention of what's NOT appropriate for quick mode
if ! echo "$cmd_quick_content" | grep -qiE "no architectural|no.*new features|no.*multi.step|no.*refactor"; then
    echo "FAIL: Doesn't specify what's not appropriate for quick mode"
    echo "Expected: examples of what's too large for quick mode"
    exit 1
fi

echo "PASS: quick mode prompt limits scope to single-file or few-file changes"
exit 0
