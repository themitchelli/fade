#!/bin/bash
# Test: fade run includes referenced discovery doc in context
# AC: fade run includes referenced discovery doc in context

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for discovery doc inclusion in run
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Check that get_prd_discovery_doc function is called somewhere in context building
# The function exists (verified in other test) and the file uses it for context
if ! grep -q 'get_prd_discovery_doc' "$FADE_CLI"; then
    echo "FAIL: get_prd_discovery_doc function not found"
    echo "Expected: function to retrieve discovery doc"
    echo "Actual: function not found"
    exit 1
fi

# Check that the function is called (not just defined)
# Should appear twice: once for definition, once for usage
usage_count=$(grep -c 'get_prd_discovery_doc' "$FADE_CLI")
if [[ $usage_count -lt 2 ]]; then
    echo "FAIL: get_prd_discovery_doc not called"
    echo "Expected: function called to get discovery doc"
    echo "Actual: only found $usage_count occurrences (need at least 2: definition + usage)"
    exit 1
fi

# Check for DISCOVERY CONTEXT section in context building
if ! grep -qi "DISCOVERY CONTEXT" "$FADE_CLI"; then
    echo "FAIL: No DISCOVERY CONTEXT section in context"
    echo "Expected: 'DISCOVERY CONTEXT' section header"
    echo "Actual: DISCOVERY CONTEXT not found"
    exit 1
fi

# Check that discovery doc content is cat'd into context
if ! grep -q 'cat.*discovery_doc\|$(cat "$discovery_doc")' "$FADE_CLI"; then
    echo "FAIL: Discovery doc content not loaded"
    echo "Expected: cat command to load discovery doc content"
    echo "Actual: discovery doc cat not found"
    exit 1
fi

echo "PASS: fade run includes referenced discovery doc in context"
exit 0
