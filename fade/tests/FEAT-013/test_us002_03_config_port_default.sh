#!/bin/bash
# Test: verify config supports port with default 8080
# AC: Config includes: dashboard port (default: 8080), refresh interval (default: 30s)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for default port 8080
if ! grep -q '"port".*8080' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have default port 8080"
    echo "Expected: port default of 8080"
    exit 1
fi

echo "PASS: Config supports port with default 8080"
exit 0
