#!/bin/bash
# Test: fade run without --detach warns when active run exists
# AC: When a run is active for a repo, `fade run` without `--detach` warns the user and offers a clear suggestion (status/logs/stop).

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

# Run fade run without --detach (should warn)
OUTPUT=$("$FADE_CLI" run 2>&1)

# Check for warning about active run
if ! echo "$OUTPUT" | grep -qE "(Active run|in progress)"; then
    echo "FAIL: Expected warning about active run"
    echo "Expected: Warning message about active run"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for suggestion to use logs
if ! echo "$OUTPUT" | grep -qE "(logs|fade logs)"; then
    echo "FAIL: Expected suggestion to use fade logs"
    echo "Expected: Suggestion including 'logs'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for suggestion to use stop
if ! echo "$OUTPUT" | grep -qE "(stop|fade stop)"; then
    echo "FAIL: Expected suggestion to use fade stop"
    echo "Expected: Suggestion including 'stop'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade run warns about active run and suggests logs/stop"
exit 0
