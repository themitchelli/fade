#!/bin/bash
# Test: verify dashboard config location is ~/.fade-dashboard/config.json
# AC: Create ~/.fade-dashboard/config.json for dashboard settings

CONFIG_DIR="$HOME/.fade-dashboard"
CONFIG_FILE="$CONFIG_DIR/config.json"

# Verify the dashboard-server.py uses the correct config path
DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    echo "Expected: $DASHBOARD_SERVER exists"
    exit 1
fi

# Check that server uses ~/.fade-dashboard/config.json
if ! grep -q '\.fade-dashboard/config\.json' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should reference ~/.fade-dashboard/config.json"
    echo "Expected: config path contains '.fade-dashboard/config.json'"
    echo "Actual: path not found in source"
    exit 1
fi

echo "PASS: Dashboard uses ~/.fade-dashboard/config.json for settings"
exit 0
