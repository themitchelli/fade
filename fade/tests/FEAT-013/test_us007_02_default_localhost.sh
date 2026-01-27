#!/bin/bash
# Test: verify default binding is localhost only
# AC: Dashboard server binds to 0.0.0.0 with --remote flag (default: localhost only)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for 127.0.0.1 as default bind address
if ! grep -q '127\.0\.0\.1' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should default to 127.0.0.1"
    echo "Expected: 127.0.0.1 as default bind address"
    exit 1
fi

echo "PASS: Default binding is localhost (127.0.0.1)"
exit 0
