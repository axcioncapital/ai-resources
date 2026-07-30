# Work Loop Remediation Report

**Date:** 2026-07-30  
**Repository:** `ai-resources`  
**Status:** Ready to become the implementation specification  
**Subject:** What must be fixed before `/work-loop` is reliable for substantive delegated work

## Executive verdict

The central idea behind `/work-loop` is good: Claude plans and implements, Codex independently challenges the plan and the completed result, and the operator retains three consequential decisions. The recent stream also proved that independent review has real value: Prove and Codex found material defects that four Build sweeps had missed.

The command is not yet a reliable controller for substantive work. It currently expresses several critical invariants as prose but does not verify them before advancing. That allowed an unreviewed final plan to reach G1, units to exist without required briefs or completion markers, two sessions to write the same stream, Prove to modify the object it was supposed to judge, and a release package to reach G2 without an independently reviewed final candidate.

This is an orchestration failure, not evidence that the two-model approach is wrong. The useful parts should be retained, but challenged work should not rely on the present command until the fail-closed repairs in this report are implemented and tested.

## Intended operating model

For substantive reviewed or challenged work, the finished system should operate as follows:

1. The operator supplies the need and source context.
2. Codex verifies the premise and frames what success must mean.
3. Claude writes a repository-resident implementation plan in a dedicated task worktree.
4. Codex independently reviews the exact plan version for instruction quality, project fit, proportionality, acceptance criteria and falsification design.
5. G1 approves that exact reviewed plan and no other version.
6. Claude is the sole implementation writer in the task worktree.
7. Claude produces reproducible evidence against the approved criteria.
8. Codex opens the same worktree and reviews the actual final candidate: the complete diff, tests, repository state, mission fit and meta-level system effects.
9. One bounded correction pass is permitted. If it cannot close the material findings, the stream stops and is reframed; it does not enter an unlimited review loop.
10. G2 decides whether the exact reviewed candidate is fit to stand. G3 decides its lifecycle outcome.

Chat is only the transport between the models. Git and repository files are the authoritative state.

The following four operator requirements are therefore in scope and remain required:

- Codex owns the independent quality check on the instructions and plan, while Claude remains the planner and writer.
- Codex reviews both mission fit and the meta-level effect of the complete implementation diff, not only whether individual evidence claims look plausible.
- Codex directly inspects Claude's actual task worktree and final candidate.
- Every substantive reviewed or challenged task has one lightweight, durable working-state record sufficient for a fresh session to continue without chat history.

## What failed in the live use of the command

These are observed failures, not hypothetical edge cases.

| ID | Observed failure | Consequence |
|---|---|---|
| F1 | Shape plan v3 materially changed the architecture after Codex review-2, received no further Codex review, and still reached G1. | G1 approved a plan that no independent reviewer had assessed. |
| F2 | Build-3 and Build-4 had evidence but no briefs; Builds 1–4 lacked `Status: complete`; Shape lacked closure evidence; Shape review-2 was never transcribed. | The stream became unresumable and required retrospective paperwork. The record cannot honestly prove brief-first ordering or a complete review chain. |
| F3 | Two sessions wrote the same stream in the same worktree. | Ownership became ambiguous and one session made decisions from stale state while another committed changes. |
| F4 | Prove changed object files while producing and adjudicating its own evidence, without a contemporary correction brief. | The final repairs were self-reviewed, the review target moved, and the correction boundary disappeared. |
| F5 | Four Build sweeps declared the migration clear, but Prove later found 24 surviving references, including broken producer/consumer contracts. | Token-shaped searches were mistaken for proof that the underlying concept had been removed. |
| F6 | Falsifiers were not all run as written; some lacked working directories or positive controls; fired criteria were initially reported as clear. | G2 could not reliably distinguish a passing result from an incomplete or mis-scoped check. |
| F7 | Review and correction rules conflict: a unit is described as having “at most one review round,” while `review-2` is permitted, and no terminal rule says what happens when the closure review still finds material problems. | The command has no deterministic non-convergence outcome and invites ad hoc extra cycles. |
| F8 | G2 identifies evidence and a review, but not an immutable base-to-final candidate. Changes can occur after review without automatically invalidating the release package. | The operator can approve code different from what Codex reviewed. |
| F9 | Non-capability streams rely on temporary `logs/loop/` files and conversation. Those files are deleted when the stream closes, and there is no single working-state manifest for handoff or recovery. | A fresh session cannot reliably reconstruct scope, ownership, decisions, exact candidate and next action from the current tree alone. |
| F10 | The command declares a single writer but has no exclusive ownership or worktree lease. Existing concurrent-session protection can degrade in a handoff-resumed session. | A prose rule did not prevent the exact concurrent-writer failure it names. |
| F11 | The command can be used to change commands and hooks, but its own “never” list forbids editing hooks and settings, while its shared contract treats existing configuration and hooks as possible work objects. | Scope authority is contradictory, and self-modification is not safely defined. |
| F12 | The existing acceptance checks were largely plan text and ad hoc shell checks, not an executable regression suite. | The same orchestration defects can return without a deterministic test failing. |

