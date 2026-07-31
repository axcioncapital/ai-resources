UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: shape
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Codex reviewer

# PLAN — Slice 1: G1 reviewed-plan integrity

Revision: **v1** (immutable; a material revision is `-v2`, per `docs/work-loop.md:140`)
Assurance: **challenged** (`docs/work-loop-repair-workflow.md:91`)
Governing authority: `docs/work-loop-repair-workflow.md`
Predecessor: `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.evidence.md`, blob `4349ae7271c01ddd1eb5837e3cb129653a16b272`

**No object edit occurs in this unit.** The plan is the deliverable (`docs/work-loop-repair-workflow.md`
§8 Stage 6). This plan is committed before any formal review, and no review artifact exists yet.

---

## 1. Binding verified before writing

| Field | Value | Verified |
|---|---|---|
| Branch | `codex/2026-07-31-g1-reviewed-plan-invariant` | `git rev-parse --abbrev-ref HEAD` |
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` | ancestor of HEAD — true |
| Starting HEAD | `55900183e48d6b5d26193bd4ef6b431da91bb443` | match |
| Frame evidence blob | `4349ae7271c01ddd1eb5837e3cb129653a16b272` | match |
| Worktree | clean | `git status --porcelain` empty |

Authority blobs at starting HEAD, unchanged since Frame §1 — confirming no drift between units:

| Path | Blob |
|---|---|
| `docs/work-loop.md` | `88f555e630a4ae898d0eb6d1827d908faf1bf81a` |
| `.claude/commands/work-loop.md` | `0e575aa5dab40a07927bd6cc3cf9af07940401f0` |
| `.agents/skills/work-loop/SKILL.md` | `33986fb80e15fd26600a619793cef37e79c5650a` |

No branch switch, pull, merge, rebase or cherry-pick. No other stream's artifacts imported.

---

## 2. Original need and confirmed causal mechanism

**Need.** On the challenged route, `/work-loop` can present a Shape plan at G1 that no independent
reviewer has inspected, and no authority contains a check that would detect it. Separately, a
`review-2` returning an unresolved material finding has no defined terminal outcome, so the loop has
no legitimate way to stop.

**Confirmed mechanism** (Frame evidence §4, confidence high):

> **G1's held package is specified by *name*, not by *identity*, and no consumer-side check closes
> the gap between the two.**

Four individually reasonable rules compose unsoundly:

1. Every plan revision is a **new immutable file** (`docs/work-loop.md:140`) — the reviewed file is
   never mutated, so nothing looks wrong at file level.
2. A review's object is whichever file existed **when the review ran** (`:91`).
3. The correction pass legitimately produces a **later** revision, after the review.
4. G1's package is *"the plan"* (`:83`, `.claude/commands/work-loop.md:132`) — a name that silently
   re-binds to the newest revision as the set grows.

Immutability guarantees the reviewed bytes still exist; it does not guarantee they are the bytes G1
receives. **Both observed occurrences followed the contract exactly** — this is a specification
defect, not operator error.

**Observed twice on 2026-07-29** (Frame §2 P4): stream `prime-minimum-responsibility` — review-1 saw
v1, review-2 saw v2, G1 approved **v3**, evidence states verbatim "Plan-v3 has been reviewed zero
times"; stream `review-layer-consolidation` — the only on-disk review named v1, G1 approved **v3**.

**Terminal-outcome half.** `docs/work-loop.md:196` enumerates four outcomes; none fits "review-2 still
requires a material plan change." `hold-reframe` appears in none of the three authorities (Frame §2
P3, zero matches with a positive control). The authorities are silent, not restrictive.

---

## 3. Premise correction adjudicated into this plan

**The control room corrected Frame evidence §4 alternative A5, and the correction is accepted.**

Frame §5 recorded a "smallest-sufficient note" stating that review-side identity emission already
exists and Shape should not re-specify it. **That note is incomplete and does not constrain this
plan.**

Verified this unit: `.agents/skills/work-loop/SKILL.md:60` requires "State the object you inspected
for every finding" — object *naming*, not *identity*. The recovered historical header
(`git show b8ef77f^:logs/loop/2026-07-29-review-layer-consolidation-shape.review-1.md`) carries:

```
Object reviewed:
logs/loop/2026-07-29-review-layer-consolidation-shape.plan.md
```

A bare path, with **no commit and no blob**. `docs/work-loop-repair-workflow.md` §9.1 defines plan
identity as path **+ containing commit + blob SHA**, and requires every Shape review header to name
that exact identity. A path alone cannot support the three-part comparison, and a path transcribed
in prose is unverifiable against Git.

**Consequence for scope:** this plan includes the smallest in-scope review-header identity carrier
the G1 comparison requires (Slice S2 below). This is **identity plumbing** — the minimum data the
comparison consumes — and is not review-method expansion, which stays excluded (§6).

The Frame evidence is **not edited**; this section is the adjudication of record. Frame's underlying
observation stands: the defect is consumer-side. What Frame understated is that the producer side
emits a path, not an identity, so the carrier must be specified for the consumer to have inputs.

---

## 4. The Slice 1 invariant

> **G1 cannot open unless the plan it presents is byte-identical to the plan a valid independent
> review inspected, proven by matching path, containing commit and blob SHA; and the correction
> loop terminates — one initial review, at most one material correction, at most one closure
> `review-2`, never a third, with an unresolved material `review-2` closing the stream
> `hold-reframe`.**

Both halves are one property: **G1 never acts on an unreviewed object, and the path to a reviewed
object always terminates.** Without the second half, the first is satisfiable only by looping.

---

## 5. Exact scope

Exactly three files. No other path is touched by any slice.

| Path | Role in this slice |
|---|---|
| `docs/work-loop.md` | Contract — defines plan identity, review-header requirement, the G1 precondition, materiality, review lifecycle, `hold-reframe`, `review-2` path |
| `.agents/skills/work-loop/SKILL.md` | Codex controller — emits the three-part identity in the review header |
| `.claude/commands/work-loop.md` | Executor — performs the comparison, presents identities at G1, runs the lifecycle and the `hold-reframe` close |

---

## 6. Explicit exclusions

Out of scope for Slice 1. Each is recorded, none is designed here.

| Excluded | Owner |
|---|---|
| Foreign-block / active-unit routing | Slice 2 |
| **G2 candidate identity**, including any Prove-side `hold-reframe` | Slice 3 |
| **Package freeze after G1** (Frame OF-1: plan-v4/v5 mutated post-G1) | Slice 3 or its own slice — operator's sequencing call |
| Working state, ownership, writer leases, fresh-session resume | Slice 4 |
| Transition and phase enforcement | Slice 5 |
| Validators, including any `scripts/check-work-loop-state.sh` | Slice 5 |
| **Review-method expansion** (what a reviewer must examine) | Slice 6 |
| Review artifact completeness beyond the `review-2` path (Frame OF-3) | Slice 5/6 |
| Legacy consolidation (`/resolve-repo-problem`, `/resolve-incident`) | Slice 8 |
| Historical rewriting of any kind | Never — `docs/work-loop-repair-workflow.md` §3 |
| `templates/capability-record.md` outcome enumeration | Declared consumer gap — §14 |

**Boundary note on `hold-reframe`.** This slice defines it **only at the Shape review point**, where
the object under work is unchanged, so the existing § Closing without a change path applies without
modification. A Prove-side `hold-reframe` would have to dispose of landed object edits — that is G2
candidate territory and is excluded. Stated as a limitation, not a hidden assumption.

---

## 7. Design

### 7.1 Plan identity structure (`PI`)

A plan identity has exactly three fields:

| Field | Form |
|---|---|
| `PLAN-PATH` | repository-relative path, e.g. `logs/loop/{shape-unit}.plan-v2.md` |
| `PLAN-COMMIT` | full 40-hex commit SHA at which the plan exists at that path |
| `PLAN-BLOB` | full 40-hex Git blob SHA of the plan at that commit |

**Binding relation — the one checkable rule:**

```
git rev-parse {PLAN-COMMIT}:{PLAN-PATH}  ==  {PLAN-BLOB}
```

The blob is the content hash and the authority on identity. The path is navigation; the commit makes
the path resolvable. Abbreviated SHAs are rejected — full 40-hex only, so comparison is exact string
equality with no ambiguity resolution. No additional generic hash is introduced
(`docs/work-loop-repair-workflow.md` §9.1).

### 7.2 Review-header identity carrier

Every Shape `REVIEW` block header carries three additional lines, immediately after the six standard
header fields:

```
PLAN-PATH:   logs/loop/{shape-unit}.plan-v2.md
PLAN-COMMIT: 1dc38b308b91ad4607dbe7f00797f739c058796d
PLAN-BLOB:   4e97dc9b7aed5c8a46868c9c68b4bcf2cfbac825
```

This is the **entire** change to `.agents/skills/work-loop/SKILL.md` — the minimum the comparison
consumes. The existing per-finding "state the object you inspected" rule at `:60` is retained
unchanged; it serves a different purpose and is not review-method expansion.

A review whose header omits any of the three fields, or carries a malformed one, is **not a valid
review** for the G1 precondition. It does not consume a review round; it is returned for a corrected
header. This prevents a malformed header from silently burning the correction budget.

### 7.3 The fail-closed comparison (the G1 precondition)

Runs in the Shape unit, **after adjudication and immediately before G1**, and only there.

1. Identify the **candidate plan** — the exact revision G1 would present.
2. Require it committed. An uncommitted or dirty candidate is a hard stop.
3. Compute candidate identity:
   - `PLAN-PATH` = the repository-relative path;
   - `PLAN-COMMIT` = `git log -1 --format=%H -- {PLAN-PATH}`;
   - `PLAN-BLOB` = `git rev-parse {PLAN-COMMIT}:{PLAN-PATH}`.
4. Read the identity from the header of the **latest valid review** (`review-2` if one exists,
   otherwise `review-1`).
5. Verify the review's own binding relation: `git rev-parse {PLAN-COMMIT}:{PLAN-PATH}` equals its
   stated `PLAN-BLOB`. This catches a header whose fields are internally inconsistent.
6. Compare all three fields by exact string equality.

**Any of the following blocks G1 — hard stop, not a warning:**

- the candidate plan is uncommitted, or absent;
- no review artifact exists for the Shape unit;
- the review header is missing `PLAN-PATH`, `PLAN-COMMIT` or `PLAN-BLOB`;
- any field is malformed (not a repository-relative path; not full 40-hex);
- the review's stated blob does not match `git rev-parse {its PLAN-COMMIT}:{its PLAN-PATH}`;
- any of the three fields differs from the candidate's.

The stop names **which field failed and both values**. G1 does not open, no package is presented, and
the operator is not asked to approve anything. Fail-closed: absence of proof blocks, exactly as
`docs/work-loop-repair-workflow.md` §9.1 requires ("Mismatch means G1 is blocked").

### 7.4 The G1 held package identities

The held package displays exact identities, not names (`docs/work-loop-repair-workflow.md` §9.1, §G1):

| Element | Displayed as |
|---|---|
| Plan | `PLAN-PATH` + `PLAN-COMMIT` + `PLAN-BLOB` |
| Review | artifact path + its commit + its blob, and which plan identity it names |
| Adjudication | one disposition per material finding, with reasons |
| Slice list | the slices Build will execute |
| Limitations | residual limitations, including any `unassessed` review |

The comparison result is stated explicitly as passed, with the matched blob shown.

### 7.5 Materiality

Imported from `docs/work-loop-repair-workflow.md` §9.3. A change is **material** when it can affect
execution or judgment: need or intended outcome · scope or exclusions · architecture or behavioural
design · interfaces, consumers or ownership · slice boundaries or ordering · acceptance or
falsification criteria · verification design · rollback or risk · the basis of a review verdict or
operator decision.

Spelling, punctuation, formatting and non-substantive citation repairs are non-material **only when
they do not change meaning**.

> **Ambiguity resolves as material.**

**Non-material notes never mutate the reviewed plan.** They are recorded in the adjudication or as a
G1 annotation. This is what prevents review churn: a wording suggestion cannot change the plan's
blob, so it cannot invalidate the review, so it cannot force another round.

### 7.6 Review and correction lifecycle

Per formal review point (this slice: the **Shape** review point):

1. **One initial independent review** — `review-1`.
2. **At most one material correction pass.** Material findings produce a new immutable revision
   (`-v{n+1}`); the reviewed revision is never edited.
3. **One conditional closure `review-2`** — permitted only when the correction changed something the
   first verdict rested on. Not on a general wish for more assurance.
4. **No `review-3`** in the same unit or stream.

After `review-2`:

| Result | Action |
|---|---|
| No remaining material change required | The exact reviewed revision may proceed to the §7.3 comparison, then G1 |
| Material change still required | **Close the stream `hold-reframe`** |

### 7.7 `hold-reframe`

A **fifth unit outcome**, joining the existing three that close a unit without altering the object
under work (`docs/work-loop.md` § Closing without a change). Shape makes no object edit, so that path
applies unchanged:

1. Write `logs/loop/{unit}.evidence.md` with outcome `hold-reframe`, the unresolved material
   finding(s), the exact plan and review identities, and populated `LIMITATIONS:`; mark
   `Status: complete`.
2. Write the `CLOSE` block with outcome `hold-reframe`; the stream closes in the same commit and its
   `logs/loop/{STREAM}-*` artifacts are deleted there.
3. Append the durable `logs/decisions.md` pointer with the recovery SHA.

`hold-reframe` is **terminal for that stream and is not a gate** — it opens no operator decision
point and adds no stop. Continuation starts a **new stream** with a new brief citing the held stream
and stating what was reframed (`docs/work-loop-repair-workflow.md` §10).

### 7.8 `review-2` artifact path — closes Frame OF-2

`.claude/commands/work-loop.md:131` hard-codes transcription to `review-1.md` while `:224`
acknowledges `review-2`, so the command names no path for a second review. Generalised:

```
logs/loop/{unit}.review-{n}.md      n ∈ {1, 2}
```

`n` starts at 1; `n = 2` is the closure review; `n ≥ 3` is not a valid artifact and its creation is a
defect. Immutable — `review-2` is never an edit to `review-1`.

### 7.9 Resolving the "one review round" conflict

`docs/work-loop.md:102` and `.agents/skills/work-loop/SKILL.md:42` both state "at most one review
round", contradicting the `review-2` permitted at `:94`, `:144` and command `:224` (Frame §2 P3
Part A). Both are corrected to state the actual rule — one initial review plus at most one
conditional closure review — and to cite the lifecycle section rather than restating it.

---

## 8. Ordered implementation steps and slice list

Three Build slices, ordered by dependency: the contract defines, the reviewer emits, the executor
compares. Each is one Build unit and one independently meaningful result.

### S1 — Contract: identity, lifecycle and terminal outcome
**File:** `docs/work-loop.md`

1. Add the plan-identity definition (§7.1) and its binding relation.
2. Require every Shape review header to carry the three-part identity (§7.2).
3. Add the G1 precondition (§7.3) as a contract rule: G1 cannot open unless the comparison passes;
   mismatch or missing identity is a hard stop.
4. State the G1 held package in identities, not names (§7.4).
5. Add the materiality definition, ambiguity-resolves-material, and the non-material-no-mutation rule (§7.5).
6. State the review/correction lifecycle and the no-`review-3` rule (§7.6); correct `:102`'s
   "at most one review round" (§7.9).
7. Add `hold-reframe` as the fifth outcome at `:196`/`:198`, and add its row to § Closing without a
   change (§7.7).
8. Generalise the review artifact path to `review-{n}`, n ∈ {1,2} (§7.8).

### S2 — Reviewer: the identity carrier
**File:** `.agents/skills/work-loop/SKILL.md`

1. Require the three header lines on every Shape `REVIEW` block (§7.2).
2. Correct `:42`'s "at most one review round" to cite the contract's lifecycle (§7.9).
3. No other change. `:60` is retained verbatim.

### S3 — Executor: comparison, G1 package, lifecycle mechanics
**File:** `.claude/commands/work-loop.md`

1. Insert the §7.3 comparison into Step 5a's Shape block, between adjudication (`:131`) and G1 (`:132`),
   with the hard-stop message naming the failed field and both values.
2. Rewrite the G1 presentation at `:132` to display identities (§7.4).
3. Generalise `:131`'s transcription target to `review-{n}` (§7.8).
4. State the lifecycle and the `hold-reframe` close path at Step 7/Step 8 (§7.6, §7.7); correct
   `:224` to match.

---

## 9. Affected interfaces and consumers

Verified this unit by repository scan (`grep -rln` over `*.md`).

| Consumer | Relationship | Impact |
|---|---|---|
| `.claude/commands/work-loop.md` | Reads the contract every invocation | **In scope** — S3 |
| `.agents/skills/work-loop/SKILL.md` | Reads the contract before its first block | **In scope** — S2 |
| `skills/capability-development/SKILL.md` | Cites the contract for process; owns method | **None.** Verified it restates no review round, no outcome vocabulary — grep for `review-1\|review-2\|review round\|rejected-premise\|Four outcomes` → zero, against a control of 23 `review` hits |
| `.claude/commands/develop-ai-resource.md` | Cites the contract for handoff labels | **None** — labels untouched |
| `docs/qc-independence.md` | Owns risk-aware review dimensions | **None** — dimensions untouched |
| `templates/capability-record.md:98` | Enumerates the four unit outcomes in `## Units` | **Gap — declared, not fixed.** See §14 |
| `plans/2026-07-28-work-loop-consolidated-build-plan.md`, `audits/risk-checks/*`, `logs/*` | Historical records | **None** — never rewritten (§3 of the repair workflow) |

