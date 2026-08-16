#!/bin/bash
# work-loop-state.test.sh — the acceptance matrix for Capability A, the one
# read-only Work Loop v2 state validator (Tracer bullet 1).
#
# WHAT IS REAL HERE. Real temporary checkouts, real git repositories where a test
# needs one, the real validator, the real work-loop-owner.sh and the real
# dispatch.sh --status. Nothing under test is stubbed. What is NOT proven here is
# anything about runtime cutover: at this commit no consumer calls the validator,
# and this suite deliberately asserts that too (R3).
#
# HOW EVERY NEGATIVE IS MADE FAIL-CAPABLE. Each illegal fixture is derived from a
# legal one by exactly ONE mutation, and the legal base is asserted to pass in the
# same run (L1..L5). So a rejection is attributable to the mutation rather than to
# a fixture that was broken in some other way — which is the difference between a
# negative control and a test that merely happens to be red (core § 6 rule 5).
#
# Case 0 is the harness's own falsifiability proof: it re-runs this suite against
# an ABSENT validator and asserts the suite fails. A harness that stays green with
# the thing under test removed is not evidence.
#
# Usage:  bash logs/scripts/work-loop-state.test.sh
#         STATE_BIN=/path/to/work-loop-state.sh bash ...

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"   # logs/scripts -> logs -> checkout root
STATE_BIN="${STATE_BIN:-$HERE/work-loop-state.sh}"
OWNER_BIN="${OWNER_BIN:-$HERE/work-loop-owner.sh}"
DISPATCH_BIN="${DISPATCH_BIN:-$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh}"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-state-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

# ============================================================ case 0 — falsifiability
# Re-runs this file against a validator path that does not exist. If the suite
# can still pass, the suite is not testing the validator.
if [ "${WL2_STATE_SELFTEST:-0}" != "1" ]; then
  echo "=== Case 0 — the suite fails when the validator is absent ==="
  ABSENT="$SANDBOX_ROOT/no-such-validator.sh"
  SELF_OUT="$(WL2_STATE_SELFTEST=1 STATE_BIN="$ABSENT" bash "${BASH_SOURCE[0]}" 2>&1)"; SELF_RC=$?
  if [ "$SELF_RC" -ne 0 ]; then
    ok "the suite fails when pointed at an absent validator (exit $SELF_RC)"
  else
    bad "the suite fails when pointed at an absent validator" "it passed — the suite proves nothing"
  fi
  echo
fi

# ---------------------------------------------------------------- fixtures

new_checkout() { # -> path on stdout. Plain directory; git only where a test needs it.
  local d
  d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  mkdir -p "$d/logs/work-loop"
  # -P: on macOS $TMPDIR is a symlink and the validator reports canonical paths.
  (cd "$d" && pwd -P)
}

# A legal open record. STATUS/TURN are supplied so one writer covers all three
# open classifications, and every illegal open fixture below is this file with
# exactly one line changed.
write_open() { # checkout task status turn [with-brief]
  local d="$1" t="$2" st="$3" tu="$4" brief="${5:-}" blocker='None.'
  [ "$st" = "blocked" ] && blocker='Waiting on the operator to choose the retention window.'
  {
    printf -- '---\ntask: %s\nstatus: %s\nturn: %s\n---\n\n' "$t" "$st" "$tu"
    printf -- '## Objective and scope\nA fixture objective, with an exit condition and a boundary.\n\n'
    printf -- '## Lane and unit\nStandard. Implementation mode. Unit 1 — the fixture unit.\n\n'
    [ -n "$brief" ] && printf -- '## Brief\nWhy: the fixture needs a handoff payload.\n\n'
    printf -- '## Latest result\nNot started.\n\n'
    printf -- '## Blocker\n%s\n\n' "$blocker"
    printf -- '## Next action\nClaude: run the fixture unit.\n'
  } >"$d/logs/work-loop/$t.md"
}

write_closed() { # checkout task
  local d="$1" t="$2"
  {
    printf -- '---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n' "$t"
    printf -- '## Outcome\nThe fixture task achieved its objective.\n\n'
    printf -- '## Decisions that matter\nOne decision, and one deferral with its reason.\n\n'
    printf -- '## Evidence\nCommit deadbeef.\n\n'
    printf -- '## Accepted limitations\nNone.\n'
  } >"$d/logs/work-loop/$t.md"
}

# ---------------------------------------------------------------- assertions

RC=0; OUT=""; ERR=""
run() { # checkout task
  OUT="$(bash "$STATE_BIN" validate --checkout "$1" --task "$2" 2>"$SANDBOX_ROOT/err")"; RC=$?
  ERR="$(cat "$SANDBOX_ROOT/err" 2>/dev/null)"
}

expect_class() { # want checkout task label
  run "$2" "$3"
  if [ "$RC" -ne 0 ]; then
    bad "$4" "expected exit 0 and '$1', got exit $RC — ${ERR:-<no diagnostic>}"
  elif [ "$OUT" != "$1" ]; then
    bad "$4" "expected stdout '$1', got '$OUT'"
  else
    ok "$4"
  fi
}

