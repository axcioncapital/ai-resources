#!/bin/bash
# Test harness for check-destructive-liveness.sh
#
# ─────────────────────────────────────────────────────────────────────────────
# HERMETIC AS OF 2026-07-19 (S6-e72). READ THIS BEFORE EDITING.
#
# WHAT WAS WRONG BEFORE
#   The old harness pointed its LIVE-TARGET and -C cases at $WT — an EXTERNAL
#   worktree (ai-resources-research-workflow) that has since ceased to be an
#   occupied checkout. Those cases then reported FAIL for environmental reasons,
#   while other cases reported PASS for no reason at all. The file's own header
#   predicted exactly this ("green-by-vacuum — passing for the wrong reason").
#   Net effect: 12 PASS / 5 FAIL, and NEITHER number was trustworthy.
#
# WHAT MAKES IT HERMETIC NOW
#   The hook derives its whole world from two environment variables:
#       project_dir = CLAUDE_PROJECT_DIR or cwd   (:295)
#       session_id  = CLAUDE_CODE_SESSION_ID      (:300)
#   and repo_root from project_dir. So every case below runs with BOTH pinned at
#   a synthesized fixture under $TMP. Nothing reads the live repo, the live
#   worktree registry, or the live logs/ directory. Deleting $TMP is a complete
#   teardown.
#
#   $OCCUPIED is a REAL `git worktree add` of the fixture main repo — that is
#   what makes `git branch -d/-D` resolvable, since the hook resolves a branch
#   target via `git -C repo_root worktree list --porcelain` (:355). A plain
#   directory would NOT exercise that path.
#
# TWO PROPERTIES THAT LOOK LIKE STYLE AND ARE NOT
#   1. FIXTURE PATHS CONTAIN A SPACE, deliberately. The real deploy path is
#      ".../Claude Code/Axcion AI Repo/...", and a `\S+` in the -C group once made
#      the whole pattern fail to match, so the verb was never DETECTED and the
#      hook exited 0. A space-free fixture cannot catch that regression.
#   2. ONE occupied worktree has a space-free path ($OCCUPIED_NS) and is used for
#      the bare (unquoted) path case. Pointing the bare case at a spaced path
#      would exit 2 via FAIL-CLOSED (unresolvable target) rather than via
#      occupancy — a pass for the wrong reason, which is the disease this rewrite
#      exists to cure.
#
# ⚠ DO NOT re-point any case at a real external checkout. That is what rotted.
# ⚠ DO NOT adjust an expected value to make a run go green. Several old passes
#   were already fake; a green suite is what this defect LOOKS like.
# ─────────────────────────────────────────────────────────────────────────────

