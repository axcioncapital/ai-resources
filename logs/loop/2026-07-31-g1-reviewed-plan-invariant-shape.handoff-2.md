UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: shape → build
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: new Claude session

# Implementation handoff — Slice 1: G1 reviewed-plan integrity

Governing authority: `docs/work-loop-repair-workflow.md` (§§6, 7, 14).
Written at pre-handoff HEAD `71d90a087ae75e71d86f6c136cb3fcfd3700be01`. **A file cannot contain its own
commit SHA — the containing handoff commit is the tip of this branch and is reported in the session
reply.**

This is the **second** handoff of this Shape unit. The first
(`…-shape.handoff.md`, commit `ccbc011b…`) transferred ownership *into* this session before review.
Both are retained; neither supersedes the other's record.

---

## 1. Repair handoff envelope (§6.2)

```text
REPAIR: work-loop
SLICE: Slice 1 — G1 reviewed-plan integrity
UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape
STREAM: 2026-07-31-g1-reviewed-plan-invariant
REPO: ai-resources
WORKTREE: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan
BRANCH: codex/2026-07-31-g1-reviewed-plan-invariant
BASE: 6050a5b83f976583154f79ecfd5335691ba3d156
HEAD: pre-handoff 71d90a087ae75e71d86f6c136cb3fcfd3700be01; the commit containing this handoff is the branch tip
OBJECT: logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v4.md at commit df45a2b1a42a2140c85a56e71c395407dc9eb903, blob 9ae4839afc8ccb23c4bd50a2644f32213273ed90 — G1-APPROVED
ROLE: Claude writer — releasing ownership (§9)
NEXT: a new Claude Code session verifies this handoff, explicitly acquires sole-writer ownership, opens the Build unit, and implements the exact G1-approved package — nothing else
```

## 2. G1 approval of record

**G1 APPROVED by the operator, 2026-07-31.** Approval is bound to these exact identities and to
nothing else:

| Object | Path | Commit | Blob |
|---|---|---|---|
| **Plan — G1-approved** | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v4.md` | `df45a2b1a42a2140c85a56e71c395407dc9eb903` | `9ae4839afc8ccb23c4bd50a2644f32213273ed90` |
| **Review — the closure review** | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.review-2.md` | `12b22dd9acfc76094f0803f29d64b5935ead4f83` | `848ee9f940c562f421c6ef727e358d21c73a299f` |

**Operator's stated scope limit, verbatim in substance:** the approval authorizes *the exact one-slice,
four-file implementation package stated in plan-v4*. **It authorizes no additional scope.**

**G1 annotation, operator-issued.** The zsh finding recorded in the Shape evidence §9.5 permits
brace-delimited or otherwise safe shell syntax during verification. It does **not** authorize mutation
of plan-v4 and **no** additional implementation content.

**Any mutation of plan-v4 changes its identity, makes review-2 stale, and voids this approval**
(`…repair-workflow.md` §9.2, §11).

## 3. Artifact identities

| Artifact | Path | Commit | Blob |
|---|---|---|---|
| Plan v4 — **G1-approved, the one to implement** | `…-shape.plan-v4.md` | `df45a2b1a42a2140c85a56e71c395407dc9eb903` | `9ae4839afc8ccb23c4bd50a2644f32213273ed90` |
| Review-2 — closure review, PASS, zero findings | `…-shape.review-2.md` | `12b22dd9acfc76094f0803f29d64b5935ead4f83` | `848ee9f940c562f421c6ef727e358d21c73a299f` |
| Shape evidence — adjudications, pre-G1 checks | `…-shape.evidence.md` | `71d90a087ae75e71d86f6c136cb3fcfd3700be01` | `568024b0aea1473049913273d6bd3bf60533d1a1` |
| Review-1 — of plan-v2 | `…-shape.review-1.md` | `96b27e5359b9b4949b31e225cd3be4bfd1479cf1` | `eb827a6715355ed10a82fce3fede46b128864bd9` |
| Plan v3 — **unreviewed historical intermediate** | `…-shape.plan-v3.md` | `9faf94518dfdb64b614440e0703ecf2969f9a239` | `af92e6992e0445535a6a6cc45c149f19c663c74d` |
| Plan v2 — reviewed by review-1, superseded | `…-shape.plan-v2.md` | `bb476184c57d04ee7b0a96645fa655435652c2a9` | `90f0b931272dead2dedb679c8b5cc834b680a3d7` |
| Plan v1 — **stopped** | `…-shape.plan.md` | `d44a4fcf56ea92be3d45ece1c27a5af18ae323ef` | `e93ae5863520e261fecfe57acadd3beecc5b8082` |
| Frame evidence | `…-frame.evidence.md` | `55900183e48d6b5d26193bd4ef6b431da91bb443` | `4349ae7271c01ddd1eb5837e3cb129653a16b272` |
| Frame brief | `…-frame.brief.md` | `bfa33152ac11c9c853c4e1f9029dbd996b3a08f8` | `2ba2bca5a2ac83bb7007dd967a57797a5534d06e` |
| First handoff | `…-shape.handoff.md` | `ccbc011bc614d7665d70f3adea33bb4996bfe2c1` | `12d9263d55fe3fc6207a551a68144f2e027b4bc9` |

