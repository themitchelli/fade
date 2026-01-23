#!/bin/bash
# Test: verify quick mode prompt instructs single-task completion, not story workflow
# AC: Quick mode prompt instructs single-task completion, not story workflow

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

# Assert 1 - verify SINGLE-TASK mode is mentioned
if ! echo "$cmd_quick_content" | grep -qi "single.task"; then
    echo "FAIL: Quick mode prompt doesn't mention SINGLE-TASK"
    echo "Expected: explicit 'SINGLE-TASK' instruction"
    exit 1
fi

# Assert 2 - verify instruction NOT to look for PRD files
if ! echo "$cmd_quick_content" | grep -qiE "do NOT.*look for PRD|NOT.*PRD files"; then
    echo "FAIL: Quick mode doesn't instruct to skip PRD files"
    echo "Expected: instruction to NOT look for PRD files"
    exit 1
fi

# Assert 3 - verify instruction NOT to output story signals
if ! echo "$cmd_quick_content" | grep -qiE "NOT.*STORY_DONE|NOT.*ALL_COMPLETE"; then
    echo "FAIL: Quick mode doesn't instruct to skip story signals"
    echo "Expected: instruction to NOT output STORY_DONE or ALL_COMPLETE"
    exit 1
fi

# Assert 4 - verify instruction NOT to follow story protocol
if ! echo "$cmd_quick_content" | grep -qiE "NOT.*story completion protocol|NOT.*story.based workflow"; then
    echo "FAIL: Quick mode doesn't instruct to skip story protocol"
    echo "Expected: instruction to NOT follow story completion protocol"
    exit 1
fi

# Assert 5 - verify task description is included in prompt
if ! echo "$cmd_quick_content" | grep -q '\$task_description'; then
    echo "FAIL: Task description variable not included in prompt"
    echo "Expected: \$task_description in context"
    exit 1
fi

echo "PASS: quick mode prompt instructs single-task completion"
exit 0
