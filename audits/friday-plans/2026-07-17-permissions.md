# Friday Act Plan — 2026-07-17 — permissions

> # ⚠ SUPERSEDED IN PART — 2026-07-18 (S6-ac5). Do not run as written.
>
> **Read this banner before executing any item.** The plan is not retired wholesale — items 2, 3 and 4
> were **not assessed** on 2026-07-18 and there is no reason to think they are wrong. What follows is
> scoped precisely, because killing valid queued work would be its own defect.
>
> ### 1. This plan is NOT a fix for the `git checkout` block. Do not run it believing it is.
>
> `logs/missions/repo-health-backlog-2026-07.md` thread 4 states that this plan "targets those Read
> patterns and would ship without unblocking git." **That routing is spurious — verified 2026-07-18 by
> reading this plan in full.** It touches neither `Bash(git checkout *)` **nor** the archive `Read()`
> patterns. It is simply not about thread 4. The real blocking rule is `Bash(git checkout *)` at
> `~/.claude/settings.json:47` and workspace-root `.claude/settings.json:27` — proven by execution:
> `git checkout --help`, which reads nothing and names no archive path, is denied.
>
> ### 2. Item 1's ai-resources finding is FALSE — verified, do not act on it.
>
> Item 1 cites *"ai-resources `settings.local.json` Rule 5 (narrow `Bash(...)` grants, no `Bash(*)`)"*.
> Literally true and **operationally meaningless**: the sibling `.claude/settings.json` grants `Bash(*)`,
> and **both** files set `defaultMode: bypassPermissions`. The merged effective permission set already
> allows everything. Verified by direct read of both files, 2026-07-18.
>
> **The other two thirds of item 1 (brand-book Rule 3, ipc/knowledge-base Rule 4) were NOT verified**
> and are **suspect by association, not disproven** — they were produced by the same `/permission-sweep`
> Rules 5/6 defect that generated the false one (each judges a single file's `allow` array without
> evaluating the merged layer stack or `defaultMode`; this is mission thread 5). **Re-verify each against
> the merged effective permissions before acting.** Do not run `/permission-sweep` non-dry to "remediate
> all three in one pass" until that defect is fixed — the sweep is the thing that produced the false HIGH.
>
> ### 3. Items 2, 3, 4 — untouched by this review.
>
> Not assessed on 2026-07-18. The DR-10 concurrency precondition below still applies to them.
>
> *Full verification record: `audits/working/thread-verification-2026-07-18-S6.md` (note: `audits/working/`*
> *is gitignored, so that file is on disk but not in git history).*

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
