#!/bin/bash
# Test: --diagram-output=PATH allows custom output location
# AC: --diagram-output=PATH allows custom output location

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR/output"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0"
}
EOF

# Act - run fade map with custom output path
fade map --diagram --diagram-output=output/custom-diagram.html > /dev/null 2>&1

# Assert - check custom file location
if [[ ! -f "output/custom-diagram.html" ]]; then
    echo "FAIL: Custom output file was not created at specified path"
    echo "Expected: output/custom-diagram.html"
    echo "Actual: $(ls -la output/ 2>/dev/null || echo 'output directory not found')"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify the default location does NOT have the file
if [[ -f "architecture.html" ]]; then
    echo "FAIL: Default architecture.html was also created"
    echo "Expected: Only custom path file"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify it's a valid HTML file
if ! grep -q "<!DOCTYPE html>" output/custom-diagram.html; then
    echo "FAIL: Custom output is not a valid HTML file"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --diagram-output=PATH allows custom output location"
exit 0
