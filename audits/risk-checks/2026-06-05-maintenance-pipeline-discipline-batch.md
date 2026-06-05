# Risk Check — 2026-06-05

## Change

Batch of maintenance-pipeline discipline edits (Phase A of an approved, QC'd, System-Owner-reviewed plan; the registry-flag piece C6 already landed standalone). Five additive edits across the workspace CLAUDE.md + 4 command bodies + 1 log schema:

C1 — Add ONE new bullet (~6 lines) to workspace CLAUDE.md § Working Principles: "Structural fix as default style; ROI decides scope." Always-loaded content. Splits two axes: ROI decides WHICH problems get fixed (ruthless gate, never "fix everything"); structural is the default STYLE for what passes; a short patch is a logged exception; "too expensive to do structurally → park, not patch."

C2 — Formalize the EXISTING `Review-cycle:`-reset convention as the canonical low-value "park" mechanism. Four sub-edits:
  (a) improvement-log.md — schema note on the existing `Review-cycle:` bullet (line 11) naming it the canonical park mechanism for ROI-deferred items.
  (b) resolve-improvement-log.md Step 3b `r` disposition (line 54) — add concrete-trigger enforcement: the new Review-cycle text must name a date/quarter/named-event; reject vague "later"/"someday"/"eventually" and re-prompt once.
  (c) resolve-improvement-log.md Step 3c (lines 59-77) — recognize a FORWARD `Review-cycle:` deferral as "parked-alive" and EXCLUDE such entries from the no-active-friction ARCHIVE offer (anti-burial guard: parked items must stay in the active log to re-surface, not be archived into the deny-read archive).
  (d) friday-checkup.md Step 6 (after the Fading-gate item, line 313) — add a monthly+only `[PARKED]` park-drain tactical item that surfaces the N oldest parked entries (by original `### YYYY-MM-DD` header date, NOT the reset Review-cycle date — to catch repeatedly-re-parked items), guarded `Skip if TIER=weekly`. No scanner filter changes.

C3 — friday-act.md Step 3.1a auto-triage (lines 142-148) — add a mechanical named-consequence overlay (reuse docs/materiality-bar.md's "name a concrete consequence" test): an item with NO nameable consequence defaults to `d` (defer/park) regardless of risk label. AND fix-repo-issues.md Step 3 (line 125) — add `low-roi` as a new entry in the existing closed Park-reason enum (currently needs-dedicated-session, decision-needed, multi-file-refactor, needs-/innovation-sweep, needs-/create-skill, risk-check-class). `low-roi` stays a free-text Park reason, NEVER a scanned status token.

C5 — friday-act.md Step 5 closeout (lines 320-361) — add an "Autonomy & Reliability notes" subsection to the maintenance-observations.md session-block template + a free-text prompt capturing what blocked autonomous running each cycle.

All edits additive (new bullet / new subsection / new tactical item / enum extension / validation clause). NO hooks, NO settings.json, NO permissions, NO new symlinks, NO new always-loaded FILES (C1 adds ~6 lines to an existing always-loaded file). NO automation with shared-state effects beyond what already exists. Fully reversible via git. Already QC'd (REVISE→all 3 findings fixed) and System-Owner-reviewed (two HIGH guards folded in: park-as-graveyard drain via C2c+C2d, C3 reshaped from a judgment label to a mechanical boolean).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/fix-repo-issues.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/materiality-bar.md — exists

## Verdict

GO

**Summary:** Five additive, fully git-reversible edits to existing maintenance-pipeline files with no permission/hook/settings surface; the one cross-cutting touch (C1, ~6 lines to always-loaded CLAUDE.md) is small and principle-aligned (closure/anti-burial), and the touched `Review-cycle:` field syntax is preserved so no scanner consumer breaks.

## Consumer Inventory

Search terms: `Review-cycle`, `maintenance-observations`, the Park-reason enum tokens (`needs-dedicated-session` / `multi-file-refactor`), `materiality-bar`, the touched command tokens (`resolve-improvement-log`, `friday-checkup`, `friday-act`, `fix-repo-issues`), and the C1 phrase (`structural fix as default` / `ROI decides scope` — zero pre-existing hits, so C1 introduces a new phrase but no new contract token). Scoped to `.claude/` (commands/agents/hooks) + `docs/` + workspace `CLAUDE.md`; historical `logs/` and `audits/` artifacts are records, not consumers, and are excluded.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/fading-gate-scanner.md | parses (`Review-cycle:` regex on gate-calibration.md, not improvement-log) | no |
| ai-resources/.claude/agents/fix-repo-issues-scanner.md | parses (`**Review-cycle:**` date on improvement-log for age; documents Park-reason exclusion via `EXCL_PARKED_REASON`) | no |
| ai-resources/.claude/commands/friday-checkup.md | parses + co-edits (Step 6 stale-detection reads `Review-cycle:` date; C2d adds a sibling tactical item here) | yes (target of C2d) |
| ai-resources/.claude/commands/resolve-improvement-log.md | parses + co-edits (owns `Review-cycle:` disposition; target of C2b/C2c) | yes (target of C2b/C2c) |
| ai-resources/.claude/commands/friday-act.md | co-edits (target of C3 overlay + C5 closeout) | yes (target of C3/C5) |
| ai-resources/.claude/commands/fix-repo-issues.md | co-edits (target of C3 enum extension) | yes (target of C3) |
| ai-resources/logs/improvement-log.md | co-edits (target of C2a schema note) | yes (target of C2a) |
| ai-resources/docs/materiality-bar.md | imports/reuses (C3 reuses its "name a concrete consequence" test; not modified) | no |
| ai-resources/.claude/agents/{qc-reviewer, refinement-reviewer, improvement-analyst}.md | documents (cite materiality-bar; unaffected — test reused, not changed) | no |
| ai-resources/.claude/commands/{tweak, so-monthly, monday-prep, log-sweep}.md; agents/{system-owner, session-feedback-collector}.md | documents/parses (reference maintenance-observations.md; C5 only APPENDS a subsection to the template) | no |
| ~30 commands/agents referencing `improvement-log.md` generally (improve, monday-prep, create-skill, prime, wrap-session, repo-dd, etc.) | documents/parses (read the log; none depend on the `Review-cycle:` disposition semantics C2 changes) | no |

Total: 11 distinct consumer rows; 4 must-change — all 4 are the deliberate edit targets named in CHANGE_DESCRIPTION (C2a/b/c/d, C3, C5). No must-change consumer is unanticipated. The other ~37 reference sites are read-only or documentation references that stay compatible because the change preserves the `**Review-cycle:**` field syntax and only adds disposition logic / an additive enum value / an appended template subsection. C1's new phrase has zero current consumers (it is advisory prose, not a parsed token) — that is expected for an always-loaded principle bullet, not a speculative-contract signal.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- C1 adds ~6 lines to an always-loaded file (workspace `CLAUDE.md` § Working Principles, line 82-89 block) — this is per-turn token cost in every session in the workspace. CHANGE_DESCRIPTION: "Always-loaded content … C1 adds ~6 lines to an existing always-loaded file." ~6 lines sits in the Medium band (~50–150 tokens to always-loaded files).
- No hook, no `@import`, no SessionStart/PreToolUse registration — verified: CHANGE_DESCRIPTION states "NO hooks … NO new always-loaded FILES." The existing § Working Principles already carries 6 bullets (CLAUDE.md lines 84-89); a 7th is an incremental, not a new always-loaded surface.
- C2/C3/C5 edits land in command bodies (`friday-checkup.md`, `friday-act.md`, `resolve-improvement-log.md`, `fix-repo-issues.md`) — these are pay-as-used (loaded only when the command runs), no ongoing per-session cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission change. CHANGE_DESCRIPTION: "NO settings.json, NO permissions." No `allow`/`ask`/`deny` entry added, removed, or narrowed.
- C2c interacts with an EXISTING deny rule rather than changing it: `resolve-improvement-log.md` line 101 documents that `settings.json` denies `Read(logs/*archive*.md)`, and C2c's anti-burial guard keeps parked items OUT of that deny-read archive — it respects the existing permission boundary, does not touch it.
- No new tool-invocation pattern, no cross-repo write, no external API.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory: 11 distinct consumer rows, 4 must-change — and all 4 must-change rows are the intended edit targets (C2a/b/c/d, C3, C5). No must-change consumer is unanticipated by CHANGE_DESCRIPTION, so the change is correctly classified as a 6-file additive batch.
- Contract-preservation check (the `parses` rows): two scanner agents parse the `Review-cycle:` field. `fix-repo-issues-scanner.md` line 65 parses `**Review-cycle:**` date for `age_days`; `fading-gate-scanner.md` line 46 parses `Review-cycle:` via regex (but on `gate-calibration.md`, a different file). C2 adds disposition logic (concrete-trigger validation, archive-exclusion) and a schema NOTE — it does not alter the `**Review-cycle:**` line syntax or the date format those regexes match. Backwards-compatible.
- `friday-checkup.md` Step 6 stale-detection (line 310) also reads the `Review-cycle:` date as the age basis. C2d adds a SIBLING tactical item (`[PARKED]` drain) in the same Step 6 and explicitly states "No scanner filter changes" — the existing stale rule is untouched.
- The Park-reason enum (`fix-repo-issues.md` line 125) has one consumer beyond the command itself: `fix-repo-issues-scanner.md` line 109 tracks `EXCL_PARKED_REASON` as a free-text count, not an enum-membership check — so adding `low-roi` as a free-text reason (never a scanned token, per CHANGE_DESCRIPTION) does not break the scanner.
- C5 appends a subsection to the `maintenance-observations.md` session-block template; 6 other components reference that file (system-owner, so-monthly, monday-prep, log-sweep, tweak, session-feedback-collector) but consume it as read/append, not as a fixed-schema parse — an appended subsection is additive.
- Medium (not Low) because the batch touches 6 files including two shared-infra surfaces (always-loaded CLAUDE.md and the improvement-log schema read by ~30 components) — but every contract those consumers depend on is preserved.

### Dimension 4: Reversibility
**Risk:** Low

- All five edits are text edits to files already under git. CHANGE_DESCRIPTION: "Fully reversible via git" and "All edits additive (new bullet / new subsection / new tactical item / enum extension / validation clause)." A single `git revert` of the batch commit restores prior state in the same working tree.
- No log-data mutation that revert leaves stale: C2a edits the improvement-log *schema header* (the `## Schema` block, lines 3-16), not log entries; reverting it removes the schema note cleanly. The `Review-cycle:`-reset *behavior* applies only when operators run `/resolve-improvement-log` after the change lands — no retroactive data rewrite.
- No state propagates beyond git: no push (gated/batched per repo rules), no external write, no symlink, no hook that could fire between landing and revert. CHANGE_DESCRIPTION: "NO automation with shared-state effects beyond what already exists."
- Minor operator muscle-memory consideration (the new `low-roi` Park reason and `[PARKED]` drain item) is documentation-level, not a rollback obstacle.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- C2 spreads one convention (`Review-cycle:`) across three files that must stay semantically aligned: the schema note (C2a, improvement-log.md line 11), the disposition rule that writes it (C2b/c, resolve-improvement-log.md Step 3b/3c), and the drain that reads it (C2d, friday-checkup.md Step 6). The coupling is real but is documented at each site by the change itself, and the field syntax is the stable contract — this is the Medium pattern (one new contract documented at the change site), not High.
- Implicit dependency surfaced by the inventory: `fading-gate-scanner.md` (line 46) and `fix-repo-issues-scanner.md` (line 65) both depend on the `**Review-cycle:**` line being a parseable date. C2b's concrete-trigger rule ("must name a date/quarter/named-event") actually *strengthens* parseability for the date case, but "quarter" or "named-event" text (e.g., "defer to Q3", "after the migration") is NOT an ISO date — the scanners that expect `YYYY-MM-DD` will skip/mis-handle a non-date Review-cycle value. This is an existing tolerance (the scanners already "skip entries with no parseable date" per resolve-improvement-log.md line 21), so it degrades gracefully rather than breaking — but it is an implicit coupling worth noting: a quarter/named-event Review-cycle value will not reset the scanner age clock, only the `[PARKED]` drain (which sorts by header date) catches it. C2d's design (drain by ORIGINAL header date, not reset date) appears to deliberately account for exactly this.
- C3's named-consequence overlay couples `friday-act.md` to `docs/materiality-bar.md`'s test wording. The reuse is explicit (CHANGE_DESCRIPTION names it; materiality-bar.md lines 12-23 own the test) and the file is unmodified, so this is a documented, single dependency.
- No silent auto-firing in unexpected contexts; no two-systems-handle-same-concern overlap (the `[PARKED]` drain and the existing `[STALE]` rule key off different signals — forward-deferral vs. age).

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active). Inline checks applied against it.
- **OP-12 (closure before detection) — actively served.** C2d adds a `[PARKED]` *detection* item, but it is paired with a closure channel by design: C2c's anti-burial guard keeps parked items in the active log so the drain can re-surface and close them, and the drain routes oldest-first to `/friday-act` for disposition. This is "detection shipped behind a working closure channel," exactly what OP-12 (principles-base line 50) requires — the change serves the principle rather than violating it.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** Every edit has a present, named consumer (the running maintenance pipeline). C1's new phrase has zero parse-consumers, but it is advisory always-loaded prose, not a pre-built hook or generalization for an absent Phase-2 consumer. No "hooks for later." CHANGE_DESCRIPTION confirms "NO hooks."
- **OP-5 (advisory vs. enforcement) — preserved.** C2b adds a re-prompt-once validation (advises and re-asks, then proceeds) and C3 changes a *default* disposition (overridable); neither converts an advisory mechanism into auto-correcting enforcement. The operator confirmation gates in resolve-improvement-log.md (line 7, load-bearing `[y/n/select]`) are untouched.
- **OP-2 / AP-4 (automate execution, gate judgment) — respected.** C3 reshapes a judgment label into a mechanical boolean (named-consequence present/absent) that sets a *default*, leaving the per-item operator override intact (friday-act.md line 148) — it automates the base-rate guess, not the judgment call.
- **DR-1 / DR-3 (placement) — correct tiers.** Edits land in their canonical homes: a cross-session rule in workspace CLAUDE.md (C1), command bodies under `.claude/commands/`, a log schema header, and a reused doc. No tier/home misplacement.
- **OP-11 (loud revision) — N/A.** The change does not revise or relax any principle; it operationalizes existing ones (materiality bar, ROI gating), so no loud-revision obligation is triggered.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from the seven referenced files plus the two scanner agents, grep-based consumer inventory counts, verbatim quotes from CHANGE_DESCRIPTION and referenced files, and principle IDs cited from the readable principles-base index). No training-data fallback was used on fetch/read failures.
