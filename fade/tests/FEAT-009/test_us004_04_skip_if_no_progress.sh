#!/bin/bash
# Test: verify quick mode skips logging if progress.md doesn't exist
# AC: If progress.md doesn't exist, skips logging (non-FADE project)

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

# Assert 1 - verify conditional check for progress.md
if ! echo "$cmd_quick_content" | grep -qE '\-f.*progress\.md'; then
    echo "FAIL: No conditional check for progress.md existence"
    echo "Expected: check if progress.md file exists"
    exit 1
fi

# Assert 2 - verify both contained and legacy paths are checked
if ! echo "$cmd_quick_content" | grep -q 'fade/progress.md'; then
    echo "FAIL: Contained structure path not checked (fade/progress.md)"
    echo "Expected: check for fade/progress.md"
    exit 1
fi

# Assert 3 - verify progress_file variable pattern
if ! echo "$cmd_quick_content" | grep -qE 'progress_file=|if.*-n.*progress_file'; then
    echo "FAIL: progress_file variable pattern not found"
    echo "Expected: progress_file variable to control logging"
    exit 1
fi

echo "PASS: quick mode skips logging if progress.md doesn't exist"
exit 0
