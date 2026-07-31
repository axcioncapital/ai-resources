UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: shape
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Codex reviewer

# PLAN v2 — Slice 1: G1 reviewed-plan integrity

Revision: **v2**, immutable. Supersedes plan-v1 for execution; v1 is retained unedited.
Assurance: **challenged** (`docs/work-loop-repair-workflow.md:91`)

| Predecessor | Path | Blob |
|---|---|---|
| Frame evidence | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.evidence.md` | `4349ae7271c01ddd1eb5837e3cb129653a16b272` |
| Plan v1 | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan.md` | `e93ae5863520e261fecfe57acadd3beecc5b8082` |

**This revision is a pre-review operator scope reframe, not a review correction.** No review has been
requested or produced. **The review and material-correction budget is untouched:** one initial review,
at most one material correction, and at most one conditional closure `review-2` all remain available.

Binding verified before writing: branch `codex/2026-07-31-g1-reviewed-plan-invariant`, HEAD
`d44a4fcf56ea92be3d45ece1c27a5af18ae323ef`, base `6050a5b` an ancestor, worktree clean. No object
edit occurs in Shape.

---

## 1. Why v2 exists

Patrik stopped plan-v1 before review. Four material defects, all confirmed against the cited lines:

| # | Defect in v1 | Resolution in v2 |
|---|---|---|
| 1 | Split one inseparable behaviour into three file-based Build units — a technical layering, barred by `templates/capability-record.md:89` and `docs/work-loop-repair-workflow.md:361`. None was useful alone; v1 §13 even conceded two must revert together | **§7 — one atomic slice** |
| 2 | Added a fifth outcome while leaving the canonical template at four, deferring the inconsistency. The slice *creates* that inconsistency, so deferral was the wrong category | **§4 — template in scope, one line** |
| 3 | A malformed review header could be retried without consuming budget — an uncapped side loop | **§6.6 — capped at one** |
| 4 | The G1 package still admitted an `unassessed` review, contradicting the invariant it exists to establish | **§6.5 — no independent review, no G1** |

**Operator scope decision of record.** Patrik has widened Slice 1's implementation scope from three
files to exactly four, adding `templates/capability-record.md` limited to its outcome enumeration.
**This explicit decision supersedes the three-file boundary stated in plan-v1 §5 and in the Frame
handoff.** Nothing else is widened.

---

## 2. Need and mechanism

Stated in full in the Frame evidence (blob `4349ae72…`, §§2–4) and not reproduced here.

**In one line:** G1's held package is specified by *name* ("the plan"), not by *identity*, and no
consumer-side check closes the gap — so a plan revision no reviewer inspected can reach G1. Observed
twice on 2026-07-29 (`prime-minimum-responsibility`, `review-layer-consolidation`), both times in
full compliance with the contract, which makes it a specification defect rather than operator error.
Separately, an unresolved material `review-2` has no terminal outcome, so the loop cannot stop.

**Premise correction carried forward from plan-v1 §3, still in force:**
`.agents/skills/work-loop/SKILL.md:60` requires naming *an object*, not an *identity* — the recovered
historical header carries a bare path with no commit and no blob. The review-header identity carrier
is therefore in scope as identity plumbing, not review-method expansion.

---

## 3. The invariant

> **G1 cannot open unless the plan it presents is byte-identical to the plan a valid independent
> review inspected — proven by matching path, containing commit and blob SHA — and the correction
> loop terminates: one initial review, at most one material correction, at most one closure
> `review-2`, never a third, with an unresolved material `review-2` closing the stream
> `hold-reframe`.**

---

## 4. Scope — exactly four files

| Path | Change |
|---|---|
| `docs/work-loop.md` | Plan identity, review-header requirement, G1 precondition, materiality, lifecycle, `hold-reframe`, `review-{n}` path |
| `.agents/skills/work-loop/SKILL.md` | The three-line identity carrier on Shape review headers |
| `.claude/commands/work-loop.md` | Header validation, the comparison, G1 package in identities, blocker stop, lifecycle mechanics |
| `templates/capability-record.md` | **Line 98 only** — add `hold-reframe` to the `## Units` outcome enumeration |

