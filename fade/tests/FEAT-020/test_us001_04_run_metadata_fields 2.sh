#!/bin/bash
# Test: run.json contains required metadata fields
# AC: Run metadata includes: repo path, repo name, branch, mode (STOP/ALL/YOLO), selected model, start time, and current PRD id/name.

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
    rm -rf "$TEST_DIR"
    exit 1
fi

RUN_JSON="fade/runs/$RUN_ID/run.json"

# Check for repo_path field
if ! grep -q '"repo_path"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'repo_path' field"
    echo "Expected: contains repo_path"
    echo "Actual: $(cat "$RUN_JSON")"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for repo field
if ! grep -q '"repo"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'repo' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for branch field
if ! grep -q '"branch"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'branch' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for mode field
if ! grep -q '"mode"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'mode' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for model field
if ! grep -q '"model"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'model' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for start_time field
if ! grep -q '"start_time"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'start_time' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for current_prd field
if ! grep -q '"current_prd"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'current_prd' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for current_prd_name field
if ! grep -q '"current_prd_name"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'current_prd_name' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for state field
if ! grep -q '"state"' "$RUN_JSON"; then
    echo "FAIL: run.json missing 'state' field"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: run.json contains all required metadata fields"
exit 0
