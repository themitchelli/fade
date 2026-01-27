#!/bin/bash
# Test: All run artifacts remain inside fade/ directory
# AC: All run artifacts remain inside `fade/` and do not pollute repo root.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize a test repo
git init --quiet
echo "# Test" > FADE.md
mkdir -p fade/prds
echo '{"id":"TEST-001","name":"Test PRD","type":"feature","userStories":[]}' > fade/prds/TEST-001.json
echo '{"active_prd":"fade/prds/TEST-001.json"}' > fade/prd.json

# Record files in repo root before run
BEFORE_FILES=$(ls -A "$TEST_DIR" | sort)

# Start a detached run
OUTPUT=$("$FADE_CLI" run --detach 2>&1)
RUN_ID=$(echo "$OUTPUT" | grep -oE "[0-9]{8}-[0-9]{6}-[0-9]{3}" | head -1)

# Record files in repo root after run
AFTER_FILES=$(ls -A "$TEST_DIR" | sort)

# Check that no new files were created in repo root (except .git which may have been modified)
# The only expected top-level items are: .git, FADE.md, fade/
EXPECTED_TOP_LEVEL=".git
FADE.md
fade"

ACTUAL_TOP_LEVEL=$(ls -A "$TEST_DIR" | sort)

if [[ "$ACTUAL_TOP_LEVEL" != "$EXPECTED_TOP_LEVEL" ]]; then
    # Check if any unexpected files were added
    for file in $ACTUAL_TOP_LEVEL; do
        if [[ "$file" != ".git" && "$file" != "FADE.md" && "$file" != "fade" ]]; then
            echo "FAIL: Unexpected file found in repo root: $file"
            echo "Expected only: .git, FADE.md, fade/"
            echo "Actual: $ACTUAL_TOP_LEVEL"
            rm -rf "$TEST_DIR"
            exit 1
        fi
    done
fi

# Verify run artifacts are inside fade/runs/
if [[ -n "$RUN_ID" ]]; then
    if [[ ! -d "fade/runs/$RUN_ID" ]]; then
        echo "FAIL: Run artifacts not in fade/runs/"
        echo "Expected: fade/runs/$RUN_ID/ to exist"
        rm -rf "$TEST_DIR"
        exit 1
    fi
fi

# Check there's no runs/ directory at repo root
if [[ -d "runs" ]]; then
    echo "FAIL: runs/ directory found at repo root (should be fade/runs/)"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check there's no run.json at repo root
if [[ -f "run.json" ]]; then
    echo "FAIL: run.json found at repo root (should be in fade/runs/<run_id>/)"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: All run artifacts remain inside fade/ directory"
exit 0
