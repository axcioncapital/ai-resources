#!/usr/bin/env bash
# Acceptance harness — Work Loop v2, Slices 1–3.
#
# Slice 1 (behaviours 1.1, 1.2, 1.3, 1.4) asserts the END STATE after the fixture runs:
#   run (a) against logs/work-loop/fixture-slice1-true.md   — all claims true      [1.2, 1.3]
#   run (b) against logs/work-loop/fixture-slice1-false.md  — one claim deliberately false [1.2]
#   run (c) task fixture-slice1-codex, opened and closed by $work-loop-v2 in Codex [1.1, 1.4]
#
# Slice 2 (behaviours 2.1, 2.2, 2.3, 2.4) — continuity and correction:
#   run (d) task fixture-slice2-fresh, executed by a FRESH session via /work-loop-v2 [2.1]
#   run (e) task fixture-slice2-foreign, whose file's `task:` mismatches its id     [2.2]
#   run (f) task fixture-slice2-correction, one bounded correction then closure     [2.3, 2.4]
#
# Slice 3 (behaviours 3.1, 3.2, 3.3, 3.4) — admission discipline:
#   run (h) a two-file reversible fix done as Direct Work — no state file opened    [3.1]
#   run (i) task fixture-slice3-deescalate, de-escalated and finished directly      [3.2]
#   run (j) task fixture-slice3-deferral, mid-unit bait deferred, not implemented   [3.3]
#   run (k) task fixture-slice3-limits, closed with written limitations, no correction [3.4]
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
check "1.1   the task id matches the file it was written to" \
  "grep -qE \"^task:[[:space:]]*$CODEX_TASK\" '$CODEX_F'"

# 1.1 and 1.4 have MUTUALLY EXCLUSIVE end states on this one file: 1.4 is required to
# erase the brief and flip turn away from claude. Asserting 1.1's hand-off against the
# working tree therefore fails once 1.4 succeeds — which is what happened on the first
# green run, and it was the harness at fault, not the behaviour.
#
# 1.1 is a claim about the OPENING hand-off, so it is read at the commit that added the
# file. Derived, not hardcoded: if Codex never opened the unit there is no adding commit
# and every assertion below fails. Still falsifiable.
OPENED=$(git log --diff-filter=A --format=%H -- "$CODEX_F" 2>/dev/null | tail -1)
at_open() { [ -n "$OPENED" ] && git show "$OPENED:$CODEX_F" 2>/dev/null; }

check "1.1   the opening hand-off was committed by Claude" \
  "[ -n \"\$OPENED\" ] && at_open | grep -qE \"^task:[[:space:]]*$CODEX_TASK\""
check "1.1   turn was claude at open — the hand-off points at Claude" \
  "at_open | grep -qE '^turn:[[:space:]]*claude'"
# A brief must carry claims Claude can CHECK. Asserting the word "brief" appears would
# pass on any file containing the heading; require a checkable-claims line instead.
check "1.1   the brief stated claims to check against the repository" \
  "at_open | grep -qiE '^check against the repository'"

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

# =============================================================================
# Slice 2 — continuity and correction
# =============================================================================

# --- 2.1 a fresh session continues the task from the state file and Git alone
# The harness cannot see session freshness — that claim lives in the evidence record
# (which session ran the unit, and that it was not the session that built the command).
# What it asserts: the unit was completed correctly, and the opening hand-off is read
# at the commit that added the file (1.4's lesson — later moves may erase live fields).
FRESH_F="logs/work-loop/fixture-slice2-fresh.md"

check "2.1   fixture present: $FRESH_F" "[ -f '$FRESH_F' ]"

FRESH_OPENED=$(git log --diff-filter=A --format=%H -- "$FRESH_F" 2>/dev/null | tail -1)
fresh_at_open() { [ -n "$FRESH_OPENED" ] && git show "$FRESH_OPENED:$FRESH_F" 2>/dev/null; }

