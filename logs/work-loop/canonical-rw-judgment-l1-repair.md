---
task: canonical-rw-judgment-l1-repair
status: active
turn: codex
---

## Objective and scope

Repair the local Sector Intelligence judgment contract identified by the failed L1 trial, then run
one new genuine L1 trial only after the repaired mechanism passes its deterministic floor. A PASS may
reopen L2 under the approved lean plan; a FAIL stops judgment canonicalization again.

Scope is the bound local Sector trial checkout and this task-state handoff. Excluded: canonical
judgment-layer changes, L2, the lightweight-RW lane (L3), L4, research-gap resolution, report writing,
generic propagation, merge, push, and deployment.

The operator's 2026-08-18 instruction, “yes let's fix it,” authorizes the minimum local-contract
repair and a later repeat L1 trial. It does not pre-approve any judgment content, revoke Decision
B3-28, clear the Step-2 HOLD, or waive any L1 proof condition.

## Lane and unit

Standard. Implementation mode. Unit 1 — enforce the local challenge and promotion contract.

Named reason for the loop: the repair needs independent assessment before it can justify another
consequential genuine trial, and the task must preserve continuity across the implementation and
later trial units.

## Brief

The first L1 trial proved the mechanical chain but failed because the deployed local path omitted the
independent challenge, bare approval survived twelve review findings, and three evidence-permission
breaches entered approved authority. This unit fixes only that local control contract so the next
trial can test representative behavior instead of repeating a known failure.

**Governing authority and current position**

- The approved lean plan is
  `plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md`, with
  material content bound to `8bf9d0d96ca7796621035e3f83b50c9dfc8055ec`. Its L1 terminal rule and
  proof table govern; L2 remains closed unless a new L1 trial passes.
- The authoritative prior outcome is
  `logs/work-loop/canonical-rw-judgment-house-view.md`, closed at `65a51f7f`. Its L1 FAIL, minimum
  local contract, decisions, deferrals, evidence, and accepted limitations remain binding.
- The evidence-only target was recorded as
  `projects/axcion-sector-intelligence-l1-trial`, branch
  `trial/l1-judgment-custom-dev-data-ai`, at `067b208`. This is a repository claim to verify before
  editing, not permission to assume that checkout is unchanged.
- Operator Decision B3-28 remains unrevoked. The Step-2 HOLD remains live.

**Required outcome**

Make the deployed **local** judgment path enforce all of the following between proposal production
and the operator's decision:

1. An independent fresh-context judgment challenge is mandatory, not an optional trial-only action.
2. Every required-change finding receives a durable disposition.
3. Promotion is refused while any required-change finding or conflict with an unrevoked operator
   decision remains unresolved.
4. A genuine judgment choice may proceed through either substantive revision followed by re-review,
   or an explicit operator disposition with reasons.
5. Bare approval cannot convert an evidence-permission breach into approved authority.

Choose the smallest implementation that makes those behaviors true in the existing local workflow.
Do not create a second approval system, a second House View artifact, a new workflow stage, or a new
top-level command.

**Check against repository reality before acting**

1. Verify the exact target checkout, current branch and HEAD, and establish that no other active
   writer owns it. Stop and hand back if it no longer represents the evidence state recorded at
   `067b208`, or if preserving later legitimate work would materially change this unit.
2. Inspect the deployed local `/run-analysis` path and its invoked producer, approval and promotion
   surfaces. Confirm or falsify the prior finding that the live sequence has no mandatory independent
   challenge between proposal and operator decision.
3. Search the local judgment artifact, validator/promotion helper, command path, and their tests for
   durable required-change dispositions, re-review state, unresolved-decision-conflict handling, and
   evidence-permission enforcement. Bound every absence claim to those searched surfaces.
4. Run the four existing judgment suites before editing and report their exact assertion total.
   Confirm or falsify the recorded 90/90 floor.
5. If a load-bearing premise is false, report the inspected evidence and hand back rather than
   silently redesigning the brief.

**Required evidence**

- A pre-fix failing case that demonstrates the missing control rather than merely matching brief
  text.
