UNIT: 2026-07-31-g1-reviewed-plan-invariant-frame   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: frame
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Codex control room

# Frame evidence — Slice 1, G1 reviewed-plan integrity

Status: complete
Outcome: **ready-for-shape**
Role: Claude repository engineer (sole writer)
Governing authority: `docs/work-loop-repair-workflow.md` (repair-time authority, read in full this session)

This unit is evidence-first Frame/diagnosis only. **No authority file was edited. No Shape plan
exists.** The only repository write in this unit is this artifact.

---

## 1. Verified starting binding and Git/worktree state

Every field below was verified against Git in this worktree before any write. All matched the
assignment; no conflicting field was found, so §6.1's hard stop did not fire.

| Field | Asserted | Verified | Method |
|---|---|---|---|
| Repository | `ai-resources` | match | `git remote -v` → `https://github.com/axcioncapital/ai-resources.git` |
| Worktree (absolute) | `…/Axcion AI Repo/ai-resources-g1-reviewed-plan` | match | `pwd`; `git worktree list` |
| Branch | `codex/2026-07-31-g1-reviewed-plan-invariant` | match | `git rev-parse --abbrev-ref HEAD` |
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` | match, is ancestor | `git merge-base --is-ancestor 6050a5b HEAD` → true |
| Opening commit | `bfa33152ac11c9c853c4e1f9029dbd996b3a08f8` | match, is ancestor | `git merge-base --is-ancestor bfa3315 HEAD` → true |
| Starting HEAD | `17ad3aa4209904991467796dd904a80a2c7bf0b8` | match | `git rev-parse HEAD` |
| Active stream | `2026-07-31-g1-reviewed-plan-invariant` | match | brief header line 1 |
| Active unit | `2026-07-31-g1-reviewed-plan-invariant-frame` | match | brief header line 1 |
| Active brief | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.brief.md` | present, 33 lines | `Read` |
| Worktree clean | expected clean | clean | `git status --porcelain` → empty |

`base..HEAD` at session start contained exactly two commits, both bookkeeping, no authority edit:

```
17ad3aa new: work-loop-repair-workflow — supervised multi-session repair method
bfa3315 loop: 2026-07-31-g1-reviewed-plan-invariant — fresh Frame brief
```

Authority-file blob identities at starting HEAD `17ad3aa` (`git rev-parse HEAD:<path>`) — recorded so
a later session can prove these files were not touched by this unit:

| Path | Blob at `17ad3aa` |
|---|---|
| `docs/work-loop.md` | `88f555e630a4ae898d0eb6d1827d908faf1bf81a` |
| `.claude/commands/work-loop.md` | `0e575aa5dab40a07927bd6cc3cf9af07940401f0` |
| `.agents/skills/work-loop/SKILL.md` | `33986fb80e15fd26600a619793cef37e79c5650a` |

No branch switch, pull, merge, rebase or cherry-pick was performed. Foreign refs were inspected as
read-only objects only (§6.3).

**Method note — a false negative was caught and corrected.** The first grep pass passed the three
paths through an unquoted shell variable. This session's shell is `zsh`, which does not word-split
unquoted parameters, so the three paths were read as one filename and every check returned a
spurious "no matches". The `ugrep: No such file or directory` warning is what exposed it. All
negative results below were re-run with explicit literal paths **and** a positive control. No
negative result in this artifact rests on the first pass.

---

## 2. Premise-by-premise verdicts

Evidence order follows §8 Stage 3: current code first, historical records last. All commands were
run with working directory `…/ai-resources-g1-reviewed-plan` at HEAD `17ad3aa`.

### P1 — `docs/work-loop.md` requires Shape review before G1 and permits immutable plan revisions, but does not bind G1 to the exact reviewed plan identity

**Verdict: CONFIRMED (directly observed).**

| Item | Detail |
|---|---|
| Inspection | `Read docs/work-loop.md` (260 lines, full) |
| Expected if premise true | review-before-G1 present; `-v2` revisions permitted; no identity binding |
| Observed | All three hold. `docs/work-loop.md:83` — G1 "sits at … after the pre-implementation review is adjudicated", held package is "**The plan**, the pre-implementation review, the adjudication of its findings, and the slice list". `:91` — "Shape's review reads a plan … Its object is `{shape-unit}.plan.md`". `:140` — `{unit}.plan.md` is "**Immutable** — a revision is `-v2`". The held package names *"the plan"*, never *which* plan. |
| Negative check | `grep -nEi 'blob\|content hash\|checksum\|fingerprint\|exact reviewed\|exactly the reviewed\|reviewed plan identity'` over all three authority paths → **zero matches** |
| Positive control | Same regex against `docs/work-loop-repair-workflow.md` → **6 matching lines**. Second control: `grep -c 'plan'` over the same three paths → `docs/work-loop.md:7`, `.claude/commands/work-loop.md:8`, `SKILL.md:0`. The regex engine reaches these files and the corpus is non-empty. |

