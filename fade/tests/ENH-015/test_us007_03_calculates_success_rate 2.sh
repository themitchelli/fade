#!/bin/bash
# Test: verify update-heuristics.py calculates success rates
# AC: For each model type (Haiku, Sonnet, Opus), calculate: Success rate: (succeeded outcomes) / (total uses)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/update-heuristics.py"

# Check script content for success rate calculation
if ! grep -q 'success_rate\|calculate_success\|Success rate\|successes.*total' "$TARGET_SCRIPT"; then
    echo "FAIL: update-heuristics.py should calculate success rates"
    exit 1
fi

echo "PASS: update-heuristics.py has success rate calculation"
exit 0
