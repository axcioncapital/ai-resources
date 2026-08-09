# Work Loop v2 core resolver — linked-worktree defect report

**Date:** 2026-08-09  
**Status:** Verified defect; correction proposed, not implemented.  
**Scope:** The executable-core resolver mirrored in the deployed Codex skill and Claude command.  
**Trigger:** `$work-loop-v2` was invoked in the `ai-resources-eval` linked worktree to plan the implementation of `eval-mvp-proposal-v0.2.md`.  
**Decision in one line:** replace the checkout-basename test with a verified Git-repository-identity test, while retaining the existing file, symlink, canonical-path, and repository-boundary checks.

## Executive finding

Work Loop v2 cannot run from this linked worktree even though the required executable core is a regular, readable file inside the current repository root. The failure is deterministic and occurs before the resolver tests that file.

The resolver treats direct use from the `ai-resources` **repository** as direct use from a directory whose basename is exactly `ai-resources`. A linked worktree has the same Git common directory as the canonical repository but may have any checkout name. Here its root is named `ai-resources-eval`, so the direct candidate is suppressed. The worktree is also a sibling of `ai-resources`, not a repository under `WORKSPACE/projects/<one-child>`, so workspace discovery is suppressed. Neither candidate reaches `wl2_try_semantic`; consequently the diagnostic says `attempted=none`.

This contradicts the deployed Codex skill's own existing-worktree fallback, which says to open a permanent user-created worktree as a Local checkout and verify that directory first. The current session did exactly that, but the resolver rejected the resulting checkout identity.

## Verified facts

### 1. Exact reproduction

The resolver copied unchanged from `.agents/skills/work-loop-v2/SKILL.md` was run in:

```text
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-eval
```

It exited `1` and emitted exactly:

```text
ERROR: Work Loop v2 semantic source not found within permitted boundary. repo=/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-eval workspace=none attempted=none
```

No relative-path fallback was used.

### 2. The semantic core exists in the rejected checkout

The required path exists as a regular file in the current worktree:

```text
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-eval/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
```

`ls -l` reports a regular readable file, `realpath` resolves it inside the current repository root, and its SHA-256 is:

```text
a0ab7d9115dbfda800430a4e4bf08dad33952e1827baaf02abff83d436305e5d
```

The canonical checkout's copy at `../ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` has the same hash and `cmp` reports byte identity. The failure is therefore not a missing, unreadable, symlinked, divergent, or out-of-bound semantic file.

### 3. The checkout is a linked worktree of the canonical repository

The current `.git` file contains:

```text
gitdir: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/worktrees/ai-resources-eval
```

Read-only Git queries return:

```text
current top-level:  /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-eval
current common dir: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git
main top-level:     /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
main common dir:    /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git
workspace top-level:/Users/patrik.lindeberg/Claude Code/Axcion AI Repo
```

The current and canonical checkouts therefore have different physical roots but the same Git common directory.

### 4. Exact branch trace

| Resolver decision | Observed value | Consequence |
|---|---|---|
| `wl2_repo_root="$(wl2_git_top "$(pwd -P)")"` | `…/ai-resources-eval` | Correctly binds the current Git checkout. |
| `wl2_is_workspace "$wl2_repo_root"` | False: the worktree root does not contain both `projects/` and `ai-resources/` | Does not classify the checkout itself as the workspace. |
| `wl2_projects_dir="$(dirname "$wl2_repo_root")"` | `…/Axcion AI Repo` | This is the actual workspace root, despite the variable name. |
| `basename "$wl2_projects_dir" = projects` | False: basename is `Axcion AI Repo` | The resolver does not test that parent as a workspace; this branch only supports `WORKSPACE/projects/<one-child>`. |
| `workspace_root` | Empty | The canonical workspace candidate is not attempted. |
| `basename "$wl2_repo_root" = ai-resources` | False: basename is `ai-resources-eval` | The existing direct candidate inside the current repository is not attempted. |
| Calls to `wl2_try_semantic` | Zero | `wl2_attempted` remains empty, producing `attempted=none`. |

`attempted=none` is therefore evidence that eligibility gates prevented every file check; it is not evidence that the core path was checked and absent.

### 5. Canonical-checkout positive control

The same exact resolver was run from:

```text
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
```

It exited `0` and printed:

```text
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
```

