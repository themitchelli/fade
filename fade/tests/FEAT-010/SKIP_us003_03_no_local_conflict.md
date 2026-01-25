# Skipped: US-003 AC-03 - Global install doesn't conflict with local installs

**Acceptance Criterion:** "Global install doesn't conflict with local installs"

**Reason:** Testing install conflicts requires actually installing the package both globally and locally in a project, then verifying npm's resolution behavior. This is environment-dependent and would modify the system state.

**Alternative:** Manual verification:
1. Install globally: `npm install -g fade-dev`
2. In a project, install locally: `npm install fade-dev`
3. Verify that local `npx fade` uses local version
4. Verify that direct `fade` command uses global version