- Post-fix command-path fixtures showing: an unresolved required-change finding blocks promotion; an
  unresolved conflict with B3-28 blocks promotion; substantive revision requires re-review; a
  properly re-reviewed and explicitly approved result may promote; and bare approval does not clear
  an evidence-permission breach.
- The complete local judgment regression floor green after the change, with exact totals and commands.
- A concise mapping from each of the five required behaviors to the enforcing surface and failing
  fixture.
- The implementation commit in the Sector trial checkout, plus the task-state handback commit here.

**Boundaries and stop conditions**

- Do not run the genuine L1 trial in this unit. That is the next unit only after Codex accepts this
  mechanism and its evidence.
- Preserve the prior trial artifacts as evidence; do not rewrite them into a pass.
- Do not resolve the 47 research gaps, Q15/Q16/GAP-03/GAP-04, GAP-17, the Step-2 HOLD, or B3-28.
- Do not touch canonical judgment resources or any L3/L4 surface.
- Stop if the required behavior cannot be enforced locally without changing canonical authority,
  expanding capability, or overriding an operator-owned decision.

Capability subset: baseline only — local reads and history inspection, edits and tests inside the
bound Sector trial checkout, this task-state handoff, and local commits by Claude. Nothing is selected
from the pre-authorizable set, which is empty today. No operator-reserved capability is needed; no
network, push, merge, deployment, credentials, destructive shared-state action, or policy weakening is
authorized.

Completion condition: the five required local behaviors are implemented and supported by fail-capable
pre/post evidence, all relevant regression suites pass, the implementation is committed in the bound
Sector checkout, and Claude records the exact evidence here with `turn: codex`. Otherwise hand back
the verified blocker or false premise without expanding scope.

## Latest result

Correction round (2026-08-18). Scope was frozen to Codex's two findings; both reproduced by
inspection before anything was changed, and both are resolved. Nothing else was implemented.

**Finding 1 — a later round could forget an earlier finding. Reproduced, then closed.**

Reproduced: built a proposal, wrote a round-1 challenge raising `F1` tagged `permission-breach` and
left it `PENDING` (gate correctly refused, exit 6), revised the proposal, then wrote a round-2
record — same sole `-review.md`, as `/run-analysis` instructed — carrying `findings: none`. The gate
returned `CLEARED` exit 0 and `promote-judgment-brief.sh` wrote the approved brief. The round-1
breach left the record with no disposition and nothing saw it go.

Closed by keeping the rounds. Before a new round is written, the current record is archived at
`{base}-review-round-{N}.md`; `/run-analysis` Step 3b.1 carries the archiving command, and the
reviewer is now told to open the ledger with every finding earlier rounds raised, under its original
id and tags. The gate reads the whole chain: it walks rounds 1..N-1, refuses `LOST-ROUND` (12) if any
archive is missing or its `review_round:` disagrees with its filename, collects every finding id
those rounds raised, and refuses `DROPPED-FINDING` (9) if the current ledger no longer carries one.
A carried-forward finding then meets the ordinary disposition rules, so nothing new was invented to
resolve it. Deleting the archive is not a way out — an unreadable round is refused, never read as
having raised nothing.

**Finding 2 — a decision could clear a conflict with itself. Reproduced, then closed.**

Reproduced: a finding tagged `decision-conflict: B3-28`, disposed `OPERATOR-ACCEPTED` with
`decision-ref: B3-28` and a one-line reason, cleared at exit 0 and promoted — while B3-28 remained
unrevoked. The gate had only checked that `decision-ref:` was non-empty.

Closed at the smallest enforceable point. `decision-ref:` must now name at least one decision
identifier, and at least one that is **not** among the decisions named in that finding's
`decision-conflict:` tag. The explicit reason requirement is unchanged. Deliberately bounded: this is
a circularity check on the reference, not a judgment that the named decision actually settles the
conflict — that stays with the operator and the written reason, and the gate's message says so. No
operator decision was invented, revoked or interpreted; B3-28 appears only as fixture text.

Evidence:

- **Pre-correction reproductions, both promoting.** `f1`: round 1 raises the breach → exit 6; revise;
  round 2 writes `findings: none` → `verdict: CLEARED` exit 0 → approved brief written. `f2`:
  `decision-ref: B3-28` against `decision-conflict: B3-28` → `verdict: CLEARED` exit 0 → approved
  brief written. Both ran against the then-committed `ba7e37a` mechanism.
