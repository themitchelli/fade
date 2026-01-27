# SKIP: US-003 AC - Click repo card for expanded view

## Acceptance Criteria
Click repo card → expanded view with full queue, recent progress entries

## Why Not Testable
This acceptance criterion requires:
1. A running browser or headless browser
2. DOM interaction testing (clicks, UI state changes)
3. JavaScript execution context

Shell-based tests cannot verify interactive UI behavior. This is a frontend interaction test that would require Selenium, Playwright, or similar browser automation tools.

To manually verify:
1. Start `fade dashboard`
2. Open browser to http://localhost:8080
3. Click on a repo card
4. Verify expanded view shows full queue and progress entries
