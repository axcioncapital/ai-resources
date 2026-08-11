#!/bin/bash
# T1-T13 — the R2 acceptance matrix for concurrent task isolation.
#
# R2 is "the checkout declares its writer": one gitignored per-checkout
# declaration at logs/work-loop/.owner, plus two repository-scoped dispatcher
# locks located through the Git common directory. This harness is the durable
# regression coverage for both halves.
#
# WHAT IS REAL HERE. Real git repositories, real linked worktrees, real lock
# directories, the real dispatch.sh, and the real ownership helper. Actors are
# stubbed via --actor-cmd — that is the model boundary the brief permits, and a
# stubbed actor can never prove live transport. Real networked Claude/Codex
# fan-out is the operator's post-integration validation, not this file's claim.
#
# Case 0 is the harness's own falsifiability proof: it points the suite at an
# ABSENT helper and asserts the suite fails. A harness that stays green with the
# thing under test removed is not evidence (core § 6 rule 5).
#
# Usage:  bash logs/scripts/work-loop-owner.test.sh
#         OWNER_BIN=/path/to/work-loop-owner.sh bash ...

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"   # logs/scripts -> logs -> checkout root
OWNER_BIN="${OWNER_BIN:-$HERE/work-loop-owner.sh}"
DISPATCH_BIN="${DISPATCH_BIN:-$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh}"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-owner-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

expect_rc() { # want got label [detail]
  if [ "$2" -eq "$1" ]; then ok "$3"; else bad "$3" "expected exit $1, got $2 — ${4:-}"; fi
}

# The verdict must be readable as well as exit-coded: a refusal that does not
# name the conflicting task or checkout is the failure mode R2 exists to remove.
expect_names() { # haystack needle label
  case "$1" in
    *"$2"*) ok "$3" ;;
    *)      bad "$3" "output does not name '$2' — got: $(printf '%s' "$1" | tr '\n' ' ')" ;;
  esac
}

# ---------------------------------------------------------------- fixtures

OWNER_REL='logs/work-loop/.owner'

# The sandbox's .gitignore is COPIED FROM THE REAL REPOSITORY, never authored
# here. T12 is a claim about this repository's ignore rule, and a harness that
# wrote its own rule would pass for a rule the repository does not have.
new_repo() { # -> path on stdout
  local d
  d="$(mktemp -d "$SANDBOX_ROOT/repo.XXXXXX")"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts" \
           "$d/plans/work-loop-v2-v0.2/handoff-automation-spike"
  git -C "$d" init -q
  git -C "$d" symbolic-ref HEAD refs/heads/main
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name  harness
  cp "$REPO_ROOT/.gitignore" "$d/.gitignore"
  printf 'sandbox\n' >"$d/README.md"
  # The helper ships inside a real checkout, so the fixture carries it too —
  # tracked, not dropped in loose, or the dispatcher would correctly read it as
  # an out-of-allowlist foreign file.
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh" 2>/dev/null || true
  git -C "$d" add .gitignore README.md logs/scripts 2>/dev/null
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  # -P: on macOS $TMPDIR is a symlink, and the helper reports canonical paths.
  # Comparing an uncanonicalised fixture path against them would fail on the
  # symlink rather than on the behaviour.
  (cd "$d" && pwd -P)
}

# Separate assignments, not one `local a=$1 b=$a`: bash expands every word of a
# `local` before assigning any of them, so the second would read an unset name.
add_worktree() { # repo name -> path on stdout
  local repo="$1"
  local name="$2"
  local p="$SANDBOX_ROOT/wt-$name-$$-$RANDOM"
  git -C "$repo" worktree add -q "$p" -b "$name" main >/dev/null 2>&1
  [ -d "$p" ] || { printf 'HARNESS ERROR: worktree %s was not created\n' "$name" >&2; exit 2; }
  mkdir -p "$p/logs/work-loop"
  (cd "$p" && pwd -P)
}