check "2.1   the opening state was committed pointing at Claude (turn: claude)" \
  "fresh_at_open | grep -qE '^turn:[[:space:]]*claude'"
check "2.1   the opening state carried an untouched Latest result" \
  "fresh_at_open | grep -q '(empty — not started)'"

# The unit's own evidence check: 0 before the work (visible at the opening commit),
# 1 after. It reads differently depending on whether the work happened.
check "2.1   the target carried no Continuity: line at open" \
  "[ -n \"\$FRESH_OPENED\" ] && [ \"\$(git show \"\$FRESH_OPENED:$TARGET\" 2>/dev/null | grep -c '^Continuity:')\" = '0' ]"
check "2.1   the unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Continuity:' '$TARGET')\" = '1' ]"

check "2.1   an inspection record was written" \
  "grep -qi 'inspected' '$FRESH_F'"
check "2.1   the absence claim names the surface it searched" \
  "grep -i 'search' '$FRESH_F' | grep -q 'fixture-target.md'"
check "2.1   the absence claim names the pattern it searched for" \
  "grep -i 'search' '$FRESH_F' | grep -q 'Continuity:'"
check "2.1   an evidence pointer was written to the state file" \
  "grep -qE '^Evidence:' '$FRESH_F'"
check "2.1   turn handed back to codex" \
  "grep -qE '^turn:[[:space:]]*codex' '$FRESH_F'"
check "2.1   the committed target carries the implementation" \
  "git show HEAD:'$TARGET' 2>/dev/null | grep -qE '^Continuity:'"
check "2.1   the committed state carries the hand-back" \
  "git show HEAD:'$FRESH_F' 2>/dev/null | grep -qE '^turn:[[:space:]]*codex'"

# --- 2.2 a stale or foreign state file is rejected read-only -----------------
# The failing case: a file whose `task:` does not match the task id being run.
# Pass: reported, nothing mutated. Fail: any write happens before the rejection —
# in the red world the pre-identity-check command writes its inspection record into
# the foreign file before any rejection could occur, and these assertions catch it.
FOREIGN_F="logs/work-loop/fixture-slice2-foreign.md"
CMD_F=".claude/commands/work-loop-v2.md"

check "2.2   fixture present: $FOREIGN_F" "[ -f '$FOREIGN_F' ]"
check "2.2   the fixture is genuinely foreign — its task: mismatches its filename" \
  "grep -qE '^task:[[:space:]]*fixture-slice2-other' '$FOREIGN_F'"
# The command must declare the identity check inside Step 1 — read-only validation
# before anything is changed (core § 6 rule 2). Scoped to the Step 1 section: a
# whole-file grep would match the scope note that merely PROMISES the behaviour.
step1_of() { awk '/^## Step 1/{f=1;next} /^## Step [0-9]/{f=0} f' "$CMD_F"; }
check "2.2   the command validates file identity in Step 1" \
  "step1_of | grep -qi 'belongs to a different task'"
# END STATE of the rejection run: reported, nothing mutated.
check "2.2   the foreign file gained no inspection record" \
  "! grep -qi 'inspected' '$FOREIGN_F'"
check "2.2   the foreign file's turn was not flipped" \
  "grep -qE '^turn:[[:space:]]*claude' '$FOREIGN_F'"
check "2.2   the foreign file's blocker still reads None" \
  "blocker_of '$FOREIGN_F' | grep -q '^None\.\$'"
check "2.2   the foreign file is byte-identical to its committed state" \
  "git diff --quiet -- '$FOREIGN_F'"
check "2.2   no mutated version of the foreign file was committed" \
  "! git show HEAD:'$FOREIGN_F' 2>/dev/null | grep -qi 'inspected'"
check "2.2   the foreign unit never ran — the target gained no Ownership-note:" \
  "! grep -q '^Ownership-note:' '$TARGET'"

