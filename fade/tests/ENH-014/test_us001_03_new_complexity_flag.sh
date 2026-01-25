#!/bin/bash
# Test: verify fade new --complexity=simple creates PRD with complexity field
# AC: fade new --complexity=simple creates PRD with complexity field

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD with --complexity flag
fade new feature "Test Feature" --complexity=simple < /dev/null 2>/dev/null || true

# Find the created PRD
PRD_FILE=$(ls fade/prds/FEAT-*.json 2>/dev/null | head -1)

if [[ -z "$PRD_FILE" ]]; then
    rm -rf "$TEST_DIR"
    echo "FAIL: No PRD file created"
    exit 1
fi

# Extract complexity field
COMPLEXITY=$(grep -o '"complexity"[[:space:]]*:[[:space:]]*"[^"]*"' "$PRD_FILE" | sed 's/.*"complexity"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Cleanup
rm -rf "$TEST_DIR"

# Assert
if [[ "$COMPLEXITY" != "simple" ]]; then
    echo "FAIL: complexity field not set correctly with --complexity flag"
    echo "Expected: simple"
    echo "Actual: $COMPLEXITY"
    exit 1
fi

echo "PASS: fade new --complexity=simple creates PRD with complexity field"
exit 0
