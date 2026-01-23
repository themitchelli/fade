#!/bin/bash
# Test: verify quick mode prompt instructs appending to progress.md
# AC: Quick mode prompt instructs appending to progress.md

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

# Assert 1 - verify progress.md is mentioned
if ! echo "$cmd_quick_content" | grep -q 'progress\.md'; then
    echo "FAIL: progress.md not mentioned in quick mode"
    echo "Expected: reference to progress.md for logging"
    exit 1
fi

# Assert 2 - verify append instruction
if ! echo "$cmd_quick_content" | grep -qiE "append.*progress|progress.*append"; then
    echo "FAIL: No append instruction for progress.md"
    echo "Expected: instruction to append to progress.md"
    exit 1
fi

# Assert 3 - verify Progress Logging section exists
if ! echo "$cmd_quick_content" | grep -q 'Progress Logging'; then
    echo "FAIL: No 'Progress Logging' section in quick mode context"
    echo "Expected: dedicated Progress Logging section"
    exit 1
fi

echo "PASS: quick mode prompt instructs appending to progress.md"
exit 0
