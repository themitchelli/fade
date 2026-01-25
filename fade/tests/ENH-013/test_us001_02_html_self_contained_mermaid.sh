#!/bin/bash
# Test: HTML file is self-contained with embedded Mermaid.js CDN link
# AC: HTML file is self-contained with embedded Mermaid.js CDN link

# Setup - create a minimal test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a minimal package.json
cat > package.json << 'EOF'
{
  "name": "test-project",
  "version": "1.0.0"
}
EOF

# Act - run fade map --diagram
fade map --diagram > /dev/null 2>&1

# Assert - check that HTML contains Mermaid.js CDN link
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for Mermaid CDN reference
if ! grep -q "cdn.jsdelivr.net/npm/mermaid" architecture.html; then
    echo "FAIL: Mermaid.js CDN link not found in HTML"
    echo "Expected: CDN link like cdn.jsdelivr.net/npm/mermaid"
    echo "Actual: $(grep -i 'mermaid' architecture.html | head -3)"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check it's a complete HTML file (self-contained)
if ! grep -q "<!DOCTYPE html>" architecture.html; then
    echo "FAIL: HTML file is not a complete document"
    echo "Expected: <!DOCTYPE html> declaration"
    rm -rf "$TEST_DIR"
    exit 1
fi

if ! grep -q "</html>" architecture.html; then
    echo "FAIL: HTML file is not complete (missing closing tag)"
    echo "Expected: </html> closing tag"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: HTML file is self-contained with embedded Mermaid.js CDN link"
exit 0
