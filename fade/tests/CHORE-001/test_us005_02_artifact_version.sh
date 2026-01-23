#!/bin/bash
# Test: verify ARTIFACT_VERSION in bin/fade-cli is 0.3.1
# AC: PROMPT_VERSION in bin/fade-cli updated to 0.3.1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_CLI="$PROJECT_ROOT/bin/fade-cli"

# Extract ARTIFACT_VERSION value (this is the prompt version)
version=$(grep -E '^ARTIFACT_VERSION=' "$FADE_CLI" | head -1 | sed 's/ARTIFACT_VERSION="//' | sed 's/"//')

if [[ "$version" != "0.3.1" ]]; then
    echo "FAIL: ARTIFACT_VERSION is not 0.3.1"
    echo "Expected: 0.3.1"
    echo "Actual: $version"
    exit 1
fi

echo "PASS: ARTIFACT_VERSION is 0.3.1"
exit 0
