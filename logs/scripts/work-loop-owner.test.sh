#!/bin/bash
# T1-T14 — the R2 acceptance matrix for concurrent task isolation, plus T14, the
#           Tracer 3 closure-order proof: valid closed state is committed before
#           the declaration is cleared, measured at both cut points.
# F1-F3   — the correction round's findings, kept as durable regression cover:
#           F1 an ownership check that cannot run must refuse, not pass;
#           F2 a malformed declaration is ambiguous, and survives;
#           F3 a contested claim on one free checkout is indivisible.
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
# The dispatcher now sources the shared lease library from the checkout it is
# pointed at, and fail-closes at exit 11 when it is absent. A fixture without it
# is not a representative checkout, so new_repo() packages it beside the owner
# helper. Resolved the same way OWNER_BIN is, and overridable for the same reason.
LEASE_BIN="${LEASE_BIN:-$HERE/work-loop-lease.sh}"
# The canonical state validator. Since the Tracer 3 cutover the owner helper asks
# it for every lifecycle answer instead of reading `turn:` itself, so a sandbox
# without it is a checkout where ownership cannot be established at all — the
# helper correctly refuses, and every assertion here would fail for the harness's
# missing file rather than for the behaviour under test.
STATE_BIN="${STATE_BIN:-$HERE/work-loop-state.sh}"

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
  cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh" 2>/dev/null || true
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh" 2>/dev/null || true
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

# Writes a record that satisfies the contract work-loop-state.sh enforces:
# explicit `status`, one of the four legal status/turn pairs, and the body shape
# that pair requires. Before the Tracer 3 cutover this wrote a status-free record
# with the OPEN body for every turn, `operator` included — which the validator
# rejects, and rightly: a closing record is not an open record with the turn
# changed. Status is derived from the turn unless the caller states it, so the
# blocked/operator pair has to be asked for explicitly.
state_file() { # checkout task turn [status]
  local co="$1" task="$2" turn="$3" status="${4:-}" blocker
  if [ -z "$status" ]; then
    case "$turn" in
      claude|codex) status=active ;;
      operator)     status=closed ;;
    esac
  fi

  if [ "$status" = closed ]; then
    cat >"$co/logs/work-loop/$task.md" <<EOF
---
task: $task
status: closed
turn: operator
---

## Outcome
Harness fixture. Closed record.

## Decisions that matter
Nothing real depends on this file.

## Evidence
Harness fixture — no commit.

## Accepted limitations
None.
EOF
    return 0
  fi

  blocker='None.'
  [ "$status" = blocked ] && blocker='Waiting on the operator to name the harness fixture owner.'

  cat >"$co/logs/work-loop/$task.md" <<EOF
---
task: $task
status: $status
turn: $turn
---

## Objective and scope
Harness fixture. No real work.

## Lane and unit
Standard. Implementation mode. Unit 1 — harness fixture.

## Latest result
Not started.

## Blocker
$blocker

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
printf 't4-alpha\n' >"$w1/$OWNER_REL"
printf 't4-beta\n' >"$w2/$OWNER_REL"
BASE1="$(git -C "$w1" rev-parse HEAD)"
BASE2="$(git -C "$w2" rev-parse HEAD)"

# CLOSING IS A WHOLE RECORD, NOT A LINE EDIT. This used to rewrite line 3 to
# `turn: operator` and call the task closed. Two things made that work, and the
# Tracer 3 cutover removed both: line 3 was the turn line, and `turn: operator`
# was by itself enough to mean closed. A record now carries an explicit `status:`
# — so line 3 is the status line, and the line edit would corrupt the very field
# the dispatcher validates — and closure is `status: closed` with the four
# closing headings and no active heading surviving. The fixture writes that
# record, which is also what a real closing actor writes.
TO_OP='{ printf "%s\n" "---" "task: $WL_TASK" "status: closed" "turn: operator" "---" "" \
     "## Outcome" "Harness fixture. Closed by the simulated actor." "" \
     "## Decisions that matter" "Nothing real depends on this file." "" \
     "## Evidence" "Harness fixture — this dispatcher run." "" \
     "## Accepted limitations" "None."; } > "$WL_STATE_FILE.tmp";
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
printf 't6-ghost\n' >"$d2/$OWNER_REL"
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
printf 't8-closed\n' >"$d2/$OWNER_REL"
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
printf 't11-held\n' >"$d/$OWNER_REL"
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
printf 't12-task\n' >"$d/$OWNER_REL"
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
printf 't12-task\n' >"$d2/$OWNER_REL"
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

