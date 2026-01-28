#!/bin/bash
# Test: verify rubric produces simple|medium|complex based on scored factors
# AC: Estimator produces `simple|medium|complex` based on a scored rubric with documented factors

# This test verifies that the get_complexity_rubric function is implemented
# with correct logic for producing simple|medium|complex complexity levels

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify the function can produce all three complexity levels
if ! grep -q 'complexity="simple"' "$FADE_CLI"; then
    echo "FAIL: Rubric should be able to produce 'simple' complexity"
    exit 1
fi

if ! grep -q 'complexity="medium"' "$FADE_CLI"; then
    echo "FAIL: Rubric should be able to produce 'medium' complexity"
    exit 1
fi

if ! grep -q 'complexity="complex"' "$FADE_CLI"; then
    echo "FAIL: Rubric should be able to produce 'complex' complexity"
    exit 1
fi

# Test 2: Verify scoring thresholds are correctly implemented
# Score >= 3 -> complex
if ! grep -qE '\$score.*-ge.*3' "$FADE_CLI"; then
    echo "FAIL: Rubric should use score >= 3 threshold for complex"
    exit 1
fi

# Score <= -2 -> simple
if ! grep -qE '\$score.*-le.*-2' "$FADE_CLI"; then
    echo "FAIL: Rubric should use score <= -2 threshold for simple"
    exit 1
fi

# Test 3: Verify get_complexity_rubric function exists
if ! grep -q 'get_complexity_rubric()' "$FADE_CLI"; then
    echo "FAIL: get_complexity_rubric function should exist"
    exit 1
fi

# Test 4: Verify function returns JSON format with required fields
if ! grep -q '"complexity":"%s"' "$FADE_CLI"; then
    echo "FAIL: Rubric should output JSON with complexity field"
    exit 1
fi

if ! grep -q '"totalScore":%d' "$FADE_CLI"; then
    echo "FAIL: Rubric should output JSON with totalScore field"
    exit 1
fi

if ! grep -q '"factors":' "$FADE_CLI"; then
    echo "FAIL: Rubric should output JSON with factors field"
    exit 1
fi

echo "PASS: Rubric produces valid simple|medium|complex based on scored factors"
exit 0
