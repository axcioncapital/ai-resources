UNIT: 2026-07-31-g1-reviewed-plan-invariant-prove   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: prove
REPO: ai-resources                                  BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: operator / Codex control room — G1-PV1-02 decision

# Prove evidence — Slice 1, G1 reviewed-plan integrity

Status: **complete.** Marked at close — see § 7. (This line read `incomplete — unit open` while the
unit was open; the closure operation is what changes it, per `docs/work-loop.md` Step 8.)

Governing authority: `docs/work-loop-repair-workflow.md` §§ Stage 8, 10, 11, 14.
Role: Claude repository engineer — sole writer, ownership acquired this session.
Working directory for every command below: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan`.

---

## 1. Entry 1 — 2026-07-31 — ownership acquisition and binding verification

The Build writer released ownership in the Build handoff commit `504cf499…` §8. This session
**explicitly acquires** sole-writer ownership; acquisition is never inferred from a new chat
(`…repair-workflow.md` §7). Verified against Git **before any write**; all fields matched, so §6.1's
hard stop did not fire.

| Field | Asserted by the envelope | Verified | Method |
|---|---|---|---|
| Repository | `ai-resources` | match — origin `…/axcioncapital/ai-resources.git` | `git remote get-url origin` |
| Worktree | `…/ai-resources-g1-reviewed-plan` | match | `git rev-parse --show-toplevel` |
| Branch | `codex/2026-07-31-g1-reviewed-plan-invariant` | match | `git rev-parse --abbrev-ref HEAD` |
| HEAD | `504cf4995c3d4f61cca987506756ac24e4ec4b87` | match | `git rev-parse HEAD` |
| Base | `6050a5b83f976583154f79ecfd5335691ba3d156` | ancestor **and** exact merge-base | `git merge-base --is-ancestor`; `git merge-base` |
| S1 commit | `8762fc7fc413d1149eb3dec531d235bc368d1108` | ancestor of HEAD | `git merge-base --is-ancestor` |
| Worktree state | clean | clean | `git status --porcelain` → empty |

**The candidate has not moved since the review's object was fixed.**
`git diff --name-only 8762fc7f HEAD -- <the four paths>` → **empty**. The only commits after S1 are the
Build evidence and Build handoff commits. All four target blobs are identical at S1 and at HEAD:
`8a7ba07f…` · `bc8e4931…` · `877a6645…` · `f9ac9d4d…`. **The review is not stale.**

**G1 remains valid.** `git rev-parse HEAD:{plan-v4}` → `9ae4839afc8ccb23c4bd50a2644f32213273ed90`,
equal to the approved identity at `df45a2b1…`. Shape review-2 still binds at `848ee9f9…`. Build
evidence binds at `8d890430…`, Build handoff at `8a8d8f36…` — every identity the reviewer declared was
independently recomputed here and matched.

## 2. Entry 2 — 2026-07-31 — Prove review-1 received and transcribed

Envelope compared field by field against the active binding (§6.1) before any write: repair · slice ·
unit · stream · repo · worktree · branch · base · HEAD · object identity · role. **All matched. No stop
fired.**

Transcribed **verbatim and unedited** — no rewording, no reordering, no correction of the reviewer's
prose (`…repair-workflow.md` §5.4). Review identity computed **after** transcription and commit, which
is the sequence plan-v4 §6.2 specifies and which this unit is now the second worked example of:

| Field | Value |
|---|---|
| `REVIEW-PATH` | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-prove.review-1.md` |
| `REVIEW-COMMIT` | `34563750a3fa80c0e3a8c112616a8a58d57026f6` |
| `REVIEW-BLOB` | `1144ef835547864e43bcbe5fcda8baa25a237527` |

**Binding relation verified:** `git rev-parse "${REVIEW-COMMIT}:${REVIEW-PATH}"` → `1144ef83…`. Holds,
and resolves identically at HEAD.

**Note on the header rule this slice introduces.** The returned block carries no `PLAN-PATH` /
`PLAN-COMMIT` / `PLAN-BLOB` lines, and that is **correct, not a defect**: the candidate's own rule
(`docs/work-loop.md` § The review header) requires them on **Shape** reviews, whose object is a plan.
This is a Prove review, whose object is the implementation. Nothing was validated against a rule that
does not apply. Separately, the candidate is not yet adopted — the operative authority for this review
is `…repair-workflow.md` §11, and that is what was applied.

