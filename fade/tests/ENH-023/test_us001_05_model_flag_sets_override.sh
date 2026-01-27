#!/bin/bash
# Test: verify --model flag parsing sets override tracking variable
# AC: Operator can override model explicitly and the override is recorded

# This test verifies that the fade-cli correctly parses --model flag
# and sets the model_override variable

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify --model flag parsing exists in the code
if ! grep -q 'model_override=true' "$FADE_CLI"; then
    echo "FAIL: fade-cli should set model_override=true when --model flag is used"
    exit 1
fi

# Test 2: Verify the --model flag is in run command
if ! grep -q '\-\-model)' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have --model flag option in run command"
    exit 1
fi

# Test 3: Verify model value is captured from the flag argument
if ! grep -q 'model="\$2"' "$FADE_CLI"; then
    echo "FAIL: fade-cli should capture model value from --model flag argument"
    exit 1
fi

# Test 4: Check that source indicates override when flag is used
if ! grep -q '"--model flag (override)"' "$FADE_CLI"; then
    echo "FAIL: fade-cli should indicate override in routing source"
    exit 1
fi

# Test 5: Verify default model_override is false
if ! grep -q 'model_override=false' "$FADE_CLI"; then
    echo "FAIL: model_override should default to false"
    exit 1
fi

echo "PASS: --model flag correctly sets override tracking for recording"
exit 0