The durable record of the largest live failure is in `logs/decisions.md`, in the entries for `2026-07-29-review-layer-consolidation`. The closed stream artifacts remain recoverable in Git at `b8ef77f`; the stream's object-edit commits are recorded there. The earlier G1 defect investigation remains useful as historical evidence on branch `session/2026-07-29-work-loop` at `544a0f5`, but it is based on an older repository state and must not simply be resumed as the implementation branch.

## Root causes

The failures have a small number of common causes:

1. **Names are used where immutable identity is required.** “The plan,” “the evidence,” and “the review” do not identify a file version or candidate commit.
2. **Transition rules are descriptive rather than fail-closed.** The command says what should exist, then advances without validating that it does.
3. **State is fragmented.** Briefs, plans, evidence, reviews, Git state and chat each hold part of the truth; no one record says what the stream presently is.
4. **Writer ownership is asserted but not enforced.** A second live session can enter the same stream and worktree.
5. **Phase permissions are not enforced.** Prove is described as judgment, but nothing prevents it from repairing the object it judges.
6. **Correction and non-convergence are ambiguous.** The system has a correction budget but no explicit terminal state when the budget is exhausted.
7. **Review scope is too narrow.** The Codex controller reviews evidence mechanics well, but it does not yet define separate, complete methods for plan quality and final implementation review.
8. **Tests do not exercise the state machine.** The most important guarantees are not protected by executable failure cases.

## Required fixes

The fixes below are ordered. P0 items are release blockers for substantive challenged use. P1 items are required for the command to deliver the intended quality. P2 items preserve proportionality and complete adjacent routing.

### P0.1 — Bind G1 to the exact independently reviewed plan

Every Shape plan revision must have an immutable identity consisting of:

- repository-relative path;
- Git commit SHA;
- blob SHA or content hash; and
- revision number.

Every Shape review must name that exact identity in its header. Before G1, `/work-loop` must compare the plan being presented with the plan named by the latest valid independent Codex review. A mismatch is a hard stop, not a warning.

Changes to architecture, scope, acceptance criteria, falsification criteria, interfaces or verification design are material. A materially revised plan re-arms the permitted closure review. Wording, spelling, formatting and other changes that do not change execution or judgment are non-material; they must be recorded but must not create review churn.

G1 must be impossible when the final plan identity has not been independently reviewed. The held package should display the exact plan and review identities, not merely their names.

### P0.2 — Define one bounded correction cycle and a terminal non-convergence outcome

Reconcile all statements about “one review round,” `review-2` and “one correction pass” into one rule:

- One initial independent review is normal.
- One bounded correction pass is permitted for material findings.
- A closure `review-2` occurs only when the correction changed something on which the first verdict depended.
- If `review-2` finds a material defect requiring another object or plan change, the unit enters `hold-reframe`. It may not produce `review-3` inside the same unit.
- Resuming requires a new bounded Shape unit or a new stream with an explicit scope decision. This uses the existing next gate; it does not add a fourth operator gate.

