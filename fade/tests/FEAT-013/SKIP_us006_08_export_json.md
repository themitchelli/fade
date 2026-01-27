# SKIP: US-006 AC - Export aggregate stats as JSON

## Acceptance Criteria
Export button: Download aggregate stats as JSON for external analysis

## Why Not Testable
This acceptance criterion requires:
1. Frontend button click testing
2. File download verification
3. Browser automation

The /api/aggregate endpoint provides JSON data (tested separately), but the actual download button functionality is a frontend concern.

To manually verify:
1. Start `fade dashboard`
2. Open browser to http://localhost:8080
3. Click export button in analytics section
4. Verify JSON file downloads with aggregate stats
