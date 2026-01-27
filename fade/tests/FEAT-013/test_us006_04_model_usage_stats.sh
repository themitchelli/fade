#!/bin/bash
# Test: verify aggregate stats include model usage breakdown
# AC: Aggregate view shows: Model usage breakdown (Haiku: 20%, Sonnet: 65%, Opus: 15%)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for model usage tracking
if ! grep -q 'modelUsage\|model_usage' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should track model usage"
    echo "Expected: modelUsage field in aggregate stats"
    exit 1
fi

# Check for haiku, sonnet, opus in model tracking
if ! grep -q 'haiku.*sonnet.*opus\|"haiku"\|"sonnet"\|"opus"' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should track haiku, sonnet, opus models"
    exit 1
fi

echo "PASS: Aggregate stats include model usage breakdown"
exit 0