# ================================================================== T14
# CLOSURE ORDER — valid closed state is committed BEFORE the declaration is
# cleared (Tracer 3). The order is the whole assertion, so it is measured by
# cutting the same closure at each of the two points it can fail.
#
# WHY THE ORDER IS NOT ARBITRARY. Clearing first leaves the one combination
# nothing recovers from: the lease is gone while the closure is still
# uncommitted, so the checkout looks free and the task is not closed, and the
# next task claims straight over it. The order below fails safe at both cuts.
echo
echo "T14 — closure commits valid closed state before it clears the declaration"

# (a) CLEAN — the prescribed order, end to end.
d="$(new_repo)"
state_file "$d" t14-task claude
commit_state "$d" t14-task
printf 't14-task\n' >"$d/$OWNER_REL"
state_file "$d" t14-task operator          # step 1: reduce to the closing record
CLS="$(bash "$STATE_BIN" validate --checkout "$d" --task t14-task 2>&1)"
[ "$CLS" = CLOSED ] && ok "the reduction validates as CLOSED before it is committed" \
                    || bad "the reduction validates as CLOSED before it is committed" "got: $CLS"
commit_state "$d" t14-task                 # step 2: commit the closed state
owner clear --checkout "$d" --task t14-task  # step 3: only now, clear
expect_rc 0 "$RC" "the declaration is cleared after the commit" "$OUT"
[ -f "$d/$OWNER_REL" ] && bad "the declaration is gone after a clean closure" "still present" \
                       || ok "the declaration is gone after a clean closure"
git -C "$d" show "HEAD:logs/work-loop/t14-task.md" 2>/dev/null | grep -q '^status: closed$' \
  && ok "the COMMITTED record carries status: closed" \
  || bad "the COMMITTED record carries status: closed" "HEAD does not"

# (b) PRE-COMMIT failure — the reduction is written but is not a valid closing
# record, so step 2's guard stops. Nothing is committed and, decisively, the
# declaration is untouched: the checkout is still held by a task that has not
# finished, and saying otherwise would be the lie the order exists to prevent.
d="$(new_repo)"
state_file "$d" t14-pre claude
commit_state "$d" t14-pre
printf 't14-pre\n' >"$d/$OWNER_REL"
HEAD_BEFORE="$(git -C "$d" rev-parse HEAD)"
# The half-written reduction: status flipped, active body still standing.
sed 's/^status: active$/status: closed/' "$d/logs/work-loop/t14-pre.md" >"$d/t.tmp"
mv "$d/t.tmp" "$d/logs/work-loop/t14-pre.md"
CLS="$(bash "$STATE_BIN" validate --checkout "$d" --task t14-pre 2>&1)"; CRC=$?
[ "$CRC" -ne 0 ] && ok "the half-written reduction is REFUSED, so the commit never happens" \
                 || bad "the half-written reduction is REFUSED" "it validated as $CLS"
[ "$(git -C "$d" rev-parse HEAD)" = "$HEAD_BEFORE" ] \
  && ok "no closure commit was made" || bad "no closure commit was made"
case "$(marker "$d")" in
  t14-pre) ok "the declaration is INTACT after a pre-commit failure" ;;
  *)       bad "the declaration is INTACT after a pre-commit failure" "got: '$(marker "$d")'" ;;
esac

