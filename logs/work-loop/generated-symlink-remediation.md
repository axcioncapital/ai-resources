---
task: generated-symlink-remediation
status: active
turn: codex
---

## Objective and scope

Make manifest-managed shared-resource symlinks checkout-local generated products: canonical manifests and project-owned resources remain tracked, while generated destinations are ignored locally, guarded from staging, and verifiably regenerable at different checkout depths.

This task is limited to the canonical mechanism and regression protection owned by `ai-resources`. The legacy-branch untracking rollout, branch merges or rebases, conflict resolution, pushes, and unrelated symlink systems are excluded; they require a later task in the repository that actually holds the named branches.

Task exit condition: the canonical generated-path calculation is shared by synchronization, local exclusion, staging prevention, and health validation; representative normal and nested-checkout behavior is proven. Units 1–5 are accepted: synchronization, checkout-local exclusion, the canonical commit-boundary guard, its installation/refresh ownership boundary, and the safe installer/refresh implementation are complete. Health validation is the remaining task-level gap.

## Lane and unit

Standard. Implementation mode. Unit 6 — generated-link health validation.

Named reason for the loop: this load-bearing SessionStart mechanism spans multiple bounded units, and its implementation must be independently assessed before it counts as complete.

## Brief

Unit 5 is accepted after its one frozen correction: the executing hook path now comes only from Git's `rev-parse --git-path`, the non-default `core.hooksPath` regression covers relative, absolute, and fixture-contained `~/...` forms, and the required regression set reports no breakage. This unit addresses the task's final explicit exit condition: after synchronization, the same generator-owned path set must support a path-specific health verdict in both ordinary and nested checkouts.

Required outcome: extend the canonical SessionStart synchronization mechanism with fail-open health validation for the shared-generated destinations it owns in that run. The validation must use the exact source/destination set already traversed by the generator, together with the marked local-exclude block it writes; it must not independently reinterpret the manifest, exclusion lists, or skill membership. A healthy generated destination is a symlink that resolves to its expected canonical resource, is not tracked, and is covered by the checkout-local generated ignore block. An unhealthy destination is left untouched and reported with its repository-relative path and actionable reason.

Authority and source disposition:

- Governing: this task's objective and exit condition; accepted implementation commits `2aedc455`, `638ab8cc`, `cd959ac2`, `e0cf0ef0`, and `c58fdf11`; and the accepted Unit 4 ownership boundary in state commit `22c0079d`.
- Settled implementation boundary: `.claude/hooks/auto-sync-shared.sh` is the single owner of generated-path calculation and the marked local-exclude block. `.claude/hooks/pre-commit` consumes that block rather than recalculating membership. Health validation must share this contract rather than become a second owner.
- Non-governing background: `.claude/commands/fix-symlinks.md` is an operator-triggered workspace repair flow, not the SessionStart health surface. Its current drift/missing pass separately derives only command/agent expectations. It may inform failure wording, but this unit must not modify it or rely on it as proof that SessionStart health is complete.
- Codex framing decision: keep one dominant deliverable—inline generated-link health validation plus one focused disposable-fixture suite. Retired-resource cleanup, broad symlink inventory, and repair behavior are held outside because they do not share the current generator-owned destination set and would turn this into a second remediation system.

Check against the repository before editing:

1. In `.claude/hooks/auto-sync-shared.sh`, the command, agent, and `skills.shared` loops still own the authoritative source/destination traversal; `note_generated` still derives the managed local-exclude entries from those same loops; and `write_exclude_block` still writes the exact marked block before guard installation.
2. In `.claude/hooks/pre-commit`, Guard 3 still consumes only the marked block from the checkout's local Git exclude file and does not recalculate manifest membership.
3. Searched surface `.claude/hooks/auto-sync-shared.sh` for post-generation checks of link type, resolved canonical target, Git tracking, and ignore coverage: no complete health validation currently exists. Existing generation, drift, write-failure, unknown-skill, Work Loop capability, and guard-install messages do not jointly establish those four properties.
4. In `.claude/commands/fix-symlinks.md`, the drift/missing pass still parses `EXCLUDE_COMMANDS` and `EXCLUDE_AGENT_GLOBS` and derives command/agent membership separately, while omitting the generator's core and manifest-opted shared-skill set. If this or another already-canonical health owner makes the proposed SessionStart validation redundant, hand back with the evidence rather than building a duplicate.

Required behavior:

1. Validate the final state after generation and after the local-exclude block is maintained. For every generated destination in the authoritative traversal, distinguish: not a symlink; dangling; resolves somewhere other than its expected canonical source; tracked by Git; or missing from the exact marked local-exclude coverage. Do not treat mere existence as health.
2. Compare resolved physical targets so correct relative links pass at different checkout depths without encoding one machine's absolute target in repository content.
3. Keep project-owned regular files safe: never replace, ignore, or classify them as healthy generated products. Existing drift reporting may remain the owner of regular-file divergence.
4. Aggregate health failures through the existing SessionStart `additionalContext` payload under one unambiguous prefix such as `GENERATED-HEALTH:`. Name each affected repository-relative path and the reason/correction. A health failure must remain fail-open—exit 0 and never block session start or mutate the unhealthy destination to make the check pass.
5. Preserve the accepted local-exclude, staging-guard, installer collision/provenance, atomic-write, worktree, and idempotency behavior. Do not broaden canonical membership, change the guard's collision policy, or create a standalone health framework.

Scope and exclusions:

- In scope: `.claude/hooks/auto-sync-shared.sh`, one focused health regression suite under `logs/scripts/`, and this state file. Change another existing focused test only if the health behavior makes a directly overlapping assertion false; report why.
- All fixtures must be disposable. No live hook, local exclude file, generated link, downstream project, workspace-root surface, or Git setting may be changed by the test run.
- Excluded by Codex framing: `.claude/commands/fix-symlinks.md`; automatic repair or deletion; retired-resource discovery; `projects/strategy-os` registration; workspace-root stale-hook adoption; project-owned hook composition; JSON-message escaping; script-mode cleanup; documentation; legacy tracked-link rollout; downstream writes; and branch, merge, rebase, or push operations.

Capability subset: baseline only—repository reads and history inspection, disposable local fixtures including linked worktrees, local tests, edits within the scoped hook/test/state paths, and Claude-owned local commits. Nothing is selected from the pre-authorizable set, which is empty today. No network, live installation, downstream write, push, merge, rebase, credential access, destructive shared-state action, or operator-reserved capability is authorized.

Evidence required:

1. Failing-before/passing-after evidence that can fail: in a disposable manifest-bearing repository, place a managed destination at a resolving but wrong symlink target. The pinned pre-health hook must preserve it without producing a generated-health verdict; the implemented hook must preserve it, exit 0, name the path, and report that its resolved target differs from canonical.
2. Healthy normal-checkout evidence: generate representative command, agent, core-skill, and manifest-opted-skill links. Prove each is a symlink resolving to the expected canonical resource, absent from `git ls-files`, covered by the exact managed local-exclude block, and silent under the new health prefix. Deleting the generated links and rerunning must recreate them without changing tracked files or producing `git status --porcelain` noise.
3. Healthy nested-checkout evidence: repeat the representative proof in an actual linked worktree placed at a different directory depth. Assert the links use the correct relative target for that checkout and resolve to the same canonical resources; the worktree's local exclude surface must cover exactly its generated destinations.
4. Unhealthy Git-state evidence: a disposable fixture with a generated destination already tracked and with unusable/missing managed-block coverage must remain byte-untouched, exit 0, and report the path-specific tracking and ignore-coverage failures. A project-owned regular file at a managed name must remain unignored and untouched and must not be reported as a healthy generated symlink.
5. Regression protection: the focused health suite; `auto-sync-shared-excludes.test.sh`; `pre-commit-generated-guard.test.sh`; `auto-sync-shared-guard-install.test.sh`; `pre-commit-hook.test.sh`; and `bash -n` for changed shell files all pass. Do not rerun unrelated suites. Show at least one targeted mutation or equivalent negative control that makes the new health suite fail rather than merely grepping wording supplied by this brief.
6. Report the exact changed-file list and commit id. Report branch divergence separately and do not reconcile it.

Completion condition: implement the generator-owned health validation, prove the failing case plus healthy normal and nested-checkout behavior in disposable fixtures, preserve the accepted mechanisms, commit the scoped changes plus this state record, set `turn: codex`, and hand back for final task assessment.

Stop and hand back if any verify-first claim is false; if health validation requires a second manifest/exclusion interpretation; if the required Git tracking or local-ignore verdict cannot be established safely; if representative nested behavior cannot be proven without touching a live checkout; if the change would overwrite or ignore a project-owned file; or if completion requires repair behavior, a new deployment owner, broader authority, or scope outside this brief.

Deferrals to carry into task closure, not implement here: `projects/strategy-os` registration repair; workspace-root stale-hook adoption; project-owned hook composition; legacy cleanup and branch rollout; two stale documentation claims; JSON escaping in aggregated `additionalContext`; script executable-mode normalization; and rerunning the five earlier installer mutation legs after the frozen correction (the correction changed only the resolver/tests and its required clean regression set passed).

## Latest result

Reproduced (2026-08-17) — frozen finding 1 reproduces on every point, and my ownership premise was false:

- The manifest opt-outs really do precede the record: `in_list "$name" "$LOCAL_COMMANDS" && continue` at line 517, `LOCAL_AGENTS` at 536, `LOCAL_SKILLS` at 554, each above its `note_generated` call at 519/538/561. So a non-symlink surviving into `managed_pairs` is undeclared, not project-owned.
- The drift pass cannot close it: lines 599 and 609 append to `drifted` only when `diff -q "$src" "$target"` fails, so a byte-identical regular copy is silent, and line 612 confirms skills have no drift pass at all.
- The collision is neither ignored nor guarded: inside `note_generated`, `[ -n "$repo_top" ] && [ -L "$dest" ] || return 0` gates the only `managed_excludes` append, and Guard 3 consumes just that block — so an undeclared non-symlink could be committed with no verdict from any message.

Result: corrected, scope frozen to the non-symlink fallthrough and its regression. `validate_generated_health`'s silent fallthrough is replaced by an explicit reported branch: any existing non-symlink at a traversed managed name is now named under `GENERATED-HEALTH:` as `not a symlink`, distinguishing `a regular file` / `a directory` / `neither a regular file nor a directory`, and carrying the manifest-local correction keyed to the destination's kind (`commands.local` / `agents.local` / `skills.local`). It is left byte-untouched, unignored and fail-open — no repair, no re-link, no delete, exit 0. The section's ownership comment is rewritten to state why the opt-out ordering makes "undeclared collision" the only reading, and why the separate `AI-RESOURCES DRIFT:` message keeps its own ownership of content divergence rather than being removed or broadened. Nothing else changed: traversal, physical-target comparison, tracking lookup, marked-block coverage, worktree behaviour, installer and guard behaviour, and all exclusions are as accepted.

Evidence: `logs/scripts/auto-sync-shared-health.test.sh`, now 74 assertions, `pass=74 fail=0 skip=0`, every fixture disposable under `mktemp` — no live hook, exclude file, generated link, project, workspace-root surface or Git setting is read or written.

- Failing case for this correction (leg F before/after, pinned): against the Unit 6 implementation body `be42752e`, a **byte-identical** regular copy at an undeclared managed command name produces no health verdict, no `AI-RESOURCES DRIFT` verdict, and is not ignored — wholly silent, which is the gap. The corrected generator reports `[.claude/commands/driftcmd.md: not a symlink, a regular file occupies this shared-generated name and was left untouched; declare it under commands.local in .claude/shared-manifest.json to own it, or remove it so the next session start regenerates the link]` while the file stays byte-identical, a regular file, and unignored. The before-leg carries a planted-file guard assertion, so it cannot pass vacuously — an earlier draft did exactly that and the guard is what caught it.
- Skills surface, the one with no drift pass at all (leg F): a real project-local directory at the core skill name `diagnose-and-fix` is reported `not a symlink, a directory` with the `skills.local` correction, and its `SKILL.md` is byte-untouched and unignored.
- Declared locals stay silent (leg F): with `commands.local: ["localcmd"]` in the manifest, a regular file at `.claude/commands/localcmd.md` never enters the traversal and appears nowhere in the health segment, byte-untouched and unignored.
- The separate drift message is preserved (leg D): the differing regular copy is now named by both messages — `AI-RESOURCES DRIFT` for content divergence and `GENERATED-HEALTH` for occupying a generated name. Both are asserted in the same run, so neither can be silently dropped.
- The accepted Unit 6 evidence still holds unchanged: leg A's wrong-but-resolving target against pinned `d0d90237`; leg B's four healthy destinations plus delete-and-regenerate with `git status --porcelain` empty and `git diff --quiet HEAD` clean; leg C's real linked worktree at `projects/deep/nest/proj-wt`, different relative target, same resolved canonical, exclude surface covering exactly its five generated destinations; leg D's tracked-plus-unusable-block reporting with target and mtime unchanged; leg E's two mutation controls, which still make the target-comparison and tracking verdicts disappear.
- Regression protection, the required set only: `auto-sync-shared-excludes.test.sh` 16/16; `pre-commit-generated-guard.test.sh` 8/8; `auto-sync-shared-guard-install.test.sh` 59/59 skip=0; `pre-commit-hook.test.sh` all arms pass; `bash -n` clean on both changed shell files. No unrelated suite was run.

Changed files: `.claude/hooks/auto-sync-shared.sh`, `logs/scripts/auto-sync-shared-health.test.sh`, `logs/work-loop/generated-symlink-remediation.md`. Correction commit id: recorded in the follow-up commit noted below.

Nothing newly noticed during this correction is carried as a new deferral; the deferral list in the brief is unchanged.

Branch divergence, reported and not reconciled: local `main` is ahead of `origin/main` by the accumulated Unit 1–6 commits plus this correction. Nothing was pushed, merged or rebased.

## Blocker

None.

## Next action

Codex: closure check on frozen finding 1 only — is the non-symlink fallthrough resolved, and did the correction break anything? The verdict wording and the manifest-local correction are in `validate_generated_health`'s else branch; the proof that it was previously silent is leg F's pinned before-leg against `be42752e`; the preserved `AI-RESOURCES DRIFT:` behaviour is asserted in leg D. Then close the task or use the post-correction menu.
