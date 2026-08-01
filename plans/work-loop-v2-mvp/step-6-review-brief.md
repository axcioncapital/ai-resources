# Step 6 — candidate review brief

**For:** the fresh-context reviewer (Codex).
**Written by:** Claude, session S9-6ba, 2026-08-01. Claude authored all four candidate files and is
therefore not eligible to review them (`qc-process-v0.1.md`, rule 2).

Read this whole file before opening anything else. Everything you need is named by path.

---

## 1. The candidate — frozen

**Freeze commit: `cc443e1`.** Approval attaches to these bytes, never to a name. If any candidate
file changes after this review, the review is stale and a new candidate exists.

| File | Lines | Blob hash at freeze |
|---|---|---|
| `.claude/commands/work-loop-v2.md` | 114 | `af411f203ada638fa9d4d459a1043ea87e0837aa` |
| `.agents/skills/work-loop-v2/SKILL.md` | 112 | `e6650fc7512b1d3036c576b063dc7450fd10aed1` |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` | 274 | `baf753b1b87e147bbb43a021fb17d821e35d5ac9` |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | 599 | `06b5b17377a1ef5c2db9d72bad49801356d7da68` |

Verify with `git hash-object <path>` before you start. If a hash differs, stop and say so — you are
not looking at the candidate.

## 2. What you are judging it against

These are the **frozen originals**. Judge against them, not against the latest plan and not against
any conversation (`qc-process-v0.1.md`, rule 3).

- `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` — **authoritative**
- `plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` — execution guide
- `plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` — binding on artifact form
- `plans/work-loop-v2-mvp/step-4-slice-plan.md` — the 12 acceptance behaviours
- `plans/work-loop-v2-mvp/README.md` — authority order, and decisions taken after v0.4
- `logs/missions/work-loop-v2-mvp.md` — validation contract, non-negotiables, off-mission signals

**One amendment you must apply, or you will report a false finding.** Acceptance assertion 1
originally read "Codex … commits it". It was amended by operator decision on 2026-08-01: **Claude
makes every commit; Codex never runs git.** Codex was refused `.git` write access in two independent
sessions with a positive control proving it was not a repository fault
(`step-2-transport-seam-conclusions.md` § 2). The artifacts correctly implement the amended version.

## 3. How to run the review — three dimensions, in this order

### Dimension 1 — Behaviour conformance (the strongest check)

Does the artifact *do* what it must? It passes by **behaving**, not by containing the right words.
This is the check that gets skipped, because reading feels like reviewing.

Run the failing cases from `skill-writing-standard-work-loop-v0.2.md` § 8 that apply:

| Behaviour | Failing case | Pass condition |
|---|---|---|
| False premise refused | State file claiming a field exists that does not | Claude reports the inspection, does not implement |
| Continuity | Brand-new session, no conversational memory | Task continues from state file and Git alone |
| Bounded correction | Assessment names findings A and B | Correction touches A and B only; closure checks A and B only |
| Admission discipline | A two-file reversible fix request | Direct Work; no state file created |
| Foreign state rejected | State file with a mismatched task identity | Rejected read-only; nothing mutated |
| Scope discipline | Tempting adjacent improvement mid-unit | Recorded as a deferral, not implemented |

The evidence that each already passed is in `step-5-slice-{1,2,3}-evidence.md`, and the acceptance
harness is `logs/scripts/work-loop-v2-slice-1.test.sh` (142 assertions, `bash` it from the repo
root, exit 0 expected). **Do not take the harness on trust** — it was written by the same author as
the artifacts. Ask of any assertion you doubt: would this go red if the behaviour were absent? Two
harness defects of exactly that shape were already found and fixed during Slice 3.

### Dimension 2 — Standards conformance

Walk `skill-writing-standard-work-loop-v0.2.md` § 10 line by line against each artifact:

- Every sentence traces to an observable behaviour.
- The operator could read it and explain what it makes the models do.
- No executable-core rule is restated — it is linked.
- The trigger says when NOT to activate.
- At most one or two worked examples, with a negative example where a failure mode exists.
- All stop conditions present, each with its on-stop behaviour.
- Only pinned vocabulary used.
- The artifact got shorter, or at least no longer, in its final revision pass.

### Dimension 3 — Authority conformance

Against the originals in § 2: does anything contradict a settled Proposal decision, build beyond MVP
scope, or quietly change a rule while restating it? Watch specifically for Consequential-lane
machinery, worktrees, reviewer machinery or automation leaking in from the complete-system
explainer, which is **destination reference only, never requirements**.

## 4. Rules that bind you

- **You find; you do not fix.** If you fix, the review target moves under you and the result means
  nothing (`qc-process-v0.1.md`, rule 4).
- **Material findings only.** A finding needs a named consequence — what breaks, for whom. A
  cosmetic preference is not a finding.
- **Findings freeze at A, B, C.** Name the material ones. That set is then closed: Claude corrects
  exactly those, and the closure check asks only whether they are resolved and whether the
  correction broke something. Anything you notice later becomes a **deferral**, never a second round.
- **Do not run a second broad review after the correction.** Forbidden by the mission's
  non-negotiables.
- **Do not run git.** Claude commits.

## 5. Already-known limitations — judge these, don't rediscover them

Each is recorded, not hidden. Your job is to say whether each is an **acceptable disclosed
limitation** for a pilot-quality candidate, or a **material finding** that must be fixed first.

1. **Codex cannot see a chat-pasted request.** Full write-up and three options:
   `issue-codex-request-intake.md`. Found twice. The artifacts say the state file is the only
   interface (`core § 4`, `SKILL.md:16`) while also having Codex question the operator directly
   (`SKILL.md:44`) — the two cannot both be true at the first request, when no file exists yet.
2. **Codex's Next instruction contradicted the turn it set.** On 2026-08-01 it wrote `turn: operator`
   into the state file, then ended its reply `**Next:** run /work-loop-v2 in Claude`. `SKILL.md:22`
   supplies that exact sentence as its only worked example of the required Next line.
3. **Folder creation from an absent `logs/work-loop/` is untested.** The folder existed throughout
   all three slices, so the case was unconstructible.
4. **Most opening briefs were hand-written fixtures.** Codex opening a unit was proven in Slice 1 and
   in Step 6's admission run; Slices 2 and 3 used fixture briefs.
5. **Slice 2's menu task's first pass and assessment block are fixture material.** Its correction
   hand-back and closure are real.
6. **The Claude-side command and harness have never had an independent review.** That is what this
   review is for.

## 6. What to hand back

Write your findings into `logs/work-loop/step6-review.md` with `turn: claude`, and end your reply
with the Next instruction to the operator. Structure:

```markdown
## Verdict
Accept / Accept with corrections / Do not accept — one sentence.

## Findings (frozen)
A. {finding} — consequence: {what breaks, for whom} — dimension: {1|2|3}
B. …
C. …
(fewer than three is a fine outcome; do not pad to reach three)

## Judgment on the known limitations
One line per item in § 5: acceptable disclosed limitation, or material finding.

## Deferrals
Things worth doing later that are not findings.
```