**Template boundary.** Verified this unit: `:98` is the sole unit-outcome enumeration. Line 7 is the
separate `status:` axis (`adopted \| keep-local \| closed \| retired \| rejected`) and is **not**
touched — outcome and status are different axes (`docs/work-loop.md:200`).

---

## 5. Exclusions

Routing (Slice 2) · G2 candidate identity and any Prove-side non-convergence (Slice 3) · post-G1
package freeze, Frame OF-1 (Slice 3 or its own) · state, ownership, writer leases (Slice 4) · phase
and transition enforcement, validators, scripts (Slice 5) · review-method expansion and review
artifact completeness beyond the `review-{n}` path, Frame OF-3 (Slice 5/6) · legacy consolidation
(Slice 8) · historical rewriting (never).

No new state, validator, script, outcome type beyond `hold-reframe`, review machinery, or later-slice
design is introduced.

---

## 6. Design

### 6.1 Plan identity

Three fields; the blob is the authority on content.

| Field | Form |
|---|---|
| `PLAN-PATH` | repository-relative path |
| `PLAN-COMMIT` | full 40-hex commit SHA at which the plan exists at that path |
| `PLAN-BLOB` | full 40-hex blob SHA of the plan at that commit |

Binding relation: `git rev-parse {PLAN-COMMIT}:{PLAN-PATH} == {PLAN-BLOB}`. Abbreviated SHAs are
rejected, so comparison is exact string equality. No additional hash (`…repair-workflow.md` §9.1).

### 6.2 Review-header carrier

Every Shape `REVIEW` header carries three lines after the six standard fields:

```
PLAN-PATH:   logs/loop/{shape-unit}.plan-v2.md
PLAN-COMMIT: {40-hex}
PLAN-BLOB:   {40-hex}
```

This is the entire `SKILL.md` change. `:60`'s per-finding object rule is retained verbatim.

### 6.3 Header validation happens **before** transcription

On receiving a `REVIEW` block, the executor validates the three header fields **before** writing the
review artifact. This ordering is deliberate: the review artifact is immutable
(`docs/work-loop.md:142`), so a malformed header must never be baked into it — there would be no
lawful way to correct it afterwards. Validating first makes every transcribed review valid by
construction and adds no mutation path and no new artifact.

### 6.4 The comparison — the G1 precondition

Runs in the Shape unit, after adjudication, immediately before G1, and only there.

1. The candidate plan must be committed; uncommitted or dirty is a stop.
2. Compute candidate identity: `PLAN-PATH`; `PLAN-COMMIT` = `git log -1 --format=%H -- {path}`;
   `PLAN-BLOB` = `git rev-parse {commit}:{path}`.
3. Take the identity from the latest valid review (`review-2` if present, else `review-1`).
4. Verify that review's own binding relation (§6.1) — catches an internally inconsistent header.
5. Compare all three fields by exact string equality.

**G1 is blocked by any of:** candidate uncommitted or absent · no review artifact · missing field ·
malformed field · review's stated blob inconsistent with its own commit+path · any field differing
from the candidate's.

The stop names the failed field and both values. G1 does not open and no package is presented.
Fail-closed: absence of proof blocks.

### 6.5 No independent review means no G1

An inline or self-review recorded `unassessed` **cannot** satisfy the precondition — it is not
independent, so a plan resting on it is not an independently reviewed plan. This replaces the
`unassessed`-at-G1 path the current command permits at `.claude/commands/work-loop.md:134` **for
challenged Shape only**.

When the independent reviewer cannot inspect the plan:

- stop before G1;
- **leave the Shape unit open** — do not close it, do not mark evidence `Status: complete`;
- return the §6.2 blocker handoff (repair-workflow envelope) naming the plan identity, why it is
  blocked, and what unblocks it;
- **no new gate and no new CLOSE outcome.**

**This needs no new machinery.** An open unit whose evidence is absent is already *incomplete* under
`docs/work-loop.md:253`, so § Resume order Tier 2 re-offers it and the stream resumes when
independent review is available. Existing mechanism, reused.

`unassessed` is **not** removed from the contract — it remains available for reviewed-route work and
for Prove, both out of scope here. Only its sufficiency at challenged-Shape G1 is denied.

### 6.6 Malformed header — bounded at one

| Step | Behaviour |
|---|---|
| 1 | A missing or malformed `PLAN-PATH` / `PLAN-COMMIT` / `PLAN-BLOB` blocks G1 |
| 2 | Permit **exactly one** mechanical request that the reviewer re-emit the same review with a corrected header. The substantive findings must be unchanged — this is a formatting repair, not a new review |
| 3 | If the re-emitted header is still invalid: **stop before G1**, leave the unit open, return the §6.5 blocker handoff |

Explicitly: the header request is **not** `review-2`, does **not** consume the material-correction
budget, and does **not** trigger `hold-reframe`. It is capped at one, so no retry loop exists.

### 6.7 Lifecycle and `hold-reframe`

One initial review (`review-1`) · at most one material correction, producing a new immutable
revision, never an edit to the reviewed one · at most one conditional closure `review-2`, justified
only when the correction changed something the first verdict rested on · **no `review-3`**.

After `review-2`: no material change required → the exact reviewed revision proceeds to §6.4, then
G1. Material change still required → **`hold-reframe`**.

`hold-reframe` is reserved for exactly that case. It is a fifth unit outcome joining the three that
close without altering the object under work — Shape makes no object edit, so `docs/work-loop.md`
§ Closing without a change applies unchanged: evidence with the outcome and both identities, the
`CLOSE` block, the stream closes in the same commit, and the durable `logs/decisions.md` pointer with
the recovery SHA. It is **terminal for the stream, not a gate** — it opens no operator decision.
Continuation starts a new stream citing the held one (`…repair-workflow.md` §10).

**Shape review point only.** A Prove-side `hold-reframe` would have to dispose of landed object
edits; that is G2 territory and is excluded (§5).

### 6.8 Materiality

Imported from `…repair-workflow.md` §9.3: need or outcome · scope or exclusions · architecture or
behavioural design · interfaces, consumers or ownership · slice boundaries or ordering · acceptance
or falsification criteria · verification design · rollback or risk · the basis of a verdict or
operator decision. Spelling, punctuation, formatting and non-substantive citation repairs are
non-material only when meaning is unchanged. **Ambiguity resolves as material.**

**Non-material findings are annotated, never mutated in.** They are recorded in the adjudication or
as a G1 annotation and cannot change the plan's blob — which is precisely what prevents review churn.

### 6.9 `review-{n}` path

`logs/loop/{unit}.review-{n}.md`, `n ∈ {1, 2}`. Immutable; `review-2` is never an edit to `review-1`;
`n ≥ 3` is not a valid artifact. Closes Frame OF-2 — `.claude/commands/work-loop.md:131` currently
hard-codes `review-1.md` while `:224` acknowledges `review-2`.

### 6.10 The "one review round" conflict

`docs/work-loop.md:102` and `.agents/skills/work-loop/SKILL.md:42` both say "at most one review
round", contradicting the `review-2` permitted at `:94`, `:144` and command `:224` (Frame §2 P3
Part A). Both are corrected to cite §6.7's lifecycle.

---

## 7. One atomic implementation slice

**S1 — G1 reviewed-plan integrity. One Build unit, four files, one result.**