**Immutability does not supply identity.** `plan.md` is never edited, but a revision mints a *new*
file, so the set of plan files grows while "the plan" at G1 continues to denote whichever the author
last wrote. Immutability of each file and ambiguity of the reference are independent properties, and
only the first is specified.

### P2 — `.claude/commands/work-loop.md` transcribes a review and then presents "the plan" at G1 without comparing it to the reviewed object

**Verdict: CONFIRMED (directly observed).**

| Item | Detail |
|---|---|
| Inspection | `Read .claude/commands/work-loop.md` (251 lines, full); `grep -nE 'G1'` |
| Expected if premise true | a transcribe step, then a G1 presentation step, with no comparison between them |
| Observed | `:131` — "**Transcribe the review verbatim** to `logs/loop/{unit}.review-1.md`. Commit by pathspec. Adjudicate every material finding". `:132` — "**G1 — stop.** Put in front of the operator: **the plan**, the review, the adjudication, and the slice list Build will execute." Nothing between `:131` and `:132`, or anywhere in Step 5a, compares the presented plan to the reviewed one. |
| Disconfirming check | `grep -nEi 'compar\|must match\|same plan\|verif(y\|ies) the plan\|which plan\|version of the plan'` over all three authorities → **one hit, and it is not a G1 rule**: `docs/work-loop.md:260` "only the first is machine-comparable", inside § Resume order's `reopen_trigger:` residual. No G1 comparison rule exists. |
| Positive control | `grep -c 'compar\|must match'` against `docs/work-loop-repair-workflow.md` → **3**. |
| Corroborating defect | `:131` hard-codes `review-1.md` as the transcription target. `:224` acknowledges `review-2` exists. The command therefore names **no write path** for a second review. |

### P3 — the "at most one review round" rule conflicts with the permitted `review-2`, and neither authority defines what follows a material review-2 finding

**Verdict: CONFIRMED (directly observed), in two parts.**

*Part A — the textual conflict is real.*

- `docs/work-loop.md:102` — "A **unit** is one bounded piece of work with one brief, one evidence package and **at most one review round**."
- `.agents/skills/work-loop/SKILL.md:42` — the Codex controller is told to scope a brief to "one bounded piece of work, one evidence package, **at most one review round**."
- `docs/work-loop.md:94` and `:144`, and `.claude/commands/work-loop.md:224`, all permit a `review-2`.

Two authorities state a one-round ceiling; three passages permit a second round. A reader applying
`:102` or `SKILL.md:42` literally reaches a different answer than one applying `:94`.

*Part B — no terminal outcome exists.*

| Item | Detail |
|---|---|
| Negative check | `grep -nEi 'hold-reframe\|reframe'` over all three authorities → **zero matches** |
| Positive control | `grep -c 'hold-reframe'` against `docs/work-loop-repair-workflow.md` → **5** |
| Outcome enumeration | `docs/work-loop.md:196` — "**Four outcomes**, exactly one per `CLOSE` block"; `:198` lists `close` · `rejected-premise` · `route-unavailable` · `routed-out`. Each of the latter three has a specific, non-substitutable trigger (premise disproved at step 4; route unbuilt; whole need left the loop). **None fits "review-2 still requires a material plan change."** |

A unit whose `review-2` returns an unresolved material finding therefore has no closing outcome it
can legitimately take, and no rule forbidding a third round either. The authorities are silent, not
restrictive — which is why the observed behaviour in P4 was not a rule violation.

### P4 — Git history retains the observed failure: `31080b0` says plan-v3 reached G1 after being reviewed zero times

**Verdict: CONFIRMED (directly observed, verbatim).**

`31080b0` = `31080b012dc57d6bb120699dd8e623923109e43c`, 2026-07-29 13:09:00 +0300,
`loop: 2026-07-29-prime-minimum-responsibility-shape — G1 approved, unit closed`. It is reachable
from `main`, from `session/2026-07-29-work-loop`, **and** from this branch
(`git branch -a --contains 31080b0`). It was inspected as a Git object only; no branch was switched
and no other ref was treated as the active unit.

