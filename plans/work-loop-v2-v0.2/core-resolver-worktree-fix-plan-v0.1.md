# Work Loop v2 core resolver — linked-worktree fix plan

**Date:** 2026-08-09
**Status:** Plan only. Nothing in this plan has been implemented.
**Fixes:** `core-resolver-worktree-defect-report-2026-08-09.md` (same directory).
**Scope level:** B — the resolver fix plus a four-check test script. Report checks 3, 4, 6 and 7 are deliberately not covered; see § 7.
**Execution posture:** Direct Work, next session. Not a Work Loop v2 task — the resolver is the thing being repaired, so routing the repair through the loop adds risk for no gain.

---

## 1. What is wrong, in one paragraph

The resolver decides whether it may read the executable core from the current checkout by testing the checkout's directory name:

```bash
[ "$(basename "$wl2_repo_root")" = 'ai-resources' ]
```

A Git linked worktree keeps the repository's identity but gets its own directory with its own name. So a worktree named `ai-resources-eval` fails that test, no file is ever checked, and the error says `attempted=none` — which reads as "the file is missing" when the truth is "the checkout was never trusted". The defect report verified this end to end.

## 2. State verified on 2026-08-09, before any edit

| Fact | Value |
|---|---|
| Deployed copy 1 | `.claude/commands/work-loop-v2.md`, lines 14–79 |
| Deployed copy 2 | `.agents/skills/work-loop-v2/SKILL.md`, lines 19–84 |
| Copies byte-identical today | Yes — `awk` marker extraction + `cmp` reports no difference |
| Existing resolver test | None |
| `ai-resources-eval` worktree | **Gone.** Not in `git worktree list`. The defect report's literal red case cannot be re-run; a fixture worktree replaces it |
| Git version | 2.50.1 (Apple Git-155) |
| `git rev-parse --git-common-dir` at a repo root | Returns the **relative** string `.git`, not an absolute path |

That last row is load-bearing. The fix must resolve the common directory against the checkout it queried, or the identity test silently misbehaves at a repo root.

## 3. The change — exact replacement bash

Three edits inside the marked block. Everything else in the block stays untouched: the workspace-first order, `wl2_try_semantic`, the regular-file / readable / not-a-symlink / physical-containment guards, and the terminal no-fallback exit.

### 3.1 Add two helpers after `wl2_is_workspace`

```bash
wl2_git_common() {
  local wl2_c
  wl2_c="$(git -C "$1" rev-parse --git-common-dir 2>/dev/null)" || return 1
  case "$wl2_c" in /*) ;; *) wl2_c="$1/$wl2_c" ;; esac
  [ -d "$wl2_c" ] || return 1
  (cd "$wl2_c" && pwd -P)
}
wl2_is_trusted_repo() {
  local wl2_common wl2_canon wl2_canon_top
  wl2_common="$(wl2_git_common "$1")" || return 1
  case "$wl2_common" in */.git) ;; *) return 1 ;; esac
  wl2_canon="${wl2_common%/.git}"
  [ "$(basename "$wl2_canon")" = 'ai-resources' ] || return 1
  wl2_canon_top="$(wl2_git_top "$wl2_canon")" || return 1
  [ "$wl2_canon_top" = "$wl2_canon" ] || return 1
  [ "$(wl2_git_common "$wl2_canon")" = "$wl2_common" ]
}
```

### 3.2 Replace the direct-use branch

Current:

```bash
wl2_direct_path="$wl2_repo_root/$wl2_semantic_rel"
if [ -z "$wl2_semantic_path" ] && [ "$(basename "$wl2_repo_root")" = 'ai-resources' ] &&
   [ "$wl2_direct_path" != "$wl2_workspace_path" ]; then
  wl2_try_semantic "$wl2_direct_path" "$wl2_repo_root" || true
fi
```

Replacement:

```bash
wl2_direct_path="$wl2_repo_root/$wl2_semantic_rel"
wl2_direct_reason=''
if [ -z "$wl2_semantic_path" ] && [ "$wl2_direct_path" != "$wl2_workspace_path" ]; then
  if wl2_is_trusted_repo "$wl2_repo_root"; then
    wl2_try_semantic "$wl2_direct_path" "$wl2_repo_root" || true
  else
    wl2_direct_reason='direct_identity=untrusted'
  fi
fi
```

### 3.3 Make the failure message discriminate

Current message ends `attempted=%s`. Replacement appends the reason when identity was the blocker:

```bash
if [ -z "$wl2_semantic_path" ]; then
  printf 'ERROR: Work Loop v2 semantic source not found within permitted boundary. repo=%s workspace=%s attempted=%s%s\n' \
    "$wl2_repo_root" "${wl2_workspace_root:-none}" "${wl2_attempted:-none}" \
    "${wl2_direct_reason:+ $wl2_direct_reason}" >&2
  exit 1
fi
```

### 3.4 Why this is not a widening of trust

The canonical checkout passes through the **same** predicate — its common directory is its own `.git`, so `wl2_canon` is itself and the basename test still holds. No separate branch is needed for it.