state_file() { # checkout task turn
  cat >"$1/logs/work-loop/$2.md" <<EOF
---
task: $2
turn: $3
---

## Objective and scope
Harness fixture. No real work.

## Lane and unit
Standard. Implementation mode. Unit 1 — harness fixture.

## Latest result
Not started.

## Blocker
None.

## Next action
Harness fixture. Nothing real depends on this file.
EOF
}

commit_state() { # checkout task
  git -C "$1" add "logs/work-loop/$2.md" >/dev/null 2>&1
  git -C "$1" commit -qm "fixture: $2" >/dev/null 2>&1
}

marker() { # checkout -> contents on stdout, empty if absent
  cat "$1/$OWNER_REL" 2>/dev/null || true
}

owner() { # ...args -> writes $OUT, sets $RC
  OUT="$(bash "$OWNER_BIN" "$@" 2>&1)"; RC=$?
}

# A PATH shim whose `git` refuses and records every invocation. This is how T6
# proves "no Git run by the writer" as a measurement rather than a claim: if the
# writer shells out to git at all, the shim records it AND the call fails.
git_trap_dir() { # -> dir on stdout; $dir/calls accumulates invocations
  local d; d="$(mktemp -d "$SANDBOX_ROOT/gittrap.XXXXXX")"
  cat >"$d/git" <<EOF
#!/bin/sh
printf '%s\n' "\$*" >>"$d/calls"
echo "git was invoked by a writer that must not run git" >&2
exit 127
EOF
  chmod +x "$d/git"
  : >"$d/calls"
  printf '%s' "$d"
}

echo "=============================================================="
echo " R2 acceptance matrix — T1..T13"
echo " helper:     $OWNER_BIN"
echo " dispatcher: $DISPATCH_BIN"
echo "=============================================================="

# ================================================================== case 0
echo
echo "Case 0 — harness falsifiability (helper absent)"
ABSENT="$SANDBOX_ROOT/no-such-helper.sh"
OUT="$(bash "$ABSENT" check --checkout / --task x 2>&1)"; RC=$?
if [ "$RC" -eq 0 ]; then
  bad "the suite fails when the helper is absent" "an absent helper exited 0"
else
  ok "the suite fails when the helper is absent (exit $RC)"
fi

# ================================================================== T1
# Different-TMPDIR same-task/same-checkout dispatch exclusion.
# RED today: LOCK_DIR is "${TMPDIR:-/tmp}/work-loop-dispatch-<sha(checkout|task)>",
# so two callers with different TMPDIR roots never contend.
echo
echo "T1 — same task, same checkout, second dispatcher refused across different TMPDIR roots"
d="$(new_repo)"; state_file "$d" t1-task codex; commit_state "$d" t1-task
TA="$(mktemp -d "$SANDBOX_ROOT/tmpA.XXXXXX")"
TB="$(mktemp -d "$SANDBOX_ROOT/tmpB.XXXXXX")"

( TMPDIR="$TA" bash "$DISPATCH_BIN" --checkout "$d" --task t1-task \
    --log-dir "$d/runs" --timeout 30 --actor-cmd 'sleep 8; exit 0' >/dev/null 2>&1 ) &
holder=$!
sleep 2

# Control first: the SAME root must already be excluded today. A control that
# fails would mean the harness, not the defect, produced T1's red.
OUT="$(TMPDIR="$TA" bash "$DISPATCH_BIN" --checkout "$d" --task t1-task \
        --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "control — a shared TMPDIR root is refused (passes on the baseline)" "$OUT"

OUT="$(TMPDIR="$TB" bash "$DISPATCH_BIN" --checkout "$d" --task t1-task \
        --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "a DIFFERENT TMPDIR root is refused too" "$OUT"

wait "$holder" 2>/dev/null

