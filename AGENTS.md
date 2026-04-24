# FADE — Agent Execution Protocol

You are working on the FADE repository. This file tells you how to work here.
Read `.github/copilot-instructions.md` for project context and strategic direction.
Read `FADE.md` for the full architecture, standards, and fragile areas.

---

## Session Start

1. Read `.github/copilot-instructions.md` — strategic context, roadmap, hard rules
2. Read `FADE.md` — full architecture, standards table, fragile areas
3. Read `LEARNINGS.md` — discoveries from previous sessions
4. Read `fade/progress.md` — what has been completed (last 20 entries are enough)
5. Find the active work item (see **Work Discovery** below)

---

## Work Discovery

When asked to implement a feature without a specific issue or PRD:

**Priority order:**
1. `fade/prd.json` — priority injection (urgent/critical work), if it exists
2. `fade/prds/*.json` — standard queue, lowest-numbered file with `"passes": false` stories
3. GitHub Issues labelled `spec` — for work created via the issue template

**Within a PRD:** pick the highest-priority story where `"passes": false`.

**PRD format:** each file has `userStories[]`, each story has `id`, `title`,
`acceptanceCriteria[]`, and `passes: true|false`.

---

## Execution Rules

- **One story at a time.** Complete it fully before moving on.
- **Read relevant standards** in `fade/standards/` before starting (see table in FADE.md).
- **Run `bash -n bin/fade-cli`** before every commit — no exceptions.
- **For complex stories**, use `/plan` first, then implement. Don't skip planning
  under time pressure.
- **Respect fragile areas** listed in `.github/copilot-instructions.md`.
- **Small commits** — one logical change per commit, not a big bang at the end.

---

## Story Completion — Do These in Order

### 1. Verify acceptance criteria pass
Check each AC from the PRD. Don't mark done until all pass.

### 2. Run syntax check
```bash
bash -n bin/fade-cli
```

### 3. Update `fade/progress.md`
Append:
```
## YYYY-MM-DD - US-XXX: Story Title - COMPLETE

- What was implemented
- Files changed: [list]
- Tests: passed/added
```

### 4. Update `LEARNINGS.md` (if applicable)
Add only reusable, non-obvious discoveries. Skip if nothing new was learned.
```
## YYYY-MM-DD - Discovery Title
- **What:** Brief description
- **Why it matters:** How this helps future work
- **Files:** Which modules this applies to
```

### 5. Mark `passes: true` in the PRD
Edit the original file in `fade/prds/`. Re-read it to confirm the change persisted.
Never create a copy. Never write to `fade/prd-archive/` directly.

### 6. Commit
```bash
git add -A && git commit -m "feat: complete US-XXX - Story Title"
```
Use the right prefix: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`.

---

## When Blocked

If you cannot proceed:
1. Document what's blocking in `fade/progress.md` as a BLOCKED entry
2. Commit the documentation if the partial state is coherent
3. Explain clearly: what's blocking, what input or decision is needed

Don't invent requirements to keep moving. Partial coherent work with a clear
note is better than silent wrong work.

---

## Test Generation

When all stories in a PRD are complete, generate regression tests in `fade/tests/`:
```
fade/tests/{PRD-ID}/test_{us_id}_{ac_num}_{slug}.sh
```
Tests must be shell scripts (no external deps), exit 0 on pass, non-zero on fail.
If an AC can't be automated, create `SKIP_{us_id}_{ac_num}_{slug}.md` explaining why.

---

## Raising a PR

Use `/delegate` to create a pull request. Before delegating:
- Ensure you are on a feature branch, not `main`
- All stories are committed and syntax-checked
- `fade/progress.md` is up to date

Branch naming: `feature/FEAT-XXX-slug` or `fix/BUG-XXX-slug`

---

## Spike Work

If a PRD has `"type": "spike"`:
1. Create a branch: `git checkout -b spike/{branchName}`
2. All work stays on the spike branch
3. Produce the `outputArtifact` described in the PRD
4. Do NOT merge to `main`
