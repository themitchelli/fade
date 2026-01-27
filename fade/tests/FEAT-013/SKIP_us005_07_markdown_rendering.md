# SKIP: US-005 AC - Markdown files rendered with syntax highlighting and formatting

## Acceptance Criteria
Markdown files rendered with syntax highlighting and formatting

## Why Not Testable
This acceptance criterion requires:
1. Frontend JavaScript/CSS verification
2. DOM structure analysis for rendered markdown
3. Browser automation to verify visual rendering

Shell tests cannot verify visual rendering. This is a frontend test requiring browser automation.

To manually verify:
1. Start `fade dashboard`
2. Open browser to http://localhost:8080
3. Click on a repo, then "Docs" tab
4. Click on a markdown file
5. Verify formatting (headers, code blocks, links) renders correctly