# A rejection must be both exit-coded AND readable: a nonzero exit that does not
# name the violated invariant leaves the caller guessing a repair, which is the
# behaviour the validator exists to remove.
expect_reject() { # code needle checkout task label
  run "$3" "$4"
  if [ "$RC" -ne "$1" ]; then
    bad "$5" "expected exit $1, got $RC — out='$OUT' err='$(printf '%s' "$ERR" | tr '\n' ' ')'"
    return
  fi
  if [ -n "$OUT" ]; then
    bad "$5" "a rejection printed '$OUT' on stdout — a classification must never accompany a failure"
    return
  fi
  case "$ERR" in
    *"$2"*) ok "$5" ;;
    *) bad "$5" "diagnostic does not name '$2' — got: $(printf '%s' "$ERR" | tr '\n' ' ')" ;;
  esac
}

# ============================================================ L — the legal matrix
echo "=== L — the four accepted classifications ==="
CO="$(new_checkout)"

write_open   "$CO" l1-active-claude   active  claude
write_open   "$CO" l2-active-codex    active  codex
write_open   "$CO" l3-blocked         blocked operator
write_closed "$CO" l4-closed
write_open   "$CO" l5-brief           active  claude yes

expect_class ACTIVE_CLAUDE    "$CO" l1-active-claude "L1  active/claude   -> ACTIVE_CLAUDE"
expect_class ACTIVE_CODEX     "$CO" l2-active-codex  "L2  active/codex    -> ACTIVE_CODEX"
expect_class BLOCKED_OPERATOR "$CO" l3-blocked       "L3  blocked/operator-> BLOCKED_OPERATOR"
expect_class CLOSED           "$CO" l4-closed        "L4  closed/operator -> CLOSED"
expect_class ACTIVE_CLAUDE    "$CO" l5-brief         "L5  the optional ## Brief does not become a sixth state field"

# Exactly one word, one line. Consumers will branch on this string.
run "$CO" l1-active-claude
[ "$(printf '%s\n' "$OUT" | wc -l | tr -d ' ')" = "1" ] \
  && ok "L6  success prints exactly one line" \
  || bad "L6  success prints exactly one line" "got: $OUT"
[ -z "$ERR" ] \
  && ok "L7  success writes nothing to stderr" \
  || bad "L7  success writes nothing to stderr" "got: $ERR"

# ============================================================ I — identity and path
echo
echo "=== I — identity, path bounds and symlinks ==="

expect_reject 13 "does not exist" "$CO" i1-absent \
  "I1  a missing state file is rejected"

write_open "$CO" i2-mismatch active claude
# ONE mutation from the L1 fixture: the frontmatter id no longer matches the path.
sed 's/^task: i2-mismatch$/task: some-other-task/' "$CO/logs/work-loop/i2-mismatch.md" >"$CO/logs/work-loop/i2-mismatch.tmp"
mv "$CO/logs/work-loop/i2-mismatch.tmp" "$CO/logs/work-loop/i2-mismatch.md"
expect_reject 14 "identity mismatch" "$CO" i2-mismatch \
  "I2  frontmatter task: disagreeing with the path is rejected"

expect_reject 12 "path traversal or separator" "$CO" '../escape' \
  "I3  a traversing task id is rejected before any path is built"
expect_reject 12 "illegal characters" "$CO" 'has space' \
  "I4  an illegal task id is rejected"
expect_reject 11 "not a directory" "$SANDBOX_ROOT/no-such-checkout" l1-active-claude \
  "I5  a missing checkout is rejected"

# The symlink case, and it matters: `-f` follows links, so without an explicit
# -L test a symlinked state path would validate against bytes from outside the
# checkout. The target here is a VALID record, so only the link is the fault.
ln -s "$CO/logs/work-loop/l1-active-claude.md" "$CO/logs/work-loop/i6-symlink.md"
expect_reject 13 "symlink" "$CO" i6-symlink \
  "I6  a symlinked state path is rejected even when its target is valid"

# The same bytes at a real path DO validate — which is what makes I6 a statement
# about the link rather than about the content.
cp "$CO/logs/work-loop/l1-active-claude.md" "$CO/logs/work-loop/i7-real.md"
sed 's/^task: l1-active-claude$/task: i7-real/' "$CO/logs/work-loop/i7-real.md" >"$CO/logs/work-loop/i7.tmp"
mv "$CO/logs/work-loop/i7.tmp" "$CO/logs/work-loop/i7-real.md"
expect_class ACTIVE_CLAUDE "$CO" i7-real \
  "I7  the same content at a real path validates (I6 is about the link, not the bytes)"

# A symlinked logs/work-loop, which the per-file -L test cannot see.
CO_SD="$(new_checkout)"
REAL_DIR="$(mktemp -d "$SANDBOX_ROOT/elsewhere.XXXXXX")"
rmdir "$CO_SD/logs/work-loop"
ln -s "$REAL_DIR" "$CO_SD/logs/work-loop"
write_open "$CO_SD" i8-sdir active claude
expect_reject 13 "resolves outside the checkout" "$CO_SD" i8-sdir \
  "I8  a symlinked logs/work-loop directory is rejected"