Verbatim, from `git show 31080b0:logs/loop/2026-07-29-prime-minimum-responsibility-shape.evidence.md`
(`LIMITATIONS:` block, artifact blob `30dfb6929082c09bd90c5007161ba8f24a2d2beb`):

> **Plan-v3 has been reviewed zero times.** Review-2 instructed that adjudication proceed to G1
> without a third round, and that instruction was followed — but the F1/F2 corrections changed the
> architecture again after review-2 read it. The gate re-siting has been reviewed twice; *this*
> version of it has not been reviewed at all.

And from the same file's G1 section: "Presented to the operator: **the plan (v3)**, both reviews, the
adjudication, and the slice list."

Reconstructed timeline (`git log --diff-filter=A` per artifact path, all 2026-07-29):

| Time | Artifact | Object actually reviewed |
|---|---|---|
| 12:31 | `plan.md` (v1) written — `9be8bb0` | — |
| 12:49 | `review-1.md` — `4c54344` | v1 |
| 12:53 | `plan-v2.md` — `aa7a56d` | — |
| 13:02 | `review-2.md` **and** `plan-v3.md`, same commit `1dc38b3` | v2 |
| 13:09 | **G1 approved on plan-v3** — `31080b0` | **nothing** |

The failure is exactly as briefed: the version G1 approved is the one no reviewer saw.

**Second, independent instance — same mechanism, different stream.** The `2026-07-29-review-layer-consolidation`
stream shows the identical shape. Its closed artifacts were recovered from Git at `b8ef77f^`
(`git ls-tree -r --name-only b8ef77f^ -- logs/loop/`): `…-shape.plan.md`, `…-shape.plan-v2.md`,
`…-shape.plan-v3.md` — and exactly **one** review, `…-shape.review-1.md`, whose own header reads:

```
Object reviewed:
logs/loop/2026-07-29-review-layer-consolidation-shape.plan.md
```

`logs/decisions.md:7` records that stream's "G1-approved package `logs/loop/…-shape.plan-v3.md`".
So G1 approved v3 while the only on-disk review named v1 — two unreviewed revisions, not one. Two
independent occurrences in a single day make this a property of the authorities, not a one-off.

### P5 — the former review-layer blocker has ceased to block this slice

**Verdict: CONFIRMED (directly observed).**

| Check | Command | Observed |
|---|---|---|
| Consolidation landed | `git merge-base --is-ancestor 1c82aef HEAD` | true — `loop: close 2026-07-29-review-layer-consolidation — G2 approved, stream closed` |
| Retirement landed | `git merge-base --is-ancestor 38981e5 HEAD` | true — `batch: retire /qc-pass, /risk-check, /resolve, /refinement-deep` |
| Durable record | `grep -n 'review-layer' logs/decisions.md` | `:5`, `:23`, `:41` — G2-approved close recorded |
| Historical branch **not** resumed | `git merge-base --is-ancestor 544a0f5 HEAD` | **false** — `session/2026-07-29-work-loop` is context only, consistent with `reports/work-loop-remediation-report-2026-07-30.md:59` ("must not simply be resumed as the implementation branch") |

The blocker is discharged in the correct way: the consolidation is *in this branch's history*, while
the stale investigation branch is *not*. This worktree carries the change and not the stale base.

---

## 3. Confirmed failure

**The failure is confirmed.** All five briefed premises hold, verified against current files and Git
objects, with a positive control behind every negative result.

Stated neutrally: on the challenged route, `/work-loop` can present a Shape plan at G1 that no
independent reviewer has inspected, and the authorities contain no check that would detect it. It
has happened at least twice, in two streams, on the same day. Separately, a `review-2` that returns
an unresolved material finding has no defined terminal outcome, so the loop has no legitimate way to
stop.

---

## 4. Causal diagnosis

### Mechanism

**G1's held package is specified by *name*, not by *identity*, and no consumer-side check closes the
gap between the two.**

Four properties compose into the failure. Each is individually reasonable:

1. Every plan revision is a **new immutable file** (`docs/work-loop.md:140`). The reviewed file is
   never mutated — so nothing looks wrong at the file level.
2. The review's object is **whichever file existed when the review ran** (`:91`).
3. The correction pass legitimately produces a **later** revision, after the review.
4. G1's package is *"the plan"* (`:83`, command `:132`) — a name that silently re-binds to the newest
   revision as the set grows.