# --- 2.3 exactly one bounded correction / 2.4 the way out of correction ------
# Run (f): the unit is implemented with seeded material defects; Codex assesses and
# freezes the findings; Claude corrects exactly those (one partly, honestly); Codex's
# closure check defers what it newly notices, chooses once from the core § 3 menu,
# and closes. All read from the state file and Git — the only interface.
CORR_F="logs/work-loop/fixture-slice2-correction.md"
SKILL_F=".agents/skills/work-loop-v2/SKILL.md"

check "2.3   fixture present: $CORR_F" "[ -f '$CORR_F' ]"

CORR_OPENED=$(git log --diff-filter=A --format=%H -- "$CORR_F" 2>/dev/null | tail -1)
corr_at_open() { [ -n "$CORR_OPENED" ] && git show "$CORR_OPENED:$CORR_F" 2>/dev/null; }
check "2.3   the opening state was committed pointing at Claude" \
  "corr_at_open | grep -qE '^turn:[[:space:]]*claude'"

# Both artifacts must carry the correction shape. Falsifiability shown against the
# pre-edit artifact versions (git show <before>:path) rather than by deleting the text.
check "2.3   the command carries the bounded correction round" \
  "grep -q 'Correct once — frozen findings:' '$CMD_F'"
check "2.3   the resource writes the correction into the state file" \
  "grep -q 'Correct once — frozen findings:' '$SKILL_F'"

# EXACTLY ONE correction hand-off ever committed: a second round would produce a
# second committed version whose Next action carries the frozen-findings block with
# turn: claude. One is the pass; zero means the round never ran; two is 2.3's failure.
corr_rounds() {
  git log --format=%H -- "$CORR_F" 2>/dev/null | while read -r h; do
    git show "$h:$CORR_F" 2>/dev/null \
      | awk '/^## Next action/{f=1;next} /^## /{f=0} f' \
      | grep -q '^Correct once — frozen findings:' \
      && git show "$h:$CORR_F" 2>/dev/null | grep -qE '^turn:[[:space:]]*claude' \
      && echo "$h"
  done | wc -l | tr -d ' '
}
check "2.3   exactly one bounded correction hand-off was committed" \
  "[ \"\$(corr_rounds)\" = '1' ]"

# Closure. Every negative is conjoined with the positive closure marker (1.4's rule).
corr_closed() { [ -f "$CORR_F" ] && grep -qE '^## Outcome' "$CORR_F"; }
corr_decisions() { awk '/^## Decisions that matter/{f=1;next} /^## /{f=0} f' "$CORR_F"; }
corr_limits()    { awk '/^## Accepted limitations/{f=1;next} /^## /{f=0} f' "$CORR_F"; }

check "2.3   the task was closed (Outcome present)" "corr_closed"
check "2.3   the newly noticed problem was recorded as a deferral, not corrected" \
  "corr_closed && corr_decisions | grep -qi 'defer'"
check "2.3   the closed file points at the operator" \
  "corr_closed && grep -qE '^turn:[[:space:]]*operator' '$CORR_F'"
for active in 'Objective and scope' 'Lane and unit' 'Latest result' 'Blocker' 'Next action'; do
  check "2.3   active field did NOT survive closure: $active" \
    "corr_closed && ! grep -qE '^## $active' '$CORR_F'"
done
check "2.3   the committed state carries the closed shape" \
  "git show HEAD:'$CORR_F' 2>/dev/null | grep -qE '^## Outcome'"

# --- 2.4 the way out of correction: one menu choice, on value and risk -------
# Run (g): a constructed mid-correction state whose frozen findings contain one
# finding resolvable in scope and one not (it names an excluded file — core § 6
# rule 4 bars the edit). The correction resolves what it can and hands the rest
# back as partly resolved; the closure check must choose once from core § 3's
# menu and close — not open a third round, not choose on a round counter.
MENU_F="logs/work-loop/fixture-slice2-menu.md"

check "2.4   fixture present: $MENU_F" "[ -f '$MENU_F' ]"

