#!/bin/bash
# Test: verify 'fade dashboard --list' command exists
# AC: Command 'fade dashboard --list' shows configured repos

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found"
    exit 1
fi

# Check that cmd_dashboard handles --list flag
if ! grep -q '\-\-list)' "$FADE_CLI"; then
    echo "FAIL: fade-cli should handle --list flag for dashboard"
    echo "Expected: '--list)' case in cmd_dashboard"
    exit 1
fi

# Verify dashboard_list_repos function exists
if ! grep -q 'dashboard_list_repos' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have dashboard_list_repos function"
    echo "Expected: dashboard_list_repos function"
    exit 1
fi

echo "PASS: fade dashboard --list command is implemented"
exit 0
