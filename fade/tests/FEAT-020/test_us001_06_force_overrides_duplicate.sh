#!/bin/bash
# Test: --force flag allows starting a run even when one is already active
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

# Try to start another detached run with --force (should succeed)
OUTPUT=$("$FADE_CLI" run --detach --force 2>&1)

# Check that a new run was started
if ! echo "$OUTPUT" | grep -q "Run started in background"; then
    echo "FAIL: Expected --force to allow starting new run"
    echo "Expected: 'Run started in background'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify a new run_id was generated (different from the existing one)
NEW_RUN_ID=$(echo "$OUTPUT" | grep -oE "[0-9]{8}-[0-9]{6}-[0-9]{3}" | head -1)
if [[ "$NEW_RUN_ID" == "20260101-000000-001" ]]; then
    echo "FAIL: Expected new run_id, got existing one"
    echo "Actual: $NEW_RUN_ID"
    rm -rf "$TEST_DIR"
    exit 1
fi

if [[ -z "$NEW_RUN_ID" ]]; then
    echo "FAIL: No new run_id generated"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --force flag allows starting run despite existing active run"
exit 0
