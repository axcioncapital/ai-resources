# Risk Check — 2026-05-26

## Change

Plan-time risk-check on Wave C of 2026-05-26 friction-cleanup session.

**Proposed change:** Enhance `/session-plan` Step 0 conflict-detection logic in `ai-resources/.claude/commands/session-plan.md` (Step 0, currently ~lines 11–27). When session-plan.md exists within the 6-hour freshness window, add an intent-comparison sub-step:

1. Compute UPCOMING_INTENT for this invocation (preview Step 1 logic — either `$ARGUMENTS` verbatim or the last `### Next Steps` first bullet from session-notes.md).
2. Read EXISTING_INTENT from the existing session-plan.md's `## Intent` line.
3. Compare both strings case-insensitively after trimming punctuation/whitespace. Match = either string contains the other as a substring (covers normal "re-invocation with rephrased intent" cases).
4. **Match → same-session re-invocation:** emit the existing 3-option prompt unchanged (keep / overwrite / pass2). Operator wants to revise their own plan.
5. **Mismatch → concurrent-session collision:** AUTO-WRITE to `logs/session-plan-pass2.md` without prompting. Emit one notification line: "Concurrent session detected. Existing intent: '{EXISTING}'. This session's intent: '{UPCOMING}'. Writing new plan to `session-plan-pass2.md` (preserves both)." Set output target to pass2 and continue to Step 1.

**Why:** Friction-log 2026-05-25 14:10 entry — when two concurrent sessions run in the same repo, the second session's `/session-plan` invocation triggers the destructive 3-option prompt with no safe default. Operator must navigate it manually each time (option 2 destroys the other session's plan; option 3 preserves but requires manual choice). The fix lets `/session-plan` detect the collision and default to pass2 automatically; same-session re-invocations are unaffected.

**Touch surface:** One file — `ai-resources/.claude/commands/session-plan.md` Step 0 block. Adds ~10 lines of new logic. May also require minor Step 1 adjustment if UPCOMING_INTENT computation is hoisted into Step 0.

