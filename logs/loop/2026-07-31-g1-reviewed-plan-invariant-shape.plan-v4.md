UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: shape
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: fresh Codex reviewer

# PLAN v4 — Slice 1: G1 reviewed-plan integrity

Revision: **v4**, immutable. **The sole candidate for `review-2`.** Supersedes plan-v3 for execution;
v3, v2 and v1 are retained unedited.
Assurance: **challenged** (`docs/work-loop-repair-workflow.md:91`)

| Predecessor | Path | Commit | Blob |
|---|---|---|---|
| Frame evidence | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.evidence.md` | `55900183e48d6b5d26193bd4ef6b431da91bb443` | `4349ae7271c01ddd1eb5837e3cb129653a16b272` |
| Plan v1 — stopped | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan.md` | `d44a4fcf56ea92be3d45ece1c27a5af18ae323ef` | `e93ae5863520e261fecfe57acadd3beecc5b8082` |
| Plan v2 — reviewed by review-1 | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v2.md` | `bb476184c57d04ee7b0a96645fa655435652c2a9` | `90f0b931272dead2dedb679c8b5cc834b680a3d7` |
| Plan v3 — **unreviewed historical intermediate** | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v3.md` | `9faf94518dfdb64b614440e0703ecf2969f9a239` | `af92e6992e0445535a6a6cc45c149f19c663c74d` |
| Review-1 of plan-v2 | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.review-1.md` | `96b27e5359b9b4949b31e225cd3be4bfd1479cf1` | `eb827a6715355ed10a82fce3fede46b128864bd9` |
| Adjudication + supersession record | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.evidence.md` | `92bd444c83a11ba22aa4bf8edaadfa35dabdacb4` | `dd0b5649db3df5eeca57b6ddaeb76d64f11f8032` |

**Plan-v3 was never submitted for review.** It is an unreviewed historical intermediate, retained
unedited because plan revisions are immutable (`docs/work-loop.md:140`). It is **not** a review
candidate and must not be reviewed or implemented. Only **plan-v4** goes to `review-2`.

**Budget.** v3 → v4 is an **operator-directed pre-review adjustment inside the already-consumed bounded
correction pass** — not a second correction pass and not a review correction.
`docs/work-loop-repair-workflow.md` §9.2 freezes a plan only once independently reviewed, and no review
has inspected plan-v3, so this stands on the same footing as the pre-review v1 → v2 operator reframe.
**`review-2` remains available and unused.**

Binding verified before writing: branch `codex/2026-07-31-g1-reviewed-plan-invariant`, HEAD
`92bd444c83a11ba22aa4bf8edaadfa35dabdacb4`, base `6050a5b` an ancestor, worktree clean. Authority blobs
re-derived and **unchanged** since plan-v2 §13.6, so every line number cited below still resolves. No
object edit occurs in Shape.

---

## 1. Why v4 exists

Independent Codex review-1 of plan-v2 returned **REVISE BEFORE G1** — three material findings, zero
minor, binding verification PASS. All three were adjudicated `fixed` and written into plan-v3.

The operator then **withdrew as disproportionate** the strengthening recorded in the Shape evidence
Entry 3, which had required persisting the complete first malformed `REVIEW` block verbatim and
comparing the re-emission byte for byte. Because plan-v3 is immutable, that withdrawal produces this
revision rather than an edit. Recorded in the Shape evidence Entry 4 (blob `dd0b5649…`); Entry 3
stands unedited as the record of what was decided at the time.

| Finding | Resolution in v4 | Change from v3 |
|---|---|---|
| **G1-RV2-01** | **§6.8** — committed `HEADER-REPAIR` receipt recording date, consumed allowance, named plan identity, verdict, finding IDs and material/minor counts; header-only re-emission of the same review; cap provable after restart | **Reverted** to the originally adjudicated resolution. Verbatim body persistence and byte-identity comparison removed, with every acceptance, scenario, falsification, verification and limitation clause that depended on them |
| **G1-RV2-02** | **§6.2** — `REVIEW-PATH` / `REVIEW-COMMIT` / `REVIEW-BLOB` defined, computed and verified | **Unchanged from v3** |
| **G1-RV2-03** | **§6.10** — capability close-and-resume transition, plus one narrow allocation exception | **Unchanged from v3** |

