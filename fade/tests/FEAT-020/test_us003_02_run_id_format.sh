#!/bin/bash
# Test: Run IDs are unique, stable, and sortable (timestamp-based)
# AC: Run IDs are unique, stable, and sortable (timestamp-based or incrementing).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Start first run
OUTPUT1=$("$FADE_CLI" run --detach 2>&1)
RUN_ID1=$(echo "$OUTPUT1" | grep -oE "[0-9]{8}-[0-9]{6}-[0-9]{3}" | head -1)

if [[ -z "$RUN_ID1" ]]; then
    echo "FAIL: First run did not return a valid run_id"
    echo "Output: $OUTPUT1"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify run_id format is YYYYMMDD-HHMMSS-NNN
if ! echo "$RUN_ID1" | grep -qE "^[0-9]{8}-[0-9]{6}-[0-9]{3}$"; then
    echo "FAIL: Run ID not in expected format YYYYMMDD-HHMMSS-NNN"
    echo "Expected format: YYYYMMDD-HHMMSS-NNN"
    echo "Actual: $RUN_ID1"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Mark first run as stopped so we can start another
sed -i.bak 's/"state": "running"/"state": "stopped"/' "fade/runs/$RUN_ID1/run.json"

# Small delay to ensure different timestamp
sleep 1

# Start second run
OUTPUT2=$("$FADE_CLI" run --detach 2>&1)
RUN_ID2=$(echo "$OUTPUT2" | grep -oE "[0-9]{8}-[0-9]{6}-[0-9]{3}" | head -1)

if [[ -z "$RUN_ID2" ]]; then
    echo "FAIL: Second run did not return a valid run_id"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify uniqueness
if [[ "$RUN_ID1" == "$RUN_ID2" ]]; then
    echo "FAIL: Run IDs are not unique"
    echo "Run 1: $RUN_ID1"
    echo "Run 2: $RUN_ID2"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify sortability (second run should sort after first)
SORTED=$(echo -e "$RUN_ID1\n$RUN_ID2" | sort)
FIRST_SORTED=$(echo "$SORTED" | head -1)
if [[ "$FIRST_SORTED" != "$RUN_ID1" ]]; then
    echo "FAIL: Run IDs are not sortable in chronological order"
    echo "Expected first: $RUN_ID1"
    echo "Sorted first: $FIRST_SORTED"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Run IDs are unique, timestamp-based, and sortable"
exit 0
