#!/bin/bash
# Test: verify 'fade dashboard --discover' auto-discovery command exists
# AC: Auto-discover: Scan parent directory for other FADE repos (finds FADE.md), suggest adding

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found"
    exit 1
fi

# Check that cmd_dashboard handles --discover flag
if ! grep -q '\-\-discover)' "$FADE_CLI"; then
    echo "FAIL: fade-cli should handle --discover flag for dashboard"
    echo "Expected: '--discover)' case in cmd_dashboard"
    exit 1
fi

# Verify dashboard_auto_discover function exists
if ! grep -q 'dashboard_auto_discover' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have dashboard_auto_discover function"
    echo "Expected: dashboard_auto_discover function"
    exit 1
fi

echo "PASS: fade dashboard --discover command is implemented"
exit 0
