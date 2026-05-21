# Risk Check — 2026-05-21

## Change

Create a new `session-governor` skill — the Phase 3 B1 governor skeleton for the Agent Harness. The skill is a skill-driven state machine: it inherits control from the `mandate-parser` skill (Phase A handoff), computes an execution plan with tier-aware unit ordering (B6) and a context-loading budget (B7) and persists it to `current-state.json`, then runs a Phase B main loop that advances test-workflow work units through the canonical state machine (pending → in_progress → verified → qc_passed → committed). Phase B steps 11–17 (verification-failure handling, cross-unit QC) are pass-through stubs; the verification function is real-but-trivial (always passes). New file: `.claude/skills/session-governor/SKILL.md`. Reads harness schemas + the `minimal-markdown` test workflow config; writes `harness/session/` state files. B2-deferred (NOT in this change): strategic compaction, blocked-item queue, operator attention budget, Stop-hook veto logic. Full plan: logs/session-plan.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/session-plan.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A self-contained new skill with no permission or always-loaded-cost impact, but the governor materially expands an existing multi-component state-machine contract (current-state.json execution plan, session-log events, single-writer ownership) under a B1/B2 split where deferred fields and named stubs create coupling that must be honored to keep Phase B2 and the existing `mandate-parser` handoff working.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New skill is invoked on demand, not auto-loaded — skills load only when their description pattern-matches a task. The `mandate-parser` sibling carries a narrow, harness-scoped description ("Implements Phase A (Session Startup) for Agent Harness sessions", `.claude/skills/mandate-parser/SKILL.md` lines 3–9); the governor will pattern-match the same narrow harness-session surface, not broad daily work.
- No always-loaded file is touched — the change adds a single file at `.claude/skills/session-governor/SKILL.md`; it does not edit workspace or project CLAUDE.md, and no `@import` is added to an always-loaded file.
- No hook is registered — CHANGE_DESCRIPTION explicitly states "no chained hooks for control flow" (session-plan.md line 31); the existing harness uses `session-start.sh` invoked from within a skill, not as a `SessionStart` hook (`mandate-parser/SKILL.md` lines 42, 78).
- The SKILL.md body itself (not yet present) will be loaded only when the governor runs; the Phase B "steps 1–24" loop spec implies a sizeable file, but its cost is pay-as-used and confined to harness sessions.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission change is described — CHANGE_DESCRIPTION names exactly one new file (`.claude/skills/session-governor/SKILL.md`) and no `settings.json` edit, no `allow`/`ask`/`deny` entry.
- The skill's runtime actions (read schemas, read workflow config, write `harness/session/` state files, `git commit` at Phase B step 18) all fall inside capability families already exercised by the existing `mandate-parser` skill, which writes `harness/session/mandate.json`, `harness/learning/mandate-history.jsonl`, and runs `bash .claude/hooks/session-start.sh` and `git status --porcelain` (`mandate-parser/SKILL.md` lines 74, 96, 332–335). The repo is intentionally permissive (workspace memory: "Permissive config philosophy"); no new tool family is introduced.
- `git commit` at Phase B step 18 is an in-tree write authorized by existing repo commit conventions; no `git push` or external write is in scope.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: one new file (`.claude/skills/session-governor/SKILL.md`). The two-gate audit-discipline classes confirm "New commands or skills" is an in-class structural change (`ai-resources/docs/audit-discipline.md` line 22).
- Dependent components already name the governor — the new skill must satisfy contracts these existing files assert. Enumeration of `grep -rl "governor"` across `harness/` and `.claude/` (16 hits):
  - `.claude/references/harness-rules.md` line 7 registers the path `.claude/skills/session-governor/` (Phase 3) and lines 44, 67, 79–83 specify governor behavior (post-compaction rehydration ownership, `Park`-mode `blocked_items` handling, verbatim `/compact` preservation instructions).
  - `harness/schemas/write-ownership.md` lines 17, 30 assign the governor sole writer of `current-state.json` (overwrite pattern) and a co-writer of `session-log.json` and `learnings.json`.
  - `harness/schemas/current-state-schema.md` lines 14, 46–53 specify the snapshot fields and the execution-plan persistence contract the governor must produce.
  - `harness/schemas/state-machine.md` lines 9–21 define the five-state lifecycle and transition owners the loop must implement exactly.
  - `harness/schemas/session-log-schema.md` lines 22–23 define governor event names (`work_unit_started/verified/qc_passed/committed`, `interrupt_triggered`).
  - `.claude/skills/mandate-parser/SKILL.md` lines 30, 296–298 hand control to the governor and state the governor reads `mandate.json` + `current-state.json`.
  - Plus `harness/prep/`, `harness/test-workflows/minimal-markdown/` spec/base-prompt files and prior planning reports reference the governor.
- Contract change is additive and backwards-compatible — the governor is the first implementation of an already-specified component; it does not change an existing caller's input/output schema. No existing file requires modification to keep working. `mandate-parser` already encodes the handoff (line 33 explicitly tells the governor to handle an absent `current-state.json` by creating it fresh — confirmed: `harness/session/` currently has no `current-state.json` or `session-log.json`).
- Why Medium, not Low: >5 dependent components reference the governor and the skill must conform to all of their specs at once; a deviation (e.g., a session-log event name not matching `session-log-schema.md`, or breaking single-writer discipline on `current-state.json`) silently breaks the multi-component contract. The blast radius is wide even though every caller is currently compatible.