**Scope is unchanged.** Still exactly four files; the template still changes only at line 98. No new
artifact family, frontmatter key, validator, script, gate or outcome beyond `hold-reframe`.

**Section numbering is identical to plan-v3**, so a reviewer holding that revision can compare
section by section. Only §6.8 and the clauses keyed to it differ.

---

## 2. Need and mechanism

Stated in full in the Frame evidence (blob `4349ae72…`, §§2–4) and not reproduced here.

**In one line:** G1's held package is specified by *name* ("the plan"), not by *identity*, and no
consumer-side check closes the gap — so a plan revision no reviewer inspected can reach G1. Observed
twice on 2026-07-29 (`prime-minimum-responsibility`, `review-layer-consolidation`), both times in full
compliance with the contract, which makes it a specification defect rather than operator error.
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
| `docs/work-loop.md` | Plan identity, review identity, review-header requirement, G1 precondition, materiality, lifecycle, `hold-reframe` and its capability transition, `review-{n}` path |
| `.agents/skills/work-loop/SKILL.md` | The three-line identity carrier on Shape review headers |
| `.claude/commands/work-loop.md` | Header validation, the header-repair receipt, the comparison, G1 package in identities, blocker stop, lifecycle mechanics, the capability `hold-reframe` transition |
| `templates/capability-record.md` | **Line 98 only** — add `hold-reframe` to the `## Units` outcome enumeration |

**Template boundary.** `:98` is the sole unit-outcome enumeration. Line 7 is the separate `status:`
axis (`adopted \| keep-local \| closed \| retired \| rejected`) and is **not** touched — outcome and
status are different axes (`docs/work-loop.md:200`). §6.10's transition needs no new frontmatter key
and no new section: `status:`, `reopen_trigger:`, `active_unit:` and `stream:` already exist at
`:6-11`, `## Units` at `:92`, `## Current phase and next action` at `:126` and `## Pointers` at `:138`.
Writing *into* an existing section is not a template change.

---

## 5. Exclusions

Routing (Slice 2) · G2 candidate identity and any Prove-side non-convergence (Slice 3) · post-G1
package freeze, Frame OF-1 (Slice 3 or its own) · state, ownership, writer leases (Slice 4) · general
phase and transition enforcement, validators, scripts (Slice 5) · review-method expansion and review
artifact completeness beyond the `review-{n}` path, Frame OF-3 (Slice 5/6) · legacy consolidation
(Slice 8) · historical rewriting (never).

No new state, validator, script, outcome type beyond `hold-reframe`, review machinery, or later-slice
design is introduced.

**Boundary note on §6.10.** Completing the record transition for the outcome *this slice introduces*
is not Slice 5's general phase-and-transition enforcement and not Slice 4's state and ownership work.
Without it the slice ships an outcome whose canonical record cannot represent it, which is the
consumer gap review-1 named. Review-1 framed it the same way.

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

### 6.2 Review identity — closes G1-RV2-02

`docs/work-loop-repair-workflow.md` § G1 requires the held package to carry an **exact review
identity** as well as an exact plan identity. It is defined on the same terms:

| Field | Form |
|---|---|
| `REVIEW-PATH` | repository-relative path, `logs/loop/{unit}.review-{n}.md` |
| `REVIEW-COMMIT` | full 40-hex commit SHA at which the review exists at that path |
| `REVIEW-BLOB` | full 40-hex blob SHA of the review at that commit |

Binding relation: `git rev-parse {REVIEW-COMMIT}:{REVIEW-PATH} == {REVIEW-BLOB}`.

**Computed by the executor after verbatim transcription and commit — never self-declared by the
reviewer.** A reviewer cannot name the commit that will contain its own transcription, so requiring it
in the `REVIEW` block would be unsatisfiable. The sequence is: validate the header (§6.4) → transcribe
verbatim → commit by pathspec → compute the three fields from Git → verify the binding relation.

**Verified immediately before G1** alongside the plan comparison, and **displayed in the held package**
(§6.6). A review identity whose binding relation fails, or whose fields are missing or malformed,
blocks G1 on the same fail-closed terms as §6.5.

*Worked example, produced by this unit:* `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.review-1.md`
at commit `96b27e5359b9b4949b31e225cd3be4bfd1479cf1`, blob `eb827a6715355ed10a82fce3fede46b128864bd9`.

