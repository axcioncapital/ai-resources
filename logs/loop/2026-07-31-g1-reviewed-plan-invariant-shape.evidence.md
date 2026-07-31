UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: shape
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Claude writer

# Shape evidence — Slice 1, G1 reviewed-plan integrity

Status: **incomplete — unit open.** Append-only (`docs/work-loop.md:141`). This marker is deliberate:
the Shape unit is not finished, G1 is not open, and § Resume order must keep offering this stream.

Governing authority: `docs/work-loop-repair-workflow.md`.
Role: Claude repository engineer — sole writer, ownership acquired this session.

---

## 1. Entry 1 — 2026-07-31 — ownership acquisition and binding verification

Verified against Git before any write; all fields matched the assignment and the committed handoff,
so `docs/work-loop-repair-workflow.md` §6.1's hard stop did not fire.

| Field | Asserted | Verified | Method |
|---|---|---|---|
| Repository | `ai-resources` | match | `git remote -v` |
| Worktree | `…/Axcion AI Repo/ai-resources-g1-reviewed-plan` | match | `pwd -P`, `git rev-parse --show-toplevel` |
| Branch | `codex/2026-07-31-g1-reviewed-plan-invariant` | match | `git rev-parse --abbrev-ref HEAD` |
| HEAD at acquisition | `ccbc011bc614d7665d70f3adea33bb4996bfe2c1` | match | `git rev-parse HEAD` |
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` | ancestor | `git merge-base --is-ancestor` → true |
| Handoff | commit `ccbc011b…`, blob `12d9263d…` | match | `git log -1 --format=%H --`, `git rev-parse HEAD:<path>` |
| Plan-v2 | commit `bb476184…`, blob `90f0b931…` | match | same |
| Plan-v1 (stopped) | commit `d44a4fc…`, blob `e93ae586…` | match | same |
| Worktree | clean | clean | `git status --porcelain` → empty |

**Objects under repair unchanged from the approved base**, verified by
`git diff --stat 6050a5b HEAD -- <four paths>` → empty: `docs/work-loop.md`,
`.agents/skills/work-loop/SKILL.md`, `.claude/commands/work-loop.md`,
`templates/capability-record.md`. The complete `base..HEAD` diff at acquisition was six added
`logs/loop/` and `docs/` artifacts and nothing else.

Ownership was acquired by explicit statement in session, per §7's temporary-lease rule. No acquisition
artifact was committed — the statement is the lease.

## 2. Entry 2 — 2026-07-31 — independent review received and transcribed

The fresh Codex reviewer returned a `REVIEW` block for plan-v2. Its envelope was compared field by
field against the active binding (§6.1): repair, slice, unit, stream, repo, worktree, branch, base,
HEAD, object identity, role. **All matched. No mismatch, so no stop fired.**

The reviewer's declared object matched the live repository:

```
git rev-parse bb476184c57d04ee7b0a96645fa655435652c2a9:logs/loop/…-shape.plan-v2.md
  → 90f0b931272dead2dedb679c8b5cc834b680a3d7        (the identity the review names)
git rev-parse HEAD:logs/loop/…-shape.plan-v2.md
  → 90f0b931272dead2dedb679c8b5cc834b680a3d7        (byte-identical at current HEAD)
```

Transcribed **verbatim and unedited** — no rewording, no reordering, no correction of the reviewer's
prose (`docs/work-loop-repair-workflow.md` §5.4).

| Artifact | Path | Containing commit | Blob |
|---|---|---|---|
| **Review-1** | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.review-1.md` | `96b27e5359b9b4949b31e225cd3be4bfd1479cf1` | `eb827a6715355ed10a82fce3fede46b128864bd9` |

**Verdict: REVISE BEFORE G1.** 3 material findings, 0 minor. Binding verification: PASS.

The review records no overengineering, no scope drift and no over-governance, and confirms the
atomic-slice structure, the four-file boundary, the plan identity binding, the non-material
no-mutation rule, the no-`review-3` rule, the Shape-only `hold-reframe` reservation, rollback and
exclusions as sound.

---

## 3. ADJUDICATION

One disposition per material finding, from the six in `docs/work-loop.md:202`. **G1 is not opened by
this adjudication** — the verdict is REVISE BEFORE G1, so the exact reviewed object does not proceed.

### G1-RV2-01 — one-shot header repair is not durable across resumption — **`fixed`**

