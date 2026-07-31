REPAIR: work-loop  
SLICE: Slice 1 — G1 reviewed-plan integrity  
UNIT: 2026-07-31-g1-reviewed-plan-invariant-prove  
STREAM: 2026-07-31-g1-reviewed-plan-invariant  
REPO: ai-resources  
WORKTREE: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan  
BRANCH: codex/2026-07-31-g1-reviewed-plan-invariant  
BASE: 6050a5b83f976583154f79ecfd5335691ba3d156  
HEAD: 504cf4995c3d4f61cca987506756ac24e4ec4b87  
OBJECT: S1 implementation commit 8762fc7fc413d1149eb3dec531d235bc368d1108, the four target blobs below, and Build evidence at commit a8256df72e9430d37f8d50f77ccb55debcadeaec  
ROLE: fresh Codex reviewer  
NEXT: Codex control room returns this initial Prove review verbatim to a new Claude Prove session for transcription and adjudication. G2 is blocked. Do not mutate the candidate until both material findings are adjudicated and the base/scope contradiction has an operator-authorized resolution.

REVIEW

## Binding verification

**PASS.**

The repository resolves to `ai-resources` with origin `https://github.com/axcioncapital/ai-resources.git`. The absolute worktree, branch and current HEAD match the envelope. `git status --porcelain` is empty: no staged, unstaged or untracked state exists.

The approved base is both the exact merge-base and an ancestor of reviewed HEAD:

- Approved base: `6050a5b83f976583154f79ecfd5335691ba3d156`
- Reviewed HEAD: `504cf4995c3d4f61cca987506756ac24e4ec4b87`
- Implementation commit: `8762fc7fc413d1149eb3dec531d235bc368d1108`
- Implementation commit is an ancestor of reviewed HEAD.
- The only commits after implementation are the Build evidence commit and Build handoff commit.
- No target file changed after the implementation commit.

The four candidate target blobs at implementation commit and reviewed HEAD are identical:

- `docs/work-loop.md` — `8a7ba07ff0a40473ad8fbf4d7e93d676adaa84a2`
- `.agents/skills/work-loop/SKILL.md` — `bc8e4931178586f79b53aa5ca03cd9203636db64`
- `.claude/commands/work-loop.md` — `877a664511697495881c103a863227380f66d848`
- `templates/capability-record.md` — `f9ac9d4d5e838a194cdf78734e9a5cd61440975a`

The approved Shape package binds:

- Plan: `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v4.md`
- Plan commit: `df45a2b1a42a2140c85a56e71c395407dc9eb903`
- Plan blob: `9ae4839afc8ccb23c4bd50a2644f32213273ed90`
- Shape review-2: `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.review-2.md`
- Review commit: `12b22dd9acfc76094f0803f29d64b5935ead4f83`
- Review blob: `848ee9f940c562f421c6ef727e358d21c73a299f`

The Build artifacts bind:

- Build evidence: `logs/loop/2026-07-31-g1-reviewed-plan-invariant-build-1.evidence.md`
- Evidence commit: `a8256df72e9430d37f8d50f77ccb55debcadeaec`
- Evidence blob: `8d890430d7e4a3a3291bc760c6b04fbfa05ffc7d`
- Build handoff: `logs/loop/2026-07-31-g1-reviewed-plan-invariant-build-1.handoff.md`
- Handoff commit: `504cf4995c3d4f61cca987506756ac24e4ec4b87`
- Handoff blob: `8a8d8f36ec365a2005535112910016b3b3f87bed`

## Verdict

**REVISE BEFORE G2.**

Material findings: **2**  
Minor findings: **0**  
New findings: **2**

The implementation commit itself is atomic and changes exactly the four approved target files. The core G1 plan-identity mechanism is substantially faithful. G2 nevertheless cannot open because:

1. the new lifecycle language leaks the Shape-only `hold-reframe` outcome into Prove and reviewed-route execution; and
2. exact acceptance criterion A20 and falsifier F12 fail on the declared approved-base-to-HEAD diff.

## Material findings

### G1-PV1-01 — MATERIAL — Shape-only `hold-reframe` leaks into Prove, and BF-2 is not safely deferred

**Objects inspected:**