### 6.3 Review-header carrier

Every Shape `REVIEW` header carries three lines after the six standard fields:

```
PLAN-PATH:   logs/loop/{shape-unit}.plan-v4.md
PLAN-COMMIT: {40-hex}
PLAN-BLOB:   {40-hex}
```

This is the entire `SKILL.md` change. `:60`'s per-finding object rule is retained verbatim. The
reviewer emits **plan** identity only; **review** identity is the executor's to compute (§6.2).

### 6.4 Header validation happens **before** transcription

On receiving a `REVIEW` block, the executor validates the three header fields **before** writing the
review artifact. This ordering is deliberate: the review artifact is immutable
(`docs/work-loop.md:142`), so a malformed header must never be baked into it — there would be no lawful
way to correct it afterwards. Validating first makes every transcribed review valid by construction.

### 6.5 The comparison — the G1 precondition

Runs in the Shape unit, after adjudication, immediately before G1, and only there.

1. The candidate plan must be committed; uncommitted or dirty is a stop.
2. Compute candidate identity: `PLAN-PATH`; `PLAN-COMMIT` = `git log -1 --format=%H -- {path}`;
   `PLAN-BLOB` = `git rev-parse {commit}:{path}`.
3. Take the plan identity from the latest valid review (`review-2` if present, else `review-1`).
4. Verify that review's own plan binding relation (§6.1) — catches an internally inconsistent header.
5. Compare all three plan fields by exact string equality.
6. Compute and verify the **review** identity (§6.2) for the artifact just used.

**G1 is blocked by any of:** candidate uncommitted or absent · no review artifact · missing field ·
malformed field · review's stated blob inconsistent with its own commit+path · any plan field
differing from the candidate's · review identity whose binding relation fails.

The stop names the failed field and both values. G1 does not open and no package is presented.
Fail-closed: absence of proof blocks.

### 6.6 The G1 held package

Displayed in identities, not names (`…repair-workflow.md` § G1):

| Element | Displayed as |
|---|---|
| Plan | `PLAN-PATH` + `PLAN-COMMIT` + `PLAN-BLOB` |
| Review | `REVIEW-PATH` + `REVIEW-COMMIT` + `REVIEW-BLOB`, and the plan identity that review names |
| Adjudication | one disposition per material finding, with reasons |
| Slice list | the slices Build will execute |
| Limitations | residual limitations |

The comparison result is reported in one line as passed, with the matched plan blob shown. That line
is **not** a stop (§14).

### 6.7 No independent review means no G1

An inline or self-review recorded `unassessed` **cannot** satisfy the precondition — it is not
independent, so a plan resting on it is not an independently reviewed plan. This replaces the
`unassessed`-at-G1 path the current command permits at `.claude/commands/work-loop.md:134` **for
challenged Shape only**.

When the independent reviewer cannot inspect the plan:

- stop before G1;
- **leave the Shape unit open** — do not close it, do not mark evidence `Status: complete`;
- return the blocker handoff in the `…repair-workflow.md` §6.2 envelope shape, naming the plan
  identity, why it is blocked, and what unblocks it;
- **no new gate and no new CLOSE outcome.**

**This needs no new machinery.** An open unit whose evidence lacks `Status: complete` is already
*incomplete* under `docs/work-loop.md:253`, so § Resume order Tier 2 re-offers it and the stream
resumes when independent review is available. Existing mechanism, reused.

`unassessed` is **not** removed from the contract — it remains available for reviewed-route work and
for Prove, both out of scope here. Only its sufficiency at challenged-Shape G1 is denied.

### 6.8 Malformed header — bounded at one, with a durable receipt — closes G1-RV2-01

| Step | Behaviour |
|---|---|
| 1 | A missing or malformed `PLAN-PATH` / `PLAN-COMMIT` / `PLAN-BLOB` blocks G1 |
| 2 | Write the **`HEADER-REPAIR` receipt** (below) to `logs/loop/{unit}.evidence.md` and commit it by pathspec, **before** requesting anything |
| 3 | Permit **exactly one** mechanical request that the reviewer re-emit **the same review** with a corrected header |
| 4 | Check the re-emission against the receipt (below). Consistent → transcribe and continue. Inconsistent, or a second invalid header → **stop before G1**, leave the unit open, return the §6.7 blocker handoff |

