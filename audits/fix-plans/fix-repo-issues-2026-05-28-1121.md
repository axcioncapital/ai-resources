# Fix plan — 2026-05-28 11:21

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, project axcion-brand-book, project nordic-pe-macro-landscape-H1-2026, project nordic-pe-screening-project
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-05-28-1121-ai-resources.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1121-ai-resources.md)
- project axcion-brand-book: [audits/working/fix-repo-issues-2026-05-28-1121-project-axcion-brand-book.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1121-project-axcion-brand-book.md)
- project nordic-pe-macro-landscape-H1-2026: [audits/working/fix-repo-issues-2026-05-28-1121-project-nordic-pe-macro-landscape-H1-2026.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1121-project-nordic-pe-macro-landscape-H1-2026.md)
- project nordic-pe-screening-project: [audits/working/fix-repo-issues-2026-05-28-1121-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1121-project-nordic-pe-screening-project.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 8

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1121.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-01] Delete or repoint broken symlink `obsidian-pe-kb/.claude/commands/resolve-improvements.md`
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/innovation-registry.md)
- **Fix:**
  1. Run `ls -la /Users/patrik.lindeberg/Claude\ Code/Axcion\ AI\ Repo/projects/obsidian-pe-kb/.claude/commands/resolve-improvements.md` to confirm it is a symlink and identify the broken target.
  2. Determine intent: is `resolve-improvements.md` the same command as canonical `resolve-improvement-log.md`? If yes → repoint to `../../../../ai-resources/.claude/commands/resolve-improvement-log.md` (or matching relative path). If no → `rm` the symlink.
  3. Update the innovation-registry row that flagged this entry — set status to `removed` (deletion path) or `graduated` (repoint path) with a one-line `Notes:` capturing the action.
- **Post-fix log update:** Innovation-registry status update.
- **QC needed:** No — single-file action + log-hygiene flip.

### [ai-resources/id-11+12+13+14+15+18+19+20+21] Innovation-registry status-flip batch (9 rows already canonical)
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/innovation-registry.md)
- **Fix:** For each of the 9 rows below, change the row's status field `triaged:graduate` → `graduated`. Each row has already been verified canonical in ai-resources by the prior triage; this is a status-cleanup pass.
  - `.claude/agents/pipeline-stage-3b.md`
  - `.claude/commands/friday-checkup.md`
  - `.claude/hooks/friday-checkup-reminder.sh`
  - `.claude/commands/session-guide.md`
  - `.claude/commands/summary.md`
  - `workflows/.../produce-knowledge-file.md` (full path from registry row)
  - `workflows/.../run-cluster.md` (full path from registry row)
  - `.claude/commands/innovation-sweep.md`
  - `.claude/agents/innovation-triage-auditor.md`
  Before flipping each row, spot-check the canonical file exists at the path the row claims (one `ls` per row); if a row's canonical path is wrong, surface that row back to the operator instead of flipping silently.
- **Post-fix log update:** Innovation-registry status flips (inline, same edit).
- **QC needed:** No — log-hygiene-only edits.

### [project-nordic-pe-macro-landscape-H1-2026/id-05+06+07+08+09+10] Innovation-registry status-flip batch (6 rows, Graduated To populated)
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/innovation-registry.md)
- **Fix:** For each of the 6 rows below, status field is currently `triaged:graduate` but `Graduated To` is already populated → flip status to `graduated`.
  - `auto-sync-shared.sh`
  - `run-sufficiency.md`
  - `run-analysis.md`
  - `run-synthesis.md`
  - `run-execution.md`
  - `run-cluster.md`
  Spot-check that `Graduated To` is non-empty for each row before flipping; if any row has an empty `Graduated To`, surface back to operator (those are id-03/id-04 which were parked).
- **Post-fix log update:** Innovation-registry status flips (inline, same edit).
- **QC needed:** No — log-hygiene-only edits.

