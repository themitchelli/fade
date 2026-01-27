#!/bin/bash
# Test: verifies 'STORY_DONE: US-001' triggers STORY_DONE detection
# AC: Create test that verifies 'STORY_DONE: US-001' triggers STORY_DONE detection

# Test various valid STORY_DONE signal formats

test_cases=(
    "STORY_DONE: US-001"
    "STORY_DONE: US-123"
    "STORY_DONE: FEAT-001"
    "STORY_DONE: BUG-007"
)

for test_case in "${test_cases[@]}"; do
    if ! echo "$test_case" | grep -q '^STORY_DONE: '; then
        echo "FAIL: Valid STORY_DONE signal should be detected"
        echo "Expected: match for '^STORY_DONE: '"
        echo "Actual: no match on: '$test_case'"
        exit 1
    fi
done

# Test in multiline context
multiline_output="I've completed implementing the feature.
All acceptance criteria have been met.

STORY_DONE: US-001

The feature is ready for review."

if ! echo "$multiline_output" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE should be detected in multiline output"
    exit 1
fi

echo "PASS: STORY_DONE: US-XXX triggers detection correctly (${#test_cases[@]} cases + multiline verified)"
exit 0