AIRES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"
HOOK="$AIRES/.claude/hooks/check-destructive-liveness.sh"
[ -f "$HOOK" ] || { echo "FATAL: hook not found at $HOOK"; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Space in the path is load-bearing — see header note 1.
BASE="$TMP/Axcion Fixture Space"
MAIN="$BASE/main-checkout"
OCCUPIED="$BASE/occupied worktree"        # spaced  → quoted + -C cases
OCCUPIED_NS="$TMP/occupied-nospace"       # unspaced → bare-path case
IDLE="$BASE/idle-repo"

FIX_SELF_ID="fixtureselfsession0001"
FIX_FOREIGN_ID="fixtureforeignsession9999"
LIVE_BRANCH="fixture/live-branch"
LIVE_BRANCH_NS="fixture/live-branch-ns"

mkdir -p "$MAIN" "$IDLE" "$OCCUPIED_NS"

# --- fixture main checkout: this is what the hook will treat as "self" ---
git -C "$MAIN" init -q
git -C "$MAIN" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init
mkdir -p "$MAIN/logs"
echo "2026-07-19 S1-fix" > "$MAIN/logs/.session-marker-${FIX_SELF_ID}"
echo "own uncommitted work" > "$MAIN/dirty-self.txt"

# --- occupied worktrees: real worktrees so `branch -d/-D` resolves (:355) ---
git -C "$MAIN" worktree add -q -b "$LIVE_BRANCH" "$OCCUPIED" >/dev/null 2>&1
git -C "$MAIN" worktree add -q -b "$LIVE_BRANCH_NS" "$OCCUPIED_NS" >/dev/null 2>&1
for occ in "$OCCUPIED" "$OCCUPIED_NS"; do
  mkdir -p "$occ/logs"
  echo "2026-07-18 S9-frn" > "$occ/logs/.session-marker-${FIX_FOREIGN_ID}"
  echo "foreign uncommitted work" > "$occ/uncommitted.txt"
done

# --- idle repo: clean, no markers, genuinely unoccupied ---
git -C "$IDLE" init -q
git -C "$IDLE" -c user.email=t@t -c user.name=t commit -q --allow-empty -m init

# Sanity: the fixture must actually BE what the cases assume. A fixture that
# silently failed to build would make every case pass for the wrong reason —
# the precise failure being fixed here.
FIXTURE_OK=1
[ -d "$OCCUPIED/.git" ] || [ -f "$OCCUPIED/.git" ] || FIXTURE_OK=0
[ -f "$OCCUPIED/logs/.session-marker-${FIX_FOREIGN_ID}" ] || FIXTURE_OK=0
git -C "$MAIN" worktree list --porcelain 2>/dev/null | grep -q "$LIVE_BRANCH" || FIXTURE_OK=0
if [ "$FIXTURE_OK" -ne 1 ]; then
  echo "FATAL: fixture did not build correctly — refusing to report results."
  echo "       (A silently-broken fixture is how a suite goes green-by-vacuum.)"
  exit 1
fi

PASSN=0; FAILN=0

# Run one case against a given hook copy, with the fixture world pinned.
# $4 (optional) overrides CLAUDE_PROJECT_DIR; $5 (optional) overrides session id.
run_against() {
  hook="$1"; cmd="$2"; expect="$3"
  pdir="${4:-$MAIN}"; sid="${5:-$FIX_SELF_ID}"
  payload=$(python3 -c "
import json,sys
print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))
" "$cmd")
  printf '%s' "$payload" | \
    CLAUDE_PROJECT_DIR="$pdir" CLAUDE_CODE_SESSION_ID="$sid" \
    bash "$hook" >/dev/null 2>&1
  echo $?
}

run() {
  desc="$1"; cmd="$2"; expect="$3"; pdir="${4:-$MAIN}"; sid="${5:-$FIX_SELF_ID}"
  rc=$(run_against "$HOOK" "$cmd" "$expect" "$pdir" "$sid")
  if [ "$rc" -eq "$expect" ]; then st="PASS"; PASSN=$((PASSN+1))
  else st="**FAIL**"; FAILN=$((FAILN+1)); fi
  printf '%-9s exit=%s (want %s)  %s\n' "$st" "$rc" "$expect" "$desc"
}

