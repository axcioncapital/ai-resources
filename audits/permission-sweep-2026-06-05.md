# Permission Sweep — Full Notes (DRY-RUN)

**Scan date:** 2026-06-05
**Workspace:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo
**Mode:** DRY-RUN — diagnostic only, no changes applied
**Files scanned:** 31
**Template used:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md

---

## Standing Operator Decisions (not flagged as findings)

- No `"model"` field in any settings.json — deliberate, per workspace CLAUDE.md Model Tier rule.
- `bypassPermissions` is the agreed working mode / floor — deny-list additions and /plan or /auto suggestions are excluded from recommendations.

---

## Files Scanned

| Path | Layer | Status |
|------|-------|--------|
| `~/.claude/settings.json` | A | ok |
| `.claude/settings.json` (workspace root) | B | ok |
| `.claude/settings.local.json` (workspace root) | B′ | ok |
| `ai-resources/.claude/settings.json` | C | ok |
| `ai-resources/.claude/settings.local.json` | C-local | CRITICAL |
| `ai-resources/workflows/research-workflow/.claude/settings.json` | template | intentional-template (silenced R8/R9) |
| `projects/ai-development-lab/.claude/settings.json` | D | advisory |
| `projects/axcion-ai-system-owner/.claude/settings.json` | D | advisory |
| `projects/axcion-ai-system-owner/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/axcion-brand-book/.claude/settings.json` | D | advisory |
| `projects/buy-side-service-plan/.claude/settings.json` | D | advisory |
| `projects/buy-side-service-plan/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/corporate-identity/.claude/settings.json` | D | advisory |
| `projects/corporate-identity/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/global-macro-analysis/.claude/settings.json` | D | advisory |
| `projects/global-macro-analysis/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/interpersonal-communication/.claude/settings.json` | D | advisory |
| `projects/interpersonal-communication/.claude/settings.local.json` | D′ | ok (hooks only, no permissions block) |
| `projects/marketing-positioning/.claude/settings.json` | D | advisory |
| `projects/nordic-pe-screening-project/.claude/settings.json` | D | advisory |
| `projects/nordic-pe-screening-project/.claude/settings.local.json` | D′ | ok (env only, no permissions block) |
| `projects/obsidian-pe-kb/.claude/settings.json` | D | advisory |
| `projects/obsidian-pe-kb/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/project-planning/.claude/settings.json` | D | advisory |
| `projects/project-planning/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/repo-documentation/.claude/settings.json` | D | advisory |
| `projects/repo-documentation/.claude/settings.local.json` | D′ | ok (empty) |
| `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json` | D | advisory |
| `projects/strategic-os/.claude/settings.json` | D | intentional-narrow |
| `projects/strategic-os/.claude/settings.local.json` | D′ | ok (empty) |

---

## Intentional-Narrow Files (excluded from auto-remediation)

### `projects/strategic-os/.claude/settings.json`

Detection: allow list contains only path-scoped entries (e.g., `Write(projects/strategic-os/state/sandbox/**)`, `Edit(projects/strategic-os/responses/**)`) with no bare `Edit`/`Write`. Deny list contains paired path-scoped denies (`Write(projects/strategic-os/state/live/**)`, `Edit(projects/strategic-os/state/live/**)`). Both heuristic conditions satisfied.

All findings on this file are tagged `[INTENTIONAL-NARROW]`. Remediation: SKIP by default; requires --fix-narrow to apply.

Findings on this file:
- Rule 4 (CRITICAL): No bare `Edit`/`Write` entries — intentional by narrow-permission design.
- Rule 5 (CRITICAL): No bare `Bash(*)` — the allow list has only narrow Bash commands.
- Rule 6 (HIGH): No `Bash(rm *)` in allow.
- Rule 8 (HIGH — ADVISORY per template note): `additionalDirectories` in tracked settings.json — same ADVISORY note as all Layer D files.

---

## Intentional-Template Files (R8/R9 silenced)

### `ai-resources/workflows/research-workflow/.claude/settings.json`

Both signals fire:
- Path-class signal: path matches `**/workflows/*/.claude/settings.json`.
- Value-class signal: `"additionalDirectories": ["{{WORKSPACE_ROOT}}"]` — `{{WORKSPACE_ROOT}}` matches `{{[A-Z_]+}}`.

Rule 8 and Rule 9 are **silenced** for this file. No finding emitted at any severity.

---

## Findings — CRITICAL

