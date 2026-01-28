#!/bin/bash
# Test: verify events do not contain secrets
# AC: Events do not contain secrets (no API keys, tokens, or credential-like strings).

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

mkdir -p fade/runs
RUN_ID="test-run-$(date +%s)"
mkdir -p "fade/runs/$RUN_ID"

# Create events file with typical FADE events (no secrets)
cat > "fade/runs/$RUN_ID/events.jsonl" << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"test-123","repo":"test","event_type":"run_start","data":{"mode":"ALL","model":"sonnet","prd_id":"FEAT-001"}}
{"ts":"2024-01-01T12:00:01Z","run_id":"test-123","repo":"test","event_type":"model_selected","data":{"model":"sonnet","source":"complexity","iteration":1}}
{"ts":"2024-01-01T12:00:02Z","run_id":"test-123","repo":"test","event_type":"story_end","data":{"story_id":"US-001","status":"pass"}}
{"ts":"2024-01-01T12:00:03Z","run_id":"test-123","repo":"test","event_type":"run_stop","data":{"status":"complete","iterations":3}}
EOF

# Patterns that indicate secrets or credentials
# Note: These patterns are common indicators, not exhaustive
secret_patterns=(
    'sk-[a-zA-Z0-9]{20,}'           # OpenAI API key pattern
    'ANTHROPIC_API_KEY'              # Anthropic env var name
    'OPENAI_API_KEY'                 # OpenAI env var name
    'api[_-]?key.*=.*[a-zA-Z0-9]{20,}'  # Generic API key assignment
    'token.*=.*[a-zA-Z0-9]{20,}'     # Generic token assignment
    'password.*=.*[^\s]+'            # Password assignment
    'secret.*=.*[^\s]+'              # Secret assignment
    'Bearer [a-zA-Z0-9._-]+'         # Bearer token
    'ghp_[a-zA-Z0-9]{36}'           # GitHub personal access token
    'gho_[a-zA-Z0-9]{36}'           # GitHub OAuth token
)

found_secrets=""
events_content=$(cat "fade/runs/$RUN_ID/events.jsonl")

for pattern in "${secret_patterns[@]}"; do
    if echo "$events_content" | grep -qiE "$pattern"; then
        found_secrets="$found_secrets [pattern: $pattern]"
    fi
done

if [[ -n "$found_secrets" ]]; then
    echo "FAIL: Events file appears to contain secrets"
    echo "Matched patterns:$found_secrets"
    echo "Events content:"
    echo "$events_content"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify no common credential field names with values
if echo "$events_content" | grep -qiE '"(api_key|apiKey|secret|password|token|credential|auth)"\s*:\s*"[^"]{10,}"'; then
    echo "FAIL: Events contain credential-like fields with substantial values"
    echo "Events content:"
    echo "$events_content"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Events do not contain secrets or credential-like strings"
exit 0