echo "=== NEGATIVE — must NOT gate (exit 0) ==="
run "plain git status"                    'git status --short'                          0
run "mention, not invocation"             'echo git clean -f'                           0
run "quoted verb in commit message"       'git commit -m "revert the git reset --hard"' 0
run "heredoc body naming the verb"        'cat >> f <<EOF
git worktree remove /x
EOF'                                                                                    0
run "branch not checked out anywhere"     'git branch -D no-such-branch-xyz'            0
run "git clean WITHOUT -f (dry run)"      'git clean -n'                                0
echo ""
echo "=== OVERRIDE BINDING — an inert override must NOT open the door ==="
# These assert on the OVERRIDE BRANCH, not on the exit code — and that distinction is the
# whole point of the block.
#
# Asserting exit 2 here would be WRONG, in this harness's already-logged failure mode:
# whether a destructive command BLOCKS depends on target occupancy, so an exit-code
# assertion could pass today and flip tomorrow. What is under test is narrower and
# environment-independent: did the guard treat this string as a genuine operator override?
# That is observable in the OVERRIDE ACCEPTED line and nowhere else.
#
# ⚠ Do NOT convert these to exit-code checks, and do NOT relax them to make a run go green.
#   If a negative case starts reporting ACCEPTED, the override check has been reverted to a
#   raw `cmd` search — read the "THE OVERRIDE MUST BE MATCHED ON `scan`" comment in the hook.
ovr_against() {
  hook="$1"; cmd="$2"
  payload=$(python3 -c "
import json,sys
print(json.dumps({'tool_name':'Bash','tool_input':{'command':sys.argv[1]}}))
" "$cmd")
  out=$(printf '%s' "$payload" | \
        CLAUDE_PROJECT_DIR="$MAIN" CLAUDE_CODE_SESSION_ID="$FIX_SELF_ID" \
        bash "$hook" 2>&1)
  if printf '%s' "$out" | grep -q "OVERRIDE ACCEPTED"; then echo "yes"; else echo "no"; fi
}
ovr() {
  desc="$1"; cmd="$2"; want="$3"
  got=$(ovr_against "$HOOK" "$cmd")
  if [ "$got" = "$want" ]; then st="PASS"; PASSN=$((PASSN+1))
  else st="**FAIL**"; FAILN=$((FAILN+1)); fi
  printf '%-9s override=%-3s (want %-3s)  %s\n' "$st" "$got" "$want" "$desc"
}
ovr "CONTROL: genuine override binds to the verb" 'AXCION_LIVENESS_OVERRIDE=1 git reset --hard' yes
ovr "inert: bound to NOTE, not the verb"          'NOTE=AXCION_LIVENESS_OVERRIDE=1 git reset --hard' no
ovr "inert: only inside a quoted string"          'git commit -m "use AXCION_LIVENESS_OVERRIDE=1 to override" && git reset --hard' no
ovr "CONTROL: no override token at all"           'git reset --hard' no
echo ""
echo "=== SELF-TARGET — own tree, own marker excluded (exit 0) ==="
# Hermetic: $MAIN holds exactly ONE marker, this session's own, so self-exclusion
# is what is under test — not the ambient contents of the live logs/ directory.
run "reset --hard on own checkout"        'git reset --hard'                            0
run "clean -fd on own checkout"           'git clean -fd'                               0
echo ""
echo "=== SELF-TARGET + FOREIGN MARKER — must BLOCK (exit 2) ==="
# NEW 2026-07-19. The old suite had no case here, so "self-target always exits 0"
# would have passed it completely. This is the discriminating pair to the two cases
# above: same command, same checkout, one extra foreign marker — opposite outcome.
# Without it, self-exclusion cannot be distinguished from blanket permissiveness.
echo "2026-07-18 S9-frn" > "$MAIN/logs/.session-marker-${FIX_FOREIGN_ID}"
run "reset --hard, foreign session present" 'git reset --hard'                          2
run "clean -fd, foreign session present"    'git clean -fd'                             2
rm -f "$MAIN/logs/.session-marker-${FIX_FOREIGN_ID}"
echo ""
echo "=== IDLE TARGET — clean, unoccupied, cold (exit 0) ==="
run "worktree remove <idle clean repo>"   "git worktree remove '$IDLE'"                 0
echo ""
echo "=== LIVE TARGET — occupied checkout (must BLOCK, exit 2) ==="
run "worktree remove QUOTED spaced path"  "git worktree remove '$OCCUPIED'"             2
run "worktree remove --force QUOTED"      "git worktree remove --force '$OCCUPIED'"     2
run "worktree remove BARE unspaced path"  "git worktree remove $OCCUPIED_NS"            2
run "branch -D of a live branch"          "git branch -D $LIVE_BRANCH"                  2
run "branch -d of a live branch"          "git branch -d $LIVE_BRANCH"                  2
echo ""
echo "=== -C FORM — the hole the first harness MISSED (must BLOCK, exit 2) ==="
# The `-C <repo>` prefix takes a path too, and in this workspace that path ALWAYS
# contains spaces. A `\S+` in the -C group made the whole pattern fail to match, so
# the verb was never DETECTED and the hook exited 0. Same space-bug as the target
# argument, one argument to the left. Found by System Owner review, not by this
# harness — the lesson being that a harness only tests what you thought of.
run "-C spaced-quoted + worktree remove"  "git -C '$MAIN' worktree remove '$OCCUPIED'"  2
run "-C spaced-double-quoted + branch -D" "git -C \"$MAIN\" branch -D $LIVE_BRANCH"     2
echo ""
echo "=== FAIL-CLOSED — verb detected, target unresolvable (must BLOCK, exit 2) ==="
# A detected destructive verb whose target cannot be resolved means the guard is
# CONFUSED, not idle. Degrading open here is how the -C hole stayed invisible.
run "worktree remove <nonexistent path>"  'git worktree remove /no/such/worktree/anywhere' 2

# ─────────────────────────────────────────────────────────────────────────────
# FALSIFICATION GATE — the part that makes the numbers above mean anything.
#
# A suite that cannot fail is worth nothing, and THIS suite has shipped two
# can-never-fail drafts in two sessions (an argv-vs-stdin harness where all five
# cases returned 0 including both controls; and an exit-code assertion that would
# have rotted into green-by-vacuum). So the suite is now run against deliberately
# BROKEN copies of the hook, and every case must FAIL against the mutant that
# targets its property. A case that still passes against a broken hook is inert
# and must be rewritten — never accepted.
#
#   MUTANT A (never blocks): every sys.exit(2) -> sys.exit(0).
#            All exit-2 cases MUST fail against it.
#   MUTANT B (always blocks): every sys.exit(0) -> sys.exit(2).
#            All exit-0 cases MUST fail against it.
#   MUTANT C (override reverted): replace the whole override computation with the
#            pre-2026-07-19 defect exactly as the hook's own comment records it —
#            "a bare re.search on RAW cmd, which neither bound the flag to the
#            destructive verb nor respected the quote-blanking." Both inert-override
#            cases MUST report ACCEPTED against it.
#
#            ⚠ The first draft of this mutant sed'd `re.search(RE_OVR_X, scan)` — a
#            form that does not exist in the hook (the real code is `re.search(p, scan)`
#            inside a generator at :236-237). The sed matched nothing, so MUTANT C was a
#            BYTE-IDENTICAL COPY and both cases reported INERT. The gate caught it, which
#            is the whole reason this block exists: a mutant that fails to mutate is
#            indistinguishable from an assertion that cannot fail, and only running it
#            tells you which one you have. Verify a mutant DIFFERS from the original
#            before trusting its verdict — this harness now does that mechanically below.
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo "FALSIFICATION GATE — every case must FAIL against a broken hook"
echo "=============================================="

MUT_A="$TMP/mutant-never-block.sh"
MUT_B="$TMP/mutant-always-block.sh"
MUT_C="$TMP/mutant-override-raw.sh"
sed 's/sys\.exit(2)/sys.exit(0)/g' "$HOOK" > "$MUT_A"
sed 's/sys\.exit(0)/sys.exit(2)/g' "$HOOK" > "$MUT_B"
# Revert the override to the pre-2026-07-19 defect: a bare token search on RAW `cmd`,
# which neither binds to the verb nor respects quote-blanking. Replaces the two-line
# `override = any(re.search(p, scan) for p in (...))` expression at :236-237.
python3 - "$HOOK" "$MUT_C" <<'PYEOF'
import re, sys
src = open(sys.argv[1]).read()
new, n = re.subn(
    r"override = any\(re\.search\(p, scan\) for p in\s*\n\s*\([^)]*\)\)",
    "override = ('AXCION_LIVENESS_OVERRIDE=1' in cmd)",
    src)
if n != 1:
    sys.stderr.write("MUTANT C: expected exactly 1 substitution, made %d\n" % n)
    sys.exit(1)
open(sys.argv[2], "w").write(new)
PYEOF
if [ $? -ne 0 ]; then
  echo "FATAL: could not build MUTANT C — the override expression has moved."
  echo "       Refusing to report a falsification result built on a mutant that may not mutate."
  exit 1
fi

# A mutant that does not DIFFER from the original proves nothing. Verify each one
# actually changed the file before any verdict is read off it. (This check is the
# direct product of the first draft's failure — see the MUTANT C note above.)
for m in "$MUT_A" "$MUT_B" "$MUT_C"; do
  if cmp -s "$HOOK" "$m"; then
    echo "FATAL: mutant $(basename "$m") is byte-identical to the hook — it cannot falsify anything."
    exit 1
  fi
done

FALSIFIED=0; INERT=0
expect_fail() {
  desc="$1"; hook="$2"; cmd="$3"; expect="$4"; pdir="${5:-$MAIN}"; sid="${6:-$FIX_SELF_ID}"
  rc=$(run_against "$hook" "$cmd" "$expect" "$pdir" "$sid")
  if [ "$rc" -ne "$expect" ]; then
    printf 'falsified  %s\n' "$desc"; FALSIFIED=$((FALSIFIED+1))
  else
    printf '**INERT**  %s  (still passed against a broken hook)\n' "$desc"; INERT=$((INERT+1))
  fi
}

echo "-- MUTANT A (never blocks): every blocking case must stop blocking --"
expect_fail "worktree remove QUOTED spaced"  "$MUT_A" "git worktree remove '$OCCUPIED'"           2
expect_fail "worktree remove --force"        "$MUT_A" "git worktree remove --force '$OCCUPIED'"   2
expect_fail "worktree remove BARE unspaced"  "$MUT_A" "git worktree remove $OCCUPIED_NS"          2
expect_fail "branch -D live branch"          "$MUT_A" "git branch -D $LIVE_BRANCH"                2
expect_fail "branch -d live branch"          "$MUT_A" "git branch -d $LIVE_BRANCH"                2
expect_fail "-C spaced + worktree remove"    "$MUT_A" "git -C '$MAIN' worktree remove '$OCCUPIED'" 2
expect_fail "-C spaced + branch -D"          "$MUT_A" "git -C \"$MAIN\" branch -D $LIVE_BRANCH"   2
expect_fail "fail-closed unresolvable"       "$MUT_A" 'git worktree remove /no/such/worktree/anywhere' 2

echo "-- MUTANT A: self-target + foreign marker must stop blocking --"
echo "2026-07-18 S9-frn" > "$MAIN/logs/.session-marker-${FIX_FOREIGN_ID}"
expect_fail "reset --hard w/ foreign marker" "$MUT_A" 'git reset --hard'                          2
expect_fail "clean -fd w/ foreign marker"    "$MUT_A" 'git clean -fd'                             2
rm -f "$MAIN/logs/.session-marker-${FIX_FOREIGN_ID}"

echo "-- MUTANT B (always blocks): every non-blocking case must start blocking --"
expect_fail "plain git status"               "$MUT_B" 'git status --short'                        0
expect_fail "mention, not invocation"        "$MUT_B" 'echo git clean -f'                         0
expect_fail "quoted verb in commit message"  "$MUT_B" 'git commit -m "revert the git reset --hard"' 0
expect_fail "branch not checked out"         "$MUT_B" 'git branch -D no-such-branch-xyz'          0
expect_fail "git clean without -f"           "$MUT_B" 'git clean -n'                              0
expect_fail "reset --hard on own checkout"   "$MUT_B" 'git reset --hard'                          0
expect_fail "clean -fd on own checkout"      "$MUT_B" 'git clean -fd'                             0
expect_fail "worktree remove idle repo"      "$MUT_B" "git worktree remove '$IDLE'"               0

echo "-- MUTANT C (override reverted to raw cmd): inert overrides must be ACCEPTED --"
for pair in "bound to NOTE|NOTE=AXCION_LIVENESS_OVERRIDE=1 git reset --hard" \
            "inside a quoted string|git commit -m \"use AXCION_LIVENESS_OVERRIDE=1 to override\" && git reset --hard"; do
  d="${pair%%|*}"; c="${pair#*|}"
  got=$(ovr_against "$MUT_C" "$c")
  if [ "$got" = "yes" ]; then
    printf 'falsified  inert override (%s) — broken hook ACCEPTED it\n' "$d"; FALSIFIED=$((FALSIFIED+1))
  else
    printf '**INERT**  inert override (%s) — broken hook still rejected it\n' "$d"; INERT=$((INERT+1))
  fi
done

echo ""
echo "──────────────────────────────"
echo "CORRECTNESS   PASS: $PASSN   FAIL: $FAILN"
echo "FALSIFICATION falsified: $FALSIFIED   INERT: $INERT"
echo "──────────────────────────────"
if [ "$FAILN" -eq 0 ] && [ "$INERT" -eq 0 ]; then
  echo "ALL GREEN — and every case is proven capable of failing."
else
  [ "$FAILN" -gt 0 ] && echo "RED — do not ship (correctness failures)."
  [ "$INERT" -gt 0 ] && echo "RED — do not ship ($INERT case(s) cannot fail; they verify nothing)."
fi