The material difference at the decisive direct-use branch is only the checkout basename: `ai-resources` passes and `ai-resources-eval` fails.

### 6. Two mirrored deployed surfaces

The resolver appears inline in both:

- `.agents/skills/work-loop-v2/SKILL.md`, between `work-loop-v2-core-resolution` markers;
- `.claude/commands/work-loop-v2.md`, between the same markers.

Extracting and diffing those marked blocks produced no difference. The defect therefore affects both Work Loop actors and must be corrected in both deployed copies in one change.

### 7. Contradiction with the deployed worktree contract

The Codex skill states:

- concurrent writers in one repository should use deliberate isolation such as a worktree;
- genuinely large implementation should use isolation;
- work continuing in a permanent user-created worktree should open that directory as a **Local** checkout and verify the working directory first;
- a task file is bound to the checkout that holds it and must not be copied to another checkout as a repair.

The resolver cannot honor that contract for an `ai-resources` linked worktree unless the linked checkout itself happens to be named exactly `ai-resources`. The eval proposal also says its build should run as a Work Loop task (`eval-mvp-proposal-v0.2.md`, § 9), making this defect the immediate gate on the operator's requested planning flow in this checkout.

### 8. Resolver regression coverage is absent

A repository search for the marker and resolver-specific names (`work-loop-v2-core-resolution`, `wl2_semantic_rel`, `wl2_try_semantic`) outside `.git` and recorded dispatcher run captures found only the two deployed inline copies above. No resolver test, resolver fixture, or canonical reusable resolver fragment was found in that searched surface.

`handoff-automation-spike/dispatch.test.sh` tests dispatcher behavior; it does not contain or exercise this core-resolution logic. The current test surface therefore cannot fail when the two deployed copies reject a supported linked-worktree layout.

## Root cause

**Verified root cause:** the direct-use authorization test is based on the physical checkout basename:

```bash
[ "$(basename "$wl2_repo_root")" = 'ai-resources' ]
```

That is not a stable repository identity. Git linked worktrees preserve repository identity through their common Git directory while deliberately giving each checkout its own root and name.

**Contributing diagnostic defect:** `wl2_attempted` is updated only inside `wl2_try_semantic`, but the rejected layout reaches no call to that function. The final message consequently reports `attempted=none` even though `wl2_direct_path` was constructed and exists. This makes an eligibility failure look like absence without naming the rejected eligibility condition.

**Not the cause:** workspace recognition is intentionally narrow to the current workspace repository or `WORKSPACE/projects/<one-child>`. Merely adding the workspace's sibling-worktree layout would make this one directory arrangement pass, but it would resolve the canonical checkout's core rather than the worktree-local core and would still fail linked worktrees located elsewhere. The load-bearing defect is repository identity being inferred from a checkout name.

## Impact

### Verified

- Codex cannot frame, assess, continue, or close a Work Loop task from this checkout because core resolution is terminal before any Work Loop action.
- Claude's mirrored resolver rejects the same layout before it can act on a task hand-off.
- Moving a task file to the canonical checkout is not a valid repair for a task that belongs to this worktree; the skill explicitly forbids copying task state between checkouts.
- The operator's requested Work Loop planning of `eval-mvp-proposal-v0.2.md` cannot proceed in the current bound checkout under the deployed resolver.

### Inference, bounded by the verified logic

Any linked worktree of the canonical `ai-resources` repository whose root basename is not exactly `ai-resources` will take the same failing direct-use branch unless it coincidentally matches the separately supported `WORKSPACE/projects/<one-child>` layout. Courier or dispatcher launches do not remove the defect because each actor still resolves the core from its routed checkout before acting.

## Immediate workaround

The verified positive control is to run from the canonical checkout at `…/Axcion AI Repo/ai-resources`; the resolver succeeds there. This is compliant only if the work is meant to live in that canonical checkout from the outset.

If the task must remain bound to `ai-resources-eval`, there is no compliant Work Loop v2 workaround in the deployed instructions. The bounded choices are:

1. correct and deploy the resolver first; or
2. do the requested planning as Direct Work without creating a Work Loop state file.

Do not copy a state file between checkouts, create a second state file for the same task, or add an unverified relative-path fallback.

## Recommended correction

### Preferred minimal fix (proposal)