**Only plan-v4 may be implemented.** Plan-v1 is stopped, plan-v2 is superseded, and plan-v3 was never
reviewed. None of the three is a build target. All are retained unedited because plan revisions are
immutable (`docs/work-loop.md:140`).

## 4. State

**Last completed transition:** **G1 passed.** The Shape unit's work is complete through the gate —
plan written, independently reviewed twice, adjudicated, pre-G1 identity checks passed, operator
approval given and bound to exact identities.

**Not done:** the Build unit is **not opened** — it has no brief, no evidence and no commits. **No
implementation has begun.** G2 and G3 have not been reached.

**No object under repair has been modified in this stream.** Verified at pre-handoff HEAD:
`git diff --stat 6050a5b HEAD -- docs/work-loop.md .agents/skills/work-loop/SKILL.md
.claude/commands/work-loop.md templates/capability-record.md` → **empty**. Their blobs are unchanged
from the approved base:

| Path | Blob at base and at HEAD |
|---|---|
| `docs/work-loop.md` | `88f555e630a4ae898d0eb6d1827d908faf1bf81a` |
| `.agents/skills/work-loop/SKILL.md` | `33986fb80e15fd26600a619793cef37e79c5650a` |
| `.claude/commands/work-loop.md` | `0e575aa5dab40a07927bd6cc3cf9af07940401f0` |
| `templates/capability-record.md` | `f0580c9e98f45232d83d1cf6d707b39c9e186acf` |

Plan-v4 §13.8 records the same four blobs as the basis for every line number it cites. **They still
match, so plan-v4's line references resolve as written.** If any of them changes before Build, Build
must re-derive the line numbers.

**The Shape unit is deliberately left open, with no `CLOSE` block and evidence not marked
`Status: complete`.** This is a decision, not an oversight. `/work-loop`'s own close-and-resume
machinery must not govern this repair (`…repair-workflow.md` §1, §13.1), so this handoff — not a
`CLOSE` block — is the resume mechanism. The next session takes its state from here, per §14.

**Scope and slice boundary — by reference, not repeated here.** Plan-v4 §4 states the exact four-file
scope, §5 the exclusions, §7 the single atomic slice and its ordered steps. Read those sections rather
than any summary in this handoff.

## 5. Commits produced by this session

Eight, all confined to `logs/loop/`:

| Commit | What |
|---|---|
| `96b27e53` | Review-1 transcribed verbatim |
| `b53c2492` | Adjudication of review-1 — three findings `fixed` |
| `854d977f` | Evidence Entry 3 — RV2-01 persisted-field set strengthened |
| `9faf9451` | Plan-v3 — bounded correction pass |
| `92bd444c` | Evidence Entry 4 — Entry 3 superseded, verbatim rule withdrawn |
| `df45a2b1` | **Plan-v4 — the G1-approved object** |
| `12b22dd9` | **Review-2 transcribed verbatim — PASS, zero findings** |
| `71d90a08` | Evidence Entry 5 — adjudication and pre-G1 identity checks |

Every commit staged by explicit pathspec. No `git add -A`, no `git add .`. No push — pushes are gated
and batched to session wrap.

**Complete `base..HEAD` file set:** `docs/work-loop-repair-workflow.md` plus this stream's ten
`logs/loop/` artifacts. **Nothing else. The diff is bounded to the approved slice** (§7).

## 6. Verification run, and what was observed

| Check | Method | Observed |
|---|---|---|
| Ownership acquisition binding | Repo, worktree, branch, HEAD, base ancestry, handoff blob, both plan identities, clean tree, four protected files | All matched; §6.1 stop did not fire |
| Review-1 envelope | Field-by-field against active binding | All matched |
| Review-1 object | `git rev-parse bb47618:{plan-v2}` and `HEAD:{plan-v2}` | Both `90f0b931…` — reviewer inspected the live object |
| Review-2 envelope | Field-by-field against active binding | All matched |
| Review-2 object | `git rev-parse df45a2b1:{plan-v4}` and `HEAD:{plan-v4}` | Both `9ae4839a…` |
| Review-2 identity binding | `git rev-parse 12b22dd9:{review-2 path}` | `848ee9f9…` — binding relation holds |
| **Pre-G1 comparison (§9.1)** | Recomputed candidate plan identity vs review-2's stated identity | **All three fields matched. G1 not blocked** |
| Objects under repair | `git diff --stat` base→HEAD, four paths | Empty at every checkpoint |
| Worktree | `git status --porcelain` | Empty at every checkpoint |

