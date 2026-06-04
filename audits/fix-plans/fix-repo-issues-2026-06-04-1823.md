# Fix plan — 2026-06-04 18:23

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, marketing-positioning, nordic-pe-screening-project, research-pe-regime-shift-advisory-gap
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-06-04-1823-ai-resources.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-04-1823-ai-resources.md)
- marketing-positioning: [audits/working/fix-repo-issues-2026-06-04-1823-project-marketing-positioning.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-04-1823-project-marketing-positioning.md)
- nordic-pe-screening-project: [audits/working/fix-repo-issues-2026-06-04-1823-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-04-1823-project-nordic-pe-screening-project.md)
- research-pe-regime-shift-advisory-gap: [audits/working/fix-repo-issues-2026-06-04-1823-project-research-pe-regime-shift-advisory-gap.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-04-1823-project-research-pe-regime-shift-advisory-gap.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 3

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix. All three items in this plan apply in the `ai-resources` scope.

Instruct fresh-session Claude:

> Execute the fix plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-06-04-1823.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Items 1 and 2 edit canonical pipeline commands (`/prime`, `/wrap-session`) — run `/qc-pass` after each, and expect a possible structural `/risk-check` gate before landing (command-logic change class). Item 3 is a log-hygiene-only edit (no QC).

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-01] /prime Step 1a git cross-check misses sibling project repos
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md):96 — logged duplicate at [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md):268
- **Fix:** In `ai-resources/.claude/commands/prime.md`, Step 1a's git cross-check currently runs `git log --since=<entry-date>` against only `$CWD_REPO` and `$AI_RESOURCES`, then keyword-matches Next Steps bullets against the merged result. The gap (caught in S4): a Next Step written in one project session can be resolved by a commit that landed in a *different* project repo, and the two-repo scan misses it — surfacing a likely-DONE item as still-open in the menu. Extend the cross-check so the merged result set also includes commits from the active project repos under `projects/*/` (enumerate them the same way `/fix-repo-issues` Step 1 does), not just cwd + ai-resources. Keep the existing fall-through behavior on git failure (treat bullets as still-open). Bound the scan to active/selected projects to avoid scanning every repo on every `/prime`.
- **Post-fix log update:** Flip `improvement-log.md:268` (the `/prime` Step 1a sibling-repo gap entry) to `**Status:** applied 2026-06-04` + `**Verified:**` per the resolve-improvement-log schema. Annotate the friction-log:96 entry as resolved.
- **QC needed:** yes — run `/qc-pass` after applying (canonical command-logic change; expect a possible `/risk-check` gate).

### [ai-resources/id-14] /wrap-session Step 3.5 REMNANT false-positive on date rollover
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md):242
- **Fix:** In `ai-resources/.claude/commands/wrap-session.md` Step 3.5, the marker-remnant guard compares the session's own marker against the *current calendar date*. When a session starts before midnight and wraps after midnight, the own-marker has gone "stale" relative to the new calendar day, so the guard fires a REMNANT false-alarm on a marker that is legitimately this session's own. Apply the one-line fix described in the S6 usage-analysis: instead of comparing the marker against today's calendar date, either (a) compare the own-marker against the recent git log to confirm it is genuinely this session's, or (b) add a grace window (e.g., treat a marker dated "yesterday" as own when the session is still active) so overnight sessions do not misfire. Pick whichever is the smaller, lower-risk edit to the existing Step 3.5 logic.
- **Post-fix log update:** Flip `improvement-log.md:242` to `**Status:** applied 2026-06-04` + `**Verified:**`.
- **QC needed:** yes — run `/qc-pass` after applying (command-logic change to a canonical pipeline).

### [ai-resources/id-29] innovation-registry stale row — resolve-improvement-log already graduated
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md):67
- **Fix:** The innovation-registry row at line 67 marks `resolve-improvement-log.md` as `triaged:graduate-candidate (operator decides timing)`, age 44 days. S5 ground-truth-verified that `resolve-improvement-log` is already canonical in `ai-resources/.claude/commands/` and symlink-distributed to projects (the strategic-os slot-1 records were corrected to CONFIRMED-DONE in commit `44258aa`). The registry row is therefore stale. Update line 67's status from `triaged:graduate-candidate` to already-graduated / done, mirroring the S5 correction, so the row stops re-surfacing as a pending graduation in future `/fix-repo-issues` and `/innovation-sweep` runs.
- **Post-fix log update:** The edit IS the log update (innovation-registry status flip). No separate improvement-log entry.
- **QC needed:** no — log-hygiene-only edit.

## Parked items (not this plan)