**The receipt** persists, in the append-only evidence file:

- the date;
- the statement that the single re-emission allowance is now **consumed**;
- the plan identity the received block named, as received;
- the received block's **verdict**, its **finding IDs**, and its **material and minor counts**.

**The re-emission is header-only.** It must be the **same review** with `PLAN-PATH`, `PLAN-COMMIT` and
`PLAN-BLOB` corrected — a formatting repair, not a new review and not a revised one. Its verdict,
finding IDs and material/minor counts must match those recorded in the receipt. A mismatch on any of
them means it is not the same review, so the allowance does not cover it: the executor stops before G1
and returns the blocker handoff. A second review is not in the budget.

**Resume rule.** An executor resuming an open Shape unit reads the evidence before acting. A
`HEADER-REPAIR` entry proves the allowance is already consumed: **no further re-emission is
permitted**, and the only remaining moves are a valid header or the blocker stop. This is what makes
the cap survive a restart, which was the substance of G1-RV2-01.

*Why the receipt goes to the evidence file and not the review artifact:* §6.4 forbids a malformed
header in the **immutable** review artifact `{unit}.review-{n}.md` (`docs/work-loop.md:142`), where no
lawful correction path would exist. The evidence file is **append-only, not immutable** (`:141`) and
exists precisely to record what was received and observed. A receipt is not a transcription.

Explicitly: the header request is **not** `review-2`, does **not** consume the material-correction
budget, and does **not** trigger `hold-reframe`. It is capped at one and the cap is provable from the
repository, so no retry loop exists across sessions.

**Declared residual — see §13.4.** Matching verdict, finding IDs and counts detects a substituted or
renumbered review; it does not detect a re-emission whose reasoning changed under unchanged IDs. This
is a deliberate proportionality decision by the operator, recorded rather than hidden.

### 6.9 Lifecycle and `hold-reframe`

One initial review (`review-1`) · at most one material correction, producing a new immutable revision,
never an edit to the reviewed one · at most one conditional closure `review-2`, justified only when
the correction changed something the first verdict rested on · **no `review-3`**.

After `review-2`: no material change required → the exact reviewed revision proceeds to §6.5, then G1.
Material change still required → **`hold-reframe`**.

`hold-reframe` is reserved for exactly that case. It is a fifth unit outcome joining the three that
close without altering the object under work — Shape makes no object edit, so `docs/work-loop.md`
§ Closing without a change applies unchanged: evidence with the outcome and both identities, the
`CLOSE` block, the stream closes in the same commit, and the durable `logs/decisions.md` pointer with
the recovery SHA. It is **terminal for the stream, not a gate** — it opens no operator decision.
Continuation starts a new stream citing the held one (`…repair-workflow.md` §10).

**Shape review point only.** A Prove-side `hold-reframe` would have to dispose of landed object edits;
that is G2 territory and is excluded (§5).

### 6.10 `hold-reframe` on a capability record — closes G1-RV2-03

Non-capability challenged work has no record and needs nothing beyond §6.9. A challenged **capability**
stream does, and the current text conflicts with it.

**The conflict, verified against the live files.** `docs/work-loop.md:109` and
`.claude/commands/work-loop.md:175` both fix the record's `stream:` as allocated once and carried
unchanged. Tier 3 resume takes its stream from that field (`docs/work-loop.md:256`,
`.claude/commands/work-loop.md:32`), and `:37` warns that allocating instead of carrying splits a
stream silently. But `…repair-workflow.md` §10 requires any continuation after `hold-reframe` to start
a **new** stream citing the held one. As written, resume would carry a stream that `hold-reframe` has
terminally closed.

**Close transition**, reusing existing fields and sections only:

1. Append the `## Units` row with outcome `hold-reframe` — append-only, never rewritten.
2. Set `active_unit: none` and `updated:` to today, in the closing commit
   (`.claude/commands/work-loop.md:230`).
3. Set `status: paused` with a concrete `reopen_trigger:`, reusing the existing pre-Land stop rule at
   `:232`. The **stream** is terminal; the **capability** is not, so a TERMINAL status would be wrong
   and `paused` is exactly right. A `paused` record without a trigger is malformed (`:179`).
