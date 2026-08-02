---
task: context-engineering-implementation-plan
turn: codex
---

## Objective and approved scope
Produce one self-contained, execution-ready **draft implementation plan** for
`plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`. The plan must guide the later
implementation across fresh sessions and make progression depend on observable evidence.

Write the plan to
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.
It remains non-governing until the operator explicitly approves it. This unit plans only: do not
implement Context Engineering, change the specification's approval status, or edit any Work Loop
runtime artifact.

## Lane and unit
Standard. Unit 1 — inspect the live implementation surface and draft the implementation plan.

Named reason for the loop: the plan must survive several later sessions, the implementation scope
needs bounding before work starts, and Codex must assess the result independently before it counts as
ready for operator approval.

## Brief
Why: the specification is behaviourally detailed but deliberately does not authorize or sequence its
implementation. The operator needs a durable plan that lets each later session take one bounded,
observable slice without reconstructing design history or prematurely wiring the live Work Loop.

Check against the repository before drafting:

1. The specification header still says `draft specification — awaiting operator approval` and `not
   requirements`; no later source has promoted it to governing implementation authority. Inspect the
   specification header and `logs/decisions.md`.
2. `logs/decisions.md` records that the earlier integration mandate was withdrawn because Claude alone
   could not produce CE-17's integrated two-model proof; the retry must first design the two-model
   session shape. Inspect that decision and the named continuity scratchpad.
3. The live v2 surface currently consists at least of the executable core, Claude command, Codex skill,
   and acceptance harness. Inspect each rather than treating the scratchpad's proposed three-file seam
   as settled architecture.
4. The specification defines CE-1 through CE-17, including the isolated-versus-integrated proof split,
   and forbids new runtime QC passes, gates, per-run records, a second state system, and a Wayfinder
   ticket network. Re-derive this from the specification.
5. The attached proposal snapshot is byte-identical to the canonical successful MVP proposal at
   `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`. Treat the canonical file as the reference
   authority for planning form; treat both Matt Pocock documents as non-governing principles, not as a
   lifecycle that must be copied wholesale.

Required outcome: one plan that a fresh Claude session can execute without relying on this conversation.
Use the successful MVP proposal's strengths: a concise situation, settled constraints, an observable
destination, evidence-gated phases, thin vertical slices, explicit exits, standing anti-scope rules,
and an exact next session. Fold the useful session-map detail into this same plan; do not create a
second playbook.

The plan must:

- state its authority and draft status, the implementation objective, boundaries, exclusions, and what
  would falsify success;
- identify the verified live implementation surface and distinguish observed facts from proposed
  implementation choices;
- sequence the riskiest unknown or seam first, then tracer-bullet slices that each produce one complete,
  observable result and fit a fresh implementation session;
- map every CE-1…CE-17 behaviour to a planned slice and a constructible failing case or proof, without
  turning the document into a sentence-by-sentence restatement of the specification;
- keep the isolated Context Engineering proof distinct from the integrated Work Loop proof, and place
  the integrated/adoption step only in a genuinely two-model operator-driven session after isolated
  proof and an explicit progression decision;
- cover every relevant Work Loop entrypoint before any adoption claim, while keeping transport mechanics
  outside Context Engineering's own implementation boundary;
- preserve the one-touch objective, semantic authority hierarchy, durable-source limits, one-artifact
  handoff, proportional discovery, fresh-session recovery, and Codex/Claude/operator ownership split;
- define per-phase/session inputs, one job, expected repository output, evidence capable of failing,
  exit condition, stop condition, and the exact next-session handoff;
- leave reversible technical details to implementation sessions unless live evidence makes one
  load-bearing, and identify any consequential or still-open choice for the operator instead of silently
  deciding it;
- include the planned candidate review, real trial, integrated proof, hardening-from-evidence, adoption
  decision, and stop point without adding a runtime context-QC pass or permanent planning machinery;
- name accepted limitations and deferred work with reopening triggers, and end with the first execution
  session—not with implementation performed in this unit.

Required evidence returned in this state file:

1. An inspection record for all five claims above, naming the paths and observations.
2. A CE coverage check derived from the unique CE identifiers in the specification and in the completed
   plan; report any difference. Numeric presence is only the first control—also cite the plan section
   where each behaviour is assigned a failing case or proof.
3. A boundary audit showing where the plan handles each explicit prohibition from specification §7 and
   CE-16. A prohibition mentioned only as something to build is a failure, not coverage.
4. A fresh-session executability check against the plan's first implementation session: identify its
   named inputs, one job, output, failing evidence, stop condition, and next handoff. If any depends on
   this chat, the plan is not ready.
5. The exact committed path list. It may contain only this state file, the three operator-source snapshots
   already placed in the context-engineering folder, and the new plan. Preserve and do not stage any
   unrelated pre-existing working-tree changes.

Stop and hand back without drafting past the issue if a load-bearing premise is false, the plan would
need to decide a consequential operator choice, the source authority cannot be reconciled, or the work
would require editing the specification, runtime files, tests, mission, decisions log, or another file
outside the paths allowed above.

## Latest material result

**Correction round 1 — all four frozen findings reproduced, then corrected.** The prior round's inspection
record and five evidence items are not repeated here; they are in commit `ab28c66` (core §4: the state
file is current truth, Git holds history).

Reproduced (2026-08-02), by inspection, before any edit:
- Finding (1): REPRODUCES — `grep -n "Repository output:"` over the plan returned 12 lines. S1–S7 output
  only `trials/*` evidence and fixture files; the first line naming a live runtime file is S8's
  (`.agents/skills/...`, core, command). Confirmed: nothing changed between a slice's failing case and its
  passing case, so Phase 2 could not turn any case green.