### [project-axcion-brand-book/id-03] Add `Verified: 2026-05-28` line to backfill improvement-log entry
- **Scope:** project axcion-brand-book — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/axcion-brand-book/logs/improvement-log.md) (line 41 area — entry titled "Backfill _appendix/rejected_directions.md from prior /scope-module runs")
- **Fix:**
  1. Locate the entry — its Status line reads `applied 2026-05-28 — 9 00_foundation + 10 02_color decision-foreclosing rejections inserted...`.
  2. Per canonical schema in `ai-resources/.claude/commands/resolve-improvement-log.md`, add a `**Verified:** 2026-05-28` line directly below the `**Status:** applied 2026-05-28 — ...` line, before any `**Implementation note:**` block if present.
  3. Verification check: open `projects/axcion-brand-book/output/_appendix/rejected_directions.md` and confirm it contains the 9+10 rejections referenced. If the file is missing or empty, do NOT add the Verified line — surface the gap to the operator.
- **Post-fix log update:** This IS the log update.
- **QC needed:** No — single-line log-hygiene edit.

### [project-axcion-brand-book/id-04] Resolve broken brand-book git remote
- **Scope:** project axcion-brand-book — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/session-notes.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/axcion-brand-book/logs/session-notes.md) (recurring Open Question 2026-05-25 → 2026-05-28; ~line 810)
- **Fix:**
  1. Run `git -C projects/axcion-brand-book remote -v` to confirm the current configured remote URL (expected: `https://github.com/axcioncapital/axcion-brand-book/` returning 404).
  2. Ask the operator inline: "Should this project stay local-only, or do you have a correct remote URL?"
  3. Apply: either `git -C projects/axcion-brand-book remote remove origin` (local-only path; **default if operator absent**) or `git -C projects/axcion-brand-book remote set-url origin <correct URL>` (remote path; verify with `git fetch` after).
  4. Append a new entry to `projects/axcion-brand-book/logs/improvement-log.md` capturing the choice, with `Status: applied 2026-05-28` and `Verified: 2026-05-28`.
- **Post-fix log update:** New improvement-log entry per step 4.
- **QC needed:** No — config action + new log entry.

### [project-nordic-pe-macro-landscape-H1-2026/id-01] Verify 2026-05-22 HIGH `/session-plan` fix reached project-local copy
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md) (line 72 — 2026-05-22 HIGH entry, applied unverified)
- **Fix:**
  1. Locate the 2026-05-22 HIGH improvement-log entry. Read its `**Fix:**` description to identify exactly what `/session-plan` change was supposed to land.
  2. Diff `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md` against `ai-resources/.claude/commands/session-plan.md`:
     ```
     diff -u projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md ai-resources/.claude/commands/session-plan.md
     ```
     If the project-local file is a symlink to ai-resources, the diff is empty by construction → fix is present, add Verified line and stop.
     If the project-local file is a real file (copy) and diverges, the documented fix may not be present — read the project-local file in the relevant region and confirm whether the fix is there.
  3. If the project copy is stale: replace with the ai-resources version (or repoint as symlink), then verify the fix is present.
  4. Add `**Verified:** 2026-05-28` line below the existing `**Status:** applied ...` line per canonical schema.
- **Post-fix log update:** Verified line on the improvement-log entry.
- **QC needed:** No — diff/verify + log-hygiene line. (If step 3 actually replaces the project copy, that becomes a file edit and the execution session should consider whether to run `/qc-pass` on the swap.)