4. Write the held stream's closing commit SHAs into `## Pointers` **before** its
   `logs/loop/{STREAM}-*` artifacts are deleted at stream close — once deleted, those SHAs are the only
   route back (`:191`).
5. State in `## Current phase and next action` that continuation requires a **new** stream citing the
   held one, and what must be reframed.

**Resume transition — one narrow exception to the carry rule.** On operator-authorized continuation
from a `hold-reframe` record, the executor **allocates** a new stream by the ordinary collision check
(`docs/work-loop.md:111`, both surfaces) and updates `stream:` to it, preserving the held stream in
`## Pointers`. The `## Units` table keeps its existing rows unchanged; new rows carry the new stream's
unit ids.

This exception is stated **for `hold-reframe` only**. Every ordinary continuation still carries the
stream unchanged, so `.claude/commands/work-loop.md:37`'s silent-split hazard is untouched. The
exception is safe precisely because the held stream is terminal and its artifacts are already deleted:
there is nothing left to correlate against, which is the condition that makes carrying correct in the
ordinary case.

### 6.11 Materiality

Imported from `…repair-workflow.md` §9.3: need or outcome · scope or exclusions · architecture or
behavioural design · interfaces, consumers or ownership · slice boundaries or ordering · acceptance or
falsification criteria · verification design · rollback or risk · the basis of a verdict or operator
decision. Spelling, punctuation, formatting and non-substantive citation repairs are non-material only
when meaning is unchanged. **Ambiguity resolves as material.**

**Non-material findings are annotated, never mutated in.** They are recorded in the adjudication or as
a G1 annotation and cannot change the plan's blob — which is precisely what prevents review churn.

### 6.12 `review-{n}` path

`logs/loop/{unit}.review-{n}.md`, `n ∈ {1, 2}`. Immutable; `review-2` is never an edit to `review-1`;
`n ≥ 3` is not a valid artifact. Closes Frame OF-2 — `.claude/commands/work-loop.md:131` currently
hard-codes `review-1.md` while `:224` acknowledges `review-2`.

### 6.13 The "one review round" conflict

`docs/work-loop.md:102` and `.agents/skills/work-loop/SKILL.md:42` both say "at most one review round",
contradicting the `review-2` permitted at `:94`, `:144` and command `:224` (Frame §2 P3 Part A). Both
are corrected to cite §6.9's lifecycle.

---

## 7. One atomic implementation slice

**S1 — G1 reviewed-plan integrity. One Build unit, four files, one result.**

Not split by file or layer. The behaviour exists only when all four land: the contract defines the
identities, the reviewer emits the plan identity, the executor checks both and records the receipt, and
the canonical template can record the outcome. Any subset ships a rule that is unenforced, uninputted,
or unrecordable.

Ordered steps within the single unit:

1. **`docs/work-loop.md`** — plan identity and binding relation (§6.1); **review identity** (§6.2);
   review-header requirement (§6.3); G1 precondition and its fail-closed stop (§6.5); the held package
   in identities (§6.6); no-G1-on-`unassessed` for challenged Shape (§6.7); the header-repair receipt,
   header-only re-emission rule and resume rule (§6.8); materiality and non-material-no-mutation
   (§6.11); lifecycle and no-`review-3` (§6.9), correcting `:102` (§6.13); `hold-reframe` as fifth
   outcome at `:196`/`:198` plus its row in § Closing without a change; **the capability
   close-and-resume transition and the narrow stream-allocation exception** (§6.10); `review-{n}` path
   (§6.12).
