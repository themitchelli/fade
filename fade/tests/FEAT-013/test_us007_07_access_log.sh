#!/bin/bash
# Test: verify access logging is implemented
# AC: Access log: Record all connections with IP, timestamp, endpoint

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for access log handling
if ! grep -q 'access.log\|access_log' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should write access log"
    echo "Expected: access.log or access_log reference"
    exit 1
fi

# Check for log_message method
if ! grep -q 'log_message' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have log_message method"
    echo "Expected: log_message method for request logging"
    exit 1
fi

echo "PASS: Access logging is implemented"
exit 0
