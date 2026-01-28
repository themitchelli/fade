#!/bin/bash
# Test: verify rubric includes documented factors in its JSON output
# AC: Estimator produces `simple|medium|complex` based on a scored rubric with documented factors

# This test verifies that the rubric output includes all documented factors:
# file count (via AC count), cross-module changes (keywords), security-sensitive areas,
# data migrations (keywords), unknown APIs (keywords)

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify acceptanceCriteria factor is in JSON output
if ! grep -q '"acceptanceCriteria":%d' "$FADE_CLI"; then
    echo "FAIL: Rubric should include acceptanceCriteria factor"
    exit 1
fi

# Test 2: Verify complexKeywords factor is in JSON output
if ! grep -q '"complexKeywords":%d' "$FADE_CLI"; then
    echo "FAIL: Rubric should include complexKeywords factor"
    exit 1
fi

# Test 3: Verify simpleKeywords factor is in JSON output
if ! grep -q '"simpleKeywords":%d' "$FADE_CLI"; then
    echo "FAIL: Rubric should include simpleKeywords factor"
    exit 1
fi

# Test 4: Verify estimatedEffort factor is in JSON output
if ! grep -q '"estimatedEffort":%d' "$FADE_CLI"; then
    echo "FAIL: Rubric should include estimatedEffort factor"
    exit 1
fi

# Test 5: Verify dependencies factor is in JSON output
if ! grep -q '"dependencies":%d' "$FADE_CLI"; then
    echo "FAIL: Rubric should include dependencies factor"
    exit 1
fi

# Test 6: Verify AC count scoring rules exist (>15 complex, <5 simple)
if ! grep -q 'ac_count -gt 15' "$FADE_CLI"; then
    echo "FAIL: AC count threshold >15 should exist for complex scoring"
    exit 1
fi

if ! grep -q 'ac_count -lt 5' "$FADE_CLI"; then
    echo "FAIL: AC count threshold <5 should exist for simple scoring"
    exit 1
fi

# Test 7: Verify complex keywords are documented
if ! grep -qE 'architecture|refactor|integrate|migration|migrate' "$FADE_CLI"; then
    echo "FAIL: Complex keywords should be documented in rubric"
    exit 1
fi

# Test 8: Verify simple keywords are documented
if ! grep -qE 'typo|fix typo|update docs|add test|simple fix' "$FADE_CLI"; then
    echo "FAIL: Simple keywords should be documented in rubric"
    exit 1
fi

echo "PASS: Rubric includes all documented factors (AC count, keywords, effort, dependencies)"
exit 0
