#!/bin/bash
# Test: verify quick mode prompt instructs Claude to commit changes when done
# AC: Quick mode prompt instructs Claude to commit changes when done

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

# Assert 1 - verify commit instruction exists
if ! echo "$cmd_quick_content" | grep -qiE "commit.*changes|commit them"; then
    echo "FAIL: Quick mode prompt doesn't instruct committing changes"
    echo "Expected: instruction to commit changes when done"
    exit 1
fi

# Assert 2 - verify commit is part of numbered steps
if ! echo "$cmd_quick_content" | grep -qE "[0-9]\..*(commit|Commit)"; then
    echo "FAIL: Commit instruction not in numbered steps"
    echo "Expected: commit instruction in numbered steps"
    exit 1
fi

echo "PASS: quick mode prompt instructs committing changes when done"
exit 0
