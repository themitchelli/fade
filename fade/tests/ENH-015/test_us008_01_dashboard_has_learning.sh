#!/bin/bash
# Test: verify dashboard-server.py has learning metrics function
# AC: Add 'Learning' section to dashboard

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Assert: file exists
if [[ ! -f "$DASHBOARD_FILE" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for learning metrics function
if ! grep -q 'get_learning_metrics\|learning' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should have learning metrics function"
    exit 1
fi

echo "PASS: dashboard-server.py has learning metrics functionality"
exit 0
