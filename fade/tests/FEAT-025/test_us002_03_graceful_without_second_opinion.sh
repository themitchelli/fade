#!/bin/bash
# Test: fade prd new works without --second-opinion flag (graceful degradation)
# AC: PRD generator never blocks if second-opinion is unavailable; it degrades gracefully.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Act: Run prd new WITHOUT --second-opinion to verify it doesn't require the flag
# We're just checking the CLI parsing, not executing the full flow
output=$("$FADE_CLI" prd new 2>&1)
exit_code=$?

# Assert: Command fails due to missing feature name, NOT missing second-opinion
# This proves --second-opinion is optional
if echo "$output" | grep -qi "second-opinion.*required\|must.*second-opinion"; then
    echo "FAIL: Command should not require --second-opinion flag"
    echo "Expected: --second-opinion to be optional"
    echo "Actual: $output"
    exit 1
fi

# Assert: The error should only be about missing feature name
if ! echo "$output" | grep -qi "feature name"; then
    echo "FAIL: Expected error about missing feature name"
    echo "Expected: error mentions 'feature name'"
    echo "Actual: $output"
    exit 1
fi

# Assert: Usage shows --second-opinion as optional (not required)
# Look for indication that it's optional in the usage string
if echo "$output" | grep -qE "\-\-second-opinion[[:space:]]+<"; then
    # If --second-opinion has a required argument marker like <something>, that's wrong
    echo "FAIL: --second-opinion should not require an argument"
    echo "Expected: --second-opinion as a flag (no required value)"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: fade prd new works without --second-opinion (graceful degradation)"
exit 0