**Verdict: REVISE BEFORE G2.** Material findings: 2. Minor: 0. Binding verification: PASS.

---

## 3. ADJUDICATION

One disposition per material finding, from the six at `docs/work-loop.md` § Block formats. **G2 is not
opened by this adjudication** — the verdict is REVISE BEFORE G2, so the candidate does not proceed.

**Every finding was independently reproduced against the live files before being dispositioned.** A
review's premises are verified, not accepted (`…repair-workflow.md` §5.3). Neither finding is rejected;
both reproduce exactly as stated.

### G1-PV1-01 — Shape-only `hold-reframe` leaks into Prove and the reviewed route — **`deferred`**

**Accepted. The finding is correct, it is material, and the defect is mine — introduced by my own
rendering at Build, not present in the approved plan.**

**Reproduced on the live candidate:**

| Claim | What was inspected | Observed |
|---|---|---|
| Step 7 governs the reviewed route and challenged Prove | `.claude/commands/work-loop.md:258–266` | Confirmed — `:262` "**Reviewed route:**", `:264` "**Challenged route:** … the Prove unit (object: the result)" |
| `:272` states the `hold-reframe` branch **without a phase qualifier** | `:272`, read in full | Confirmed — "If a material finding survives `review-2`, the correction lifecycle is spent: the stream closes `hold-reframe`". No Shape restriction anywhere in the sentence or its paragraph |
| The contract's generic statement precedes its qualifier | `docs/work-loop.md:212–215` then `:225` | Confirmed — § Correction lifecycle states "material change still required → the stream closes **`hold-reframe`**" with no phase scope; "**Shape review point only**" arrives at `:225`, in the *following* subsection |
| The `review-3` sentence is generic | `docs/work-loop.md:293` | Confirmed — "a `review-3.md` … is a signal that the stream should have closed `hold-reframe`", unscoped |
| The Prove branch cannot name a `review-2` artifact | `.claude/commands/work-loop.md:178` | Confirmed — still hard-codes "transcribe verbatim to `logs/loop/{unit}.review-1.md`" |
| One surface **is** correctly scoped | `docs/work-loop.md:347` | Confirmed — "at a challenged **Shape** review point". This is the control showing the qualifier was available and simply not applied consistently |

**Why it is material and not a wording nit.** Plan-v4 §13.1 declares `hold-reframe` Shape-side only and
excludes Prove-side non-convergence to Slice 3 (§5). A Prove unit reaching `hold-reframe` would
terminally close a stream **containing landed object edits** instead of putting the unresolved release
question at G2 — the one thing §6.9 says belongs to G2. Under plan-v4 §6.11 ambiguity resolves as
material, and this is worse than ambiguity: `:272` is unqualified in a step that expressly covers other
phases.

**The reviewer is also right that BF-2 is no longer safely deferred.** My Build evidence deferred it on
the reasoning that Prove-side review mechanics belong to Slice 3. That reasoning holds *only* while
nothing makes a Prove `review-2` operational — and my own `:272` sentence did exactly that. The
deferral was sound about the approved plan and wrong about what I had actually written.

**Correction, specified now so it can be authorized with full sight.** It is the reviewer's smaller
option — remove the generic promise rather than build a Prove `review-2` path, which is Slice 3's and
is excluded. Three edits, in two files already in scope:

1. `.claude/commands/work-loop.md:272` — scope the terminal branch to a **challenged Shape** review
   point; state that an unresolved Prove finding remains a **G2 release question**; state that the
   reviewed route does not acquire the outcome.
2. `docs/work-loop.md:212–215` — carry the Shape qualifier at the point of the statement, not only in
   the subsection after it.
3. `docs/work-loop.md:293` — scope the `review-3` sentence so it cannot be read as routing a Prove unit
   to `hold-reframe`.

This touches no file outside the four, adds nothing new, and restores BF-2 to a genuinely safe
deferral.

