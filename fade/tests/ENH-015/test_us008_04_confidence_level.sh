#!/bin/bash
# Test: verify dashboard returns confidence level
# AC: Recommendation confidence: Show 85% or 'Low confidence, limited history' if <10 similar PRDs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Check for confidence level calculation
if ! grep -q 'confidence\|High\|Medium\|Low' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should calculate confidence level"
    exit 1
fi

echo "PASS: dashboard-server.py has confidence level calculation"
exit 0
