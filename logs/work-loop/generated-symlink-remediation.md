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

Inspected (2026-08-17):

- Claim (1): HOLDS — read `.claude/hooks/auto-sync-shared.sh`; the command, agent and `SHARED_SKILLS` loops are still the only source/destination traversal, `note_generated` still derives the managed exclude entries inside those same loops, and `write_exclude_block` still runs before `install_generated_guard` (pre-change lines 423 and 427).
- Claim (2): HOLDS — searched `.claude/hooks/pre-commit` for manifest or exclusion recalculation; Guard 3 (lines 60–127) `sed`-extracts only `EXCL_BEGIN`/`EXCL_END` from the generator, `awk`-extracts the block from `git rev-parse --git-path info/exclude`, and matches staged paths against it. No `jq`, no `shared-manifest`, no exclusion list.
- Claim (3): HOLDS — searched `.claude/hooks/auto-sync-shared.sh` for `ls-files|realpath|readlink|check-ignore|health|GENERATED-HEALTH`; the only two matches were a `pwd -P` inside `note_generated` and a `readlink` inside the guard's symlink report. No post-generation check of link type, resolved target, Git tracking or ignore coverage existed.
- Claim (4): HOLDS — read `.claude/commands/fix-symlinks.md` lines 59–155; the drift/missing pass parses `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` out of the hook and iterates only `("command", …, "commands")` and `("agent", …, "agents")` — no core or manifest-opted skill set, and no tracking or ignore-coverage verdict anywhere. It does not make SessionStart health redundant.

Result: Unit 6 implemented. `.claude/hooks/auto-sync-shared.sh` now runs `validate_generated_health` last, after generation and after the managed block is written. `note_generated` takes `<dest> <src> <kind>` and records two deliberately different sets: `managed_pairs` (every traversed destination, whatever is at that path — so "not a symlink" is sayable) and the unchanged `managed_excludes` (symlinks only). Path relativization moved into one `rel_in_repo` owner so exclude entries and health verdicts cannot spell the same destination two ways. Per symlink destination, four properties are measured: it is a symlink, it resolves to its expected canonical source, it is untracked, and it is covered by the marked block read back off disk (the same consumption contract as Guard 3). Resolution is physical via a flag-free `readlink` loop, so a correct relative target passes at any depth and no absolute path enters repository content. Failures aggregate into the existing `additionalContext` under `GENERATED-HEALTH:`, one bracketed `[path: reason]` entry each; exit stays 0 and nothing is repaired, re-linked or deleted. Ownership stayed narrow on purpose: a project-owned regular file at a managed name and a real project-local skill directory are distinguished, never counted healthy, and stay silent here because the existing drift pass and the skills no-drift rule already own them — reporting them would create the second owner the brief forbids. `git ls-files` is one call for the whole set, not one per destination, because this is SessionStart.

Evidence: new suite `logs/scripts/auto-sync-shared-health.test.sh`, 53 assertions, `pass=53 fail=0 skip=0`, all fixtures disposable under `mktemp` — no live hook, exclude file, generated link, project or Git setting is read or written.

- Failing case (leg A), one fixture, same wrong link: a managed name pointed at a resolving-but-wrong target. Pinned pre-health generator `d0d90237` exits 0, preserves the link, and emits **no** health verdict. Current generator exits 0, preserves the link byte-for-byte, and reports `[.claude/commands/sharedcmd.md: it resolves to <tmp>/decoy.md, not to the canonical <tmp>/ai-resources/.claude/commands/sharedcmd.md]`.
- Healthy normal checkout (leg B): command, agent, core skill and manifest-opted skill each proven a relative symlink resolving to canonical, absent from `git ls-files --error-unmatch`, present as an exact `grep -qxF` line in the managed block, and silent under the health prefix. Deleting all four and rerunning regenerates them healthily with `git status --porcelain` empty and `git diff --quiet HEAD` clean.
- Healthy nested checkout (leg C): a real `git worktree add` at `projects/deep/nest/proj-wt`. All four links resolve to canonical; the worktree's relative target differs from the main checkout's (proving depth is handled, not hard-coded) while both resolve to the same canonical file; the exclude surface `git rev-parse --git-path info/exclude` resolves for that worktree contains **exactly** its five generated destinations, sorted-compared, not merely "contains".
- Unhealthy Git state (leg D): a tracked generated destination under a hand-mangled (two-`BEGIN`) exclude file. Run exits 0; both reasons reported on the named path — `tracked by Git, so a checkout-local product is committed content (git rm --cached …)` and `not covered by the managed block in …`; the link keeps its exact target and its mtime; the mangled exclude file is byte-identical to what it found. A project-owned regular file at a managed name stays a regular file, byte-untouched, unignored, and does not appear anywhere in the health segment.
- Negative controls (leg E), both against disposable copies of the generator, so the assertions bind to code rather than to wording this brief supplied: neutering the resolved-target comparison makes leg A's verdict disappear entirely; neutering the tracked-set lookup makes the tracking verdict disappear, paired against the unmutated generator reporting it on the same fixture shape. Both mutations exit 3 → `skip`, never `pass`, if their target text is absent.
- Regression protection: `auto-sync-shared-excludes.test.sh` 16/16; `pre-commit-generated-guard.test.sh` 8/8; `auto-sync-shared-guard-install.test.sh` 59/59 skip=0; `pre-commit-hook.test.sh` all arms pass; `bash -n` clean on both changed shell files. No unrelated suite was run.

Changed files: `.claude/hooks/auto-sync-shared.sh`, `logs/scripts/auto-sync-shared-health.test.sh`, `logs/work-loop/generated-symlink-remediation.md`. Commit id: `be42752e`.

Branch divergence, reported and not reconciled: local `main` is ahead of `origin/main` by the accumulated Unit 1–6 commits; nothing was pushed, merged or rebased.

Judgment disclosed for assessment: requirement 1 lists "not a symlink" among the states to distinguish. It is distinguished in a named branch and never counted healthy, but it is not *reported* under the health prefix, because requirement 3 leaves regular-file divergence with the existing drift pass and the skills loop deliberately has no drift pass. Emitting a health line there would duplicate an existing owner. A destination that is absent after the run *is* reported, because nothing else owns that case.

## Blocker

None.

## Next action

Codex: assess Unit 6 — generator-owned health validation. The task's final exit condition is now addressed; confirm the four properties are measured off the generator's own traversal and written block rather than a second interpretation, that the disclosed "not a symlink" ownership judgment is acceptable, and that the negative controls establish the evidence can fail. Then close the task or freeze findings for one correction. Deferrals listed above are carried, not implemented.
