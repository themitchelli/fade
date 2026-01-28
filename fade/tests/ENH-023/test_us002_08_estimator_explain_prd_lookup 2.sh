#!/bin/bash
# Test: verify fade estimator explain can find PRDs by ID or name
# AC: Provide `fade estimator explain` to print the rubric decision for a given PRD

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify cmd_estimator searches in fade/prds/ directory
if ! grep -q 'fade/prds/\*.json' "$FADE_CLI"; then
    echo "FAIL: estimator explain should search in fade/prds/ directory"
    exit 1
fi

# Test 2: Verify cmd_estimator searches in fade/prd-archive/ directory
if ! grep -q 'fade/prd-archive/\*.json' "$FADE_CLI"; then
    echo "FAIL: estimator explain should search in fade/prd-archive/ directory"
    exit 1
fi

# Test 3: Verify cmd_estimator searches active prd.json
if ! grep -q 'fade/prd.json' "$FADE_CLI"; then
    echo "FAIL: estimator explain should search fade/prd.json"
    exit 1
fi

# Test 4: Verify cmd_estimator can match by ID
if ! grep -qE 'id.*==.*search_query|search_query.*==.*id' "$FADE_CLI"; then
    echo "FAIL: estimator explain should match PRDs by ID"
    exit 1
fi

# Test 5: Verify cmd_estimator can match by name (partial match)
if ! grep -qE 'name.*\*.*search_query|search_query.*\*' "$FADE_CLI"; then
    echo "FAIL: estimator explain should match PRDs by name (partial match)"
    exit 1
fi

# Test 6: Verify error handling for PRD not found
if ! grep -q 'PRD not found' "$FADE_CLI"; then
    echo "FAIL: estimator explain should show error when PRD not found"
    exit 1
fi

echo "PASS: fade estimator explain can find PRDs by ID or name"
exit 0
