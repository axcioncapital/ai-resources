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

Inspected (2026-08-18):

- Claim (1): HOLDS — `git -C projects/axcion-sector-intelligence-l1-trial rev-parse` returns branch
  `trial/l1-judgment-custom-dev-data-ai` at `067b208`, matching the recorded evidence state;
  `git status --porcelain` was empty, so nothing was staged or in flight. `git worktree list` shows
  five worktrees on this object store and **only this one is on that branch** — the other four are
  `codex/florian-demo-continue` (`d0cb658`) and three detached Codex worktrees (`15ffb11`, `3a3bbc1`,
  `8ac3149`). No other active writer owns it, and no later legitimate work needed preserving.
- Claim (2): HOLDS — the prior finding is confirmed. Read `.claude/commands/run-analysis.md` end to
  end: the live sequence is Step 3a (producer dispatch → `--allow-proposed` shape check) → Step 3b
  (operator approval → `promote-judgment-brief.sh`) → Step 3c (`check-judgment-contract.sh` on the
  approved path). Nothing runs between production and the operator's decision. Searched
  `.claude/commands/run-{analysis,synthesis,report}.md`, the four `check-judgment-*.sh` helpers,
  `promote-judgment-brief.sh`, their four test suites,
  `reference/templates/unit-judgment-brief-template.md` and `reference/analyst-judgment-standard.md`
  for `judgment.challenge|independent (semantic )?challenge|challenge (agent|review|record|pass)|
  fresh.context challenge`; **no match**. Repo-wide, `judgment.challeng|challenge.judgment` matches
  nothing outside the preserved trial artifacts under `analysis/` and `logs/l1-judgment-*`. The
  trial's reviewer existed only as a granted capability; its own provenance note says so.
- Claim (3): HOLDS as four bounded absences, over the same fourteen surfaces listed above.
  `required.change|disposition` — no match. `re.review|rereview` — no match.
  `unrevoked|decision.conflict|conflicting operator decision|B3-[0-9]` — no match.
  `permission.breach|breach` — no match. So the deployed path carried no durable required-change
  disposition, no re-review state, no unresolved-decision-conflict handling, and no
  evidence-permission enforcement.
- Claim (4): HOLDS — the 90/90 floor is confirmed exactly. Before any edit, run from the Sector
  checkout: `check-judgment-contract.test.sh` 17/0, `check-judgment-gate.test.sh` 16/0,
  `check-judgment-producer.test.sh` 41/0, `check-judgment-propagation.test.sh` 16/0. Total
  **90 passed, 0 failed**, all four exit 0.
- Claim (5): not triggered — no premise was false, so the unit proceeded.

Result: the five required behaviors are enforced in the deployed local path. `/run-analysis` Step 3b
now runs an independent fresh-context challenge (3b.1) before the operator halt (3b.2), records a
durable disposition per required-change finding (3b.3), and promotes only after that (3b.4). A new
`logs/scripts/check-judgment-challenge.sh` is the gate, and `promote-judgment-brief.sh` calls it as a
hard precondition — new verdict `CHALLENGE-UNCLEARED`, exit 11 — so the refusal sits at the single
transition that creates downstream authority rather than in prose. The template's "what is wired"
note is corrected; it previously described the pre-repair sequence. Committed in the Sector checkout
at `ba7e37a`. The prior trial artifacts are byte-unchanged: `git status --porcelain -- analysis/
logs/l1-judgment-trial-record.md` is empty.

**Behavior → enforcing surface → failing fixture**

| # | Required behavior | Enforcing surface | Fixture that fails without it |
|---|---|---|---|
| 1 | Independent challenge is mandatory | `check-judgment-challenge.sh` exit 3 `NO-CHALLENGE`; `/run-analysis` Step 3b.1; promotion hook | J1, J26, J29–J32 (live), J34/J35 control pair |
| 2 | Durable disposition per finding | ledger grammar + exit 6 `UNRESOLVED-FINDING` | J14 (`PENDING`), J15 (no reason), J16 (undeclared status) |
| 3 | Promotion refused while unresolved | promote exit 11, delegating to the gate | J25 (undisposed breach), J27 (post-clearance revision), J18 (B3-28 conflict, no decision named) |
| 4 | Revise-and-re-review **or** operator disposition with reasons | `reviews_sha256` binding + the two terminal dispositions | J2 (revision breaks the binding), J13 (round 1 cannot re-review), J19 (accepted with `decision-ref`), J20 (revised, confirmed round 2) |
| 5 | Bare approval cannot launder a breach | exit 7 `LAUNDERED-BREACH` | J17, and J25 end to end |

Re-review is mechanical rather than promised: each challenge round binds to the sha256 of the bytes
it reviewed, so revising the proposal invalidates its own clearance and the next round must run. J2
and J27 are what prove it.