**Why `deferred` and not `fixed`.** Nothing has been fixed — the operator directed that the
implementation not be modified in this unit, and recording `fixed` for work not done would be exactly
the claim-to-evidence failure this review process exists to catch. It is deferred **inside this unit**,
not out of the stream. **Reopening trigger: the operator authorizes the bounded correction pass.**
There is only one such pass and G1-PV1-02 currently gates it (below), so the two findings are corrected
together or not at all. **G2 cannot open until this is fixed.** On authorization the disposition
converts to `fixed` and the conversion is recorded as a new append entry here.

### G1-PV1-02 — A20 fails and F12 fires on the approved-base-to-HEAD diff — **`operator`**

**Accepted. The finding is correct and material, and my Build evidence's A20 `PASS` was wrong.**

**Reproduced, with the positive control the check requires:**

| Check | Command | Observed |
|---|---|---|
| Complete path set | `git diff --name-only 6050a5b HEAD` | **19 paths** — exactly as the reviewer states |
| Paths outside A20's allowed set | same, filtered against `^logs/loop/` and the four literal targets | **`docs/work-loop-repair-workflow.md`** — one path |
| **Positive control** | same filter, kept `^docs/work-loop\.md$` | fired → `docs/work-loop.md`. The filter can detect an allowed target, so the single hit is not an artefact of a broken filter |
| The S1 commit itself | `git show --name-only 8762fc7f` | the four targets and nothing else — **atomic, as approved** |

**The decisive fact the review did not have.** I traced when the offending path entered:

```
git log --oneline --reverse 6050a5b..HEAD | head -5
  bfa3315  loop: … — fresh Frame brief
  17ad3aa  new: work-loop-repair-workflow — supervised multi-session repair method
  5590018  loop: … Frame evidence
  d44a4fc  loop: … PLAN v1 written
  bb47618  loop: … PLAN v2, operator scope reframe
```

`docs/work-loop-repair-workflow.md` entered at **`17ad3aa`, the second commit of the entire repair** —
before Frame evidence, before plan-v1, and long before Build. It has **never been modified since**
(`git diff --name-only 8762fc7f^ HEAD -- <that path>` → empty).

Therefore:

| At | Was A20's set already violated? |
|---|---|
| review-1's commit `96b27e53…` | **Yes** — `docs/work-loop-repair-workflow.md` |
| plan-v4's commit `df45a2b1…` (what review-2 inspected, and what G1 approved) | **Yes** — same path |

**A20 was unsatisfiable from the moment it was written.** It passed review-1, the bounded correction
pass, review-2 and G1 without being caught. This is a criterion-authoring defect in the approved plan,
not a Build regression — Build changed exactly the four files it was authorized to change.

**That is an explanation of A20, not an excuse for my evidence.** My Build evidence A20 row recorded
the observation honestly — it lists the extra path — and then labelled the row **PASS**. The
observation contradicts the row's own stated expectation. That is a claim-to-evidence failure I own,
and the reviewer was right to call the "all A1–A20 pass" claim false.

**Three of my Build verdicts are wrong and are superseded here:**

| Criterion | Build evidence said | Correct verdict | Why mine was wrong |
|---|---|---|---|
| **A13** | PASS | **FAIL** | I cited the contract's Shape-only reservation and never checked the command sentence I had written myself in the same commit |
| **A16** | PASS | **FAIL in consumer coherence** | Contract-side is correct; I did not test it against the Prove branch my own generic rule had just made reachable |
| **A20** | PASS | **FAIL** | The row's observation contradicted its expectation and I recorded PASS anyway |

The Build evidence file is **left unedited**. It is append-only, and the Shape unit set the precedent
when Entry 3 was superseded by Entry 4 rather than rewritten: the earlier record stands as what was
claimed at the time, and this entry is the operative correction. If the operator prefers an in-file
supersession note appended to the Build evidence, that is a one-line change and I will make it on
request.

**Why the disposition is `operator` and not `fixed` or `rejected`.** No edit available to me can make
A20 true:

- editing plan-v4 to widen A20 **changes its blob, voids G1** (`…repair-workflow.md` §9.2, §11);
- editing the candidate cannot help — the offending path is not part of the candidate;
- deleting `docs/work-loop-repair-workflow.md` would delete the **active governing authority of this
  repair** to satisfy a diff filter. The reviewer names this as unsafe and I agree;