Immutability guarantees the reviewed *bytes* still exist. It does **not** guarantee they are the
bytes G1 receives. Steps 1–4 are consistent, and their composition is unsound. That is why the two
observed instances were not rule violations: the operators followed the contract exactly, and the
contract permits the outcome.

The `review-2` half is the same defect in the time dimension: §10-style bounded correction is
described (`:94`) but not *terminated*, and the enumerated outcomes (`:198`) have no state for
"still materially wrong after the last permitted round." Without a terminal outcome, the only
available moves are an undefined third round or an unreviewed advance to G1 — and the P4 record
shows which one was taken.

This matches, independently, the diagnosis already written at
`reports/work-loop-remediation-report-2026-07-30.md:65`: "Names are used where immutable identity is
required. 'The plan,' 'the evidence,' and 'the review' do not identify a file version or candidate
commit." That report is a prior source, not this session's reasoning; it corroborates rather than
proves.

### Alternatives considered and tested

| # | Alternative explanation | Test | Result |
|---|---|---|---|
| A1 | Immutability already binds identity — "the plan" can only mean the reviewed file | Read `:140` with the P4 artifact list | **Eliminated.** `plan.md`, `plan-v2.md`, `plan-v3.md` coexist, each immutable; G1 took v3. Per-file immutability and reference ambiguity are independent. |
| A2 | Operator or session error, not a contract defect — the interrupted session caused it | Read `31080b0` LIMITATIONS in full | **Eliminated.** The interruption is scoped explicitly to *the evidence write*, not to the plan lineage. The same file separately records review-2's instruction to proceed without a third round — i.e. the rule as written produced the outcome. |
| A3 | One-off, not systemic | Recover a second stream's artifacts from `b8ef77f^` | **Eliminated.** `review-layer-consolidation` shows the identical shape (review-1 named v1; G1 took v3). Two streams, one day. |
| A4 | Already fixed by a later commit — the defect is historical | `git log 31080b0..HEAD -- <three authorities>` → only `38981e5`, `ff000a4` (both review-layer consolidation); plus P1/P3 greps at HEAD | **Eliminated.** No identity-binding or `hold-reframe` text exists at current HEAD. Nothing landed against this defect. |
| A5 | The Codex reviewer fails to state what it inspected, so the gap is on the producer side | Read `b8ef77f^:…-consolidation-shape.review-1.md` header; `SKILL.md:60` | **Eliminated, and it sharpens the diagnosis.** The review *did* name its object (`Object reviewed: …plan.md`), and `SKILL.md:60` already requires it. The identity information exists at review time. The defect is purely **consumer-side**: no authority requires anyone to read that header and compare it before G1. |

A5's elimination is load-bearing for Shape scope: the repair does not need to add identity *emission*
on the Codex side. It needs a definition of plan identity, a requirement that the review header carry
it, and a G1 pre-condition that compares. That is materially smaller than the brief implies.

### Confidence

**High** for the mechanism and for both briefed defects. Direct textual observation at current HEAD,
two independent reproductions in Git history, five alternatives tested and eliminated, and every
negative result backed by a positive control.

**Moderate** on one bounded point: whether the `:102` / `:94` "one round" conflict *causally
contributed* to the P4 outcome, as opposed to merely coexisting with it. The record shows review-2
instructed advance to G1; it does not show the author consulting `:102`. The conflict is confirmed as
a textual defect (P3 Part A) with high confidence; its causal role in P4 is inference, not
observation, and is not relied on by the diagnosis.

### Evidence that would disconfirm this diagnosis

Any one of these would require re-opening the diagnosis:

1. A passage in any of the three authorities — including one the greps' vocabulary missed — that
   requires the G1 plan to be compared against the reviewed object. Would refute the mechanism
   outright.
2. A demonstration that "the plan" at `:83`/`:132` is bound elsewhere to a specific revision by a
   naming convention this session did not find.
3. A third stream where a plan revision followed a review and G1 nonetheless received the reviewed
   version — showing an effective control operating outside the text.
4. Evidence that plan-v3 in P4 *was* independently reviewed and the LIMITATIONS entry is wrong.
5. A defined terminal outcome for an unresolved material `review-2` existing under a name this
   session did not search for.

---

## 5. Slice 1 readiness assessment (bounded)

Assessed strictly against §8 Stage 5's eight required elements, using the brief plus
`docs/work-loop-repair-workflow.md` §12 row 1 and §4.2. **No Shape content was authored.**