chmod 000 "$CO/logs/work-loop/i7-real.md" 2>/dev/null
if [ -r "$CO/logs/work-loop/i7-real.md" ]; then
  ok "I9  unreadable-file case skipped (this user can read mode 000)"
else
  expect_reject 13 "not readable" "$CO" i7-real "I9  an unreadable state file is rejected"
fi
chmod 644 "$CO/logs/work-loop/i7-real.md" 2>/dev/null

# ============================================================ F — frontmatter
echo
echo "=== F — frontmatter block, keys, values and combinations ==="

mutate() { # task sed-expr  — one edit against a freshly written legal open record
  local t="$1" expr="$2"
  write_open "$CO" "$t" active claude
  sed "$expr" "$CO/logs/work-loop/$t.md" >"$CO/logs/work-loop/$t.tmp"
  mv "$CO/logs/work-loop/$t.tmp" "$CO/logs/work-loop/$t.md"
}

# The legal base for every F case, asserted here so each rejection below is
# attributable to its single mutation.
write_open "$CO" f0-base active claude
expect_class ACTIVE_CLAUDE "$CO" f0-base "F0  the unmutated base record passes (the control for F1..F12)"

printf '## Objective and scope\nno frontmatter at all\n' >"$CO/logs/work-loop/f1-nofm.md"
expect_reject 15 "line 1" "$CO" f1-nofm "F1  a file with no frontmatter is rejected"

mutate f2-unterminated '5s/^---$/still frontmatter/'
expect_reject 15 "unterminated frontmatter" "$CO" f2-unterminated "F2  an unterminated frontmatter block is rejected"

mutate f3-unknownkey 's/^status: active$/status: active\nphase: execution/'
expect_reject 15 "unsupported frontmatter key" "$CO" f3-unknownkey "F3  an unsupported frontmatter key is rejected"

mutate f4-dupe 's/^turn: claude$/turn: claude\nturn: codex/'
expect_reject 15 "exactly once" "$CO" f4-dupe "F4  a duplicated frontmatter key is rejected"

mutate f5-nostatus '/^status: active$/d'
expect_reject 15 "'status' is missing" "$CO" f5-nostatus "F5  a missing status: key is rejected"

mutate f6-noturn '/^turn: claude$/d'
expect_reject 15 "'turn' is missing" "$CO" f6-noturn "F6  a missing turn: key is rejected"

mutate f7-badstatus 's/^status: active$/status: paused/'
expect_reject 15 "not one of active" "$CO" f7-badstatus "F7  an unknown status value is rejected"

mutate f8-badturn 's/^turn: claude$/turn: nobody/'
expect_reject 15 "not one of claude" "$CO" f8-badturn "F8  an unknown turn value is rejected"

mutate f9-junkline 's/^status: active$/status: active\nthis is not a key value pair/'
expect_reject 15 "not a 'key: value' pair" "$CO" f9-junkline "F9  a non key:value frontmatter line is rejected"

# The illegal status/turn pairs, enumerated. active/operator is the one the old
# runtime produced constantly — turn: operator used to MEAN closed — so it is the
# combination most likely to arrive from a half-migrated record.
mutate f10-active-operator 's/^turn: claude$/turn: operator/'
expect_reject 15 "illegal combination" "$CO" f10-active-operator "F10 active/operator is rejected"

mutate f11-blocked-claude 's/^status: active$/status: blocked/'
expect_reject 15 "illegal combination" "$CO" f11-blocked-claude "F11 blocked/claude is rejected"

mutate f12-closed-codex 's/^status: active$/status: closed/;s/^turn: claude$/turn: codex/'
expect_reject 15 "illegal combination" "$CO" f12-closed-codex "F12 closed/codex is rejected"

# ============================================================ B — body contract
echo
echo "=== B — body headings, order and required content ==="

write_open "$CO" b0-base active claude
expect_class ACTIVE_CLAUDE "$CO" b0-base "B0  the unmutated open base passes (the control for B1..B7)"

mutate b1-missing '/^## Blocker$/d;/^None\.$/d'
expect_reject 16 "'## Blocker' is missing" "$CO" b1-missing "B1  a missing state heading is rejected by name"

# Swap Latest result and Blocker: every heading is present, only the order moved.
write_open "$CO" b2-order active claude
awk '
  /^## Latest result$/ { print "## Blocker"; print "None."; print ""; skip=1; next }
  /^## Blocker$/ { print "## Latest result"; print "Not started."; print ""; skip=1; next }
  skip && /^## / { skip=0 }
  skip { next }
  { print }
' "$CO/logs/work-loop/b2-order.md" >"$CO/logs/work-loop/b2.tmp"
mv "$CO/logs/work-loop/b2.tmp" "$CO/logs/work-loop/b2-order.md"
expect_reject 16 "out of order" "$CO" b2-order "B2  the five state headings out of order are rejected"

mutate b3-extra 's/^## Next action$/## Notes\nSomething extra.\n\n## Next action/'
expect_reject 16 "unsupported top-level heading" "$CO" b3-extra "B3  an unsupported top-level heading is rejected"

mutate b4-emptyresult '/^Not started\.$/d'
expect_reject 16 "'## Latest result' is empty" "$CO" b4-emptyresult "B4  an empty Latest result is rejected"

