#!/bin/bash
# Test: fade run --detach returns immediately with a run_id
# AC: Command `fade run --detach` starts a run in the background and returns immediately with a `run_id`.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Run fade run --detach and capture output
OUTPUT=$("$FADE_CLI" run --detach 2>&1)

# Verify the command returns a run_id (format: YYYYMMDD-HHMMSS-NNN)
if ! echo "$OUTPUT" | grep -qE "Run ID:.*[0-9]{8}-[0-9]{6}-[0-9]{3}"; then
    echo "FAIL: Expected output to contain Run ID in format YYYYMMDD-HHMMSS-NNN"
    echo "Expected: Run ID: YYYYMMDD-HHMMSS-NNN"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify it returns immediately (check for success message)
if ! echo "$OUTPUT" | grep -q "Run started in background"; then
    echo "FAIL: Expected output to indicate background start"
    echo "Expected: 'Run started in background'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade run --detach returns immediately with a run_id"
exit 0
