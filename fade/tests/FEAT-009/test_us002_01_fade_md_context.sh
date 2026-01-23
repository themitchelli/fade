#!/bin/bash
# Test: verify quick mode includes FADE.md when it exists
# AC: If FADE.md exists, it's included in context

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

# Assert - check for FADE.md conditional inclusion
if ! echo "$cmd_quick_content" | grep -qE 'if.*-f.*FADE\.md|\[\[.*-f.*FADE\.md'; then
    echo "FAIL: cmd_quick doesn't check for FADE.md existence"
    echo "Expected: conditional check for FADE.md file"
    exit 1
fi

# Assert - check that FADE.md content is added to context
if ! echo "$cmd_quick_content" | grep -q 'cat FADE.md'; then
    echo "FAIL: cmd_quick doesn't include FADE.md content"
    echo "Expected: cat FADE.md to include file contents"
    exit 1
fi

# Assert - check context variable includes Project Context label
if ! echo "$cmd_quick_content" | grep -q 'Project Context'; then
    echo "FAIL: FADE.md not labeled as Project Context"
    echo "Expected: 'Project Context' label in context"
    exit 1
fi

echo "PASS: FADE.md is included in quick mode context when it exists"
exit 0
