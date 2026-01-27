#!/bin/bash
# Test: Session detection handles incomplete stories (ongoing PRD)
# AC: If has_incomplete (resumed work): sessions = (completed + blocked) + 1

set -e

# Create test data
temp_progress=$(mktemp)
trap "rm -f $temp_progress" EXIT

cat > "$temp_progress" <<'EOF'
## 2026-01-25 17:30 - US-002: Test (ENH-015) - COMPLETE
- Work done
EOF

# Create PRD with one incomplete story
temp_prd=$(mktemp)
trap "rm -f $temp_prd $temp_progress" EXIT

cat > "$temp_prd" <<'EOF'
{
  "type": "enhancement",
  "id": "ENH-015",
  "name": "Test",
  "userStories": [
    {"id": "US-001", "passes": true},
    {"id": "US-002", "passes": false}
  ]
}
EOF

# Test: 1 completed + 0 blocked + 1 incomplete = 2 total sessions
result=$(bash fade/lib/detect-sessions.sh "ENH-015" "$temp_progress" "$temp_prd" 2>&1 | tail -1)

if [[ "$result" == "2" ]]; then
    echo "PASS: Detected 1 completed + 1 incomplete = 2 sessions"
    exit 0
else
    echo "FAIL: Expected 2 sessions for incomplete PRD, got $result"
    exit 1
fi
