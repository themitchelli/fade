#!/bin/bash
# Test: fade status lists active runs with required fields
# AC: Command `fade status` lists active runs and the last N recent runs with: `run_id`, repo, branch, state, current PRD, current story, model, and start time.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Create a simulated active run
mkdir -p fade/runs/20260127-120000-001
cat > fade/runs/20260127-120000-001/run.json << 'EOF'
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
touch fade/runs/20260127-120000-001/run.log
touch fade/runs/20260127-120000-001/events.jsonl

# Run fade status
OUTPUT=$("$FADE_CLI" status 2>&1)

# Check for run_id in output
if ! echo "$OUTPUT" | grep -q "20260127-120000-001"; then
    echo "FAIL: Expected status to show run_id"
    echo "Expected: Contains '20260127-120000-001'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for repo in output
if ! echo "$OUTPUT" | grep -q "test-repo"; then
    echo "FAIL: Expected status to show repo name"
    echo "Expected: Contains 'test-repo'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for branch in output
if ! echo "$OUTPUT" | grep -q "main"; then
    echo "FAIL: Expected status to show branch"
    echo "Expected: Contains 'main'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for model in output
if ! echo "$OUTPUT" | grep -q "sonnet"; then
    echo "FAIL: Expected status to show model"
    echo "Expected: Contains 'sonnet'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for PRD in output
if ! echo "$OUTPUT" | grep -q "TEST-001"; then
    echo "FAIL: Expected status to show PRD id"
    echo "Expected: Contains 'TEST-001'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade status lists active runs with run_id, repo, branch, model, and PRD"
exit 0
