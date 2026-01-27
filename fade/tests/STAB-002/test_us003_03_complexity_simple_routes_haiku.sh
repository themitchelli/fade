#!/bin/bash
# Test: complexity=simple routes to haiku
# AC: Test: complexity=simple routes to haiku

# Source the fade-cli to get access to functions
source bin/fade-cli

# Create a temp PRD with complexity=simple
temp_prd=$(mktemp)
cat > "$temp_prd" << 'EOF'
{
  "complexity": "simple"
}
EOF

# Test: complexity=simple should route to haiku
result=$(get_model_for_complexity "$temp_prd" "false" "sonnet")
model=$(echo "$result" | cut -d'|' -f1)
source=$(echo "$result" | cut -d'|' -f2)

if [[ "$model" != "haiku" ]] || [[ "$source" != "complexity=simple" ]]; then
    echo "FAIL: complexity=simple did not route to haiku"
    echo "Expected: haiku|complexity=simple"
    echo "Actual: $result"
    rm -f "$temp_prd"
    exit 1
fi

rm -f "$temp_prd"
echo "PASS: complexity=simple correctly routes to haiku"
exit 0
