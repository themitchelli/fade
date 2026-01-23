#!/bin/bash
# Test: verify FADE.md contains architecture references
# AC: Architecture references are current

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_MD="$PROJECT_ROOT/FADE.md"

# Check for Architecture section
if ! grep -q "Architecture" "$FADE_MD"; then
    echo "FAIL: FADE.md missing Architecture section"
    echo "Expected: Architecture section present"
    echo "Actual: Section not found"
    exit 1
fi

# Check for key architecture elements
if ! grep -q "fade-cli" "$FADE_MD"; then
    echo "FAIL: FADE.md Architecture should reference fade-cli"
    echo "Expected: fade-cli mentioned"
    echo "Actual: Not found"
    exit 1
fi

echo "PASS: FADE.md contains architecture references"
exit 0
