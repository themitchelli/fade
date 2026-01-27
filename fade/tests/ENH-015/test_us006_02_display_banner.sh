#!/bin/bash
# Test: verify fade run displays recommendation banner
# AC: Display recommendation banner before Claude Code launches with box drawing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for banner display function with box drawing characters
if ! grep -q 'display_model_recommendation\|Model Recommendation\|Recommend:' "$CLI_FILE"; then
    echo "FAIL: fade-cli should have model recommendation banner display"
    exit 1
fi

# Check for box drawing characters
if ! grep -q '┌\|┐\|└\|┘\|│' "$CLI_FILE"; then
    echo "FAIL: fade-cli should use box drawing characters for banner"
    exit 1
fi

echo "PASS: fade-cli has recommendation banner display"
exit 0
