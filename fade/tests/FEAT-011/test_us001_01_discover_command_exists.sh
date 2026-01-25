#!/bin/bash
# Test: fade discover command exists and is recognized
# AC: fade discover command launches interactive Claude session

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Check that discover is a recognized command (not "Unknown command")
# Running without a feature name should show usage, not "Unknown command"
output=$("$FADE_CLI" discover 2>&1 || true)

if echo "$output" | grep -q "Unknown command"; then
    echo "FAIL: discover is not a recognized command"
    echo "Expected: usage message or error about missing feature name"
    echo "Actual: Unknown command error"
    exit 1
fi

# Should show usage message about feature name required
if ! echo "$output" | grep -q "feature name\|Feature name"; then
    echo "FAIL: discover command doesn't show expected usage"
    echo "Expected: usage message mentioning feature name"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: fade discover command exists and is recognized"
exit 0