- recording it as a Prove annotation would be smuggling a material G1-premise change past the gate that
  exists to catch exactly that.

This is a decision the loop cannot make. **It is the operator's, and it is stated in §5 below.**

---

## 4. Budget after this adjudication

| Item | Status |
|---|---|
| Initial independent Prove review | **Consumed** — `34563750…`, blob `1144ef83…`, 2 material findings |
| One bounded material correction pass | **Available, unspent, and currently gated** on the G1-PV1-02 decision |
| One conditional closure `review-2` | **Available**, and would be justified — both corrections change matters this verdict rests on |
| `review-3` | **Does not exist** in this unit or stream |
| **G2** | **Closed.** Not opened, not armed, no package presented |

If a correction is authorized and `review-2` then returns a further unresolved material finding, the
Shape-side terminal outcome does **not** apply here — this is a Prove unit, and plan-v4 §13.1 reserves
`hold-reframe` for Shape. The result would be an unresolved release question at G2, which is precisely
the boundary G1-PV1-01 exists to restore.

## 5. The decision this unit cannot make — for the operator / control room

**G1-PV1-02 requires an authorized, binding-consistent resolution before the correction pass is spent.**
Three options; the third is listed to be ruled out rather than because it is viable.

**Option A — record an operator-issued scope binding. Recommended.**
The operator states that Slice 1's permitted base-to-HEAD set is the four target files, this stream's
`logs/loop/` artifacts, **and** `docs/work-loop-repair-workflow.md` — the repair's own governing
authority, established at `17ad3aa` before the slice was shaped and unmodified since (blob
`37c6be795568dd6942dc3883bb067ff03b0a5007`).
*Why it is the right one:* it states what is already true rather than changing what was built. The
property A20 and F12 actually protect — no unapproved change to any object — **is satisfied**, and the
S1 commit proves it. plan-v4's bytes are untouched, so its identity stays `9ae4839a…` and **G1 remains
valid**.
*The risk, stated plainly:* this is a post-G1 clarification of an approved criterion's reading, which
is adjacent to **OF-1** (the deferred finding that the 2026-07-29 package was mutated after G1). It
differs in that nothing is edited and the decision is explicit, attributed and recorded — the opposite
of a silent mutation — but the adjacency is real and the operator should decide with it in view.

**Option B — accept A20/F12 as failed and stop.**
Truthful and available. It closes the stream without the slice landing, on a criterion that was
unsatisfiable when written, while the change it governs is sound. Disproportionate on the evidence, but
it is the honest fallback if Option A is judged too close to OF-1.

**Option C — move the approved base past `17ad3aa`. Not recommended.**
It would make A20 literally true with no reinterpretation, but `BASE:` is a binding field printed in
every artifact of this stream — the Frame brief, plan-v1 through v4, both reviews, all evidence and
both handoffs — and plan-v4 §11.5 names `6050a5b` as a literal command argument. It would make every
one of those stale and contradict the approved plan's own verification text. Strictly worse than A.

**Nothing in this unit presumes the answer.** No file outside `logs/loop/` was touched, the correction
pass is unspent, and G2 is closed.

---

LIMITATIONS (Entries 1–2, as written before the correction pass): This entry adjudicates an
implementation review; **no object under repair was modified in
this unit** and no correction has been made, so nothing here demonstrates that either finding is
resolved. Both findings were reproduced against the live candidate blobs, but the resolutions are
**specified, not written** — as at Shape Entry 3, recording the chosen resolution before spending the
single correction pass is deliberate, so the control room can object while an objection still has
budget to act on. The A20 analysis rests on Git history, which is observation; the claim that A20's
authoring defect *caused* no substantive scope violation rests on the S1 commit's contents, which is
also observation — but the judgment that this makes Option A proportionate is mine and is the
operator's to overturn. No behavioural evidence exists or can exist before Stage 9 (Use): M8, M9 and
M10 remain unexecuted. Line numbers cited are as of the candidate blobs `8a7ba07f…` (contract) and
`877a6645…` (command) and will move once the correction lands. The unit remains **open** and **G2
remains closed**.