Not split by file or layer. The behaviour exists only when all four land: the contract defines the
identity, the reviewer emits it, the executor checks it, and the canonical template can record the
outcome. Any subset ships a rule that is unenforced, uninputted, or unrecordable.

Ordered steps within the single unit:

1. **`docs/work-loop.md`** — plan identity and binding relation (§6.1); review-header requirement
   (§6.2); G1 precondition and its fail-closed stop (§6.4); no-G1-on-`unassessed` for challenged
   Shape (§6.5); materiality and non-material-no-mutation (§6.8); lifecycle and no-`review-3` (§6.7),
   correcting `:102` (§6.10); `hold-reframe` as fifth outcome at `:196`/`:198` plus its row in
   § Closing without a change; `review-{n}` path (§6.9).
2. **`.agents/skills/work-loop/SKILL.md`** — the three header lines (§6.2); correct `:42` (§6.10).
3. **`.claude/commands/work-loop.md`** — header validation before transcription (§6.3); the
   comparison between adjudication `:131` and G1 `:132` (§6.4); G1 package in identities; the
   one-shot header request and blocker stop (§6.5, §6.6); generalise `:131` to `review-{n}`; the
   `hold-reframe` close path; correct `:224`.
4. **`templates/capability-record.md:98`** — add `hold-reframe` to the outcome enumeration.

Step 4 last, so the template is made consistent with a contract that already defines the outcome.

---

## 8. Interfaces and consumers

Verified by repository scan (`grep -rln` over `*.md`).

| Consumer | Impact |
|---|---|
| `.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md` | **In scope** |
| `templates/capability-record.md` | **In scope**, line 98 only |
| `skills/capability-development/SKILL.md` | **None.** Restates no review round and no outcome vocabulary — grep for `review-1\|review-2\|review round\|rejected-premise\|Four outcomes` → zero, against a control of 23 `review` hits |
| `.claude/commands/develop-ai-resource.md` | **None** — cites handoff labels only |
| `docs/qc-independence.md` | **None** — risk-aware dimensions untouched |
| `logs/*`, `audits/*`, `plans/*`, `reports/*` | **None** — historical records, never rewritten |

---

## 9. Acceptance criteria

| ID | Criterion |
|---|---|
| **A1** | Contract defines plan identity as path + commit + blob, with the binding relation and full-40-hex requirement |
| **A2** | Contract and `SKILL.md` both require the three-field Shape review header |
| **A3** | Command validates the header **before** transcription |
| **A4** | Command runs the comparison after adjudication and before G1, hard-stopping on any mismatch, missing/malformed field, inconsistent header, or uncommitted candidate |
| **A5** | G1 held package displays plan and review identities, not bare names |
| **A6** | An `unassessed` review cannot satisfy the G1 precondition for challenged Shape; an unreachable reviewer stops before G1, leaves the unit open, and returns a blocker handoff — with no new gate and no new CLOSE outcome |
| **A7** | Header repair is capped at exactly one re-emit; a second invalid header stops with a blocker handoff; it is not `review-2`, consumes no material-correction budget, and does not trigger `hold-reframe` |
| **A8** | Materiality defined; ambiguity resolves material; a non-material note provably cannot mutate the reviewed plan |
| **A9** | Lifecycle stated as one initial review, ≤1 material correction, ≤1 closure `review-2`, no `review-3` |
| **A10** | `hold-reframe` exists as the terminal Shape-side outcome for an unresolved material `review-2` only, with a complete close path including the durable pointer, and creates no gate |
| **A11** | `review-{n}` path defined, `n ∈ {1,2}` (closes OF-2) |
| **A12** | `templates/capability-record.md:98` includes `hold-reframe`; line 7's status axis is unchanged |
| **A13** | No "at most one review round" text survives in the contract or `SKILL.md` |
| **A14** | Exactly G1, G2, G3 remain — no fourth gate in any of the four files |
| **A15** | The base-to-HEAD diff touches only the four in-scope files plus this stream's `logs/loop/` artifacts |

