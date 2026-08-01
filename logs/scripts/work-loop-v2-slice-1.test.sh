#!/usr/bin/env bash
# Acceptance harness — Work Loop v2, Slice 1 (behaviours 1.1, 1.2, 1.3, 1.4).
#
# Asserts the END STATE after the fixture runs have been performed:
#   run (a) against logs/work-loop/fixture-slice1-true.md   — all claims true      [1.2, 1.3]
#   run (b) against logs/work-loop/fixture-slice1-false.md  — one claim deliberately false [1.2]
#   run (c) task fixture-slice1-codex, opened and closed by $work-loop-v2 in Codex [1.1, 1.4]
#
# Run it BEFORE the behaviours exist (must fail) and AFTER (must pass). That ordering is the
# point: an assertion that cannot fail is not evidence (executable core § 6 rule 5).
#
# Exit 0 only when every assertion passes.

set -uo pipefail
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "not a git repo"; exit 2; }
cd "$ROOT" || exit 2

TRUE_F="logs/work-loop/fixture-slice1-true.md"
FALSE_F="logs/work-loop/fixture-slice1-false.md"
TARGET="logs/work-loop/fixture-target.md"
CODEX_TASK="fixture-slice1-codex"

pass=0; fail=0
ok()   { echo "PASS  $1"; pass=$((pass+1)); }
no()   { echo "FAIL  $1"; fail=$((fail+1)); }
check(){ if eval "$2" >/dev/null 2>&1; then ok "$1"; else no "$1"; fi; }

# --- preconditions: the fixtures themselves ---------------------------------
for f in "$TRUE_F" "$FALSE_F" "$TARGET"; do
  check "fixture present: $f" "[ -f '$f' ]"
done

# --- 1.2(a) the inspection record appears even when every claim holds --------
# "the inspection record must still appear" — slice plan 1.2, failing case (a).
check "1.2a  latest result is no longer the untouched placeholder" \
  "! grep -q '(empty — not started)' '$TRUE_F'"
check "1.2a  an inspection record is written" \
  "grep -qi 'inspected' '$TRUE_F'"

# --- 1.2(a) an absence claim says WHAT WAS SEARCHED (core § 6 rule 3) -------
# Claim (2) of the true fixture is an absence claim. The record must name both the
# surface inspected and the pattern searched — 'there is no Status: line' alone fails.
check "1.2a  absence claim names the surface it searched" \
  "grep -i 'search' '$TRUE_F' | grep -q 'fixture-target.md'"
check "1.2a  absence claim names the pattern it searched for" \
  "grep -i 'search' '$TRUE_F' | grep -q 'Status:'"

# --- 1.2(b) a false premise is refused, and NOTHING is mutated --------------
# The brief named exactly one file. It must be untouched, and in particular the
# false premise must not have been quietly built into existence (core § 1: Claude
# does not silently repair a bad brief).
check "1.2b  the false premise was NOT manufactured into the target" \
  "! grep -q '^## Owner' '$TARGET'"
check "1.2b  turn handed back to codex" \
  "grep -qE '^turn:[[:space:]]*codex' '$FALSE_F'"
# The finding must live in the Blocker section and name the claim that failed.
# Grepping the whole file is NOT sufficient: the fixture's own id contains the word
# "false" and its objective contains "owner", so a whole-file grep passes before any
# work is done. Scope the assertion to the section the finding belongs in.
blocker_of() { awk '/^## Blocker/{f=1;next} /^## /{f=0} f' "$1"; }
check "1.2b  the blocker section no longer reads None" \
  "[ -n \"\$(blocker_of '$FALSE_F' | grep -v '^[[:space:]]*\$' | grep -v '^None\.\$')\" ]"
check "1.2b  the blocker names the claim that failed" \
  "blocker_of '$FALSE_F' | grep -qi 'owner'"
# The COMMITTED state must carry the hand-back. Asserting only that a commit touches
# the file would pass the moment the fixture itself was committed.
check "1.2b  the committed state carries the hand-back" \
  "git show HEAD:'$FALSE_F' 2>/dev/null | grep -qE '^turn:[[:space:]]*codex'"

