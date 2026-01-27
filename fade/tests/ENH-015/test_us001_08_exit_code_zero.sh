#!/bin/bash
# Test: verify detect-sessions.sh exits 0 on success
# AC: Exit code 0 on success, show warning if PRD JSON unreachable but continue with signal-only count

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Setup: create temp files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/progress.md" << 'EOF'
## 2026-01-20 14:30 - US-001: Story (TEST-001) - COMPLETE
EOF

cat > "$TEST_DIR/prd.json" << 'EOF'
{"id": "TEST-001", "userStories": [{"id": "US-001", "passes": true}]}
EOF

# Act
bash "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/progress.md" "$TEST_DIR/prd.json" >/dev/null 2>&1
exit_code=$?

# Assert
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: Expected exit code 0 on success"
    echo "Expected: 0"
    echo "Actual: $exit_code"
    exit 1
fi

echo "PASS: detect-sessions.sh exits 0 on success"
exit 0