# (c) POST-COMMIT / PRE-CLEAR failure — the safe side of the cut. Valid CLOSED
# state is committed and the declaration survives as a stale one, which is
# recoverable precisely because the validator can now see the task is closed:
# the next task start in this same checkout clears it without an operator.
d="$(new_repo)"
state_file "$d" t14-post claude
commit_state "$d" t14-post
printf 't14-post\n' >"$d/$OWNER_REL"
state_file "$d" t14-post operator
commit_state "$d" t14-post                 # step 2 done; step 3 never runs
git -C "$d" show "HEAD:logs/work-loop/t14-post.md" 2>/dev/null | grep -q '^status: closed$' \
  && ok "valid CLOSED state survives the interruption, committed" \
  || bad "valid CLOSED state survives the interruption, committed" "HEAD does not carry it"
case "$(marker "$d")" in
  t14-post) ok "the stale declaration survives, rather than being silently dropped" ;;
  *)        bad "the stale declaration survives" "got: '$(marker "$d")'" ;;
esac
state_file "$d" t14-next claude
owner claim --checkout "$d" --task t14-next --depth local
expect_rc 0 "$RC" "the stale declaration is safely clearable by the next task start" "$OUT"
case "$(marker "$d")" in
  t14-next) ok "the checkout is recovered with no operator involved" ;;
  *)        bad "the checkout is recovered with no operator involved" "got: '$(marker "$d")'" ;;
esac

# ================================================================== F1
# Correction finding 1 — an ownership check that cannot run must refuse, not
# pass. The dispatcher half is dispatch.test.sh case 12d; this is the helper's
# own half: a caller must be able to tell "ran and found nothing" from "did not
# run", and the exit code is the only thing a caller reads.
echo
echo "F1 — an unavailable ownership check is distinguishable from a clean one"
d="$(new_repo)"
state_file "$d" f1-task claude
owner check --checkout "$d" --task f1-task --depth local
expect_rc 0 "$RC" "control — a check that RAN on a free checkout exits 0" "$OUT"

OUT="$(bash "$ABSENT" check --checkout "$d" --task f1-task 2>&1)"; RC=$?
[ "$RC" -ne 0 ] && ok "an absent helper cannot exit 0 (exit $RC)" \
                || bad "an absent helper cannot exit 0" "it exited 0"

# The dispatcher must not treat that as a pass. Proved end to end here because
# the helper and the dispatcher are the two supported entry surfaces and this
# suite owns the pairing.
d2="$(new_repo)"
state_file "$d2" f1-disp codex; commit_state "$d2" f1-disp
git -C "$d2" rm -q --cached logs/scripts/work-loop-owner.sh >/dev/null 2>&1
rm -f "$d2/logs/scripts/work-loop-owner.sh"
git -C "$d2" commit -qm "no helper" >/dev/null 2>&1
HEAD_BEFORE="$(git -C "$d2" rev-parse HEAD)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d2" --task f1-disp \
        --log-dir "$d2/runs" --timeout 20 --actor-cmd 'exit 0' 2>&1)"; RC=$?
expect_rc 35 "$RC" "the dispatcher REFUSES a checkout with no helper" "$OUT"
[ "$(git -C "$d2" rev-parse HEAD)" = "$HEAD_BEFORE" ] \
  && ok "nothing was committed by the refused run" \
  || bad "nothing was committed by the refused run"

# ================================================================== F2
# Correction finding 2 — the declaration has exactly one legal shape, and a
# declaration outside it is AMBIGUOUS, refuses, and SURVIVES. The survival half
# is the one that used to fail: `clear` deleted the evidence the operator needed.
echo
echo "F2 — malformed declarations are ambiguous, and are never guessed at or deleted"
d="$(new_repo)"
state_file "$d" f2-holder claude
state_file "$d" f2-other claude

