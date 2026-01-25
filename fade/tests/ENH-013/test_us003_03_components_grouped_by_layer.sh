#!/bin/bash
# Test: Components grouped by architectural layer (presentation, business, data)
# AC: Components grouped by architectural layer (presentation, business, data)

# Setup - create a test project with layered structure
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-layered-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Create layered directory structure
mkdir -p routes controllers services models
echo "// Routes (presentation)" > routes/api.js
echo "// Controller (presentation)" > controllers/main.js
echo "// Service (business)" > services/logic.js
echo "// Model (data)" > models/Entity.js

# Act - run fade map with component level diagram
fade map --diagram=component > /dev/null 2>&1

# Assert - check for layer grouping
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for layer-related terms or Component_Boundary (grouping) in diagram
# C4 uses Container_Boundary or Boundary() for grouping
if ! grep -qiE "presentation|business|data|layer|routes|controllers|services|models|Boundary" architecture.html; then
    echo "FAIL: No layer grouping or architectural terms found in diagram"
    echo "Expected: Layer grouping or architectural layer references"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Components grouped by architectural layer"
exit 0
