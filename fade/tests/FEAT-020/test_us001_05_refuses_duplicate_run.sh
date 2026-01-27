#!/bin/bash
# Test: FADE refuses to start another detached run if one is already active
# AC: If a detached run is already active for the same repo, FADE refuses to start another unless `--force` is used, and prints a clear message.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Create a simulated active run (state: running)
mkdir -p fade/runs/20260101-000000-001
cat > fade/runs/20260101-000000-001/run.json << 'EOF'
{
  "run_id": "20260101-000000-001",
  "repo": "test-repo",
  "repo_path": "/tmp/test-repo",
  "branch": "main",
  "mode": "ALL",
  "model": "sonnet",
  "start_time": "2026-01-01T00:00:00Z",
  "current_prd": "TEST-001",
  "current_prd_name": "Test PRD",
  "state": "running",
  "stop_time": null,
  "stop_reason": null
}
EOF
touch fade/runs/20260101-000000-001/run.log
touch fade/runs/20260101-000000-001/events.jsonl

# Try to start another detached run (should fail)
OUTPUT=$("$FADE_CLI" run --detach 2>&1)
EXIT_CODE=$?

# Check that it refused (non-zero exit or warning message)
if [[ $EXIT_CODE -eq 0 ]] && ! echo "$OUTPUT" | grep -q "Active run already in progress"; then
    echo "FAIL: Expected FADE to refuse starting duplicate run"
    echo "Expected: Warning about active run or non-zero exit"
    echo "Actual output: $OUTPUT"
    echo "Actual exit code: $EXIT_CODE"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for clear message about active run
if ! echo "$OUTPUT" | grep -qE "(Active run|already in progress|20260101-000000-001)"; then
    echo "FAIL: Expected clear message about existing active run"
    echo "Expected: Message mentioning active run"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: FADE refuses to start duplicate detached run with clear message"
exit 0