# ================================================================== T2
# Same task in two worktrees refused, with the claiming checkout visible.
echo
echo "T2 — the same task in two worktrees is refused, and the claiming checkout is named"
d="$(new_repo)"
w1="$(add_worktree "$d" t2-one)"
w2="$(add_worktree "$d" t2-two)"
state_file "$w1" t2-task claude
owner claim --checkout "$w1" --task t2-task --depth repo
expect_rc 0 "$RC" "the first worktree claims the task" "$OUT"

owner check --checkout "$w2" --task t2-task --depth repo
expect_rc 3 "$RC" "the second worktree is REFUSED" "$OUT"
expect_names "$OUT" "$w1" "the refusal names the claiming checkout"

# ================================================================== T3
# Two tasks in one checkout refused, with the holding task visible.
echo
echo "T3 — a second task entering a claimed checkout is refused, and the holder is named"
d="$(new_repo)"
state_file "$d" t3-alpha claude
owner claim --checkout "$d" --task t3-alpha --depth local
expect_rc 0 "$RC" "alpha claims the checkout" "$OUT"

owner check --checkout "$d" --task t3-beta --depth local
expect_rc 3 "$RC" "beta is REFUSED in the same checkout" "$OUT"
expect_names "$OUT" "t3-alpha" "the refusal names the holding task"

# The dispatcher half of the same rule: two DIFFERENT tasks in one checkout must
# not run concurrently. RED today — the lock key includes the task, so two tasks
# in one checkout take two different locks and both proceed.
state_file "$d" t3-run-a codex; commit_state "$d" t3-run-a
state_file "$d" t3-run-b codex; commit_state "$d" t3-run-b
rm -f "$d/$OWNER_REL"
( bash "$DISPATCH_BIN" --checkout "$d" --task t3-run-a \
    --log-dir "$d/runs" --timeout 30 --actor-cmd 'sleep 8; exit 0' >/dev/null 2>&1 ) &
holder=$!
sleep 2
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task t3-run-b \
        --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "a second dispatcher on a DIFFERENT task in the same checkout is refused" "$OUT"
wait "$holder" 2>/dev/null

# ================================================================== T4
# Fan-out 2 in separate worktrees succeeds, with no cross-task paths in either
# candidate range.
echo
echo "T4 — fan-out 2 on separate worktrees completes with no cross-task paths"
d="$(new_repo)"
w1="$(add_worktree "$d" t4-one)"
w2="$(add_worktree "$d" t4-two)"
for w in "$w1" "$w2"; do
  mkdir -p "$w/plans/work-loop-v2-v0.2/handoff-automation-spike"
done
state_file "$w1" t4-alpha codex; commit_state "$w1" t4-alpha
state_file "$w2" t4-beta  codex; commit_state "$w2" t4-beta
printf 't4-alpha %s\n' "$(date '+%Y-%m-%d')" >"$w1/$OWNER_REL"
printf 't4-beta %s\n'  "$(date '+%Y-%m-%d')" >"$w2/$OWNER_REL"
BASE1="$(git -C "$w1" rev-parse HEAD)"
BASE2="$(git -C "$w2" rev-parse HEAD)"

TO_OP='awk "NR==3{print \"turn: operator\"; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
   mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE";
   if [ "$WL_ACTOR" = "claude" ]; then
     git -C "$WL_CHECKOUT" add "logs/work-loop/$WL_TASK.md" >/dev/null 2>&1;
     git -C "$WL_CHECKOUT" commit -qm "actor commit" >/dev/null 2>&1 || true; fi'

( bash "$DISPATCH_BIN" --checkout "$w1" --task t4-alpha --log-dir "$w1/runs" \
    --timeout 30 --actor-cmd "$TO_OP" >"$SANDBOX_ROOT/t4a.out" 2>&1 ) & p1=$!
( bash "$DISPATCH_BIN" --checkout "$w2" --task t4-beta  --log-dir "$w2/runs" \
    --timeout 30 --actor-cmd "$TO_OP" >"$SANDBOX_ROOT/t4b.out" 2>&1 ) & p2=$!
