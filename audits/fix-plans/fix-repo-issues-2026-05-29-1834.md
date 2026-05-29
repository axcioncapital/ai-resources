# Fix plan — 2026-05-29 18:34

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, workspace, project-ai-development-lab, project-axcion-ai-system-owner, project-nordic-pe-macro-landscape-H1-2026, project-nordic-pe-screening-project, project-repo-documentation
**Scanner notes (per scope):**
- ai-resources: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-ai-resources.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-ai-resources.md)
- workspace: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-workspace.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-workspace.md)
- project-ai-development-lab: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-ai-development-lab.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-ai-development-lab.md)
- project-axcion-ai-system-owner: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-axcion-ai-system-owner.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-axcion-ai-system-owner.md) (zero items)
- project-nordic-pe-macro-landscape-H1-2026: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-nordic-pe-macro-landscape-H1-2026.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-nordic-pe-macro-landscape-H1-2026.md)
- project-nordic-pe-screening-project: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-nordic-pe-screening-project.md)
- project-repo-documentation: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-repo-documentation.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1834-project-repo-documentation.md)
**Plans directory:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/`
**Items:** 3

## Scanner-notes staleness footnote

The ai-resources scanner-notes file (line 77) records that the `/open-items` four-condition tolerance match was "not yet shipped (per id-08 proposal)." That statement is fact-stale — `/qc-pass` confirmed the tolerance match is shipped in commit `e72bca7`, present at `.claude/commands/open-items.md` line 35. Two original Plan-into-batch items (ai-resources/id-07 = wrap-session marker-aware counter; ai-resources/id-08 = open-items tolerance match) were dropped from this plan after QC verified both fixes already landed on 2026-05-29. The scanner-notes file is left as a historical record of the 18:34 run; no edit needed.

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-29-1834.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/working-tree-commit] Commit in-progress improvement-log changes

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** working tree at session start — both files modified, uncommitted:
  - [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md) (new SO observation entry appended at lines 195+)
  - [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log-archive.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log-archive.md) (entry rotation from the active log)
- **Fix:**
  1. From `ai-resources/`, run `git diff -- logs/improvement-log.md logs/improvement-log-archive.md` to inspect the delta.
  2. Confirm the new active-log entry is the SO observation `### 2026-05-29 — Pre-spec consumer-inventory grep checklist (SO advisory, TOCTOU Phase 2+3 rollout)` with `**Status:** logged (pending)`.
  3. Confirm the archive delta is consistent with the standard `check-archive.sh` rotation (older entries moved to archive; no content edits).
  4. Stage and commit in one step (no pre-commit `git status` / `git diff` per workspace `Commit behavior` rule):
     ```
     git add logs/improvement-log.md logs/improvement-log-archive.md
     git commit -m "log: improvement-log — pre-spec consumer-inventory grep checklist (SO advisory) + archive rotation"
     ```
  5. Expected outcome: one new commit in ai-resources; working tree clean for these two files.
- **Post-fix log update:** none (the commit IS the log update)
- **QC needed:** no — log-hygiene-only edit; content was authored prior to this plan and verified by the planning session's `/qc-pass`

### [ai-resources/S4-Item-4] Run backup-session-plan.sh regex smoke-test

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-S4.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-S4.md) Item 4 (verification step that did not run in session S4)
- **Fix:**
  1. Read the hook regex at [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/backup-session-plan.sh](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/backup-session-plan.sh) — confirm the broadened pattern is `(-[a-zA-Z0-9]+){0,2}` (per S4 plan + QC fix).
  2. Set up a tmp test directory:
     ```
     TEST_DIR=$(mktemp -d)
     cd "$TEST_DIR"
     mkdir -p logs/backups
     touch logs/session-plan-S1.md logs/session-plan-S1-pass2.md logs/session-plan-pass3.md
     ```
  3. Copy the hook into the tmp dir and run it against each synthetic input. Use whatever invocation mimics how the SessionEnd hook would receive a file argument; check the script source for the invocation contract.
  4. For each input, confirm the script either matches and backs up (positive case) or skips with an expected reason. Specifically:
     - `session-plan-S1.md` — must match (canonical marker-scoped path)
     - `session-plan-S1-pass2.md` — must match (the BREAK risk the QC fix addressed)
     - `session-plan-pass3.md` — must match (no marker, single suffix)
  5. Record the result in the smoke-test session's `session-notes.md` (under that session's `## YYYY-MM-DD — Session SN` header). Example line: `S4 Item 4 smoke-test: PASS on session-plan-S1.md, session-plan-S1-pass2.md, session-plan-pass3.md — broadened regex covers all three.`
  6. If any input silently skips (regex miss), STOP — do NOT amend the hook in this plan. Surface the failure to the operator; the regex fix is an out-of-plan structural change.
- **Post-fix log update:** none beyond the session-notes line
- **QC needed:** no — read-only verification

### [ai-resources/id-03+04+05+06+09] Run /innovation-sweep on 5 pending-triage entries

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md) — 5 entries at status `pending-triage`:
  - `source-class-mapper/SKILL.md` (3 days)
  - `country-parity-checker/SKILL.md` (3 days)
  - `claim-permission-gate/SKILL.md` (3 days)
  - `run-sufficiency.md` (3 days)
  - `doc-scanner-agent.md` (0 days)
- **Fix:** From `ai-resources/`, invoke `/innovation-sweep`. The command runs its own pipeline (per-entry verdict: graduate / backport / accept-fork / keep-local / already-graduated / loose-end), prompts the operator on any judgment calls, and updates `innovation-registry.md` with final dispositions. No pre-work needed — the registry entries identify themselves.
- **Post-fix log update:** `/innovation-sweep` updates `innovation-registry.md` directly per its own contract; no separate improvement-log status flip needed.
- **QC needed:** no — `/innovation-sweep` manages its own QC inside the pipeline

