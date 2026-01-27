#!/bin/bash
# Test: FADE_MODEL env var overrides complexity
# AC: Test: FADE_MODEL env overrides complexity

# Source the fade-cli to get access to functions
source bin/fade-cli

# Create a temp PRD with complexity=complex
temp_prd=$(mktemp)
cat > "$temp_prd" << 'EOF'
{
  "complexity": "complex"
}
EOF

# Test: FADE_MODEL should override PRD complexity (complex→opus normally)
export FADE_MODEL="haiku"
result=$(get_model_for_complexity "$temp_prd" "false" "sonnet")
model=$(echo "$result" | cut -d'|' -f1)
source=$(echo "$result" | cut -d'|' -f2)

if [[ "$model" != "haiku" ]] || [[ "$source" != "FADE_MODEL env var" ]]; then
    echo "FAIL: FADE_MODEL env did not override complexity"
    echo "Expected: haiku|FADE_MODEL env var"
    echo "Actual: $result"
    rm -f "$temp_prd"
    exit 1
fi

rm -f "$temp_prd"
unset FADE_MODEL
echo "PASS: FADE_MODEL env correctly overrides complexity"
exit 0