wait "$p1"; R1=$?
wait "$p2"; R2=$?
expect_rc 0 "$R1" "worktree 1 completes" "$(cat "$SANDBOX_ROOT/t4a.out")"
expect_rc 0 "$R2" "worktree 2 completes" "$(cat "$SANDBOX_ROOT/t4b.out")"

X1="$(git -C "$w1" diff --name-only "$BASE1"..HEAD 2>/dev/null)"
X2="$(git -C "$w2" diff --name-only "$BASE2"..HEAD 2>/dev/null)"
case "$X1" in *t4-beta*)  bad "worktree 1's candidate range has no cross-task path" "$X1" ;;
              *)          ok  "worktree 1's candidate range has no cross-task path" ;; esac
case "$X2" in *t4-alpha*) bad "worktree 2's candidate range has no cross-task path" "$X2" ;;
              *)          ok  "worktree 2's candidate range has no cross-task path" ;; esac

# ================================================================== T5
# A later handoff reuses the claimed checkout and creates no replacement binding.
echo
echo "T5 — a later handoff reuses the claimed checkout and creates no replacement binding"
d="$(new_repo)"
w1="$(add_worktree "$d" t5-one)"
state_file "$w1" t5-task claude
owner claim --checkout "$w1" --task t5-task --depth repo
expect_rc 0 "$RC" "the task claims its worktree" "$OUT"
BEFORE="$(marker "$w1")"
COUNT_BEFORE="$(git -C "$d" worktree list --porcelain | grep -c '^worktree ')"

owner check --checkout "$w1" --task t5-task --depth repo
expect_rc 0 "$RC" "the later handoff PROCEEDS in the same checkout" "$OUT"
AFTER="$(marker "$w1")"
COUNT_AFTER="$(git -C "$d" worktree list --porcelain | grep -c '^worktree ')"
[ "$BEFORE" = "$AFTER" ] && ok "the declaration is unchanged by the handoff" \
                         || bad "the declaration is unchanged by the handoff" "'$BEFORE' -> '$AFTER'"
[ "$COUNT_BEFORE" = "$COUNT_AFTER" ] && ok "no replacement worktree was created" \
                                     || bad "no replacement worktree was created" "$COUNT_BEFORE -> $COUNT_AFTER"
[ -f "$w1/logs/work-loop/t5-task.md" ] && ok "the single state file is still where it was" \
                                       || bad "the single state file is still where it was"

# ================================================================== T6
# Both pre-brief paths require .owner BEFORE the state file, with no git run by
# the writer.
echo
echo "T6 — the declaration precedes the state file on both lanes, and the writer runs no git"
# Lane A: ordinary Local.
d="$(new_repo)"
GT="$(git_trap_dir)"
OUT="$(PATH="$GT:$PATH" bash "$OWNER_BIN" claim --checkout "$d" --task t6-local --depth local 2>&1)"; RC=$?
expect_rc 0 "$RC" "Local lane — the pre-brief claim succeeds" "$OUT"
[ -s "$d/$OWNER_REL" ] && ok "Local lane — the declaration exists" \
                       || bad "Local lane — the declaration exists"
[ -f "$d/logs/work-loop/t6-local.md" ] && bad "Local lane — the claim did NOT create a state file" \
                                       || ok "Local lane — the claim did NOT create a state file"
[ -s "$GT/calls" ] && bad "Local lane — the writer ran no git" "git calls: $(tr '\n' ';' <"$GT/calls")" \
                   || ok "Local lane — the writer ran no git"

# Lane B: isolated worktree — same one sequence.
w1="$(add_worktree "$d" t6-iso)"
GT2="$(git_trap_dir)"
OUT="$(PATH="$GT2:$PATH" bash "$OWNER_BIN" claim --checkout "$w1" --task t6-iso --depth local 2>&1)"; RC=$?
expect_rc 0 "$RC" "isolated lane — the pre-brief claim succeeds" "$OUT"
[ -s "$w1/$OWNER_REL" ] && ok "isolated lane — the declaration exists" \
                        || bad "isolated lane — the declaration exists"