- `docs/work-loop.md` at blob `8a7ba07f…`, especially lines 205–225 and 286–293.
- `.claude/commands/work-loop.md` at blob `877a6645…`, especially lines 168, 174–181 and 258–272.
- Plan-v4 at blob `9ae4839a…`, especially A13, A16 and declared boundary §13.1.
- Build evidence at blob `8d890430…`, especially A12–A16 and BF-2.

**Evidence:**

Plan-v4 line 559 makes the boundary explicit:

> `hold-reframe` is Shape-side only. Prove-side non-convergence is Slice 3.

The contract repeats this at `docs/work-loop.md:225`:

> Shape review point only. A Prove-side `hold-reframe` … belongs to G2.

The outcome enumeration at `docs/work-loop.md:347` also limits `hold-reframe` to a challenged Shape review point.

But `.claude/commands/work-loop.md:272` is a general Step 7 rule. Step 7 expressly applies to the reviewed route and to challenged Prove at lines 262–266. It says without qualification:

> If a material finding survives `review-2` … the stream closes `hold-reframe`.

That gives a Prove unit—and also ordinary reviewed-route work—a route that the approved plan reserves for Shape. For Prove this can terminally close a stream containing landed object edits instead of presenting the unresolved release question at G2.

The consumer is additionally incoherent about how such a Prove `review-2` would exist:

- the generic lifecycle at command line 272 permits `review-2`;
- the contract’s artifact rule at line 293 defines `review-{n}`, `n ∈ {1,2}`;
- the Prove branch at command line 178 still hard-codes transcription to `review-1.md`.

Build finding BF-2 therefore is not safely deferred under the candidate as written. It becomes operational as soon as the newly generalized Step 7 lifecycle is applied to Prove.

The same ambiguity appears in `docs/work-loop.md:212–215` and `:293`, which refer generically to post-`review-2` `hold-reframe`, despite the later Shape-only qualifier. Plan-v4’s materiality rule says ambiguity resolves as material.

**Impact:**

- A13 fails: `hold-reframe` is not confined consistently to unresolved Shape `review-2`.
- A16 is not coherent across the changed consumers.
- Prove non-convergence can bypass or distort G2.
- Reviewed-route work acquires challenged-Shape terminal machinery, weakening proportionality.
- BF-2 cannot be represented as harmlessly deferred while the generic rule depends on it.

**Smallest required correction:**

Confine the `hold-reframe` terminal branch expressly to a challenged Shape review point everywhere the new lifecycle appears. In the general Step 7 adjudication rule, state that:

- challenged Shape follows the bounded lifecycle and may close `hold-reframe`;
- unresolved Prove findings remain a G2 release question;
- reviewed-route behavior remains proportionate and does not acquire Shape’s terminal outcome.

Reconcile the generic artifact/lifecycle wording so it cannot be read as routing Prove to `hold-reframe`. Either implement a coherent Prove `review-2` path or preserve BF-2’s deferral by removing the new generic promise; the latter is the smaller correction and matches plan-v4’s explicit exclusion.

**Evidence required to close:**

- Full reads of the corrected contract and command show no path from challenged Prove or reviewed-route `review-2` to `hold-reframe`.
- The Shape `review-2` material-finding path still closes `hold-reframe`.
- Prove still reaches G2 with unresolved findings.
- A positive trace demonstrates the Shape path, and a negative search for unqualified post-`review-2` `hold-reframe` rules is backed by that positive control.
- The Prove review-path language and the retained BF-2 disposition no longer contradict each other.

### G1-PV1-02 — MATERIAL — A20 fails and F12 fires on the exact approved-base-to-HEAD diff

**Objects inspected:**

- Plan-v4 A20 at line 432 and F12 at line 466.
- Build evidence A20 row at line 110.
- Complete diff `6050a5b83f976583154f79ecfd5335691ba3d156..504cf4995c3d4f61cca987506756ac24e4ec4b87`.

**Required result:**

A20 requires the base-to-HEAD diff to contain only:

- the four target files; and
- this stream’s `logs/loop/` artifacts.

F12 fires if any file outside the four in-scope paths is modified.

**Observed result:**

The complete diff contains one additional path:

`docs/work-loop-repair-workflow.md`

A filtered negative check returned that exact path. Its positive control found `docs/work-loop.md`, proving the filter could detect an allowed target.

