#!/bin/bash
# Test: verify config supports refresh interval with default 30s
# AC: Config includes: dashboard port (default: 8080), refresh interval (default: 30s)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for refreshInterval with default 30
if ! grep -q '"refreshInterval".*30' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have default refreshInterval 30"
    echo "Expected: refreshInterval default of 30"
    exit 1
fi

echo "PASS: Config supports refreshInterval with default 30s"
exit 0
