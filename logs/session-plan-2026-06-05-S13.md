# Session Plan — 2026-06-05 S13

## Intent
Land two System-Owner-flagged structural fixes for shared-log write-path integrity: id-14 (pre-append guard) + id-15 (advisory-scan extension).

**RESCOPE (post risk-check, 2026-06-05 S13):** Risk-check returned RECONSIDER. id-16 (classifier extraction) DROPPED — verified already done 2026-05-29 (`docs/change-shape-classifier.md` is canonical; `/consult` + `project-manager` already read it). Re-homing would re-introduce two-source drift. The two remaining items are GO-grade; no further risk-check needed. Execution order below: Stage 2 (id-15) then Stage 3 (id-14); Stage 0 and Stage 1 are obsolete.

## Model
opus (`claude-opus-4-8[1m]`) — match. Deciding-class work: structural design with risk tradeoffs on shared command/agent bodies.

## Source Material
- `logs/improvement-log.md` — id-14 entry (lines ~242–244, read-during-rewrite mass-deletion near-miss), id-15 entry (lines ~266–270, advisory-scan omits logs/), id-16 entry (lines ~97–104, classifier two-end contract).
- `audits/working/diagnostics-scan-2026-06-05-1603-ai-resources.md` — candidate table (id-14/15/16 rows).
- `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-05-fix-project-issues-ai-resources.md` — SO Function-A advisory naming id-14/15/16 worth-doing.

## Findings / Items to Address

### Item 1 — id-14: shared-log read-during-rewrite mass-deletion guard
- **Problem:** A Read landing inside another session's non-atomic full-file rewrite of `improvement-log.md` returns a silently truncated state (S7 caught a transient 17-line read of a ~24-entry file). A downstream Write-of-full-content would persist that truncation as a mass deletion. The feedback-collector itself writes this file, so the gap sits on the loop's own write path.
- **Fix:** Add a cheap pre-append integrity check for shared-log writers that do Read-then-Write-full-content on `improvement-log.md` / `friction-log.md`: before persisting, assert the working entry count (or byte size) is not sharply below the committed `HEAD` baseline (`git show HEAD:logs/improvement-log.md | grep -c '^### '`); STOP-loud on a sharp shortfall (the read-during-rewrite signature). Document the hazard + the minimal-append-over-full-rewrite preference.
- **Target files:** `.claude/agents/session-feedback-collector` (pre-append assertion), `.claude/commands/improve.md` (same), `docs/commit-discipline.md` (document the hazard + preference).

### Item 2 — id-15: extend concurrent shared-dir advisory scan to non-append logs
- **Problem:** The `FOREIGN_SHARED` advisory scan in `/prime` Step 1a and `/session-start` Step 0.5 covers only `.claude/commands` + `docs`; `logs/` is excluded, so a live foreign in-place edit to the non-append `improvement-log.md` never surfaces in the brief (discovered only on a write attempt in S10).
- **Fix:** Extend the read-only scan in BOTH commands (lockstep) to also cover non-append shared logs — minimally `logs/improvement-log.md`, reasonably `logs/improvement-log-archive.md` + `logs/decisions.md`. Keep append-only `logs/session-notes.md` OUT (marker model protects it; including it false-positives on every concurrent session). Surface any foreign-dirty log as a lost-update exception line, exactly as the command/doc advisory already does.
- **Target files:** `.claude/commands/prime.md` (Step 1a scan), `.claude/commands/session-start.md` (Step 0.5 scan) — lockstep, identical change.

### Item 3 — id-16: extract change-shape classifier to shared reference doc
- **Problem:** The change-shape classifier list (Files / Commands / Agents / Models / Folder structure / Hooks / Workflows / Project boundaries / Permissions) is duplicated verbatim in `.claude/commands/consult.md` Step 2 and `.claude/agents/project-manager.md` Phase 3 — a two-end contract; silent drift causes routing inconsistency between `/consult` and `/pm`.
- **Fix:** Add a "Change-shape classifier" subsection to `docs/repo-architecture.md` (lives naturally alongside its Q5 classifier reference). Convert both consumers from verbatim copies to "read this section; apply the list."
- **Target files:** `docs/repo-architecture.md` (add subsection), `.claude/commands/consult.md` (replace list with Read-and-apply reference), `.claude/agents/project-manager.md` (same).

## Execution Sequence

### Stage 0 — Risk-check gate (all three items)
Run `/risk-check` once over the combined change set (command-body + agent-body + shared-doc edits). On GO, proceed. On RECONSIDER/NO-GO, pause; mandate + plan retained on disk.

### Stage 1 — Item 3 (id-16): classifier extraction
Lowest-coupling, cleanest win. (1) Read `docs/repo-architecture.md` to find the Q5 classifier reference and the canonical 9-item list. (2) Add the "Change-shape classifier" subsection (single source of truth). (3) Read `consult.md` Step 2 + `project-manager.md` Phase 3; verify both lists are identical before extracting (reconcile any pre-existing drift into the canonical list). (4) Replace each verbatim copy with a read-and-apply reference. (5) `/qc-pass` the three files.

### Stage 2 — Item 2 (id-15): advisory-scan extension
(1) Read the existing `FOREIGN_SHARED` block in `prime.md` Step 1a + `session-start.md` Step 0.5 to capture the exact current shape. (2) Extend both scans identically (lockstep) to include the non-append logs; keep `session-notes.md` excluded. (3) Update the Step-6 exception-line wording in `prime.md` if it enumerates the covered surfaces. (4) `/qc-pass` both files.

### Stage 3 — Item 1 (id-14): pre-append integrity guard
Most design-judgment-heavy (lands a runtime assertion into agent/command bodies). (1) Read `session-feedback-collector` + `improve.md` write paths to find the Read-then-Write-full-content points on the shared logs. (2) Add the pre-append baseline assertion (entry-count vs `git show HEAD:` baseline; STOP-loud on sharp shortfall). (3) Document the hazard + minimal-append preference in `docs/commit-discipline.md`. (4) `/qc-pass`.

### Stage 4 — Close-out
Flip id-14/15/16 improvement-log entries to `applied` with commit refs. Commit (explicit-path staging). `/contract-check` if drift suspected across the three stages.

## Scope Alternatives
- **Minimal subset:** id-15 + id-16 only (both are clean, low-judgment, well-specified). Drop id-14 if its runtime-assertion design proves more invasive than the entry suggests — id-14 is the only item adding executable assertions into agent/command bodies, so it carries the most design risk.
- **Full (planned):** all three.
- **Drop candidate:** id-14's optional `docs/commit-discipline.md` documentation can stand alone if the in-body assertion is deferred.

## Autonomy Posture
Gated — all three touch structural change classes (command-body, agent-body, shared-doc edits). Single risk-check gate at Stage 0 covers the set; per workspace Autonomy Rules #9. Commit directly after QC; push batched to wrap.

## Risk
- **id-14** is the highest-risk: it injects a runtime guard into the feedback-collector's own write path. A miscalibrated baseline check could STOP-loud on legitimate large archival edits (false positive) — calibrate the shortfall threshold against the archival workflow, not a fixed entry count. This is the item to drop to the minimal subset if it doesn't converge cleanly.
- **id-15/id-16** are low-risk lockstep / extraction edits; main risk is leaving the two ends of either pair out of sync — mitigated by editing each pair in immediate succession and QC'ing both files together.
- Concurrent-session hazard: this session edits shared `.claude/commands` + `docs` + `logs/improvement-log.md` — the very surfaces id-14/15 are about. SIBLING_COUNT was high today; re-check foreign-dirty state before each shared-file edit and before the improvement-log flip.
