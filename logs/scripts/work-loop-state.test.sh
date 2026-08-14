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
echo "=== R — the validator writes nothing, and no consumer calls it yet ==="

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

# The seam is inactive at this commit. If a consumer starts calling the validator,
# this assertion is the one that must be updated deliberately — in Tracer 3.
#
# RUNTIME surfaces only: shell scripts, plus the instruction files that ARE the
# Claude command, the Codex skill and the Codex hooks. Logs, reports and plans are
# excluded on purpose — a report that discusses the validator is not a consumer,
# and an earlier version that searched every .md failed on a hook-written write-
# activity log and on a v1 file whose name merely ends in `work-loop-state.sh`.
# `/work-loop-state.sh` is anchored for the same reason.
runtime_mentions() {
  grep -rl '/work-loop-state\.sh' "$REPO_ROOT" --include='*.sh' 2>/dev/null
  for d in "$REPO_ROOT/.claude" "$REPO_ROOT/.agents" "$REPO_ROOT/.codex"; do
    [ -d "$d" ] && grep -rl '/work-loop-state\.sh' "$d" 2>/dev/null
  done
}
CALLERS="$(runtime_mentions \
          | grep -v 'work-loop-state\.sh$' \
          | grep -v 'work-loop-state\.test\.sh$' \
          | LC_ALL=C sort -u || true)"
[ -z "$CALLERS" ] \
  && ok "R3  no runtime consumer calls the validator yet (the seam is inactive)" \
  || bad "R3  no runtime consumer calls the validator yet" "callers: $(printf '%s' "$CALLERS" | tr '\n' ' ')"

# ============================================================ P — preparation compatibility
echo
echo "=== P — the still-live old consumers accept a status-augmented record ==="
#
# The plan's riskiest early assumption (§ 2, risky assumption 1): records can gain
# `status` BEFORE cutover without breaking the old runtime. If this is false,
# Tracer 2 has no safe migration order, so it is proven here against the real
# helpers rather than asserted.

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
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  (cd "$d" && pwd -P)
}

# OLD shape: task + turn only, no status. This is what every tracked record looks
# like today.
write_old_open() { # checkout task turn
  local d="$1" t="$2" tu="$3"
  {
    printf -- '---\ntask: %s\nturn: %s\n---\n\n' "$t" "$tu"
    printf -- '## Objective and scope\nA fixture objective.\n\n'
    printf -- '## Lane and unit\nStandard. Unit 1.\n\n'
    printf -- '## Latest result\nNot started.\n\n'
    printf -- '## Blocker\nNone.\n\n'
    printf -- '## Next action\nClaude: run the unit.\n'
  } >"$d/logs/work-loop/$t.md"
}

add_status() { # file value — inserts `status:` above the turn: line
  local f="$1" v="$2"
  awk -v v="$v" '!done && /^turn: / { print "status: " v; done=1 } { print }' "$f" >"$f.tmp" \
    && mv "$f.tmp" "$f"
}

GCO="$(new_git_checkout)"
write_old_open "$GCO" p-open codex
printf '%s %s\n' p-open 2026-08-14 >"$GCO/logs/work-loop/.owner"

P1_BEFORE="$(bash "$OWNER_BIN" check --checkout "$GCO" --task p-open --depth repo 2>&1)"; P1B_RC=$?
add_status "$GCO/logs/work-loop/p-open.md" active
P1_AFTER="$(bash "$OWNER_BIN" check --checkout "$GCO" --task p-open --depth repo 2>&1)"; P1A_RC=$?

[ "$P1B_RC" -eq "$P1A_RC" ] && [ "$P1_BEFORE" = "$P1_AFTER" ] \
  && ok "P1  work-loop-owner.sh gives an identical verdict with status: added (rc=$P1A_RC)" \
  || bad "P1  work-loop-owner.sh gives an identical verdict with status: added" \
         "before rc=$P1B_RC '$P1_BEFORE' / after rc=$P1A_RC '$P1_AFTER'"

# The augmented record must ALSO be valid under the new contract — that is the
# whole point of migrating before cutover rather than at it.
expect_class ACTIVE_CODEX "$GCO" p-open "P2  the status-augmented record is already valid under the new validator"

# The old closed-detection path: turn: operator means closed to the old helper.
# Adding status: closed must not disturb that, or migration would silently turn
# closed tasks back into open ones and lock their checkouts.
write_old_open "$GCO" p-closed-old operator
printf '%s %s\n' p-closed-old 2026-08-14 >"$GCO/logs/work-loop/.owner"
P3_BEFORE="$(bash "$OWNER_BIN" check --checkout "$GCO" --task p-other --depth local 2>&1)"; P3B_RC=$?
add_status "$GCO/logs/work-loop/p-closed-old.md" closed
P3_AFTER="$(bash "$OWNER_BIN" check --checkout "$GCO" --task p-other --depth local 2>&1)"; P3A_RC=$?

[ "$P3B_RC" -eq 0 ] && [ "$P3A_RC" -eq 0 ] && [ "$P3_BEFORE" = "$P3_AFTER" ] \
  && ok "P3  the old helper still reads a status-augmented record as closed (stale, clearable)" \
  || bad "P3  the old helper still reads a status-augmented record as closed" \
         "before rc=$P3B_RC '$P3_BEFORE' / after rc=$P3A_RC '$P3_AFTER'"

# P1 and P3 compare a before to an after, so they need the before to have been a
# real reading rather than an error both times.
case "$P1_BEFORE" in *PROCEED*) ok "P4  P1's baseline was a real verdict, not a failure on both sides" ;;
  *) bad "P4  P1's baseline was a real verdict" "got: $P1_BEFORE" ;; esac

# dispatch.sh --status is read-only and prints what it parsed. A second live
# consumer, chosen because it has its OWN frontmatter reader rather than sharing
# the owner helper's.
if [ -f "$DISPATCH_BIN" ]; then
  D_OUT="$(bash "$DISPATCH_BIN" --status --checkout "$GCO" --task p-open 2>&1)"
  case "$D_OUT" in
    *"turn=codex"*"task=p-open"*) ok "P5  dispatch.sh --status still parses the status-augmented record correctly" ;;
    *) bad "P5  dispatch.sh --status still parses the status-augmented record" "got: $(printf '%s' "$D_OUT" | tr '\n' ' ' | cut -c1-220)" ;;
  esac
else
  bad "P5  dispatch.sh --status still parses the status-augmented record" "dispatcher not found at $DISPATCH_BIN"
fi

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

# ================================================================== summary
echo
echo "=============================================================="
printf ' L + I + F + B/C + R + P + X: %d passed, %d failed\n' "$PASS" "$FAIL"
echo "=============================================================="
[ "$FAIL" -eq 0 ] || exit 1