---

## 6. Entry 3 — 2026-07-31 — operator binding recorded, correction pass spent, criteria re-measured

Appended, not rewritten (`docs/work-loop.md` § Artifacts). Entries 1–2 stand unedited as the record of
what was decided before the operator's decision arrived.

**Two things in this file's header block are now superseded, and are deliberately left unedited:** the
status note's clause "the bounded correction pass is unspent" — it is now **consumed** (§6.5) — and the
`NEXT:` field, since the decision has been made and the next actor is a fresh Codex Prove reviewer. The
`Status: incomplete — unit open` marker itself **remains correct**: the unit is still open, G2 is still
closed, and § Resume order must keep offering this stream.

### 6.1 The operator's binding, recorded verbatim in substance

**Option A approved, as a narrow Slice-1-only scope binding.** For this Slice 1 candidate the permitted
`BASE..HEAD` path set is:

1. the four G1-approved implementation targets;
2. this stream's `logs/loop/` artifacts;
3. `docs/work-loop-repair-workflow.md` at its existing immutable identity — introducing commit
   `17ad3aa4209904991467796dd904a80a2c7bf0b8`, blob `37c6be795568dd6942dc3883bb067ff03b0a5007`.

That document is classified as **pre-Shape repair-program governance, not an S1 implementation target.**

**The binding does not:** authorize modifying `docs/work-loop-repair-workflow.md` · add it to the
implementation slice · widen the four target-file scope · change the approved base · mutate plan-v4 or
its identity · create a general exception for any other file, stream or slice.

**Any different blob for that path, or any additional outside path, still fails the bounded-diff
requirement.** The binding supersedes A20/F12's previously unsatisfiable path-set reading **only** to
the precise extent stated above.

**Verified against Git before the binding was relied on:**

| Condition | Command | Observed |
|---|---|---|
| Commit resolves | `git rev-parse 17ad3aa4209904991467796dd904a80a2c7bf0b8` | resolves; subject "new: work-loop-repair-workflow — supervised multi-session repair method" |
| Blob at that commit | `git rev-parse 17ad3aa4…:docs/work-loop-repair-workflow.md` | `37c6be795568dd6942dc3883bb067ff03b0a5007` |
| Blob at HEAD | `git rev-parse HEAD:docs/work-loop-repair-workflow.md` | `37c6be795568dd6942dc3883bb067ff03b0a5007` — **identical, so the binding's condition is met** |
| Predates the approved package | `git merge-base --is-ancestor 17ad3aa4… df45a2b1…` | true — it precedes plan-v4 and G1 |

**G1-PV1-02 — disposition updated from `operator` to `fixed`.** Resolved by this exact binding, not by
any edit. plan-v4 remains at blob `9ae4839a…`; the approved base remains `6050a5b…`; the repair
workflow was not touched.

### 6.2 The correction pass — spent once, on both findings

**Commit `e384d8c383c226f00176abe6956bf5f5c29acab8`.** Two files, both already in scope.
`.agents/skills/work-loop/SKILL.md` and `templates/capability-record.md` were **not** touched —
verified: their blobs still equal their S1 values `bc8e4931…` and `f9ac9d4d…`.

**G1-PV1-01 — disposition updated from `deferred` to `fixed`.** Five sites, not the three specified:

| # | Site | Correction | Source |
|---|---|---|---|
| 1 | `.claude/commands/work-loop.md:272` | Per-review-point table — Shape closes `hold-reframe`; **Prove carries the finding into G2 as a residual limitation**; reviewed route takes neither | Specified in review |
| 2 | `docs/work-loop.md:212` | "After `review-2` **at a challenged Shape review point**", plus an explicit non-application paragraph | Specified in review |
| 3 | `docs/work-loop.md:295` | The `review-3` signal no longer routes a Prove unit to `hold-reframe` | Specified in review |
| 4 | `docs/work-loop.md:94` | **Found by the required negative search, not named in the review.** The § challenged route paragraph — which speaks of `review-2` "in either unit" — asserted `hold-reframe` with no phase qualifier. The most exposed leak of the five, because it sits in the section a reader consults for route behaviour | This unit |
| 5 | `.claude/commands/work-loop.md:168` | **Also found by the negative search.** Step 5a's Shape-block sentence was scoped only by its surrounding heading; now qualified in its own text | This unit |