Findings should be classified as blocking, bounded-correction or non-blocking. Settled decisions may not be reopened without new evidence. Review is against the approved acceptance criteria, not a new reviewer preference.

### P0.3 — Require a task worktree and enforce exclusive ownership

All substantive challenged work must run in a dedicated task worktree created from an approved base commit. Reviewed work should use one when it changes a shared resource, crosses a meaningful file boundary or is expected to span sessions. Solo work remains eligible to use the current working tree.

The live repository is the stable authoritative reference. The task worktree is the implementation and review environment. It must contain the approved plan, source context, candidate changes, tests and evidence. It must not depend on uncommitted state elsewhere.

The stream state must record:

- worktree path;
- task branch;
- approved base commit;
- current candidate HEAD;
- current writer session/owner; and
- ownership timestamp or lease state.

Claude is the sole object writer. Codex gets read access to the same worktree but remains read-only toward the candidate. A second writer must be rejected while ownership is live. A handoff must explicitly release and acquire ownership; it cannot be inferred from a new chat. Stale-owner recovery needs a deterministic rule and a recorded operator decision.

Before G2, the command must verify the correct base, a bounded base-to-HEAD diff, no unrelated branch changes, a clean worktree, no relevant untracked dependencies, and reproducible tests run from that worktree.

### P0.4 — Add one durable working-state manifest

Create one lightweight state file for each substantive reviewed or challenged stream. Do not create three new permanent planning documents. A single manifest is enough.

Suggested path:

`logs/loop/{STREAM}.state.md`

It must contain:

- original need and intended outcome;
- authoritative source documents and verified premises;
- approved scope and Build slices;
- exact approved plan and review identities;
- current phase and unit;
- worktree path, branch, base and current candidate HEAD;
- current writer ownership;
- material decisions and their evidence;
- rejected and deferred decisions;
- completed and outstanding work;
- validation already run;
- known issues and limitations;
- artifact index with status; and
- exact handoff state and next action.

Update it after planning, any material scope change, every ownership handoff, every independent review, before a session ends, and at G1/G2/G3. A fresh Claude or Codex session must be able to continue correctly using only this file, its referenced repository files and Git state.

The manifest is temporary while work is active. At terminal close, its essential history and artifact commit pointers must be copied into the durable decision or development record before temporary stream artifacts are deleted.

### P0.5 — Validate every state transition atomically

Add a small deterministic validator and make `/work-loop` call it before opening, closing or advancing a unit. The command itself should continue to own judgment; the validator should own mechanical invariants.

Suggested implementation:

- `scripts/check-work-loop-state.sh` — validates artifact presence, identity, status, ownership and Git state;
- `scripts/tests/test-work-loop-state.sh` — fixture-driven regression cases for the state machine.

Required transition checks:

- A unit brief exists and is committed before work or evidence begins.
- Brief and evidence may not be created as a retrospective combined shortcut.
- Every completed unit has `Status: complete` and a manifest entry.
- G1 has the final plan, its exact Codex review and complete adjudication.
- G2 has criterion-by-criterion evidence, the exact final candidate, its Codex review, complete adjudication, limitations and a clean worktree.
- A missing brief, review, status marker or identity stops before the next phase opens.
- Stream close first writes durable pointers for every required artifact and candidate commit.
- Paused, held and rejected streams retain enough state to resume or audit; they are not cleaned up as successful closes.

The validator must fail closed with a plain-language explanation and the exact missing or conflicting paths. It must never repair historical artifacts automatically.

### P0.6 — Enforce phase mutation boundaries

The phases need executable permissions, not only descriptions:

- **Frame:** source reading and need definition only.
- **Shape:** plan and state artifacts only; no target-object changes.
- **Build:** target-object changes only within one approved slice.
- **Prove:** read, test and evidence only; no target-object changes.
- **Correction:** one explicit unit/pass with a contemporary brief, named allowed paths and the remaining accepted findings.
- **Land:** lifecycle and durable-record changes only.

If Prove finds a defect, it records the finding and opens the one correction pass. It does not repair the object it is judging. After correction, all affected proof is rerun against the new final HEAD. Any candidate commit after Codex's final review invalidates that review automatically.

### P0.7 — Make falsification evidence reproducible

Shape must assign a stable ID to every acceptance and falsification criterion. Prove must produce one ledger row per ID containing:

- the exact command or inspection;
- working directory;
- paths and exclusions defining scope;
- expected observation;
- actual observation;
- positive control for every negative or zero-result check;
- verdict; and
- disposition if the criterion fired.

Prove may not reinterpret or rename an immutable criterion to turn a failure into a pass. If the original criterion was badly formed, it remains a disclosed limitation and is dispositioned honestly.

Reference migrations must be checked by concept and contract shape, not only by the literal command token. The plan should enumerate relevant forms such as prose instructions, schema fields, step names, verdict tokens, filenames, generated examples and producer/consumer pairs. Count-based criteria must preserve their exact query and exclusions so another session can reproduce the count.

### P0.8 — Bind G2 to the exact independently reviewed candidate

The Prove review must identify:

- approved base SHA;
- final candidate HEAD SHA;
- base-to-HEAD diff scope;
- evidence artifact identity; and
- test/evidence run being reviewed.

The review must inspect the actual task worktree, not Claude's summary or selected extracts. G2 must verify that current HEAD still equals the reviewed HEAD. Any target-object commit after review makes the package stale and requires the permitted closure review or a hold-reframe outcome.

Review files remain verbatim Codex-authored transcriptions. Claude's evidence may summarize a review for navigation, but the review artifact is authoritative. Verdict, finding counts and materiality must be mechanically consistent between the G2 package and the review file.

### P1.1 — Expand Codex's controller into two explicit review methods

`.agents/skills/work-loop/SKILL.md` should define two different reviews.

**Shape plan review** must cover:

- whether the original need is correctly understood;
- whether repository assumptions and premises were actually verified;
- alignment with the project's mission, architecture and governing documents;
- smallest sufficient solution and proportionality;
- instruction clarity and implementation precision;
- bounded scope and explicit exclusions;
- interface and consumer impacts;
- acceptance and falsification quality;
- verification feasibility; and
- unnecessary machinery or project drift.

Codex owns this independent instruction-quality judgment. Claude still authors and revises the plan.

**Prove implementation review** must cover:

- compliance with the approved plan and original need;
- technical correctness;
- the complete base-to-HEAD diff;
- reproducibility and adequacy of tests;
- repository cleanliness and branch suitability;
- mission-level fit;
- meta-level effects on the larger operating system;
- duplicated mechanisms, hidden operator burden and unnecessary complexity;
- maintainability, observability and ability to retire the change; and
- honest residual limitations.

Planning review and red-team implementation review should occur in separate Codex tasks with fresh conversational context. Both rely on the same durable repository evidence. Neither relies on the other task's memory.

### P1.2 — Define a safe self-hosting rule

`/work-loop` must not change the active contract under which its own stream is running.

When the object is `docs/work-loop.md`, `.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md`, the validator or related worktree/ownership machinery:

- run the controller from a stable control checkout pinned to the pre-change commit;
- perform implementation in a separate task worktree;
- record the controlling contract commit in the state manifest;
- do not reload or switch to edited instructions midstream; and
- review and land the new controller as a candidate, then use it only in a later stream.

Resolve the present scope contradiction as part of this change. Existing hooks, scripts and settings may be valid target objects when explicitly in scope; the command's “never edits hooks or settings” blanket prohibition conflicts with the command's own stated purpose and the shared contract. Protected files should be governed by explicit scope and risk rules, not an inaccurate absolute ban.

