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

Standard. Implementation mode. Unit 1 — generated-path inventory and local excludes.

Named reason for the loop: this load-bearing SessionStart mechanism spans multiple bounded units, and its implementation must be independently assessed before it counts as complete.

## Brief

The operator wants the generated-symlink conflict source removed using Work Loop v2. This first unit establishes the prerequisite policy at generation time without touching legacy branches, so later staging protection and cleanup can rely on one observable set of generated destinations.

Required outcome: when `.claude/hooks/auto-sync-shared.sh` runs for a manifest-managed project, the generated command, agent, and opted-in/core skill destinations that it manages are covered by an exact, idempotent marked block in that checkout's local Git exclude configuration. Project-owned/local destinations and unrelated existing exclude entries remain untouched and unignored.

Authority and source disposition:

- Governing: the operator's current decision to use Work Loop v2 for a simple remediation of generated symlink conflicts.
- Applicable repository contract: `docs/repo-architecture.md` and the current manifest semantics implemented by `.claude/hooks/auto-sync-shared.sh`; preserve relative symlinks and project-owned exceptions unless live repository evidence disproves that reading.
- Non-governing background: the supplied “Generated Symlink Remediation Report.” Its proposed mechanism is useful context, but its claims and branch names are not repository truth.
- Codex framing decision: this unit excludes staging guards, expanded health checks, and fleet cleanup so it has one dominant deliverable. Those remain adjacent work under the task objective.

Check against the repository before editing:

1. Verify `.claude/hooks/auto-sync-shared.sh` is the canonical manifest-aware generator for commands, agents, core skills, and `skills.shared`; establish this from the hook plus its direct consumer documentation.
2. Verify the current hook creates relative links but does not maintain an exact local-exclude block for its generated destinations. Search the whole hook and any directly invoked helper before claiming absence.
3. Verify the manifest `commands.local`, `agents.local`, and `skills.local` entries are the project-owned exceptions the generator must not ignore or replace.
4. Verify the current checkout and branch state. The preparation pass observed a clean `main` that was nine commits ahead and one behind `origin/main`; do not treat that observation as current truth.
5. The report names `managed-it-cloud` and `cleantech-equipment`, which the preparation pass did not find among branches visible from this workspace. This is not a premise for this canonical-mechanism unit; do not infer that the later rollout belongs in this checkout.

Implementation boundary:

- In scope: `.claude/hooks/auto-sync-shared.sh`; focused regression test code under `logs/scripts/`; the minimum directly coupled documentation update only if the live documented contract would otherwise become false; this state file.
- Excluded: `.gitignore` broad-directory rules; existing tracked symlink removal; any branch checkout, merge, rebase, push, or force operation; project content; workspace-root `.claude/hooks/sync-shared-resources.sh`; staging-guard and full health-check implementation.
- Preserve existing unrelated local-exclude content byte-for-byte outside the managed block. Repeated synchronization must produce the same block without duplicates.
- Leave the implementation mechanism to repository evidence. Do not create a second generated-path interpretation that can drift from the generator.

Capability subset: baseline only — read and search the repository, inspect local Git state, edit only the scoped repository files, create throwaway local test fixtures, run focused local tests, and make the local commit owned by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No network, push, merge, rebase, deployment, credential access, destructive shared-state action, or other operator-reserved capability is authorized.

Evidence required:

1. A failing pre-change regression case showing a manifest-managed generated destination is not covered by the intended local exclude behavior.
2. The focused regression test passing after implementation, proving in one representative fixture that generated command, agent, and skill destinations are ignored; project-owned/local destinations are not ignored; unrelated exclude entries survive; and a second run is idempotent.
3. A different-depth case proving relative link generation and the generated exclude paths remain correct when the managed project is nested differently. Reuse the same fixture family rather than building an unrelated test matrix.
4. Shell syntax validation for each changed shell file.
5. The resulting commit id and a concise changed-file list. Report repository/branch state separately; do not claim it was reconciled.

Completion condition: implement and commit the generated-path inventory/local-exclude behavior with the failing-before and passing-after evidence above, then set `turn: codex` and hand back for assessment.

Stop and hand back without implementing if a load-bearing claim is false; if the canonical generated destinations cannot be derived without a second competing interpretation; if safe proof requires touching the real checkout's tracked files or excluded legacy branches; if repository policy requires resolving the diverged branch first; or if the required evidence cannot be made capable of failure.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read `.claude/hooks/auto-sync-shared.sh` end-to-end and `docs/repo-architecture.md` § Symlink topology (line 149 names the hook as the workspace auto-sync generator for commands, agents, `CORE_SHARED_SKILLS`, and `skills.shared[]`); the hook implements exactly that.
- Claim (2): HOLDS — the hook emits relative targets via `os.path.relpath` in all three sync loops; searched the whole hook and its only invoked helper (`logs/scripts/work-loop-capability.sh`, invoked check-only) for `exclude|info/|update-index|gitignore`; no local-exclude maintenance existed — only the unrelated `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` name lists and comments.
- Claim (3): HOLDS — `commands.local`/`agents.local`/`skills.local` are read at hook lines 85–94 and used only as skip-lists in the sync loops; `repo-architecture.md` lines 143 and 153 document them as project-owned.
- Claim (4): HOLDS (re-verified fresh) — `git status -sb`: clean `main`, ahead 9 / behind 1 of `origin/main`; only untracked path was this state file. Not reconciled; reported as-is.
- Claim (5): NOTED — searched `git branch -a`; neither `managed-it-cloud` nor `cleantech-equipment` exists in this workspace. Treated as non-premise per the brief; no rollout inferred.

Result: `auto-sync-shared.sh` now derives, inside the same three sync loops that generate the links, the set of managed generated destinations (symlinks only — regular files at managed names and manifest `*.local` entries are never listed) and rewrites one marked block (`# BEGIN/END auto-sync-shared generated symlinks`) in the checkout's local Git exclude file (`git rev-parse --git-path info/exclude`), root-anchored per destination. Content outside the markers is preserved; an unbalanced hand-edited block or a project outside any Git repo skips maintenance (fail open). New focused regression test: `logs/scripts/auto-sync-shared-excludes.test.sh`.

Evidence: pre-change run of the test failed 8/16 assertions — every "destination is git-ignored" case plus block presence failed; the 8 passes were pre-existing behavior (relative links, project-owned files unignored, byte-preservation). Post-change the same test passes 16/16, covering: generated command/agent/core-skill/opted-in-skill ignored; manifest-local command, drifted regular file, and `shared-manifest.json` unignored; pre-existing exclude content byte-identical prefix; exactly one block; second run byte-identical (idempotent); and a different-depth variant (repo root above the project, project nested two levels down) proving relative links resolve and exclude paths are root-anchored (`/nested/proj2/...`). `bash -n` clean on both changed files. Changed files: `.claude/hooks/auto-sync-shared.sh`, `logs/scripts/auto-sync-shared-excludes.test.sh` (new), this state file — all in the commit carrying this hand-back. Branch state reported separately above (claim 4); not reconciled.

Deferral: `docs/repo-architecture.md` § Symlink topology does not yet document the new local-exclude invariant. Not done now because no documented statement became false (the brief bounds doc edits to that case); worth one rule line once the mechanism survives assessment. Design note, not implemented: a stale generated symlink whose canonical source was later removed drops out of the block and becomes visible to git — intentionally, so `/fix-symlinks` cleanup can see it.

## Blocker

None.

## Next action

Codex: assess Unit 1 — the managed local-exclude block in `auto-sync-shared.sh` against the required outcome and evidence list; decide close, continue (staging protection / health checks remain under the task objective), or correct once.