---

## 10. Acceptance criteria

Positively stated and observable. Each has a stable ID and is verified in §12.

| ID | Criterion |
|---|---|
| **A1** | `docs/work-loop.md` defines plan identity as path + commit + blob, with the binding relation, and requires full 40-hex SHAs |
| **A2** | Both `docs/work-loop.md` and `.agents/skills/work-loop/SKILL.md` require the three-field header carrier on every Shape review |
| **A3** | `.claude/commands/work-loop.md` runs the comparison after adjudication and before G1, and hard-stops on any mismatch, missing field, malformed field or uncommitted candidate |
| **A4** | The G1 held package displays plan and review identities, not bare names |
| **A5** | Materiality is defined; ambiguity resolves as material; a non-material note provably cannot mutate the reviewed plan |
| **A6** | The lifecycle is stated as one initial review, ≤1 material correction, ≤1 closure `review-2`, no `review-3` |
| **A7** | `hold-reframe` exists as a terminal Shape-side outcome with a complete close path including the durable `logs/decisions.md` pointer, and creates no gate |
| **A8** | The `review-{n}` artifact path is defined with n ∈ {1,2} (closes OF-2) |
| **A9** | No "at most one review round" text survives in `docs/work-loop.md` or `.agents/skills/work-loop/SKILL.md` |
| **A10** | Exactly G1, G2 and G3 remain — no fourth gate anywhere in the three files |
| **A11** | The complete base-to-HEAD diff touches only the three in-scope files |

