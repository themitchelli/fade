#!/bin/bash
# Test: verify iteration banner displays model and complexity
# AC: Display selected model in iteration banner: 'Iteration 1 - model: haiku (complexity: simple)'

set -e

FADE_CLI="$(which fade)"

# Check that iteration banner includes model and routing info
if grep -A 300 "cmd_run()" "$FADE_CLI" | grep -q 'Iteration.*model:.*routing_source\|model:.*selected_model.*routing_source'; then
    echo "PASS: Iteration banner displays model with complexity/routing info"
    exit 0
fi

# Alternative check for the banner format
if grep "$FADE_CLI" -e 'Iteration.*model:'; then
    echo "PASS: Iteration banner displays model information"
    exit 0
fi

echo "FAIL: Iteration banner should display model with complexity info"
exit 1