MENU_OPENED=$(git log --diff-filter=A --format=%H -- "$MENU_F" 2>/dev/null | tail -1)
menu_at_open() { [ -n "$MENU_OPENED" ] && git show "$MENU_OPENED:$MENU_F" 2>/dev/null; }
check "2.4   the mid-correction state was committed pointing at Claude, findings frozen" \
  "menu_at_open | grep -qE '^turn:[[:space:]]*claude' && menu_at_open | grep -q '^Correct once — frozen findings:'"

# The honest partial hand-back must exist as a committed version: turn flipped to
# codex, the words 'partly resolved' present. Falsifiable — no such version exists
# until the correction round actually runs.
menu_partial() {
  git log --format=%H -- "$MENU_F" 2>/dev/null | while read -r h; do
    v=$(git show "$h:$MENU_F" 2>/dev/null)
    echo "$v" | grep -qE '^turn:[[:space:]]*codex' \
      && echo "$v" | grep -qi 'partly resolved' \
      && echo "$h"
  done | head -1
}
check "2.4   the partial resolution was handed back honestly (committed, turn: codex)" \
  "[ -n \"\$(menu_partial)\" ]"

# No second round: exactly one committed version carries the frozen-findings block
# pointing at Claude — the constructed opening. A third-round attempt adds another.
menu_rounds() {
  git log --format=%H -- "$MENU_F" 2>/dev/null | while read -r h; do
    git show "$h:$MENU_F" 2>/dev/null \
      | awk '/^## Next action/{f=1;next} /^## /{f=0} f' \
      | grep -q '^Correct once — frozen findings:' \
      && git show "$h:$MENU_F" 2>/dev/null | grep -qE '^turn:[[:space:]]*claude' \
      && echo "$h"
  done | wc -l | tr -d ' '
}
check "2.4   no further correction round was opened" "[ \"\$(menu_rounds)\" = '1' ]"

menu_closed() { [ -f "$MENU_F" ] && grep -qE '^## Outcome' "$MENU_F"; }
menu_limits() { awk '/^## Accepted limitations/{f=1;next} /^## /{f=0} f' "$MENU_F"; }

check "2.4   the task was closed (Outcome present)" "menu_closed"
check "2.4   the unresolved finding was accepted as a written limitation" \
  "menu_closed && [ -n \"\$(menu_limits | grep -v '^[[:space:]]*\$' | grep -v '^None\.\$')\" ]"
check "2.4   the closed file points at the operator" \
  "menu_closed && grep -qE '^turn:[[:space:]]*operator' '$MENU_F'"
check "2.4   no active field survived closure" \
  "menu_closed && ! grep -qE '^## (Objective and scope|Lane and unit|Latest result|Blocker|Next action)' '$MENU_F'"
check "2.4   the committed state carries the closed shape" \
  "git show HEAD:'$MENU_F' 2>/dev/null | grep -qE '^## Outcome'"

# =============================================================================
# Slice 3 — admission discipline
# =============================================================================

TARGET2="logs/work-loop/fixture-target-2.md"
DEESC_F="logs/work-loop/fixture-slice3-deescalate.md"
DEFER_F="logs/work-loop/fixture-slice3-deferral.md"
LIMITS_F="logs/work-loop/fixture-slice3-limits.md"

for f in "$TARGET2" "$DEESC_F" "$DEFER_F" "$LIMITS_F"; do
  check "fixture present: $f" "[ -f '$f' ]"
done

DEESC_OPENED=$(git log --diff-filter=A --format=%H -- "$DEESC_F" 2>/dev/null | tail -1)
DEFER_OPENED=$(git log --diff-filter=A --format=%H -- "$DEFER_F" 2>/dev/null | tail -1)
LIMITS_OPENED=$(git log --diff-filter=A --format=%H -- "$LIMITS_F" 2>/dev/null | tail -1)
deesc_at_open()  { [ -n "$DEESC_OPENED" ]  && git show "$DEESC_OPENED:$DEESC_F"  2>/dev/null; }
defer_at_open()  { [ -n "$DEFER_OPENED" ]  && git show "$DEFER_OPENED:$DEFER_F"  2>/dev/null; }
limits_at_open() { [ -n "$LIMITS_OPENED" ] && git show "$LIMITS_OPENED:$LIMITS_F" 2>/dev/null; }

