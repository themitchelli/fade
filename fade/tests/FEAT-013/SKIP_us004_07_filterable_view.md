# SKIP: US-004 AC - Filterable view for blocked/active repos

## Acceptance Criteria
Filterable view: Show only blocked repos, show only active repos

## Why Not Testable
This acceptance criterion requires:
1. Frontend JavaScript interaction testing
2. DOM state verification after filter applied
3. Browser automation

This is a UI interaction test that cannot be verified with shell scripts. It requires browser automation tools like Selenium or Playwright.

To manually verify:
1. Start `fade dashboard` with multiple repos
2. Open browser to http://localhost:8080
3. Use filter controls to show only blocked/active repos
4. Verify card visibility changes appropriately