[ -s "$GT2/calls" ] && bad "isolated lane — the writer ran no git" "git calls: $(tr '\n' ';' <"$GT2/calls")" \
                    || ok "isolated lane — the writer ran no git"

# A state file created with NO declaration is the sequence the rule forbids, and
# the check must catch it rather than trusting the writer to have gone first.
d2="$(new_repo)"
state_file "$d2" t6-nodecl claude
owner check --checkout "$d2" --task t6-other --depth local
expect_rc 0 "$RC" "an unclaimed checkout does not block an unrelated first contact" "$OUT"
rm -f "$d2/$OWNER_REL"
printf 't6-ghost %s\n' "$(date '+%Y-%m-%d')" >"$d2/$OWNER_REL"
owner check --checkout "$d2" --task t6-ghost --depth local
expect_rc 3 "$RC" "a declaration with no matching local state file is REFUSED as a contradiction" "$OUT"

# ================================================================== T7
# A replicated task file cannot authorise a second checkout, and the check never
# copies, moves or recreates a state file.
echo
echo "T7 — a replicated state file authorises nobody, and the check moves no file"
d="$(new_repo)"
w1="$(add_worktree "$d" t7-one)"
w2="$(add_worktree "$d" t7-two)"
state_file "$w1" t7-task claude
state_file "$w2" t7-task claude
H1="$(shasum -a 256 "$w1/logs/work-loop/t7-task.md" | cut -d' ' -f1)"
H2="$(shasum -a 256 "$w2/logs/work-loop/t7-task.md" | cut -d' ' -f1)"
N1="$(ls -a "$w1/logs/work-loop" | wc -l | tr -d ' ')"

owner check --checkout "$w2" --task t7-task --depth repo
expect_rc 4 "$RC" "a replicated state file yields AMBIGUOUS, not authority" "$OUT"

A1="$(shasum -a 256 "$w1/logs/work-loop/t7-task.md" | cut -d' ' -f1)"
A2="$(shasum -a 256 "$w2/logs/work-loop/t7-task.md" | cut -d' ' -f1)"
M1="$(ls -a "$w1/logs/work-loop" | wc -l | tr -d ' ')"
[ "$H1" = "$A1" ] && [ "$H2" = "$A2" ] && ok "neither replica was modified" \
                                       || bad "neither replica was modified"
[ "$N1" = "$M1" ] && ok "no file was created or removed by the check" \
                  || bad "no file was created or removed by the check" "$N1 -> $M1"
[ -f "$w2/$OWNER_REL" ] && bad "the check claimed nothing" "a declaration appeared" \
                        || ok "the check claimed nothing"

# ================================================================== T8
# Ordinary serial Local work stays non-isolated, and the checkout is reusable
# after closure.
echo
echo "T8 — ordinary serial Local work is not isolated, and the checkout is reusable after closure"
d="$(new_repo)"
COUNT0="$(git -C "$d" worktree list --porcelain | grep -c '^worktree ')"
state_file "$d" t8-first claude
owner claim --checkout "$d" --task t8-first --depth local
expect_rc 0 "$RC" "the first serial task claims its own checkout" "$OUT"
COUNT1="$(git -C "$d" worktree list --porcelain | grep -c '^worktree ')"
[ "$COUNT0" = "$COUNT1" ] && ok "no worktree was created for ordinary serial work" \
                          || bad "no worktree was created for ordinary serial work" "$COUNT0 -> $COUNT1"

owner clear --checkout "$d" --task t8-first
expect_rc 0 "$RC" "closure clears the declaration" "$OUT"
[ -f "$d/$OWNER_REL" ] && bad "the declaration is gone after closure" "still present" \
                       || ok "the declaration is gone after closure"

state_file "$d" t8-second claude
owner claim --checkout "$d" --task t8-second --depth local
expect_rc 0 "$RC" "the next serial task reuses the same checkout" "$OUT"