Sites 4 and 5 are the same defect class the review named. Correcting only the three cited lines would
have left the leak reachable, so the correction covers the class rather than the citation list. No new
rule, no new outcome, no new machinery was introduced.

### 6.3 Traces the review required to close

| ID | Check | Expected | Observed | Verdict |
|---|---|---|---|---|
| **T1** | **Negative** — a close-rule mention of `hold-reframe` with no Shape qualifier | zero genuine leaks | Raw grep returns **four** lines; each inspected individually and **none is a leak** — see the adjudication below | **PASS** |
| **T2** | **Positive control for T1** — the same grep must still find the Shape close-rules | non-zero | **4** close-rule lines carry a Shape qualifier (`docs/work-loop.md:94`, `:212`; `.claude/commands/work-loop.md:168`, `:278`). The search can detect the construct it looks for | **PASS** |
| **T3** | **Positive trace** — a Shape `review-2` material finding still closes `hold-reframe` | intact | `docs/work-loop.md:212–215` and `.claude/commands/work-loop.md:168`, `:278` | **PASS** |
| **T4** | **Positive trace** — Prove still reaches G2 with an unresolved finding | intact | `docs/work-loop.md:84`, `:94`, `:217`; `.claude/commands/work-loop.md:179`, `:279` — all route it to G2 as a residual limitation | **PASS** |
| **T5** | Reviewed route does not acquire the terminal outcome | stated | `.claude/commands/work-loop.md:280`; `docs/work-loop.md:217` | **PASS** |

**T1's four raw hits, adjudicated one by one — a bare "zero" would have been false, so it is not
claimed:**

| Line | Why it is not a leak |
|---|---|
| `docs/work-loop.md:215` | The bullet's qualifier is in its lead-in two lines above (`:212`, "at a challenged Shape review point"). The grep is line-scoped and cannot see it |
| `docs/work-loop.md:217` | **This is the fix** — it states that the branch does *not* apply outside Shape |
| `docs/work-loop.md:363` | § Closing without a change, step 1: what evidence must carry *once* an outcome is used. A consequence rule, not a close rule |
| `.claude/commands/work-loop.md:217` | The capability-record transition, conditioned on a stream having already closed `hold-reframe` — an event now reachable only at Shape. Downstream of the close rule, not a second statement of it |

### 6.4 Acceptance and falsification criteria re-measured

| ID | Before | Now | Evidence |
|---|---|---|---|
| **A12** | PASS, boundary caveat | **PASS** | Lifecycle intact at `docs/work-loop.md:207–210`; the caveat was the leak, now closed |
| **A13** | **FAIL** | **PASS** | Terminal branch confined to challenged Shape at five sites; `Shape review point only` retained at `:227` |
| **A16** | **FAIL in consumer coherence** | **PASS** | `review-{n}`, `n ∈ {1,2}` at `:295`; no rendering routes Prove to `hold-reframe`, so the Prove branch's `review-1.md` no longer contradicts anything |
| **A17** | PASS | **PASS, unchanged** | Template blob still `f9ac9d4d…`, identical to S1 |
| **A18** | PASS | **PASS** | `grep -nE 'at most one review round'` → zero on both files; control fires at `d44a4fc:docs/work-loop.md:102` |
| **A19** | PASS | **PASS** | `grep -nEi 'G4\|fourth gate\|four gates'` → one hit, the pre-existing `:96` prohibition. No new occurrence |
| **A20** | **FAIL** | **PASS under the operator binding** | Filter over `git diff --name-only 6050a5b HEAD` excluding the three permitted classes → **zero paths**. Positive control: the same filter with `docs/work-loop.md` un-excluded returns it, so the filter works |
| **F4** | did not fire | **does not fire** | No third cycle at any review point |
| **F11** | did not fire | **does not fire** | `hold-reframe` remains a terminal close, not a gate (`docs/work-loop.md:225`); exactly G1, G2, G3 |
| **F12** | **FIRED** | **does not fire** | No path outside the operator-bound permitted set; the third path's blob matches `37c6be79…` exactly |

