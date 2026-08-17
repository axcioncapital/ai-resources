# Resolving the executable core

**Read this when the Work Loop owns the move, and during `$reorient` recovery.** It is the
complete marker-bounded resolver and its terminal failure contract, and it is the one owner of
both. The block between the two markers is byte-identical to the block in the Claude command
`.claude/commands/work-loop-v2.md`; `logs/scripts/work-loop-v2-core-resolver.test.sh` check 4
compares them and fails on any drift. Change it in both places or in neither.

**Contents**
- Resolve the executable core — the marker-bounded Bash resolver
- What to do with what it prints, and why a nonzero exit is terminal

<!-- work-loop-v2-core-resolution:start -->
### Resolve the executable core

Resolve the complete semantic-file path, never an `ai-resources/` directory. Two layouts are valid in
order: the canonical repository inside the verified workspace, then direct use from any checkout —
including a linked worktree — that shares a Git object store with a main checkout named
`ai-resources`. That is a shared-store plus name test, not a cryptographic repository identity: both
halves are load-bearing and neither may be dropped as redundant. The boundary is the current Git
repository plus, only at `WORKSPACE/projects/<one-child>`, that verified workspace Git repository.
Never walk higher. Run this exact Bash resolver in one call:

```bash
wl2_semantic_rel='plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md'
# No Bash positional parameters in this block — the slash-command expander owns those tokens
# and rewrites them at invocation. Each function reads its input from the wl2_*_in variable
# its caller sets on the line before the call.
wl2_git_top() {
  local wl2_top
  wl2_top="$(git -C "$wl2_top_in" rev-parse --show-toplevel 2>/dev/null)" || return 1
  (cd "$wl2_top" && pwd -P)
}
wl2_is_workspace() {
  [ -d "$wl2_ws_in/projects" ] && [ -d "$wl2_ws_in/ai-resources" ] || return 1
  wl2_top_in="$wl2_ws_in"
  [ "$(wl2_git_top)" = "$wl2_ws_in" ] || return 1
  wl2_top_in="$wl2_ws_in/ai-resources"
  [ "$(wl2_git_top)" = "$wl2_ws_in/ai-resources" ]
}
wl2_git_common() {
  local wl2_c
  wl2_c="$(git -C "$wl2_common_in" rev-parse --git-common-dir 2>/dev/null)" || return 1
  case "$wl2_c" in /*) ;; *) wl2_c="$wl2_common_in/$wl2_c" ;; esac
  [ -d "$wl2_c" ] || return 1
  (cd "$wl2_c" && pwd -P)
}
wl2_is_trusted_repo() {
  local wl2_common wl2_canon wl2_canon_top
  wl2_common_in="$wl2_trust_in"
  wl2_common="$(wl2_git_common)" || return 1
  case "$wl2_common" in */.git) ;; *) return 1 ;; esac
  wl2_canon="${wl2_common%/.git}"
  # Load-bearing: the shared store proves same-repo, the name proves which repo. Do not drop.
  [ "$(basename "$wl2_canon")" = 'ai-resources' ] || return 1
  wl2_top_in="$wl2_canon"
  wl2_canon_top="$(wl2_git_top)" || return 1
  [ "$wl2_canon_top" = "$wl2_canon" ] || return 1
  wl2_common_in="$wl2_canon"
  [ "$(wl2_git_common)" = "$wl2_common" ]
}
wl2_top_in="$(pwd -P)"
wl2_repo_root="$(wl2_git_top)" ||
  { echo 'ERROR: Work Loop v2 cannot resolve its repository boundary.' >&2; exit 1; }
wl2_workspace_root=''
wl2_ws_in="$wl2_repo_root"
if wl2_is_workspace; then
  wl2_workspace_root="$wl2_repo_root"
else
  wl2_projects_dir="$(dirname "$wl2_repo_root")"
  wl2_workspace_candidate="$(dirname "$wl2_projects_dir")"
  wl2_ws_in="$wl2_workspace_candidate"
  if [ "$(basename "$wl2_projects_dir")" = 'projects' ] &&
     wl2_is_workspace; then
    wl2_workspace_root="$wl2_workspace_candidate"
  fi
fi
wl2_semantic_path=''
wl2_attempted=''
wl2_try_semantic() {
  local wl2_dir
  wl2_attempted="${wl2_attempted}${wl2_attempted:+; }$wl2_cand_in"
  [ -f "$wl2_cand_in" ] && [ -r "$wl2_cand_in" ] && [ ! -L "$wl2_cand_in" ] || return 1
  wl2_dir="$(cd "$(dirname "$wl2_cand_in")" && pwd -P)" || return 1
  case "$wl2_dir/" in "$wl2_root_in/"*) ;; *) return 1 ;; esac
  wl2_semantic_path="$wl2_dir/$(basename "$wl2_cand_in")"
}
wl2_workspace_path=''
if [ -n "$wl2_workspace_root" ]; then
  wl2_workspace_path="$wl2_workspace_root/ai-resources/$wl2_semantic_rel"
  wl2_cand_in="$wl2_workspace_path"
  wl2_root_in="$wl2_workspace_root/ai-resources"
  wl2_try_semantic || true
fi
wl2_direct_path="$wl2_repo_root/$wl2_semantic_rel"
wl2_direct_reason=''
if [ -z "$wl2_semantic_path" ] && [ "$wl2_direct_path" != "$wl2_workspace_path" ]; then
  wl2_trust_in="$wl2_repo_root"
  if wl2_is_trusted_repo; then
    wl2_cand_in="$wl2_direct_path"
    wl2_root_in="$wl2_repo_root"
    wl2_try_semantic || true
  else
    wl2_direct_reason='direct_identity=untrusted'
  fi
fi
if [ -z "$wl2_semantic_path" ]; then
  printf 'ERROR: Work Loop v2 semantic source not found within permitted boundary. repo=%s workspace=%s attempted=%s%s\n' \
    "$wl2_repo_root" "${wl2_workspace_root:-none}" "${wl2_attempted:-none}" \
    "${wl2_direct_reason:+ $wl2_direct_reason}" >&2
  exit 1
fi
printf '%s\n' "$wl2_semantic_path"
```

Read exactly the printed file. A nonzero exit is terminal: report it and stop without a relative-path
fallback. The file is the contract for roles, unit cycle, state, vocabulary, safety, and stopping.
Where this resource and the core disagree, the core wins; report the disagreement as a defect.
<!-- work-loop-v2-core-resolution:end -->
