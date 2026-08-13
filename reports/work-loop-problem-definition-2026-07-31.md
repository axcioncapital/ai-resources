# Work Loop Problem Definition

**Date:** 2026-07-31  
**Repository:** `ai-resources`  
**Observation baseline:** `6050a5b` on `main`  
**Purpose:** Explain, in plain language, the problem that must be fixed in `/work-loop`

## The problem in one sentence

`/work-loop` describes a careful handoff between Claude, Codex and the operator, but it does not reliably prove that everyone is planning, changing, reviewing and approving the same exact version of the work.

That makes the workflow look more controlled than it actually is.

## What `/work-loop` is supposed to do

The command is intended to coordinate substantive repository work between three parties:

- **Claude** plans and implements the change.
- **Codex** independently reviews the plan and the completed implementation.
- **The operator** makes the important approval decisions.

For high-consequence work, the current design uses these phases:

1. **Frame** — establish the real need and verify the premise.
2. **Shape** — write the implementation plan and have Codex review it.
3. **G1** — the operator approves the plan and scope.
4. **Build** — Claude implements the approved slices.
5. **Prove** — test the result and have Codex review it.
6. **G2** — the operator decides whether the implementation is fit to stand.
7. **Land/G3** — decide whether to adopt, hold or reject it.

This is a sensible model. Independent review has already demonstrated its value: in the review-layer consolidation stream, Prove and Codex found important defects that four Build sweeps had missed.

The problem is that the command does not enforce the model strongly enough.

## What “not enforced strongly enough” means

The command contains many correct instructions:

- write the brief before doing the work;
- review the plan before G1;
- keep Claude as the single writer;
- run one bounded correction pass;
- mark completed units complete;
- review the implementation before G2; and
- retain enough evidence to resume the stream.

However, most of these are prose instructions. The command does not consistently check that they are true before it advances.

For example, G1 currently receives “the plan” and “the review.” It does not check that the review names the exact plan version being approved. If Claude revises the plan after Codex reviews it, the command can still present the revised, unreviewed plan at G1.

The same identity problem exists at G2. The gate receives evidence and a review, but it does not prove that the repository's current final commit is exactly the candidate Codex inspected. A later correction can change the candidate without automatically invalidating the review.

In plain English: the workflow checks that a plan and review exist, but not always that they belong to each other.

## What happened in real use

The recent streams exposed several concrete failures.

### 1. An unreviewed final plan reached G1

In stream `2026-07-29-prime-minimum-responsibility`:

1. Claude wrote plan v1.
2. Codex reviewed it.
3. Claude wrote plan v2.
4. Codex reviewed it and found material architectural problems.
5. Claude responded by writing materially different plan v3.
6. Plan v3 received no Codex review.
7. G1 nevertheless approved plan v3 as Build's execution contract.

The workflow technically contained Codex reviews, but the final approved plan was not the plan Codex had reviewed.

This is the highest-priority defect because it defeats the purpose of pre-implementation review.

### 2. Required records were missing without the command stopping

In stream `2026-07-29-review-layer-consolidation`:

- Build-3 and Build-4 had evidence but no briefs.
- Builds 1–4 lacked `Status: complete`.
- Shape lacked its normal closure evidence.
- Shape review-2 was never written to the repository.
- Prove also received a retrospective brief rather than a brief written before the work.

The command's resume logic depends on those files and markers. Their absence made the stream partially invisible and unresumable.

The missing records were later reconstructed where possible, but that only repaired reachability. It could not make brief-first planning or independent review happen retroactively.

### 3. Two sessions wrote the same stream

Two Claude sessions operated on the same stream and worktree at the same time.

One session made decisions using repository state that changed while it was working. The sessions happened not to overwrite each other, but only because they noticed the collision and stopped.

The contract says Claude is the single writer. There is no reliable ownership mechanism that prevents a second session from becoming another writer.

### 4. Prove changed the work it was supposed to judge

Prove is meant to test and evaluate the Build result. Instead, the Prove session also repaired object files while producing and adjudicating its evidence.

That caused three problems:

- the reviewed candidate moved during review;
- the reviewer and repairer became the same working session; and
- the corrections had no contemporary correction brief.

The repairs may have been good, but the workflow could no longer claim that the final repaired result had received an independent review.

### 5. Searches passed while the underlying cleanup remained incomplete

Four Build units reported that their cleanup sweeps were clear. Prove later found 24 surviving references to the retired review machinery.

The Build checks mainly searched for specific command-shaped text. They missed the same concept expressed as:

- field names;
- prose instructions;
- step names;
- verdict tokens;
- hook filenames;
- generated examples; and
- producer/consumer contracts.

The command asks for evidence, but it does not require the evidence to preserve the exact working directory, search scope, exclusions, positive controls and concept variants needed for another session to reproduce the claim.

### 6. The correction limit has no clear terminal outcome

The authorities currently say both:

- a unit has “at most one review round”; and
- a justified `review-2` may occur after corrections.

They do not say clearly what happens if `review-2` still finds a material problem requiring another change.

Without a defined stop condition, the workflow can drift into repeated review and correction cycles—the exact behavior the bounded model is supposed to prevent.

## The common cause behind these failures

These incidents look different, but they share one cause:

> `/work-loop` tracks documents and phases by human-readable names and instructions when it needs a small, enforceable state machine built around exact identities and transition checks.

The workflow currently lacks five guarantees.

### Guarantee 1: exact object identity

The system must know exactly which plan Codex reviewed and exactly which final commit Codex reviewed.