**Method note carried forward.** Two distinct zsh hazards have now been recorded in this stream: Frame
§1's unquoted word-splitting (silent false negative) and Shape evidence §9.5's `:l` parameter modifier
(loud failure, consumed a path character). **Build must brace-delimit any parameter followed by `:`**
and use explicit literal paths or arrays. Plan-v4 §11.5's mandatory shell note currently warns only
about the first; widening it is a **non-material annotation permitted by the G1 annotation** and must
not become additional scope.

## 7. Open findings and correction budget

**Open material findings: none for this slice.** Review-2 returned zero.

**Deferred, and not to be designed or reworded in Build:**

- **OF-1** — the G1-approved package mutated twice after G1 in the 2026-07-29 stream (`plan-v4`
  `bc435d5`, `plan-v5` `6a81121`). Deferred to Slice 3 or its own slice.
- **OF-3** — a review named at `logs/decisions.md:11` has no artifact at `b8ef77f^`. Deferred to
  Slice 5/6.
- **OF-2** — closed by plan-v4 §6.12.

**Correction budget for this unit is fully spent:**

| Item | Status |
|---|---|
| Initial independent review | Consumed — review-1 |
| Bounded material correction pass | Consumed — plan-v3, then plan-v4 by operator-directed pre-review adjustment. One pass |
| Conditional closure `review-2` | Consumed — zero findings |
| `review-3` | Does not exist in this unit or stream |

**Build opens a new unit with its own budget.** Build carries **no review and no gate**
(`.claude/commands/work-loop.md:136-138`); the next independent review is Prove's, before G2.

## 8. Known limitations, carried from plan-v4 §§13 and 15

- **RV2-01 residual (§13.4).** The header-repair check is identity-level. Matching verdict, finding IDs
  and counts detects a substituted or renumbered review; it does not detect changed reasoning under an
  unchanged ID set. Operator proportionality decision, declared not eliminated.
- `hold-reframe` is defined Shape-side only; Prove-side non-convergence is Slice 3.
- `unassessed` is denied only at challenged-Shape G1; it survives for reviewed-route work and Prove.
- The comparison trusts a faithful transcription — full protection needs Slice 4's writer controls.
- No validator or script is introduced; mechanisation is Slice 5.
- The §6.10 allocation exception is stated, not enforced — Slice 5 owns enforcement.
- No behavioural evidence is obtainable before implementation; M8–M10 belong to Stage 9 (Use).
- The `docs/work-loop.md:102` conflict's causal role remains inference, not observation.

**Worktree is expected clean** at handoff, with nothing staged and nothing untracked.

## 9. Ownership release

> Effective when the commit containing this handoff is created and the worktree is verified clean, I
> release sole-writer ownership of this repair worktree. No other Claude session may write before
> verifying this release and explicitly acquiring ownership.

## 10. Next action

A new Claude Code session must:

1. read `docs/work-loop-repair-workflow.md`, the Frame brief, the Frame evidence, **plan-v4**, the
   Shape evidence, review-2, and this handoff;
2. verify this envelope and the Git state against the repository — chat memory is never the tiebreak
   (§6.2). In particular re-derive plan-v4's identity and confirm it still equals
   `df45a2b1…` / `9ae4839a…`, because **any mutation voids G1**;
3. **explicitly acquire sole-writer ownership** — a handoff does not infer acquisition from silence or
   from a new chat (§7);
4. open the **Build** unit and implement the exact G1-approved package: plan-v4 §7's single atomic
   slice, four files, ordered steps 1–4, with step 4 last;
5. touch **no path outside** plan-v4 §4's four files plus this stream's `logs/loop/` artifacts. Work
   that is worth doing but outside the approved slice is a deferred finding, never a quiet extra edit
   (`…repair-workflow.md` § Stage 7);
6. **stop and report rather than expand** if a discovery materially invalidates the approved plan.

**Do not** re-review plan-v4, implement plan-v1/v2/v3, mutate plan-v4, open G2, invoke `/work-loop` or
its skill to govern this repair, switch branches, pull, merge, rebase, import another stream's
artifacts, or reopen the settled scope decisions recorded in plan-v4 and this handoff.

LIMITATIONS: This handoff records state and authority, not implementation results — nothing has been
built, so no behavioural claim is made or implied. Every identity in it was verified against Git in
this worktree at pre-handoff HEAD `71d90a08`; none rests on an asserted value. The containing commit's
own SHA cannot appear here.
