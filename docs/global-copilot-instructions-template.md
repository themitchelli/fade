# Global Copilot Instructions — Template

This file is a template. To install it, copy it to:
  `~/.copilot/copilot-instructions.md`   (macOS / Linux)
  `C:\Users\<you>\.copilot\copilot-instructions.md`  (Windows)

It will load automatically for every Copilot CLI session across all repos.
Per-repo `.github/copilot-instructions.md` files provide project-specific context
and override these where needed.

---

# Global Coding Standards

## Before You Start
1. Read `.github/copilot-instructions.md` for project context, strategic direction,
   and constraints. This shapes every decision — don't skip it.
2. Read `AGENTS.md` if present — it contains execution protocol for this repo.
3. Read the Issue or spec for the task. Understand acceptance criteria before
   writing a line of code.
4. For complex work (multiple files, architectural decisions), use `/plan` first.

## Spec-First Rule
Never implement a feature without written acceptance criteria. If none exist,
stop and ask. The cost of building the wrong thing always exceeds the cost of
writing a spec first.

## Git
- Conventional commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`, `spike:`
- Imperative mood, lowercase after colon, under 72 chars: `feat: add rate limiting`
- Never force-push to `main` or `master`
- Never commit secrets, `.env` files, credentials, or build artefacts
- One logical change per commit — not a big bang at the end

## Testing
- Structure every test as Arrange / Act / Assert
- Test behaviour and outcomes, not implementation details
- Mock at boundaries (HTTP calls, databases, filesystem) — not internal functions
- If a criterion can't be tested automatically, say so explicitly with a reason
- 70% unit tests, 20% integration, 10% E2E

## Code Quality
- Functions: single responsibility, 20–30 lines target
- Names reveal intent — no abbreviations (`customer` not `cust`), no generics
  (`data`, `temp`, `stuff`, `info`)
- Boolean names as questions: `isActive`, `hasPermission`, `canEdit`
- Error handling: explicit, meaningful messages, never swallow errors silently
- Comments explain *why* the code exists, not *what* it does

## When Stuck or Blocked
- Say clearly what's blocking and what input or decision is needed
- Don't invent requirements or make up behaviour to keep moving
- Partial coherent work with a clear note beats silent wrong work
- For ambiguous requirements: ask one focused question, don't bundle multiple

## Raising Pull Requests
- Use `/delegate` to raise a PR from the current session
- Always work on a branch — never commit directly to `main` in protected repos
- Commit and checkpoint before delegating