- **Post-correction, the same two fixtures.** `f1` → `verdict: DROPPED-FINDING`, *"earlier round(s)
  raised F1 and round 2's ledger does not carry it"*; with the archive deleted instead →
  `verdict: LOST-ROUND`. `f2` → `verdict: UNRESOLVED-DECISION-CONFLICT`, *"finding F1 cites B3-28 as
  what resolves a conflict tagged against B3-28 — a decision cannot clear a conflict with itself."*
  Promotion refused in both, nothing written.
- **The fixtures Codex asked for, each paired with its control.** J36 — round 1 raises it, the
  proposal is revised, round 2 omits it → 9, and J36b/J36c show promotion refused with nothing
  written. J37 — the identical two rounds with the finding carried forward and resolved by the
  re-review → 0, and promotion proceeds. J38 (archive deleted) and J39 (archive mislabelled) → 12.
  J40 — the conflicting decision cited as its own resolution → 8, promotion refused, nothing written;
  J41 (prose padded around the same id) and J42 (a reference naming no decision) → 8; J44 (a conflict
  against two decisions, one of them cited) → 8. J43 is the control: a superseding decision, plus the
  reason, clears at 0. Each refusal has a positive control, so neither new rule is a gate that
  refuses everything.
- **Nothing broke.** Full judgment floor, run from the Sector checkout root:
  `check-judgment-contract.test.sh` 17/0 · `check-judgment-gate.test.sh` 16/0 ·
  `check-judgment-producer.test.sh` 41/0 · `check-judgment-propagation.test.sh` 16/0 ·
  `check-judgment-challenge.test.sh` 55/0. **Total 145 passed, 0 failed**, every suite exit 0. Prior
  floor was 130/130; the four original suites hold their exact counts and the challenge suite went
  40 → 55. Three of its existing fixtures (J20, J28, and the round-2 half of the chain cases) gained
  a round-1 archive, which is the new contract applying to them, not an assertion relaxed.
- **Scope.** Three files changed: `.claude/commands/run-analysis.md`,
  `logs/scripts/check-judgment-challenge.sh`, `logs/scripts/check-judgment-challenge.test.sh`. The
  Unit 1 implementation is preserved — `promote-judgment-brief.sh`, the producer suite and the
  template are untouched this round. `git status --porcelain -- analysis/
  logs/l1-judgment-trial-record.md` is empty, so the prior trial artifacts remain unmodified. No
  genuine L1 trial run, no canonical or L3/L4 surface touched, no research gap, HOLD or operator
  decision resolved, no push or merge.
- **Commits.** Correction `9e3242b` on `trial/l1-judgment-custom-dev-data-ai` in
  `projects/axcion-sector-intelligence-l1-trial`, on top of Unit 1's `ba7e37a`. This handback is the
  commit carrying this file.

**Newly noticed, recorded as candidate deferrals, not implemented** (correction scope was frozen):

- The round archives are ordinary files in the working tree. The gate proves a round exists and is
  labelled correctly; it cannot prove an archive was not edited after the fact. Git history records
  any such edit, and a hash chain across rounds would close it inside the gate — a change to the
  record format, well outside two frozen findings.
- `decisions_checked:` is not cross-checked against the decisions the findings actually tag. A
  reviewer could tag `decision-conflict: B3-28` while listing only `B3-1` as screened. Cheap to add,
  but it is a third rule and this round is frozen to two.

The three deferrals recorded in Unit 1 — the `## Theses`-down drift guard, the template's stale
line-133 note, and the reviewer being dispatch text rather than a named agent — stand unchanged.

## Blocker

None.

## Next action

Codex: run the closure check on the two frozen findings only — are finding 1 (an earlier
required-change finding can no longer be dropped by a later round) and finding 2 (a decision cannot
clear a conflict with itself) resolved, and did the correction break anything? The floor answers the
second: 145/145 green, the four pre-existing suites at their exact prior counts. Two newly noticed
items are recorded above as candidate deferrals and were not implemented.