Keep the existing resolution order and all file-containment guards. Replace only the direct-use basename predicate with verified Git repository identity:

1. Resolve and physically canonicalize the current checkout's Git common directory (for example via `git rev-parse --path-format=absolute --git-common-dir`).
2. Derive the canonical repository checkout only when that common directory is its `.git` directory.
3. Verify that the derived checkout is itself the `ai-resources` Git top-level, has basename `ai-resources`, and reports the same canonical common Git directory as the current checkout.
4. When those checks hold, classify the current checkout as a checkout of the trusted `ai-resources` repository and call `wl2_try_semantic` on the **current worktree's** `$wl2_repo_root/$wl2_semantic_rel`.
5. Retain the regular-file, readable, non-symlink, physical-directory containment, canonical-workspace-first, and terminal-no-fallback checks unchanged.
6. Mirror the corrected marked block into both deployed surfaces and mechanically assert their byte identity.

This admits linked worktrees because they share Git identity, not because their parent directory or name looks familiar. It also preserves branch/worktree locality: a task in a worktree reads the semantic core from that same worktree, rather than silently reading the canonical checkout's possibly different branch.

### Diagnostic improvement (same bounded change)

When a trusted `ai-resources` checkout is recognized, call `wl2_try_semantic` even if the file is missing so `attempted=` names the checked path. If repository identity itself is rejected, add a concise reason such as `direct_identity=untrusted` rather than implying a file lookup occurred. This is diagnostic only; it must not widen resolution.

### Rejected shortcuts

- **Remove the basename check and trust any repository containing the relative path.** This widens the trust boundary to a same-named file in an unrelated repository.
- **Recognize any sibling of a directory containing `ai-resources/`.** Directory placement is not Git identity and can select the canonical core while a task is bound to a different worktree branch.
- **Walk upward until a core is found.** This violates the resolver's explicit boundary and creates shadowing ambiguity.
- **Special-case `ai-resources-eval`.** This fixes one checkout name, not linked worktrees as a supported class.

## Falsifiable acceptance checks

The correction is acceptable only if an automated resolver regression test demonstrates all of these outcomes:

1. **Current red case becomes green:** from the actual `ai-resources-eval` linked worktree, exit `0` and print that worktree's own complete core path.
2. **Canonical positive control stays green:** from canonical `ai-resources`, exit `0` and print its own core path.
3. **Workspace and project layouts stay green:** from the verified workspace root and from `WORKSPACE/projects/<one-child>`, print `WORKSPACE/ai-resources/$wl2_semantic_rel`.
4. **Location independence:** a linked worktree of the same `ai-resources` Git common directory, created under a different parent and arbitrary checkout name, resolves its own core.
5. **Unrelated-repository negative control:** an unrelated Git repository named `ai-resources-eval` containing a copied file at the semantic relative path exits nonzero; no path is printed.
6. **File guards stay closed:** missing, unreadable, symlinked, or physically escaping candidates exit nonzero and do not become the semantic path.
7. **Diagnostic discrimination:** a recognized `ai-resources` worktree with a missing core names the attempted absolute path; an untrusted repository reports identity rejection rather than `attempted=none` alone.
8. **Mirror parity:** the marked resolver blocks in the Codex skill and Claude command are byte-identical, and the test fails if either copy drifts.

The regression harness must first reproduce the current linked-worktree failure against the pre-fix resolver; otherwise a post-fix pass would not prove that it covers this defect.

## Sources and evidence boundary

Primary local sources only:

- `.agents/skills/work-loop-v2/SKILL.md` — deployed Codex resolver, checkout binding, isolation policy, and existing-worktree fallback.
- `.claude/commands/work-loop-v2.md` — mirrored deployed Claude resolver and terminal core requirement.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — required semantic core found in both checkouts.
- `plans/work-loop-v2-v0.2/eval-mvp-proposal-v0.2.md` — triggering proposal and its instruction to run the build as a Work Loop task.
- `.git` plus read-only `git rev-parse` results — current top-level, common Git directory, canonical repository, and workspace identities.
- Exact resolver executions in the current and canonical checkouts, file metadata, `realpath`, SHA-256, `cmp`, marked-block `diff`, and the bounded repository search described above.

No web source, model recollection, or external documentation is used. Proposals are explicitly labelled and are not presented as verified implementation behavior.