2. **`.agents/skills/work-loop/SKILL.md`** — the three header lines (§6.3); correct `:42` (§6.13).
3. **`.claude/commands/work-loop.md`** — header validation before transcription (§6.4); the
   `HEADER-REPAIR` receipt and one-shot cap (§6.8); the comparison between adjudication `:131` and G1
   `:132`, including review-identity computation (§6.2, §6.5); G1 package in identities (§6.6); the
   blocker stop (§6.7); generalise `:131` to `review-{n}` (§6.12); the `hold-reframe` close path and
   the capability transition at Step 5b/Step 8 (§6.9, §6.10); correct `:224`.
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
| **A5** | Contract defines **review identity** as path + commit + blob with its binding relation, computed by the executor after transcription and commit, and verified before G1 |
| **A6** | G1 held package displays plan **and review** identities, not bare names |
| **A7** | An `unassessed` review cannot satisfy the G1 precondition for challenged Shape; an unreachable reviewer stops before G1, leaves the unit open, and returns a blocker handoff — no new gate, no new CLOSE outcome |
| **A8** | Header repair writes a committed `HEADER-REPAIR` receipt recording the date, the consumed allowance, the named plan identity, and the received block's verdict, finding IDs and material/minor counts — **before** any re-emission is requested |
| **A9** | The re-emission is header-only — the same review with the three `PLAN-*` fields corrected; a verdict, finding-ID or count mismatch against the receipt stops before G1 |
| **A10** | Header repair is capped at exactly one, and the cap is **provable from the repository after a restart**; it is not `review-2`, consumes no material-correction budget, and does not trigger `hold-reframe` |
| **A11** | Materiality defined; ambiguity resolves material; a non-material note provably cannot mutate the reviewed plan |
| **A12** | Lifecycle stated as one initial review, ≤1 material correction, ≤1 closure `review-2`, no `review-3` |
| **A13** | `hold-reframe` exists as the terminal Shape-side outcome for an unresolved material `review-2` only, with a complete close path including the durable pointer, and creates no gate |
| **A14** | The capability `hold-reframe` transition is complete: `## Units` row · `active_unit: none` · `status: paused` with `reopen_trigger:` · `## Pointers` SHAs before deletion · `## Current phase and next action` stating the reframe |
| **A15** | Continuation from `hold-reframe` **allocates** a new stream and updates `stream:`, preserving the held stream in `## Pointers`; the exception is stated for `hold-reframe` only and ordinary carry is unchanged |
| **A16** | `review-{n}` path defined, `n ∈ {1,2}` (closes OF-2) |
| **A17** | `templates/capability-record.md:98` includes `hold-reframe`; line 7's status axis is unchanged |
| **A18** | No "at most one review round" text survives in the contract or `SKILL.md` |
| **A19** | Exactly G1, G2, G3 remain — no fourth gate in any of the four files |
| **A20** | The base-to-HEAD diff touches only the four in-scope files plus this stream's `logs/loop/` artifacts |

### Required mechanical scenarios

| ID | Scenario | Required result |
|---|---|---|
| **M1** | Reviewed v1, then materially revised v2 presented at G1 | **Blocks** |
| **M2** | The exact independently reviewed revision presented at G1 | **Passes** |
| **M3** | A non-material note returned | **No plan mutation, no new revision, no new review round** |
| **M4** | `review-2` returns a material finding | **No third cycle; closes `hold-reframe`** |
| **M5** | Header missing, malformed, or blob/commit inconsistent | **Blocks** |
| **M6** | Reviewer unreachable, or only an `unassessed` self-review exists | **Stops before G1; unit stays open; blocker handoff; no gate, no CLOSE outcome** |
| **M7** | Header invalid once, corrected on the single permitted re-emit, verdict/IDs/counts matching the receipt | **Proceeds, budget unconsumed** |
| **M8** | Re-emission returns a different verdict, a changed finding-ID set, or different counts | **Stops — not the same review, so the allowance does not cover it** |
| **M9** | Session restarts after the allowance was spent, then a further re-emission is offered | **Refused — the committed receipt proves the allowance is consumed** |
| **M10** | A challenged capability stream closes `hold-reframe`, then the operator authorizes continuation | **Record `paused` with trigger, pointers written, `active_unit: none`; continuation allocates a NEW stream and does not resume the held one** |

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
| **F7** | Header repair runs more than once across any number of sessions, or consumes the material-correction budget, or triggers `hold-reframe` |
| **F8** | A re-emission with a different verdict, finding-ID set or counts is accepted through the header-repair allowance |
| **F9** | The G1 package presents a review by bare name, or a review identity that cannot be verified against Git |
| **F10** | A capability record that closed `hold-reframe` is resumed on its held stream, or is left without a `reopen_trigger:`, or loses its recovery SHAs before artifact deletion |
| **F11** | A fourth gate appears, or `hold-reframe` behaves as a gate |
| **F12** | Any file outside the four in-scope paths is modified |

---

## 11. Verification