Build evidence line 110 records the same observation—“`docs/work-loop-repair-workflow.md` + this stream’s artifacts + the four files”—but labels A20 **PASS**. The observation contradicts the expected set stated in the same row.

The full diff contains 19 paths:

- four target files;
- fourteen stream-local `logs/loop/` artifacts;
- `docs/work-loop-repair-workflow.md`.

The implementation commit itself remains correctly atomic: `git show 8762fc7f…` contains only the four targets. This finding concerns the exact base-to-reviewed-HEAD scope that A20, F12 and G2 require, not Build’s staging discipline.

**Impact:**

- A20 fails.
- F12 fires.
- Build evidence’s claim that all A1–A20 pass is false.
- The repair workflow’s G2 requirement for a bounded approved-base-to-HEAD diff is not presently satisfied.
- The mismatch cannot be dismissed as wording-only because plan-v4 says ambiguity resolves as material.

**Smallest required correction:**

This cannot be fixed honestly by editing only the candidate text or Build evidence. If the approved base remains `6050a5b…` and the repair workflow remains present at reviewed HEAD, A20 and F12 remain false.

The control room and operator must choose a binding-consistent resolution—for example, formally reframing the approved scope/base so the already-established repair workflow is explicitly part of the reviewed package. That changes a material G1 premise and therefore must not be smuggled in as a Prove annotation. Removing the active repair authority merely to satisfy the diff is not a safe correction.

**Evidence required to close:**

- An operator-authorized binding that makes the approved base, reviewed plan and permitted diff set mutually consistent.
- A rerun of the exact base-to-HEAD path filter yielding zero outside paths.
- A positive control showing an allowed target is detected.
- Corrected Build/Prove evidence that does not mark A20 PASS while listing a disallowed path.

If no binding-consistent resolution is authorized, this candidate cannot truthfully pass A20/F12 and G2 must remain blocked.

## Acceptance assessment

| Criterion | Result | Repository evidence |
|---|---|---|
| A1 | PASS | Contract lines 106–116 define `PLAN-PATH`, `PLAN-COMMIT`, `PLAN-BLOB`, full SHAs and binding relation. |
| A2 | PASS | Contract line 138 and skill line 74 require all three Shape header fields. |
| A3 | PASS | Command line 131 validates before line 132 transcribes. |
| A4 | PASS | Command line 133 sits after adjudication and before G1, with the required fail-closed cases. |
| A5 | PASS | Contract lines 118–130 define review identity; command lines 132–133 compute and verify it after commit. |
| A6 | PASS | Contract lines 163–175 and command lines 134–145 present both identities and reject bare names. |
| A7 | PASS | Contract lines 176–187 and command lines 159–166 deny `unassessed` at challenged Shape G1 and leave the unit open. |
| A8 | PASS | Contract line 193 and command line 151 require the committed receipt before requesting re-emission. |
| A9 | PASS | Contract line 195 and command lines 152–153 require header-only re-emission and stop on verdict/ID/count mismatch. |
| A10 | PASS | Contract lines 197–201 and command lines 155–157 make the cap restart-visible and separate it from review budget and `hold-reframe`. |
| A11 | PASS | Contract lines 241–247 define materiality, resolve ambiguity upward and prohibit plan mutation for non-material findings. |
| A12 | PASS, boundary caveat | The bounded Shape lifecycle exists at contract lines 205–217, but its generic rendering contributes to G1-PV1-01. |
| A13 | **FAIL** | Shape-only reservation at contract line 225 conflicts with generic command line 272. |
| A14 | PASS | Contract lines 227–235 and command lines 215–223 contain the complete capability close transition. |
| A15 | PASS | Contract lines 237–239 and command lines 225–227 narrowly scope new-stream allocation; ordinary carry remains. |
| A16 | **FAIL in consumer coherence** | Contract defines `review-{n}` and Shape uses it, but Prove line 178 hard-codes `review-1` while generic Step 7 permits `review-2`. |
| A17 | PASS | Template diff changes only the `## Units` outcome row; the status axis is unchanged. |
| A18 | PASS | Zero current matches for “at most one review round”; positive control fires at stopped plan-era contract line 102. |
| A19 | PASS | No G4/four-gate rule exists; the only “fourth gate” hit is the retained prohibition. |
| A20 | **FAIL** | `docs/work-loop-repair-workflow.md` is outside the criterion’s allowed path set. |

