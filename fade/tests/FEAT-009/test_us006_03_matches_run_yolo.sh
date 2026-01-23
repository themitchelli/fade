#!/bin/bash
# Test: verify quick --yolo behavior matches fade run --yolo pattern
# AC: Behavior matches fade run --yolo pattern

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helper.sh"

# Setup
FADE_CLI_PATH=$(find_fade_cli)
if [[ -z "$FADE_CLI_PATH" ]]; then
    echo "FAIL: Could not locate fade-cli script"
    exit 1
fi

# Get both cmd_quick and cmd_run functions
cmd_quick_content=$(extract_cmd_quick "$FADE_CLI_PATH")
cmd_run_content=$(extract_cmd_run "$FADE_CLI_PATH")

if [[ -z "$cmd_quick_content" ]]; then
    echo "FAIL: Could not extract cmd_quick function"
    exit 1
fi

if [[ -z "$cmd_run_content" ]]; then
    echo "FAIL: Could not extract cmd_run function"
    exit 1
fi

# Assert 1 - both use --dangerously-skip-permissions for yolo mode
if ! echo "$cmd_quick_content" | grep -q '\-\-dangerously-skip-permissions'; then
    echo "FAIL: cmd_quick doesn't use --dangerously-skip-permissions"
    exit 1
fi

if ! echo "$cmd_run_content" | grep -q '\-\-dangerously-skip-permissions'; then
    echo "FAIL: cmd_run doesn't use --dangerously-skip-permissions"
    exit 1
fi

# Assert 2 - both parse --yolo flag
if ! echo "$cmd_quick_content" | grep -q '\-\-yolo'; then
    echo "FAIL: cmd_quick doesn't parse --yolo"
    exit 1
fi

if ! echo "$cmd_run_content" | grep -q '\-\-yolo'; then
    echo "FAIL: cmd_run doesn't parse --yolo"
    exit 1
fi

# Assert 3 - verify help documents --yolo for both run and quick
FADE_CLI="${FADE_CLI:-fade}"
help_output=$($FADE_CLI help 2>&1)

# Check Run Options section has --yolo
if ! echo "$help_output" | grep -A10 "Run Options" | grep -q "\-\-yolo"; then
    echo "FAIL: Run Options doesn't document --yolo"
    exit 1
fi

# Check Quick Options section has --yolo
if ! echo "$help_output" | grep -A5 "Quick Options" | grep -q "\-\-yolo"; then
    echo "FAIL: Quick Options doesn't document --yolo"
    exit 1
fi

echo "PASS: quick --yolo behavior matches fade run --yolo pattern"
exit 0
