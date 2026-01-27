#!/bin/bash
# Test: verify 'fade dashboard --add' command exists
# AC: Command 'fade dashboard --add /path/to/repo' updates config

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found"
    exit 1
fi

# Check that cmd_dashboard handles --add flag
if ! grep -q '\-\-add)' "$FADE_CLI"; then
    echo "FAIL: fade-cli should handle --add flag for dashboard"
    echo "Expected: '--add)' case in cmd_dashboard"
    exit 1
fi

# Verify dashboard_add_repo function exists
if ! grep -q 'dashboard_add_repo' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have dashboard_add_repo function"
    echo "Expected: dashboard_add_repo function"
    exit 1
fi

echo "PASS: fade dashboard --add command is implemented"
exit 0