### Required mechanical scenarios (`docs/work-loop-repair-workflow.md` §12 row 1)

| ID | Scenario | Required result |
|---|---|---|
| **M1** | Reviewed v1, then materially revised v2 presented at G1 | **Blocks** |
| **M2** | The exact independently reviewed v2 presented at G1 | **Passes** |
| **M3** | A non-material note returned by the reviewer | **No plan mutation, no new revision, no new review round** |
| **M4** | `review-2` returns a material finding | **Cannot start a third cycle; closes `hold-reframe`** |
| **M5** | Header missing, incomplete, malformed, or blob/commit mismatched | **Blocks** |

---

## 11. Falsification criteria

Slice 1 is falsified if **any** of these is observed after implementation.

| ID | Falsifier |
|---|---|
| **F1** | A materially revised plan that no valid review inspected can reach G1 |
| **F2** | The exact independently reviewed plan is blocked from G1 — a false positive that would make the check unusable |
| **F3** | A wording-only, non-material note forces a new plan revision or an extra review round |
| **F4** | A material `review-2` finding can start a third same-unit or same-stream review cycle |
| **F5** | A missing, incomplete, malformed or mismatched identity field permits G1 to open |
| **F6** | A fourth operator gate appears, or `hold-reframe` behaves as a gate rather than a terminal close |
| **F7** | Any file outside the three in-scope paths is modified |