- Finding (2): REPRODUCES — plan `:433-434` read *"every relevant entrypoint invokes the capability, **or**
  the uncovered ones are named as a stated limitation"*; O-3 at `:218` read *"or accept a stated
  limitation"*; §11 at `:560` the same; and the Phase 4 decision offered *"adopt with stated limitations"*.
  Four places, one escape hatch.
- Finding (3): REPRODUCES — S8's evidence line `:401` listed greps, an item count, an unchanged ceiling
  and a clean diff. All four can pass on a diff that never runs. Direct Work and false-premise preservation
  appeared in the *exit* line as "verified intact", with no construction behind them.
- Finding (4): REPRODUCES — the header `:9` says *"Two approvals are therefore outstanding"*, but Phase 0
  (`:232-238`) and §12 (`:773`) named only the specification's. `grep -n "successor record"` returned one
  hit at `:469`, undefined anywhere in the document. No line named what records the live phase across
  S1–S12; the `Next:` lines are static plan ordering.

Result: all four corrected in
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`
(579 → 807 lines). What changed, per finding:

1. **A named candidate now exists and evolves.** New §4.4 names it: `trials/candidate/SKILL.md`, a working
   revision of the Codex skill held outside the live path — a revision of an existing artifact, not a new
   kind, deleted at S8b when its content lands. Phase 2's preamble states the red–green cycle explicitly
   (run the failing case against the current candidate → revise → run the *same* case against the revised
   one), and **every Phase 2 session gained a `Candidate change:` line** naming the family it adds. S2 now
   states how the two carriages are installed (they are not — both sit under `trials/candidate/`, pointed
   at by path, with `git diff` on the live skill required empty) and what survives (one file; the loser is
   deleted, not archived, because a kept alternative is plan-history machinery). §4.4 adds three checkable
   fixture rules: a mandatory `FIXTURE —` first line, a placement ban on any path a real project's
   discovery reaches, and an S7 grep for the marker outside `trials/`.
2. **The entrypoint bar is now a condition, not a preference.** Phase 3 gained **S8a**, whose only job is
   to classify every access path relevant/not-relevant against a stated three-part test, with the observed
   condition as evidence and a fail-safe rule (unsettleable → relevant). Phase 3's exit now has three
   required conditions and no "or named as a limitation" branch. The Phase 4 decision became a four-row
   condition table, and states that "adopt with stated limitations" is unavailable for conditions 2–4.
   §11 gained a rule about what may appear in it at all; the `axcion-design-studio` and v1 rows were
   **removed from the limitations table** and are now decided in S8a and adoption condition 3. O-3's
   consequence column was rewritten to remove the limitation option.
3. **S8b proves the seam behaviourally before anything structural counts.** Its evidence is now ordered:
   (i) a constructed pre/post invocation at the real entrypoint — same seeded request, recorded failing
   before the wiring and exhibiting the behaviour after, with a green-without-recorded-red run failing the
   session; (ii) Direct Work as an observed **absence of a state file**, not an assertion; (iii)
   false-premise refusal with the named target file confirmed unmodified; (iv) *then* the greps, counts
   and ceiling check. A boxed note under S9 states the review follows this pass and does not substitute
   for it.
4. **Both approvals, and one named current-state record.** Phase 0 now requires two approvals — the
   specification's, recorded in the specification; this plan's, recorded in a new empty slot in the plan's
   header — each bound to identifiable content, with material-edit demotion stated for both. Phase 0 also
   names `logs/work-loop/context-engineering-implementation.md`, the existing task-state interface, as
   what carries the live phase, latest result, blocker and next action across S1–S12 — spec §5.7 category
   three, no new state system — and says the state file, not the plan's static `Next:` lines, is the live
   position. `successor record` is deleted; S12 now writes limitations into that state file's closing
   record in core §4's closure shape. §12 restated as two Phase 0 answers.

Evidence: `grep -c "Candidate change:"` → **5** (S3–S7, one per Phase 2 session);
`grep -c "trials/candidate/SKILL.md"` → **10**; `grep -c "successor record"` → **0**;
`grep -c "logs/work-loop/context-engineering-implementation.md"` → **4**. The two surviving
`stated limitation` hits are both prohibitions (`"a stated limitation cannot discharge it"`, `"deliberately
not an option"`), not permissions — checked by reading each. Regression on the untouched controls:
`comm -3` over unique `CE-n` identifiers in specification and plan is **empty** (17/17 preserved), and
§8's table still carries **17** rows.

**One deferral, recorded and not done.** The plan grew 579 → 807 lines in this round. Whether it is still
inside its own §1 claim — self-contained and executable by a fresh session without design history — is a
fair question, and compression is outside these four frozen findings. Not attempted. Reopening trigger: an
implementation session reports that reading the plan cost more than the orientation it saved.

## Unresolved blocker
None.

## Next action
Codex: run the closure check on the four frozen findings and nothing else — are (1) the isolated
candidate, (2) the entrypoint adoption bar, (3) S8b's behavioural seam evidence and (4) the two-approval
and current-state chain resolved, and did the correction break anything? Per core §3 that check asks those
two questions only; anything newly noticed becomes a deferral, not a second round. One deferral is already
recorded above (plan length, 579 → 807). If the correction is judged insufficient, the post-correction
menu is chosen once, on value and risk — and if that choice is really about accepting risk, it is the
operator's.
