#!/bin/bash
# Test: Iteration summary shows correct PRD name, acceptance criteria, and checkbox status
# AC: Iteration summary shows correct PRD name, acceptance criteria, and checkbox status

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract display_iteration_summary function body
func_body=$(sed -n '/^display_iteration_summary()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that it displays story title from the correct PRD
if ! echo "$func_body" | grep -q 'get_story_title.*story_prd.*story_id'; then
    echo "FAIL: display_iteration_summary does not get story title from correct PRD"
    echo "Expected: Calls get_story_title with story_prd"
    exit 1
fi

# Check that it displays acceptance criteria
if ! echo "$func_body" | grep -q 'get_story_acceptance_criteria.*story_prd.*story_id'; then
    echo "FAIL: display_iteration_summary does not get acceptance criteria from correct PRD"
    echo "Expected: Calls get_story_acceptance_criteria with story_prd"
    exit 1
fi

# Check that it displays PRD status (checkbox status)
if ! echo "$func_body" | grep -q 'display_prd_stories.*story_prd'; then
    echo "FAIL: display_iteration_summary does not display PRD story status"
    echo "Expected: Calls display_prd_stories with story_prd"
    exit 1
fi

echo "PASS: Iteration summary displays correct PRD info using story_prd"
exit 0
