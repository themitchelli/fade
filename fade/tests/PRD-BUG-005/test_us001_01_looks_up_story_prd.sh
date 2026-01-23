#!/bin/bash
# Test: display_iteration_summary looks up which PRD contains the story_id from STORY_DONE
# AC: display_iteration_summary looks up which PRD contains the story_id from STORY_DONE

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Check that display_iteration_summary calls find_prd_by_story_id with the story_id
# This is the fix - it looks up the PRD containing the story, not just get_active_prd
if ! grep -A10 'display_iteration_summary()' "$CLI_PATH" | grep -q 'find_prd_by_story_id'; then
    echo "FAIL: display_iteration_summary does not look up PRD by story_id"
    echo "Expected: Uses find_prd_by_story_id to find the PRD containing the story"
    echo "Actual: Function does not call find_prd_by_story_id"
    exit 1
fi

# Verify it uses the result for displaying info
if ! sed -n '/display_iteration_summary()/,/^[a-z_]*().*{$/p' "$CLI_PATH" | grep -q 'story_prd'; then
    echo "FAIL: display_iteration_summary does not use story_prd variable"
    echo "Expected: Variable story_prd used for looking up story's PRD"
    exit 1
fi

echo "PASS: display_iteration_summary looks up which PRD contains the story_id"
exit 0
