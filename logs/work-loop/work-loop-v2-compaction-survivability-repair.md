---
task: work-loop-v2-compaction-survivability-repair
turn: codex
---

## Objective and scope

Make Work Loop v2 reliably recover its authoritative task after Codex compaction in every intended Work-Loop-enabled project, without adding parallel state, weakening actor boundaries, or duplicating recovery authority. The task exits only when the instruction layer is review-clean, the approved deployment scope is installed, and one representative project-repository compaction proves recovery or a safe stop.

In scope across the task: the instruction-layer correction following commit `df35ddd`; deployment only to verified Work-Loop-enabled projects and future eligible scaffolds; the operator-approved user-level compact-hook carrier; proportionate operational proof. Excluded: distributing these skills to every project, a five-compaction endurance exercise, broad Work Loop redesign, a second recovery artifact, and approving or rewriting the executable core without a later explicit operator decision.

## Lane and unit

Standard. Implementation mode. Unit 5 — correct the instruction layer's overbroad prohibition on Codex using Git without weakening the Claude-owned commit boundary.

Named reason for the loop: the repair crosses sessions and repositories, needs bounding before deployment, and requires independent assessment of Claude's evidence before changes propagate to project environments.

Why this unit, why now: Unit 4 is accepted, but Unit 2 left one material instruction-accuracy defect unresolved. The durable transport evidence distinguishes allowed read-only Git inspection from prohibited `.git` mutation, while the current instruction layer repeatedly turns that narrower fact into `Codex never runs git`; correcting that mismatch is the smallest remaining step toward a review-clean instruction layer before deployment.

Governing authority: the operator-approved clause assigning every commit to Claude; `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` § 2, which establishes that Codex read-only Git commands succeeded while `.git` writes were refused; and the operator's decision that only individually approved executable-core clauses govern. The draft core must not be rewritten or promoted by this unit.

Codex framing decision: this unit contains one semantic correction across only the instruction surfaces that currently overstate the Git boundary, plus proportionate regression evidence. Deployment, user settings, project files, scaffolding, operational proof, unexplained project skill-link provenance, and the deferred hook-pointer concern stay outside because they are separate deliverables.

Pre-implementation risk review, completed by Codex before opening the unit:

1. **Authority:** Claude must remain the only actor that stages, commits, checks out, or otherwise mutates Git state; correcting the overstatement must not transfer repository-reality ownership to Codex.
2. **Behavior:** Codex may use read-only Git only where its own permitted judgment needs a repository fact; Claude still supplies implementation, test, diff, status and commit evidence at the seam where the Work Loop assigns those duties to Claude.
3. **Recovery:** Reorient's local `.owner` fallback must remain local and non-mutating. Its existing owner-check validation must not be weakened merely because the surrounding rationale is corrected.
4. **Authority scope:** the resolver block, executable core, routing index, protocol tokens and deployment surfaces are outside this unit.
5. **Validation:** evidence must distinguish the false broad wording from the narrower approved mutation boundary, prove the old overstatement is gone from the bounded instruction surfaces, and prove the commit/actor seam remains explicit.

## Brief

Required outcome: make the Work Loop and Reorient instruction layer state the actual Git boundary precisely: Claude owns all Git mutations and commits; Codex may perform read-only Git inspection when needed within its role. Remove claims that the evidence or authority prohibits every Git invocation, without broadening Codex into Claude's live implementation and evidence role.

Check against the repository:

1. Search the active Work Loop v2 and Reorient instruction surfaces for absolute claims such as `never run git`, `runs no git`, and equivalent prohibitions. Report the bounded searched paths and each controlling occurrence before editing; do not infer beyond that surface.
2. Check each occurrence against the approved Claude-commit clause and `step-2-transport-seam-conclusions.md` § 2. Preserve a prohibition where it accurately describes a specific operation or local procedure; correct it where it falsely asserts that Codex cannot use read-only Git at all.
3. Keep the actor seam explicit: Codex does not stage, commit, checkout, reset, merge, rebase, push, or otherwise mutate Git state; Claude remains responsible for repository implementation, tests, technical evidence and every commit. Do not turn permission into a routine duty for Codex where Claude already owes the evidence.
4. Preserve Reorient's validated `.owner` fallback order, stop conditions, local-only scope, and warning that cross-checkout claims require repository-depth inspection by Claude or the dispatcher.
5. Do not change the draft executable core, resolver block, routing index, acceptance ceilings, project installations, templates, manifests, user settings or hook deployment.

Required evidence capable of failure:

