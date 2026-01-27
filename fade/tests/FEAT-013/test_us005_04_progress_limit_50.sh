#!/bin/bash
# Test: verify progress.md is limited to last 50 entries
# AC: Docs tab shows: progress.md (last 50 entries)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for _limit_progress_entries method
if ! grep -q '_limit_progress_entries' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have _limit_progress_entries method"
    echo "Expected: _limit_progress_entries method"
    exit 1
fi

# Check for max_entries=50 parameter
if ! grep -q 'max_entries.*50\|50.*entries' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should limit progress.md to 50 entries"
    echo "Expected: max_entries=50 or similar"
    exit 1
fi

echo "PASS: progress.md limited to 50 entries"
exit 0