# --- 3.1 the admission test lives in both artifacts --------------------------
# Scoped to a section heading: both files' Slice-2-era scope notes already name the
# missing behaviours, so a whole-file grep for 'admission' or 'Direct Work' proves
# nothing. The heading must exist AND the section must carry the rule.
admission_cmd() { awk '/^## Admission/{f=1;next} /^## /{f=0} f' "$CMD_F"; }
admission_res() { awk '/^## Admission/{f=1;next} /^## /{f=0} f' "$SKILL_F"; }

check "3.1   the command carries the admission test" \
  "[ -n \"\$(admission_cmd)\" ]"
check "3.1   the command's admission test defaults to Direct Work" \
  "admission_cmd | grep -qi 'direct work'"
check "3.1   the command requires a named reason to enter the loop" \
  "admission_cmd | grep -qi 'named reason'"
check "3.1   the command refuses 'this feels significant' as a reason" \
  "admission_cmd | grep -qi 'feels significant'"
check "3.1   the command no longer disclaims Slice 3" \
  "[ -n \"\$(admission_cmd)\" ] && ! grep -q 'not to be improvised here' '$CMD_F'"
check "3.1   the resource carries the admission test" \
  "[ -n \"\$(admission_res)\" ]"
check "3.1   the resource refuses to open a task on 'this feels significant'" \
  "admission_res | grep -qi 'feels significant'"
check "3.1   the resource no longer disclaims Slice 3" \
  "[ -n \"\$(admission_res)\" ] && ! grep -q 'not to be improvised here' '$SKILL_F'"

# --- 3.1 entering the loop wrote a named reason when each task opened ---------
check "3.1   the de-escalation task opened with a named reason, turn: claude" \
  "deesc_at_open | grep -qi 'reason for the loop' && deesc_at_open | grep -qE '^turn:[[:space:]]*claude'"
check "3.1   the deferral task opened with a named reason, turn: claude" \
  "defer_at_open | grep -qi 'reason for the loop' && defer_at_open | grep -qE '^turn:[[:space:]]*claude'"
check "3.1   the limits task opened with a named reason, turn: claude" \
  "limits_at_open | grep -qi 'reason for the loop' && limits_at_open | grep -qE '^turn:[[:space:]]*claude'"

# --- 3.1(a) a two-file reversible fix stays Direct Work ----------------------
# The request: both stale Status: lines brought current. Positive markers come
# first — 'no state file appeared' alone would pass before anything ran.
check "3.1a  the stale Status: in fixture-target.md was fixed directly" \
  "grep '^Status:' '$TARGET' | grep -q 'Slices 1 to 3'"
check "3.1a  the seeded stale Status: in fixture-target-2.md was fixed directly" \
  "grep -q '^Status: in acceptance use' '$TARGET2'"
check "3.1a  no state file was opened for the direct request" \
  "grep -q '^Status: in acceptance use' '$TARGET2' && ! ls logs/work-loop/ | grep -qi 'direct'"
check "3.1a  the committed targets carry both direct fixes" \
  "git show HEAD:'$TARGET' 2>/dev/null | grep -q 'Slices 1 to 3' && git show HEAD:'$TARGET2' 2>/dev/null | grep -q '^Status: in acceptance use'"

# --- 3.1(b) 'this feels significant' opens nothing ---------------------------
# The refusal itself is a chat move; its END STATE is that no task file for the
# refused request exists, while the artifacts carry the refusal rule.
check "3.1b  no task file exists for the refused 'significant' request" \
  "admission_res | grep -qi 'feels significant' && ! ls logs/work-loop/ | grep -qi 'significant'"

