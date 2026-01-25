#!/bin/bash
# Test: verify fade new --help includes complexity flag documentation
# AC: Update 'fade new --help' with complexity flag documentation

set -e

# Run fade new with no args to see help/usage
OUTPUT=$(fade new 2>&1 || true)

# Check for complexity in usage output
if echo "$OUTPUT" | grep -qi "complexity"; then
    echo "PASS: fade new help/usage mentions complexity flag"
    exit 0
fi

echo "FAIL: fade new help/usage should mention --complexity flag"
echo "Output: $OUTPUT"
exit 1
