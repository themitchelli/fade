# SKIP: US-006 AC - Charts for stories and session duration

## Acceptance Criteria
Chart: Stories completed per day (simple ASCII bar chart or sparkline)
Chart: Session duration over time (identify trends)

## Why Not Testable
This acceptance criterion requires:
1. Frontend JavaScript visualization testing
2. Canvas/SVG rendering verification
3. Browser automation

Charts are visual elements that cannot be tested with shell scripts. They require browser automation or screenshot comparison testing.

To manually verify:
1. Start `fade dashboard` with session history
2. Open browser to http://localhost:8080
3. Navigate to analytics section
4. Verify charts render with meaningful data