“Plan v3” is not enough. The review must identify the plan's path and immutable Git/content identity. The release review must identify the approved base commit and exact final candidate commit.

### Guarantee 2: one authoritative working state

The task's need, plan, scope, decisions, worktree, owner, current phase, evidence, limitations and next action are spread across chat, temporary artifacts and Git history.

One lightweight repository record must say what the task currently is. A fresh Claude or Codex session must be able to continue using repository files and Git state without relying on the old conversation.

### Guarantee 3: one implementation writer

A substantive task needs a dedicated worktree and an explicit current writer. A second session must be unable to claim the same stream silently.

Codex should inspect that same worktree directly, but remain read-only toward the implementation.

### Guarantee 4: enforced phase boundaries

Shape may change the plan, Build may change the object, and Prove may test and judge it.

If Prove finds a defect, the workflow should open one explicit correction pass. Prove should not quietly become another Build phase.

### Guarantee 5: fail-closed transitions

Before G1, G2 or the next phase, the command must mechanically verify that all required artifacts, identities, status markers and ownership conditions are valid.

If something is missing or mismatched, it must stop immediately. It should not continue and repair the paperwork retrospectively.

## What Codex's role needs to become

Codex should remain independent and read-only toward Claude's implementation. Its responsibility needs to be broader and more explicit.

### Before implementation

Codex should review the exact final plan for:

- whether it solves the original need;
- whether repository assumptions were actually verified;
- whether it fits the project's mission and architecture;
- whether it is the smallest sufficient solution;
- whether the instructions are precise enough to implement;
- whether scope and exclusions are clear;
- whether interfaces and consumers were considered; and
- whether acceptance and falsification criteria can genuinely prove failure.

Claude still authors the plan. Codex owns the independent instruction-quality judgment.

### After implementation

A fresh Codex task should inspect Claude's actual worktree and review:

- the complete base-to-final diff;
- compliance with the approved plan;
- technical correctness;
- reproducible tests and evidence;
- unrelated or out-of-scope changes;
- mission-level fit;
- system-wide and meta-level effects;
- duplicated mechanisms and unnecessary complexity;
- operator burden and maintainability; and
- unresolved limitations.

Codex should not approve from Claude's summary or selected extracts when it can inspect the actual repository.

## What the fixed workflow must guarantee

The repaired command is useful only if it guarantees all of the following:

1. G1 can approve only the exact plan version most recently reviewed by Codex.
2. A material plan revision requires the one permitted closure review.
3. A wording-only correction does not cause unnecessary review churn.
4. G2 can approve only the exact final commit Codex reviewed.
5. Any candidate change after review makes that review stale.
6. Every substantive task runs in a recorded task worktree from an approved base.
7. Only one Claude session owns implementation writes at a time.
8. Codex can directly inspect the same task worktree.
9. One repository working-state record is enough for a fresh session to continue.
10. Briefs, plans, evidence, reviews and completion markers are checked before advancing.
11. Prove cannot edit the implementation it judges.
12. One bounded correction pass exists.
13. If the closure review still finds a material problem, the stream stops and is reframed; it does not start review-3.
14. Negative and zero-result checks include a positive control and reproducible scope.
15. The existing three operator gates remain exactly G1, G2 and G3.
16. Small solo work stays lightweight.

## What this problem is not

This is not a request to:

- remove independent Codex review;
- replace Claude as the implementer;
- add more operator gates;
- create unlimited Claude/Codex loops;
- create three new permanent planning documents;
- require a heavy worktree process for every trivial edit;
- rewrite historical evidence so old streams appear compliant; or
- replace the useful premise-verification, proportional-routing, positive-control, vertical-slice and lifecycle concepts already present.

The goal is to make the existing good model enforceable.

## Practical consequence right now

The current `/work-loop` should not control a new substantive challenged implementation, especially not the implementation of its own repair.

Until the core defects are fixed, substantive work should use a supervised temporary process:

1. create one task worktree from a recorded base;
2. keep one Claude session as the sole writer;
3. store the approved specification and current working state in that worktree;
4. have Codex review the exact specification;
5. let Claude implement and test;
6. have a fresh Codex task inspect the actual worktree and complete diff;
7. allow one bounded correction pass;
8. stop and reframe if a material issue remains; and
9. merge only the exact clean candidate Codex reviewed.

## Definition of the problem being solved

The repair is complete when `/work-loop` is no longer merely a set of good instructions. It must become a small, auditable controller that can prove:

- what was approved;
- what was changed;
- who currently owns the work;
- what Codex actually reviewed;
- whether the candidate changed afterwards;
- what evidence supports release;
- whether the correction budget is exhausted; and
- what a fresh session should do next.

That is the problem this work-loop remediation needs to solve.

## Evidence and related specification

This report is self-contained, but the repository contains the supporting record:

- `docs/work-loop.md` — current shared contract.
- `.claude/commands/work-loop.md` — current Claude-side controller.
- `.agents/skills/work-loop/SKILL.md` — current Codex-side controller.
- `logs/decisions.md` — durable account of the review-layer consolidation failures and retrospective recovery.
- Git commit `b8ef77f` — recoverable closed-stream artifacts for that consolidation.
- Branch `session/2026-07-29-work-loop` at `544a0f5` — historical investigation of the G1 exact-plan defect; evidence only, not a current implementation base.
- `reports/work-loop-remediation-report-2026-07-30.md` — detailed prioritized repair specification and regression-test matrix.

