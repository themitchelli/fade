#!/bin/bash
# Test: verify token estimation based on context size (chars / 4)
# AC: Estimate tokens used based on context size + PRD size (rough: chars / 4)

set -e

FADE_CLI="$(which fade)"

# Check estimate_tokens function divides by 4
if grep -A 5 "estimate_tokens()" "$FADE_CLI" | grep -q "/ 4\|/4"; then
    echo "PASS: Token estimation uses chars / 4 formula"
    exit 0
fi

echo "FAIL: Token estimation should use chars / 4 formula"
exit 1
