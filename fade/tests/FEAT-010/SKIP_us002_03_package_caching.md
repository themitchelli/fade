# Skipped: US-002 AC-03 - First run downloads package, subsequent runs use cache

**Acceptance Criterion:** "First run downloads package, subsequent runs use cache"

**Reason:** This test requires npm/npx caching behavior verification which depends on npm's internal cache mechanism. Cannot be verified through shell scripts without network access and npm registry interaction.

**Alternative:** Manual verification by:
1. Clear npm cache: `npm cache clean --force`
2. Run `npx fade-dev version` (observe download)
3. Run again (should be instant from cache)
