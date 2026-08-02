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

Inspected (2026-08-02):
- Claim (1): HOLDS — read `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md:3`; the header still
  reads `**Stage:** draft specification — awaiting operator approval · **Status:** not requirements`, and
  the authority notice at `:5-8` still states "nothing here authorises implementation". Searched
  `logs/decisions.md` for `context.engineering|CE-1[0-9]|withdraw|premature`; the 2026-08-02 entry at
  `:90` closes with an explicit **"Not decided here"** clause on whether the stage header flips, recording
  the approval as scoped *"for this implementation unit"*. Searched the repository (`*.md`, `*.sh`,
  excluding `.git/`) for `context-engineering-spec-v0.1`; the only non-log reference is this state file.
  `logs/session-plan-2026-08-02-S4-510.md:10` calls it "the approved spec" — but that is the plan file of
  the session whose mandate was withdrawn, and it names commit `148689d` content, not the file, so it
  promotes nothing. **No source promotes the specification to governing implementation authority.**
- Claim (2): HOLDS — read `logs/decisions.md:90-121`. It records the mid-session withdrawal, the operator's
  words *"implementation call was premature by codex"*, the rationale that the demonstration "cannot be
  produced by Claude working alone" because Codex is operator-driven in the ChatGPT app, the citation to
  CE-17's two-proofs table, and under **Consequence for the retry**: *"A future attempt must be structured
  as a genuinely two-model session."* Read the named continuity scratchpad
  `logs/scratchpads/2026-08-02-13-08-scratchpad.md` in full; its `resume_with` line reads *"Do NOT resume
  the CE integration solo … first decide the two-model session shape, not the code."*
- Claim (3): HOLDS — inspected each of the four surfaces directly, not the scratchpad's summary of them:
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (300 lines, read in full),
  `.claude/commands/work-loop-v2.md` (113), `.agents/skills/work-loop-v2/SKILL.md` (116, read in full),
  `logs/scripts/work-loop-v2-slice-1.test.sh` (673, header and assertion set read). The claim's "at least"
  is doing real work: a symlink-following sweep (`find -L`) over the workspace found **three** access
  paths to the one Claude command file and **two** to the one Codex skill file, and a plain `find` misses
  the third because `axcion-design-studio/.claude/commands` is a symlinked directory. Work Loop **v1**
  (`.claude/commands/work-loop.md`, `docs/work-loop.md`) is also still live. The full inventory is the
  plan's §4.2; the scratchpad's three-file seam was not treated as settled.
- Claim (4): HOLDS — re-derived from the specification, not from recall. `grep -o 'CE-[0-9]*' | sort -u`
  returns exactly 17 identifiers, CE-1…CE-17, no gaps. The isolated-versus-integrated split is the boxed
  two-proofs table under CE-17 (§6 Family 1), stating a real adoption claim requires the integrated proof
  and the isolated one "must never be presented as the integrated one". §7 excludes a separate context-QC
  pass including a risk-triggered one, a new backlog/register/log, a second project-state system, and a
  Wayfinder ticket network is absent from §7 by name but rejected in the MVP proposal's settled decision 8
  — CE-16 carries the per-run and new-machinery prohibitions.
- Claim (5): HOLDS — `shasum -a 256` on
  `plans/work-loop-v2-v0.2/context-engineering/work-loop-v2-mvp-proposal-v0.4-reference.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` both return
  `9822e196764b5321051b6b402633d94e17dbed652e30ea4f93040bd5f78fe3e1`; `cmp` reports no difference. The
  canonical file was used as the reference authority for planning form. Both Matt Pocock documents were
  read and treated as non-governing principles; no lifecycle was copied.