A1–A11, A14 and A15 were not touched by this correction and were verified unaffected — the two edited
files' other sections are unchanged, and the two untouched files are byte-identical to S1.

### 6.5 Budget after the correction pass

| Item | Status |
|---|---|
| Initial independent Prove review | **Consumed** — `34563750…`, blob `1144ef83…` |
| One bounded material correction pass | **Consumed** — commit `e384d8c3…`, one pass, both findings |
| One conditional closure `review-2` | **Available, and justified** — the correction changed matters this verdict rested on |
| `review-3` | **Does not exist** in this unit or stream |
| **G2** | **Closed.** Not opened, not armed, no package presented |

If `review-2` returns a further unresolved material finding, `hold-reframe` does **not** apply — this
is a Prove unit, and the correction just made that explicit. The finding would be carried into G2 as a
residual limitation for the operator to decide.

LIMITATIONS: The corrections are text. They were verified by reading every changed site, by a negative
search whose four raw hits were each adjudicated rather than dismissed, and by positive controls on
both the search and the path filter — **none of that demonstrates that a future session obeys them**,
which is behavioural and belongs to Stage 9 (Use). M8, M9 and M10 remain unexecuted. A20 now passes
**only** under the operator's Slice-1 binding; on plan-v4's literal wording it remains unsatisfiable,
and the binding is recorded rather than folded into the plan, whose blob is untouched at `9ae4839a…`.
The judgment that sites 4 and 5 belong inside the same correction — rather than being new scope — is
mine: they are the identical defect class in the same two files, and leaving them would have left the
finding open. A fresh reviewer may overturn it. Line numbers are as of blobs recomputed in §7. The unit
remains **open** and **G2 remains closed**.

---

## 7. CLOSE — 2026-07-31

**Outcome:** `close` — the work landed.

**Operator decisions, Slice 1 only:** repository transcription and identity tracking for Prove
`review-2` **waived**; the Codex closure verdict that both findings are resolved **accepted**;
**G2 APPROVED** for exact candidate HEAD `179bc0d60d7846c0343e124658c1ba70572253de`; representative Use
**waived** with the documented residual limitations accepted; **G3 ADOPT — Slice 1 complete.**

**Durable Git pointer** (the closing commit is this branch's tip and cannot name itself):

| Anchor | SHA |
|---|---|
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` |
| S1 implementation | `8762fc7fc413d1149eb3dec531d235bc368d1108` |
| Bounded correction | `e384d8c383c226f00176abe6956bf5f5c29acab8` |
| **G2/G3-approved candidate HEAD** | `179bc0d60d7846c0343e124658c1ba70572253de` |

**Final target blobs:** `docs/work-loop.md` `c0226b7868ba63355c8dfeadffd610e3ba3bbfcd` ·
`.claude/commands/work-loop.md` `74aa0c2b86e3fe710ca5c170eff78e6dff942cc2` ·
`.agents/skills/work-loop/SKILL.md` `bc8e4931178586f79b53aa5ca03cd9203636db64` ·
`templates/capability-record.md` `f9ac9d4d5e838a194cdf78734e9a5cd61440975a`.

**What closed:** the Prove unit and, with it, the stream `2026-07-31-g1-reviewed-plan-invariant`.
Non-capability work — no record, no `status:` axis.

**Artifacts retained, not deleted.** `/work-loop`'s stream-close deletion does not govern this repair
(`docs/work-loop-repair-workflow.md` §1, §13.1), and § Stage 10 forbids deleting temporary artifacts
while they are the repair program's record. Slice 1 is one of eight.

**Residual limitations carried into adoption, unchanged:** the RV2-01 content-level residual
(plan-v4 §13.4) · no validator; every check is an instruction (§13.5) · the allocation exception is
stated, not enforced (§13.6) · no behavioural evidence — M8/M10 unexecuted, Use waived (§11.6) ·
deferred BF-1, BF-2, OF-1, OF-3.

**Ownership release.** Effective with the commit containing this block, I release sole-writer ownership
of this repair worktree. No other session may write before explicitly acquiring it.

Status: complete. Stream closed.
