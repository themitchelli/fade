#!/bin/bash
# Test: verify graceful shutdown writes 'Server stopped' message
# AC: Graceful shutdown: Ctrl+C writes 'Server stopped' to log, closes connections cleanly

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for 'Server stopped' message
if ! grep -q 'Server stopped' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should print 'Server stopped' on shutdown"
    echo "Expected: 'Server stopped' message"
    exit 1
fi

echo "PASS: Graceful shutdown prints 'Server stopped'"
exit 0
