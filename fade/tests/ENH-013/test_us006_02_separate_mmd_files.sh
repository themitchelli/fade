#!/bin/bash
# Test: Generates context.mmd, container.mmd, component.mmd as separate files
# AC: Generates context.mmd, container.mmd, component.mmd as separate files

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

mkdir -p routes services
echo "// Routes" > routes/api.js
echo "// Services" > services/logic.js

# Act - run fade map with mermaid format at component level
fade map --diagram=component --diagram-format=mermaid > /dev/null 2>&1

# Assert - check for separate mmd files
# Default output should create architecture_context.mmd, architecture_container.mmd, architecture_component.mmd
if [[ ! -f "architecture_context.mmd" ]]; then
    echo "FAIL: context.mmd file not created"
    echo "Expected: architecture_context.mmd"
    echo "Actual files: $(ls -la *.mmd 2>/dev/null || echo 'no .mmd files')"
    rm -rf "$TEST_DIR"
    exit 1
fi

if [[ ! -f "architecture_container.mmd" ]]; then
    echo "FAIL: container.mmd file not created"
    echo "Expected: architecture_container.mmd"
    rm -rf "$TEST_DIR"
    exit 1
fi

if [[ ! -f "architecture_component.mmd" ]]; then
    echo "FAIL: component.mmd file not created"
    echo "Expected: architecture_component.mmd"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Generates separate mmd files for each level"
exit 0