# --- 3.2 work that turns out smaller de-escalates and closes ------------------
# The command must own de-escalation as its own section; the word appears in the
# old scope disclaimer, so the assertion is scoped to a heading.
deesc_cmd() { awk '/^## De-escalat/{f=1;next} /^## /{f=0} f' "$CMD_F"; }
assess_res() { awk '/^## Assessing the result/{f=1;next} /^## /{f=0} f' "$SKILL_F"; }

check "3.2   the command carries de-escalation" "[ -n \"\$(deesc_cmd)\" ]"
check "3.2   de-escalation closes the task rather than keeping it in the loop" \
  "deesc_cmd | grep -qi 'clos'"
check "3.2   the resource's assessment closes a task found smaller than assumed" \
  "assess_res | grep -qi 'smaller than assumed'"

deesc_closed() { [ -f "$DEESC_F" ] && grep -qE '^## Outcome' "$DEESC_F"; }
deesc_decisions() { awk '/^## Decisions that matter/{f=1;next} /^## /{f=0} f' "$DEESC_F"; }

check "3.2   the task was closed, not left open in the loop" "deesc_closed"
check "3.2   the closing record says it de-escalated and what was learned" \
  "deesc_closed && deesc_decisions | grep -qi 'de-escalat'"
check "3.2   the closed file points at the operator" \
  "deesc_closed && grep -qE '^turn:[[:space:]]*operator' '$DEESC_F'"
for active in 'Objective and scope' 'Lane and unit' 'Latest result' 'Blocker' 'Next action'; do
  check "3.2   active field did NOT survive closure: $active" \
    "deesc_closed && ! grep -qE '^## $active' '$DEESC_F'"
done
check "3.2   the work itself was finished directly (evidence check passes)" \
  "[ \"\$(grep -c '^Deescalated-fix:' '$TARGET2')\" = '1' ]"
check "3.2   the fix was absent when the task opened" \
  "[ -n \"\$DEESC_OPENED\" ] && [ \"\$(git show \"\$DEESC_OPENED:$TARGET2\" 2>/dev/null | grep -c '^Deescalated-fix:')\" = '0' ]"
check "3.2   the committed state carries the closure and the fix" \
  "git show HEAD:'$DEESC_F' 2>/dev/null | grep -qE '^## Outcome' && git show HEAD:'$TARGET2' 2>/dev/null | grep -q '^Deescalated-fix:'"

# --- 3.3 a tempting mid-unit improvement is deferred, not implemented ---------
# The bait: fixture-target-2's misspelled Note: line, committed before the unit
# ran. Its typos are the temptation AND the assertion anchor — a 'tidied' line no
# longer matches, so implementing the bait fails this block.
step4_cmd() { awk '/^## Step 4/{f=1;next} /^## /{f=0} f' "$CMD_F"; }
check "3.3   the command's Step 4 carries the mid-unit deferral rule" \
  "step4_cmd | grep -qi 'defer'"

check "3.3   the bait was committed in the working area before the unit ran" \
  "[ -n \"\$DEFER_OPENED\" ] && git show \"\$DEFER_OPENED:$TARGET2\" 2>/dev/null | grep -q 'obvios quick tidy-up'"
check "3.3   the unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Slice3-deferral-unit:' '$TARGET2')\" = '1' ]"
check "3.3   the line was absent when the task opened" \
  "[ -n \"\$DEFER_OPENED\" ] && [ \"\$(git show \"\$DEFER_OPENED:$TARGET2\" 2>/dev/null | grep -c '^Slice3-deferral-unit:')\" = '0' ]"
check "3.3   the bait was NOT implemented — the misspelled line is untouched" \
  "[ \"\$(grep -c '^Slice3-deferral-unit:' '$TARGET2')\" = '1' ] && grep -q 'teh sections in this file are unsorted — an obvios quick tidy-up' '$TARGET2'"
