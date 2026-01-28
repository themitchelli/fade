#!/bin/bash
# Test: fade stop updates run.json state to stopped
# AC: Stopping a run updates `run.json` state to `stopped` and records stop time and stop reason.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Create a simulated running run
RUN_ID="20260127-120000-001"
mkdir -p "fade/runs/$RUN_ID"
cat > "fade/runs/$RUN_ID/run.json" << 'EOF'
{
  "run_id": "20260127-120000-001",
  "repo": "test-repo",
  "repo_path": "/tmp/test-repo",
  "branch": "main",
  "mode": "ALL",
  "model": "sonnet",
  "start_time": "2026-01-27T12:00:00Z",
  "current_prd": "TEST-001",
  "current_prd_name": "Test PRD",
  "state": "running",
  "stop_time": null,
  "stop_reason": null
}
EOF
touch "fade/runs/$RUN_ID/run.log"
touch "fade/runs/$RUN_ID/events.jsonl"

# Run fade stop
"$FADE_CLI" stop "$RUN_ID" > /dev/null 2>&1

# Check that state was updated to stopped
STATE=$(grep -o '"state": "[^"]*"' "fade/runs/$RUN_ID/run.json" | cut -d'"' -f4)
if [[ "$STATE" != "stopped" ]]; then
    echo "FAIL: Expected state to be 'stopped'"
    echo "Expected: stopped"
    echo "Actual: $STATE"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that stop_time was recorded (not null)
STOP_TIME=$(grep -o '"stop_time": "[^"]*"' "fade/runs/$RUN_ID/run.json" | cut -d'"' -f4 || echo "null")
if [[ -z "$STOP_TIME" ]]; then
    # Check if it's still null
    if grep -q '"stop_time": null' "fade/runs/$RUN_ID/run.json"; then
        echo "FAIL: Expected stop_time to be set"
        echo "Expected: timestamp"
        echo "Actual: null"
        rm -rf "$TEST_DIR"
        exit 1
    fi
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade stop updates run.json state to 'stopped' and records stop_time"
exit 0
