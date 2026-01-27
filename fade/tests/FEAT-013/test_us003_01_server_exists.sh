#!/bin/bash
# Test: verify dashboard-server.py exists
# AC: Create fade/lib/dashboard-server.py (simple Python HTTP server, no external dependencies)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    echo "Expected: $DASHBOARD_SERVER exists"
    exit 1
fi

echo "PASS: fade/lib/dashboard-server.py exists"
exit 0
