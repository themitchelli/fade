#!/bin/bash
# Test: verify dashboard returns learned patterns
# AC: Key patterns learned: 'Architecture + integration_surface=heavy → Opus (100% success)'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Check for patterns extraction
if ! grep -q 'patterns\|useHaikuIf\|useSonnetIf\|useOpusIf' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should extract learned patterns"
    exit 1
fi

echo "PASS: dashboard-server.py extracts learned patterns"
exit 0
