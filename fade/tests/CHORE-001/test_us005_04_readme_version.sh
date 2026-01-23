#!/bin/bash
# Test: verify README.md version references are 0.3.1
# AC: Any version references in README updated

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
README="$PROJECT_ROOT/README.md"

# Check for version in README header (usually "# FADE v0.3.1")
if ! head -5 "$README" | grep -qE "FADE v?0\.3\.1"; then
    actual=$(head -5 "$README" | grep -i "fade")
    echo "FAIL: README version reference is not 0.3.1"
    echo "Expected: FADE v0.3.1 in header"
    echo "Actual: $actual"
    exit 1
fi

echo "PASS: README version reference is 0.3.1"
exit 0