mutate b5-emptynext '/^Claude: run the fixture unit\.$/d'
expect_reject 16 "'## Next action' is empty" "$CO" b5-emptynext "B5  an empty Next action is rejected"

# blocked + "None." — the record's lifecycle disagrees with itself.
write_open "$CO" b6-blocked-none blocked operator
sed 's/^Waiting on the operator to choose the retention window\.$/None./' \
  "$CO/logs/work-loop/b6-blocked-none.md" >"$CO/logs/work-loop/b6.tmp"
mv "$CO/logs/work-loop/b6.tmp" "$CO/logs/work-loop/b6-blocked-none.md"
expect_reject 16 "says 'None.'" "$CO" b6-blocked-none "B6  blocked with a 'None.' blocker is rejected"

write_open "$CO" b7-blocked-empty blocked operator
sed '/^Waiting on the operator to choose the retention window\.$/d' \
  "$CO/logs/work-loop/b7-blocked-empty.md" >"$CO/logs/work-loop/b7.tmp"
mv "$CO/logs/work-loop/b7.tmp" "$CO/logs/work-loop/b7-blocked-empty.md"
expect_reject 16 "'## Blocker' is empty" "$CO" b7-blocked-empty "B7  blocked with an empty blocker is rejected"

# An ACTIVE record keeps None. — B6 must be about blocked, not about the string.
expect_class ACTIVE_CLAUDE "$CO" l1-active-claude "B8  an active record may still say 'None.' (B6 is about blocked)"

# ---- closed-shape cases, controlled by their own base
write_closed "$CO" c0-base
expect_class CLOSED "$CO" c0-base "C0  the unmutated closed base passes (the control for C1..C4)"

write_closed "$CO" c1-activehead
sed 's/^## Outcome$/## Objective and scope/' "$CO/logs/work-loop/c1-activehead.md" >"$CO/logs/work-loop/c1.tmp"
mv "$CO/logs/work-loop/c1.tmp" "$CO/logs/work-loop/c1-activehead.md"
expect_reject 16 "unsupported top-level heading" "$CO" c1-activehead "C1  an active heading surviving in a closed record is rejected"

write_closed "$CO" c2-missing
sed '/^## Accepted limitations$/,$d' "$CO/logs/work-loop/c2-missing.md" >"$CO/logs/work-loop/c2.tmp"
mv "$CO/logs/work-loop/c2.tmp" "$CO/logs/work-loop/c2-missing.md"
expect_reject 16 "'## Accepted limitations' is missing" "$CO" c2-missing "C2  a missing closing heading is rejected by name"

write_closed "$CO" c3-brief
sed 's/^## Evidence$/## Brief\nA leftover handoff.\n\n## Evidence/' "$CO/logs/work-loop/c3-brief.md" >"$CO/logs/work-loop/c3.tmp"
mv "$CO/logs/work-loop/c3.tmp" "$CO/logs/work-loop/c3-brief.md"
expect_reject 16 "closed record carries '## Brief'" "$CO" c3-brief "C3  a closed record carrying ## Brief is rejected"

# The five open headings under status: closed — the shape/lifecycle disagreement
# the old runtime could not detect at all, because it read turn: operator alone.
write_open "$CO" c4-openbody active claude
sed 's/^status: active$/status: closed/;s/^turn: claude$/turn: operator/' \
  "$CO/logs/work-loop/c4-openbody.md" >"$CO/logs/work-loop/c4.tmp"
mv "$CO/logs/work-loop/c4.tmp" "$CO/logs/work-loop/c4-openbody.md"
expect_reject 16 "unsupported top-level heading" "$CO" c4-openbody \
  "C4  status: closed with an open five-heading body is rejected"

# A fenced ``` block quoting a heading is documentation, not a state field.
write_open "$CO" b9-fenced active claude
awk '/^## Latest result$/ { print "## Brief"; print "The closing record looks like this:"; print "```markdown"; print "## Outcome"; print "## Evidence"; print "```"; print "" } { print }' \
  "$CO/logs/work-loop/b9-fenced.md" >"$CO/logs/work-loop/b9.tmp"
mv "$CO/logs/work-loop/b9.tmp" "$CO/logs/work-loop/b9-fenced.md"
expect_class ACTIVE_CLAUDE "$CO" b9-fenced "B9  headings quoted inside a fenced block are not state headings"

# ============================================================ R — read-only
echo
echo "=== R — the validator writes nothing, and every named consumer calls it ==="

manifest() { # dir -> sorted "mode size sha path" for every entry
  ( cd "$1" && find . -print0 | LC_ALL=C sort -z | while IFS= read -r -d '' p; do
      if [ -f "$p" ] && [ ! -L "$p" ]; then
        printf '%s %s\n' "$(shasum -a 256 "$p" 2>/dev/null | awk '{print $1}')" "$p"
      else
        printf 'DIRORLINK %s\n' "$p"
      fi
    done )
}

CO_RO="$(new_checkout)"
write_open   "$CO_RO" r1-active active claude
write_closed "$CO_RO" r1-closed
printf -- '---\nbroken\n' >"$CO_RO/logs/work-loop/r1-broken.md"

