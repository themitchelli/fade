# SKIP: US-004 AC - Sortable view by activity/workload

## Acceptance Criteria
Sortable: By activity (most recent first), by workload (most stories pending)

## Why Not Testable
This acceptance criterion requires:
1. Frontend JavaScript interaction testing
2. DOM element order verification after sort
3. Browser automation

This is a UI interaction test that cannot be verified with shell scripts. It requires browser automation tools.

To manually verify:
1. Start `fade dashboard` with multiple repos
2. Open browser to http://localhost:8080
3. Use sort controls to change repo ordering
4. Verify repos are reordered based on selection
