#!/bin/bash
# Test: verify quick mode context is minimal - just FADE.md and task, no PRD protocol
# AC: Context is minimal - just FADE.md and task, no PRD protocol

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

# Assert 1 - verify PRD files are NOT referenced
if echo "$cmd_quick_content" | grep -qE 'prd\.json|prds/|PRD Discovery'; then
    echo "FAIL: cmd_quick references PRD files"
    echo "Expected: no PRD file references in quick mode"
    exit 1
fi

# Assert 2 - verify prompt.md is NOT included (full PRD protocol)
if echo "$cmd_quick_content" | grep -q 'prompt\.md'; then
    echo "FAIL: cmd_quick includes prompt.md"
    echo "Expected: no prompt.md reference - quick mode has minimal context"
    exit 1
fi

# Assert 3 - verify learned.md is NOT included (that's for PRD workflow)
if echo "$cmd_quick_content" | grep -q 'learned\.md'; then
    echo "FAIL: cmd_quick includes learned.md"
    echo "Expected: no learned.md reference - quick mode is single-task"
    exit 1
fi

# Assert 4 - verify quick mode explicitly states it's NOT story-based
if ! echo "$cmd_quick_content" | grep -qiE "not.*story|single.task|without PRD"; then
    echo "FAIL: cmd_quick doesn't clearly state it's not story-based"
    echo "Expected: explicit instruction that this is not story workflow"
    exit 1
fi

echo "PASS: quick mode context is minimal without PRD protocol"
exit 0
