#!/bin/bash
# Test: verify dashboard has /api/learning endpoint
# AC: HTTP Endpoint for learning metrics

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Check for learning API endpoint
if ! grep -q '/api/learning' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should have /api/learning endpoint"
    exit 1
fi

echo "PASS: dashboard-server.py has /api/learning endpoint"
exit 0