### Required mechanical scenarios

| ID | Scenario | Required result |
|---|---|---|
| **M1** | Reviewed v1, then materially revised v2 presented at G1 | **Blocks** |
| **M2** | The exact independently reviewed v2 presented at G1 | **Passes** |
| **M3** | A non-material note returned | **No plan mutation, no new revision, no new review round** |
| **M4** | `review-2` returns a material finding | **No third cycle; closes `hold-reframe`** |
| **M5** | Header missing, malformed, or blob/commit inconsistent | **Blocks** |
| **M6** | Reviewer unreachable, or only an `unassessed` self-review exists | **Stops before G1; unit stays open; blocker handoff; no gate, no CLOSE outcome** |
| **M7** | Header invalid once, corrected on the single permitted re-emit | **Proceeds, budget unconsumed**; a second invalid header **stops** |

---

## 10. Falsification criteria

| ID | Falsifier |
|---|---|
| **F1** | A materially revised plan no valid review inspected reaches G1 |
| **F2** | The exact independently reviewed plan is blocked — a false positive making the check unusable |
| **F3** | A non-material note forces a new plan revision or an extra review round |
| **F4** | A material `review-2` finding can start a third cycle |
| **F5** | A missing, malformed, inconsistent or mismatched identity permits G1 to open |
| **F6** | G1 opens on an `unassessed` review, **or** an unreachable reviewer closes the unit instead of leaving it open |
| **F7** | Header repair can run more than once, or consumes the material-correction budget, or triggers `hold-reframe` |
| **F8** | A fourth gate appears, or `hold-reframe` behaves as a gate |
| **F9** | Any file outside the four in-scope paths is modified |

---

## 11. Verification

