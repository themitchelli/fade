#!/bin/bash
# Test: ALL_COMPLETE detection matches '^ALL_COMPLETE$' on its own line
# AC: ALL_COMPLETE detection: match '^ALL_COMPLETE$' on its own line (already using -qx, verify working)

# Verify the pattern in source code
FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

# Check that ALL_COMPLETE uses -qx (exact line match)
if ! grep -q 'grep -qx "ALL_COMPLETE"' "$FADE_CLI"; then
    echo "FAIL: ALL_COMPLETE detection should use 'grep -qx' for exact line match"
    echo "Expected: grep -qx \"ALL_COMPLETE\""
    exit 1
fi

# Test the pattern behavior with grep -qx

# Should match: ALL_COMPLETE on its own line
output1="ALL_COMPLETE"
if ! echo "$output1" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: grep -qx should match 'ALL_COMPLETE' as entire line"
    exit 1
fi

# Should match: ALL_COMPLETE in multiline (on its own line)
output2="Some output
ALL_COMPLETE
More output"
if ! echo "$output2" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: grep -qx should match 'ALL_COMPLETE' as entire line in multiline output"
    exit 1
fi

# Should NOT match: ALL_COMPLETE with extra text
output3="ALL_COMPLETE with extra"
if echo "$output3" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: grep -qx should NOT match 'ALL_COMPLETE with extra'"
    exit 1
fi

# Should NOT match: ALL_COMPLETE mid-line
output4="Signal: ALL_COMPLETE"
if echo "$output4" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: grep -qx should NOT match 'ALL_COMPLETE' when not entire line"
    exit 1
fi

echo "PASS: ALL_COMPLETE detection uses grep -qx for exact line match"
exit 0