An unrelated repository named `ai-resources` would pass, exactly as it does today. The trust boundary is therefore unchanged in width; only the *anchor* moves, from "this directory is named `ai-resources`" to "this checkout shares a Git common directory with a checkout named `ai-resources`".

Repositories using `--separate-git-dir`, and bare repositories, are rejected because their common directory does not end in `/.git`. That is conservative and intentional.

### 3.5 Prose to update inside the marked block

The block's opening paragraph says "then direct use from `ai-resources`". Change to "then direct use from any checkout of the `ai-resources` repository, including a linked worktree". One sentence; keeps the prose honest about what the code now does.

### 3.6 Mirroring

Apply the identical edited block to both files. The block is delimited by `<!-- work-loop-v2-core-resolution:start -->` and `<!-- work-loop-v2-core-resolution:end -->`. Edit one, then copy the marked region into the other — do not retype it.

## 4. The test script

**Path:** `logs/scripts/work-loop-v2-core-resolver.test.sh`
**Convention:** follows `logs/scripts/*.test.sh` house style — header comment stating what each run asserts, `set -uo pipefail`, exit 0 only when every assertion passes.

**Setup.** Extract the bash from the marked block of `.claude/commands/work-loop-v2.md` into a temp script: take the region between the two markers, then the region between the ` ```bash ` fence and its closing fence. Everything runs against that extracted script, so the test exercises the deployed text rather than a copy.

**Fixtures.** All under one `mktemp -d`, removed by a `trap` on exit. The linked worktree is created with `git worktree add --detach "$TMP/wl2-fixture-eval" HEAD` and removed with `git worktree remove --force`.

| # | Check | Fixture | Expect |
|---|---|---|---|
| 1 | Worktree red case turns green | linked worktree `$TMP/wl2-fixture-eval` | exit 0, prints `$TMP/wl2-fixture-eval/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` |
| 2 | Canonical control stays green | repo root | exit 0, prints the canonical core path |
| 3 | Unrelated-repo negative control | `$TMP/ai-resources-eval`, fresh `git init`, core file copied to the same relative path | nonzero exit, no path on stdout, stderr contains `direct_identity=untrusted` |
| 4 | Mirror parity | both deployed files | marker regions byte-identical (`cmp`) |

Check 1 asserts the worktree's **own** path, not the canonical one. That is what proves branch locality: a task in a worktree must read that worktree's core.

Check 3 covers both the negative control and the diagnostic improvement in one run.

## 5. Execution order for the next session

1. Write `logs/scripts/work-loop-v2-core-resolver.test.sh`.
2. **Run it before any edit. It must fail on check 1.** Paste the failing output into § 8 of this file. A test that has never failed is not evidence — the same rule the Slice 1 harness states in its header.
3. Apply § 3 to `.claude/commands/work-loop-v2.md`.
4. Copy the marked region into `.agents/skills/work-loop-v2/SKILL.md`.
5. Run the test. All four checks must pass.
6. Record the passing output in § 8.
7. One Codex review of the diff — an ordinary change to a load-bearing resolver, so one review, not risk-aware.
8. Commit: `fix: work-loop-v2 core resolver — trust Git repository identity, not checkout name`.

Steps 1–6 are one continuous unit. Do not commit between the red run and the green run.

## 6. Risks

| Risk | Handling |
|---|---|
| `git worktree add` fails in the test environment | Test exits 2 with a clear message and does not report a false pass |
| Stale worktree left behind if the test is interrupted | `trap` cleanup plus `git worktree prune` at test start |
| The two copies drift during the edit | Step 4 copies rather than retypes; check 4 catches it anyway |
| Some other checkout layout regresses | Not covered at level B — see § 7. Canonical and worktree cases are covered |

## 7. Stated coverage gap

Level B does not test: the workspace root layout, `WORKSPACE/projects/<one-child>`, a worktree created under a different parent with an arbitrary name, the file guards (missing / unreadable / symlinked / escaping), or the full diagnostic discrimination matrix. These are report checks 3, 4, 6 and 7.

The workspace branches are untouched by this change, and the file guards are untouched by this change, so the risk is regression-by-accident rather than new behaviour going unverified. This is a stated gap, accepted by the operator on 2026-08-09, not an oversight. Raising to level C means adding those fixtures to the same script.

## 8. Evidence record — to be filled during execution

### Red run (before the edit)

> _paste output here_

### Green run (after the edit)

> _paste output here_

### Codex review verdict

> _paste verdict here_

## 9. What this unblocks

Planning `eval-mvp-proposal-v0.2.md` as a Work Loop task inside a linked worktree. That worktree no longer exists and is not recreated by this plan; recreating it is the follow-on task.

## 10. Deliberately not done

- Single-source generation of the mirrored block. Logged as a separate idea: the parity check detects drift but does not prevent it. A generator or a pre-commit hook would prevent it. That is a different change and deserves its own decision.
- A repository-identity marker file as an alternative to the common-directory test. Rejected here because it is a different trust model, not a fix for this defect.
