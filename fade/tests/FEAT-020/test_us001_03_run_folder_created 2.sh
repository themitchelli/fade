#!/bin/bash
# Test: fade run --detach creates folder fade/runs/<run_id>/
# AC: Each run creates a folder `fade/runs/<run_id>/` containing at minimum: `run.json` (metadata), `run.log` (stdout/stderr), and `events.jsonl` (may be stubbed until FEAT-021).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Run fade run --detach
OUTPUT=$("$FADE_CLI" run --detach 2>&1)

# Extract run_id from output
RUN_ID=$(echo "$OUTPUT" | grep -oE "[0-9]{8}-[0-9]{6}-[0-9]{3}" | head -1)

if [[ -z "$RUN_ID" ]]; then
    echo "FAIL: Could not extract run_id from output"
    echo "Output: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check run folder exists
if [[ ! -d "fade/runs/$RUN_ID" ]]; then
    echo "FAIL: Expected fade/runs/$RUN_ID/ directory to exist"
    echo "Expected: directory exists"
    echo "Actual: directory not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check run.json exists
if [[ ! -f "fade/runs/$RUN_ID/run.json" ]]; then
    echo "FAIL: Expected fade/runs/$RUN_ID/run.json to exist"
    echo "Expected: file exists"
    echo "Actual: file not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check run.log exists
if [[ ! -f "fade/runs/$RUN_ID/run.log" ]]; then
    echo "FAIL: Expected fade/runs/$RUN_ID/run.log to exist"
    echo "Expected: file exists"
    echo "Actual: file not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check events.jsonl exists
if [[ ! -f "fade/runs/$RUN_ID/events.jsonl" ]]; then
    echo "FAIL: Expected fade/runs/$RUN_ID/events.jsonl to exist"
    echo "Expected: file exists"
    echo "Actual: file not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade/runs/<run_id>/ folder created with run.json, run.log, and events.jsonl"
exit 0
