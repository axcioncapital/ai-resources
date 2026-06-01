# Fix plan — 2026-06-01 19:17

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, project nordic-pe-screening-project
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-06-01-1917-ai-resources.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-01-1917-ai-resources.md)
- project nordic-pe-screening-project: [audits/working/fix-repo-issues-2026-06-01-1917-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-01-1917-project-nordic-pe-screening-project.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 4

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `ai-resources/audits/fix-plans/fix-repo-issues-2026-06-01-1917.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-01] Port wrap-session Steps 6.4 + 6.5 into the workspace-root copy
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md)
- **Fix:** The canonical ai-resources `.claude/commands/wrap-session.md` now has Step 6.4 (session outcome check — completion + execution-quality grading) and Step 6.5 (session feedback collector). The non-symlink workspace-root copy at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` lacks both. Read BOTH files first, identify the structural divergence between them (this mirror was deliberately deferred because the two are not byte-identical), then port Steps 6.4 + 6.5 into the workspace-root copy, **adapting** to its existing step numbering, preflight-toggle structure, and staging/cost-budget lines — do not blind-paste. Confirm the workspace-root file's preflight toggle list and Step 4 schema lines are updated consistently with the new steps.
- **Post-fix log update:** Flip the corresponding improvement-log entry ("Workspace-root wrap-session lacks Step 6.4 + 6.5") to `**Status:** applied 2026-06-01` + add a `**Verified:**` line after confirming the workspace-root file parses.
- **QC needed:** yes — run /qc-pass after applying (cross-file consistency between canonical and workspace-root copies is the main risk).

### [ai-resources/id-02] Re-scope /resolve-improvement-log Step 7b away from the denied archive path
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md)
- **Fix:** `/resolve-improvement-log` Step 7b reads an archive path that the repo `settings.json` deny rule blocks — when the command runs, the read is denied and the step fails silently or prompts. Adapt the COMMAND to the permission policy (do NOT loosen the settings deny rule): read `.claude/commands/resolve-improvement-log.md` Step 7b, identify the archive read it performs, and re-scope it so it no longer reads the denied path (e.g., write-append to the archive without reading it back, or derive the needed state from the live log rather than the archive). Verify against the deny rule in `.claude/settings.json` (and `.claude/settings.local.json` if present).
- **Post-fix log update:** Flip the improvement-log entry ("/resolve-improvement-log Step 7b conflicts with archive read-deny") to `**Status:** applied 2026-06-01` + `**Verified:**` line.
- **QC needed:** yes — run /qc-pass (confirm the re-scoped step still achieves its original archival purpose without reading the denied path).

### [project-nordic-pe-screening-project/id-03] Add timberland / natural-resource real-assets to the G4 disqualifier criteria
- **Scope:** project nordic-pe-screening-project — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md) (2026-06-01, "Finding C")
- **Fix:** The G4 asset-class disqualifier criteria names real estate, infrastructure, and credit but not timberland / natural-resource / farmland real-assets — a batch-5 fund (GreenGold) was excluded correctly only via the out-of-scope-mandate route, not the criteria text. Locate the criteria document holding G4 (likely the current screening-criteria version file, e.g. `v4.3` — find it before editing), and add timberland / natural-resource / farmland to the G4 asset-class disqualifier naming so this exclusion surfaces directly. Per Working Principles, if this is a versioned criteria file, create the next version file rather than overwriting in place.
- **Post-fix log update:** none (project content edit; record in the project's `logs/decisions.md` per project convention if the criteria file is versioned).
- **QC needed:** yes — run /qc-pass (confirm the addition is consistent with the existing G4 disqualifier wording and does not over-broaden the exclusion).

### [project-nordic-pe-screening-project/id-04] Reconcile pipeline/decisions.md vs logs/decisions.md canonicity
- **Scope:** project nordic-pe-screening-project — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md) (carried open since 2026-05-28)
- **Fix:** Two decision logs coexist: `pipeline/decisions.md` and `logs/decisions.md`. The session convention has consistently written to `logs/decisions.md` across Sessions B–S4, so treat `logs/decisions.md` as canonical. Read both files; migrate any entries that exist ONLY in `pipeline/decisions.md` into `logs/decisions.md` (preserving date order), then replace `pipeline/decisions.md` content with a one-line pointer to `logs/decisions.md` (do not delete the file outright — leave the pointer so existing references resolve). If `pipeline/decisions.md` turns out to be empty or a duplicate subset, just add the pointer.
- **Post-fix log update:** Record the reconciliation in `logs/decisions.md` itself (a row noting pipeline/decisions.md retired in favor of logs/decisions.md).
- **QC needed:** yes — run /qc-pass (confirm no unique decision entries were dropped in the migration).

## Parked items (not this plan)

- [project-nordic-pe-screening-project/id-04(scanner)] No working GitHub remote — push fails — reason: decision-needed. **Blocks Prime task #1** (archiving nordic requires a clean pushed tree). Operator must create the remote or decide nordic stays local-only.
- [ai-resources/id-39(scanner)] /wrap-session Step 3.5 marker guard false-negatives — reason: needs-dedicated-session (Option 2′ spec ready at `audits/option2-marker-redesign-2026-06-01.md`; atomic 9-consumer commit).
- [ai-resources/id-04..07(scanner)] 4 pending-triage skills/commands (source-class-mapper, country-parity-checker, claim-permission-gate, run-sufficiency) — reason: needs-/innovation-sweep.
- [ai-resources/id-01,02,03,08(scanner)] 4 inbox command briefs (/repo-review, codex second-opinion auditor, workflow-diagnosis, /audit-workflow) — reason: needs-/create-skill.
- [ai-resources/id-09,10,15(scanner)] graduate-candidates (settings decision-log, Stop-checkpoint-nag, doc-scanner-agent) — reason: needs-/graduate-resource.
- [ai-resources/id-20(scanner)] obsidian-pe-kb settings#model-field violates no-model-in-settings rule — reason: out-of-selected-scope (obsidian-pe-kb not selected this run; genuine hard-rule violation — surface for a future fix run).
- [ai-resources/id-37(scanner)] (NOTE: planned as id-02 above — not parked.)
- [ai-resources/id-38(scanner)] /risk-check add Dimension 6 (design-internal principle drift) — reason: decision-needed (design change to a core gating command).
- [ai-resources/id-11(scanner)] gate-calibration durable CLAUDE.md enforcement — reason: decision-needed (deferred to separate gated item).
- [ai-resources/id-16..19,21,22(scanner)] innovation-registry triaged loose-ends — reason: operator-decides / needs-/innovation-sweep.
- [ai-resources/id-24..36(scanner)] DR-7 placement-extraction items, /pm data-gated reviews, boundary docs — reason: multi-file-refactor / threshold-gated / data-gated.
- [project-nordic-pe-screening-project/id-02(scanner)] W2/W3/W4 README pre-read — reason: future-session action (read before those phases open; not a fixable item).
- [project-nordic-pe-screening-project/id-03(scanner)] Pre-S5 operator decisions (record naming, carry-forward, batch size) — reason: decision-needed.

## Skipped items

- [ai-resources/id-14(scanner)] Context Engine Phase 1 eval "pending" — reason: already-resolved (S2 wrap recorded eval PASS + promote).
- [ai-resources/id-12,13(scanner)] Historical concurrent-session overlap / marker-overwrite questions — reason: low-signal (stale 3-day investigation; id-13 superseded by Option 2′ spec).
- [project-nordic-pe-screening-project/id-06(scanner)] Session S5 in-flight — reason: low-signal (status note only, no action).
