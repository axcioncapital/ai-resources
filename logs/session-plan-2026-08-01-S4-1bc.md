# Session Plan — 2026-08-01

## Intent
Write the Work Loop v2 MVP slice plan as one short note covering the three Proposal slices with a few observable acceptance behaviours each, and put the mission-contract contradiction to the operator for a decision.

## Model
opus — match (deciding, not doing: acceptance behaviours must be derived as observable falsifiable tests from settled decisions, and the mission-contract item is a governance judgment)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md` — authority order; the "Decisions taken after v0.4" section this session may extend
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` — AUTHORITATIVE. §4 destination behaviours 1–7 (`:52-58`), §5 Phase 2 slices (`:81-89`), §5 Phase 4 regression set (`:107`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` — Step 4 definition (`:105-119`), Step 5 red-green method (`:123-134`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — the approved core the slices must respect
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` — proven seam constraints (Codex cannot write `.git`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md` — Codex-side packaging facts
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` — binding on how the note is written
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md` — Step 4 thread; acceptance assertion 1 (the contradiction)

## Findings / Items to Address

1. **Slice 1 — core round trip.** Codex brief in the state file → Claude reads and verifies premises (including refusing a deliberately wrong one) → Claude executes a small real unit → result and evidence written → Codex assesses and closes. Kept as ONE slice deliberately (Proposal `:83`).
2. **Slice 1 predefined split point.** If Slice 1 does not fit one clean implementation session, split it at the Codex side / Claude side boundary. "The session boundary decides the slice count, not ideology" (Proposal `:83`, Playbook `:115`). Must be recorded in the note, not left implicit.
3. **Slice 2 — continuity and correction.** Fresh-session recovery from the state file alone, exactly one bounded correction cycle, clean closure (Proposal `:84`).
4. **Slice 3 — admission discipline.** Direct Work bypass, deferral recording, and the executive "good enough, proceed" behaviour (Proposal `:85`).
5. **Acceptance behaviours must be observable, demonstrable, few** (Playbook `:117`). Each one must name its failing case, because Step 5 builds red-green (Playbook `:130`) — a behaviour with no constructible failing case is not an acceptance behaviour.
6. **Trace each behaviour to a destination behaviour.** Proposal §4 (`:52-58`) states 7 observable destination behaviours; behaviours 1–6 fall inside the three slices (7 is the pilot, Phase 3). Anything in the note not traceable to §4 or the executable core is scope creep and must be cut.
7. **Cross-check against the Phase 4 regression set** (Proposal `:107`). It names 8 behaviours to demonstrate once each — including de-escalation, stale/foreign state-file rejection, and review-goes-stale-on-change. The slice plan must not silently promise behaviours the slices never build, nor omit ones a slice must deliver. Where a regression item is Phase-4-only, say so in the note rather than leaving the gap unexplained.
8. **Amendment already carried:** "Claude commits the state file" supersedes destination behaviour 1's "Codex … commits it" (README `:57-61`). Slice 1's acceptance behaviours must be written against the amended behaviour, not the Proposal's original wording.
9. **Mission-contract contradiction — operator decision.** `logs/missions/work-loop-v2-mvp.md` acceptance assertion 1 still carries the pre-amendment wording, so the mission cannot currently satisfy its own definition of done (session-notes 2026-08-01 S3-19b § Open Questions). Two options: amend the assertion, or accept and record the divergence. Frozen at mission creation — not Claude's call.

## Execution Sequence

1. **Read the frozen set.** Proposal §4 + §5 Phase 2 and Phase 4; Playbook Step 4 and Step 5; the executable core in full; Step 2 conclusions § 2. *Verify:* every slice description and destination behaviour quoted in the note has a line anchor I actually read.
2. **Derive acceptance behaviours per slice.** For each of the three slices, 3–5 behaviours, each written as: observable outcome + its constructible failing case + the destination behaviour or core section it traces to. *Verify:* no behaviour lacks a failing case; no behaviour lacks a trace; count per slice ≤5.
3. **Record the Slice 1 split point** with the concrete boundary (Codex side / Claude side) and the trigger that fires it. *Verify:* the note states what to do, not merely that a split is permitted.
4. **Reconcile against the Phase 4 regression set.** Walk the 8 items; mark each as delivered-by-slice-N or Phase-4-only. *Verify:* all 8 accounted for explicitly.
5. **Write `plans/work-loop-v2-mvp/step-4-slice-plan.md`.** Short note, matching the `step-N-*` convention of the Step 1 and Step 2 notes. Checked against the skill-writing standard's form rules. *Verify:* file exists on disk; three slices present; split point present; regression reconciliation present.
6. **Show the note to the operator** ("glanced at it" is part of Playbook `:119`'s done condition) and **put the mission-contract question** with a recommendation. *Verify:* operator has responded on the contradiction.
7. **Record the resolution** — README § "Decisions taken after v0.4", plus the mission file if the operator amends. *Verify:* README carries a dated line; mission file's frozen prefix unchanged unless the operator authorised the amendment.
8. **Commit; tick the mission's Step 4 thread with evidence** via the `/mission` update-then-check sequence. *Verify:* thread shows `- [x]` with an evidence pointer; frozen prefix byte-identical before and after.

## Scope Alternatives

- **Min:** the three slices with acceptance behaviours + the split point. Drops item 7 (regression-set reconciliation) and item 9 (mission contract).
- **Recommended:** min + regression-set reconciliation + the mission-contract decision put and recorded. This is the mandate.
- **Max:** recommended + draft the Slice 1 state-file fixture (the deliberately-false-premise case) as a concrete artifact. **Rejected** — that is Step 5 implementation work and the Playbook puts it in a fresh session with the live repo inspected at zero planning cost (`:129`).

## Autonomy Posture
Gated

**Stop points:**
- After step 6's note is written — show it to the operator; "the operator has glanced at it" is an explicit exit condition, not an optional courtesy.
- The mission-contract contradiction (item 9). The validation contract is frozen at mission creation and the choice between amending and recording divergence is a governance call with the operator's authority behind it, not a recommended-default. I will state a recommendation, but not act on it unilaterally.
- Any point where an acceptance behaviour cannot be written without a Proposal-level call (mandate `Stop if`).

## Risk
No structural change classes apparent — re-size the review if scope changes. The work product is a plan note plus two record edits; no hooks, permissions, commands, skills, symlinks, or automation are touched, and the environment-fit check does not apply (nothing executable is produced). One thing worth naming without inflating it: editing `logs/missions/work-loop-v2-mvp.md`'s frozen prefix would be a governance edit, which is exactly why it is a stop point above rather than something this session decides. The Step 4 thread tick is a normal `/mission` operation and is not that.
