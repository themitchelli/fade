#!/bin/bash
# Test: verify get_session_analytics function exists in fade-cli
# AC: Dashboard aggregate view shows: Sessions run today, this week, this month

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found"
    exit 1
fi

# Check for get_session_analytics function
if ! grep -q 'get_session_analytics()' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have get_session_analytics function"
    echo "Expected: get_session_analytics() function"
    exit 1
fi

echo "PASS: get_session_analytics function exists"
exit 0
