---
task: generated-symlink-remediation
status: active
turn: codex
---

## Objective and scope

Make manifest-managed shared-resource symlinks checkout-local generated products: canonical manifests and project-owned resources remain tracked, while generated destinations are ignored locally, later guarded from staging, and verifiably regenerable at different checkout depths.

This task is limited to the canonical mechanism and regression protection owned by `ai-resources`. The legacy-branch untracking rollout, branch merges or rebases, conflict resolution, pushes, and unrelated symlink systems are excluded; they require a later task in the repository that actually holds the named branches.

Task exit condition: the canonical generated-path calculation is shared by synchronization, local exclusion, staging prevention, and health validation; representative normal and nested-checkout behavior is proven. This unit advances only the synchronization and local-exclusion part.

## Lane and unit

Standard. Implementation mode. Unit 3 — commit-boundary generated-link guard.

Named reason for the loop: this load-bearing SessionStart mechanism spans multiple bounded units, and its implementation must be independently assessed before it counts as complete.

## Brief

Unit 2 is accepted: repository evidence establishes that ordinary ignored-path staging is already handled by Git, while force-add can still put a generated symlink into a commit. This unit closes that narrow commit-boundary hole in the canonical tracked pre-commit body and proves it without claiming downstream deployment that does not yet exist.

Required outcome: when the canonical pre-commit hook body is installed in a checkout, a commit must fail with an actionable path-specific message if the staged index contains a destination listed in the marked generated-symlink block maintained by `auto-sync-shared.sh`. The guard must consume that block rather than reimplement manifest, local-exception, or canonical-resource logic, and ordinary commits must remain unaffected.

Authority and source disposition:

- Governing: the task objective plus accepted Unit 1 commit `2aedc455` and accepted Unit 2 discovery commit `125cfc39`.
- Verified repository reality from Unit 2: Git already refuses ordinary adds of block-covered ignored links; `git add -f` can stage one and the current commit path accepts it; `.claude/hooks/pre-commit` can inspect the final index but has no versioned downstream installer; the managed block is the existing side-effect-free reuse seam.
- Codex technical decision: adopt the pre-commit boundary for this unit because it covers every staging route once installed and avoids weakening the unrelated concurrent-session guard.
- Codex framing decision: this unit edits and proves the tracked guard body and may refresh only this checkout's already-installed `.git/hooks/pre-commit` copy. Versioned downstream installation, full health validation, legacy tracked-link cleanup, and the two stale documentation claims remain adjacent work outside this unit.

Check against the repository before editing:

1. Verify `.claude/hooks/pre-commit` still runs its integrity guards before the no-staged-skill early exit and can therefore protect every commit type. Establish this from the whole hook, not the header comment.
2. Verify the Unit 1 marker assignments and local-exclude path resolution still exist in `.claude/hooks/auto-sync-shared.sh`, and identify a reuse that reads the produced block without triggering synchronization or rewriting Git configuration.
3. Verify the narrow pre-change failure in a throwaway repository: with the current tracked hook installed, force-add one block-covered generated symlink and show the commit succeeds. Record HEAD/index evidence that can distinguish success from a blocked commit.
4. Verify the existing pre-commit regression suite and installation assumptions before changing the body. Do not treat the unsupported “Claude Code picks it up” header claim as authority.

Implementation boundary:

- In scope: `.claude/hooks/pre-commit`; one focused regression test under `logs/scripts/`; this state file; and an exact refresh of this checkout's existing `.git/hooks/pre-commit` copy after the tracked implementation is committed or otherwise at a safe point that does not contaminate the commit.
- Excluded: `auto-sync-shared.sh` behavior changes; project/workspace settings; templates; `check-foreign-staging.sh`; `/sync-workflow`; downstream repositories; docs; branch operations; legacy tracked symlinks; health-check implementation.
- Preserve all existing pre-commit integrity and skill-validation behavior. The new check belongs before any early exit that could skip it.
- The actionable block message must name each staged generated destination and say how to unstage/regenerate it. Do not claim an installed or portable guarantee beyond checkouts where this hook body is actually installed.
- Treat `git commit --no-verify` as the existing explicit bypass shared by all Git pre-commit hooks, not as a new problem to solve in this unit.

Capability subset: baseline only — repository read/search, edits to the scoped tracked files, throwaway local Git fixtures, focused local tests, shell syntax checks, Claude-owned local commit, and refreshing the one existing `.git/hooks/pre-commit` copy in this checkout. Nothing is selected from the pre-authorizable set, which is empty today. No network, push, merge, rebase, downstream deployment, credential access, destructive shared-state action, or other operator-reserved capability is authorized.

Evidence required:

1. Red/green evidence for the same force-add case: before the change the commit succeeds; afterward it fails, names the generated path, and does not advance HEAD.
2. A normal staged non-generated file still commits successfully through the installed candidate hook in the same fixture family.
3. The existing `logs/scripts/pre-commit-hook.test.sh` suite still passes, plus the new focused suite and `bash -n` for every changed shell file.
4. Evidence that the guard reads the Unit 1 managed block and does not contain a second manifest/resource/exclusion interpretation.
5. If the local installed copy is refreshed, prove its bytes match the committed tracked body. Report this as local checkout state, not committed repository content.
6. The resulting commit id and exact changed-file list; report branch divergence separately and do not reconcile it.

