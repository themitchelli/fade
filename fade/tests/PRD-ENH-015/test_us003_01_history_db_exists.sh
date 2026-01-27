#!/bin/bash
# Test: model-selection-history.json exists and has correct schema
# AC: File is valid JSON, loadable without errors

set -e

# Test file exists
if [[ ! -f fade/model-selection-history.json ]]; then
    echo "FAIL: model-selection-history.json does not exist"
    exit 1
fi

# Test it's valid JSON
if ! python3 -c "import json; json.load(open('fade/model-selection-history.json'))" 2>/dev/null; then
    echo "FAIL: model-selection-history.json is not valid JSON"
    exit 1
fi

# Test required fields exist
python3 -c "
import json
history = json.load(open('fade/model-selection-history.json'))
assert 'version' in history, 'Missing version field'
assert 'prds' in history, 'Missing prds array'
assert 'learnedHeuristics' in history, 'Missing learnedHeuristics'
assert isinstance(history['prds'], list), 'prds must be array'
assert len(history['prds']) > 0, 'prds array must not be empty'
# Check first PRD record structure
prd = history['prds'][0]
assert 'id' in prd, 'PRD missing id'
assert 'date' in prd, 'PRD missing date'
assert 'features' in prd, 'PRD missing features'
assert 'actualOutcome' in prd, 'PRD missing actualOutcome'
print('All required fields present')
" 2>&1 | grep -q "All required fields" && {
    echo "PASS: model-selection-history.json has correct schema"
    exit 0
} || {
    echo "FAIL: model-selection-history.json schema check failed"
    exit 1
}