BEFORE="$(manifest "$CO_RO")"
bash "$STATE_BIN" validate --checkout "$CO_RO" --task r1-active >/dev/null 2>&1
bash "$STATE_BIN" validate --checkout "$CO_RO" --task r1-closed >/dev/null 2>&1
bash "$STATE_BIN" validate --checkout "$CO_RO" --task r1-broken >/dev/null 2>&1
bash "$STATE_BIN" validate --checkout "$CO_RO" --task r1-absent >/dev/null 2>&1
AFTER="$(manifest "$CO_RO")"

[ "$BEFORE" = "$AFTER" ] \
  && ok "R1  the checkout is byte-identical after success and after failure" \
  || bad "R1  the checkout is byte-identical after success and after failure" \
         "$(diff <(printf '%s\n' "$BEFORE") <(printf '%s\n' "$AFTER") | head -5 | tr '\n' ' ')"

# The manifest itself must be capable of noticing a change, or R1 proves nothing.
printf 'x\n' >>"$CO_RO/logs/work-loop/r1-active.md"
[ "$(manifest "$CO_RO")" != "$BEFORE" ] \
  && ok "R2  the byte-identical check can detect a change (R1 is fail-capable)" \
  || bad "R2  the byte-identical check can detect a change" "an appended byte went unnoticed"

# THE SEAM IS ACTIVE FROM THE TRACER 3 CUTOVER, AND THIS IS THE ASSERTION THAT
# SAYS SO. Until that commit this row read the other way — "no runtime consumer
# calls the validator yet" — because the validator had to be proven against
# adversarial fixtures before anything stopped understanding the old shape (plan
# § 2, dependency 2). That preparation is spent: the inactive seam was the thing
# Tracer 3 exists to close, so an inactive-seam assertion surviving the cutover
# would assert the state the cutover removed.
#
# Inverted rather than deleted, and the direction matters. A deleted row proves
# nothing afterwards; this one now fails if any named consumer QUIETLY DROPS the
# validator and goes back to reading state itself, which is the regression the
# whole cutover is exposed to.
#
# THE LIST IS EXPLICIT, not discovered. A discovered list would pass the moment
# every file that happens to mention the validator mentions it — including none
# of the ones that matter. These are the plan-named production lifecycle
# consumers, each of which must obtain classification from the validator.
REQUIRED_CALLERS='
logs/scripts/work-loop-owner.sh
scripts/axcion-harness-v0.2/carry-turn.sh
plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh
.claude/commands/work-loop-v2.md
.agents/skills/work-loop-v2/SKILL.md
.agents/skills/reorient/SKILL.md
plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
'
MISSING=""
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  if [ ! -f "$REPO_ROOT/$rel" ]; then
    MISSING="$MISSING $rel(absent)"
  elif ! grep -q 'work-loop-state\.sh' "$REPO_ROOT/$rel" 2>/dev/null; then
    MISSING="$MISSING $rel"
  fi
done <<EOF
$REQUIRED_CALLERS
EOF
[ -z "$MISSING" ] \
  && ok "R3  every plan-named production consumer obtains lifecycle from the validator" \
  || bad "R3  every plan-named production consumer obtains lifecycle from the validator" \
         "not delegating:$MISSING"

# Delegating is only half of it. A consumer can call the validator AND keep the
# parser it used to decide with, and the fallback is what makes a cutover partial
# — two readings of one record, disagreeing under exactly the conditions the
# explicit contract was introduced to settle. These are the two private readings
# Tracer 3 removed by name: work-loop-owner.sh's `turn: operator` closure test,
# and both transports' closing-record test by heading sequence.
retired_parsers() { # file -> prints each retired construct found
  grep -nE 'task_is_closed|\$\(printf .## Outcome' "$1" 2>/dev/null
}
LEFTOVER=""
for rel in logs/scripts/work-loop-owner.sh \
           scripts/axcion-harness-v0.2/carry-turn.sh \
           plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh; do
  [ -f "$REPO_ROOT/$rel" ] || continue
  hit="$(retired_parsers "$REPO_ROOT/$rel")"
  [ -n "$hit" ] && LEFTOVER="$LEFTOVER $rel:$(printf '%s' "$hit" | head -1 | cut -d: -f1)"
done
[ -z "$LEFTOVER" ] \
  && ok "R4  no production consumer retains a private lifecycle parser" \
  || bad "R4  no production consumer retains a private lifecycle parser" "found:$LEFTOVER"

# R4 is a positive-absence check, so its detector must be shown to detect. Without
# this control R4 would pass just as happily against a broken pattern.
CTRL="$SANDBOX_ROOT/retired-parser-control.sh"
{
  printf 'task_is_closed() { :; }\n'
  printf 'heads_ok() { [ "$heads" = "$(printf %s)" ]; }\n' "'## Outcome\\n## Decisions that matter'"
} >"$CTRL"
[ -n "$(retired_parsers "$CTRL")" ] \
  && ok "R5  the retired-parser detector detects them (R4 is fail-capable)" \
  || bad "R5  the retired-parser detector detects them" "the control file went unnoticed"