### [project-axcion-brand-book/id-02] `/session-plan` MISMATCH false-positive — add session-already-wrapped short-circuit
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (fix lives here even though the friction was logged from the brand-book project)
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/friction-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/axcion-brand-book/logs/friction-log.md) (Session 2026-05-26 19:56 — 4th recurrence) — proposed remediation captured in `projects/axcion-brand-book/logs/usage-log.md` ("add 'session already wrapped' short-circuit")
- **Fix:**
  1. Read `ai-resources/.claude/commands/session-plan.md` Step 0 (the concurrent-session intent-comparison logic). Locate the MISMATCH branch that auto-routes the plan to `session-plan-pass2.md` instead of overwriting `session-plan.md`.
  2. Identify a reliable own-session marker that distinguishes "this is the same session that wrote the existing session-plan.md" from "this is a concurrent foreign session." Candidates: `logs/.prime-mtime` marker written by `/prime` Steps 8a/8b/8c; a fresh-session sentinel written by `/session-start` Step 0.5; or mtime comparison between `session-notes.md` today-header and the existing `session-plan.md`. Pick the marker whose semantics best match "same-session" vs "concurrent-session."
  3. Add a short-circuit BEFORE the MISMATCH-route decision: if the marker indicates same-session, treat the existing `session-plan.md` as this session's own prior plan and route to the normal `## Existing plan — keep / overwrite / pass-2` 3-option gate (or the equivalent already-defined flow), NOT to silent pass2 auto-routing. The current MISMATCH branch fires the silent-auto-pass2 path; the new same-session branch must bypass that.
  4. Verify by re-running a fresh `/session-plan` invocation in a project where a same-day `session-plan.md` already exists from an earlier session in the same terminal — confirm no `session-plan-pass2.md` is created when intent strings differ but the session marker shows own-session.
  5. If no reliable own-session marker exists today, the fix becomes either (a) define one (add a write step to `/session-start` or `/prime`), or (b) document the limitation and add an interactive prompt to the MISMATCH branch instead of silent auto-routing. Surface this discovery to the operator before picking (a) vs (b).
  6. Flip the friction-log entry to verified (`[FADING-GATE] verified 2026-05-28` annotation under the 2026-05-26 19:56 session line) and write a new improvement-log entry in `ai-resources/logs/improvement-log.md` with `Status: applied 2026-05-28` and `Verified: 2026-05-28`.
- **Post-fix log update:** Friction-log verified annotation + new improvement-log entry.
- **QC needed:** Yes — `/qc-pass` on the edited `session-plan.md` before commit. Independent verification matters because the short-circuit changes concurrent-session-collision behavior, which the wrap-session guard and pass2 backup machinery depend on.

### [project-axcion-brand-book/id-06] `settings.json` deny blocks `/draft-module` mid-run
- **Scope:** project axcion-brand-book — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/axcion-brand-book/logs/improvement-log.md) (line 33 area — 2026-05-27 entry, Status: logged)
- **Fix:**
  1. Read `projects/axcion-brand-book/.claude/settings.json` and identify the deny pattern(s) that block `/draft-module`'s write paths. Cross-reference against the improvement-log narrative for the specific file path or tool name that triggered the block.
  2. Read `ai-resources/.claude/commands/draft-module.md` (or equivalent) to confirm which file paths `/draft-module` writes to.
  3. Pick a path:
     - **(a) Preferred — narrow scope.** Edit `projects/axcion-brand-book/.claude/settings.json`: relax or remove the specific deny pattern that conflicts with `/draft-module`'s write paths. Keep all other deny patterns intact. Re-confirm against `ai-resources/docs/permission-template.md` to ensure the edit does not violate canonical permission-template shape.
     - **(b) Fallback — document workaround.** If editing settings.json risks breaking other guardrails, append a short note to `projects/axcion-brand-book/CLAUDE.md` describing the in-session permission-cache limitation and the operator workaround (e.g., restart Claude Code session before `/draft-module`). Do NOT edit settings.json in this path.
  4. Default to (a) unless the deny pattern is structurally protecting something else; if uncertain, surface the deny pattern to the operator before applying.
  5. Flip the improvement-log entry from `Status: logged` to `Status: applied 2026-05-28` + add `Verified: 2026-05-28` line (per canonical schema). If path (b) was chosen, the Verified semantic is "documented" rather than "fix applied" — write `Verified: 2026-05-28 — documented workaround in CLAUDE.md (settings.json untouched)`.
