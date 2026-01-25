#!/bin/bash
# Test: verify log format follows the specification
# AC: Log format: '## YYYY-MM-DD HH:MM - [SEVERITY] PRD-ID/US-ID'

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the log format includes timestamp
if ! grep -q 'date "+%Y-%m-%d %H:%M' "$FADE_CLI"; then
    echo "FAIL: Log should include YYYY-MM-DD HH:MM timestamp"
    echo "Expected: date format '+%Y-%m-%d %H:%M' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify log entries start with ##
if ! grep -q 'echo "## ' "$FADE_CLI"; then
    echo "FAIL: Log entries should start with ## header"
    echo "Expected: 'echo \"## ' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Log format follows YYYY-MM-DD HH:MM specification"
exit 0