### Finding C-1 — Rule 1: `settings.local.json` missing `defaultMode`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json`
- **Layer:** C-local (Layer C's local file)
- **Evidence:** The file declares a `permissions` block with `allow` entries but has NO `defaultMode` field:
  ```json
  {
    "permissions": {
      "allow": [
        "Bash(git add *)",
        "Bash(git commit -m ' *)",
        "Bash(mkdir -p audits/risk-checks)",
        "Bash(ls .claude/agents/risk-check-reviewer.md)",
        "Bash(ls audits/risk-checks/2026-06-01-wrap-session-feedback-collector*.md)"
      ]
    }
  }
  ```
- **Canonical value:** `"defaultMode": "bypassPermissions"` must be present in any `permissions` block in a `settings.local.json` (root cause #1 — local file wholly shadows sibling `settings.json`'s `defaultMode`).
- **Impact:** When a session opens inside `ai-resources/`, the local file's `permissions` block shadows `ai-resources/.claude/settings.json`. Without `defaultMode`, the harness reverts to its default restrictive mode. All Edit/Write/Bash operations outside the five narrow allow entries will prompt.
- **Proposed fix (plain English):** Add `"defaultMode": "bypassPermissions"` to the `permissions` block of `ai-resources/.claude/settings.local.json`.
- **Remediation hint:** apply-by-default.

### Finding C-2 — Rule 4/5: `settings.local.json` allow list — bare tools and Bash(*) missing

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json`
- **Layer:** C-local
- **Evidence:** The allow list contains only five narrow Bash patterns. No bare `Edit`, `Write`, `MultiEdit`, `Read`, `Bash(*)` entries.
- **Canonical value:** Layer B′/C-local canonical shape: `"allow": ["Edit", "Write", "MultiEdit", "Bash(*)"]`. The local file should re-declare these or rely solely on the `defaultMode` grant without a `permissions.allow` block.
- **Impact:** Even if `defaultMode` is added, the restrictive allow list may still constrain operations to only the five listed Bash patterns in some harness versions.
- **Proposed fix (plain English):** Either (a) remove the `permissions.allow` list entirely and keep only `defaultMode: bypassPermissions` (cleanest — parent settings.json provides the full allow list), or (b) add `"Edit"`, `"Write"`, `"MultiEdit"`, `"Bash(*)"` to the allow list alongside the narrow entries.
- **Remediation hint:** apply-by-default. Option (a) is recommended — the narrow bash entries appear to be temporary scaffolding from a specific session and have no ongoing value.

---

## Findings — HIGH

No HIGH findings. (All `additionalDirectories` in tracked project settings.json files are classified as ADVISORY per the template's updated Layer D′ note — see ADVISORY section.)

---

## Findings — MEDIUM

No MEDIUM findings triggered by Rules 10–11 across scanned files.

---

## Findings — ADVISORY

### Finding A-1 — Rule 13: Workspace-root `settings.local.json` missing `MultiEdit` in allow

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.local.json`
- **Layer:** B′
- **Evidence:** `"allow": ["Edit", "Write", "Bash(*)"]` — `MultiEdit` absent.
- **Canonical value:** `"allow": ["Edit", "Write", "MultiEdit", "Bash(*)"]`
- **Proposed fix (plain English):** Add `"MultiEdit"` to the allow list.
- **Remediation hint:** apply-by-default. Low impact (MultiEdit is covered by the parent settings.json's bare `MultiEdit` entry, and by Layer A's broad grant), but brings the file into canonical form.

### Finding A-2 — Rule 8 (ADVISORY per template Layer D′ note): Tracked `additionalDirectories` in project settings.json files

Per the template's Layer D note (updated 2026-06-03): a tracked `settings.json` that carries `additionalDirectories` with a machine-specific absolute path is an ADVISORY finding — relocate to `settings.local.json`. The tracked path is correct on this machine but breaks on other operator machines pulling the same repo.

The following 13 project `settings.json` files carry `"additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` in their tracked (git-committed) settings:

1. **File:** `projects/ai-development-lab/.claude/settings.json` — Layer D
2. **File:** `projects/axcion-ai-system-owner/.claude/settings.json` — Layer D
3. **File:** `projects/axcion-brand-book/.claude/settings.json` — Layer D
4. **File:** `projects/buy-side-service-plan/.claude/settings.json` — Layer D
5. **File:** `projects/corporate-identity/.claude/settings.json` — Layer D
6. **File:** `projects/global-macro-analysis/.claude/settings.json` — Layer D
7. **File:** `projects/interpersonal-communication/.claude/settings.json` — Layer D
8. **File:** `projects/marketing-positioning/.claude/settings.json` — Layer D
9. **File:** `projects/nordic-pe-screening-project/.claude/settings.json` — Layer D
10. **File:** `projects/obsidian-pe-kb/.claude/settings.json` — Layer D
11. **File:** `projects/project-planning/.claude/settings.json` — Layer D
12. **File:** `projects/repo-documentation/.claude/settings.json` — Layer D
13. **File:** `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json` — Layer D

- **Evidence (representative):** `"additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` in tracked settings.json.
- **Canonical value:** `additionalDirectories` belongs in the gitignored `settings.local.json` (Layer D′). The tracked `settings.json` should not carry it.
- **Canonical local form:**
  ```json
  { "permissions": { "defaultMode": "bypassPermissions", "additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"] } }
  ```
- **Proposed fix (plain English):** For each project: (1) remove `additionalDirectories` from the tracked `settings.json`; (2) create (or update) the project's `settings.local.json` with the canonical D′ form above. Each of the 13 projects already has a `settings.local.json` — most are empty `{}` and can simply receive the D′ content.
- **Note:** `/new-project` still writes `additionalDirectories` into the tracked file (known pending alignment item per template § Layer D′). These 13 files are products of that deployment pattern. The template acknowledges this and classifies it as ADVISORY.
- **Remediation hint:** apply-by-default (low urgency — single-operator workspace, so cross-machine breakage is not currently a live risk; remediate in a batch pass).

### Finding A-3 — Rule 13: Layer A deny list carries Layer B extras

- **File:** `~/.claude/settings.json`
- **Layer:** A
- **Evidence:** `"deny"` includes `"Bash(git reset --hard *)"` and `"Bash(git checkout *)"`. Layer A canonical deny is `["Bash(rm -rf *)", "Bash(sudo *)"]` only. The two git entries are Layer B safeguards.
- **Canonical value:** Layer A deny: `["Bash(rm -rf *)", "Bash(sudo *)"]`
- **Proposed fix (plain English):** These entries in Layer A are harmless — they add safety at the broadest layer. This is an informational divergence, not a prompt-causing failure. No action required unless the operator wants strict layer separation.
- **Remediation hint:** operator review — the entries add safety and cause no prompts; removing them would narrow the safety floor at Layer A.

### Finding A-4 — Rule 13: Layer C `settings.json` has two overlapping archive-log deny patterns

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json`
- **Layer:** C
- **Evidence:** Deny list contains both `"Read(logs/*-archive-*.md)"` (line 29) and `"Read(logs/*archive*.md)"` (line 33). The second pattern subsumes the first.
- **Canonical value:** Single pattern is sufficient; the more general `Read(logs/*archive*.md)` covers all cases the hyphenated form covers.
- **Proposed fix (plain English):** Remove `"Read(logs/*-archive-*.md)"` from the deny list, keeping only `"Read(logs/*archive*.md)"`.
- **Remediation hint:** apply-by-default (hygiene only — no prompt impact).

### Finding A-5 — Rule 13: Layer B′ workspace `settings.local.json` syntax inconsistency (Bash colon vs space)

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json`
- **Layer:** C-local
- **Evidence:** Allow entries use `Bash(git add *)` form (space separator). The template notes `Bash(foo *)` is preferred over `Bash(foo:*)`. The narrow git entries use the preferred form, but this is flagged because the local file is otherwise noted under CRITICAL — this advisory is superseded by C-1/C-2 fix.
- **Remediation hint:** superseded by C-1/C-2 remediation.

### Finding A-6 — Rule 8 (ADVISORY): `[INTENTIONAL-NARROW]` `projects/strategic-os/.claude/settings.json` — tracked `additionalDirectories`

- **File:** `projects/strategic-os/.claude/settings.json`
- **Layer:** D (intentional-narrow)
- **Evidence:** `"additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` in tracked settings.json.
- **Remediation hint:** SKIP by default (intentional-narrow file); requires --fix-narrow to apply. Same ADVISORY as Finding A-2 when addressed.

---

## Layer-by-Layer Verdicts

| Layer | File | Verdict | Reason |
|-------|------|---------|--------|
| A | `~/.claude/settings.json` | PASS | All critical rules satisfied; two advisory items (deny extras, no structural impact) |
| B | `.claude/settings.json` (workspace root) | PASS | Canonical shape matched |
| B′ | `.claude/settings.local.json` (workspace root) | PASS | defaultMode present; missing MultiEdit (ADVISORY only) |
| C | `ai-resources/.claude/settings.json` | PASS | Canonical shape matched; one duplicate deny pattern (ADVISORY) |
| C-local | `ai-resources/.claude/settings.local.json` | FAIL | Missing defaultMode — shadows parent bypass (CRITICAL) |
| template | `ai-resources/workflows/research-workflow/.claude/settings.json` | PASS | Intentional-template; R8/R9 silenced |
| D | 13 project settings.json files | DRIFT | Tracked additionalDirectories (ADVISORY per template note) |
| D | `projects/strategic-os/.claude/settings.json` | INTENTIONAL-NARROW | Narrow grants by design |
| D′ | All project settings.local.json files | PASS | No permissions block (empty or env/hooks only); parent bypass unaffected |

---

## Parse Errors

None. All 31 files parsed cleanly.

---

## Summary of Findings by Severity

| Severity | Count |
|----------|-------|
| CRITICAL | 2 (C-1 and C-2 on same file — ai-resources/.claude/settings.local.json) |
| HIGH | 0 |
| MEDIUM | 0 |
| ADVISORY | 5 (A-1 through A-5; A-6 is narrow-tagged duplicate of A-2) |
| INTENTIONAL-NARROW | 1 file (strategic-os) |
| INTENTIONAL-TEMPLATE | 1 file (research-workflow, R8/R9 silenced) |