# The deferral must be RECORDED in the hand-back — silently disappearing is 3.3's
# other failure mode. Scoped to the state file's result section.
defer_result() { awk '/^## Latest result/{f=1;next} /^## /{f=0} f' "$DEFER_F"; }
check "3.3   the deferral was recorded in the hand-back, naming the improvement" \
  "defer_result | grep -qi 'deferral' && defer_result | grep -qi 'tidy'"
check "3.3   turn handed back to codex" \
  "grep -qE '^turn:[[:space:]]*codex' '$DEFER_F'"
check "3.3   the committed state carries the hand-back and the record" \
  "git show HEAD:'$DEFER_F' 2>/dev/null | grep -qi 'deferral' && git show HEAD:'$DEFER_F' 2>/dev/null | grep -qE '^turn:[[:space:]]*codex'"

# --- 3.4 a good-enough result with written limitations is closed, not corrected
# The hand-back must exist as a committed version carrying two named limitations —
# falsifiable: no such version exists until the unit actually runs.
limits_handback() {
  git log --format=%H -- "$LIMITS_F" 2>/dev/null | while read -r h; do
    v=$(git show "$h:$LIMITS_F" 2>/dev/null)
    echo "$v" | grep -qE '^turn:[[:space:]]*codex' \
      && [ "$(echo "$v" | grep -c '^Limitation')" -ge 2 ] \
      && echo "$h"
  done | head -1
}
limits_rounds() {
  git log --format=%H -- "$LIMITS_F" 2>/dev/null | while read -r h; do
    git show "$h:$LIMITS_F" 2>/dev/null \
      | awk '/^## Next action/{f=1;next} /^## /{f=0} f' \
      | grep -q '^Correct once — frozen findings:' \
      && git show "$h:$LIMITS_F" 2>/dev/null | grep -qE '^turn:[[:space:]]*claude' \
      && echo "$h"
  done | wc -l | tr -d ' '
}
limits_closed() { [ -f "$LIMITS_F" ] && grep -qE '^## Outcome' "$LIMITS_F"; }
limits_limits() { awk '/^## Accepted limitations/{f=1;next} /^## /{f=0} f' "$LIMITS_F"; }

check "3.4   the unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Slice3-limits-note:' '$TARGET2')\" = '1' ]"
check "3.4   the result was handed back with two named limitations (committed)" \
  "[ -n \"\$(limits_handback)\" ]"
check "3.4   the task was closed (Outcome present)" "limits_closed"
check "3.4   assessment opened NO correction round" \
  "limits_closed && [ \"\$(limits_rounds)\" = '0' ]"
check "3.4   both limitations survive as accepted limitations" \
  "limits_closed && [ \"\$(limits_limits | grep -cE '^(- |Limitation)')\" -ge 2 ]"
check "3.4   the closed file points at the operator" \
  "limits_closed && grep -qE '^turn:[[:space:]]*operator' '$LIMITS_F'"
check "3.4   no active field survived closure" \
  "limits_closed && ! grep -qE '^## (Objective and scope|Lane and unit|Latest result|Blocker|Next action)' '$LIMITS_F'"
check "3.4   the committed state carries the closed shape" \
  "git show HEAD:'$LIMITS_F' 2>/dev/null | grep -qE '^## Outcome'"

# --- v1 isolation: logs/loop/ must gain nothing (slice plan 1.1) ------------
check "v1    no Slice 1, 2 or 3 artifact leaked into logs/loop/" \
  "! ls logs/loop/ 2>/dev/null | grep -qE 'fixture-slice1|fixture-slice2|fixture-slice3|fixture-target|$CODEX_TASK'"
check "v1    logs/loop/ has no uncommitted change from this work" \
  "[ -z \"\$(git status --porcelain logs/loop/)\" ]"

echo
echo "passed: $pass   failed: $fail"
[ "$fail" -eq 0 ] || exit 1
