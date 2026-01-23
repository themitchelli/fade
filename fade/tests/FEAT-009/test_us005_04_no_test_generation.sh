#!/bin/bash
# Test: verify quick mode does not include regression test generation
# AC: No regression test generation for quick tasks

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

# Assert 1 - verify no test generation instructions
if echo "$cmd_quick_content" | grep -qiE "test generation|generate.*test|regression test|TESTS_GENERATED"; then
    echo "FAIL: Quick mode includes test generation instructions"
    echo "Expected: no test generation in quick mode"
    exit 1
fi

# Assert 2 - verify no reference to tests/ folder for writing
if echo "$cmd_quick_content" | grep -qiE "create.*test.*file|write.*test|add.*test"; then
    echo "FAIL: Quick mode mentions creating test files"
    echo "Expected: no instructions to create tests"
    exit 1
fi

# Assert 3 - verify fade/tests is not referenced as output destination
if echo "$cmd_quick_content" | grep -qE 'fade/tests.*write|write.*fade/tests'; then
    echo "FAIL: Quick mode references writing to fade/tests"
    echo "Expected: no writing to test directory"
    exit 1
fi

echo "PASS: quick mode does not include regression test generation"
exit 0
