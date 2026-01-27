#!/bin/bash
# Test: Model recommender outputs recommendation with required format
# AC: Output includes model recommendation, confidence %, reasoning, citation

set -e

# Run recommender on a known PRD
output=$(python3 fade/recommend-model.py "ENH-015" fade/prds/ENH-015-model-selection-learner.json fade/model-selection-history.json 2>/dev/null)

# Check for required fields in output
if ! echo "$output" | grep -q "^Recommend:"; then
    echo "FAIL: Output missing 'Recommend:' line"
    echo "Output: $output"
    exit 1
fi

if ! echo "$output" | grep -q "^Confidence:"; then
    echo "FAIL: Output missing 'Confidence:' line"
    exit 1
fi

if ! echo "$output" | grep -q "^Reasoning:"; then
    echo "FAIL: Output missing 'Reasoning:' line"
    exit 1
fi

if ! echo "$output" | grep -q "^Based on:"; then
    echo "FAIL: Output missing 'Based on:' line (citation)"
    exit 1
fi

# Verify model is one of the three options
if ! echo "$output" | grep -q "HAIKU\|SONNET\|OPUS"; then
    echo "FAIL: Recommendation not one of HAIKU/SONNET/OPUS"
    exit 1
fi

echo "PASS: Recommender outputs all required fields"
exit 0
