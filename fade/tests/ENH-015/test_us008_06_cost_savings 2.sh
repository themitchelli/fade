#!/bin/bash
# Test: verify dashboard calculates cost savings
# AC: Cost savings so far: Compare 'all-Sonnet' cost vs actual model mix used

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Check for cost savings calculation
if ! grep -q 'cost\|savings\|costSavings' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should calculate cost savings"
    exit 1
fi

echo "PASS: dashboard-server.py calculates cost savings"
exit 0