Completion condition: implement and commit the canonical pre-commit generated-destination guard with the required failing-before and passing-after proof, safely refresh only this checkout's existing installed hook copy if present, set `turn: codex`, and hand back for assessment.

Stop and hand back without implementing if the current managed block cannot be consumed without duplicating generator logic; if the check would require changing the concurrent-session guard or a deployment surface; if the current hook's ordering makes preservation of existing commit behavior unprovable; or if the required red/green case cannot be made capable of failure.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read the whole tracked `.claude/hooks/pre-commit`: the integrity-guards section (lines 10–48 pre-change) runs before the no-staged-SKILL.md early exit (`exit 0` at line 57 pre-change), so a guard placed inside it protects every commit type.
- Claim (2): HOLDS — `auto-sync-shared.sh` lines 120–121 still carry `EXCL_BEGIN=`/`EXCL_END=` as static single-line start-of-line literal assignments, and lines 122–127 resolve the exclude file via `git rev-parse --git-path info/exclude`. Reuse identified and used: sed-extract the two marker literals from the generator source, read the block between them from the exclude file — read-only, no sync run, no Git-config write.
- Claim (3): HOLDS — verified in the new test's pre-change run against a fixture populated by the real generator with the then-current tracked hook installed: `git add -f` of a block-covered symlink then `git commit` succeeded (assertions "commit is blocked" and "HEAD did not advance" both FAILED pre-change; HEAD comparison recorded via `rev-parse HEAD` before/after).
- Claim (4): HOLDS — `logs/scripts/pre-commit-hook.test.sh` passed all six arms (A–F) pre-change; installation assumption verified as machine-local: this checkout's installed `.git/hooks/pre-commit` copy existed but DIFFERED from the tracked body pre-change (stale install, noted as local state). The header's "Claude Code picks it up" claim was not relied on.

Result: Guard 3 added to the tracked `.claude/hooks/pre-commit`, inside the integrity-guards section (before every early exit). It locates the canonical generator (own repo copy for ai-resources including worktrees, else the `ai-resources/` child of the repo root or an ancestor — the same walk auto-sync uses), sed-extracts the two marker literals, reads the managed block from `git rev-parse --git-path info/exclude`, and fails the commit (exit 1) if any staged path (`git diff --cached --name-only -z`, NUL-safe) matches a block entry — with a message naming each path, pointing at the block, and giving the fix (`git restore --staged <path>`; SessionStart regenerates links; `--no-verify` named as the deliberate bypass per the shared pre-commit convention). Absent generator, markers, exclude file, or block → guard skips (fail-open, same posture as Guard 2). New focused suite: `logs/scripts/pre-commit-generated-guard.test.sh`, fixture populated by the real generator and guarded by the real tracked hook body installed into the fixture repo.

Evidence:
1. Red/green on the same case: pre-change 4/8 assertions failed (force-add commit succeeded, HEAD advanced, no message); post-change 8/8 pass — commit blocked, HEAD unchanged, message names `.claude/commands/sharedcmd.md` and contains `restore --staged`.
2. Ordinary staged non-generated file commits through the installed candidate hook in the same fixture, both before the red case and again after unstaging; a plain repo with no managed block also commits normally (fail-open case).
3. `logs/scripts/pre-commit-hook.test.sh`: ALL ARMS PASS (A–F) after the change; `bash -n` clean on the changed hook and the new test.
4. No second interpretation: the Guard 3 section contains zero occurrences of `jq`, `shared-manifest`, or `EXCLUDE_COMMANDS=` (grep count 0) — it consumes only the generator-extracted markers and the generator-produced block.
5. Installed copy refreshed at a safe point (`.git/hooks/` is untracked; refresh cannot contaminate the commit): `cmp -s` confirms the installed copy is byte-identical to the committed tracked body. Local checkout state, not repository content. The hand-back commit itself ran through the refreshed guard live and passed.
6. Changed files in the commit carrying this hand-back: `.claude/hooks/pre-commit`, `logs/scripts/pre-commit-generated-guard.test.sh` (new), this state file. Branch state reported separately: local `main` ahead of `origin/main` (12 after this commit) and behind 1; not reconciled.

Adjacent work unchanged and still open under the task objective: versioned downstream installation route, health validation, legacy tracked-link cleanup, and the two stale documentation claims recorded at Unit 2.

## Blocker

None.

## Next action

Codex: assess Unit 3 — the commit-boundary generated-link guard against the required outcome and evidence list; decide close, continue (health validation / installation route remain), or correct once.

Current task position: Unit 1 implementation and Unit 2 discovery are accepted. Unit 3 now implements the canonical guard body only. Remaining adjacent scope after this unit: choose and implement a versioned downstream installation/refresh route, then health validation and any warranted one-line invariant/stale-doc correction. Local `main` was ahead 11 and behind 1 of `origin/main` at this handoff and remains unreconciled.

## Blocker

None.

## Next action

Claude: verify the Unit 3 premises, implement and prove the commit-boundary generated-link guard within scope, commit, and hand back to Codex.
