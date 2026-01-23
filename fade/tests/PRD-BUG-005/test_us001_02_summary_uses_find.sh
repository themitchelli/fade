#!/bin/bash
# Test: Iteration summary uses find_prd_by_story_id, not get_active_prd
# AC: Iteration summary shows correct PRD name, acceptance criteria, and checkbox status

set -e

# The fix for this bug is that display_iteration_summary() calls find_prd_by_story_id()
# instead of get_active_prd(). We verify this by checking the code.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Check that display_iteration_summary uses find_prd_by_story_id
if ! grep -q 'find_prd_by_story_id.*\$story_id' "$CLI_PATH"; then
    echo "FAIL: display_iteration_summary does not call find_prd_by_story_id"
    echo "Expected: story_prd=\$(find_prd_by_story_id \"\$story_id\")"
    exit 1
fi

# Check that the variable is named story_prd (not active_prd) to clarify semantics
if grep -q 'active_prd.*get_active_prd' "$CLI_PATH" | grep -q 'display_iteration_summary' 2>/dev/null; then
    # This should not be the pattern used
    echo "FAIL: display_iteration_summary still uses get_active_prd directly"
    echo "Expected: Uses find_prd_by_story_id to find the PRD containing the completed story"
    exit 1
fi

# Verify find_prd_by_story_id function exists and has correct search order
if ! grep -q 'find_prd_by_story_id()' "$CLI_PATH"; then
    echo "FAIL: find_prd_by_story_id function not defined"
    exit 1
fi

# Verify the function checks fade/prd.json first (priority order)
# Use -A15 to capture enough context for the check
if ! grep -A15 'find_prd_by_story_id()' "$CLI_PATH" | grep -q 'fade/prd.json'; then
    echo "FAIL: find_prd_by_story_id does not check fade/prd.json"
    exit 1
fi

echo "PASS: Iteration summary correctly uses find_prd_by_story_id for story lookup"
exit 0
