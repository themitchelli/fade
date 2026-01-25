#!/bin/bash
# Test: Zoom and pan controls for large diagrams
# AC: Zoom and pan controls for large diagrams

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

# Assert - check for zoom controls
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for zoom controls class
if ! grep -q 'zoom-controls' architecture.html; then
    echo "FAIL: Zoom controls container not found"
    echo "Expected: Element with class='zoom-controls'"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for zoom functions
if ! grep -q 'zoomIn\|zoomOut\|resetZoom' architecture.html; then
    echo "FAIL: Zoom functions not found"
    echo "Expected: zoomIn(), zoomOut(), or resetZoom() functions"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for transform CSS (used for zoom/pan)
if ! grep -qi 'transform' architecture.html; then
    echo "FAIL: CSS transform not found for zoom functionality"
    echo "Expected: CSS transform property for zoom/pan"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Zoom and pan controls for large diagrams"
exit 0