# Every one of these used to resolve to 'f2-holder' by reading field 1 alone.
malformed_is_ambiguous() { # content label
  printf '%s' "$1" >"$d/$OWNER_REL"
  owner check --checkout "$d" --task f2-other --depth local
  expect_rc 4 "$RC" "$2" "$OUT"
  # And it survives the check that found it.
  [ -f "$d/$OWNER_REL" ] && ok "$2 — the declaration survives the check" \
                         || bad "$2 — the declaration survives the check" "it was removed"
}
malformed_is_ambiguous 'f2-holder f2-second 2026-08-11
'                                        "extra token / second id on the line"
# THE RETIRED FORM. Tracer 3 dropped the claim date, so `{task-id} {date}` is no
# longer a declaration at all. This row is the one that proves the legacy shape
# is genuinely rejected rather than quietly tolerated by a reader that still
# looks at field 1 — which is exactly how a fallback parser survives a cutover.
malformed_is_ambiguous 'f2-holder 2026-08-11
'                                        "the retired {task-id} {date} form"
malformed_is_ambiguous 'f2-holder not-a-date
'                                        "a second token that is not a date either"
malformed_is_ambiguous 'f2-holder 2026-99-99
'                                        "a date-shaped second token, out of range"
malformed_is_ambiguous 'f2-holder
f2-other
'                                        "two declaration lines"

# clear must leave it exactly as it is. This is the R2 row that was inverted.
printf 'f2-holder\nf2-other\n' >"$d/$OWNER_REL"
BEFORE="$(cat "$d/$OWNER_REL")"
owner clear --checkout "$d" --task f2-other
expect_rc 4 "$RC" "clear REFUSES a malformed declaration as AMBIGUOUS" "$OUT"
[ -f "$d/$OWNER_REL" ] && ok "clear did not delete the malformed declaration" \
                       || bad "clear did not delete the malformed declaration" "it is gone"
[ "$(cat "$d/$OWNER_REL" 2>/dev/null)" = "$BEFORE" ] \
  && ok "clear left the malformed declaration byte-for-byte unchanged" \
  || bad "clear left the malformed declaration byte-for-byte unchanged"

# claim must not overwrite it either — that would be the same erasure by another
# route, and it is how a live claim's half-written file would be destroyed.
owner claim --checkout "$d" --task f2-other --depth local
expect_rc 4 "$RC" "claim REFUSES on a malformed declaration" "$OUT"
[ "$(cat "$d/$OWNER_REL" 2>/dev/null)" = "$BEFORE" ] \
  && ok "claim left the malformed declaration unchanged" \
  || bad "claim left the malformed declaration unchanged"

# The control: the exact legal shape must still be read as a claim. Without it
# this whole case would pass for a reader that called everything malformed.
printf 'f2-holder\n' >"$d/$OWNER_REL"
owner check --checkout "$d" --task f2-other --depth local
expect_rc 3 "$RC" "control — the exact legal shape IS read, and refuses by name" "$OUT"
expect_names "$OUT" "f2-holder" "control — the legal declaration names its holder"

# The strict rule must hold in the cross-checkout reader too, which was a
# second, looser inline copy. A malformed marker elsewhere names nobody, so it
# cannot claim this task away from a checkout that legitimately holds it.
d="$(new_repo)"
w1="$(add_worktree "$d" f2-one)"
w2="$(add_worktree "$d" f2-two)"
state_file "$w1" f2-cross claude
printf 'f2-cross f2-decoy 2026-08-11\n' >"$w2/$OWNER_REL"
owner check --checkout "$w1" --task f2-cross --depth repo
expect_rc 0 "$RC" "a malformed marker in ANOTHER checkout does not claim this task" "$OUT"

# ================================================================== F3
# Correction finding 3 — a contested claim on one free checkout is indivisible.
# RED before the fix: `claim` ran its check, then installed with `mv -f`, so two
# different tasks both saw a free checkout and both returned PROCEED, the later
# rename silently winning. Measured on the pre-fix helper: 10 rounds, 10 double
# claims, 0 refusals.
echo
echo "F3 — two simultaneous different-task claims produce exactly one winner"
d="$(new_repo)"
state_file "$d" f3-alpha claude
state_file "$d" f3-beta  claude

