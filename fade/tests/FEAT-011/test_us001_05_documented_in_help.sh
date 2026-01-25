#!/bin/bash
# Test: fade discover is documented in fade help
# AC: Documented in fade help

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Run fade help and check for discover command
output=$("$FADE_CLI" help 2>&1)

# Check that discover is listed in commands
if ! echo "$output" | grep -q "discover"; then
    echo "FAIL: discover command not found in fade help output"
    echo "Expected: 'discover' appears in help output"
    echo "Actual: discover not found"
    exit 1
fi

# Check that there's a description for discover
if ! echo "$output" | grep -qi "discover.*interactive\|discover.*exploration\|discover.*session\|Interactive.*discover"; then
    echo "FAIL: discover command lacks description in help"
    echo "Expected: discover has meaningful description"
    echo "Actual: no descriptive text near 'discover'"
    exit 1
fi

echo "PASS: fade discover is documented in fade help"
exit 0
