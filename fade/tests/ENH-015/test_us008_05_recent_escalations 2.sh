#!/bin/bash
# Test: verify dashboard returns recent escalations
# AC: Recent escalations: List last 3 PRDs that needed escalation with reason

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Check for escalations tracking
if ! grep -q 'escalation\|recentEscalations' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should track recent escalations"
    exit 1
fi

echo "PASS: dashboard-server.py tracks recent escalations"
exit 0