## Falsifier assessment

- **F1:** did not fire. The historical v2/v3 fixture differs and the written precondition blocks it.
- **F2:** did not fire. The self-identity positive control passes.
- **F3:** did not fire in the written Shape behavior; non-material findings are annotations only.
- **F4:** did not fire for Shape; no third cycle is provided. The terminal rule’s leakage to Prove is G1-PV1-01.
- **F5:** did not fire in the written checks; missing, abbreviated, inconsistent and mismatched identities block.
- **F6:** did not fire; challenged Shape `unassessed` leaves the unit open.
- **F7:** did not fire in the written header-repair path; the committed receipt makes the allowance visible after restart.
- **F8:** did not fire under the approved proportional residual; verdict, ID-set or count mismatch blocks.
- **F9:** did not fire; the held package requires verifiable plan and review identities.
- **F10:** did not fire in the written capability transition; all required fields, pointers and new-stream exception are present.
- **F11:** did not fire. Exactly G1, G2 and G3 remain, and `hold-reframe` is described as a terminal close rather than a gate. Its wrong phase reach is separately material.
- **F12:** **FIRED.** `docs/work-loop-repair-workflow.md` appears outside the four target paths in the exact approved-base-to-HEAD diff.

## Proportionality, scope and rendering judgments

The core identity design is proportionate. It reuses Git path/commit/blob identities, existing evidence, existing review artifacts and the existing capability record. It adds no validator, script, frontmatter key, state subsystem or fourth gate.

The approved `HEADER-REPAIR` residual is implemented faithfully: verdict, finding IDs and counts are durable, while changed reasoning beneath unchanged identifiers remains explicitly unprotected. The implementation neither silently strengthens the withdrawn byte-comparison design nor weakens the approved receipt/restart behavior.

Both declared rendering judgments in Build evidence §6 are reasonable and non-material:

1. Specifying blocker-handoff content directly in the durable contract avoids a dangling dependency on the temporary repair workflow while preserving the required information.
2. Adding a local pointer from the general `unassessed` fallback to the challenged-Shape denial prevents a reading-order ambiguity without changing behavior.

BF-1—the retired `/qc-pass` reference—is a real stale pre-existing reference but is safely deferred. It is unrelated to the G1 identity invariant and does not justify expanding this correction.

BF-2 is **not** safely deferred under the current rendering, because the new generic lifecycle rule already makes a Prove `review-2` operational while the Prove branch cannot name its artifact coherently.

No general overengineering was found. The material problems are scope precision and phase-boundary leakage, not excessive machinery.

## Limitations

This review is read-only. No file, index, branch, commit or worktree state was changed.

These are instruction and documentation changes. Identity arithmetic, text paths, positive controls and diff bounds can be reviewed now; future-session obedience cannot. M8, M9 and M10 remain representative Use scenarios and were not executed here.

The complete approved-base-to-reviewed-HEAD changed-file set was inspected. Historical Shape revisions and review artifacts were treated as immutable records, not candidate authorities. `git diff --check` reports only the Markdown hard-break whitespace already present in the added repair workflow header; no target-file whitespace defect was found.

## Correction budget and exact next action

- Initial Prove review: **consumed by this review**.
- One bounded correction pass: **available, unused**.
- Conditional closure `review-2`: **available only if the correction changes something this verdict depends on**.
- `review-3`: **does not exist**.
- G2: **blocked**.

Exact next action:

1. The Codex control room returns this review verbatim to a new Claude Prove session.
2. Claude verifies the envelope and transcribes the review without editing it.
3. Claude adjudicates both material findings.
4. Do not mutate the candidate until the operator/control room resolves G1-PV1-02’s approved-base/scope contradiction.
5. If a binding-consistent resolution exists, use one bounded correction pass to align the Shape-only lifecycle across contract and command and to restore truthful scope evidence.
6. A fresh closure review-2 then inspects the new exact HEAD, all target blobs, corrected evidence and the complete approved-base-to-HEAD diff.
7. G2 opens only if no material finding remains and all identity, cleanliness and bounded-scope checks pass.
