UNIT: 2026-07-31-g1-reviewed-plan-invariant-shape   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: shape
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: new Claude session

# Shape handoff — Slice 1: G1 reviewed-plan integrity

Governing authority: `docs/work-loop-repair-workflow.md` (§§6, 14).
Written at pre-handoff HEAD `bb476184c57d04ee7b0a96645fa655435652c2a9`. **A file cannot contain its
own commit SHA — the containing handoff commit is reported in the session reply and is the tip of
this branch.**

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
HEAD: pre-handoff bb476184c57d04ee7b0a96645fa655435652c2a9; the commit containing this handoff is the branch tip and is reported in the session reply
OBJECT: logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v2.md at commit bb476184c57d04ee7b0a96645fa655435652c2a9, blob 90f0b931272dead2dedb679c8b5cc834b680a3d7
ROLE: Claude writer — releasing ownership (§4)
NEXT: a new Claude Code session, per §6
```

## 2. Artifact identities

| Artifact | Path | Containing commit | Blob |
|---|---|---|---|
| **Plan v2 — the review candidate** | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan-v2.md` | `bb476184c57d04ee7b0a96645fa655435652c2a9` | `90f0b931272dead2dedb679c8b5cc834b680a3d7` |
| Plan v1 — **stopped** | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.plan.md` | `d44a4fcf56ea92be3d45ece1c27a5af18ae323ef` | `e93ae5863520e261fecfe57acadd3beecc5b8082` |
| Frame evidence | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.evidence.md` | `55900183e48d6b5d26193bd4ef6b431da91bb443` | `4349ae7271c01ddd1eb5837e3cb129653a16b272` |
| Frame brief | `logs/loop/2026-07-31-g1-reviewed-plan-invariant-frame.brief.md` | `bfa33152ac11c9c853c4e1f9029dbd996b3a08f8` | `2ba2bca5a2ac83bb7007dd967a57797a5534d06e` |

**Plan-v2 is the sole candidate for formal review. Plan-v1 is stopped: it must not be reviewed and
must not be implemented.** Both revisions are immutable and neither has been edited. Plan-v1 is
retained only as the record of what was proposed and stopped.

Plan-v2 has passed control-room identity and settled-boundary preflight. **It has not received formal
independent review.**

## 3. State

**Last completed transition:** a pre-review operator scope reframe produced plan-v2. It was a settled
operator scope decision, **not** a formal review correction.

**Current status:** Shape unit **active and open**. Formal independent review **not yet requested**.
**G1 is not open.** No authority file, template file, or object under work has been modified in this
stream — verified: `git diff --name-only 6050a5b HEAD` against `docs/work-loop.md`,
`.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md` and
`templates/capability-record.md` returns empty.

**Scope and slice boundary — by reference, not repeated here.** Plan-v2 §4 states the exact four-file
implementation scope; §7 states the single atomic implementation slice; §5 states the exclusions.
Read those sections rather than any summary. The four-file scope supersedes the earlier three-file
boundary by explicit operator decision, recorded in plan-v2 §1.

**Review and material-correction budget: fully intact.** No review has been requested, produced or
transcribed. One initial review, at most one material correction, and at most one conditional closure
`review-2` all remain available. The v1→v2 reframe consumed none of it.

**Open findings:** OF-2 (no `review-2` artifact path) is **covered by plan-v2** §6.9. **OF-1**
(post-G1 package mutation) and **OF-3** (a review named in `logs/decisions.md:11` with no artifact at
`b8ef77f^`) remain **deferred** to later slices and must not be designed or reworded in this unit.

**Known limitations, from plan-v2 §§13 and 15:**

- `hold-reframe` is defined Shape-side only; Prove-side non-convergence is Slice 3.
- `unassessed` is denied only at challenged-Shape G1; it survives for reviewed-route work and Prove.
- The comparison trusts a transcribed review header — mitigated by the header's internal binding
  check against Git, fully addressed only by Slice 4's writer/ownership controls.
- No validator or script is introduced; mechanisation is Slice 5.
- No behavioural evidence is obtainable before implementation — a live challenged Shape-to-G1 run is
  Stage 9 (Use).
- The `docs/work-loop.md:102` conflict's causal role remains inference, not observation.
- Cited line numbers are as of the blobs recorded in plan-v2 §13.6; Build re-derives them if any file
  moves.

**Worktree is expected clean** at handoff, with nothing staged and nothing untracked.

## 4. Ownership release

> Effective when the commit containing this handoff is created and the worktree is verified clean, I
> release sole-writer ownership of this repair worktree. No other Claude session may write before
> verifying this release and explicitly acquiring ownership.

## 5. Next action

A new Claude Code session must:

1. read `docs/work-loop-repair-workflow.md`, the Frame brief, the Frame evidence, plan-v1, plan-v2,
   and this handoff;
2. verify this envelope and the Git state against the repository — chat memory is never the tiebreak
   (§6.2);
3. **explicitly acquire sole-writer ownership** — a handoff does not infer acquisition from silence
   or from a new chat (§7);
4. **make no repository edit** until the exact independent Codex review of plan-v2 (blob
   `90f0b931272dead2dedb679c8b5cc834b680a3d7`) is returned for transcription and adjudication.

Do not open G1, do not implement, and do not review plan-v1.