# The stale-marker row of the safe state table: a marker naming a CLOSED local
# task may be cleared by the next task start in that same checkout.
d2="$(new_repo)"
state_file "$d2" t8-closed operator
printf 't8-closed %s\n' "$(date '+%Y-%m-%d')" >"$d2/$OWNER_REL"
owner claim --checkout "$d2" --task t8-next --depth local
expect_rc 0 "$RC" "a stale declaration for a CLOSED local task is cleared by the next start" "$OUT"
case "$(marker "$d2")" in
  t8-next*) ok "the declaration now names the new task" ;;
  *)        bad "the declaration now names the new task" "got: $(marker "$d2")" ;;
esac

# ================================================================== T9
# Missing marker plus a replicated state file is ambiguous everywhere and claims
# nowhere.
echo
echo "T9 — no declaration + a replicated state file is AMBIGUOUS in every checkout"
d="$(new_repo)"
w1="$(add_worktree "$d" t9-one)"
w2="$(add_worktree "$d" t9-two)"
state_file "$w1" t9-task claude
state_file "$w2" t9-task claude
for w in "$w1" "$w2"; do
  owner check --checkout "$w" --task t9-task --depth repo
  expect_rc 4 "$RC" "AMBIGUOUS in $(basename "$w")" "$OUT"
  [ -f "$w/$OWNER_REL" ] && bad "$(basename "$w") claimed nothing" "a declaration appeared" \
                         || ok "$(basename "$w") claimed nothing"
done

# The single-copy row is the contrast that makes T9 mean something: one copy IS
# decisive, and only in the checkout that holds it.
d="$(new_repo)"
w1="$(add_worktree "$d" t9-solo)"
w2="$(add_worktree "$d" t9-empty)"
state_file "$w1" t9-single claude
owner check --checkout "$w1" --task t9-single --depth repo
expect_rc 0 "$RC" "contrast — a UNIQUE copy may re-declare in its own checkout" "$OUT"
owner check --checkout "$w2" --task t9-single --depth repo
expect_rc 3 "$RC" "contrast — any other checkout is refused" "$OUT"
expect_names "$OUT" "$w1" "contrast — the refusal names the holding checkout"

# ================================================================== T10
# Migration / first contact cannot silently claim a replicated open task.
echo
echo "T10 — first contact cannot silently claim a replicated OPEN task"
d="$(new_repo)"
w1="$(add_worktree "$d" t10-one)"
w2="$(add_worktree "$d" t10-two)"
state_file "$w1" t10-open claude
state_file "$w2" t10-open claude
owner claim --checkout "$w1" --task t10-open --depth repo
expect_rc 4 "$RC" "an explicit CLAIM on a replicated open task is refused as AMBIGUOUS" "$OUT"
[ -f "$w1/$OWNER_REL" ] && bad "no declaration was written by the refused claim" "one appeared" \
                        || ok "no declaration was written by the refused claim"
[ -f "$w2/$OWNER_REL" ] && bad "the other checkout was left untouched" "one appeared" \
                        || ok "the other checkout was left untouched"

# ================================================================== T11
# A second interactive task is refused by Codex's local marker read alone.
echo
echo "T11 — a second interactive task is refused by the local read alone, with no git"
d="$(new_repo)"
state_file "$d" t11-held claude
printf 't11-held %s\n' "$(date '+%Y-%m-%d')" >"$d/$OWNER_REL"
GT="$(git_trap_dir)"
OUT="$(PATH="$GT:$PATH" bash "$OWNER_BIN" check --checkout "$d" --task t11-new --depth local 2>&1)"; RC=$?
expect_rc 3 "$RC" "the second interactive task is REFUSED" "$OUT"
expect_names "$OUT" "t11-held" "the refusal names the holding task"
[ -s "$GT/calls" ] && bad "the local read ran no git" "git calls: $(tr '\n' ';' <"$GT/calls")" \
                   || ok "the local read ran no git"