# ============================================================ P — consumer consistency
echo
echo "=== P — every cut-over consumer agrees with the validator ==="
#
# WHAT THIS SECTION USED TO PROVE, AND WHY IT NO LONGER CAN. Before Tracer 3 this
# was the plan's riskiest early assumption (§ 2, risky assumption 1): records
# could gain `status` BEFORE cutover without breaking the old runtime. That
# premise bought Tracer 2 its safe migration order, it was proven here against
# the real helpers, and it is now spent — the old runtime it measured was
# replaced by the cutover, so those rows would test consumers that no longer
# exist.
#
# WHAT REPLACES IT is the risk the cutover actually carries. Four consumers now
# read one classifier, each translating into its own vocabulary — the validator's
# word, the dispatcher's `turn=`, the carrier's actor routing, the owner helper's
# verdict. A translation is where two consumers can silently diverge, so the
# agreement is measured on one record at a time rather than assumed from the fact
# that they all call the same script.
#
# Real binaries throughout, on real git checkouts, through each consumer's own
# READ-ONLY entry: the dispatcher's --status, the carrier's --dry-run, the owner
# helper's check. Nothing here launches an actor and nothing here mutates.

new_git_checkout() { # -> path on stdout
  local d
  d="$(mktemp -d "$SANDBOX_ROOT/gitco.XXXXXX")"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts"
  git -C "$d" init -q
  git -C "$d" symbolic-ref HEAD refs/heads/main
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name harness
  cp "$REPO_ROOT/.gitignore" "$d/.gitignore" 2>/dev/null || true
  printf 'sandbox\n' >"$d/README.md"
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh" 2>/dev/null || true
  # dispatch.sh resolves the shared lease library as $CHECKOUT/logs/scripts/
  # work-loop-lease.sh and dies at exit 11 without it — BEFORE it ever parses a
  # state file. P5 therefore reported a lease-library error rather than a verdict
  # on status-augmented parsing, so it could not discriminate at all.
  cp "$REPO_ROOT/logs/scripts/work-loop-lease.sh" "$d/logs/scripts/work-loop-lease.sh" 2>/dev/null || true
  # Since the cutover every consumer resolves the validator out of the checkout it
  # was pointed at. Without this copy each of them refuses for a missing file, and
  # the section would measure the harness rather than the agreement.
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh" 2>/dev/null || true
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  (cd "$d" && pwd -P)
}

commit_gco() { # checkout task
  git -C "$1" add -A >/dev/null 2>&1
  git -C "$1" commit -qm "state $2" >/dev/null 2>&1
}

# The consumers under test, each through its own read-only entry. Missing ones are
# reported rather than skipped: a silently absent consumer is an unmeasured one.
consumer_reads() { # checkout task -> "dispatch=<line> carry=<line>"
  local co="$1" t="$2" d_out c_out
  d_out="$(bash "$DISPATCH_BIN" --status --checkout "$co" --task "$t" 2>&1)"
  c_out="$(bash "$CARRY_BIN" --checkout "$co" --task "$t" --dry-run 2>&1)"
  printf 'DISPATCH<<%s>>CARRY<<%s>>' "$d_out" "$c_out"
}

# ---- P1..P4: one row per classification, three consumers each ----------------
#
# EVERY ROW IS A DIFFERENT RECORD, not the same record re-labelled, so a consumer
# that hardcodes one answer fails three of the four. The blocked/closed pair is
# the one that matters most: both are `turn: operator`, they differ only by
# `status:`, and before the cutover the consumers told them apart by whether the
# body still had a `## Blocker` — the inference Tracer 3 removed.
p_row() { # n class status turn dispatch-turn carry-marker owner-rc owner-marker
  local n="$1" class="$2" st="$3" tu="$4" dturn="$5" cmark="$6" orc="$7" omark="$8"
  local co reads o_out o_rc
  co="$(new_git_checkout)"
  if [ "$st" = closed ]; then write_closed "$co" p-rec; else write_open "$co" p-rec "$st" "$tu"; fi
  printf 'p-rec\n' >"$co/logs/work-loop/.owner"
  commit_gco "$co" p-rec

  expect_class "$class" "$co" p-rec "$n.a validator classifies the record $class"

  reads="$(consumer_reads "$co" p-rec)"
  case "$reads" in
    *"DISPATCH<<"*"turn=$dturn"*) ok "$n.b dispatch.sh --status translates $class to turn=$dturn" ;;
    *) bad "$n.b dispatch.sh --status translates $class to turn=$dturn" \
           "got: $(printf '%s' "$reads" | tr '\n' ' ' | cut -c1-200)" ;;
  esac
  case "$reads" in
    *"CARRY<<"*"$cmark"*) ok "$n.c carry-turn.sh --dry-run translates $class to '$cmark'" ;;
    *) bad "$n.c carry-turn.sh --dry-run translates $class to '$cmark'" \
           "got: $(printf '%s' "$reads" | sed 's/.*CARRY<<//' | tr '\n' ' ' | cut -c1-200)" ;;
  esac

  # The owner helper is asked about a DIFFERENT task, which is the only question
  # that makes it classify the declaring record rather than match on the id.
  o_out="$(bash "$OWNER_BIN" check --checkout "$co" --task p-other --depth local 2>&1)"; o_rc=$?
  if [ "$o_rc" -eq "$orc" ] && case "$o_out" in *"$omark"*) true ;; *) false ;; esac; then
    ok "$n.d work-loop-owner.sh translates $class to rc=$orc ('$omark')"
  else
    bad "$n.d work-loop-owner.sh translates $class to rc=$orc ('$omark')" \
        "rc=$o_rc out: $(printf '%s' "$o_out" | tr '\n' ' ' | cut -c1-200)"
  fi
}

