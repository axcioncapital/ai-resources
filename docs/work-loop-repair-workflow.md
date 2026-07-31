# Work Loop Repair Workflow

**Status:** Active temporary authority for the `/work-loop` repair program  
**Established:** 2026-07-31  
**Repository:** `ai-resources`  
**Purpose:** Govern the diagnosis, design, implementation, review and adoption of repairs to `/work-loop` across multiple sessions without asking the current `/work-loop` to control its own repair.

## 1. Authority and lifetime

This workflow governs the `/work-loop` repair program until the operator closes that program. It is a repair-time control document, not a replacement for the finished `/work-loop` contract.

For this repair program, authority resolves in this order:

1. explicit operator decisions and the active task handoff;
2. this workflow;
3. the current approved slice brief and exact approved plan;
4. the remediation evidence and historical records named below;
5. the existing `/work-loop` authorities as objects under repair, not as the controller of their own repair.

The active `/work-loop` command and skill must not be invoked to govern changes to:

- `docs/work-loop.md`;
- `.claude/commands/work-loop.md`;
- `.agents/skills/work-loop/SKILL.md`;
- the future validator, state, ownership or routing mechanisms that enforce those authorities.

Once G1 approves a repair slice, this workflow is frozen for that slice. A proposed change to this workflow is handled as a later operator-approved slice; it does not silently change the rules under which active work is running.

This workflow depends on no off-repository SOP. If an external review or session SOP is later supplied, its useful rules may be considered for a future slice, but an unavailable document is never an operative transition condition.

## 2. Repair anchor

The first repair slice is anchored as follows:

| Field | Value |
|---|---|
| Repair | `/work-loop` reliability |
| Worktree | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan` |
| Branch | `codex/2026-07-31-g1-reviewed-plan-invariant` |
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` |
| Opening commit | `bfa3315` |
| Active stream | `2026-07-31-g1-reviewed-plan-invariant` |
| Active unit | `2026-07-31-g1-reviewed-plan-invariant-frame` |
| Active brief | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.brief.md` |

These values bind the current conversation and worktree. A later slice receives its own explicit binding. Values from `main`, another worktree, another stream or another pasted block do not replace this binding.

## 3. Evidence base

The repair program begins from evidence already established in:

- `reports/work-loop-remediation-report-2026-07-30.md`;
- the 2026-07-29 `review-layer-consolidation` entries in `logs/decisions.md`;
- the historical G1 investigation on branch `session/2026-07-29-work-loop` at `544a0f5`;
- the current authorities in the dedicated repair worktree;
- the first-slice brief named in § 2.

Historical artifacts establish what happened. Current code and current execution establish what is true now. Historical evidence must not be rewritten to make an old stream appear compliant with rules that did not yet exist.

## 4. Governing model

The repair follows:

> **Observe → Clarify → Confirm → Diagnose → Select slice → Shape → G1 → Build → Verify → G2 → Use → G3 → Close**

The process becomes deeper only when evidence requires it. Small, settled corrections stay bounded. Shared-state, identity, ownership and transition changes receive the stronger controls their consequences justify.

The model has two independent classifications:

### 4.1 Response classification

This says what kind of response the demonstrated problem warrants:

- **No change** — not confirmed, already fixed, acceptable, duplicated or not worth changing.
- **Bounded repair** — cause understood, correction local or clearly bounded.
- **AI-resource redevelopment** — the resource follows its current instructions, but its behavioural contract must change.
- **Structural project** — ownership, architecture or dependent decisions are too broad for coherent bounded redevelopment.

The `/work-loop` repair program is **AI-resource redevelopment**. `/work-loop` is an existing resource whose useful model is retained while its behavioural contract and enforcement are corrected. It is not a new project and does not warrant Wayfinder unless later evidence exposes unresolved multi-session design fog.

### 4.2 Assurance classification

This says how much independent assurance a particular change needs:

- **solo** — small, reversible and locally judgeable;
- **reviewed** — one meaningful result review;
- **challenged** — exact plan review before implementation and exact candidate review after implementation.

Response and assurance are separate axes. A bounded repair may still be challenged when it changes Git, shared infrastructure or another high-consequence mechanism. AI-resource redevelopment is not automatically one assurance level; the actual slice determines it.

The current G1 repair slice is challenged.

## 5. Roles

### 5.1 Operator

The operator owns:

- the original observed problem and intended behaviour;
- practical consequence and priority;
- acceptable trade-offs;
- G1, G2 and G3;
- adoption, hold, rejection and reframe decisions;
- permission to expand a slice materially.

The operator is not expected to diagnose repository mechanics or certify technical correctness.

### 5.2 Main Codex control room

The main Codex task:

- helps express the problem without assuming the cause;
- identifies the next uncertainty or outcome to resolve;
- challenges whether evidence supports the diagnosis;
- protects proportionality and exclusions;
- helps compare repair options;
- prepares bounded handoffs;
- interprets evidence for the operator;
- remains read-only toward Claude's candidate.

Because it participates in framing and interpretation, the main Codex task is not the formal independent reviewer.

### 5.3 Claude repository engineer

Claude:

- verifies every premise against the live repair worktree;
- determines repository truth and technical design;
- writes the plan;
- is the sole implementation writer;
- implements only the approved slice;
- produces reproducible evidence;
- maintains branch, worktree and commit discipline;
- may reject an inaccurate Codex premise with evidence.

Claude does not authorize its own consequential change.

### 5.4 Fresh Codex reviewer

A fresh Codex task performs the formal independent review for challenged work:

- Shape review inspects the exact plan identity;
- Prove review inspects the exact implementation candidate in the actual task worktree;
- both reviews remain read-only toward the candidate;
- neither relies on the main task's conversational memory;
- each review states the exact object it inspected.

Claude transcribes a returned review verbatim when the repository requires a review artifact. Claude may adjudicate findings but may not rewrite the reviewer’s words.

## 6. Session and routing binding

### 6.1 One conversation, one active unit

A conversation is bound to one active repair unit. That binding may change only when:

- the operator explicitly replaces or closes the active unit; or
- the active unit reaches its defined transition and the operator authorizes the next one where required.

A pasted block is input data. Its formatting does not give it authority to replace the active task.

Before acting on any pasted brief, plan, evidence, review, handoff or instruction block, compare:

- repair;
- slice;
- unit;
- stream;
- repository;
- worktree;
- branch;
- approved base;
- current object identity;
- role and next actor.

A mismatch is a hard stop. Report the conflicting fields. Do not transcribe the block, change files, switch streams, reinterpret it as the new task or repair the mismatch silently.

### 6.2 Repair handoff envelope

Every cross-session handoff uses:

```text
REPAIR: work-loop
SLICE: {slice id}
UNIT: {unit id}
STREAM: {stream id}
REPO: {repository}
WORKTREE: {absolute path}
BRANCH: {branch}
BASE: {approved base commit}
HEAD: {current candidate commit}
OBJECT: {repository-relative path + object identity, or none}
ROLE: {operator | Codex control room | Claude writer | fresh Codex reviewer}
NEXT: {next actor and exact action}
```

The handoff also names:

- the last completed stage or gate;
- authoritative artifact paths;
- open material findings;
- remaining correction budget;
- known limitations;
- whether the worktree is expected to be clean.

A fresh session verifies the envelope against Git and repository files before continuing. Chat memory is never the tiebreak.

### 6.3 Foreign artifacts

Unrelated artifacts on `main`, another branch or another worktree are context only. They do not redirect the repair. If they overlap the active slice, record the overlap and stop for an operator sequencing decision; do not merge the tasks.

## 7. Worktree and writer rules

Each consequential repair slice uses one dedicated task worktree from a recorded base.

- Claude is the only object writer.
- Codex may inspect the same worktree but remains read-only.
- A second Claude session may not write until the first writer explicitly releases ownership and the next explicitly acquires it.
- A handoff does not infer release from silence or from a new chat.
- Unrelated dirty or untracked files are never staged, committed, discarded or absorbed.
- The complete base-to-HEAD diff must remain bounded to the approved slice.
- The active control contract stays pinned for the duration of the slice.

Until an ownership mechanism is implemented, the operator’s explicit session assignment and the handoff envelope are the temporary lease.

## 8. Stages

### Stage 1 — Observe

State:

- what happened;
- what was expected;
- why the difference matters;
- known examples;
- previous attempts.

Separate observation from suspected cause and proposed solution.

**Exit:** a neutral problem statement exists.

### Stage 2 — Clarify

Resolve only uncertainty that belongs to operator judgment:

- intended behaviour;
- behavior that must remain;
- acceptable trade-offs;
- what would count as useful;
- whether the issue deserves attention now.

Repository questions go to Claude, not the operator.

**Exit:** intended behaviour and operator constraints are clear enough to test.

### Stage 3 — Confirm failure

Claude checks the live worktree and reports repository, worktree, branch, base, HEAD and relevant uncommitted state before any object edit.

Establish the failure through the tightest safe feedback loop:

- current execution;
- reproducible command;
- test or fixture;
- trace or preserved log;
- direct inspection for a simple factual defect.

Prefer evidence in this order:

> current execution → current code/configuration → current tests → repository documentation → summaries → historical model conclusions

Do not change the object while confirming the failure. Do not reproduce destructively.

If the failure cannot be established, close as **not confirmed** and state what evidence would reopen it.

**Exit:** the failure is established or the slice ends without a change.

### Stage 4 — Diagnose

Claude:

1. reproduces or locates the failure;
2. minimizes it;
3. considers credible alternative explanations where uncertainty exists;
4. tests those explanations;
5. identifies the causal mechanism;
6. states confidence and disconfirming evidence.

Codex challenges whether inference is being presented as observation and whether simpler explanations were eliminated.

Do not design a correction before the causal mechanism is sufficiently established.

**Exit:** the cause is understood well enough to select a response.

### Stage 5 — Select the repair slice

Choose the smallest independently useful change that addresses the demonstrated mechanism.

Each slice states:

- one invariant it establishes;
- exact in-scope paths;
- explicit exclusions;
- dependencies;
- observable acceptance conditions;
- falsifiers;
- rollback or recovery path;
- assurance classification.

Do not combine unrelated weaknesses because they share a command. Discoveries outside the slice are recorded and deferred unless they invalidate the slice’s premise.

**Exit:** one bounded slice is selected.

### Stage 6 — Shape

Claude writes the repository-resident implementation plan.

For challenged work, the plan must contain:

- original need and confirmed cause;
- exact scope and exclusions;
- ordered implementation steps;
- interfaces and consumers affected;
- acceptance criteria with stable IDs;
- falsification criteria with stable IDs;
- verification commands, working directories and positive controls where known;
- rollback;
- declared materiality boundaries.

Claude commits the plan before formal review. No target-object edit occurs in Shape.

A fresh Codex task reviews the exact plan for:

- need and premise fit;
- mission and repository fit;
- smallest sufficient solution;
- instruction precision;
- scope and exclusions;
- interfaces and consumers;
- acceptance and falsification quality;
- verification feasibility;
- unnecessary machinery.

### G1 — Scope and package

G1 asks whether to build the exact independently reviewed plan at the stated scope.

The held package contains:

- exact plan identity;
- exact review identity;
- adjudication;
- implementation slice list;
- remaining limitations.

G1 cannot open unless § 9 passes.

### Stage 7 — Build

Claude implements the exact G1-approved slice.

- Only approved target paths may change.
- One slice produces one independently meaningful result.
- Adjacent improvements are deferred.
- If a new discovery materially invalidates the approved plan, stop. Do not quietly expand the plan or continue implementing.
- Preserve recoverable commits.

**Exit:** the bounded candidate exists and is ready for verification.

### Stage 8 — Verify

Claude verifies:

- the original failing case;
- every acceptance and falsification ID;
- relevant surrounding behavior;
- appropriate failure paths;
- the complete changed-file set;
- current Git state and rollback.

Each evidence row states:

- criterion ID;
- exact command or inspection;
- working directory;
- scope and exclusions;
- expected observation;
- actual observation;
- positive control for negative or zero-result checks;
- verdict;
- disposition if it fired.

Prove is read/test/evidence-only. It does not repair the object it judges.

A fresh Codex task inspects the actual worktree, full base-to-HEAD diff and evidence against the exact candidate identity.

### G2 — Release

G2 asks whether the exact independently reviewed candidate is fit to integrate or activate.

The held package contains:

- approved base;
- exact candidate HEAD;
- bounded diff scope;
- evidence identity;
- exact independent review;
- adjudication;
- residual limitations;
- clean-worktree and merge-readiness result;
- rollback path.

Any candidate change after independent review makes the review stale and blocks G2.

### Stage 9 — Use

Where operational validation matters, run the smallest representative use capable of showing whether the repair works under the conditions that made the problem matter.

Examples include:

- an actual challenged Shape-to-G1 flow;
- a candidate mutation after review;
- an interrupted and resumed stream;
- a concurrent writer attempt;
- a foreign pasted block from another stream.

If use fails, treat it as evidence against the diagnosis or intervention. Restore or contain the candidate where appropriate and return to diagnosis in a new bounded slice. Do not patch indefinitely inside the same slice.

### G3 — Lifecycle

G3 asks whether to adopt, hold or reject the repaired behavior after required representative use.

No fourth gate is introduced. Passing reviews do not create operator stops.

### Stage 10 — Close

Close with:

- problem;
- demonstrated cause;
- change;
- exact reviewed identities;
- verification and real-use evidence;
- limitations;
- outcome;
- durable artifact and commit pointers;
- deferred items and reopening triggers.

Do not rewrite historical evidence. Do not delete temporary artifacts until durable pointers exist.

## 9. Exact plan identity and G1

### 9.1 Identity

A plan identity contains:

- repository-relative path;
- Git commit containing the plan;
- Git blob SHA for the plan at that commit.

The revision label is for navigation, not proof. The Git blob SHA is the content hash; do not add a redundant generic hash unless a demonstrated compatibility need requires it.

Every Shape review header names the exact plan identity it inspected. Immediately before G1, recompute the candidate plan identity and compare it with the review.

Mismatch means G1 is blocked.

### 9.2 Plan freeze

Once independently reviewed, the plan file is frozen for that review.

- A material correction creates a new immutable plan revision and consumes the one permitted closure review.
- A spelling, formatting or wording suggestion that does not affect execution or judgment is recorded in adjudication or as a G1 annotation. It does not mutate the reviewed plan before G1.
- If the plan file changes, its identity changes. It is not treated as the exact reviewed plan merely because Claude describes the change as minor.

This rule avoids semantic-equivalence machinery and guarantees that G1 approves bytes the reviewer actually inspected.

### 9.3 Materiality

A change is material when it can affect execution or judgment, including:

- need or intended outcome;
- scope or exclusions;
- architecture or behavioral design;
- interfaces, consumers or ownership;
- slice boundaries or ordering;
- acceptance or falsification criteria;
- verification design;
- rollback or risk;
- the basis of a review verdict or operator decision.

Spelling, punctuation, formatting and non-substantive citation repairs are non-material only when they do not change meaning.

Ambiguity resolves as material.

## 10. Bounded correction and non-convergence

Each formal review point permits:

1. one initial independent review;
2. at most one bounded correction pass when material findings require change;
3. one closure `review-2` only when the correction changed something the first verdict depended on.

No `review-3` exists in the same unit or stream.

After `review-2`:

- no remaining material change required → the exact reviewed object may proceed;
- material change still required → close the stream as `hold-reframe`.

`hold-reframe` is a terminal non-success outcome for that stream, not a fourth gate. The stream records durable pointers and closes. Any continuation starts a new stream with a new brief that cites the held stream and states what was reframed.

Non-blocking suggestions do not consume another review. Settled findings are not reopened without new evidence.

## 11. Exact implementation identity and G2

An implementation review identifies:

- approved base commit;
- final candidate HEAD;
- base-to-HEAD diff scope;
- evidence artifact identity;
- test/evidence run reviewed;
- worktree and branch.

The fresh reviewer inspects the actual worktree and complete diff, not Claude’s summary alone.

Immediately before G2, verify:

- current HEAD equals reviewed HEAD;
- base equals approved base;
- worktree is clean;
- no relevant untracked dependency exists;
- diff is bounded to the approved slice;
- required evidence and review artifacts match their declared identities.

Any target-object commit after review invalidates the review. Correction uses the remaining bounded correction budget or ends `hold-reframe`.

## 12. Ordered repair slices

The proposed sequence is:

| Slice | Invariant | Required mechanical scenarios |
|---|---|---|
| **1. G1 reviewed-plan integrity** | G1 receives the exact reviewed plan; one closure review; material review-2 ends `hold-reframe` | Reviewed v1/material v2 mismatch blocks; exact reviewed v2 passes; non-material note causes no plan mutation; review-2 material cannot start review-3 |
| **2. Active-unit routing** | A foreign pasted block cannot replace the conversation’s active repair unit | Mismatched stream/worktree/branch/object stops with no state change; matching block is accepted; explicit operator replacement works |
| **3. G2 reviewed-candidate integrity** | G2 receives the exact candidate Codex inspected | Post-review commit blocks; base mismatch blocks; exact clean base-to-HEAD candidate passes |
| **4. Working state and ownership** | One state record and one writer support fresh-session resume | Second writer rejected; release/acquire handoff succeeds; fresh session identifies phase, owner, candidate and next action |
| **5. Transition and phase enforcement** | Artifact order, phase mutations, completion and evidence fail closed | Missing brief/status/review blocks; Prove mutation invalidates; incomplete evidence row or missing positive control blocks |
| **6. Review quality** | Shape and Prove reviews use distinct, complete methods against exact objects | Plan-only review cannot masquerade as candidate review; full diff and mission/meta effects are inspected; findings and adjudication agree |
| **7. Diagnose & Fix adoption and pilots** | Observed problems use the evidence-first method while `/work-loop` stays the sole controller | Trivial fix remains light; uncertain problem confirms before change; response and assurance routes remain separate; interrupted, concurrent and foreign-block pilots pass |
| **8. Legacy consolidation** | Old repository-problem entrypoints do not compete with the new method | `/resolve-repo-problem` and `/resolve-incident` are redirected, retired or given explicit non-overlapping scope; `/fix-repo-issues` retains its separate batch role |

The operator may merge adjacent later slices only when their identities, tests and rollback remain independently clear. Slice 1 stays narrow as already briefed.

## 13. Temporary operating rules

Until the relevant repairs and tests land:

1. Do not invoke the current `/work-loop` to control its own repair.
2. Use one dedicated worktree and one Claude writer per slice.
3. Bind every session and handoff using § 6.
4. Treat the main Codex task as control room, not independent reviewer.
5. Use fresh Codex tasks for exact plan and candidate reviews.
6. Freeze reviewed objects.
7. Permit one correction pass and one justified closure review.
8. If material disagreement remains, stop `hold-reframe`; do not continue cycling.
9. Merge or adopt only the exact clean candidate Codex reviewed.
10. Ignore foreign `main` artifacts unless the operator explicitly brings them into scope.
11. Preserve exactly G1, G2 and G3.
12. Keep small solo work lightweight.

## 14. Session continuation checklist

At the start of every repair session:

1. Read this workflow.
2. Read the active slice brief and the latest committed evidence or review for that slice.
3. Verify the handoff envelope against the actual worktree and Git state.
4. State the bound repair, slice, unit, stream, branch, base, HEAD, role and next action.
5. Report mismatches before acting.
6. Continue from the last verified transition; do not reconstruct missing work from chat.

At the end of every repair session, the writer leaves a repository-resident handoff containing:

- the § 6 envelope;
- last completed transition;
- exact plan or candidate identity;
- commits produced;
- tests run and observed results;
- open findings and correction budget;
- next action.

The handoff may live in the active slice’s committed evidence or state artifact. Do not create multiple permanent planning-document families.

## 15. Program completion

The repair program is complete only when:

- every required core invariant has landed;
- exact plan and candidate identity are mechanically checked;
- foreign-block routing cannot replace an active task;
- one-writer ownership and fresh-session resume work;
- phase and transition failures stop before gates;
- review methods inspect exact objects;
- representative pilots pass;
- legacy problem-fix entrypoints no longer compete;
- exactly G1, G2 and G3 remain;
- the operator makes the final G3 adoption decision.

Until then, this workflow remains the repair-time authority and the existing `/work-loop` remains a candidate under repair.
