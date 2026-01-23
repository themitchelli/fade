#!/bin/bash
# Test: verify FADE.md Standards table includes Architecture row
# AC: FADE.md Standards table includes Architecture row

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/FADE.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: FADE.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check for Architecture row in Standards table
if ! echo "$CONTENT" | grep -qi "Architecture.*architecture.md\|architecture.md.*Architecture"; then
    # Try alternative pattern - just check both words appear
    if ! echo "$CONTENT" | grep -q "Architecture" || ! echo "$CONTENT" | grep -q "architecture.md"; then
        echo "FAIL: Architecture row not found in FADE.md Standards table"
        echo "Expected: Row mentioning 'Architecture' linking to architecture.md"
        exit 1
    fi
fi

echo "PASS: FADE.md includes Architecture row in Standards table"
exit 0
