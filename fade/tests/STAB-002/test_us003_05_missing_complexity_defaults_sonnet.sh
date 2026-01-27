#!/bin/bash
# Test: missing complexity defaults to sonnet
# AC: Test: missing complexity defaults to sonnet

# Source the fade-cli to get access to functions
source bin/fade-cli

# Create a temp PRD without complexity field
temp_prd=$(mktemp)
cat > "$temp_prd" << 'EOF'
{
  "name": "Test PRD"
}
EOF

# Test: missing complexity should default to sonnet
result=$(get_model_for_complexity "$temp_prd" "false" "sonnet")
model=$(echo "$result" | cut -d'|' -f1)
source=$(echo "$result" | cut -d'|' -f2)

if [[ "$model" != "sonnet" ]] || [[ "$source" != "complexity=medium (default)" ]]; then
    echo "FAIL: missing complexity did not default to sonnet"
    echo "Expected: sonnet|complexity=medium (default)"
    echo "Actual: $result"
    rm -f "$temp_prd"
    exit 1
fi

rm -f "$temp_prd"
echo "PASS: missing complexity correctly defaults to sonnet"
exit 0