- **Post-fix log update:** improvement-log Status flip + Verified line.
- **QC needed:** Yes if path (a) — `/qc-pass` on the settings.json edit against `docs/permission-template.md`. No if path (b) — CLAUDE.md addition is documentation-only.

## Parked items (not this plan)

- [ai-resources/id-02] pending-triage: skills/source-class-mapper/SKILL.md — reason: `needs-/innovation-sweep`
- [ai-resources/id-03] pending-triage: skills/country-parity-checker/SKILL.md — reason: `needs-/innovation-sweep`
- [ai-resources/id-04] pending-triage: skills/claim-permission-gate/SKILL.md — reason: `needs-/innovation-sweep`
- [ai-resources/id-05] pending-triage: workflows/research-workflow/.../run-sufficiency.md — reason: `needs-/innovation-sweep`
- [ai-resources/id-06] friction-log 2026-05-28 TOCTOU concurrent-session races (3 instances) — reason: `multi-file-refactor` (superseded by broader proposal in id-35)
- [ai-resources/id-07] inbox: /repo-review command brief — reason: `needs-/create-skill`
- [ai-resources/id-08] inbox: Codex second-opinion auditor brief — reason: `needs-/create-skill`
- [ai-resources/id-09] inbox: workflow-diagnosis skill brief — reason: `needs-/create-skill`
- [ai-resources/id-10] inbox: audit-workflow-pipeline command + skill triplet brief — reason: `needs-/create-skill`
- [ai-resources/id-16] T2 watch: .claude/commands/audit-critical-resources.md (graduate pending) — reason: `needs-/graduate-resource` — **DROPPED 2026-05-29**: command deleted (subsumed by `/pipeline-review`); graduation moot.
- [ai-resources/id-17] T2 watch: .claude/agents/critical-resource-auditor.md (graduate pending) — reason: `needs-/graduate-resource` — **DROPPED 2026-05-29**: agent deleted (replaced by `pipeline-review-auditor`); graduation moot.
- [ai-resources/id-22] T2 hygiene: nordic settings.json#SessionStart-upward-walk → permission-template — reason: `needs-dedicated-session`
- [ai-resources/id-23] T2 hygiene: repo-doc settings.json#SessionStart-upward-walk → permission-template — reason: `needs-dedicated-session`
- [ai-resources/id-24] T2 hygiene: interpersonal-comm settings.json#deny-archive → permission-template — reason: `needs-dedicated-session`
- [ai-resources/id-25] T2 hygiene: nordic settings.json#UserPromptSubmit-decision-log → ai-resources — reason: `needs-dedicated-session`
- [ai-resources/id-26] T2 hygiene: nordic settings.json#Stop-checkpoint-nag → ai-resources workflows — reason: `needs-dedicated-session`
- [ai-resources/id-27] T2 hygiene: nordic settings.json#PostToolUse-5hook-taxonomy → permission-template — reason: `needs-dedicated-session`
- [ai-resources/id-28] T2 hygiene: interpersonal-comm CLAUDE.md#Compaction → compaction-protocol.md — reason: `needs-dedicated-session`
- [ai-resources/id-29] Coaching carry-forward: "Name the bright-line before you review it" — reason: `needs-dedicated-session`
- [ai-resources/id-30] Gate-calibration follow-up: bright-line-review behavioral enforcement — reason: `needs-dedicated-session`
- [ai-resources/id-31] T3 graduate-candidate: .claude/commands/resolve-improvement-log.md — reason: `not-yet-actionable` (operator decides timing)
- [ai-resources/id-32] workflow-diagnosis / improvement-analyst boundary doc — reason: `not-yet-actionable` (pending skill build)
- [ai-resources/id-33] Pattern to watch: operator-caught review-class gaps (below threshold) — reason: `not-yet-actionable`
- [ai-resources/id-34] Extract shared rendering convention doc (DR-7 deferred) — reason: `not-yet-actionable`
- [ai-resources/id-35] Concurrent sessions TOCTOU races — broader structural per-session-marker proposal — reason: `not-yet-actionable` (logged pending — also informs id-02 fix in this plan)
- [ai-resources/id-36] wrap-session Step 3.5 foreign-guard prior-day misfire — reason: `not-yet-actionable`
- [ai-resources/id-37] /prime does not surface per-unit work/Wn-README.md files — reason: `not-yet-actionable`
- [ai-resources/id-38] /session-start Step 0.5 mtime guard — superseded by id-35 — reason: `not-yet-actionable`
- [ai-resources/id-39] T3 loose-end: interpersonal-comm today-drill.md rotation mechanic — reason: `not-yet-actionable`
- [ai-resources/id-40] T3 loose-end: nordic CLAUDE.md#Autonomy-Rules workflow-execution schema — reason: `not-yet-actionable`
- [ai-resources/id-41] T3 loose-end: nordic settings.json#auto-commit-hook (conflicts with workspace Commit Rules) — reason: `not-yet-actionable`
- [ai-resources/id-42] T3 loose-end: obsidian-pe-kb settings.json#model-field (violates no-model rule) — reason: `not-yet-actionable`
- [ai-resources/id-43] T3 loose-end: repo-doc friction-log-trigger.sh generalizable — reason: `not-yet-actionable`
- [ai-resources/id-44] T3 loose-end: repo-doc CLAUDE.md#Compaction scratchpad-before-/compact pattern — reason: `not-yet-actionable`
- [project-axcion-brand-book/id-01] Edit stale-read race (LOW severity in body) — reason: `low-signal`
- [project-axcion-brand-book/id-05] 03_typography §9 [OPEN] visual review flags (items 2/3/7) — reason: `decision-needed` (operator visual review required)
- [project-nordic-pe-macro-landscape-H1-2026/id-02] Chapter 07 review prose-inline fix (already a logged improvement-log proposal) — reason: `multi-file-refactor`
- [project-nordic-pe-macro-landscape-H1-2026/id-03] triaged:graduate produce-prose-draft.md — Graduated To empty — reason: `needs-/graduate-resource`
- [project-nordic-pe-macro-landscape-H1-2026/id-04] triaged:graduate produce-jargon-gloss.md — Graduated To empty — reason: `needs-/graduate-resource`
- [project-nordic-pe-macro-landscape-H1-2026/id-11] Open Q: WU4a parallel-terminal state — confirm FX-B1 not yet executed — reason: `decision-needed`
- [project-nordic-pe-macro-landscape-H1-2026/id-12] Open Q: mandate alignment vs actual work — re-invoke /session-start on pivot? — reason: `decision-needed`
- [project-nordic-pe-macro-landscape-H1-2026/id-13] Coaching One Thing: close session-plan verification gap — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-14] RECURRING: chapter-review presentation rule at wrong layer — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-15] backup-session-plan.sh does not back up pass2 alternate targets — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-16] settings.json allow-list has redundant Bash(rm *) entry — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-17] /prime Step 8b free-text-intent skips /session-start+/session-plan chain — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-18] /prime Step 8b annotation — non-determinism vs deterministic failure — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-19] /prime Step 1a git-log cross-check misses dual-repo Cluster A closure — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-20] Template-level contract doc for FX-C1 wiring (required-reference-files.md) — reason: `not-yet-actionable`
- [project-nordic-pe-macro-landscape-H1-2026/id-21] risk-topology.md missing row for workflow-template CLAUDE.md class — reason: `not-yet-actionable`
- [project-nordic-pe-screening-project/id-01] No GitHub remote configured — reason: `decision-needed` (operator: configure or stay local-only?)
- [project-nordic-pe-screening-project/id-02] Verify W1–W4 READMEs vs "Layer 2 child cycle" rubric — reason: `decision-needed`

## Skipped items

(none)
