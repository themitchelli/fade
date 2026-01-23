#!/bin/bash
# Test: verify FADE.md project structure matches actual layout
# AC: Project structure matches actual layout

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_MD="$PROJECT_ROOT/FADE.md"

# Key directories that should be mentioned in FADE.md
EXPECTED_DIRS=("bin/" "fade/" "standards/" "prds/" "tests/")

missing=()

for dir in "${EXPECTED_DIRS[@]}"; do
    if ! grep -q "$dir" "$FADE_MD"; then
        missing+=("$dir")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "FAIL: FADE.md missing references to directories: ${missing[*]}"
    echo "Expected: All key directories documented"
    echo "Actual: Missing: ${missing[*]}"
    exit 1
fi

echo "PASS: FADE.md references key project directories"
exit 0