| Element | Present? | Where / gap |
|---|---|---|
| One invariant | **Yes, with a note** | §12 row 1: "G1 receives the exact reviewed plan; one closure review; material review-2 ends `hold-reframe`". Compound in wording, but a single coherent property — *G1 cannot act on an object that was not independently reviewed, and the correction loop terminates*. Shape should state it as one sentence. |
| Exact in-scope paths | **Yes** | Brief lines 20–22: the three authorities, named exactly. |
| Explicit exclusions | **Yes** | Brief lines 29–30: routing, worktree/state, G2 identity, phase enforcement, validators, review-method expansion, historical rewrites. Consistent with §12 slices 2–8. |
| Dependencies | **No — gap** | Brief states none. Observed dependency: the `.claude/commands` change depends on the `docs/work-loop.md` definition of plan identity; `SKILL.md` must carry the review-header requirement or the comparison has no input. Shape must order these. |
| Observable acceptance conditions | **Partial — gap** | Brief gives falsifiers only. §12 row 1 supplies four positive mechanical scenarios (v1-reviewed/v2-material mismatch blocks; exact reviewed v2 passes; non-material note causes no plan mutation; material review-2 cannot start review-3). Shape must give these stable IDs per §8 Stage 6. |
| Falsifiers | **Yes** | Brief lines 32–33, three stated, all observable. |
| Rollback / recovery path | **No — gap** | Brief states none. Low risk in fact: three text files on a dedicated branch from a recorded base; `git revert` or branch abandonment suffices. Shape must state it explicitly. |
| Assurance classification | **Yes, not in the brief** | `docs/work-loop-repair-workflow.md:91` — "The current G1 repair slice is **challenged**." |

**Assessment: the brief defines the smallest independently useful Slice 1, and the three gaps are
Shape-stage deliverables, not Frame blockers.** §8 Stage 6 assigns dependencies, stable-ID acceptance
criteria and rollback to the plan; requiring them in the brief would invert the stages. The slice is
independently useful on its own — it closes a demonstrated failure with two recorded occurrences,
and it does not depend on any of slices 2–8.

**Smallest-sufficient note for Shape (bounded, not a design):** A5 shows review-side identity
emission already exists and is already required by `SKILL.md:60`. Shape should not re-specify it.

**G1, G2 and G3 are preserved exactly.** Nothing in this assessment adds, removes or re-sites a gate.

---

## 6. Outcome

**`ready-for-shape`.**

This authorizes no implementation and opens no gate. It states only that the failure is confirmed,
the cause is understood well enough to select a response, and Slice 1 is bounded well enough for a
plan to be written — if and when the operator authorizes Shape.

---

## 7. Open findings, limitations, deferred discoveries

### Open material findings

