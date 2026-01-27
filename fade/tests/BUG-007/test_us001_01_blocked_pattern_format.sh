#!/bin/bash
# Test: verify BLOCKED detection uses '^BLOCKED: ' pattern, not loose matching
# AC: Change BLOCKED detection from 'grep -q "BLOCKED"' to match the signal format 'BLOCKED:' specifically

# This test verifies the pattern used in fade-cli for BLOCKED detection
# by checking the actual grep pattern in the source code

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

# Check that the BLOCKED detection uses the strict pattern
if ! grep -q "grep -q '\^BLOCKED: '" "$FADE_CLI"; then
    echo "FAIL: BLOCKED detection should use strict pattern '^BLOCKED: '"
    echo "Expected: grep -q '^BLOCKED: '"
    echo "Actual: $(grep -o "grep.*BLOCKED.*'" "$FADE_CLI" | head -1)"
    exit 1
fi

echo "PASS: BLOCKED detection uses strict pattern '^BLOCKED: '"
exit 0