Working directory: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan`.

### 11.1 Plan-identity fixture — the real failure on real objects

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

### 11.2 Review-identity fixture (A5, A6, F9)

This unit produced a live example, so the check runs on a real artifact rather than a constructed one.

| ID | Case | Command | Expected |
|---|---|---|---|
| **V-R1** | Binding relation holds | `git rev-parse 96b27e5359b9b4949b31e225cd3be4bfd1479cf1:logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.review-1.md` | `eb827a6715355ed10a82fce3fede46b128864bd9` — **passes** (positive control) |
| **V-R2** | Stated blob wrong | same commit+path, compared against any other 40-hex | **Differs → blocks** |
| **V-R3** | Abbreviated SHA in a field | 7-hex `REVIEW-COMMIT` | **Blocks** — malformed |

### 11.3 Header-repair receipt (A8, A9, A10, F7, F8)

Text and construction checks; the behavioural cases belong to Stage 9.

| ID | Check | Expected | Control |
|---|---|---|---|
| **V-H1** | Command requires the receipt written and committed **before** the re-emission request | ordering present in Step 5a | Read the block and confirm sequence |
| **V-H2** | Contract names the four recorded fields and the header-only re-emission rule | ≥1 match on `HEADER-REPAIR` | `grep -c 'PLAN-BLOB' docs/work-loop.md` → non-zero |
| **V-H3** | Contract states the resume rule keyed on the committed receipt | ≥1 match on `allowance` in the resume text | as V-H2 |
| **V-H4** | M8 and M9 are expressible: a verdict/ID/count mismatch and a post-restart offer both reach a stop | trace both paths through the written steps | — |

### 11.4 Capability transition (A14, A15, F10)

| ID | Check | Expected | Control |
|---|---|---|---|
| **V-C1** | All five close steps present and keyed to existing fields/sections | ≥1 each for `## Units`, `active_unit`, `status: paused`, `reopen_trigger`, `## Pointers`, `## Current phase and next action` | `grep -c 'active_unit' .claude/commands/work-loop.md` → non-zero |
| **V-C2** | The allocation exception is stated for `hold-reframe` only | exactly one exception, scoped by name | `grep -n 'carried unchanged\|carried forward unchanged'` still present for the ordinary case |
| **V-C3** | Template `:98` carries `hold-reframe`; `:7` status axis unchanged | `:98` match; `:7` byte-unchanged | `git diff 6050a5b HEAD -- templates/capability-record.md` shows one line |

### 11.5 Textual checks

| ID | Check | Expected | Control |
|---|---|---|---|
| A18 | `grep -nE 'at most one review round'` in contract + `SKILL.md` | **zero** | Same regex against `git show d44a4fc:docs/work-loop.md` → must return `:102` |
| A19 | `grep -nEi 'G4\|fourth gate\|four gates'` | **zero**, bar existing "no fourth" prose | `grep -c 'G1'` → non-zero |
| A7 | Command has no G1 path reachable from `unassessed` | **zero** such path | `grep -n 'unassessed'` → non-zero, showing surviving out-of-scope uses |
| A20 | `git diff --name-only 6050a5b HEAD` | exactly the four files + this stream's artifacts | `git diff --name-only 6050a5b HEAD -- docs/work-loop.md` → non-empty after S1 |

**Shell note — mandatory.** This session's shell is `zsh`, which does not word-split unquoted
parameters. Frame §1 records a false negative from passing several paths through an unquoted variable
— read as one filename, every check returned a spurious "no matches". **Use explicit literal paths or
a shell array**, and re-run every zero result against a known-matching corpus.

### 11.6 Out of reach at Prove

These are documentation and instruction changes. Prove verifies text, diff bounds and the identity
arithmetic against real historical blobs. It **cannot** verify that a future session obeys the
instruction — that is behavioural, needs a live challenged Shape-to-G1 run, and belongs to Stage 9
(Use). M8, M9 and M10 in particular are behavioural: a mismatched re-emission, a post-restart re-offer
and a capability reframe cannot be staged before the slice exists. Declared, not hidden.

---

## 12. Rollback and recovery

Four markdown files, one repository; no script, hook, symlink, permission or setting. Fully reversible
by `git revert` of the single S1 Build commit, or by abandoning the branch — the approved base
`6050a5b` is untouched. Because S1 is atomic, **rollback is all-or-nothing, which is the point**:
there is no partial state in which the rule is defined but unenforced. No deletion, no history
rewrite; everything recoverable from Git.

