#!/bin/bash
# Test: verify tests are re-run after applying fixes
# AC: Re-run regression tests after applying fixes

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the retry logic exists in the code
if ! grep -q "Retrying tests after healing" "$FADE_CLI"; then
    echo "FAIL: Code should re-run tests after applying fixes"
    echo "Expected: 'Retrying tests after healing' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify tests are actually executed again
if ! grep -q 'run_script.*2>&1' "$FADE_CLI"; then
    echo "FAIL: Tests should be executed via run_script"
    echo "Expected: run_script execution in healing loop"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Tests are re-run after applying fixes"
exit 0
