#!/bin/bash
# Test: verify quick mode uses conventional commit format
# AC: Uses conventional commit format (fix:, docs:, chore:, etc.)

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

# Assert 1 - verify conventional commit prefixes are mentioned
conventional_prefixes=("fix:" "feat:" "docs:" "chore:" "refactor:")
found_prefixes=0
for prefix in "${conventional_prefixes[@]}"; do
    if echo "$cmd_quick_content" | grep -q "$prefix"; then
        ((found_prefixes++))
    fi
done

if [[ $found_prefixes -lt 3 ]]; then
    echo "FAIL: Not enough conventional commit prefixes mentioned"
    echo "Expected: at least 3 of fix:, feat:, docs:, chore:, refactor:"
    echo "Found: $found_prefixes prefixes"
    exit 1
fi

# Assert 2 - verify "conventional commit" or prefix instruction
if ! echo "$cmd_quick_content" | grep -qiE "conventional commit|appropriate prefix"; then
    echo "FAIL: No mention of conventional commits or prefix selection"
    echo "Expected: instruction about conventional commit format"
    exit 1
fi

# Assert 3 - verify examples use conventional format
if ! echo "$cmd_quick_content" | grep -qE 'docs:.*fix|chore:.*add'; then
    echo "FAIL: Examples don't show conventional commit format"
    echo "Expected: examples with conventional commit prefixes"
    exit 1
fi

echo "PASS: quick mode uses conventional commit format"
exit 0
