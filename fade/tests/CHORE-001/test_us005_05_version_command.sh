#!/bin/bash
# Test: verify fade --version shows 0.3.1
# AC: Version display in fade --version shows 0.3.1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_CLI="$PROJECT_ROOT/bin/fade-cli"

# Run version command
output=$("$FADE_CLI" version 2>&1)

if ! echo "$output" | grep -q "0.3.1"; then
    echo "FAIL: fade version does not show 0.3.1"
    echo "Expected: Output contains 0.3.1"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: fade version shows 0.3.1"
exit 0