**Accepted. The finding is correct and reproduces on inspection.**

Traced through plan-v2's own mechanisms: §6.3 validates the header *before* transcription, so a
malformed header writes **no** review artifact; §6.6 spends the single re-emission allowance; §6.6
step 3 leaves the unit open and returns a blocker handoff; §6.5 relies on § Resume order Tier 2 to
re-offer that open unit. Following that chain, after both a malformed header and a failed re-emission
the repository holds: no review artifact, an open unit, and **no record that the allowance was ever
spent**. A resuming executor cannot distinguish "not yet attempted" from "already exhausted", so each
session can grant a fresh nominally-one-time re-emission. A7 and F7 assert a cap that nothing on disk
can prove. This is the same class of defect the slice exists to close — a control expressed as an
in-session name rather than durable state — so it is material by plan-v2 §6.8 and by
`docs/work-loop-repair-workflow.md` §9.3.

**Correction, using an existing artifact and no new machinery.** `logs/loop/{unit}.evidence.md` is
already append-only (`docs/work-loop.md:141`), already exists per unit, and is already the artifact
whose absence-or-incompleteness drives Tier 2 resume — the exact mechanism §6.5 depends on. The
correction records the expenditure there as a `HEADER-REPAIR` entry, committed by pathspec at write
time, persisting: the date; that the single allowance is now consumed; the plan identity the received
block named; and the received block's **verdict, finding IDs, and material/minor counts**.

Those last three are what prove "substantive findings unchanged" without retaining a body the plan
forbids writing: the re-emitted block must match the recorded verdict, finding IDs and counts exactly.
Any difference makes it a **new review**, not a header repair — and a second review is not in the
budget. **Resume rule:** an executor resuming an open Shape unit reads the evidence first; a
`HEADER-REPAIR` entry means the allowance is exhausted, and the only remaining moves are a valid
header or the §6.5 blocker stop. No new artifact family, no validator, no gate.

### G1-RV2-02 — exact review identity asserted but not defined — **`fixed`**

**Accepted, and it is a regression against plan-v1.**

`docs/work-loop-repair-workflow.md` §G1 requires the held package to contain "exact plan identity;
**exact review identity**; adjudication; implementation slice list; remaining limitations." Plan-v2
defines a precise three-field schema for the plan only (§6.1) and then asks G1 to display "plan and
review identities" (A5) with no schema, computation rule, binding check or verification case for the
review artifact. Plan-v1 §7.4 was strictly more specific here — "artifact path + its commit + its
blob, and which plan identity it names" — and v2 dropped it while widening scope elsewhere. Two
executors could satisfy A5 differently and neither would demonstrably be the exact review identity
the governing workflow requires.

**Correction.** Define `REVIEW-PATH` / `REVIEW-COMMIT` / `REVIEW-BLOB` on the same terms as the plan
fields: full 40-hex, no abbreviations, with the binding relation
`git rev-parse {REVIEW-COMMIT}:{REVIEW-PATH} == {REVIEW-BLOB}`. The executor computes them **after**
verbatim transcription and commit — so there is no chicken-and-egg and the reviewer never self-declares
a future commit, exactly as the finding notes. Verified immediately before G1 alongside the plan
comparison, and displayed in the held package. Add an acceptance criterion and a verification case
carrying both directions: self-identity passes (positive control), a stated-but-wrong blob blocks.

This session already produced the worked example — review-1 at commit `96b27e5359b9b4949b31e225cd3be4bfd1479cf1`,
blob `eb827a6715355ed10a82fce3fede46b128864bd9`, computed after transcription and commit.

### G1-RV2-03 — `hold-reframe` lacks a capability-record close-and-resume transition — **`fixed`**

**Accepted. The conflict is real and I verified it against the live command and contract.**

The reviewer's conditional — "if the four declared files cannot express that coherently, stop and
reframe the scope before G1" — is **resolved: they can. No scope reframe is required.** Evidence:

*The conflict exists.* `docs/work-loop.md:109` and `.claude/commands/work-loop.md:175` both fix the
record's `stream:` as "allocated once … carried forward unchanged". Tier 3 resume takes its stream
from that field (`docs/work-loop.md:256`, `.claude/commands/work-loop.md:32`), and `:37` warns at
length that allocating instead of carrying splits a stream silently. But
`docs/work-loop-repair-workflow.md` §10 requires any continuation after `hold-reframe` to start a
**new** stream citing the held one. So for a challenged *capability* stream, resume as currently
written would carry a stream that `hold-reframe` has terminally closed — the precise violation the
finding names. Adding the outcome literal at template `:98` makes the row writable and does nothing
about this.

