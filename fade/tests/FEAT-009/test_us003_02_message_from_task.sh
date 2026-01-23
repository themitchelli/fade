#!/bin/bash
# Test: verify commit message is derived from task description
# AC: Commit message derived from task description

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

# Assert 1 - verify instruction to derive message from task
if ! echo "$cmd_quick_content" | grep -qiE "derive.*message.*task|message.*from.*task"; then
    echo "FAIL: No instruction to derive commit message from task"
    echo "Expected: instruction to derive message from task description"
    exit 1
fi

# Assert 2 - verify task_description is referenced in commit context
# The pattern is: "Derive the message from the task: \"$task_description\""
if ! echo "$cmd_quick_content" | grep -q 'task_description'; then
    echo "FAIL: Task description not referenced for commit message"
    echo "Expected: task_description referenced in commit context"
    exit 1
fi

# Assert 3 - verify examples show task-to-commit derivation
if ! echo "$cmd_quick_content" | grep -qE 'Example.*task.*commit|task.*commit'; then
    echo "FAIL: No examples of task-to-commit message derivation"
    echo "Expected: examples showing task description to commit message"
    exit 1
fi

echo "PASS: commit message is derived from task description"
exit 0
