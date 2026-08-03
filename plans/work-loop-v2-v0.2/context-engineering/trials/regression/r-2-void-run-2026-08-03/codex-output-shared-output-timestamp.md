---
task: shared-output-timestamp
turn: claude
---

## Objective and approved scope
Define one shared representation for timestamp values in the outputs of Quarry, Tinder,
Pinfold, Kestrel, Millrace, Saltmarsh, Oxbow and Fernpath so their weekly logs can be
combined without manual format reconciliation.

The task covers timestamp values inside active output records only. It does not cover
output filenames, run schedules, output destinations, row ordering, retry behaviour,
retention, or other schema fields. Fernpath remains JSON-feed-only unless the operator
explicitly changes the 2026-07-30 decision.

## Current lane and unit
Standard. Unit 1 — prepare a decision-ready shared timestamp contract and eight-tool
impact map; do not implement it.

Named reason for the loop: the scope crosses eight separately governed tools and contains
conflicting claims, so it needs bounding and independent assessment before any plan or
tool is changed.

## Brief
Why: Dana currently reconciles timestamp formats by hand when combining a week's logs.
The exact shared syntax and timezone policy are not yet settled, so the first observable
unit is a proposal the operator can approve without reopening unrelated tool decisions.

Check these premises against the live workspace before proceeding:

1. `decisions.md` settles whole-second precision on 2026-07-14 and makes Fernpath's JSON
   feed its only active publication path on 2026-07-30.
2. Tinder's approved plan says its timestamps are already ISO-8601 with an offset, but
   `tinder/sample-output.md` shows epoch seconds instead.
3. Pinfold's current acceptance condition requires every timestamp to carry an explicit
   UTC offset, while Quarry's approved outcome specifies `DD/MM/YY HH:MM` in site-local
   time.
4. Kestrel's offset-free local-time format is explicitly proposed and unsettled. The
   three files in `inbox/` are raw or third-party material, not settled decisions; one of
   them explicitly says not to act on the epoch-seconds idea.
5. No exact cross-tool timestamp syntax or timezone policy is settled elsewhere in the
   supplied workspace. For this absence claim, search `decisions.md`, all eight tool
   folders (including Tinder's sample and Saltmarsh's rollout), and all three inbox notes.

If the premises hold, return in this state file:

- one concrete recommended contract, including exact syntax, timezone/offset semantics,
  precision, and a representative timestamp;
- an authority-aware impact map covering all eight named tools, showing current evidence,
  the change each would need, and any conversion input that is not yet known;
- a short explanation of how the recommendation satisfies the settled whole-second and
  explicit-offset constraints while avoiding the known reconciliation problem; and
- alternatives or raw suggestions that were rejected or deferred, with the source and
  reason, so they are not mistaken for decisions.

Evidence required: (1) a read-only inventory that independently accounts for exactly the
eight named tool folders and every supplied decision/inbox evidence file; (2) the completed
eight-row impact map; and (3) a normalization check using the observed Tinder epoch form
and Quarry local form that either produces the recommended representation or exposes the
missing conversion fact. The normalization check must distinguish a conforming
whole-second value with the required timezone information from a millisecond value and an
offset-free value; a check that accepts all three is not evidence.

Do not edit `decisions.md`, any tool plan, rollout, sample output, or tool behaviour in this
unit. Stop and hand back if a premise is false, the workspace contains a ninth tool output
in scope, the recommendation would require overriding another settled decision, or the
required evidence cannot be produced without inventing a timezone or other conversion
fact.

## Next action
Claude: validate the state file and every premise read-only, then prepare the bounded
proposal and required evidence if they hold. Write the latest material result into this
state file, set `turn: codex`, and commit the state file.
