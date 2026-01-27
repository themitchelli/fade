# SKIP: US-004 AC - Click PRD name to view JSON

## Acceptance Criteria
Click PRD name → view PRD JSON (syntax highlighted)

## Why Not Testable
This acceptance criterion requires:
1. Frontend JavaScript interaction testing
2. Modal dialog verification
3. Syntax highlighting verification
4. Browser automation

This is a UI interaction test that cannot be verified with shell scripts.

To manually verify:
1. Start `fade dashboard`
2. Open browser to http://localhost:8080
3. Click on a PRD name in the queue
4. Verify modal shows syntax-highlighted JSON
