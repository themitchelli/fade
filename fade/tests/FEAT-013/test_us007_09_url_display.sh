#!/bin/bash
# Test: verify server displays URL on startup
# AC: Display server URL on startup: 'Dashboard running at http://192.168.1.100:8080'

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for startup URL display
if ! grep -q 'Dashboard running at' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should display 'Dashboard running at' on startup"
    echo "Expected: 'Dashboard running at' message"
    exit 1
fi

echo "PASS: Server displays URL on startup"
exit 0