- Before editing, quote the contradictory evidence pair: at least one overbroad instruction-layer claim and the Step 2 record showing successful read-only Git plus refused `.git` mutation.
- After editing, search the same bounded surfaces for remaining absolute no-Git claims and classify any retained match by why it is accurate. A zero-match check alone is insufficient; also show that the Claude-only mutation and commit boundary remains present.
- Run the relevant existing instruction acceptance checks only if they cover the changed behavior; otherwise provide a focused failing-before/passing-after text check that can fail on both an overbroad prohibition and a missing mutation boundary. Do not invent a broad new test matrix.
- Run the resolver parity test if `work-loop-v2/SKILL.md` changes, because that file contains the protected block, and report the result without modifying the block.
- Confirm changed paths are limited to the minimum instruction files and this state file. Report automatic `logs/friction-log.md` telemetry separately and exclude it from the commit.
- Set `turn: codex` and commit the handback. Do not push.

Completion condition: the bounded instruction surfaces no longer misstate a Git-write restriction as a ban on all Git use, the Claude-only mutation/commit boundary and repository-reality ownership remain unambiguous, Reorient recovery behavior is unchanged, and the correction is committed for Codex assessment.

Stop and hand back if the controlling occurrences extend beyond the bounded instruction surfaces, the evidence does not support a precise replacement boundary, or the correction would require changing an approved core clause. Stop for the operator if preserving the role split requires a new policy choice. A false premise is a valid result; report it instead of widening scope.

## Latest result

Implementation unit. Every premise held; the correction was implemented as briefed.

```
Inspected (2026-08-13):
- Claim (1) overbroad claims exist on the bounded surfaces: HOLDS. Searched all five active
  instruction files — `.agents/skills/work-loop-v2/SKILL.md`,
  `.agents/skills/work-loop-v2/references/routing-index.md`, `.agents/skills/reorient/SKILL.md`,
  `.agents/skills/reorient/agents/openai.yaml`, `.claude/commands/work-loop-v2.md` — for every
  occurrence of `git`, then classified each. Seven controlling occurrences, all asserting the
  prohibition of the actor rather than of an operation:
    SKILL.md L141 `You **never run git.**`; L182 `You still never run git.`;
    L197 `both need \`git worktree list\`, and you run no git`;
    L254 `This does not loosen "you never run git."`; L500 `Commit, or run any git command.`
    reorient L107 `Codex does not run git under Work Loop v2.`;
    L206 `Running git directly instead of preserving the Work Loop role boundary.`
  Plus one false rationale: reorient L70 `runs no git, which is what keeps the fallback inside
  Codex's authority` — the fact is true, the stated reason is not.
  Searched `.claude/commands/work-loop-v2.md` and `references/routing-index.md` for the same
  patterns: no match in either. `reorient/agents/openai.yaml` contains no `git` at all.
- Claim (2) the evidence supports a precise narrower boundary: HOLDS. `step-2-transport-seam-
  conclusions.md` § 2 states it outright — "**The fence is on `.git` writes specifically — not on
  Git as a whole.** Three data points from inside Codex: `git status --short` succeeded, `git log
  --oneline` succeeded, `git add` failed. Read commands pass; the write is refused." The approved
  Claude-commit clause (core § 4) agrees and is already narrow: Codex "was refused write access to
  `.git`". Searched the core for `never run git` / `run any git`: no match — the core never carried
  the overstatement, so no approved clause needed changing.
- Claim (3) the accurate no-git statements must survive: HOLDS. `work-loop-owner.sh` L115 and L327
  state that `--depth local` is git-free, and its only `git` invocation is L221 inside the
  repository-depth path. So reorient L59 ("plain file reads and need no git") and SKILL.md L195
  ("`--depth local` … run no git") describe real procedures accurately and were preserved.
- Claim (4) no existing acceptance check covers this behavior: HOLDS. Searched
  `work-loop-v2-slice-1.test.sh` for `never run git|runs no git|run any git|does not run git`: no
  match. A focused check was therefore built rather than an existing one reused.