Result: the plan was drafted and written to
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` (579 lines).
It is explicitly draft and non-governing, records that approval must bind to identifiable content rather
than to the filename, and ends at the first execution session with no implementation performed.

**Evidence 2 — CE coverage check.** Derived by `grep -o -E 'CE-[0-9]+' | sort -u` over the specification
and over the plan, compared with `comm`. Spec: 17 unique ids. Plan: 17 unique ids. **Both set differences
are empty** — nothing missing, no invented identifier. Numeric presence is not the control: the plan's §8
assigns each behaviour to a slice, a named session, a constructible failing case and the evidence that
distinguishes pass from fail (17 table rows, counted). Assignments: CE-1/2/3 → Slice A · S3; CE-4/5/6 →
Slice B · S4; CE-7/8/9 → Slice C · S5 (instrument built in S1); CE-10/11/12/13/14 → Slice D · S6;
CE-15 → S3, re-confirmed S7; CE-16 → Slice E · S7; **CE-17 → S3 for clauses 1–2 and S11 for clause 3**,
which is the isolated/integrated split kept apart by construction.

**Evidence 3 — boundary audit.** Plan §9 tabulates all fifteen §7/CE-16 prohibitions against an *active*
handling, not a mention. Representative rows: a context-QC pass is a **falsification criterion** in §5.2
and fires S6's stop condition; a second state system is refused by S8's evidence requirement that the
five-field ceiling be unchanged and by its stop condition; approval artifacts are avoided because Phase 0
records approval *inside the specification*, bound to content; transport is proved in S11 by observing
delivery, never by building it, and S2's stop condition routes a transport fact to the operator;
**no CE trial depends on `work-loop-v2-slice-1.test.sh`**, honouring §7's rejection of a harness
dependency — it appears only in S12's Work Loop regression check. The prohibition on shrinking behaviour
because packaging is hard is held by Phase 1's boxed note: a carriage failure escalates, and only §9's
acid test in a real trial shrinks anything.

**Evidence 4 — fresh-session executability of the first implementation session (S1).** *Inputs:* this
plan, spec §3.5, §5.7 and CE-9, plus re-verification of §4.1's facts — all repository paths, none of them
this conversation. *One job:* construct one seeded CE-9 scenario whose durable sources carry a material
fact the request message does not. *Output:* `trials/ce-9-recovery-scenario.md` plus its seeded sources.
*Failing evidence:* two greps — the seeded fact must hit in the durable sources and miss in the request
text; if it appears in the request the instrument is broken and the session has failed. *Stop condition:*
if no such fact can be seeded, stop and report CE-9 as possibly unmeasurable. *Next handoff:* the operator
runs S2 with Codex. **Nothing in S1 depends on this chat.**

**Evidence 5 — exact committed path list** (`git add` by explicit pathspec, five paths, nothing else):
- `logs/work-loop/context-engineering-implementation-plan.md`
- `plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`
- `plans/work-loop-v2-v0.2/context-engineering/work-loop-v2-mvp-proposal-v0.4-reference.md`
- `plans/work-loop-v2-v0.2/context-engineering/matt-pocock-style-principles.md`
- `plans/work-loop-v2-v0.2/context-engineering/matt-pocock-wayfinder-led-project-development-lifecycle.md`

The pre-existing unrelated working-tree change to `logs/friction-log.md` was **not** staged and remains
modified in the tree.

**One deferral, recorded and not done.** The Work Loop v2 mission thread describing
`axcion-design-studio` as holding *"a copy of the command"* is imprecise — live inspection shows it
reaches the same bytes through a symlinked `commands/` directory, and what it actually lacks is the Codex
skill and `logs/work-loop/`. Correcting `logs/missions/work-loop-v2-mvp.md` is outside this unit's allowed
paths, so it was not touched. The corrected fact is recorded in the plan's §4.2 and §11 instead.

## Unresolved blocker
None.

## Next action
Codex: assess the plan at
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` against the
brief's eleven requirements and the five returned evidence items — close, correct once, or stop. Two
things need a decision rather than an assessment: the plan hands **four** operator decisions up (§6),
of which O-1 (does the specification become governing?) gates every later phase; and the plan states that
the integrated CE-17 proof cannot be obtained without a genuinely two-model operator-driven session.
