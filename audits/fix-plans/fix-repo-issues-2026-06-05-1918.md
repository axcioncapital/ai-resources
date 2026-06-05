# Fix plan — 2026-06-05 19:18

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, workspace, project axcion-ai-system-owner, project marketing-positioning, project project-planning, project repo-documentation, project research-pe-regime-shift-advisory-gap
**Scanner notes (per scope):**
- ai-resources: [fix-repo-issues-2026-06-05-1918-ai-resources.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-ai-resources.md)
- workspace: [fix-repo-issues-2026-06-05-1918-workspace.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-workspace.md)
- project axcion-ai-system-owner: [fix-repo-issues-2026-06-05-1918-project-axcion-ai-system-owner.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-project-axcion-ai-system-owner.md)
- project marketing-positioning: [fix-repo-issues-2026-06-05-1918-project-marketing-positioning.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-project-marketing-positioning.md)
- project project-planning: [fix-repo-issues-2026-06-05-1918-project-project-planning.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-project-project-planning.md)
- project repo-documentation: [fix-repo-issues-2026-06-05-1918-project-repo-documentation.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-project-repo-documentation.md)
- project research-pe-regime-shift-advisory-gap: [fix-repo-issues-2026-06-05-1918-project-research-pe-regime-shift-advisory-gap.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-05-1918-project-research-pe-regime-shift-advisory-gap.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 4

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `audits/fix-plans/fix-repo-issues-2026-06-05-1918.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-11+id-12+id-13] Add `**Verified:**` field to 3 applied improvement-log entries

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md)
- **Fix:** Locate the three improvement-log entries that are `Status: applied` but missing a `**Verified:**` field:
  1. The entry for id-14 (pre-append integrity guard, applied S13 via commit `2bc89d9`) — add `**Verified:** 2026-06-05 — confirmed via commit 2bc89d9 (batch: shared-log write-path integrity S13) + S13 session QC observations`
  2. The entry for id-15 (concurrent shared-dir advisory-scan extension to non-append logs, applied S13 via commit `2bc89d9`) — add `**Verified:** 2026-06-05 — confirmed via commit 2bc89d9 (batch: shared-log write-path integrity S13) + S13 session QC observations`
  3. The diagnostics-lag resolution entry (applied via commit `23c9143`) — add `**Verified:** 2026-06-05 — confirmed via commit 23c9143 (new: backlog-reconciliation primitive) + S14 session verification`
  The `**Verified:**` line should be placed immediately after the `**Status:** applied` line in each entry. Read the improvement-log schema from `resolve-improvement-log.md` before editing to confirm exact placement.
- **Post-fix log update:** These entries are the log update — no further status flip needed. After editing, run `/resolve-improvement-log` to confirm the 3 entries now qualify for archival (they should, once **Verified:** is present).
- **QC needed:** no — log-hygiene-only edit; no command behaviour changes.

---

### [ai-resources/id-05] Fix wrap-session Step 3.5 false-positive on same-session chained tasks

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md) *(Session 2026-05-28 10:05 entry)*
- **Fix:** In `ai-resources/.claude/commands/wrap-session.md` Step 3.5, the FOREIGN-count logic counts all same-day marker-bearing headers that are not this session's own marker. When auto-mode runs multiple chained tasks in a single prime session, each task appends its own work-description line under the session's marker header — but the guard is counting additional marker-bearing headers from concurrent sessions as FOREIGN. The fix: update the FOREIGN computation to read this session's own MARKER from `logs/.session-marker` (or the per-session-id marker file) before the header-count pass, and exclude headers with `## YYYY-MM-DD — Session {MARKER}` (where MARKER matches the current session's marker) from the FOREIGN count. This ensures that chained tasks within the same session are never misidentified as foreign writes.
  Apply the same edit to the workspace-root mirror at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/wrap-session.md` (the paired sibling — confirm it exists and has the same Step 3.5 logic before editing).
- **Post-fix log update:** Add `[FADING-GATE] verified 2026-06-05` annotation to the friction-log entry for this item (Session 2026-05-28 10:05). Flip the corresponding improvement-log entry status to `applied YYYY-MM-DD` if one exists (search improvement-log for "chained tasks" or "id-05").
- **QC needed:** yes — run `/qc-pass` on the edited wrap-session.md after applying; scope: confirm the FOREIGN-count change doesn't affect legitimate concurrent-session detection.

---

### [project-marketing-positioning/id-02] Fix prime Step 7 parser for `N auto` / `auto N` disambiguation

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` *(fix is in ai-resources prime.md, triggered by marketing-positioning friction)*
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/logs/friction-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/logs/friction-log.md) *(Session 2026-06-04 entry)*
- **Fix:** In `ai-resources/.claude/commands/prime.md` Step 7, add explicit handling for the `N auto` input shape (a bare number followed by the word "auto", e.g. `1 auto`). Currently this is parsed as a bare-number selection (item 1), which silently skips auto-mode and the mandate/plan ceremony. The fix: add a new classifier branch before the bare-number check — if the trimmed input matches `^[1-6]\s+auto$` (number then whitespace then "auto"), re-classify it as `auto N` and route to Step 8c with the corresponding item number. Add a brief inline comment noting that `N auto` and `auto N` are treated identically.
- **Post-fix log update:** Add `[FADING-GATE] verified 2026-06-05` annotation to the friction-log entry in the marketing-positioning scope. No improvement-log flip needed (friction-log only for this item).
- **QC needed:** yes — run `/qc-pass` on the edited prime.md; scope: confirm the new branch doesn't shadow any existing valid classifier paths.

---