**Blast radius:**
- `/session-plan` invocations only — no other commands invoke this Step 0 logic.
- Output target choice (`session-plan.md` vs `session-plan-pass2.md`) is the changed behavior — shared-state filename effect.
- Consumers of `session-plan.md` path: 12 live consumers (4 commands incl. drift-check + new-project + open-items + prime; 4 docs; 4 workflow templates). None directly consume `session-plan-pass2.md`; that path is only written-to by `/session-plan` itself.
- `/open-items` Step 1 already lists `session-plan-pass2.md` as a known source (per Wave B's preceding edit), so increased pass2 frequency doesn't surprise downstream readers.

**Reversibility:** Single-file edit; trivially reversible. No state created beyond `session-plan-pass2.md` files (already an established pattern).

**Hidden coupling concerns:**
- Risk of false-positive collision (rephrased intent → auto-pass2 fires when operator wanted overwrite). Cost: minor — extra file, no data loss.
- Risk of false-negative collision (overlapping intents → 3-option prompt still fires). Cost: same as current pain (no regression).
- `/session-plan` Step 1's existing intent-confirmation prompt may run twice (once for Step 0 preview, once for Step 1) if UPCOMING_INTENT determination is duplicated. Mitigation: cache UPCOMING_INTENT in Step 0 and reuse in Step 1.

**Approved session plan called for plan-time + end-time /risk-check on this wave** because the change modifies an automation flow with shared-state filename effects — risk class "automation with shared-state effects" per `docs/audit-discipline.md` (clarified 2026-05-25 to cover reorders/changes to shared-state ops).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Single-file edit with surgical scope and a clean revert path; the only elevated risk is hidden-coupling around the intent-comparison heuristic and Step 1 prompt duplication, which the change-author already named — landing requires the named mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file touched. The change is confined to `.claude/commands/session-plan.md`, which loads only when `/session-plan` is invoked — not on every turn (file is a slash-command body, not a CLAUDE.md or hook).
- No new hook registration. The change adds inline logic inside an existing Step 0; no SessionStart/PreToolUse/Stop hook is being added (the existing command had no hook to begin with — confirmed by reading session-plan.md frontmatter at lines 1–5: only `model: opus` and `effort: high`).
- No new `@import` chain. The Step 0 logic reads `logs/session-notes.md` and `logs/session-plan.md` — both reads already happen in the existing Step 0/Step 1 (line 13 reads session-notes.md, line 16 stats session-plan.md). The new comparison adds one extra `## Intent` line-read from session-plan.md, not a new file load.
- Estimated added body size: ~10 lines (per CHANGE_DESCRIPTION "Adds ~10 lines of new logic"). `/session-plan` is invoked once per session via `/prime` chain (prime.md line 139) — pay-as-used, not pay-per-turn.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edit named in CHANGE_DESCRIPTION. The change is scoped to `session-plan.md` command body only ("Touch surface: One file").
- No new tool family. Step 0 already uses `Read` (session-notes.md, session-plan.md `## Intent`) and `stat` (freshness check at line 16). The added logic uses the same primitives — case-insensitive string comparison is pure in-context computation, not a new tool invocation.
- No `deny` rule narrowed; no scope-escalation from project to user layer.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touch count: 1 (`ai-resources/.claude/commands/session-plan.md`).
- Enumeration of dependent callers — files referencing `session-plan.md` outside `audits/` and `logs/` (grep on `.claude/`, `docs/`, `skills/`, `workflows/`, `templates/`):
  - `.claude/commands/drift-check.md` — 4 references (lines 18, 28, 30, 48). Reads `session-plan.md` for mandate cross-check.
  - `.claude/commands/prime.md` — 7 references (lines 132, 133, 137, 139, 140, 141, 149). Invokes `/session-plan` in the prime auto-chain (line 139).
  - `.claude/commands/open-items.md` — 5 references. Lists `logs/session-plan.md` AND `logs/session-plan-pass2.md` as T1/T3 sources (lines 41–42, confirmed by Read).
  - `.claude/commands/new-project.md` — 2 references (lines 535, 545). Lists session-plan as a scaffolded command.
  - `docs/weekly-cadence.md`, `docs/repo-architecture.md`, `docs/compaction-protocol.md`, `docs/heavy-read-discipline.md` — 1–2 references each (docs only, no behavioral wiring).
  - `workflows/research-workflow/.claude/commands/run-execution.md` — 4 references; `intake-reports.md` + `inject-dependency.md` — 1 each; `reference/file-conventions.md` — 1. These reference the workflow's *own* per-section session-plan.md under `workflows/research-workflow/`, NOT the orchestrator's `logs/session-plan.md` — confirmed by session-plan.md line 7 disclaimer.
- Total dependent consumers of the orchestrator's `logs/session-plan.md`: 4 commands + 4 docs = 8 live consumers (the 4 workflow files reference a different file under a different path).
- Contract changes: NO change to the `logs/session-plan.md` schema (Intent / Class / Model / Source Material / ... headings at lines 165–195 unchanged). NO change to the `## Intent` line format. The only behavioral change is which output target (`session-plan.md` vs `session-plan-pass2.md`) is selected; both filenames already exist as recognized targets in Step 0 today (lines 21, 27).
- `/open-items` already lists `session-plan-pass2.md` as a tracked source (line 42, T1/T3 split). Increased pass2 write frequency therefore does not surprise that consumer.
- `/drift-check` reads `logs/session-plan.md` (drift-check.md line 18, 28). If a concurrent session auto-routes to `session-plan-pass2.md`, the drift-check in the *second* session would read only the first session's plan — potential mismatch. Worth noting; not a contract break (drift-check.md line 28 already acknowledges multiple same-day entries and mandate-conflict scenarios).

Verdict for this dimension: 8 dependent consumers (more than the Medium "3–5" calibration point), but all are compatible with the change — none require modification. The Medium rating is conservative due to the consumer count.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to `.claude/commands/session-plan.md`. `git revert` of the commit restores the prior Step 0 block verbatim.
- The change produces no new sibling files, no migrations, no log-mutation. Any `session-plan-pass2.md` files written under the new logic remain in place after revert, but `session-plan-pass2.md` is already an established convention (Step 0 option 3 already writes to that path, line 21) — these are not artifacts unique to the new behavior.
- No state propagates beyond the repo (no push, no Notion write, no external API).
- No hook/cron/symlink added — nothing fires between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New implicit contract: intent-comparison heuristic.** "Either string contains the other as a substring (case-insensitive, trimmed)" is a new contract embedded in Step 0. It is undocumented anywhere outside the command body itself. False-positive case (rephrased intent matches loosely → routes to pass2 when operator wanted overwrite) and false-negative case (different work, overlapping vocabulary → routes through 3-option prompt) are named in CHANGE_DESCRIPTION but their thresholds aren't pinned down — "trimming punctuation/whitespace" is vague (which punctuation? leading/trailing only or all?). Mitigation: the implementing edit must spell out the exact normalization steps (lowercase, strip leading/trailing whitespace, strip trailing punctuation `.,;:!?`) inline in the command body so a future reader can predict matches without re-reading this risk-check.
- **Prompt-duplication coupling between Step 0 and Step 1.** CHANGE_DESCRIPTION flags this directly: "Step 1's existing intent-confirmation prompt may run twice (once for Step 0 preview, once for Step 1) if UPCOMING_INTENT determination is duplicated. Mitigation: cache UPCOMING_INTENT in Step 0 and reuse in Step 1." Inspection of session-plan.md line 51–55 confirms the risk — Step 1 explicitly issues an "Confirm, or state a different intent" prompt and waits. If Step 0 also issues a prompt to derive UPCOMING_INTENT (e.g., when `$ARGUMENTS` is empty and the `### Next Steps` lookup hits a `(none derived)` sentinel — line 45), the operator faces two prompts back-to-back. Mitigation must land as part of the same edit.
- **Interaction with `/drift-check`.** drift-check.md line 28 already encodes a "multiple same-day entries — isolation rule" and a mandate-conflict path. The new auto-pass2 logic concentrates concurrent-session output at `session-plan-pass2.md`; drift-check.md does not currently inspect pass2. Not a regression (drift-check today doesn't handle the manual-option-3 case either) but worth a note in the commit message so the next `/drift-check` improvement cycle considers pass2.
- **Sentinel collision risk.** Step 1 line 43–44 sets `INTENT` to sentinel values like `(none derived — file missing or empty)` when session-notes.md lookups fail. If EXISTING_INTENT is a real intent and UPCOMING_INTENT resolves to a sentinel, substring-contains will likely declare mismatch and auto-route to pass2 — which is arguably correct, but the new Step 0 should handle the sentinel case explicitly (fall through to the original 3-option prompt) rather than letting the comparison fire on garbage. Mitigation: explicit sentinel check before comparison.

### INCOMPLETE flags

None. All five dimensions evaluated against direct evidence from the four referenced files plus grep enumeration of dependent callers.

## Mitigations

- **Dimension 5 (Hidden Coupling) — pin down the comparison contract.** Inline in the Step 0 edit, name the exact normalization steps used by the intent-comparison heuristic: (a) lowercase both strings, (b) strip leading and trailing whitespace, (c) strip trailing punctuation from the set `.,;:!?`, (d) declare match if EXISTING contains UPCOMING or UPCOMING contains EXISTING as a substring after normalization. A future reader must be able to predict match/mismatch without re-deriving the rule from this risk-check.
- **Dimension 5 (Hidden Coupling) — cache UPCOMING_INTENT.** Implement the change so Step 0 computes UPCOMING_INTENT once and Step 1 reuses the cached value. Do not let Step 1 re-prompt the operator if Step 0 already prompted (the `(none derived)` sentinel path at line 45 already prompts — Step 0's preview must not duplicate it).
- **Dimension 5 (Hidden Coupling) — handle sentinel values explicitly.** Before comparing EXISTING_INTENT vs UPCOMING_INTENT, check whether UPCOMING_INTENT begins with `(none derived`. If yes, skip the comparison and fall through to the existing 3-option prompt — do not auto-route a sentinel to pass2.
- **Dimension 3 (Blast Radius) — document the drift-check interaction.** In the commit message, note that `/drift-check` does not currently read `session-plan-pass2.md` and that increased pass2 write frequency under the new logic means a future drift-check enhancement may want to inspect it. This is documentation only; no `/drift-check` edit is required in this wave.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: session-plan.md lines 11–55 (current Step 0 and Step 1 bodies), open-items.md lines 41–42 (pass2 already tracked), drift-check.md lines 18, 28 (mandate cross-check and same-day isolation rule), prime.md line 139 (prime auto-chain invokes session-plan), audit-discipline.md lines 23–24 (shared-state-effects class definition including the 2026-05-25 reorder clarification), grep counts across 12 dependent files in `.claude/`, `docs/`, and `workflows/`. No training-data fallback used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Function B — Pre-change Advisory: `/session-plan` Step 0 Intent-Comparison Enhancement

## Routing position

The change touches `ai-resources/.claude/commands/session-plan.md` — a canonical slash command auto-symlinked into every project (`repo-architecture.md` § Canonical homes; § Symlink topology). Q5 classes this as a structural change ("automation with shared-state effects"), so `/risk-check` is mandatory at both gates per DR-8 (`principles.md § DR-8`). The change stays in its correct home; no routing move. The `session-plan-pass2.md` path remains an ad-hoc artifact owned by `/session-plan` itself — it is not registered in `repo-architecture.md` § Q6 (which only lists `session-plan.md`), and no downstream command currently treats it as a documented contract.

## Concurrence with PROCEED-WITH-CAUTION

We concur with the verdict and with the dimension scoring. The change is well-motivated by a recurring friction pattern (friction-log 2026-05-25 14:10) and lines up with OP-1 (compound AI value) and OP-2 (automate execution; gate judgment — auto-routing a clearly-detectable mismatch is exactly the kind of execution that should not require operator navigation) (`principles.md § OP-1`, `§ OP-2`). The medium scores on blast radius and hidden coupling are appropriate: 12 documented consumers, auto-symlink distribution to every project (`risk-topology.md § 2 — Critical: auto-sync-shared.sh`), and the introduction of a new normalization contract that other components will eventually need to share.

## Architectural commentary on top of the four mitigations

**Mitigation 1 (pin normalization rules inline) — strongly endorse.** This is exactly the right shape per AP-10 boundary discipline and per QS-4: when a comparison is load-bearing, the rules are stated where the comparison happens, not left to inference. Without this pin, the contract becomes invisible technical debt — every future reader has to reverse-engineer it from behavior. (`principles.md § QS-4`, `§ AP-10`)

**Mitigation 2 (cache UPCOMING_INTENT, avoid duplicate prompts) — endorse.** Aligns with AP-4 (no rubber-stamp / no double-prompt). Reordering Step 0 / Step 1 without this cache would create a regression in operator friction — the kind of "fix introduces new friction" pattern that AP-9 warns against. (`principles.md § AP-4`, `§ AP-9`)

**Mitigation 3 (sentinel handling — fall through, not auto-route) — endorse strongly.** Auto-routing a `(none derived — ...)` sentinel to pass2 would be a silent-conflict-resolution failure (AP-1) — the system would commit a meaningful side-effect (writing a separate file) on the basis of a value that is explicitly "I don't know yet." Falling through to the 3-option prompt is the only correct shape: it preserves OP-3 (loud failure over silent continuation) at the exact point where ambiguity is highest. (`principles.md § AP-1`, `§ OP-3`)

**Mitigation 4 (commit-message note on `/drift-check`) — endorse but insufficient.** A commit-message note is not a load-bearing record. It surfaces nothing to any future scan, audit, or maintenance pass.

## Scrutiny points

**(a) Substring-either-direction match semantic.** Correct call. Stricter (exact-equal-after-normalization) would miss the dominant real-world case. Looser (token-overlap with a threshold) would introduce a tunable that becomes its own contract drift surface. Substring-either-direction matches OP-6 — the operator's mental model is "is the second session working on the same thing?"

**(b) Step 0 / Step 1 reordering — second-order effects.** Live consumer set for the reordering is `/prime` only. `/monday-prep` does NOT invoke `/session-plan` (line 293 — writes separate `session-plan-next.md`). `/prime`'s `$ARGUMENTS`-non-empty path is semantically unchanged. Risk is bounded.

**(c) Auto-pass2 notification placement.** Inline chat notification is sufficient for the operator-in-the-loop case but insufficient as a system signal. See Risk M-1 below.

## Risks the dimension review missed

**Risk M-1 — `session-plan-pass2.md` is undocumented in `repo-architecture.md` Q6.** The Q6 log table lists `session-plan.md` and nothing else. Increasing the rate at which pass2 files are written makes that documentation gap load-bearing. Add a one-line entry to `repo-architecture.md` Q6 for `session-plan-pass2.md` *in the same commit* as the `/session-plan` change. (`risk-topology.md § 1`; `principles.md § OP-11`)

**Risk M-2 — `/drift-check` mandate-conflict logic.** `/drift-check` reads `logs/session-plan.md`, not pass2 (drift-check.md line 48). When auto-pass2 fires, the current session's mandate is in pass2, but `/drift-check` will use the prior session's plan as baseline. This produces false ALIGNED verdicts in concurrent-session scenarios. Add a one-line check to `/drift-check` Step 3 — if pass2 exists and is newer than session-plan.md, prefer pass2. OR defer as known debt with explicit `maintenance-observations.md` note. (`risk-topology.md § 5 — two-end contract`)

**Risk M-3 — auto-pass2 normalizes an ad-hoc filename.** Today pass2 is rare and operator-acknowledged. After this change, it becomes routine automatic side-effect — downstream consumers will start to *depend* on its presence. DR-7 / OP-9 warns against pre-emptive normalization. Acknowledge in commit message that this is a v1 fix; if pass2 frequency exceeds ~2/week, the date+intent slug approach (friction-log fix direction (a)) becomes the correct evolution.

## Position

**PROCEED-WITH-CAUTION holds. The four mitigations are correct as far as they go, but mitigation #4 must be upgraded from a commit-message note to a same-commit documentation update.** Specifically: `repo-architecture.md` Q6 gets a one-line entry for `session-plan-pass2.md`, and the commit message acknowledges (i) the `/drift-check` gap as known debt to track, and (ii) the pass2 filename normalization as a v1 fix that may need to evolve.
