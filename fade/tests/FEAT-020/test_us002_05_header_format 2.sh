#!/bin/bash
# Test: Commands print execution header with correct format
# AC: All commands print an execution header like: `FADE | repo=<name> | branch=<branch> | run=<run_id> | mode=<mode> | model=<model>` where applicable.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Create a run with metadata
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
echo "Test log line" > "fade/runs/$RUN_ID/run.log"
touch "fade/runs/$RUN_ID/events.jsonl"

# Test logs command header
LOGS_OUTPUT=$("$FADE_CLI" logs "$RUN_ID" 2>&1)

# Check for header with repo
if ! echo "$LOGS_OUTPUT" | grep -qE "FADE.*repo="; then
    echo "FAIL: logs command missing repo in header"
    echo "Expected: Header containing 'repo='"
    echo "Actual: $LOGS_OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for header with branch
if ! echo "$LOGS_OUTPUT" | grep -qE "branch="; then
    echo "FAIL: logs command missing branch in header"
    echo "Expected: Header containing 'branch='"
    echo "Actual: $LOGS_OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for header with run_id
if ! echo "$LOGS_OUTPUT" | grep -qE "run="; then
    echo "FAIL: logs command missing run in header"
    echo "Expected: Header containing 'run='"
    echo "Actual: $LOGS_OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for header with mode
if ! echo "$LOGS_OUTPUT" | grep -qE "mode="; then
    echo "FAIL: logs command missing mode in header"
    echo "Expected: Header containing 'mode='"
    echo "Actual: $LOGS_OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for header with model
if ! echo "$LOGS_OUTPUT" | grep -qE "model="; then
    echo "FAIL: logs command missing model in header"
    echo "Expected: Header containing 'model='"
    echo "Actual: $LOGS_OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Commands print execution header with repo, branch, run, mode, and model"
exit 0
