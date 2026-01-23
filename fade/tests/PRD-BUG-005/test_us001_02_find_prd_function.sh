#!/bin/bash
# Test: find_prd_by_story_id helper function searches all PRDs for matching story ID
# AC: New helper function find_prd_by_story_id searches all PRDs for matching story ID

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Check that find_prd_by_story_id function exists
if ! grep -q '^find_prd_by_story_id()' "$CLI_PATH"; then
    echo "FAIL: find_prd_by_story_id function not defined"
    echo "Expected: Function find_prd_by_story_id() exists"
    exit 1
fi

# Extract the function and verify it searches all PRD locations
func_body=$(sed -n '/^find_prd_by_story_id()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that it searches fade/prd.json
if ! echo "$func_body" | grep -q 'fade/prd.json'; then
    echo "FAIL: find_prd_by_story_id does not check fade/prd.json"
    echo "Expected: Searches fade/prd.json"
    exit 1
fi

# Check that it searches root prd.json
if ! echo "$func_body" | grep -q '"prd.json"' | grep -v 'fade/'; then
    # Alternative check - must handle root prd.json
    if ! echo "$func_body" | grep -q 'prd.json.*2>/dev/null'; then
        echo "FAIL: find_prd_by_story_id does not check root prd.json"
        echo "Expected: Searches prd.json at root"
        exit 1
    fi
fi

# Check that it searches fade/prds/
if ! echo "$func_body" | grep -q 'fade/prds'; then
    echo "FAIL: find_prd_by_story_id does not check fade/prds/"
    echo "Expected: Searches fade/prds/*.json"
    exit 1
fi

# Check that it searches root prds/
if ! echo "$func_body" | grep -q '"prds"' || ! echo "$func_body" | grep -q 'prds/\*.json'; then
    # Try alternate pattern
    if ! echo "$func_body" | grep -qE 'prds/.*\.json'; then
        echo "FAIL: find_prd_by_story_id does not check root prds/"
        echo "Expected: Searches prds/*.json at root"
        exit 1
    fi
fi

echo "PASS: find_prd_by_story_id searches all PRD locations"
exit 0
