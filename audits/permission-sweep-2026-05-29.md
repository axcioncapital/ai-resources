# Permission Sweep — 2026-05-29 (dry-run)

**Scan date:** 2026-05-29
**Run type:** dry-run (called from /friday-checkup weekly)
**Workspace:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo
**Files scanned:** 30
**Template:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 2 |
| MEDIUM | 1 |
| ADVISORY | 12 |
| INTENTIONAL-NARROW (excluded) | 1 |
| Parse errors | 0 |

---

## HIGH Findings

### H1 — Rule 6: No Bash(rm *) in allow
**File:** `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (Layer D)
**Evidence:** `allow` contains `"Bash(*)"` and bare tool entries but lacks `"Bash(rm *)"`.
**Fix:** Add `"Bash(rm *)"` to the `allow` array.

### H2 — Rule 9: Stale absolute path in additionalDirectories
**File:** `projects/interpersonal-communication/.claude/settings.json` (Layer D)
**Evidence:** `additionalDirectories` contains `"/Users/danielniklander/Axcion Claude Code/Axcion AI Repo"` — path does not exist (user `danielniklander` not present on this machine).
**Fix:** Replace with `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"`.

---

## MEDIUM Findings

### M1 — Rule 11: Layer A vs Layer B divergence
**Files:** `~/.claude/settings.json` (Layer A) vs workspace root `.claude/settings.json` (Layer B)
**Evidence:** (1) Layer A `deny` lacks `"Bash(git reset --hard *)"` and `"Bash(git checkout *)"` present in Layer B. (2) Layer A `allow` includes broad `"Edit(**)"` and `"Write(**)"` absent from Layer B.
**Action:** Operator review. Layer A is intentionally more permissive (personal machine); divergence is by design. No mechanical fix unless operator wants uniform git guards at user level.

---

## ADVISORY Findings

### A1 — Rule 13: Colon-syntax Bash entries [INTENTIONAL-NARROW]
**File:** `projects/strategic-os/.claude/settings.json` (Layer D)
**Evidence:** `allow` and `deny` use colon-delimited form: `"Bash(git status:*)"`, `"Bash(git reset --hard:*)"`, etc. Preferred form is space-delimited: `"Bash(git status *)"`.
**Remediation hint:** SKIP by default (INTENTIONAL-NARROW file; requires --fix-narrow).

### A2–A11 — Rule 14: Read(archive/**) deny without archive/ in .gitignore
Ten project files have `"Read(archive/**)"` in deny but `archive/` is not listed in their project `.gitignore`. This can cause `git status` noise if an `archive/` directory is created. Rule 14 is hygiene-only — does not cause permission prompts.

| Finding | File | Fix |
|---------|------|-----|
| A2 | projects/axcion-brand-book/.claude/settings.json | Create .gitignore at project root; add `archive/` |
| A3 | projects/nordic-pe-screening-project/.claude/settings.json | Append `archive/` to existing .gitignore |
| A4 | projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json | Append `archive/` to existing .gitignore |
| A5 | projects/repo-documentation/.claude/settings.json | Append `archive/` to existing .gitignore |
| A6 | projects/interpersonal-communication/.claude/settings.json | Append `archive/` to existing .gitignore |
| A7 | projects/axcion-ai-system-owner/.claude/settings.json | Append `archive/` to existing .gitignore |
| A8 | projects/corporate-identity/.claude/settings.json | Append `archive/` to existing .gitignore |
| A9 | projects/project-planning/.claude/settings.json | Append `archive/` to existing .gitignore |
| A10 | projects/obsidian-pe-kb/.claude/settings.json | Append `archive/` to existing .gitignore |
| A11 | projects/buy-side-service-plan/.claude/settings.json | Append `archive/` to existing .gitignore |

**Exempt:** global-macro-analysis (has `archive/` in .gitignore), ai-resources (has `archive/` in .gitignore).

---

## Intentional-narrow (excluded from auto-remediation)

- `projects/strategic-os/.claude/settings.json` — narrow path-scoped allow; paired path-scoped deny on `projects/strategic-os/state/live/**` and `projects/strategic-os/inputs/**`. Rule 6 (no `Bash(*)`) and Rule 5 (no `Bash(rm *)`) technically fire but are excluded from auto-remediation. Findings tagged [INTENTIONAL-NARROW].

---

## Template-class (Rule 8 and Rule 9 silenced)

- `ai-resources/workflows/research-workflow/.claude/settings.json` — both path-class and value-class signals fire (`{{WORKSPACE_ROOT}}` in `additionalDirectories`). Rule 8 and Rule 9 silenced.

---

## Files with no findings

All other files conform to their canonical layer shapes. Layer C (`ai-resources/.claude/settings.json`) and Layer B/B′ are fully compliant. All `settings.local.json` files are untracked by git (Rule 12 clear).

---

**Full working notes:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-05-29.md
**Summary:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-05-29.md.summary.md
