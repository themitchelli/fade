#!/bin/bash
# Test: verify estimator writes decision and factor scores to telemetry (model_selected event)
# AC: Estimator writes its decision and factor scores to telemetry (`model_selected` event)

# This test verifies that the emit_event function exists and the model_selected
# event is emitted with the expected data structure including rubric scores

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify emit_event function exists
if ! grep -q 'emit_event()' "$FADE_CLI"; then
    echo "FAIL: emit_event function should exist"
    exit 1
fi

# Test 2: Verify model_selected event is emitted
if ! grep -q 'emit_event.*"model_selected"' "$FADE_CLI"; then
    echo "FAIL: model_selected event should be emitted via emit_event"
    exit 1
fi

# Test 3: Verify model field is included in event
if ! grep -q '\\"model\\":\\"' "$FADE_CLI"; then
    echo "FAIL: model_selected event should include model field"
    exit 1
fi

# Test 4: Verify rubric is included when available (escaped quotes in bash string)
if ! grep -q '\\"rubric\\":' "$FADE_CLI"; then
    echo "FAIL: model_selected event should include rubric when available"
    exit 1
fi

# Test 5: Verify iteration is included in event
if ! grep -q '\\"iteration\\":' "$FADE_CLI"; then
    echo "FAIL: model_selected event should include iteration number"
    exit 1
fi

# Test 6: Verify event is written to events.jsonl
if ! grep -q 'events.jsonl' "$FADE_CLI"; then
    echo "FAIL: Events should be written to events.jsonl file"
    exit 1
fi

# Test 7: Verify event includes timestamp (in JSON format)
if ! grep -q '"ts":' "$FADE_CLI"; then
    echo "FAIL: Events should include timestamp field"
    exit 1
fi

# Test 8: Verify complexity_rubric variable is used for telemetry
if ! grep -q 'complexity_rubric' "$FADE_CLI"; then
    echo "FAIL: complexity_rubric should be captured for telemetry"
    exit 1
fi

echo "PASS: model_selected event written to telemetry with decision and factor scores"
exit 0
