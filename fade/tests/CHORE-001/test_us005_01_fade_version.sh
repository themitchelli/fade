#!/bin/bash
# Test: verify FADE_VERSION in bin/fade-cli is 0.3.1
# AC: FADE_VERSION in bin/fade-cli updated to 0.3.1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_CLI="$PROJECT_ROOT/bin/fade-cli"

# Extract FADE_VERSION value
version=$(grep -E '^FADE_VERSION=' "$FADE_CLI" | head -1 | sed 's/FADE_VERSION="//' | sed 's/"//')

if [[ "$version" != "0.3.1" ]]; then
    echo "FAIL: FADE_VERSION is not 0.3.1"
    echo "Expected: 0.3.1"
    echo "Actual: $version"
    exit 1
fi

echo "PASS: FADE_VERSION is 0.3.1"
exit 0
