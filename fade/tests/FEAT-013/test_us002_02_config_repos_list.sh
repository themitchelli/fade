#!/bin/bash
# Test: verify config includes list of repo paths to monitor
# AC: Config includes: list of repo paths to monitor

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check that DashboardData reads repos from config
if ! grep -q '"repos"' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle 'repos' config key"
    echo "Expected: 'repos' key referenced in code"
    exit 1
fi

# Verify repos iteration in refresh_data
if ! grep -A 5 'def refresh_data' "$DASHBOARD_SERVER" | grep -q 'repos'; then
    # Try a broader search
    if ! grep -q 'for repo in self.config.get("repos"' "$DASHBOARD_SERVER"; then
        echo "FAIL: dashboard-server.py should iterate over repos from config"
        echo "Expected: iteration over config repos"
        exit 1
    fi
fi

echo "PASS: Config structure supports list of repo paths"
exit 0
