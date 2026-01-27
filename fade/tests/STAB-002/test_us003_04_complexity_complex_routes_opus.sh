#!/bin/bash
# Test: complexity=complex routes to opus
# AC: Test: complexity=complex routes to opus

# Source the fade-cli to get access to functions
source bin/fade-cli

# Create a temp PRD with complexity=complex
temp_prd=$(mktemp)
cat > "$temp_prd" << 'EOF'
{
  "complexity": "complex"
}
EOF

# Test: complexity=complex should route to opus
result=$(get_model_for_complexity "$temp_prd" "false" "sonnet")
model=$(echo "$result" | cut -d'|' -f1)
source=$(echo "$result" | cut -d'|' -f2)

if [[ "$model" != "opus" ]] || [[ "$source" != "complexity=complex" ]]; then
    echo "FAIL: complexity=complex did not route to opus"
    echo "Expected: opus|complexity=complex"
    echo "Actual: $result"
    rm -f "$temp_prd"
    exit 1
fi

rm -f "$temp_prd"
echo "PASS: complexity=complex correctly routes to opus"
exit 0