## Parked items (not this plan)

- [ai-resources/id-01] HIGH — Concurrent-session detection hook (DR-8) — reason: decision-needed
- [ai-resources/id-02] HIGH — Auto-apply /qc-pass fixes (REVISE + wording-level) — reason: needs-dedicated-session
- [ai-resources/id-10] — `/repo-review` command brief (inbox) — reason: needs-/create-skill
- [ai-resources/id-11] — workflow-diagnosis skill brief (inbox) — reason: needs-/create-skill
- [ai-resources/id-12] — `/audit-workflow` command brief (inbox) — reason: needs-/create-skill
- [ai-resources/id-13] — Codex second-opinion auditor brief (inbox) — reason: needs-/create-skill
- [ai-resources/id-14] — Context engine MVP brief (inbox) — reason: needs-/create-skill
- [ai-resources/id-15] — Context engine session-pairing brief (inbox) — reason: needs-/create-skill
- [ai-resources/id-16] — `/cleanup-worktree` ai-resources — reason: needs-dedicated-session
- [ai-resources/id-17] — Extract change-shape classifier to shared reference doc — reason: needs-dedicated-session
- [ai-resources/id-18] — Extract Q1-Q8 placement logic into shared SKILL.md — reason: needs-dedicated-session
- [ai-resources/id-19] — Dedicated `/wrap-session` refactor + permission-sweep follow-ups — reason: needs-dedicated-session
- [ai-resources/id-20] — Build `/clean-folder` workspace-level command — reason: needs-dedicated-session
- [ai-resources/id-21] — `/improve-skill` friday-act dedicated session — reason: needs-dedicated-session
- [ai-resources/id-22] — `/graduate-resource` Step 4+5 strengthening — reason: needs-dedicated-session
- [ai-resources/id-23] — bright-line-review durable enforcement — reason: risk-check-class
- [ai-resources/id-24..43] — 20 T3 watch items (loose-ends, thresholds, late-stage improvement-log entries) — reason: watch
- [workspace/id-01] — QC scope desc "preserve verbatim" auto-loop re-flag (25 days old) — reason: needs-dedicated-session
- [workspace/id-02] — Governor B1 schemas-upfront — reason: needs-dedicated-session
- [workspace/id-03] — strategic-os 10 detected innovation entries — reason: needs-/innovation-sweep (run in strategic-os scope if/when project becomes active again)
- [workspace/id-04..12] — 9 stale Open-Question markers in 2026-05-20 session-notes — reason: needs-dedicated-session (single OQ-hygiene pass; most appear implicitly resolved by later sessions)
- [workspace/id-13] — Cross-project read pattern — reason: watch
- [workspace/id-14, id-15] — workspace-level innovation-registry batches (~46 entries, 18–48d) — reason: needs-/innovation-sweep batch run
- [project-ai-development-lab/id-01] — AMBIGUOUS-REFERENT MISREAD — reason: needs-dedicated-session
- [project-ai-development-lab/id-02] — CONCURRENT-SESSION COMMIT BUNDLING — reason: needs-dedicated-session (TOCTOU class)
- [project-ai-development-lab/id-03] — `/develop-memo` mid-loop collab gap (Option 1 vs 2) — reason: decision-needed
- [project-ai-development-lab/id-04] — Word-cap doc conflict (ref-memo-template ≤700 vs analyze-transcript ≤1500) — reason: decision-needed
- [project-ai-development-lab/id-05] — Gap 2 trade-off (fresh-context QC gate vs lean R&D) — reason: decision-needed
- [project-ai-development-lab/id-06..12] — 7 T3 watch items — reason: watch
- [project-nordic-pe-macro-landscape-H1-2026/id-01..02] — produce-prose-draft + produce-jargon-gloss graduation pending — reason: watch (deferred until next active session)
- [project-nordic-pe-macro-landscape-H1-2026/id-03..08] — 6 logged-pending improvement-log entries — reason: watch
- [project-nordic-pe-screening-project/id-01] — Configure GitHub remote — reason: needs-dedicated-session (external write — GitHub repo creation)
- [project-nordic-pe-screening-project/id-02] — pipeline/decisions.md vs logs/decisions.md canonicity — reason: needs-dedicated-session
- [project-nordic-pe-screening-project/id-03] — W2/W3/W4 README scan — reason: needs-dedicated-session (read pass before opening those phases)
- [project-nordic-pe-screening-project/id-04..06] — 3 watch items (R3.7, R3.3, R2.3 future) — reason: watch
- [project-repo-documentation/id-01] — W2.3 maintenance subagent vs `/friday-checkup` cadence — reason: decision-needed

## Skipped items

- [ai-resources/id-07] — wrap-session.md Step 3.5 marker-aware counter — reason: already-resolved (shipped commit `9f91b2f`; `wrap-session.md` lines 45 + 78–134 implement the marker-aware path)
- [ai-resources/id-08] — `/open-items.md` Step 1 four-condition tolerance match — reason: already-resolved (shipped commit `e72bca7`; `open-items.md` line 35 carries the four-condition match; improvement-log line 184 records `Status: applied 2026-05-29`)
- [ai-resources/S4-Item-3-finish — write SO observation entry] — reason: already-resolved (the entry is already at `improvement-log.md` lines 195+); the residual stage-and-commit work is now Item 1 of the Plan-into-batch
