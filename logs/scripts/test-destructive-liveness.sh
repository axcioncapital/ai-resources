#!/bin/bash
# Test harness for check-destructive-liveness.sh
# Run from the ai-resources repo root.
AIRES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"
H="$AIRES/.claude/hooks/check-destructive-liveness.sh"
WT="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow"
cd "$AIRES" || exit 1

# NOTE: the LIVE-TARGET cases below depend on $WT actually being an occupied checkout
# (uncommitted work and/or an un-wrapped per-id session marker). If that worktree is ever
# cleaned up or wrapped, those cases will go GREEN-BY-VACUUM — passing for the wrong reason.
# Re-point $WT at a genuinely occupied checkout, or synthesize one, before trusting them.

TMP=$(mktemp -d)
IDLE="$TMP/idle-repo"
mkdir -p "$IDLE/logs"
git -C "$IDLE" init -q 2>/dev/null
git -C "$IDLE" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init 2>/dev/null

PASSN=0; FAILN=0

run() {
  desc="$1"; cmd="$2"; expect="$3"
  payload=$(python3 -c "
import json,sys
print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))
" "$cmd")
  printf '%s' "$payload" | bash "$H" >/dev/null 2>&1
  rc=$?
  if [ "$rc" -eq "$expect" ]; then
    st="PASS"; PASSN=$((PASSN+1))
  else
    st="**FAIL**"; FAILN=$((FAILN+1))
  fi
  printf '%-9s exit=%s (want %s)  %s\n' "$st" "$rc" "$expect" "$desc"
}

echo "=== NEGATIVE — must NOT gate (exit 0) ==="
run "plain git status"                    'git status --short'                                 0
run "mention, not invocation"             'echo git clean -f'                                  0
run "quoted verb in commit message"       'git commit -m "revert the git reset --hard"'        0
run "heredoc body naming the verb"        'cat >> f <<EOF
git worktree remove /x
EOF'                                                                                           0
run "branch not checked out anywhere"     'git branch -D no-such-branch-xyz'                   0
run "git clean WITHOUT -f (dry run)"      'git clean -n'                                       0
echo ""
echo "=== SELF-TARGET — own tree, own marker excluded (exit 0) ==="
run "reset --hard on own checkout"        'git reset --hard'                                   0
run "clean -fd on own checkout"           'git clean -fd'                                      0
echo ""
echo "=== IDLE TARGET — clean, unoccupied, cold (exit 0) ==="
run "worktree remove <idle clean repo>"   "git worktree remove '$IDLE'"                        0
echo ""
echo "=== LIVE TARGET — occupied checkout (must BLOCK, exit 2) ==="
run "worktree remove QUOTED path [bug-1]" "git worktree remove '$WT'"                          2
run "worktree remove bare path"           "git worktree remove $WT"                            2
run "worktree remove --force QUOTED"      "git worktree remove --force '$WT'"                  2
run "branch -D of the live branch"        'git branch -D session/2026-07-13-research-workflow' 2
run "branch -d of the live branch"        'git branch -d session/2026-07-13-research-workflow' 2
echo ""
echo "=== -C FORM — the hole the first harness MISSED (must BLOCK, exit 2) ==="
# The `-C <repo>` prefix takes a path too, and in this workspace that path ALWAYS contains
# spaces. A `\S+` in the -C group made the whole pattern fail to match, so the verb was never
# even DETECTED and the hook exited 0. Same space-bug as bug-1, one argument to the left;
# it survived the bug-1 fix precisely because no -C case existed here. Found by the System
# Owner review, not by this harness. THAT is the lesson: a harness only tests what you thought of.
run "-C spaced-quoted + worktree remove" "git -C '$AIRES' worktree remove '$WT'"               2
run "-C spaced-double-quoted + branch -D" "git -C \"$AIRES\" branch -D session/2026-07-13-research-workflow" 2
echo ""
echo "=== FAIL-CLOSED — verb detected, target unresolvable (must BLOCK, exit 2) ==="
# A detected destructive verb whose target cannot be resolved means the guard is CONFUSED,
# not idle. Degrading open here is how the -C hole stayed invisible: an unresolvable target
# looked exactly like an all-clear.
run "worktree remove <nonexistent path>"  'git worktree remove /no/such/worktree/anywhere'     2

rm -rf "$TMP"
echo ""
echo "──────────────────────────────"
echo "PASS: $PASSN   FAIL: $FAILN"
[ "$FAILN" -eq 0 ] && echo "ALL GREEN" || echo "RED — do not ship"
