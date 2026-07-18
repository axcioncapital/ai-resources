# Friday Act Plan — 2026-07-17 — permissions

**Source report:** friday-checkup-2026-07-17.md (weekly tier, recovery run)
**Journal report:** (none — freshest is 2026-05-29, outside the 7-day window)
**Generated:** 2026-07-17
**Items:** 4

> **Cluster 3 (System Owner triage). Real risk, but concurrency-gated.**
> Three of these (items 1, 3, and the deferred 34-item ADVISORY hygiene batch) largely resolve in a
> **single `/permission-sweep` run (no `--dry-run`)**. Items 2 and 4 are targeted settings edits.

> **⚠ EXECUTION PRECONDITION (DR-10 — concurrent session).** All four items edit `settings.json` /
> `settings.local.json` across layers (workspace root, project, ai-resources) — shared, non-append,
> lost-update surfaces. A live foreign session marker was present in the main checkout at plan time
> (`LIVE_FOREIGN_HERE=1`). **Do not execute until the concurrent session has cleared.** Re-check at
> execution; run `/concurrent-session-check` if unsure.

## Items

### 1. [high] Fix the 3 CRITICAL permission gaps — run `/permission-sweep` (no `--dry-run`)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (permission surface, multiple layers)
- **W2.4 auto-draft:** no
- Detail: brand-book `settings.json` Rule 3 (scoped Edit/Write globs, no `Edit/Write(**/.claude/**)` companion); ipc/knowledge-base `settings.json` Rule 4 (missing bare `MultiEdit`); ai-resources `settings.local.json` Rule 5 (narrow `Bash(...)` grants, no `Bash(*)`; also Rule 6 no `Bash(rm *)`). One `/permission-sweep` remediates all three in one approved pass. Report: `audits/permission-sweep-2026-07-17.md`.

### 2. [high] Remove the 6 stale worktree-path `Bash` entries (workspace-root `settings.local.json`, Rule 9)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- Detail: 6 `Bash(...)` allow entries hardcode two agent-worktree dirs that no longer exist. Safe to remove. Confirm the two paths are gone from the filesystem before removing (they were named in the checkup).

### 3. [med] Create `settings.local.json` with additionalDirectories grant (brand-book + website, Rule 8)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- Detail: adds the additionalDirectories grant so those two projects stop prompting. Folds into the same `/permission-sweep` run as item 1.

### 4. [med] Decide the user-vs-workspace confidentiality deny divergence (Rule 11)
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (resolution edits a deny list)
- **W2.4 auto-draft:** no
- Detail: `Read(**/*deal-*)` and similar confidentiality denies diverge between the user-level and workspace settings. Decide the intended posture (which layer owns confidentiality denies; whether they should match), then align. Grounds the fix in `docs/permission-template.md § confidentiality`.

## Execution notes
- Commit each settings change separately (workspace commit-behavior rules).
- **Precondition above is BLOCKING** — settings files are shared, non-append; confirm the concurrent session cleared first.
- **Every item is a `/risk-check` change class (settings.json).** Run `/risk-check` before executing — one pass can cover the batched `/permission-sweep` scope; items 2 and 4 may need their own framing.
- Never add a `"model"` field to any settings.json (workspace Model-Tier prohibition) while in these files.
- Run `/wrap-session` when all items in this plan are done.