---

## 13. Declared materiality boundaries

1. **`hold-reframe` is Shape-side only** (§6.9). Prove-side non-convergence is Slice 3.
2. **`unassessed` survives elsewhere** (§6.7) — denied only at challenged-Shape G1.
3. **The comparison trusts a transcribed review.** §6.5 step 4 checks the header's internal binding
   relation and §6.2 binds the transcribed artifact to Git, which together detect an inconsistent or
   substituted header — but a faithful transcription of a wrong review is still possible. Full
   protection needs writer/ownership controls, which are Slice 4.
4. **The header-repair check is identity-level, not content-level** (§6.8). Matching verdict, finding
   IDs and material/minor counts detects a substituted or renumbered review; it does **not** detect a
   re-emission whose reasoning, cited evidence or required corrections changed under an unchanged ID
   set. A stronger content-level check was drafted in plan-v3 and **withdrawn by the operator as
   disproportionate** (Shape evidence Entry 4, blob `dd0b5649…`). Recorded here so the trade-off is
   visible at review and at G1 rather than discovered later.
5. **No validator is introduced.** Every check is an instruction the executor follows; mechanisation is
   Slice 5. This slice makes the rules exact and checkable, not automatic.
6. **The §6.10 allocation exception is stated, not enforced.** Nothing prevents a future session from
   carrying the held stream anyway; Slice 5 owns enforcement.
7. **Behavioural evidence cannot exist before implementation** (§11.6).
8. **Line numbers** are as of blobs `88f555e630a4ae898d0eb6d1827d908faf1bf81a` (contract),
   `33986fb80e15fd26600a619793cef37e79c5650a` (skill),
   `0e575aa5dab40a07927bd6cc3cf9af07940401f0` (command),
   `f0580c9e98f45232d83d1cf6d707b39c9e186acf` (template), unchanged since plan-v2. Build re-derives
   them if any file moves.

---

## 14. Gates

**Exactly G1, G2 and G3 remain.** Nothing is added or removed.

The comparison is a **precondition on G1**, not a gate — it produces no operator decision; it either
lets G1 open or stops before it. The blocker handoff (§6.7, §6.8) is a **stop**, not a gate — it asks
nothing and leaves the unit open to resume. The `HEADER-REPAIR` receipt is a **record**, not a gate.
`hold-reframe` is a **terminal close**, not a gate. A passing comparison produces no stop and is
reported in one line inside the G1 package.

---

## 15. Open findings, budget, limitations

- **OF-1** (post-G1 package mutation, `plan-v4` `bc435d5` / `plan-v5` `6a81121` of the 2026-07-29
  stream) — **deferred**, §5.
- **OF-2** (no `review-2` artifact path) — **closed** by §6.12 / A16.
- **OF-3** (review named in `logs/decisions.md:11` with no artifact at `b8ef77f^`) — **deferred**, §5.
- **G1-RV2-01 / -02 / -03** — all three **closed** by §6.8, §6.2 and §6.10 respectively, with the
  §13.4 residual declared on RV2-01.

**Budget:**

| Item | Status |
|---|---|
| One initial independent review | **Consumed** — review-1, commit `96b27e53…`, blob `eb827a67…` |
| One bounded material correction pass | **Consumed** — it produced plan-v3, then plan-v4 after an operator-directed pre-review adjustment. One pass, not two |
| One conditional closure `review-2` | **Available and unused** — justified, since the corrections change matters review-1's verdict rested on |
| `review-3` | **Does not exist** in this unit or stream |

If `review-2` returns a further unresolved material finding, the stream closes `hold-reframe`.

**Limitations:** the `docs/work-loop.md:102` conflict's causal role in the observed failure remains
inference, not observation (Frame §4) — it is corrected here because it is a confirmed textual defect,
not because its causal role is proven. No behavioural evidence is obtainable before implementation.
Settled scope decisions were not reopened: the four-file boundary, plan-v1's stopped status, plan-v3's
status as an unreviewed historical intermediate, and the exclusions all stand as written.

LIMITATIONS: §13 and §15. This plan makes no object edit, opens no gate, and authorizes no
implementation. It is the object a fresh Codex task must now review at the exact identity reported in
this unit's handoff.