DOUBLE=0; NONE=0; ROUNDS=6
for i in $(seq 1 "$ROUNDS"); do
  rm -f "$d/$OWNER_REL"
  rmdir "$d/logs/work-loop/.owner.lock" 2>/dev/null
  ra_f="$SANDBOX_ROOT/f3.a.$i"; rb_f="$SANDBOX_ROOT/f3.b.$i"
  ( bash "$OWNER_BIN" claim --checkout "$d" --task f3-alpha --depth local \
      >"$ra_f.out" 2>&1; echo $? >"$ra_f" ) &
  ( bash "$OWNER_BIN" claim --checkout "$d" --task f3-beta --depth local \
      >"$rb_f.out" 2>&1; echo $? >"$rb_f" ) &
  wait
  ra="$(cat "$ra_f")"; rb="$(cat "$rb_f")"
  winners=0
  [ "$ra" = 0 ] && winners=$((winners+1))
  [ "$rb" = 0 ] && winners=$((winners+1))
  [ "$winners" -gt 1 ] && DOUBLE=$((DOUBLE+1))
  [ "$winners" -lt 1 ] && NONE=$((NONE+1))

  # The declaration left behind must name the winner — not the loser, and not a
  # task that was refused. A last-writer-wins rename produced exactly this
  # mismatch, and it is invisible to an exit-code-only assertion.
  final="$(awk 'NF {print $1; exit}' "$d/$OWNER_REL" 2>/dev/null)"
  won=""
  [ "$ra" = 0 ] && won="f3-alpha"
  [ "$rb" = 0 ] && won="f3-beta"
  [ "$final" = "$won" ] || bad "round $i — the declaration names the winner" \
                               "declaration says '$final', the PROCEED went to '$won'"
done
[ "$DOUBLE" -eq 0 ] && ok "no round admitted two writers ($ROUNDS contested rounds)" \
                    || bad "no round admitted two writers" "$DOUBLE of $ROUNDS rounds double-claimed"
[ "$NONE" -eq 0 ] && ok "every round produced a winner — the lock does not deadlock" \
                  || bad "every round produced a winner" "$NONE of $ROUNDS rounds had none"

# The loser's refusal must be readable, not just non-zero.
rm -f "$d/$OWNER_REL"
owner claim --checkout "$d" --task f3-alpha --depth local
expect_rc 0 "$RC" "alpha takes the free checkout" "$OUT"
owner claim --checkout "$d" --task f3-beta --depth local
expect_rc 3 "$RC" "beta's later claim is REFUSED" "$OUT"
expect_names "$OUT" "f3-alpha" "the refusal names the task that won"

# The lock takes no git. --depth local's whole guarantee is that Codex can run
# it, and Codex may not run git.
GT="$(git_trap_dir)"
rm -f "$d/$OWNER_REL"
OUT="$(PATH="$GT:$PATH" bash "$OWNER_BIN" claim --checkout "$d" --task f3-alpha --depth local 2>&1)"; RC=$?
expect_rc 0 "$RC" "a locked claim still runs with no git available" "$OUT"
[ -s "$GT/calls" ] && bad "the locked claim ran no git" "git calls: $(tr '\n' ';' <"$GT/calls")" \
                   || ok "the locked claim ran no git"

# The lock is released, so the next claim is not blocked by the last one.
[ -d "$d/logs/work-loop/.owner.lock" ] \
  && bad "the mutation lock is released after a claim" "still held" \
  || ok "the mutation lock is released after a claim"

# The lock needs no ignore rule because git does not track directories. That is
# why it is safe to put it beside the state files, and it is asserted rather
# than assumed — an empty directory that ever became visible would put an
# unignored path into the one folder the task state files live in.
mkdir -p "$d/logs/work-loop/.owner.lock"
LSEEN="$(git -C "$d" status --porcelain -uall -- logs/work-loop/ | grep -c 'owner.lock')"
[ "$LSEEN" = "0" ] && ok "the empty lock directory is invisible to git status" \
                   || bad "the empty lock directory is invisible to git status" "matched $LSEEN times"
rmdir "$d/logs/work-loop/.owner.lock" 2>/dev/null

# ================================================================== summary
echo
echo "=============================================================="
printf ' T1..T14 + F1..F3: %d passed, %d failed\n' "$PASS" "$FAIL"
echo "=============================================================="
[ "$FAIL" -eq 0 ] || exit 1
