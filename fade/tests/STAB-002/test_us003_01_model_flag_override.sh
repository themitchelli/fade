#!/bin/bash
# Test: --model flag overrides everything
# AC: Test: --model flag overrides everything

# Source the fade-cli to get access to functions
source bin/fade-cli

# Create a temp PRD with complexity=complex
temp_prd=$(mktemp)
cat > "$temp_prd" << 'EOF'
{
  "complexity": "complex"
}
EOF

# Test: --model flag should override PRD complexity (complex) and FADE_MODEL env
export FADE_MODEL="haiku"
result=$(get_model_for_complexity "$temp_prd" "true" "sonnet")
model=$(echo "$result" | cut -d'|' -f1)
source=$(echo "$result" | cut -d'|' -f2)

if [[ "$model" != "sonnet" ]] || [[ "$source" != "--model flag (override)" ]]; then
    echo "FAIL: --model flag did not override"
    echo "Expected: sonnet|--model flag (override)"
    echo "Actual: $result"
    rm -f "$temp_prd"
    exit 1
fi

rm -f "$temp_prd"
unset FADE_MODEL
echo "PASS: --model flag correctly overrides everything"
exit 0
