#!/bin/bash
# Focused failing-case harness for the Work Loop v2 handoff dispatcher spike.
#
# Every case here is SIMULATED: actors are replaced by --actor-cmd, so this
# harness proves controller logic only. It deliberately cannot prove live
# product transport — that is a separate, explicitly-labelled live run.
#
# ONE EXCEPTION TO "replaced by --actor-cmd", and it is not a relaxation. The
# cross-transport cases (12e) launch the ATTENDED CARRIER as well, and
# carry-turn.sh REFUSES --actor-cmd, --simulate and --fake-actor outright
# (carry-turn.sh 316-317). Its sanctioned test route is a stub binary passed
# with --claude-bin, which is how carry-turn.test.sh works. So those cases are
# still controller evidence with no real model involved — the seam is a
# different one because the other program's boundary says it must be.
#
# Case 0 is the harness's own falsifiability proof: it points the suite at an
# ABSENT dispatcher and asserts the suite fails. A harness that stays green with
# the thing under test removed is not evidence.
#
# Usage:  bash dispatch.test.sh
#         DISPATCH_BIN=/path/to/dispatch.sh bash dispatch.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISPATCH_BIN="${DISPATCH_BIN:-$HERE/dispatch.sh}"
# handoff-automation-spike -> work-loop-v2-v0.2 -> plans -> checkout root
REPO_ROOT="${REPO_ROOT:-$(cd "$HERE/../../.." && pwd)}"
OWNER_BIN="${OWNER_BIN:-$REPO_ROOT/logs/scripts/work-loop-owner.sh}"
# The shared live-lease library. Sourced by the dispatcher out of the CHECKOUT it
# drives — the same resolution the ownership helper uses — so every sandbox has
# to carry it for the same reason every sandbox carries the ownership helper.
LEASE_BIN="${LEASE_BIN:-$REPO_ROOT/logs/scripts/work-loop-lease.sh}"
# The canonical state validator. Since the Tracer 3 cutover the dispatcher asks it
# for the state's classification instead of reading `turn:` and the body headings
# itself, and fail-closes at exit 13 when it is absent. A sandbox without it is
# not modelling a real checkout.
STATE_BIN="${STATE_BIN:-$REPO_ROOT/logs/scripts/work-loop-state.sh}"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-dispatch-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()   { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

# ---------------------------------------------------------------- fixtures

# Writes a record that satisfies the contract work-loop-state.sh enforces:
# explicit `status`, one of the four legal status/turn pairs, and that pair's body
# shape. Before the Tracer 3 cutover this wrote a status-free record with the OPEN
# body for every turn, `operator` included — which the validator rejects, and
# rightly: a closing record is not an open record with the turn changed. Status is
# derived from the turn unless the caller states it.
state_file() { # dir task turn [declared-task] [status]
  local dir="$1" task="$2" turn="$3" declared="${4:-$2}" status="${5:-}" blocker
  if [ -z "$status" ]; then
    case "$turn" in
      codex|claude) status=active ;;
      operator)     status=closed ;;
    esac
  fi
  if [ "$status" = closed ]; then
    cat >"$dir/logs/work-loop/$task.md" <<EOF
---
task: $declared
status: closed
turn: operator
---

## Outcome
Sandbox fixture for the dispatcher harness. Closed record.

## Decisions that matter
Nothing real depends on this file.

## Evidence
Harness fixture — no commit.

## Accepted limitations
None.
EOF
    if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
      git -C "$dir" add "logs/work-loop/$task.md" >/dev/null 2>&1
      git -C "$dir" commit -qm "fixture: $task" >/dev/null 2>&1
    fi
    return 0
  fi
  blocker='None.'
  [ "$status" = blocked ] && blocker='Waiting on the operator to decide the fixture question.'
  cat >"$dir/logs/work-loop/$task.md" <<EOF
---
task: $declared
status: $status
turn: $turn
---

## Objective and scope
Sandbox fixture for the dispatcher harness. No real work.

## Lane and unit
Standard. Unit 1 — harness fixture.

## Latest result
Not started.

## Blocker
$blocker

## Next action
Harness fixture. Nothing real depends on this file.
EOF
  # Fixtures are committed, so "the state file is uncommitted" means what it
  # means in the live repo rather than being true of every fixture by default.
  if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$dir" add "logs/work-loop/$task.md" >/dev/null 2>&1
    git -C "$dir" commit -qm "fixture: $task" >/dev/null 2>&1
  fi
}

new_sandbox() { # -> path on stdout
  local d; d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts" \
           "$d/plans/work-loop-v2-v0.2/handoff-automation-spike"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name  harness
  printf 'sandbox\n' >"$d/README.md"
  printf 'unrelated tracked file\n' >"$d/other.txt"
  # The ownership helper ships inside a real checkout, and admission now FAILS
  # CLOSED without it, so every sandbox must carry it or it is not modelling a
  # real checkout. Tracked, not dropped in loose, or the dispatcher would
  # correctly read it as an out-of-allowlist foreign file. Case 12d removes it
  # deliberately — that is the fail-closed case, and it must be the only one.
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh" 2>/dev/null || true
  # Same argument for the lease library, and the same single exception: case 12f
  # removes it deliberately, and that must be the only case without it.
  cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh" 2>/dev/null || true
  # And the validator, for the same reason and with the same single-exception rule.
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh" 2>/dev/null || true
  git -C "$d" add README.md other.txt logs/scripts 2>/dev/null
  git -C "$d" commit -qm "sandbox base"

  # The decoys. These mirror the live folder: files that advertise a turn and
  # would be picked up by any glob-and-guess dispatcher.
  state_file "$d" "decoy-alpha"   "codex"
  state_file "$d" "decoy-beta"    "claude"
  state_file "$d" "decoy-mismatch" "claude" "some-other-task"
  printf '%s' "$d"
}

# A simulated Claude commits the state file, because the real one does (core § 4).
# Appended to the actors below so the well-behaved cases are not tripped by the
# uncommitted-handback guard, which case 13 exercises on its own.
# `|| true` because these ping-pong actors sometimes flip the turn back to the
# committed value, leaving nothing to stage. That is a fixture artifact, not a
# failed commit — the dispatcher still sees a clean state file either way.
COMMIT_IF_CLAUDE='; if [ "$WL_ACTOR" = "claude" ]; then
        git -C "$WL_CHECKOUT" add "logs/work-loop/$WL_TASK.md" >/dev/null 2>&1;
        git -C "$WL_CHECKOUT" commit -qm "actor commit" >/dev/null 2>&1 || true; fi'

# Records which task an actor was invoked for, then flips the turn.
#
# ADDRESSED BY PATTERN, NOT BY LINE NUMBER. These actors used to rewrite line 3,
# which was `turn:` only because the frontmatter happened to be exactly two keys.
# The canonical contract adds `status:`, so line 3 is now `status:` and a
# position-addressed actor would corrupt the lifecycle instead of flipping the
# turn — silently, and in every case at once.
FLIP_BODY='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      t=$(sed -n "/^turn: /{p;q;}" "$WL_STATE_FILE");
      case "$t" in
        "turn: codex")  n="turn: claude" ;;
        "turn: claude") n="turn: codex"  ;;
        *) n="$t" ;;
      esac;
      awk -v n="$n" "/^turn: /&&!done{print n; done=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'

FLIP="$FLIP_BODY$COMMIT_IF_CLAUDE"

# Handing a record to the operator is a LIFECYCLE change, not just a turn change:
# the canonical contract has no active/operator pair, so an actor that rewrote
# only `turn:` would leave a record no consumer may act on. A real Claude closing
# write reduces the file to the closing record, and so does this one.
FLIP_TO_OPERATOR='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      d=$(sed -n "s/^task: //p" "$WL_STATE_FILE" | head -1);
      printf -- "---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n## Outcome\nHanded to the operator by the fixture actor.\n\n## Decisions that matter\nNothing real depends on this file.\n\n## Evidence\nHarness fixture.\n\n## Accepted limitations\nNone.\n" "$d" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"

NOOP='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; exit 0'

# The lease locations, mirrored from logs/scripts/work-loop-lease.sh — the shared
# library BOTH transports now source (dispatch.sh 671-697, carry-turn.sh 679-706).
# They moved out of ${TMPDIR} and into the repository's Git common directory, and
# the one composite checkout|task key became two independent leases — see the
# "lease" block in dispatch.sh for why. Defined ONCE here, above every user: six
# copies of the old expression had drifted into the suite, and each was a place
# this change could have been missed.
#
# Mirrored rather than imported, deliberately. Sourcing the library to assert the
# library's own output would make every assertion below true by construction: the
# oracle would move whenever the thing it checks moved. The mirror is the whole
# point, and it carries the matching hazard — if this and the two launchers ever
# disagree, the assertions pass against a directory neither launcher writes. Case
# 12e's controls are what catch that: each one requires the OTHER side to have
# really launched, which a phantom lease path cannot produce.
lock_root_for() { # checkout -> lock root dir
  local c g
  c="$(cd "$1" && pwd -P)"
  g="$(git -C "$c" rev-parse --git-common-dir 2>/dev/null)"
  case "$g" in /*) ;; *) g="$c/$g" ;; esac
  printf '%s/work-loop-dispatch-locks' "$(cd "$g" && pwd -P)"
}
task_lock_for() { # checkout task -> task lock dir
  printf '%s/task-%s.lock' "$(lock_root_for "$1")" \
    "$(printf '%s' "$2" | shasum -a 256 | cut -c1-16)"
}
checkout_lock_for() { # checkout -> checkout lock dir
  local c; c="$(cd "$1" && pwd -P)"
  printf '%s/checkout-%s.lock' "$(lock_root_for "$1")" \
    "$(printf '%s' "$c" | shasum -a 256 | cut -c1-16)"
}

# ------------------------------------------------------- the OTHER transport
# The attended carrier. Cross-transport contention cannot be proven by planting
# a lock directory: what is under test is precisely whether one program's code
# OBSERVES the lease the other program's code takes, so both sides are launched
# for real and each takes its own lease through its own acquire path.
CARRY_BIN="${CARRY_BIN:-$REPO_ROOT/scripts/axcion-harness-v0.2/carry-turn.sh}"

# THERE IS NO SEPARATE CARRIER ORACLE, and its absence is the point of this
# change. The carrier used to key ONE lock on the canonical checkout path under
# the caller's ${TMPDIR}; it now canonicalizes --checkout (carry-turn.sh 408) and
# hands it to wl_lease_init (696), exactly as the dispatcher does (503, 685). One
# derivation, so one mirror: task_lock_for and checkout_lock_for above answer for
# BOTH transports. A second carrier-shaped helper here would be the drift the
# shared library exists to remove.
#
# The carrier also still READS the old ${TMPDIR} lock for one release
# (legacy_lock_check, carry-turn.sh 724-741). That path is a refusal-only
# compatibility read, never a lease this suite plants or observes, so nothing
# below derives it.

# A stub `claude` for the carrier. It answers --version, because the carrier
# probes it before every launch; it records each REAL launch, which is what the
# "nothing was launched" assertions read; and it then does what a Claude hop
# does — move the turn and commit it (core § 4).
#
# The count is the load-bearing part. An exit code alone cannot separate "the
# lease refused this run" from "the run failed for some other reason", so every
# case below asserts the exit code AND that the actor never started.
make_carry_stub() { # path count-file state-file hold-secs
  cat >"$1" <<'STUB'
#!/bin/bash
COUNT="__COUNT__"; STATE="__STATE__"; HOLD="__HOLD__"
for a in "$@"; do [ "$a" = "--version" ] && { echo "carry-stub 0.0.1"; exit 0; }; done
printf 'x' >>"$COUNT"
[ "$HOLD" -gt 0 ] && sleep "$HOLD"
REPO="$(cd "$(dirname "$STATE")/../.." && pwd -P)"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$STATE" >"$STATE.tmp" && mv "$STATE.tmp" "$STATE"
printf '\ncarrier stub ran\n' >>"$STATE"
git -C "$REPO" add -- "logs/work-loop/$(basename "$STATE")" >/dev/null 2>&1
git -C "$REPO" commit -qm "carrier stub: handed on" >/dev/null 2>&1
printf '{"type":"result","subtype":"success","is_error":false,"result":"done","permission_denials":[]}\n'
exit 0
STUB
  sed -e "s|__COUNT__|$2|" -e "s|__STATE__|$3|" -e "s|__HOLD__|$4|" "$1" >"$1.tmp"
  mv "$1.tmp" "$1"
  chmod +x "$1"
}

carry_calls() { # count-file -> number of real carrier actor launches
  [ -f "$1" ] && wc -c <"$1" | tr -d ' ' || printf '0'
}

# The carrier's default allowlist is ^logs/work-loop/ and ^logs/harness-runs/.
# A dispatcher sharing the checkout writes its run log to runs/, which is
# outside that set, so an unwidened carrier would stop at 18 FOREIGN_UNSTAGED —
# a refusal that has nothing to do with a lease. Widening it here keeps the
# thing being measured the thing under test. The carrier's own run log goes
# OUTSIDE the checkout for the mirror-image reason: logs/harness-runs/ is not in
# the DISPATCHER's allowlist.
CARRY_ALLOW=(--allow-path '^logs/work-loop/' --allow-path '^runs/')

run_dispatch() { # sandbox task [extra args...] -> writes $OUT, sets $RC
  local d="$1" t="$2"; shift 2
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task "$t" \
        --log-dir "$d/runs" --timeout 20 "$@" 2>&1)"
  RC=$?
}

calls() { # sandbox -> number of actor invocations
  [ -f "$1.calls" ] && wc -l <"$1.calls" | tr -d ' ' || printf '0'
}

# Every file in a checkout's WORKING TREE, with its hash. `.git` is pruned, and
# that prune is the claim being made rather than a convenience: the shared lease
# root lives inside the Git common directory, so a refusal that writes its
# evidence there writes NOTHING a checkout's working tree can see. A manifest
# that included `.git` could not tell that apart from a refusal scribbling in the
# operator's files, which is the distinction case 12h exists to draw.
#
# Content, not mtime: a file rewritten with identical bytes is not a change the
# operator would ever have to reconcile, and a timestamp comparison would report
# one. Paths are included so the diff on failure names what moved.
tree_manifest() { # checkout -> "<sha>  <relative path>" per line, sorted
  ( cd "$1" 2>/dev/null || return 1
    find . -path ./.git -prune -o -type f -print 2>/dev/null | LC_ALL=C sort |
      while IFS= read -r f; do
        printf '%s  %s\n' "$(shasum -a 256 "$f" 2>/dev/null | cut -d' ' -f1)" "$f"
      done )
}

res_field() { # file key -> value
  sed -n "s/^$2=//p" "$1" 2>/dev/null | head -1
}
# The run-bound result path, derived from the run log line the dispatcher printed
# rather than from anything this harness composes. If the two ever disagree, the
# record is not run-bound and every assertion below should fail — which is why the
# id is READ, not reconstructed.
run_id_of() { # dispatcher output -> run id
  printf '%s\n' "$1" | sed -n 's/^run=\([^ ]*\) .*/\1/p' | head -1
}
res_count() { # runs dir -> number of finalized results
  ls "$1"/*.result 2>/dev/null | wc -l | tr -d ' '
}
part_count() { # runs dir -> number of UNfinalized temporary artifacts
  ls "$1"/*.result.partial 2>/dev/null | wc -l | tr -d ' '
}

expect_rc() { # want got label [detail]
  if [ "$2" -eq "$1" ]; then ok "$3"; else bad "$3" "expected exit $1, got $2 — ${4:-}"; fi
}

# Substring assertions over a captured refusal, for the holder-identity checks
# below. `case` rather than `grep`: one of the phrases under test contains
# parentheses, which grep would read as pattern syntax rather than as text.
#
# The NEGATIVE half is the load-bearing one. "an attended carry holds task X"
# also contains no "a dispatcher", but a message that named both would
# satisfy the positive assertion alone while still telling the operator to go
# looking for the wrong process.
out_has()   { # needle out label
  case "$2" in *"$1"*) ok "$3" ;; *) bad "$3" "expected to contain: $1 — got: $2" ;; esac
}
out_lacks() { # needle out label
  case "$2" in *"$1"*) bad "$3" "expected NOT to contain: $1 — got: $2" ;; *) ok "$3" ;; esac
}

# Exactly one occurrence of FLAG in a recorded argv, immediately followed by
# VALUE on the next line. Two separate `grep -Fqx` calls would pass on an argv
# that carried the flag and the value in unrelated positions — which is not the
# same claim as "the pair was passed". The count is part of it: a flag repeated
# with a different value is a policy the log line cannot describe.
argv_pair() { # argv-file flag value
  local f="$1" flag="$2" value="$3" n
  n="$(grep -Fxc -- "$flag" "$f" 2>/dev/null || printf '0')"
  [ "$n" = "1" ] || return 1
  grep -A1 -Fx -- "$flag" "$f" | tail -1 | grep -Fqx -- "$value"
}

# ================================================================== case 0
echo
echo "Case 0 — harness falsifiability (dispatcher absent)"
d="$(new_sandbox)"; state_file "$d" "live-task" "codex"
ABSENT="$SANDBOX_ROOT/no-such-dispatcher.sh"
OUT="$(DISPATCH_BIN="$ABSENT" bash "$ABSENT" --checkout "$d" --task live-task 2>&1)"; RC=$?
if [ "$RC" -eq 0 ]; then
  bad "suite fails when the dispatcher is absent" "an absent dispatcher exited 0 — the harness cannot detect its own subject"
else
  ok "suite fails when the dispatcher is absent (exit $RC)"
fi
if [ ! -x "$DISPATCH_BIN" ] && [ ! -f "$DISPATCH_BIN" ]; then
  bad "dispatcher under test exists at $DISPATCH_BIN"
  echo; echo "ABORT: nothing to test."; exit 1
else
  ok "dispatcher under test exists at $DISPATCH_BIN"
fi

# ================================================================== case 1
echo
echo "Case 1 — exact-task routing; decoys are never selected"
d="$(new_sandbox)"; state_file "$d" "live-task" "codex"
run_dispatch "$d" live-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "reaches turn: operator and exits 0" "$OUT"
if [ "$(calls "$d")" = "1" ] && grep -qx "live-task" "$d.calls"; then
  ok "exactly one actor call, for the named task"
else
  bad "exactly one actor call, for the named task" "calls=$(calls "$d") content=$(cat "$d.calls" 2>/dev/null)"
fi
untouched=1
for decoy in decoy-alpha decoy-beta decoy-mismatch; do
  grep -q "^turn: \(codex\|claude\)$" "$d/logs/work-loop/$decoy.md" || untouched=0
done
[ "$untouched" -eq 1 ] && ok "all three decoy files still hold their original turn" \
                       || bad "all three decoy files still hold their original turn"

# ================================================================== case 2
echo
echo "Case 2 — filename / frontmatter identity mismatch is rejected read-only"
d="$(new_sandbox)"
before="$(shasum -a 256 "$d/logs/work-loop/decoy-mismatch.md" | cut -d' ' -f1)"
run_dispatch "$d" decoy-mismatch --actor-cmd "$FLIP"
expect_rc 14 "$RC" "exits 14 on identity mismatch" "$OUT"
after="$(shasum -a 256 "$d/logs/work-loop/decoy-mismatch.md" | cut -d' ' -f1)"
[ "$before" = "$after" ] && ok "the mismatched file is byte-identical afterwards" \
                         || bad "the mismatched file is byte-identical afterwards"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"

# ================================================================== case 3
echo
echo "Case 3 — path traversal in the task id"
d="$(new_sandbox)"
run_dispatch "$d" "../../etc/passwd" --actor-cmd "$FLIP"
expect_rc 12 "$RC" "exits 12 on a traversal task id" "$OUT"
run_dispatch "$d" "live task" --actor-cmd "$FLIP"
expect_rc 12 "$RC" "exits 12 on an illegal-character task id" "$OUT"

# ================================================================= case 3a
echo
echo "Case 3a — a task id longer than the derived maximum is refused BEFORE admission; the maximum itself stays legal"
# WHY A LENGTH BOUND EXISTS AT ALL. Case 3 above proves the CHARACTER grammar, and
# until this case that was the whole of it: an id built only from legal characters
# was accepted at ANY length. The task id is the LAST field of the run id
# (dispatch.sh, RUN_ID), and every piece of run evidence is that run id plus a
# suffix — so a long enough id did not produce a refusal, it produced an ADMITTED
# run that could not name its own artifacts. Measured against the unmodified
# dispatcher, a 129-character id ran all four hops, launched four actors, took both
# leases, mutated the working tree and published a terminal result. The approved
# plan's hostile-input boundary asks for "strict length and character grammars to
# task IDs"; this case is the length half of it.
#
# THE DERIVATION, from the current naming formats and nothing else:
#   run id            <timestamp 15> "-" <lock key <=8> "-" <pid> "-" <task>
#   longest filename  <run id> ".unattended-settings.json"        (25 bytes)
#   NAME_MAX          255
# The fixed prefix is 15+1+8+1+7+1 = 33 bytes at the widest pid Linux allots, so
# the hard ceiling is 255-33-25 = 197. The enforced maximum is 128, which keeps 69
# bytes in hand: the hop-capture suffixes ".hop<N>.<actor>.out" and ".tree" grow
# with the caller's --max-hops digits, and bounds for the other token classes are
# deferred, so the margin is what keeps one fixed number safe while that stays
# true. 128 is also more than twice the longest task id this repository has ever
# committed (54 characters), so the bound relabels nothing legal.
#
# THE TWO IDS ARE GENERATED AND DIFFER BY EXACTLY ONE CHARACTER. A 129-character
# literal could not be checked by eye, and building the over-length id as "the
# legal one plus one 'a'" is what makes the pair a boundary rather than two
# unrelated strings.
ID3A_OK="L$(printf '%*s' 127 '' | tr ' ' 'a')"
ID3A_BAD="${ID3A_OK}a"
[ "${#ID3A_OK}" -eq 128 ] && [ "${#ID3A_BAD}" -eq 129 ] \
  && ok "3a — the fixture ids are exactly the maximum and the maximum plus one" \
  || bad "3a — the fixture ids are exactly the maximum and the maximum plus one" \
         "ok=${#ID3A_OK} bad=${#ID3A_BAD}"

D3A="$(new_sandbox)"
# BOTH state files exist, so "it was refused" cannot be explained away by a missing
# record. The refusal has to come from the id itself.
state_file "$D3A" "$ID3A_BAD" codex
state_file "$D3A" "$ID3A_OK"  codex
rm -f "$D3A.calls"
LR3A="$(lock_root_for "$D3A")"
HEAD3A="$(git -C "$D3A" rev-parse HEAD)"
TREE3A="$(tree_manifest "$D3A")"
# --actor-cmd, not --dry-run, and that is deliberate: a dry-run launches nothing
# whatever the verdict, so "no actor was launched" could not fail. With a simulated
# actor available, an admitted run WOULD call it — and against the unmodified
# dispatcher it called it four times.
run_dispatch "$D3A" "$ID3A_BAD" --actor-cmd "$FLIP"
expect_rc 12 "$RC" "3a — the over-length task id is refused as an invalid task id" "$OUT"
out_has "STOP [12]" "$OUT" "3a — the refusal names itself on stderr"
out_has "too long: 129 characters, maximum 128" "$OUT" \
  "3a — the refusal names LENGTH and both numbers, not characters"
# THE PRE-ADMISSION CONTRACT, as the four absences the approved plan names: no owner
# or lease, no evidence, no actor, no mutation.
[ ! -e "$LR3A" ] \
  && ok "3a — no lease was ever acquired: the shared lease root was never created" \
  || bad "3a — no lease was ever acquired: the shared lease root was never created" \
         "$(ls -a "$LR3A" 2>&1 | tr '\n' ' ')"
[ ! -e "$D3A/runs" ] \
  && ok "3a — it wrote no run evidence: the evidence directory was never created" \
  || bad "3a — it wrote no run evidence: the evidence directory was never created" \
         "$(ls -a "$D3A/runs" 2>&1 | tr '\n' ' ')"
[ "$(calls "$D3A")" = "0" ] \
  && ok "3a — no actor was launched" || bad "3a — no actor was launched" "calls=$(calls "$D3A")"
[ "$(git -C "$D3A" rev-parse HEAD)" = "$HEAD3A" ] \
  && ok "3a — it committed nothing" || bad "3a — it committed nothing" "HEAD moved from $HEAD3A"
[ "$TREE3A" = "$(tree_manifest "$D3A")" ] \
  && ok "3a — every byte of the checkout's working tree is unchanged" \
  || bad "3a — every byte of the checkout's working tree is unchanged" "the tree moved"

# THE POSITIVE CONTROL, through the narrowest safe mode. Without it the bound could
# be satisfied by refusing everything, and an off-by-one would be invisible.
run_dispatch "$D3A" "$ID3A_OK" --dry-run
expect_rc 0 "$RC" "3a — an otherwise identical id at exactly the maximum is still admitted" "$OUT"
# AND THE BOUND'S ARITHMETIC, CHECKED AGAINST THE RUN THIS CASE JUST PRODUCED
# rather than against the comment above it. Take the result filename the admitted
# run actually wrote, swap its 7-byte ".result" for the 25-byte longest suffix the
# dispatcher builds, and require the answer to still fit NAME_MAX. This is the
# assertion that would go red if the maximum were ever raised past what the naming
# formats can carry. Exactly ONE result is required in the same breath, because the
# refusal above must have published none — the two runs share this sandbox.
if [ "$(res_count "$D3A/runs")" = 1 ]; then
  N3A="$(basename "$(ls "$D3A/runs"/*.result)")"
  W3A=$(( ${#N3A} - 7 + 25 ))
  [ "$W3A" -le 255 ] \
    && ok "3a — at the maximum, even the longest run-evidence filename fits NAME_MAX ($W3A <= 255)" \
    || bad "3a — at the maximum, even the longest run-evidence filename fits NAME_MAX" "$W3A > 255"
else
  bad "3a — the admitted run at the maximum published exactly one result, and the refusal published none" \
      "results=$(res_count "$D3A/runs")"
fi

# ================================================================== case 4
echo
echo "Case 4 — missing and malformed state"
d="$(new_sandbox)"
run_dispatch "$d" no-such-task --actor-cmd "$FLIP"
expect_rc 13 "$RC" "exits 13 when the state file is missing" "$OUT"
d="$(new_sandbox)"; state_file "$d" "bad-turn" "robot"
run_dispatch "$d" bad-turn --actor-cmd "$FLIP"
expect_rc 15 "$RC" "exits 15 on an out-of-domain turn: value" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched for malformed state" || bad "no actor launched for malformed state"

# ================================================================== case 5
echo
echo "Case 5 — turn: operator is terminal"
d="$(new_sandbox)"; state_file "$d" "op-task" "operator"
run_dispatch "$d" op-task --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0 on turn: operator" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "zero model launches for an operator stop" || bad "zero model launches for an operator stop" "calls=$(calls "$d")"

# ================================================================== case 6
echo
echo "Case 6 — an actor that changes nothing stops the loop once"
d="$(new_sandbox)"; state_file "$d" "noop-task" "codex"
run_dispatch "$d" noop-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "exits 22 on no observable transition" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "the no-op actor was launched exactly once, not repeatedly" \
                          || bad "the no-op actor was launched exactly once" "calls=$(calls "$d")"

# ================================================================== case 7
echo
echo "Case 7 — actor failure and actor timeout"
d="$(new_sandbox)"; state_file "$d" "fail-task" "codex"
run_dispatch "$d" fail-task --actor-cmd 'exit 3'
expect_rc 20 "$RC" "exits 20 when the actor exits non-zero" "$OUT"
d="$(new_sandbox)"; state_file "$d" "slow-task" "codex"
t0="$(date '+%s')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task slow-task --log-dir "$d/runs" \
       --timeout 3 --actor-cmd 'sleep 60' 2>&1)"; RC=$?
took=$(( $(date '+%s') - t0 ))
expect_rc 21 "$RC" "exits 21 when the actor exceeds the timeout" "$OUT"
# Regression for the drift the 2026-08-05 live run exposed: the deadline used to
# count poll iterations, so real elapsed time ran well past --timeout. 3s
# requested + 2s TERM->KILL grace; anything at or beyond 20s means it is
# counting loops again rather than the clock.
if [ "$took" -lt 20 ]; then
  ok "the timeout fired on wall-clock time (${took}s for a 3s deadline)"
else
  bad "the timeout fired on wall-clock time" "took ${took}s for a 3s deadline — the deadline is drifting"
fi

# ================================================================== case 8
echo
echo "Case 8 — hop limit"
d="$(new_sandbox)"; state_file "$d" "ping-task" "codex"
run_dispatch "$d" ping-task --max-hops 2 --actor-cmd "$FLIP"
expect_rc 23 "$RC" "exits 23 at the hop limit" "$OUT"
[ "$(calls "$d")" = "2" ] && ok "stopped after exactly 2 launches" || bad "stopped after exactly 2 launches" "calls=$(calls "$d")"

echo
echo "Case 8b — a post-launch hop-limit stop reports the last hop's partial effect"
d="$(new_sandbox)"; state_file "$d" "limit-effects-task" "codex"
run_dispatch "$d" limit-effects-task --max-hops 1 --actor-cmd "$FLIP"
expect_rc 23 "$RC" "exits 23 after the single allowed launch" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS — since launch" \
  && ok "the post-launch hop-limit stop carries partial effects" \
  || bad "the post-launch hop-limit stop carries partial effects" "$OUT"
printf '%s' "$OUT" | sed -n '/PARTIAL FILE EFFECTS/,$p' | grep -Fq "logs/work-loop/limit-effects-task.md" \
  && ok "the Codex handoff left by the launched hop is named" \
  || bad "the Codex handoff left by the launched hop is named" "$OUT"

# ================================================================== case 9
echo
echo "Case 9 — foreign staged state stops the spike"
d="$(new_sandbox)"; state_file "$d" "staged-task" "codex"
printf 'foreign edit\n' >>"$d/other.txt"
git -C "$d" add other.txt
run_dispatch "$d" staged-task --actor-cmd "$FLIP"
expect_rc 16 "$RC" "exits 16 when something is already staged" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched over foreign staged state" || bad "no actor launched over foreign staged state"

# ================================================================= case 10
echo
echo "Case 10 — unexpected repository effects"
d="$(new_sandbox)"; state_file "$d" "head-task" "codex"
MOVE_HEAD="$FLIP"'; printf "x\n" >> "$WL_CHECKOUT/other.txt";
      git -C "$WL_CHECKOUT" add other.txt; git -C "$WL_CHECKOUT" commit -qm "codex should never do this"'
run_dispatch "$d" head-task --actor-cmd "$MOVE_HEAD"
expect_rc 24 "$RC" "exits 24 when the Codex actor moves HEAD" "$OUT"

d="$(new_sandbox)"; state_file "$d" "stray-task" "codex"
STRAY="$FLIP"'; printf "stray\n" > "$WL_CHECKOUT/stray-file.txt"'
run_dispatch "$d" stray-task --actor-cmd "$STRAY"
expect_rc 24 "$RC" "exits 24 when an actor writes outside the allowlist" "$OUT"

# ================================================================= case 11
echo
echo "Case 11 — a simulated round trip runs unattended and ends at operator"
d="$(new_sandbox)"; state_file "$d" "trip-task" "codex"
TRIP='printf "%s:%s\n" "$WL_HOP" "$WL_ACTOR" >> "$WL_CHECKOUT.calls";
      if [ "$WL_HOP" -ge 3 ]; then
        d=$(sed -n "s/^task: //p" "$WL_STATE_FILE" | head -1);
        printf -- "---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n## Outcome\nRound trip finished.\n\n## Decisions that matter\nNothing real depends on this file.\n\n## Evidence\nHarness fixture.\n\n## Accepted limitations\nNone.\n" "$d" > "$WL_STATE_FILE.tmp";
      else
        if [ "$WL_ACTOR" = "codex" ]; then n="turn: claude"; else n="turn: codex"; fi;
        awk -v n="$n" "/^turn: /&&!d{print n; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      fi;
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" trip-task --max-hops 6 --actor-cmd "$TRIP"
expect_rc 0 "$RC" "codex -> claude -> codex -> operator completes and exits 0" "$OUT"
if [ "$(tr '\n' ' ' <"$d.calls")" = "1:codex 2:claude 3:codex " ]; then
  ok "the actor sequence was exactly codex, claude, codex"
else
  bad "the actor sequence was exactly codex, claude, codex" "got: $(tr '\n' ' ' <"$d.calls")"
fi
grep -q '^turn: operator$' "$d/logs/work-loop/trip-task.md" && ok "the file ends at turn: operator" \
                                                            || bad "the file ends at turn: operator"

# ================================================================= case 12
echo
echo "Case 12 — a second dispatcher on the same checkout/task is refused"
d="$(new_sandbox)"; state_file "$d" "lock-task" "codex"
( bash "$DISPATCH_BIN" --checkout "$d" --task lock-task --log-dir "$d/runs" \
    --timeout 30 --actor-cmd 'sleep 6; exit 0' >/dev/null 2>&1 ) &
outer=$!
sleep 2
run_dispatch "$d" lock-task --actor-cmd "$FLIP"
expect_rc 17 "$RC" "exits 17 while another dispatcher holds the task" "$OUT"
# The DISPATCHER-HELD control for the holder-identity assertions in 12e. Those
# check that a carrier-held lease is not reported as a dispatcher; this checks
# the other direction, that reading the holder did not lose the case it was
# already getting right. Without it, a refusal that said "an attended carry"
# unconditionally would pass 12e and be just as wrong.
out_has 'a dispatcher holds task lock-task' "$OUT" \
  "  and the TASK refusal names a dispatcher, because a dispatcher holds it"

# Case 12b/12c — the two halves the composite ${TMPDIR} key could not enforce.
# Both are exercised against the SAME live holder above, so they measure real
# contention rather than a hand-placed lock directory.
#
# 12b: the caller's TMPDIR is not part of the answer any more. Two dispatchers
# launched with different TMPDIR roots used to compute one key under two parents
# and never contend at all.
OUT="$(TMPDIR="$SANDBOX_ROOT/elsewhere-$$" bash "$DISPATCH_BIN" --checkout "$d" \
        --task lock-task --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "exits 17 even when the second caller's TMPDIR differs" "$OUT"

# 12c: a DIFFERENT task in the SAME checkout. Two tasks sharing one working tree
# and index is how either sweeps the other's paths into a commit, and the old
# key — which included the task — let both in.
state_file "$d" "lock-other" "codex"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task lock-other \
        --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "exits 17 for a DIFFERENT task in the same checkout" "$OUT"
case "$OUT" in
  *lock-task*) ok "the checkout refusal names the task already running there" ;;
  *)           bad "the checkout refusal names the task already running there" "$OUT" ;;
esac
# The CHECKOUT half of the same control.
out_has 'a dispatcher is already running in this checkout' "$OUT" \
  "the checkout refusal names a dispatcher, because a dispatcher holds it"

wait "$outer" 2>/dev/null

# Both locks are released once the holder exits — otherwise the exclusion above
# would be indistinguishable from a leak.
[ -d "$(task_lock_for "$d" lock-task)" ] \
  && bad "the task lock is released after the run" "still held" \
  || ok "the task lock is released after the run"
[ -d "$(checkout_lock_for "$d")" ] \
  && bad "the checkout lock is released after the run" "still held" \
  || ok "the checkout lock is released after the run"

# The lock root is inside the repository, not under a caller-controlled TMPDIR.
# That is what makes the exclusion above hold across sessions with different
# environments — the property, not the path, is the claim.
LR="$(lock_root_for "$d")"
case "$LR" in
  "$(cd "$d" && pwd -P)"/.git/*) ok "the lock root lives in the Git common directory" ;;
  *) bad "the lock root lives in the Git common directory" "got $LR" ;;
esac

# ---------------------------------------------------------------- case 12d
# Ownership admission FAILS CLOSED. This used to print "ownership: SKIPPED" and
# launch anyway, which is the same outcome as a passing check for anyone reading
# the exit code — and it applied to exactly the checkouts most likely to hold a
# conflicting writer. The two sub-cases are the two ways the check can fail to
# run: the helper is absent, and the helper is present but broken.
echo
echo "case 12d — admission fails closed when the ownership check cannot run"
d="$(new_sandbox)"
state_file "$d" "fc-task" "codex"

# The measurement that makes this more than an exit-code assertion: no actor may
# be invoked. run_dispatch's actors append to "$d.calls".
rm -f "$d.calls"
git -C "$d" rm -q --cached logs/scripts/work-loop-owner.sh >/dev/null 2>&1
rm -f "$d/logs/scripts/work-loop-owner.sh"
git -C "$d" commit -qm "remove the ownership helper" >/dev/null 2>&1
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" fc-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 35 "$RC" "an ABSENT ownership helper refuses with exit 35" "$OUT"
case "$OUT" in
  *"ownership check is unavailable"*) ok "the refusal says the check could not run" ;;
  *) bad "the refusal says the check could not run" "$OUT" ;;
esac
[ -s "$d.calls" ] && bad "no actor was launched with the check unavailable" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                      || ok "no actor was launched with the check unavailable"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "no commit was made with the check unavailable" \
  || bad "no commit was made with the check unavailable"
# THE DURABLE RESULT, which this case did not assert at all before this unit. Both
# code-35 branches are raised from the ownership block (dispatch.sh, `die 35`), which
# sits AFTER run identity, after the evidence location and after both leases — so
# each is an admitted-run terminal, not a pre-admission refusal, and the approved plan
# requires it to "Atomically finalize exactly one terminal result for … invalid state
# or ownership". Exit 35 and a silent run directory would have satisfied every
# assertion above this line.
#
# `owner_check` IS THE HALF THAT SEPARATES THE TWO BRANCHES. Absent helper reports
# `unavailable`; the broken helper below reports `check-failed`. They share the
# outcome token because the operator's situation is the same — ownership is
# unestablished — but the observed verdict is not, and a record that collapsed them
# would be reporting the code path rather than what was seen.
RID12DA="$(run_id_of "$OUT")"
[ -n "$RID12DA" ] && ok "  and the run announced a run id" \
                  || bad "  and the run announced a run id" "$OUT"
R12DA="$d/runs/$RID12DA.result"
[ "$(res_count "$d/runs")" = "1" ] && [ "$(part_count "$d/runs")" = "0" ] \
  && ok "  and exactly one finalized result, with no unfinalized temporary beside it" \
  || bad "  and exactly one finalized result, with no unfinalized temporary beside it" \
         "results=$(res_count "$d/runs") partials=$(part_count "$d/runs"): $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(tail -1 "$R12DA" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "  and the record is complete to its sentinel" \
  || bad "  and the record is complete to its sentinel" "last line: $(tail -1 "$R12DA" 2>/dev/null)"
for pair in "outcome:OWNERSHIP_UNAVAILABLE" "code:35" "stage:pre-hop" \
            "owner_check:unavailable" "actor:none" "actor_launched:no" \
            "model_request_started:no" "hop:0" \
            "next_action:operator-resolve-ownership" \
            "lease_task_at_finalization:held-by-this-run" \
            "lease_checkout_at_finalization:held-by-this-run"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R12DA" "$k")"
  [ "$got" = "$want" ] && ok "  absent-helper result: $k=$want" \
                       || bad "  absent-helper result: $k=$want" "got: ${got:-<absent>}"
done
# HELD AT FINALIZATION AND GONE AFTERWARDS — the ordering Change set A states, read
# from the filesystem rather than inferred from the two fields above.
LT12DA="$(res_field "$R12DA" lease_task_dir)"; LC12DA="$(res_field "$R12DA" lease_checkout_dir)"
if [ -n "$LT12DA" ] && [ -n "$LC12DA" ] && [ ! -d "$LT12DA" ] && [ ! -d "$LC12DA" ]; then
  ok "  and both leases it reported holding were released on the way out"
else
  bad "  and both leases it reported holding were released on the way out" \
      "task=${LT12DA:-<absent>} ($([ -d "$LT12DA" ] && echo present || echo gone)) checkout=${LC12DA:-<absent>} ($([ -d "$LC12DA" ] && echo present || echo gone))"
fi

# The control. Same fixture recipe, same command, helper PRESENT — it must
# proceed and must launch. Without it, case 12d would pass just as well for a
# dispatcher that refuses everything, which is not the behaviour claimed.
#
# It gets its own sandbox on purpose. Reusing the one above would make the
# control depend on the refused run having left the task untouched — which is
# the very thing under test, so a broken dispatcher would fail the control for
# the wrong reason and the evidence would no longer separate the two facts.
dc="$(new_sandbox)"
state_file "$dc" "fc-task" "codex"
rm -f "$dc.calls"
run_dispatch "$dc" fc-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "control — with the helper present the same run proceeds" "$OUT"
[ -s "$dc.calls" ] && ok "control — the actor did run once the check was available" \
                   || bad "control — the actor did run once the check was available" "no calls"

# Present but unusable is the same fact as absent: the check did not run.
d="$(new_sandbox)"
state_file "$d" "fc-broken" "codex"
printf '#!/bin/bash\nexit 99\n' >"$d/logs/scripts/work-loop-owner.sh"
git -C "$d" add logs/scripts/work-loop-owner.sh >/dev/null 2>&1
git -C "$d" commit -qm "break the ownership helper" >/dev/null 2>&1
rm -f "$d.calls"
run_dispatch "$d" fc-broken --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 35 "$RC" "a BROKEN ownership helper refuses with exit 35 too" "$OUT"
[ -s "$d.calls" ] && bad "no actor was launched with a broken check" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                      || ok "no actor was launched with a broken check"
# The same durable-result proof for the second branch, and the same reason for it.
# What must differ from the branch above is `owner_check`: the helper RAN here and
# returned an exit the dispatcher does not recognise, which is `check-failed`, not
# `unavailable`. If both branches reported one value, the record would be naming the
# exit code it produced instead of the check it observed.
RID12DB="$(run_id_of "$OUT")"
[ -n "$RID12DB" ] && ok "  and the broken-helper run announced a run id" \
                  || bad "  and the broken-helper run announced a run id" "$OUT"
R12DB="$d/runs/$RID12DB.result"
[ "$(res_count "$d/runs")" = "1" ] && [ "$(part_count "$d/runs")" = "0" ] \
  && ok "  and exactly one finalized result for the broken helper, no temporary beside it" \
  || bad "  and exactly one finalized result for the broken helper, no temporary beside it" \
         "results=$(res_count "$d/runs") partials=$(part_count "$d/runs"): $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(tail -1 "$R12DB" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "  and that record is complete to its sentinel" \
  || bad "  and that record is complete to its sentinel" "last line: $(tail -1 "$R12DB" 2>/dev/null)"
for pair in "outcome:OWNERSHIP_UNAVAILABLE" "code:35" "stage:pre-hop" \
            "owner_check:check-failed" "actor:none" "actor_launched:no" \
            "model_request_started:no" "hop:0" \
            "next_action:operator-resolve-ownership" \
            "lease_task_at_finalization:held-by-this-run" \
            "lease_checkout_at_finalization:held-by-this-run"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R12DB" "$k")"
  [ "$got" = "$want" ] && ok "  broken-helper result: $k=$want" \
                       || bad "  broken-helper result: $k=$want" "got: ${got:-<absent>}"
done
# THE TWO BRANCHES REALLY DID OBSERVE DIFFERENT THINGS, asserted against each other
# rather than only against their own literals — the check a shared constant of the
# right shape would pass.
[ "$(res_field "$R12DA" owner_check)" != "$(res_field "$R12DB" owner_check)" ] \
  && ok "  and the two branches recorded DIFFERENT owner_check verdicts" \
  || bad "  and the two branches recorded DIFFERENT owner_check verdicts" \
         "both: $(res_field "$R12DB" owner_check)"
LT12DB="$(res_field "$R12DB" lease_task_dir)"; LC12DB="$(res_field "$R12DB" lease_checkout_dir)"
if [ -n "$LT12DB" ] && [ -n "$LC12DB" ] && [ ! -d "$LT12DB" ] && [ ! -d "$LC12DB" ]; then
  ok "  and the broken-helper run released both leases it reported holding"
else
  bad "  and the broken-helper run released both leases it reported holding" \
      "task=${LT12DB:-<absent>} ($([ -d "$LT12DB" ] && echo present || echo gone)) checkout=${LC12DB:-<absent>} ($([ -d "$LC12DB" ] && echo present || echo gone))"
fi

# M41 — the mutation control for every ownership-result assertion above, and for
# case 50e's code-33 assertions, which rest on the same guarantee. ONE mutation, not
# a matrix: the ownership stops publish through the shared die funnel, so removing
# that one action is what falsifies the claim for all three ownership codes at once.
#
# It is M1's construction reused verbatim rather than a new technique — same marker
# line, matched whole, occurrences counted, mutant required to differ and to parse —
# because the seam under test is the same one and a second way of cutting it would
# only add a way for the two controls to disagree.
MUTOWN="$SANDBOX_ROOT/mutants-ownership"; mkdir -p "$MUTOWN"
M41_LINE='  finalize_terminal_result "$code" || die_funnel_unprovable "$code" # die funnel failure transfer'
M41_HITS="$(grep -Fxc -- "$M41_LINE" "$DISPATCH_BIN" 2>/dev/null)"
awk -v want="$M41_LINE" '$0 == want { print "  :"; next } { print }' "$DISPATCH_BIN" >"$MUTOWN/m41.sh"
M41_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUTOWN/m41.sh" || M41_DIFFERS=yes
M41_PARSES=no; bash -n "$MUTOWN/m41.sh" 2>/dev/null && M41_PARSES=yes
if [ "$M41_HITS" = "1" ] && [ "$M41_DIFFERS" = yes ] && [ "$M41_PARSES" = yes ]; then
  ok "  M41 mutant differs from the dispatcher and still parses (the one funnel call site was found)"
  dm="$(new_sandbox)"; state_file "$dm" "fc-mut" "codex"
  git -C "$dm" rm -q --cached logs/scripts/work-loop-owner.sh >/dev/null 2>&1
  rm -f "$dm/logs/scripts/work-loop-owner.sh"
  git -C "$dm" commit -qm "remove the ownership helper" >/dev/null 2>&1
  OUTM="$(bash "$MUTOWN/m41.sh" --checkout "$dm" --task fc-mut --log-dir "$dm/runs" \
        --timeout 20 --actor-cmd "$FLIP_TO_OPERATOR" 2>&1)"; RCM=$?
  # THE EXIT CODE IS UNCHANGED AT 35, and that is the point of the control: a case
  # asserting only the code would have passed against this mutant and proved nothing
  # about the record. What disappears is the record itself.
  if [ "$RCM" -eq 35 ] && [ "$(res_count "$dm/runs")" = "0" ]; then
    ok "  M41: the ownership stop still exits 35 but publishes NO result (the assertions above are fail-capable)"
  else
    bad "  M41: the ownership stop still exits 35 but publishes NO result" \
        "rc=$RCM results=$(res_count "$dm/runs")"
  fi
  # And with no record, every field assertion above has nothing to read — shown on
  # the one field a supervised-use claim leans on hardest.
  RIDM41="$(run_id_of "$OUTM")"
  [ -z "$(res_field "$dm/runs/$RIDM41.result" model_request_started)" ] \
    && ok "  M41: and model_request_started reads as absent, not as 'no'" \
    || bad "  M41: and model_request_started reads as absent, not as 'no'" \
           "got: $(res_field "$dm/runs/$RIDM41.result" model_request_started)"
else
  bad "  M41 mutant differs from the dispatcher and still parses (the one funnel call site was found)" \
      "matched ${M41_HITS:-0} lines, want exactly 1; differs=$M41_DIFFERS parses=$M41_PARSES — the control cannot run"
fi

# ---------------------------------------------------------------- case 12e
# CROSS-TRANSPORT CONTENTION — the attended carrier against the unattended
# dispatcher. These four were written FAILING FIRST against the pre-shared-lease
# code, and the failure each recorded was UNSAFE ADMISSION — the second program
# launched an actor while the first was live in the same working tree, or on the
# same logical task in another one.
#
# WHY THEY FAILED THEN, and it was an inference from two absences rather than
# from the presence of two locks. dispatch.sh rooted its two leases in the Git
# common directory; carry-turn.sh keyed a single lease under the caller's
# ${TMPDIR}. Neither source read the other's path. Each program was internally
# correct and jointly blind, which is also why this is the contention least
# likely to be noticed: both programs reported a clean single-writer run.
#
# WHAT HOLDS NOW: both transports resolve their leases through the one shared
# library (see the mirror block above), so the second program refuses with 17 and
# launches nothing. That is asserted rather than asserted-in-a-comment, so these
# turn green by behaviour and not by being rewritten — the expected exit codes,
# launch counts and HEAD checks below are unchanged from the failing version.
#
# The setup assertions moved with the code, and only the setup assertions. They
# used to observe a carrier-shaped ${TMPDIR} lock that no longer exists; they now
# observe the shared lease the carrier actually takes. An oracle pointing at a
# directory nobody writes is the one way these cases could go green while proving
# nothing, so each is paired with a control that requires a REAL launch.
#
# The four are the two acquisition directions across the two resources:
#   12e-1  carrier holds a CHECKOUT   -> dispatcher on another task refused
#   12e-2  dispatcher holds a CHECKOUT -> carrier on another task refused
#   12e-3  carrier holds a TASK        -> dispatcher on that task refused
#   12e-4  dispatcher holds a TASK     -> carrier on that task refused
echo
echo "Case 12e-1 — a live CARRIER holds the checkout; a DISPATCHER on ANOTHER task starts"
d="$(new_sandbox)"
state_file "$d" "xt-carried"    "claude"
state_file "$d" "xt-dispatched" "codex"
CCOUNT="$SANDBOX_ROOT/xt1.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt1.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-carried.md" 8
( bash "$CARRY_BIN" --checkout "$d" --task xt-carried --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt1-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
# The setup assertion is not ceremony. Without it a green result could mean the
# carrier never took a lease at all, and the case would be proving nothing.
# The CHECKOUT lease is the one under test here: the dispatcher below runs a
# DIFFERENT task in the same working tree, so the task lease cannot refuse it.
[ -d "$(checkout_lock_for "$d")" ] \
  && ok "12e-1 setup — the carrier's CHECKOUT lease is live before the dispatcher starts" \
  || bad "12e-1 setup — the carrier's CHECKOUT lease is live before the dispatcher starts" \
         "no lease at $(checkout_lock_for "$d")"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" xt-dispatched --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a dispatcher is refused while a CARRIER holds the checkout" "$OUT"
# REFUSING IS NOT THE WHOLE CONTRACT. The proposal's § 4.1 property 5 and its
# § 5 case 3 both require the refusal to NAME the attended holder, because the
# operator's next move is to find that process — and this line said "another
# dispatcher" for a lease whose recorded program is `carry`, sending them after
# a process that does not exist. The exit code was already right when this was
# wrong, which is why the code alone could not catch it.
out_has 'an attended carry is already running in this checkout' "$OUT" \
  "  and the refusal names the ATTENDED CARRIER as the holder"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not call the carrier a dispatcher"
[ -s "$d.calls" ] && bad "  and the dispatcher launched no actor" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and the dispatcher launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$carrier" 2>/dev/null
# The control. Without it this case would pass just as well against a carrier
# that never launched anything and a dispatcher that refuses everything.
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD the lease did launch its own actor" \
  || bad "  control — the carrier that HELD the lease did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"

echo
echo "Case 12e-2 — a live DISPATCHER holds the checkout; a CARRIER on ANOTHER task starts"
d="$(new_sandbox)"
state_file "$d" "xt-carried"    "claude"
state_file "$d" "xt-dispatched" "codex"
rm -f "$d.calls"
( bash "$DISPATCH_BIN" --checkout "$d" --task xt-dispatched --log-dir "$d/runs" \
    --timeout 40 --actor-cmd 'sleep 8; exit 0' >/dev/null 2>&1 ) &
dispatcher=$!
sleep 3
[ -d "$(checkout_lock_for "$d")" ] \
  && ok "12e-2 setup — the dispatcher's checkout lease is live before the carrier starts" \
  || bad "12e-2 setup — the dispatcher's checkout lease is live before the carrier starts" \
         "no lock at $(checkout_lock_for "$d")"
CCOUNT="$SANDBOX_ROOT/xt2.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt2.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-carried.md" 0
BEFORE="$(git -C "$d" rev-parse HEAD)"
OUT="$(bash "$CARRY_BIN" --checkout "$d" --task xt-carried --claude-bin "$CSTUB" \
        --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt2-carry-runs" 2>&1)"; RC=$?
expect_rc 17 "$RC" "a carrier is refused while a DISPATCHER holds the checkout" "$OUT"
[ "$(carry_calls "$CCOUNT")" = "0" ] \
  && ok "  and the carrier launched no actor" \
  || bad "  and the carrier launched no actor" "launches: $(carry_calls "$CCOUNT")"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$dispatcher" 2>/dev/null

echo
echo "Case 12e-3 — a live CARRIER holds the TASK in a linked worktree; a DISPATCHER starts on it here"
d="$(new_sandbox)"
state_file "$d" "xt-shared" "claude"
WT="$SANDBOX_ROOT/xt3-wt"
git -C "$d" worktree add -q -b xt3-lane "$WT" >/dev/null 2>&1
[ -f "$WT/logs/work-loop/xt-shared.md" ] \
  && ok "12e-3 setup — the state file replicates into the linked worktree" \
  || bad "12e-3 setup — the state file replicates into the linked worktree" "absent"
# THE DECLARATION BELONGS TO THE CARRIER'S CHECKOUT, and which checkout holds it
# IS the setup. The carrier gained its own repo-depth ownership admission in this
# change (carry-turn.sh 1496-1508), so it launches only where the task is
# ownership-valid. It runs in $WT, so $WT is where the task must be declared.
# Declaring it in $d instead — which this case did until the carrier acquired
# that check — leaves $WT REFUSED at 33 before launch: no actor, no task lease,
# and a dispatcher that then sails through. That is precisely the unsafe
# admission this case exists to catch, so it must never be the setup.
#
# --depth local, and the depth is not incidental. The worktree add above
# replicated the state file into a second checkout with neither one declaring
# it, and a repo-depth claim runs exactly that read, returns AMBIGUOUS and
# writes nothing (work-loop-owner.sh 278-282) — claiming is never the way out of
# an ambiguity. Local is the depth that can still record a declaration here, and
# it is what carry-turn.test.sh's own ownership-settled control uses.
#
# $d is left undeclared deliberately, and one declaration is the maximum: a
# second one in $d would make the task claimed by two checkouts, which is
# AMBIGUOUS for both and would refuse the carrier again by another route.
# Nothing is lost by leaving $d undeclared, because the dispatcher takes its
# leases (dispatch.sh 1249) before it performs ownership admission (2370): it
# meets the carrier's live task lease first and refuses with 17. If that order
# were ever reversed it would refuse with 33 here — still refused, still nothing
# launched, but a loud failure in this case rather than a silent pass.
bash "$WT/logs/scripts/work-loop-owner.sh" claim --checkout "$WT" --task xt-shared \
  --depth local >/dev/null 2>&1 \
  && ok "12e-3 setup — the carrier's worktree declares the task" \
  || bad "12e-3 setup — the carrier's worktree declares the task" "claim did not succeed"
CCOUNT="$SANDBOX_ROOT/xt3.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt3.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$WT/logs/work-loop/xt-shared.md" 8
( bash "$CARRY_BIN" --checkout "$WT" --task xt-shared --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt3-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
# The TASK lease is the one under test here, and it is the mirror image of 12e-1:
# the dispatcher below runs in a DIFFERENT checkout, so the checkout lease cannot
# refuse it. The lease root is the repository's, not the worktree's, which is
# exactly what lets a lease taken in $WT be seen from $d — deriving it from $WT
# is what proves that, since a per-worktree root would resolve somewhere else.
[ -d "$(task_lock_for "$WT" xt-shared)" ] \
  && ok "12e-3 setup — the carrier's TASK lease is live before the dispatcher starts" \
  || bad "12e-3 setup — the carrier's TASK lease is live before the dispatcher starts" \
         "no lease at $(task_lock_for "$WT" xt-shared)"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" xt-shared --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a dispatcher is refused while a CARRIER holds the same task elsewhere" "$OUT"
# The TASK half of the holder-identity contract, and the one this defect was
# first reproduced on. The detail line below it — the holder's checkout — was
# already right, which made the wrong subject harder to notice: the message
# named a real directory and the wrong kind of process holding it.
out_has 'an attended carry holds task xt-shared' "$OUT" \
  "  and the refusal names the ATTENDED CARRIER as the task holder"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not call the carrier a dispatcher"
[ -s "$d.calls" ] && bad "  and the dispatcher launched no actor" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and the dispatcher launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$carrier" 2>/dev/null
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD the task did launch its own actor" \
  || bad "  control — the carrier that HELD the task did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"
git -C "$d" worktree remove --force "$WT" >/dev/null 2>&1

echo
echo "Case 12e-4 — a live DISPATCHER holds the TASK here; a CARRIER starts on it in a linked worktree"
d="$(new_sandbox)"
state_file "$d" "xt-shared" "claude"
bash "$d/logs/scripts/work-loop-owner.sh" claim --checkout "$d" --task xt-shared \
  --depth repo >/dev/null 2>&1 \
  && ok "12e-4 setup — this checkout declares the task" \
  || bad "12e-4 setup — this checkout declares the task" "claim did not succeed"
WT="$SANDBOX_ROOT/xt4-wt"
git -C "$d" worktree add -q -b xt4-lane "$WT" >/dev/null 2>&1
rm -f "$d.calls"
( bash "$DISPATCH_BIN" --checkout "$d" --task xt-shared --log-dir "$d/runs" \
    --timeout 40 --actor-cmd 'sleep 8; exit 0' >/dev/null 2>&1 ) &
dispatcher=$!
sleep 3
[ -d "$(task_lock_for "$d" xt-shared)" ] \
  && ok "12e-4 setup — the dispatcher's TASK lease is live before the carrier starts" \
  || bad "12e-4 setup — the dispatcher's TASK lease is live before the carrier starts" \
         "no lock at $(task_lock_for "$d" xt-shared)"
CCOUNT="$SANDBOX_ROOT/xt4.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt4.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$WT/logs/work-loop/xt-shared.md" 0
BEFORE="$(git -C "$WT" rev-parse HEAD)"
# 17, not 33. The carrier gains a repo-depth ownership check in the same change,
# and this worktree does NOT declare the task — so ownership alone would also
# refuse this run. The expected code is the LEASE code because the dispatcher
# takes its leases before it performs ownership admission (dispatch.sh 1192 vs
# 2336) and the shared contract is written against what the dispatcher already
# does. If the implementation orders admission first, this becomes 33; the
# behaviour under test — refused, nothing launched — is the same either way, and
# the launch count below is the assertion that does not move.
expect_rc_note="lease refusal precedes ownership admission"
OUT="$(bash "$CARRY_BIN" --checkout "$WT" --task xt-shared --claude-bin "$CSTUB" \
        --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt4-carry-runs" 2>&1)"; RC=$?
expect_rc 17 "$RC" "a carrier is refused while a DISPATCHER holds the same task elsewhere ($expect_rc_note)" "$OUT"
[ "$(carry_calls "$CCOUNT")" = "0" ] \
  && ok "  and the carrier launched no actor" \
  || bad "  and the carrier launched no actor" "launches: $(carry_calls "$CCOUNT")"
[ "$(git -C "$WT" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing in the worktree" \
  || bad "  and committed nothing in the worktree" "HEAD moved from $BEFORE"
wait "$dispatcher" 2>/dev/null
git -C "$d" worktree remove --force "$WT" >/dev/null 2>&1

# --------------------------------------------------- cases 12e-5 .. 12e-7
# THE PROPOSAL'S CASES 3, 4 AND 12 — the three rows of the acceptance matrix
# that had no case of their own.
#
# WHY 12e-1..4 DID NOT ALREADY COVER THEM, which is the whole reason these
# exist. The four above are cross-transport, but each is a DIFFERENT row of the
# proposal's matrix, and the difference is the axis being isolated:
#
#   12e-1 / 12e-2  one checkout, DIFFERENT tasks  -> the proposal's case 11
#   12e-3 / 12e-4  one task, DIFFERENT checkouts  -> the proposal's cases 7 / 8
#
# The proposal's cases 3 and 4 are the plain collision neither pair states: the
# SAME task in the SAME checkout, one transport against the other. Both leases
# refuse it, which is exactly why an indirect argument from the four above is
# not evidence — a suite can be green on every neighbouring row while the
# straightforward one is untested, and "it must be covered, look at 12e" is the
# reasoning the correction plan's finding 6 names.
#
# Case 12 is the other direction, and it is the one a refusal-shaped change
# breaks silently: two DIFFERENT tasks in two DIFFERENT worktrees must BOTH be
# admitted. Nothing here asserted that two runs ever hold leases at the same
# moment. carry-turn.test.sh 12b has an over-refusal control, but it is carrier
# against a planted lease, sequential, and single-transport — it cannot show
# two live programs concurrent in one repository.
#
# Numbered in this suite's own 12e series, with the proposal's number in the
# header, for the reason case 30g gives: "case 3", "case 4" and "case 12" are
# all already taken here by unrelated local cases, and renumbering those would
# break every reference to them.
echo
echo "Case 12e-5 — proposal case 3: a CARRIER holds this task in THIS checkout; a DISPATCHER starts on it"
d="$(new_sandbox)"
state_file "$d" "xt-same" "claude"
CCOUNT="$SANDBOX_ROOT/xt5.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt5.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-same.md" 8
( bash "$CARRY_BIN" --checkout "$d" --task xt-same --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt5-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
CK5="$(checkout_lock_for "$d")"; TK5="$(task_lock_for "$d" xt-same)"
# BOTH leases, and both are asserted rather than one: this is the row where the
# task lease and the checkout lease would each refuse on their own, so a setup
# that established only one would leave which lease did the work unsettled.
{ [ -d "$CK5" ] && [ -d "$TK5" ]; } \
  && ok "12e-5 setup — the carrier holds BOTH the task and the checkout lease" \
  || bad "12e-5 setup — the carrier holds BOTH the task and the checkout lease" \
         "checkout=$([ -d "$CK5" ] && echo held || echo absent) task=$([ -d "$TK5" ] && echo held || echo absent)"
[ "$(cat "$TK5/program" 2>/dev/null)" = carry ] \
  && ok "12e-5 setup — and the task lease records a CARRIER as its holder" \
  || bad "12e-5 setup — and the task lease records a CARRIER as its holder" \
         "program=$(cat "$TK5/program" 2>/dev/null)"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" xt-same --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a dispatcher is refused on the SAME task in the SAME checkout as a live carrier" "$OUT"
# The proposal's case 3 requires the refusal to NAME the attended holder, not
# merely to happen. The acquisition order is task lease first (work-loop-lease.sh
# 457), so this is the task-lease refusal.
out_has 'an attended carry holds task xt-same' "$OUT" \
  "  and the refusal names the ATTENDED CARRIER as the holder"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not call the carrier a dispatcher"
[ -s "$d.calls" ] && bad "  and the dispatcher launched no actor" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and the dispatcher launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$carrier" 2>/dev/null
# The control. Without it every assertion above would pass just as well against
# a carrier that took a lease and never launched anything, and against a
# dispatcher that refuses unconditionally.
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD the leases did launch its own actor" \
  || bad "  control — the carrier that HELD the leases did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"

echo
echo "Case 12e-6 — proposal case 4: a DISPATCHER holds this task in THIS checkout; a CARRIER starts on it"
d="$(new_sandbox)"
state_file "$d" "xt-same2" "claude"
rm -f "$d.calls"
# The actor RECORDS itself before it sleeps. 12e-2's dispatcher used a bare
# `sleep`, which cannot answer "did the holder actually launch?" — the control
# the proposal requires on this row.
( bash "$DISPATCH_BIN" --checkout "$d" --task xt-same2 --log-dir "$d/runs" \
    --timeout 40 --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; sleep 8; exit 0' \
    >/dev/null 2>&1 ) &
dispatcher=$!
sleep 3
CK6="$(checkout_lock_for "$d")"; TK6="$(task_lock_for "$d" xt-same2)"
{ [ -d "$CK6" ] && [ -d "$TK6" ]; } \
  && ok "12e-6 setup — the dispatcher holds BOTH the task and the checkout lease" \
  || bad "12e-6 setup — the dispatcher holds BOTH the task and the checkout lease" \
         "checkout=$([ -d "$CK6" ] && echo held || echo absent) task=$([ -d "$TK6" ] && echo held || echo absent)"
[ "$(cat "$TK6/program" 2>/dev/null)" = dispatch ] \
  && ok "12e-6 setup — and the task lease records a DISPATCHER as its holder" \
  || bad "12e-6 setup — and the task lease records a DISPATCHER as its holder" \
         "program=$(cat "$TK6/program" 2>/dev/null)"
CCOUNT="$SANDBOX_ROOT/xt6.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt6.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-same2.md" 0
BEFORE="$(git -C "$d" rev-parse HEAD)"
OUT="$(bash "$CARRY_BIN" --checkout "$d" --task xt-same2 --claude-bin "$CSTUB" \
        --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt6-carry-runs" 2>&1)"; RC=$?
expect_rc 17 "$RC" "a carrier is refused on the SAME task in the SAME checkout as a live dispatcher" "$OUT"
# The mirror image of 12e-5, on the carrier's own wording (carry-turn.sh 831).
# The negative half is the load-bearing one: a launcher that named the holder
# after the program doing the looking would say "an attended carry" here.
out_has "an unattended dispatched run already holds the TASK lease for 'xt-same2'" "$OUT" \
  "  and the refusal names the DISPATCHED RUN as the holder"
out_lacks 'an attended carry' "$OUT" \
  "  and does not call the dispatcher an attended carry"
[ "$(carry_calls "$CCOUNT")" = "0" ] \
  && ok "  and the carrier launched no actor" \
  || bad "  and the carrier launched no actor" "launches: $(carry_calls "$CCOUNT")"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$dispatcher" 2>/dev/null
[ "$(calls "$d")" = "1" ] \
  && ok "  control — the dispatcher that HELD the leases did launch its own actor" \
  || bad "  control — the dispatcher that HELD the leases did launch its own actor" \
         "actor launches: $(calls "$d")"

echo
echo "Case 12e-7 — proposal case 12: DIFFERENT tasks in DIFFERENT worktrees are BOTH admitted, concurrently"
# The over-refusal row. Everything else in this section proves a refusal, and a
# lease that refused everything would satisfy all of it. This is the row that
# fails against such a lease, so it is where the section's own falsifiability
# sits — and it is proven CONCURRENTLY, because "both were admitted at different
# times" is not the claim: legitimate parallel work needs both leases held at
# one moment.
d="$(new_sandbox)"
state_file "$d" "iso-here"  "claude"
state_file "$d" "iso-there" "claude"
WT="$SANDBOX_ROOT/iso-wt"
git -C "$d" worktree add -q -b iso-lane "$WT" >/dev/null 2>&1
[ -f "$WT/logs/work-loop/iso-here.md" ] && [ -f "$WT/logs/work-loop/iso-there.md" ] \
  && ok "12e-7 setup — both state files replicate into the linked worktree" \
  || bad "12e-7 setup — both state files replicate into the linked worktree" "absent"
# THE SHARED LEASE ROOT IS THE POINT. Two worktrees of one repository resolve to
# ONE lease root, so these two runs are visible to each other and are admitted
# anyway. If the root were per-worktree, this case would pass by never having
# been a contention at all.
[ "$(lock_root_for "$d")" = "$(lock_root_for "$WT")" ] \
  && ok "12e-7 setup — both checkouts resolve the SAME lease root, so each could see the other" \
  || bad "12e-7 setup — both checkouts resolve the same lease root" \
         "$(lock_root_for "$d") vs $(lock_root_for "$WT")"
# Ownership has to be SETTLED in both, for the reason 12b and 12e-3 give: the
# worktree add replicated BOTH state files, and repository-depth ownership reads
# an undeclared replicated task as AMBIGUOUS. Each checkout declares the ONE
# task it runs — a second declaration in either would make that task claimed
# twice and refuse it by another route. --depth local, because a repo-depth
# claim runs the same replicated-state read and writes nothing.
bash "$d/logs/scripts/work-loop-owner.sh"  claim --checkout "$d"  --task iso-here \
     --depth local >/dev/null 2>&1 \
  && ok "12e-7 setup — this checkout declares iso-here" \
  || bad "12e-7 setup — this checkout declares iso-here" "claim did not succeed"
bash "$WT/logs/scripts/work-loop-owner.sh" claim --checkout "$WT" --task iso-there \
     --depth local >/dev/null 2>&1 \
  && ok "12e-7 setup — the worktree declares iso-there" \
  || bad "12e-7 setup — the worktree declares iso-there" "claim did not succeed"
ICOUNT="$SANDBOX_ROOT/iso.count"; : >"$ICOUNT"
ISTUB="$SANDBOX_ROOT/iso.stub"
make_carry_stub "$ISTUB" "$ICOUNT" "$d/logs/work-loop/iso-here.md" 8
rm -f "$d.calls" "$WT.calls"
ICRC="$SANDBOX_ROOT/iso-carry.rc"; IDRC="$SANDBOX_ROOT/iso-disp.rc"
ICOUT="$SANDBOX_ROOT/iso-carry.out"; IDOUT="$SANDBOX_ROOT/iso-disp.out"
( bash "$CARRY_BIN" --checkout "$d" --task iso-here --claude-bin "$ISTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/iso-carry-runs" \
    >"$ICOUT" 2>&1; printf '%s' "$?" >"$ICRC" ) &
carrier=$!
( bash "$DISPATCH_BIN" --checkout "$WT" --task iso-there --log-dir "$WT/runs" \
    --timeout 40 --actor-cmd "sleep 6; $FLIP_TO_OPERATOR" \
    >"$IDOUT" 2>&1; printf '%s' "$?" >"$IDRC" ) &
dispatcher=$!
sleep 3
# THE CONCURRENCY ASSERTION, and it is read while both are still running. After
# they exit, four absent directories look exactly like two runs that never
# started, so this cannot be checked at the end.
CKh="$(checkout_lock_for "$d")";  TKh="$(task_lock_for "$d" iso-here)"
CKt="$(checkout_lock_for "$WT")"; TKt="$(task_lock_for "$WT" iso-there)"
{ [ -d "$CKh" ] && [ -d "$TKh" ] && [ -d "$CKt" ] && [ -d "$TKt" ]; } \
  && ok "  BOTH runs hold BOTH of their leases AT THE SAME MOMENT" \
  || bad "  BOTH runs hold BOTH of their leases AT THE SAME MOMENT" \
         "here: checkout=$([ -d "$CKh" ] && echo held || echo absent) task=$([ -d "$TKh" ] && echo held || echo absent); there: checkout=$([ -d "$CKt" ] && echo held || echo absent) task=$([ -d "$TKt" ] && echo held || echo absent)"
# MIXED PATHS would produce the same four `-d` results above while the two runs
# shared a resource, so the distinctness is asserted rather than assumed.
[ "$CKh" != "$CKt" ] \
  && ok "  and the two checkout leases are distinct paths" \
  || bad "  and the two checkout leases are distinct paths" "both resolve to $CKh"
[ "$TKh" != "$TKt" ] \
  && ok "  and the two task leases are distinct paths" \
  || bad "  and the two task leases are distinct paths" "both resolve to $TKh"
[ "$(cat "$CKh/program" 2>/dev/null)" = carry ] && [ "$(cat "$CKt/program" 2>/dev/null)" = dispatch ] \
  && ok "  and each lease records the program that actually took it" \
  || bad "  and each lease records the program that actually took it" \
         "here=$(cat "$CKh/program" 2>/dev/null) there=$(cat "$CKt/program" 2>/dev/null)"
wait "$carrier" 2>/dev/null
wait "$dispatcher" 2>/dev/null
# NEITHER WAS REFUSED. 17 is the code under test; the exit codes are asserted as
# "not 17" rather than as 0 because what follows admission — the carrier's
# post-hop verdict, the dispatcher's turn: operator stop — is other cases' subject
# and would couple this row to verdicts it is not about.
#
# The recorded code has to EXIST for that comparison to mean anything: a run
# that died without writing its rc file leaves an empty string, which is also
# "not 17". Read once into a variable so the emptiness and the value are the
# same reading.
irc="$(cat "$ICRC" 2>/dev/null)"; idrc="$(cat "$IDRC" 2>/dev/null)"
{ [ -n "$irc" ] && [ "$irc" != "17" ]; } \
  && ok "  and the carrier was NOT refused (exit $irc)" \
  || bad "  and the carrier was NOT refused" \
         "rc=[$irc] ${ICOUT}: $(head -5 "$ICOUT" 2>/dev/null | tr '\n' ' ')"
{ [ -n "$idrc" ] && [ "$idrc" != "17" ]; } \
  && ok "  and the dispatcher was NOT refused (exit $idrc)" \
  || bad "  and the dispatcher was NOT refused" \
         "rc=[$idrc] ${IDOUT}: $(head -5 "$IDOUT" 2>/dev/null | tr '\n' ' ')"
# The controls. Both of them: a lease that admitted both runs and neither of
# which launched would satisfy every assertion above.
[ "$(carry_calls "$ICOUNT")" = "1" ] \
  && ok "  control — the carrier launched its own actor" \
  || bad "  control — the carrier launched its own actor" "launches: $(carry_calls "$ICOUNT")"
[ "$(calls "$WT")" = "1" ] \
  && ok "  control — the dispatcher launched its own actor" \
  || bad "  control — the dispatcher launched its own actor" "launches: $(calls "$WT")"
[ "$(calls "$d")" = "0" ] \
  && ok "  and no actor ran against the OTHER checkout" \
  || bad "  and no actor ran against the OTHER checkout" "$(tr '\n' ';' <"$d.calls" 2>/dev/null)"
# ISOLATION, on the working trees rather than on the leases. The carrier's hop
# rewrote iso-here in ITS checkout; the worktree's replica of the same file must
# be untouched, or the two runs were never separated in the way this row claims.
grep -q 'carrier stub ran' "$d/logs/work-loop/iso-here.md" 2>/dev/null \
  && ok "  and the carrier's hop landed in ITS OWN checkout's state file" \
  || bad "  and the carrier's hop landed in ITS OWN checkout's state file" "no hop recorded"
grep -q 'carrier stub ran' "$WT/logs/work-loop/iso-here.md" 2>/dev/null \
  && bad "  and the worktree's replica of that file is untouched" "the hop reached the other checkout" \
  || ok "  and the worktree's replica of that file is untouched"
[ -d "$WT/runs" ] && [ ! -e "$d/runs" ] \
  && ok "  and the dispatcher's run log exists only in the worktree it ran in" \
  || bad "  and the dispatcher's run log exists only in the worktree it ran in" \
         "worktree=$([ -d "$WT/runs" ] && echo present || echo absent) other=$([ -e "$d/runs" ] && echo present || echo absent)"
# No leak: two admitted runs that exit normally leave nothing behind, so the
# next pair is admitted for the same reason this one was.
{ [ ! -d "$CKh" ] && [ ! -d "$TKh" ] && [ ! -d "$CKt" ] && [ ! -d "$TKt" ]; } \
  && ok "  and all four leases were released when the two runs ended" \
  || bad "  and all four leases were released when the two runs ended" \
         "here: checkout=$([ -d "$CKh" ] && echo held || echo gone) task=$([ -d "$TKh" ] && echo held || echo gone); there: checkout=$([ -d "$CKt" ] && echo held || echo gone) task=$([ -d "$TKt" ] && echo held || echo gone)"
git -C "$d" worktree remove --force "$WT" >/dev/null 2>&1

# ---------------------------------------------------------------- case 12f
# THE LEASE ITSELF FAILS CLOSED when its shared library cannot be sourced.
#
# This is the sibling of 12d, one control over. 12d covers a checkout whose
# OWNERSHIP check cannot run; this covers a checkout whose LIVE LEASE cannot be
# taken, because the library that implements it is not there. Both are absences,
# and an absent check is not a passed check: the checkouts most likely to lack
# the library — older siblings, partial copies — are exactly the ones most likely
# to hold a conflicting writer.
#
# The code is 11, not 33/34/35. Those three are the OWNERSHIP taxonomy and this
# is not an ownership fact; 11 is the outcome this dispatcher already uses for
# every other lease-infrastructure failure (an unresolvable Git common directory,
# an uncreatable lock root). Reusing it keeps leases and durable ownership
# separate, which is the distinction the whole shared-lease design rests on.
#
# The exit code alone would not be evidence. A dispatcher that refuses
# everything passes an exit-code assertion, so the case also measures that NO
# actor was launched, that HEAD did not move, and — in the control below — that
# the same run proceeds and does launch once the library is present.
echo
echo "Case 12f — an ABSENT lease library refuses before launch and takes no lease"
d="$(new_sandbox)"
state_file "$d" "lease-missing" "codex"
rm -f "$d.calls"
git -C "$d" rm -q --cached logs/scripts/work-loop-lease.sh >/dev/null 2>&1
rm -f "$d/logs/scripts/work-loop-lease.sh"
git -C "$d" commit -qm "remove the lease library" >/dev/null 2>&1
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" lease-missing --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 11 "$RC" "an ABSENT lease library refuses with exit 11" "$OUT"
case "$OUT" in
  *"lease"*"missing or unreadable"*) ok "the refusal names the missing lease library" ;;
  *) bad "the refusal names the missing lease library" "$OUT" ;;
esac
[ -s "$d.calls" ] && bad "no actor was launched without the lease library" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                      || ok "no actor was launched without the lease library"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "no commit was made without the lease library" \
  || bad "no commit was made without the lease library" "HEAD moved from $BEFORE"
# A refusal must not leave a lease behind. The run never took one, so the two
# lease directories must be absent — a refusal that half-acquired would refuse
# the NEXT run for a reason that never existed.
{ [ ! -d "$(task_lock_for "$d" lease-missing)" ] && [ ! -d "$(checkout_lock_for "$d")" ]; } \
  && ok "the refused run left no lease directory behind" \
  || bad "the refused run left no lease directory behind" \
         "$(task_lock_for "$d" lease-missing) / $(checkout_lock_for "$d")"

# The control. Same fixture recipe, same command, library PRESENT — it must
# proceed and must launch. Its own sandbox, for the reason case 12d's control
# spells out: reusing the refused one would make the control depend on the very
# thing under test.
dl="$(new_sandbox)"
state_file "$dl" "lease-present" "codex"
rm -f "$dl.calls"
run_dispatch "$dl" lease-present --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "control — with the lease library present the same run proceeds" "$OUT"
[ -s "$dl.calls" ] && ok "control — the actor did run once the lease could be taken" \
                   || bad "control — the actor did run once the lease could be taken" "no calls"

# ---------------------------------------------------------------- case 12g
# THE HOLDER LABEL'S TWO FALLBACKS. A held lease whose `program` file is missing,
# empty or unrecognised is still HELD — the refusal must say so without guessing
# which transport left it. Guessing is the specific failure: naming a dispatcher
# by default is exactly what 12e caught, and naming a carrier by default would be
# the same mistake pointing the other way.
#
# These two PLANT a lease directory rather than launching a second program, and
# that is the one place in this suite where planting is the right instrument.
# 12e asks whether one program OBSERVES the other's lease, which a planted
# directory cannot answer. This asks what the message SAYS about metadata that no
# healthy program writes — an absent `program` file (an older lease predating the
# shared library, or a partially-written one) and a value from some future
# program. Neither can be produced by running a program that is working
# correctly, so a real launch could not set up either case.
#
# The lease is planted with pid/task/checkout but no `survivors` file, so it is
# HELD and not PINNED — the pinned branches exit before the label is used.
plant_lease() { # lease-dir holding-task holding-checkout [program]
  mkdir -p "$1"
  printf '%s\n' "$$"  >"$1/pid"
  printf '%s\n' "$2"  >"$1/task"
  printf '%s\n' "$3"  >"$1/checkout"
  [ "$#" -ge 4 ] && printf '%s\n' "$4" >"$1/program"
  return 0
}

echo
echo "Case 12g — a held lease with no recorded program, and one from an unknown program"
d="$(new_sandbox)"
state_file "$d" "label-task" "codex"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
# No `program` file at all: WL_LEASE_HOLDER_PROGRAM comes back empty.
plant_lease "$(task_lock_for "$d" label-task)" label-task "$d"
run_dispatch "$d" label-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a lease with no recorded program still refuses with 17" "$OUT"
out_has 'a Work Loop run (program unrecorded) holds task label-task' "$OUT" \
  "  and the refusal says the program is unrecorded rather than guessing"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not guess a dispatcher"
[ -s "$d.calls" ] && bad "  and launched no actor" "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" || bad "  and committed nothing" "HEAD moved from $BEFORE"
rm -rf "$(task_lock_for "$d" label-task)"

# An unrecognised program name is reported verbatim: the operator can act on a
# name they can search for, and a name this dispatcher does not know is still
# more than "another run".
plant_lease "$(checkout_lock_for "$d")" other-task "$d" some-future-runner
rm -f "$d.calls"
run_dispatch "$d" label-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a lease held by an UNKNOWN program still refuses with 17" "$OUT"
out_has 'a Work Loop run (some-future-runner) is already running in this checkout' "$OUT" \
  "  and the refusal reports the unknown program name verbatim"
[ -s "$d.calls" ] && bad "  and launched no actor" "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and launched no actor"
rm -rf "$(checkout_lock_for "$d")" "$(task_lock_for "$d" label-task)"

# ---------------------------------------------------------------- case 12h
# A PRE-ADMISSION REFUSAL LEAVES DURABLE EVIDENCE — AND LEAVES THE CHECKOUT ALONE.
#
# The live cross-transport hop of 2026-08-14 found the first half the hard way.
# The dispatcher refused correctly at 17 while the attended carrier held the
# shared lease — the concurrency control worked — but the refusal reached stderr
# and nowhere else, and an unattended dispatcher's stderr goes nowhere anybody is
# watching. Every case 12 assertion above passed throughout, because they all
# read the exit code and the message.
#
# The FIRST fix opened the run log before the lease was asked for, which bought
# the durable record at a price that is not payable: a dispatcher that has lost
# admission would create a directory and a file inside a checkout it does not own
# and is not entitled to touch. Two runs racing for one checkout would each leave
# marks in the other's working tree, and the whole point of losing admission is
# that the loser changes nothing.
#
# So the record moved, and this case asserts BOTH halves at once. Neither is
# sufficient alone — a refusal that writes nothing is unprovable, and a refusal
# that writes into the checkout is a trespass — and it is the pair that pins the
# behaviour:
#
#   1. the requested --log-dir, inside the checkout, is NEVER created;
#   2. the checkout's working-tree bytes and `git status` are unchanged;
#   3. a durable record still exists, under the shared lease root in the Git
#      common directory, carrying the human refusal AND a stable machine-readable
#      terminal record a later reader can match without parsing prose;
#   4. the refusal names that record's path, so an operator can find it;
#   5. no actor started, so the record describes a refusal and not a run.
#
# HALF OF THAT WAS SUPERSEDED BY THE OPERATOR'S SHRINK DECISION, and this case
# was rewritten rather than deleted. Points 1 and 2 rested on a boundary the
# approved revised plan moved: winning the lease is no longer what admits a run.
# Task, checkout and evidence location are established and trusted well above the
# lease, so a run refused at 17 is an ADMITTED run reaching an enumerated terminal
# class, and it owes exactly one run-bound terminal result written into its own
# evidence location. Point 3's standalone `.refusal` store was the workaround for
# a run that could not write one, and it is gone: two durable records for one
# ending can disagree, and nothing here may choose between them.
#
# WHAT SURVIVES UNCHANGED IS THE REAL PROTECTION. A refused run may write its own
# evidence and NOTHING ELSE — not the state file, not a commit, not any other
# path in the working tree — and the manifest below still asserts exactly that,
# with the run's own evidence directory excluded and case 64a asserting what goes
# into it. Points 4 and 5 also survive verbatim, re-pointed at the terminal
# result. The `--status` half at the end is untouched: it is read-only whatever
# the boundary says.
#
# THE HOLDER'S OWN LOG DIRECTORY IS OUTSIDE THE CHECKOUT. It is admitted, so it
# is entitled to write wherever it was asked to — but its writes would land in
# the same working tree the loser is being measured against, and the manifest
# could not say which run moved a byte.
#
# The lease is HELD BY A REAL SECOND DISPATCHER, not planted. What is under test
# is a stop taken on the live acquisition path, and a planted directory would
# reach the same branch without proving the ordering that caused the defect.
echo
echo "Case 12h — an exit-17 refusal writes durable evidence into its OWN log dir, and nowhere else in the checkout"
d="$(new_sandbox)"; state_file "$d" "record-task" "codex"
rm -f "$d.calls" "$d.holder"
LOSER_LOGS="$d/refused-runs"                    # INSIDE the checkout: this run's own evidence location
HOLDER_LOGS="$SANDBOX_ROOT/12h-holder-runs"     # outside it, so only the loser can move the bytes
REFUSALS="$(lock_root_for "$d")/refusals"
BEFORE="$(git -C "$d" rev-parse HEAD)"
# Everything in the working tree EXCEPT the loser's own evidence directory. The
# exclusion is the boundary this case now draws: writes there are the run's own
# and are asserted by case 64a; a moved byte anywhere else is a trespass.
tree_outside_logs() { # -> manifest with ./refused-runs/ removed
  tree_manifest "$1" | grep -v '  \./refused-runs/' || true
}
( bash "$DISPATCH_BIN" --checkout "$d" --task record-task --log-dir "$HOLDER_LOGS" \
    --timeout 90 \
    --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.holder"; sleep 30; exit 0' \
    >/dev/null 2>&1 ) &
holder=$!
# WAITED ON THE ACTOR, NOT ON THE LEASE, and the difference is load-bearing. The
# holder writes its own ownership declaration into the checkout somewhere between
# taking the lease and launching, so a manifest captured in that window would
# move for the HOLDER's reasons and this case would fail for something it is not
# testing. Once the actor is running, the holder touches the working tree no more.
for _ in $(seq 1 120); do [ -f "$d.holder" ] && break; sleep 0.5; done
[ -f "$d.holder" ] \
  && ok "12h setup — the holding dispatcher is admitted and inside its actor" \
  || bad "12h setup — the holding dispatcher is admitted and inside its actor" "no $d.holder marker"

TREE_BEFORE="$(tree_outside_logs "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain | grep -v 'refused-runs' || true)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task \
        --log-dir "$LOSER_LOGS" --timeout 20 --actor-cmd "$FLIP" 2>&1)"; RC=$?
TREE_AFTER="$(tree_outside_logs "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain | grep -v 'refused-runs' || true)"
expect_rc 17 "$RC" "the second dispatcher is refused at 17 by a REAL held lease" "$OUT"

# THE REST OF THE CHECKOUT IS UNTOUCHED, and it fails LOUDLY rather than by
# absence: the diff names the file. This is the half of the original claim the
# approved boundary change does NOT relax — a refused run writes its own evidence
# and nothing else.
if [ "$TREE_BEFORE" = "$TREE_AFTER" ]; then
  ok "  and every byte of the checkout OUTSIDE its own evidence directory is unchanged"
else
  bad "  and every byte of the checkout OUTSIDE its own evidence directory is unchanged" \
      "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -10 | tr '\n' ' ')"
fi
[ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and git status is unchanged outside it" \
  || bad "  and git status is unchanged outside it" "before [$STATUS_BEFORE] after [$STATUS_AFTER]"

# THE DURABLE RECORD IS THE RUN'S OWN TERMINAL RESULT, in the directory the
# operator pointed --log-dir at. Case 64a asserts its fields; what 12h keeps is
# that it exists, that it is the only durable record of this ending, and that the
# refusal says where it is.
RID12="$(run_id_of "$OUT")"
RR="$LOSER_LOGS/$RID12.result"
if [ -n "$RID12" ] && [ -f "$RR" ]; then
  ok "  and a durable terminal result was written into the requested --log-dir"
else
  bad "  and a durable terminal result was written into the requested --log-dir" \
      "run id '${RID12:-<none>}'; $(ls -a "$LOSER_LOGS" 2>&1 | tr '\n' ' ')"
fi
# THE COMPETING STORE IS GONE. One ending, one durable record — a `refusals/`
# entry alongside the result would be the second authority this unit removed.
[ ! -e "$REFUSALS" ] \
  && ok "    and no standalone refusal store was created beside the lease directories" \
  || bad "    and no standalone refusal store was created beside the lease directories" \
         "$(ls -a "$REFUSALS" 2>&1 | tr '\n' ' ')"
if [ -f "$RR" ] && grep -q '^code=17$' "$RR"; then
  ok "    and it records the refusal's own exit code"
else
  bad "    and it records the refusal's own exit code" "record: ${RR:-none}"
fi
# EVIDENCE NOBODY CAN FIND IS NOT EVIDENCE.
if [ -f "$RR" ]; then
  out_has "$RR" "$OUT" "  and the refusal prints the record's path on the terminal"
else
  bad "  and the refusal prints the record's path on the terminal" "no record to name"
fi
# THE HUMAN REFUSAL IS STILL ON BOTH CHANNELS — stderr and the run log the result
# points at. That was open_refusal_record's job and is now die()'s.
if [ -f "$LOSER_LOGS/$RID12.log" ] && grep -q '^STOP \[17\]' "$LOSER_LOGS/$RID12.log"; then
  ok "  and the human refusal reached the run log, not only the terminal"
else
  bad "  and the human refusal reached the run log, not only the terminal" \
      "$(ls -a "$LOSER_LOGS" 2>&1 | tr '\n' ' ')"
fi

# NO ACTOR RAN. Three independent handles, because the record's whole value is
# that it describes a refusal: an exit code alone cannot separate "refused before
# launch" from "launched and then failed".
[ -s "$d.calls" ] && bad "  and no actor was launched" "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and no actor was launched"
if [ -f "$RR" ] && [ "$(sed -n 's/^hop=//p' "$RR" | head -1)" = "0" ]; then
  ok "  and the record shows no hop"
else
  bad "  and the record shows no hop" "hop=$(sed -n 's/^hop=//p' "$RR" 2>/dev/null | head -1)"
fi
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" || bad "  and committed nothing" "HEAD moved from $BEFORE"

# --status STAYS NO-WRITE, on all three surfaces it could now touch: the
# requested log directory, a log directory that does not exist, and the refusal
# store. It takes no lease, so it can never be refused, so it must never file a
# refusal — a record written by a read-only command would be a false one.
# --status STAYS NO-WRITE whatever the admission boundary says, and the surfaces
# it is tested against are now the ones that exist: the requested log directory
# (which the refused run legitimately created, so the claim is that --status adds
# nothing to it), a log directory that does not exist at all, and the terminal
# result store. It takes no lease, so it can never be refused, so it must never
# finalize a result — a record written by a read-only command would be a false one.
n_res_before="$(res_count "$LOSER_LOGS")"
LOGS_BEFORE="$(ls -1 "$LOSER_LOGS" 2>/dev/null | LC_ALL=C sort)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task \
        --log-dir "$LOSER_LOGS" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "  --status still exits 0 over a held lease" "$OUT"
[ "$LOGS_BEFORE" = "$(ls -1 "$LOSER_LOGS" 2>/dev/null | LC_ALL=C sort)" ] \
  && ok "  --status added nothing to the log directory it was pointed at" \
  || bad "  --status added nothing to the log directory it was pointed at" \
         "$(diff <(printf '%s\n' "$LOGS_BEFORE") <(ls -1 "$LOSER_LOGS" | LC_ALL=C sort) | tr '\n' ' ')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task \
        --log-dir "$d/status-only-runs" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "  --status exits 0 for a log directory that does not exist" "$OUT"
[ ! -d "$d/status-only-runs" ] \
  && ok "  --status created no log directory" \
  || bad "  --status created no log directory" "$d/status-only-runs exists"
[ "$n_res_before" = "$(res_count "$LOSER_LOGS")" ] \
  && ok "  --status finalized no terminal result" \
  || bad "  --status finalized no terminal result" "result count moved from $n_res_before"
[ ! -e "$REFUSALS" ] \
  && ok "  --status created no refusal store either" \
  || bad "  --status created no refusal store either" "$(ls -a "$REFUSALS" 2>&1 | tr '\n' ' ')"

wait "$holder" 2>/dev/null
rm -rf "$(task_lock_for "$d" record-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# ---------------------------------------------------------------- case 12h-ok
# THE POSITIVE CONTROL, and without it 12h passes against a dispatcher that never
# writes a run log at all. Everything above is about one directory and one
# record, and a program that had simply lost the ability to open its run evidence
# would still satisfy the "nowhere else in the checkout" half. This is the run
# that WINS the lease, and it must reach the actor the refused one never did.
#
# IT USES THE SAME --log-dir AS THE REFUSED RUN, and that is now load-bearing
# rather than incidental. The refused run legitimately created its evidence
# directory inside this checkout, and a dispatcher only allowlists the log
# directory IT was pointed at — so a following run aimed at a DIFFERENT --log-dir
# reads the first one's evidence as out-of-allowlist litter and stops at 18
# before launching. That consequence is real and is now the DOCUMENTED CONTRACT
# rather than a deferral: one stable evidence location per checkout, proven by
# case 65a, with 65c the refusal that fires when a run is aimed somewhere else.
# Pointing both runs at one evidence location is what an operator does, and it is
# what this control has always measured.
echo
echo "Case 12h-ok — an ADMITTED run still creates and uses the requested run log"
rm -f "$d.calls"
n_ref_before="$(ls -1 "$REFUSALS" 2>/dev/null | wc -l | tr -d ' ')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task --log-dir "$LOSER_LOGS" \
      --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
AL="$(ls -t "$LOSER_LOGS"/*.log 2>/dev/null | head -1)"
if [ -n "$AL" ]; then
  ok "the requested --log-dir received a run log once both leases were held"
else
  bad "the requested --log-dir received a run log once both leases were held" \
      "nothing under $LOSER_LOGS: $(ls -a "$LOSER_LOGS" 2>&1 | tr '\n' ' ')"
fi
# Created is not the same claim as used. The run header only exists because the
# log was open when the run reported itself.
if [ -n "$AL" ] && grep -q '^run=' "$AL"; then
  ok "  and the run wrote its own header into it"
else
  bad "  and the run wrote its own header into it" "run log: ${AL:-none}"
fi
[ "$(calls "$d")" = "1" ] \
  && ok "  and the actor really launched (this is an admitted run, not another refusal)" \
  || bad "  and the actor really launched" "calls: $(calls "$d")"
[ "$n_ref_before" = "$(ls -1 "$REFUSALS" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  and an admitted run files no refusal record" \
  || bad "  and an admitted run files no refusal record" "refusal count moved from $n_ref_before"
rm -rf "$(task_lock_for "$d" record-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# ---------------------------------------------------------------- case 12i
echo
echo "Case 12i — the run id's checkout discriminator is populated, stable per checkout/task, and different across checkouts"
# WHAT THE SECOND FIELD IS FOR. A run id is
# <timestamp>-<discriminator>-<pid>-<task>, and every piece of run evidence is that
# id plus a suffix. Two runs of the SAME task, started in the SAME second, from
# DIFFERENT checkouts, writing into ONE shared --log-dir agree on the timestamp and
# on the task — so without the second field they compute the same id and silently
# overwrite each other's run log, hop captures and unattended profile. Case 12h
# proved evidence lands in the log dir it was asked for; this case proves two
# checkouts sharing one log dir stay distinguishable inside it.
#
# WHY IT NEEDED RESTORING, and why this is a regression rather than a new feature.
# The discriminator was computed in the original spike (94b440b2) as
# sha256("$CHECKOUT|$TASK") and deleted by 0d9e3355 (2026-08-11), the two-lease
# refactor. That deletion was right about the LOCK key — a composite enforces
# neither resource on its own, which is why there are now two independent leases —
# but RUN_ID was left still reading ${LOCK_KEY:0:8}, of a variable nothing assigned
# any more. The run logs on disk from before that refactor carry a populated field
# (`-d571444e-`, `-bb64bbd9-`); every run id produced after it carried two adjacent
# hyphens instead.
#
# THE FIELD IS READ OUT OF A REAL RUN ID, never reconstructed by this harness. It is
# field 2 on "-", which is unambiguous: the timestamp, the discriminator and the pid
# contain no hyphen, and the task id is last.
disc_of() { # dispatcher output -> the run id's discriminator field
  printf '%s' "$(run_id_of "$1")" | cut -d- -f2
}
DA="$(new_sandbox)"; DB="$(new_sandbox)"
SHARED12I="$SANDBOX_ROOT/shared-evidence-12i"; mkdir -p "$SHARED12I"
state_file "$DA" disc-task codex
state_file "$DB" disc-task codex
# --dry-run is the narrowest mode that still claims a run id and publishes evidence,
# and it launches no actor. The SAME task id and the SAME shared log dir are used
# throughout: the checkout is the only thing that varies, which is the only way the
# distinction assertion can be about the checkout.
run12i() { # checkout -> writes $OUT/$RC
  OUT="$(bash "$DISPATCH_BIN" --checkout "$1" --task disc-task \
        --log-dir "$SHARED12I" --timeout 20 --dry-run 2>&1)"; RC=$?
}
run12i "$DA"; expect_rc 0 "$RC" "12i — checkout A is admitted" "$OUT"
RID_A1="$(run_id_of "$OUT")"; DISC_A1="$(disc_of "$OUT")"
run12i "$DA"; expect_rc 0 "$RC" "12i — checkout A is admitted a second time" "$OUT"
RID_A2="$(run_id_of "$OUT")"; DISC_A2="$(disc_of "$OUT")"
run12i "$DB"; expect_rc 0 "$RC" "12i — checkout B is admitted for the same task" "$OUT"
RID_B1="$(run_id_of "$OUT")"; DISC_B1="$(disc_of "$OUT")"

# (1) POPULATED, and within the bounded grammar the field reserves. Eight lowercase
# hex characters — the width the run-id format allots and the alphabet a truncated
# sha256 can produce. This is the assertion that was red while nothing assigned it.
if printf '%s' "$DISC_A1" | grep -qE '^[0-9a-f]{8}$'; then
  ok "12i — the discriminator is populated and within its bounded 8-hex grammar ($DISC_A1)"
else
  bad "12i — the discriminator is populated and within its bounded 8-hex grammar" \
      "got '${DISC_A1}' from run id '${RID_A1}'"
fi
# (2) STABLE for one canonical checkout/task pair. Derived identity, not a nonce: two
# runs from the same checkout for the same task must agree, or evidence from one
# checkout could not be recognised as a set.
[ -n "$DISC_A1" ] && [ "$DISC_A1" = "$DISC_A2" ] \
  && ok "12i — the same checkout/task pair yields the same discriminator across runs" \
  || bad "12i — the same checkout/task pair yields the same discriminator across runs" \
         "A1='$DISC_A1' A2='$DISC_A2'"
# (3) DIFFERENT when the canonical checkout changes and the task does not. This is
# the collision the field exists to prevent, and it is proved without manufacturing
# a same-second/same-pid coincidence: if the field itself differs, the ids cannot
# collide whatever the clock and the pid do.
[ -n "$DISC_A1" ] && [ -n "$DISC_B1" ] && [ "$DISC_A1" != "$DISC_B1" ] \
  && ok "12i — a different checkout running the SAME task yields a different discriminator" \
  || bad "12i — a different checkout running the SAME task yields a different discriminator" \
         "A='$DISC_A1' B='$DISC_B1'"
# (4) AND THE EVIDENCE REALLY IS SEPARATE in the one shared directory: three distinct
# run ids, three run logs, three results. Overwriting would show up as a short count.
if [ "$RID_A1" != "$RID_A2" ] && [ "$RID_A1" != "$RID_B1" ] && [ "$RID_A2" != "$RID_B1" ]; then
  ok "12i — all three runs claimed distinct run ids"
else
  bad "12i — all three runs claimed distinct run ids" "A1='$RID_A1' A2='$RID_A2' B1='$RID_B1'"
fi
N_LOG12I="$(ls -1 "$SHARED12I"/*.log 2>/dev/null | wc -l | tr -d ' ')"
[ "$N_LOG12I" = 3 ] && [ "$(res_count "$SHARED12I")" = 3 ] \
  && ok "12i — the shared log dir holds all three runs' evidence, none overwritten" \
  || bad "12i — the shared log dir holds all three runs' evidence, none overwritten" \
         "logs=$N_LOG12I results=$(res_count "$SHARED12I")"
# (5) THE TASK-LAST LOOKUP CONTRACT IS UNCHANGED. --status globs "*-$TASK.log", and
# the discriminator sits in field 2, so populating it must not hide a run from the
# lookup. Asserted through the real --status, not by re-globbing here.
OUT="$(bash "$DISPATCH_BIN" --checkout "$DA" --task disc-task \
      --log-dir "$SHARED12I" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "12i — --status still exits 0 over the shared evidence dir" "$OUT"
out_has "logs: $SHARED12I/" "$OUT" "12i — --status still finds a run log by the task-last glob"
out_lacks "no run log for this task" "$OUT" "12i — and it does not report the task as unseen"
# ================================================================= case 13
# Regression for the gap the 2026-08-05 live run exposed: a Claude hop killed
# between editing and committing left a partial state file, and nothing stopped.
echo
echo "Case 13 — a Claude hop that edits but does not commit"
d="$(new_sandbox)"; state_file "$d" "dirty-task" "claude"
NO_COMMIT="$FLIP_BODY"   # deliberately WITHOUT COMMIT_IF_CLAUDE
run_dispatch "$d" dirty-task --actor-cmd "$NO_COMMIT"
expect_rc 25 "$RC" "exits 25 when Claude hands back without committing" "$OUT"

echo
echo "Case 13b — restart over a partial edit vs. the expected Codex handoff"
d="$(new_sandbox)"; state_file "$d" "restart-task" "codex"
# Claude's side of the seam: turn says codex, but the file is uncommitted, so a
# previous Claude died mid-hop. Must stop for inspection.
perl -pi -e 's/^turn: codex$/turn: codex/' "$d/logs/work-loop/restart-task.md"
printf '\nleftover partial edit\n' >>"$d/logs/work-loop/restart-task.md"
run_dispatch "$d" restart-task --actor-cmd "$FLIP"
expect_rc 25 "$RC" "exits 25 restarting over an uncommitted turn: codex file" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched over a partial edit" || bad "no actor launched over a partial edit"

# Codex's side of the same seam: uncommitted with turn: claude is the expected
# handoff, because Codex writes the file and never runs git. Must proceed.
d="$(new_sandbox)"; state_file "$d" "handoff-task" "claude"
printf '\nCodex just wrote this and cannot commit it.\n' >>"$d/logs/work-loop/handoff-task.md"
run_dispatch "$d" handoff-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -eq 23 ] && [ "$(calls "$d")" = "1" ]; then
  ok "an uncommitted turn: claude file is accepted as the Codex handoff and runs"
else
  bad "an uncommitted turn: claude file is accepted as the Codex handoff and runs" "rc=$RC calls=$(calls "$d")"
fi

# ================================================================= case 14
# Cluster 1 (controller side). An unattended actor that blocks on an approval
# nobody will ever give must be killed on the clock, not waited on forever, and
# the dispatcher must not touch any permission surface to get past it.
echo
echo "Case 14 — an actor blocked on an approval prompt is killed, not waited on"
d="$(new_sandbox)"; state_file "$d" "approval-task" "claude"
mkdir -p "$d/.claude"
printf '{\n  "permissions": { "defaultMode": "default" }\n}\n' >"$d/.claude/settings.json"
git -C "$d" add .claude/settings.json >/dev/null 2>&1
git -C "$d" commit -qm "fixture: sandbox settings" >/dev/null 2>&1
set_before="$(shasum -a 256 "$d/.claude/settings.json" | cut -d' ' -f1)"
BLOCKED_ON_APPROVAL='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      echo "Claude needs your permission to use Bash. Allow? (y/n)";
      sleep 120'
t0="$(date '+%s')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task approval-task --log-dir "$d/runs" \
       --timeout 4 --actor-cmd "$BLOCKED_ON_APPROVAL" 2>&1)"; RC=$?
took=$(( $(date '+%s') - t0 ))
expect_rc 21 "$RC" "exits 21 when the actor blocks on an approval it never gets" "$OUT"
if [ "$took" -lt 25 ]; then
  ok "the blocked actor was killed on the clock (${took}s for a 4s deadline)"
else
  bad "the blocked actor was killed on the clock" "took ${took}s for a 4s deadline"
fi
grep -q "Allow? (y/n)" "$d/runs/"*.hop1.claude.out 2>/dev/null \
  && ok "the captured output shows it stopped ON the approval prompt, not on work" \
  || bad "the captured output shows it stopped ON the approval prompt, not on work"
set_after="$(shasum -a 256 "$d/.claude/settings.json" | cut -d' ' -f1)"
[ "$set_before" = "$set_after" ] && ok "no permission surface was touched to get past it" \
                                || bad "no permission surface was touched to get past it"
grep -q '^turn: claude$' "$d/logs/work-loop/approval-task.md" \
  && ok "the state file did not move" || bad "the state file did not move"

# ================================================================= case 15
# Cluster 2. A crash BEFORE the actor changed anything is retried once from
# repository truth. A crash AFTER it changed something is not.
echo
echo "Case 15 — a pre-edit crash is retried exactly once"
d="$(new_sandbox)"; state_file "$d" "retry-task" "claude"
RETRY_ONCE='if [ ! -f "$WL_CHECKOUT.attempt" ]; then touch "$WL_CHECKOUT.attempt"; exit 7; fi;
      '"$FLIP_TO_OPERATOR"
run_dispatch "$d" retry-task --actor-cmd "$RETRY_ONCE"
expect_rc 0 "$RC" "the retried hop completes and reaches turn: operator" "$OUT"
printf '%s' "$OUT" | grep -q "retrying this hop once" \
  && ok "the run log says it retried, and why" || bad "the run log says it retried, and why"
if [ "$(ls "$d/runs/" 2>/dev/null | grep -c '\.hop1r\.claude\.out$')" = "1" ]; then
  ok "the first attempt's output was kept as separate evidence"
else
  bad "the first attempt's output was kept as separate evidence" "no hop1r capture in $d/runs/"
fi
[ "$(calls "$d")" = "1" ] && ok "exactly one successful actor call was recorded" \
                          || bad "exactly one successful actor call was recorded" "calls=$(calls "$d")"

echo
echo "Case 15b — a crash AFTER a repository change is not retried"
d="$(new_sandbox)"; state_file "$d" "partial-task" "codex"
CRASH_AFTER_EDIT="$FLIP_BODY"'; exit 9'
run_dispatch "$d" partial-task --actor-cmd "$CRASH_AFTER_EDIT"
expect_rc 20 "$RC" "exits 20 without retrying over a partial effect" "$OUT"
printf '%s' "$OUT" | grep -q "not retried" \
  && ok "the stop names the partial effect as the reason" || bad "the stop names the partial effect as the reason"
[ "$(calls "$d")" = "1" ] && ok "the failed actor was launched once, not twice" \
                          || bad "the failed actor was launched once, not twice" "calls=$(calls "$d")"

# ================================================================= case 16
# Cluster 3. Foreign work that was ALREADY in the working tree. The before/after
# delta cannot see this — both snapshots contain it — so it used to pass through.
echo
echo "Case 16 — foreign UNSTAGED work stops the run before any launch"
d="$(new_sandbox)"; state_file "$d" "unstaged-task" "codex"
printf 'foreign unstaged edit\n' >>"$d/other.txt"
run_dispatch "$d" unstaged-task --actor-cmd "$FLIP"
expect_rc 18 "$RC" "exits 18 on a modified tracked file outside the allowlist" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched over foreign unstaged work" \
                          || bad "no actor launched over foreign unstaged work" "calls=$(calls "$d")"
printf '%s' "$OUT" | grep -q "Recoverable next action" \
  && ok "the stop names a recoverable next action" || bad "the stop names a recoverable next action"

d="$(new_sandbox)"; state_file "$d" "untracked-task" "codex"
printf 'stray\n' >"$d/somebody-elses-file.txt"
run_dispatch "$d" untracked-task --actor-cmd "$FLIP"
expect_rc 18 "$RC" "exits 18 on an untracked file outside the allowlist" "$OUT"

# The expected uncommitted Codex handoff must still run: the state file is inside
# the allowlist, so it is never foreign work.
d="$(new_sandbox)"; state_file "$d" "still-runs-task" "claude"
printf '\nCodex wrote this and cannot commit it.\n' >>"$d/logs/work-loop/still-runs-task.md"
run_dispatch "$d" still-runs-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -eq 23 ] && [ "$(calls "$d")" = "1" ]; then
  ok "the uncommitted Codex handoff still launches under the new gate"
else
  bad "the uncommitted Codex handoff still launches under the new gate" "rc=$RC calls=$(calls "$d")"
fi

# ================================================================= case 17
echo
echo "Case 17 — Git lock contention stops the run before any launch"
d="$(new_sandbox)"; state_file "$d" "lockfile-task" "codex"
touch "$d/.git/index.lock"
run_dispatch "$d" lockfile-task --actor-cmd "$FLIP"
expect_rc 19 "$RC" "exits 19 while a Git index.lock is held" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched while another Git process is writing" \
                          || bad "no actor launched while another Git process is writing"
rm -f "$d/.git/index.lock"

# ================================================================= case 18
echo
echo "Case 18 — an in-progress merge, rebase or cherry-pick stops the run"
for marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
  d="$(new_sandbox)"; state_file "$d" "midop-task" "codex"
  printf '0000000000000000000000000000000000000000\n' >"$d/.git/$marker"
  run_dispatch "$d" midop-task --actor-cmd "$FLIP"
  expect_rc 19 "$RC" "exits 19 with $marker present" "$OUT"
  [ "$(calls "$d")" = "0" ] && ok "no actor launched with $marker present" \
                           || bad "no actor launched with $marker present" "calls=$(calls "$d")"
done
for dir in rebase-merge rebase-apply; do
  d="$(new_sandbox)"; state_file "$d" "midop-task" "codex"
  mkdir -p "$d/.git/$dir"
  run_dispatch "$d" midop-task --actor-cmd "$FLIP"
  expect_rc 19 "$RC" "exits 19 with $dir/ present" "$OUT"
done

# ================================================================= case 19
echo
echo "Case 19 — a duplicate completion event relaunches nothing"
d="$(new_sandbox)"; state_file "$d" "dup-task" "claude"
run_dispatch "$d" dup-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "the first run reaches turn: operator" "$OUT"
first_calls="$(calls "$d")"
run_dispatch "$d" dup-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "the duplicate run also exits 0" "$OUT"
[ "$(calls "$d")" = "$first_calls" ] \
  && ok "the duplicate run launched nothing (calls stayed at $first_calls)" \
  || bad "the duplicate run launched nothing" "was $first_calls, now $(calls "$d")"

# ================================================================= case 20
# Cluster 4. turn: operator reached by a genuine core § 7 question, not by a
# normal close — and the question survives, visibly unanswered.
echo
echo "Case 20 — a core § 7 operator question is preserved and left unanswered"
d="$(new_sandbox)"; state_file "$d" "opq-task" "claude"
ASK_OPERATOR='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      { printf -- "---\ntask: %s\nstatus: blocked\nturn: operator\n---\n\n" "$WL_TASK";
        printf "## Objective and scope\nSandbox fixture.\n\n";
        printf "## Lane and unit\nStandard. Implementation mode. Unit 1 — harness fixture.\n\n";
        printf "## Latest result\nStopped to ask.\n\n";
        printf "## Blocker\nOPERATOR-Q7: this change is hard to reverse. Authorise it?\n\n";
        printf "## Next action\nOperator decides. Neither model may answer this.\n"; } > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" opq-task --actor-cmd "$ASK_OPERATOR"
expect_rc 0 "$RC" "stops at turn: operator on a genuine question" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "zero further launches after the question was raised" \
                          || bad "zero further launches after the question was raised" "calls=$(calls "$d")"
grep -q 'OPERATOR-Q7' "$d/logs/work-loop/opq-task.md" \
  && ok "the question is preserved in the state file" || bad "the question is preserved in the state file"
printf '%s' "$OUT" | grep -q 'OPERATOR-Q7' \
  && ok "the dispatcher surfaces the question rather than swallowing it" \
  || bad "the dispatcher surfaces the question rather than swallowing it"
printf '%s' "$OUT" | grep -q 'UNANSWERED' \
  && ok "the output states that nobody answered it" || bad "the output states that nobody answered it"

# ================================================================= case 21
# Cluster 4, the other cause. turn: operator reached by a core § 4 CLOSE, which
# deletes ## Blocker and ## Next action. The stop is still correct; the message
# must not claim an unanswered question that the closing record does not contain.
# Exposed live on 2026-08-05 by the two-worktree parallel proof: both tasks
# closed, and both printed "The question below is UNANSWERED" above nothing.
echo
echo "Case 21 — turn: operator reached by a close is announced as a close, not as a question"
d="$(new_sandbox)"; state_file "$d" "closed-task" "claude"
CLOSE_TASK='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      { printf -- "---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n" "$WL_TASK";
        printf "## Outcome\nUnit 1 done.\n\n";
        printf "## Decisions that matter\nNone.\n\n";
        printf "## Evidence\nCommit deadbeef.\n\n";
        printf "## Accepted limitations\nNone.\n"; } > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" closed-task --actor-cmd "$CLOSE_TASK"
expect_rc 0 "$RC" "stops at turn: operator on a close" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "zero further launches after the close" \
                          || bad "zero further launches after the close" "calls=$(calls "$d")"
printf '%s' "$OUT" | grep -q 'UNANSWERED' \
  && bad "the output does not claim an unanswered question" "it printed UNANSWERED for a closed task" \
  || ok "the output does not claim an unanswered question"
printf '%s' "$OUT" | grep -q 'CLOSED' \
  && ok "the output names the close" || bad "the output names the close" "$OUT"

# ================================================================= case 22
# The classification seam case 21 opened. Absence of ## Blocker and ## Next action
# is NECESSARY for a core § 4 closing record and not SUFFICIENT: a Claude hop that
# died after deleting the active fields and before writing the record leaves a file
# with neither section and no closing record either. Calling that "closed" is a
# guess dressed as a verdict, so it must stop for inspection instead.
echo
echo "Case 22 — a malformed turn: operator record is NOT labelled closed"
d="$(new_sandbox)"
cat >"$d/logs/work-loop/partial-task.md" <<'EOF'
---
task: partial-task
status: closed
turn: operator
---

## Objective and scope
A half-written file: the active fields are gone and the closing record was never
finished. Neither a core § 7 question nor a core § 4 closing record.

## Outcome
Unit 1 pro
EOF
git -C "$d" add logs/work-loop/partial-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: partial-task" >/dev/null 2>&1
run_dispatch "$d" partial-task
expect_rc 26 "$RC" "stops 26 on a turn: operator file that is neither shape" "$OUT"
printf '%s' "$OUT" | grep -q 'CLOSED' \
  && bad "a malformed record is not announced as closed" "it printed CLOSED for a partial file" \
  || ok "a malformed record is not announced as closed"
printf '%s' "$OUT" | grep -q 'Recoverable next action' \
  && ok "the stop names a recoverable next action" || bad "the stop names a recoverable next action" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched on the malformed terminal record" \
                          || bad "no actor was launched on the malformed terminal record" "calls=$(calls "$d")"

# A closing record whose four headings are present but joined by a FIFTH surviving
# section is also not a closing record — core § 4 says nothing else survives.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/extra-task.md" <<'EOF'
---
task: extra-task
status: closed
turn: operator
---

## Outcome
Done.

## Decisions that matter
None.

## Evidence
Commit deadbeef.

## Accepted limitations
None.

## Objective and scope
This active field should not have survived the reduction.
EOF
git -C "$d" add logs/work-loop/extra-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: extra-task" >/dev/null 2>&1
run_dispatch "$d" extra-task
expect_rc 26 "$RC" "stops 26 when an active field survived the reduction" "$OUT"

# The four headings present with nothing else, but SHUFFLED. Core § 4 names the
# closing record as an exact shape; "the right sections in some order" is a
# different, weaker claim. A classifier that sorts before comparing cannot see this.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/shuffled-task.md" <<'EOF'
---
task: shuffled-task
status: closed
turn: operator
---

## Evidence
Commit deadbeef.

## Outcome
Done.

## Accepted limitations
None.

## Decisions that matter
None.
EOF
git -C "$d" add logs/work-loop/shuffled-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: shuffled-task" >/dev/null 2>&1
run_dispatch "$d" shuffled-task
expect_rc 26 "$RC" "stops 26 when the four headings are out of core § 4 order" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched on the out-of-order record" \
                          || bad "no actor was launched on the out-of-order record" "calls=$(calls "$d")"

# The four headings in the right order, but one written TWICE. Deduplicating
# before comparing hides this the same way sorting hides the case above.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/dup-task.md" <<'EOF'
---
task: dup-task
status: closed
turn: operator
---

## Outcome
Done.

## Decisions that matter
None.

## Evidence
Commit deadbeef.

## Evidence
Commit cafebabe.

## Accepted limitations
None.
EOF
git -C "$d" add logs/work-loop/dup-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: dup-task" >/dev/null 2>&1
run_dispatch "$d" dup-task
expect_rc 26 "$RC" "stops 26 when a closing section appears twice" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched on the duplicated-section record" \
                          || bad "no actor was launched on the duplicated-section record" "calls=$(calls "$d")"

# ================================================================= case 23
echo
echo "Case 23 — --carry-one carries exactly one hop and exits 0"
# The defect this mode exists for: without --carry-one, a one-hop carry ends at the
# hop limit, which is exit 23 — a failure code for the expected outcome. Both halves
# are asserted here, so the mode cannot silently regress into the old behaviour.
d="$(new_sandbox)"; state_file "$d" "carry-task" "claude"
run_dispatch "$d" carry-task --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0 after one carried hop" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "exactly one actor call" || bad "exactly one actor call" "calls=$(calls "$d")"
grep -qx "turn: codex" "$d/logs/work-loop/carry-task.md" \
  && ok "the turn moved claude -> codex" \
  || bad "the turn moved claude -> codex" "$(sed -n '3p' "$d/logs/work-loop/carry-task.md")"
printf '%s' "$OUT" | grep -q "carry-one: the turn moved claude -> codex" \
  && ok "the carry is announced with both turns named" \
  || bad "the carry is announced with both turns named" "$OUT"

# The same fixture WITHOUT --carry-one, to prove the exit code actually differs.
# A green case 23 above means nothing if the default path already returned 0.
d="$(new_sandbox)"; state_file "$d" "carry-task" "claude"
run_dispatch "$d" carry-task --max-hops 1 --actor-cmd "$FLIP"
expect_rc 23 "$RC" "the same single hop WITHOUT --carry-one exits 23 HOP_LIMIT" "$OUT"

# ================================================================= case 24
echo
echo "Case 24 — --carry-one keeps every post-hop guard"
# The mode must be a shorter run, not a weaker one. Each guard below would stop a
# full loop; each must still stop a carry.
d="$(new_sandbox)"
run_dispatch "$d" decoy-mismatch --carry-one --actor-cmd "$FLIP"
expect_rc 14 "$RC" "identity mismatch still stops the carry (14)" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched on the mismatched file" \
                          || bad "no actor launched on the mismatched file" "calls=$(calls "$d")"

d="$(new_sandbox)"; state_file "$d" "carry-noop" "claude"
run_dispatch "$d" carry-noop --carry-one --actor-cmd "$NOOP"
expect_rc 22 "$RC" "a no-op actor still stops the carry (22)" "$OUT"

# An actor that edits a path the allowlist does not cover. The carry must fail 24
# rather than reporting a clean one-hop success.
d="$(new_sandbox)"; state_file "$d" "carry-stray" "claude"
STRAY="$FLIP_BODY"'; printf "stray\n" >> "$WL_CHECKOUT/other.txt"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" carry-stray --carry-one --actor-cmd "$STRAY"
expect_rc 24 "$RC" "an out-of-allowlist change still stops the carry (24)" "$OUT"

# Claude edits the state file and does not commit it — the measured live shape of
# a refused git permission. It must stop the carry, not pass as a moved turn.
d="$(new_sandbox)"; state_file "$d" "carry-uncommitted" "claude"
run_dispatch "$d" carry-uncommitted --carry-one --actor-cmd "$FLIP_BODY"
expect_rc 25 "$RC" "an uncommitted Claude handback still stops the carry (25)" "$OUT"

# ================================================================= case 25
echo
echo "Case 25 — --carry-one on a turn that is already operator"
# Exit 0 here means "nothing to carry", not "a turn was carried". The two are told
# apart by reading turn: from the file, which is why the run says so explicitly.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/closed-task.md" <<'EOF'
---
task: closed-task
status: closed
turn: operator
---

## Outcome
Done.

## Decisions that matter
None.

## Evidence
Commit deadbeef.

## Accepted limitations
None.
EOF
git -C "$d" add logs/work-loop/closed-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: closed-task" >/dev/null 2>&1
run_dispatch "$d" closed-task --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0 on turn: operator" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"
printf '%s' "$OUT" | grep -q "carry-one: the turn moved" \
  && bad "does NOT claim a turn was carried" "$OUT" \
  || ok "does NOT claim a turn was carried"

# ================================================================= case 26
echo
echo "Case 26 — --carry-one --dry-run launches nothing"
d="$(new_sandbox)"; state_file "$d" "carry-dry" "claude"
before="$(shasum -a 256 "$d/logs/work-loop/carry-dry.md" | cut -d' ' -f1)"
run_dispatch "$d" carry-dry --carry-one --dry-run --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"
[ "$before" = "$(shasum -a 256 "$d/logs/work-loop/carry-dry.md" | cut -d' ' -f1)" ] \
  && ok "the state file is byte-identical afterwards" \
  || bad "the state file is byte-identical afterwards"
printf '%s' "$OUT" | grep -q "carry-one would launch actor 'claude'" \
  && ok "names the actor it would carry" || bad "names the actor it would carry" "$OUT"

# ================================================================= case 27
# Phase 1a. The defect these cases pin down was OBSERVED before it was fixed —
# runs/probe-interruption-2026-08-07.md. The old handler released the lock and let
# the run continue, so a stop attempt UNLOCKED the task instead of ending it.
echo
echo "Case 27 — SIGTERM stops the run, the actor, and the actor's descendants"
d="$(new_sandbox)"; state_file "$d" "sig-task" "claude"
SIGROOT="$SANDBOX_ROOT/sig27"; mkdir -p "$SIGROOT"
# An actor that spawns a grandchild, then hangs. The grandchild is the point:
# `pkill -P` reaches one generation, and a live Claude hop runs deeper than that.
SLOW_ACTOR='( sleep 300 ) & echo "$!" > "'"$SIGROOT"'/gc.pid"; echo $$ > "'"$SIGROOT"'/actor.pid"; sleep 300'
bash "$DISPATCH_BIN" --checkout "$d" --task sig-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$SLOW_ACTOR" >"$SIGROOT/out" 2>&1 &
DPID=$!
for _ in $(seq 1 40); do [ -f "$SIGROOT/gc.pid" ] && break; sleep 0.5; done
sleep 1
APID="$(cat "$SIGROOT/actor.pid" 2>/dev/null)"; GPID="$(cat "$SIGROOT/gc.pid" 2>/dev/null)"
LK="$(task_lock_for "$d" sig-task)"

if [ -z "$APID" ]; then
  bad "the simulated actor started" "no actor pid file; case 27 is inconclusive"
else
  ok "the simulated actor started (pid $APID, grandchild $GPID)"
  kill -TERM "$DPID" 2>/dev/null
  sleep 6
  kill -0 "$DPID" 2>/dev/null && bad "the dispatcher exits on SIGTERM" "still alive 6s later" \
                              || ok "the dispatcher exits on SIGTERM"
  kill -0 "$APID" 2>/dev/null && bad "the actor is terminated" "actor $APID survived" \
                              || ok "the actor is terminated"
  kill -0 "$GPID" 2>/dev/null && bad "the actor's DESCENDANTS are terminated" "grandchild $GPID survived" \
                              || ok "the actor's DESCENDANTS are terminated"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "exits 28 INTERRUPTED (not 0 — an interrupted run is not a finished one)" "$(cat "$SIGROOT/out")"
  [ -d "$LK" ] && bad "the lock is released" "$LK still held" || ok "the lock is released"
  grep -q "STOP \[28\]" "$SIGROOT/out" && ok "the run log records the interruption" \
                                       || bad "the run log records the interruption" "$(cat "$SIGROOT/out")"
  grep -q "Nothing is retried" "$SIGROOT/out" && ok "states that nothing is retried" \
                                              || bad "states that nothing is retried"
  # The whole point of the old defect: it let a SECOND dispatcher onto the same
  # state file while the first was still running. Now the first is gone, so a
  # second is legitimate — this asserts the lock is not merely leaked.
  kill -KILL "$APID" "$GPID" 2>/dev/null
fi
rm -rf "$LK" 2>/dev/null

# ====================================================== cases 27b .. 27h
# Phase 1a, the escaped-descendant half.
#
# WHAT CHANGED, AND WHY THE OLD EXPECTATION WAS THE DEFECT. Case 27b used to
# assert that a `setsid` descendant SURVIVES the stop, and it was right to: the
# teardown killed a process GROUP, so that was the measured boundary and pinning
# it was better than pretending otherwise. That boundary is now gone. dispatch.sh
# terminates the union of the process group, the recursive ancestry walk and the
# holders of the hop's inherited output descriptor, and VERIFIES the result before
# releasing the lock. So 27b now asserts the opposite outcome — not because the
# old coverage was inconvenient, but because the behaviour it described was the
# thing 1a called a blocker: a stop that leaves a process running is not a stop.
# The surviving limitation is pinned by 27h, which is the honest replacement for
# what 27b used to guard.
#
# Every case below asserts the escapee was REAL before the stop — alive, and
# genuinely outside the actor's process group. Without that, a case could go green
# because the escapee never started, or never escaped.

escapee_is_real() { # actor-pid escapee-pid label -> 0 when the control holds
  local ap="$1" ep="$2" lab="$3" apg epg
  if [ -z "$ep" ] || ! kill -0 "$ep" 2>/dev/null; then
    bad "$lab — control: the escapee is running before the stop" "pid '${ep:-<none>}' is not alive; the case proves nothing"
    return 1
  fi
  apg="$(ps -o pgid= -p "$ap" 2>/dev/null | tr -d ' ')"
  epg="$(ps -o pgid= -p "$ep" 2>/dev/null | tr -d ' ')"
  if [ -z "$apg" ] || [ -z "$epg" ] || [ "$apg" = "$epg" ]; then
    bad "$lab — control: the escapee really left the actor's process group" \
        "actor pgid='$apg' escapee pgid='$epg'; an in-group child would pass this case trivially"
    return 1
  fi
  ok "$lab — control: escapee alive and OUTSIDE the actor's group (actor pgid=$apg, escapee pgid=$epg)"
  return 0
}

must_be_dead() { # pid label
  if [ -n "$1" ] && kill -0 "$1" 2>/dev/null; then bad "$2" "pid $1 survived the stop"; else ok "$2"; fi
}

reap() { local p; for p in "$@"; do [ -n "$p" ] && kill -KILL "$p" 2>/dev/null; done; }

drop_lock() { # sandbox task
  rm -rf "$(task_lock_for "$1" "$2")" "$(checkout_lock_for "$1")" 2>/dev/null
}

# Defined out here, not beside its first user: the degraded-sweep cases that use
# it sit inside the python3 guard below, but case 30d does not, and a host
# without python3 would otherwise reach 30d with this function undefined.
lock_path_for() { # checkout task -> task lock dir (alias kept for its callers)
  task_lock_for "$1" "$2"
}

if ! command -v python3 >/dev/null 2>&1; then
  echo
  echo "Cases 27b-27h — SKIP: python3 unavailable; cannot create a detached session portably"
else

# A descendant in its own session AND process group that also IGNORES SIGTERM.
# The TERM-resistance is what stops the KILL half of the escalation being prose:
# this process can only be removed by SIGKILL.
mk_stubborn() { # pidfile -> actor fragment
  printf '%s' 'python3 -c "
import os, sys, signal, time
os.setsid()
signal.signal(signal.SIGTERM, signal.SIG_IGN)
with open(\"'"$1"'\",\"w\") as f: f.write(str(os.getpid()))
time.sleep(300)
" &'
}

# A double-forked grandchild: re-parented to pid 1 the instant the intermediate
# exits, so no ancestry walk can find it, then exec'd into /bin/sleep so it is
# also a SIP-protected platform binary whose environment cannot be read. This is
# the hardest shape — only the inherited descriptor reaches it.
mk_orphan() { # pidfile -> actor fragment
  printf '%s' 'python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$1"'\",\"w\") as f: f.write(str(os.getpid()))
os.execv(\"/bin/sleep\", [\"sleep\", \"300\"])
" &'
}

wait_for() { # file [file...] -> waits up to 20s
  local f _
  for _ in $(seq 1 40); do
    local all=1
    for f in "$@"; do [ -s "$f" ] || all=0; done
    [ "$all" -eq 1 ] && return 0
    sleep 0.5
  done
  return 1
}

# ================================================================ case 27b
echo
echo "Case 27b — SIGTERM reaches a TERM-RESISTANT descendant that left the group"
d="$(new_sandbox)"; state_file "$d" "setsid-task" "claude"
SR="$SANDBOX_ROOT/sig27b"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task setsid-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27b"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$APID" "the in-group actor dies"
  must_be_dead "$EPID" "the OUT-OF-GROUP, TERM-RESISTANT descendant is GONE (SIGKILL half proven)"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "still exits 28 INTERRUPTED" "$(cat "$SR/out")"
  grep -q "teardown verified" "$SR/out" \
    && ok "the run log records a VERIFIED teardown" || bad "the run log records a VERIFIED teardown" "$(cat "$SR/out")"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" setsid-task

# ================================================================ case 27c
echo
echo "Case 27c — SIGTERM reaches a DOUBLE-FORKED orphan re-parented to pid 1"
d="$(new_sandbox)"; state_file "$d" "orphan-task" "claude"
SR="$SANDBOX_ROOT/sig27c"; mkdir -p "$SR"
ACT="$(mk_orphan "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task orphan-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
# The extra control this case needs: the orphan must really be re-parented, or it
# would be reachable by the ancestry walk and prove nothing about the fd handle.
OPPID="$(ps -o ppid= -p "$EPID" 2>/dev/null | tr -d ' ')"
if [ "$OPPID" = "1" ]; then
  ok "27c — control: the orphan is re-parented to pid 1 (no ancestry link survives)"
else
  bad "27c — control: the orphan is re-parented to pid 1" "ppid is '$OPPID'; the double fork did not take"
fi
if escapee_is_real "$APID" "$EPID" "27c"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$APID" "the in-group actor dies"
  must_be_dead "$EPID" "the ORPHANED, re-parented, SIP-binary descendant is GONE"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "still exits 28 INTERRUPTED" "$(cat "$SR/out")"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" orphan-task

# ================================================================ case 27d
echo
echo "Case 27d — SIGINT (the other trap) reaches an escaped descendant too"
d="$(new_sandbox)"; state_file "$d" "sigint-task" "claude"
SR="$SANDBOX_ROOT/sig27d"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
# `set -m` is load-bearing here, and it took a failing run to find out. A command
# backgrounded from a NON-interactive shell has SIGINT set to IGNORED by POSIX
# rule, and bash cannot trap a signal that was ignored on entry — so without job
# control the dispatcher never saw this signal, ran its actor to completion, and
# the case "failed" for a reason that has nothing to do with the dispatcher. Job
# control gives the child its own process group and default dispositions, which is
# the shape an operator's Ctrl-C actually reaches.
set -m
bash "$DISPATCH_BIN" --checkout "$d" --task sigint-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
set +m
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27d"; then
  kill -INT "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$EPID" "SIGINT clears the escaped descendant (both traps asserted, not assumed shared)"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "SIGINT also exits 28" "$(cat "$SR/out")"
  grep -q "SIGINT" "$SR/out" && ok "the stop names SIGINT" || bad "the stop names SIGINT" "$(cat "$SR/out")"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" sigint-task

# ================================================================ case 27e
echo
echo "Case 27e — the PER-ACTOR TIMEOUT path (exit 21) clears escaped descendants"
d="$(new_sandbox)"; state_file "$d" "timeout-esc" "claude"
SR="$SANDBOX_ROOT/sig27e"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    $(mk_orphan "$SR/orphan.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
( bash "$DISPATCH_BIN" --checkout "$d" --task timeout-esc --log-dir "$d/runs" \
    --timeout 6 --actor-cmd "$ACT" >"$SR/out" 2>&1; echo $? >"$SR/rc" ) &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/orphan.pid" "$SR/actor.pid"
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; OPID="$(cat "$SR/orphan.pid" 2>/dev/null)"
APID="$(cat "$SR/actor.pid" 2>/dev/null)"
escapee_is_real "$APID" "$EPID" "27e"
wait "$DPID" 2>/dev/null
sleep 1
expect_rc 21 "$(cat "$SR/rc" 2>/dev/null || echo 99)" "exits 21 ACTOR_TIMEOUT" "$(cat "$SR/out")"
must_be_dead "$EPID" "the timeout path clears the TERM-resistant escapee"
must_be_dead "$OPID" "the timeout path clears the double-forked orphan"
reap "$EPID" "$OPID" "$APID"
drop_lock "$d" timeout-esc

# ================================================================ case 27f
echo
echo "Case 27f — the GLOBAL DEADLINE path (exit 29) clears escaped descendants"
d="$(new_sandbox)"; state_file "$d" "deadline-esc" "claude"
SR="$SANDBOX_ROOT/sig27f"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
( bash "$DISPATCH_BIN" --checkout "$d" --task deadline-esc --log-dir "$d/runs" \
    --timeout 300 --deadline 6 --actor-cmd "$ACT" >"$SR/out" 2>&1; echo $? >"$SR/rc" ) &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
escapee_is_real "$APID" "$EPID" "27f"
wait "$DPID" 2>/dev/null
sleep 1
expect_rc 29 "$(cat "$SR/rc" 2>/dev/null || echo 99)" "exits 29 BUDGET_EXHAUSTED" "$(cat "$SR/out")"
must_be_dead "$EPID" "the deadline path clears the escaped descendant"
reap "$EPID" "$APID"
drop_lock "$d" deadline-esc

# ================================================================ case 27g
# The evidence guard. Every case above would go green if the teardown were simply
# killing everything in sight, so this proves the OLD mechanism could not have
# passed them: a group-only TERM, applied to the same escapee, leaves it running.
# It also proves the harness can tell an in-group child from an escaped one.
echo
echo "Case 27g — positive control: a GROUP-ONLY kill does NOT reach these escapees"
SR="$SANDBOX_ROOT/sig27g"; mkdir -p "$SR"
set -m
bash -c "$(mk_stubborn "$SR/escapee.pid")
  ( sleep 300 ) & echo \$! > \"$SR/ingroup.pid\"
  echo \$\$ > \"$SR/actor.pid\"; sleep 300" >"$SR/out" 2>&1 &
CTRL=$!
set +m
wait_for "$SR/escapee.pid" "$SR/ingroup.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; IPID="$(cat "$SR/ingroup.pid" 2>/dev/null)"
CPG="$(ps -o pgid= -p "$CTRL" 2>/dev/null | tr -d ' ')"
kill -TERM -- "-$CPG" 2>/dev/null
sleep 3
if [ -n "$IPID" ] && kill -0 "$IPID" 2>/dev/null; then
  bad "the group-only kill DOES reach an in-group child" "in-group child $IPID survived; the control is broken"
else
  ok "the group-only kill DOES reach an in-group child"
fi
if [ -n "$EPID" ] && kill -0 "$EPID" 2>/dev/null; then
  ok "the group-only kill does NOT reach the escapee — so cases 27b-27f are not passing trivially"
else
  bad "the group-only kill does NOT reach the escapee" \
      "the escapee died from a group kill alone; the escape shape is wrong and 27b-27f prove nothing"
fi
reap "$EPID" "$IPID" "$CTRL"

# ================================================================ case 27h
# THE RESIDUAL, pinned. This is the honest successor to what old-27b guarded.
#
# NOTE THE SHAPE CHANGE (2026-08-07 correction). This case used to close only
# fds 0/1/2, because the fd handle then read the hop's `.out` log. The handle now
# reads a PRIVATE marker descriptor, which such a process still holds — so that
# shape is now CAUGHT, and using it here would have quietly turned the residual
# test into a pass that proves nothing. The residual shape is now what a real
# daemon does: `closerange` over every inherited descriptor.
echo
echo "Case 27h — a descendant that closes EVERY inherited descriptor survives, and the claim stays scoped"
d="$(new_sandbox)"; state_file "$d" "residual-task" "claude"
SR="$SANDBOX_ROOT/sig27h"; mkdir -p "$SR"
INVISIBLE='python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$SR"'/escapee.pid\",\"w\") as f: f.write(str(os.getpid()))
os.closerange(0, 64)
os.execv(\"/bin/sleep\", [\"sleep\", \"300\"])
" &'
ACT="$INVISIBLE
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task residual-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27h"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$APID" "the in-group actor still dies"
  if kill -0 "$EPID" 2>/dev/null; then
    ok "the fd-closing orphan SURVIVES — the residual is real and measured, not assumed"
  else
    bad "the fd-closing orphan SURVIVES — the residual is real and measured" \
        "it died; the teardown reaches further than dispatch.sh claims, so widen that comment and this case"
  fi
  # The claim must be scoped to what the handles can see. An unqualified success
  # line here would be the 1a defect wearing a verification badge.
  if grep -q "no descendant reachable by group, ancestry or inherited descriptor" "$SR/out"; then
    ok "the success line is SCOPED to the handles that were actually checked"
  else
    bad "the success line is SCOPED to the handles that were actually checked" \
        "teardown reported something else: $(grep -i teardown "$SR/out" | head -2)"
  fi
fi
# This case deliberately creates the very escapee 1a exists to prevent. It does
# not leave with one running.
reap "$EPID" "$APID" "$DPID"
sleep 1
if [ -n "$EPID" ] && kill -0 "$EPID" 2>/dev/null; then
  bad "case 27h cleaned up its own escapee" "pid $EPID is STILL running after the case"
else
  ok "case 27h cleaned up its own escapee"
fi
drop_lock "$d" residual-task

# ================================================================ case 27i
# THE NEGATIVE CONTROL for the fd handle, and the regression test for a defect
# this work introduced and had to be told about.
#
# The first version censused holders of the hop's `.out` log. That reached the
# escapees, and it also reached anything ELSE holding the file — an operator's
# `tail -f` was sent TERM and then KILL. Reproduced before the fix: a `tail`
# started outside the run went from ALIVE to GONE across one teardown.
#
# The handle now reads a private per-hop marker descriptor that only descendants
# inherit. This case pins that: an unrelated reader of the hop log must be
# untouched, while the escapee in the same run must still die. Both halves matter
# — asserting only the survival of `tail` would pass on a teardown that had
# stopped working altogether.
echo
echo "Case 27i — an UNRELATED holder of the hop log is never signalled by teardown"
d="$(new_sandbox)"; state_file "$d" "bystander-task" "claude"
SR="$SANDBOX_ROOT/sig27i"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task bystander-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
HOPLOG="$(ls "$d"/runs/*.hop1.claude.out 2>/dev/null | head -1)"
if [ -z "$HOPLOG" ]; then
  bad "27i — control: the hop log exists to be watched" "no hop .out file found"
else
  tail -f "$HOPLOG" >/dev/null 2>&1 &
  BYSTANDER=$!
  sleep 1
  if kill -0 "$BYSTANDER" 2>/dev/null; then
    ok "27i — control: an unrelated reader is holding the hop log ($BYSTANDER)"
  else
    bad "27i — control: an unrelated reader is holding the hop log" "the tail did not start"
  fi
  if escapee_is_real "$APID" "$EPID" "27i"; then
    kill -TERM "$DPID" 2>/dev/null
    sleep 11
    must_be_dead "$EPID" "the escapee still dies (the handle did not stop working)"
    if kill -0 "$BYSTANDER" 2>/dev/null; then
      ok "the UNRELATED reader of the hop log SURVIVES teardown"
    else
      bad "the UNRELATED reader of the hop log SURVIVES teardown" \
          "pid $BYSTANDER was killed — teardown is signalling processes it does not own"
    fi
  fi
  reap "$BYSTANDER"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" bystander-task

# ================================================================ case 27j
# DISCOVERY FAILURE MUST NOT READ AS SUCCESS.
#
# When `lsof` cannot be found, the fd handle — the only one that reaches an
# escapee at all — is simply absent. The first version printed `teardown verified`
# in that state whenever the two remaining handles happened to come back empty:
# the script's strongest claim, on no evidence. It must now say UNVERIFIED and
# pin the lock.
#
# `lsof` is hidden by giving the dispatcher a PATH without it, while keeping the
# directories its other tools live in.
echo
echo "Case 27j — with lsof absent, teardown reports UNVERIFIED and does not claim success"
d="$(new_sandbox)"; state_file "$d" "degraded-task" "claude"
SR="$SANDBOX_ROOT/sig27j"; mkdir -p "$SR"
# Hide lsof by dropping ONLY the directory it lives in, rather than building a
# PATH of hand-picked symlinks. The hand-built version was tried first and was
# wrong: it silently starved the dispatcher of tools it needs, so the actor never
# started and the case "passed its way" into proving nothing. Removing one
# directory changes exactly one thing.
NOLSOF_PATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v "^$(dirname "$(command -v lsof 2>/dev/null || echo /usr/sbin/lsof)")$" | paste -sd: -)"
if PATH="$NOLSOF_PATH" command -v lsof >/dev/null 2>&1; then
  bad "27j — control: lsof is absent from the constructed PATH" "it is still resolvable; the case would prove nothing"
else
  ok "27j — control: lsof is absent from the constructed PATH"
fi
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$d" --task degraded-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27j"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  if grep -q "teardown UNVERIFIED" "$SR/out"; then
    ok "teardown reports UNVERIFIED when a load-bearing handle is unavailable"
  else
    bad "teardown reports UNVERIFIED when a load-bearing handle is unavailable" \
        "output said: $(grep -i teardown "$SR/out" | head -2)"
  fi
  if grep -q "teardown verified" "$SR/out"; then
    bad "a degraded sweep must NOT print the success line" "it printed 'teardown verified' with lsof missing"
  else
    ok "a degraded sweep does NOT print the success line"
  fi
  grep -q "lsof is not installed" "$SR/out" \
    && ok "the reason names the missing handle" || bad "the reason names the missing handle" "$(grep -i unverified -A2 "$SR/out" | head -4)"
  LK="$(task_lock_for "$d" degraded-task)"
  if [ -f "$LK/survivors" ]; then
    ok "the lock is PINNED after an unverified teardown"
  else
    bad "the lock is PINNED after an unverified teardown" "no survivors file at $LK"
  fi
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" degraded-task

# ================================================================ case 27k
# THE LOCK INVARIANT. The plan requires that no second dispatcher is admitted
# while a descendant of the stopped actor may still be alive. Teardown knew about
# survivors and released the lock anyway, because both call sites discarded its
# return value — so the invariant existed only in prose.
#
# A survivor is manufactured here rather than waited for: the escapee that
# teardown cannot see (case 27h's shape) is the one that leaves the lock pinned
# via the UNKNOWN path, so this case uses the lsof-less PATH to make an
# unverifiable teardown deterministic, then asserts what the operator actually
# experiences — a second dispatcher refused, and `--status` saying why.
echo
echo "Case 27k — an unverified teardown REFUSES a second dispatcher (exit 17) and --status explains"
d="$(new_sandbox)"; state_file "$d" "pinned-task" "claude"
SR="$SANDBOX_ROOT/sig27k"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$d" --task pinned-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
kill -TERM "$DPID" 2>/dev/null
sleep 11
wait "$DPID" 2>/dev/null; SRC=$?
expect_rc 28 "$SRC" "the interrupted run still exits 28 (the pin does not change the exit code)" "$(cat "$SR/out")"
# THE rc=0 CONTROL for cases 27ka and 27kb below. Those two only ever assert the
# durable-pin line is ABSENT, so a dispatcher that had stopped printing it at all
# would satisfy both of them and still be wrong. Here it must be PRESENT, on both
# operator channels, and the record it announces must genuinely be on disk —
# otherwise this is rc=2 wearing rc=0's message.
KTL="$(task_lock_for "$d" pinned-task)"
[ -f "$KTL/survivors" ] \
  && ok "27k control: the pin record really WAS written (this is rc=0, not rc=2)" \
  || bad "27k control: the pin record really WAS written (this is rc=0, not rc=2)" "no survivors file at $KTL"
grep -q "the task lock is PINNED at" "$SR/out" \
  && ok "a DURABLE pin announces itself on the terminal" \
  || bad "a DURABLE pin announces itself on the terminal" "$(cat "$SR/out")"
RL="$(ls -t "$d"/runs/*.log 2>/dev/null | head -1)"
if [ -n "$RL" ] && grep -q "the task lock is PINNED at" "$RL"; then
  ok "and the same line reaches the run log"
else
  bad "and the same line reaches the run log" "run log: ${RL:-none found}"
fi
# The invariant, as the next dispatcher experiences it.
run_dispatch "$d" pinned-task --actor-cmd "$NOOP"
expect_rc 17 "$RC" "a SECOND dispatcher is REFUSED while the tree is unaccounted for" "$OUT"
printf '%s' "$OUT" | grep -q "PINNED" \
  && ok "the refusal says the lock is pinned, not merely held" || bad "the refusal says the lock is pinned" "$OUT"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task pinned-task --log-dir "$d/runs" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "--status stays read-only and exits 0 over a pinned lock" "$OUT"
printf '%s' "$OUT" | grep -q "PINNED LOCK" \
  && ok "--status reports a PINNED LOCK" || bad "--status reports a PINNED LOCK" "$OUT"
if printf '%s' "$OUT" | grep -q "STALE LOCK"; then
  bad "--status must NOT call a pinned lock stale" "it told the operator to remove the one thing holding the invariant"
else
  ok "--status does NOT call a pinned lock stale"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" pinned-task

# ================================================================ case 27ka
# EVERY PIN RESULT REPORTED AS ITSELF.
#
# The lease library answers a pin with three distinct outcomes — 0 durably
# pinned, 1 nothing owned, 2 owned and pinned but with NO durable record. This
# dispatcher wrote `wl_lease_pin ... || return 0`, which merged 1, 2 and any
# future code into the silent no-owned path. Case 27k above is the rc=0 control.
#
# rc=2 is the outcome that matters. The lock DIRECTORIES are retained and still
# refuse a second dispatcher, but the written reason inside them is gone — so the
# operator meets an unexplained held lock, and the obvious reading (a stale lock,
# safe to delete) is the unsafe one.
#
# FORCED FROM INSIDE THE RUN, not by a seam. The actor command runs after the
# locks are acquired and before teardown pins them, so it puts a DIRECTORY where
# each `survivors` FILE has to go. `>` then cannot create the file for any user,
# root included — no privilege, nothing destructive — and `[ -f ]`, the same test
# acquire and --status recognise a pin by, is false afterwards. Same device the
# library's own suite uses.
echo
echo "Case 27ka — a pin whose RECORD did not persist is reported, not silently swallowed"
d="$(new_sandbox)"; state_file "$d" "norecord-task" "claude"
SR="$SANDBOX_ROOT/sig27ka"; mkdir -p "$SR"
KTL="$(task_lock_for "$d" norecord-task)"; KCL="$(checkout_lock_for "$d")"
ACT="$(mk_stubborn "$SR/escapee.pid")
    mkdir -p \"$KTL/survivors\" \"$KCL/survivors\"
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$d" --task norecord-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
kill -TERM "$DPID" 2>/dev/null
sleep 11
wait "$DPID" 2>/dev/null; SRC=$?
OUT="$(cat "$SR/out")"
# The forcing control. If the blocking directories were not in place the pin
# would have persisted normally and every assertion below would be about nothing.
if [ -d "$KTL/survivors" ] && [ ! -f "$KTL/survivors" ]; then
  ok "27ka control: the pin record really could not be written"
else
  bad "27ka control: the pin record really could not be written" "at $KTL"
fi
expect_rc 28 "$SRC" "the interrupted run still exits 28 (an unpersisted record does not change it)" "$OUT"
printf '%s' "$OUT" | grep -q "teardown UNVERIFIED" \
  && ok "the teardown warning still stands" || bad "the teardown warning still stands" "$OUT"
printf '%s' "$OUT" | grep -q "pin RECORD could not be persisted" \
  && ok "the dispatcher says the pin RECORD could not be persisted" \
  || bad "the dispatcher says the pin RECORD could not be persisted" "$OUT"
printf '%s' "$OUT" | grep -q "task checkout" \
  && ok "and NAMES the resources whose evidence is missing" \
  || bad "and NAMES the resources whose evidence is missing" "$OUT"
printf '%s' "$OUT" | grep -q "deliberately RETAINED" \
  && ok "and says the lock directories were RETAINED, not released" \
  || bad "and says the lock directories were RETAINED, not released" "$OUT"
printf '%s' "$OUT" | grep -q "second dispatcher is still refused (exit 17)" \
  && ok "and says a second dispatcher is still refused" \
  || bad "and says a second dispatcher is still refused" "$OUT"
printf '%s' "$OUT" | grep -q "removable stale lock" \
  && ok "and warns against reading them as a removable stale lock" \
  || bad "and warns against reading them as a removable stale lock" "$OUT"
# The false success line is the whole failure this case exists to prevent.
if printf '%s' "$OUT" | grep -q "the task lock is PINNED at"; then
  bad "a pin that recorded nothing must NOT print the durable-pin line" "$OUT"
else
  ok "a pin that recorded nothing does NOT print the durable-pin line"
fi
# The run log is this transport's second operator channel, and a warning that
# reaches only the terminal is lost the moment the walk-away run is unattended.
RL="$(ls -t "$d"/runs/*.log 2>/dev/null | head -1)"
if [ -n "$RL" ] && grep -q "pin RECORD could not be persisted" "$RL"; then
  ok "the same warning reaches the run log"
else
  bad "the same warning reaches the run log" "run log: ${RL:-none found}"
fi
[ -d "$KTL" ] && [ -d "$KCL" ] \
  && ok "both lock directories are retained" \
  || bad "both lock directories are retained" "$KTL / $KCL"
# What the operator meets next. The refusal is the reason the directories are
# kept, so it has to survive the missing record.
run_dispatch "$d" norecord-task --actor-cmd "$NOOP"
expect_rc 17 "$RC" "a SECOND dispatcher is still REFUSED with the record missing" "$OUT"
reap "$EPID" "$APID" "$DPID"
rm -rf "$KTL/survivors" "$KCL/survivors"
drop_lock "$d" norecord-task

# ================================================================ case 27kb
# rc=1 stays SILENT, and an unrecognised code is reported as unrecognised.
#
# Neither has a route through the real library from a run that owns its locks, so
# the library's pin is overridden in the SANDBOX copy — the real file everywhere
# else. Committed, because a modified tracked helper is an out-of-allowlist
# working-tree change and the dispatcher would correctly stop on that instead.
stub_pin_rc() { # sandbox, rc, pinned-flag
  printf '\nwl_lease_pin() { WL_LEASE_PINNED=%s; return %s; }\n' "$3" "$2" \
    >>"$1/logs/scripts/work-loop-lease.sh"
  git -C "$1" add -- logs/scripts/work-loop-lease.sh >/dev/null 2>&1
  git -C "$1" commit -qm "stub the pin result" >/dev/null 2>&1
}

pin_result_run() { # sandbox, task, sig-dir -> sets SRC and OUT
  local sd="$1" tk="$2" sr="$3" act dp
  mkdir -p "$sr"
  act="$(mk_stubborn "$sr/escapee.pid")
    echo \$\$ > \"$sr/actor.pid\"; sleep 300"
  PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$sd" --task "$tk" --log-dir "$sd/runs" \
    --timeout 300 --actor-cmd "$act" >"$sr/out" 2>&1 &
  dp=$!
  wait_for "$sr/escapee.pid" "$sr/actor.pid"
  sleep 1
  kill -TERM "$dp" 2>/dev/null
  sleep 11
  wait "$dp" 2>/dev/null; SRC=$?
  OUT="$(cat "$sr/out")"
  reap "$(cat "$sr/escapee.pid" 2>/dev/null)" "$(cat "$sr/actor.pid" 2>/dev/null)" "$dp"
}

echo
echo "Case 27kb — rc=1 says nothing; an unrecognised pin result says it is unrecognised"
d="$(new_sandbox)"; state_file "$d" "nolock-task" "claude"
stub_pin_rc "$d" 1 0
pin_result_run "$d" nolock-task "$SANDBOX_ROOT/sig27kb1"
expect_rc 28 "$SRC" "rc=1 still exits 28" "$OUT"
if printf '%s' "$OUT" | grep -qE "PINNED|could not be persisted|UNRECOGNISED"; then
  bad "rc=1 says nothing about a lock at all" "$OUT"
else
  ok "rc=1 says nothing about a lock at all"
fi
drop_lock "$d" nolock-task

d="$(new_sandbox)"; state_file "$d" "oddrc-task" "claude"
stub_pin_rc "$d" 3 1
pin_result_run "$d" oddrc-task "$SANDBOX_ROOT/sig27kb2"
expect_rc 28 "$SRC" "an unrecognised pin result still exits 28" "$OUT"
printf '%s' "$OUT" | grep -q "UNRECOGNISED pin result (3)" \
  && ok "the unrecognised code is reported, with the code" \
  || bad "the unrecognised code is reported, with the code" "$OUT"
printf '%s' "$OUT" | grep -q "second dispatcher is still refused (exit 17)" \
  && ok "and says a second dispatcher is still refused" \
  || bad "and says a second dispatcher is still refused" "$OUT"
if printf '%s' "$OUT" | grep -q "the task lock is PINNED at"; then
  bad "an unrecognised result must NOT print the durable-pin line" "$OUT"
else
  ok "an unrecognised result does NOT print the durable-pin line"
fi
drop_lock "$d" oddrc-task

# ==================================================== cases 27L .. 27q
# DISCOVERY FAILURE, ROUTE BY ROUTE.
#
# Case 27j covers ONE route into "cannot establish": lsof missing from PATH.
# The dispatcher has several others, and an untested route is where the first
# correction's bug lived — every call site read the census through a command
# substitution, so the unknown-reason was assigned in a subshell and thrown away,
# and a degraded sweep still printed `teardown verified`. Only 27j caught it.
# So each materially distinct route gets its own fail-capable case, and each
# asserts the same three things: no success line, a reason naming the route, and
# a PINNED lock.
#
# The stubs shadow ONE tool each by prepending a directory to PATH, and every
# stub passes everything it is not simulating through to the real tool. A stub
# that starved the dispatcher of unrelated tools would make a case pass without
# testing anything — that failure mode was hit while building 27j and is the
# reason this helper exists.
mk_stubdir() { # name body -> prints a PATH with the stub first
  local dir real
  dir="$(mktemp -d "$SANDBOX_ROOT/stub-$1.XXXXXX")"
  real="$(command -v "$1" 2>/dev/null)"
  {
    printf '#!/bin/bash\n'
    printf 'REAL=%q\n' "$real"
    printf '%s\n' "$2"
  } >"$dir/$1"
  chmod +x "$dir/$1"
  printf '%s:%s' "$dir" "$PATH"
}

# Asserts the shared shape of every degraded-sweep case, so the six cases below
# differ only in HOW discovery was broken.
assert_unverified() { # label outfile sandbox task reason-pattern
  local lab="$1" out="$2" d="$3" task="$4" pat="$5" LK
  grep -q "teardown UNVERIFIED" "$out" \
    && ok "$lab — reports UNVERIFIED" \
    || bad "$lab — reports UNVERIFIED" "$(grep -i 'teardown' "$out" | head -2)"
  grep -q "teardown verified" "$out" \
    && bad "$lab — must NOT print the success line" "it claimed verified teardown on a sweep that could not look" \
    || ok "$lab — does NOT print the success line"
  grep -q "$pat" "$out" \
    && ok "$lab — the reason names the broken route" \
    || bad "$lab — the reason names the broken route" "$(grep -i -A2 'UNVERIFIED' "$out" | head -4)"
  LK="$(lock_path_for "$d" "$task")"
  [ -f "$LK/survivors" ] \
    && ok "$lab — the lock is PINNED" \
    || bad "$lab — the lock is PINNED" "no survivors file at $LK"
}

# Runs one degraded-sweep case end to end: launch under a stubbed PATH, let the
# actor and its escapee start, SIGTERM the dispatcher, wait out the escalation.
run_degraded() { # sandbox task stubpath extra-setup-fn -> $SR/out
  local d="$1" task="$2" spath="$3" setup="${4:-}"
  ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
  PATH="$spath" bash "$DISPATCH_BIN" --checkout "$d" --task "$task" --log-dir "$d/runs" \
    --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
  DPID=$!
  wait_for "$SR/escapee.pid" "$SR/actor.pid"
  sleep 1
  EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
  [ -n "$setup" ] && "$setup" "$d"
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  wait "$DPID" 2>/dev/null; SRC=$?
}

# ================================================================ case 27L
# THE SURVIVOR BRANCH, which case 27k does not reach. 27k pins the lock because
# the sweep could not LOOK; this one pins it because the sweep looked, FOUND a
# live descendant, and could not clear it. Those are different code paths —
# TEARDOWN_SURVIVORS versus TEARDOWN_UNKNOWN — and the frozen finding names the
# survivor one.
#
# Forcing "alive and unkillable" without mocking the kill: a root-owned process
# is alive, `ps` confirms it, and `kill` from a non-root uid returns EPERM. Same
# device case 30d already uses for an uninspectable pid. It is injected into the
# census through a stubbed `lsof`, which is the handle that reports marker
# holders — so the dispatcher genuinely believes it is a descendant.
#
# TWO guards, not one, because this case makes the dispatcher signal a pid it
# did not create: the case refuses to run as root, AND it re-checks that the pid
# really is unsignallable before proceeding. Under both guards the TERM and KILL
# are guaranteed no-ops.
echo
echo "Case 27L — a survivor the sweep CAN see but cannot clear pins the lock"
ROOTPID=""
if [ "$(id -u)" -eq 0 ]; then
  bad "case 27L can run (needs a non-root uid so the survivor is unkillable)" \
      "running as root: every pid is killable, so 'sees it but cannot clear it' cannot be forced"
else
  # Lowest root-owned pid above 1 that is not in this test's own ancestry.
  ROOTPID="$(ps -axo pid=,uid= 2>/dev/null | awk '$2==0 && $1>1 {print $1}' | sort -n | head -1)"
  # Alive is established with `ps` and NOT with `kill -0`, because for this pid
  # `kill -0` is expected to fail — that is the whole point of choosing it.
  if [ -z "$ROOTPID" ] || ! ps -p "$ROOTPID" -o pid= >/dev/null 2>&1; then
    bad "case 27L — control: a live root-owned pid is available" \
        "pid '${ROOTPID:-<none>}' is not visible to ps; the case would prove nothing"
    ROOTPID=""
  elif kill -0 "$ROOTPID" 2>/dev/null; then
    bad "case 27L — control: that pid is NOT signallable by this uid" \
        "pid $ROOTPID accepted kill -0, so teardown could really kill it and the case is unsafe"
    ROOTPID=""
  else
    ok "27L — control: pid $ROOTPID is alive (ps) and this uid may NOT signal it (kill -0 refused)"
  fi
fi
if [ -n "$ROOTPID" ]; then
  d="$(new_sandbox)"; state_file "$d" "survivor-task" "claude"
  SR="$SANDBOX_ROOT/sig27L"; mkdir -p "$SR"
  # Real holders, plus one that will never die.
  SP27L="$(mk_stubdir lsof "
out=\"\$(\"\$REAL\" \"\$@\" 2>/dev/null)\"
printf '%s\n' \"\$out\" | grep -v '^\$'
printf '%s\n' $ROOTPID
exit 0")"
  run_degraded "$d" survivor-task "$SP27L"
  expect_rc 28 "$SRC" "the interrupted run still exits 28 (an unclearable survivor does not change it)" "$(cat "$SR/out")"
  grep -q "teardown could NOT confirm" "$SR/out" \
    && ok "teardown reports the survivor rather than claiming success" \
    || bad "teardown reports the survivor rather than claiming success" "$(grep -i teardown "$SR/out" | head -3)"
  grep -q "teardown verified" "$SR/out" \
    && bad "a sweep with a known survivor must NOT print the success line" "it did" \
    || ok "a sweep with a known survivor does NOT print the success line"
  grep -q "Still running:.*$ROOTPID" "$SR/out" \
    && ok "the surviving pid is named in the warning" \
    || bad "the surviving pid is named in the warning" "$(grep -i 'still running' "$SR/out" | head -2)"
  LK="$(lock_path_for "$d" survivor-task)"
  if [ -f "$LK/survivors" ]; then
    ok "the lock is PINNED after a survivor is left behind"
    grep -q "descendants still running:.*$ROOTPID" "$LK/survivors" \
      && ok "the survivors file records the pid, so the operator can find it" \
      || bad "the survivors file records the pid" "$(cat "$LK/survivors")"
  else
    bad "the lock is PINNED after a survivor is left behind" "no survivors file at $LK"
  fi
  # The invariant, as the next dispatcher experiences it.
  run_dispatch "$d" survivor-task --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "a SECOND dispatcher is REFUSED while a known survivor is alive" "$OUT"
  printf '%s' "$OUT" | grep -q "PINNED" \
    && ok "the refusal says the lock is pinned" || bad "the refusal says the lock is pinned" "$OUT"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task survivor-task --log-dir "$d/runs" --status 2>&1)"; RC=$?
  expect_rc 0 "$RC" "--status stays read-only and exits 0 over the pinned lock" "$OUT"
  printf '%s' "$OUT" | grep -q "PINNED LOCK" \
    && ok "--status explains the pin" || bad "--status explains the pin" "$OUT"
  printf '%s' "$OUT" | grep -q "STILL ALIVE NOW" \
    && ok "--status re-checks the recorded pid and says it is still alive" \
    || bad "--status re-checks the recorded pid" "$OUT"
  # The root process must be untouched — the whole case rests on TERM/KILL being
  # refused, so if it died something far worse than a test failure happened.
  # `ps`, not `kill -0`: this pid refuses kill -0 by design, so kill -0 would
  # report "untouched" even if teardown had actually killed it.
  ps -p "$ROOTPID" -o pid= >/dev/null 2>&1 \
    && ok "the unrelated root process is untouched (TERM and KILL were refused, as designed)" \
    || bad "the unrelated root process was killed" "pid $ROOTPID is gone — teardown removed a process it does not own"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" survivor-task
fi

# ================================================================ case 27m
# `ps -ax` FAILING. The group-membership handle is the one that reaches ordinary
# in-group children, so losing it is not cosmetic. The stub fails only the `-ax`
# form; every other ps query the dispatcher makes still works, so this case
# isolates one handle instead of breaking the script.
echo
echo "Case 27m — a FAILING \`ps -ax\` is unknown, not an empty tree"
d="$(new_sandbox)"; state_file "$d" "psfail-task" "claude"
SR="$SANDBOX_ROOT/sig27m"; mkdir -p "$SR"
SP27M="$(mk_stubdir ps '
for a in "$@"; do case "$a" in -ax|-axo|*ax*) exit 1 ;; esac; done
exec "$REAL" "$@"')"
if PATH="$SP27M" ps -ax -o pid= >/dev/null 2>&1; then
  bad "27m — control: \`ps -ax\` really fails under the stub" "it still succeeded; the case would prove nothing"
else
  ok "27m — control: \`ps -ax\` fails under the stub, and other ps forms still work"
  run_degraded "$d" psfail-task "$SP27M"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27m" "$SR/out" "$d" psfail-task "ps -ax"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" psfail-task
fi

# ================================================================ case 27n
# `pgrep` FAILING AT RUNTIME, as opposed to being absent. pgrep exits 1 for "no
# matches" and >=2 for its own failure; the first version discarded the exit code
# entirely, so a broken ancestry walk was indistinguishable from an actor with no
# children.
echo
echo "Case 27n — a RUNTIME-FAILING \`pgrep\` is unknown, not a childless actor"
d="$(new_sandbox)"; state_file "$d" "pgrepfail-task" "claude"
SR="$SANDBOX_ROOT/sig27n"; mkdir -p "$SR"
SP27N="$(mk_stubdir pgrep 'echo "pgrep: fatal" >&2; exit 3')"
if PATH="$SP27N" pgrep -P 1 >/dev/null 2>&1; then
  bad "27n — control: pgrep really fails under the stub" "it succeeded; the case would prove nothing"
else
  ok "27n — control: pgrep exits 3 under the stub, and is still ON PATH (so this is failure, not absence)"
  run_degraded "$d" pgrepfail-task "$SP27N"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27n" "$SR/out" "$d" pgrepfail-task "pgrep -P"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" pgrepfail-task
fi

# ================================================================ case 27o
# `lsof` FAILING AT RUNTIME. Distinct from 27j (absent) because `lsof -t` exits 1
# both for "nobody holds it" and for its own errors, so the exit code cannot
# separate them and the dispatcher has to read stderr. Sending stderr to
# /dev/null — which the first version did — makes a broken handle look like an
# empty one.
echo
echo "Case 27o — a RUNTIME-FAILING \`lsof\` is unknown, not an unheld marker"
d="$(new_sandbox)"; state_file "$d" "lsoffail-task" "claude"
SR="$SANDBOX_ROOT/sig27o"; mkdir -p "$SR"
SP27O="$(mk_stubdir lsof 'echo "lsof: status error on marker: Permission denied" >&2; exit 1')"
if PATH="$SP27O" lsof -t -- /etc/hosts 2>/dev/null | grep -q .; then
  bad "27o — control: lsof really fails under the stub" "it returned holders; the case would prove nothing"
else
  ok "27o — control: lsof exits 1 with a diagnostic on stderr, and is still ON PATH"
  run_degraded "$d" lsoffail-task "$SP27O"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27o" "$SR/out" "$d" lsoffail-task "lsof\` failed on the tree marker"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" lsoffail-task
fi

# ================================================================ case 27p
# THE MARKER GONE. The fd handle is the only one that reaches an escaped
# descendant at all, so if its file has vanished the census has lost the reach
# this whole work exists to provide. Deleted mid-run, which is also the realistic
# shape: a tmp-cleaner, or an operator tidying the runs directory.
echo
echo "Case 27p — a MISSING tree marker is unknown, not an empty census"
d="$(new_sandbox)"; state_file "$d" "nomarker-task" "claude"
SR="$SANDBOX_ROOT/sig27p"; mkdir -p "$SR"
eat_marker() { rm -f "$1"/runs/*.tree 2>/dev/null; }
run_degraded "$d" nomarker-task "$PATH" eat_marker
if ls "$d"/runs/*.tree >/dev/null 2>&1; then
  bad "27p — control: the marker really was removed before the stop" "a .tree file is still present"
else
  ok "27p — control: the marker was removed before the stop"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27p" "$SR/out" "$d" nomarker-task "tree marker file is missing"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" nomarker-task

# ================================================================ case 27q
# ACTOR / DISPATCHER PROCESS-GROUP COLLISION. If `set -m` ever stops isolating the
# actor, the sweep would enumerate the operator's own jobs, so the dispatcher
# refuses to census its own group — and that refusal must read as "cannot
# establish", never as an empty tree.
#
# This case also pins a REAL BUG in the first version of the guard, which compared
# the caller's argument — the actor's *pid* — against the dispatcher's *pgid*.
# Those are different kinds of number and can only match by coincidence, so the
# guard could not fire in the one situation it existed for. The guard now asks
# what group the actor is actually in, which is what this stub manipulates.
echo
echo "Case 27q — an actor sharing the dispatcher's process group is unknown, not empty"
d="$(new_sandbox)"; state_file "$d" "samegroup-task" "claude"
SR="$SANDBOX_ROOT/sig27q"; mkdir -p "$SR"
# Every `-o pgid=` answer becomes the same number, so the actor's group and the
# dispatcher's group are identical however the processes really sit.
SP27Q="$(mk_stubdir ps '
want_pgid=0
for a in "$@"; do case "$a" in pgid=|*pgid=*) want_pgid=1 ;; esac; done
case "$*" in *-ax*) exec "$REAL" "$@" ;; esac
if [ "$want_pgid" -eq 1 ]; then echo "  424242"; exit 0; fi
exec "$REAL" "$@"')"
if [ "$(PATH="$SP27Q" ps -o pgid= -p $$ 2>/dev/null | tr -d ' ')" != "424242" ]; then
  bad "27q — control: the stub really forces one shared pgid" "it did not; the case would prove nothing"
else
  ok "27q — control: every -o pgid= query returns the same group, forcing the collision"
  run_degraded "$d" samegroup-task "$SP27Q"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27q" "$SR/out" "$d" samegroup-task "shares this dispatcher's process group"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" samegroup-task
fi

fi   # python3 available

# ================================================================ case 27r
#
# THE INTERRUPTION TERMINAL'S EVIDENCE (Unit 23). Cases 27–27q above prove the
# signal path STOPS things: the actor dies, its descendants die, the exit is 28,
# an unverified teardown pins. None of them asks the question this one does —
# whether the run left behind anything a later reader can point at.
#
# Before this unit it did not. on_signal() reported on screen, released the lease
# and exited 28 with no run-bound terminal result, which is the same
# unproven-ending hole units 8, 11 and 12 closed at the operator, funnel and
# dry-run seams. This is the launched-actor half of the remaining one; a signal
# arriving BEFORE an actor was forked is deliberately still on the old path and
# is asserted as such in 27r-deferred below, so this case cannot be read as
# "every interruption is now covered".
#
# THE ACTOR IS SIMULATED, so model_request_started must stay `no`. That is not
# incidental: it is the field a supervised-use claim rests on, and a terminal
# that started reporting `yes` because a fixture hung would be the false claim
# the whole change set exists to remove.
# WAITS ONLY. The dispatcher is backgrounded by the CALLER, in the main shell,
# because `wait` can only reap its own children: backgrounding it inside a
# `$(...)` helper put the job in a subshell and every `wait` returned 127, which
# reads as an exit code the dispatcher never produced.
sig27_actor_pid() { # root -> pid of the hung simulated actor, once it exists
  local root="$1" _
  for _ in $(seq 1 40); do [ -f "$root/actor.pid" ] && break; sleep 0.5; done
  sleep 1
  cat "$root/actor.pid" 2>/dev/null
}

echo
echo "Case 27r — an interruption AFTER a launched actor publishes and consumes one trusted result BEFORE release"
d="$(new_sandbox)"; state_file "$d" "sig-evidence-task" "claude"
R27R="$SANDBOX_ROOT/sig27r"; mkdir -p "$R27R"
SIG27R_ACTOR='echo $$ > "'"$R27R"'/actor.pid"; sleep 300'
bash "$DISPATCH_BIN" --checkout "$d" --task sig-evidence-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$SIG27R_ACTOR" >"$R27R/out" 2>&1 &
D27R=$!
A27R="$(sig27_actor_pid "$R27R")"
LK27R="$(task_lock_for "$d" sig-evidence-task)"
if [ -z "$A27R" ]; then
  bad "27r — the simulated actor started" "no actor pid file; case 27r is inconclusive"
else
  ok "27r — the simulated actor started (pid $A27R)"
  kill -TERM "$D27R" 2>/dev/null
  wait "$D27R" 2>/dev/null; RC27R=$?
  OUT27R="$(cat "$R27R/out")"
  expect_rc 28 "$RC27R" "27r — still exits 28 INTERRUPTED, unchanged" "$OUT27R"
  ROOT27R="$(cd "$d/runs" && pwd -P)"
  RID27R="$(run_id_of "$OUT27R")"
  RES27R="$ROOT27R/$RID27R.result"
  # THE RED THIS UNIT EXISTS TO TURN: before the edit there is no result at all.
  if [ "$(res_count "$ROOT27R")" = "1" ] && [ "$(part_count "$ROOT27R")" = "0" ]; then
    ok "27r — exactly one finalized result, no partial left behind"
  else
    bad "27r — exactly one finalized result, no partial left behind" \
        "results=$(res_count "$ROOT27R") partials=$(part_count "$ROOT27R")"
  fi
  for pair in "outcome:INTERRUPTED" "code:28" "stage:post-hop" "actor_launched:yes" \
              "model_request_started:no" "task:sig-evidence-task"; do
    k27="${pair%%:*}"; w27="${pair#*:}"
    if [ "$(res_field "$RES27R" "$k27")" = "$w27" ]; then
      ok "27r — the record carries $k27=$w27"
    else
      bad "27r — the record carries $k27=$w27" "got: $(res_field "$RES27R" "$k27")"
    fi
  done
  [ "$(tail -1 "$RES27R" 2>/dev/null)" = "result_complete=yes" ] \
    && ok "27r — the record ends with its completion sentinel" \
    || bad "27r — the record ends with its completion sentinel" "last: $(tail -1 "$RES27R" 2>/dev/null)"
  # CONSUMPTION IS OBSERVED BY ITS ABSENCE OF REFUSAL. Every consumer refusal
  # leaves through die_terminal_untrusted, which exits 38 and pins; an exit of 28
  # with the promised artifact present and no scratch file left is the accepted
  # gate having run and returned. The scratch check is what separates "consumed"
  # from "never called".
  ls "$ROOT27R"/*.consume >/dev/null 2>&1 \
    && bad "27r — the consumer left no scratch file behind" "$(ls "$ROOT27R"/*.consume 2>&1 | tr '\n' ' ')" \
    || ok "27r — the consumer left no scratch file behind"
  # MATCHED ON THE RUN ID, not on the full path. The dispatcher prints
  # "$LOG_DIR/$RUN_ID.result" from the --log-dir argument exactly as passed, while
  # this harness canonicalizes with `pwd -P`; on macOS those are the same file
  # spelled two ways (/var/... and /private/var/...). Asserting the literal string
  # would fail on the spelling and prove nothing about the behaviour. What matters
  # is that the operator is pointed at THIS run's result.
  printf '%s\n' "$OUT27R" | grep -q "  terminal result: .*/$RID27R\.result$" \
    && ok "27r — the operator is told where the evidence is" \
    || bad "27r — the operator is told where the evidence is" "$OUT27R"
  # RELEASED ONLY AFTER CONSUMPTION. Teardown was clean here, so the lease must
  # be gone — and it may only be gone because the two lines above returned.
  [ -d "$LK27R" ] \
    && bad "27r — a clean teardown releases the lease after consumption" "$LK27R still held" \
    || ok "27r — a clean teardown releases the lease after consumption"
  # UNCHANGED BEHAVIOUR, asserted rather than assumed: the wording and the
  # no-retry promise are what cases 27–27q rely on.
  printf '%s\n' "$OUT27R" | grep -q "STOP \[28\]" \
    && ok "27r — the interruption wording is unchanged" \
    || bad "27r — the interruption wording is unchanged" "$OUT27R"
  printf '%s\n' "$OUT27R" | grep -q "Nothing is retried" \
    && ok "27r — the no-retry promise is unchanged" \
    || bad "27r — the no-retry promise is unchanged" "$OUT27R"
  kill -KILL "$A27R" 2>/dev/null
fi

# ================================================================ case 27u
#
# THE PRE-LAUNCH HALF OF THE SAME TERMINAL (Unit 25). This case was 27r-deferred:
# it asserted that an interruption arriving before any fork still exited 28 with
# NO result, and that assertion was honest for Unit 23's scope. It was also the
# measurement that showed the boundary was drawn at the wrong fact. By the time
# the signal lands here the run has taken BOTH leases, claimed its RUN_ID and
# opened its run log — it has already changed the shared world — and it was
# exiting 28 having published nothing a later reader could point at.
#
# THE FIXTURE IS UNCHANGED FROM THE DEFERRAL, deliberately: same slow ownership
# helper, same 3-second signal, same window. Only the expectation moved, so the
# red this turned is the exact behaviour the deferral recorded.
#
# THE SIGNAL IS DELIVERED TO A DISPATCHER HELD BEFORE ITS FIRST LAUNCH by a slow
# ownership helper, which is the one seam that can be stalled from outside
# without touching the signal path itself. A busy git dir is not needed and would
# not model this: --actor-cmd is never reached, so the run stops pre-hop.
#
# TWO FOREIGN PATHS ARE PLANTED ON PURPOSE, and they are what makes the hoist
# fail-capable rather than merely stated. finalize_terminal_result() counts them
# through foreign_worktree(), which — before this unit — was defined BELOW the
# block that raises RUN_ID. A record published from this window against that
# ordering would report `worktree_foreign_paths=0`: not an absent field but a
# positive, plausible, false claim that the working tree was clean, written by a
# function that did not exist. Asserting the count against an independently
# computed ground truth is what turns that into a failure instead of a pass.
#
# THEY DO NOT DISTURB THE RUN. The pre-hop foreign-path guard that refuses to
# launch on a dirty tree sits BELOW the ownership check, so the signal lands
# first and the guard is never reached.
echo
echo "Case 27u — an interruption AFTER run evidence exists but BEFORE any fork publishes one trusted result"
d="$(new_sandbox)"; state_file "$d" "sig-prelaunch-task" "claude"
R27U="$SANDBOX_ROOT/sig27u"; mkdir -p "$R27U"
printf 'planted\n' >"$d/foreign-a.txt"
printf 'planted\n' >"$d/foreign-b.txt"
# The ground truth, computed by this harness from git rather than from the record
# under test: porcelain entries whose path is outside the three allowlist
# prefixes the dispatcher was given (--allow-path defaults plus the run dir it
# adds for --log-dir "$d/runs").
foreign_truth() { # checkout -> count of out-of-allowlist porcelain entries
  git -C "$1" status --porcelain 2>/dev/null |
    while IFS= read -r l; do
      p="${l:3}"; p="${p%\"}"; p="${p#\"}"
      case "$p" in
        runs/*|logs/work-loop/*|plans/work-loop-v2-v0.2/handoff-automation-spike/*) ;;
        *) printf 'x\n' ;;
      esac
    done | grep -c . || true
}
cat >"$d/logs/scripts/work-loop-owner.sh" <<'SLOWOWN'
#!/bin/bash
sleep 30
exit 0
SLOWOWN
chmod +x "$d/logs/scripts/work-loop-owner.sh"
# COMPUTED AFTER THE STALL IS INSTALLED, and that ordering is not cosmetic:
# overwriting the tracked ownership helper is itself an out-of-allowlist working
# tree change, so a ground truth taken before it would be short by one and would
# disagree with a record that is right. The run directory is excluded because the
# dispatcher adds it to its own allowlist for --log-dir inside the checkout.
FG27U="$(foreign_truth "$d")"
CO27U="$(cd "$d" && pwd -P)"
LK27U="$(task_lock_for "$d" sig-prelaunch-task)"
CL27U="$(checkout_lock_for "$d")"
bash "$DISPATCH_BIN" --checkout "$d" --task sig-prelaunch-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$NOOP" >"$R27U/out" 2>&1 &
D27U=$!
sleep 3
# BOTH LEASES ARE OBSERVED HELD AT THE MOMENT OF THE SIGNAL, before it is sent.
# This is the fact that makes the window worth an artifact at all: the run is not
# merely "started", it is holding the two things that keep every other dispatcher
# out. Read here rather than inferred from the record afterwards.
[ -d "$LK27U" ] && [ -d "$CL27U" ] \
  && ok "27u — both leases are held at the moment the signal is delivered" \
  || bad "27u — both leases are held at the moment the signal is delivered" \
         "task=$([ -d "$LK27U" ] && echo held || echo absent) checkout=$([ -d "$CL27U" ] && echo held || echo absent)"
kill -TERM "$D27U" 2>/dev/null
wait "$D27U" 2>/dev/null; RC27U=$?
OUT27U="$(cat "$R27U/out")"
expect_rc 28 "$RC27U" "27u — a pre-launch interruption still exits 28, unchanged" "$OUT27U"
ROOT27U="$(cd "$d/runs" && pwd -P)"
RID27U="$(run_id_of "$OUT27U")"
RES27U="$ROOT27U/$RID27U.result"
# THE RED THIS UNIT EXISTS TO TURN: before the edit this window published nothing.
if [ "$(res_count "$ROOT27U")" = "1" ] && [ "$(part_count "$ROOT27U")" = "0" ]; then
  ok "27u — exactly one finalized result, no partial left behind"
else
  bad "27u — exactly one finalized result, no partial left behind" \
      "results=$(res_count "$ROOT27U") partials=$(part_count "$ROOT27U")"
fi
# NOTHING WAS LAUNCHED, asserted on three independent surfaces: the record's own
# tuple, the teardown line the handler prints only when a pgid exists, and the
# actor's own call log. A record claiming pre-hop while an actor had in fact run
# would be the exact false claim this field exists to prevent.
for pair in "outcome:INTERRUPTED" "code:28" "stage:pre-hop" "actor_launched:no" \
            "model_request_started:no" "actor:none" "hop:0" "mode:simulated" \
            "task:sig-prelaunch-task"; do
  k27="${pair%%:*}"; w27="${pair#*:}"
  if [ "$(res_field "$RES27U" "$k27")" = "$w27" ]; then
    ok "27u — the record carries $k27=$w27"
  else
    bad "27u — the record carries $k27=$w27" "got: $(res_field "$RES27U" "$k27")"
  fi
done
printf '%s\n' "$OUT27U" | grep -q 'terminating actor descendant tree' \
  && bad "27u — no actor descendant tree was torn down" "$OUT27U" \
  || ok "27u — no actor descendant tree was torn down"
[ -f "$d.calls" ] \
  && bad "27u — the simulated actor was never invoked" "$(cat "$d.calls")" \
  || ok "27u — the simulated actor was never invoked"
# TRUST IS ASSERTED AGAINST FIXTURE FACTS, not read back off the record. Each
# expectation below is a value this harness knows independently — the sandbox
# path, the run id parsed from the dispatcher's own first line, the state file it
# was pointed at, the declaration the sandbox does NOT carry, and the two lease
# directories this harness computed before the run started.
for pair in "checkout:$CO27U" "run:$RID27U" "run_log:$d/runs/$RID27U.log" \
            "state_file:$CO27U/logs/work-loop/sig-prelaunch-task.md" \
            "owner_declared:none" "owner_check:unchecked" \
            "lease_task_dir:$LK27U" "lease_checkout_dir:$CL27U" \
            "lease_task_at_finalization:held-by-this-run" \
            "lease_checkout_at_finalization:held-by-this-run" \
            "turn_at_terminal:claude" "state_class:ACTIVE_CLAUDE"; do
  k27="${pair%%:*}"; w27="${pair#*:}"
  if [ "$(res_field "$RES27U" "$k27")" = "$w27" ]; then
    ok "27u — $k27 matches the fixture fact"
  else
    bad "27u — $k27 matches the fixture fact" "want: $w27 — got: $(res_field "$RES27U" "$k27")"
  fi
done
# THE ANTI-FABRICATION ASSERTION. A `0` here is what a record written against the
# un-hoisted ordering reports, and it is indistinguishable from a clean tree
# unless the expected value is known independently and is NOT zero.
if [ "$FG27U" -gt 0 ] 2>/dev/null && [ "$(res_field "$RES27U" worktree_foreign_paths)" = "$FG27U" ]; then
  ok "27u — worktree_foreign_paths=$FG27U was counted, not fabricated"
else
  bad "27u — worktree_foreign_paths was counted, not fabricated" \
      "git ground truth=$FG27U — record says $(res_field "$RES27U" worktree_foreign_paths)"
fi
# THE PRE-HOP FIELDS THAT MUST BE EXPLICITLY UNAVAILABLE RATHER THAN GUESSED.
# There is no launch baseline, so there is no delta to report; no --deadline was
# given, so there is no remainder. Both are bounded tokens, and neither is empty.
for pair in "changed_paths_since_launch:unavailable" "deadline_seconds:none" \
            "deadline_remaining_seconds:none" "permission_mode_requested:none"; do
  k27="${pair%%:*}"; w27="${pair#*:}"
  if [ "$(res_field "$RES27U" "$k27")" = "$w27" ]; then
    ok "27u — $k27 is the bounded token $w27, not a guess"
  else
    bad "27u — $k27 is the bounded token $w27, not a guess" "got: $(res_field "$RES27U" "$k27")"
  fi
done
[ "$(tail -1 "$RES27U" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "27u — the record ends with its completion sentinel" \
  || bad "27u — the record ends with its completion sentinel" "last: $(tail -1 "$RES27U" 2>/dev/null)"
# CONSUMED, not merely written — the same observation 27r makes, for the same
# reason: every consumer refusal leaves through die_terminal_untrusted with exit
# 38, so an exit of 28 with the promised artifact present and no scratch file
# left is the accepted gate having run and returned.
ls "$ROOT27U"/*.consume >/dev/null 2>&1 \
  && bad "27u — the consumer left no scratch file behind" "$(ls "$ROOT27U"/*.consume 2>&1 | tr '\n' ' ')" \
  || ok "27u — the consumer left no scratch file behind"
printf '%s\n' "$OUT27U" | grep -q "  terminal result: .*/$RID27U\.result$" \
  && ok "27u — the operator is told where the evidence is" \
  || bad "27u — the operator is told where the evidence is" "$OUT27U"
# RELEASED ONLY AFTER CONSUMPTION. Nothing was launched, so nothing could pin;
# the leases may only be gone because both integration lines returned.
if [ -d "$LK27U" ] || [ -d "$CL27U" ]; then
  bad "27u — a clean pre-launch stop releases both leases after consumption" \
      "task=$([ -d "$LK27U" ] && echo held || echo gone) checkout=$([ -d "$CL27U" ] && echo held || echo gone)"
else
  ok "27u — a clean pre-launch stop releases both leases after consumption"
fi
# THE WORDING IS TRUE OF WHAT HAPPENED. The launched-actor message claims a hop
# was interrupted and may have left a partial effect; printed here it sends the
# operator to reconcile a hop against effects that cannot exist, because no actor
# was ever forked. The no-retry promise is unchanged in both wordings.
out_has  'before the first hop launched' "$OUT27U" "27u — the stop names the pre-launch window"
out_has  'no actor was ever launched by this run' "$OUT27U" "27u — the message says nothing was launched"
out_lacks 'the actor was killed mid-hop' "$OUT27U" "27u — it does not claim a hop was interrupted"
out_has  'Nothing is retried' "$OUT27U" "27u — the no-retry promise is unchanged"
out_has  'STOP [28]' "$OUT27U" "27u — the interruption wording is unchanged"

# ================================================================ case 27s
#
# THE FAIL-CLOSED HALF. A publication that cannot be written must not buy a lease
# release with an ordinary exit 28 — the same rule units 8 and 11 set at the other
# seams. The evidence directory is made unwritable while the actor hangs, so the
# finalizer's atomic write fails on a real failed write rather than on a stub.
echo
echo "Case 27s — an interruption whose result CANNOT be published exits 38 and keeps the lease"
d="$(new_sandbox)"; state_file "$d" "sig-unprovable-task" "claude"
R27S="$SANDBOX_ROOT/sig27s"; mkdir -p "$R27S"
SIG27S_ACTOR='echo $$ > "'"$R27S"'/actor.pid"; sleep 300'
bash "$DISPATCH_BIN" --checkout "$d" --task sig-unprovable-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$SIG27S_ACTOR" >"$R27S/out" 2>&1 &
D27S=$!
A27S="$(sig27_actor_pid "$R27S")"
LK27S="$(task_lock_for "$d" sig-unprovable-task)"
if [ -z "$A27S" ]; then
  bad "27s — the simulated actor started" "no actor pid file; case 27s is inconclusive"
else
  ok "27s — the simulated actor started (pid $A27S)"
  chmod a-w "$d/runs"
  kill -TERM "$D27S" 2>/dev/null
  wait "$D27S" 2>/dev/null; RC27S=$?
  OUT27S="$(cat "$R27S/out")"
  chmod u+w "$d/runs" 2>/dev/null
  expect_rc 38 "$RC27S" "27s — an unprovable interruption exits 38, NOT an ordinary 28" "$OUT27S"
  [ -d "$LK27S" ] \
    && ok "27s — the lease is retained, so a second dispatcher is refused" \
    || bad "27s — the lease is retained, so a second dispatcher is refused" "$LK27S was released"
  printf '%s\n' "$OUT27S" | grep -q 'must not report that it ended' \
    && ok "27s — the operator is told the ending could not be proved" \
    || bad "27s — the operator is told the ending could not be proved" "$OUT27S"
  kill -KILL "$A27S" 2>/dev/null
fi

# ================================================================ case 27t
#
# THE MUTATION CONTROL (M29). Removes ONLY the two new integration lines from a
# throwaway copy of the dispatcher and re-runs 27r's fixture. If the case still
# passed without them, it would be proving something other than the integration.
#
# The selector matches each production line whole and FAILS CLOSED: absence,
# duplication, a mutant that does not differ, or one that does not parse all stop
# the control rather than letting it report a pass it did not earn. Both lines go
# together because they are one seam — deleting only the finalization would leave
# the consumer gating a promised artifact that was never written, which exits 38
# for a different reason and would not isolate the publication.
echo
echo "Case 27t — M29: with the interruption integration removed, 27r's evidence disappears and the exit stays 28"
M29_SRC="$SANDBOX_ROOT/dispatch-M29.sh"
M29_FIN='# interruption terminal finalization'
M29_CON='# interruption terminal consumption'
# `grep -c` prints its count AND exits 1 on zero matches, so a `|| printf 0`
# fallback would emit the count twice and the guard below would compare against
# "0\n0". head -1 takes grep's own answer, which is already correct at zero.
M29_HF="$(grep -cF "$M29_FIN" "$DISPATCH_BIN" 2>/dev/null | head -1)"
M29_HC="$(grep -cF "$M29_CON" "$DISPATCH_BIN" 2>/dev/null | head -1)"
if [ "$M29_HF" = "1" ] && [ "$M29_HC" = "1" ]; then
  grep -vF "$M29_FIN" "$DISPATCH_BIN" | grep -vF "$M29_CON" >"$M29_SRC"
  M29_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$M29_SRC" || M29_DIFFERS=yes
  M29_PARSES=no; bash -n "$M29_SRC" 2>/dev/null && M29_PARSES=yes
else
  M29_DIFFERS=no; M29_PARSES=no
fi
if [ "$M29_HF" = "1" ] && [ "$M29_HC" = "1" ] && [ "$M29_DIFFERS" = yes ] && [ "$M29_PARSES" = yes ]; then
  ok "27t — M29 matched each integration line exactly once, differs, and still parses"
  d="$(new_sandbox)"; state_file "$d" "sig-mutant-task" "claude"
  R27T="$SANDBOX_ROOT/sig27t"; mkdir -p "$R27T"
  M29_ACTOR='echo $$ > "'"$R27T"'/actor.pid"; sleep 300'
  bash "$M29_SRC" --checkout "$d" --task sig-mutant-task --log-dir "$d/runs" \
    --timeout 300 --actor-cmd "$M29_ACTOR" >"$R27T/out" 2>&1 &
  D27T=$!
  for _ in $(seq 1 40); do [ -f "$R27T/actor.pid" ] && break; sleep 0.5; done
  sleep 1
  A27T="$(cat "$R27T/actor.pid" 2>/dev/null)"
  if [ -z "$A27T" ]; then
    bad "27t — the mutant launched its actor" "no actor pid file; M29 is inconclusive"
  else
    kill -TERM "$D27T" 2>/dev/null
    wait "$D27T" 2>/dev/null; RC27T=$?
    OUT27T="$(cat "$R27T/out")"
    expect_rc 28 "$RC27T" "27t — the mutant still reaches exit 28, so the fixture is not merely broken" "$OUT27T"
    if [ "$(res_count "$d/runs" 2>/dev/null)" = "0" ]; then
      ok "27t — with the integration removed, NO terminal result is published"
    else
      bad "27t — with the integration removed, NO terminal result is published" \
          "results=$(res_count "$d/runs") — the control cannot distinguish the seam"
    fi
    [ -d "$(task_lock_for "$d" sig-mutant-task)" ] \
      && bad "27t — the mutant released the lease on an unproven ending" "lease retained" \
      || ok "27t — the mutant released the lease on an unproven ending, which is the hole 27r closes"
    kill -KILL "$A27T" 2>/dev/null
  fi
else
  bad "27t — M29 matched each integration line exactly once, differs, and still parses" \
      "finalization matches=$M29_HF consumption matches=$M29_HC differs=$M29_DIFFERS parses=$M29_PARSES — the control cannot run"
fi

# ================================================================ case 27v
#
# THE MUTATION CONTROL FOR THE WIDENING (M31). Case 27t deletes both integration
# lines and proves the seam exists at all. It cannot prove what THIS unit added,
# because both windows now travel through those same two lines: deleting them
# takes 27r's evidence away as well, and a control that removes the launched-actor
# path too is not isolating the pre-launch one.
#
# SO THIS MUTANT REVERTS RATHER THAN DELETES. Each guard is rewritten from the
# run-evidence condition back to Unit 23's fork condition — the exact edit this
# unit made, and nothing else. The integration lines stay, the finalizer and the
# consumer stay, and the launched-actor path is left fully present. If 27u still
# passed against that mutant, it would be proving something other than the
# widening.
#
# BOTH HALVES ARE MEASURED, on the same mutant: the pre-launch fixture must lose
# its result and fall back to a bare exit 28, and 27r's launched fixture must
# still publish exactly one. A mutant that broke both would satisfy the first
# assertion while telling us nothing.
#
# LITERAL, NOT REGEX. The guard text is full of `[`, `$`, `{` and `}`; awk's
# index/substr replaces the exact bytes with no pattern interpretation, and the
# count guard below fails closed on absence, on a single match, or on three.
echo
echo "Case 27v — M31: with the guard reverted to the fork fact, 27u's evidence disappears and 27r's remains"
M31_SRC="$SANDBOX_ROOT/dispatch-M31.sh"
M31_OLD='[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] &&'
M31_NEW='[ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] &&'
M31_HITS="$(grep -cF "$M31_OLD" "$DISPATCH_BIN" 2>/dev/null | head -1)"
if [ "$M31_HITS" = "2" ]; then
  awk -v old="$M31_OLD" -v new="$M31_NEW" '
    { i = index($0, old)
      if (i > 0) $0 = substr($0, 1, i-1) new substr($0, i + length(old))
      print }' "$DISPATCH_BIN" >"$M31_SRC"
  M31_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$M31_SRC" || M31_DIFFERS=yes
  M31_PARSES=no; bash -n "$M31_SRC" 2>/dev/null && M31_PARSES=yes
  # The launched-actor path must survive the mutation, or the control is a
  # deletion wearing a different name.
  M31_KEPT=no
  [ "$(grep -cF '# interruption terminal finalization' "$M31_SRC" | head -1)" = "1" ] &&
    [ "$(grep -cF '# interruption terminal consumption' "$M31_SRC" | head -1)" = "1" ] && M31_KEPT=yes
else
  M31_DIFFERS=no; M31_PARSES=no; M31_KEPT=no
fi
if [ "$M31_HITS" = "2" ] && [ "$M31_DIFFERS" = yes ] && [ "$M31_PARSES" = yes ] && [ "$M31_KEPT" = yes ]; then
  ok "27v — M31 matched the widened guard exactly twice, differs, still parses, and kept both integration lines"

  # HALF ONE — the pre-launch window loses its evidence.
  d="$(new_sandbox)"; state_file "$d" "sig-m31-pre-task" "claude"
  R27V="$SANDBOX_ROOT/sig27v"; mkdir -p "$R27V"
  cat >"$d/logs/scripts/work-loop-owner.sh" <<'SLOWM31'
#!/bin/bash
sleep 30
exit 0
SLOWM31
  chmod +x "$d/logs/scripts/work-loop-owner.sh"
  bash "$M31_SRC" --checkout "$d" --task sig-m31-pre-task --log-dir "$d/runs" \
    --timeout 300 --actor-cmd "$NOOP" >"$R27V/out" 2>&1 &
  D27V=$!
  sleep 3
  kill -TERM "$D27V" 2>/dev/null
  wait "$D27V" 2>/dev/null; RC27V=$?
  OUT27V="$(cat "$R27V/out")"
  expect_rc 28 "$RC27V" "27v — the mutant still reaches exit 28, so the fixture is not merely broken" "$OUT27V"
  if [ "$(res_count "$d/runs" 2>/dev/null)" = "0" ]; then
    ok "27v — with the guard reverted, the pre-launch window publishes NO result"
  else
    bad "27v — with the guard reverted, the pre-launch window publishes NO result" \
        "results=$(res_count "$d/runs") — the control cannot distinguish the widening"
  fi

  # HALF TWO — the launched-actor window keeps its evidence, on the same mutant.
  d="$(new_sandbox)"; state_file "$d" "sig-m31-post-task" "claude"
  R27W="$SANDBOX_ROOT/sig27w"; mkdir -p "$R27W"
  M31_ACTOR='echo $$ > "'"$R27W"'/actor.pid"; sleep 300'
  bash "$M31_SRC" --checkout "$d" --task sig-m31-post-task --log-dir "$d/runs" \
    --timeout 300 --actor-cmd "$M31_ACTOR" >"$R27W/out" 2>&1 &
  D27W=$!
  A27W="$(sig27_actor_pid "$R27W")"
  if [ -z "$A27W" ]; then
    bad "27v — the mutant launched its actor" "no actor pid file; the second half is inconclusive"
  else
    kill -TERM "$D27W" 2>/dev/null
    wait "$D27W" 2>/dev/null; RC27W=$?
    if [ "$(res_count "$d/runs" 2>/dev/null)" = "1" ]; then
      ok "27v — and the launched-actor window still publishes exactly one (the mutation is not a deletion)"
    else
      bad "27v — and the launched-actor window still publishes exactly one" \
          "rc=$RC27W results=$(res_count "$d/runs") — M31 broke more than the widening"
    fi
    kill -KILL "$A27W" 2>/dev/null
  fi
else
  bad "27v — M31 matched the widened guard exactly twice, differs, still parses, and kept both integration lines" \
      "matches=$M31_HITS want 2; differs=$M31_DIFFERS parses=$M31_PARSES kept=$M31_KEPT — the control cannot run"
fi

# ================================================================ case 27w
#
# THE FOURTH AND LAST PRODUCTION CONSUMER (Unit 30). 27r and 27u proved this
# terminal publishes and consumes the artifact it promised, in both windows;
# nothing proved the artifact said what this run actually did. Measured on the
# fixtures below before the edit: a record altered after successful finalization
# to `outcome=COMPLETED` — the word for a task driven to its end, over a run a
# signal stopped mid-hop — exited 28, was advertised as this run's terminal
# result and released both leases after a clean teardown; so did one altered to
# `code=22`. Path, structure and identity have nothing to object to; only meaning
# does.
#
# SAME FORCING TECHNIQUE, SAME WINDOW as 56b, 58e, 60j and 62b: one altering line
# injected after this seam's own finalization marker, between publication and
# consumption. It is GUARDED on RESULT_FILE, unlike the other four, because
# on_signal() also runs in windows where no record exists — an unguarded fixture
# would act outside the window under test and stop being a control on it.
#
# THE LAUNCHED-ACTOR WINDOW IS WHERE THE RED IS TAKEN, because it is the one an
# operator actually meets: a hop in flight, stopped by a signal. The pre-launch
# window shares the identical expectation — code 28 has no branch in
# result_outcome() — and 27u remains its green.
echo
echo "Case 27w — an interrupted record altered ONLY in outcome, or ONLY in code, is refused before release"
MUT27W="$SANDBOX_ROOT/mutants27w"; mkdir -p "$MUT27W"

mk_int_alter27() { # outfile sed-script [source] -> 0 when the fixture differs and parses
  awk -v s="$2" '{print} /# interruption terminal finalization/ {
    printf "  [ -n \"$RESULT_FILE\" ] && { sed %c%s%c \"$RESULT_FILE\" >\"$RESULT_FILE.x\" && mv -f \"$RESULT_FILE.x\" \"$RESULT_FILE\"; } # harness interruption alteration\n", 39, s, 39 }' \
    "${3:-$DISPATCH_BIN}" >"$1"
  ! cmp -s "${3:-$DISPATCH_BIN}" "$1" && bash -n "$1" 2>/dev/null
}

# One real launched-actor interruption against a forcing fixture, run the way 27r
# runs its own: backgrounded by THIS shell so `wait` can reap it, actor pid file
# polled, SIGTERM to the dispatcher. Returns the sandbox and the captured output
# through globals rather than stdout, because the caller needs the sandbox to
# inspect leases afterwards.
int_run27w() { # fixture task -> sets V27W and O27W, or leaves V27W empty
  local fx="$1" t="$2" dir pid apid
  V27W=""; O27W=""; RC27W=0
  dir="$(new_sandbox)"; state_file "$dir" "$t" claude
  local scratch="$MUT27W/$t.d"; mkdir -p "$scratch"
  bash "$fx" --checkout "$dir" --task "$t" --log-dir "$dir/runs" --timeout 300 \
    --actor-cmd 'echo $$ > "'"$scratch"'/actor.pid"; sleep 300' >"$scratch/out" 2>&1 &
  pid=$!
  apid="$(sig27_actor_pid "$scratch")"
  if [ -z "$apid" ]; then
    kill -KILL "$pid" 2>/dev/null; wait "$pid" 2>/dev/null
    return 1
  fi
  kill -TERM "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null; RC27W=$?
  O27W="$(cat "$scratch/out")"
  kill -KILL "$apid" 2>/dev/null
  V27W="$dir"
  return 0
}

# The full refusal contract for one forced interruption mismatch, asserted as
# 58e, 60j and 62b assert theirs: exit 38, nothing advertised, the truthful
# terminal named, both leases retained with the bounded token, next dispatcher
# refused.
expect_int_refusal27() { # fixture task expected-token label-prefix
  local TL CL
  if ! int_run27w "$1" "$2"; then
    bad "$4 — the simulated actor started" "no actor pid file; the case is inconclusive"
    return 0
  fi
  expect_rc 38 "$RC27W" "$4 — refused with exit 38, never 28" "$O27W"
  out_lacks "  terminal result:" "$O27W" "$4 — the refused artifact is not advertised as this run's result"
  # The dynamic label from Unit 23/25 still names the window this refusal fired
  # in, and the shared exit's operator-terminal default stays absent.
  out_has "reached the interruption terminal after a launched actor" "$O27W" \
    "$4 — the refusal names the launched-actor interruption terminal it actually reached"
  out_lacks "reached a real operator terminal" "$O27W" \
    "$4 — the refusal claims no operator terminal"
  # THE SAME TERMINAL-NEUTRAL SENTENCE (Unit 31), asserted over the consumer that
  # makes the old wording plainly false: this run was ending at code 28, so
  # "refusing to exit 0" describes an ending it was never going to have. 58e
  # asserts the identical phrases over a code-0 consumer; one clause has to be
  # true for both, which is why neither assertion may be code-specific.
  out_has "did not pass the consumer gate" "$O27W" \
    "$4 — the refusal says the promised artifact did not pass the consumer gate"
  out_has "refused as this run's reported ending" "$O27W" \
    "$4 — the refusal refuses the artifact as this run's reported ending"
  out_lacks "failed this run's own consumer gate" "$O27W" \
    "$4 — the refusal does not offer the gate as proof of the artifact's provenance"
  out_lacks "refusing to exit 0" "$O27W" \
    "$4 — the refusal assumes no exit-0 ending"
  TL="$(task_lock_for "$V27W" "$2")"; CL="$(checkout_lock_for "$V27W")"
  # NOT a finalization story and NOT a teardown story: the record published
  # perfectly well (27s owns the publication failure) and the teardown was clean
  # (27r owns that release). What failed here is what the record says.
  if [ -d "$TL" ] && [ -d "$CL" ] &&
     grep -q '^terminal result unprovable: ' "$TL/survivors" 2>/dev/null &&
     grep -q "$3" "$TL/survivors" 2>/dev/null &&
     grep -q "$3" "$CL/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL/survivors" 2>/dev/null; then
    ok "$4 — both leases retained, both pins carrying the bounded '$3' cause"
  else
    bad "$4 — both leases retained, both pins carrying the bounded '$3' cause" \
        "task=$([ -d "$TL" ] && echo present || echo absent) checkout=$([ -d "$CL" ] && echo present || echo absent) cause: $(cat "$TL/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V27W" "$2" --dry-run
  expect_rc 17 "$RC" "$4 — the next dispatcher is refused by the retained lease" "$OUT"
}

if mk_int_alter27 "$MUT27W/outonly.sh" 's/^outcome=.*/outcome=COMPLETED/'; then
  ok "27w — the outcome-only forcing fixture differs from the dispatcher and is valid bash"
  expect_int_refusal27 "$MUT27W/outonly.sh" sig-sem-out-task outcome-mismatch \
    "27w — an interruption whose record claims COMPLETED"
else
  bad "27w — the outcome-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi
if mk_int_alter27 "$MUT27W/codeonly.sh" 's/^code=.*/code=22/'; then
  ok "27w — the code-only forcing fixture differs from the dispatcher and is valid bash"
  expect_int_refusal27 "$MUT27W/codeonly.sh" sig-sem-code-task code-mismatch \
    "27w — an interruption whose record claims code 22"
else
  bad "27w — the code-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

# INDEPENDENCE, structurally, the same assertion 60j and 62c make for their own
# seams: this call site must derive its expected symbol through the sole mapping
# owner and state its expected code as a literal. A call site that passed a field
# out of the record would compare it with itself, and the two refusals above
# would go green on a forgery.
CALL27W="$(grep -n '# interruption terminal consumption' "$DISPATCH_BIN" | grep -v ':[[:space:]]*#' | cut -d: -f2-)"
if printf '%s\n' "$CALL27W" | grep -q 'result_outcome 28' &&
   ! printf '%s\n' "$CALL27W" | grep -qE 'RESULT_FILE|TR_OUTCOME|TR_CODE|res_field|\.result'; then
  ok "27w — the interruption seam derives its expected pair through result_outcome and reads nothing from the artifact"
else
  bad "27w — the interruption seam derives its expected pair through result_outcome and reads nothing from the artifact" \
      "call site: $CALL27W"
fi

# ================================================================ case 27x
echo
echo "Case 27x — mutation control: remove ONLY the interruption expected pair and both mismatches release again"
# M37 — the fourth in the M33/M34/M36 line. It strips exactly the two expectation
# arguments from the interruption call, leaving that call, its DYNAMIC label, its
# run-evidence eligibility guard, the path gate, the parse and the identity
# boundary in place, AND leaving the operator, dry-run and carry-one pairs
# untouched — which is what proves the four migrated seams are separately
# fail-capable rather than one shared switch. Fails closed: unless the selector
# matched exactly once and the mutant differs and parses, the control does not run.
sed 's/ "$term_label" "$(result_outcome 28)" 28 # interruption terminal consumption/ "$term_label" # interruption terminal consumption/' \
  "$DISPATCH_BIN" >"$MUT27W/m37.sh" 2>/dev/null
M37_HITS="$(grep -c ' "\$term_label" "\$(result_outcome 28)" 28 # interruption terminal consumption' "$DISPATCH_BIN" 2>/dev/null | head -1)"
M37_LEFT="$(grep -c ' "\$term_label" "\$(result_outcome 28)" 28 # interruption terminal consumption' "$MUT27W/m37.sh" 2>/dev/null | head -1)"
M37_KEPT="$(grep -c 'consume_terminal_result "\$term_label" # interruption terminal consumption' "$MUT27W/m37.sh" 2>/dev/null | head -1)"
M37_GUARD="$(grep -cF '[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] &&' "$MUT27W/m37.sh" 2>/dev/null | head -1)"
M37_OP="$(grep -c ' "" "\$(result_outcome 0)" 0 # operator terminal consumption' "$MUT27W/m37.sh" 2>/dev/null | head -1)"
M37_DRY="$(grep -c ' "\$(result_outcome 0)" 0 # dry-run terminal consumption' "$MUT27W/m37.sh" 2>/dev/null | head -1)"
M37_CARRY="$(grep -c ' "\$(result_outcome 0)" 0 # carry-one terminal consumption' "$MUT27W/m37.sh" 2>/dev/null | head -1)"
M37_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT27W/m37.sh" || M37_DIFFERS=yes
M37_PARSES=no; bash -n "$MUT27W/m37.sh" 2>/dev/null && M37_PARSES=yes
if [ "$M37_HITS" = 1 ] && [ "$M37_LEFT" = 0 ] && [ "$M37_KEPT" = 1 ] && [ "$M37_GUARD" = 2 ] &&
   [ "$M37_OP" = 1 ] && [ "$M37_DRY" = 1 ] && [ "$M37_CARRY" = 1 ] &&
   [ "$M37_DIFFERS" = yes ] && [ "$M37_PARSES" = yes ]; then
  ok "27x — M37 removed exactly the interruption pair, kept its labelled guarded consumer call and the other three pairs, differs, and parses"
  for f27 in outcome:COMPLETED code:22; do
    FLD27="${f27%%:*}"; VAL27="${f27##*:}"
    if mk_int_alter27 "$MUT27W/m37-$FLD27.sh" "s/^$FLD27=.*/$FLD27=$VAL27/" "$MUT27W/m37.sh"; then
      if int_run27w "$MUT27W/m37-$FLD27.sh" "sig-m37-$FLD27-task"; then
        if [ "$RC27W" -eq 28 ] && [ ! -d "$(task_lock_for "$V27W" "sig-m37-$FLD27-task")" ] &&
           [ ! -d "$(checkout_lock_for "$V27W")" ]; then
          ok "27x — M37: without the expected pair the $FLD27-only mismatch exits 28 and releases (27w is fail-capable)"
        else
          bad "27x — M37: without the expected pair the $FLD27-only mismatch exits 28 and releases (27w is fail-capable)" \
              "rc=$RC27W task-lease=$([ -d "$(task_lock_for "$V27W" "sig-m37-$FLD27-task")" ] && echo held || echo released)"
        fi
      else
        bad "27x — M37: the $FLD27-only mutant launched its actor" "no actor pid file; the control is inconclusive"
      fi
    else
      bad "27x — M37: the $FLD27-only fixture over the mutant differs and parses" \
          "the injection matched nothing, or the fixture does not parse — the control cannot run"
    fi
  done
else
  bad "27x — M37 removed exactly the interruption pair, kept its labelled guarded consumer call and the other three pairs, differs, and parses" \
      "matched=$M37_HITS left=$M37_LEFT kept=$M37_KEPT guards=$M37_GUARD operator=$M37_OP dry-run=$M37_DRY carry-one=$M37_CARRY differs=$M37_DIFFERS parses=$M37_PARSES — the control cannot run"
fi

# ================================================================= case 28
echo
echo "Case 28 — --deadline is a deadline, not a start gate"
d="$(new_sandbox)"; state_file "$d" "budget-task" "claude"
# The actor outlives the deadline by a wide margin. If --deadline only gated the
# START of a hop, this would run the full 60s; the clamp must kill it near 3s.
HANG='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; sleep 60'
t0="$(date '+%s')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task budget-task --log-dir "$d/runs" \
      --timeout 60 --deadline 3 --actor-cmd "$HANG" 2>&1)"; RC=$?
elapsed=$(( $(date '+%s') - t0 ))
expect_rc 29 "$RC" "exits 29 BUDGET_EXHAUSTED" "$OUT"
# The bound is asserted from the arithmetic, not from a round number.
#   deadline 3 + 1s poll + TERM_GRACE_SECS 5 + KILL_SETTLE_SECS 2
#             + census/reaping slack 3 = 14
# The previous version of this case accepted anything under 20s, which a 60s
# timeout could have slipped through on a slow machine — too loose to prove a hard
# clock (caught in review, 2026-08-07). If TERM_GRACE_SECS or KILL_SETTLE_SECS
# changes in dispatch.sh, this number changes with it.
#
# RAISED 11 -> 14 on 2026-08-07 by the whole-tree teardown, which adds a SIGKILL
# settle window and a verification census the group-only sweep never ran. That is
# a real, disclosed widening of the worst case, not a loosened test: the plan
# forbids relaxing the hard clock silently, so the arithmetic above and the
# comment in dispatch.sh's effective_timeout state the same new bound.
DEADLINE_CEILING=14
if [ "$elapsed" -le "$DEADLINE_CEILING" ]; then
  ok "terminated within the stated worst case (${elapsed}s <= ${DEADLINE_CEILING}s; the timeout was 60s)"
else
  bad "terminated within the stated worst case" \
      "took ${elapsed}s, bound is ${DEADLINE_CEILING}s (deadline 3 + poll 1 + grace 5 + slack 2)"
fi
printf '%s' "$OUT" | grep -q "THIS IS NOT COMPLETION" \
  && ok "refuses to be read as completion" || bad "refuses to be read as completion" "$OUT"
printf '%s' "$OUT" | grep -qi "resumable\|re-run this dispatcher" \
  && ok "says the work is resumable" || bad "says the work is resumable" "$OUT"

echo
echo "Case 28b — an expired clock REFUSES the next hop rather than starting it"
d="$(new_sandbox)"; state_file "$d" "budget-none" "claude"
# The other half of 1b: a DIFFERENT code path from case 28. Case 28 kills a
# running actor at the clock; this asserts the check at the TOP of the loop, which
# declines to launch at all.
#
# --deadline 1 is what makes the branch deterministic. Whichever way the timing
# falls, the refuse branch is the one that fires: either the clock is already gone
# at the first check (no hop runs), or hop 1's instant actor completes and the
# check before hop 2 finds it gone. What is NOT asserted is the hop count — that
# genuinely is timing-dependent, and asserting it was what made an earlier version
# of this case fail intermittently by landing on the mid-hop kill instead.
#
# The branch is identified by its message: "with turn still" is unique to the
# refuse path; the kill path says "expired during hop".
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task budget-none --log-dir "$d/runs" \
      --timeout 30 --deadline 1 --max-hops 200 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 29 "$RC" "exits 29 once the clock is gone" "$OUT"
if printf '%s' "$OUT" | grep -q "with turn still"; then
  ok "the stop is the refuse-to-launch branch (no actor was launched into an expired clock)"
elif printf '%s' "$OUT" | grep -q "expired during hop"; then
  bad "the stop is the refuse-to-launch branch" "took the mid-hop kill path instead — case 28 already covers that"
else
  bad "the stop is the refuse-to-launch branch" "neither 29 message matched: $OUT"
fi
printf '%s' "$OUT" | grep -q "THIS IS NOT COMPLETION" \
  && ok "the refuse branch also refuses to be read as completion" \
  || bad "the refuse branch also refuses to be read as completion" "$OUT"

echo
echo "Case 28c — no --deadline keeps the old unbounded-by-clock behaviour"
d="$(new_sandbox)"; state_file "$d" "nodeadline" "claude"
run_dispatch "$d" nodeadline --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "reaches turn: operator and exits 0 with no deadline set" "$OUT"
printf '%s' "$OUT" | grep -q "deadline=none" \
  && ok "states the real upper bound when no deadline is set" || bad "states the real upper bound" "$OUT"

echo
echo "Case 28d — --deadline must be a positive integer"
d="$(new_sandbox)"; state_file "$d" "badbudget" "claude"
run_dispatch "$d" badbudget --deadline abc --actor-cmd "$FLIP"
expect_rc 10 "$RC" "rejects a non-numeric --deadline" "$OUT"
run_dispatch "$d" badbudget --deadline 0 --actor-cmd "$FLIP"
expect_rc 10 "$RC" "rejects --deadline 0" "$OUT"

# ================================================================= case 29
# Phase 1c. Established fact 5 of the plan: foreign_worktree() reads
# `git status --porcelain`, so anything an actor COMMITS leaves a clean tree and
# passes the guard. These cases pin the gap shut.
echo
echo "Case 29 — an actor that COMMITS outside the allowlist is stopped"
d="$(new_sandbox)"; state_file "$d" "commit-task" "claude"
COMMIT_FOREIGN='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
  awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
  mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE";
  printf "actor wrote this\n" > "$WL_CHECKOUT/outside.txt";
  git -C "$WL_CHECKOUT" add -A >/dev/null 2>&1;
  git -C "$WL_CHECKOUT" commit -qm "actor commit outside the allowlist" >/dev/null 2>&1'
run_dispatch "$d" commit-task --actor-cmd "$COMMIT_FOREIGN"
expect_rc 30 "$RC" "exits 30 UNEXPECTED_COMMIT" "$OUT"
printf '%s' "$OUT" | grep -q "outside.txt" \
  && ok "names the committed path" || bad "names the committed path" "$OUT"
printf '%s' "$OUT" | grep -qi "already exists\|detection" \
  && ok "is honest that the commit already happened" || bad "is honest that the commit already happened" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "stopped after the offending hop; no further launch" \
                          || bad "stopped after the offending hop" "calls=$(calls "$d")"

echo
echo "Case 29b — committing INSIDE the allowlist is normal work and passes"
d="$(new_sandbox)"; state_file "$d" "commit-ok" "claude"
run_dispatch "$d" commit-ok --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "a Claude hop that commits only the state file reaches operator" "$OUT"

echo
echo "Case 29c — a widened --allow-path admits the same commit"
d="$(new_sandbox)"; state_file "$d" "commit-allowed" "claude"
# --carry-one bounds this to the single hop under test. Without it the turn moves
# to codex and the NEXT hop trips the Codex-moved-HEAD guard instead, which would
# make the assertion pass for the wrong reason.
run_dispatch "$d" commit-allowed --carry-one \
  --allow-path '^logs/work-loop/' --allow-path '^outside\.txt' \
  --actor-cmd "$COMMIT_FOREIGN"
expect_rc 0 "$RC" "the same commit is admitted once its path is allowlisted" "$OUT"
printf '%s' "$OUT" | grep -q "within the allowlist" \
  && ok "reports the commit as allowlisted rather than silently ignoring it" \
  || bad "reports the commit as allowlisted" "$OUT"

# ================================================================= case 30
echo
echo "Case 30 — --status is read-only and takes no lock"
d="$(new_sandbox)"; state_file "$d" "status-task" "claude"
before="$(shasum -a 256 "$d/logs/work-loop/status-task.md" | cut -d' ' -f1)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task status-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0" "$OUT"
[ "$before" = "$(shasum -a 256 "$d/logs/work-loop/status-task.md" | cut -d' ' -f1)" ] \
  && ok "the state file is byte-identical afterwards" || bad "the state file is byte-identical afterwards"
printf '%s' "$OUT" | grep -q "turn=claude" && ok "reports the current turn" || bad "reports the current turn" "$OUT"
printf '%s' "$OUT" | grep -q "none in flight" && ok "reports no run in flight" || bad "reports no run in flight" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"
# The contract that makes it usable mid-run: it must create nothing.
[ ! -d "$d/runs" ] && ok "created no run-log directory" || bad "created no run-log directory" "$d/runs exists"
LK="$(task_lock_for "$d" status-task)"
[ ! -d "$LK" ] && ok "acquired no lock" || { bad "acquired no lock" "$LK exists"; rm -rf "$LK"; }

echo
echo "Case 30b — --status detects a run in flight and does not disturb it"
d="$(new_sandbox)"; state_file "$d" "inflight" "claude"
SIGROOT="$SANDBOX_ROOT/sig30"; mkdir -p "$SIGROOT"
SLOW='echo $$ > "'"$SIGROOT"'/actor.pid"; sleep 300'
bash "$DISPATCH_BIN" --checkout "$d" --task inflight --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$SLOW" >"$SIGROOT/out" 2>&1 &
DPID=$!
for _ in $(seq 1 40); do [ -f "$SIGROOT/actor.pid" ] && break; sleep 0.5; done
sleep 1
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task inflight --log-dir "$d/runs" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0 while another dispatcher holds the lock (17 would be wrong here)" "$OUT"
printf '%s' "$OUT" | grep -q "IN FLIGHT" && ok "reports the run as in flight" || bad "reports the run as in flight" "$OUT"
printf '%s' "$OUT" | grep -q "kill -TERM" && ok "tells the operator how to stop it" || bad "tells the operator how to stop it" "$OUT"
kill -0 "$DPID" 2>/dev/null && ok "the in-flight run is undisturbed by --status" \
                            || bad "the in-flight run is undisturbed by --status" "dispatcher died"
kill -TERM "$DPID" 2>/dev/null; sleep 4
kill -KILL "$DPID" "$(cat "$SIGROOT/actor.pid" 2>/dev/null)" 2>/dev/null
rm -rf "$(task_lock_for "$d" inflight)" "$(checkout_lock_for "$d")" 2>/dev/null

echo
echo "Case 30c — --status and --dry-run are not interchangeable"
d="$(new_sandbox)"; state_file "$d" "bothmodes" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task bothmodes --status --dry-run 2>&1)"; RC=$?
expect_rc 10 "$RC" "refuses --status --dry-run together rather than silently picking one" "$OUT"

# ================================================================ case 30d/e
# The Phase 0 § 0b item 3 defect: `--status` reported a genuinely live dispatcher
# (pid 79266) as STALE LOCK because sandbox policy refused `kill -0`, and then
# told the operator to `rm -rf` the live lock.
#
# Cases 30–30c did not catch it, because they all run where PID inspection is
# permitted. These two cases are a MATCHED PAIR and only mean something together:
#
#   30d  a pid that cannot be inspected  -> must be UNKNOWN, must not say rm -rf
#   30e  a pid that is positively absent -> must STILL be STALE LOCK
#
# 30e is the positive control. Without it, a "fix" that answered UNKNOWN to every
# failed check would pass 30d while destroying the stale-lock report entirely.
#
# Forcing a real permission denial, with no mocking: pid 1 is launchd. It always
# exists, it is owned by root, and `kill -0 1` as a non-root user returns EPERM
# — the same errno the Codex sandbox produced. That is a genuine uninspectable
# live process, not a simulation of one. It only works as non-root, so the case
# refuses to score itself rather than passing vacuously under root.
#
# `lock_path_for` is defined once, with the 27L-27q degraded-sweep cases above,
# which are the first users of it.

echo
echo "Case 30d — a pid that CANNOT be inspected reports UNKNOWN, never STALE LOCK"
if [ "$(id -u)" -eq 0 ]; then
  bad "case 30d can run (needs a non-root uid so kill -0 1 is refused)" \
      "running as root: pid 1 is inspectable, so the permission-denied state cannot be forced"
else
  d="$(new_sandbox)"; state_file "$d" "denied" "claude"
  LK="$(lock_path_for "$d" denied)"
  mkdir -p "$LK"; printf '1\n' >"$LK/pid"     # pid 1 = alive, uninspectable
  before="$(shasum -a 256 "$d/logs/work-loop/denied.md" | cut -d' ' -f1)"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task denied --status 2>&1)"; RC=$?

  expect_rc 0 "$RC" "exits 0 — the exit-code contract is unchanged by the new state" "$OUT"
  printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
    && ok "reports UNKNOWN — CANNOT INSPECT" || bad "reports UNKNOWN — CANNOT INSPECT" "$OUT"
  # The regression itself. This is the assertion that fails against the pre-fix
  # dispatcher, which printed STALE LOCK here.
  printf '%s' "$OUT" | grep -q "STALE LOCK" \
    && bad "does NOT claim STALE LOCK about a pid it could not inspect" "$OUT" \
    || ok "does NOT claim STALE LOCK about a pid it could not inspect"
  # The dangerous half of the old output: acting on it corrupts a live run.
  printf '%s' "$OUT" | grep -q "rm -rf" \
    && bad "never recommends removing the lock when it cannot inspect the pid" "$OUT" \
    || ok "never recommends removing the lock when it cannot inspect the pid"
  # The caution this case exists for, now stated about the HOLDER rather than
  # about a dispatcher: this lock is planted with no `program` file, so naming a
  # dispatcher here would be the same guess correction-plan step 5 removed. The
  # caution itself is unchanged and still asserted; 30h(4) covers the holder line.
  printf '%s' "$OUT" | grep -qi "THE HOLDER MAY STILL BE LIVE" \
    && ok "says the holder may still be live" \
    || bad "says the holder may still be live" "$OUT"
  printf '%s' "$OUT" | grep -qi "LIVE DISPATCHER" \
    && bad "does not guess a dispatcher for a lease that records no program" "$OUT" \
    || ok "does not guess a dispatcher for a lease that records no program"
  # UNKNOWN must show its evidence. The first cut of this fix printed an empty
  # reason line: pid_state() set a global, but the caller read it through $( ),
  # which is a subshell, so the assignment was discarded. A blank "why:" would
  # have satisfied every other assertion here.
  printf '%s' "$OUT" | grep -qE '^ *why: *[^ ]' \
    && ok "shows the evidence for the UNKNOWN verdict, not a blank reason" \
    || bad "shows the evidence for the UNKNOWN verdict" "$OUT"
  printf '%s' "$OUT" | grep -qi "why:.*not permitted" \
    && ok "names the permission denial as the reason it cannot inspect" \
    || bad "names the permission denial as the reason" "$OUT"
  # UNKNOWN is still a report, not a shrug: the operator needs the identifiers.
  printf '%s' "$OUT" | grep -q "pid 1" && ok "still identifies the pid" || bad "still identifies the pid" "$OUT"
  printf '%s' "$OUT" | grep -qF "$LK" && ok "still identifies the lock path" || bad "still identifies the lock path" "$OUT"
  printf '%s' "$OUT" | grep -q "turn=claude" \
    && ok "still reports the state file and its turn" || bad "still reports the state file and its turn" "$OUT"
  # Read-only holds in the new branch too — it is the branch most likely to be
  # run against a live dispatcher, so this matters more here than anywhere.
  [ "$before" = "$(shasum -a 256 "$d/logs/work-loop/denied.md" | cut -d' ' -f1)" ] \
    && ok "the state file is byte-identical after an UNKNOWN report" \
    || bad "the state file is byte-identical after an UNKNOWN report"
  [ ! -d "$d/runs" ] && ok "created no run-log directory while reporting UNKNOWN" \
                     || bad "created no run-log directory while reporting UNKNOWN" "$d/runs exists"
  [ "$(calls "$d")" = "0" ] && ok "launched no actor while reporting UNKNOWN" \
                            || bad "launched no actor while reporting UNKNOWN" "calls=$(calls "$d")"
  # --status must not have touched the lock it could not inspect.
  [ -d "$LK" ] && [ "$(cat "$LK/pid")" = "1" ] \
    && ok "left the lock exactly as it found it" || bad "left the lock exactly as it found it"
  rm -rf "$LK"
fi

echo
echo "Case 30e — POSITIVE CONTROL: a pid that IS gone still reports STALE LOCK"
# Guards against a fix that simply answers UNKNOWN to everything. A reaped pid
# yields a real ESRCH, which is the only evidence that proves absence.
d="$(new_sandbox)"; state_file "$d" "reaped" "claude"
LK="$(lock_path_for "$d" reaped)"
mkdir -p "$LK"
DEADPID="$(bash -c 'exec 2>/dev/null; sleep 0 & echo $!')"
wait 2>/dev/null; sleep 1
printf '%s\n' "$DEADPID" >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task reaped --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0" "$OUT"
printf '%s' "$OUT" | grep -q "STALE LOCK" \
  && ok "still reports STALE LOCK for a positively-absent pid" \
  || bad "still reports STALE LOCK for a positively-absent pid" "$OUT"
printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
  && bad "does not blur a proven-absent pid into UNKNOWN" "$OUT" \
  || ok "does not blur a proven-absent pid into UNKNOWN"
printf '%s' "$OUT" | grep -q "rm -rf" \
  && ok "still tells the operator how to clear a genuinely stale lock" \
  || bad "still tells the operator how to clear a genuinely stale lock" "$OUT"
rm -rf "$LK"

echo
echo "Case 30f — an unreadable or malformed lock pid is UNKNOWN, not STALE LOCK"
# The old code read an empty pid file as "not running" and recommended rm -rf.
# An empty or garbled pid is a failure to inspect, not evidence of death.
d="$(new_sandbox)"; state_file "$d" "nopid" "claude"
LK="$(lock_path_for "$d" nopid)"
mkdir -p "$LK"                                   # lock dir with no pid file at all
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0" "$OUT"
printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
  && ok "an absent pid file reports UNKNOWN" || bad "an absent pid file reports UNKNOWN" "$OUT"
printf '%s' "$OUT" | grep -q "rm -rf" \
  && bad "does not recommend removing a lock whose pid it never read" "$OUT" \
  || ok "does not recommend removing a lock whose pid it never read"
printf 'not-a-pid\n' >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
  && ok "a non-numeric pid reports UNKNOWN" || bad "a non-numeric pid reports UNKNOWN" "$OUT"

# "numeric" is not the same test as "a valid pid". These three were accepted by
# the first cut of the three-state fix, and each produced a confident answer:
#
#   0    kill -0 0 SUCCEEDS — pid 0 means the CALLER'S OWN process group — so
#        --status said "IN FLIGHT — dispatcher pid 0" and instructed
#        "kill -TERM 0", which would signal the operator's own shell.
#   00   same, via the same route.
#   007  reaches kill(2) as pid 7: a true verdict about an unrelated process,
#        printed as a verdict about this lock (observed: STALE LOCK + rm -rf).
#
# A valid pid matches [1-9][0-9]*. Anything else is a corrupt lock, which is a
# thing that cannot be inspected — never a conclusion about the dispatcher.
for BADPID in 0 00 007 0000000; do
  printf '%s\n' "$BADPID" >"$LK/pid"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
  expect_rc 0 "$RC" "pid '$BADPID': exits 0 (the exit-code contract is unchanged)" "$OUT"
  printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
    && ok "pid '$BADPID' reports UNKNOWN — CANNOT INSPECT" \
    || bad "pid '$BADPID' reports UNKNOWN — CANNOT INSPECT" "$OUT"
  # No conclusion, and above all no instruction: `kill -TERM 0` and `rm -rf` are
  # the two ways this output can destroy something.
  for FORBIDDEN in "IN FLIGHT" "STALE LOCK" "kill -TERM" "rm -rf"; do
    printf '%s' "$OUT" | grep -qF "$FORBIDDEN" \
      && bad "pid '$BADPID' output contains no '$FORBIDDEN'" "$OUT" \
      || ok "pid '$BADPID' output contains no '$FORBIDDEN'"
  done
done

# The boundary the rule turns on: 1 is the smallest valid pid and must NOT be
# swept up by the zero rule. Without this, "reject 0*" could quietly become
# "reject anything starting with a digit ≤ some bound" and nobody would notice.
printf '1\n' >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -q "pid 1 " \
  && ok "pid 1 is still treated as a valid pid and inspected" \
  || bad "pid 1 is still treated as a valid pid and inspected" "$OUT"
printf '%s' "$OUT" | grep -qi "not a usable process id" \
  && bad "pid 1 is not rejected by the zero rule" "$OUT" \
  || ok "pid 1 is not rejected by the zero rule"
# 10 exercises the other side: a valid pid that merely CONTAINS a zero.
printf '10\n' >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -qi "not a usable process id" \
  && bad "a pid containing a zero (10) is not rejected" "$OUT" \
  || ok "a pid containing a zero (10) is not rejected"
rm -rf "$LK"

# ============================================================ case 30g/30h
# THE PROPOSAL'S CASE 22, and the controls that keep it honest.
#
# NUMBERED 30g/30h ON PURPOSE. "Case 22" is already taken in this file by the
# malformed-close case, and the number in the correction plan is the PROPOSAL's
# acceptance-matrix number, not this suite's. Renumbering the local case would
# break every reference to it; naming the proposal's case in the header is the
# cheaper half of the same fix.
#
# WHAT WAS WRONG. `--status` described whoever held a lease as a dispatcher,
# because a dispatcher is the program doing the looking. The lease has recorded
# `program` since it became shared, and the acquisition refusals already read it
# (holder_label, dispatch.sh) — status did not. Against a carrier-held lease it
# therefore printed "IN FLIGHT — dispatcher pid N", which sends an operator
# looking for a process that does not exist, and the checkout-lease line named a
# task while naming no holder at all.
#
# ONE FORMATTER, both surfaces. The correction plan's step 5 fixes the drift at
# its source: refusals and status render the holder through the same function,
# so the two vocabularies cannot separate again. That is why the acquisition
# assertions in cases 12, 12e and 12g moved to the plan's exact wording in the
# same change — they are reading the same formatter these cases read.
#
# 30g uses a REAL carrier holding both leases, because what is under test is
# whether status reads a lease another program actually took. 30h plants its
# leases: it asks what the message SAYS about each recorded-program class, and
# two of those classes (absent, unrecognised) cannot be produced by any program
# that is working correctly.
echo
echo "Case 30g — proposal case 22: --status over a CARRIER-HELD lease names the attended holder"
d="$(new_sandbox)"; state_file "$d" "st-carried" "claude"
CCOUNT="$SANDBOX_ROOT/st22.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/st22.stub"
# A long hold: the stub commits to the state file when it finishes, and the
# no-write assertions below must run inside the window where the carrier is
# holding and not yet writing.
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/st-carried.md" 14
( bash "$CARRY_BIN" --checkout "$d" --task st-carried --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/st22-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
CK22="$(checkout_lock_for "$d")"; TK22="$(task_lock_for "$d" st-carried)"
# Without this the case could pass against a carrier that never took a lease,
# which would make every assertion below a statement about an empty directory.
{ [ -d "$CK22" ] && [ -d "$TK22" ]; } \
  && ok "30g setup — the carrier holds BOTH the task and the checkout lease" \
  || bad "30g setup — the carrier holds BOTH the task and the checkout lease" \
         "checkout=$([ -d "$CK22" ] && echo held || echo absent) task=$([ -d "$TK22" ] && echo held || echo absent)"
REF22="$(lock_root_for "$d")/refusals"
n_ref22="$(ls -1 "$REF22" 2>/dev/null | wc -l | tr -d ' ')"
TREE_BEFORE="$(tree_manifest "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task st-carried \
        --log-dir "$d/st22-runs" --status 2>&1)"; RC=$?
TREE_AFTER="$(tree_manifest "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain)"
expect_rc 0 "$RC" "--status over a carrier-held lease exits 0" "$OUT"
out_has 'checkout-lock: HELD by an attended carry' "$OUT" \
  "  and the CHECKOUT-lease line names the attended carrier"
out_has 'IN FLIGHT — an attended carry' "$OUT" \
  "  and the TASK-lease LIVE line names the attended carrier"
out_lacks 'a dispatcher' "$OUT" \
  "  and calls the carrier a dispatcher nowhere in the report"
# The exact string the old code printed. "a dispatcher" alone would have passed
# against it — it said "dispatcher pid N" — so the negative half needs the
# wording that was actually wrong, or it asserts nothing about this defect.
out_lacks 'dispatcher pid' "$OUT" \
  "  and does not fall back to the old unconditional \"dispatcher pid\" wording"
# READ-ONLY, on every surface it could have touched.
[ ! -e "$d/st22-runs" ] \
  && ok "  and created no run-log directory in the checkout" \
  || bad "  and created no run-log directory in the checkout" "$(ls -a "$d/st22-runs" 2>&1 | tr '\n' ' ')"
[ "$n_ref22" = "$(ls -1 "$REF22" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  and filed no refusal record" \
  || bad "  and filed no refusal record" "refusal count moved from $n_ref22"
if [ "$TREE_BEFORE" = "$TREE_AFTER" ]; then
  ok "  and every byte of the checkout's working tree is unchanged"
else
  bad "  and every byte of the checkout's working tree is unchanged" \
      "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -10 | tr '\n' ' ')"
fi
[ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and git status is unchanged" \
  || bad "  and git status is unchanged" "before [$STATUS_BEFORE] after [$STATUS_AFTER]"
# "Took no lease" is not the same as "created no directory": both lease
# directories already existed. What must hold is that they are still the
# CARRIER'S — a status run that had acquired anything would have rewritten them.
{ [ "$(cat "$CK22/program" 2>/dev/null)" = carry ] && [ "$(cat "$TK22/program" 2>/dev/null)" = carry ]; } \
  && ok "  and both leases still record the carrier as holder, so status took neither" \
  || bad "  and both leases still record the carrier as holder, so status took neither" \
         "checkout=$(cat "$CK22/program" 2>/dev/null) task=$(cat "$TK22/program" 2>/dev/null)"
kill -0 "$carrier" 2>/dev/null \
  && ok "  and the carrier is undisturbed by the status run" \
  || bad "  and the carrier is undisturbed by the status run" "the carrier is gone"
wait "$carrier" 2>/dev/null
# The control. Without it every assertion above would pass just as well against
# a carrier that took its leases and never ran anything.
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD both leases did launch its own actor" \
  || bad "  control — the carrier that HELD both leases did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"

echo
echo "Case 30h — --status reports the RECORDED program: a dispatcher, an absent one, an unknown one"
d="$(new_sandbox)"; state_file "$d" "prog-task" "claude"
CKp="$(checkout_lock_for "$d")"; TKp="$(task_lock_for "$d" prog-task)"
# plant_lease records the TEST'S OWN pid, which is alive, so these all reach the
# LIVE branch. The pid states themselves are 30b/30d/30e/30f's subject; what is
# under test here is only which program the LIVE line names.

# (1) THE POSITIVE CONTROL, and it is the load-bearing one. A "fix" that printed
# "an attended carry" unconditionally would satisfy 30g completely and be just
# as wrong as the hard-coded dispatcher it replaced.
plant_lease "$TKp" prog-task "$d" dispatch
plant_lease "$CKp" prog-task "$d" dispatch
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "a dispatcher-held lease: --status exits 0" "$OUT"
out_has 'checkout-lock: HELD by a dispatcher' "$OUT" \
  "  and the checkout-lease line still names a dispatcher when a dispatcher holds it"
out_has 'IN FLIGHT — a dispatcher' "$OUT" \
  "  and the LIVE line still names a dispatcher when a dispatcher holds it"
out_lacks 'an attended carry' "$OUT" \
  "  control — it does not call a dispatcher an attended carry"
rm -rf "$CKp" "$TKp"

# (2) NO `program` FILE — an older lease, or one caught part-written. Held, and
# reported as unrecorded rather than guessed in either direction.
plant_lease "$TKp" prog-task "$d"
plant_lease "$CKp" prog-task "$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "a lease with no recorded program: --status exits 0" "$OUT"
out_has 'checkout-lock: HELD by a Work Loop run (program unrecorded)' "$OUT" \
  "  and the checkout-lease line says the program is unrecorded"
out_has 'IN FLIGHT — a Work Loop run (program unrecorded)' "$OUT" \
  "  and the LIVE line says the program is unrecorded"
out_lacks 'a dispatcher' "$OUT" "  and does not guess a dispatcher"
out_lacks 'an attended carry' "$OUT" "  and does not guess a carrier either"
rm -rf "$CKp" "$TKp"

# (3) A PROGRAM THIS DISPATCHER DOES NOT KNOW is reported verbatim: a name the
# operator can search for is worth more than "some other run".
plant_lease "$TKp" prog-task "$d" some-future-runner
plant_lease "$CKp" prog-task "$d" some-future-runner
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "a lease held by an UNKNOWN program: --status exits 0" "$OUT"
out_has 'checkout-lock: HELD by a Work Loop run (some-future-runner)' "$OUT" \
  "  and the checkout-lease line reports the unknown program verbatim"
out_has 'IN FLIGHT — a Work Loop run (some-future-runner)' "$OUT" \
  "  and the LIVE line reports the unknown program verbatim"
rm -rf "$CKp" "$TKp"

# (4) THE UNKNOWN PID PATH, the other half of the plan's "LIVE/UNKNOWN" pair.
# The verdict there is that nothing could be inspected — which is exactly when
# an operator most needs to be told who the lease SAYS holds it. Same real
# permission denial 30d uses: pid 1 is root-owned, so `kill -0 1` returns EPERM
# for any non-root caller.
if [ "$(id -u)" -eq 0 ]; then
  bad "case 30h(4) can run (needs a non-root uid so kill -0 1 is refused)" \
      "running as root: pid 1 is inspectable, so the UNKNOWN state cannot be forced"
else
  plant_lease "$TKp" prog-task "$d" carry
  printf '1\n' >"$TKp/pid"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
  expect_rc 0 "$RC" "an UNINSPECTABLE carrier-held lease: --status exits 0" "$OUT"
  printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
    && ok "  and the verdict is still UNKNOWN — CANNOT INSPECT" \
    || bad "  and the verdict is still UNKNOWN — CANNOT INSPECT" "$OUT"
  out_has 'the lease records its holder as an attended carry' "$OUT" \
    "  and the UNKNOWN branch names the recorded holder rather than assuming a dispatcher"
  out_lacks 'LIVE DISPATCHER' "$OUT" \
    "  and no longer calls an uninspectable carrier a live dispatcher"
  printf '%s' "$OUT" | grep -q "rm -rf" \
    && bad "  and still never recommends removing a lock it could not inspect" "$OUT" \
    || ok "  and still never recommends removing a lock it could not inspect"
  rm -rf "$TKp"
fi

# ================================================================ case 30i
# THE PROPOSAL'S CASE 16 — a pin claims only what the run actually acquired, and
# --status reports exactly that state.
#
# NUMBERED 30i for case 30g's reason: "case 16" is already taken in this file by
# the foreign-unstaged-work case, and the number in the correction plan is the
# PROPOSAL's acceptance-matrix number, not this suite's.
#
# WHAT WAS MISSING, and it is a seam rather than a behaviour. The library's own
# suite proves the pin GUARD (work-loop-lease.test.sh case 6), driving the
# library directly. Nothing proved what the DISPATCHER shows an operator
# standing in front of the resulting half-pinned repository, and that is the
# surface the operator actually reads. A guard nobody can observe is a guard
# whose regression is silent.
#
# WHY THE LIBRARY IS DRIVEN DIRECTLY HERE TOO. wl_lease_acquire rolls the task
# lease back when the checkout lease is refused (work-loop-lease.sh 470-473), so
# "owns the task lease and not the checkout lease" is unreachable through
# acquire alone. The state is real — a run reaches it whenever a resource is
# lost between acquisition and teardown — but the route into it is not, and what
# is under test is the guard and the report, not the route. The library that is
# driven is the SANDBOX's own copy, the same file the dispatcher sources.
#
# THE DISCRIMINATOR IS THE CHECKOUT LEASE, and it is behavioural rather than a
# string. An unowned lease that was wrongly pinned would refuse every later run
# in that checkout permanently; an unowned lease that was correctly left alone
# is an ordinary dead lease the next run reclaims. Part A runs an unrelated task
# and requires it to be ADMITTED; part B pins a genuinely owned checkout lease
# and requires the same run to be REFUSED. Neither half means anything without
# the other: A alone passes against a pin that never writes the checkout lease
# at all, and B alone passes against a pin that writes it unconditionally.
PARTIAL_DRV="$SANDBOX_ROOT/partial-pin.sh"
cat >"$PARTIAL_DRV" <<'DRV'
#!/bin/bash
# Drives the shared lease library to the state proposal case 16 names, then pins.
# A separate process because a lease is held by a PROCESS: this one exits without
# releasing, which is what a stopped run leaves behind.
set -uo pipefail
LIB="$1"; CO="$2"; TK="$3"; MODE="${4:-partial}"; SURV="$5"
# CANONICALIZE FIRST, exactly as the real callers do (dispatch.sh, carry-turn.sh)
# before they reach wl_lease_init. The library hashes the checkout string it is
# GIVEN (work-loop-lease.sh 167) rather than a resolved path, so a driver that
# passed the raw sandbox path would take its checkout lease under a second key —
# on macOS ${TMPDIR} is /var/... and its resolved form is /private/var/... — and
# every assertion here would then be about a directory the dispatcher never
# looks at. The task lease would still line up, because its key is the task id,
# which is what makes this failure quiet.
CO="$(cd "$CO" && pwd -P)" || { printf 'CHECKOUT-UNRESOLVABLE\n'; exit 72; }
. "$LIB" || { printf 'LIB-SOURCE-FAILED\n'; exit 70; }
wl_lease_init "$CO" "$TK" || { printf 'INIT-FAILED\n'; exit 71; }
wl_lease_acquire dispatch "$$" || { printf 'ACQUIRE-REFUSED\n'; exit 17; }
# The disowning IS the case: the run no longer holds the checkout lease when it
# comes to pin. In `both` mode nothing is disowned, which is the control.
[ "$MODE" = partial ] && WL_LEASE_CHECKOUT_OWNED=0
wl_lease_pin "$SURV" "" "$TK"; prc=$?
printf 'PIN rc=%s pinned=%s task_survivors=%s checkout_survivors=%s\n' \
  "$prc" "$WL_LEASE_PINNED" \
  "$([ -f "$WL_LEASE_TASK_DIR/survivors" ] && printf yes || printf no)" \
  "$([ -f "$WL_LEASE_CHECKOUT_DIR/survivors" ] && printf yes || printf no)"
exit 0
DRV

echo
echo "Case 30i — proposal case 16: a PARTIAL acquisition pins only the lease it held, and --status says so"
d="$(new_sandbox)"
state_file "$d" "pin-partial" "claude"
state_file "$d" "pin-other"   "claude"
CKi="$(checkout_lock_for "$d")"; TKi="$(task_lock_for "$d" pin-partial)"
DRVOUT="$(bash "$PARTIAL_DRV" "$d/logs/scripts/work-loop-lease.sh" "$d" pin-partial partial 4242 2>&1)"; RC=$?
expect_rc 0 "$RC" "30i setup — the run acquired both leases, disowned the checkout, then pinned" "$DRVOUT"
out_has 'PIN rc=0 pinned=1' "$DRVOUT" "30i setup — and the pin reports success"
# THE MIRROR CHECK, and it is the one this case was first written without. Both
# lease directories must be where THIS suite derives them, or every assertion
# below is a statement about a path nothing wrote. The task lease alone would
# not catch it: its key is the task id, so it lines up under any checkout
# string, while the checkout lease's key is the checkout path itself.
{ [ -d "$TKi" ] && [ -d "$CKi" ]; } \
  && ok "30i setup — both leases are where this suite derives them, so the case observes the run's own state" \
  || bad "30i setup — both leases are where this suite derives them" \
         "task=$([ -d "$TKi" ] && echo present || echo absent) checkout=$([ -d "$CKi" ] && echo present || echo absent)"
# THE GUARD, on disk. `survivors` is the exact file wl_lease_acquire and
# wl_lease_status recognise a pin by, so this is the state a later process sees.
[ -f "$TKi/survivors" ] \
  && ok "  the OWNED task lease carries the pin evidence" \
  || bad "  the OWNED task lease carries the pin evidence" "no survivors file at $TKi"
[ -f "$CKi/survivors" ] \
  && bad "  and the UNOWNED checkout lease was NOT pinned" "the pin claimed a lease this run did not hold" \
  || ok "  and the UNOWNED checkout lease was NOT pinned"
# --status, read-only, over exactly that half-pinned state.
TREE_BEFORE="$(tree_manifest "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task pin-partial \
        --log-dir "$d/pin-runs" --status 2>&1)"; RC=$?
TREE_AFTER="$(tree_manifest "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain)"
expect_rc 0 "$RC" "--status over a partially pinned repository exits 0" "$OUT"
out_has 'run: PINNED LOCK' "$OUT" \
  "  and --status reports the TASK lease as PINNED"
out_has 'descendants still running: 4242' "$OUT" \
  "  and reads back the pin evidence the operator has to act on"
# The checkout lease is HELD and not pinned, and --status must describe it as
# what it is. A report that promoted it to pinned would tell the operator to go
# and clear two things by hand where one is the answer.
out_has 'checkout-lock: HELD by a dispatcher running task pin-partial' "$OUT" \
  "  and describes the checkout lease as HELD, not as a second pin"
[ ! -e "$d/pin-runs" ] \
  && ok "  and created no run-log directory in the checkout" \
  || bad "  and created no run-log directory in the checkout" "$(ls -a "$d/pin-runs" 2>&1 | tr '\n' ' ')"
[ "$TREE_BEFORE" = "$TREE_AFTER" ] && [ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and the working tree and git status are unchanged" \
  || bad "  and the working tree and git status are unchanged" \
         "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -5 | tr '\n' ' ')"
# THE BEHAVIOURAL HALF. An unrelated task in this checkout meets the task lease
# it does not want and the checkout lease that was left unpinned — a dead,
# unpinned lease, which is the one state a later run may reclaim. It must be
# ADMITTED, or the pin silently took the whole checkout with it.
rm -f "$d.calls"
run_dispatch "$d" pin-other --actor-cmd "$FLIP_TO_OPERATOR"
[ "$RC" != "17" ] \
  && ok "  and an UNRELATED task in this checkout is still admitted" \
  || bad "  and an UNRELATED task in this checkout is still admitted" "refused: $OUT"
out_lacks 'its checkout lock is PINNED' "$OUT" \
  "  and is not turned away by a pin on a lease the stopped run never held"
[ "$(calls "$d")" = "1" ] \
  && ok "  control — that unrelated run really launched its actor" \
  || bad "  control — that unrelated run really launched its actor" "launches: $(calls "$d")"
[ -f "$TKi/survivors" ] \
  && ok "  and the genuine pin on the task lease survived all of it" \
  || bad "  and the genuine pin on the task lease survived all of it" "the pin is gone"

echo
echo "Case 30i-b — POSITIVE CONTROL: a FULL acquisition does pin the checkout lease, and it does refuse"
# Without this, every assertion in 30i above is satisfied by a pin that never
# writes a checkout lease under any circumstances.
d="$(new_sandbox)"
state_file "$d" "pin-both"  "claude"
state_file "$d" "pin-other" "claude"
CKb="$(checkout_lock_for "$d")"; TKb="$(task_lock_for "$d" pin-both)"
DRVOUT="$(bash "$PARTIAL_DRV" "$d/logs/scripts/work-loop-lease.sh" "$d" pin-both both 5353 2>&1)"; RC=$?
expect_rc 0 "$RC" "30i-b setup — the run acquired both leases and pinned while holding both" "$DRVOUT"
out_has 'task_survivors=yes checkout_survivors=yes' "$DRVOUT" \
  "  a run that OWNED both leases pins BOTH of them"
[ -f "$CKb/survivors" ] \
  && ok "  and the checkout lease carries pin evidence when the run held it" \
  || bad "  and the checkout lease carries pin evidence when the run held it" "no survivors file at $CKb"
rm -f "$d.calls"
run_dispatch "$d" pin-other --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "  and an unrelated task in this checkout IS refused by that checkout pin" "$OUT"
out_has 'its checkout lock is PINNED' "$OUT" \
  "  and the refusal names the CHECKOUT lock as the pinned resource"
[ "$(calls "$d")" = "0" ] \
  && ok "  and it launched no actor" \
  || bad "  and it launched no actor" "actors ran: $(tr '\n' ';' <"$d.calls" 2>/dev/null)"
rm -rf "$CKb" "$TKb"

# ================================================================= case 31
# --claude-deny had NO dispatcher-level coverage when it was added (caught in
# review, 2026-08-07). --actor-cmd cannot exercise it, because the flag only
# affects the live `claude` branch of launch_actor.
#
# A FAKE claude binary closes that gap without a live model call: it records the
# exact argv the dispatcher built, then behaves like a well-behaved Claude hop
# (flip the turn, commit the state file). What is under test is the dispatcher's
# argument construction — which is the whole of what --claude-deny does.
echo
echo "Case 31 — --claude-deny reaches the Claude child as --disallowedTools"
d="$(new_sandbox)"; state_file "$d" "deny-task" "claude"
FAKE="$SANDBOX_ROOT/fake-claude.sh"
cat >"$FAKE" <<'FAKEEOF'
#!/bin/bash
# Stands in for the claude binary. Records argv, then acts like a good hop.
if [ "${1:-}" = "--version" ]; then echo "0.0.0-fake (test double)"; exit 0; fi
printf '%s\n' "$@" > "$WL_ARGV_FILE"
sf="$WL_SF"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
git -C "$WL_CO" add "$sf" >/dev/null 2>&1
git -C "$WL_CO" commit -qm "fake claude hop" >/dev/null 2>&1
exit 0
FAKEEOF
chmod +x "$FAKE"

export WL_ARGV_FILE="$SANDBOX_ROOT/argv-with-deny.txt"
export WL_SF="$d/logs/work-loop/deny-task.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task deny-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" \
      --claude-deny 'Bash(git push:*)' --claude-deny 'WebFetch' 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with --claude-deny set" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  grep -qx -- "--disallowedTools" "$WL_ARGV_FILE" \
    && ok "--disallowedTools was passed to the child" \
    || bad "--disallowedTools was passed to the child" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # -F matters: the rule contains ( and *, which grep would otherwise read as a
  # pattern. Without it this assertion fails on an argv that is in fact correct.
  grep -Fqx -- "Bash(git push:*)" "$WL_ARGV_FILE" \
    && ok "the push rule reached the child verbatim, metacharacters intact" \
    || bad "the push rule reached the child verbatim" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -qx -- "WebFetch" "$WL_ARGV_FILE" \
    && ok "a second --claude-deny is passed too (the flag is repeatable)" \
    || bad "a second --claude-deny is passed too" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -qx -- "-p" "$WL_ARGV_FILE" && grep -q "work-loop-v2 deny-task" "$WL_ARGV_FILE" \
    && ok "the normal prompt arguments are unchanged" \
    || bad "the normal prompt arguments are unchanged" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # P0-F. The attended child must not inherit this checkout's bypassPermissions:
  # the discovery run read `permissionMode: bypassPermissions` off the runtime's
  # own system/init event and the v0.2 plan forbids it for an actor launch.
  # The fix is a launch-time request, so the argv is where it is provable —
  # and it must hold on the --claude-deny branch too, not only the plain one.
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "the attended child is launched with --permission-mode default, even with denies set" \
    || bad "the attended child is launched with --permission-mode default, even with denies set" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi
printf '%s' "$OUT" | grep -q "claude_deny=Bash(git push:\*) WebFetch" \
  && ok "the run log records the deny rules the run was launched under" \
  || bad "the run log records the deny rules" "$OUT"
printf '%s' "$OUT" | grep -q -- "--permission-mode default" \
  && ok "the logged command states the explicit permission mode (deny branch)" \
  || bad "the logged command states the explicit permission mode (deny branch)" "$OUT"

echo
echo "Case 31b — WITHOUT --claude-deny the child's arguments are unchanged"
d="$(new_sandbox)"; state_file "$d" "nodeny-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-no-deny.txt"
export WL_SF="$d/logs/work-loop/nodeny-task.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nodeny-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with no --claude-deny" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  # CHANGED BY O1, deliberately. This assertion used to read "no
  # --disallowedTools is passed when none was asked for" and it was correct
  # until the nested-actor deny set became a default. It is now inverted: the
  # attended path ALWAYS passes --disallowedTools, because NESTED_ACTOR_DENY is
  # never empty. The old assertion is not being relaxed — it is being replaced
  # by the opposite claim, which is the one the dispatcher now makes.
  grep -qx -- "--disallowedTools" "$WL_ARGV_FILE" \
    && ok "--disallowedTools IS passed even with no --claude-deny (the nested-actor default)" \
    || bad "--disallowedTools IS passed even with no --claude-deny" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # P0-F, the plain attended shape. Separate from case 31's assertion because
  # these are two distinct branches of launch_actor: a fix applied to one of
  # them leaves the other silently inheriting bypassPermissions.
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "the attended child is launched with --permission-mode default with no denies set" \
    || bad "the attended child is launched with --permission-mode default with no denies set" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # The correction is a permission POLICY, not a bypass. The opposite flag must
  # never appear on any path this suite drives.
  grep -q -- "dangerously-skip-permissions" "$WL_ARGV_FILE" \
    && bad "no --dangerously-skip-permissions is ever passed" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no --dangerously-skip-permissions is ever passed"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
printf '%s' "$OUT" | grep -q "claude_deny=none" \
  && ok "the run log says plainly that no extra tool denial was applied" \
  || bad "the run log says plainly that no extra tool denial was applied" "$OUT"
printf '%s' "$OUT" | grep -q -- "--permission-mode default" \
  && ok "the logged command states the explicit permission mode (plain branch)" \
  || bad "the logged command states the explicit permission mode (plain branch)" "$OUT"
unset WL_ARGV_FILE WL_SF WL_CO

# ================================================================= case 32
# --unattended: the contained 1d profile, wired into the dispatcher.
#
# The same fake-binary technique as case 31, extended in two ways it needed:
# the double now ANSWERS --version (the profile is gated on it) and records the
# environment it was launched with (one layer of the profile is env-only).
#
# What these cases can and cannot prove, stated once so no reader has to infer
# it: they prove the dispatcher REQUESTS the profile — correct argv, correct
# JSON, correct delivery scope, and a gate that fails closed. They cannot prove
# the EFFECTIVE policy inside a real child, because there is no real child here.
# That is runs/probes/unattended-effective-policy.sh, and it is a live check.

FAKE2="$SANDBOX_ROOT/fake-claude-versioned.sh"
cat >"$FAKE2" <<'FAKE2EOF'
#!/bin/bash
# Stands in for the claude binary, with a settable version and an env record.
if [ "${1:-}" = "--version" ]; then echo "${WL_FAKE_VERSION:-2.1.220 (Claude Code)}"; exit 0; fi
printf '%s\n' "$@" > "$WL_ARGV_FILE"
printf 'SCRUB=%s\n' "${CLAUDE_CODE_SUBPROCESS_ENV_SCRUB:-<unset>}" > "$WL_ENV_FILE"
sf="$WL_SF"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
git -C "$WL_CO" add "$sf" >/dev/null 2>&1
git -C "$WL_CO" commit -qm "fake claude hop" >/dev/null 2>&1
exit 0
FAKE2EOF
chmod +x "$FAKE2"

# Argv assertions run often enough below to be worth a helper. -F throughout:
# the profile's rules contain (, ) and *, which grep would otherwise interpret.
argv_has()  { grep -Fqx -- "$2" "$1"; }

echo
echo "Case 32 — --unattended builds the contained child argv"
d="$(new_sandbox)"; state_file "$d" "unatt-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-unatt.txt"
export WL_ENV_FILE="$SANDBOX_ROOT/env-unatt.txt"
export WL_SF="$d/logs/work-loop/unatt-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task unatt-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes under --unattended" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  argv_has "$WL_ARGV_FILE" "--settings" \
    && ok "the profile is delivered by --settings (CLI scope)" \
    || bad "the profile is delivered by --settings" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "Bash,Skill" \
    && ok "--tools restricts the child to Bash,Skill (no built-in Read/Edit/Write)" \
    || bad "--tools restricts the child to Bash,Skill" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "--strict-mcp-config" \
    && ok "--strict-mcp-config loads no MCP tools" \
    || bad "--strict-mcp-config loads no MCP tools" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "--no-session-persistence" \
    && ok "--no-session-persistence is passed" \
    || bad "--no-session-persistence is passed" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # Each base deny individually. A single "some deny reached the child" assertion
  # would stay green if the push rule were the one that got dropped.
  for r in 'Bash(git push:*)' 'Bash(git push *)' 'WebFetch' 'WebSearch' 'mcp__*'; do
    argv_has "$WL_ARGV_FILE" "$r" \
      && ok "base deny reached the child verbatim: $r" \
      || bad "base deny reached the child: $r" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  done
  grep -qx -- "-p" "$WL_ARGV_FILE" && grep -q "work-loop-v2 unatt-task" "$WL_ARGV_FILE" \
    && ok "the normal prompt arguments are unchanged under --unattended" \
    || bad "the normal prompt arguments are unchanged" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # stream-json is what makes the EFFECTIVE tool roster and MCP list auditable:
  # its first event is the product's own system/init. Asserted per-token, because
  # the failure that matters is a silent drop back to --output-format json, which
  # would leave the live probe with nothing but the child's prose to read.
  argv_has "$WL_ARGV_FILE" "stream-json" \
    && ok "--output-format stream-json under --unattended (the hop capture carries system/init)" \
    || bad "--output-format stream-json under --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "--verbose" \
    && ok "--verbose accompanies stream-json (required under --print)" \
    || bad "--verbose accompanies stream-json" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "json" \
    && bad "the plain json output format is NOT used under --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "the plain json output format is NOT used under --unattended"
  # The P0-F attended correction must not leak the other way either. The
  # contained profile is unchanged by that unit, and its authority question is
  # answered by the OS sandbox and the deny set, not by a permission mode.
  argv_has "$WL_ARGV_FILE" "--permission-mode" \
    && bad "no --permission-mode under --unattended (the contained profile is unchanged)" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no --permission-mode under --unattended (the contained profile is unchanged)"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi

echo
echo "Case 32b — the credential-scrub env var actually reaches the child"
# Not a formality. The scrub is the one profile layer that travels by environment
# rather than by flag or settings file, so it is the one layer a shell-scoping
# mistake could drop while every other assertion here stayed green.
if [ -f "$WL_ENV_FILE" ]; then
  grep -qx "SCRUB=1" "$WL_ENV_FILE" \
    && ok "CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 was set in the child's environment" \
    || bad "CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 reaches the child" "got: $(cat "$WL_ENV_FILE")"
else
  bad "the child recorded its environment" "no env file at $WL_ENV_FILE"
fi

echo
echo "Case 32c — the generated profile carries every settings-side layer"
PROF="$(ls -t "$d"/runs/*.unattended-settings.json 2>/dev/null | head -1)"
if [ -n "$PROF" ] && [ -s "$PROF" ]; then
  ok "a per-run profile file was written to the evidence directory"
  # Whitespace-tolerant: the assertions are about policy, not about formatting.
  prof_has() { # regex label
    grep -Eq "$1" "$PROF" && ok "$2" || bad "$2" "profile: $PROF"
  }
  prof_has '"enabled"[[:space:]]*:[[:space:]]*true'                  "sandbox.enabled: true"
  prof_has '"failIfUnavailable"[[:space:]]*:[[:space:]]*true'        "sandbox.failIfUnavailable: true — the child fails closed if the sandbox is missing"
  prof_has '"allowUnsandboxedCommands"[[:space:]]*:[[:space:]]*false' "sandbox.allowUnsandboxedCommands: false — no dangerouslyDisableSandbox escape"
  prof_has '"allowedDomains"[[:space:]]*:[[:space:]]*\[\]'           "network.allowedDomains: [] — empty allowlist"
  prof_has '"strictAllowlist"[[:space:]]*:[[:space:]]*true'          "network.strictAllowlist: true — no approval prompt to widen it"
  prof_has '"denyRead"[[:space:]]*:[[:space:]]*\["~/"\]'             "filesystem.denyRead: [\"~/\"] — home is closed to sandboxed Bash"
  prof_has '"disableAllHooks"[[:space:]]*:[[:space:]]*true'          "disableAllHooks: true"
  prof_has '"disableClaudeAiConnectors"[[:space:]]*:[[:space:]]*true' "disableClaudeAiConnectors: true"
  prof_has '"disableRemoteControl"[[:space:]]*:[[:space:]]*true'     "disableRemoteControl: true"
  prof_has '"disableAgentView"[[:space:]]*:[[:space:]]*true'         "disableAgentView: true"
  prof_has '"disableArtifact"[[:space:]]*:[[:space:]]*true'          "disableArtifact: true"
  prof_has '"autoMemoryEnabled"[[:space:]]*:[[:space:]]*false'       "autoMemoryEnabled: false"
  # The child works through sandboxed Bash, so the checkout MUST be readable or
  # the run cannot read the repository it was launched against.
  #
  # Asserted against the CANONICAL path, and that is the point rather than a
  # detail: on macOS the temp path handed to --checkout here is /var/..., which
  # is a symlink to /private/var/.... An allowRead entry naming the symlinked
  # form would not describe the path Seatbelt actually evaluates. The dispatcher
  # canonicalizes --checkout before anything else, so the profile gets the real
  # one — this case would have caught the opposite. (It caught the reverse
  # mistake in this case's own first draft, which compared the raw path.)
  d_canon="$(cd "$d" && pwd -P)"
  grep -Fq "$d_canon" "$PROF" \
    && ok "filesystem.allowRead re-opens the checkout, by its canonical path" \
    || bad "filesystem.allowRead re-opens the checkout by canonical path" "wanted $d_canon in $PROF"

  # The one named exception inside the denied home tree (operator decision A,
  # 2026-08-07). Without it Git exits 128 before touching the repository.
  grep -Fq '"~/.gitconfig"' "$PROF" \
    && ok "filesystem.allowRead re-opens ~/.gitconfig, so Git works inside the child" \
    || bad "filesystem.allowRead re-opens ~/.gitconfig" "profile: $PROF"

  # ...and the guard that the exception STAYED an exception. The operator's
  # decision was "the minimum Git configuration paths, do not broaden home
  # access", so widening is the regression to catch — and it is the kind that
  # would otherwise pass every other assertion in this file. Each pattern below
  # is a way the single file could quietly become a tree.
  prof_allow="$(sed -n '/"allowRead"/,/\]/p' "$PROF")"
  for widened in '"~/"' '"~"' '"~/.config"' '"~/.config/"' '"~/*"' '"~/.*"' '"$HOME"'; do
    if printf '%s' "$prof_allow" | grep -Fq "$widened"; then
      bad "allowRead does not broaden home access" "found $widened in allowRead"
    else
      ok "allowRead does not broaden home access with $widened"
    fi
  done
  # denyRead must still be there. An allowRead exception is only narrow if the
  # broad deny it sits inside is still in force.
  grep -Eq '"denyRead"[[:space:]]*:[[:space:]]*\["~/"\]' "$PROF" \
    && ok "the broad home denyRead is still in force around that exception" \
    || bad "the broad home denyRead is still in force" "profile: $PROF"
  # Exactly three allowRead entries: checkout, git common dir, ~/.gitconfig.
  # A count assertion catches a fourth entry that none of the named patterns above
  # would have anticipated.
  # Count the quoted entries BETWEEN the brackets, so the "allowRead" key itself
  # is not counted as one of its own values.
  n_allow="$(printf '%s' "$prof_allow" | sed -n 's/.*\[\(.*\)\].*/\1/p' | grep -o '"[^"]*"' | wc -l | tr -d ' ')"
  [ "$n_allow" -eq 3 ] \
    && ok "allowRead holds exactly three entries (checkout, git dir, ~/.gitconfig)" \
    || bad "allowRead holds exactly three entries" "counted $n_allow in: $prof_allow"
  # The argv --settings path must be the file that was actually written.
  argv_has "$WL_ARGV_FILE" "$PROF" \
    && ok "the --settings argument points at exactly the profile that was written" \
    || bad "the --settings argument points at the written profile" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "a per-run profile file was written" "nothing matching $d/runs/*.unattended-settings.json"
fi

echo
echo "Case 32d — the profile is NOT delivered through a repository settings file"
# The silent-failure path this whole design is shaped around: strictAllowlist has
# no effect from .claude/settings.json, and on a machine whose USER settings
# already carry the key the mistake is invisible. So assert the negative
# directly — the dispatcher must not have created either repo settings file, and
# the delivered path must not be inside the checkout's .claude/ directory.
if [ -e "$d/.claude/settings.json" ] || [ -e "$d/.claude/settings.local.json" ]; then
  bad "the dispatcher wrote no repository settings file" "found one under $d/.claude/"
else
  ok "the dispatcher wrote no repository settings file"
fi
case "$PROF" in
  "$d"/.claude/*) bad "the profile does not live in the checkout's .claude/ directory" "$PROF" ;;
  *)              ok "the profile does not live in the checkout's .claude/ directory" ;;
esac

echo
echo "Case 32e — the run log records the restrictions and the delivery scope"
printf '%s' "$OUT" | grep -q "unattended=ON" \
  && ok "the log says the run is contained" \
  || bad "the log says the run is contained" "$OUT"
printf '%s' "$OUT" | grep -q "scope: CLI --settings" \
  && ok "the log records the SCOPE the profile arrived through, not just that one was sent" \
  || bad "the log records the delivery scope" "$OUT"
printf '%s' "$OUT" | grep -q "gate: claude 2.1.220 >= 2.1.219" \
  && ok "the log records the version the gate actually read" \
  || bad "the log records the version the gate read" "$OUT"
printf '%s' "$OUT" | grep -q "strictAllowlist=true" \
  && ok "the log names the network policy in force" \
  || bad "the log names the network policy in force" "$OUT"
printf '%s' "$OUT" | grep -q "LIMIT: this records the REQUESTED policy" \
  && ok "the log states plainly that this is the requested, not the effective, policy" \
  || bad "the log states requested-vs-effective" "$OUT"
printf '%s' "$OUT" | grep -q "codex hops are NOT covered" \
  && ok "the log does not let the reader assume Codex hops are contained by this profile" \
  || bad "the log scopes the profile to Claude hops" "$OUT"

echo
echo "Case 32z — CONTROL: the --unattended argv is byte-unchanged"
# O1's own stated control, and the assertion that was missing when a commit on
# 2026-08-11 prepended the nested-actor denies to this path anyway. O1's surface
# is the attended launch only; the contained profile is a separately settled
# artifact that O1 excludes by name.
#
# A FROZEN WHOLE-ARGV COMPARISON, not another set of per-token greps. Every
# assertion in case 32 is "this token is present", and no number of those can
# catch an ADDED argument — which is precisely the regression that landed and
# sat green. This form fails on an addition, a removal, or a reorder.
#
# The expected list is written out literally rather than derived from the
# dispatcher's own deny arrays. Deriving it would make the test agree with
# whatever the source happens to say, which is not evidence.
dz="$(new_sandbox)"; state_file "$dz" "argvfreeze-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-freeze.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-freeze.txt"
export WL_SF="$dz/logs/work-loop/argvfreeze-task.md"
export WL_CO="$dz"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUTZ="$(bash "$DISPATCH_BIN" --checkout "$dz" --task argvfreeze-task --log-dir "$dz/runs" \
       --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RCZ=$?
expect_rc 0 "$RCZ" "the contained hop completes" "$OUTZ"
if [ -f "$WL_ARGV_FILE" ]; then
  # The generated per-run profile path is the only volatile token.
  sed 's|^.*/runs/.*\.unattended-settings\.json$|<PROFILE>|' "$WL_ARGV_FILE" \
    >"$SANDBOX_ROOT/argv-freeze.norm"
  cat >"$SANDBOX_ROOT/argv-freeze.want" <<'WANTEOF'
-p
/work-loop-v2 argvfreeze-task
--output-format
stream-json
--verbose
--settings
<PROFILE>
--tools
Bash,Skill
--strict-mcp-config
--no-session-persistence
--disallowedTools
Bash(git push:*)
Bash(git push *)
WebFetch
WebSearch
mcp__*
WANTEOF
  if diff -u "$SANDBOX_ROOT/argv-freeze.want" "$SANDBOX_ROOT/argv-freeze.norm" \
       >"$SANDBOX_ROOT/argv-freeze.diff" 2>&1; then
    ok "the --unattended argv is byte-for-byte the settled contained profile"
  else
    bad "the --unattended argv is byte-for-byte the settled contained profile" \
        "$(cat "$SANDBOX_ROOT/argv-freeze.diff")"
  fi
  # Called out separately from the frozen list because this is the specific
  # widening that landed, and it should read as its own line in the output.
  grep -Fq 'Bash(claude' "$WL_ARGV_FILE" \
    && bad "no nested-actor deny reaches the contained profile" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no nested-actor deny reaches the contained profile"
  # The run log must not describe a policy this argv does not carry.
  printf '%s' "$OUTZ" | grep -q "nested_actor_deny=n/a" \
    && ok "the run log scopes the nested-actor set to attended runs" \
    || bad "the run log scopes the nested-actor set to attended runs" "$OUTZ"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi

echo
echo "Case 32z2 — the --claude-deny append path adds no nested rule either"
# Case 32i already proves the append is additive. This one covers the other place
# a widening could hide: the composed array, when the operator set is non-empty.
dz="$(new_sandbox)"; state_file "$dz" "argvfreeze2-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-freeze2.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-freeze2.txt"
export WL_SF="$dz/logs/work-loop/argvfreeze2-task.md"
export WL_CO="$dz"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUTZ="$(bash "$DISPATCH_BIN" --checkout "$dz" --task argvfreeze2-task --log-dir "$dz/runs" \
       --carry-one --claude-bin "$FAKE2" --unattended --claude-deny 'Bash(rm:*)' 2>&1)"; RCZ=$?
expect_rc 0 "$RCZ" "the contained hop completes with an operator deny" "$OUTZ"
if [ -f "$WL_ARGV_FILE" ]; then
  # The control for the negative below: without it, the negative would pass on a
  # run that never exercised the append path at all.
  argv_has "$WL_ARGV_FILE" 'Bash(rm:*)' \
    && ok "control: the operator rule really did reach the composed array" \
    || bad "control: the operator rule reached the composed array" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -Eq 'Bash\((claude|codex)' "$WL_ARGV_FILE" \
    && bad "the composed array carries no nested-actor rule" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "the composed array carries no nested-actor rule"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi

echo
echo "Case 32f — the version gate FAILS CLOSED below 2.1.219"
d="$(new_sandbox)"; state_file "$d" "oldver-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-oldver.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-oldver.txt"
export WL_SF="$d/logs/work-loop/oldver-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.218 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task oldver-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "2.1.218 is refused with UNATTENDED_UNAVAILABLE" "$OUT"
[ -f "$WL_ARGV_FILE" ] \
  && bad "nothing launched when the gate refused" "the child ran anyway: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
  || ok "nothing launched when the gate refused"
printf '%s' "$OUT" | grep -q "strictAllowlist" \
  && ok "the refusal names WHY the version matters, not just that it is old" \
  || bad "the refusal names why the version matters" "$OUT"

echo
echo "Case 32g — the gate passes at exactly 2.1.219, and reads past a build suffix"
d="$(new_sandbox)"; state_file "$d" "minver-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-minver.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-minver.txt"
export WL_SF="$d/logs/work-loop/minver-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.219-beta.4 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task minver-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "the boundary version 2.1.219 is accepted, suffix and all" "$OUT"
# A major bump must not be read as "lower" by string comparison.
d="$(new_sandbox)"; state_file "$d" "newver-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-newver.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-newver.txt"
export WL_SF="$d/logs/work-loop/newver-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="10.0.1 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task newver-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "10.0.1 is accepted — the comparison is numeric, not lexical" "$OUT"

echo
echo "Case 32h — an unreadable version FAILS CLOSED rather than being assumed fine"
d="$(new_sandbox)"; state_file "$d" "noverr-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-noverr.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-noverr.txt"
export WL_SF="$d/logs/work-loop/noverr-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="claude code, build unknown"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task noverr-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "a version string with no dotted number is refused" "$OUT"
[ -f "$WL_ARGV_FILE" ] \
  && bad "nothing launched on an unreadable version" "the child ran anyway" \
  || ok "nothing launched on an unreadable version"
printf '%s' "$OUT" | grep -q "refusing to assume" \
  && ok "the refusal distinguishes 'cannot tell' from 'too old'" \
  || bad "the refusal distinguishes cannot-tell from too-old" "$OUT"

echo
echo "Case 32i — --claude-deny under --unattended is ADDITIVE, never a replacement"
d="$(new_sandbox)"; state_file "$d" "adddeny-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-adddeny.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-adddeny.txt"
export WL_SF="$d/logs/work-loop/adddeny-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task adddeny-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended \
      --claude-deny 'Bash(rm:*)' 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with --unattended plus an extra deny" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  argv_has "$WL_ARGV_FILE" 'Bash(rm:*)' \
    && ok "the operator's extra deny reached the child" \
    || bad "the operator's extra deny reached the child" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" 'Bash(git push:*)' && argv_has "$WL_ARGV_FILE" 'WebFetch' \
    && ok "the base profile denies SURVIVE the extra deny — narrowing only, never widening" \
    || bad "the base profile denies survive" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi

echo
echo "Case 32j — WITHOUT --unattended the child is unchanged (attended and courier)"
d="$(new_sandbox)"; state_file "$d" "attended-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-attended.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-attended.txt"
export WL_SF="$d/logs/work-loop/attended-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task attended-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" 2>&1)"; RC=$?
expect_rc 0 "$RC" "an ordinary courier hop still completes" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  for f in "--settings" "--tools" "--strict-mcp-config" "--no-session-persistence"; do
    argv_has "$WL_ARGV_FILE" "$f" \
      && bad "no $f without --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
      || ok "no $f without --unattended"
  done
  # The stream-json switch is scoped to the contained path and nowhere else.
  # Attended and courier hops keep the compact single-object capture they have
  # always had, so required outcome 3 stays true after this change.
  argv_has "$WL_ARGV_FILE" "json" \
    && ok "an attended hop still uses --output-format json" \
    || bad "an attended hop still uses --output-format json" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  for f in "stream-json" "--verbose"; do
    argv_has "$WL_ARGV_FILE" "$f" \
      && bad "no $f without --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
      || ok "no $f without --unattended"
  done
  # "Unchanged" now means unchanged EXCEPT the explicit permission mode (P0-F).
  # The attended correction is a Claude permission policy; --unattended is OS
  # containment. This case is where the two are kept distinct, so the attended
  # requirement is asserted here as well as in case 31b — a courier hop is the
  # shape the harness actually runs in normal operation.
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "an attended/courier hop asks for --permission-mode default" \
    || bad "an attended/courier hop asks for --permission-mode default" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
[ -f "$WL_ENV_FILE" ] && grep -qx "SCRUB=<unset>" "$WL_ENV_FILE" \
  && ok "the credential scrub is not set on an attended hop either" \
  || bad "the credential scrub is not set on an attended hop" "got: $(cat "$WL_ENV_FILE" 2>/dev/null)"
ls "$d"/runs/*.unattended-settings.json >/dev/null 2>&1 \
  && bad "no profile file is written without --unattended" "one exists under $d/runs" \
  || ok "no profile file is written without --unattended"
printf '%s' "$OUT" | grep -q "unattended=off" \
  && ok "the log says out loud that a live run is NOT contained" \
  || bad "the log says a live run is not contained" "$OUT"

echo
echo "Case 32k — --unattended refuses to combine with --actor-cmd"
# A simulated actor cannot be contained. Allowing the pair would produce a run
# log reading "unattended" for a run in which no profile reached anything.
d="$(new_sandbox)"; state_file "$d" "simunatt-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task simunatt-task --log-dir "$d/runs" \
      --carry-one --unattended --actor-cmd "$NOOP" 2>&1)"; RC=$?
expect_rc 10 "$RC" "--unattended with --actor-cmd is a usage error" "$OUT"
[ "$(calls "$d")" = "0" ] \
  && ok "the simulated actor was never invoked" \
  || bad "the simulated actor was never invoked" "calls=$(calls "$d")"

echo
echo "Case 32l — --dry-run --unattended is a real preflight"
d="$(new_sandbox)"; state_file "$d" "dryunatt-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-dryunatt.txt"; rm -f "$WL_ARGV_FILE"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task dryunatt-task --log-dir "$d/runs" \
      --dry-run --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "a dry run under --unattended passes the gate" "$OUT"
[ -f "$WL_ARGV_FILE" ] \
  && bad "a dry run launches nothing" "the child ran" \
  || ok "a dry run launches nothing"
ls "$d"/runs/*.unattended-settings.json >/dev/null 2>&1 \
  && ok "the profile was written, so the operator can inspect what a live run would use" \
  || bad "the profile was written during the dry run" "nothing under $d/runs"
# And the same dry run must FAIL on a host that could not deliver the profile —
# otherwise it is a preflight that only ever says yes.
export WL_FAKE_VERSION="2.1.218 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task dryunatt-task --log-dir "$d/runs" \
      --dry-run --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "the dry-run preflight refuses an under-version host too" "$OUT"
echo
echo "Case 32m — the allowRead minimality guards can actually fail"
# Why this case exists. The red-to-green pair does NOT cover the guards added for
# the operator's 2026-08-07 decision ("allow the minimum Git configuration paths,
# do not broaden home access"). Those assertions live inside a "a profile was
# written" branch, so against the pre-change dispatcher — which writes no profile
# — they do not run at all: the red count stayed 22 while the green pass count
# rose. Assertions that never execute in the red half are not proven capable of
# failing by it, and core § 6 rule 5 wants that shown, not assumed.
#
# So this case builds a real profile from the dispatcher, widens it the ways a
# future edit plausibly would, and asserts the guards go red on each. It is the
# guard on the guard.
d="$(new_sandbox)"; state_file "$d" "widen-task" "claude"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
bash "$DISPATCH_BIN" --checkout "$d" --task widen-task --log-dir "$d/runs" \
      --dry-run --claude-bin "$FAKE2" --unattended >/dev/null 2>&1
BASEPROF="$(ls -t "$d"/runs/*.unattended-settings.json 2>/dev/null | head -1)"

# The same predicates the real assertions use, applied to an arbitrary file.
# Returns 0 when at least one guard fires — i.e. the file would be rejected.
guards_fire() { # profile-path
  local f="$1" a w n
  a="$(sed -n '/"allowRead"/,/\]/p' "$f")"
  for w in '"~/"' '"~"' '"~/.config"' '"~/.config/"' '"~/*"' '"~/.*"' '"$HOME"'; do
    printf '%s' "$a" | grep -Fq "$w" && return 0
  done
  n="$(printf '%s' "$a" | sed -n 's/.*\[\(.*\)\].*/\1/p' | grep -o '"[^"]*"' | wc -l | tr -d ' ')"
  [ "$n" -ne 3 ] && return 0
  grep -Eq '"denyRead"[[:space:]]*:[[:space:]]*\["~/"\]' "$f" || return 0
  return 1
}

if [ -n "$BASEPROF" ] && [ -s "$BASEPROF" ]; then
  # Positive control first. If the guards fired on the profile that actually
  # ships, they would be catching everything and proving nothing.
  guards_fire "$BASEPROF" \
    && bad "the guards stay silent on the shipping profile" "they fired on $BASEPROF" \
    || ok "the guards stay silent on the shipping profile (positive control)"

  # Each mutation is a way the one-file exception could plausibly become a tree.
  sed 's|"~/.gitconfig"|"~/"|'                        "$BASEPROF" >"$SANDBOX_ROOT/w-home.json"
  sed 's|"~/.gitconfig"|"~/.config"|'                 "$BASEPROF" >"$SANDBOX_ROOT/w-cfgdir.json"
  sed 's|"~/.gitconfig"|"~/.gitconfig", "~/.ssh/id"|' "$BASEPROF" >"$SANDBOX_ROOT/w-extra.json"
  sed 's|"denyRead": \["~/"\]|"denyRead": []|'        "$BASEPROF" >"$SANDBOX_ROOT/w-nodeny.json"

  guards_fire "$SANDBOX_ROOT/w-home.json" \
    && ok "widening the exception to the whole home tree is caught" \
    || bad "widening to the whole home tree is caught" "guards stayed silent"
  guards_fire "$SANDBOX_ROOT/w-cfgdir.json" \
    && ok "widening the exception to a config DIRECTORY is caught" \
    || bad "widening to a config directory is caught" "guards stayed silent"
  # The one a named-pattern list would miss on its own — which is why the entry
  # count assertion exists alongside the patterns.
  guards_fire "$SANDBOX_ROOT/w-extra.json" \
    && ok "an extra fourth allowRead entry is caught, even though it matches no named pattern" \
    || bad "an extra fourth allowRead entry is caught" "guards stayed silent"
  guards_fire "$SANDBOX_ROOT/w-nodeny.json" \
    && ok "removing the broad home denyRead is caught" \
    || bad "removing the broad home denyRead is caught" "guards stayed silent"
else
  bad "a profile was generated for the widening check" "nothing under $d/runs"
fi
echo
echo "Case 32n — the stream-json assertions can actually fail"
# Same reasoning as 32m, applied to the assertions case 32 gained on 2026-08-07.
# The pre-1d dispatcher has no --unattended at all, so case 32 never reaches its
# argv assertions in the red half — the matched pair cannot show them capable of
# failing, and "obviously it would fail" is the phrase that hid the last defect.
#
# So this builds a dispatcher that has --unattended and has REGRESSED the output
# format back to --output-format json, and asserts case 32's three checks flip.
# That regression matters more than it looks: without stream-json the hop capture
# carries no system/init event, and the live probe loses the only surface on
# which the effective tool roster and MCP absence can be measured rather than
# taken from the child's own prose.
d="$(new_sandbox)"; state_file "$d" "regress-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-regress.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-regress.txt"
export WL_SF="$d/logs/work-loop/regress-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"

REGRESSED="$SANDBOX_ROOT/dispatch-regressed.sh"
sed 's|--output-format stream-json --verbose \\|--output-format json \\|' \
    "$DISPATCH_BIN" >"$REGRESSED"
chmod +x "$REGRESSED"

if ! grep -q -- '--output-format json \\' "$REGRESSED"; then
  bad "the regression mutant was actually built" "the sed found nothing to change in $DISPATCH_BIN"
else
  ok "the regression mutant was actually built (stream-json reverted to json)"
  bash "$REGRESSED" --checkout "$d" --task regress-task --log-dir "$d/runs" \
        --carry-one --claude-bin "$FAKE2" --unattended >/dev/null 2>&1
  if [ -f "$WL_ARGV_FILE" ]; then
    argv_has "$WL_ARGV_FILE" "stream-json" \
      && bad "the stream-json assertion goes red on the regressed dispatcher" "it still found stream-json" \
      || ok "the stream-json assertion goes red on the regressed dispatcher"
    argv_has "$WL_ARGV_FILE" "--verbose" \
      && bad "the --verbose assertion goes red on the regressed dispatcher" "it still found --verbose" \
      || ok "the --verbose assertion goes red on the regressed dispatcher"
    # And the inverse assertion — "plain json is NOT used" — must go red too,
    # otherwise it is a check that only ever agrees with itself.
    argv_has "$WL_ARGV_FILE" "json" \
      && ok "the no-plain-json assertion goes red on the regressed dispatcher" \
      || bad "the no-plain-json assertion goes red on the regressed dispatcher" "no plain json in the mutant's argv"
    # The rest of the profile must be untouched by the mutation, or this case
    # would be measuring a broken dispatcher rather than one regressed change.
    argv_has "$WL_ARGV_FILE" "--settings" && argv_has "$WL_ARGV_FILE" "Bash,Skill" \
      && ok "the mutation changed only the output format (the profile still ships)" \
      || bad "the mutation changed only the output format" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  else
    bad "the regressed dispatcher invoked the fake claude binary" "no argv file at $WL_ARGV_FILE"
  fi
fi

unset WL_ARGV_FILE WL_ENV_FILE WL_SF WL_CO WL_FAKE_VERSION

# ============================================ cases 40-45: bounded execution
#
# The O1-O5 outcomes of plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.2.md.
# Every case here is SIMULATED like the rest of this suite: no live model, no
# nested AI, no pilot. The two incidents these cover cost 25 minutes and 900
# seconds of real model time respectively; both shapes are reproduced below in
# seconds by a scripted actor, which is the entire argument for doing it this way.
#
# RED/GREEN. Each case below fails against the pre-change dispatcher. Run the
# suite with DISPATCH_BIN pointed at a checkout of the previous dispatch.sh to
# see the red half — that is what makes these assertions evidence rather than
# decoration.

# An allowed implementation file, tracked, so a later modification shows up as
# ' M ' rather than '??'. Both are partial effects; the tracked shape is the one
# incident 2 actually produced.
seed_impl() { # sandbox -> path (repo-relative) on stdout
  local d="$1" p="plans/work-loop-v2-v0.2/handoff-automation-spike/impl.txt"
  printf 'baseline\n' >"$d/$p"
  git -C "$d" add "$p" >/dev/null 2>&1
  git -C "$d" commit -qm "seed impl" >/dev/null 2>&1
  printf '%s' "$p"
}

# Only the PARTIAL FILE EFFECTS block, not the whole run output.
#
# THIS EXISTS BECAUSE THE OBVIOUS ASSERTION IS NOT EVIDENCE. Grepping the full
# output for the modified path passes against the PRE-CHANGE dispatcher too: the
# run log echoes the --actor-cmd verbatim (`launch: mode=simulated … cmd=…`), and
# that command string contains the very path the test is looking for. Measured,
# not theorised — the first cut of cases 41/44/45 stayed green in the red half
# for exactly this reason, which is the "a red half that passes is not evidence"
# trap the plan's verification budget names.
partial_section() { # full-output -> the block from the header to the end
  printf '%s' "$1" | sed -n '/PARTIAL FILE EFFECTS/,$p'
}

echo
echo "Case 40 — O1: the nested-actor denies reach the child, on both attended shapes"
d="$(new_sandbox)"; state_file "$d" "nest-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-nested.txt"
export WL_SF="$d/logs/work-loop/nest-task.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nest-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with the nested-actor denies in place" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  # -F throughout: these rules carry ( and *, which grep would read as a pattern.
  for rule in 'Bash(claude:*)' 'Bash(claude *)' 'Bash(codex:*)' 'Bash(codex *)'; do
    grep -Fqx -- "$rule" "$WL_ARGV_FILE" \
      && ok "the child is denied $rule" \
      || bad "the child is denied $rule" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  done
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "P0-F still holds — the nested denies did not displace --permission-mode default" \
    || bad "P0-F still holds alongside the nested denies" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
printf '%s' "$OUT" | grep -Fq "nested_actor_deny=Bash(claude:*)" \
  && ok "the run log records the nested-actor deny set" \
  || bad "the run log records the nested-actor deny set" "$OUT"
# The honesty clause. A deny at the child's permission layer is NOT containment,
# and the plan's § 3.4 makes overclaiming it a defect in its own right. Asserted
# here so a future edit cannot quietly upgrade the wording.
printf '%s' "$OUT" | grep -q "not containment" \
  && ok "the run log states plainly that this is NOT containment" \
  || bad "the run log states plainly that this is NOT containment" "$OUT"

echo
echo "Case 40b — --claude-deny APPENDS to the nested set, it does not replace it"
d="$(new_sandbox)"; state_file "$d" "nest-append" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-nested-append.txt"
export WL_SF="$d/logs/work-loop/nest-append.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nest-append --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" --claude-deny 'WebFetch' 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with an operator deny added" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  grep -Fqx -- 'Bash(claude:*)' "$WL_ARGV_FILE" \
    && ok "an operator --claude-deny does not displace the nested-actor rules" \
    || bad "an operator --claude-deny does not displace the nested-actor rules" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -Fqx -- 'WebFetch' "$WL_ARGV_FILE" \
    && ok "the operator's own rule is passed alongside them" \
    || bad "the operator's own rule is passed alongside them" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
unset WL_ARGV_FILE WL_SF WL_CO

echo
echo "Case 41 — O2: a TIMEOUT names the partial edits it left behind (incident 2)"
# The exact shape of 2026-08-11: the actor edits an allowed implementation file,
# never touches the state file, never commits, and is killed on the deadline.
# Before this change the stop said "exceeded 3s and was killed" and stopped
# there — the state file had not moved and the branch ref had not advanced, so
# every check that could have reported the edit was scoped to violations and
# found none. Three true facts, one misleading picture.
d="$(new_sandbox)"; state_file "$d" "timeout-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task timeout-task --log-dir "$d/runs" \
      --carry-one --timeout 3 \
      --actor-cmd 'printf "half-written work\n" >> "$WL_CHECKOUT/'"$IMPL"'"; sleep 30' 2>&1)"; RC=$?
expect_rc 21 "$RC" "the oversized hop is stopped by the actor timeout" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && ok "the timeout stop carries a partial-effects section" \
  || bad "the timeout stop carries a partial-effects section" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "the modified allowed file is named INSIDE the partial-effects section" \
  || bad "the modified allowed file is named INSIDE the partial-effects section" "$OUT"
printf '%s' "$OUT" | grep -q "NOT a violation" \
  && ok "the stop says the listed paths are work, not a violation" \
  || bad "the stop says the listed paths are work, not a violation" "$OUT"
# The state file genuinely did not move. That must still be true, or this case
# is proving something other than the blind spot it was written for.
[ -z "$(git -C "$d" status --porcelain -- "logs/work-loop/timeout-task.md")" ] \
  && ok "control: the state file itself is untouched, as in the real incident" \
  || bad "control: the state file itself is untouched" "$(git -C "$d" status --porcelain)"

echo
echo "Case 41b — O2 attribution: only what the hop changed SINCE LAUNCH is reported"
# The mechanism under test is the pre-launch snapshot, not the post-stop scan.
#
# Two allowed files are dirty BEFORE the actor launches — an ordinary uncommitted
# Codex handoff sitting on disk. The hop appends to one and never opens the other.
# A post-stop scan alone cannot tell them apart, because both are dirty when the
# stop is written; reporting the untouched one as "work the hop did" is the same
# false attribution O2 exists to remove, one file over.
#
# BOTH assertions are load-bearing and they fail against DIFFERENT wrong answers.
# The negative one fails a plain post-stop scan. The positive one fails a
# subtract-by-path-name implementation: this file was already dirty, so its
# porcelain status line is byte-identical before and after, and only pairing that
# line with the worktree blob hash makes the hop's additional edit observable.
d="$(new_sandbox)"; state_file "$d" "attrib-task" "claude"
IMPL="$(seed_impl "$d")"
UNTOUCHED="plans/work-loop-v2-v0.2/handoff-automation-spike/untouched.txt"
printf 'baseline\n' >"$d/$UNTOUCHED"
git -C "$d" add "$UNTOUCHED" >/dev/null 2>&1
git -C "$d" commit -qm "seed untouched" >/dev/null 2>&1
printf 'pre-existing Codex work\n' >>"$d/$IMPL"
printf 'pre-existing Codex work\n' >>"$d/$UNTOUCHED"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task attrib-task --log-dir "$d/runs" \
      --carry-one --timeout 3 \
      --actor-cmd 'printf "the hop added this\n" >> "$WL_CHECKOUT/'"$IMPL"'"; sleep 30' 2>&1)"; RC=$?
expect_rc 21 "$RC" "the hop is stopped by the actor timeout" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "a FURTHER edit to an already-dirty file IS attributed to the hop" \
  || bad "a FURTHER edit to an already-dirty file IS attributed to the hop" "$(partial_section "$OUT")"
partial_section "$OUT" | grep -Fq "$UNTOUCHED" \
  && bad "pre-existing dirt the hop never opened is NOT attributed to it" "$(partial_section "$OUT")" \
  || ok "pre-existing dirt the hop never opened is NOT attributed to it"

echo
echo "Case 42 — the FALSE exit 25: an already-dirty state file Claude never touched"
# Incident 1's claim 2a. turn: claude with an uncommitted state file is the
# EXPECTED Codex handoff and is accepted at startup. If the hop then changes
# nothing, the old code read bare dirtiness as proof and reported "Claude edited
# logs/work-loop/<task>.md" about a file byte-identical before and after.
d="$(new_sandbox)"; state_file "$d" "falsedirty-task" "claude"
printf '\nuncommitted Codex handoff text\n' >> "$d/logs/work-loop/falsedirty-task.md"
BEFORE_SUM="$(shasum -a 256 "$d/logs/work-loop/falsedirty-task.md" | cut -d' ' -f1)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task falsedirty-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'exit 0' 2>&1)"; RC=$?
expect_rc 36 "$RC" "the no-op hop over a pre-dirty state file exits 36, not 25" "$OUT"
printf '%s' "$OUT" | grep -q "CLAUDE DID NOT TOUCH IT" \
  && ok "the stop says plainly that Claude did not touch the file" \
  || bad "the stop says plainly that Claude did not touch the file" "$OUT"
printf '%s' "$OUT" | grep -q "Claude edited logs/work-loop/falsedirty-task.md" \
  && bad "the stop no longer claims Claude edited the file" "$OUT" \
  || ok "the stop no longer claims Claude edited the file"
printf '%s' "$OUT" | grep -q "Addressed to the OPERATOR" \
  && ok "the stop names its addressee, so Codex cannot read it as its own instruction" \
  || bad "the stop names its addressee" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS — since launch" \
  && bad "an untouched pre-existing Codex handoff is not attributed to Claude" "$OUT" \
  || ok "an untouched pre-existing Codex handoff is not attributed to Claude"
AFTER_SUM="$(shasum -a 256 "$d/logs/work-loop/falsedirty-task.md" | cut -d' ' -f1)"
[ "$BEFORE_SUM" = "$AFTER_SUM" ] \
  && ok "control: the state file really is byte-identical across the hop" \
  || bad "control: the state file really is byte-identical across the hop" "$BEFORE_SUM -> $AFTER_SUM"

echo
echo "Case 42b — a REAL uncommitted Claude edit still exits 25"
# The control that keeps case 42 honest. If 36 swallowed this shape too, the
# split would have replaced one wrong classification with another.
d="$(new_sandbox)"; state_file "$d" "realedit-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task realedit-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"' 2>&1)"; RC=$?
expect_rc 25 "$RC" "an actual uncommitted Claude edit is still 25" "$OUT"
printf '%s' "$OUT" | grep -q "CLAUDE DID NOT TOUCH IT" \
  && bad "25 does not borrow 36's wording" "$OUT" \
  || ok "25 does not borrow 36's wording"

echo
echo "Case 42c — exit 36 reports other allowed work without claiming the hop did nothing"
d="$(new_sandbox)"; state_file "$d" "state-noop-work-task" "claude"
printf '\nuncommitted Codex handoff text\n' >> "$d/logs/work-loop/state-noop-work-task.md"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task state-noop-work-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'printf "other allowed work\n" >> "$WL_CHECKOUT/'"$IMPL"'"' 2>&1)"; RC=$?
expect_rc 36 "$RC" "an untouched pre-dirty state file still exits 36" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "exit 36 names other allowed work changed by the hop" \
  || bad "exit 36 names other allowed work changed by the hop" "$OUT"
printf '%s' "$OUT" | grep -q "hop therefore accomplished no observable transition" \
  && bad "exit 36 no longer claims the whole hop did nothing" "$OUT" \
  || ok "exit 36 no longer claims the whole hop did nothing"

echo
echo "Case 43 — O3: a permission denial becomes its own stop, naming tool and target"
# The capture body is modelled on the recorded live shape in
# runs/live-permission-denial-2026-08-05.md (run C): the child is refused
# `git add`/`git commit` through Bash, edits the state file, cannot commit it,
# and STILL EXITS 0. That last part is why this used to arrive as a bare 25 with
# no cause named — and why the operator on 2026-08-10 went looking outside the
# dispatcher for an answer it had in a file it never read.
d="$(new_sandbox)"; state_file "$d" "denial-task" "claude"
DENIAL_JSON='{"type":"result","subtype":"success","is_error":false,"permission_denials":[{"tool_name":"Bash","tool_use_id":"toolu_fixture01","tool_input":{"command":"git add logs/work-loop/denial-task.md && git commit -m wip"}},{"tool_name":"Edit","tool_use_id":"toolu_fixture02","tool_input":{"file_path":"/sandbox/logs/work-loop/denial-task.md"}}],"result":"I was denied permission to commit."}'
printf '%s' "$DENIAL_JSON" > "$SANDBOX_ROOT/denial.json"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task denial-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"; cat "'"$SANDBOX_ROOT"'/denial.json"' 2>&1)"; RC=$?
expect_rc 37 "$RC" "a hop whose capture reports denials exits 37, not 25" "$OUT"
printf '%s' "$OUT" | grep -q "DENIED PERMISSION" \
  && ok "the stop names permission denial as the cause" \
  || bad "the stop names permission denial as the cause" "$OUT"
printf '%s' "$OUT" | grep -Fq "git add logs/work-loop/denial-task.md" \
  && ok "the exact denied command is carried into the stop" \
  || bad "the exact denied command is carried into the stop" "$OUT"
printf '%s' "$OUT" | grep -q "Edit :: " \
  && ok "a second denial of a different tool is reported too" \
  || bad "a second denial of a different tool is reported too" "$OUT"
printf '%s' "$OUT" | grep -q "capability question" \
  && ok "the stop frames it as an operator capability decision, not a transport failure" \
  || bad "the stop frames it as an operator capability decision" "$OUT"

echo
echo "Case 43c — O3: a target LONGER THAN 200 CHARACTERS is carried whole"
# The exit table and the README both promise the EXACT denied target. The parser
# used to cut every target at 200 characters, so the promise held only for short
# ones — and a long `git commit -m …`, a deep path or a long URL is exactly the
# shape that got cut. A truncated command is not something the operator can act
# on, which puts them back at the unnamed dead end exit 37 exists to remove.
#
# 256 characters, built rather than typed so the boundary is unambiguous, and
# ENDING IN A SENTINEL rather than in more padding. A padded tail cannot detect
# truncation: the first 200 characters end in the same repeated character, so an
# assertion on the last N characters matches inside the truncated string and
# passes against the very dispatcher it is meant to catch. Measured, not
# theorised — the first cut of this case did exactly that.
LONGARG="$(printf 'a%.0s' $(seq 1 226))"
LONGTGT="git commit -m ${LONGARG}TAIL-SENTINEL-Z9"
d="$(new_sandbox)"; state_file "$d" "longdenial-task" "claude"
printf '{"type":"result","subtype":"success","is_error":false,"permission_denials":[{"tool_name":"Bash","tool_use_id":"toolu_long01","tool_input":{"command":"%s"}}],"result":"denied"}' \
  "$LONGTGT" > "$SANDBOX_ROOT/denial-long.json"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task longdenial-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"; cat "'"$SANDBOX_ROOT"'/denial-long.json"' 2>&1)"; RC=$?
expect_rc 37 "$RC" "the long denial still reaches a permission stop" "$OUT"
printf '%s' "$OUT" | grep -Fq "Bash :: $LONGTGT" \
  && ok "the >200-character target is carried WHOLE into the stop" \
  || bad "the >200-character target is carried whole" "$(printf '%s' "$OUT" | grep -o 'Bash :: .*' | head -1)"
# Named separately so a truncation regression reads as truncation rather than as
# a general parse failure. The sentinel sits at character 241, past the old
# .[0:200] cut, so it can only appear if nothing was cut.
printf '%s' "$OUT" | grep -Fq "TAIL-SENTINEL-Z9" \
  && ok "the tail past character 200 survives (nothing was cut)" \
  || bad "the tail past character 200 survives" "$OUT"

echo
echo "Case 43d — O3: the exact target survives when jq is UNUSABLE"
# The other half of the same promise. Without jq the parser used to emit
# "? :: (detail unavailable …)", carrying neither the tool nor the target, while
# the stop still described itself as satisfying O3.
#
# jq is shimmed rather than removed from PATH, because on this platform it lives
# in /usr/bin beside git, awk and sed — a PATH that excludes it excludes the
# dispatcher's own toolchain. The shim exits 127, the shell's own
# command-not-found status, so this covers BOTH an absent jq and a broken one.
# The broken case is the stronger of the two and the one a `command -v` guard
# cannot see on its own.
if command -v python3 >/dev/null 2>&1; then
  NOJQ="$SANDBOX_ROOT/nojq"; mkdir -p "$NOJQ"
  printf '#!/bin/bash\nexit 127\n' > "$NOJQ/jq"; chmod +x "$NOJQ/jq"
  d="$(new_sandbox)"; state_file "$d" "nojq-task" "claude"
  OUT="$(PATH="$NOJQ:$PATH" bash "$DISPATCH_BIN" --checkout "$d" --task nojq-task --log-dir "$d/runs" \
        --carry-one \
        --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"; cat "'"$SANDBOX_ROOT"'/denial-long.json"' 2>&1)"; RC=$?
  expect_rc 37 "$RC" "an unusable jq still reaches a permission stop" "$OUT"
  printf '%s' "$OUT" | grep -Fq "Bash :: $LONGTGT" \
    && ok "the exact >200-character target survives without jq" \
    || bad "the exact target survives without jq" "$(printf '%s' "$OUT" | grep -o '[?A-Za-z]* :: .*' | head -1)"
  # A "no placeholder appears" assertion was tried here and REMOVED. Against the
  # pre-fix dispatcher the shimmed jq produced no denials at all, so no stop
  # fired, so no placeholder appeared and the assertion passed — vacuously, on
  # the run it existed to catch. The exact-target assertion above already
  # excludes the placeholder, since the two are mutually exclusive outputs.
  #
  # The control: proves the shim actually took effect. Without it this case would
  # pass identically on a run that quietly used the real jq all along.
  printf '%s' "$OUT" | grep -q "denial_parser=python3" \
    && ok "control: the run really did fall through to the python3 parser" \
    || bad "control: the run fell through to the python3 parser" "$OUT"
else
  ok "SKIPPED — no python3 on this host, so the no-jq tier cannot be exercised"
fi

echo
echo "Case 43b — a clean capture produces NO permission stop"
# The control. Without it, case 43 would pass equally well against a dispatcher
# that exits 37 on every Claude hop.
d="$(new_sandbox)"; state_file "$d" "nodenial-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nodenial-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'printf "{\"type\":\"result\",\"permission_denials\":[],\"result\":\"fine\"}"; '"$FLIP" 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -q "DENIED PERMISSION" \
  && bad "an empty permission_denials array does not trigger a permission stop" "$OUT" \
  || ok "an empty permission_denials array does not trigger a permission stop"
[ "$RC" -ne 37 ] \
  && ok "the run does not exit 37 when nothing was denied (got $RC)" \
  || bad "the run does not exit 37 when nothing was denied" "$OUT"

echo
echo "Case 44 — O2: an OUT-OF-SCOPE edit reports the in-scope work alongside it"
# 24 already named the violation. It did not name what the hop had legitimately
# done, so the operator deciding whether to keep or discard was reading half the
# picture.
d="$(new_sandbox)"; state_file "$d" "scope-edit-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task scope-edit-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'printf "in-scope work\n" >> "$WL_CHECKOUT/'"$IMPL"'"; printf "out-of-scope\n" >> "$WL_CHECKOUT/other.txt"' 2>&1)"; RC=$?
expect_rc 24 "$RC" "an out-of-allowlist working-tree edit still stops the run" "$OUT"
printf '%s' "$OUT" | grep -Fq "other.txt" \
  && ok "the out-of-scope path is reported (unchanged behaviour)" \
  || bad "the out-of-scope path is reported" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && ok "the out-of-scope stop ALSO carries a partial-effects section" \
  || bad "the out-of-scope stop ALSO carries a partial-effects section" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "the in-scope work the hop did is named INSIDE that section" \
  || bad "the in-scope work the hop did is named INSIDE that section" "$OUT"

echo
echo "Case 45 — O2: an OUT-OF-SCOPE COMMIT reports uncommitted in-scope work too"
d="$(new_sandbox)"; state_file "$d" "scope-commit-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task scope-commit-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'printf "in-scope, left uncommitted\n" >> "$WL_CHECKOUT/'"$IMPL"'"; printf "out-of-scope\n" >> "$WL_CHECKOUT/other.txt"; git -C "$WL_CHECKOUT" add other.txt; git -C "$WL_CHECKOUT" commit -qm "actor commits out of scope"' 2>&1)"; RC=$?
expect_rc 30 "$RC" "an out-of-allowlist COMMIT still stops the run" "$OUT"
printf '%s' "$OUT" | grep -Fq "other.txt" \
  && ok "the committed out-of-scope path is reported (unchanged behaviour)" \
  || bad "the committed out-of-scope path is reported" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && ok "the out-of-scope-commit stop ALSO carries a partial-effects section" \
  || bad "the out-of-scope-commit stop ALSO carries a partial-effects section" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "the uncommitted in-scope work is named INSIDE that section" \
  || bad "the uncommitted in-scope work is named INSIDE that section" "$OUT"

echo
echo "Case 46 — a clean hop is NOT decorated with a partial-effects section"
# The other half of the O2 control. partial_effect_block() must be silent when
# the tree is clean, or every stop in this suite grows a confusing empty header.
d="$(new_sandbox)"; state_file "$d" "clean-hop-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task clean-hop-task --log-dir "$d/runs" \
      --carry-one --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 0 "$RC" "the well-behaved hop still completes" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && bad "a clean hop prints no partial-effects section" "$OUT" \
  || ok "a clean hop prints no partial-effects section"

echo
echo "Case 47 — malformed post-hop state still reports partial effects"
d="$(new_sandbox)"; state_file "$d" "malformed-after-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task malformed-after-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'printf "partial implementation\n" >> "$WL_CHECKOUT/'"$IMPL"'"; awk "/^turn: /&&!d{print \"turn: broken\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"' 2>&1)"; RC=$?
expect_rc 15 "$RC" "malformed post-hop state exits 15" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "post-hop validate_state failure reports the allowed implementation edit" \
  || bad "post-hop validate_state failure reports the allowed implementation edit" "$OUT"

# ============================================ Tracer 4 — legacy isolation
#
# These two cases are the ONLY thing standing behind "the dispatcher no longer
# touches legacy session state". They are written to fail against the PRE-Tracer-4
# dispatcher, which is what makes them evidence rather than description:
#
#   Case 48  pre-change, init_session_identity() ran prime-session-entry.sh and
#            appended a `- Files in scope:` bullet to logs/session-notes.md
#            before hop 1, so every one of its four assertions failed.
#   Case 49  pre-change, allowlisted_dirty() carried a hardcoded
#            `[ "$p" = "logs/session-notes.md" ] && continue`, so the path was
#            filtered out of partial-effect accounting and the assertion failed.
#
# Both were confirmed failing against the pre-change dispatcher before the change
# landed; see this task's record for the exact counts.

echo
echo "Case 48 — Tracer 4: a run in a checkout that CARRIES the legacy session infrastructure writes no legacy session state"
d="$(new_sandbox)"; state_file "$d" "legacy-isolation-task" "claude"
# The sandbox is deliberately the DANGEROUS shape: it carries an executable
# allocator, exactly like a real checkout. The pre-change dispatcher skipped its
# init only when the allocator was ABSENT, so a sandbox without one would have
# passed this case for the wrong reason and proved nothing.
ENTRY_CALLS="$d/entry-calls.txt"
cat >"$d/logs/scripts/prime-session-entry.sh" <<EOF
#!/bin/bash
# Stub allocator. Records that it was called AT ALL, then behaves like the real
# one so that a dispatcher which calls it succeeds rather than failing closed —
# a stub that errored would let this case pass on the allocator's failure
# instead of on the dispatcher's silence.
#
# It writes logs/.session-marker because the REAL allocator does
# (logs/scripts/prime-session-entry.sh, writer invariant at its line 194). A
# stub that skipped that write would make the ".session-marker was not created"
# assertion below pass against the pre-change dispatcher too — i.e. not evidence.
printf 'called\n' >>"$ENTRY_CALLS"
printf '%s 1\n' "\$(date '+%Y-%m-%d')" | tee logs/.session-marker
EOF
chmod +x "$d/logs/scripts/prime-session-entry.sh"
printf '# Session Notes\n\n## 2026-01-01 — Session 1\n**Work:** a stranger session.\n' >"$d/logs/session-notes.md"
git -C "$d" add logs/scripts/prime-session-entry.sh logs/session-notes.md >/dev/null 2>&1
git -C "$d" commit -qm "legacy session infrastructure" >/dev/null 2>&1
NOTES_BEFORE="$(cat "$d/logs/session-notes.md")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task legacy-isolation-task --log-dir "$d/runs" \
      --carry-one --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 0 "$RC" "48 — the hop completes" "$OUT"
[ ! -f "$ENTRY_CALLS" ] \
  && ok "48 — prime-session-entry.sh was never invoked" \
  || bad "48 — prime-session-entry.sh was never invoked" "called $(wc -l <"$ENTRY_CALLS" 2>/dev/null) time(s)"
[ "$(cat "$d/logs/session-notes.md")" = "$NOTES_BEFORE" ] \
  && ok "48 — logs/session-notes.md is byte-identical after the run" \
  || bad "48 — logs/session-notes.md is byte-identical after the run" "$(git -C "$d" diff -- logs/session-notes.md)"
[ ! -e "$d/logs/.session-marker" ] \
  && ok "48 — no logs/.session-marker was created" \
  || bad "48 — no logs/.session-marker was created" "$(cat "$d/logs/.session-marker")"
printf '%s' "$OUT" | grep -q 'identity:' \
  && bad "48 — the run log carries no session-identity line" "$(printf '%s' "$OUT" | grep 'identity:')" \
  || ok "48 — the run log carries no session-identity line"

echo
echo "Case 49 — Tracer 4: an uncommitted logs/session-notes.md inside the allowlist is REPORTED, not hidden"
# The complement of case 48. Once the dispatcher stops writing session-notes.md,
# any uncommitted edit to it is somebody else's work, and hiding it from
# partial-effect accounting would be the false statement O2 exists to remove.
# The path reaches the allowlist here only because this case passes it
# explicitly — which is the whole point: the operator asked for it to be in scope.
d="$(new_sandbox)"; state_file "$d" "notes-partial-task" "claude"
printf '# Session Notes\n' >"$d/logs/session-notes.md"
git -C "$d" add logs/session-notes.md >/dev/null 2>&1
git -C "$d" commit -qm "seed session notes" >/dev/null 2>&1
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task notes-partial-task --log-dir "$d/runs" \
      --carry-one \
      --allow-path '^logs/work-loop/' --allow-path '^logs/session-notes\.md$' \
      --actor-cmd 'printf "an uncommitted edit\n" >> "$WL_CHECKOUT/logs/session-notes.md"; awk "/^turn: /&&!d{print \"turn: broken\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"' 2>&1)"; RC=$?
expect_rc 15 "$RC" "49 — malformed post-hop state exits 15" "$OUT"
partial_section "$OUT" | grep -Fq "logs/session-notes.md" \
  && ok "49 — the uncommitted session-notes.md edit is reported as a partial effect" \
  || bad "49 — the uncommitted session-notes.md edit is reported as a partial effect" "$(partial_section "$OUT")"

# ==================================================================== case 50
#
# Change set A, items 3 and 4: the die() funnel finalizes exactly ONE versioned,
# run-bound, complete terminal result before it releases the lease.
#
# SCOPE OF THIS CASE, stated so a later reader does not over-read it. It covers
# the terminal families that already converge on die()/die_hop() — the nine
# post-admission nonzero families D–L. It deliberately does NOT cover the
# families that reach their exit by another route: usage/argument refusal and
# checkout/lease-infrastructure failure exit directly before a run id exists,
# lease refusal has its own producer (refuse_17), the signal handler exits on its
# own path, and the five zero-exit sites are not terminals this producer owns.
# Those are separate integrations and asserting them here would claim coverage
# the dispatcher does not yet have.
#
# There is no reader in this case either. Every assertion below reads the
# artifact with `sed`/`grep` from the harness, which is exactly the point: the
# record has to be consumable without a parser shipped alongside it.

# One field out of a result file. `head -1` because a duplicate singleton field is
# a defect the grammar assertion below catches separately — this helper must not
# quietly paper over it by concatenating.
# res_field(), run_id_of(), res_count() and part_count() MOVED UP to the
# fixtures block at the top of this file. Case 12h now reads a terminal
# result too, and a helper defined at line ~5400 does not exist yet at
# line ~1300 — the definitions have to precede their FIRST caller, not
# their most frequent one.

echo
echo "Case 50a — a post-hop nonzero terminal (22) finalizes exactly one complete run-bound result"
# Modelled on case 6 — the narrowest existing post-hop terminal in this suite. The
# actor ALSO plants two lookalike results: one at a name it invented, and one at
# the exact run-bound path it derived by globbing the run log. Both are the
# "actor-created lookalike" the trusted-field-ownership contract forbids from
# supplying the result framing.
NOOP_PLANT='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      for f in "$WL_CHECKOUT"/runs/*.log; do
        [ -e "$f" ] || continue
        printf "terminal_result_version=1\noutcome=SUCCESS\ncode=0\nactor_launched=no\nresult_complete=yes\n" > "${f%.log}.result";
      done;
      printf "terminal_result_version=1\noutcome=SUCCESS\ncode=0\nresult_complete=yes\n" > "$WL_CHECKOUT/runs/actor-planted.result";
      exit 0'
d="$(new_sandbox)"; state_file "$d" "result-post-task" "codex"
run_dispatch "$d" result-post-task --actor-cmd "$NOOP_PLANT"
expect_rc 22 "$RC" "50a — exits 22 on no observable transition" "$OUT"
RID="$(run_id_of "$OUT")"
[ -n "$RID" ] && ok "50a — the run announced a run id" \
              || bad "50a — the run announced a run id" "$OUT"
R50="$d/runs/$RID.result"
if [ -f "$R50" ]; then
  ok "50a — a terminal result exists at the run-bound path"
else
  bad "50a — a terminal result exists at the run-bound path" \
      "missing $R50; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
fi
# NO PARTIAL ARTIFACT SURVIVES. The producer writes to a temporary and renames, so
# a leftover .partial means the finalization did not complete atomically.
[ "$(part_count "$d/runs")" = "0" ] \
  && ok "50a — no unfinalized temporary artifact was left behind" \
  || bad "50a — no unfinalized temporary artifact was left behind" "$(ls "$d/runs"/*.result.partial 2>&1)"
# EXACTLY ONE finalization, not two. Counted as version lines inside the artifact:
# a producer that appended instead of replacing would carry two.
NV="$(grep -c '^terminal_result_version=' "$R50" 2>/dev/null || printf '0')"
[ "$NV" = "1" ] && ok "50a — the artifact carries exactly one version line" \
                || bad "50a — the artifact carries exactly one version line" "found $NV"
[ "$(head -1 "$R50" 2>/dev/null)" = "terminal_result_version=1" ] \
  && ok "50a — the first line is the recognized schema version" \
  || bad "50a — the first line is the recognized schema version" "$(head -1 "$R50" 2>/dev/null)"
# THE COMPLETENESS SENTINEL, last line. Together with the atomic rename this is
# what separates "a complete result" from "a result that was being written".
[ "$(tail -1 "$R50" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50a — the last line is the completeness sentinel" \
  || bad "50a — the last line is the completeness sentinel" "$(tail -1 "$R50" 2>/dev/null)"
# BOUNDED GRAMMAR. Every line is one key=value pair, so a value carrying a newline
# — a path, a git status line, an operator-supplied argument — cannot inject a
# field. The check is the complement: no line that fails the shape.
if [ -z "$(grep -vE '^[a-z][a-z0-9_]*=' "$R50" 2>/dev/null)" ]; then
  ok "50a — every line matches the bounded key=value grammar"
else
  bad "50a — every line matches the bounded key=value grammar" "$(grep -vnE '^[a-z][a-z0-9_]*=' "$R50" | head -3 | tr '\n' ';')"
fi
# THE TRUTHFUL REQUIRED FIELDS, checked against what the dispatcher observed
# rather than against what the actor claimed.
for pair in "outcome:NO_TRANSITION" "code:22" "task:result-post-task" \
            "stage:post-hop" "actor:codex" "actor_launched:yes" \
            "model_request_started:no" "mode:simulated" "hop:1" \
            "owner_check:proceed" "owner_declared:none" \
            "lease_task_at_finalization:held-by-this-run" \
            "lease_checkout_at_finalization:held-by-this-run"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50" "$k")"
  [ "$got" = "$want" ] && ok "50a — $k=$want" || bad "50a — $k=$want" "got: ${got:-<absent>}"
done
[ "$(res_field "$R50" run)" = "$RID" ] \
  && ok "50a — the result names its own run id" \
  || bad "50a — the result names its own run id" "got: $(res_field "$R50" run)"
[ "$(res_field "$R50" checkout)" = "$(cd "$d" && pwd -P)" ] \
  && ok "50a — the result names the canonical checkout" \
  || bad "50a — the result names the canonical checkout" "got: $(res_field "$R50" checkout)"
# Exit 22 is precisely "the bytes did not move", so before and after must be equal
# AND present. Equal-and-absent would satisfy a naive comparison, which is why the
# non-emptiness is asserted separately.
SB="$(res_field "$R50" state_sha256_before)"; SA="$(res_field "$R50" state_sha256_after)"
if [ -n "$SB" ] && [ "$SB" != "unavailable" ] && [ "$SB" = "$SA" ]; then
  ok "50a — state hashes are recorded and equal, matching the 22 it reported"
else
  bad "50a — state hashes are recorded and equal, matching the 22 it reported" "before=$SB after=$SA"
fi
HB="$(res_field "$R50" head_before)"
[ -n "$HB" ] && [ "$HB" = "$(git -C "$d" rev-parse HEAD)" ] \
  && ok "50a — head_before is the real commit, read from Git" \
  || bad "50a — head_before is the real commit, read from Git" "got: $HB"
[ -f "$(res_field "$R50" run_log)" ] \
  && ok "50a — the named run log exists on disk" \
  || bad "50a — the named run log exists on disk" "got: $(res_field "$R50" run_log)"
[ -n "$(res_field "$R50" next_action)" ] \
  && ok "50a — a next required action is recorded" \
  || bad "50a — a next required action is recorded"
# THE UNAVAILABLE FACTS ARE STATED, NOT OMITTED AND NOT GUESSED. These three are
# not established anywhere in this dispatcher today. Recording the requested
# permission mode while leaving the effective one unavailable is the distinction
# the plan draws between evidence and authorization.
for k in recorded_usage actor_session_id permission_mode_effective; do
  [ "$(res_field "$R50" "$k")" = "unavailable" ] \
    && ok "50a — $k is explicitly unavailable" \
    || bad "50a — $k is explicitly unavailable" "got: $(res_field "$R50" "$k")"
done
# THE ACTOR CANNOT SUPPLY THE FRAMING. It wrote SUCCESS/0 over the exact run-bound
# path before exiting; the dispatcher's finalization replaced it with what the
# dispatcher observed. Asserted on the field values, not on file count, because a
# lookalike that survived would still be exactly one file.
case "$(res_field "$R50" outcome):$(res_field "$R50" code)" in
  NO_TRANSITION:22) ok "50a — the actor's planted SUCCESS result did not become the trusted result" ;;
  *) bad "50a — the actor's planted SUCCESS result did not become the trusted result" \
         "got outcome=$(res_field "$R50" outcome) code=$(res_field "$R50" code)" ;;
esac
[ -f "$d/runs/actor-planted.result" ] \
  && ok "50a — the actor's invented lookalike is still on disk and is simply not run-bound" \
  || bad "50a — the actor's invented lookalike is still on disk and is simply not run-bound"

echo
echo "Case 50b — a PRE-HOP die() family (18) finalizes once, with the unavailable fields explicit"
# The control for the half of the funnel where no actor ran. Nothing observed
# after a launch exists here, and the producer must say so rather than abort under
# `set -u` or invent a post-hop fact. Exit 18 is chosen because it is a pre-hop
# die() reached AFTER the run id exists and BEFORE before_hash/before_head are
# assigned — the narrowest place where unset state is reachable.
d="$(new_sandbox)"; state_file "$d" "result-pre-task" "codex"
printf 'out of allowlist\n' >>"$d/other.txt"
run_dispatch "$d" result-pre-task --actor-cmd "$NOOP"
expect_rc 18 "$RC" "50b — exits 18 on pre-existing out-of-allowlist changes" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "50b — no actor was launched" || bad "50b — no actor was launched" "calls=$(calls "$d")"
RIDB="$(run_id_of "$OUT")"
R50B="$d/runs/$RIDB.result"
[ -f "$R50B" ] && ok "50b — a terminal result exists for the pre-hop stop" \
              || bad "50b — a terminal result exists for the pre-hop stop" "missing $R50B; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(res_count "$d/runs")" = "1" ] \
  && ok "50b — exactly one result was finalized" \
  || bad "50b — exactly one result was finalized" "found $(res_count "$d/runs")"
[ "$(part_count "$d/runs")" = "0" ] \
  && ok "50b — no unfinalized temporary artifact was left behind" \
  || bad "50b — no unfinalized temporary artifact was left behind" "$(ls "$d/runs"/*.result.partial 2>&1)"
[ "$(tail -1 "$R50B" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50b — the pre-hop result is complete" \
  || bad "50b — the pre-hop result is complete" "$(tail -1 "$R50B" 2>/dev/null)"
for pair in "outcome:FOREIGN_UNSTAGED" "code:18" "stage:pre-hop" "actor:none" \
            "actor_launched:no" "model_request_started:no" "hop:0"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50B" "$k")"
  [ "$got" = "$want" ] && ok "50b — $k=$want" || bad "50b — $k=$want" "got: ${got:-<absent>}"
done
# THE UNSET-STATE FIELDS. Each is a fact that only a launched hop establishes, and
# each must carry the explicit bounded token rather than an empty value, an
# omitted key, or a value carried over from somewhere else.
for k in state_sha256_before state_sha256_after head_after capture; do
  got="$(res_field "$R50B" "$k")"
  case "$got" in
    unavailable|none) ok "50b — $k is explicitly '$got', not omitted or guessed" ;;
    *) bad "50b — $k is explicitly unavailable/none" "got: ${got:-<absent>}" ;;
  esac
done
# The one fact this terminal DID establish, so the case cannot pass by marking
# everything unavailable. 18 fires precisely because a foreign path was seen.
[ "$(res_field "$R50B" worktree_foreign_paths)" = "1" ] \
  && ok "50b — the foreign path it stopped on is counted, not blanked" \
  || bad "50b — the foreign path it stopped on is counted, not blanked" "got: $(res_field "$R50B" worktree_foreign_paths)"
[ "$(res_field "$R50B" state_class)" = "ACTIVE_CODEX" ] \
  && ok "50b — the validator's classification is carried, not re-derived" \
  || bad "50b — the validator's classification is carried, not re-derived" "got: $(res_field "$R50B" state_class)"

echo
echo "Case 50c — mutation controls: the assertions above go red when the producer is broken"
# Three mutants of the real dispatcher, each breaking one property case 50a
# asserts. A green suite against a mutant means the assertion proves nothing.
MUT_DIR="$SANDBOX_ROOT/mutants"; mkdir -p "$MUT_DIR"

# M1 — finalization SKIPPED. Since Unit 11 this seam carries its own failure
# transfer, so the WHOLE action has to go — the publish and the unprovability exit
# it falls to. Cutting only the call would leave `|| die_funnel_unprovable "$code"`
# dangling, which changes the syntax rather than the behaviour under test. The line
# is matched whole and its occurrences counted, so a seam that moves, changes shape
# or appears twice stops the control rather than silently mutating something else
# or testing a script that was never changed.
M1_LINE='  finalize_terminal_result "$code" || die_funnel_unprovable "$code" # die funnel failure transfer'
M1_HITS="$(grep -Fxc -- "$M1_LINE" "$DISPATCH_BIN" 2>/dev/null)"
awk -v want="$M1_LINE" '$0 == want { print "  :"; next } { print }' "$DISPATCH_BIN" >"$MUT_DIR/m1.sh"
M1_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT_DIR/m1.sh" || M1_DIFFERS=yes
M1_PARSES=no; bash -n "$MUT_DIR/m1.sh" 2>/dev/null && M1_PARSES=yes
if [ "$M1_HITS" = "1" ] && [ "$M1_DIFFERS" = yes ] && [ "$M1_PARSES" = yes ]; then
  ok "50c — M1 mutant differs from the dispatcher and still parses (the one call site was found)"
  d="$(new_sandbox)"; state_file "$d" "m1-task" "codex"
  OUT="$(bash "$MUT_DIR/m1.sh" --checkout "$d" --task m1-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  [ "$RC" -eq 22 ] && [ "$(res_count "$d/runs")" = "0" ] \
    && ok "50c — M1: with finalization skipped, no result is produced (assertion is fail-capable)" \
    || bad "50c — M1: with finalization skipped, no result is produced" "rc=$RC results=$(res_count "$d/runs")"
else
  bad "50c — M1 mutant differs from the dispatcher and still parses (the one call site was found)" \
      "matched ${M1_HITS:-0} lines, want exactly 1; differs=$M1_DIFFERS parses=$M1_PARSES — the control cannot run"
fi

# M2 — the atomic publish removed, so the temporary is never renamed.
sed 's|^  mv -f "\$tmp" "\$final" .*$|  true|' "$DISPATCH_BIN" >"$MUT_DIR/m2.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m2.sh"; then
  ok "50c — M2 mutant differs from the dispatcher (the rename was found)"
  d="$(new_sandbox)"; state_file "$d" "m2-task" "codex"
  OUT="$(bash "$MUT_DIR/m2.sh" --checkout "$d" --task m2-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  if [ "$(res_count "$d/runs")" = "0" ] && [ "$(part_count "$d/runs")" = "1" ]; then
    ok "50c — M2: without the rename, a partial artifact is exposed and no final one exists"
  else
    bad "50c — M2: without the rename, a partial artifact is exposed and no final one exists" \
        "rc=$RC final=$(res_count "$d/runs") partial=$(part_count "$d/runs")"
  fi
else
  bad "50c — M2 mutant differs from the dispatcher (the rename was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M3 — the result path stops being run-bound, so two runs in one evidence
# directory finalize over each other and the second overwrites the first.
sed 's|^  local final="\$LOG_DIR/\$RUN_ID.result"$|  local final="$LOG_DIR/terminal.result"|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m3.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m3.sh"; then
  ok "50c — M3 mutant differs from the dispatcher (the run-bound path was found)"
  d="$(new_sandbox)"; state_file "$d" "m3-task" "codex"
  bash "$MUT_DIR/m3.sh" --checkout "$d" --task m3-task --log-dir "$d/runs" \
       --timeout 20 --actor-cmd "$NOOP" >/dev/null 2>&1
  bash "$MUT_DIR/m3.sh" --checkout "$d" --task m3-task --log-dir "$d/runs" \
       --timeout 20 --actor-cmd "$NOOP" >/dev/null 2>&1
  [ "$(res_count "$d/runs")" = "1" ] \
    && ok "50c — M3: two runs collapse onto one result (run-binding is what prevents it)" \
    || bad "50c — M3: two runs collapse onto one result" "found $(res_count "$d/runs")"
  # The unmutated control, same shape: two runs, two results.
  d="$(new_sandbox)"; state_file "$d" "m3-control-task" "codex"
  run_dispatch "$d" m3-control-task --actor-cmd "$NOOP"
  run_dispatch "$d" m3-control-task --actor-cmd "$NOOP"
  [ "$(res_count "$d/runs")" = "2" ] \
    && ok "50c — and the real dispatcher keeps both runs' results apart" \
    || bad "50c — and the real dispatcher keeps both runs' results apart" "found $(res_count "$d/runs")"
else
  bad "50c — M3 mutant differs from the dispatcher (the run-bound path was found)" \
      "the sed matched nothing — the control cannot run"
fi

echo
echo "Case 50d — a die() BEFORE any child is forked reports no launch and no model request"
# The correction control for the launch fields. launch_actor() dies four ways
# before run_bounded() forks anything — a non-executable codex binary, an
# unresolvable claude binary, a checkout it cannot enter, an unknown actor name —
# and every one of them is reached AFTER HOP_BASELINE_READY is raised. While that
# flag was the source of actor_launched, all four reported a launch, and in live
# mode a model request, that never happened.
#
# STILL NO LIVE PRODUCT TRANSPORT. The run is in live mode because no --actor-cmd
# is given, and it stops on a binary path that does not exist: nothing is
# executed, no model is contacted, and the case is controller evidence like every
# other one here.
d="$(new_sandbox)"; state_file "$d" "pre-fork-task" "codex"
run_dispatch "$d" pre-fork-task --codex-bin "$d/no-such-codex-binary"
expect_rc 20 "$RC" "50d — exits 20 when the actor binary is not executable" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "50d — no actor process ran" || bad "50d — no actor process ran" "calls=$(calls "$d")"
RIDD="$(run_id_of "$OUT")"
R50D="$d/runs/$RIDD.result"
[ -f "$R50D" ] && ok "50d — the pre-fork stop still finalizes one result" \
              || bad "50d — the pre-fork stop still finalizes one result" "missing $R50D; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(res_count "$d/runs")" = "1" ] \
  && ok "50d — exactly one result was finalized" \
  || bad "50d — exactly one result was finalized" "found $(res_count "$d/runs")"
[ "$(tail -1 "$R50D" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50d — the pre-fork result is complete" \
  || bad "50d — the pre-fork result is complete" "$(tail -1 "$R50D" 2>/dev/null)"
# THE LOAD-BEARING ASSERTIONS. `no` here is established-and-absent, not
# unavailable: nothing forked, so nothing could have requested a model. `launch`
# is the third stage value — the baseline was live and the fork never happened,
# which is neither pre-hop nor post-hop.
for pair in "outcome:ACTOR_FAILED" "code:20" "mode:live" "actor:codex" \
            "actor_launched:no" "model_request_started:no" "stage:launch" \
            "hop:1" "permission_mode_requested:none"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50D" "$k")"
  [ "$got" = "$want" ] && ok "50d — $k=$want" || bad "50d — $k=$want" "got: ${got:-<absent>}"
done

# The same stop on the CLAUDE path, which is the one that names a permission
# mode. A mode is only requested by an argv handed to a child, so a run that
# never forked one requested nothing — reporting the launch path's constant here
# would be the same false-launch claim wearing a different field name.
d="$(new_sandbox)"; state_file "$d" "pre-fork-claude-task" "claude"
run_dispatch "$d" pre-fork-claude-task --claude-bin "$d/no-such-claude-binary"
expect_rc 20 "$RC" "50d — exits 20 when the claude binary is not resolvable" "$OUT"
RIDD2="$(run_id_of "$OUT")"
R50D2="$d/runs/$RIDD2.result"
for pair in "actor:claude" "actor_launched:no" "stage:launch" \
            "permission_mode_requested:none" "permission_mode_effective:unavailable"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50D2" "$k")"
  [ "$got" = "$want" ] && ok "50d — claude path: $k=$want" || bad "50d — claude path: $k=$want" "got: ${got:-<absent>}"
done

echo
echo "Case 50e — owner and lease status are OBSERVED, and an ownership refusal says so"
# The correction control for finding 2. Case 50a already pins the clean values
# (owner_check=proceed, owner_declared=none, both leases held-by-this-run); this
# case is the other observation, so neither field can be a constant that happens
# to look right. A checkout that declares a DIFFERENT open task is refused at
# admission (33), which is inside the covered funnel, so the record exists and
# has to carry what the check actually returned.
d="$(new_sandbox)"; state_file "$d" "owner-refused-task" "codex"
printf 'decoy-alpha\n' >"$d/logs/work-loop/.owner"
run_dispatch "$d" owner-refused-task --actor-cmd "$NOOP"
expect_rc 33 "$RC" "50e — exits 33 when the checkout declares another task" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "50e — nothing was launched" || bad "50e — nothing was launched" "calls=$(calls "$d")"
RIDE="$(run_id_of "$OUT")"
R50E="$d/runs/$RIDE.result"
[ -f "$R50E" ] && ok "50e — the ownership refusal finalizes a result" \
              || bad "50e — the ownership refusal finalizes a result" "missing $R50E; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
for pair in "outcome:OWNERSHIP_REFUSED" "code:33" \
            "owner_check:refused" "owner_declared:decoy-alpha" \
            "actor_launched:no" "stage:pre-hop"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50E" "$k")"
  [ "$got" = "$want" ] && ok "50e — $k=$want" || bad "50e — $k=$want" "got: ${got:-<absent>}"
done
# The lease is taken before admission runs, so a refusal is finalized holding
# both — read from the lease directories, not asserted from that ordering.
for k in lease_task_at_finalization lease_checkout_at_finalization; do
  [ "$(res_field "$R50E" "$k")" = "held-by-this-run" ] \
    && ok "50e — $k=held-by-this-run" \
    || bad "50e — $k=held-by-this-run" "got: $(res_field "$R50E" "$k")"
done
# The recorded pid is what separates "held by this run" from "held": the value is
# only reachable by reading the holder file the library wrote.
LTD="$(res_field "$R50E" lease_task_dir)"
[ -n "$LTD" ] && [ ! -d "$LTD" ] \
  && ok "50e — and the lease it reported holding was released on the way out" \
  || bad "50e — and the lease it reported holding was released on the way out" "still present: $LTD"
# COMPLETING THE CODE-33 RESULT PROOF. Everything above asserts what the record
# SAYS; these assert that there is exactly one record and that it is whole. The
# approved plan asks for both — "Atomically finalize exactly one terminal result
# for … invalid state or ownership" — and "a result exists" is the weakest of those
# claims: an appending or double-publishing producer satisfies it. Counted the three
# ways 67a counts them for code 34, so the two ownership siblings prove the same
# thing about their own terminals.
[ "$(res_count "$d/runs")" = "1" ] \
  && ok "50e — exactly one finalized result" \
  || bad "50e — exactly one finalized result" "found $(res_count "$d/runs"): $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(part_count "$d/runs")" = "0" ] \
  && ok "50e — no unfinalized temporary artifact was left behind" \
  || bad "50e — no unfinalized temporary artifact was left behind" "$(ls "$d/runs"/*.result.partial 2>&1)"
NV50E="$(grep -c '^terminal_result_version=' "$R50E" 2>/dev/null || printf '0')"
[ "$NV50E" = "1" ] && ok "50e — the artifact carries exactly one version line" \
                   || bad "50e — the artifact carries exactly one version line" "found $NV50E"
[ "$(tail -1 "$R50E" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50e — the last line is the completeness sentinel" \
  || bad "50e — the last line is the completeness sentinel" "$(tail -1 "$R50E" 2>/dev/null)"
# The two fields the refusal's own semantics turn on that this case did not pin.
# `model_request_started=no` is the one a supervised-use claim rests on — an
# ownership refusal must not have reached the model — and it is a separate fact from
# `actor_launched`, which 50e already had. `next_action` is the bounded token, shared
# with codes 34 and 35 (`result_next_action()` maps 33|34|35 to one instruction).
for pair in "model_request_started:no" "next_action:operator-resolve-ownership"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50E" "$k")"
  [ "$got" = "$want" ] && ok "50e — $k=$want" || bad "50e — $k=$want" "got: ${got:-<absent>}"
done
# BOTH leases, not one. The record above says both were held at finalization; the
# assertion above this only proved the TASK lease was released afterwards, so the
# checkout lease could have survived and nothing here would have noticed.
LCD="$(res_field "$R50E" lease_checkout_dir)"
[ -n "$LCD" ] && [ ! -d "$LCD" ] \
  && ok "50e — and the CHECKOUT lease it reported holding was released too" \
  || bad "50e — and the CHECKOUT lease it reported holding was released too" \
         "reported: ${LCD:-<absent>} ($([ -d "$LCD" ] && echo present || echo gone))"

echo
echo "Case 50f — mutation controls for the corrected launch and lease observations"
# M4 and M5 are to case 50d and 50e what M1–M3 were to 50a: without them, an
# assertion that the fields are OBSERVED proves nothing, because a constant of
# the right shape would satisfy it.

# M4 — the launch fields go back to being derived from the intent flag, which is
# the defect this correction removed. The 50d scenario must then claim a launch.
sed 's|^  if \[ "\$ACTOR_PROCESS_STARTED" -eq 1 \]; then$|  if [ "${HOP_BASELINE_READY:-0}" -eq 1 ]; then|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m4.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m4.sh"; then
  ok "50f — M4 mutant differs from the dispatcher (the observed-fork branch was found)"
  d="$(new_sandbox)"; state_file "$d" "m4-task" "codex"
  OUT="$(bash "$MUT_DIR/m4.sh" --checkout "$d" --task m4-task --log-dir "$d/runs" \
        --timeout 20 --codex-bin "$d/no-such-codex-binary" 2>&1)"; RC=$?
  RIDM4="$(run_id_of "$OUT")"
  [ "$(res_field "$d/runs/$RIDM4.result" actor_launched)" = "yes" ] \
    && ok "50f — M4: with the intent flag restored, a pre-fork stop claims a launch (50d is fail-capable)" \
    || bad "50f — M4: with the intent flag restored, a pre-fork stop claims a launch" \
           "rc=$RC actor_launched=$(res_field "$d/runs/$RIDM4.result" actor_launched)"
else
  bad "50f — M4 mutant differs from the dispatcher (the observed-fork branch was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M5 — the reported task lease points somewhere the lease is not. A status READ
# from the filesystem changes; a hard-coded one cannot. Only the reporting path
# is redirected: the library acquires and releases through its own variables.
sed 's|^LOCK_DIR="\$WL_LEASE_TASK_DIR"$|LOCK_DIR="$WL_LEASE_TASK_DIR.absent"|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m5.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m5.sh"; then
  ok "50f — M5 mutant differs from the dispatcher (the reported lease path was found)"
  d="$(new_sandbox)"; state_file "$d" "m5-task" "codex"
  OUT="$(bash "$MUT_DIR/m5.sh" --checkout "$d" --task m5-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  RIDM5="$(run_id_of "$OUT")"
  [ "$(res_field "$d/runs/$RIDM5.result" lease_task_at_finalization)" = "missing" ] \
    && ok "50f — M5: with the lease directory absent, the status tracks the filesystem" \
    || bad "50f — M5: with the lease directory absent, the status tracks the filesystem" \
           "rc=$RC lease_task_at_finalization=$(res_field "$d/runs/$RIDM5.result" lease_task_at_finalization)"

  # M6 — the same absent lease, plus the observation replaced by the constant the
  # field used to be. It reports a held lease that is not there, which is exactly
  # what M5 catches and what a hard-coded field would have gone on doing.
  sed 's|^  lease_task="\$(result_lease_status .*$|  lease_task=held-by-this-run|' \
      "$MUT_DIR/m5.sh" >"$MUT_DIR/m6.sh"
  if ! cmp -s "$MUT_DIR/m5.sh" "$MUT_DIR/m6.sh"; then
    ok "50f — M6 mutant differs from M5 (the lease observation was found)"
    d="$(new_sandbox)"; state_file "$d" "m6-task" "codex"
    OUT="$(bash "$MUT_DIR/m6.sh" --checkout "$d" --task m6-task --log-dir "$d/runs" \
          --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
    RIDM6="$(run_id_of "$OUT")"
    [ "$(res_field "$d/runs/$RIDM6.result" lease_task_at_finalization)" = "held-by-this-run" ] \
      && ok "50f — M6: hard-coded, it claims a lease that is not on disk (M5's assertion is fail-capable)" \
      || bad "50f — M6: hard-coded, it claims a lease that is not on disk" \
             "rc=$RC lease_task_at_finalization=$(res_field "$d/runs/$RIDM6.result" lease_task_at_finalization)"
  else
    bad "50f — M6 mutant differs from M5 (the lease observation was found)" \
        "the sed matched nothing — the control cannot run"
  fi
else
  bad "50f — M5 mutant differs from the dispatcher (the reported lease path was found)" \
      "the sed matched nothing — the control cannot run"
fi

echo
echo "Case 50g — a lease whose HOLDER cannot be established is not reported as another holder"
# The residual half of the observed-lease contract. wl_lease__read_holder() `cat`s
# the holder files and returns empty for any it cannot read, so an absent or
# unreadable pid record reaches the classifier looking exactly like a pid that is
# not ours. Falling through to `held-by-other` would assert a second holder that
# nothing observed — the same class of unobserved claim as the `held` constant
# this whole field replaced, one branch further in.
#
# The condition is staged the way M5 stages its own: only the REPORTED task-lease
# path is redirected, at a directory this case creates with no holder metadata in
# it. Acquisition and release still run through the library's own variables, so
# the run is otherwise an ordinary one.
sed 's|^LOCK_DIR="\$WL_LEASE_TASK_DIR"$|LOCK_DIR="$WL_LEASE_TASK_DIR.holderless"|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m7.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m7.sh"; then
  ok "50g — M7 mutant differs from the dispatcher (the reported lease path was found)"
  d="$(new_sandbox)"; state_file "$d" "m7-task" "codex"
  # An existing lease directory with NO pid file — the observable shape of holder
  # metadata that cannot be established. `-p` because the lease root is created by
  # the library on acquire and does not exist yet.
  HOLDERLESS="$(task_lock_for "$d" m7-task).holderless"
  mkdir -p "$HOLDERLESS"
  [ -d "$HOLDERLESS" ] && [ ! -e "$HOLDERLESS/pid" ] \
    && ok "50g — the staged lease directory exists and carries no holder record" \
    || bad "50g — the staged lease directory exists and carries no holder record" "$HOLDERLESS"
  OUT="$(bash "$MUT_DIR/m7.sh" --checkout "$d" --task m7-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  RIDM7="$(run_id_of "$OUT")"
  G7="$(res_field "$d/runs/$RIDM7.result" lease_task_at_finalization)"
  [ "$G7" = "held-holder-unavailable" ] \
    && ok "50g — an unreadable holder is reported as explicitly unavailable" \
    || bad "50g — an unreadable holder is reported as explicitly unavailable" "rc=$RC got: ${G7:-<absent>}"
  # Stated as its own assertion rather than left implied by the one above: the two
  # values this must never take are the two that would each assert a fact — that
  # someone else holds it, or that this run does.
  case "$G7" in
    held-by-other|held-by-this-run)
      bad "50g — it is neither 'held-by-other' nor 'held-by-this-run'" "got: $G7" ;;
    *)
      ok "50g — it is neither 'held-by-other' nor 'held-by-this-run'" ;;
  esac

  # M8 — the same staged directory with the unavailable branch removed, which is
  # the classification as it stood before this fix. It reports another holder for
  # a lease whose holder was never read, so 50g's assertions are fail-capable.
  sed "s|^  if \[ -z \"\$pid\" \]; then printf 'held-holder-unavailable'; return 0; fi\$|  :|" \
      "$MUT_DIR/m7.sh" >"$MUT_DIR/m8.sh"
  if ! cmp -s "$MUT_DIR/m7.sh" "$MUT_DIR/m8.sh"; then
    ok "50g — M8 mutant differs from M7 (the unavailable branch was found)"
    d="$(new_sandbox)"; state_file "$d" "m8-task" "codex"
    HOLDERLESS8="$(task_lock_for "$d" m8-task).holderless"
    mkdir -p "$HOLDERLESS8"
    OUT="$(bash "$MUT_DIR/m8.sh" --checkout "$d" --task m8-task --log-dir "$d/runs" \
          --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
    RIDM8="$(run_id_of "$OUT")"
    [ "$(res_field "$d/runs/$RIDM8.result" lease_task_at_finalization)" = "held-by-other" ] \
      && ok "50g — M8: without the branch it claims another holder it never read (50g is fail-capable)" \
      || bad "50g — M8: without the branch it claims another holder it never read" \
             "rc=$RC got: $(res_field "$d/runs/$RIDM8.result" lease_task_at_finalization)"
  else
    bad "50g — M8 mutant differs from M7 (the unavailable branch was found)" \
        "the sed matched nothing — the control cannot run"
  fi
else
  bad "50g — M7 mutant differs from the dispatcher (the reported lease path was found)" \
      "the sed matched nothing — the control cannot run"
fi

echo
echo "Case 50h — the EARLIEST finalizing terminal reports worktree facts it actually collected"
# Unit 21, and it is the terminal this suite could not previously see. The
# --unattended version gate exits 31 from six places, and until this unit every
# one of them finalized BEFORE foreign_worktree() and allowlisted_dirty() were
# defined: bash printed `command not found` twice, the command substitutions came
# back empty, and count_lines() turned each into `0`.
#
# `0` IS WHY THIS NEEDED A CASE AND NOT A GLANCE. An absent field is a question an
# operator asks; `0` is an answer they act on — "the working tree held nothing
# foreign and nothing uncommitted" — produced by a check that never ran. Case 50b
# already pins these two fields at a LATER pre-hop terminal, where the helpers do
# exist, so the defect lived precisely in the gap no case reached.
#
# THE FIXTURE MAKES `0` FALSIFIABLE, which is the whole point: it dirties one
# TRACKED file on each side of the allowlist, so the truthful answers are 1 and 1
# and the pre-repair value is provably wrong rather than coincidentally right. A
# clean-tree fixture would have reported 0 and passed against the broken build.
# Tracked, not new, because `git status --porcelain` collapses an untracked
# directory to a single `?? plans/` line and the expected count would then depend
# on which directories the sandbox happens to have materialised.
#
# NO MODEL AND NO ACTOR. The gate refuses on the version the fake binary reports,
# before any launch — the same route case 32f already drives.
V50H="$(new_sandbox)"; state_file "$V50H" "gate-facts-task" "claude"
FK50H="$SANDBOX_ROOT/fake-claude-50h.sh"
cat >"$FK50H" <<'FK50HEOF'
#!/bin/bash
if [ "${1:-}" = "--version" ]; then echo "2.1.218 (Claude Code)"; exit 0; fi
printf '%s\n' "$@" > "$WL50H_ARGV"
exit 0
FK50HEOF
chmod +x "$FK50H"
export WL50H_ARGV="$SANDBOX_ROOT/argv-50h.txt"; rm -f "$WL50H_ARGV"
printf 'edited by the fixture\n' >>"$V50H/other.txt"
printf '\nfixture edit\n' >>"$V50H/logs/work-loop/gate-facts-task.md"
# Ground truth, read from git rather than assumed, so the expectations below are
# anchored to the repository and not to this comment.
G50H_FOREIGN="$(git -C "$V50H" status --porcelain 2>/dev/null | grep -c 'other\.txt' || true)"
G50H_ALLOWED="$(git -C "$V50H" status --porcelain 2>/dev/null | grep -c 'logs/work-loop/' || true)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$V50H" --task gate-facts-task --log-dir "$V50H/runs" \
      --carry-one --claude-bin "$FK50H" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "50h — the version gate still refuses with its accepted code" "$OUT"
[ -f "$WL50H_ARGV" ] \
  && bad "50h — nothing was launched" "the child ran: $(tr '\n' ' ' <"$WL50H_ARGV")" \
  || ok "50h — nothing was launched"
# THE DIAGNOSTIC ITSELF IS AN ASSERTION. A repair that produced the right numbers
# while still calling undefined functions would be papering over the cause.
printf '%s\n' "$OUT" | grep -q 'command not found' \
  && bad "50h — finalization emits no undefined-function diagnostic" \
         "$(printf '%s\n' "$OUT" | grep 'command not found' | tr '\n' ' ')" \
  || ok "50h — finalization emits no undefined-function diagnostic"
R50H="$V50H/runs/$(run_id_of "$OUT").result"
if [ "$(res_count "$V50H/runs")" = "1" ] && [ "$(part_count "$V50H/runs")" = "0" ] &&
   [ "$(tail -1 "$R50H" 2>/dev/null)" = "result_complete=yes" ]; then
  ok "50h — exactly one complete result, no partial"
else
  bad "50h — exactly one complete result, no partial" \
      "results=$(res_count "$V50H/runs") partials=$(part_count "$V50H/runs") last=$(tail -1 "$R50H" 2>/dev/null)"
fi
# THE TWO FIELDS UNDER REPAIR, compared against git rather than against a literal.
if [ "$(res_field "$R50H" worktree_foreign_paths)" = "$G50H_FOREIGN" ] &&
   [ "$(res_field "$R50H" worktree_allowlisted_dirty_paths)" = "$G50H_ALLOWED" ] &&
   [ "$G50H_FOREIGN" != "0" ] && [ "$G50H_ALLOWED" != "0" ]; then
  ok "50h — both worktree facts match the dirty tree git reports ($G50H_FOREIGN foreign, $G50H_ALLOWED allowed)"
else
  bad "50h — both worktree facts match the dirty tree git reports" \
      "git says foreign=$G50H_FOREIGN allowed=$G50H_ALLOWED; the record says foreign=$(res_field "$R50H" worktree_foreign_paths) allowed=$(res_field "$R50H" worktree_allowlisted_dirty_paths)"
fi
# THE REFUSAL IS UNCHANGED. The repair is evidence hygiene, so every other value
# this terminal already carried has to be exactly what it was — including that no
# model request and no launch happened, which is what keeps this a supervised-use
# terminal rather than a Gate U claim.
for pair in "outcome:UNATTENDED_UNAVAILABLE" "code:31" "stage:pre-hop" \
            "actor_launched:no" "model_request_started:no" \
            "next_action:operator-restore-contained-profile-prerequisites"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50H" "$k")"
  [ "$got" = "$want" ] && ok "50h — $k=$want" || bad "50h — $k=$want" "got: ${got:-<absent>}"
done
unset WL50H_ARGV

# =================================================================== case 50i
#
# THE SAME EARLIEST TERMINAL, WITH A CLOCK (Unit 24). Case 50h proved this
# terminal collects the worktree facts it reports. It runs without --deadline, so
# `deadline_remaining_seconds` is the honest literal `none` and the row cannot see
# the defect this case exists for: with a deadline supplied, the finalizer at
# dispatch.sh:796 asks remaining_seconds() for the fact, and the sole definition
# of that function used to sit BELOW the die 31 that reaches finalization. Bash
# reported `command not found`, the command substitution produced an empty string,
# and the record went out carrying `deadline_remaining_seconds=` beside
# `result_complete=yes`.
#
# THE SYMPTOM IS AN EMPTY REQUIRED FIELD, not a wrong number, which is why the
# assertions below check GRAMMAR AND BOUNDS rather than a second count. An empty
# value and a truthful one are distinguishable without being timing-sensitive:
# the deadline is 600s and the run takes a few, so the only requirement is a
# non-negative integer no greater than the deadline. The lower bound of 1 is what
# separates a real reading from the two failure modes that would otherwise slip
# through — an empty string, and a `0` that would claim the budget was already
# spent. The upper bound rules out the no-deadline sentinel (2147483647).
echo
echo "Case 50i — the earliest finalizing terminal reports a TRUTHFUL remaining deadline, not an empty field"
V50I="$(new_sandbox)"; state_file "$V50I" "gate-clock-task" "claude"
FK50I="$SANDBOX_ROOT/fake-claude-50i.sh"
cat >"$FK50I" <<'FK50IEOF'
#!/bin/bash
if [ "${1:-}" = "--version" ]; then echo "2.1.218 (Claude Code)"; exit 0; fi
printf '%s\n' "$@" > "$WL50I_ARGV"
exit 0
FK50IEOF
chmod +x "$FK50I"
export WL50I_ARGV="$SANDBOX_ROOT/argv-50i.txt"; rm -f "$WL50I_ARGV"
# The same dirty tree 50h uses, so the worktree facts this unit must NOT disturb
# are asserted against git here too rather than assumed from that case.
printf 'edited by the fixture\n' >>"$V50I/other.txt"
printf '\nfixture edit\n' >>"$V50I/logs/work-loop/gate-clock-task.md"
G50I_FOREIGN="$(git -C "$V50I" status --porcelain 2>/dev/null | grep -c 'other\.txt' || true)"
G50I_ALLOWED="$(git -C "$V50I" status --porcelain 2>/dev/null | grep -c 'logs/work-loop/' || true)"
D50I=600
OUT="$(bash "$DISPATCH_BIN" --checkout "$V50I" --task gate-clock-task --log-dir "$V50I/runs" \
      --carry-one --claude-bin "$FK50I" --unattended --deadline "$D50I" 2>&1)"; RC=$?
expect_rc 31 "$RC" "50i — the version gate still refuses with its accepted code" "$OUT"
[ -f "$WL50I_ARGV" ] \
  && bad "50i — nothing was launched" "the child ran: $(tr '\n' ' ' <"$WL50I_ARGV")" \
  || ok "50i — nothing was launched"
# THE DIAGNOSTIC IS AN ASSERTION, exactly as in 50h: a repair that produced a
# number while still calling an undefined function would be papering over the cause.
printf '%s\n' "$OUT" | grep -q 'command not found' \
  && bad "50i — finalization emits no undefined-function diagnostic" \
         "$(printf '%s\n' "$OUT" | grep 'command not found' | tr '\n' ' ')" \
  || ok "50i — finalization emits no undefined-function diagnostic"
R50I="$V50I/runs/$(run_id_of "$OUT").result"
if [ "$(res_count "$V50I/runs")" = "1" ] && [ "$(part_count "$V50I/runs")" = "0" ] &&
   [ "$(tail -1 "$R50I" 2>/dev/null)" = "result_complete=yes" ]; then
  ok "50i — exactly one complete result, no partial"
else
  bad "50i — exactly one complete result, no partial" \
      "results=$(res_count "$V50I/runs") partials=$(part_count "$V50I/runs") last=$(tail -1 "$R50I" 2>/dev/null)"
fi
# THE SUPPLIED DEADLINE, which must be carried through unchanged.
[ "$(res_field "$R50I" deadline_seconds)" = "$D50I" ] \
  && ok "50i — deadline_seconds carries the supplied $D50I" \
  || bad "50i — deadline_seconds carries the supplied $D50I" "got: $(res_field "$R50I" deadline_seconds)"
# THE FIELD UNDER REPAIR. Grammar first, then bounds — an empty value fails the
# grammar check, which is the red this unit turns.
REM50I="$(res_field "$R50I" deadline_remaining_seconds)"
case "${REM50I:-}" in
  ''|*[!0-9]*)
    bad "50i — deadline_remaining_seconds is a bounded non-negative integer" \
        "got: '${REM50I:-<empty>}' — not an integer; the fact producer was unavailable at this terminal" ;;
  *)
    if [ "$REM50I" -ge 1 ] && [ "$REM50I" -le "$D50I" ]; then
      ok "50i — deadline_remaining_seconds is a bounded truthful integer ($REM50I of $D50I)"
    else
      bad "50i — deadline_remaining_seconds is a bounded truthful integer" \
          "got: $REM50I, want 1..$D50I — outside the supplied budget"
    fi ;;
esac
# UNIT 21'S FACTS ARE UNDISTURBED, checked against git rather than against 50h.
if [ "$(res_field "$R50I" worktree_foreign_paths)" = "$G50I_FOREIGN" ] &&
   [ "$(res_field "$R50I" worktree_allowlisted_dirty_paths)" = "$G50I_ALLOWED" ] &&
   [ "$G50I_FOREIGN" != "0" ] && [ "$G50I_ALLOWED" != "0" ]; then
  ok "50i — the Unit 21 worktree facts still match git ($G50I_FOREIGN foreign, $G50I_ALLOWED allowed)"
else
  bad "50i — the Unit 21 worktree facts still match git" \
      "git says foreign=$G50I_FOREIGN allowed=$G50I_ALLOWED; the record says foreign=$(res_field "$R50I" worktree_foreign_paths) allowed=$(res_field "$R50I" worktree_allowlisted_dirty_paths)"
fi
# THE REFUSAL IS UNCHANGED. This unit changes fact availability, not policy.
for pair in "outcome:UNATTENDED_UNAVAILABLE" "code:31" "stage:pre-hop" \
            "actor_launched:no" "model_request_started:no" \
            "next_action:operator-restore-contained-profile-prerequisites"; do
  k50i="${pair%%:*}"; w50i="${pair#*:}"
  g50i="$(res_field "$R50I" "$k50i")"
  [ "$g50i" = "$w50i" ] && ok "50i — $k50i=$w50i" || bad "50i — $k50i=$w50i" "got: ${g50i:-<absent>}"
done
unset WL50I_ARGV

# =================================================================== case 50j
#
# M30 — THE RELOCATION IS WHAT MATTERS, not the function. This control does not
# delete remaining_seconds(): it moves the definition back BELOW the terminal that
# needs it, which is exactly the pre-repair topology. The mutant therefore still
# holds one syntactically valid definition and still parses, and every later
# caller inside the hop loop would still resolve — only the early terminal loses
# the fact, which is the precise claim under test.
#
# Fails closed on all four ways the selector could be wrong: no definition found,
# more than one, a mutant that does not differ, or one that does not parse.
echo
echo "Case 50j — M30: with the clock fact defined below the terminal again, 50i's field goes empty and the refusal still finalizes"
M30_SRC="$SANDBOX_ROOT/dispatch-M30.sh"
M30_DEFS="$(grep -c '^remaining_seconds() {$' "$DISPATCH_BIN" 2>/dev/null | head -1)"
if [ "$M30_DEFS" = "1" ]; then
  # Cut the definition block (its opening line to the next column-0 brace) and
  # re-append it verbatim at end of file — below every top-level statement.
  awk '
    /^remaining_seconds\(\) \{$/ { infn=1; blk=$0 ORS; next }
    infn==1 { blk=blk $0 ORS; if ($0 ~ /^\}/) infn=0; next }
    { print }
    END { printf "%s", blk }
  ' "$DISPATCH_BIN" >"$M30_SRC"
  M30_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$M30_SRC" || M30_DIFFERS=yes
  M30_PARSES=no; bash -n "$M30_SRC" 2>/dev/null && M30_PARSES=yes
  M30_STILL="$(grep -c '^remaining_seconds() {$' "$M30_SRC" 2>/dev/null | head -1)"
else
  M30_DIFFERS=no; M30_PARSES=no; M30_STILL=0
fi
if [ "$M30_DEFS" = "1" ] && [ "$M30_DIFFERS" = yes ] && [ "$M30_PARSES" = yes ] && [ "$M30_STILL" = "1" ]; then
  ok "50j — M30 found exactly one definition, moved it, still parses, and still has exactly one"
  V50J="$(new_sandbox)"; state_file "$V50J" "gate-clock-mutant" "claude"
  FK50J="$SANDBOX_ROOT/fake-claude-50j.sh"
  cp "$FK50I" "$FK50J" 2>/dev/null || true
  export WL50I_ARGV="$SANDBOX_ROOT/argv-50j.txt"; rm -f "$WL50I_ARGV"
  OUTM30="$(bash "$M30_SRC" --checkout "$V50J" --task gate-clock-mutant --log-dir "$V50J/runs" \
        --carry-one --claude-bin "$FK50J" --unattended --deadline 600 2>&1)"; RCM30=$?
  expect_rc 31 "$RCM30" "50j — the mutant still refuses with code 31, so the fixture is not merely broken" "$OUTM30"
  RM30="$V50J/runs/$(run_id_of "$OUTM30").result"
  [ "$(tail -1 "$RM30" 2>/dev/null)" = "result_complete=yes" ] \
    && ok "50j — the mutant still finalizes a complete result" \
    || bad "50j — the mutant still finalizes a complete result" "last: $(tail -1 "$RM30" 2>/dev/null)"
  REMM30="$(res_field "$RM30" deadline_remaining_seconds)"
  case "${REMM30:-}" in
    ''|*[!0-9]*) ok "50j — with the definition moved back down, the field is NOT a truthful integer ('${REMM30:-<empty>}')" ;;
    *)           bad "50j — with the definition moved back down, the field is NOT a truthful integer" \
                     "got: $REMM30 — the control cannot distinguish the relocation" ;;
  esac
  printf '%s\n' "$OUTM30" | grep -q 'remaining_seconds: command not found' \
    && ok "50j — and the mutant names the undefined fact producer, which is the cause 50i removes" \
    || bad "50j — and the mutant names the undefined fact producer" "$(printf '%s\n' "$OUTM30" | grep 'command not found' | tr '\n' ' ')"
  unset WL50I_ARGV
else
  bad "50j — M30 found exactly one definition, moved it, still parses, and still has exactly one" \
      "definitions=$M30_DEFS after=$M30_STILL differs=$M30_DIFFERS parses=$M30_PARSES — the control cannot run"
fi

# =================================================================== case 50k
#
# THE FIFTH AND LAST PRODUCTION CONSUMER (Unit 32), and the one that covers the
# most terminals: the shared nonzero die() funnel. 50a and 50b proved it
# FINALIZES a truthful run-bound record at a post-hop 22 and a pre-hop 18; 57b
# proved a failed publication transfers instead of falling through. Nothing
# proved the artifact it goes on to advertise still says what this run did.
# Measured on the fixtures below before the edit: a record altered after
# successful finalization to `outcome=COMPLETED` still exited 22, was advertised
# as this run's terminal result and released both leases, and so did one altered
# to `code=0` at the pre-hop 18. Path, structure and identity have nothing to
# object to; only meaning does.
#
# SAME FORCING TECHNIQUE, SAME WINDOW as 56b, 58e, 60j, 62b and 27w: one altering
# line injected after this seam's own finalization marker, between publication and
# consumption. It is GUARDED on RESULT_FILE, like 27w's and for the same reason —
# die() is also reached from terminals outside the run-evidence coverage guard,
# where no record exists and an unguarded fixture would act outside the window.
#
# BOTH HALVES OF THE FUNNEL ARE EXERCISED, because they are different runs and
# not two spellings of one: the post-hop 22 has a launched actor and observed
# state hashes behind it, the pre-hop 18 stops before any launch with its
# unavailable fields explicit. One consumer covers both without a per-code call
# site, which is the claim these two fixtures together carry.
echo
echo "Case 50k — a nonzero funnel record altered ONLY in outcome, or ONLY in code, is refused before release"
MUT50K="$SANDBOX_ROOT/mutants50k"; mkdir -p "$MUT50K"

mk_funnel_alter50() { # outfile sed-script [source] -> 0 when the fixture differs and parses
  awk -v s="$2" '{print} /# die funnel failure transfer/ {
    printf "  [ -n \"$RESULT_FILE\" ] && { sed %c%s%c \"$RESULT_FILE\" >\"$RESULT_FILE.x\" && mv -f \"$RESULT_FILE.x\" \"$RESULT_FILE\"; } # harness die-funnel alteration\n", 39, s, 39 }' \
    "${3:-$DISPATCH_BIN}" >"$1"
  ! cmp -s "${3:-$DISPATCH_BIN}" "$1" && bash -n "$1" 2>/dev/null
}

# One run through a forcing fixture at whichever half of the funnel the caller
# names. `foreign` is what separates them: a path outside the allowlist stops the
# run at the pre-hop 18 before any launch, and its absence lets the simulated
# actor run and reach the post-hop 22.
funnel_run50() { # fixture task foreign? -> sets V50K and O50K
  V50K="$(new_sandbox)"; state_file "$V50K" "$2" codex
  [ "${3:-no}" = yes ] && printf 'out of allowlist\n' >>"$V50K/other.txt"
  O50K="$(bash "$1" --checkout "$V50K" --task "$2" --log-dir "$V50K/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC50K=$?
}

# The full refusal contract for one forced funnel mismatch, asserted exactly as
# the four migrated seams assert theirs — plus the one assertion only this seam
# needs. The refusal re-enters die() to exit 38, so "it refused" is not enough:
# it has to have refused ONCE.
expect_funnel_refusal50() { # fixture task expected-token label-prefix original-code foreign?
  local TL CL N
  funnel_run50 "$1" "$2" "${6:-no}"
  expect_rc 38 "$RC50K" "$4 — refused with exit 38, never $5" "$O50K"
  out_lacks "  terminal result:" "$O50K" "$4 — the refused artifact is not advertised as this run's result"
  out_has "reached the shared nonzero terminal for code $5" "$O50K" \
    "$4 — the refusal names the shared nonzero terminal it actually reached, and the code it was ending with"
  out_lacks "reached a real operator terminal" "$O50K" \
    "$4 — the refusal claims no operator terminal"
  # TERMINATION, and this is the assertion the other four seams do not need. They
  # refuse from a terminal that exits directly; this one refuses from INSIDE the
  # funnel, and the refusal's own `die 38` re-enters it. A consumer that ran again
  # on re-entry would refuse the same artifact against TERMINAL_UNPROVABLE/38 and
  # never stop. Counted rather than reasoned about: exactly one STOP [38] line.
  N="$(printf '%s\n' "$O50K" | grep -c '^STOP \[38\]' || true)"
  [ "$N" = 1 ] && ok "$4 — the refusal fired exactly once and did not re-enter the consumer" \
               || bad "$4 — the refusal fired exactly once and did not re-enter the consumer" \
                      "STOP [38] lines: $N"
  TL="$(task_lock_for "$V50K" "$2")"; CL="$(checkout_lock_for "$V50K")"
  # NOT a finalization story: the record published perfectly well (57b owns the
  # publication failure). What failed here is what it says.
  if [ -d "$TL" ] && [ -d "$CL" ] &&
     grep -q '^terminal result unprovable: ' "$TL/survivors" 2>/dev/null &&
     grep -q "$3" "$TL/survivors" 2>/dev/null &&
     grep -q "$3" "$CL/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL/survivors" 2>/dev/null; then
    ok "$4 — both leases retained, both pins carrying the bounded '$3' cause"
  else
    bad "$4 — both leases retained, both pins carrying the bounded '$3' cause" \
        "task=$([ -d "$TL" ] && echo present || echo absent) checkout=$([ -d "$CL" ] && echo present || echo absent) cause: $(cat "$TL/survivors" 2>&1 | tr '\n' '|')"
  fi
  # THE ACCEPTED CAUSE-RECORDED WORDING, on the ordinary path where no earlier pin
  # exists. Unit 34 makes this sentence conditional, so the unpinned case has to
  # keep saying it — otherwise "preserve the first cause" would have been
  # implemented as "stop recording consumer causes at all", which is the opposite
  # failure and would look identical from the exit code alone.
  out_has "Both run leases are retained with that cause recorded" "$O50K" \
    "$4 — with no earlier pin, the refusal still states that its own cause was recorded"
  run_dispatch "$V50K" "$2" --dry-run
  expect_rc 17 "$RC" "$4 — the next dispatcher is refused by the retained lease" "$OUT"
}

if mk_funnel_alter50 "$MUT50K/outonly.sh" 's/^outcome=.*/outcome=COMPLETED/'; then
  ok "50k — the outcome-only forcing fixture differs from the dispatcher and is valid bash"
  expect_funnel_refusal50 "$MUT50K/outonly.sh" funnel-out-task outcome-mismatch \
    "50k — a post-hop 22 whose record claims COMPLETED" 22
else
  bad "50k — the outcome-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi
if mk_funnel_alter50 "$MUT50K/codeonly.sh" 's/^code=.*/code=0/'; then
  ok "50k — the code-only forcing fixture differs from the dispatcher and is valid bash"
  expect_funnel_refusal50 "$MUT50K/codeonly.sh" funnel-code-task code-mismatch \
    "50k — a pre-hop 18 whose record claims code 0" 18 yes
else
  bad "50k — the code-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

# THE CLEAN CONTROLS, on the same two halves and through the same runner. Without
# these the refusals above could be satisfied by a seam that refuses everything,
# which would break every ordinary nonzero terminal in the dispatcher.
for c50 in 22:funnel-clean-post-task:NO_TRANSITION:no 18:funnel-clean-pre-task:FOREIGN_UNSTAGED:yes; do
  WANT50="${c50%%:*}"; REST50="${c50#*:}"
  T50K="${REST50%%:*}"; REST50="${REST50#*:}"
  SYM50="${REST50%%:*}"; FGN50="${REST50##*:}"
  funnel_run50 "$DISPATCH_BIN" "$T50K" "$FGN50"
  RID50K="$(run_id_of "$O50K")"
  R50K="$V50K/runs/$RID50K.result"
  if [ "$RC50K" = "$WANT50" ] && [ "$(res_count "$V50K/runs")" = 1 ] &&
     [ "$(res_field "$R50K" outcome)" = "$SYM50" ] && [ "$(res_field "$R50K" code)" = "$WANT50" ] &&
     [ "$(tail -1 "$R50K" 2>/dev/null)" = "result_complete=yes" ] &&
     printf '%s\n' "$O50K" | grep -qF "  terminal result: $R50K" &&
     [ ! -d "$(task_lock_for "$V50K" "$T50K")" ] && [ ! -d "$(checkout_lock_for "$V50K")" ]; then
    ok "50k — a clean $WANT50 still exits $WANT50, advertises its one complete $SYM50 result, and releases both leases"
  else
    bad "50k — a clean $WANT50 still exits $WANT50, advertises its one complete $SYM50 result, and releases both leases" \
        "rc=$RC50K results=$(res_count "$V50K/runs") outcome=$(res_field "$R50K" outcome) code=$(res_field "$R50K" code) task-lease=$([ -d "$(task_lock_for "$V50K" "$T50K")" ] && echo held || echo released)"
  fi
done

# INDEPENDENCE, structurally, the same assertion 60j, 62c and 27w make for their
# own seams: this call site must derive its expected symbol through the sole
# mapping owner and state its expected code from the funnel's own dispatcher-owned
# parameter. A call site that passed a field out of the record would compare it
# with itself, and both refusals above would go green on a forgery.
CALL50K="$(grep -n '# die-funnel terminal consumption' "$DISPATCH_BIN" | grep -v ':[[:space:]]*#' | cut -d: -f2-)"
if printf '%s\n' "$CALL50K" | grep -q 'result_outcome "\$code"' &&
   ! printf '%s\n' "$CALL50K" | grep -qE 'RESULT_FILE|TR_OUTCOME|TR_CODE|res_field|\.result'; then
  ok "50k — the funnel seam derives its expected pair through result_outcome and the funnel's own code, and reads nothing from the artifact"
else
  bad "50k — the funnel seam derives its expected pair through result_outcome and the funnel's own code, and reads nothing from the artifact" \
      "call site: $CALL50K"
fi

# =================================================================== case 50L
echo
echo "Case 50L — mutation control: remove ONLY the new funnel consumer and both mismatches release again"
# M39 — the fifth in the M33/M34/M36/M37 line, and the first that addresses the
# funnel itself. It strips exactly the consumer call, leaving the finalization
# line, its failure transfer, the advertisement, the release and the exit in
# place, AND leaving the other four consumers untouched — which is what proves
# this seam is separately fail-capable rather than sharing a switch with them.
# Fails closed: unless the selector matched exactly once and the mutant differs
# and parses, the control does not run.
sed '/# die-funnel terminal consumption$/d' "$DISPATCH_BIN" >"$MUT50K/m39.sh" 2>/dev/null
M39_HITS="$(grep -c '# die-funnel terminal consumption$' "$DISPATCH_BIN" 2>/dev/null || true)"
M39_LEFT="$(grep -c '# die-funnel terminal consumption$' "$MUT50K/m39.sh" 2>/dev/null || true)"
M39_FINAL="$(grep -c '# die funnel failure transfer$' "$MUT50K/m39.sh" 2>/dev/null || true)"
M39_OTHERS=0
for m39 in operator dry-run carry-one interruption; do
  M39_OTHERS=$((M39_OTHERS + $(grep -c "# $m39 terminal consumption\$" "$MUT50K/m39.sh" 2>/dev/null || true)))
done
M39_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT50K/m39.sh" || M39_DIFFERS=yes
M39_PARSES=no; bash -n "$MUT50K/m39.sh" 2>/dev/null && M39_PARSES=yes
if [ "$M39_HITS" = 1 ] && [ "$M39_LEFT" = 0 ] && [ "$M39_FINAL" = 1 ] && [ "$M39_OTHERS" = 4 ] &&
   [ "$M39_DIFFERS" = yes ] && [ "$M39_PARSES" = yes ]; then
  ok "50L — M39 removed exactly the funnel consumer, kept its finalization transfer and the other four consumers, differs, and parses"
  for f50 in out:22:funnel-m39-out-task:no code:18:funnel-m39-code-task:yes; do
    FLD50="${f50%%:*}"; REST39="${f50#*:}"
    WANT39="${REST39%%:*}"; REST39="${REST39#*:}"
    T39="${REST39%%:*}"; FGN39="${REST39##*:}"
    if [ "$FLD50" = out ]; then S39='s/^outcome=.*/outcome=COMPLETED/'; else S39='s/^code=.*/code=0/'; fi
    if mk_funnel_alter50 "$MUT50K/m39-$FLD50.sh" "$S39" "$MUT50K/m39.sh"; then
      funnel_run50 "$MUT50K/m39-$FLD50.sh" "$T39" "$FGN39"
      if [ "$RC50K" = "$WANT39" ] &&
         printf '%s\n' "$O50K" | grep -q '  terminal result: ' &&
         [ ! -d "$(task_lock_for "$V50K" "$T39")" ] && [ ! -d "$(checkout_lock_for "$V50K")" ]; then
        ok "50L — M39: without the consumer the $FLD50-only mismatch exits $WANT39, advertises the altered artifact and releases (50k is fail-capable)"
      else
        bad "50L — M39: without the consumer the $FLD50-only mismatch exits $WANT39, advertises the altered artifact and releases (50k is fail-capable)" \
            "rc=$RC50K advertised=$(printf '%s\n' "$O50K" | grep -c '  terminal result: ') task-lease=$([ -d "$(task_lock_for "$V50K" "$T39")" ] && echo held || echo released)"
      fi
    else
      bad "50L — M39: the $FLD50-only fixture over the mutant differs and parses" \
          "the injection matched nothing, or the fixture does not parse — the control cannot run"
    fi
  done
else
  bad "50L — M39 removed exactly the funnel consumer, kept its finalization transfer and the other four consumers, differs, and parses" \
      "matched=$M39_HITS left=$M39_LEFT finalization=$M39_FINAL others=$M39_OTHERS differs=$M39_DIFFERS parses=$M39_PARSES — the control cannot run"
fi

# =================================================================== case 50m
#
# THE DURABLE CAUSE OUTLIVES THE RUN, and that is what makes this a defect rather
# than a wording preference. Unit 33 measured the nested path with a temporary
# probe: a terminal-specific finalization fails, die_terminal_unprovable pins the
# finalization-failure cause and re-enters `die 38`, that retry SUCCEEDS, and the
# funnel consumer added at Unit 32 then refuses an altered artifact and pins
# again. Measured on the fixture below before the edit: both leases stayed held,
# but their surviving cause said only `outcome-mismatch` — the finalization
# failure that actually started the incident was gone, and the later refusal told
# the operator its own cause had been recorded on both leases when it had just
# overwritten the one that mattered. The recovery actions differ: the surviving
# record sent the operator to repair an interfering artifact when the real cause
# was a write that failed.
#
# WHY THE OPERATOR TERMINAL. It is the seam whose finalization failure is already
# an accepted case (55e/57), and it reaches the funnel with no actor, no signal
# and no carried hop to confound what is being observed.
#
# THE FIXTURE FORCES BY CODE, NOT BY COUNTER, which is what keeps it readable and
# fail-closed at the same time: the operator terminal finalizes at code 0 and the
# re-entry finalizes at code 38, so failing exactly the code-0 attempt forces the
# first failure and lets the retry through without any counter state to get wrong.
# RESULT_FILE is cleared exactly as the production failure paths clear it.
echo
echo "Case 50m — a consumer refusal that arrives AFTER an earlier pin does not overwrite the first durable cause"
MUT50M="$SANDBOX_ROOT/mutants50m"; mkdir -p "$MUT50M"

mk_nested_alter50() { # outfile [source] -> 0 when the fixture differs and parses
  awk '
    {print}
    index($0, "[ \"$RESULT_FINALIZED\" -eq 1 ] && return 0") {
      print "  [ \"$1\" = 0 ] && { RESULT_FILE=\"\"; return 1; } # harness nested first-finalization failure" }
    /# die funnel failure transfer/ {
      print "  [ -n \"$RESULT_FILE\" ] && { sed '\''s/^outcome=.*/outcome=COMPLETED/'\'' \"$RESULT_FILE\" >\"$RESULT_FILE.x\" && mv -f \"$RESULT_FILE.x\" \"$RESULT_FILE\"; } # harness nested retry-result alteration" }
  ' "${2:-$DISPATCH_BIN}" >"$1"
  ! cmp -s "${2:-$DISPATCH_BIN}" "$1" && bash -n "$1" 2>/dev/null
}

# Both selectors must have matched, or the fixture is not modelling the nested
# path at all and every assertion below would be vacuous.
if mk_nested_alter50 "$MUT50M/nested.sh"; then
  NEST_FIN="$(grep -c '# harness nested first-finalization failure$' "$MUT50M/nested.sh" 2>/dev/null || true)"
  NEST_ALT="$(grep -c '# harness nested retry-result alteration$' "$MUT50M/nested.sh" 2>/dev/null || true)"
else
  NEST_FIN=0; NEST_ALT=0
fi
if [ "$NEST_FIN" = 1 ] && [ "$NEST_ALT" = 1 ]; then
  ok "50m — the nested forcing fixture injected both the first-finalization failure and the retry alteration, differs, and parses"
else
  bad "50m — the nested forcing fixture injected both the first-finalization failure and the retry alteration, differs, and parses" \
      "finalization-injections=$NEST_FIN alteration-injections=$NEST_ALT — the case cannot run"
fi

nested_probe50() { # fixture task -> sets V50M and O50M
  V50M="$(new_sandbox)"; state_file "$V50M" "$2" operator
  O50M="$(bash "$1" --checkout "$V50M" --task "$2" --log-dir "$V50M/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC50M=$?
}

expect_nested_preservation50() { # fixture task label-prefix
  local TL CL S T U REC LOG
  nested_probe50 "$1" "$2"
  expect_rc 38 "$RC50M" "$3 — the nested refusal still exits 38" "$O50M"
  # THE RETRY-SUCCESS PATH IS STILL THE ONE UNDER TEST. Unit 33's counters are not
  # available here, so the observable stands in for them: the record on disk is the
  # code-38 one the RETRY wrote, which only exists if the first attempt failed and
  # the second succeeded.
  REC="$V50M/runs/$(run_id_of "$O50M").result"
  [ "$(res_field "$REC" code)" = 38 ] \
    && ok "$3 — the surviving record is the retry's own code-38 result" \
    || bad "$3 — the surviving record is the retry's own code-38 result" "code=$(res_field "$REC" code)"
  # ONE OF EACH REFUSAL, NOT ONE REPEATED. Two distinct sentences, one nested in
  # the other; a third of either would be the recursion Unit 32's one-shot bound
  # exists to prevent.
  U="$(printf '%s\n' "$O50M" | grep -cF 'could not be finalized under' || true)"
  T="$(printf '%s\n' "$O50M" | grep -cF 'did not pass the consumer gate' || true)"
  if [ "$U" = 1 ] && [ "$T" = 1 ]; then
    ok "$3 — both refusals are reported exactly once, and neither recurred"
  else
    bad "$3 — both refusals are reported exactly once, and neither recurred" \
        "finalization-failure sentences=$U consumer-gate sentences=$T"
  fi
  out_lacks "  terminal result:" "$O50M" "$3 — the refused artifact is not advertised as this run's result"
  # THE LATER REFUSAL IS STILL VISIBLE where the operator reads this run — both
  # channels. Preserving the earlier cause must not cost the later evidence.
  LOG="$V50M/runs/$(run_id_of "$O50M").log"
  if grep -qF 'did not pass the consumer gate' "$LOG" 2>/dev/null &&
     grep -qF 'outcome-mismatch' "$LOG" 2>/dev/null; then
    ok "$3 — the later mismatch is still recorded in the run log, not only on stderr"
  else
    bad "$3 — the later mismatch is still recorded in the run log, not only on stderr" \
        "run log: $(tr '\n' '|' <"$LOG" 2>&1 | tail -c 200)"
  fi
  # THE DURABLE HALF. Both leases must still carry the FIRST cause, byte-for-byte,
  # and must not carry the later one.
  TL="$(task_lock_for "$V50M" "$2")"; CL="$(checkout_lock_for "$V50M")"
  S=ok
  for d50 in "$TL" "$CL"; do
    [ -d "$d50" ] || { S="missing $d50"; break; }
    grep -q 'could not finalize its terminal result' "$d50/survivors" 2>/dev/null \
      || { S="first cause absent in $d50"; break; }
    grep -q 'was refused before release' "$d50/survivors" 2>/dev/null \
      && { S="later cause overwrote $d50"; break; }
  done
  [ "$S" = ok ] \
    && ok "$3 — both leases are retained still carrying the FIRST finalization-failure cause, not the later mismatch" \
    || bad "$3 — both leases are retained still carrying the FIRST finalization-failure cause, not the later mismatch" \
           "$S; task cause: $(tr '\n' '|' <"$TL/survivors" 2>&1)"
  # THE WORDING HALF, and it is a separate claim: the durable record can be right
  # while the message still tells the operator this refusal's cause was written to
  # the leases. Counted rather than matched, because the FIRST refusal says the
  # accepted sentence legitimately — exactly one of them may.
  S="$(printf '%s\n' "$O50M" | grep -cF 'Both run leases are retained with that cause recorded' || true)"
  if [ "$S" = 1 ] &&
     printf '%s\n' "$O50M" | grep -qF 'remain retained under the cause recorded before this refusal'; then
    ok "$3 — only the earlier refusal claims its cause was recorded; the later one says the earlier evidence is preserved"
  else
    bad "$3 — only the earlier refusal claims its cause was recorded; the later one says the earlier evidence is preserved" \
        "cause-recorded claims=$S preserved-wording=$(printf '%s\n' "$O50M" | grep -cF 'remain retained under the cause recorded before this refusal' || true)"
  fi
  run_dispatch "$V50M" "$2" --dry-run
  expect_rc 17 "$RC" "$3 — the next dispatcher is refused by the retained lease" "$OUT"
}

if [ "$NEST_FIN" = 1 ] && [ "$NEST_ALT" = 1 ]; then
  expect_nested_preservation50 "$MUT50M/nested.sh" nested-pin-task \
    "50m — a consumer refusal after a finalization-failure pin"
fi

# =================================================================== case 50n
echo
echo "Case 50n — mutation control: remove ONLY the pin precedence and the first durable cause is overwritten again"
# M40 — it neutralizes exactly the new precedence test and nothing else: the pin
# call, its bounded cause, the cleared RESULT_FILE, the exit, the retention and
# the refusal sentence all stay. So the run must still refuse identically, while
# the durable record goes back to carrying only the later mismatch AND the later
# message goes back to claiming that cause was recorded. Both halves are asserted,
# because the defect was both. Fails closed: unless the selector matched exactly
# once and the mutant differs and parses, the control does not run.
sed 's/if \[ "${WL_LEASE_PINNED:-0}" -eq 0 \]; then # consumer retention precedence/if true; then # consumer retention precedence/' \
  "$DISPATCH_BIN" >"$MUT50M/m40.sh" 2>/dev/null
M40_HITS="$(grep -c '# consumer retention precedence$' "$DISPATCH_BIN" 2>/dev/null || true)"
M40_LEFT="$(grep -c 'WL_LEASE_PINNED:-0.*# consumer retention precedence$' "$MUT50M/m40.sh" 2>/dev/null || true)"
M40_KEPT="$(grep -c '# consumer retention precedence$' "$MUT50M/m40.sh" 2>/dev/null || true)"
M40_PIN="$(grep -c '# operator consumer retention$' "$MUT50M/m40.sh" 2>/dev/null || true)"
M40_FUNNEL="$(grep -c 'WL_LEASE_PINNED:-0' "$MUT50M/m40.sh" 2>/dev/null || true)"
M40_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT50M/m40.sh" || M40_DIFFERS=yes
M40_PARSES=no; bash -n "$MUT50M/m40.sh" 2>/dev/null && M40_PARSES=yes
if [ "$M40_HITS" = 1 ] && [ "$M40_LEFT" = 0 ] && [ "$M40_KEPT" = 1 ] && [ "$M40_PIN" = 1 ] &&
   [ "$M40_FUNNEL" = 1 ] && [ "$M40_DIFFERS" = yes ] && [ "$M40_PARSES" = yes ]; then
  ok "50n — M40 neutralized exactly the consumer pin precedence, kept the pin call and the funnel's own precedence, differs, and parses"
  if mk_nested_alter50 "$MUT50M/m40-nested.sh" "$MUT50M/m40.sh"; then
    nested_probe50 "$MUT50M/m40-nested.sh" nested-m40-task
    TL40="$(task_lock_for "$V50M" nested-m40-task)"
    if [ "$RC50M" -eq 38 ] && [ -d "$TL40" ] &&
       grep -q 'was refused before release' "$TL40/survivors" 2>/dev/null &&
       ! grep -q 'could not finalize its terminal result' "$TL40/survivors" 2>/dev/null &&
       [ "$(printf '%s\n' "$O50M" | grep -cF 'Both run leases are retained with that cause recorded' || true)" = 2 ]; then
      ok "50n — M40: without the precedence the later cause overwrites the first and the refusal claims it was recorded (50m is fail-capable)"
    else
      bad "50n — M40: without the precedence the later cause overwrites the first and the refusal claims it was recorded (50m is fail-capable)" \
          "rc=$RC50M claims=$(printf '%s\n' "$O50M" | grep -cF 'Both run leases are retained with that cause recorded' || true) cause: $(tr '\n' '|' <"$TL40/survivors" 2>&1 | head -c 160)"
    fi
  else
    bad "50n — M40: the nested fixture over the mutant differs and parses" \
        "the injection matched nothing, or the fixture does not parse — the control cannot run"
  fi
else
  bad "50n — M40 neutralized exactly the consumer pin precedence, kept the pin call and the funnel's own precedence, differs, and parses" \
      "matched=$M40_HITS left=$M40_LEFT kept=$M40_KEPT pin=$M40_PIN funnel-precedence=$M40_FUNNEL differs=$M40_DIFFERS parses=$M40_PARSES — the control cannot run"
fi

# ==================================================================== case 51
# THE STANDALONE STRUCTURAL VALIDATOR for the v1 terminal result case 50 proves
# the dispatcher produces. Case 50 read that artifact with harness `sed`/`grep`
# on purpose — to show it is consumable without a parser shipped alongside it.
# This case adds the parser the DISPATCHER itself owns, and the two claims are
# different: "a careful reader can extract a field" is not "this program refuses
# a record it must not trust".
#
# THERE IS NO CONSUMER HERE, and that is this unit's boundary. Nothing below
# makes a valid result advance a loop, choose a path, wait for a record, or infer
# a semantic fact from a structure that validated. The validator answers exactly
# one question — is this artifact structurally the v1 record this dispatcher
# writes — and returns one bounded token saying why not. Meaning, run/task/path
# identity and first-consumer integration are separate units.
#
# HOW IT IS EXERCISED, and why that route. dispatch.sh parses its arguments and
# exits at load, so it cannot be sourced; and this unit may not add a CLI, status
# or transition route to reach the function, because that route would be the
# consumer the boundary above excludes. So the harness lifts the
# marker-delimited validator region out of the dispatcher UNDER TEST and sources
# that. It is not a second implementation: the text executed below is
# dispatch.sh's own production text, and 51c proves it by mutating dispatch.sh
# and watching these assertions go red.

VAL_BEGIN='# --- wl2:terminal-result-validator:begin ---'
VAL_END='# --- wl2:terminal-result-validator:end ---'

extract_validator() { # dispatcher-path outfile -> 0 when a non-empty region came out
  awk -v b="$VAL_BEGIN" -v e="$VAL_END" '
    $0 == b { f=1; next } $0 == e { f=0; next } f' "$1" >"$2" 2>/dev/null
  [ -s "$2" ]
}

# One validation, in its own subshell. The isolation is the point twice over:
# nothing the extracted text defines leaks into the harness, and nothing the
# harness already holds can stand in for a definition the dispatcher failed to
# ship — an undefined function exits 127 here rather than silently resolving.
val_run() { # lib artifact -> "<rc> <token>"
  ( . "$1" >/dev/null 2>&1 || { printf '99 lib-unsourceable\n'; exit 0; }
    tok="$(validate_terminal_result "$2" 2>/dev/null)"; rc=$?
    printf '%s %s\n' "$rc" "$tok" )
}

# want-rc want-token label
val_expect() { # lib artifact want-rc want-token label
  local got; got="$(val_run "$1" "$2")"
  if [ "$got" = "$3 $4" ]; then ok "$5"; else bad "$5" "expected '$3 $4', got '$got'"; fi
}

echo
echo "Case 51a — the dispatcher's own validator accepts the artifact its producer really writes"
VAL_LIB="$SANDBOX_ROOT/wl2-validator-lib.sh"
if extract_validator "$DISPATCH_BIN" "$VAL_LIB"; then
  ok "51a — a marker-delimited validator region exists in the dispatcher"
else
  bad "51a — a marker-delimited validator region exists in the dispatcher" \
      "no region between the markers in $DISPATCH_BIN — there is no production validator to exercise"
  : >"$VAL_LIB"
fi

# THE VALID CONTROL IS A REAL RUN'S OUTPUT, not a hand-built happy-path sample.
# A validator agreeing with a fixture the same author wrote proves only that the
# two agree; agreeing with what finalize_terminal_result() actually emitted is
# what makes it compatible with the artifact in the field.
V51D="$(new_sandbox)"; state_file "$V51D" "validator-task" "codex"
run_dispatch "$V51D" validator-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "51a — the producing run reaches a nonzero terminal (22)" "$OUT"
RID51="$(run_id_of "$OUT")"
REAL51="$V51D/runs/$RID51.result"
if [ -f "$REAL51" ]; then
  ok "51a — the producing run left a terminal result to validate"
else
  bad "51a — the producing run left a terminal result to validate" \
      "missing $REAL51; runs/ holds: $(ls "$V51D/runs" 2>&1 | tr '\n' ' ')"
fi
val_expect "$VAL_LIB" "$REAL51" 0 ok "51a — the unchanged real producer result is accepted"

# THE DECLARED SET IS THE PRODUCED SET. Two key lists in one file is how a
# reader drifts from its writer without either side looking wrong, so the
# validator's required set is compared against the keys the producer actually
# emitted rather than against a list this harness restates.
PRODUCED_KEYS="$(sed -n 's/^\([a-z][a-z0-9_]*\)=.*/\1/p' "$REAL51" 2>/dev/null | LC_ALL=C sort | tr '\n' ' ')"
DECLARED_KEYS="$( ( . "$VAL_LIB" >/dev/null 2>&1 &&
                    printf '%s\n' $TERMINAL_RESULT_REQUIRED ) 2>/dev/null | LC_ALL=C sort | tr '\n' ' ')"
if [ -n "$PRODUCED_KEYS" ] && [ "$PRODUCED_KEYS" = "$DECLARED_KEYS" ]; then
  ok "51a — the validator's required set is exactly the set the producer writes"
else
  bad "51a — the validator's required set is exactly the set the producer writes" \
      "produced: ${PRODUCED_KEYS:-<none>} / declared: ${DECLARED_KEYS:-<none>}"
fi

echo
echo "Case 51b — every structural defect is REJECTED with one bounded reason token"
V51="$SANDBOX_ROOT/v51"; mkdir -p "$V51"

# A duplicate singleton. The brief's named case: two `outcome=` lines, everything
# else intact and the sentinel still last, so nothing but the duplication can
# explain a rejection.
awk '/^outcome=/{print} {print}' "$REAL51" >"$V51/dup" 2>/dev/null
val_expect "$VAL_LIB" "$V51/dup" 1 duplicate-field "51b — a duplicated singleton is rejected"

# An unrecognized version. The record is otherwise this producer's own bytes,
# which is the case a later v2 would present.
sed '1s/^terminal_result_version=1$/terminal_result_version=2/' "$REAL51" >"$V51/ver2" 2>/dev/null
val_expect "$VAL_LIB" "$V51/ver2" 1 unknown-version "51b — an unrecognized version is rejected"

# The version line PRESENT BUT NOT FIRST. A validator that merely grepped for the
# expected version string would accept this; the structural claim is that the
# record announces its version before anything else can be read.
{ sed -n '2p' "$REAL51"; sed -n '1p' "$REAL51"; sed -n '3,$p' "$REAL51"; } >"$V51/vermoved" 2>/dev/null
val_expect "$VAL_LIB" "$V51/vermoved" 1 bad-version-line "51b — a version line that is not the first line is rejected"

sed 's|^schema=.*|schema=work-loop-v2-something-else|' "$REAL51" >"$V51/schema" 2>/dev/null
val_expect "$VAL_LIB" "$V51/schema" 1 unknown-schema "51b — an unrecognized schema name is rejected"

sed '/^owner_check=/d' "$REAL51" >"$V51/missing" 2>/dev/null
val_expect "$VAL_LIB" "$V51/missing" 1 missing-field "51b — a missing required singleton is rejected"

awk 'NR==5{print "NOT_A_PAIR"} {print}' "$REAL51" >"$V51/nopair" 2>/dev/null
val_expect "$VAL_LIB" "$V51/nopair" 1 malformed-line "51b — a line outside the key=value grammar is rejected"

awk 'NR==5{print "bad-key=x"} {print}' "$REAL51" >"$V51/badkey" 2>/dev/null
val_expect "$VAL_LIB" "$V51/badkey" 1 malformed-line "51b — a key outside the bounded key charset is rejected"

awk 'NR==5{print "surprise_field=x"} {print}' "$REAL51" >"$V51/extra" 2>/dev/null
val_expect "$VAL_LIB" "$V51/extra" 1 unknown-field "51b — a field this version does not define is rejected"

# TRUNCATED, the crash-boundary shape: a record that was being written when the
# writer stopped. It has no sentinel and it is missing most of its fields, and
# the token names the more specific of the two.
head -20 "$REAL51" >"$V51/trunc" 2>/dev/null
val_expect "$VAL_LIB" "$V51/trunc" 1 incomplete "51b — a truncated record with no sentinel is rejected"

# THE SENTINEL PRESENT BUT NOT LAST — the second half of the not-merely-grepping
# claim. Every required field is here exactly once and the grammar is clean; the
# only defect is that `result_complete=yes` is not the final line, which is
# precisely what separates a finished record from one still being written.
{ sed -n '1p' "$REAL51"; grep '^result_complete=' "$REAL51"
  sed '1d;/^result_complete=/d' "$REAL51"; } >"$V51/midsentinel" 2>/dev/null
val_expect "$VAL_LIB" "$V51/midsentinel" 1 incomplete "51b — a sentinel that is not the last line is rejected"

sed 's|^result_complete=yes$|result_complete=no|' "$REAL51" >"$V51/notyes" 2>/dev/null
val_expect "$VAL_LIB" "$V51/notyes" 1 incomplete "51b — a negated completion sentinel is rejected"

# THE FINITE ARTIFACT BOUND. A reader with no size bound is a reader an actor can
# make run for as long as it likes by planting a large file at the path.
PAD70K="$(head -c 70000 /dev/zero 2>/dev/null | tr '\0' 'x')"
{ cat "$REAL51"; printf 'next_action=%s\n' "$PAD70K"; } >"$V51/big" 2>/dev/null
val_expect "$VAL_LIB" "$V51/big" 1 too-large "51b — an artifact past the declared byte bound is rejected"

PAD600="$(head -c 600 /dev/zero 2>/dev/null | tr '\0' 'y')"
sed "s|^next_action=.*|next_action=$PAD600|" "$REAL51" >"$V51/longval" 2>/dev/null
val_expect "$VAL_LIB" "$V51/longval" 1 value-too-long "51b — a value past the declared value bound is rejected"

: >"$V51/empty"
val_expect "$VAL_LIB" "$V51/empty" 1 empty "51b — an empty artifact is rejected"
val_expect "$VAL_LIB" "$V51/does-not-exist" 1 unreadable "51b — an absent artifact is rejected"

# READ-ONLY, PROVED AGAINST THE WHOLE CHECKOUT rather than against the artifact
# alone. The claim is not just "it did not rewrite the record" but "it touched no
# state file, no lease, no ownership declaration, no log and no capture", and a
# tree manifest is the only assertion that covers all of them at once.
BEFORE51="$(tree_manifest "$V51D")"
val_run "$VAL_LIB" "$REAL51" >/dev/null 2>&1
val_run "$VAL_LIB" "$V51/dup" >/dev/null 2>&1
AFTER51="$(tree_manifest "$V51D")"
if [ "$BEFORE51" = "$AFTER51" ]; then
  ok "51b — validating changes nothing in the checkout (artifact, state, leases, logs)"
else
  bad "51b — validating changes nothing in the checkout (artifact, state, leases, logs)" \
      "$(printf '%s\n' "$BEFORE51" >"$V51/before"; printf '%s\n' "$AFTER51" >"$V51/after"
         diff "$V51/before" "$V51/after" | head -4 | tr '\n' ';')"
fi

# IT NEITHER SOURCES NOR EVALUATES WHAT IT READS, asserted twice. The static half
# is what the production text may not contain; the live half plants a value that
# WOULD have an effect if any of those constructs were reached.
#
# WHOLE-LINE COMMENTS ARE STRIPPED FIRST, and that sharpens the claim rather than
# softening it: a comment cannot execute, so a prose line mentioning `eval` would
# be a false positive about the one thing this control exists to catch.
VAL_CODE="$SANDBOX_ROOT/wl2-validator-code.sh"
NOEXEC_RE='(^|[^[:alnum:]_])(eval|source)[[:space:]]|^[[:space:]]*\.[[:space:]]|`|\$\(<'
sed 's/^[[:space:]]*#.*$//' "$VAL_LIB" >"$VAL_CODE" 2>/dev/null
if [ -s "$VAL_LIB" ] && ! grep -nE "$NOEXEC_RE" "$VAL_CODE" >/dev/null 2>&1; then
  ok "51b — the validator's executable text contains no eval, source, dot-source or backtick"
else
  bad "51b — the validator's executable text contains no eval, source, dot-source or backtick" \
      "$(grep -nE "$NOEXEC_RE" "$VAL_CODE" 2>/dev/null | head -3 | tr '\n' ';')"
fi
CANARY51="$V51D/CANARY"
sed "s|^next_action=.*|next_action=\$(touch $CANARY51)|" "$REAL51" >"$V51/inject" 2>/dev/null
val_run "$VAL_LIB" "$V51/inject" >/dev/null 2>&1
if [ ! -e "$CANARY51" ]; then
  ok "51b — a command substitution inside a value is data, not code"
else
  bad "51b — a command substitution inside a value is data, not code" "the canary at $CANARY51 was created"
fi

echo
echo "Case 51c — mutation controls: the rejections above go green when the validator is broken"
MUT51="$SANDBOX_ROOT/mutants51"; mkdir -p "$MUT51"

# M9 — remove the duplicate-detection line from the DISPATCHER, then extract the
# validator from the mutant. If 51b's duplicate rejection were satisfied by
# anything other than that line, this control would still reject and the
# assertion above would not be evidence.
sed "/printf 'duplicate-field/d" "$DISPATCH_BIN" >"$MUT51/m9.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT51/m9.sh"; then
  ok "51c — M9 mutant differs from the dispatcher (the duplicate check was found)"
  if extract_validator "$MUT51/m9.sh" "$MUT51/m9.lib"; then
    val_expect "$MUT51/m9.lib" "$V51/dup" 0 ok \
      "51c — M9: without the duplicate check the duplicate is accepted (51b is fail-capable)"
  else
    bad "51c — M9: without the duplicate check the duplicate is accepted (51b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "51c — M9 mutant differs from the dispatcher (the duplicate check was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M10 — remove the sentinel-is-last line. Without it the validator still finds
# every required field exactly once in the reordered record, so it accepts a
# record that was never finalized. That is exactly the failure a grep for
# `result_complete=yes` would have shipped.
sed "/printf 'incomplete/d" "$DISPATCH_BIN" >"$MUT51/m10.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT51/m10.sh"; then
  ok "51c — M10 mutant differs from the dispatcher (the sentinel check was found)"
  if extract_validator "$MUT51/m10.sh" "$MUT51/m10.lib"; then
    val_expect "$MUT51/m10.lib" "$V51/midsentinel" 0 ok \
      "51c — M10: without the sentinel check a non-final record is accepted (51b is fail-capable)"
  else
    bad "51c — M10: without the sentinel check a non-final record is accepted (51b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "51c — M10 mutant differs from the dispatcher (the sentinel check was found)" \
      "the sed matched nothing — the control cannot run"
fi

# ==================================================================== case 52
# EXPECTED-IDENTITY BINDING for the artifact case 51 proved is structurally a v1
# record. The two questions are different, and case 51 says so in its own words:
# "is this the shape this dispatcher writes" is not "is this the result promised
# for THIS task, THIS checkout and THIS run". A structurally perfect record is
# exactly what a copied, replayed or planted one looks like.
#
# WHAT THE BOUNDARY COMPARES, and the constraint that makes it worth having: only
# the artifact against values the CALLER supplied. It never reads an expectation
# out of the artifact, never scans a directory for a candidate, and never takes a
# path from actor prose. An identity check that sourced either side of its own
# comparison from the thing under test would confirm the record agrees with
# itself, which every forgery also does.
#
# STILL NOT A CONSUMER. Nothing below makes a validated result advance a loop,
# choose a route, wait for a record, or settle a semantic fact. Outcome/code
# agreement and first-consumer integration remain later units.
#
# SAME EXERCISE ROUTE as case 51, for the same reason: the marker-delimited region
# is lifted out of the dispatcher under test and sourced, so the text executed
# here is dispatch.sh's own production text, and 52d proves it by mutating
# dispatch.sh and watching these assertions go red.

# THE THREE CHECKS IN THE ONE ORDER THAT IS CORRECT, in a single subshell: gate
# the path while nothing is open, parse the bytes exactly once, then compare
# identity against that pinned snapshot.
#
# THE GATE SHORT-CIRCUITS, and that is the behaviour under test rather than a
# convenience of the harness. A refused path must stop here, before the parser is
# ever handed the name — case 53a asserts that nothing was parsed by looking at
# what the parse would have published.
# THE TOKENS GO THROUGH A FILE, NOT THROUGH `$(...)`, and that is a correctness
# requirement rather than a style choice. Command substitution runs its command in
# a subshell, so the three checks hand each other their state — which path the gate
# cleared, what the parse published — through globals that a subshell would
# discard. Capturing the first two that way would silently break the chain and
# make every precondition below look unmet. The scratch file sits in
# SANDBOX_ROOT, outside any checkout, so it cannot disturb a tree manifest.
ident_run() { # lib artifact task checkout run root -> "<rc> <token>"
  ( . "$1" >/dev/null 2>&1 || { printf '99 lib-unsourceable\n'; exit 0; }
    t="$SANDBOX_ROOT/.ident-token"
    validate_terminal_result_path "$2" "$3" "$4" "$5" "$6" >"$t" 2>/dev/null; rc=$?
    [ "$rc" -eq 0 ] || { printf '%s %s\n' "$rc" "$(cat "$t")"; exit 0; }
    validate_terminal_result "$2" >"$t" 2>/dev/null; rc=$?
    [ "$rc" -eq 0 ] || { printf '%s %s\n' "$rc" "$(cat "$t")"; exit 0; }
    validate_terminal_result_identity "$2" "$3" "$4" "$5" "$6" >"$t" 2>/dev/null; rc=$?
    printf '%s %s\n' "$rc" "$(cat "$t")" )
}

ident_expect() { # lib artifact task checkout run root want-rc want-token label
  local got; got="$(ident_run "$1" "$2" "$3" "$4" "$5" "$6")"
  if [ "$got" = "$7 $8" ]; then ok "$9"; else bad "$9" "expected '$7 $8', got '$got'"; fi
}

echo
echo "Case 52a — a real result at its promised path is accepted for the identity it was written under"
V52D="$(new_sandbox)"; state_file "$V52D" "identity-task" "codex"
run_dispatch "$V52D" identity-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "52a — the producing run reaches a nonzero terminal (22)" "$OUT"
RID52="$(run_id_of "$OUT")"
# The dispatcher canonicalizes both --checkout and --log-dir, so the harness must
# compare against the canonical forms or every assertion below would fail on
# macOS for the wrong reason: $TMPDIR resolves through /private.
CO52="$(cd "$V52D" && pwd -P)"
ROOT52="$(cd "$V52D/runs" && pwd -P)"
REAL52="$ROOT52/$RID52.result"
if [ -f "$REAL52" ]; then
  ok "52a — the producing run left a terminal result at its promised path"
else
  bad "52a — the producing run left a terminal result at its promised path" \
      "missing $REAL52; runs/ holds: $(ls "$ROOT52" 2>&1 | tr '\n' ' ')"
fi
ident_expect "$VAL_LIB" "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 0 ok \
  "52a — the real result is accepted for its own task, checkout, run and promised path"

echo
echo "Case 52b — a structurally valid record is REJECTED when any expected field or the path disagrees"
V52="$SANDBOX_ROOT/v52"; mkdir -p "$V52"

# THE CENTRAL CASE, and the one this unit exists for. A byte-identical copy of a
# real result, placed at the plausible promised path of a DIFFERENT run in the
# same evidence root, presented as that run. Structure cannot tell these apart —
# 52c asserts that in so many words — so only the identity comparison can.
OTHER52="20260101T000000-deadbeef-9999-identity-task"
COPY52="$ROOT52/$OTHER52.result"
cp "$REAL52" "$COPY52"
ident_expect "$VAL_LIB" "$COPY52" identity-task "$CO52" "$OTHER52" "$ROOT52" 1 run-mismatch \
  "52b — a valid result copied to another run's promised path is rejected as that run"

# The same copy presented under the ORIGINAL run's expectations. Now the record's
# own run field matches, and the defect is that the artifact is not sitting where
# the promised path for that run says it must be.
ident_expect "$VAL_LIB" "$COPY52" identity-task "$CO52" "$RID52" "$ROOT52" 1 path-not-promised \
  "52b — a result read from anywhere but the promised path for the expected run is rejected"

ident_expect "$VAL_LIB" "$REAL52" a-different-task "$CO52" "$RID52" "$ROOT52" 1 task-mismatch \
  "52b — a task the caller did not expect is rejected"

ident_expect "$VAL_LIB" "$REAL52" identity-task "$SANDBOX_ROOT/not-this-checkout" "$RID52" "$ROOT52" \
  1 checkout-mismatch "52b — a checkout the caller did not expect is rejected"

# A SYMLINK AT THE PROMISED PATH — Unit 6's deferred observation, owned here.
#
# THE LINK POINTS AT THE RIGHT RESULT, and that is what makes this the sharp case
# rather than a soft one. Its name is the promised path for the expected run, and
# its target is the genuine result for that very run, so the task, the checkout
# and the run all match and NO field comparison can explain a rejection. The only
# defect left is that the dispatcher promised a file at that path and found a
# pointer — which is the whole claim: a link is not the file it names, however
# right the file it names happens to be.
#
# An earlier draft of this fixture pointed the link at a DIFFERENT run's result,
# and M12 caught it: the run comparison rejected that one first, so the assertion
# was never evidence about the symlink refusal at all.
SYM52D="$SANDBOX_ROOT/v52-symroot"; mkdir -p "$SYM52D"
SYM52ROOT="$(cd "$SYM52D" && pwd -P)"
ln -s "$REAL52" "$SYM52ROOT/$RID52.result"
ident_expect "$VAL_LIB" "$SYM52ROOT/$RID52.result" identity-task "$CO52" "$RID52" "$SYM52ROOT" \
  1 symlinked-path "52b — a symlink standing at the promised path is refused, not followed"

# AN EVIDENCE ROOT THAT IS ITSELF A LINK. The final component is a real file and
# the promised path matches literally, so only resolving the directory catches
# that the admitted root is not the directory actually being read.
LINKROOT52="$SANDBOX_ROOT/v52-linkroot"
ln -s "$ROOT52" "$LINKROOT52"
ident_expect "$VAL_LIB" "$LINKROOT52/$RID52.result" identity-task "$CO52" "$RID52" "$LINKROOT52" \
  1 outside-evidence-root "52b — a promised path whose evidence root resolves elsewhere is rejected"

# HOSTILE PATH SHAPES ARE REFUSED, NOT NORMALIZED. A traversal segment, a leading
# dash that a later command would read as an option, and an embedded newline are
# each refused outright rather than cleaned up into something trusted.
ident_expect "$VAL_LIB" "$ROOT52/../runs/$RID52.result" identity-task "$CO52" "$RID52" "$ROOT52" \
  1 unsafe-path "52b — a traversal segment in the artifact path is refused, not resolved"
ident_expect "$VAL_LIB" "$REAL52" identity-task "$CO52" "$RID52" "-$ROOT52" \
  1 unsafe-path "52b — an evidence root that could be read as an option is refused"
ident_expect "$VAL_LIB" "$REAL52" identity-task "$CO52" "$(printf 'a\nb')" "$ROOT52" \
  1 unsafe-path "52b — an expected value carrying a control character is refused"

# AN EMPTY EXPECTATION IS NOT A WILDCARD. A caller that has not established one of
# the four values must be refused, never quietly matched against whatever the
# artifact happens to say.
ident_expect "$VAL_LIB" "$REAL52" "" "$CO52" "$RID52" "$ROOT52" 1 no-expectation \
  "52b — an unsupplied expected task is refused rather than treated as any task"

# BOTH PRECONDITIONS ARE PRECONDITIONS, NOT ASSUMPTIONS, and they are separate
# failures with separate tokens. Asked cold, identity has neither a gate decision
# nor a parse to consume, and it names the earlier of the two — the path was never
# vetted, which is the more serious of the two things missing.
NOGATE52="$( . "$VAL_LIB" >/dev/null 2>&1
             tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
             printf '%s %s\n' "$?" "$tok" )"
if [ "$NOGATE52" = "1 path-unchecked" ]; then
  ok "52b — identity refuses an artifact whose path the safety gate never cleared"
else
  bad "52b — identity refuses an artifact whose path the safety gate never cleared" \
      "expected '1 path-unchecked', got '$NOGATE52'"
fi

# THE PARSE RAN, BUT NOT ON THIS ARTIFACT. The gate cleared this path and a parse
# did happen after it — so the ordering precondition is satisfied — but what that
# parse read was a different file, so the published fields belong to something
# else. This is the state `unvalidated` names, and reaching it takes a parse:
# an artifact with no parse at all stops one check earlier, at `path-unchecked`,
# which is what the assertion above covers. The two are distinguishable, and
# neither stands in for the other.
UNVAL52="$( . "$VAL_LIB" >/dev/null 2>&1
            validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
            validate_terminal_result "$COPY52" >/dev/null 2>&1
            tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
            printf '%s %s\n' "$?" "$tok" )"
if [ "$UNVAL52" = "1 unvalidated" ]; then
  ok "52b — identity refuses an artifact when the parse that ran read a different file"
else
  bad "52b — identity refuses an artifact when the parse that ran read a different file" \
      "expected '1 unvalidated', got '$UNVAL52'"
fi

echo
echo "Case 52c — the boundary reads only what the caller supplied, and changes nothing"

# THE FRAMING CLAIM, asserted rather than assumed: the copied result 52b rejects
# is structurally FLAWLESS. If structure alone could catch it, this whole case
# would be redundant — and this assertion is what would say so.
val_expect "$VAL_LIB" "$COPY52" 0 ok \
  "52c — the copied result is structurally valid, so only identity can reject it"

# READ-ONLY ACROSS THE WHOLE CHECKOUT, on the same argument case 51b makes: the
# claim covers state files, leases, ownership, logs and captures, not just the
# artifact.
BEFORE52="$(tree_manifest "$V52D")"
ident_run "$VAL_LIB" "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
ident_run "$VAL_LIB" "$COPY52" identity-task "$CO52" "$OTHER52" "$ROOT52" >/dev/null 2>&1
AFTER52="$(tree_manifest "$V52D")"
if [ "$BEFORE52" = "$AFTER52" ]; then
  ok "52c — identity validation changes nothing in the checkout"
else
  bad "52c — identity validation changes nothing in the checkout" \
      "$(printf '%s\n' "$BEFORE52" >"$V52/before"; printf '%s\n' "$AFTER52" >"$V52/after"
         diff "$V52/before" "$V52/after" | head -4 | tr '\n' ';')"
fi

# IT DOES NOT GO LOOKING FOR A RESULT. A boundary that could enumerate the
# evidence root could pick its own candidate, which is the consumer behaviour this
# unit excludes. Comments are stripped first, for the reason 51b gives.
IDENT_CODE="$SANDBOX_ROOT/wl2-identity-code.sh"
awk '/^validate_terminal_result_identity\(\)/{f=1} f' "$VAL_LIB" 2>/dev/null |
  sed 's/^[[:space:]]*#.*$//' >"$IDENT_CODE" 2>/dev/null
SCAN_RE='(^|[^[:alnum:]_])(ls|find|glob|shopt)[[:space:]]|\*\.result|\$\(ls|\$\(find'
if [ -s "$IDENT_CODE" ] && ! grep -nE "$SCAN_RE" "$IDENT_CODE" >/dev/null 2>&1; then
  ok "52c — the identity boundary's text contains no directory scan for a candidate result"
else
  bad "52c — the identity boundary's text contains no directory scan for a candidate result" \
      "${IDENT_CODE} empty, or: $(grep -nE "$SCAN_RE" "$IDENT_CODE" 2>/dev/null | head -3 | tr '\n' ';')"
fi

echo
echo "Case 52d — mutation controls: the rejections above go green when the identity check is broken"
MUT52="$SANDBOX_ROOT/mutants52"; mkdir -p "$MUT52"

# M11 — remove the run comparison from the DISPATCHER. Without it the copied
# result presented as another run is accepted, which is precisely the forgery
# 52b's central assertion claims to catch. If 52b passed for any other reason,
# this control would still reject and 52b would not be evidence.
sed "/printf 'run-mismatch/d" "$DISPATCH_BIN" >"$MUT52/m11.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT52/m11.sh"; then
  ok "52d — M11 mutant differs from the dispatcher (the run comparison was found)"
  if extract_validator "$MUT52/m11.sh" "$MUT52/m11.lib"; then
    ident_expect "$MUT52/m11.lib" "$COPY52" identity-task "$CO52" "$OTHER52" "$ROOT52" 0 ok \
      "52d — M11: without the run comparison the copied result is accepted (52b is fail-capable)"
  else
    bad "52d — M11: without the run comparison the copied result is accepted (52b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "52d — M11 mutant differs from the dispatcher (the run comparison was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M12 — remove the symlink refusal. Without it the link is followed to a real,
# structurally valid, field-matching result and ACCEPTED, which is exactly the
# outcome Unit 6 deferred and this unit owns. This control is also what proved the
# fixture above had to point at the matching run: while it pointed elsewhere, the
# mutant still rejected — on the run comparison — and the assertion it was meant
# to underwrite was not evidence.
sed "/printf 'symlinked-path/d" "$DISPATCH_BIN" >"$MUT52/m12.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT52/m12.sh"; then
  ok "52d — M12 mutant differs from the dispatcher (the symlink refusal was found)"
  if extract_validator "$MUT52/m12.sh" "$MUT52/m12.lib"; then
    ident_expect "$MUT52/m12.lib" "$SYM52ROOT/$RID52.result" identity-task "$CO52" "$RID52" "$SYM52ROOT" \
      0 ok "52d — M12: without the symlink refusal the planted link is followed (52b is fail-capable)"
  else
    bad "52d — M12: without the symlink refusal the planted link is followed (52b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "52d — M12 mutant differs from the dispatcher (the symlink refusal was found)" \
      "the sed matched nothing — the control cannot run"
fi

# ==================================================================== case 53
# THE TWO CORRECTION FINDINGS AGAINST UNIT 7, and both are about WHEN a check
# happens rather than whether it exists.
#
# 53a — REFUSED BEFORE READ, not read and rejected afterwards. Unit 7 put the
# symlink and resolved-root refusals in the identity boundary, which runs after
# the structural parse. Every rejection token was correct and the artifact had
# already been opened, sized and read to its end through the hostile path first. A
# reader that has followed a planted link has done the thing the refusal was for,
# and returning the right word afterwards does not undo it.
#
# 53b — THE ACCEPTED FIELDS ARE PINNED TO BYTES, not to a pathname. Unit 7 recorded
# `TR_SOURCE="$f"`, which proves which NAME was parsed and nothing about what is at
# that name now. A structurally valid record could be parsed and then replaced at
# the same promised path by another structurally valid record, and identity would
# still answer from the first one's fields.
#
# HOW "BEFORE" IS OBSERVED, since a token alone cannot say when. The parse is the
# only thing that publishes TR_SOURCE and TR_SHA, so those staying empty after a
# refusal is direct evidence that no parse happened. 53c breaks each check in the
# dispatcher and watches that evidence flip.

echo
echo "Case 53a — an unsafe path is refused BEFORE the artifact is opened"

# The probe returns the token AND what the parse would have published. A refusal
# that reports `symlinked-path` with an empty TR_SOURCE was decided on the name;
# the same token with TR_SOURCE set would mean the bytes were read first and the
# refusal came too late.
gate_probe() { # lib artifact task checkout run root -> "<token>|<TR_SOURCE>|<TR_SHA>"
  ( . "$1" >/dev/null 2>&1 || { printf 'lib-unsourceable||\n'; exit 0; }
    t="$SANDBOX_ROOT/.gate-token"
    validate_terminal_result_path "$2" "$3" "$4" "$5" "$6" >"$t" 2>/dev/null
    if [ "$(cat "$t")" = ok ]; then validate_terminal_result "$2" >"$t" 2>/dev/null; fi
    printf '%s|%s|%s\n' "$(cat "$t")" "${TR_SOURCE:-}" "${TR_SHA:-}" )
}

GATE53="$(gate_probe "$VAL_LIB" "$SYM52ROOT/$RID52.result" identity-task "$CO52" "$RID52" "$SYM52ROOT")"
if [ "$GATE53" = "symlinked-path||" ]; then
  ok "53a — a symlinked promised path is refused with nothing parsed (TR_SOURCE and TR_SHA stay empty)"
else
  bad "53a — a symlinked promised path is refused with nothing parsed (TR_SOURCE and TR_SHA stay empty)" \
      "expected 'symlinked-path||', got '$GATE53'"
fi

GATE53R="$(gate_probe "$VAL_LIB" "$LINKROOT52/$RID52.result" identity-task "$CO52" "$RID52" "$LINKROOT52")"
if [ "$GATE53R" = "outside-evidence-root||" ]; then
  ok "53a — an evidence root that resolves elsewhere is refused with nothing parsed"
else
  bad "53a — an evidence root that resolves elsewhere is refused with nothing parsed" \
      "expected 'outside-evidence-root||', got '$GATE53R'"
fi

# THE POSITIVE HALF, so the two assertions above cannot pass by the probe simply
# never parsing anything. A safe path clears the gate and the parse then publishes
# both values.
GATE53OK="$(gate_probe "$VAL_LIB" "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52")"
case "$GATE53OK" in
  "ok|$REAL52|"?*) ok "53a — a safe path clears the gate and the parse then publishes the snapshot" ;;
  *) bad "53a — a safe path clears the gate and the parse then publishes the snapshot" \
         "expected 'ok|$REAL52|<sha>', got '$GATE53OK'" ;;
esac

# GATING AFTER PARSING IS NOT GATING. Both globals end up naming this artifact, so
# a check that only asked "has the gate cleared this path" would be satisfied —
# while the bytes were read through a path nothing had vetted at the time.
LATE53="$( . "$VAL_LIB" >/dev/null 2>&1
           validate_terminal_result "$REAL52" >/dev/null 2>&1
           validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
           tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
           printf '%s %s\n' "$?" "$tok" )"
if [ "$LATE53" = "1 path-unchecked" ]; then
  ok "53a — parsing first and gating afterwards is refused, not retroactively blessed"
else
  bad "53a — parsing first and gating afterwards is refused, not retroactively blessed" \
      "expected '1 path-unchecked', got '$LATE53'"
fi

echo
echo "Case 53b — acceptance is bound to the validated bytes, not to the pathname"
V53="$SANDBOX_ROOT/v53"; mkdir -p "$V53"

# THE REPLACEMENT CARRIES THE SAME task, checkout AND run, and that is what makes
# this the sharp case. Every field comparison passes on either record, so no
# identity comparison can explain a rejection — only the snapshot binding can. The
# fields that DO differ are the ones a caller would go on to act upon.
SWAP53="$V53/swapped.result"
sed 's|^next_action=.*|next_action=something-else-entirely|' "$REAL52" >"$SWAP53" 2>/dev/null
val_expect "$VAL_LIB" "$SWAP53" 0 ok \
  "53b — the replacement is itself a structurally valid v1 record"
if ! cmp -s "$REAL52" "$SWAP53"; then
  ok "53b — the replacement differs in bytes from the validated result"
else
  bad "53b — the replacement differs in bytes from the validated result" "the sed matched nothing"
fi

# Gate, parse, THEN swap the file at the same promised path, THEN ask identity.
SWAP53RUN="$( . "$VAL_LIB" >/dev/null 2>&1
              cp "$REAL52" "$V53/original.result"
              validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
              validate_terminal_result "$REAL52" >/dev/null 2>&1
              cp "$SWAP53" "$REAL52"
              tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
              rc=$?
              cp "$V53/original.result" "$REAL52"
              printf '%s %s\n' "$rc" "$tok" )"
if [ "$SWAP53RUN" = "1 artifact-changed" ]; then
  ok "53b — a record replaced at the promised path after validation is rejected"
else
  bad "53b — a record replaced at the promised path after validation is rejected" \
      "expected '1 artifact-changed', got '$SWAP53RUN'"
fi

# THE ORIGINAL IS STILL ACCEPTED, so the assertion above is not passing because the
# checkout was left in a state where everything fails.
ident_expect "$VAL_LIB" "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 0 ok \
  "53b — the restored original result is still accepted"

echo
echo "Case 53c — mutation controls: the corrections above go green when each check is broken"
MUT53="$SANDBOX_ROOT/mutants53"; mkdir -p "$MUT53"

# M13 — remove the snapshot comparison. Without it the swapped record is accepted
# from the first parse's stale fields, which is finding 2 exactly as it was
# reported.
sed "/printf 'artifact-changed/d" "$DISPATCH_BIN" >"$MUT53/m13.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT53/m13.sh"; then
  ok "53c — M13 mutant differs from the dispatcher (the snapshot comparison was found)"
  if extract_validator "$MUT53/m13.sh" "$MUT53/m13.lib"; then
    M13="$( . "$MUT53/m13.lib" >/dev/null 2>&1
            cp "$REAL52" "$V53/original.result"
            validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
            validate_terminal_result "$REAL52" >/dev/null 2>&1
            cp "$SWAP53" "$REAL52"
            tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
            rc=$?
            cp "$V53/original.result" "$REAL52"
            printf '%s %s\n' "$rc" "$tok" )"
    if [ "$M13" = "0 ok" ]; then
      ok "53c — M13: without the snapshot comparison the swapped record is accepted (53b is fail-capable)"
    else
      bad "53c — M13: without the snapshot comparison the swapped record is accepted (53b is fail-capable)" \
          "expected '0 ok', got '$M13'"
    fi
  else
    bad "53c — M13: without the snapshot comparison the swapped record is accepted (53b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "53c — M13 mutant differs from the dispatcher (the snapshot comparison was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M14 — remove the ordering precondition. Without it, parsing first and gating
# afterwards is accepted, which is the retroactive blessing 53a refuses.
sed "/printf 'path-unchecked/d" "$DISPATCH_BIN" >"$MUT53/m14.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT53/m14.sh"; then
  ok "53c — M14 mutant differs from the dispatcher (the ordering precondition was found)"
  if extract_validator "$MUT53/m14.sh" "$MUT53/m14.lib"; then
    M14="$( . "$MUT53/m14.lib" >/dev/null 2>&1
            validate_terminal_result "$REAL52" >/dev/null 2>&1
            validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
            tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
            printf '%s %s\n' "$?" "$tok" )"
    if [ "$M14" = "0 ok" ]; then
      ok "53c — M14: without the ordering precondition a late gate is accepted (53a is fail-capable)"
    else
      bad "53c — M14: without the ordering precondition a late gate is accepted (53a is fail-capable)" \
          "expected '0 ok', got '$M14'"
    fi
  else
    bad "53c — M14: without the ordering precondition a late gate is accepted (53a is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "53c — M14 mutant differs from the dispatcher (the ordering precondition was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M15 — remove the gate's symlink refusal. The gate then clears the planted link,
# the parse follows it and publishes a snapshot — which is 53a's "nothing was
# parsed" evidence going the other way, and is exactly the pre-correction
# behaviour finding 1 reported.
sed "/printf 'symlinked-path/d" "$DISPATCH_BIN" >"$MUT53/m15.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT53/m15.sh"; then
  ok "53c — M15 mutant differs from the dispatcher (the gate's symlink refusal was found)"
  if extract_validator "$MUT53/m15.sh" "$MUT53/m15.lib"; then
    M15="$(gate_probe "$MUT53/m15.lib" "$SYM52ROOT/$RID52.result" identity-task "$CO52" "$RID52" "$SYM52ROOT")"
    case "$M15" in
      "ok|$SYM52ROOT/$RID52.result|"?*)
        ok "53c — M15: without the gate's symlink refusal the link is followed and parsed (53a is fail-capable)" ;;
      *)
        bad "53c — M15: without the gate's symlink refusal the link is followed and parsed (53a is fail-capable)" \
            "expected the link to be parsed, got '$M15'" ;;
    esac
  else
    bad "53c — M15: without the gate's symlink refusal the link is followed and parsed (53a is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "53c — M15 mutant differs from the dispatcher (the gate's symlink refusal was found)" \
      "the sed matched nothing — the control cannot run"
fi

# ==================================================================== case 54
# THE TWO RESIDUALS the correction round left on the same findings. Both are the
# same shape as the originals: a check that exists but does not cover the case it
# is supposed to.
#
# 54a — THE READER DID NOT DEFEND ITS OWN READ. The correction put a pre-read gate
# in front of the parser and had identity refuse when the gate had not cleared the
# artifact. But the PARSER still opened, sized, hashed and read anything it was
# handed: it recorded the gate's decision and then ignored it. Nothing stops a
# caller invoking the parser directly, and Unit 6's standalone structural contract
# positively allows it — so the late-refusal defect survived one function over.
#
# 54b — THE SNAPSHOT SAW BYTES, NOT FILES. `TR_SHA` catches a record replaced by a
# DIFFERENT record. It cannot catch a replacement by a byte-identical file, whose
# digest is equal by construction, nor a regular file swapped for a symlink to
# byte-identical content — where both hashes cheerfully follow the link. The frozen
# requirement is content OR file identity, and only content was bound.
#
# THE GATE STAYS OPTIONAL, and that is a boundary rather than an omission. Case 51
# calls the parser with no gate at all on a dozen fixtures, and that is accepted
# Unit 6 behaviour. What 54a fixes is the parser following an UNSAFE path, and a
# gate clearance that names a DIFFERENT artifact; a plain ungated regular file is
# still parsed, exactly as before.

echo
echo "Case 54a — the parser refuses an unsafe path itself, with no gate in front of it"

# Straight at the parser, no gate anywhere. The published snapshot is the witness:
# only the parse sets TR_SOURCE, so an empty one proves the artifact was never read.
parse_probe() { # lib artifact -> "<token>|<TR_SOURCE>"
  ( . "$1" >/dev/null 2>&1 || { printf 'lib-unsourceable|\n'; exit 0; }
    t="$SANDBOX_ROOT/.parse-token"
    validate_terminal_result "$2" >"$t" 2>/dev/null
    printf '%s|%s\n' "$(cat "$t")" "${TR_SOURCE:-}" )
}

PARSE54="$(parse_probe "$VAL_LIB" "$SYM52ROOT/$RID52.result")"
if [ "$PARSE54" = "symlinked-path|" ]; then
  ok "54a — the parser refuses a symlinked artifact before opening it, with nothing published"
else
  bad "54a — the parser refuses a symlinked artifact before opening it, with nothing published" \
      "expected 'symlinked-path|', got '$PARSE54'"
fi

# THE ACCEPTED UNGATED CASE, asserted so the fix above cannot have been made by
# refusing everything the gate did not clear. Case 51 depends on this and so does
# Unit 6's standalone structural contract.
PARSE54OK="$(parse_probe "$VAL_LIB" "$REAL52")"
if [ "$PARSE54OK" = "ok|$REAL52" ]; then
  ok "54a — an ungated regular artifact is still parsed, as Unit 6's standalone contract requires"
else
  bad "54a — an ungated regular artifact is still parsed, as Unit 6's standalone contract requires" \
      "expected 'ok|$REAL52', got '$PARSE54OK'"
fi

# A GATE CLEARANCE FOR SOME OTHER ARTIFACT IS NOT A CLEARANCE FOR THIS ONE.
STALE54="$( . "$VAL_LIB" >/dev/null 2>&1
            validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
            tok="$(validate_terminal_result "$COPY52" 2>/dev/null)"
            printf '%s %s\n' "$?" "$tok" )"
if [ "$STALE54" = "1 path-unchecked" ]; then
  ok "54a — a gate clearance naming a different artifact does not cover this one"
else
  bad "54a — a gate clearance naming a different artifact does not cover this one" \
      "expected '1 path-unchecked', got '$STALE54'"
fi

echo
echo "Case 54b — acceptance is bound to WHICH FILE, not only to which bytes"
V54="$SANDBOX_ROOT/v54"; mkdir -p "$V54"

# A BYTE-IDENTICAL REPLACEMENT, swapped in atomically the way a real one would be.
# Same name, same content, same digest — a different file. The digest cannot see
# this by construction, which is exactly why file identity has to be pinned too.
SWAP54="$( . "$VAL_LIB" >/dev/null 2>&1
           cp "$REAL52" "$V54/keep.result"
           validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
           validate_terminal_result "$REAL52" >/dev/null 2>&1
           cp "$REAL52" "$V54/twin.result"; mv -f "$V54/twin.result" "$REAL52"
           tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
           rc=$?
           cp "$V54/keep.result" "$REAL52"
           printf '%s %s\n' "$rc" "$tok" )"
if [ "$SWAP54" = "1 artifact-replaced" ]; then
  ok "54b — a byte-identical file substituted at the promised path is rejected"
else
  bad "54b — a byte-identical file substituted at the promised path is rejected" \
      "expected '1 artifact-replaced', got '$SWAP54'"
fi

# THE SAME BYTES, REACHED THROUGH A LINK. The gate cleared this name while it was a
# regular file; it is a symlink by the time identity looks. Both digests would
# follow it happily to valid, matching content.
LINK54="$( . "$VAL_LIB" >/dev/null 2>&1
           cp "$REAL52" "$V54/target.result"
           validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
           validate_terminal_result "$REAL52" >/dev/null 2>&1
           cp "$REAL52" "$V54/keep2.result"
           rm -f "$REAL52"; ln -s "$V54/target.result" "$REAL52"
           tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
           rc=$?
           rm -f "$REAL52"; cp "$V54/keep2.result" "$REAL52"
           printf '%s %s\n' "$rc" "$tok" )"
if [ "$LINK54" = "1 symlinked-path" ]; then
  ok "54b — a promised path that became a symlink after the gate is rejected"
else
  bad "54b — a promised path that became a symlink after the gate is rejected" \
      "expected '1 symlinked-path', got '$LINK54'"
fi

# THE UNDISTURBED ARTIFACT IS STILL ACCEPTED, so neither assertion above is passing
# because the fixture was left broken.
ident_expect "$VAL_LIB" "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 0 ok \
  "54b — the untouched original result is still accepted"

echo
echo "Case 54c — mutation controls: the final fixes go green when each binding is broken"
MUT54="$SANDBOX_ROOT/mutants54"; mkdir -p "$MUT54"

# M16 — remove the file-identity comparison. The byte-identical substitute is then
# accepted on its matching digest, which is residual 2 exactly as reported.
sed "/printf 'artifact-replaced/d" "$DISPATCH_BIN" >"$MUT54/m16.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT54/m16.sh"; then
  ok "54c — M16 mutant differs from the dispatcher (the file-identity comparison was found)"
  if extract_validator "$MUT54/m16.sh" "$MUT54/m16.lib"; then
    M16="$( . "$MUT54/m16.lib" >/dev/null 2>&1
            cp "$REAL52" "$V54/keep3.result"
            validate_terminal_result_path "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" >/dev/null 2>&1
            validate_terminal_result "$REAL52" >/dev/null 2>&1
            cp "$REAL52" "$V54/twin3.result"; mv -f "$V54/twin3.result" "$REAL52"
            tok="$(validate_terminal_result_identity "$REAL52" identity-task "$CO52" "$RID52" "$ROOT52" 2>/dev/null)"
            rc=$?
            cp "$V54/keep3.result" "$REAL52"
            printf '%s %s\n' "$rc" "$tok" )"
    if [ "$M16" = "0 ok" ]; then
      ok "54c — M16: without the file-identity binding the byte-identical swap is accepted (54b is fail-capable)"
    else
      bad "54c — M16: without the file-identity binding the byte-identical swap is accepted (54b is fail-capable)" \
          "expected '0 ok', got '$M16'"
    fi
  else
    bad "54c — M16: without the file-identity binding the byte-identical swap is accepted (54b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "54c — M16 mutant differs from the dispatcher (the file-identity comparison was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M17 — remove ONLY the reader's own pre-open refusal. The gate keeps its identical
# refusal, so deleting by token would remove both and prove nothing about which one
# does the work; the trailing marker comment is what makes this control address the
# reader's line alone.
sed "/# reader pre-open path refusal/d" "$DISPATCH_BIN" >"$MUT54/m17.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT54/m17.sh"; then
  ok "54c — M17 mutant differs from the dispatcher (the reader's own refusal was found)"
  if extract_validator "$MUT54/m17.sh" "$MUT54/m17.lib"; then
    M17="$(parse_probe "$MUT54/m17.lib" "$SYM52ROOT/$RID52.result")"
    if [ "$M17" = "ok|$SYM52ROOT/$RID52.result" ]; then
      ok "54c — M17: without the reader's own refusal the parser follows the link again (54a is fail-capable)"
    else
      bad "54c — M17: without the reader's own refusal the parser follows the link again (54a is fail-capable)" \
          "expected 'ok|$SYM52ROOT/$RID52.result', got '$M17'"
    fi
  else
    bad "54c — M17: without the reader's own refusal the parser follows the link again (54a is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "54c — M17 mutant differs from the dispatcher (the reader's own refusal was found)" \
      "the sed matched nothing — the control cannot run"
fi

# ==================================================================== case 55
# THE REAL OPERATOR TERMINAL, which is where the result boundary Units 5-7 built
# finally has to be used rather than merely to exist.
#
# WHAT WAS WRONG. Every nonzero terminal in the D-L families funnels through die()
# and finalizes a run-bound record. The two SUCCESSFUL ends of a loop did not: a
# task that reached `turn: operator` — whether closed or blocked — said its piece
# on screen, released its lease and exited 0 with no terminal result at all. Those
# are the two outcomes an operator most wants durable evidence of, and they were
# the two with none.
#
# COMPLETION AND TAKEOVER ARE NOT THE SAME OUTCOME, and this is the distinction
# the unit exists to make durable. `CLOSED` means the work finished.
# `BLOCKED_OPERATOR` means it stopped and is waiting for a person. Both exit 0
# because neither is a failure, so the exit code cannot tell them apart and a
# record that collapsed them would be actively misleading — 55c is the control
# that would catch exactly that collapse.
#
# THE CLASSIFICATION IS NOT RE-DERIVED HERE. `validate_state()` already asked the
# canonical validator and set ST_CLASS before the loop began; this seam reads that
# and nothing else. No second lifecycle parser, no body-shape inference, no
# reconstruction from state prose, Git or logs.

echo
echo "Case 55a — a loop-mode CLOSED terminal finalizes exactly one truthful completion result"
V55C="$(new_sandbox)"; state_file "$V55C" closed-task operator
CO55C="$(cd "$V55C" && pwd -P)"
run_dispatch "$V55C" closed-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "55a — a CLOSED record is not a failure and still exits 0" "$OUT"
RID55C="$(run_id_of "$OUT")"
ROOT55C="$(cd "$V55C/runs" && pwd -P)"
REAL55C="$ROOT55C/$RID55C.result"

# THE RED THE UNIT BEGINS FROM. Before the seam existed this file was simply not
# there, and everything below it could only report that absence.
if [ -f "$REAL55C" ]; then
  ok "55a — the CLOSED terminal left the promised run-bound result"
else
  bad "55a — the CLOSED terminal left the promised run-bound result" \
      "missing $REAL55C; runs/ holds: $(ls "$ROOT55C" 2>&1 | tr '\n' ' ')"
fi

# EXACTLY ONE, and no half-written temporary left behind.
if [ "$(res_count "$ROOT55C")" = 1 ] && [ "$(part_count "$ROOT55C")" = 0 ]; then
  ok "55a — exactly one finalized result and no leftover partial"
else
  bad "55a — exactly one finalized result and no leftover partial" \
      "results=$(res_count "$ROOT55C") partials=$(part_count "$ROOT55C")"
fi

# It is the accepted boundary that judges it, not this harness reading fields with
# sed — that is the whole point of having shipped a parser and an identity check.
val_expect   "$VAL_LIB" "$REAL55C" 0 ok "55a — the CLOSED result is structurally valid v1"
ident_expect "$VAL_LIB" "$REAL55C" closed-task "$CO55C" "$RID55C" "$ROOT55C" 0 ok \
  "55a — the CLOSED result is identity-valid for this task, checkout, run and promised path"

if [ "$(res_field "$REAL55C" code)" = 0 ] &&
   [ "$(res_field "$REAL55C" state_class)" = CLOSED ] &&
   [ "$(res_field "$REAL55C" result_complete)" = yes ]; then
  ok "55a — it truthfully carries code 0, the canonical CLOSED classification and the sentinel"
else
  bad "55a — it truthfully carries code 0, the canonical CLOSED classification and the sentinel" \
      "code=$(res_field "$REAL55C" code) state_class=$(res_field "$REAL55C" state_class) complete=$(res_field "$REAL55C" result_complete)"
fi

# NOTHING LAUNCHED. The operator terminal is reached before any hop in this
# iteration, and finalizing must not have changed that.
if [ "$(calls "$V55C")" = 0 ] && [ "$(res_field "$REAL55C" actor_launched)" = no ]; then
  ok "55a — no actor launched, and the record says so"
else
  bad "55a — no actor launched, and the record says so" \
      "calls=$(calls "$V55C") actor_launched=$(res_field "$REAL55C" actor_launched)"
fi

echo
echo "Case 55b — a loop-mode BLOCKED_OPERATOR terminal finalizes a DISTINCT takeover result"
V55B="$(new_sandbox)"; state_file "$V55B" blocked-task operator blocked-task blocked
CO55B="$(cd "$V55B" && pwd -P)"
run_dispatch "$V55B" blocked-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "55b — a blocked record is a stop, not a failure, and exits 0" "$OUT"
RID55B="$(run_id_of "$OUT")"
ROOT55B="$(cd "$V55B/runs" && pwd -P)"
REAL55B="$ROOT55B/$RID55B.result"

if [ -f "$REAL55B" ]; then
  ok "55b — the BLOCKED_OPERATOR terminal left the promised run-bound result"
else
  bad "55b — the BLOCKED_OPERATOR terminal left the promised run-bound result" \
      "missing $REAL55B; runs/ holds: $(ls "$ROOT55B" 2>&1 | tr '\n' ' ')"
fi

val_expect   "$VAL_LIB" "$REAL55B" 0 ok "55b — the takeover result is structurally valid v1"
ident_expect "$VAL_LIB" "$REAL55B" blocked-task "$CO55B" "$RID55B" "$ROOT55B" 0 ok \
  "55b — the takeover result is identity-valid for its own run"

if [ "$(res_field "$REAL55B" code)" = 0 ] &&
   [ "$(res_field "$REAL55B" state_class)" = BLOCKED_OPERATOR ]; then
  ok "55b — it truthfully carries code 0 and the canonical BLOCKED_OPERATOR classification"
else
  bad "55b — it truthfully carries code 0 and the canonical BLOCKED_OPERATOR classification" \
      "code=$(res_field "$REAL55B" code) state_class=$(res_field "$REAL55B" state_class)"
fi

echo
echo "Case 55c — completion and takeover cannot collapse into one outcome"
OUT55C="$(res_field "$REAL55C" outcome)";     OUT55B="$(res_field "$REAL55B" outcome)"
NXT55C="$(res_field "$REAL55C" next_action)"; NXT55B="$(res_field "$REAL55B" next_action)"

# Asserted as a DIFFERENCE, not against two hard-coded words. A test that pinned
# the exact strings would go green on a rename that quietly made both the same;
# what matters to an operator reading two records is that they can tell which one
# finished and which one is waiting for them.
if [ -n "$OUT55C" ] && [ -n "$OUT55B" ] && [ "$OUT55C" != "$OUT55B" ]; then
  ok "55c — the two terminals record different outcomes ($OUT55C vs $OUT55B)"
else
  bad "55c — the two terminals record different outcomes" \
      "closed='$OUT55C' blocked='$OUT55B'"
fi
if [ -n "$NXT55C" ] && [ -n "$NXT55B" ] && [ "$NXT55C" != "$NXT55B" ]; then
  ok "55c — the two terminals record different next actions ($NXT55C vs $NXT55B)"
else
  bad "55c — the two terminals record different next actions" \
      "closed='$NXT55C' blocked='$NXT55B'"
fi

# NEITHER IS THE FALLBACK. `UNCLASSIFIED` is what an unmapped code produces, so a
# seam that forgot to map code 0 would still satisfy "they are both non-empty" on
# one of them. This is what separates "mapped" from "merely present".
if [ "$OUT55C" != UNCLASSIFIED ] && [ "$OUT55B" != UNCLASSIFIED ]; then
  ok "55c — neither outcome fell through to the unmapped-code fallback"
else
  bad "55c — neither outcome fell through to the unmapped-code fallback" \
      "closed='$OUT55C' blocked='$OUT55B'"
fi

echo
echo "Case 55d — mutation controls: the terminal seam and its distinction are fail-capable"
MUT55="$SANDBOX_ROOT/mutants55"; mkdir -p "$MUT55"

# M18 — remove the finalization call from the operator block. Before Unit 10 the
# run then exited 0 with no result — the pre-unit behaviour exactly. The consumer
# now stands between that hole and release_lock: the promised result is absent at
# consumption, so the run refuses at 38 and the only record left is die()'s own
# code-38 one. 55a stays fail-capable either way — no code-0 completion with a
# valid completion result can come out of a seam with no finalization in it.
# Addressed by its marker comment: deleting by function name would also remove
# die()'s call and prove something else entirely.
sed "/# operator terminal finalization/d" "$DISPATCH_BIN" >"$MUT55/m18.sh"
chmod +x "$MUT55/m18.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT55/m18.sh" && bash -n "$MUT55/m18.sh" 2>/dev/null; then
  ok "55d — M18 mutant differs from the dispatcher and is valid bash"
  V55M="$(new_sandbox)"; state_file "$V55M" closed-task operator
  OUT="$(bash "$MUT55/m18.sh" --checkout "$V55M" --task closed-task \
        --log-dir "$V55M/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RCM=$?
  RIDM="$(run_id_of "$OUT")"
  if [ "$RCM" -eq 38 ] && [ "$(res_field "$V55M/runs/$RIDM.result" code)" = 38 ]; then
    ok "55d — M18: without the finalization call the consumer refuses the absent result at 38 (55a is fail-capable)"
  else
    bad "55d — M18: without the finalization call the consumer refuses the absent result at 38 (55a is fail-capable)" \
        "rc=$RCM code=$(res_field "$V55M/runs/$RIDM.result" code)"
  fi
else
  bad "55d — M18 mutant differs from the dispatcher and is valid bash" \
      "the sed matched nothing, or the mutant does not parse — the control cannot run"
fi

# M19 — collapse the two classifications onto one outcome. Everything else stays:
# both records are still produced, still valid, still code 0. Only the distinction
# goes, and 55c is what must notice.
sed 's/OPERATOR_TAKEOVER/COMPLETED/' "$DISPATCH_BIN" >"$MUT55/m19.sh"
chmod +x "$MUT55/m19.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT55/m19.sh" && bash -n "$MUT55/m19.sh" 2>/dev/null; then
  ok "55d — M19 mutant differs from the dispatcher and is valid bash"
  V55X="$(new_sandbox)"; state_file "$V55X" closed-task operator
  OUT="$(bash "$MUT55/m19.sh" --checkout "$V55X" --task closed-task \
        --log-dir "$V55X/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"
  RIDX="$(run_id_of "$OUT")"
  V55Y="$(new_sandbox)"; state_file "$V55Y" blocked-task operator blocked-task blocked
  OUT="$(bash "$MUT55/m19.sh" --checkout "$V55Y" --task blocked-task \
        --log-dir "$V55Y/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"
  RIDY="$(run_id_of "$OUT")"
  MX="$(res_field "$V55X/runs/$RIDX.result" outcome)"
  MY="$(res_field "$V55Y/runs/$RIDY.result" outcome)"
  if [ -n "$MX" ] && [ "$MX" = "$MY" ]; then
    ok "55d — M19: with the classifications collapsed both terminals report '$MX' (55c is fail-capable)"
  else
    bad "55d — M19: with the classifications collapsed both terminals report the same outcome (55c is fail-capable)" \
        "closed='$MX' blocked='$MY'"
  fi
else
  bad "55d — M19 mutant differs from the dispatcher and is valid bash" \
      "the sed matched nothing, or the mutant does not parse — the control cannot run"
fi

# M20 — FORCE FINALIZATION TO FAIL, by pointing the operator seam at a finalizer
# that does not exist. This is the fail-closed requirement and it is the one that
# matters most: a run that could not produce its evidence must not be able to
# report success. The exit code must not be 0 and no completion may be claimed.
sed 's/finalize_terminal_result 0 ||/wl2_absent_finalizer 0 ||/' "$DISPATCH_BIN" >"$MUT55/m20.sh"
chmod +x "$MUT55/m20.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT55/m20.sh" && bash -n "$MUT55/m20.sh" 2>/dev/null; then
  ok "55d — M20 mutant differs from the dispatcher and is valid bash"
  V55Z="$(new_sandbox)"; state_file "$V55Z" closed-task operator
  OUT="$(bash "$MUT55/m20.sh" --checkout "$V55Z" --task closed-task \
        --log-dir "$V55Z/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RCZ=$?
  RIDZ="$(run_id_of "$OUT")"
  ZOUT="$(res_field "$V55Z/runs/$RIDZ.result" outcome)"
  # THE SPECIFIC TERMINAL, not merely "not zero". An assertion that only required a
  # nonzero exit would be satisfied by the run failing for some unrelated reason,
  # which is not the claim: the claim is that this exact condition is recognised
  # and reported as itself.
  if [ "$RCZ" -eq 38 ] && [ "$ZOUT" = TERMINAL_UNPROVABLE ]; then
    ok "55d — M20: a finalization that cannot be proven exits 38 and reports TERMINAL_UNPROVABLE, never completion"
  else
    bad "55d — M20: a finalization that cannot be proven exits 38 and reports TERMINAL_UNPROVABLE, never completion" \
        "rc=$RCZ outcome='$ZOUT'"
  fi
  # AND THE OWNERSHIP DECLARATION IS UNTOUCHED. The dispatcher never clears it on
  # any path — that is the actor's move at closure — so a run that failed to prove
  # its terminal cannot have quietly handed the checkout on.
  if [ ! -e "$V55Z/logs/work-loop/.owner" ]; then
    ok "55d — M20: the failed terminal did not clear or forge an ownership declaration"
  else
    bad "55d — M20: the failed terminal did not clear or forge an ownership declaration" \
        "declaration present: $(cat "$V55Z/logs/work-loop/.owner" 2>&1 | tr '\n' ' ')"
  fi
else
  bad "55d — M20 mutant differs from the dispatcher and is valid bash" \
      "the sed matched nothing, or the mutant does not parse — the control cannot run"
fi

echo
echo "Case 55e — a terminal that cannot be proven RETAINS both leases with its truthful cause"
# THE CORRECTION'S FINDING, WHOLE. Exit 38 already refused to claim success, but
# it still RELEASED both run leases — die() releases, and the EXIT trap releases
# again — so the one run whose ending is unproven was also the one run that
# handed its checkout straight to the next dispatcher. Retention is the missing
# half of fail-closed: the leases must survive this process, carry a cause that
# is TRUE (no descendant story — nothing survived a teardown here), and refuse
# the next dispatcher until an operator has looked.
sed 's/finalize_terminal_result 0 ||/wl2_absent_finalizer 0 ||/' "$DISPATCH_BIN" >"$MUT55/m21-force.sh"
chmod +x "$MUT55/m21-force.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT55/m21-force.sh" && bash -n "$MUT55/m21-force.sh" 2>/dev/null; then
  ok "55e — the forcing mutant differs from the dispatcher and is valid bash"
  V55R="$(new_sandbox)"; state_file "$V55R" closed-task operator
  OUT="$(bash "$MUT55/m21-force.sh" --checkout "$V55R" --task closed-task \
        --log-dir "$V55R/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RCR=$?
  TL55="$(task_lock_for "$V55R" closed-task)"; CL55="$(checkout_lock_for "$V55R")"
  expect_rc 38 "$RCR" "55e — the unprovable terminal still exits 38, never 0" "$OUT"
  if [ -d "$TL55" ] && [ -d "$CL55" ]; then
    ok "55e — BOTH owned lease directories survived die() and the EXIT trap"
  else
    bad "55e — BOTH owned lease directories survived die() and the EXIT trap" \
        "task=$([ -d "$TL55" ] && echo present || echo absent) checkout=$([ -d "$CL55" ] && echo present || echo absent)"
  fi
  if grep -q '^PINNED by pid ' "$TL55/survivors" 2>/dev/null &&
     grep -q '^PINNED by pid ' "$CL55/survivors" 2>/dev/null; then
    ok "55e — each retained lease carries the durable pin marker a later run recognises"
  else
    bad "55e — each retained lease carries the durable pin marker" \
        "task: $(head -1 "$TL55/survivors" 2>&1); checkout: $(head -1 "$CL55/survivors" 2>&1)"
  fi
  if grep -q '^terminal result unprovable: ' "$TL55/survivors" 2>/dev/null &&
     ! grep -q '^descendants still running:' "$TL55/survivors" 2>/dev/null &&
     ! grep -q 'descendant of the stopped actor' "$TL55/survivors" 2>/dev/null; then
    ok "55e — the recorded cause is terminal-result unprovability, not an actor-teardown story"
  else
    bad "55e — the recorded cause is terminal-result unprovability, not a teardown story" \
        "$(cat "$TL55/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V55R" closed-task --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "55e — a second dispatcher is refused by the retained lease" "$OUT"

  # M21 — remove ONLY the retention call, by its own marker comment. Forced
  # failure then reverts to the pre-correction behaviour — exit 38 with both
  # leases RELEASED by the EXIT path — which is what proves the retention call
  # is doing the work rather than some other part of the seam.
  sed -e 's/finalize_terminal_result 0 ||/wl2_absent_finalizer 0 ||/' \
      -e '/# operator terminal retention/d' "$DISPATCH_BIN" >"$MUT55/m21.sh"
  chmod +x "$MUT55/m21.sh"
  if ! cmp -s "$MUT55/m21-force.sh" "$MUT55/m21.sh" && bash -n "$MUT55/m21.sh" 2>/dev/null; then
    ok "55e — M21 mutant differs from the forcing mutant and is valid bash"
    V55S="$(new_sandbox)"; state_file "$V55S" closed-task operator
    OUT="$(bash "$MUT55/m21.sh" --checkout "$V55S" --task closed-task \
          --log-dir "$V55S/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RCS=$?
    TL55S="$(task_lock_for "$V55S" closed-task)"; CL55S="$(checkout_lock_for "$V55S")"
    if [ "$RCS" -eq 38 ] && [ ! -d "$TL55S" ] && [ ! -d "$CL55S" ]; then
      ok "55e — M21: without the retention call the EXIT path releases both leases (retention is fail-capable)"
    else
      bad "55e — M21: without the retention call the EXIT path releases both leases" \
          "rc=$RCS task=$([ -d "$TL55S" ] && echo present || echo absent) checkout=$([ -d "$CL55S" ] && echo present || echo absent)"
    fi
  else
    bad "55e — M21 mutant differs from the forcing mutant and is valid bash" \
        "the retention marker was not found, or the mutant does not parse"
  fi
else
  bad "55e — the forcing mutant differs from the dispatcher and is valid bash" \
      "the sed matched nothing, or the mutant does not parse — the case cannot run"
fi

echo
echo "Case 55f — the ordinary operator terminals still finalize once and release normally"
# The other half of the closure check: retention must not leak into the
# successful paths. 55a and 55b each finalized exactly one result above; here
# their leases must be GONE — released, not pinned — so the next run is admitted.
if [ ! -d "$(task_lock_for "$V55C" closed-task)" ] && [ ! -d "$(checkout_lock_for "$V55C")" ]; then
  ok "55f — the CLOSED terminal released both leases once its result existed"
else
  bad "55f — the CLOSED terminal released both leases once its result existed" \
      "task=$([ -d "$(task_lock_for "$V55C" closed-task)" ] && echo present || echo absent) checkout=$([ -d "$(checkout_lock_for "$V55C")" ] && echo present || echo absent)"
fi
if [ ! -d "$(task_lock_for "$V55B" blocked-task)" ] && [ ! -d "$(checkout_lock_for "$V55B")" ]; then
  ok "55f — the BLOCKED_OPERATOR terminal released both leases once its result existed"
else
  bad "55f — the BLOCKED_OPERATOR terminal released both leases once its result existed" \
      "task=$([ -d "$(task_lock_for "$V55B" blocked-task)" ] && echo present || echo absent) checkout=$([ -d "$(checkout_lock_for "$V55B")" ] && echo present || echo absent)"
fi

# ============================== case 56: the operator terminal CONSUMES first
#
# Unit 10. Finalization proves a record was written; it does not prove the record
# at the promised path is the one this run wrote. Before this seam consumed, a
# swap or removal landing between finalize_terminal_result and release_lock — the
# exact window the forcing fixtures below occupy — still exited 0, released both
# leases and admitted the next dispatcher: a lease release bought with evidence
# nothing checked. The consumer composes the three accepted boundaries (path gate,
# structural reader, identity) at the release seam; every refusal takes the
# existing exit-38 retention route with the gate's bounded token as its cause.
#
# THE FIXTURES FORCE, THE DISPATCHER DECIDES — same technique as 55e's forcing
# mutant: awk appends one hostile line after the finalization marker, inside the
# window under test, and everything asserted afterwards is the unmodified seam's
# own behaviour.

echo
echo "Case 56a — valid completion and takeover results pass the consumer and release normally"
# 55a/55b already proved exit 0 and one finalized result each; what is new here is
# that the SAME paths now run through the consumer gate — so a regression that
# refused valid evidence would surface as a 38 here — and that the released lease
# really admits a subsequent dispatcher.
V56A="$(new_sandbox)"; state_file "$V56A" closed-task operator
run_dispatch "$V56A" closed-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "56a — a valid CLOSED result passes the composed consumer and still exits 0" "$OUT"
ROOT56A="$(cd "$V56A/runs" && pwd -P)"
if [ "$(res_count "$ROOT56A")" = 1 ] && [ "$(part_count "$ROOT56A")" = 0 ] &&
   [ "$(ls "$ROOT56A"/*.consume 2>/dev/null | wc -l | tr -d ' ')" = 0 ]; then
  ok "56a — exactly one finalized result, no partial, and no consumer scratch left behind"
else
  bad "56a — exactly one finalized result, no partial, and no consumer scratch left behind" \
      "results=$(res_count "$ROOT56A") partials=$(part_count "$ROOT56A") scratch=$(ls "$ROOT56A"/*.consume 2>&1 | tr '\n' ' ')"
fi
if [ ! -d "$(task_lock_for "$V56A" closed-task)" ] && [ ! -d "$(checkout_lock_for "$V56A")" ]; then
  ok "56a — the accepted CLOSED terminal released both leases"
else
  bad "56a — the accepted CLOSED terminal released both leases" "a lease survived"
fi
run_dispatch "$V56A" closed-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "56a — a subsequent dispatcher is admitted after the verified release" "$OUT"

V56B="$(new_sandbox)"; state_file "$V56B" blocked-task operator blocked-task blocked
run_dispatch "$V56B" blocked-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "56a — a valid BLOCKED_OPERATOR result passes the composed consumer and still exits 0" "$OUT"
if [ ! -d "$(task_lock_for "$V56B" blocked-task)" ] && [ ! -d "$(checkout_lock_for "$V56B")" ]; then
  ok "56a — the accepted takeover terminal released both leases"
else
  bad "56a — the accepted takeover terminal released both leases" "a lease survived"
fi

echo
echo "Case 56b — a wrong-identity result at the promised path is refused BEFORE release"
MUT56="$SANDBOX_ROOT/mutants56"; mkdir -p "$MUT56"
# The unit's red fixture: a structurally flawless record whose run identity is
# another run's, swapped in after successful finalization. Structure cannot see
# it (52c proved that in so many words); only the identity boundary can.
awk '{print} /# operator terminal finalization/ {print "    sed \047s/^run=.*/run=20990101T000000-deadbeef-1-swapped/\047 \"$RESULT_FILE\" >\"$RESULT_FILE.swapped\" && mv -f \"$RESULT_FILE.swapped\" \"$RESULT_FILE\" # harness identity swap"}' \
  "$DISPATCH_BIN" >"$MUT56/swap.sh"
chmod +x "$MUT56/swap.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT56/swap.sh" && bash -n "$MUT56/swap.sh" 2>/dev/null; then
  ok "56b — the swap-forcing fixture differs from the dispatcher and is valid bash"
  V56S="$(new_sandbox)"; state_file "$V56S" closed-task operator
  OUT="$(bash "$MUT56/swap.sh" --checkout "$V56S" --task closed-task \
        --log-dir "$V56S/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC56=$?
  expect_rc 38 "$RC56" "56b — the wrong-identity result is refused with exit 38, never 0" "$OUT"
  # NO COMPLETION IS CLAIMED. The refused artifact is deliberately not advertised
  # as this run's terminal result — that line names the run's own evidence, and
  # this run just proved it has none it can trust.
  out_lacks "  terminal result:" "$OUT" "56b — the refused artifact is not advertised as this run's result"
  TL56="$(task_lock_for "$V56S" closed-task)"; CL56="$(checkout_lock_for "$V56S")"
  if [ -d "$TL56" ] && [ -d "$CL56" ]; then
    ok "56b — BOTH leases survived die() and the EXIT trap"
  else
    bad "56b — BOTH leases survived die() and the EXIT trap" \
        "task=$([ -d "$TL56" ] && echo present || echo absent) checkout=$([ -d "$CL56" ] && echo present || echo absent)"
  fi
  # The truthful cause, with the IDENTITY token — not a finalization story and
  # not a teardown story: the record finalized fine and no descendant survived.
  if grep -q '^terminal result unprovable: ' "$TL56/survivors" 2>/dev/null &&
     grep -q 'run-mismatch' "$TL56/survivors" 2>/dev/null &&
     grep -q 'run-mismatch' "$CL56/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL56/survivors" 2>/dev/null &&
     ! grep -q '^descendants still running:' "$TL56/survivors" 2>/dev/null; then
    ok "56b — both pins carry the bounded identity token as their truthful cause"
  else
    bad "56b — both pins carry the bounded identity token as their truthful cause" \
        "task: $(cat "$TL56/survivors" 2>&1 | tr '\n' '|'); checkout: $(cat "$CL56/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V56S" closed-task --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "56b — the next dispatcher is refused by the retained lease" "$OUT"
else
  bad "56b — the swap-forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

echo
echo "Case 56c — a MISSING promised result is refused the same way"
awk '{print} /# operator terminal finalization/ {print "    rm -f \"$RESULT_FILE\" # harness result removal"}' \
  "$DISPATCH_BIN" >"$MUT56/gone.sh"
chmod +x "$MUT56/gone.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT56/gone.sh" && bash -n "$MUT56/gone.sh" 2>/dev/null; then
  ok "56c — the removal-forcing fixture differs from the dispatcher and is valid bash"
  V56G="$(new_sandbox)"; state_file "$V56G" closed-task operator
  OUT="$(bash "$MUT56/gone.sh" --checkout "$V56G" --task closed-task \
        --log-dir "$V56G/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC56=$?
  expect_rc 38 "$RC56" "56c — a missing promised result is refused with exit 38, never 0" "$OUT"
  TL56G="$(task_lock_for "$V56G" closed-task)"; CL56G="$(checkout_lock_for "$V56G")"
  # `unreadable` is the structural reader's bounded token for a path it cannot
  # open — which is what "missing" is to a reader that never goes looking for
  # substitutes. The gate passes the name; the read refuses; the cause records it.
  if [ -d "$TL56G" ] && [ -d "$CL56G" ] &&
     grep -q '^terminal result unprovable: ' "$TL56G/survivors" 2>/dev/null &&
     grep -q 'unreadable' "$TL56G/survivors" 2>/dev/null; then
    ok "56c — both leases retained, with the bounded missing-result cause recorded"
  else
    bad "56c — both leases retained, with the bounded missing-result cause recorded" \
        "task=$([ -d "$TL56G" ] && echo present || echo absent) checkout=$([ -d "$CL56G" ] && echo present || echo absent) cause: $(cat "$TL56G/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V56G" closed-task --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "56c — the next dispatcher is refused by the retained lease" "$OUT"
else
  bad "56c — the removal-forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

echo
echo "Case 56d — mutation control: remove ONLY the consumer call and the wrong-identity path releases again"
# Addressed by its own marker, exactly like M18/M21: deleting by function name
# would take the definition too and prove something else. With the one call gone,
# the swap that 56b refused must sail through — exit 0, both leases released, the
# next dispatcher admitted — which is what proves the consumer gate alone, not
# some other part of the seam, is doing the refusing.
sed '/# operator terminal consumption/d' "$DISPATCH_BIN" >"$MUT56/noconsume.sh"
awk '{print} /# operator terminal finalization/ {print "    sed \047s/^run=.*/run=20990101T000000-deadbeef-1-swapped/\047 \"$RESULT_FILE\" >\"$RESULT_FILE.swapped\" && mv -f \"$RESULT_FILE.swapped\" \"$RESULT_FILE\" # harness identity swap"}' \
  "$MUT56/noconsume.sh" >"$MUT56/m22.sh"
chmod +x "$MUT56/m22.sh"
if ! cmp -s "$MUT56/swap.sh" "$MUT56/m22.sh" && bash -n "$MUT56/m22.sh" 2>/dev/null; then
  ok "56d — M22 mutant differs from the swap fixture and is valid bash"
  V56M="$(new_sandbox)"; state_file "$V56M" closed-task operator
  OUT="$(bash "$MUT56/m22.sh" --checkout "$V56M" --task closed-task \
        --log-dir "$V56M/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RCM=$?
  TL56M="$(task_lock_for "$V56M" closed-task)"; CL56M="$(checkout_lock_for "$V56M")"
  if [ "$RCM" -eq 0 ] && [ ! -d "$TL56M" ] && [ ! -d "$CL56M" ]; then
    ok "56d — M22: without the consumer call the wrong-identity result exits 0 and releases (56b is fail-capable)"
  else
    bad "56d — M22: without the consumer call the wrong-identity result exits 0 and releases (56b is fail-capable)" \
        "rc=$RCM task=$([ -d "$TL56M" ] && echo present || echo absent) checkout=$([ -d "$CL56M" ] && echo present || echo absent)"
  fi
  run_dispatch "$V56M" closed-task --actor-cmd "$NOOP"
  expect_rc 0 "$RC" "56d — M22: the next dispatcher is admitted after the unverified release" "$OUT"
else
  bad "56d — M22 mutant differs from the swap fixture and is valid bash" \
      "the consumption marker was not found, or the mutant does not parse"
fi

echo
echo "Case 56e — the production composition is the four accepted boundaries, in order, one call each"
# Structural, against the shipped text — the same style as 51a's key-set check.
# The behavioural half lives in 56a-d; this half pins the SHAPE the brief
# requires: gate -> parse -> identity -> meaning, one production call site, no
# second parser and no waiting.
#
# THE FOURTH IS ASSERTED HERE, IN THE COMPOSITION, AND NOWHERE ELSE. It is
# present in this function for every caller; whether a given terminal seam is
# SUBJECT to it depends on that seam supplying an expected pair, which is a
# call-site fact and is asserted at 62c. Reading this assertion as "every
# terminal is now semantically gated" is exactly the overclaim 62c exists to
# prevent — the deferred seams supply no pair and are unchanged.
BODY56="$(sed -n '/^consume_terminal_result()/,/^}/p' "$DISPATCH_BIN")"
N_GATE="$(printf '%s\n' "$BODY56" | grep -c 'validate_terminal_result_path "')"
N_PARSE="$(printf '%s\n' "$BODY56" | grep -c 'validate_terminal_result "')"
N_IDENT="$(printf '%s\n' "$BODY56" | grep -c 'validate_terminal_result_identity "')"
N_SEM="$(printf '%s\n' "$BODY56" | grep -c 'validate_terminal_result_semantics "')"
L_GATE="$(printf '%s\n' "$BODY56" | grep -n 'validate_terminal_result_path "' | cut -d: -f1 | head -1)"
L_PARSE="$(printf '%s\n' "$BODY56" | grep -n 'validate_terminal_result "' | cut -d: -f1 | head -1)"
L_IDENT="$(printf '%s\n' "$BODY56" | grep -n 'validate_terminal_result_identity "' | cut -d: -f1 | head -1)"
L_SEM="$(printf '%s\n' "$BODY56" | grep -n 'validate_terminal_result_semantics "' | cut -d: -f1 | head -1)"
if [ "$N_GATE" = 1 ] && [ "$N_PARSE" = 1 ] && [ "$N_IDENT" = 1 ] && [ "$N_SEM" = 1 ] &&
   [ -n "$L_GATE" ] && [ "$L_GATE" -lt "$L_PARSE" ] && [ "$L_PARSE" -lt "$L_IDENT" ] &&
   [ "$L_IDENT" -lt "$L_SEM" ]; then
  ok "56e — path gate, structural reader, identity and meaning: one call each, in that order"
else
  bad "56e — path gate, structural reader, identity and meaning: one call each, in that order" \
      "gate=$N_GATE@$L_GATE parse=$N_PARSE@$L_PARSE identity=$N_IDENT@$L_IDENT meaning=$N_SEM@$L_SEM"
fi
# THE COMPOSED BOUNDARY OWNS NO MAPPING EITHER. 61c proves the semantic boundary
# itself knows no symbols; this proves the function that now calls it did not
# acquire a second table on the way — the expected pair passes straight through
# from the caller's arguments.
if ! printf '%s\n' "$BODY56" | sed 's/^[[:space:]]*#.*$//' | grep -qE 'COMPLETED|OPERATOR_TAKEOVER|result_outcome'; then
  ok "56e — the consumer carries no outcome symbols and no second code-to-outcome mapping"
else
  bad "56e — the consumer carries no outcome symbols and no second code-to-outcome mapping" \
      "$(printf '%s\n' "$BODY56" | sed 's/^[[:space:]]*#.*$//' | grep -nE 'COMPLETED|OPERATOR_TAKEOVER|result_outcome' | head -3 | tr '\n' ';')"
fi
if [ "$(grep -c '# operator terminal consumption' "$DISPATCH_BIN")" = 1 ]; then
  ok "56e — exactly one production consumer call sits at the operator-terminal seam"
else
  bad "56e — exactly one production consumer call sits at the operator-terminal seam" \
      "marker count: $(grep -c '# operator terminal consumption' "$DISPATCH_BIN")"
fi
if ! printf '%s\n' "$BODY56" | grep -q 'sleep' &&
   ! printf '%s\n' "$BODY56" | grep -q 'ls '; then
  ok "56e — the consumer neither waits nor searches: no sleep, no listing"
else
  bad "56e — the consumer neither waits nor searches: no sleep, no listing" "$BODY56"
fi

# ===================== case 57: the die() funnel honors finalizer failure
#
# Unit 11. Every D–L terminal publishes its result through the one die() funnel,
# which invoked the accepted finalizer and IGNORED its return: a run whose
# publication failed still exited with its original code and released both
# leases — the unproven-ending hole the operator seam closed at Unit 8,
# reachable from every other terminal. The funnel now transfers a failed
# publication to its own unprovability exit: pin both owned leases with the
# truthful finalization-failure cause, exit 38, release nothing.
#
# THE INDUCTION IS RUNTIME, NOT A MUTANT: the actor removes write permission
# from the evidence directory, so the atomic producer cannot create its
# temporary at publication time. Everything asserted afterwards is the
# unmodified funnel's own behaviour on a real failed write.

BREAK_PUBLISH='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; chmod a-w "$WL_CHECKOUT/runs"; exit 0'

echo
echo "Case 57a — a representative D–L terminal still publishes once and releases normally"
# The no-transition terminal (22) — the same representative path 51a produces
# from. The success branch must be byte-for-byte the old behaviour: original
# code, one valid result, normal release, next acquire admitted.
V57A="$(new_sandbox)"; state_file "$V57A" die-task codex
run_dispatch "$V57A" die-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "57a — the no-transition terminal keeps its original code 22" "$OUT"
RID57="$(run_id_of "$OUT")"
ROOT57="$(cd "$V57A/runs" && pwd -P)"
if [ "$(res_count "$ROOT57")" = 1 ] && [ "$(res_field "$ROOT57/$RID57.result" code)" = 22 ]; then
  ok "57a — exactly one finalized result, truthfully carrying code 22"
else
  bad "57a — exactly one finalized result, truthfully carrying code 22" \
      "results=$(res_count "$ROOT57") code=$(res_field "$ROOT57/$RID57.result" code)"
fi
if [ ! -d "$(task_lock_for "$V57A" die-task)" ] && [ ! -d "$(checkout_lock_for "$V57A")" ]; then
  ok "57a — both leases released once the result existed"
else
  bad "57a — both leases released once the result existed" "a lease survived"
fi
run_dispatch "$V57A" die-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "57a — the next dispatcher is admitted after the proven exit" "$OUT"

echo
echo "Case 57b — a FAILED publication transfers to the unprovability exit instead of the original code"
V57B="$(new_sandbox)"; state_file "$V57B" die-task codex
OUT="$(bash "$DISPATCH_BIN" --checkout "$V57B" --task die-task \
      --log-dir "$V57B/runs" --timeout 20 --actor-cmd "$BREAK_PUBLISH" 2>&1)"; RC57=$?
expect_rc 38 "$RC57" "57b — the induced finalizer failure exits 38, not the original 22" "$OUT"
if [ "$(res_count "$V57B/runs")" = 0 ]; then
  ok "57b — no terminal result exists and none is claimed"
else
  bad "57b — no terminal result exists and none is claimed" "results=$(res_count "$V57B/runs")"
fi
out_lacks "  terminal result:" "$OUT" "57b — no terminal result is advertised"
TL57="$(task_lock_for "$V57B" die-task)"; CL57="$(checkout_lock_for "$V57B")"
if [ -d "$TL57" ] && [ -d "$CL57" ]; then
  ok "57b — BOTH owned leases survived die() and the EXIT trap"
else
  bad "57b — BOTH owned leases survived die() and the EXIT trap" \
      "task=$([ -d "$TL57" ] && echo present || echo absent) checkout=$([ -d "$CL57" ] && echo present || echo absent)"
fi
# The truthful cause: a finalization failure, through the one shared lease
# writer — not a teardown story (nothing survived) and not a consumer-refusal
# story (nothing was published to refuse).
if grep -q '^terminal result unprovable: ' "$TL57/survivors" 2>/dev/null &&
   grep -q 'could not finalize' "$TL57/survivors" 2>/dev/null &&
   grep -q 'could not finalize' "$CL57/survivors" 2>/dev/null &&
   ! grep -q 'was refused before release' "$TL57/survivors" 2>/dev/null &&
   ! grep -q '^descendants still running:' "$TL57/survivors" 2>/dev/null; then
  ok "57b — both pins carry the bounded finalization-failure cause"
else
  bad "57b — both pins carry the bounded finalization-failure cause" \
      "task: $(cat "$TL57/survivors" 2>&1 | tr '\n' '|'); checkout: $(cat "$CL57/survivors" 2>&1 | tr '\n' '|')"
fi
chmod u+w "$V57B/runs" 2>/dev/null
run_dispatch "$V57B" die-task --actor-cmd "$NOOP"
expect_rc 17 "$RC" "57b — the next dispatcher is refused by the retained lease" "$OUT"

echo
echo "Case 57c — mutation control: remove ONLY the failure transfer and the unsafe fall-through returns"
MUT57="$SANDBOX_ROOT/mutants57"; mkdir -p "$MUT57"
# Addressed by the transfer's own marker text, replace-not-delete: the finalizer
# call on the same line must survive, or the mutant would prove the absence of
# finalization rather than the absence of the transfer.
sed 's/ || die_funnel_unprovable "$code" # die funnel failure transfer//' "$DISPATCH_BIN" >"$MUT57/m23.sh"
chmod +x "$MUT57/m23.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT57/m23.sh" && bash -n "$MUT57/m23.sh" 2>/dev/null &&
   grep -q 'finalize_terminal_result "$code"' "$MUT57/m23.sh"; then
  ok "57c — M23 mutant differs, parses, and keeps the finalizer call itself"
  V57M="$(new_sandbox)"; state_file "$V57M" die-task codex
  OUT="$(bash "$MUT57/m23.sh" --checkout "$V57M" --task die-task \
        --log-dir "$V57M/runs" --timeout 20 --actor-cmd "$BREAK_PUBLISH" 2>&1)"; RCM=$?
  TL57M="$(task_lock_for "$V57M" die-task)"; CL57M="$(checkout_lock_for "$V57M")"
  if [ "$RCM" -eq 22 ] && [ ! -d "$TL57M" ] && [ ! -d "$CL57M" ]; then
    ok "57c — M23: without the transfer the failed publication exits 22 and releases (57b is fail-capable)"
  else
    bad "57c — M23: without the transfer the failed publication exits 22 and releases (57b is fail-capable)" \
        "rc=$RCM task=$([ -d "$TL57M" ] && echo present || echo absent) checkout=$([ -d "$CL57M" ] && echo present || echo absent)"
  fi
  chmod u+w "$V57M/runs" 2>/dev/null
  run_dispatch "$V57M" die-task --actor-cmd "$NOOP"
  expect_rc 22 "$RC" "57c — M23: the next dispatcher is admitted after the unproven exit" "$OUT"
else
  bad "57c — M23 mutant differs, parses, and keeps the finalizer call itself" \
      "the transfer marker was not found, or the mutant does not parse"
fi

echo
echo "Case 57d — the funnel publishes once and the transfer neither retries nor adds a writer"
# Structural, against the shipped text — 56e's style. The behavioural half is
# 57a-c; this half pins the shape: one finalizer invocation in die(), one
# transfer, one pin call in the transfer, no second attempt and no waiting.
DIE57="$(sed -n '/^die() {/,/^}/p' "$DISPATCH_BIN")"
XFER57="$(sed -n '/^die_funnel_unprovable()/,/^}/p' "$DISPATCH_BIN")"
if [ "$(printf '%s\n' "$DIE57" | grep -c 'finalize_terminal_result ')" = 1 ] &&
   [ "$(grep -c '# die funnel failure transfer' "$DISPATCH_BIN")" = 1 ]; then
  ok "57d — die() invokes the accepted finalizer once, with exactly one failure transfer"
else
  bad "57d — die() invokes the accepted finalizer once, with exactly one failure transfer" \
      "finalize calls: $(printf '%s\n' "$DIE57" | grep -c 'finalize_terminal_result '); markers: $(grep -c '# die funnel failure transfer' "$DISPATCH_BIN")"
fi
if [ "$(printf '%s\n' "$XFER57" | grep -c 'pin_lock_terminal')" = 1 ] &&
   ! printf '%s\n' "$XFER57" | grep -q 'finalize_terminal_result' &&
   ! printf '%s\n' "$XFER57" | grep -q 'sleep' &&
   printf '%s\n' "$XFER57" | grep -q 'exit 38'; then
  ok "57d — the transfer pins once through the shared owner, never re-finalizes, never waits, exits 38"
else
  bad "57d — the transfer pins once through the shared owner, never re-finalizes, never waits, exits 38" "$XFER57"
fi

echo
echo "Case 57e — ALREADY-PINNED leases + failed publication is still observably unprovable (exit 38)"
# The Unit 11 correction's frozen finding: with a teardown cause already pinned,
# a failed publication used to keep its original exit and record the failure
# nowhere — a non-38 terminal indistinguishable from one whose result exists.
# The forcing fixture plants a teardown-style pin at the top of die() (through
# the shared library's own pin writer — no new writer), and the actor makes the
# evidence directory unwritable, so the pinned + failed-finalize conjunction is
# real when the funnel reaches it.
awk '{print} /^die\(\) { # code, message/ {print "  wl_lease_pin \"424242\" \"\" \"die-task\" 2>/dev/null # harness forced teardown pin"}' \
  "$DISPATCH_BIN" >"$MUT57/prepin.sh"
chmod +x "$MUT57/prepin.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT57/prepin.sh" && bash -n "$MUT57/prepin.sh" 2>/dev/null; then
  ok "57e — the pre-pin forcing fixture differs from the dispatcher and is valid bash"
  V57P="$(new_sandbox)"; state_file "$V57P" die-task codex
  OUT="$(bash "$MUT57/prepin.sh" --checkout "$V57P" --task die-task \
        --log-dir "$V57P/runs" --timeout 20 --actor-cmd "$BREAK_PUBLISH" 2>&1)"; RCP=$?
  expect_rc 38 "$RCP" "57e — the already-pinned failed publication exits 38, not the original 22" "$OUT"
  out_has "exiting 38 instead" "$OUT" "57e — the failed publication is recorded on the output channels"
  TL57P="$(task_lock_for "$V57P" die-task)"; CL57P="$(checkout_lock_for "$V57P")"
  # THE STRONGER CAUSE SURVIVES. The teardown pin's survivor-pid evidence must
  # still be the recorded cause — a transfer that re-pinned would have replaced
  # it with the weaker finalization story, which is the half of the old guard
  # that was right and must stay.
  if [ -d "$TL57P" ] && [ -d "$CL57P" ] &&
     grep -q 'descendants still running: 424242' "$TL57P/survivors" 2>/dev/null &&
     ! grep -q '^terminal result unprovable: ' "$TL57P/survivors" 2>/dev/null; then
    ok "57e — both leases stay pinned under the earlier teardown cause, preserved unchanged"
  else
    bad "57e — both leases stay pinned under the earlier teardown cause, preserved unchanged" \
        "task=$([ -d "$TL57P" ] && echo present || echo absent) cause: $(cat "$TL57P/survivors" 2>&1 | tr '\n' '|')"
  fi
  if [ "$(res_count "$V57P/runs")" = 0 ]; then
    ok "57e — no terminal result exists and none is claimed"
  else
    bad "57e — no terminal result exists and none is claimed" "results=$(res_count "$V57P/runs")"
  fi
  chmod u+w "$V57P/runs" 2>/dev/null
  run_dispatch "$V57P" die-task --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "57e — the next dispatcher is refused by the retained lease" "$OUT"

  # M24 — restore ONLY the old early return, by the coverage guard's marker: the
  # pinned conjunction then keeps the original exit again, which is the finding
  # itself and proves this case can fail.
  awk '{print} /# die funnel coverage guard/ {print "  [ \"${WL_LEASE_PINNED:-0}\" -eq 0 ] || return 0 # harness restored early return"}' \
    "$MUT57/prepin.sh" >"$MUT57/m24.sh"
  chmod +x "$MUT57/m24.sh"
  if ! cmp -s "$MUT57/prepin.sh" "$MUT57/m24.sh" && bash -n "$MUT57/m24.sh" 2>/dev/null; then
    ok "57e — M24 mutant differs from the forcing fixture and is valid bash"
    V57Q="$(new_sandbox)"; state_file "$V57Q" die-task codex
    OUT="$(bash "$MUT57/m24.sh" --checkout "$V57Q" --task die-task \
          --log-dir "$V57Q/runs" --timeout 20 --actor-cmd "$BREAK_PUBLISH" 2>&1)"; RCQ=$?
    if [ "$RCQ" -eq 22 ]; then
      ok "57e — M24: with the early return restored the pinned failure exits 22 again (57e is fail-capable)"
    else
      bad "57e — M24: with the early return restored the pinned failure exits 22 again (57e is fail-capable)" \
          "rc=$RCQ"
    fi
    chmod u+w "$V57Q/runs" 2>/dev/null
  else
    bad "57e — M24 mutant differs from the forcing fixture and is valid bash" \
        "the coverage-guard marker was not found, or the mutant does not parse"
  fi
else
  bad "57e — the pre-pin forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

# ===================== case 58: --dry-run finalizes and consumes before release
#
# Unit 12. A dry-run is an ADMITTED run — both leases held, run evidence
# initialized — and it was the last N-family success that released and exited 0
# leaving no run-bound terminal result. It now goes through the same accepted
# boundary as the operator terminal: finalize exactly one truthful no-model
# code-0 record, consume that exact promised artifact (path gate -> one
# structural parse -> expected identity), and only then release. Failure takes
# the accepted exit-38 pin routes unchanged.

echo
echo "Case 58a — a valid admitted --dry-run publishes, consumes, reports, and releases"
V58A="$(new_sandbox)"; state_file "$V58A" dry-task codex
run_dispatch "$V58A" dry-task --dry-run
expect_rc 0 "$RC" "58a — the admitted dry-run still exits 0" "$OUT"
out_has "dry-run: would launch actor 'codex'" "$OUT" "58a — the operator-visible dry-run report is preserved"
if [ "$(calls "$V58A")" = 0 ]; then
  ok "58a — no actor launched"
else
  bad "58a — no actor launched" "calls=$(calls "$V58A")"
fi
RID58="$(run_id_of "$OUT")"
CO58="$(cd "$V58A" && pwd -P)"
ROOT58="$(cd "$V58A/runs" && pwd -P)"
REAL58="$ROOT58/$RID58.result"
if [ "$(res_count "$ROOT58")" = 1 ] && [ "$(part_count "$ROOT58")" = 0 ] &&
   [ "$(ls "$ROOT58"/*.consume 2>/dev/null | wc -l | tr -d ' ')" = 0 ]; then
  ok "58a — exactly one finalized result, no partial, no consumer scratch"
else
  bad "58a — exactly one finalized result, no partial, no consumer scratch" \
      "results=$(res_count "$ROOT58") partials=$(part_count "$ROOT58")"
fi
val_expect   "$VAL_LIB" "$REAL58" 0 ok "58a — the dry-run result is structurally valid v1"
ident_expect "$VAL_LIB" "$REAL58" dry-task "$CO58" "$RID58" "$ROOT58" 0 ok \
  "58a — the dry-run result is identity-valid for this task, checkout, run and promised path"
# TRUTHFUL NO-MODEL FACTS, from the dispatcher's own state: nothing was launched
# and nothing spoke to a model, and the record must say so rather than inherit a
# post-hop story.
if [ "$(res_field "$REAL58" code)" = 0 ] && [ "$(res_field "$REAL58" mode)" = dry-run ] &&
   [ "$(res_field "$REAL58" actor_launched)" = no ] &&
   [ "$(res_field "$REAL58" model_request_started)" = no ] &&
   [ "$(res_field "$REAL58" stage)" = pre-hop ]; then
  ok "58a — the record truthfully carries code 0, mode dry-run, no actor, no model request, pre-hop"
else
  bad "58a — the record truthfully carries code 0, mode dry-run, no actor, no model request, pre-hop" \
      "code=$(res_field "$REAL58" code) mode=$(res_field "$REAL58" mode) launched=$(res_field "$REAL58" actor_launched) model=$(res_field "$REAL58" model_request_started) stage=$(res_field "$REAL58" stage)"
fi
if [ ! -d "$(task_lock_for "$V58A" dry-task)" ] && [ ! -d "$(checkout_lock_for "$V58A")" ]; then
  ok "58a — both leases released once the result was consumed"
else
  bad "58a — both leases released once the result was consumed" "a lease survived"
fi
run_dispatch "$V58A" dry-task --dry-run
expect_rc 0 "$RC" "58a — the next dispatcher is admitted after the verified release" "$OUT"

echo
echo "Case 58b — an unwritable evidence directory is refused BEFORE admission: no lease, no evidence, exit 10"
# WHY THIS CASE CHANGED ITS SUBJECT, and why that is not a weakening. Until the
# 2026-08-18 revision this fixture was the dry-run's PUBLICATION-FAILURE case: it
# expected the run to be admitted, take both leases, fail to write its result and
# exit 38. That expectation was correct under the plan content approved
# 2026-08-16, whose terminal classes owing one durable result included `usage or
# argument refusal`. The revised plan (blob c7857d5f, approved 2026-08-18) DELETED
# that class and moved the evidence location into the admission boundary: "a run
# exists only after argument parsing has supplied syntactically valid task,
# checkout and evidence-location inputs … Such a refusal is not a run terminal
# class and needs no durable result."
#
# So this exact input is now a PRE-ADMISSION refusal, and the case asserts that
# contract instead. The publication-failure invariant it used to carry did not go
# with it — 58g below reaches that branch after admission, which is the only place
# the revised plan still puts it.
#
# THE INPUT IS UNCHANGED ON PURPOSE: an existing directory that refuses new
# entries is the one `check_evidence_location()` branch (`[ -w "$want" ]`) that no
# other case reaches — 63a and 63a(2) both drive the ancestor-not-a-directory
# branch instead. Keeping the fixture keeps that branch covered.
#
# The old `out_lacks "  terminal result:"` assertion is deliberately NOT carried
# forward. It passed under both contracts — an exit-10 refusal advertises nothing
# either way — so it could not fail for the right reason and was proving nothing.
V58B="$(new_sandbox)"; mkdir -p "$V58B/runs"; chmod a-w "$V58B/runs"
state_file "$V58B" dry-task codex
rm -f "$V58B.calls"
LR58B="$(lock_root_for "$V58B")"
HEAD58B="$(git -C "$V58B" rev-parse HEAD)"
TREE58B="$(tree_manifest "$V58B")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$V58B" --task dry-task \
      --log-dir "$V58B/runs" --timeout 20 --dry-run 2>&1)"; RC58=$?
expect_rc 10 "$RC58" "58b — the unwritable evidence directory is refused as usage, never admitted" "$OUT"
out_has "STOP [10]" "$OUT" "58b — the refusal names itself on stderr"
out_has "not writable" "$OUT" "58b — the refusal names writability as the reason"
out_has "$V58B/runs" "$OUT" "58b — the refusal names the location it refused"
# THE PRE-ADMISSION CONTRACT, asserted as the four absences the revised plan
# names: no owner or lease, no evidence, no actor, no mutation.
[ ! -e "$LR58B" ] \
  && ok "58b — no lease was ever acquired: the shared lease root was never created" \
  || bad "58b — no lease was ever acquired: the shared lease root was never created" \
         "$(ls -a "$LR58B" 2>&1 | tr '\n' ' ')"
if [ "$(res_count "$V58B/runs")" = 0 ] && [ "$(part_count "$V58B/runs")" = 0 ] &&
   [ "$(ls -1 "$V58B/runs" 2>/dev/null | wc -l | tr -d ' ')" = 0 ]; then
  ok "58b — it wrote no evidence at all into the location it refused"
else
  bad "58b — it wrote no evidence at all into the location it refused" \
      "$(ls -a "$V58B/runs" 2>&1 | tr '\n' ' ')"
fi
[ "$(calls "$V58B")" = "0" ] \
  && ok "58b — no actor was launched" || bad "58b — no actor was launched" "calls=$(calls "$V58B")"
[ "$(git -C "$V58B" rev-parse HEAD)" = "$HEAD58B" ] \
  && ok "58b — it committed nothing" || bad "58b — it committed nothing" "HEAD moved from $HEAD58B"
[ "$TREE58B" = "$(tree_manifest "$V58B")" ] \
  && ok "58b — every byte of the checkout's working tree is unchanged" \
  || bad "58b — every byte of the checkout's working tree is unchanged" "the tree moved"
# THE SUCCESSOR IS ADMITTED, and this is the half that makes the four absences
# above mean something. A refusal that had quietly half-acquired a lease would
# refuse the next run at 17 for a reason that never existed — which is exactly
# what this case asserted, correctly, under the old contract.
chmod u+w "$V58B/runs" 2>/dev/null
run_dispatch "$V58B" dry-task --dry-run
expect_rc 0 "$RC" "58b — the next dispatcher is admitted: the refusal left no lease behind" "$OUT"

echo
echo "Case 58g — an ADMITTED dry-run whose publication fails pins both leases and exits 38"
# THE INVARIANT 58b USED TO CARRY, at the boundary the revised plan still puts it
# behind. Gate SA requires that "every terminal path after run admission produces
# one durable atomic result", and Change set A's durable ordering requires that a
# lease be released "only after the terminal result exists and teardown is proven
# safe", with uncertain teardown pinning it. The dry-run terminal has its OWN
# finalization call site — `finalize_terminal_result 0 || die_terminal_unprovable
# # dry-run terminal finalization` — so the proof at the other three sites (27s
# interruption, 57b die funnel, 60e carry-one) does not reach it, and 58c's M25
# control deletes the finalizer call TOGETHER WITH its failure handoff, so it
# cannot see the handoff go missing on its own. 58h below is that missing control.
#
# THE INDUCTION IS DETERMINISTIC AND HAS NO ACTOR TO USE. 57b and 60e break
# publication from inside the actor's own command; a dry-run launches nothing, so
# that door does not exist here, and an external chmod raced against the run would
# be a coin toss rather than a case. The one point where test-controlled code runs
# at a FIXED place in an admitted dry-run's control flow is the checkout's own
# ownership helper (dispatch.sh 4047-4049), which the dispatcher invokes after run
# evidence and BOTH leases exist and roughly fifty lines above the seam. Cases 27u
# and 31 already substitute that helper for their own timing; this one substitutes
# it to remove write permission and then hands straight on to the real helper, so
# the ownership answer under test is still the shipped helper's own.
#
# It is COMMITTED in the sandbox, like case 12f's removal, because the tracked
# helper is outside the dispatcher's allowlist and an uncommitted rewrite would be
# a foreign working-tree change rather than a fixture.
V58G="$(new_sandbox)"; state_file "$V58G" dry-fail-task codex
REAL58G="$SANDBOX_ROOT/owner58g-real.sh"
cp "$V58G/logs/scripts/work-loop-owner.sh" "$REAL58G"
cat >"$V58G/logs/scripts/work-loop-owner.sh" <<BREAK58G
#!/bin/bash
chmod a-w "$V58G/runs" 2>/dev/null
exec bash "$REAL58G" "\$@"
BREAK58G
chmod +x "$V58G/logs/scripts/work-loop-owner.sh"
git -C "$V58G" commit -qam "fixture: the evidence directory refuses new entries at the ownership check" >/dev/null 2>&1
if [ -z "$(git -C "$V58G" status --porcelain)" ]; then
  ok "58g — the fixture is committed, so the run sees a clean tree and not a foreign change"
else
  bad "58g — the fixture is committed, so the run sees a clean tree and not a foreign change" \
      "$(git -C "$V58G" status --porcelain | tr '\n' '|')"
fi
OUT="$(bash "$DISPATCH_BIN" --checkout "$V58G" --task dry-fail-task \
      --log-dir "$V58G/runs" --timeout 20 --dry-run 2>&1)"; RC58G=$?
expect_rc 38 "$RC58G" "58g — the unprovable admitted dry-run exits 38, never 0" "$OUT"
out_lacks "  terminal result:" "$OUT" "58g — no terminal result is advertised"
out_has "could not be finalized" "$OUT" \
  "58g — the operator is told the ending could not be proved, not that it ended well"
if [ "$(res_count "$V58G/runs")" = 0 ] && [ "$(part_count "$V58G/runs")" = 0 ]; then
  ok "58g — no result and no half-written partial survive the failed publication"
else
  bad "58g — no result and no half-written partial survive the failed publication" \
      "results=$(res_count "$V58G/runs") partials=$(part_count "$V58G/runs")"
fi
# IT REACHED THE SEAM RATHER THAN A REFUSAL BEFORE IT. Only an ADMITTED run owns
# these, so their presence is what separates this case from 58b above.
TL58G="$(task_lock_for "$V58G" dry-fail-task)"; CL58G="$(checkout_lock_for "$V58G")"
if [ -d "$TL58G" ] && [ -d "$CL58G" ]; then
  ok "58g — both leases were held and survived die() and the EXIT trap"
else
  bad "58g — both leases were held and survived die() and the EXIT trap" \
      "task=$([ -d "$TL58G" ] && echo present || echo absent) checkout=$([ -d "$CL58G" ] && echo present || echo absent)"
fi
# THE CAUSE IS THE DISCRIMINATOR, not the exit code — 57b's distinction exactly.
# Dropping the failure handoff still exits 38, via the consumer gate one line
# below, so a case that asserted only the code could not tell the two apart. The
# finalization story and the consumer-refusal story are different sentences, and
# 58h proves this assertion flips to the other one.
if grep -q '^terminal result unprovable: ' "$TL58G/survivors" 2>/dev/null &&
   grep -q 'could not finalize' "$TL58G/survivors" 2>/dev/null &&
   grep -q 'could not finalize' "$CL58G/survivors" 2>/dev/null &&
   ! grep -q 'was refused before release' "$TL58G/survivors" 2>/dev/null; then
  ok "58g — both pins carry the truthful FINALIZATION-failure cause, not a consumer refusal"
else
  bad "58g — both pins carry the truthful FINALIZATION-failure cause, not a consumer refusal" \
      "task: $(cat "$TL58G/survivors" 2>&1 | tr '\n' '|'); checkout: $(cat "$CL58G/survivors" 2>&1 | tr '\n' '|')"
fi
chmod u+w "$V58G/runs" 2>/dev/null
run_dispatch "$V58G" dry-fail-task --dry-run
expect_rc 17 "$RC" "58g — the next dispatcher is refused by the retained lease" "$OUT"

echo
echo "Case 58h — mutation control: remove ONLY the dry-run failure handoff and the cause stops being true"
MUT58H="$SANDBOX_ROOT/mutants58h"; mkdir -p "$MUT58H"
# REPLACE, NOT DELETE, and only the handoff: `finalize_terminal_result 0` must
# survive on the same line, or the mutant would prove the absence of finalization
# — which is M25's job — instead of the absence of the failure transfer. The
# operator and carry-one seams keep their own handoffs, which is what proves this
# control addresses the dry-run one alone.
sed 's/ || die_terminal_unprovable # dry-run terminal finalization/ # dry-run terminal finalization/' \
  "$DISPATCH_BIN" >"$MUT58H/m30.sh"
chmod +x "$MUT58H/m30.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT58H/m30.sh" && bash -n "$MUT58H/m30.sh" 2>/dev/null &&
   grep -q 'finalize_terminal_result 0 # dry-run terminal finalization' "$MUT58H/m30.sh" &&
   grep -q 'die_terminal_unprovable # operator terminal finalization' "$MUT58H/m30.sh" &&
   grep -q 'die_terminal_unprovable "the carry-one terminal after one carried hop"' "$MUT58H/m30.sh"; then
  ok "58h — M30 mutant differs, parses, keeps the dry-run finalizer call, and leaves the other two seams intact"
  V58H="$(new_sandbox)"; state_file "$V58H" dry-fail-task codex
  REAL58H="$SANDBOX_ROOT/owner58h-real.sh"
  cp "$V58H/logs/scripts/work-loop-owner.sh" "$REAL58H"
  cat >"$V58H/logs/scripts/work-loop-owner.sh" <<BREAK58H
#!/bin/bash
chmod a-w "$V58H/runs" 2>/dev/null
exec bash "$REAL58H" "\$@"
BREAK58H
  chmod +x "$V58H/logs/scripts/work-loop-owner.sh"
  git -C "$V58H" commit -qam "fixture" >/dev/null 2>&1
  OUT="$(bash "$MUT58H/m30.sh" --checkout "$V58H" --task dry-fail-task \
        --log-dir "$V58H/runs" --timeout 20 --dry-run 2>&1)"; RCM=$?
  TL58H="$(task_lock_for "$V58H" dry-fail-task)"
  # WITHOUT THE HANDOFF the run still exits 38 — the consumer gate one line below
  # catches the missing artifact — so the exit code alone proves nothing here.
  # What changes is the sentence the operator and the lease are given: a record
  # that was never written is reported as one that was written and then refused.
  if grep -q 'was refused before release' "$TL58H/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL58H/survivors" 2>/dev/null; then
    ok "58h — M30: the pin now tells the consumer-refusal story instead (58g's cause assertion is fail-capable)"
  else
    bad "58h — M30: the pin now tells the consumer-refusal story instead (58g's cause assertion is fail-capable)" \
        "rc=$RCM cause: $(cat "$TL58H/survivors" 2>&1 | tr '\n' '|')"
  fi
  chmod u+w "$V58H/runs" 2>/dev/null
else
  bad "58h — M30 mutant differs, parses, keeps the dry-run finalizer call, and leaves the other two seams intact" \
      "the dry-run handoff marker was not found, or the mutant does not parse"
fi

echo
echo "Case 58c — mutation control: remove ONLY the dry-run boundary and the result-less release returns"
MUT58="$SANDBOX_ROOT/mutants58"; mkdir -p "$MUT58"
# Both marked lines go, and only them — the operator-terminal seam keeps its own
# markers, which is what proves the two seams are separately fail-capable.
sed -e '/# dry-run terminal finalization/d' -e '/# dry-run terminal consumption/d' \
  "$DISPATCH_BIN" >"$MUT58/m25.sh"
chmod +x "$MUT58/m25.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT58/m25.sh" && bash -n "$MUT58/m25.sh" 2>/dev/null &&
   grep -q '# operator terminal finalization' "$MUT58/m25.sh"; then
  ok "58c — M25 mutant differs, parses, and leaves the operator-terminal seam intact"
  V58M="$(new_sandbox)"; state_file "$V58M" dry-task codex
  OUT="$(bash "$MUT58/m25.sh" --checkout "$V58M" --task dry-task \
        --log-dir "$V58M/runs" --timeout 20 --dry-run 2>&1)"; RCM=$?
  if [ "$RCM" -eq 0 ] && [ "$(res_count "$V58M/runs")" = 0 ] &&
     [ ! -d "$(task_lock_for "$V58M" dry-task)" ]; then
    ok "58c — M25: without the boundary the dry-run releases result-less again (58a is fail-capable)"
  else
    bad "58c — M25: without the boundary the dry-run releases result-less again (58a is fail-capable)" \
        "rc=$RCM results=$(res_count "$V58M/runs") task-lock=$([ -d "$(task_lock_for "$V58M" dry-task)" ] && echo present || echo absent)"
  fi
else
  bad "58c — M25 mutant differs, parses, and leaves the operator-terminal seam intact" \
      "a dry-run marker was not found, or the mutant does not parse"
fi

echo
echo "Case 58e — a dry-run record altered ONLY in outcome, or ONLY in code, is refused before release"
# Unit 28. The seam's second half. 58a-c proved the dry-run publishes and consumes
# the artifact it promised; nothing proved the artifact said what this run
# actually did. Measured on these fixtures before the edit: a record altered to
# `outcome=COMPLETED` — over a preflight that launched no actor and started no
# model request — exited 0, released both leases and was advertised as this run's
# terminal result, and so did one altered to `code=22`. Path, structure and
# identity have nothing to object to; only meaning does.
#
# SAME FORCING TECHNIQUE, SAME WINDOW as 56b and 62b: one altering line injected
# after the dry-run finalization marker, between publication and consumption.
# Everything asserted afterwards is the unmodified seam's own behaviour.
MUT58E="$SANDBOX_ROOT/mutants58e"; mkdir -p "$MUT58E"

mk_dry_alter58() { # outfile sed-script [source] -> 0 when the fixture differs and parses
  awk -v s="$2" '{print} /# dry-run terminal finalization/ {
    printf "  sed %c%s%c \"$RESULT_FILE\" >\"$RESULT_FILE.x\" && mv -f \"$RESULT_FILE.x\" \"$RESULT_FILE\" # harness dry-run alteration\n", 39, s, 39 }' \
    "${3:-$DISPATCH_BIN}" >"$1"
  ! cmp -s "${3:-$DISPATCH_BIN}" "$1" && bash -n "$1" 2>/dev/null
}

# The full refusal contract for one forced dry-run mismatch, asserted exactly as
# 58b asserts the publication failure: exit 38, nothing advertised, both leases
# retained with the bounded token as their cause, next dispatcher refused.
expect_dry_refusal58() { # fixture expected-token label-prefix
  local V O R TL CL
  V="$(new_sandbox)"; state_file "$V" dry-task codex
  O="$(bash "$1" --checkout "$V" --task dry-task --log-dir "$V/runs" --timeout 20 --dry-run 2>&1)"; R=$?
  expect_rc 38 "$R" "$3 — refused with exit 38, never 0" "$O"
  out_lacks "  terminal result:" "$O" "$3 — the refused artifact is not advertised as this run's result"
  # THE REFUSAL NAMES THE TERMINAL IT ACTUALLY REACHED. The shared exit's default
  # sentence belongs to the OPERATOR terminal, and a bare call here inherited it —
  # so this seam told an operator who launched nothing that a loop terminal had
  # been reached. Both halves are asserted: naming the preflight is not enough if
  # the operator-terminal claim is also present somewhere in the output.
  out_has "reached the admitted dry-run preflight terminal" "$O" \
    "$3 — the refusal names the preflight terminal it actually reached"
  out_lacks "reached a real operator terminal" "$O" \
    "$3 — the refusal claims no operator terminal"
  # THE SENTENCE IS TERMINAL-NEUTRAL (Unit 31). One shared clause is read by
  # consumers whose run was ending at code 0 and by consumers whose run was
  # ending at code 28, so it may not assume the ending it interrupted was exit 0
  # — for the interruption that is simply false. Nor may it offer the gate as
  # proof of the artifact's provenance: the gate is the check that FAILED, and
  # calling it "this run's own" reads as though passing it had established
  # ownership. Both halves are asserted here and in 27w, over the two consumers
  # that differ in exactly that intended code.
  out_has "did not pass the consumer gate" "$O" \
    "$3 — the refusal says the promised artifact did not pass the consumer gate"
  out_has "refused as this run's reported ending" "$O" \
    "$3 — the refusal refuses the artifact as this run's reported ending"
  out_lacks "failed this run's own consumer gate" "$O" \
    "$3 — the refusal does not offer the gate as proof of the artifact's provenance"
  out_lacks "refusing to exit 0" "$O" \
    "$3 — the refusal assumes no exit-0 ending"
  TL="$(task_lock_for "$V" dry-task)"; CL="$(checkout_lock_for "$V")"
  # NOT a finalization story, and that distinction is the point: the record
  # published perfectly well. What failed is what it says.
  if [ -d "$TL" ] && [ -d "$CL" ] &&
     grep -q '^terminal result unprovable: ' "$TL/survivors" 2>/dev/null &&
     grep -q "$2" "$TL/survivors" 2>/dev/null &&
     grep -q "$2" "$CL/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL/survivors" 2>/dev/null; then
    ok "$3 — both leases retained, both pins carrying the bounded '$2' cause"
  else
    bad "$3 — both leases retained, both pins carrying the bounded '$2' cause" \
        "task=$([ -d "$TL" ] && echo present || echo absent) checkout=$([ -d "$CL" ] && echo present || echo absent) cause: $(cat "$TL/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V" dry-task --dry-run
  expect_rc 17 "$RC" "$3 — the next dispatcher is refused by the retained lease" "$OUT"
}

if mk_dry_alter58 "$MUT58E/outonly.sh" 's/^outcome=.*/outcome=COMPLETED/'; then
  ok "58e — the outcome-only forcing fixture differs from the dispatcher and is valid bash"
  expect_dry_refusal58 "$MUT58E/outonly.sh" outcome-mismatch \
    "58e — a preflight whose record claims COMPLETED"
else
  bad "58e — the outcome-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi
if mk_dry_alter58 "$MUT58E/codeonly.sh" 's/^code=.*/code=22/'; then
  ok "58e — the code-only forcing fixture differs from the dispatcher and is valid bash"
  expect_dry_refusal58 "$MUT58E/codeonly.sh" code-mismatch \
    "58e — a preflight whose record claims code 22"
else
  bad "58e — the code-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

# THE EXPECTATION IS MODE'S ANSWER, NOT THE TASK'S, and that is what lets ONE
# call cover a preflight over any lifecycle class. 59a already proves the RECORD
# carries DRY_RUN_COMPLETE over active, closed and blocked tasks; this proves the
# seam's EXPECTATION tracks it, by running a real dry-run over each and requiring
# the accepted release. A seam that had derived its expectation from ST_CLASS
# would refuse two of these three.
for t58 in dry-task:codex closed-task:operator blocked-task:operator; do
  T58="${t58%%:*}"; TU58="${t58##*:}"
  V58L="$(new_sandbox)"
  if [ "$T58" = blocked-task ]; then state_file "$V58L" "$T58" "$TU58" "$T58" blocked
  else state_file "$V58L" "$T58" "$TU58"; fi
  run_dispatch "$V58L" "$T58" --dry-run
  R58L="$RC"; RID58L="$(run_id_of "$OUT")"
  if [ "$R58L" -eq 0 ] &&
     [ "$(res_field "$V58L/runs/$RID58L.result" outcome)" = DRY_RUN_COMPLETE ] &&
     [ "$(res_field "$V58L/runs/$RID58L.result" code)" = 0 ] &&
     [ ! -d "$(task_lock_for "$V58L" "$T58")" ]; then
    ok "58e — a real dry-run over $T58 expects and accepts DRY_RUN_COMPLETE/0, and releases"
  else
    bad "58e — a real dry-run over $T58 expects and accepts DRY_RUN_COMPLETE/0, and releases" \
        "rc=$R58L outcome=$(res_field "$V58L/runs/$RID58L.result" outcome) code=$(res_field "$V58L/runs/$RID58L.result" code)"
  fi
done

echo
echo "Case 58f — mutation control: remove ONLY the dry-run expected pair and both mismatches release again"
# M34 — the mirror of M33 one seam over. It strips exactly the two expectation
# arguments from the dry-run call, leaving that call, the path gate, the parse
# and the identity boundary in place, AND leaving the operator terminal's own
# pair untouched — which is what proves the two migrated seams are separately
# fail-capable rather than one shared switch. Fails closed.
sed 's/ "$(result_outcome 0)" 0 # dry-run terminal consumption/ # dry-run terminal consumption/' \
  "$DISPATCH_BIN" >"$MUT58E/m34.sh" 2>/dev/null
M34_HITS="$(grep -c ' "\$(result_outcome 0)" 0 # dry-run terminal consumption' "$DISPATCH_BIN" 2>/dev/null || true)"
M34_LEFT="$(grep -c ' "\$(result_outcome 0)" 0 # dry-run terminal consumption' "$MUT58E/m34.sh" 2>/dev/null || true)"
M34_KEPT="$(grep -c '# dry-run terminal consumption' "$MUT58E/m34.sh" 2>/dev/null || true)"
M34_OTHER="$(grep -c ' "" "\$(result_outcome 0)" 0 # operator terminal consumption' "$MUT58E/m34.sh" 2>/dev/null || true)"
M34_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT58E/m34.sh" || M34_DIFFERS=yes
M34_PARSES=no; bash -n "$MUT58E/m34.sh" 2>/dev/null && M34_PARSES=yes
if [ "$M34_HITS" = 1 ] && [ "$M34_LEFT" = 0 ] && [ "$M34_KEPT" = 1 ] && [ "$M34_OTHER" = 1 ] &&
   [ "$M34_DIFFERS" = yes ] && [ "$M34_PARSES" = yes ]; then
  ok "58f — M34 removed exactly the dry-run pair, kept its consumer call and the operator pair, differs, and parses"
  for f58 in outcome:COMPLETED code:22; do
    FLD58="${f58%%:*}"; VAL58="${f58##*:}"
    if mk_dry_alter58 "$MUT58E/m34-$FLD58.sh" "s/^$FLD58=.*/$FLD58=$VAL58/" "$MUT58E/m34.sh"; then
      V58F="$(new_sandbox)"; state_file "$V58F" dry-task codex
      OUT="$(bash "$MUT58E/m34-$FLD58.sh" --checkout "$V58F" --task dry-task \
            --log-dir "$V58F/runs" --timeout 20 --dry-run 2>&1)"; RCM=$?
      if [ "$RCM" -eq 0 ] && [ ! -d "$(task_lock_for "$V58F" dry-task)" ] &&
         [ ! -d "$(checkout_lock_for "$V58F")" ]; then
        ok "58f — M34: without the expected pair the $FLD58-only mismatch exits 0 and releases (58e is fail-capable)"
      else
        bad "58f — M34: without the expected pair the $FLD58-only mismatch exits 0 and releases (58e is fail-capable)" \
            "rc=$RCM task-lease=$([ -d "$(task_lock_for "$V58F" dry-task)" ] && echo held || echo released)"
      fi
    else
      bad "58f — M34: the $FLD58-only fixture over the mutant differs and parses" \
          "the injection matched nothing, or the fixture does not parse — the control cannot run"
    fi
  done
else
  bad "58f — M34 removed exactly the dry-run pair, kept its consumer call and the operator pair, differs, and parses" \
      "matched=$M34_HITS left=$M34_LEFT kept=$M34_KEPT operator-pair=$M34_OTHER differs=$M34_DIFFERS parses=$M34_PARSES — the control cannot run"
fi

# M35 — the label's own control, and it is separate from M34 on purpose: M34
# proves the semantic REFUSAL is real, this proves the refusal's WORDING is. It
# restores exactly the empty label the bare call used to pass, leaving the
# expected pair and every boundary in place, so the run still refuses with the
# same token and the same retention — and the sentence goes back to claiming a
# real operator terminal was reached over a preflight. Without this, 58e's two
# wording assertions could pass against a message that was never at risk.
sed 's/consume_terminal_result "the admitted dry-run preflight terminal" /consume_terminal_result "" /' \
  "$DISPATCH_BIN" >"$MUT58E/m35.sh" 2>/dev/null
M35_HITS="$(grep -c 'consume_terminal_result "the admitted dry-run preflight terminal" ' "$DISPATCH_BIN" 2>/dev/null || true)"
M35_LEFT="$(grep -c 'consume_terminal_result "the admitted dry-run preflight terminal" ' "$MUT58E/m35.sh" 2>/dev/null || true)"
M35_PAIR="$(grep -c ' "\$(result_outcome 0)" 0 # dry-run terminal consumption' "$MUT58E/m35.sh" 2>/dev/null || true)"
M35_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT58E/m35.sh" || M35_DIFFERS=yes
M35_PARSES=no; bash -n "$MUT58E/m35.sh" 2>/dev/null && M35_PARSES=yes
if [ "$M35_HITS" = 1 ] && [ "$M35_LEFT" = 0 ] && [ "$M35_PAIR" = 1 ] &&
   [ "$M35_DIFFERS" = yes ] && [ "$M35_PARSES" = yes ]; then
  ok "58f — M35 restored the empty label, kept the expected pair, differs, and parses"
  if mk_dry_alter58 "$MUT58E/m35-out.sh" 's/^outcome=.*/outcome=COMPLETED/' "$MUT58E/m35.sh"; then
    V58G="$(new_sandbox)"; state_file "$V58G" dry-task codex
    OUT="$(bash "$MUT58E/m35-out.sh" --checkout "$V58G" --task dry-task \
          --log-dir "$V58G/runs" --timeout 20 --dry-run 2>&1)"; RCM=$?
    if [ "$RCM" -eq 38 ] &&
       printf '%s\n' "$OUT" | grep -q 'reached a real operator terminal' &&
       ! printf '%s\n' "$OUT" | grep -q 'reached the admitted dry-run preflight terminal'; then
      ok "58f — M35: with the empty label the preflight refusal claims an operator terminal again (58e's wording is fail-capable)"
    else
      bad "58f — M35: with the empty label the preflight refusal claims an operator terminal again (58e's wording is fail-capable)" \
          "rc=$RCM message: $(printf '%s\n' "$OUT" | grep -m1 '^STOP')"
    fi
  else
    bad "58f — M35: the outcome-only fixture over the mutant differs and parses" \
        "the injection matched nothing, or the fixture does not parse — the control cannot run"
  fi
else
  bad "58f — M35 restored the empty label, kept the expected pair, differs, and parses" \
      "matched=$M35_HITS left=$M35_LEFT pair=$M35_PAIR differs=$M35_DIFFERS parses=$M35_PARSES — the control cannot run"
fi

# M38 — the SHARED SENTENCE's own control, and the third distinct thing this seam
# can get wrong. M34 proves the semantic refusal is real; M35 proves the terminal
# LABEL is; this proves the rest of the sentence is. It restores exactly the two
# clauses the wording carried before Unit 31 — "failed this run's own consumer
# gate" and "refusing to exit 0" — and changes nothing else: the consumer call,
# its expected pair, the dynamic labels, the bounded token, the pin-first order,
# exit 38 and the recovery paragraph all stay as they are. So the run must still
# refuse exactly as before, while the wording assertions in 58e AND 27w go red.
#
# ONE CONTROL COVERS BOTH CASES because there is one production clause: 27w
# asserts the identical phrases over the code-28 consumer, and a per-case control
# would only re-prove the same line twice. The exit-0 count is asserted at 2 in
# the mutant rather than 1, which is what shows die_terminal_unprovable's own
# separate sentence was left alone and the restored phrase went into this one.
# Fails closed: unless both selectors matched exactly once and the mutant differs
# and parses, the control does not run.
sed -e "s/did not pass the consumer gate/failed this run's own consumer gate/" \
    -e "s/so it is refused as this run's reported ending/refusing to exit 0/" \
  "$DISPATCH_BIN" >"$MUT58E/m38.sh" 2>/dev/null
M38_A="$(grep -cF 'did not pass the consumer gate' "$DISPATCH_BIN" 2>/dev/null || true)"
M38_B="$(grep -cF "so it is refused as this run's reported ending" "$DISPATCH_BIN" 2>/dev/null || true)"
M38_A_LEFT="$(grep -cF 'did not pass the consumer gate' "$MUT58E/m38.sh" 2>/dev/null || true)"
M38_B_LEFT="$(grep -cF "so it is refused as this run's reported ending" "$MUT58E/m38.sh" 2>/dev/null || true)"
M38_OLD="$(grep -cF "failed this run's own consumer gate" "$MUT58E/m38.sh" 2>/dev/null || true)"
M38_ZERO="$(grep -cF 'refusing to exit 0' "$MUT58E/m38.sh" 2>/dev/null || true)"
M38_PAIRS=0
for m38 in operator dry-run carry-one interruption; do
  M38_PAIRS=$((M38_PAIRS + $(grep -cF "# $m38 terminal consumption" "$MUT58E/m38.sh" 2>/dev/null || true)))
done
M38_LABEL="$(grep -cF 'consume_terminal_result "the admitted dry-run preflight terminal" ' "$MUT58E/m38.sh" 2>/dev/null || true)"
M38_RECOVERY="$(grep -cF 'remove or repair the interfering artifact' "$MUT58E/m38.sh" 2>/dev/null || true)"
M38_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT58E/m38.sh" || M38_DIFFERS=yes
M38_PARSES=no; bash -n "$MUT58E/m38.sh" 2>/dev/null && M38_PARSES=yes
if [ "$M38_A" = 1 ] && [ "$M38_B" = 1 ] && [ "$M38_A_LEFT" = 0 ] && [ "$M38_B_LEFT" = 0 ] &&
   [ "$M38_OLD" = 1 ] && [ "$M38_ZERO" = 2 ] && [ "$M38_PAIRS" = 4 ] && [ "$M38_LABEL" = 1 ] &&
   [ "$M38_RECOVERY" = 1 ] && [ "$M38_DIFFERS" = yes ] && [ "$M38_PARSES" = yes ]; then
  ok "58f — M38 restored exactly the former shared clause, left the four consumers, labels, token and recovery text intact, differs, and parses"
  if mk_dry_alter58 "$MUT58E/m38-out.sh" 's/^outcome=.*/outcome=COMPLETED/' "$MUT58E/m38.sh"; then
    V58H="$(new_sandbox)"; state_file "$V58H" dry-task codex
    OUT="$(bash "$MUT58E/m38-out.sh" --checkout "$V58H" --task dry-task \
          --log-dir "$V58H/runs" --timeout 20 --dry-run 2>&1)"; RCM=$?
    # The BEHAVIOURAL half must stay green — that is what makes this a wording
    # control rather than a second copy of M34. Same exit, same retention, same
    # truthful terminal label; only the shared clause moved.
    if [ "$RCM" -eq 38 ] && [ -d "$(task_lock_for "$V58H" dry-task)" ] &&
       [ -d "$(checkout_lock_for "$V58H")" ] &&
       printf '%s\n' "$OUT" | grep -qF 'reached the admitted dry-run preflight terminal' &&
       printf '%s\n' "$OUT" | grep -qF "failed this run's own consumer gate" &&
       printf '%s\n' "$OUT" | grep -qF 'refusing to exit 0' &&
       ! printf '%s\n' "$OUT" | grep -qF 'did not pass the consumer gate' &&
       ! printf '%s\n' "$OUT" | grep -qF "refused as this run's reported ending"; then
      ok "58f — M38: with the former clause restored the refusal still refuses, and the shared sentence claims provenance and an exit-0 ending again (58e's and 27w's wording is fail-capable)"
    else
      bad "58f — M38: with the former clause restored the refusal still refuses, and the shared sentence claims provenance and an exit-0 ending again (58e's and 27w's wording is fail-capable)" \
          "rc=$RCM task-lease=$([ -d "$(task_lock_for "$V58H" dry-task)" ] && echo held || echo released) message: $(printf '%s\n' "$OUT" | grep -m1 '^STOP')"
    fi
  else
    bad "58f — M38: the outcome-only fixture over the mutant differs and parses" \
        "the injection matched nothing, or the fixture does not parse — the control cannot run"
  fi
else
  bad "58f — M38 restored exactly the former shared clause, left the four consumers, labels, token and recovery text intact, differs, and parses" \
      "neutral-a=$M38_A neutral-b=$M38_B left-a=$M38_A_LEFT left-b=$M38_B_LEFT restored=$M38_OLD exit0=$M38_ZERO pairs=$M38_PAIRS label=$M38_LABEL recovery=$M38_RECOVERY differs=$M38_DIFFERS parses=$M38_PARSES — the control cannot run"
fi

echo
echo "Case 58d — the boundary reuses the accepted owners and --status stays read-only"
if [ "$(grep -c '# dry-run terminal finalization' "$DISPATCH_BIN")" = 1 ] &&
   [ "$(grep -c '# dry-run terminal consumption' "$DISPATCH_BIN")" = 1 ]; then
  ok "58d — exactly one dry-run finalization and one dry-run consumption call site"
else
  bad "58d — exactly one dry-run finalization and one dry-run consumption call site" \
      "finalize markers: $(grep -c '# dry-run terminal finalization' "$DISPATCH_BIN"); consume markers: $(grep -c '# dry-run terminal consumption' "$DISPATCH_BIN")"
fi
# Behavioural read-only proof for --status, the same observable the contract
# names: it publishes no terminal result and holds no lease afterwards.
V58S="$(new_sandbox)"; state_file "$V58S" dry-task codex
OUT="$(bash "$DISPATCH_BIN" --checkout "$V58S" --task dry-task \
      --log-dir "$V58S/runs" --timeout 20 --status 2>&1)"; RCS=$?
if [ "$RCS" -eq 0 ] && [ "$(res_count "$V58S/runs" 2>/dev/null)" = 0 ] &&
   [ ! -d "$(task_lock_for "$V58S" dry-task)" ]; then
  ok "58d — --status still exits 0, writes no terminal result, and holds no lease"
else
  bad "58d — --status still exits 0, writes no terminal result, and holds no lease" \
      "rc=$RCS results=$(res_count "$V58S/runs" 2>/dev/null)"
fi

# ============== case 59: a dry-run's code-zero outcome is its own, not the task's
#
# Unit 14. The code-zero vocabulary read the task's lifecycle class first, so one
# terminal class produced three symbols: UNCLASSIFIED over an active task, and —
# worse — COMPLETED over a closed one and OPERATOR_TAKEOVER over a blocked one.
# A preflight that launched nothing wore the symbols of runs that actually
# finished or were actually handed over, and only the separate mode field told
# them apart. Dispatcher-owned MODE is now read first at the same single owner.
#
# THE CLAIM IS SAMENESS ACROSS LIFECYCLE, NOT A HARD-CODED STRING, for the reason
# 55c states one case over: pinning exact words would go green on a rename that
# quietly re-collapsed the classes. The pair is asserted equal across all three
# states, distinct from both loop-terminal pairs, and not the unmapped fallback.

# Reads the record a dry-run leaves, through the run id the dispatcher printed.
dry_pair() { # sandbox task [status] -> "<outcome> <next_action>"
  local d="$1" t="$2" s="${3:-}" r
  if [ -n "$s" ]; then state_file "$d" "$t" operator "$t" "$s"; else state_file "$d" "$t" codex; fi
  run_dispatch "$d" "$t" --dry-run
  r="$d/runs/$(run_id_of "$OUT").result"
  printf '%s %s' "$(res_field "$r" outcome)" "$(res_field "$r" next_action)"
}

echo
echo "Case 59a — one dry-run outcome and next action across active, closed and blocked tasks"
V59A="$(new_sandbox)"; P59A="$(dry_pair "$V59A" dry-active)"
V59C="$(new_sandbox)"; P59C="$(dry_pair "$V59C" dry-closed closed)"
V59B="$(new_sandbox)"; P59B="$(dry_pair "$V59B" dry-blocked blocked)"
if [ -n "$P59A" ] && [ "$P59A" = "$P59C" ] && [ "$P59C" = "$P59B" ]; then
  ok "59a — the same pair on all three lifecycle states ($P59A)"
else
  bad "59a — the same pair on all three lifecycle states" \
      "active='$P59A' closed='$P59C' blocked='$P59B'"
fi
# NOT THE FALLBACK. A mode branch that printed the unmapped symbol would satisfy
# sameness above while classifying nothing — the same "mapped, not merely
# present" distinction 55c draws.
case "$P59A" in
  *UNCLASSIFIED*|*operator-read-run-log*)
    bad "59a — the dry-run pair is a real classification, not the unmapped fallback" "$P59A" ;;
  *) ok "59a — the dry-run pair is a real classification, not the unmapped fallback" ;;
esac

echo
echo "Case 59b — the two real loop terminals keep their accepted meanings"
# The regression half. These are 55a/55b's records, re-read for the two fields
# this unit touched: a mode branch that leaked into live mode would show here.
V59L="$(new_sandbox)"; state_file "$V59L" closed-task operator
run_dispatch "$V59L" closed-task --actor-cmd "$NOOP"
R59L="$V59L/runs/$(run_id_of "$OUT").result"
V59K="$(new_sandbox)"; state_file "$V59K" blocked-task operator blocked-task blocked
run_dispatch "$V59K" blocked-task --actor-cmd "$NOOP"
R59K="$V59K/runs/$(run_id_of "$OUT").result"
if [ "$(res_field "$R59L" outcome)" = COMPLETED ] &&
   [ "$(res_field "$R59L" next_action)" = none-task-closed ]; then
  ok "59b — a real CLOSED terminal still reports COMPLETED / none-task-closed"
else
  bad "59b — a real CLOSED terminal still reports COMPLETED / none-task-closed" \
      "$(res_field "$R59L" outcome) / $(res_field "$R59L" next_action)"
fi
if [ "$(res_field "$R59K" outcome)" = OPERATOR_TAKEOVER ] &&
   [ "$(res_field "$R59K" next_action)" = operator-answer-the-blocking-question ]; then
  ok "59b — a real BLOCKED_OPERATOR terminal still reports OPERATOR_TAKEOVER / its question"
else
  bad "59b — a real BLOCKED_OPERATOR terminal still reports OPERATOR_TAKEOVER / its question" \
      "$(res_field "$R59K" outcome) / $(res_field "$R59K" next_action)"
fi
# And the dry-run pair is neither of theirs — the distinction this unit exists for.
if [ "$P59A" != "COMPLETED none-task-closed" ] &&
   [ "$P59A" != "OPERATOR_TAKEOVER operator-answer-the-blocking-question" ]; then
  ok "59b — the dry-run pair borrows neither loop terminal's meaning"
else
  bad "59b — the dry-run pair borrows neither loop terminal's meaning" "$P59A"
fi

echo
echo "Case 59c — mutation control: remove ONLY the mode-derived branches"
MUT59="$SANDBOX_ROOT/mutants59"; mkdir -p "$MUT59"
# Both mode branches go and nothing else: the lifecycle cases below them are
# untouched, so the mutant reverts to exactly the pre-unit derivation.
sed -e '/dry-run) printf .DRY_RUN_COMPLETE.; return 0 ;;/d' \
    -e '/dry-run) printf .none-dry-run-preflight-complete.; return 0 ;;/d' \
    "$DISPATCH_BIN" >"$MUT59/m26.sh"
chmod +x "$MUT59/m26.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT59/m26.sh" && bash -n "$MUT59/m26.sh" 2>/dev/null; then
  ok "59c — M26 mutant differs from the dispatcher and is valid bash"
  SAVE_BIN="$DISPATCH_BIN"; DISPATCH_BIN="$MUT59/m26.sh"
  V59MA="$(new_sandbox)"; M59A="$(dry_pair "$V59MA" dry-active)"
  V59MC="$(new_sandbox)"; M59C="$(dry_pair "$V59MC" dry-closed closed)"
  DISPATCH_BIN="$SAVE_BIN"
  if [ "$M59A" != "$M59C" ] && [ "$M59C" = "COMPLETED none-task-closed" ]; then
    ok "59c — M26: without the branches the lifecycle-borrowed pairs return (59a is fail-capable)"
  else
    bad "59c — M26: without the branches the lifecycle-borrowed pairs return (59a is fail-capable)" \
        "active='$M59A' closed='$M59C'"
  fi
else
  bad "59c — M26 mutant differs from the dispatcher and is valid bash" \
      "a mode branch was not found, or the mutant does not parse"
fi

# ========= case 60: a carried --carry-one hop publishes its own terminal result
#
# Unit 16. Cases 55 and 58 closed the two pre-hop code-zero terminals; this was
# the remaining one, and it is the only POST-hop terminal in the dispatcher that
# released its lease and exited 0 with nothing on disk. Every nonzero post-hop
# terminal funnels through die() and finalizes; a carried hop — the outcome a
# courier exists to produce — left only prose in the run log.
#
# THE OUTCOME NAMES THE RUN, NOT THE TASK, for exactly the reason case 59 gives
# one seam over. Read through the lifecycle first, a carried hop wore three
# symbols: UNCLASSIFIED when it handed on to an active actor, and — worse —
# COMPLETED or OPERATOR_TAKEOVER when it handed on to the operator, which are the
# full loop's words for a run that drove the task to its end. The task's own
# lifecycle is not lost: state_class and turn_at_terminal are required fields and
# carry it exactly.
#
# NEXT ACTION STAYS SPLIT, because the required action genuinely differs. A hop
# that handed on to an actor needs that actor named; one that handed on to a
# blocked task must still say a person owns an unanswered question. Collapsing
# all four into one completion token would re-hide precisely what code 0 was
# split to protect.
#
# BOTH HALVES OF THE CONDITION ARE LOAD-BEARING. --carry-one over a task that is
# ALREADY operator-terminal carries no hop at all: it reaches the accepted
# pre-hop operator terminal before any actor starts. Keying on the flag alone
# would relabel that as a carried hop, which is why 60c is a control and not a
# courtesy.

# A handback that blocks on the operator. The mirror of FLIP_TO_OPERATOR above:
# that one closes, this one stops for a question, and the two produce the two
# different operator-terminal classes the next-action split turns on.
FLIP_TO_BLOCKED='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      d=$(sed -n "s/^task: //p" "$WL_STATE_FILE" | head -1);
      printf -- "---\ntask: %s\nstatus: blocked\nturn: operator\n---\n\n## Objective and scope\nSandbox fixture for the dispatcher harness. No real work.\n\n## Lane and unit\nStandard. Unit 1 — harness fixture.\n\n## Latest result\nNot started.\n\n## Blocker\nThe fixture actor raised a question the operator owns.\n\n## Next action\nThe operator decides.\n" "$d" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"

# Reads the record a carried hop leaves, through the run id the dispatcher
# printed. Same shape as dry_pair above, one flag over.
carry_pair() { # sandbox task start-turn actor -> "<outcome> <next_action>"
  local d="$1" t="$2" turn="$3" a="$4" r
  state_file "$d" "$t" "$turn"
  run_dispatch "$d" "$t" --carry-one --actor-cmd "$a"
  r="$d/runs/$(run_id_of "$OUT").result"
  printf '%s %s' "$(res_field "$r" outcome)" "$(res_field "$r" next_action)"
}

echo
echo "Case 60a — a validated carried hop publishes, consumes, reports, and releases"
V60A="$(new_sandbox)"; state_file "$V60A" carry-pub claude
run_dispatch "$V60A" carry-pub --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "60a — the carried hop still exits 0" "$OUT"
out_has "carry-one: the turn moved claude -> codex" "$OUT" \
  "60a — the operator-visible carry report is preserved"
RID60="$(run_id_of "$OUT")"
CO60="$(cd "$V60A" && pwd -P)"
ROOT60="$(cd "$V60A/runs" && pwd -P)"
REAL60="$ROOT60/$RID60.result"
# THE TARGETED FAILING CASE. Before this unit the seam released and exited 0 with
# runs/ holding only the hop capture, the process-tree marker and the run log.
if [ -f "$REAL60" ]; then
  ok "60a — a terminal result exists at the run-bound path"
else
  bad "60a — a terminal result exists at the run-bound path" \
      "missing $REAL60; runs/ holds: $(ls "$ROOT60" 2>&1 | tr '\n' ' ')"
fi
if [ "$(res_count "$ROOT60")" = 1 ] && [ "$(part_count "$ROOT60")" = 0 ] &&
   [ "$(ls "$ROOT60"/*.consume 2>/dev/null | wc -l | tr -d ' ')" = 0 ]; then
  ok "60a — exactly one finalized result, no partial, no consumer scratch"
else
  bad "60a — exactly one finalized result, no partial, no consumer scratch" \
      "results=$(res_count "$ROOT60") partials=$(part_count "$ROOT60")"
fi
val_expect   "$VAL_LIB" "$REAL60" 0 ok "60a — the carry-one result is structurally valid v1"
ident_expect "$VAL_LIB" "$REAL60" carry-pub "$CO60" "$RID60" "$ROOT60" 0 ok \
  "60a — the carry-one result is identity-valid for this task, checkout, run and promised path"
# TRUTHFUL POST-HOP FACTS. An actor really ran, so this record must carry the
# post-hop story — the mirror of 58a's no-model assertions.
#
# `actor` IS `none` HERE, AND THAT IS THE FIELD'S OWN MEANING, not a gap this
# case papers over. It names the actor IN FLIGHT, and the hop-over line clears it
# once no process is running — the same line that keeps a signal arriving between
# hops from claiming a process group it could not terminate. What proves an actor
# ran is asserted below instead: post-hop stage, actor_launched, hop 1, and the
# capture path the record names. That this seam is the first terminal to produce
# the pair `actor=none` with `actor_launched=yes` is recorded as a deferral, not
# repaired here: moving the clear would trade this reading for a false one in the
# signal handler, which is an accepted invariant.
if [ "$(res_field "$REAL60" code)" = 0 ] &&
   [ "$(res_field "$REAL60" stage)" = post-hop ] &&
   [ "$(res_field "$REAL60" actor)" = none ] &&
   [ "$(res_field "$REAL60" actor_launched)" = yes ] &&
   [ "$(res_field "$REAL60" hop)" = 1 ] &&
   [ "$(res_field "$REAL60" turn_at_terminal)" = codex ] &&
   [ "$(res_field "$REAL60" state_class)" = ACTIVE_CODEX ]; then
  ok "60a — the record truthfully carries code 0, post-hop, a launched actor, hop 1, and the validated post-hop turn"
else
  bad "60a — the record truthfully carries code 0, post-hop, a launched actor, hop 1, and the validated post-hop turn" \
      "code=$(res_field "$REAL60" code) stage=$(res_field "$REAL60" stage) actor=$(res_field "$REAL60" actor) launched=$(res_field "$REAL60" actor_launched) hop=$(res_field "$REAL60" hop) turn=$(res_field "$REAL60" turn_at_terminal) class=$(res_field "$REAL60" state_class)"
fi
if [ ! -d "$(task_lock_for "$V60A" carry-pub)" ] && [ ! -d "$(checkout_lock_for "$V60A")" ]; then
  ok "60a — both leases released once the result was consumed"
else
  bad "60a — both leases released once the result was consumed" "a lease survived"
fi
run_dispatch "$V60A" carry-pub --dry-run
expect_rc 0 "$RC" "60a — the next dispatcher is admitted after the verified release" "$OUT"

echo
echo "Case 60b — all four reachable carried transitions publish one outcome, with the next action keyed on the validated post-hop class"
V60B1="$(new_sandbox)"; P60B1="$(carry_pair "$V60B1" carry-cc claude "$FLIP")"
V60B2="$(new_sandbox)"; P60B2="$(carry_pair "$V60B2" carry-xc codex  "$FLIP")"
V60B3="$(new_sandbox)"; P60B3="$(carry_pair "$V60B3" carry-cl claude "$FLIP_TO_OPERATOR")"
V60B4="$(new_sandbox)"; P60B4="$(carry_pair "$V60B4" carry-xb codex  "$FLIP_TO_BLOCKED")"
for row in "claude->codex:$P60B1" "codex->claude:$P60B2" \
           "claude->operator/CLOSED:$P60B3" "codex->operator/BLOCKED:$P60B4"; do
  lbl="${row%%:*}"; got="${row#*:}"
  case "$got" in
    "CARRY_ONE_COMPLETE "*) ok "60b — $lbl reports CARRY_ONE_COMPLETE" ;;
    *) bad "60b — $lbl reports CARRY_ONE_COMPLETE" "got: ${got:-<no record>}" ;;
  esac
done
# The next action is the half that must NOT collapse. Four rows, four required
# meanings: two naming the actor that owns the next move, and the two accepted
# operator tokens kept verbatim so a blocked task still announces its question.
if [ "$P60B1" = "CARRY_ONE_COMPLETE operator-carry-turn-to-codex" ] &&
   [ "$P60B2" = "CARRY_ONE_COMPLETE operator-carry-turn-to-claude" ] &&
   [ "$P60B3" = "CARRY_ONE_COMPLETE none-task-closed" ] &&
   [ "$P60B4" = "CARRY_ONE_COMPLETE operator-answer-the-blocking-question" ]; then
  ok "60b — each row's next action names the validated next owner"
else
  bad "60b — each row's next action names the validated next owner" \
      "cc='$P60B1' xc='$P60B2' cl='$P60B3' xb='$P60B4'"
fi
# NOT THE UNMAPPED FALLBACK, the same "mapped, not merely present" distinction
# 55c and 59a draw: a branch printing the catch-all would satisfy a laxer check.
case "$P60B1$P60B2" in
  *UNCLASSIFIED*|*operator-read-run-log*)
    bad "60b — the carried rows are real classifications, not the unmapped fallback" "$P60B1 / $P60B2" ;;
  *) ok "60b — the carried rows are real classifications, not the unmapped fallback" ;;
esac

echo
echo "Case 60c — the carry-one classification does not over-fire"
# THE CONTROL THAT JUSTIFIES THE SECOND HALF OF THE CONDITION. --carry-one over a
# task already at an operator terminal carries nothing: it stops pre-hop, and it
# must keep the accepted loop-terminal meaning rather than claim a hop it never ran.
V60C="$(new_sandbox)"; state_file "$V60C" carry-already operator
run_dispatch "$V60C" carry-already --carry-one --actor-cmd "$FLIP"
R60C="$V60C/runs/$(run_id_of "$OUT").result"
if [ "$(calls "$V60C")" = 0 ] &&
   [ "$(res_field "$R60C" outcome)" = COMPLETED ] &&
   [ "$(res_field "$R60C" next_action)" = none-task-closed ] &&
   [ "$(res_field "$R60C" stage)" = pre-hop ] &&
   [ "$(res_field "$R60C" actor_launched)" = no ]; then
  ok "60c — --carry-one with no hop to carry keeps the pre-hop operator terminal"
else
  bad "60c — --carry-one with no hop to carry keeps the pre-hop operator terminal" \
      "calls=$(calls "$V60C") outcome=$(res_field "$R60C" outcome) next=$(res_field "$R60C" next_action) stage=$(res_field "$R60C" stage) launched=$(res_field "$R60C" actor_launched)"
fi
# And the dry-run branch still wins over the carry-one one — case 26 launches
# nothing, so there is no carried hop for this unit to claim.
V60D="$(new_sandbox)"; state_file "$V60D" carry-dry codex
run_dispatch "$V60D" carry-dry --carry-one --dry-run
R60D="$V60D/runs/$(run_id_of "$OUT").result"
if [ "$(calls "$V60D")" = 0 ] &&
   [ "$(res_field "$R60D" outcome)" = DRY_RUN_COMPLETE ] &&
   [ "$(res_field "$R60D" next_action)" = none-dry-run-preflight-complete ]; then
  ok "60c — --carry-one --dry-run still reports the accepted dry-run terminal (Unit 14 unchanged)"
else
  bad "60c — --carry-one --dry-run still reports the accepted dry-run terminal (Unit 14 unchanged)" \
      "calls=$(calls "$V60D") outcome=$(res_field "$R60D" outcome) next=$(res_field "$R60D" next_action)"
fi

echo
echo "Case 60e — a carried hop whose publication FAILS pins both leases and exits 38, naming its own terminal"
# Induced AFTER the hop, by the actor itself: it hands the turn on and then makes
# the evidence directory refuse new entries, so the run log stays appendable and
# only the producer's temporary cannot be created. A codex actor, so no commit and
# no permission-denial probe stands between the hop and the seam under test.
V60E="$(new_sandbox)"; state_file "$V60E" carry-fail codex
run_dispatch "$V60E" carry-fail --carry-one \
  --actor-cmd "$FLIP_BODY"'; chmod a-w "$WL_CHECKOUT/runs"'
expect_rc 38 "$RC" "60e — the unprovable carried hop exits 38, never 0" "$OUT"
out_lacks "  terminal result:" "$OUT" "60e — no terminal result is advertised"
# FINDING F1. The accepted fail-closed exit hardcoded "a real operator terminal",
# which is false here: this run carried a hop between two actors. The wording has
# to name the terminal it actually reached, and the operator seam's own default
# has to be untouched — 55d and 58b assert that half.
out_lacks "reached a real operator terminal" "$OUT" \
  "60e — the failure does not falsely claim an operator terminal"
out_has "carry-one terminal" "$OUT" \
  "60e — the failure names the carry-one terminal it actually reached"
TL60="$(task_lock_for "$V60E" carry-fail)"; CL60="$(checkout_lock_for "$V60E")"
if [ -d "$TL60" ] && [ -d "$CL60" ] &&
   grep -q '^terminal result unprovable: ' "$TL60/survivors" 2>/dev/null &&
   grep -q 'could not finalize' "$TL60/survivors" 2>/dev/null; then
  ok "60e — both leases retained with the truthful finalization-failure cause"
else
  bad "60e — both leases retained with the truthful finalization-failure cause" \
      "task=$([ -d "$TL60" ] && echo present || echo absent) checkout=$([ -d "$CL60" ] && echo present || echo absent) cause: $(cat "$TL60/survivors" 2>&1 | tr '\n' '|')"
fi
chmod u+w "$V60E/runs" 2>/dev/null
run_dispatch "$V60E" carry-fail --dry-run
expect_rc 17 "$RC" "60e — the next dispatcher is refused by the retained lease" "$OUT"

echo
echo "Case 60f — mutation control: remove ONLY the carry-one vocabulary branches"
MUT60="$SANDBOX_ROOT/mutants60"; mkdir -p "$MUT60"
# Addressed by their own markers, exactly like M25/M26. The lifecycle cases below
# them are untouched, so the mutant reverts to the pre-unit derivation and nothing
# else: the seam that publishes the record stays in place, which is what makes
# this a control on the VOCABULARY rather than on the boundary.
sed -e '/# carry-one code-zero outcome/d' -e '/# carry-one code-zero next action/d' \
  "$DISPATCH_BIN" >"$MUT60/m27.sh"
chmod +x "$MUT60/m27.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT60/m27.sh" && bash -n "$MUT60/m27.sh" 2>/dev/null &&
   grep -q '# carry-one terminal finalization' "$MUT60/m27.sh"; then
  ok "60f — M27 mutant differs, parses, and leaves the carry-one publication seam intact"
  # ALL FOUR ROWS, because all four are what 60b asserts. A control covering two
  # of them leaves the other two proven by nothing: the ACTIVE_CLAUDE fallback and
  # the BLOCKED_OPERATOR borrow are separate branches of the pre-unit derivation,
  # and a mutant that only ever reaches ACTIVE_CODEX and CLOSED would stay green
  # with either of them wired wrong. Each row is asserted on its own so a failure
  # names which one, and the four expectations are exactly the pre-unit behaviour:
  # both active classes fall through to the unmapped pair, and the two operator
  # classes borrow the loop terminals 60b proves they no longer wear.
  SAVE60="$DISPATCH_BIN"; DISPATCH_BIN="$MUT60/m27.sh"
  V60M1="$(new_sandbox)"; M60A="$(carry_pair "$V60M1" carry-cc claude "$FLIP")"
  V60M2="$(new_sandbox)"; M60B="$(carry_pair "$V60M2" carry-xc codex  "$FLIP")"
  V60M3="$(new_sandbox)"; M60C="$(carry_pair "$V60M3" carry-cl claude "$FLIP_TO_OPERATOR")"
  V60M4="$(new_sandbox)"; M60D="$(carry_pair "$V60M4" carry-xb codex  "$FLIP_TO_BLOCKED")"
  DISPATCH_BIN="$SAVE60"
  for mrow in "claude->codex/ACTIVE_CODEX:$M60A:UNCLASSIFIED operator-read-run-log" \
              "codex->claude/ACTIVE_CLAUDE:$M60B:UNCLASSIFIED operator-read-run-log" \
              "claude->operator/CLOSED:$M60C:COMPLETED none-task-closed" \
              "codex->operator/BLOCKED:$M60D:OPERATOR_TAKEOVER operator-answer-the-blocking-question"; do
    mlbl="${mrow%%:*}"; mrest="${mrow#*:}"; mgot="${mrest%%:*}"; mwant="${mrest#*:}"
    [ "$mgot" = "$mwant" ] \
      && ok "60f — M27: $mlbl falls back to '$mwant' without the branches" \
      || bad "60f — M27: $mlbl falls back to '$mwant' without the branches" "got: ${mgot:-<no record>}"
  done
  # And the mutant's four rows are not all the same value — the pre-unit defect
  # was precisely that ONE terminal class produced several symbols, so a control
  # in which they had collapsed would be measuring something else.
  if [ "$M60A" != "$M60C" ] && [ "$M60C" != "$M60D" ]; then
    ok "60f — M27: the mutant splits one terminal class across lifecycle symbols again (60b is fail-capable)"
  else
    bad "60f — M27: the mutant splits one terminal class across lifecycle symbols again (60b is fail-capable)" \
        "cc='$M60A' xc='$M60B' cl='$M60C' xb='$M60D'"
  fi
else
  bad "60f — M27 mutant differs, parses, and leaves the carry-one publication seam intact" \
      "a carry-one marker was not found, or the mutant does not parse"
fi

echo
echo "Case 60g — the seam reuses the accepted owners, one call site each"
for m in 'carry-one terminal finalization' 'carry-one terminal consumption' \
         'carry-one code-zero outcome' 'carry-one code-zero next action'; do
  n="$(grep -c "# $m" "$DISPATCH_BIN")"
  [ "$n" = 1 ] && ok "60g — exactly one '$m' site" \
                || bad "60g — exactly one '$m' site" "found $n"
done
# The seams closed by units 8, 12 and 14 keep their own markers: four separately
# addressable boundaries, which is what makes each one separately fail-capable.
if [ "$(grep -c '# operator terminal finalization' "$DISPATCH_BIN")" = 1 ] &&
   [ "$(grep -c '# dry-run terminal finalization' "$DISPATCH_BIN")" = 1 ]; then
  ok "60g — the operator and dry-run seams are untouched and still separately addressable"
else
  bad "60g — the operator and dry-run seams are untouched and still separately addressable" \
      "operator: $(grep -c '# operator terminal finalization' "$DISPATCH_BIN"); dry-run: $(grep -c '# dry-run terminal finalization' "$DISPATCH_BIN")"
fi

# ========= case 60h: the requested permission mode survives to a carried terminal
#
# Unit 19. `permission_mode_requested` was produced from CUR_ACTOR, and the
# hop-over line clears CUR_ACTOR between the transition table and the --carry-one
# block. Every FAILURE terminal finalizes ABOVE that clear and reported `default`;
# the one SUCCESSFUL post-hop terminal finalizes BELOW it and reported `none` —
# "no permission mode was requested" about a launch whose argv carried
# `--permission-mode default`, which case 31b asserts reaches the child verbatim.
#
# LIVE, NOT SIMULATED, and that distinction is the whole case. --actor-cmd sets
# MODE=live -> simulated, which the producer's SECOND guard already answers `none`
# at, so a simulated row cannot tell the defect from correct behaviour. A fake
# claude BINARY keeps MODE=live and forks a real child while contacting no model —
# the technique cases 31 and 32 already use for the argv assertions.
#
# THE FOUR ROWS ARE NOT REDUNDANT. Each one is answered by a DIFFERENT guard in
# result_permission_mode_requested(), so a repair that collapsed the function to a
# constant would be caught by whichever row it stopped answering: the live codex
# row by the actor guard, the simulated row by the mode guard, the unattended row
# by the contained-profile guard, and the pre-fork row by the fork guard.
echo
echo "Case 60h — a carried live attended Claude terminal reports the mode it actually requested"

# Stands in for the claude binary on the LIVE branch: answers --version, hands the
# turn on, commits. It contacts nothing — a real fork is the point, not a model.
#
# THE VERSION IS NOT DECORATION. --unattended is gated on claude >= 2.1.219 and
# refuses at 31 below it, which is a PRE-fork stop: a double reporting 0.0.0 would
# make row 4 assert `none` about a launch that never happened, and pass for the
# wrong reason. Same value case 32 uses, for the same gate.
FAKE60H="$SANDBOX_ROOT/fake-claude-60h.sh"
cat >"$FAKE60H" <<'F60HEOF'
#!/bin/bash
if [ "${1:-}" = "--version" ]; then echo "2.1.220 (Claude Code)"; exit 0; fi
sf="$WL60H_SF"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
git -C "$WL60H_CO" add "$sf" >/dev/null 2>&1
git -C "$WL60H_CO" commit -qm "fake claude hop" >/dev/null 2>&1
exit 0
F60HEOF
chmod +x "$FAKE60H"

# The same double, refusing to move the file at all. It drives the FAILURE
# terminal that finalizes above the hop-over clear (22, no observable transition),
# which is the row that must NOT change: it already reported the requested mode
# truthfully, and a repair that moved the clear instead of preserving the fact
# would break it.
FAKE60HN="$SANDBOX_ROOT/fake-claude-60h-noop.sh"
cat >"$FAKE60HN" <<'F60HNEOF'
#!/bin/bash
if [ "${1:-}" = "--version" ]; then echo "2.1.220 (Claude Code)"; exit 0; fi
exit 0
F60HNEOF
chmod +x "$FAKE60HN"

# The codex mirror. NO COMMIT: Codex never runs git (core § 4), and the post-hop
# guard dies 24 on a codex hop that moved HEAD.
FAKE60HX="$SANDBOX_ROOT/fake-codex-60h.sh"
cat >"$FAKE60HX" <<'F60HXEOF'
#!/bin/bash
if [ "${1:-}" = "--version" ]; then echo "0.0.0-fake-codex (test double)"; exit 0; fi
sf="$WL60H_SF"
awk '/^turn: /&&!d{print "turn: claude"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
exit 0
F60HXEOF
chmod +x "$FAKE60HX"

# --- row 1: THE TARGETED FAILING ROW ----------------------------------------
V60H="$(new_sandbox)"; state_file "$V60H" carry-perm claude
export WL60H_SF="$V60H/logs/work-loop/carry-perm.md"
export WL60H_CO="$V60H"
OUT="$(bash "$DISPATCH_BIN" --checkout "$V60H" --task carry-perm --log-dir "$V60H/runs" \
      --carry-one --claude-bin "$FAKE60H" 2>&1)"; RC=$?
expect_rc 0 "$RC" "60h — the live attended Claude hop is carried" "$OUT"
R60H="$V60H/runs/$(run_id_of "$OUT").result"
[ -f "$R60H" ] && ok "60h — the carried terminal finalized a result" \
              || bad "60h — the carried terminal finalized a result" \
                     "missing $R60H; runs/ holds: $(ls "$V60H/runs" 2>&1 | tr '\n' ' ')"
# The preconditions, asserted separately from the field under test so a row that
# never reached the live branch cannot pass by reporting the right token for the
# wrong reason.
if [ "$(res_field "$R60H" mode)" = live ] &&
   [ "$(res_field "$R60H" outcome)" = CARRY_ONE_COMPLETE ] &&
   [ "$(res_field "$R60H" stage)" = post-hop ] &&
   [ "$(res_field "$R60H" actor_launched)" = yes ] &&
   [ "$(res_field "$R60H" hop)" = 1 ] &&
   [ "$(res_field "$R60H" turn_at_terminal)" = codex ]; then
  ok "60h — the row really is a live, carried, post-hop Claude terminal"
else
  bad "60h — the row really is a live, carried, post-hop Claude terminal" \
      "mode=$(res_field "$R60H" mode) outcome=$(res_field "$R60H" outcome) stage=$(res_field "$R60H" stage) launched=$(res_field "$R60H" actor_launched) hop=$(res_field "$R60H" hop) turn=$(res_field "$R60H" turn_at_terminal)"
fi
[ "$(res_field "$R60H" permission_mode_requested)" = default ] \
  && ok "60h — the carried terminal reports the requested mode: default" \
  || bad "60h — the carried terminal reports the requested mode: default" \
         "got: $(res_field "$R60H" permission_mode_requested) — the launch argv carried --permission-mode default (case 31b)"
# ACCEPTED SEMANTICS, PRESERVED. `actor` names the actor IN FLIGHT and the
# hop-over clear is what makes `none` true here (60a). The repair must preserve
# the launch fact WITHOUT reinstating an in-flight actor that no longer exists.
[ "$(res_field "$R60H" actor)" = none ] \
  && ok "60h — and actor stays none: no process is in flight at the carried terminal" \
  || bad "60h — and actor stays none" "got: $(res_field "$R60H" actor)"
# Requested is never promoted to effective. Nothing here reads the child's own
# system/init event, so the effective mode stays the bounded unavailable token.
[ "$(res_field "$R60H" permission_mode_effective)" = unavailable ] \
  && ok "60h — the effective mode is still unavailable, not derived from the request" \
  || bad "60h — the effective mode is still unavailable" "got: $(res_field "$R60H" permission_mode_effective)"

# --- row 2: live CODEX carries, and requests no permission mode ---------------
# Answered by the ACTOR guard, at MODE=live, so it is not the simulated row again.
V60HX="$(new_sandbox)"; state_file "$V60HX" carry-perm-codex codex
export WL60H_SF="$V60HX/logs/work-loop/carry-perm-codex.md"
export WL60H_CO="$V60HX"
OUT="$(bash "$DISPATCH_BIN" --checkout "$V60HX" --task carry-perm-codex --log-dir "$V60HX/runs" \
      --carry-one --codex-bin "$FAKE60HX" 2>&1)"; RC=$?
expect_rc 0 "$RC" "60h — the live Codex hop is carried" "$OUT"
R60HX="$V60HX/runs/$(run_id_of "$OUT").result"
if [ "$(res_field "$R60HX" mode)" = live ] &&
   [ "$(res_field "$R60HX" actor_launched)" = yes ] &&
   [ "$(res_field "$R60HX" permission_mode_requested)" = none ]; then
  ok "60h — a live carried Codex terminal still requests no permission mode"
else
  bad "60h — a live carried Codex terminal still requests no permission mode" \
      "mode=$(res_field "$R60HX" mode) launched=$(res_field "$R60HX" actor_launched) perm=$(res_field "$R60HX" permission_mode_requested)"
fi

# --- row 3: a SIMULATED Claude carry requests nothing -------------------------
# Answered by the MODE guard. --actor-cmd never builds a claude argv at all.
V60HS="$(new_sandbox)"; state_file "$V60HS" carry-perm-sim claude
run_dispatch "$V60HS" carry-perm-sim --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "60h — the simulated Claude hop is carried" "$OUT"
R60HS="$V60HS/runs/$(run_id_of "$OUT").result"
if [ "$(res_field "$R60HS" mode)" = simulated ] &&
   [ "$(res_field "$R60HS" actor_launched)" = yes ] &&
   [ "$(res_field "$R60HS" permission_mode_requested)" = none ]; then
  ok "60h — a simulated carried Claude terminal requests no permission mode"
else
  bad "60h — a simulated carried Claude terminal requests no permission mode" \
      "mode=$(res_field "$R60HS" mode) launched=$(res_field "$R60HS" actor_launched) perm=$(res_field "$R60HS" permission_mode_requested)"
fi

# --- row 4: the contained profile carries no permission mode of its own -------
# Answered by the UNATTENDED guard, on the live branch with a real fork.
V60HU="$(new_sandbox)"; state_file "$V60HU" carry-perm-unatt claude
export WL60H_SF="$V60HU/logs/work-loop/carry-perm-unatt.md"
export WL60H_CO="$V60HU"
OUT="$(bash "$DISPATCH_BIN" --checkout "$V60HU" --task carry-perm-unatt --log-dir "$V60HU/runs" \
      --carry-one --claude-bin "$FAKE60H" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "60h — the unattended Claude hop is carried" "$OUT"
R60HU="$V60HU/runs/$(run_id_of "$OUT").result"
if [ "$(res_field "$R60HU" mode)" = live ] &&
   [ "$(res_field "$R60HU" actor_launched)" = yes ] &&
   [ "$(res_field "$R60HU" permission_mode_requested)" = none ]; then
  ok "60h — a carried --unattended terminal still requests no permission mode"
else
  bad "60h — a carried --unattended terminal still requests no permission mode" \
      "mode=$(res_field "$R60HU" mode) launched=$(res_field "$R60HU" actor_launched) perm=$(res_field "$R60HU" permission_mode_requested)"
fi

# --- row 5: the FAILURE terminal above the clear is unchanged -----------------
# The same live attended launch, stopped at 22 instead of carried. It finalizes
# while the actor is still named in flight, and it ALREADY reported `default`.
# Asserting it here is what makes the repair provably a preservation rather than a
# move of the hop-over clear: this row and row 1 must now agree, and the clear
# must still be the thing that separates `actor=claude` from `actor=none`.
V60HF="$(new_sandbox)"; state_file "$V60HF" carry-perm-fail claude
OUT="$(bash "$DISPATCH_BIN" --checkout "$V60HF" --task carry-perm-fail --log-dir "$V60HF/runs" \
      --carry-one --claude-bin "$FAKE60HN" 2>&1)"; RC=$?
expect_rc 22 "$RC" "60h — a live Claude hop that changes nothing stops at 22" "$OUT"
R60HF="$V60HF/runs/$(run_id_of "$OUT").result"
if [ "$(res_field "$R60HF" permission_mode_requested)" = default ] &&
   [ "$(res_field "$R60HF" actor)" = claude ]; then
  ok "60h — the failure terminal above the clear still reports default, with the actor still in flight"
else
  bad "60h — the failure terminal above the clear still reports default, with the actor still in flight" \
      "perm=$(res_field "$R60HF" permission_mode_requested) actor=$(res_field "$R60HF" actor)"
fi

# --- row 6: a pre-fork stop requests nothing, even after an earlier fork ------
# THE ROW THAT DECIDES WHERE THE FACT MAY BE RECORDED. Case 50d proves a FIRST-hop
# pre-fork stop reports `none`, but it is protected there only by the run-level
# ACTOR_PROCESS_STARTED flag. Once any hop has forked, that flag is 1 for the rest
# of the run, so a launched-actor fact recorded on ENTRY to launch_actor() — before
# the binary checks — would make hop 2's unresolvable claude binary report
# `default` for an argv no child ever received. Hop 1 is a live codex fork that
# hands on to claude; hop 2 stops on a claude binary that does not exist.
V60HP="$(new_sandbox)"; state_file "$V60HP" prefork-after-fork codex
export WL60H_SF="$V60HP/logs/work-loop/prefork-after-fork.md"
export WL60H_CO="$V60HP"
OUT="$(bash "$DISPATCH_BIN" --checkout "$V60HP" --task prefork-after-fork --log-dir "$V60HP/runs" \
      --max-hops 3 --codex-bin "$FAKE60HX" --claude-bin "$V60HP/no-such-claude-binary" 2>&1)"; RC=$?
expect_rc 20 "$RC" "60h — hop 2 stops on the unresolvable claude binary" "$OUT"
R60HP="$V60HP/runs/$(run_id_of "$OUT").result"
if [ "$(res_field "$R60HP" hop)" = 2 ] &&
   [ "$(res_field "$R60HP" actor_launched)" = yes ] &&
   [ "$(res_field "$R60HP" permission_mode_requested)" = none ]; then
  ok "60h — a pre-fork stop after an earlier fork requests no permission mode"
else
  bad "60h — a pre-fork stop after an earlier fork requests no permission mode" \
      "hop=$(res_field "$R60HP" hop) launched=$(res_field "$R60HP" actor_launched) perm=$(res_field "$R60HP" permission_mode_requested)"
fi
unset WL60H_SF WL60H_CO

echo
echo "Case 60i — mutation control: neutralize ONLY the launched-actor publication"
# Unit 20, and it is the half Unit 19 deliberately left out. 60h proves the
# carried terminal REPORTS `default`; on its own it cannot prove that
# LAUNCHED_ACTOR is what makes it do so — a producer that had simply been
# hard-coded to `default` for live Claude would satisfy every row above.
#
# THE PUBLICATION, NOT THE READ, is the site. Neutralizing the read would delete
# the guard and make the function answer `default` for Codex too, which fails 60h
# for a reason that is not the one under test. Removing the one line that records
# WHICH actor was forked leaves every other guard standing and reverts exactly the
# Unit 19 behaviour: the fact is never published, so the producer's third guard
# sees an empty value and falls to `none` — the pre-unit answer.
#
# MATCHED WHOLE AND COUNTED, the M1 discipline. A seam that moved, changed shape,
# or appears twice stops the control rather than silently mutating something else
# or testing a script that was never changed. The three conditions are separate
# variables and are reported separately, so a control that could not run is never
# confused with one that ran and found nothing.
MUT60I="$SANDBOX_ROOT/mutants60i"; mkdir -p "$MUT60I"
M28_LINE='  LAUNCHED_ACTOR="${CUR_ACTOR:-}"'
M28_HITS="$(grep -Fxc -- "$M28_LINE" "$DISPATCH_BIN" 2>/dev/null)"
awk -v want="$M28_LINE" '$0 == want { print "  :"; next } { print }' "$DISPATCH_BIN" >"$MUT60I/m28.sh"
M28_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT60I/m28.sh" || M28_DIFFERS=yes
M28_PARSES=no; bash -n "$MUT60I/m28.sh" 2>/dev/null && M28_PARSES=yes

# THE GUARD'S OWN FALSIFIABILITY, three one-shot checks before the control runs.
# Each shows one of the three conditions above actually rejects something, so a
# later edit cannot leave the control passing vacuously against an unmutated,
# doubly-mutated or unparseable script. They are cheap: no dispatcher runs.
M28_NOOP_LINE='  LAUNCHED_ACTOR="${CUR_ACTOR:-}" # a suffix the dispatcher does not carry'
M28_NOOP_HITS="$(grep -Fxc -- "$M28_NOOP_LINE" "$DISPATCH_BIN" 2>/dev/null || true)"
awk -v want="$M28_NOOP_LINE" '$0 == want { print "  :"; next } { print }' \
    "$DISPATCH_BIN" >"$MUT60I/m28-noop.sh"
if [ "${M28_NOOP_HITS:-0}" = "0" ] && cmp -s "$DISPATCH_BIN" "$MUT60I/m28-noop.sh"; then
  ok "60i — a selector matching nothing yields an UNMUTATED script, which hits==1 and differs==yes both reject"
else
  bad "60i — a selector matching nothing yields an UNMUTATED script" \
      "hits=${M28_NOOP_HITS:-0}, and the 'mutant' $(cmp -s "$DISPATCH_BIN" "$MUT60I/m28-noop.sh" && echo 'is' || echo 'is not') identical"
fi
awk -v want="$M28_LINE" '{ print } $0 == want { print }' "$DISPATCH_BIN" >"$MUT60I/m28-dup.sh"
[ "$(grep -Fxc -- "$M28_LINE" "$MUT60I/m28-dup.sh" 2>/dev/null)" = "2" ] \
  && ok "60i — a duplicated seam counts 2, which the hits==1 test rejects (the counter is real)" \
  || bad "60i — a duplicated seam counts 2, which the hits==1 test rejects" \
         "counted $(grep -Fxc -- "$M28_LINE" "$MUT60I/m28-dup.sh" 2>/dev/null)"
awk -v want="$M28_LINE" '$0 == want { print "  if"; next } { print }' \
    "$DISPATCH_BIN" >"$MUT60I/m28-broken.sh"
bash -n "$MUT60I/m28-broken.sh" 2>/dev/null \
  && bad "60i — an unparseable replacement is rejected by the parses test" "bash -n accepted a dangling 'if'" \
  || ok "60i — an unparseable replacement is rejected by the parses test, separately from any behaviour"

if [ "$M28_HITS" = "1" ] && [ "$M28_DIFFERS" = yes ] && [ "$M28_PARSES" = yes ]; then
  ok "60i — M28 mutant matched the publication exactly once, differs, and still parses"

  # The fixture is 60h row 1 verbatim: a live fake-Claude fork, no external model
  # request, carried to the post-hop terminal 60h asserts.
  M28FAKE="$SANDBOX_ROOT/fake-claude-60i.sh"
  cat >"$M28FAKE" <<'M28EOF'
#!/bin/bash
if [ "${1:-}" = "--version" ]; then echo "2.1.220 (Claude Code)"; exit 0; fi
sf="$WL60I_SF"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
git -C "$WL60I_CO" add "$sf" >/dev/null 2>&1
git -C "$WL60I_CO" commit -qm "fake claude hop" >/dev/null 2>&1
exit 0
M28EOF
  chmod +x "$M28FAKE"

  V60I="$(new_sandbox)"; state_file "$V60I" carry-mut claude
  export WL60I_SF="$V60I/logs/work-loop/carry-mut.md"
  export WL60I_CO="$V60I"
  OUT="$(bash "$MUT60I/m28.sh" --checkout "$V60I" --task carry-mut --log-dir "$V60I/runs" \
        --carry-one --claude-bin "$M28FAKE" 2>&1)"; RC=$?
  R60I="$V60I/runs/$(run_id_of "$OUT").result"
  # CAUSAL FAILURE, NOT FIXTURE BREAKAGE. Asserted as one condition so the control
  # cannot pass on a mutant that merely crashed: the run must still carry the hop
  # and still finalize a live, post-hop, carried record — everything 60h's
  # precondition assertion checks — and differ from it in the ONE field under test.
  if [ "$RC" -eq 0 ] &&
     [ "$(res_field "$R60I" mode)" = live ] &&
     [ "$(res_field "$R60I" outcome)" = CARRY_ONE_COMPLETE ] &&
     [ "$(res_field "$R60I" stage)" = post-hop ] &&
     [ "$(res_field "$R60I" actor_launched)" = yes ] &&
     [ "$(res_field "$R60I" permission_mode_requested)" = none ]; then
    ok "60i — M28: the carried terminal still runs, and reports none instead of default (60h is fail-capable)"
  else
    bad "60i — M28: the carried terminal still runs, and reports none instead of default" \
        "rc=$RC mode=$(res_field "$R60I" mode) outcome=$(res_field "$R60I" outcome) stage=$(res_field "$R60I" stage) launched=$(res_field "$R60I" actor_launched) perm=$(res_field "$R60I" permission_mode_requested)"
  fi

  # THE PAIRED UNMUTATED RUN, same fixture, same flags, one line of source apart.
  # Without it the row above would be satisfied by a fixture that reports `none`
  # for some reason of its own, and the mutation would be proving nothing.
  V60IC="$(new_sandbox)"; state_file "$V60IC" carry-mut-control claude
  export WL60I_SF="$V60IC/logs/work-loop/carry-mut-control.md"
  export WL60I_CO="$V60IC"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$V60IC" --task carry-mut-control --log-dir "$V60IC/runs" \
        --carry-one --claude-bin "$M28FAKE" 2>&1)"; RC=$?
  R60IC="$V60IC/runs/$(run_id_of "$OUT").result"
  if [ "$RC" -eq 0 ] && [ "$(res_field "$R60IC" permission_mode_requested)" = default ]; then
    ok "60i — and the unmodified dispatcher reports default on the identical fixture"
  else
    bad "60i — and the unmodified dispatcher reports default on the identical fixture" \
        "rc=$RC perm=$(res_field "$R60IC" permission_mode_requested)"
  fi
  unset WL60I_SF WL60I_CO
else
  bad "60i — M28 mutant matched the publication exactly once, differs, and still parses" \
      "matched ${M28_HITS:-0} lines, want exactly 1; differs=$M28_DIFFERS parses=$M28_PARSES — the control cannot run"
fi

echo
echo "Case 60j — a carried record altered ONLY in outcome, or ONLY in code, is refused before release"
# Unit 29. The third production consumer, and the seam's last unproven half.
# 60a-b proved a carried hop publishes and consumes the artifact it promised and
# that the artifact says CARRY_ONE_COMPLETE/0; nothing proved the artifact the
# CONSUMER accepted said that. Measured on these fixtures before the edit: a
# record altered after successful finalization to `outcome=COMPLETED` — the full
# loop's word for a run that drove the task to its end, over a run that carried
# exactly one hop — exited 0, was advertised as this run's terminal result and
# released both leases; so did one altered to `code=22`, the code for a hop that
# made no transition, over a run whose transition table had just passed. Path,
# structure and identity have nothing to object to; only meaning does.
#
# SAME FORCING TECHNIQUE, SAME WINDOW as 56b, 58e and 62b: one altering line
# injected after this seam's own finalization marker, between publication and
# consumption. Everything asserted afterwards is the unmodified seam's behaviour.
#
# A CODEX ACTOR, for 60e's reason unchanged: no commit and no permission-denial
# probe stands between the hop and the seam under test.
#
# THE ACCEPTED ROWS ARE NOT RE-RUN HERE. 60a and 60b already exercise a real
# carried hop's post-hop facts, release, and all four lifecycle rows' outcome and
# next-action meanings — against this integrated dispatcher, so they are this
# unit's green for the accepted behaviour rather than a second matrix.
MUT60J="$SANDBOX_ROOT/mutants60j"; mkdir -p "$MUT60J"

mk_carry_alter60() { # outfile sed-script [source] -> 0 when the fixture differs and parses
  awk -v s="$2" '{print} /# carry-one terminal finalization/ {
    printf "    sed %c%s%c \"$RESULT_FILE\" >\"$RESULT_FILE.x\" && mv -f \"$RESULT_FILE.x\" \"$RESULT_FILE\" # harness carry-one alteration\n", 39, s, 39 }' \
    "${3:-$DISPATCH_BIN}" >"$1"
  ! cmp -s "${3:-$DISPATCH_BIN}" "$1" && bash -n "$1" 2>/dev/null
}

# The full refusal contract for one forced carried mismatch, asserted exactly as
# 58e asserts the preflight's: exit 38, nothing advertised, the truthful terminal
# named, both leases retained with the bounded token as their cause, and the next
# dispatcher refused.
expect_carry_refusal60() { # fixture expected-token label-prefix
  local V O R TL CL
  V="$(new_sandbox)"; state_file "$V" carry-sem codex
  O="$(bash "$1" --checkout "$V" --task carry-sem --log-dir "$V/runs" --timeout 20 \
        --carry-one --actor-cmd "$FLIP" 2>&1)"; R=$?
  expect_rc 38 "$R" "$3 — refused with exit 38, never 0" "$O"
  out_lacks "  terminal result:" "$O" "$3 — the refused artifact is not advertised as this run's result"
  # The accepted label from Unit 16 (finding F1) still names the terminal this run
  # really reached, and the operator terminal's default sentence stays absent.
  out_has "reached the carry-one terminal after one carried hop" "$O" \
    "$3 — the refusal names the carry-one terminal it actually reached"
  out_lacks "reached a real operator terminal" "$O" \
    "$3 — the refusal claims no operator terminal"
  TL="$(task_lock_for "$V" carry-sem)"; CL="$(checkout_lock_for "$V")"
  # NOT a finalization story: the record published perfectly well, and 60e owns
  # the case where it does not. What failed here is what the record says.
  if [ -d "$TL" ] && [ -d "$CL" ] &&
     grep -q '^terminal result unprovable: ' "$TL/survivors" 2>/dev/null &&
     grep -q "$2" "$TL/survivors" 2>/dev/null &&
     grep -q "$2" "$CL/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL/survivors" 2>/dev/null; then
    ok "$3 — both leases retained, both pins carrying the bounded '$2' cause"
  else
    bad "$3 — both leases retained, both pins carrying the bounded '$2' cause" \
        "task=$([ -d "$TL" ] && echo present || echo absent) checkout=$([ -d "$CL" ] && echo present || echo absent) cause: $(cat "$TL/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V" carry-sem --dry-run
  expect_rc 17 "$RC" "$3 — the next dispatcher is refused by the retained lease" "$OUT"
}

if mk_carry_alter60 "$MUT60J/outonly.sh" 's/^outcome=.*/outcome=COMPLETED/'; then
  ok "60j — the outcome-only forcing fixture differs from the dispatcher and is valid bash"
  expect_carry_refusal60 "$MUT60J/outonly.sh" outcome-mismatch \
    "60j — a carried hop whose record claims COMPLETED"
else
  bad "60j — the outcome-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi
if mk_carry_alter60 "$MUT60J/codeonly.sh" 's/^code=.*/code=22/'; then
  ok "60j — the code-only forcing fixture differs from the dispatcher and is valid bash"
  expect_carry_refusal60 "$MUT60J/codeonly.sh" code-mismatch \
    "60j — a carried hop whose record claims code 22"
else
  bad "60j — the code-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

# INDEPENDENCE, structurally, on the same argument 62c makes for the operator
# seam: the call site must derive its expected symbol through the sole mapping
# owner and state its expected code as a literal. A call site that passed a field
# out of the record would compare it with itself, and the two refusals above
# would go green on a forgery.
CALL60J="$(grep -n '# carry-one terminal consumption' "$DISPATCH_BIN" | grep -v ':[[:space:]]*#' | cut -d: -f2-)"
if printf '%s\n' "$CALL60J" | grep -q 'result_outcome 0' &&
   ! printf '%s\n' "$CALL60J" | grep -qE 'RESULT_FILE|TR_OUTCOME|TR_CODE|res_field|\.result'; then
  ok "60j — the carry-one seam derives its expected pair through result_outcome and reads nothing from the artifact"
else
  bad "60j — the carry-one seam derives its expected pair through result_outcome and reads nothing from the artifact" \
      "call site: $CALL60J"
fi

echo
echo "Case 60k — mutation control: remove ONLY the carry-one expected pair and both mismatches release again"
# M36 — the mirror of M33 and M34 one seam over. It strips exactly the two
# expectation arguments from the carry-one call, leaving that call, its truthful
# label, the path gate, the parse and the identity boundary in place, AND leaving
# the operator and dry-run pairs untouched — which is what proves the three
# migrated seams are separately fail-capable rather than one shared switch. Fails
# closed: unless the selector matched exactly once and the mutant differs and
# parses, the control does not run.
sed 's/ "$(result_outcome 0)" 0 # carry-one terminal consumption/ # carry-one terminal consumption/' \
  "$DISPATCH_BIN" >"$MUT60J/m36.sh" 2>/dev/null
M36_HITS="$(grep -c ' "\$(result_outcome 0)" 0 # carry-one terminal consumption' "$DISPATCH_BIN" 2>/dev/null || true)"
M36_LEFT="$(grep -c ' "\$(result_outcome 0)" 0 # carry-one terminal consumption' "$MUT60J/m36.sh" 2>/dev/null || true)"
M36_KEPT="$(grep -c 'consume_terminal_result "the carry-one terminal after one carried hop" # carry-one terminal consumption' "$MUT60J/m36.sh" 2>/dev/null || true)"
M36_OP="$(grep -c ' "" "\$(result_outcome 0)" 0 # operator terminal consumption' "$MUT60J/m36.sh" 2>/dev/null || true)"
M36_DRY="$(grep -c ' "\$(result_outcome 0)" 0 # dry-run terminal consumption' "$MUT60J/m36.sh" 2>/dev/null || true)"
M36_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT60J/m36.sh" || M36_DIFFERS=yes
M36_PARSES=no; bash -n "$MUT60J/m36.sh" 2>/dev/null && M36_PARSES=yes
if [ "$M36_HITS" = 1 ] && [ "$M36_LEFT" = 0 ] && [ "$M36_KEPT" = 1 ] &&
   [ "$M36_OP" = 1 ] && [ "$M36_DRY" = 1 ] &&
   [ "$M36_DIFFERS" = yes ] && [ "$M36_PARSES" = yes ]; then
  ok "60k — M36 removed exactly the carry-one pair, kept its labelled consumer call and the other two pairs, differs, and parses"
  for f60 in outcome:COMPLETED code:22; do
    FLD60="${f60%%:*}"; VAL60="${f60##*:}"
    if mk_carry_alter60 "$MUT60J/m36-$FLD60.sh" "s/^$FLD60=.*/$FLD60=$VAL60/" "$MUT60J/m36.sh"; then
      V60J="$(new_sandbox)"; state_file "$V60J" carry-sem codex
      OUT="$(bash "$MUT60J/m36-$FLD60.sh" --checkout "$V60J" --task carry-sem \
            --log-dir "$V60J/runs" --timeout 20 --carry-one --actor-cmd "$FLIP" 2>&1)"; RCM=$?
      if [ "$RCM" -eq 0 ] && [ ! -d "$(task_lock_for "$V60J" carry-sem)" ] &&
         [ ! -d "$(checkout_lock_for "$V60J")" ]; then
        ok "60k — M36: without the expected pair the $FLD60-only mismatch exits 0 and releases (60j is fail-capable)"
      else
        bad "60k — M36: without the expected pair the $FLD60-only mismatch exits 0 and releases (60j is fail-capable)" \
            "rc=$RCM task-lease=$([ -d "$(task_lock_for "$V60J" carry-sem)" ] && echo held || echo released)"
      fi
    else
      bad "60k — M36: the $FLD60-only fixture over the mutant differs and parses" \
          "the injection matched nothing, or the fixture does not parse — the control cannot run"
    fi
  done
else
  bad "60k — M36 removed exactly the carry-one pair, kept its labelled consumer call and the other two pairs, differs, and parses" \
      "matched=$M36_HITS left=$M36_LEFT kept=$M36_KEPT operator-pair=$M36_OP dry-run-pair=$M36_DRY differs=$M36_DIFFERS parses=$M36_PARSES — the control cannot run"
fi

# ==================================================================== case 61
# THE THIRD TRUST QUESTION, and the gap cases 51-54 leave open by design.
#
# WHAT WAS MISSING. The accepted composition answers path safety, structure and
# task/checkout/run identity. All three can pass on a record whose `outcome` and
# `code` describe a DIFFERENT ending than the one the caller is finalizing: a
# genuine record of another terminal, structurally perfect and correctly
# addressed. 61b asserts that gap directly — the same fixtures the semantic
# boundary rejects are shown being ACCEPTED by the three-gate composition, so the
# assertion below is evidence about what identity does not cover rather than a
# claim that it is broken.
#
# THE EXPECTATION IS ESTABLISHED WITHOUT THE ARTIFACT, and 61a proves it by
# deriving the pair while the record is moved out of the way. Reading either
# expected value out of the record under test would compare it with itself, which
# is the one comparison a forgery passes by construction.
#
# NO SECOND TABLE. The expected symbol comes from the dispatcher's own
# `result_outcome()`, lifted as production text, driven by the exit status this
# harness OBSERVED from the producing process. The boundary itself knows no
# symbols — 61c asserts that against its shipped text.
#
# STILL NOT A CONSUMER. Nothing below makes a validated result advance a loop,
# release a lease, choose a route or wait for a record. Integration into
# `consume_terminal_result()` is a later unit.
#
# SAME EXERCISE ROUTE as cases 51-54: the marker-delimited region is lifted out of
# the dispatcher under test and sourced, so the text executed here is dispatch.sh's
# own production text, and 61d proves it by mutating dispatch.sh and watching these
# assertions go green.

# The four checks in the one order that is correct, in a single subshell, for the
# reason ident_run() states: the boundaries hand each other state through globals
# that a command substitution would discard.
sem_run() { # lib artifact task checkout run root want-outcome want-code -> "<rc> <token>"
  ( . "$1" >/dev/null 2>&1 || { printf '99 lib-unsourceable\n'; exit 0; }
    t="$SANDBOX_ROOT/.sem-token"
    validate_terminal_result_path "$2" "$3" "$4" "$5" "$6" >"$t" 2>/dev/null; rc=$?
    [ "$rc" -eq 0 ] || { printf '%s %s\n' "$rc" "$(cat "$t")"; exit 0; }
    validate_terminal_result "$2" >"$t" 2>/dev/null; rc=$?
    [ "$rc" -eq 0 ] || { printf '%s %s\n' "$rc" "$(cat "$t")"; exit 0; }
    validate_terminal_result_identity "$2" "$3" "$4" "$5" "$6" >"$t" 2>/dev/null; rc=$?
    [ "$rc" -eq 0 ] || { printf '%s %s\n' "$rc" "$(cat "$t")"; exit 0; }
    validate_terminal_result_semantics "$2" "$7" "$8" >"$t" 2>/dev/null; rc=$?
    printf '%s %s\n' "$rc" "$(cat "$t")" )
}

sem_expect() { # lib artifact task checkout run root want-outcome want-code want-rc want-token label
  local got; got="$(sem_run "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8")"
  if [ "$got" = "${9} ${10}" ]; then ok "${11}"; else bad "${11}" "expected '${9} ${10}', got '$got'"; fi
}

echo
echo "Case 61a — the expected pair is established WITHOUT the artifact, and the real result is accepted"
V61D="$(new_sandbox)"; state_file "$V61D" "semantic-task" "codex"
V61="$SANDBOX_ROOT/v61"; mkdir -p "$V61"
run_dispatch "$V61D" semantic-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "61a — the producing run reaches a nonzero terminal (22)" "$OUT"
# THE OBSERVED PROCESS FACT, not a field. This is the exit status the producing
# run really returned to this harness, captured before anything opened the record.
X_CODE61="$RC"
RID61="$(run_id_of "$OUT")"
CO61="$(cd "$V61D" && pwd -P)"
ROOT61="$(cd "$V61D/runs" && pwd -P)"
REAL61="$ROOT61/$RID61.result"
if [ -f "$REAL61" ]; then
  ok "61a — the producing run left a terminal result at its promised path"
else
  bad "61a — the producing run left a terminal result at its promised path" \
      "missing $REAL61; runs/ holds: $(ls "$ROOT61" 2>&1 | tr '\n' ' ')"
fi

# THE SOLE CODE-TO-SYMBOL OWNER, lifted as production text rather than restated.
# A symbol table written here would be a second authority on what an exit code
# means, and the two would drift the first time either changed.
OUTFN61="$SANDBOX_ROOT/wl2-outcome-fn.sh"
sed -n '/^result_outcome() {/,/^}/p' "$DISPATCH_BIN" >"$OUTFN61" 2>/dev/null
if [ -s "$OUTFN61" ] && [ "$(grep -c '^result_outcome() {' "$DISPATCH_BIN")" = 1 ]; then
  ok "61a — the dispatcher still defines exactly one code-to-outcome map, and it was lifted"
else
  bad "61a — the dispatcher still defines exactly one code-to-outcome map, and it was lifted" \
      "definitions: $(grep -c '^result_outcome() {' "$DISPATCH_BIN"), lifted bytes: $(wc -c <"$OUTFN61" 2>/dev/null)"
fi

# INDEPENDENCE, PROVED RATHER THAN ASSERTED. The pair is derived with the record
# moved out of the way entirely: a derivation that read the artifact could not
# survive its absence. Restored immediately, so every assertion below runs against
# the unchanged producer artifact at its promised path.
mv "$REAL61" "$V61/hidden.result" 2>/dev/null
X_OUTCOME61="$( . "$OUTFN61" >/dev/null 2>&1; result_outcome "$X_CODE61" )"
X_ABSENT61="$([ -f "$REAL61" ] && printf 'present' || printf 'absent')"
mv "$V61/hidden.result" "$REAL61" 2>/dev/null
if [ -n "$X_OUTCOME61" ] && [ "$X_ABSENT61" = absent ]; then
  ok "61a — the expected outcome/code pair is derived with the artifact absent ($X_OUTCOME61/$X_CODE61)"
else
  bad "61a — the expected outcome/code pair is derived with the artifact absent ($X_OUTCOME61/$X_CODE61)" \
      "outcome='$X_OUTCOME61' artifact-was='$X_ABSENT61'"
fi

sem_expect "$VAL_LIB" "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" "$X_OUTCOME61" "$X_CODE61" \
  0 ok "61a — the unchanged real producer result is accepted for the terminal the caller expected"

echo
echo "Case 61b — a structurally valid, correctly ADDRESSED record is rejected when its meaning disagrees"
# ONE FIELD APART FROM THE GENUINE RECORD, and placed at the promised path of an
# evidence root of its own so task, checkout, run and path all still match. Only
# the meaning differs, which is what makes these the sharp fixtures rather than
# soft ones: no other boundary has anything left to object to.
WRONG_OUT61="$SANDBOX_ROOT/v61-outroot"; mkdir -p "$WRONG_OUT61"
WRONG_OUT61="$(cd "$WRONG_OUT61" && pwd -P)"
sed 's/^outcome=.*/outcome=COMPLETED/' "$REAL61" >"$WRONG_OUT61/$RID61.result" 2>/dev/null
WRONG_CODE61="$SANDBOX_ROOT/v61-coderoot"; mkdir -p "$WRONG_CODE61"
WRONG_CODE61="$(cd "$WRONG_CODE61" && pwd -P)"
sed 's/^code=.*/code=0/' "$REAL61" >"$WRONG_CODE61/$RID61.result" 2>/dev/null

sem_expect "$VAL_LIB" "$WRONG_OUT61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_OUT61" \
  "$X_OUTCOME61" "$X_CODE61" 1 outcome-mismatch \
  "61b — a record claiming another terminal's OUTCOME is rejected"
sem_expect "$VAL_LIB" "$WRONG_CODE61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_CODE61" \
  "$X_OUTCOME61" "$X_CODE61" 1 code-mismatch \
  "61b — a record claiming another terminal's CODE is rejected with a DISTINCT token"

# THE GAP, ASSERTED IN SO MANY WORDS. If path, structure and identity could catch
# either fixture, this whole boundary would be redundant — and these two
# assertions are what would say so.
ident_expect "$VAL_LIB" "$WRONG_OUT61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_OUT61" 0 ok \
  "61b — the wrong-outcome record passes path, structure and identity, so only meaning can reject it"
ident_expect "$VAL_LIB" "$WRONG_CODE61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_CODE61" 0 ok \
  "61b — the wrong-code record passes path, structure and identity, so only meaning can reject it"

echo
echo "Case 61c — the comparison is bound to the one parse, and the boundary owns no table"

# ASKED COLD. No gate decision and no parse, so there is nothing to compare and it
# names the earlier of the two missing preconditions.
COLD61="$( . "$VAL_LIB" >/dev/null 2>&1
           tok="$(validate_terminal_result_semantics "$REAL61" "$X_OUTCOME61" "$X_CODE61" 2>/dev/null)"
           printf '%s %s\n' "$?" "$tok" )"
if [ "$COLD61" = "1 path-unchecked" ]; then
  ok "61c — the semantic check refuses an artifact whose path the safety gate never cleared"
else
  bad "61c — the semantic check refuses an artifact whose path the safety gate never cleared" \
      "expected '1 path-unchecked', got '$COLD61'"
fi

# THE PARSE RAN ON A DIFFERENT FILE. The ordering precondition is satisfied and
# fields ARE published — they just belong to something else, which is exactly the
# stale-field reuse this refusal exists to prevent.
OTHER61="$WRONG_OUT61/$RID61.result"
UNVAL61="$( . "$VAL_LIB" >/dev/null 2>&1
            validate_terminal_result_path "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" >/dev/null 2>&1
            validate_terminal_result "$OTHER61" >/dev/null 2>&1
            tok="$(validate_terminal_result_semantics "$REAL61" "$X_OUTCOME61" "$X_CODE61" 2>/dev/null)"
            printf '%s %s\n' "$?" "$tok" )"
if [ "$UNVAL61" = "1 unvalidated" ]; then
  ok "61c — the semantic check refuses when the parse that ran read a different file"
else
  bad "61c — the semantic check refuses when the parse that ran read a different file" \
      "expected '1 unvalidated', got '$UNVAL61'"
fi

# REPLACED AFTER THE PARSE. A different file at the same promised path, carrying
# the wrong-outcome record: without the file-identity pin the comparison would
# answer from the first record's captured outcome and ACCEPT it.
SWAP61="$( . "$VAL_LIB" >/dev/null 2>&1
           cp "$REAL61" "$V61/original.result"
           validate_terminal_result_path "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" >/dev/null 2>&1
           validate_terminal_result "$REAL61" >/dev/null 2>&1
           rm -f "$REAL61"; cp "$OTHER61" "$REAL61"
           tok="$(validate_terminal_result_semantics "$REAL61" "$X_OUTCOME61" "$X_CODE61" 2>/dev/null)"
           rc=$?
           rm -f "$REAL61"; cp "$V61/original.result" "$REAL61"
           printf '%s %s\n' "$rc" "$tok" )"
if [ "$SWAP61" = "1 artifact-replaced" ]; then
  ok "61c — a record replaced after the parse is refused, not answered from captured fields"
else
  bad "61c — a record replaced after the parse is refused, not answered from captured fields" \
      "expected '1 artifact-replaced', got '$SWAP61'"
fi

# REWRITTEN IN PLACE. Same file, different bytes — which the identity pin cannot
# see and the digest can. Both are required, and each names its own event.
APPEND61="$( . "$VAL_LIB" >/dev/null 2>&1
             cp "$REAL61" "$V61/original2.result"
             validate_terminal_result_path "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" >/dev/null 2>&1
             validate_terminal_result "$REAL61" >/dev/null 2>&1
             printf 'next_action=appended\n' >>"$REAL61"
             tok="$(validate_terminal_result_semantics "$REAL61" "$X_OUTCOME61" "$X_CODE61" 2>/dev/null)"
             rc=$?
             cp "$V61/original2.result" "$REAL61"
             printf '%s %s\n' "$rc" "$tok" )"
if [ "$APPEND61" = "1 artifact-changed" ]; then
  ok "61c — a record rewritten in place after the parse is refused"
else
  bad "61c — a record rewritten in place after the parse is refused" \
      "expected '1 artifact-changed', got '$APPEND61'"
fi

# AN UNSUPPLIED EXPECTATION IS NOT A WILDCARD, the same rule the two accepted
# boundaries state.
sem_expect "$VAL_LIB" "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" "" "$X_CODE61" \
  1 no-expectation "61c — an unsupplied expected outcome is refused rather than treated as any outcome"
sem_expect "$VAL_LIB" "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" "$X_OUTCOME61" "" \
  1 no-expectation "61c — an unsupplied expected code is refused rather than treated as any code"

# THE BOUNDARY KNOWS NO SYMBOLS. A code-to-outcome table here would be a second
# authority on what an exit code means. Whole-line comments are stripped first,
# for the reason 51b gives: a comment cannot execute, so prose naming a symbol
# would be a false positive about the one thing this control exists to catch.
SEM_CODE="$SANDBOX_ROOT/wl2-semantic-code.sh"
awk '/^validate_terminal_result_semantics\(\)/{f=1} f' "$VAL_LIB" 2>/dev/null |
  sed 's/^[[:space:]]*#.*$//' >"$SEM_CODE" 2>/dev/null
TABLE_RE='NO_TRANSITION|COMPLETED|OPERATOR_TAKEOVER|UNCLASSIFIED|result_outcome|^[[:space:]]*case '
if [ -s "$SEM_CODE" ] && ! grep -nE "$TABLE_RE" "$SEM_CODE" >/dev/null 2>&1; then
  ok "61c — the semantic boundary's text carries no outcome symbols and no second mapping"
else
  bad "61c — the semantic boundary's text carries no outcome symbols and no second mapping" \
      "${SEM_CODE} empty, or: $(grep -nE "$TABLE_RE" "$SEM_CODE" 2>/dev/null | head -3 | tr '\n' ';')"
fi

# READ-ONLY ACROSS THE WHOLE CHECKOUT, on the argument case 51b makes: the claim
# covers state files, leases, ownership, logs and captures, not just the artifact.
BEFORE61="$(tree_manifest "$V61D")"
sem_run "$VAL_LIB" "$REAL61" semantic-task "$CO61" "$RID61" "$ROOT61" "$X_OUTCOME61" "$X_CODE61" >/dev/null 2>&1
sem_run "$VAL_LIB" "$WRONG_OUT61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_OUT61" \
  "$X_OUTCOME61" "$X_CODE61" >/dev/null 2>&1
AFTER61="$(tree_manifest "$V61D")"
if [ "$BEFORE61" = "$AFTER61" ]; then
  ok "61c — semantic validation changes nothing in the checkout"
else
  bad "61c — semantic validation changes nothing in the checkout" \
      "$(printf '%s\n' "$BEFORE61" >"$V61/before"; printf '%s\n' "$AFTER61" >"$V61/after"
         diff "$V61/before" "$V61/after" | head -4 | tr '\n' ';')"
fi

echo
echo "Case 61d — mutation control: remove ONLY the two semantic comparisons and both mismatches are accepted"
MUT61="$SANDBOX_ROOT/mutants61"; mkdir -p "$MUT61"

# M32 — delete exactly the two comparison lines from the DISPATCHER, leaving path
# safety, structure, identity and every precondition above them untouched. Without
# them the records one field apart from the genuine one are ACCEPTED, which is the
# pre-edit behaviour 61b exists to catch. Fails closed: unless the selector matched
# exactly one of each line, the mutant differs and still parses, the control does
# not run and says so.
sed "/printf 'outcome-mismatch/d; /printf 'code-mismatch/d" "$DISPATCH_BIN" >"$MUT61/m32.sh" 2>/dev/null
# `|| true` INSIDE the substitution, not a `printf` fallback after it: `grep -c`
# already prints its count and exits 1 when that count is zero, so a fallback
# appends a SECOND zero and the comparison below can never match.
M32_HITS="$(grep -c "printf 'outcome-mismatch\|printf 'code-mismatch" "$DISPATCH_BIN" 2>/dev/null || true)"
M32_LEFT="$(grep -c "printf 'outcome-mismatch\|printf 'code-mismatch" "$MUT61/m32.sh" 2>/dev/null || true)"
M32_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT61/m32.sh" || M32_DIFFERS=yes
M32_PARSES=no; bash -n "$MUT61/m32.sh" 2>/dev/null && M32_PARSES=yes
if [ "$M32_HITS" = 2 ] && [ "$M32_LEFT" = 0 ] && [ "$M32_DIFFERS" = yes ] && [ "$M32_PARSES" = yes ]; then
  ok "61d — M32 matched exactly the two comparisons, differs from the dispatcher, and still parses"
  if extract_validator "$MUT61/m32.sh" "$MUT61/m32.lib"; then
    sem_expect "$MUT61/m32.lib" "$WRONG_OUT61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_OUT61" \
      "$X_OUTCOME61" "$X_CODE61" 0 ok \
      "61d — M32: without the comparisons the wrong-outcome record is accepted (61b is fail-capable)"
    sem_expect "$MUT61/m32.lib" "$WRONG_CODE61/$RID61.result" semantic-task "$CO61" "$RID61" "$WRONG_CODE61" \
      "$X_OUTCOME61" "$X_CODE61" 0 ok \
      "61d — M32: without the comparisons the wrong-code record is accepted (61b is fail-capable)"
  else
    bad "61d — M32: without the comparisons both mismatched records are accepted (61b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "61d — M32 matched exactly the two comparisons, differs from the dispatcher, and still parses" \
      "matched=$M32_HITS left=$M32_LEFT differs=$M32_DIFFERS parses=$M32_PARSES — the control cannot run"
fi

# ==================================================================== case 62
# THE FIRST PRODUCTION CONSUMER OF THE THIRD TRUST QUESTION.
#
# WHAT WAS MISSING. Case 61 proved the semantic boundary works standalone and
# proved, at 61b, that path/structure/identity cannot see a one-field meaning
# change. Nothing consumed it: the loop-mode operator terminal — the one seam
# where release IS the advance decision — composed only the three, so a record
# altered after finalization in `outcome` alone or in `code` alone still bought
# the lease release. Measured before this unit's edit, on the fixtures below:
# both exited 0, released both leases, and were advertised as the run's terminal
# result.
#
# THE FIXTURES FORCE, THE DISPATCHER DECIDES — case 56's technique unchanged.
# awk appends one altering line after the finalization marker, inside the window
# between publication and consumption, and everything asserted afterwards is the
# unmodified seam's own behaviour.
#
# WHICH SEAMS ARE MIGRATED, AND THE CASE SAYS SO. 62c names them: at Unit 27
# this terminal was the only one, Unit 28 added the dry-run terminal (case 58e),
# Unit 29 the post-hop carry-one terminal (case 60j), and Unit 30 the interruption
# terminal (case 27w) — which is all four consumer call sites.
#
# WHAT IS STILL NOT CLAIMED, now that the deferred list is empty. The shared
# nonzero die() funnel consumes nothing at all: it is not a consumer call site,
# so "every consumer supplies a pair" is not "every terminal is gated". 62c is
# updated each time a seam migrates, and that distinction is what stops the
# empty deferred list reading as coverage the dispatcher does not have.

MUT62="$SANDBOX_ROOT/mutants62"; mkdir -p "$MUT62"

# One altering injection, parameterised by the sed script it plants. Written as a
# builder rather than four copies so the four fixtures below cannot drift apart
# in anything except the field they alter.
mk_alter62() { # outfile sed-script marker -> 0 when the fixture differs and parses
  awk -v s="$2" -v m="$3" '{print} /# operator terminal finalization/ {
    printf "    sed %c%s%c \"$RESULT_FILE\" >\"$RESULT_FILE.x\" && mv -f \"$RESULT_FILE.x\" \"$RESULT_FILE\" # %s\n", 39, s, 39, m }' \
    "${4:-$DISPATCH_BIN}" >"$1"
  ! cmp -s "${4:-$DISPATCH_BIN}" "$1" && bash -n "$1" 2>/dev/null
}

# The full refusal contract for one forced mismatch, asserted the same way 56b
# asserts the identity refusal: exit 38, nothing advertised, both leases retained
# with the bounded token as their truthful cause, next dispatcher refused.
expect_sem_refusal62() { # fixture task expected-token label-prefix
  local V O R TL CL
  V="$(new_sandbox)"; state_file "$V" "$2" operator
  [ "$2" = blocked-task ] && state_file "$V" "$2" operator "$2" blocked
  O="$(bash "$1" --checkout "$V" --task "$2" --log-dir "$V/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; R=$?
  expect_rc 38 "$R" "$4 — refused with exit 38, never 0" "$O"
  out_lacks "  terminal result:" "$O" "$4 — the refused artifact is not advertised as this run's result"
  TL="$(task_lock_for "$V" "$2")"; CL="$(checkout_lock_for "$V")"
  if [ -d "$TL" ] && [ -d "$CL" ] &&
     grep -q '^terminal result unprovable: ' "$TL/survivors" 2>/dev/null &&
     grep -q "$3" "$TL/survivors" 2>/dev/null &&
     grep -q "$3" "$CL/survivors" 2>/dev/null &&
     ! grep -q 'could not finalize' "$TL/survivors" 2>/dev/null; then
    ok "$4 — both leases retained, both pins carrying the bounded '$3' cause"
  else
    bad "$4 — both leases retained, both pins carrying the bounded '$3' cause" \
        "task=$([ -d "$TL" ] && echo present || echo absent) checkout=$([ -d "$CL" ] && echo present || echo absent) cause: $(cat "$TL/survivors" 2>&1 | tr '\n' '|')"
  fi
  run_dispatch "$V" "$2" --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "$4 — the next dispatcher is refused by the retained lease" "$OUT"
}

echo
echo "Case 62a — real CLOSED and BLOCKED_OPERATOR results still pass the composed consumer and release"
# 56a already proved this for the three-boundary composition; what is new is that
# the SAME two real producer artifacts now also have to agree with the ending the
# caller independently expected. A regression that derived the expectation wrongly
# — or derived it from the record and then compared it back — would surface here
# as a 38 on a run that did nothing wrong.
V62A="$(new_sandbox)"; state_file "$V62A" closed-task operator
run_dispatch "$V62A" closed-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "62a — a real CLOSED result passes the semantic boundary and still exits 0" "$OUT"
RID62A="$(run_id_of "$OUT")"
ROOT62A="$(cd "$V62A/runs" && pwd -P)"
if [ "$(res_field "$ROOT62A/$RID62A.result" outcome)" = COMPLETED ] &&
   [ "$(res_field "$ROOT62A/$RID62A.result" code)" = 0 ] &&
   [ ! -d "$(task_lock_for "$V62A" closed-task)" ] && [ ! -d "$(checkout_lock_for "$V62A")" ]; then
  ok "62a — the accepted CLOSED terminal carries COMPLETED/0 and released both leases"
else
  bad "62a — the accepted CLOSED terminal carries COMPLETED/0 and released both leases" \
      "outcome=$(res_field "$ROOT62A/$RID62A.result" outcome) code=$(res_field "$ROOT62A/$RID62A.result" code) leases held"
fi
run_dispatch "$V62A" closed-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "62a — a subsequent dispatcher is admitted after the verified release" "$OUT"

V62B="$(new_sandbox)"; state_file "$V62B" blocked-task operator blocked-task blocked
run_dispatch "$V62B" blocked-task --actor-cmd "$NOOP"
expect_rc 0 "$RC" "62a — a real BLOCKED_OPERATOR result passes the semantic boundary and still exits 0" "$OUT"
RID62B="$(run_id_of "$OUT")"
ROOT62B="$(cd "$V62B/runs" && pwd -P)"
# THE SECOND CANONICAL ENDING, AND THE REASON ONE CALL COVERS BOTH. The seam
# passes result_outcome's answer for code 0; ST_CLASS is what makes that answer
# OPERATOR_TAKEOVER here and COMPLETED above, with no symbol at the call site.
if [ "$(res_field "$ROOT62B/$RID62B.result" outcome)" = OPERATOR_TAKEOVER ] &&
   [ "$(res_field "$ROOT62B/$RID62B.result" code)" = 0 ] &&
   [ ! -d "$(task_lock_for "$V62B" blocked-task)" ] && [ ! -d "$(checkout_lock_for "$V62B")" ]; then
  ok "62a — the accepted takeover terminal carries OPERATOR_TAKEOVER/0 and released both leases"
else
  bad "62a — the accepted takeover terminal carries OPERATOR_TAKEOVER/0 and released both leases" \
      "outcome=$(res_field "$ROOT62B/$RID62B.result" outcome) code=$(res_field "$ROOT62B/$RID62B.result" code) leases held"
fi

echo
echo "Case 62b — a record altered ONLY in outcome, or ONLY in code, is refused before release"
# The unit's red. Each fixture leaves task, checkout, run, path and structure
# exactly as the producer wrote them — 61b already proved the other three
# boundaries accept precisely this — so only meaning can reject it, and the two
# rejections must be distinguishable.
if mk_alter62 "$MUT62/outonly.sh" 's/^outcome=.*/outcome=OPERATOR_TAKEOVER/' 'harness outcome-only alteration'; then
  ok "62b — the outcome-only forcing fixture differs from the dispatcher and is valid bash"
  expect_sem_refusal62 "$MUT62/outonly.sh" closed-task outcome-mismatch \
    "62b — a CLOSED run whose record claims OPERATOR_TAKEOVER"
else
  bad "62b — the outcome-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi
if mk_alter62 "$MUT62/codeonly.sh" 's/^code=.*/code=22/' 'harness code-only alteration'; then
  ok "62b — the code-only forcing fixture differs from the dispatcher and is valid bash"
  expect_sem_refusal62 "$MUT62/codeonly.sh" closed-task code-mismatch \
    "62b — a CLOSED run whose record claims code 22"
else
  bad "62b — the code-only forcing fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi
# THE OTHER CANONICAL ENDING IS GATED TOO, not merely the one the fixtures were
# written against. A takeover record claiming COMPLETED is the mirror image of
# 62b's first fixture, and it is the one an operator would most be misled by:
# "finished" printed over a task still waiting on them.
if mk_alter62 "$MUT62/outonly-blocked.sh" 's/^outcome=.*/outcome=COMPLETED/' 'harness outcome-only alteration'; then
  ok "62b — the takeover outcome-only fixture differs from the dispatcher and is valid bash"
  expect_sem_refusal62 "$MUT62/outonly-blocked.sh" blocked-task outcome-mismatch \
    "62b — a BLOCKED_OPERATOR run whose record claims COMPLETED"
else
  bad "62b — the takeover outcome-only fixture differs from the dispatcher and is valid bash" \
      "the awk injection matched nothing, or the fixture does not parse — the case cannot run"
fi

echo
echo "Case 62c — the expectation is the caller's, and all four seams supply one"
# Structural, against the shipped text, and it carries the unit's scope claim.
#
# INDEPENDENCE FIRST. The call site must derive its expected symbol through the
# sole mapping owner and state its expected code as a literal — never read either
# from the artifact. A call site that passed a field out of the record would
# compare it with itself, and 62b would go green on a forgery.
CALL62="$(grep -n '# operator terminal consumption' "$DISPATCH_BIN" | cut -d: -f2-)"
if printf '%s\n' "$CALL62" | grep -q 'result_outcome 0' &&
   ! printf '%s\n' "$CALL62" | grep -qE 'RESULT_FILE|TR_OUTCOME|TR_CODE|res_field|\.result'; then
  ok "62c — the seam derives its expected pair through result_outcome and reads nothing from the artifact"
else
  bad "62c — the seam derives its expected pair through result_outcome and reads nothing from the artifact" \
      "call site: $CALL62"
fi
# WHICH CONSUMERS ARE MIGRATED, NAMED RATHER THAN COUNTED LOOSELY. Every
# consume_terminal_result call site is enumerated from the shipped text and
# classified by whether it supplies a pair. All five must now — the operator
# terminal (Unit 27), the dry-run terminal (Unit 28), the post-hop carry-one
# terminal (Unit 29, case 60j), the interruption terminal (Unit 30, case 27w) and
# the shared nonzero die() funnel (Unit 32, case 50k). Asserting the exact NAMES,
# not just a count, is what stops a later unit migrating one seam while silently
# dropping another and still satisfying "five".
#
# COMPARED AS SORTED SETS, because the enumeration follows the order the call
# sites happen to appear in the dispatcher. Spelling out every permutation was
# already awkward at two names and is the wrong assertion at three: what is being
# claimed is which seams, not where they sit in the file.
#
# THE DEFERRED SIDE IS THE HALF THAT MATTERS HERE. This assertion is the honest
# limit on 56e: the composed boundary exists for every caller, and this case says
# which callers are actually subject to it. With Unit 32 that list includes the
# shared nonzero die() funnel, so no marked consumer remains deferred. It still
# makes no claim about the direct pre-run exits that never reach the funnel, or
# about the finalization-failure transfer, which exits without an artifact to
# consume — neither is a call site here.
SUPPLY62=''; NOSUPPLY62=''
# CALL SITES ONLY, and the selection is deliberately narrow twice over. Comment
# lines are dropped because prose that names the function is not a call — the
# dry-run seam's own note cites `consume_terminal_result` and was miscounted as a
# deferred consumer until this filter existed. The end-of-line marker is what
# identifies the rest: every production call site carries `# <seam> terminal
# consumption`, which is also the handle every mutation control addresses them
# by, so a call site without one would be invisible to those controls too and is
# correctly treated as not existing here.
while IFS= read -r l; do
  if printf '%s\n' "$l" | grep -q 'result_outcome'; then
    SUPPLY62="$SUPPLY62$(printf '%s\n' "$l" | sed 's/.*# //;s/ .*//');"
  else
    NOSUPPLY62="$NOSUPPLY62$(printf '%s\n' "$l" | sed 's/.*# //;s/ .*//');"
  fi
done <<EOF
$(grep -n 'consume_terminal_result' "$DISPATCH_BIN" |
  grep -v 'consume_terminal_result()' |
  grep -v '^[0-9]*:[[:space:]]*#' |
  grep ' terminal consumption$')
EOF
sort62() { printf '%s' "$1" | tr ';' '\n' | grep -v '^$' | LC_ALL=C sort | tr '\n' ';'; }
if [ "$(sort62 "$SUPPLY62")" = 'carry-one;die-funnel;dry-run;interruption;operator;' ]; then
  ok "62c — all five call sites supply an expected pair: the operator, dry-run, carry-one, interruption and shared nonzero die() funnel terminals"
else
  bad "62c — all five call sites supply an expected pair: the operator, dry-run, carry-one, interruption and shared nonzero die() funnel terminals" \
      "supplying='$SUPPLY62'"
fi
# THE EMPTY SIDE IS ASSERTED, NOT DROPPED. With the last consumer migrated this
# list must be empty, and saying so is a different claim from deleting the
# assertion: a sixth call site added later without a pair would land here, and a
# case that had stopped looking would not see it.
if [ -z "$(sort62 "$NOSUPPLY62")" ]; then
  ok "62c — no consumer call site is left without an expected pair"
else
  bad "62c — no consumer call site is left without an expected pair" \
      "not-supplying='$NOSUPPLY62'"
fi
# THE MIGRATED SEAM, BEHAVIOURALLY. This line predates Unit 29, when it asserted
# that the then-deferred carry-one terminal was untouched by the shared boundary.
# It is kept and re-read rather than deleted: the same run now has to stay green
# with that seam MIGRATED, which is what would catch an expectation derived
# wrongly at the new call site — it would surface here as a 38 on a carried hop
# that did nothing wrong. The deferred seam that remains is interruption, and
# the structural assertion above is what carries that claim.
V62D="$(new_sandbox)"; state_file "$V62D" carry-defer-task codex
run_dispatch "$V62D" carry-defer-task --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "62c — the migrated carry-one terminal still exits 0 and releases on a genuine carried hop" "$OUT"

echo
echo "Case 62d — mutation control: remove ONLY the expected pair and both mismatches release again"
# M33 — strip exactly the two expectation arguments from the operator-terminal
# call, leaving the consume call, the path gate, the structural parse and the
# identity boundary all in place. That is the narrowest possible removal of THIS
# integration: with no pair supplied, the composed semantic boundary is skipped
# and the pre-edit behaviour returns. Fails closed — unless the selector matched
# exactly once and the mutant differs and parses, the control does not run.
sed 's/ "" "$(result_outcome 0)" 0 # operator terminal consumption/ # operator terminal consumption/' \
  "$DISPATCH_BIN" >"$MUT62/m33.sh" 2>/dev/null
M33_HITS="$(grep -c ' "" "\$(result_outcome 0)" 0 # operator terminal consumption' "$DISPATCH_BIN" 2>/dev/null || true)"
M33_LEFT="$(grep -c ' "" "\$(result_outcome 0)" 0 # operator terminal consumption' "$MUT62/m33.sh" 2>/dev/null || true)"
M33_KEPT="$(grep -c '# operator terminal consumption' "$MUT62/m33.sh" 2>/dev/null || true)"
M33_DIFFERS=no; cmp -s "$DISPATCH_BIN" "$MUT62/m33.sh" || M33_DIFFERS=yes
M33_PARSES=no; bash -n "$MUT62/m33.sh" 2>/dev/null && M33_PARSES=yes
if [ "$M33_HITS" = 1 ] && [ "$M33_LEFT" = 0 ] && [ "$M33_KEPT" = 1 ] &&
   [ "$M33_DIFFERS" = yes ] && [ "$M33_PARSES" = yes ]; then
  ok "62d — M33 removed exactly the expected pair, kept the consumer call, differs, and parses"
  for f in outonly:OPERATOR_TAKEOVER:outcome codeonly:22:code; do
    m="${f%%:*}"; rest="${f#*:}"; v="${rest%%:*}"; fld="${rest##*:}"
    if mk_alter62 "$MUT62/m33-$m.sh" "s/^$fld=.*/$fld=$v/" "harness $fld-only alteration" "$MUT62/m33.sh"; then
      V62M="$(new_sandbox)"; state_file "$V62M" closed-task operator
      OUT="$(bash "$MUT62/m33-$m.sh" --checkout "$V62M" --task closed-task \
            --log-dir "$V62M/runs" --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RCM=$?
      if [ "$RCM" -eq 0 ] && [ ! -d "$(task_lock_for "$V62M" closed-task)" ] &&
         [ ! -d "$(checkout_lock_for "$V62M")" ]; then
        ok "62d — M33: without the expected pair the $fld-only mismatch exits 0 and releases (62b is fail-capable)"
      else
        bad "62d — M33: without the expected pair the $fld-only mismatch exits 0 and releases (62b is fail-capable)" \
            "rc=$RCM leases: task=$([ -d "$(task_lock_for "$V62M" closed-task)" ] && echo present || echo absent)"
      fi
    else
      bad "62d — M33: the $fld-only fixture over the mutant differs and parses" \
          "the injection matched nothing, or the fixture does not parse — the control cannot run"
    fi
  done
else
  bad "62d — M33 removed exactly the expected pair, kept the consumer call, differs, and parses" \
      "matched=$M33_HITS left=$M33_LEFT kept=$M33_KEPT differs=$M33_DIFFERS parses=$M33_PARSES — the control cannot run"
fi


# =================================================================== case 63a
# THE ADMISSION BOUNDARY REACHES THE EVIDENCE LOCATION, NOT ONLY THE TASK AND
# THE CHECKOUT.
#
# The approved plan admits a run only once task, checkout AND the evidence
# location have been supplied and established as trusted; before that point an
# invalid invocation must launch no actor, take no owner or lease, mutate
# nothing and write no evidence. Task and checkout already cleared that bar
# (dispatch.sh, the task-id and checkout blocks). The evidence location did not:
# its directory was created and canonicalized far BELOW acquire_lock, so an
# invocation naming a location it could never write to still took both leases
# first — and, where another run already held one, filed a refusal record — for
# a run that was never admissible in the first place.
#
# THE DETECTOR IS THE LEASE ROOT, and it is chosen because the leases themselves
# are released by the EXIT trap. Once the process is gone, "no lease directory"
# is true whether the lease was taken or not, so asserting on the two lease
# directories alone would pass against the very defect under test. The lease
# ROOT is created by wl_lease_acquire (logs/scripts/work-loop-lease.sh) and is
# NOT removed by release, which removes only the two lease directories — so in a
# sandbox that has never admitted a run, its existence is a durable one-way
# record that acquire_lock ran. That is the assertion that is red before the fix
# and green after it.
echo
echo "Case 63a — an unusable evidence location is refused BEFORE admission: no lease, no evidence, no actor"
d="$(new_sandbox)"; state_file "$d" "evidence-loc-task" "codex"
rm -f "$d.calls"
# Unusable because a REGULAR FILE sits where a parent directory would have to
# be: mkdir -p can never succeed under it, so this invocation could never have
# written one line of its own run evidence.
printf 'not a directory\n' >"$d/blocked-runs"
BAD_LOGS="$d/blocked-runs/inside"
LEASE_ROOT="$(lock_root_for "$d")"
[ ! -e "$LEASE_ROOT" ] \
  && ok "63a setup — this sandbox has never admitted a run (no shared lease root yet)" \
  || bad "63a setup — this sandbox has never admitted a run (no shared lease root yet)" \
         "$(ls -a "$LEASE_ROOT" 2>&1 | tr '\n' ' ')"
BEFORE="$(git -C "$d" rev-parse HEAD)"
TREE_BEFORE="$(tree_manifest "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task evidence-loc-task \
      --log-dir "$BAD_LOGS" --timeout 20 --actor-cmd "$FLIP" 2>&1)"; RC=$?
TREE_AFTER="$(tree_manifest "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain)"
expect_rc 10 "$RC" "the unusable evidence location is refused as usage" "$OUT"
out_has "STOP [10]" "$OUT" "  and the refusal names itself on stderr"
out_has "$BAD_LOGS" "$OUT" "  and names the location it refused"
# THE ASSERTION THAT FAILS AGAINST THE DEFECT.
[ ! -e "$LEASE_ROOT" ] \
  && ok "  and no lease was ever acquired — the shared lease root was never created" \
  || bad "  and no lease was ever acquired — the shared lease root was never created" \
         "$(ls -a "$LEASE_ROOT" 2>&1 | tr '\n' ' ')"
[ ! -e "$BAD_LOGS" ] \
  && ok "  and the evidence location itself was not created" \
  || bad "  and the evidence location itself was not created" "$BAD_LOGS exists"
[ -f "$d/blocked-runs" ] && [ "$(cat "$d/blocked-runs")" = "not a directory" ] \
  && ok "  and the file standing in its way is byte-identical" \
  || bad "  and the file standing in its way is byte-identical" \
         "$(ls -la "$d/blocked-runs" 2>&1 | tr '\n' ' ')"
if [ "$TREE_BEFORE" = "$TREE_AFTER" ]; then
  ok "  and every byte of the checkout's working tree is unchanged"
else
  bad "  and every byte of the checkout's working tree is unchanged" \
      "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -10 | tr '\n' ' ')"
fi
[ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and git status is unchanged" \
  || bad "  and git status is unchanged" "before [$STATUS_BEFORE] after [$STATUS_AFTER]"
[ "$(calls "$d")" = "0" ] \
  && ok "  and no actor was launched" || bad "  and no actor was launched" "calls=$(calls "$d")"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" || bad "  and committed nothing" "HEAD moved from $BEFORE"

# ------------------------------------------------------------ case 63a, part 2
# THE OTHER HALF OF THE SAME BOUNDARY: writes no evidence for a non-run.
#
# Part 1 proves no lease is taken when no lease is contended. It cannot prove
# the evidence half, because with nothing holding the lease there is no refusal
# record to write either way. So this half puts a REAL second dispatcher on the
# lease, and the two outcomes are then distinguishable:
#
#   before the fix — the invalid invocation reaches acquire_lock, loses, exits
#                    17, and files a refusal record for a run that was never
#                    admissible;
#   after  the fix — it never reaches the lease at all, exits 10 over its own
#                    unusable evidence location, and files nothing.
#
# The lease is HELD BY A REAL DISPATCHER rather than planted, for the reason
# case 12h gives: what is under test is an ORDERING, and only a live holder puts
# the acquisition path where the ordering can be observed.
echo
echo "Case 63a (2) — the same refusal files no evidence, even with the lease already held"
d2="$(new_sandbox)"; state_file "$d2" "evidence-held-task" "codex"
rm -f "$d2.calls" "$d2.holder"
HOLDER2_LOGS="$SANDBOX_ROOT/63a-holder-runs"   # OUTSIDE the checkout, so only the loser can move its bytes
BAD_LOGS2="$d2/blocked-runs/inside"
REFUSALS2="$(lock_root_for "$d2")/refusals"
( bash "$DISPATCH_BIN" --checkout "$d2" --task evidence-held-task --log-dir "$HOLDER2_LOGS" \
    --timeout 90 \
    --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.holder"; sleep 30; exit 0' \
    >/dev/null 2>&1 ) &
holder2=$!
# Waited on the ACTOR, not on the lease — case 12h's reason exactly: the holder
# still touches the checkout between taking the lease and launching.
for _ in $(seq 1 120); do [ -f "$d2.holder" ] && break; sleep 0.5; done
[ -f "$d2.holder" ] \
  && ok "63a(2) setup — the holding dispatcher is admitted and inside its actor" \
  || bad "63a(2) setup — the holding dispatcher is admitted and inside its actor" "no $d2.holder marker"
# PLANTED ONLY NOW, and the ordering is load-bearing: an untracked file present
# before the holder launched would stop the HOLDER at 18 (out-of-allowlist
# working-tree changes) and there would be no held lease to test against.
printf 'not a directory\n' >"$d2/blocked-runs"
n_ref_before="$(ls -1 "$REFUSALS2" 2>/dev/null | wc -l | tr -d ' ')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d2" --task evidence-held-task \
      --log-dir "$BAD_LOGS2" --timeout 20 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 10 "$RC" "  it refuses on its own evidence location, not at the held lease (17)" "$OUT"
[ "$n_ref_before" = "$(ls -1 "$REFUSALS2" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  and filed no refusal record — a non-run leaves no durable record" \
  || bad "  and filed no refusal record — a non-run leaves no durable record" \
         "refusal count moved from $n_ref_before to $(ls -1 "$REFUSALS2" 2>/dev/null | wc -l | tr -d ' ')"
[ ! -e "$BAD_LOGS2" ] \
  && ok "  and still created no evidence directory" \
  || bad "  and still created no evidence directory" "$BAD_LOGS2 exists"
[ "$(calls "$d2")" = "0" ] \
  && ok "  and still launched no actor" || bad "  and still launched no actor" "calls=$(calls "$d2")"
wait "$holder2" 2>/dev/null
rm -rf "$(task_lock_for "$d2" evidence-held-task)" "$(checkout_lock_for "$d2")" 2>/dev/null

# =================================================================== case 63b
# THE POSITIVE CONTROL, and without it 63a passes against a dispatcher that
# refuses every evidence location it is given. Everything asserted above is an
# absence — no lease, no directory, no record, no actor — and a boundary that
# had simply become "refuse always" would satisfy all of it. This is the
# ORDINARY invocation, and it must still reach the admitted-run path.
#
# The requested directory DELIBERATELY DOES NOT EXIST. That is what a first run
# looks like, and it is the case a naive "the directory must already be there"
# check would break — so it is the one the control has to make.
echo
echo "Case 63b — a legitimate invocation still reaches the admitted-run path, requested and default"
d3="$(new_sandbox)"; state_file "$d3" "evidence-ok-task" "codex"
rm -f "$d3.calls"
FRESH_LOGS="$d3/fresh-runs"
[ ! -e "$FRESH_LOGS" ] \
  && ok "63b setup — the requested evidence directory does not exist yet" \
  || bad "63b setup — the requested evidence directory does not exist yet" "$FRESH_LOGS already exists"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d3" --task evidence-ok-task \
      --log-dir "$FRESH_LOGS" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
if [ "$RC" -ne 10 ]; then
  ok "the boundary did not refuse a creatable evidence location (exit $RC, not 10)"
else
  bad "the boundary did not refuse a creatable evidence location" "exited 10: $OUT"
fi
AL3="$(ls -t "$FRESH_LOGS"/*.log 2>/dev/null | head -1)"
if [ -n "$AL3" ] && grep -q '^run=' "$AL3"; then
  ok "  and the admitted run created the requested directory and wrote its own header into it"
else
  bad "  and the admitted run created the requested directory and wrote its own header into it" \
      "$(ls -a "$FRESH_LOGS" 2>&1 | tr '\n' ' ')"
fi
[ "$(calls "$d3")" = "1" ] \
  && ok "  and the actor really launched — this is an admitted run, not another refusal" \
  || bad "  and the actor really launched" "calls=$(calls "$d3")"
rm -rf "$(task_lock_for "$d3" evidence-ok-task)" "$(checkout_lock_for "$d3")" 2>/dev/null
# THE DEFAULT LOCATION IS COVERED TOO. The boundary validates the requested
# location OR the default one, and only an invocation that passes no --log-dir
# exercises the second.
#
# This leg asserts the run's own header rather than a completed hop. The default
# location sits under plans/, which new_sandbox creates and never commits, so
# `git status` reports the whole `plans/` directory as untracked and the pre-hop
# gate stops at 18 for a reason that has nothing to do with this boundary. The
# header is written by the run-evidence block itself, so it is the exact fact
# this leg needs: the default location was accepted and used.
d4="$(new_sandbox)"; state_file "$d4" "evidence-default-task" "codex"
rm -f "$d4.calls"
DEF_LOGS="$d4/plans/work-loop-v2-v0.2/handoff-automation-spike/runs"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d4" --task evidence-default-task \
      --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
if [ "$RC" -ne 10 ]; then
  ok "  and the DEFAULT evidence location is not refused either (exit $RC, not 10)"
else
  bad "  and the DEFAULT evidence location is not refused either" "exited 10: $OUT"
fi
AL4="$(ls -t "$DEF_LOGS"/*.log 2>/dev/null | head -1)"
if [ -n "$AL4" ] && grep -q '^run=' "$AL4"; then
  ok "  and the default directory received the run's own header"
else
  bad "  and the default directory received the run's own header" \
      "$(ls -a "$DEF_LOGS" 2>&1 | tr '\n' ' ')"
fi
rm -rf "$(task_lock_for "$d4" evidence-default-task)" "$(checkout_lock_for "$d4")" 2>/dev/null

# =================================================================== case 64a
# A LEASE REFUSAL IS A TERMINAL OF AN ADMITTED RUN, AND OWES ONE RESULT.
#
# Under the revised plan a run exists once task, checkout and evidence location
# are supplied and trusted — all of which happen long before the lease is asked
# for. So an invocation refused at the lease is not a run that "lost admission";
# it is an admitted run reaching one of Change set A's enumerated terminal
# classes, and it must finalize exactly one run-bound terminal result through the
# same producer/consumer contract every other terminal uses.
#
# BEFORE THIS UNIT it could not. finalize_terminal_result() refuses to write
# without RUN_ID and LOG_DIR, and both were created BELOW acquire_lock, so the
# refusal had neither — which is why it carried a standalone `.refusal` record of
# its own under the shared lease root. That record is the competing second
# authority this case also asserts is gone: one ending, one durable record.
#
# THE LEASE IS HELD BY A REAL SECOND DISPATCHER, for case 12h's reason: what is
# under test is an ordering on the live acquisition path, and a planted directory
# would reach the same branch without exercising it.
echo
echo "Case 64a — an admitted run refused at the lease finalizes exactly ONE run-bound terminal result"
d="$(new_sandbox)"; state_file "$d" "lease-result-task" "codex"
rm -f "$d.calls" "$d.holder"
LOSER64="$d/runs"                              # the loser's OWN evidence location, inside its checkout
HOLDER64="$SANDBOX_ROOT/64a-holder-runs"       # outside it, so the two runs' evidence cannot be confused
REFUSALS64="$(lock_root_for "$d")/refusals"
STATE64="$d/logs/work-loop/lease-result-task.md"
ST64_BEFORE="$(shasum -a 256 "$STATE64" | cut -d' ' -f1)"
HEAD64="$(git -C "$d" rev-parse HEAD)"
( bash "$DISPATCH_BIN" --checkout "$d" --task lease-result-task --log-dir "$HOLDER64" \
    --timeout 90 \
    --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.holder"; sleep 30; exit 0' \
    >/dev/null 2>&1 ) &
holder64=$!
for _ in $(seq 1 120); do [ -f "$d.holder" ] && break; sleep 0.5; done
[ -f "$d.holder" ] \
  && ok "64a setup — the holding dispatcher is admitted and inside its actor" \
  || bad "64a setup — the holding dispatcher is admitted and inside its actor" "no $d.holder marker"
n_ref64="$(ls -1 "$REFUSALS64" 2>/dev/null | wc -l | tr -d ' ')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task lease-result-task \
      --log-dir "$LOSER64" --timeout 20 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 17 "$RC" "the second dispatcher is refused at 17 by a REAL held lease" "$OUT"
# THE ID IS READ FROM THE RUN'S OWN HEADER, never reconstructed here. A refusal
# that finalized a result under an id this harness invented would not be
# run-bound, and every assertion below has to fail in that case.
RID64="$(run_id_of "$OUT")"
if [ -n "$RID64" ]; then
  ok "  and the refused run announced a run identity of its own"
else
  bad "  and the refused run announced a run identity of its own" \
      "no run= header in the refusal output: $OUT"
fi
R64="$LOSER64/$RID64.result"

# EXACTLY ONE, and the count is the assertion. Zero is the pre-unit behaviour;
# two would mean a second producer appeared alongside the funnel.
[ "$(res_count "$LOSER64")" = "1" ] \
  && ok "  and finalized exactly one terminal result" \
  || bad "  and finalized exactly one terminal result" \
         "count=$(res_count "$LOSER64") in $(ls -a "$LOSER64" 2>&1 | tr '\n' ' ')"
[ "$(part_count "$LOSER64")" = "0" ] \
  && ok "  and left no unfinalized temporary artifact behind" \
  || bad "  and left no unfinalized temporary artifact behind" "$(ls "$LOSER64"/*.result.partial 2>&1)"
[ -n "$RID64" ] && [ -f "$R64" ] \
  && ok "  and it is the run-bound path the run announced" \
  || bad "  and it is the run-bound path the run announced" "expected $R64"
printf '%s\n' "$OUT" | grep -q "  terminal result: .*/$RID64\.result$" \
  && ok "  and the refusal prints that exact path — evidence nobody can find is not evidence" \
  || bad "  and the refusal prints that exact path" "$(printf '%s\n' "$OUT" | grep 'terminal result' || printf '<no line>')"

# THE MEANING, field by field. A record that exists but says the wrong thing is
# worse than none: it is a durable false statement about how the run ended.
for pair in outcome:LOCK_HELD code:17 result_complete:yes \
            actor_launched:no model_request_started:no stage:pre-hop \
            next_action:wait-for-lease-holder lease_task_at_finalization:held-by-other; do
  k="${pair%%:*}"; want="${pair#*:}"; got="$(res_field "$R64" "$k")"
  [ "$got" = "$want" ] \
    && ok "    the result carries $k=$want" \
    || bad "    the result carries $k=$want" "got: ${got:-<absent>}"
done
# IDENTITY-BOUND, all three ways. A result that names another run, another task
# or another checkout is not this run's proof of how it ended.
[ "$(res_field "$R64" task)" = "lease-result-task" ] \
  && ok "    and names this task" || bad "    and names this task" "got: $(res_field "$R64" task)"
[ "$(res_field "$R64" checkout)" = "$(cd "$d" && pwd -P)" ] \
  && ok "    and names this checkout" || bad "    and names this checkout" "got: $(res_field "$R64" checkout)"
# Guarded on RID64 being non-empty, or the comparison is `"" = ""` and passes
# against a run that announced no identity at all — which is precisely the
# pre-unit behaviour this case exists to catch.
[ -n "$RID64" ] && [ "$(res_field "$R64" run)" = "$RID64" ] \
  && ok "    and names this run" || bad "    and names this run" "got: '$(res_field "$R64" run)' want: '$RID64'"

# THE COMPETING RECORD IS GONE. This is the "not two authorities" half, and it
# fails loudly against the pre-unit dispatcher, which filed one here.
[ "$n_ref64" = "$(ls -1 "$REFUSALS64" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  and filed no standalone refusal record alongside it" \
  || bad "  and filed no standalone refusal record alongside it" \
         "refusal count moved from $n_ref64 to $(ls -1 "$REFUSALS64" 2>/dev/null | wc -l | tr -d ' ')"

# NOTHING WAS LAUNCHED AND NOTHING WAS DECIDED. The record's whole value is that
# it describes a refusal, so an actor start or a state edit would make it false.
[ "$(calls "$d")" = "0" ] \
  && ok "  and launched no actor" || bad "  and launched no actor" "calls=$(calls "$d")"
[ "$(shasum -a 256 "$STATE64" | cut -d' ' -f1)" = "$ST64_BEFORE" ] \
  && ok "  and left the state file byte-identical" || bad "  and left the state file byte-identical"
[ "$(git -C "$d" rev-parse HEAD)" = "$HEAD64" ] \
  && ok "  and committed nothing" || bad "  and committed nothing" "HEAD moved from $HEAD64"
wait "$holder64" 2>/dev/null
rm -rf "$(task_lock_for "$d" lease-result-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# =================================================================== case 64b
# THE NO-CONTENTION CONTROL, and without it 64a passes against a dispatcher that
# refuses at the lease unconditionally. Moving the lease call below the
# run-evidence block is exactly the kind of change that can leave a run holding
# its own evidence and never getting past acquisition, so the control has to be
# the ordinary uncontended run: it must still take both leases, launch, and
# release.
echo
echo "Case 64b — with no contention an admitted run still gets past lease acquisition and launches"
d5="$(new_sandbox)"; state_file "$d5" "lease-clear-task" "codex"
rm -f "$d5.calls"
run_dispatch "$d5" lease-clear-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -ne 17 ]; then
  ok "the uncontended run was not refused at the lease (exit $RC, not 17)"
else
  bad "the uncontended run was not refused at the lease" "exited 17 with nothing holding: $OUT"
fi
[ "$(calls "$d5")" = "1" ] \
  && ok "  and the actor really launched past acquisition" \
  || bad "  and the actor really launched past acquisition" "calls=$(calls "$d5")"
RID64B="$(run_id_of "$OUT")"
[ -n "$RID64B" ] && [ "$(res_field "$d5/runs/$RID64B.result" lease_task_at_finalization)" = "held-by-this-run" ] \
  && ok "  and its own result records the lease as held by this run, not by another" \
  || bad "  and its own result records the lease as held by this run, not by another" \
         "got: $(res_field "$d5/runs/$RID64B.result" lease_task_at_finalization)"
# RELEASED, not leaked. The lease call moved; the release path must still run.
[ ! -d "$(task_lock_for "$d5" lease-clear-task)" ] && [ ! -d "$(checkout_lock_for "$d5")" ] \
  && ok "  and both leases were released on the way out" \
  || bad "  and both leases were released on the way out" \
         "task=$([ -d "$(task_lock_for "$d5" lease-clear-task)" ] && echo present || echo absent) checkout=$([ -d "$(checkout_lock_for "$d5")" ] && echo present || echo absent)"
rm -rf "$(task_lock_for "$d5" lease-clear-task)" "$(checkout_lock_for "$d5")" 2>/dev/null
# =================================================================== case 65a
# ONE STABLE EVIDENCE LOCATION IS THE SUPPORTED PATH, AND IT MUST NOT BE BROKEN
# BY KEEPING THE FOREIGN-WORK GATE STRICT.
#
# THE HISTORY MATTERS HERE, because this case used to assert the opposite claim.
# Case 12h-ok recorded a deferral: a dispatcher allowlists only the log directory
# IT was pointed at, so a later run aimed at a DIFFERENT --log-dir read the
# earlier run's evidence as out-of-allowlist litter and stopped at 18 before
# launching anything. The first repair taught the gate to recognise a prior run's
# own evidence by reading the run log header its artifacts were written under.
# That recognition was removed: the receipt lives in the working tree, anything
# with write access to the checkout can write one, and freezing the answer before
# the first launch closes the hole against THIS run's actors but not against
# content that was already there (case 65d). What replaces it is an operating
# rule — one stable evidence location per checkout — and this case is the half
# that proves the rule actually works.
#
# THE SHARPEST FORM OF THE SEQUENCE IS A LEASE-REFUSED FIRST RUN. Since Unit 2 a
# refusal at the lease is a terminal of an ADMITTED run and finalizes a real
# result inside its own evidence directory (case 64a) — so the very artifact
# Unit 2 made the dispatcher write is the one most likely to obstruct the next
# run. Pointed at the same stable location, it must not: that directory is this
# run's allowlisted evidence location too, so the gate never sees it.
#
# WHAT THIS CASE MUST NOT BECOME. "The second run no longer exits 18" is
# satisfied by deleting the foreign-work gate, so it is not the claim on its own:
# 65b, 65c and 65d below are the other half, and they must still stop.
echo
echo "Case 65a — two sequential runs sharing ONE stable evidence location both reach their intended terminal"
d="$(new_sandbox)"; state_file "$d" "sequential-evidence-task" "codex"
rm -f "$d.calls" "$d.holder"
DIR65="$d/runs-stable"                     # the ONE evidence location, INSIDE the checkout, used by both runs
HOLDER65="$SANDBOX_ROOT/65a-holder-runs"   # the lease holder's, OUTSIDE it, so only run A's evidence lands in the tree
( bash "$DISPATCH_BIN" --checkout "$d" --task sequential-evidence-task --log-dir "$HOLDER65" \
    --timeout 90 \
    --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.holder"; sleep 12; exit 0' \
    >/dev/null 2>&1 ) &
holder65=$!
for _ in $(seq 1 120); do [ -f "$d.holder" ] && break; sleep 0.5; done
[ -f "$d.holder" ] \
  && ok "65a setup — the holding dispatcher is admitted and inside its actor" \
  || bad "65a setup — the holding dispatcher is admitted and inside its actor" "no $d.holder marker"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task sequential-evidence-task \
      --log-dir "$DIR65" --timeout 20 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 17 "$RC" "65a setup — run A is refused at the lease and is therefore an admitted run" "$OUT"
[ "$(res_count "$DIR65")" = "1" ] \
  && ok "65a setup — run A left exactly one terminal result in the stable location" \
  || bad "65a setup — run A left exactly one terminal result in the stable location" \
         "count=$(res_count "$DIR65") in $(ls -a "$DIR65" 2>&1 | tr '\n' ' ')"
wait "$holder65" 2>/dev/null
rm -rf "$(task_lock_for "$d" sequential-evidence-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# NOW THE SECOND RUN, aimed at the SAME location. Nothing contends with it, the
# state file is untouched and committed, and the only dispatcher-written thing in
# the working tree is run A's evidence — sitting in the directory run B was
# itself pointed at, which is why the gate never has an opinion about it.
rm -f "$d.calls"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task sequential-evidence-task \
      --log-dir "$DIR65" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
if [ "$RC" -ne 18 ]; then
  ok "run B is not refused as foreign work (exit $RC, not 18)"
else
  bad "run B is not refused as foreign work" "exited 18 over run A's own evidence: $OUT"
fi
# NOT REFUSED IS NOT THE SAME CLAIM AS RAN. Exit 18 is taken before the launch,
# so the launch is what proves the stop is gone rather than moved.
[ "$(calls "$d")" = "1" ] \
  && ok "  and its actor really launched past the pre-hop gate" \
  || bad "  and its actor really launched past the pre-hop gate" "calls=$(calls "$d")"
RID65B="$(run_id_of "$OUT")"
[ -n "$RID65B" ] && [ -f "$DIR65/$RID65B.result" ] \
  && ok "  and run B wrote its own run-bound result into the same stable location" \
  || bad "  and run B wrote its own run-bound result into the same stable location" \
         "expected $DIR65/$RID65B.result; it holds $(ls -a "$DIR65" 2>&1 | tr '\n' ' ')"
# BOTH RESULTS, not one overwritten by the other. Sharing a location is only a
# supported path if the earlier run's durable terminal survives the later run.
[ "$(res_count "$DIR65")" = "2" ] \
  && ok "  and run A's terminal result is still there beside it — two results, neither overwritten" \
  || bad "  and run A's terminal result is still there beside it" "count=$(res_count "$DIR65")"
[ -z "$(git -C "$d" diff --cached --name-only 2>/dev/null)" ] \
  && ok "  and nothing of run A's was staged on the way past" \
  || bad "  and nothing of run A's was staged" "$(git -C "$d" diff --cached --name-only)"
# NOTHING IS EXCUSED ANY MORE, and this is the line that says so. The removed
# mechanism announced every path it dropped from the gate's view; a run that
# still printed that announcement would still be carrying the mechanism.
out_lacks "prior_run_evidence" "$OUT" "  and no path was excused from the gate to achieve it"
rm -rf "$(task_lock_for "$d" sequential-evidence-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# =================================================================== case 65b
# THE NEGATIVE CONTROL: A GENUINELY FOREIGN PATH STILL STOPS THE RUN.
#
# 65a is satisfied by any change that stops looking at the working tree, so this
# is the half that keeps it honest. A prior run's evidence sits in the shared
# stable location exactly as in 65a, and an unrelated untracked path sits beside
# it — the pre-hop gate must still take exit 18, and the message must name the
# foreign path rather than the run's own evidence directory, or an operator sent
# to "commit, stash or revert the paths above" is sent to the wrong files.
#
# Run A here is an ORDINARY admitted run rather than a lease-refused one. What
# 65b needs is real dispatcher evidence in the tree, which either shape produces;
# the refused shape is 65a's subject and costs a live holder to arrange.
echo
echo "Case 65b — an unrelated untracked path beside the stable evidence location still stops the next run"
d="$(new_sandbox)"; state_file "$d" "foreign-control-task" "codex"
rm -f "$d.calls"
DIR65B="$d/runs-stable"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task foreign-control-task \
      --log-dir "$DIR65B" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
[ "$(res_count "$DIR65B")" = "1" ] \
  && ok "65b setup — run A left its evidence in the stable location" \
  || bad "65b setup — run A left its evidence in the stable location" \
         "rc=$RC count=$(res_count "$DIR65B") in $(ls -a "$DIR65B" 2>&1 | tr '\n' ' ')"
rm -rf "$(task_lock_for "$d" foreign-control-task)" "$(checkout_lock_for "$d")" 2>/dev/null
mkdir -p "$d/actor-scratch"
printf 'notes an actor left behind\n' >"$d/actor-scratch/notes.md"
rm -f "$d.calls"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task foreign-control-task \
      --log-dir "$DIR65B" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 18 "$RC" "the unrelated untracked path still stops the run at 18" "$OUT"
[ "$(calls "$d")" = "0" ] \
  && ok "  and no actor was launched over it" || bad "  and no actor was launched over it" "calls=$(calls "$d")"
# THE STOP MESSAGE, not the whole run — the same scoping the earlier revision
# used, kept because the assertion below is a negative one and the run log
# legitimately mentions its own evidence directory elsewhere.
STOP65B="$(printf '%s\n' "$OUT" | awk '/^STOP \[18\]/{f=1} f{print} /^Recoverable next action/{f=0}')"
out_has   "actor-scratch" "$STOP65B" "  and the stop names the foreign path"
out_lacks "runs-stable"   "$STOP65B" "  and the stop does NOT send the operator at this run's own evidence location"
rm -rf "$(task_lock_for "$d" foreign-control-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# =================================================================== case 65c
# THE CONTRACT ITSELF: AIMING A LATER RUN SOMEWHERE ELSE IS A REFUSAL, NOT A
# MIGRATION.
#
# This is the case that states the price of removing the recognition mechanism,
# and it is written as an assertion rather than left implicit so that nobody
# reintroduces the mechanism believing this behaviour was an accident. Run A used
# directory A. Run B is pointed at directory B while A is still untracked, so A
# is out-of-allowlist content run B was not pointed at — indistinguishable, from
# inside the checkout, from anything else somebody left lying there.
#
# THE REFUSAL HAS TO BE ACTIONABLE, which is the second half of the assertion.
# Naming the path and giving the existing recoverable-next-action guidance is
# what makes this a one-off operator step rather than a dead end.
echo
echo "Case 65c — a run aimed at a DIFFERENT evidence directory stops at 18 and names the old one"
d="$(new_sandbox)"; state_file "$d" "switched-evidence-task" "codex"
rm -f "$d.calls"
DIR_A65C="$d/runs-a"; DIR_B65C="$d/runs-b"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task switched-evidence-task \
      --log-dir "$DIR_A65C" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
[ "$(res_count "$DIR_A65C")" = "1" ] \
  && ok "65c setup — run A left its evidence under directory A" \
  || bad "65c setup — run A left its evidence under directory A" \
         "rc=$RC count=$(res_count "$DIR_A65C") in $(ls -a "$DIR_A65C" 2>&1 | tr '\n' ' ')"
rm -rf "$(task_lock_for "$d" switched-evidence-task)" "$(checkout_lock_for "$d")" 2>/dev/null
rm -f "$d.calls"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task switched-evidence-task \
      --log-dir "$DIR_B65C" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 18 "$RC" "switching evidence directories while the old one is untracked stops at 18" "$OUT"
[ "$(calls "$d")" = "0" ] \
  && ok "  and no actor was launched over it" || bad "  and no actor was launched over it" "calls=$(calls "$d")"
STOP65C="$(printf '%s\n' "$OUT" | awk '/^STOP \[18\]/{f=1} f{print} /^Recoverable next action/{f=0}')"
out_has "runs-a"                   "$STOP65C" "  and the stop names the old evidence directory"
out_has "Recoverable next action"  "$STOP65C" "  and gives the operator the existing actionable guidance"
# THE OLD DIRECTORY IS LEFT ALONE. A refusal that tidied the path away would be
# doing the migration it just refused to do, and silently.
[ "$(res_count "$DIR_A65C")" = "1" ] \
  && ok "  and directory A is untouched — refused, not tidied away" \
  || bad "  and directory A is untouched" "count=$(res_count "$DIR_A65C")"
rm -rf "$(task_lock_for "$d" switched-evidence-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# =================================================================== case 65d
# THE CASE THAT DECIDED THE DESIGN: CONTENT ALREADY IN THE TREE CANNOT BE TRUSTED.
#
# The removed mechanism recognised a directory as an earlier run's own evidence
# by reading the run log header its artifacts were written under. That header is
# a file in the working tree, and this case writes one — a directory, a lookalike
# log naming an id it invented, and a payload file named after that id — BEFORE
# the dispatcher starts. No actor of this run existed, so freezing the answer
# before the first launch cannot help: at the moment of the freeze the forgery is
# already there and satisfies the classifier exactly as a real receipt would.
#
# THIS IS NOT A HYPOTHETICAL SHAPE. A hop killed mid-write, a crashed previous
# run, or any other process with write access to the checkout can leave content
# behind, and the dispatcher restarts into a tree it did not write. Trusting it
# would let actor-writable content change what the foreign-work gate believes on
# the next start, which is the one thing the gate exists to prevent.
#
# Red before the removal: the run was excused, announced "prior_run_evidence=1",
# and launched its actor. Green after it: the path is out-of-allowlist like any
# other, and the run stops before anything is launched.
echo
echo "Case 65d — evidence-shaped content already in the tree before the run starts is not trusted"
d="$(new_sandbox)"; state_file "$d" "pre-existing-forgery-task" "codex"
rm -f "$d.calls"
FID65D='20260101T000000-forged'
mkdir -p "$d/runs-preexisting"
printf 'run=%s mode=simulated task=forged\n' "$FID65D" >"$d/runs-preexisting/$FID65D.log"
printf 'payload the operator was never shown\n'        >"$d/runs-preexisting/$FID65D.out"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task pre-existing-forgery-task \
      --log-dir "$d/runs" --timeout 20 --max-hops 1 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 18 "$RC" "content that merely LOOKS like a prior run's evidence still stops the run at 18" "$OUT"
[ "$(calls "$d")" = "0" ] \
  && ok "  and no actor was launched over it" || bad "  and no actor was launched over it" "calls=$(calls "$d")"
STOP65D="$(printf '%s\n' "$OUT" | awk '/^STOP \[18\]/{f=1} f{print} /^Recoverable next action/{f=0}')"
out_has "runs-preexisting" "$STOP65D" "  and the stop names the forged path"
out_lacks "prior_run_evidence" "$OUT" "  and nothing in the run claims to have recognised it as earlier evidence"
rm -rf "$(task_lock_for "$d" pre-existing-forgery-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# =================================================================== case 66a
# THE POST-HOP HALF: AN ACTOR THAT MINTS DISPATCHER-SHAPED EVIDENCE IS CAUGHT.
#
# 65a-65d are all about the PRE-HOP gate — refusing to run OVER somebody else's
# work. This is the post-hop delta, which catches the actor DOING something it
# was not allowed to, and it is the assertion that would have gone quiet first if
# the recognition mechanism had been kept: an actor that could mint the receipt
# could put its own work somewhere the delta no longer looked.
#
# It is unchanged by the removal and must stay green either way — which is the
# point. The mechanism was never what made this work; the allowlist is.
echo
echo "Case 66a — an actor that MINTS dispatcher-shaped evidence mid-hop is still caught"
d="$(new_sandbox)"; state_file "$d" "forged-evidence-task" "codex"
rm -f "$d.calls"
FORGE66='mkdir -p "$WL_CHECKOUT/runs-forged";
      printf "run=20260101T000000-forged mode=simulated task=forged\n" > "$WL_CHECKOUT/runs-forged/20260101T000000-forged.log";
      printf "work the operator was never shown\n" > "$WL_CHECKOUT/runs-forged/20260101T000000-forged.out";'
run_dispatch "$d" forged-evidence-task --max-hops 1 --actor-cmd "$FORGE66$FLIP"
expect_rc 24 "$RC" "the run stops at 24 when the actor mints a dispatcher-shaped directory" "$OUT"
[ "$(calls "$d")" = "1" ] \
  && ok "  and the actor really ran, so the stop is about what it did" \
  || bad "  and the actor really ran" "calls=$(calls "$d")"
out_has "runs-forged" "$OUT" "  and the stop names the minted directory"
[ -f "$d/runs-forged/20260101T000000-forged.out" ] \
  && ok "  and the minted files are left in place for the operator to look at" \
  || bad "  and the minted files are left in place" "$(ls -a "$d/runs-forged" 2>&1 | tr '\n' ' ')"
rm -rf "$(task_lock_for "$d" forged-evidence-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# ------------------------------------------------------------- 66b, 66c: gone
# RETIRED WITH THE MECHANISM THEY POLICED, and named here rather than deleted
# silently so the gap is a decision on the record.
#
# 66b asserted that an actor writing INSIDE a legitimately excused evidence
# directory was still caught at 24. 66c was its positive control: with the actor
# behaving, the same excused directory still let the run through. Both sentences
# begin "the excused directory", and after this unit no directory is excused —
# 66b's setup now stops at 18 before the actor it needs is ever launched, and
# 66c's claim is 65a's claim with a second directory it no longer needs.
#
# WHAT COVERS THEM NOW. 66a keeps the post-hop delta honest against an actor that
# builds evidence shapes from nothing, which is 66b's real subject once the
# excuse is gone; 65a keeps the sequential path working, which is 66c's.

# =================================================================== case 67a
#
# THE LAST ADMITTED TERMINAL WITH NO TEST AT ALL. Every other nonzero code in this
# dispatcher has at least an `expect_rc` pinning its exit; code 34
# OWNERSHIP_AMBIGUOUS had nothing — not a result assertion, not an exit assertion,
# nothing. It is reachable (work-loop-owner.sh returns AMBIGUOUS at exit 4, and
# dispatch.sh branches on that), it is post-admission, and the approved plan's
# Change set A requires exactly one atomically finalized terminal result for the
# invalid-state-or-ownership class it belongs to. So the gap was release proof,
# not polish.
#
# THE SIBLING IS 50e, which does the same job for OWNERSHIP_REFUSED (33) — a
# checkout declaring a DIFFERENT open task. This case is the other verdict the
# same helper can return, and it is a different route: 33 is a decision the helper
# reached, 34 is the helper reporting it could not reach one.
#
# THROUGH THE REAL HELPER, and that is the point of the fixture rather than an
# incidental detail. The declaration is made genuinely ambiguous — two task ids in
# one `.owner` file, which is the helper's own documented "holds more than one
# task id" row — so the AMBIGUOUS verdict is produced by the shipped helper's own
# logic. Nothing here calls finalize_terminal_result directly, stubs the helper,
# or plants a verdict.
echo
echo "Case 67a — an admitted OWNERSHIP_AMBIGUOUS refusal finalizes exactly one complete run-bound result"
d="$(new_sandbox)"; state_file "$d" "owner-ambiguous-task" "codex"
# TWO ids, one declaration. `marker_holder` collapses any multi-id or unreadable
# declaration to `?`, which check_local turns into AMBIGUOUS.
printf 'owner-ambiguous-task\nsome-other-task\n' >"$d/logs/work-loop/.owner"
# THE FIXTURE PROVES ITSELF FIRST. Without this, a case that stopped reaching the
# ambiguity route would keep asserting against whatever terminal it reached
# instead, and the ownership half of the claim would quietly stop being tested.
bash "$OWNER_BIN" check --checkout "$d" --task owner-ambiguous-task --depth repo >/dev/null 2>&1
expect_rc 4 "$?" "67a — the real ownership helper returns AMBIGUOUS for this declaration" ""
run_dispatch "$d" owner-ambiguous-task --actor-cmd "$NOOP"
expect_rc 34 "$RC" "67a — exits 34 when ownership is ambiguous" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "67a — nothing was launched" \
                          || bad "67a — nothing was launched" "calls=$(calls "$d")"
# The refusal has to be THIS one. Exit 34 has a single production site, but the
# wording is what shows the helper's own verdict reached the operator.
out_has "ownership is AMBIGUOUS for task owner-ambiguous-task" "$OUT" \
  "67a — the stop names the ambiguity the helper reported"
RID67="$(run_id_of "$OUT")"
[ -n "$RID67" ] && ok "67a — the run announced a run id" \
                || bad "67a — the run announced a run id" "$OUT"
R67="$d/runs/$RID67.result"
[ -f "$R67" ] && ok "67a — a terminal result exists at the run-bound path" \
              || bad "67a — a terminal result exists at the run-bound path" \
                     "missing $R67; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
# EXACTLY ONE, counted three ways, because "a result exists" is the weakest of the
# claims Change set A makes: one file, no unfinalized temporary beside it, and one
# version line inside it (an appending producer would carry two).
[ "$(res_count "$d/runs")" = "1" ] \
  && ok "67a — exactly one finalized result" \
  || bad "67a — exactly one finalized result" "found $(res_count "$d/runs"): $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(part_count "$d/runs")" = "0" ] \
  && ok "67a — no unfinalized temporary artifact was left behind" \
  || bad "67a — no unfinalized temporary artifact was left behind" "$(ls "$d/runs"/*.result.partial 2>&1)"
NV67="$(grep -c '^terminal_result_version=' "$R67" 2>/dev/null || printf '0')"
[ "$NV67" = "1" ] && ok "67a — the artifact carries exactly one version line" \
                  || bad "67a — the artifact carries exactly one version line" "found $NV67"
# PROTOCOL COMPLETENESS, the same three checks 50a makes: the recognized version
# first, the completeness sentinel last, and the bounded grammar throughout.
[ "$(head -1 "$R67" 2>/dev/null)" = "terminal_result_version=1" ] \
  && ok "67a — the first line is the recognized schema version" \
  || bad "67a — the first line is the recognized schema version" "$(head -1 "$R67" 2>/dev/null)"
[ "$(tail -1 "$R67" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "67a — the last line is the completeness sentinel" \
  || bad "67a — the last line is the completeness sentinel" "$(tail -1 "$R67" 2>/dev/null)"
if [ -z "$(grep -vE '^[a-z][a-z0-9_]*=' "$R67" 2>/dev/null)" ]; then
  ok "67a — every line matches the bounded key=value grammar"
else
  bad "67a — every line matches the bounded key=value grammar" \
      "$(grep -vnE '^[a-z][a-z0-9_]*=' "$R67" | head -3 | tr '\n' ';')"
fi
# THE SEMANTICS OF THIS TERMINAL. `owner_check:ambiguous` is the ownership fact —
# the observed verdict, not the fact that the code got here — and the launch and
# stage fields are what keep this a refusal that stopped before any actor rather
# than a failure after one.
for pair in "outcome:OWNERSHIP_AMBIGUOUS" "code:34" "task:owner-ambiguous-task" \
            "owner_check:ambiguous" "stage:pre-hop" "actor:none" \
            "actor_launched:no" "model_request_started:no" "hop:0" \
            "next_action:operator-resolve-ownership" \
            "lease_task_at_finalization:held-by-this-run" \
            "lease_checkout_at_finalization:held-by-this-run"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R67" "$k")"
  [ "$got" = "$want" ] && ok "67a — $k=$want" || bad "67a — $k=$want" "got: ${got:-<absent>}"
done
# RUN-BINDING, asserted from inside the artifact as well as from its name: the
# path proves where it was written, these prove what it says about itself.
[ "$(res_field "$R67" run)" = "$RID67" ] \
  && ok "67a — the result names its own run id" \
  || bad "67a — the result names its own run id" "got: $(res_field "$R67" run)"
[ "$(res_field "$R67" checkout)" = "$(cd "$d" && pwd -P)" ] \
  && ok "67a — the result names the canonical checkout" \
  || bad "67a — the result names the canonical checkout" "got: $(res_field "$R67" checkout)"
# owner_declared IS ASSERTED NON-EMPTY AND NOT PINNED TO A VALUE, deliberately.
# owner_declaration() reports the first non-empty line, so a two-id declaration
# reports one of the two ids beside `owner_check=ambiguous`. That pairing is
# defensible — the field's contract is "a declaration that exists" and the stop
# message carries the helper's full reason — but it is arguably a field that
# should read `unavailable` when the declaration cannot be resolved to one owner.
# That question is open and is recorded as a deferral, so pinning the current
# value here would freeze one side of it into a regression.
[ -n "$(res_field "$R67" owner_declared)" ] \
  && ok "67a — owner_declared records the observed declaration" \
  || bad "67a — owner_declared records the observed declaration" "empty"
# THE LEASE ORDER, which is the durable-ordering rule Change set A states: the
# record above says both leases were held AT finalization, and both are gone
# afterwards — so release happened after a valid result existed, not before.
LT67="$(res_field "$R67" lease_task_dir)"; LC67="$(res_field "$R67" lease_checkout_dir)"
if [ -n "$LT67" ] && [ -n "$LC67" ] && [ ! -d "$LT67" ] && [ ! -d "$LC67" ]; then
  ok "67a — both leases it reported holding were released on the way out"
else
  bad "67a — both leases it reported holding were released on the way out" \
      "task=$LT67 ($([ -d "$LT67" ] && echo present || echo gone)) checkout=$LC67 ($([ -d "$LC67" ] && echo present || echo gone))"
fi
# ==================================================================== done
echo
echo "-----------------------------------------------"
printf 'pass=%d fail=%d  (all cases SIMULATED — no live product transport)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
