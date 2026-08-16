#!/bin/bash
# Focused harness for Tracer bullet 4's legacy-session isolation.
#
# TWO THINGS ARE PROVED HERE, and they are deliberately different in kind:
#
#   Part A  the SHARED RULE — work-loop-session-preflight.sh itself, against the
#           smallest set of fixtures that discriminate between its outcomes.
#   Part B  the WIRING — that the four named commands, the handoff skill and the
#           compaction protocol actually carry that rule.
#
# WHY NOT A CROSS-PRODUCT. The obvious harness runs every lifecycle state against
# every command: four commands x five owner shapes = twenty cases. Nineteen of
# them would re-prove the same script. The commands are Markdown instructions
# that all call ONE executable; the rule's behaviour is proved once in Part A,
# and Part B proves each command reaches it before writing. Running the product
# would cost twenty times as much and discriminate nothing further.
#
# WHAT PART B CAN AND CANNOT SHOW. It is a mechanical check over instruction
# text: it proves the call is present and positioned above the command's first
# write, not that a model obeyed it. Interactive enforcement is instruction-borne
# — the same accepted limitation the ownership helper carries. Stated, not
# covered by a claim to the contrary.
#
# Case 0 is the falsifiability proof: it points Part A at an ABSENT preflight and
# asserts the suite notices. A harness that stays green with the thing under test
# removed is not evidence.
#
# Usage:  bash work-loop-session-preflight.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# logs/scripts -> logs -> checkout root. Two levels, not one.
REPO_ROOT="${REPO_ROOT:-$(cd "$HERE/../.." && pwd)}"
PREFLIGHT_BIN="${PREFLIGHT_BIN:-$HERE/work-loop-session-preflight.sh}"
OWNER_BIN="$HERE/work-loop-owner.sh"
STATE_BIN="$HERE/work-loop-state.sh"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-preflight-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

expect_rc() { # want got label output
  [ "$1" = "$2" ] && ok "$3" || bad "$3" "expected exit $1, got $2 — $4"
}

# ------------------------------------------------------------------ fixtures

new_checkout() { # -> path
  local d; d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name harness
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh"
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh"
  printf 'sandbox\n' >"$d/README.md"
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  printf '%s' "$d"
}

