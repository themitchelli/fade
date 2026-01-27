#!/bin/bash
# Test: verify detect-sessions.sh logs reasoning to stderr
# AC: Log reasoning to stderr: 'PRD-001: 1 ALL_COMPLETE + 0 BLOCKED + 0 incomplete = 1 session' or similar

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Setup: create temp files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/progress.md" << 'EOF'
## 2026-01-20 14:30 - US-001: Story (TEST-001) - COMPLETE
EOF

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "userStories": [{"id": "US-001", "passes": true}]
}
EOF

# Act: capture stderr
stderr=$(bash "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/progress.md" "$TEST_DIR/prd.json" 2>&1 >/dev/null)

# Assert: stderr contains reasoning with PRD ID and session calculation
if [[ "$stderr" != *"TEST-001"* ]]; then
    echo "FAIL: Reasoning should contain PRD ID"
    echo "Expected: contains 'TEST-001'"
    echo "Actual: $stderr"
    exit 1
fi

if [[ "$stderr" != *"session"* ]]; then
    echo "FAIL: Reasoning should mention session count"
    echo "Expected: contains 'session'"
    echo "Actual: $stderr"
    exit 1
fi

echo "PASS: detect-sessions.sh logs reasoning to stderr"
exit 0