### Dimension 4: Reversibility
**Risk:** Medium

- The skill file itself reverts cleanly — `git revert` of the commit removes `.claude/skills/session-governor/SKILL.md` with no orphan, since it is a single new file in a new directory.
- The "Recommended" scope alternative (session-plan.md line 50) runs unit-1 live, producing real `harness/session/current-state.json` and `harness/session/session-log.json`. These files do not exist today (verified: `harness/session/` contains only `.gitkeep` and two week-mandate files). A `git revert` of the skill commit does not delete state files created by *running* the skill — they are separate working-tree artifacts that need a manual `git rm` / `rm`. This is the one extra cleanup step that places the dimension at Medium rather than Low.
- `current-state.json` uses an overwrite pattern (`write-ownership.md` line 30) and `session-log.json` is append-only (`write-ownership.md` line 29). If the skill is reverted after a live run, leftover state files would be read as stale by a future `mandate-parser` crash-detection pass (`mandate-parser/SKILL.md` line 78 names "stale `in_progress` `current-state.json`" as a crash indicator) — a revert that leaves them in place can mis-fire crash recovery.
- No state propagates beyond git — no push, no external API write is in scope. Rollback is local and at most two steps (revert commit + remove generated state files).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The B1/B2 split creates a deferred-contract dependency. CHANGE_DESCRIPTION places "blocked-item queue" out of scope, but `current-state-schema.md` lines 20–42 already specify `blocked_items` as a required snapshot array and `harness-rules.md` line 67 routes `Park`-mode blockers there. If the B1 governor writes a `current-state.json` snapshot that omits `blocked_items`, B2 must retro-fit the field — and any Phase 4 reporter that reads `blocked_items` (current-state-schema.md line 26) would see an absent key. The B1 snapshot shape must reserve the `blocked_items` slot even though B1 does not populate it. This dependency is not visible from the change site (the SKILL.md) alone — it lives in the schema.
- Named-stub coupling at Phase B steps 11–17 and the disposition branch: session-plan.md line 33 requires each stub's "code-path point" to exist and be marked so B2/Phase 5–7 can fill it "without touching the loop." This is a real contract — B2 work depends on the exact stub locations and marker names the B1 skill chooses. The contract is documented at the change site (the SKILL.md will carry the markers) and in session-plan.md, which keeps this at Medium rather than High.
- Schema-vs-spec contradiction the governor must resolve, not inherit silently: `mandate-parser/SKILL.md` line 33 records that the v7 context pack lists `mandate-parser` as a writer of `current-state.json`, contradicting `write-ownership.md` (governor is sole writer). The governor must (per that note) "handle an absent `current-state.json` on first run by creating it fresh." If the B1 governor instead assumes a parser-created stub, the handoff silently breaks. This is a known, documented coupling — the governor design must honor it explicitly.
- `verification` function is real-but-trivial (always passes) and is explicitly *not* one of the 11–17 stubs (session-plan.md line 33). Its code-path point must exist so Phase 5 can replace it. A future reader who treats it as "just another stub" could remove the path — the SKILL.md must mark it distinctly from the 11–17 stubs.
- The `not yet present` SKILL.md means all five points above are evaluated from described intent (session-plan.md + CHANGE_DESCRIPTION), not from the file. The couplings are real per the schemas; whether the as-written skill honors them cannot be verified at plan time and must be checked at the end-time gate.

## Mitigations

- **Blast radius:** Before commit, cross-check the as-written SKILL.md against all four harness schemas in one pass — `state-machine.md` (transition owners + five states), `current-state-schema.md` (snapshot fields + execution-plan persistence), `session-log-schema.md` (exact governor event names: `work_unit_started/verified/qc_passed/committed`, `interrupt_triggered`), and `write-ownership.md` (governor as sole `current-state.json` writer, overwrite pattern). Record the cross-check in the end-time `/risk-check` payload.
- **Reversibility:** Land the SKILL.md file as one commit, and commit any live-run state files (`harness/session/current-state.json`, `harness/session/session-log.json`) as a separate follow-up commit — so a revert of the skill does not require disentangling generated state, and stale state files can be removed independently without mis-firing `mandate-parser` crash detection.
- **Hidden coupling (deferred-field):** Have the B1 governor write a `current-state.json` snapshot that includes the `blocked_items` key as an empty array `[]` even though B1 does not populate it — reserving the slot per `current-state-schema.md` lines 20–42 so B2 and any Phase 4 reporter never see an absent key.
- **Hidden coupling (named stubs):** In the SKILL.md, mark each Phase B step 11–17 stub and the failure-disposition branch with a stable, greppable marker string (e.g., `STUB-B2:`), and mark the real-but-trivial verification function distinctly (e.g., `PHASE5-REPLACE:`) so it is not mistaken for a B2 stub. Confirm at the end-time gate that the markers are present and unique.
- **Hidden coupling (handoff):** Confirm the SKILL.md explicitly states the governor creates `current-state.json` fresh on first run if absent (per `mandate-parser/SKILL.md` line 33), rather than assuming the parser left a stub.

## Recommended redesign

Not applicable — verdict is PROCEED-WITH-CAUTION.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). The new SKILL.md is `not yet present`; Dimension 5 findings on that file are evaluated from described intent in `logs/session-plan.md` and CHANGE_DESCRIPTION, noted explicitly in that dimension. No training-data fallback was used on fetch/read failures.