CARRY_BIN="${CARRY_BIN:-$REPO_ROOT/scripts/axcion-harness-v0.2/carry-turn.sh}"
for b in "$DISPATCH_BIN" "$CARRY_BIN" "$OWNER_BIN"; do
  [ -f "$b" ] || bad "P0  every consumer under test is present" "missing: $b"
done

p_row P1 ACTIVE_CLAUDE    active  claude   claude   "actor 'claude'"    3 "open task 'p-rec'"
p_row P2 ACTIVE_CODEX     active  codex    codex    "actor 'codex'"     3 "open task 'p-rec'"
p_row P3 BLOCKED_OPERATOR blocked operator operator "UNANSWERED"        3 "BLOCKED_OPERATOR"
p_row P4 CLOSED           closed  operator operator "task is CLOSED"    0 "CLOSED"

# ---- P5: the illegal records stop every consumer, and none of them writes -----
#
# Five shapes, each the plan's named refusal condition: missing status,
# contradictory status/turn, identity mismatch, an unsupported status value, and
# a body that does not match its status. A consumer that "helpfully" resolved any
# of these would be reintroducing the inference the cutover removed, one record
# at a time.
p_neg() { # n label mutate-fn
  local n="$1" label="$2" fn="$3" co before after d_rc c_rc o_rc
  co="$(new_git_checkout)"
  write_open "$co" p-bad active claude
  "$fn" "$co/logs/work-loop/p-bad.md"
  printf 'p-bad\n' >"$co/logs/work-loop/.owner"
  commit_gco "$co" p-bad

  bash "$STATE_BIN" validate --checkout "$co" --task p-bad >/dev/null 2>&1
  [ $? -ne 0 ] || { bad "$n.a the validator refuses $label" "it returned 0"; return; }
  ok "$n.a the validator refuses $label"

  # Scoped to the STATE surface on purpose. A whole-checkout manifest would also
  # capture the run log and the lease directory under .git, which a refusing run
  # legitimately creates before it ever reads the record — so it would go red for
  # the transports doing their job rather than for a mutation.
  before="$(manifest "$co/logs/work-loop")"
  bash "$DISPATCH_BIN" --checkout "$co" --task p-bad --log-dir "$co/runs" --dry-run >/dev/null 2>&1; d_rc=$?
  bash "$CARRY_BIN" --checkout "$co" --task p-bad --dry-run >/dev/null 2>&1; c_rc=$?
  bash "$OWNER_BIN" check --checkout "$co" --task p-other --depth local >/dev/null 2>&1; o_rc=$?
  after="$(manifest "$co/logs/work-loop")"

  [ "$d_rc" -ne 0 ] && [ "$c_rc" -ne 0 ] \
    && ok "$n.b both transports stop before launch on $label (dispatch=$d_rc carry=$c_rc)" \
    || bad "$n.b both transports stop before launch on $label" "dispatch=$d_rc carry=$c_rc"

  # AMBIGUOUS, not REFUSE: an unclassifiable declaration is neither open enough to
  # refuse on nor closed enough to clear, and the helper says so rather than
  # picking one.
  [ "$o_rc" -eq 4 ] \
    && ok "$n.c work-loop-owner.sh is AMBIGUOUS on $label, so nothing is claimed or cleared" \
    || bad "$n.c work-loop-owner.sh is AMBIGUOUS on $label" "rc=$o_rc"

  [ "$before" = "$after" ] \
    && ok "$n.d no consumer mutated the checkout while refusing $label" \
    || bad "$n.d no consumer mutated the checkout while refusing $label" \
           "$(diff <(printf '%s\n' "$before") <(printf '%s\n' "$after") | head -4 | tr '\n' ' ')"
}

drop_status()    { grep -v '^status: ' "$1" >"$1.t" && mv "$1.t" "$1"; }
contradict()     { sed 's/^turn: claude$/turn: operator/' "$1" >"$1.t" && mv "$1.t" "$1"; }
mismatch_id()    { sed 's/^task: p-bad$/task: p-somethingelse/' "$1" >"$1.t" && mv "$1.t" "$1"; }
unsupported()    { sed 's/^status: active$/status: paused/' "$1" >"$1.t" && mv "$1.t" "$1"; }
wrong_body()     { sed 's/^status: active$/status: closed/' "$1" >"$1.t" && mv "$1.t" "$1"; }

p_neg P5 "a missing status: key"               drop_status
p_neg P6 "a contradictory active/operator pair" contradict
p_neg P7 "an identity mismatch"                 mismatch_id
p_neg P8 "an unsupported status value"          unsupported
p_neg P9 "a closed status over an active body"  wrong_body

