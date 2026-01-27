#!/bin/bash
# Test: fade prd new accepts --second-opinion flag
# AC: PRD generator offers an optional `--second-opinion` flag (stub OK) that captures at least one alternative approach and risks.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Act: Run prd new with --second-opinion but no feature name to see if flag is recognized
output=$("$FADE_CLI" prd new --second-opinion 2>&1)
exit_code=$?

# Assert: Should fail due to missing feature name, NOT unknown option
# If the flag were unknown, error message would say "Unknown option '--second-opinion'"
if echo "$output" | grep -qi "unknown option.*--second-opinion"; then
    echo "FAIL: --second-opinion flag not recognized"
    echo "Expected: flag accepted by CLI"
    echo "Actual: $output"
    exit 1
fi

# Assert: Error should be about missing feature name (proving flag was accepted)
if ! echo "$output" | grep -qi "feature name"; then
    echo "FAIL: Expected error about missing feature name after accepting --second-opinion flag"
    echo "Expected: 'feature name' mentioned in error"
    echo "Actual: $output"
    exit 1
fi

# Assert: Usage should show --second-opinion option
if ! echo "$output" | grep -q "\-\-second-opinion"; then
    echo "FAIL: Usage should document --second-opinion flag"
    echo "Expected: '--second-opinion' in usage text"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: fade prd new accepts --second-opinion flag"
exit 0