---

## 12. Verification

Working directory for every command: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan`.
Every negative result carries a positive control, per `docs/work-loop.md:204`.

### 12.1 The identity-comparison fixture — the real failure, replayed on real objects

The 2026-07-29 failure is reproducible from committed history with **zero mutation and no branch
switch**. All four values below were computed and confirmed while writing this plan.

```bash
# what review-1 actually inspected (v1)
git rev-parse 4c54344:logs/loop/2026-07-29-prime-minimum-responsibility-shape.plan.md
# → 1943f64849f15873707ed7fe80ac223c4aab0d24

# what review-2 actually inspected (v2)
git rev-parse 1dc38b3:logs/loop/2026-07-29-prime-minimum-responsibility-shape.plan-v2.md
# → 4e97dc9b7aed5c8a46868c9c68b4bcf2cfbac825

# what G1 actually received (v3)
git rev-parse 1dc38b3:logs/loop/2026-07-29-prime-minimum-responsibility-shape.plan-v3.md
# → ca274137f9e99460a29e3607f7e2d36079eba1a7
```

| ID | Case | Expected |
|---|---|---|
| **V-M1** | Compare review-2's blob `4e97dc9b…` against candidate v3 `ca274137…` | **Differ → blocks.** This is the historical failure; the check must catch it |
| **V-M2** | Compare v3's identity against itself — `git rev-parse 1dc38b3:…plan-v3.md` vs `ca274137…` | **Equal → passes.** Confirmed already: the match case returns `ca274137f9e99460a29e3607f7e2d36079eba1a7` |
| **V-M5a** | Drop `PLAN-BLOB` from a header copy | **Blocks** — missing field |
| **V-M5b** | Truncate a SHA to 7 hex | **Blocks** — malformed |
| **V-M5c** | Header stating v2's path with v3's blob | **Blocks** — binding relation `git rev-parse {commit}:{path} == blob` fails |

**V-M2 is the positive control for the whole comparison.** Without it, a check that blocks everything
would pass V-M1 while being useless — F2. Both directions are required.

**Containing-commit primitive**, confirmed:
`git log --diff-filter=A --format=%H -- …plan-v3.md` → `1dc38b308b91ad4607dbe7f00797f739c058796d`,
consistent with the abbreviated `1dc38b3` above.

### 12.2 Textual acceptance checks

Each grep is run against the three in-scope files, with the stated positive control.

| ID | Check | Expected | Positive control |
|---|---|---|---|
| A1 | `grep -nE 'PLAN-BLOB\|PLAN-COMMIT\|PLAN-PATH' docs/work-loop.md` | ≥1 per field | `grep -c 'plan' docs/work-loop.md` → non-zero (currently 7) |
| A2 | Same grep against `.agents/skills/work-loop/SKILL.md` | ≥1 per field | `grep -c 'REVIEW' SKILL.md` → non-zero |
| A3 | `grep -nEi 'hard stop\|blocks G1\|cannot open' .claude/commands/work-loop.md` | ≥1, sited between adjudication and G1 | Read the Step 5a block and confirm ordering |
| A5 | `grep -nEi 'ambiguity (resolves\|is treated) as material' <3 files>` | ≥1 | `grep -c 'material'` → non-zero |
| A7 | `grep -nE 'hold-reframe' <3 files>` | ≥1 in each of contract and command | `grep -c 'hold-reframe' docs/work-loop-repair-workflow.md` → 5 (regex proven to fire) |
| A8 | `grep -nE 'review-\{n\}\|review-2\.md' <3 files>` | ≥1 | as A7 |
| **A9** | `grep -nE 'at most one review round' docs/work-loop.md .agents/skills/work-loop/SKILL.md` | **zero** | Same regex against `git show 5590018:docs/work-loop.md` → must return `:102`. **Mandatory** — this is a negative result and is meaningless without proof the regex fires on the pre-change text |
| **A10** | `grep -nEi 'G4\|fourth gate\|four gates' <3 files>` | **zero**, except existing prose asserting "no fourth" | `grep -c 'G1' <3 files>` → non-zero |
| **A11** | `git diff --name-only 6050a5b HEAD` | exactly the three in-scope files plus this stream's `logs/loop/` artifacts | `git diff --name-only 6050a5b HEAD -- docs/work-loop.md` → non-empty after S1 |

**Shell note — mandatory.** This session's shell is `zsh`, which does **not** word-split unquoted
parameters. Frame §1 records a false negative caused by passing three paths through an unquoted
variable: they were read as one filename and every check returned a spurious "no matches". **Every
verification command above must use explicit literal paths or a shell array**, and every zero result
must be re-run against a known-matching corpus before being recorded.

### 12.3 What cannot be verified at Prove

These are documentation and instruction changes. Prove can verify the text, the diff bounds and the
identity-comparison arithmetic against real historical blobs. It **cannot** verify that a future
`/work-loop` session obeys the instruction — that is behavioural, requires a live challenged
Shape-to-G1 run, and belongs to Stage 9 (Use), not to this slice's Prove. Declared, not hidden.

---

## 13. Rollback and recovery

| Property | Value |
|---|---|
| Blast radius | Three markdown files in one repository. No script, hook, symlink, permission or setting. |
| Reversibility | Full. `git revert` of the S1–S3 Build commits, or abandon the branch — the approved base `6050a5b` is untouched. |
| Isolation | Dedicated worktree and branch; nothing merges to `main` without G2. |
| Partial-failure recovery | Slices are independently revertible. Reverting S3 alone leaves the contract defining an unenforced rule — a documented gap, not a broken command. Reverting S2 alone leaves the comparison without inputs, so **S2 and S3 revert together**. |
| Data loss risk | None. No deletion; no history rewrite; every artifact recoverable from Git. |
| Recovery command | `git revert --no-commit {S1..S3}` then a single revert commit on this branch |

---

## 14. Declared materiality boundaries

1. **`templates/capability-record.md:98` enumerates the four outcomes** in its `## Units` table. Adding
   `hold-reframe` makes that enumeration incomplete for a challenged **capability** stream that
   hold-reframes. The template is outside this slice's three-file scope, so it is **not** changed
   here. **Trigger to close:** the first capability stream to reach a `hold-reframe`, or the first
   later slice that already touches the template. Declared as a known bounded gap, not repaired
   silently and not used to widen scope.