### [project-research-pe-regime-shift-advisory-gap/id-09 → fix in ai-resources] Add marker-trio to `/clarify` preamble

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` *(fix is in ai-resources /clarify skill, triggered by research-pe friction)*
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md) *(markerless session entry, 2026-06-05)*
- **Fix:** Locate the `/clarify` skill — check both `ai-resources/skills/clarify/SKILL.md` and `ai-resources/.claude/commands/clarify.md` (one or both may exist). In the skill's preamble (before any work is done), add a step that ensures a session marker exists:
  1. Read `logs/.session-marker` (relative to CWD). If it exists and contains today's date prefix, this session already has a marker — skip.
  2. If absent or stale (different date), run the marker-trio initialization from prime.md Step 8a.3.a: write `logs/.session-marker`, write the per-session-id file `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, and append a `## YYYY-MM-DD — Session S{N}` header to `logs/session-notes.md`.
  3. After ensuring the marker exists, write `logs/.prime-mtime` (same as prime Step 8a.3.a — for wrap-session's Step 0.5 check).
  This prevents a session started via `/clarify` (without prior `/prime`) from writing markerless entries to session-notes.md.
- **Post-fix log update:** Add `[FADING-GATE] verified 2026-06-05` annotation to the friction-log entry in the research-pe scope. Log a note in `ai-resources/logs/improvement-log.md` if a corresponding deferred entry exists there.
- **QC needed:** yes — run `/qc-pass` on the edited clarify.md / SKILL.md; scope: confirm the marker initialization doesn't double-create markers when /clarify is called after /prime has already run.

---

## Parked items (not this plan)

- [ai-resources/id-01,02,03,04] Inbox briefs: /repo-review, /codex-dd, workflow-diagnosis, audit-workflow — reason: `needs /create-skill`
- [ai-resources/id-06] Wrap-session Step 3.5 chained-tasks Phase 2 (separate from id-05) — reason: `parked to id-31 Phase 2 in source`
- [ai-resources/id-10] Consumer-inventory under-count on structural rename (3rd recurrence) — reason: `needs-dedicated-session`
- [ai-resources/id-14] innovation-registry backup-session-plan.sh pending-triage — reason: `needs /innovation-sweep`
- [ai-resources/id-15,16] innovation-registry re-parked items (UserPromptSubmit-decision-log, Stop-checkpoint-nag) — reason: `needs /graduate-resource`
- [ai-resources/id-17–41] Watch/deferred improvement-log + innovation-registry items — reason: `low-roi` or `threshold-not-met`
- [workspace/id-01] QC auto-loop overrun — "verbatim purity" misapplied to Tier-3 fixes (32d) — reason: `needs-dedicated-session`
- [workspace/id-02] Governor B1: QC loop schema-conformance errors caught late (15d) — reason: `needs-dedicated-session`
- [workspace/id-03] W1 strategic-os /promote-to-live Bash heredoc verification — reason: `needs-dedicated-session`
- [workspace/id-04,05] Cross-project read pattern (watch) + 70 untriaged innovation-registry entries — reason: `threshold-not-met` / `needs /innovation-sweep`
- [project-marketing-positioning/id-01] Session-numbering collision (project-level, operational) — reason: `low-roi`
- [project-marketing-positioning/id-03] No working GitHub remote for marketing-positioning — reason: `decision-needed` (operator)
- [project-marketing-positioning/id-04] Warmth-ceiling Checkpoint A (P6 decision) — reason: `decision-needed`
- [project-marketing-positioning/id-05] positioning.md reconciliation pending operator go — reason: `decision-needed`
- [project-marketing-positioning/id-06,07] Statement opener + gate-reopener scope — reason: `decision-needed`
- [project-marketing-positioning/id-08] Uncommitted side-build files in working tree — reason: `decision-needed` (verify if still present)
- [project-marketing-positioning/id-09,10,11] Improvement-log watch items — reason: `low-roi` / `threshold-not-met`
- [project-project-planning/id-01–07] Pipeline-without-session-start + stale OQs — reason: `low-roi` or `decision-needed`
- [project-repo-documentation/id-01] W2.3 maintenance subagent vs /friday-checkup cadence-step OQ — reason: `decision-needed`
- [research-pe/id-05] 1M-context credit gate re-fires (S5 subagent model-pin fix insufficient) — reason: `needs-dedicated-session`
- [research-pe/id-06,07,08] innovation-registry pending-triage ≤7d entries — reason: `needs /innovation-sweep`
- [research-pe/id-11–20] T3 improvement-log watch items — reason: `low-roi` / `threshold-not-met`

## Skipped items

- [ai-resources/id-07] /prime Step 1a sibling-repo extension — reason: `already-resolved (commit 23c9143)`
- [ai-resources/id-08] /prime Step 8c done-condition gate — reason: `already-resolved (commit 1d91723)`
- [ai-resources/id-09] concurrent shared-dir advisory-scan extension to non-append logs — reason: `already-resolved (commits 2bc89d9 + a3f1a0b)`
- [research-pe/id-01] UTF-8 corruption on raw-report intake — reason: `already-resolved (commit b6be86f)`
- [research-pe/id-02] /run-analysis Step 2.5 PAUSE bypassed — reason: `already-resolved (commit 2add1f2)`
- [research-pe/id-03] session-plan cross-day filename collision — reason: `already-resolved (commits fa2b3f2 + b32d611)`
- [research-pe/id-04] citation-converter misclassified auto-commit hook commits — reason: `already-resolved (commit 1021bfe F7)`
- [research-pe/id-10] concurrent sessions on same checkout (shared-log interleave + git index collision) — reason: `already-resolved (commits 93abf16 + 2e52b22)`
