#!/bin/bash
# Test: verify fade classify runs heuristic analyzer on each PRD
# AC: Run heuristic analyzer on each PRD

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify calls analyze_complexity
if grep -A 150 "cmd_classify()" "$FADE_CLI" | grep -q "analyze_complexity"; then
    echo "PASS: fade classify runs heuristic analyzer on each PRD"
    exit 0
fi

echo "FAIL: fade classify should call analyze_complexity on each PRD"
exit 1