# ============================================================ X — execution surface
echo
echo "=== X — usage and execution ==="

[ -x "$STATE_BIN" ] && ok "X1  the validator is executable" || bad "X1  the validator is executable" "chmod +x is missing"

"$STATE_BIN" validate --checkout "$CO" --task l1-active-claude >/dev/null 2>&1
[ "$?" -eq 0 ] && ok "X2  direct execution via the shebang works" || bad "X2  direct execution via the shebang works"

bash "$STATE_BIN" >/dev/null 2>&1; [ "$?" -eq 10 ] && ok "X3  no arguments exits BAD_USAGE (10)" || bad "X3  no arguments exits BAD_USAGE (10)"
bash "$STATE_BIN" classify --checkout "$CO" --task l1-active-claude >/dev/null 2>&1
[ "$?" -eq 10 ] && ok "X4  an unknown command exits BAD_USAGE (10)" || bad "X4  an unknown command exits BAD_USAGE (10)"
bash "$STATE_BIN" validate --task l1-active-claude >/dev/null 2>&1
[ "$?" -eq 10 ] && ok "X5  a missing --checkout exits BAD_USAGE (10)" || bad "X5  a missing --checkout exits BAD_USAGE (10)"
bash "$STATE_BIN" validate --checkout "$CO" >/dev/null 2>&1
[ "$?" -eq 10 ] && ok "X6  a missing --task exits BAD_USAGE (10)" || bad "X6  a missing --task exits BAD_USAGE (10)"

# The repository's Bash baseline is 3.2 (macOS /bin/bash). Bash-4-only syntax
# would fail here at parse time, before any test ran.
bash -n "$STATE_BIN" 2>/dev/null && ok "X7  the validator parses under this repository's Bash baseline" \
                                 || bad "X7  the validator parses under this repository's Bash baseline"

# A path with a space is the ordinary case in this workspace ("Claude Code").
CO_SP="$(mktemp -d "$SANDBOX_ROOT/with space.XXXXXX")"
mkdir -p "$CO_SP/logs/work-loop"
CO_SP="$(cd "$CO_SP" && pwd -P)"
write_open "$CO_SP" x8-space active claude
expect_class ACTIVE_CLAUDE "$CO_SP" x8-space "X8  a checkout path containing a space works"

# A DANGLING option — the value-taking flag is the last argument, so its value
# is missing rather than merely absent from the invocation. Correction round,
# 2026-08-14: `shift 2` past the end of the positional list is a Bash no-op, not
# an error, so the loop never advanced and spun forever instead of reaching the
# "is required" check. Each case is run with a background timeout because a
# regression here hangs the test process itself rather than failing it.
# Sets HX_STATUS to "RC=<n>" or "HUNG", and HX_DIAG to whatever the process
# printed. Kept as two variables rather than one encoded string, so a
# diagnostic that happens to contain "RC=" can never be misread as the signal.
HX_STATUS=""; HX_DIAG=""
hangs_or_exits() { # args...
  local diagfile rc
  diagfile="$(mktemp "$SANDBOX_ROOT/hx.XXXXXX")"
  bash "$STATE_BIN" "$@" >"$diagfile" 2>&1 &
  local pid=$!
  ( sleep 5; kill -9 "$pid" 2>/dev/null ) &
  local watchdog=$!
  if wait "$pid" 2>/dev/null; then rc=0; else rc=$?; fi
  kill "$watchdog" 2>/dev/null; wait "$watchdog" 2>/dev/null
  HX_DIAG="$(cat "$diagfile")"; rm -f "$diagfile"
  if [ "$rc" -eq 137 ] || [ "$rc" -eq 143 ]; then HX_STATUS="HUNG"; else HX_STATUS="RC=$rc"; fi
}

hangs_or_exits validate --checkout
case "$HX_STATUS" in
  RC=10) ok "X9  a dangling --checkout (no value) exits BAD_USAGE (10), not a hang" ;;
  HUNG)  bad "X9  a dangling --checkout (no value) exits BAD_USAGE (10), not a hang" "the process hung and was killed by the watchdog" ;;
  *)     bad "X9  a dangling --checkout (no value) exits BAD_USAGE (10), not a hang" "got $HX_STATUS — $HX_DIAG" ;;
esac

hangs_or_exits validate --checkout "$CO" --task
case "$HX_STATUS" in
  RC=10) ok "X10 a dangling --task (no value) exits BAD_USAGE (10), not a hang" ;;
  HUNG)  bad "X10 a dangling --task (no value) exits BAD_USAGE (10), not a hang" "the process hung and was killed by the watchdog" ;;
  *)     bad "X10 a dangling --task (no value) exits BAD_USAGE (10), not a hang" "got $HX_STATUS — $HX_DIAG" ;;
esac

# ================================================================== summary
echo
echo "=============================================================="
printf ' L + I + F + B/C + R + P + X: %d passed, %d failed\n' "$PASS" "$FAIL"
echo "=============================================================="
[ "$FAIL" -eq 0 ] || exit 1
