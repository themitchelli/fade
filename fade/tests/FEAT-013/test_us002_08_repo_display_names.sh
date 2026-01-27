#!/bin/bash
# Test: verify config supports repo display names
# AC: Config includes: repo display names (map path to friendly name)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check that code reads 'name' from repo config
if ! grep -q 'repo\["name"\]' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should read 'name' from repo config"
    echo "Expected: repo[\"name\"] access pattern"
    exit 1
fi

echo "PASS: Config supports repo display names"
exit 0
