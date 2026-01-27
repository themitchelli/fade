#!/bin/bash
# Test: verify fade estimator explain outputs rubric decision details
# AC: Provide `fade estimator explain` to print the rubric decision for a given PRD

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify cmd_estimator displays PRD Information section
if ! grep -q 'PRD Information' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display 'PRD Information' section"
    exit 1
fi

# Test 2: Verify cmd_estimator displays Complexity Calculation section
if ! grep -q 'Complexity Calculation' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display 'Complexity Calculation' section"
    exit 1
fi

# Test 3: Verify cmd_estimator displays Scoring Factors section
if ! grep -q 'Scoring Factors' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display 'Scoring Factors' section"
    exit 1
fi

# Test 4: Verify individual factors are displayed
if ! grep -q 'Acceptance Criteria' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display Acceptance Criteria factor"
    exit 1
fi

if ! grep -q 'Complex Keywords' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display Complex Keywords factor"
    exit 1
fi

# Test 5: Verify Estimation Rules section explains scoring thresholds
if ! grep -q 'Estimation Rules' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display 'Estimation Rules' section"
    exit 1
fi

# Test 6: Verify score thresholds are documented
if ! grep -qE 'score.*3.*complex|complex.*score.*3' "$FADE_CLI"; then
    echo "FAIL: estimator explain should document score >= 3 -> complex rule"
    exit 1
fi

# Test 7: Verify Recommendation section exists
if ! grep -q 'Recommendation' "$FADE_CLI"; then
    echo "FAIL: estimator explain should display 'Recommendation' section"
    exit 1
fi

echo "PASS: fade estimator explain outputs complete rubric decision details"
exit 0
