#!/bin/bash
# Test: verify server supports graceful shutdown
# AC: Server runs in foreground (Ctrl+C to stop), logs requests to console

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for signal handling
if ! grep -q 'signal.SIGINT\|signal.SIGTERM' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle SIGINT/SIGTERM for graceful shutdown"
    echo "Expected: signal.SIGINT or signal.SIGTERM handling"
    exit 1
fi

# Check for shutdown handling
if ! grep -q 'shutdown' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have shutdown handling"
    echo "Expected: shutdown method or message"
    exit 1
fi

echo "PASS: Server supports graceful shutdown"
exit 0