### P1.3 — Add merge-readiness checks to G2

In addition to correctness, G2 must answer whether the branch is suitable to merge:

- Was the task worktree created from the approved base?
- Is the complete diff visible and bounded to the approved work?
- Does the branch contain unrelated commits or changes?
- Are there relevant changes outside the task worktree?
- Does the implementation depend on untracked or uncommitted files elsewhere?
- Can tests be reproduced from inside the task worktree?
- Are generated artifacts and evidence present?
- Is the final candidate operationally ready for adoption?

After merge, rejection or deliberate archive, remove or archive the task worktree under the repository's normal branch-retention policy. It must not become a permanent parallel repository.

### P2.1 — Preserve proportionality

Do not impose the challenged route on every edit.

- **Solo:** small, reversible, single-repository work remains one unit with no worktree manifest or independent review unless a trigger fires.
- **Reviewed:** one final independent review; use a task worktree and state manifest when the work is shared, multi-session or otherwise substantive.
- **Challenged:** dedicated worktree, state manifest, Shape review, Prove review and all three existing gates.

Passing reviews create no additional confirmation. The operator gates remain exactly G1, G2 and G3.

### P2.2 — Repair rough-note intake separately

This is a separate bounded follow-up, not part of the controller safety repair.

`/leverage-idea` should remain the rough-note distiller. Its output should record the intended outcome, evidence versus assumptions, constraints and open questions. Repair, extend or build recommendations should hand off a ready `/work-loop` brief; the leverage analysis must not become a parallel implementation plan or bypass premise verification and review.

## File-level implementation map

| File | Required change |
|---|---|
| `docs/work-loop.md` | Become the unambiguous authority for exact plan/candidate identity, materiality, bounded correction, hold-reframe, worktree ownership, state manifest, phase permissions, G1/G2 packages, self-hosting and close retention. Remove the contradiction between one review round and `review-2`. |
| `.claude/commands/work-loop.md` | Create/update the state manifest, invoke mechanical validation at every transition, enforce worktree ownership and phase boundaries, present exact identities at gates, and stop on stale or incomplete packages. |
| `.agents/skills/work-loop/SKILL.md` | Add the full Shape instruction-quality review and Prove technical/mission/meta-diff review. Require direct access to the exact task worktree and immutable object identity. |
| `scripts/check-work-loop-state.sh` | New minimal validator for artifact order, identity, ownership, phase, status and Git-state invariants. It performs no subjective review and no automatic historical repair. |
| `scripts/tests/test-work-loop-state.sh` | New deterministic regression suite using temporary fixture repositories/worktrees. |
| `logs/loop/{STREAM}.state.md` | Generated per substantive active stream from one schema defined in the contract; not a new permanent planning-document family. |
| `.claude/commands/leverage-idea.md` | Later, separate change: route build/repair/extend outcomes into a ready `/work-loop` brief. |

No historical stream artifact should be rewritten to make old work appear compliant with the new rules.

## Required regression tests

The implementation is not complete until these cases are executable and passing:

| Test | Expected result |
|---|---|
| Material plan v2 is presented after only plan v1 was reviewed. | G1 is blocked and names the identity mismatch. |
| A reviewed plan receives spelling or formatting corrections only. | G1 proceeds without another review; the non-material change is recorded. |
| Review-2 still finds a material issue requiring a plan/object change. | Unit enters `hold-reframe`; no review-3 is allowed. |
| A Build evidence file exists without a committed brief. | Transition stops immediately; no retrospective brief is fabricated. |
| A completed unit lacks `Status: complete`. | Next phase cannot open. |
| A required review file is absent or its identity does not match its object. | Gate is blocked. |
| A second session attempts to acquire a live stream/worktree. | It is rejected with the current owner named. |
| The task worktree base differs from the approved base. | Build/G2 is blocked. |
| A fresh session has only repository files and Git state. | It identifies the correct phase, owner, candidate and next action without chat. |
| Prove modifies a target-object path. | The mutation is blocked or the unit is invalidated and routed to the correction pass. |
| A negative falsifier lacks a positive control, working directory or scope. | G2 is blocked with the missing field named. |
| One acceptance/falsifier ID has no evidence row. | G2 is blocked. |
| A target-object commit lands after Codex review. | G2 reports a stale review and cannot proceed. |
| Claude's summary disagrees with the Codex review verdict or material finding count. | G2 uses the review artifact and blocks the inconsistent package. |
| The task worktree is dirty or depends on relevant untracked files. | G2 is blocked. |
| A small two-file solo fix is run. | It remains lightweight; no challenged-only machinery appears. |
| `/work-loop` edits its own authorities. | The active stream remains pinned to the old controller and reviews the new one only as a candidate. |
| A stream pauses or is held. | Artifacts and state remain reachable and resumable. |
| A stream closes. | Durable pointers are written before temporary files are removed. |

