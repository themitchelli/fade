#!/bin/bash
# Test: BLOCKED detection matches '^BLOCKED: ' at start of line
# AC: BLOCKED detection: match '^BLOCKED: ' at start of line

# Verify the pattern in source code uses '^' anchor
FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if ! grep -q "grep -q '\^BLOCKED: '" "$FADE_CLI"; then
    echo "FAIL: BLOCKED detection should use '^BLOCKED: ' pattern"
    exit 1
fi

# Test pattern behavior

# Should match: at start of line
output1="BLOCKED: Cannot resolve conflict"
if ! echo "$output1" | grep -q '^BLOCKED: '; then
    echo "FAIL: Should match BLOCKED at start of line"
    exit 1
fi

# Should match: at start of line in multiline
output2="Previous output
BLOCKED: Missing dependency
More context"
if ! echo "$output2" | grep -q '^BLOCKED: '; then
    echo "FAIL: Should match BLOCKED at start of line in multiline output"
    exit 1
fi

# Should NOT match: not at start of line
output3="  BLOCKED: indented"
if echo "$output3" | grep -q '^BLOCKED: '; then
    echo "FAIL: Should NOT match BLOCKED with leading whitespace"
    exit 1
fi

# Should NOT match: mid-line
output4="Status is BLOCKED: reason here"
if echo "$output4" | grep -q '^BLOCKED: '; then
    echo "FAIL: Should NOT match BLOCKED when not at start of line"
    exit 1
fi

echo "PASS: BLOCKED detection matches '^BLOCKED: ' at start of line"
exit 0
