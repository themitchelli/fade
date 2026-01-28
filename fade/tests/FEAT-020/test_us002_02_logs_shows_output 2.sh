#!/bin/bash
# Test: fade logs <run_id> prints recent log output
# AC: Command `fade logs <run_id>` prints recent log output; `fade logs -f <run_id>` tails the log until interrupted.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Create a run with some log content
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

# Add some log lines
for i in {1..30}; do
    echo "Log line $i: Testing FADE run" >> "fade/runs/$RUN_ID/run.log"
done
touch "fade/runs/$RUN_ID/events.jsonl"

# Run fade logs
OUTPUT=$("$FADE_CLI" logs "$RUN_ID" 2>&1)

# Check that it shows log content (default 20 lines)
if ! echo "$OUTPUT" | grep -q "Log line"; then
    echo "FAIL: Expected logs command to show log content"
    echo "Expected: Contains 'Log line'"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that it shows the context header
if ! echo "$OUTPUT" | grep -qE "FADE.*repo="; then
    echo "FAIL: Expected logs to show context header"
    echo "Expected: Contains 'FADE' header with repo"
    echo "Actual: $OUTPUT"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Test -n flag for custom line count
OUTPUT_N=$("$FADE_CLI" logs "$RUN_ID" -n 5 2>&1)
# Count the number of "Log line" entries (should be approximately 5)
LINE_COUNT=$(echo "$OUTPUT_N" | grep -c "Log line")
if [[ $LINE_COUNT -gt 10 ]]; then
    echo "FAIL: Expected -n 5 to limit output to ~5 lines"
    echo "Expected: ~5 log lines"
    echo "Actual: $LINE_COUNT log lines"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade logs shows recent log output and respects -n flag"
exit 0