# --- 1.3 the unit is implemented, and the evidence can fail ------------------
# The evidence check itself: 0 before the work, 1 after. It reads differently
# depending on whether the work happened, which is what makes it evidence.
check "1.3   the unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Status:' '$TARGET')\" = '1' ]"
# A bare grep for "evidence" passes on the untouched fixture — its brief already says
# "Evidence required:". Require a written `Evidence:` line, which the brief cannot supply.
check "1.3   an evidence pointer was written to the state file" \
  "grep -qE '^Evidence:' '$TRUE_F'"
check "1.3   turn handed back to codex" \
  "grep -qE '^turn:[[:space:]]*codex' '$TRUE_F'"
# Assert the COMMITTED target carries the change, not merely that some commit touched it.
check "1.3   the committed target carries the implementation" \
  "git show HEAD:'$TARGET' 2>/dev/null | grep -qE '^Status:'"

# --- 1.1 Codex opens the unit: the brief lands in logs/work-loop/ -----------
# Codex is invoked as $work-loop-v2 and told the task id and the need — NOT the path.
# Routing to logs/work-loop/ must come from the resource, or the assertion tests nothing.
CODEX_F="logs/work-loop/$CODEX_TASK.md"

check "1.1   the brief landed in logs/work-loop/, not logs/loop/" \
  "[ -f '$CODEX_F' ]"
check "1.1   it did NOT fall back to logs/loop/" \
  "[ ! -e 'logs/loop/$CODEX_TASK.md' ]"
check "1.1   turn is claude — the hand-off points at Claude" \
  "grep -qE '^turn:[[:space:]]*claude' '$CODEX_F'"
check "1.1   the task id matches the file it was written to" \
  "grep -qE \"^task:[[:space:]]*$CODEX_TASK\" '$CODEX_F'"
# A brief must carry claims Claude can CHECK. Asserting the word "brief" appears would
# pass on any file containing the heading; require a checkable-claims line instead.
check "1.1   the brief states claims to check against the repository" \
  "grep -qiE '^check against the repository' '$CODEX_F'"
# Assert the COMMITTED state, not merely that the file exists in the working tree —
# Claude committing the file Codex wrote is half of what 1.1 claims.
check "1.1   Claude committed the brief Codex wrote" \
  "git show HEAD:'$CODEX_F' 2>/dev/null | grep -qE '^task:[[:space:]]*$CODEX_TASK'"

# --- 1.4 Codex closes: the file reduces to the four closing fields ----------
# EVERY negative below is conjoined with a positive closure marker. On its own,
# "the file has no ## Next action" passes trivially before the file exists — the exact
# class of always-passing assertion this harness caught in its own first red run.
closed() { [ -f "$CODEX_F" ] && grep -qE '^## Outcome' "$CODEX_F"; }

check "1.4   the closed file carries Outcome" \
  "closed"
check "1.4   the closed file carries the decisions that matter" \
  "closed && grep -qE '^## Decisions that matter' '$CODEX_F'"
check "1.4   the closed file carries a commit or evidence pointer" \
  "closed && grep -qE '^## Evidence' '$CODEX_F'"
check "1.4   the closed file carries accepted limitations" \
  "closed && grep -qE '^## Accepted limitations' '$CODEX_F'"
# The behaviour's failing case: ANY of the five active fields surviving closure.
for active in 'Objective and scope' 'Lane and unit' 'Latest result' 'Blocker' 'Next action'; do
  check "1.4   active field did NOT survive closure: $active" \
    "closed && ! grep -qE '^## $active' '$CODEX_F'"
done
check "1.4   the committed state carries the closed shape" \
  "git show HEAD:'$CODEX_F' 2>/dev/null | grep -qE '^## Outcome'"

# --- v1 isolation: logs/loop/ must gain nothing (slice plan 1.1) ------------
check "v1    no Slice 1 artifact leaked into logs/loop/" \
  "! ls logs/loop/ 2>/dev/null | grep -qE 'fixture-slice1|$CODEX_TASK'"
check "v1    logs/loop/ has no uncommitted change from this work" \
  "[ -z \"\$(git status --porcelain logs/loop/)\" ]"

echo
echo "passed: $pass   failed: $fail"
[ "$fail" -eq 0 ] || exit 1