*It is expressible within the four files.* The transition needs no new frontmatter key and no new
template section — every field and section it writes already exists:
`status:`/`reopen_trigger:`/`active_unit:`/`stream:` (`templates/capability-record.md:6-11`),
`## Units` (`:92`), `## Current phase and next action` (`:126`), `## Pointers` (`:138`). The rules
themselves land in `docs/work-loop.md` and `.claude/commands/work-loop.md`, both already in scope. The
template therefore still needs only its line-98 outcome literal, and the operator's four-file boundary
holds unchanged.

**Correction.** Define the capability-side `hold-reframe` transition: append the `## Units` row with
outcome `hold-reframe`; set `active_unit: none` and `updated:`; set `status: paused` with a concrete
`reopen_trigger:` — reusing `.claude/commands/work-loop.md:232`'s existing pre-Land stop rule, since
the *stream* is terminal while the *capability* is not; write the held stream's closing SHAs to
`## Pointers` before its `logs/loop/{STREAM}-*` artifacts are deleted; and state in
`## Current phase and next action` that continuation requires a new stream citing the held one. Then
add the single narrow exception to the carry rule: on operator-authorized continuation from
`hold-reframe`, the executor **allocates** a new stream (ordinary collision check) and updates
`stream:` to it, with the held stream preserved in `## Pointers`. That exception is stated only for
this outcome, so `:37`'s silent-split hazard is untouched for every ordinary continuation.

**Boundary note.** This completes the consumer interface of the outcome *this slice introduces*. It is
not Slice 5's general phase-and-transition enforcement and not Slice 4's state/ownership work, both of
which remain excluded (plan-v2 §5). The reviewer framed it the same way.

---

## 4. Budget after this adjudication

| Item | Status |
|---|---|
| One initial independent review | **Consumed** — review-1, commit `96b27e53…`, blob `eb827a67…` |
| One bounded material correction pass | **Not yet consumed.** Authorized by this adjudication; executed by writing plan-v3 |
| One conditional closure `review-2` | **Available, and justified.** All three corrections change matters the first verdict rested on (`docs/work-loop-repair-workflow.md` §10) |
| `review-3` | **Does not exist** in this unit or stream |

If `review-2` returns a further unresolved material finding, the stream closes `hold-reframe` — the
terminal outcome this slice is defining.

## 5. Why plan-v3 was not written in this entry

The correction pass is the **single** one the budget allows, and two of the three corrections carried a
design choice that could burn it if taken wrongly — RV2-01's persisted-field set, and RV2-03's
narrow exception to the `stream:` carry rule, which touches resume semantics that Slice 4 also borders.
Recording the chosen resolutions before minting the revision lets the control room object cheaply,
while an objection after plan-v3 exists would have no budget left to act on. The returned review's
`NEXT` also stops at transcription and adjudication.

## 6. Open findings and deferrals

- **OF-1** (post-G1 package mutation) — **deferred**, plan-v2 §5. Not designed or reworded here.
- **OF-2** (no `review-2` artifact path) — **closed** by plan-v2 §6.9. This unit's own artifact is
  `review-1.md`, consistent with that scheme.
- **OF-3** (review named in `logs/decisions.md:11` with no artifact at `b8ef77f^`) — **deferred**,
  plan-v2 §5.

Settled scope decisions recorded in plan-v2 and the Shape handoff were **not** reopened: the four-file
boundary, plan-v1's stopped status, and the exclusions all stand as written.

LIMITATIONS: This entry adjudicates a plan review; no object under repair has been edited and no
behavioural evidence exists or can exist before implementation (plan-v2 §11.3). The three corrections
are **specified, not yet written** — plan-v3 does not exist, so nothing here has been verified against
a revised plan. RV2-03's feasibility verdict rests on reading the current command, contract and
template, not on executing a capability `hold-reframe`, which is unreachable until the slice is built
and belongs to Stage 9 (Use). Line numbers are as of the blobs recorded in plan-v2 §13.6. The unit
remains open and G1 remains closed.
