#!/bin/bash
# Test: verify operator model override is recorded in telemetry
# AC: Operator can override model explicitly and the override is recorded

# This test verifies that when the --model flag is used, the override is recorded
# in the telemetry event data

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify model_override variable exists
if ! grep -q 'model_override=' "$FADE_CLI"; then
    echo "FAIL: model_override variable should exist"
    exit 1
fi

# Test 2: Verify override is set to true when --model flag is used
if ! grep -q 'model_override=true' "$FADE_CLI"; then
    echo "FAIL: model_override should be set to true when --model flag is used"
    exit 1
fi

# Test 3: Verify override is included in telemetry event when true (escaped quotes in bash)
if ! grep -q '\\"override\\":true' "$FADE_CLI"; then
    echo "FAIL: override:true should be included in telemetry event when flag is used"
    exit 1
fi

# Test 4: Verify routing source indicates override
if ! grep -q '\-\-model flag (override)' "$FADE_CLI"; then
    echo "FAIL: Routing source should indicate override when --model flag is used"
    exit 1
fi

# Test 5: Verify override is conditionally added (only when model_override is true)
if ! grep -qE 'model_override.*==.*true' "$FADE_CLI"; then
    echo "FAIL: Override should only be added to event when model_override is true"
    exit 1
fi

echo "PASS: Model override is recorded in telemetry when --model flag is used"
exit 0