## Safe implementation sequence

Do not implement all of this as one large self-modifying `/work-loop` stream. Use the temporary operating rule below and land small, independently reviewed slices.

1. **Core gate integrity:** exact plan identity, exact candidate identity, review provenance, materiality and the bounded non-convergence rule.
2. **State and ownership:** dedicated worktree policy, exclusive writer ownership and the single state manifest.
3. **Mechanical enforcement:** validator, atomic transition checks, phase permissions and G2 cleanliness/merge readiness.
4. **Review quality:** expand the Codex controller with instruction, mission and meta-level diff review.
5. **Regression and pilots:** executable state-machine tests plus real pilot streams.
6. **Separate intake follow-up:** repair `/leverage-idea` handoff after the core controller is stable.

The historical `session/2026-07-29-work-loop` branch can supply evidence and wording for step 1, but it must be re-derived against current `main`. It should not be merged or resumed as if concurrent changes had not happened.

## Definition of done

The repaired command is ready for normal substantive use only when:

- every P0 item is implemented;
- the Codex Shape and Prove review methods in P1.1 are implemented;
- all regression cases above pass;
- the current three-gate model remains intact;
- no permanent trio of new planning documents was introduced;
- a reviewed small-fix pilot completes without retrospective artifacts;
- a challenged multi-file pilot proves both material-plan re-review and wording-only non-churn;
- an interrupted/resumed pilot continues from repository state alone;
- a concurrent-writer attempt is rejected;
- a correction pass terminates either in an independently reviewed candidate or `hold-reframe`; and
- a fresh Codex task can inspect the actual final worktree and reproduce the release conclusion without access to prior chat.

## Temporary operating rule

Until the P0 repairs and tests land, do not use the current `/work-loop` to control a new substantive challenged implementation, especially not its own repair.

Use this supervised temporary flow instead:

1. Create one fresh task worktree from a recorded base commit.
2. Keep one Claude session as the only writer.
3. Store one approved specification and one working-state file in the worktree.
4. Have Codex review the exact specification before implementation.
5. Let Claude implement and test once.
6. Have a fresh Codex task inspect the actual worktree, base-to-HEAD diff and tests.
7. Permit one bounded Claude correction pass and one closure review only if the reviewed basis changed.
8. If a material issue remains, stop and reframe; do not keep cycling.
9. Merge only the exact clean candidate Codex reviewed.

This temporary method preserves the valuable two-model separation without trusting the state machine that still needs repair.

## Non-goals

This remediation must not:

- add a fourth operator gate;
- create unlimited Codex/Claude review cycles;
- make Codex the implementation writer;
- create three new permanent planning documents;
- force a dedicated worktree and full manifest onto every trivial solo edit;
- rewrite historical evidence to appear compliant;
- combine the `/leverage-idea` intake correction with the core safety repair; or
- replace the current premise-verification, positive-control, proportional-routing, resumability, vertical-slice and lifecycle concepts that already work.

The goal is to make those concepts enforceable, auditable and safe under real interruptions, revisions and handoffs.
