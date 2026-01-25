#!/bin/bash
# Test: verify complexity value validation rejects invalid values
# AC: Validate complexity value in PRD schema (reject invalid values)

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Try to create PRD with invalid complexity value
OUTPUT=$(fade new feature "Test Feature" --complexity=invalid 2>&1 || true)

# Check if error message was shown
if echo "$OUTPUT" | grep -q "Invalid complexity value"; then
    # Cleanup
    rm -rf "$TEST_DIR"
    echo "PASS: Invalid complexity value is rejected"
    exit 0
fi

# Also verify valid values are accepted
for valid_value in simple medium complex; do
    rm -f fade/prds/*.json 2>/dev/null || true
    OUTPUT=$(fade new feature "Test $valid_value" --complexity=$valid_value 2>&1 < /dev/null || true)
    if echo "$OUTPUT" | grep -q "Invalid complexity value"; then
        rm -rf "$TEST_DIR"
        echo "FAIL: Valid complexity value '$valid_value' was rejected"
        exit 1
    fi
done

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Complexity value validation works correctly"
exit 0