```

Result: the bounded instruction surfaces now state the real boundary. Codex never *mutates* Git
state — `add`, `commit`, `checkout`, `reset`, `merge`, `rebase`, `push` — and Claude makes every
commit and owns repository reality; read-only inspection is permitted where Codex's own judgment
needs a repository fact, and is explicitly bounded so it never displaces the evidence Claude owes at
the seam. Eight sites changed across two files: SKILL.md L141 (mutation bullet plus a new paragraph
carrying the permission and its two limits), L182, L197, L254, L500; reorient L70, L107, L206.
Reorient's `.owner` fallback is untouched in order, stop conditions, local-only scope and its warning
that cross-checkout claims need repository-depth inspection by Claude or the dispatcher. `SKILL.md`
526 → 528 lines, `reorient/SKILL.md` 228 → 233.

Evidence:

- **Contradictory pair, quoted before editing.** Overbroad: SKILL.md L141 `You **never run git.**`
  and reorient L107 `Codex does not run git under Work Loop v2.` Against Step 2 § 2: `git status
  --short` succeeded and `git log --oneline` succeeded from inside Codex, while `git add` failed with
  `Unable to create '.../.git/index.lock': Operation not permitted`. Read passes, write is refused.
- **Focused check, failing before and passing after.** Twelve assertions over the bounded surfaces in
  four groups: A no absolute actor-level no-Git prohibition, B the mutation and commit boundary is
  stated by naming the verbs, C read-only is permitted *and* bounded against Claude's evidence duty,
  D Reorient's fallback survives. Against `HEAD`: `passed: 6 failed: 6`. Against the working tree:
  `passed: 12 failed: 0`.
- **It fails in both directions, which is the point.** Group A fails on the pre-change files. Group B
  fails on a mutated copy that removed the overbroad wording *and* deleted the mutation boundary —
  `FAIL B1`, `FAIL B2`, `passed: 10 failed: 2` — so "corrected" text that quietly dropped the
  Claude-only boundary cannot pass this check.
- **Post-change residual scan, with retained matches classified.** Searched the same bounded surfaces
  for `never run git|never runs git|run any git command|does not run git|you run no git`: zero
  matches. Three `no git` phrasings were deliberately retained and are accurate, not overbroad, each
  describing a named procedure rather than the actor: reorient L59 (the manual fallback reads),
  reorient L70 (the six fallback checks), SKILL.md L195 (`--depth local`). The Claude-only boundary is
  independently confirmed present by assertions B1–B3, so the zero-match result does not stand alone.
- **Regression, unchanged:** acceptance harness `passed: 293 failed: 2` — identical to the Unit 4
  post-change run, same two pre-existing `3.1a` failures, nothing new. Resolver parity ran because
  `SKILL.md` changed: `4 passed, 0 failed`, including `check 4 — deployed resolver blocks are
  byte-identical`. The protected block was not touched; all eight edits sit outside L26–132.
- **Changed paths:** `.agents/skills/work-loop-v2/SKILL.md`, `.agents/skills/reorient/SKILL.md`, and
  this state file. No core, resolver block, routing index, ceiling, harness, project, template,
  manifest, user-setting or hook change. `logs/friction-log.md` moved by automatic hook telemetry only
  and is excluded from the commit. The focused check and all mutated copies live in the session
  scratchpad; no test file was added to the repository.

One correction to my own process, stated rather than hidden: the first pass classified five
occurrences, because the initial survey output was truncated at 190 characters per line and cut the
trailing sentences of SKILL.md L182 and L197. The focused check caught both after the first edit
round, and its A-pattern was then widened to `you run no git` to cover actor-level claims while
leaving procedural ones alone. Both are corrected and covered.

Deferrals noticed and not done:

1. **The same overbroad wording exists outside the bounded surfaces, and one instance is pinned by a
   test.** `scripts/axcion-harness-v0.2/carry-turn.sh` L629 and
   `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` L2559 both emit
   `Codex never runs git (core § 4)` as an exit-24 diagnostic, and `carry-turn.test.sh` L414 asserts
   that exact string. The *guards* are correct — they detect a moved HEAD, which is mutation — only
   the message wording overstates. These are transport tooling, not instruction surfaces, and the
   brief bounds this unit to the instruction layer, so nothing was changed. Codex should decide
   whether a follow-up unit covers them, since the test coupling makes it a real edit rather than a
   wording tweak.
2. Historical records in `plans/` carry the old phrasing (`step-6-review-brief.md` L40,
   `handoff-automation-investigation-2026-08-05.md` L76, `handoff-automation-spike/README.md` L892).
   They are records of what was believed at the time and were left alone.
3. No durable regression check now guards this wording — the focused check was not committed, because
   the brief bounds changed paths to the instruction files and this state file. Whether it should
   become a permanent assertion in the acceptance harness is Codex's call.
4. Unit 4's accepted deferrals remain open: no whole-skill line ceiling, the skill-growth trend, the
   unexplained project skill-link provenance, and the hook-pointer duplication concern.

## Blocker

None.

## Next action

Codex: assess the Git-boundary correction. Judge whether the replacement boundary is precise, whether
read-only permission stays bounded so it does not become a routine duty that displaces Claude's
evidence at the seam, whether Claude's exclusive ownership of Git mutation and commits remains
unambiguous, and whether the transport-tooling wording in deferral 1 needs its own unit before
deployment. Then decide close, continue, correct once, or stop.
