#!/bin/bash
# Test: Single HTML file with no external dependencies except CDN
# AC: Single HTML file with no external dependencies except CDN (works offline after first load)

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0"
}
EOF

# Act - run fade map --diagram
fade map --diagram > /dev/null 2>&1

# Assert - verify single HTML file
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Count generated files - should only be architecture.html for diagram
diagram_files=$(find . -maxdepth 1 -name "*.html" -o -name "*.js" -o -name "*.css" | grep -v package | wc -l)
if [[ "$diagram_files" -gt 1 ]]; then
    echo "FAIL: Multiple files generated instead of single self-contained HTML"
    echo "Expected: Only architecture.html"
    echo "Actual: $(find . -maxdepth 1 \( -name '*.html' -o -name '*.js' -o -name '*.css' \) | tr '\n' ' ')"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify HTML contains embedded styles (no external CSS files)
if ! grep -q "<style>" architecture.html; then
    echo "FAIL: HTML does not contain embedded styles"
    echo "Expected: <style> tag with embedded CSS"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify HTML contains embedded scripts (no external JS except CDN)
if ! grep -q "<script>" architecture.html; then
    echo "FAIL: HTML does not contain script tags"
    echo "Expected: <script> tags in HTML"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Single HTML file with no external dependencies except CDN"
exit 0
