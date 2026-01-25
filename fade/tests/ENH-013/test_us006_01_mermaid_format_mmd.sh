#!/bin/bash
# Test: --diagram-format=mermaid outputs .mmd files instead of HTML
# AC: --diagram-format=mermaid outputs .mmd files instead of HTML

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

mkdir -p src
echo "// Code" > src/index.js

# Act - run fade map with mermaid format
fade map --diagram --diagram-format=mermaid > /dev/null 2>&1

# Assert - check that .mmd files are created, not HTML
if [[ -f "architecture.html" ]]; then
    echo "FAIL: HTML file created when mermaid format requested"
    echo "Expected: Only .mmd files"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for at least one .mmd file
mmd_files=$(find . -maxdepth 1 -name "*.mmd" | wc -l)
if [[ "$mmd_files" -lt 1 ]]; then
    echo "FAIL: No .mmd files created"
    echo "Expected: .mmd files for diagram export"
    echo "Actual files: $(ls -la)"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --diagram-format=mermaid outputs .mmd files"
exit 0