- **OF-1 — the approved package kept mutating after G1, twice, unreviewed.** Beyond the briefed v3
  defect, the same stream produced `plan-v4.md` (`bc435d5`, 20:10, "package amendment; ≤300 target
  falsified on measurement") and `plan-v5.md` (`6a81121`, 21:08, during Build-2) — both **after**
  G1 approved v3 at 13:09, with no review and no gate. The G1-approved scope was amended twice while
  Build executed against it. This is a *distinct* invariant (the approved package is frozen through
  Build) and is **not** Slice 1's. Recorded and deferred per §8 Stage 5; it does not invalidate
  Slice 1's premise — it reinforces it. Nearest existing home is §12 slice 3; the operator may wish
  to confirm slice 3's wording covers post-G1 package drift, not only G2 candidate identity.
- **OF-2 — `review-2` has no defined artifact path.** `.claude/commands/work-loop.md:131` hard-codes
  transcription to `review-1.md` while `:224` acknowledges `review-2`. In-scope for Slice 1's
  closure-review rule; Shape should resolve it rather than leave it to slice 5.
- **OF-3 — a review named in the durable record has no artifact.** `logs/decisions.md:11` cites
  "Codex review-2 was right to reject it" for the consolidation stream, but `b8ef77f^` holds only
  `…-shape.review-1.md` for that unit. Either a review was never transcribed, or the record's prose
  is loose. Same root cause (names, not identities), but the fix belongs to slice 5/6 — **deferred**,
  not Slice 1.

### Limitations

- **This artifact's own commit SHA cannot appear inside it.** A commit cannot contain its own hash.
  The artifact's immutable identity is its blob SHA, reported alongside the commit in the session
  reply and in §8; the commit is the tip of this branch.
- **P3 Part A's causal role is inference, not observation** — see § Confidence. The textual conflict
  is confirmed; its contribution to the P4 outcome is not.
- **No execution evidence.** `/work-loop` was not invoked — the repair workflow forbids it governing
  its own repair (§1, §13.1), and Frame is diagnosis-only. Every verdict rests on text inspection
  and Git objects, not on a run. A behavioural reproduction is possible only after a repair exists,
  and belongs to Stage 9 (Use).
- **Instance 2 is partly prose-based.** Its plan/review artifacts were recovered from `b8ef77f^`, but
  the assertion that G1 approved v3 rests on `logs/decisions.md:7`, not on a G1 evidence artifact
  (that stream's artifacts were deleted at stream close, as § Artifacts prescribes).
- **Grep vocabulary is finite.** P1/P3's negative results could in principle miss a passage using
  vocabulary neither the search terms nor the full read of all three files surfaced. Mitigated by
  reading all 630 lines of the three authorities in full, not only by grepping.
- **Scope of reading.** Only the three authorities, the active brief, the repair workflow, the
  remediation report (grep-scoped) and `logs/decisions.md` (grep-scoped) were read. Consumer commands
  that might also present a G1 package were not surveyed.

### Deferred later-slice discoveries

OF-1 (post-G1 package freeze → slice 3 or its own slice) and OF-3 (review artifact completeness →
slice 5/6). Neither was designed, planned or acted on here.

---

## 8. Repair handoff envelope (§§6.2, 14)

```text
REPAIR: work-loop
SLICE: Slice 1 — G1 reviewed-plan integrity
UNIT: 2026-07-31-g1-reviewed-plan-invariant-frame
STREAM: 2026-07-31-g1-reviewed-plan-invariant
REPO: ai-resources
WORKTREE: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan
BRANCH: codex/2026-07-31-g1-reviewed-plan-invariant
BASE: 6050a5b83f976583154f79ecfd5335691ba3d156
HEAD: the commit created by this artifact — the tip of this branch (a commit cannot contain its own SHA)
OBJECT: logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.evidence.md — identity is its Git blob SHA at that commit. NO SHAPE PLAN EXISTS. No authority file was modified.
ROLE: Claude writer
NEXT: Codex control room — inspect this committed Frame evidence and advise Patrik whether to authorize Shape, or the exact stop/reframe action
```

**Supplemental fields (§6.2, §14):**

- **Last completed stage or gate:** §8 Stage 4 (Diagnose) complete; Stage 5 (Select the slice)
  assessed as ready, not executed. **No gate has been reached.** G1 is not armed. The last gate
  passed is none — this stream has had none.
- **Authoritative artifact paths:** brief `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.brief.md`;
  this evidence `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.evidence.md`; governing
  authority `docs/work-loop-repair-workflow.md`. Objects under repair (unmodified, blobs in §1):
  `docs/work-loop.md`, `.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md`.
- **Commits produced by this unit:** exactly one — the commit carrying this artifact. No other write.
- **Inspections run and observed results:** full reads of the three authorities (630 lines), the
  brief, and `docs/work-loop-repair-workflow.md`; ten Git/grep inspections recorded in §§1–2, each
  with expected vs. actual and a positive control where the result was negative. All five premises
  confirmed. One method error (zsh word-splitting) detected and fully re-run.
- **Open material findings:** OF-1, OF-2, OF-3 (§7). OF-1 and OF-3 are deferred to later slices.
- **Remaining correction budget:** **untouched and fully intact.** Per §10, Slice 1 retains one
  initial independent review, one bounded correction pass, and one conditional closure `review-2`.
  Frame carries no review (`docs/work-loop.md:124`), so nothing has been consumed.
- **Known limitations:** §7.
- **Worktree expected clean:** **yes** — one commit containing exactly one file; nothing staged,
  nothing untracked, no authority file touched.
- **Exact next action:** Codex control room reads this artifact at the branch tip and advises the
  operator whether to authorize Shape for Slice 1. Shape, if authorized, must close the three §5
  gaps (dependencies, stable-ID acceptance criteria, rollback) and must not re-specify review-side
  identity emission (§4, A5). **No implementation is authorized by this outcome.**

LIMITATIONS: recorded in full at §7 — no execution evidence, one inference-grade sub-claim (P3 Part A
causality), instance 2 partly prose-based, finite grep vocabulary, bounded read scope, and this
artifact's self-referential commit SHA.
