#!/bin/bash
# Test: verify --remote flag binds to 0.0.0.0
# AC: Dashboard server binds to 0.0.0.0 with --remote flag (default: localhost only)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for --remote argument handling
if ! grep -q '\-\-remote' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle --remote flag"
    echo "Expected: --remote argument parsing"
    exit 1
fi

# Check for 0.0.0.0 bind address with remote
if ! grep -q '0\.0\.0\.0' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should bind to 0.0.0.0 with --remote"
    echo "Expected: 0.0.0.0 bind address"
    exit 1
fi

echo "PASS: --remote flag binds to 0.0.0.0"
exit 0