2. **`hold-reframe` is defined for the Shape review point only** (§6 boundary note). Prove-side
   non-convergence is Slice 3.
3. **The comparison trusts a transcribed header.** Claude transcribes the Codex review verbatim, so a
   transcription error could produce a matching-but-wrong header. Mitigated — not eliminated — by
   step 5 of §7.3, which verifies the header's internal binding relation against Git. Full protection
   needs writer/ownership controls, which are Slice 4.
4. **No validator script is introduced.** The comparison is an instruction the executor follows.
   Mechanising it is Slice 5. This slice makes the rule exact and checkable; it does not automate it.
5. **Three of the four historical instances are documentation-grade evidence.** The behavioural claim
   rests on two reproduced streams, not on a live run.

---

## 15. Gates

**Exactly G1, G2 and G3 remain.** This slice adds no gate and removes none.

- The §7.3 comparison is a **precondition on G1**, not a gate — it produces no operator decision. It
  either lets G1 open or hard-stops before it.
- `hold-reframe` is a **terminal close**, not a gate — it ends a stream rather than asking a question.
- A passing comparison produces **no** stop; it is reported in one line inside the G1 package.

---

## 16. Open findings, deferred items, limitations

**Carried from Frame, still open:**

- **OF-1** — the G1-approved package mutated twice after G1 (`plan-v4` `bc435d5`, `plan-v5` `6a81121`),
  unreviewed. **Deferred**, §6. Not redesigned or reworded here.
- **OF-2** — `review-2` had no artifact path. **Closed by this plan**, §7.8 / A8.
- **OF-3** — a review named in `logs/decisions.md:11` has no artifact at `b8ef77f^`. **Deferred**, §6.

**Limitations of this plan:**

- No behavioural evidence exists or can exist before implementation (§12.3).
- The `:102` conflict's *causal* role in the observed failure remains inference, not observation
  (Frame §4 Confidence). This plan corrects the conflict because it is a confirmed textual defect,
  not because its causal role is proven.
- Line numbers cited throughout are as of blob `88f555e6…` / `0e575aa5…` / `33986fb8…` at HEAD
  `5590018`. If any authority file changes before Build, Build must re-derive them.

**Review and correction budget: fully intact.** No review has been requested, produced or
transcribed. One initial review, at most one material correction, and at most one conditional
`review-2` remain available.

LIMITATIONS: §14 and §16 above. This plan makes no object edit, opens no gate, and authorizes no
implementation. It is the object a fresh Codex task must now review at the exact identity reported
in this unit's handoff.