- [ai-resources/id-06] Build brief: /audit-workflow — 5-pass workflow audit pipeline + 3 net-new skills — reason: needs-/create-skill
- [ai-resources/id-07] Build brief: workflow-diagnosis skill — artifact-defect → workflow-fix spec — reason: needs-/create-skill
- [ai-resources/id-08] Build brief: /repo-review command — operational health assessment — reason: needs-/create-skill
- [ai-resources/id-09] Build brief: /codex-dd — Codex CLI as independent second-opinion auditor — reason: needs-/create-skill
- [ai-resources/id-02] doc-scanner-agent graduation (E1) — reason: needs-dedicated-session (heavy graduate pipeline)
- [ai-resources/id-03] UserPromptSubmit-decision-log graduation — reason: needs-/graduate-resource
- [ai-resources/id-04] Stop-checkpoint-nag graduation — reason: needs-/graduate-resource
- [ai-resources/id-05] bright-line-review durable-enforcement flagged for separate gated item — reason: risk-check-class
- [ai-resources/id-12] /fix-symlinks blind to regular-file-where-symlink-expected drift class — reason: needs-dedicated-session (new detection-class design)
- [ai-resources/id-13] §8 grounding-absence self-resolved; SO agent ran ungrounded — reason: needs-dedicated-session
- [ai-resources/id-15] improve.md / improvement-analyst archive de-dup hits Read deny rule — reason: risk-check-class (permission edit)
- [ai-resources/id-16] Pre-spec consumer-inventory grep checklist (SO advisory) — reason: needs-dedicated-session
- [ai-resources/id-17] /risk-check 5-dimension shape misses design-internal principle drift — reason: needs-dedicated-session
- [ai-resources/id-18] extract change-shape classifier to shared reference — reason: multi-file-refactor
- [ai-resources/id-19] B-04 deferred companion: extract S-04 from execution-manifest-creator — reason: multi-file-refactor
- [ai-resources/id-20] placement-verifier four-pipeline extension — reason: needs-dedicated-session
- [ai-resources/id-21] Extract Q1–Q8 placement logic into shared SKILL.md — reason: multi-file-refactor
- [ai-resources/id-22] Architecture-gap report loop (SO advisory, monthly cadence) — reason: needs-dedicated-session
- [ai-resources/id-23] Track /placement skip-rate in gate-calibration (quarterly) — reason: needs-dedicated-session
- [ai-resources/id-24] Tighten Placement Discipline trigger to constraint-on-Write checklist — reason: needs-dedicated-session
- [ai-resources/id-25] /pm forward-looking handling: re-evaluate after 3 paste cycles — reason: decision-needed (threshold not met)
- [ai-resources/id-26] investigate sub-subagent dispatch (Task-from-agent) limitation — reason: needs-dedicated-session
- [ai-resources/id-27] /pm internal QC step: data-gated review after 3 invocations — reason: decision-needed (threshold not met)
- [ai-resources/id-28] Extract shared rendering convention doc (DR-7 second consumer) — reason: multi-file-refactor
- [ai-resources/id-30] innovation loose-end: today-drill.md rotation mechanic generalizable — reason: decision-needed
- [ai-resources/id-31] innovation loose-end: nordic-pe CLAUDE.md Autonomy-Rules schema — reason: decision-needed
- [ai-resources/id-32] innovation loose-end: nordic-pe auto-commit hook (conflicts Commit Rules) — reason: decision-needed
- [ai-resources/id-33] innovation loose-end: obsidian-pe-kb settings.json model-field (violates no-model rule) — reason: decision-needed
- [ai-resources/id-34] innovation loose-end: repo-documentation friction-log-trigger.sh — reason: decision-needed
- [project-marketing-positioning/id-01] Intra-day session-numbering collision — reason: needs-dedicated-session (project command-sync investigation)
- [project-marketing-positioning/id-02] Auto-mode mandate/plan ceremony skipped at /prime "1 auto" — reason: needs-dedicated-session (project command-sync investigation)
- [project-marketing-positioning/id-03] Warmth-ceiling Checkpoint A decision (W1.1 P6) — reason: decision-needed (editorial)
- [project-marketing-positioning/id-04] GitHub remote 404 — create or keep local — reason: decision-needed
- [project-marketing-positioning/id-05] positioning.md reconciliation — operator go pending (cross-project write) — reason: decision-needed
- [project-marketing-positioning/id-06] Statement opener wording — reason: decision-needed (editorial)
- [project-marketing-positioning/id-07] Gate-reopener scope confirmation — reason: decision-needed
- [project-marketing-positioning/id-08] Uncommitted expert-check files left untracked — reason: needs-dedicated-session (part of the known workspace-wide git-hygiene batch)
- [project-marketing-positioning/id-09] Concurrent-session staged shared session-notes — misattribution — reason: watch (below threshold)
- [project-marketing-positioning/id-10] Nested KB vault orphaned from parent knowledge-bases repo tracking — reason: needs-dedicated-session
- [project-marketing-positioning/id-11] Heavy side-build on non-blocking day — build-then-validate ordering — reason: watch (below threshold)
- [project-nordic-pe-screening-project/id-01] pipeline/decisions.md vs logs/decisions.md canonicity — reason: decision-needed
- [project-nordic-pe-screening-project/id-02] W2/W3/W4 README scan not yet done — reason: needs-dedicated-session (precedes opening those phases)
- [project-nordic-pe-screening-project/id-03..05] remaining session-notes carryovers — reason: decision-needed / needs-dedicated-session

## Skipped items

- [ai-resources] 7 friction-log entries — reason: already-resolved ([FADING-GATE] verified)
- [ai-resources] 1 friction-log entry — reason: already-resolved ([STUB — discarded 2026-05-27])
- [ai-resources] 4 improvement-log entries — reason: already-resolved (Status applied + Verified)
- [project-marketing-positioning] 3 innovation-registry rows (kb-query, kb-update, kb-integrity) — reason: low-signal (triaged:project-specific, per contract skip list)
