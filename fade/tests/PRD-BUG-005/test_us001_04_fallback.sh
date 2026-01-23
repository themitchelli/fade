#!/bin/bash
# Test: Falls back to get_active_prd if story_id not found in any PRD
# AC: Falls back to get_active_prd if story_id not found in any PRD

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract display_iteration_summary function body
func_body=$(sed -n '/^display_iteration_summary()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that it has fallback logic to get_active_prd
if ! echo "$func_body" | grep -q 'get_active_prd'; then
    echo "FAIL: display_iteration_summary has no fallback to get_active_prd"
    echo "Expected: Falls back to get_active_prd when story not found"
    exit 1
fi

# Check the fallback pattern: if story_prd is empty, use get_active_prd
if ! echo "$func_body" | grep -qE '\[\[.*-z.*story_prd|if.*story_prd.*get_active_prd'; then
    # Check for alternate pattern where fallback happens after find_prd_by_story_id
    if ! echo "$func_body" | grep -B2 'get_active_prd' | grep -q 'story_prd'; then
        echo "FAIL: Fallback logic not properly structured"
        echo "Expected: Check if story_prd is empty, then call get_active_prd"
        exit 1
    fi
fi

echo "PASS: display_iteration_summary falls back to get_active_prd correctly"
exit 0