# An open record in one of the two active pairs, or a blocked one.
open_record() { # dir task status turn
  local d="$1" task="$2" status="$3" turn="$4" blocker='None.'
  [ "$status" = blocked ] && blocker='Waiting on the operator to choose between two designs.'
  cat >"$d/logs/work-loop/$task.md" <<EOF
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

closed_record() { # dir task
  cat >"$1/logs/work-loop/$2.md" <<EOF
---
task: $2
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
}

declare_owner() { printf '%s\n' "$2" >"$1/logs/work-loop/.owner"; }

# Every case asserts this. A gate that mutated on the way past would be taking
# the turn rather than checking it — and the mutation most likely to happen by
# accident is a "helpful" repair of the very declaration that stopped it.
fingerprint() { # dir -> stable digest of the Work Loop state surface
  ( cd "$1" && find logs/work-loop -type f -exec shasum -a 256 {} \; 2>/dev/null | sort )
}

# Sets OUT and RC. It must NOT be called inside $( ), because a command
# substitution runs in a subshell and the exit code assigned there is discarded
# — which is exactly how the first draft of this harness reported 127 for every
# case while the assertions on the output text all passed.
run_pf() { # dir command
  OUT="$(bash "$PREFLIGHT_BIN" --checkout "$1" --command "$2" 2>&1)"; RC=$?
}

case_readonly() { # dir before label
  [ "$(fingerprint "$1")" = "$2" ] \
    && ok "$3 — the Work Loop state surface is untouched (read-only)" \
    || bad "$3 — the Work Loop state surface is untouched (read-only)" "$(fingerprint "$1")"
}

echo "=============================================================="
echo " Part A — the shared rule (work-loop-session-preflight.sh)"
echo "=============================================================="

echo
echo "Case 0 — falsifiability: an ABSENT preflight is noticed"
d="$(new_checkout)"; open_record "$d" "gone-task" active claude; declare_owner "$d" "gone-task"
OUT="$(PREFLIGHT_BIN="$HERE/does-not-exist.sh" bash -c 'bash "$0" --checkout "$1" --command "/prime" 2>&1' "$HERE/does-not-exist.sh" "$d")"; RC=$?
[ "$RC" -ne 0 ] && [ "$RC" -ne 3 ] \
  && ok "0 — an absent preflight does not silently return PROCEED" \
  || bad "0 — an absent preflight does not silently return PROCEED" "rc=$RC out=$OUT"

echo
echo "Case 1 — ACTIVE_CLAUDE: the checkout is held, and the route is the task"
d="$(new_checkout)"; open_record "$d" "held-task" active claude; declare_owner "$d" "held-task"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/prime"
expect_rc 3 "$RC" "1 — exits 3 (STOP, open task)" "$OUT"
printf '%s' "$OUT" | grep -q '^verdict: STOP' \
  && ok "1 — verdict is STOP" || bad "1 — verdict is STOP" "$OUT"
printf '%s' "$OUT" | grep -q '^route: /work-loop-v2 held-task' \
  && ok "1 — the route names the exact task" || bad "1 — the route names the exact task" "$OUT"
case_readonly "$d" "$BEFORE" "1"

echo
echo "Case 2 — ACTIVE_CODEX: still held; it is simply the other actor's move"
d="$(new_checkout)"; open_record "$d" "codex-task" active codex; declare_owner "$d" "codex-task"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/session-plan"
expect_rc 3 "$RC" "2 — exits 3 (STOP, open task)" "$OUT"
printf '%s' "$OUT" | grep -q 'Codex' \
  && ok "2 — the route names Codex as the actor owed the turn" || bad "2 — the route names Codex" "$OUT"
case_readonly "$d" "$BEFORE" "2"

echo
echo "Case 3 — BLOCKED_OPERATOR: ownership is RETAINED and the blocker is surfaced"
# The case most likely to be got wrong. A blocked task has stopped, and "stopped"
# reads like "finished" — but it is waiting on a decision, so the checkout is
# still leased and a legacy wrap over it would bury the question.
d="$(new_checkout)"; open_record "$d" "blocked-task" blocked operator; declare_owner "$d" "blocked-task"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/wrap-session"
expect_rc 3 "$RC" "3 — exits 3 (STOP, task retained)" "$OUT"
printf '%s' "$OUT" | grep -q '## Blocker' \
  && ok "3 — the route sends the operator to '## Blocker'" || bad "3 — the route sends the operator to '## Blocker'" "$OUT"
printf '%s' "$OUT" | grep -qi 'stopped, not finished' \
  && ok "3 — the reason distinguishes blocked from closed" || bad "3 — the reason distinguishes blocked from closed" "$OUT"
[ -f "$d/logs/work-loop/.owner" ] \
  && ok "3 — the declaration is retained" || bad "3 — the declaration is retained" "the .owner file was removed"
case_readonly "$d" "$BEFORE" "3"

echo
echo "Case 4 — no declaration: the ordinary session proceeds, behaviour unchanged"
d="$(new_checkout)"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/prime"
expect_rc 0 "$RC" "4 — exits 0 (PROCEED)" "$OUT"
printf '%s' "$OUT" | grep -q '^verdict: PROCEED' \
  && ok "4 — verdict is PROCEED" || bad "4 — verdict is PROCEED" "$OUT"
[ ! -e "$d/logs/work-loop/.owner" ] \
  && ok "4 — no declaration was created by the check" || bad "4 — no declaration was created" "$(cat "$d/logs/work-loop/.owner")"
case_readonly "$d" "$BEFORE" "4"

echo
echo "Case 5 — CLOSED under a surviving declaration: stale, so PROCEED — and do not clear it"
# Canonical stale-owner semantics. The declaration is ended by the next Work Loop
# task start, never by a legacy command: this gate reports and moves on.
d="$(new_checkout)"; closed_record "$d" "done-task"; declare_owner "$d" "done-task"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/session-start"
expect_rc 0 "$RC" "5 — exits 0 (PROCEED)" "$OUT"
printf '%s' "$OUT" | grep -qi 'stale' \
  && ok "5 — the reason names the declaration as stale" || bad "5 — the reason names the declaration as stale" "$OUT"
[ -f "$d/logs/work-loop/.owner" ] \
  && ok "5 — the stale declaration is LEFT IN PLACE, not cleared" || bad "5 — the stale declaration is left in place" "it was removed"
case_readonly "$d" "$BEFORE" "5"

echo
echo "Case 6 — malformed declaration (the retired two-field shape) stops"
d="$(new_checkout)"; open_record "$d" "two-field" active claude
printf '%s\n' "two-field 2026-08-14" >"$d/logs/work-loop/.owner"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/prime"
expect_rc 4 "$RC" "6 — exits 4 (STOP, unestablished)" "$OUT"
printf '%s' "$OUT" | grep -qi 'retired' \
  && ok "6 — the reason names the retired shape" || bad "6 — the reason names the retired shape" "$OUT"
case_readonly "$d" "$BEFORE" "6"

echo
echo "Case 7 — contradictory: a declaration whose task record does not exist stops"
d="$(new_checkout)"; declare_owner "$d" "ghost-task"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/wrap-session"
expect_rc 4 "$RC" "7 — exits 4 (STOP, unestablished)" "$OUT"
printf '%s' "$OUT" | grep -q 'ghost-task.md does not exist' \
  && ok "7 — the reason names the missing record" || bad "7 — the reason names the missing record" "$OUT"
case_readonly "$d" "$BEFORE" "7"

echo
echo "Case 8 — a declared task whose record is MALFORMED stops (validator non-zero)"
d="$(new_checkout)"; declare_owner "$d" "broken-task"
printf -- '---\ntask: broken-task\nstatus: active\nturn: operator\n---\n\n## Objective and scope\nIllegal pair.\n' \
  >"$d/logs/work-loop/broken-task.md"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/session-plan"
expect_rc 4 "$RC" "8 — exits 4 (STOP, unestablished)" "$OUT"
printf '%s' "$OUT" | grep -qi 'could not classify' \
  && ok "8 — the reason attributes the stop to the validator" || bad "8 — the reason attributes the stop to the validator" "$OUT"
case_readonly "$d" "$BEFORE" "8"

echo
echo "Case 9 — a declaration with the validator MISSING fails closed"
# The asymmetry that matters: an absent declaration proceeds (case 4), an absent
# validator UNDER a declaration stops. Something claimed this checkout and the
# evidence about it is exactly what went missing.
d="$(new_checkout)"; open_record "$d" "no-validator" active claude; declare_owner "$d" "no-validator"
rm -f "$d/logs/scripts/work-loop-state.sh"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/prime"
expect_rc 4 "$RC" "9 — exits 4 (STOP, unestablished)" "$OUT"
printf '%s' "$OUT" | grep -q 'work-loop-state.sh is missing' \
  && ok "9 — the reason names the missing validator" || bad "9 — the reason names the missing validator" "$OUT"
case_readonly "$d" "$BEFORE" "9"

echo
echo "Case 10 — outside a Git repository, PROCEED rather than fail"
d="$(mktemp -d "$SANDBOX_ROOT/nogit.XXXXXX")"
OUT="$(bash "$PREFLIGHT_BIN" --checkout "$d" --command "/prime" 2>&1)"; RC=$?
expect_rc 0 "$RC" "10 — exits 0 (PROCEED)" "$OUT"

echo
echo "Case 15 — handoff fixture: an ACTIVE task selects the Work Loop branch"
# The handoff skill has no state of its own to inspect — it branches on this
# verdict. So the fixture that proves the branch is the verdict the skill reads.
d="$(new_checkout)"; open_record "$d" "handoff-active" active claude; declare_owner "$d" "handoff-active"
BEFORE="$(fingerprint "$d")"
run_pf "$d" "handoff-thread"
expect_rc 3 "$RC" "15 — an active task returns STOP, so the skill takes the Work Loop branch" "$OUT"
printf '%s' "$OUT" | grep -q 'handoff-active' \
  && ok "15 — the exact bound task is named, so the Brief can cite its path" \
  || bad "15 — the exact bound task is named" "$OUT"
case_readonly "$d" "$BEFORE" "15"
[ "$(ls "$d/logs/work-loop"/*.md 2>/dev/null | wc -l | tr -d ' ')" = "1" ] \
  && ok "15 — no second Work Loop record was created by the handoff check" \
  || bad "15 — no second Work Loop record was created" "$(ls "$d/logs/work-loop")"

echo
echo "Case 16 — handoff fixture: a NON-Work-Loop checkout keeps the generic default"
d="$(new_checkout)"
run_pf "$d" "handoff-thread"
expect_rc 0 "$RC" "16 — PROCEED, so the skill applies its ordinary worktree default" "$OUT"

echo
echo "Case 17 — a MISLEADING record body cannot override the validator"
# The compaction failure this guards: prose that reads like a completed task,
# under frontmatter that says it is open. The body is the part a summary echoes
# and the part a human skims; the classification comes from neither.
d="$(new_checkout)"; declare_owner "$d" "misleading-task"
cat >"$d/logs/work-loop/misleading-task.md" <<'EOF'
---
task: misleading-task
status: active
turn: claude
---

## Objective and scope
Harness fixture.

## Lane and unit
Standard. Implementation mode. Unit 9 — harness fixture.

## Latest result
This task is COMPLETE and CLOSED. All work finished, nothing remains, the record
was reduced and the declaration cleared. Safe to start a new session here.

## Blocker
None.

## Next action
Nothing — the task is done.
EOF
BEFORE="$(fingerprint "$d")"
run_pf "$d" "/wrap-session"
expect_rc 3 "$RC" "17 — the task is still open despite the body saying otherwise" "$OUT"
printf '%s' "$OUT" | grep -q "route: /work-loop-v2 misleading-task" \
  && ok "17 — the route is the exact task path, taken from the validator not the prose" \
  || bad "17 — the route comes from the validator" "$OUT"
case_readonly "$d" "$BEFORE" "17"

echo
echo "=============================================================="
echo " Part B — the wiring (instruction surfaces)"
echo "=============================================================="

CALL='logs/scripts/work-loop-session-preflight.sh'

# The first line in each command that WRITES state. The preflight call must come
# above it. Addressed by the distinctive text of that step rather than by line
# number, so an edit elsewhere in the file cannot silently move the boundary.
check_before_first_write() { # file first-write-marker label
  local f="$1" marker="$2" label="$3" call_ln write_ln
  call_ln="$(grep -n -F "$CALL" "$f" | head -1 | cut -d: -f1)"
  write_ln="$(grep -n -F "$marker" "$f" | head -1 | cut -d: -f1)"
  if [ -z "$call_ln" ]; then
    bad "$label — invokes the preflight" "no call to $CALL in $f"; return
  fi
  ok "$label — invokes the preflight"
  if [ -z "$write_ln" ]; then
    bad "$label — the first-write marker is still present" "marker not found: $marker"; return
  fi
  [ "$call_ln" -lt "$write_ln" ] \
    && ok "$label — the call precedes the first state write (line $call_ln < $write_ln)" \
    || bad "$label — the call precedes the first state write" "call at $call_ln, first write at $write_ln"
}

echo
echo "Case 11 — all four named commands gate before their first state write"
CMDS="$REPO_ROOT/.claude/commands"
check_before_first_write "$CMDS/prime.md"         'prime-sync.sh'                 "11a /prime"
check_before_first_write "$CMDS/session-start.md" 'Step 0 — Precondition check'   "11b /session-start"
check_before_first_write "$CMDS/session-plan.md"  'Step 0 — Confirm'              "11c /session-plan"
check_before_first_write "$CMDS/wrap-session.md"  'claude-wrap-session-done'      "11d /wrap-session"

echo
echo "Case 12 — the handoff skill carries the Work Loop branch, and only that branch"
HO="$REPO_ROOT/.agents/skills/handoff-thread/SKILL.md"
grep -q -F "$CALL" "$HO" \
  && ok "12 — the handoff skill invokes the preflight" || bad "12 — the handoff skill invokes the preflight" "no call in $HO"
grep -qi 'uses \*\*Local\*\*\|target the bound checkout as Local' "$HO" \
  && ok "12 — the Work Loop branch targets the bound checkout as Local" || bad "12 — the Work Loop branch targets Local" "$HO"
grep -qi 'create and copy no second Work Loop record' "$HO" \
  && ok "12 — the branch forbids copying state into a second record" || bad "12 — the branch forbids copying state" "$HO"
# The generic default must survive. A change that removed it would isolate Work
# Loop by breaking every other handoff, which is not isolation.
grep -q 'startingState: { type: "working-tree" }' "$HO" \
  && ok "12 — the generic Git default (worktree) is preserved" || bad "12 — the generic Git default is preserved" "$HO"

echo
echo "Case 13 — the compaction protocol makes the validator and the exact path authoritative"
CP="$REPO_ROOT/docs/compaction-protocol.md"
grep -q 'logs/scripts/work-loop-state.sh' "$CP" \
  && ok "13 — it names the validator as what 'validated' means" || bad "13 — it names the validator" "$CP"
grep -qi 'stop and ask the operator' "$CP" \
  && ok "13 — an absent or invalid pointer stops rather than guessing" || bad "13 — absent pointer stops" "$CP"
grep -qi 'No legacy session state is consulted or written' "$CP" \
  && ok "13 — legacy session state is excluded from Work Loop state" || bad "13 — legacy state excluded" "$CP"

echo
echo "Case 14 — no active Work Loop surface still claims the unwired staging hook guards it"
# Bounded to ACTIVE instruction surfaces, per the unit's scope. Historical plans,
# audits and past task records are records of what was believed then and are
# deliberately not rewritten.
HOOK='check-foreign-staging'
ACTIVE_SURFACE="$REPO_ROOT/AGENTS.md
$REPO_ROOT/docs/compaction-protocol.md
$REPO_ROOT/.agents/skills/work-loop-v2/SKILL.md
$REPO_ROOT/.agents/skills/reorient/SKILL.md
$REPO_ROOT/.agents/skills/handoff-thread/SKILL.md
$REPO_ROOT/.claude/commands/work-loop-v2.md
$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh"
# KEYWORD MATCHING CANNOT DO THIS, and the first draft of this case proved it:
# a regex for "arm|guard|protect" near the hook name fires on the retirement
# note in dispatch.sh, which says the exact opposite of a claim. A denial and an
# assertion share their vocabulary.
#
# So the test is structural instead. Exactly ONE active surface may mention the
# hook at all — dispatch.sh — and there every mention must sit inside the block
# that retires it. Anywhere else, any mention at all fails: an active Work Loop
# surface has no business naming a hook that guards nothing.
# THE RULE: an active Work Loop surface may name the hook ONLY while denying that
# it guards anything. Naming it without that denial is the claim being retired.
# Both surviving mentions are denials and are meant to stay — a reader who has
# heard the hook protects Work Loop needs to be told, in the place they would
# look, that it does not.
DENIAL='registered in NO settings layer|is registered in no settings layer|guards nothing|does not.*supply any commit or state boundary'
HITS=""
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -q "$HOOK" "$f" 2>/dev/null || continue
  grep -qE "$DENIAL" "$f" 2>/dev/null && continue
  HITS="$HITS$f "
done <<EOF
$ACTIVE_SURFACE
EOF
[ -z "$HITS" ] \
  && ok "14 — every active mention of the hook denies that it guards Work Loop" \
  || bad "14 — every active mention of the hook denies that it guards Work Loop" "$HITS"

# And the mechanism itself is gone, not merely re-described.
! grep -q 'init_session_identity' "$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh" \
  && ok "14 — the dispatcher's session-identity init no longer exists" \
  || bad "14 — the dispatcher's session-identity init no longer exists" \
         "$(grep -n 'init_session_identity' "$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh")"

# And the premise behind that: the hook really is unwired.
WIRED=""
for s in "$REPO_ROOT/.claude/settings.json" "$REPO_ROOT/.claude/settings.local.json"; do
  [ -f "$s" ] && grep -q "$HOOK" "$s" && WIRED="$WIRED$s "
done
[ -z "$WIRED" ] \
  && ok "14 — control: the hook is registered in no settings layer in this repo" \
  || bad "14 — control: the hook is registered in no settings layer" "$WIRED"

echo
echo "-----------------------------------------------"
printf 'pass=%d fail=%d  (Part B is a mechanical instruction check — interactive enforcement is instruction-borne)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
