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
echo "=== OVERRIDE BINDING — an inert override must NOT open the door (added 2026-07-19, S5-dd5) ==="
# These assert on the OVERRIDE BRANCH, not on the exit code — and that distinction is the
# whole point of the block.
#
# Asserting exit 2 here would have been WRONG, and wrong in this harness's already-logged
# failure mode: whether a destructive command BLOCKS depends on ambient liveness (marker
# files in logs/, live processes), so an exit-code assertion would pass today and silently
# flip the day the markers are cleaned — green-by-vacuum, the exact rot recorded against
# $WT below. What is actually under test is narrower and environment-independent: did the
# guard treat this string as a genuine operator override? That is observable directly, in
# the OVERRIDE ACCEPTED line the override branch prints, and nowhere else.
#
# Both shapes WERE accepted as genuine overrides before the fix (reproduced by execution,
# 2026-07-19). The bug: a bare `re.search` on RAW `cmd`, which neither bound the flag to the
# destructive verb nor respected the quote-blanking that verb detection already uses.
#
# ⚠ Do NOT convert these to exit-code checks, and do NOT relax them to make a run go green.
#   If a negative case starts reporting ACCEPTED, the override check has been reverted to a
#   raw `cmd` search — read the "THE OVERRIDE MUST BE MATCHED ON `scan`" comment in the hook.
ovr() {
  desc="$1"; cmd="$2"; want="$3"   # want = yes|no  (should the override branch fire?)
  payload=$(python3 -c "
import json,sys
print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))
" "$cmd")
  out=$(printf '%s' "$payload" | bash "$H" 2>&1)
  if printf '%s' "$out" | grep -q "OVERRIDE ACCEPTED"; then got="yes"; else got="no"; fi
  if [ "$got" = "$want" ]; then
    st="PASS"; PASSN=$((PASSN+1))
  else
    st="**FAIL**"; FAILN=$((FAILN+1))
  fi
  printf '%-9s override=%-3s (want %-3s)  %s\n' "$st" "$got" "$want" "$desc"
}
ovr "CONTROL: genuine override binds to the verb" 'AXCION_LIVENESS_OVERRIDE=1 git reset --hard' yes
ovr "inert: bound to NOTE, not the verb"          'NOTE=AXCION_LIVENESS_OVERRIDE=1 git reset --hard' no
ovr "inert: only inside a quoted string"          'git commit -m "use AXCION_LIVENESS_OVERRIDE=1 to override" && git reset --hard' no
ovr "CONTROL: no override token at all"           'git reset --hard' no
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