Working directory: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan`.

### 11.1 Identity fixture — the real failure on real objects

Derived and confirmed in plan-v1 §12.1; values restated because Build and Prove consume them. Zero
mutation, no branch switch.

| Object | Command | Blob |
|---|---|---|
| What review-1 saw (v1) | `git rev-parse 4c54344:logs/loop/2026-07-29-prime-minimum-responsibility-shape.plan.md` | `1943f64849f15873707ed7fe80ac223c4aab0d24` |
| What review-2 saw (v2) | `git rev-parse 1dc38b3:…-shape.plan-v2.md` | `4e97dc9b7aed5c8a46868c9c68b4bcf2cfbac825` |
| What G1 received (v3) | `git rev-parse 1dc38b3:…-shape.plan-v3.md` | `ca274137f9e99460a29e3607f7e2d36079eba1a7` |

| ID | Case | Expected |
|---|---|---|
| **V-M1** | review-2's `4e97dc9b…` vs candidate v3 `ca274137…` | **Differ → blocks** — the historical failure caught |
| **V-M2** | v3's identity against itself | **Equal → passes** — confirmed: returns `ca274137…` |
| **V-M5** | Drop a field · truncate a SHA to 7 hex · state v2's path with v3's blob | **Blocks** in all three |

**V-M2 is the positive control for the whole comparison.** Without it a check that blocks everything
would pass V-M1 while being useless — F2. Both directions required.

### 11.2 Textual checks

Each grep runs against the four in-scope files with a stated control. Two negatives are mandatory and
meaningless without their control:

| ID | Check | Expected | Control |
|---|---|---|---|
| A13 | `grep -nE 'at most one review round'` in contract + `SKILL.md` | **zero** | Same regex against `git show d44a4fc:docs/work-loop.md` → must return `:102` |
| A14 | `grep -nEi 'G4\|fourth gate\|four gates'` | **zero**, bar existing "no fourth" prose | `grep -c 'G1'` → non-zero |
| A6 | Command has no G1 path reachable from `unassessed` | **zero** such path | `grep -n 'unassessed'` → non-zero, showing surviving out-of-scope uses |
| A12 | `grep -n 'hold-reframe' templates/capability-record.md` | ≥1 at `:98` | `grep -c 'hold-reframe' docs/work-loop-repair-workflow.md` → 5 |
| A15 | `git diff --name-only 6050a5b HEAD` | exactly the four files + this stream's artifacts | `git diff --name-only 6050a5b HEAD -- docs/work-loop.md` → non-empty after S1 |

**Shell note — mandatory.** This session's shell is `zsh`, which does not word-split unquoted
parameters. Frame §1 records a false negative from passing several paths through an unquoted
variable — read as one filename, every check returned a spurious "no matches". **Use explicit literal
paths or a shell array**, and re-run every zero result against a known-matching corpus.

### 11.3 Out of reach at Prove

These are documentation and instruction changes. Prove verifies text, diff bounds and the identity
arithmetic against real historical blobs. It **cannot** verify that a future session obeys the
instruction — that is behavioural, needs a live challenged Shape-to-G1 run, and belongs to Stage 9
(Use). Declared, not hidden.

---

## 12. Rollback and recovery

Four markdown files, one repository; no script, hook, symlink, permission or setting. Fully
reversible by `git revert` of the single S1 Build commit, or by abandoning the branch — the approved
base `6050a5b` is untouched. Because S1 is atomic, **rollback is all-or-nothing, which is the point**:
there is no partial state in which the rule is defined but unenforced. No deletion, no history
rewrite; everything recoverable from Git.

---

## 13. Declared materiality boundaries

1. **`hold-reframe` is Shape-side only** (§6.7). Prove-side non-convergence is Slice 3.
2. **`unassessed` survives elsewhere** (§6.5) — denied only at challenged-Shape G1. Reviewed-route and
   Prove behaviour is unchanged, as required.
3. **The comparison trusts a transcribed header.** Mitigated by §6.4 step 4 (the header's internal
   binding relation is checked against Git), not eliminated — full protection needs writer/ownership
   controls, which are Slice 4.
4. **No validator is introduced.** The comparison is an instruction the executor follows;
   mechanisation is Slice 5. This slice makes the rule exact and checkable, not automatic.
5. **Behavioural evidence cannot exist before implementation** (§11.3).
6. **Line numbers** are as of blobs `88f555e6…` (contract), `33986fb8…` (skill), `0e575aa5…`
   (command), `f0580c9e…` (template) at HEAD `d44a4fc`. Build re-derives them if any file moves.

---

## 14. Gates

**Exactly G1, G2 and G3 remain.** Nothing is added or removed.

The comparison is a **precondition on G1**, not a gate — it produces no operator decision; it either
lets G1 open or stops before it. The blocker handoff (§6.5, §6.6) is a **stop**, not a gate — it asks
nothing and leaves the unit open to resume. `hold-reframe` is a **terminal close**, not a gate. A
passing comparison produces no stop and is reported in one line inside the G1 package.

---

## 15. Open findings, budget, limitations

- **OF-1** (post-G1 package mutation, `plan-v4` `bc435d5` / `plan-v5` `6a81121`) — **deferred**, §5.
- **OF-2** (no `review-2` artifact path) — **closed** by §6.9 / A11.
- **OF-3** (review named in `logs/decisions.md:11` with no artifact at `b8ef77f^`) — **deferred**, §5.

**Review and correction budget: fully intact.** This reframe was an operator scope decision taken
before any review existed. One initial review, at most one material correction, and at most one
conditional `review-2` remain available.

**Limitations:** the `:102` conflict's causal role in the observed failure remains inference, not
observation (Frame §4) — it is corrected here because it is a confirmed textual defect, not because
its causal role is proven; and no behavioural evidence is obtainable before implementation.

LIMITATIONS: §13 and §15. This plan makes no object edit, opens no gate, requests no review, and
authorizes no implementation. It is the object a fresh Codex task must now review at the exact
identity reported in this unit's handoff.