Evidence:

- **Pre-fix failing case, on the real trial artifacts** — the L1 failure reproduced before any edit.
  Copied `analysis/judgment/custom-dev-data-ai/…-proposed.md` and its preserved `…-review.md` (8
  findings requiring change; its own bottom line reads *"it should not be approved in its current
  form … Those three are permission breaches"*) to a scratch directory and ran the then-current
  `promote-judgment-brief.sh` with `--approval "approved"`. Result: `verdict: PROMOTED`, exit 0, the
  approved brief written. A second case with the review removed entirely: also `PROMOTED`, exit 0.
  Neither the presence of the challenge nor its findings changed anything, which is the missing
  control, not a restatement of the brief.
- **Post-fix, same real artifacts, three variants** — (a) proposal with no conforming challenge →
  exit 11, reason `no readable independent challenge …`; (b) the real review with its eight findings
  transcribed into the ledger, undisposed → exit 11, reason `8 of 8 required-change finding(s) … are
  still 'PENDING'`; (c) all eight accepted by fiat, exactly what the trial did → exit 11, reason
  `finding F1 is tagged 'permission-breach' and disposed 'OPERATOR-ACCEPTED' — an approval cannot
  convert an evidence-permission breach into approved authority`. Nothing was written in any of the
  three. The trial's own approved brief was never regenerated; these ran on copies.
- **The evidence can fail, shown two ways.** J34 removes the promotion hook from a copy of the script
  and the identical unchallenged proposal promotes at exit 0 again; J35 restores it and the same
  proposal is refused at 11. J28 is the positive control — a proposal whose breach was revised and
  confirmed in round 2 promotes normally, so the gate is not one that refuses everything.
- **Regression floor, green, run from the Sector checkout root** —
  `bash logs/scripts/check-judgment-contract.test.sh` 17/0 ·
  `check-judgment-gate.test.sh` 16/0 · `check-judgment-producer.test.sh` 41/0 ·
  `check-judgment-propagation.test.sh` 16/0 · `check-judgment-challenge.test.sh` 40/0.
  **Total 130 passed, 0 failed**, every suite exit 0. Pre-fix total was 90/90; the four original
  suites hold their exact prior counts, and the 40 new assertions are the fifth suite.
  `check-judgment-producer.test.sh` gained fixture setup only — a `write_cleared_challenge` helper,
  because promotion now legitimately requires a cleared challenge — and lost no assertion.
- **Commits** — implementation `ba7e37a` on `trial/l1-judgment-custom-dev-data-ai` in
  `projects/axcion-sector-intelligence-l1-trial`, touching six files:
  `.claude/commands/run-analysis.md`, `logs/scripts/check-judgment-challenge.sh` (new),
  `logs/scripts/check-judgment-challenge.test.sh` (new),
  `logs/scripts/check-judgment-producer.test.sh`, `logs/scripts/promote-judgment-brief.sh`,
  `reference/templates/unit-judgment-brief-template.md`. This handback is the commit carrying this
  file.

**Deferrals — recorded, not implemented.** Three adjacent improvements were noticed and left alone
because none is required by this unit's completion condition:

- `promote-judgment-brief.sh`'s CONTENT-DRIFT guard still covers only `## Theses` downward, leaving
  the pre-thesis HOLD preamble unguarded. This was already a deferral in the closed task, and the new
  `reviews_sha256` binding now covers the *challenge*'s view of the whole file, which narrows the
  exposure without closing it. Widening the drift guard is a separate change to a surface this unit
  was not asked to alter.
- The template's *"Still not wired"* note at line 133 remains stale — a recorded deferral from the
  closed task. Only the "what is wired" note, which this unit made actively false, was corrected.
- The challenge dispatch is specified as instruction text rather than an agent definition. A named
  reviewer agent would make independence a property of the harness instead of the dispatch, but that
  is a new resource and the brief's smallest-implementation constraint rules it out here.

**Boundaries observed.** No genuine L1 trial was run. No trial artifact was rewritten. Nothing was
touched in the 47 research gaps, Q15/Q16/GAP-03/GAP-04, GAP-17, the Step-2 HOLD or B3-28 — B3-28
appears only as a fixture tag in the new suite and as an example in documentation. No canonical
judgment resource and no L3/L4 surface was modified. No push, merge or deployment.

## Blocker

None.

## Next action

Codex: assess whether this mechanism and its evidence justify opening the repeat genuine L1 trial as
Unit 2 — in particular whether the five behaviors are enforced where it matters rather than only
described, whether the sha-binding re-review route is a sound reading of the closed task's "either
substantive revision followed by re-review, or an explicit operator disposition with reasons", and
whether the three recorded deferrals are correctly held back rather than trial-blocking.