# The stated non-goal, asserted as a non-goal rather than smuggled in as a pass:
# the SAME task entered twice interactively is not prevented by anything here.
OUT="$(PATH="$GT:$PATH" bash "$OWNER_BIN" check --checkout "$d" --task t11-held --depth local 2>&1)"; RC=$?
expect_rc 0 "$RC" "NON-GOAL confirmed — the same task entering twice is NOT prevented" "$OUT"

# ================================================================== T12
# .owner is absent from status and commits with the ignore rule, and a
# meaningful control proves it would be visible without that rule.
echo
echo "T12 — the declaration is checkout-local: invisible to status and to commits"
# -uall, not the default: git collapses a wholly-untracked directory to
# "logs/" and would hide the file behind its parent rather than behind the rule.
d="$(new_repo)"
printf 't12-task %s\n' "$(date '+%Y-%m-%d')" >"$d/$OWNER_REL"
SEEN="$(git -C "$d" status --porcelain -uall -- logs/work-loop/ | grep -c '\.owner')"
[ "$SEEN" = "0" ] && ok "git status does not list the declaration" \
                  || bad "git status does not list the declaration" "matched $SEEN times"
git -C "$d" add -A >/dev/null 2>&1
git -C "$d" commit -qm "everything the tree offers" >/dev/null 2>&1
TRACKED="$(git -C "$d" ls-files | grep -c '\.owner')"
[ "$TRACKED" = "0" ] && ok "no commit contains the declaration" \
                     || bad "no commit contains the declaration" "tracked $TRACKED times"

# The control. Same file, same command, rule removed — it must become visible.
# Without this, T12 would pass just as well for a file that is not there.
d2="$(new_repo)"
: >"$d2/.gitignore"
git -C "$d2" add .gitignore >/dev/null 2>&1
git -C "$d2" commit -qm "control: no ignore rule" >/dev/null 2>&1
printf 't12-task %s\n' "$(date '+%Y-%m-%d')" >"$d2/$OWNER_REL"
CSEEN="$(git -C "$d2" status --porcelain -uall -- logs/work-loop/ | grep -c '\.owner')"
[ "$CSEEN" -ge 1 ] && ok "control — without the rule the declaration IS visible" \
                   || bad "control — without the rule the declaration IS visible" "matched $CSEEN times"

# ================================================================== T13
# Codex's narrowed check may admit a same-task claim elsewhere; the next Claude
# entry refuses it before any implementation commit.
echo
echo "T13 — the narrowed local read admits what the next Claude entry refuses"
d="$(new_repo)"
w1="$(add_worktree "$d" t13-one)"
w2="$(add_worktree "$d" t13-two)"
state_file "$w1" t13-task claude
owner claim --checkout "$w1" --task t13-task --depth repo
expect_rc 0 "$RC" "worktree 1 holds the task" "$OUT"

# Codex, standing in an unclaimed second checkout, sees nothing wrong locally.
owner check --checkout "$w2" --task t13-task --depth local
expect_rc 0 "$RC" "the narrowed local read ADMITS it — the stated limit, measured" "$OUT"

# Claude's entry, which may run git, refuses before anything is committed.
BEFORE_HEAD="$(git -C "$w2" rev-parse HEAD)"
owner check --checkout "$w2" --task t13-task --depth repo
expect_rc 3 "$RC" "the next Claude entry REFUSES it" "$OUT"
expect_names "$OUT" "$w1" "the refusal names the checkout that holds the task"
[ "$(git -C "$w2" rev-parse HEAD)" = "$BEFORE_HEAD" ] \
  && ok "no commit was made in the refused checkout" \
  || bad "no commit was made in the refused checkout"

# ================================================================== summary
echo
echo "=============================================================="
printf ' T1..T13: %d passed, %d failed\n' "$PASS" "$FAIL"
echo "=============================================================="
[ "$FAIL" -eq 0 ] || exit 1
