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
#   run (k) task fixture-slice3-limits — mis-designed as the close case (limitation 1
#           contradicted its own objective), became one real bounded correction then
#           closure; documented in the Slice 3 evidence record                      [2.3-class]
#   run (l) task fixture-slice3-close, opened by Codex, closed with written
#           limitations, zero correction rounds                                     [3.4]
#
# Continue (post-MVP project progression, accepted 2026-08-06):
#   run (m) fixture-continue — a constructed multi-unit end state: unit 1 accepted
#           via Continue, unit 2's brief open in the same file, task not closed
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
#
# S10 finding 2: core § 3 step 3 now permits BOTH claim placements — marked in place, or
# gathered under one collecting heading. This assertion is not a statement that the
# collecting heading is mandatory. It reads fixture-slice1-codex at its immutable opening
# commit, where the brief used that shape, so it asserts what that one brief actually did.
# A brief in the other valid shape is not tested here and is not a failure.
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
# Finding C, Step 6: this used to require Step 1 to SPELL OUT core § 6 rule 2's
# condition ('belongs to a different task'). Core owns the conditions; the command
# owns what Claude does when one is met. Split accordingly — the rule is linked, the
# actor's mechanics are asserted. The mechanic phrase below appears nowhere in the
# core, so this cannot be satisfied by copying policy back in.
check "2.2   the command's Step 1 defers the identity rule to core § 6" \
  "step1_of | grep -qiE 'core §[[:space:]]*6'"
check "2.2   the command's Step 1 keeps the read-only rejection mechanics" \
  "step1_of | grep -qi 'no inspection record'"
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
# The four direct references the skill was split into (Unit 1,
# work-loop-v2-post-compaction-recovery-repair). Assertions follow their content: a
# rule that moved is verified against its new one semantic owner, never dropped and
# never weakened. Frontmatter and universal-behavior checks stay on $SKILL_F.
WL2_REFS=".agents/skills/work-loop-v2/references"
CORERES_F="$WL2_REFS/core-resolution.md"
COURIER_F="$WL2_REFS/courier-operation.md"
ROUTADM_F="$WL2_REFS/routing-and-admission.md"
UNITFR_F="$WL2_REFS/unit-framing.md"

check "2.3   fixture present: $CORR_F" "[ -f '$CORR_F' ]"

CORR_OPENED=$(git log --diff-filter=A --format=%H -- "$CORR_F" 2>/dev/null | tail -1)
corr_at_open() { [ -n "$CORR_OPENED" ] && git show "$CORR_OPENED:$CORR_F" 2>/dev/null; }
check "2.3   the opening state was committed pointing at Claude" \
  "corr_at_open | grep -qE '^turn:[[:space:]]*claude'"

# Finding C, Step 6: both artifacts used to carry the literal hand-off token, so the
# producer and the consumer each owned a copy of the same protocol string and could
# drift apart. The core now names it once (§ 3, "The hand-off token") and both sides
# reference it. These four assertions test that interface end to end: the owner still
# names it, neither runtime artifact re-spells it, and both still route through it.
# A reference with no owner, or an owner with no references, fails here.
CORE_F="plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md"
check "2.3   the core owns the hand-off token's literal text" \
  "grep -q 'Correct once — frozen findings:' '$CORE_F'"
check "2.3   neither runtime artifact duplicates the token's literal text" \
  "! grep -q 'Correct once — frozen findings:' '$CMD_F' && ! grep -q 'Correct once — frozen findings:' '$SKILL_F'"
check "2.3   the command reads the correction round from the core-owned token" \
  "grep -qi 'hand-off token' '$CMD_F'"
check "2.3   the resource writes the correction using the core-owned token" \
  "grep -qi 'hand-off token' '$SKILL_F'"

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
# Admission moved to $ROUTADM_F; the rule is unchanged, so only its owner is retargeted.
admission_res() { awk '/^## Admission/{f=1;next} /^## /{f=0} f' "$ROUTADM_F"; }

# Finding C, Step 6: these used to require BOTH artifacts to spell out core § 2's
# policy ('direct work', 'named reason', 'feels significant'). That is precisely the
# duplication C named — the harness was rewarding the copies, so removing them went
# red and keeping them went green. The ownership boundary is tested instead: each
# artifact must carry its own Admission section (the actor's mechanics live there)
# and defer the rule to core § 2, and must NOT re-state the rule's content.
#
# The negative checks are the load-bearing half. A link check alone does not
# discriminate — the pre-correction artifacts also said "core § 2" while restating it
# underneath. These go red against those versions and go red again the moment a copy
# returns, which is the regression C exists to prevent.
check "3.1   the command carries the admission section" \
  "[ -n \"\$(admission_cmd)\" ]"
check "3.1   the command defers the admission rule to core § 2" \
  "admission_cmd | grep -qiE 'core §[[:space:]]*2'"
check "3.1   the command does not restate core § 2's excluded reason" \
  "[ -n \"\$(admission_cmd)\" ] && ! admission_cmd | grep -qi 'feels significant'"
check "3.1   the command no longer disclaims Slice 3" \
  "[ -n \"\$(admission_cmd)\" ] && ! grep -q 'not to be improvised here' '$CMD_F'"
check "3.1   the resource carries the admission section" \
  "[ -n \"\$(admission_res)\" ]"
check "3.1   the resource defers the admission rule to core § 2" \
  "admission_res | grep -qiE 'core §[[:space:]]*2'"
check "3.1   the resource does not restate core § 2's excluded reason" \
  "[ -n \"\$(admission_res)\" ] && ! admission_res | grep -qi 'feels significant'"
check "3.1   the resource no longer disclaims Slice 3" \
  "[ -n \"\$(admission_res)\" ] && ! grep -q 'not to be improvised here' '$ROUTADM_F'"

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
# Finding B, Step 6 review: the old predicate was
#   ! ls logs/work-loop/ | grep -qi 'direct'
# which only checks that no FILENAME contains the word 'direct'. An arbitrary state
# file passes it. Proven by creating logs/work-loop/arbitrary-state.md and watching
# all 142 assertions stay green. The real question is whether ANY state file exists
# that this build did not deliberately create — first answered by a hand-maintained
# closed set over the whole of logs/work-loop/ (KNOWN_WORKLOOP_FILES).
#
# 2026-08-13: that closed set measured the live directory, so every genuine task
# record opened after Slice 3 counted as unexpected — 36 of them by the time this was
# repaired, and both assertions had been red across five sessions for that reason
# alone. The inventory is now scoped to the ONE commit that performed the direct fix.
# The behaviour under test is whether that change opened a state file, and no task
# record written by any later task can affect it.
#
# Rejected: classifying by the 'fixture-' name prefix (the improvement-log entry's
# proposal). It would ignore every non-fixture file, which is exactly the arbitrary
# state file — logs/work-loop/arbitrary-state.md — that Finding B strengthened this
# block to catch. Scoping by commit keeps that signal: a file the direct request
# opened is ADDED in the direct-fix commit, whatever it is named.
DIRECT_FIX_COMMIT=$(git log --format=%H -S'Status: in acceptance use' -- "$TARGET2" 2>/dev/null | tail -1)

# Paths under logs/work-loop/ that a commit ADDED. Takes the repository as an
# argument so the fail-capability control below drives this same function against a
# simulated direct fix rather than a look-alike written for the control.
worklog_added_in() {   # $1 = repo dir, $2 = commit
  git -C "$1" show --diff-filter=A --name-only --format= "$2" -- logs/work-loop/ 2>/dev/null |
    sed '/^$/d'
}
worklog_touched_in() { # $1 = repo dir, $2 = commit — every work-loop path the commit changed
  git -C "$1" show --name-only --format= "$2" -- logs/work-loop/ 2>/dev/null | sed '/^$/d' | sort
}

DIRECT_FIX_ADDED=$(worklog_added_in "$ROOT" "$DIRECT_FIX_COMMIT")
DIRECT_FIX_TOUCHED=$(worklog_touched_in "$ROOT" "$DIRECT_FIX_COMMIT")
DIRECT_FIX_EXPECTED=$(printf '%s\n%s\n' "$TARGET" "$TARGET2" | sort)

check "3.1a  the direct fix is one identifiable commit in history" \
  "[ -n \"\$DIRECT_FIX_COMMIT\" ]"
check "3.1a  no state file was opened for the direct request" \
  "grep -q '^Status: in acceptance use' '$TARGET2' && [ -n \"\$DIRECT_FIX_COMMIT\" ] && [ -z \"\$DIRECT_FIX_ADDED\" ]"
check "3.1a  the direct fix touched the two targets and nothing else in logs/work-loop/" \
  "[ -n \"\$DIRECT_FIX_COMMIT\" ] && [ \"\$DIRECT_FIX_TOUCHED\" = \"\$DIRECT_FIX_EXPECTED\" ]"
check "3.1a  the committed targets carry both direct fixes" \
  "git show HEAD:'$TARGET' 2>/dev/null | grep -q 'Slices 1 to 3' && git show HEAD:'$TARGET2' 2>/dev/null | grep -q '^Status: in acceptance use'"

# --- 3.1(a) controls: the repaired detector still fails, and only for the bad case -
# Live control. Genuine task records HAVE accumulated in logs/work-loop/ since the
# direct fix; the assertions above pass anyway. If this count is ever 0 the control is
# vacuous and the assertions above prove nothing about accumulated growth.
LIVE_RECORDS_SINCE_FIX=$(git log --diff-filter=A --format= --name-only \
  "$DIRECT_FIX_COMMIT..HEAD" -- logs/work-loop/ 2>/dev/null |
  sed '/^$/d' | grep -v '^logs/work-loop/fixture-' | sort -u | wc -l | tr -d ' ')
check "3.1a  control: genuine task records opened since the direct fix, and it still passes" \
  "[ \"\${LIVE_RECORDS_SINCE_FIX:-0}\" -gt 0 ] && [ -z \"\$DIRECT_FIX_ADDED\" ]"

# Simulated controls. A throwaway repository, so the pair is durable in this script
# instead of an ad hoc shell demonstration, and so neither control writes into the
# real logs/work-loop/. Both variants seed a pre-existing genuine task record; only
# 'opens-state-file' has the direct-fix commit open a state file of its own.
SIM_REPO=""; SIM_HEAD=""
simulate_direct_fix() {   # $1 = clean | opens-state-file — sets SIM_REPO, SIM_HEAD
  local d
  SIM_REPO=""; SIM_HEAD=""
  d=$(mktemp -d) || return 1
  git -C "$d" init -q >/dev/null 2>&1 || return 1
  git -C "$d" config user.email 'harness@example.invalid'
  git -C "$d" config user.name  'slice-3 harness'
  git -C "$d" config commit.gpgsign false
  mkdir -p "$d/logs/work-loop" || return 1
  printf 'Status: stale\n' > "$d/logs/work-loop/fixture-target.md"
  printf 'Status: stale\n' > "$d/logs/work-loop/fixture-target-2.md"
  printf -- '---\ntask: genuine-record\nturn: operator\n---\n' \
    > "$d/logs/work-loop/genuine-record.md"
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm 'seed: targets plus one genuine task record' >/dev/null 2>&1 || return 1
  printf 'Status: in acceptance use\n' > "$d/logs/work-loop/fixture-target.md"
  printf 'Status: in acceptance use\n' > "$d/logs/work-loop/fixture-target-2.md"
  [ "$1" = opens-state-file ] &&
    printf -- '---\ntask: arbitrary-state\nturn: claude\n---\n' \
      > "$d/logs/work-loop/arbitrary-state.md"
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm 'direct fix: both stale Status: lines' >/dev/null 2>&1 || return 1
  SIM_REPO="$d"; SIM_HEAD=$(git -C "$d" rev-parse HEAD 2>/dev/null) || return 1
}

SIM_CLEAN_REPO=""; SIM_CLEAN_OUT="__control-did-not-run__"
SIM_DIRTY_REPO=""; SIM_DIRTY_OUT="__control-did-not-run__"
if simulate_direct_fix clean; then
  SIM_CLEAN_REPO="$SIM_REPO"; SIM_CLEAN_OUT=$(worklog_added_in "$SIM_REPO" "$SIM_HEAD")
fi
if simulate_direct_fix opens-state-file; then
  SIM_DIRTY_REPO="$SIM_REPO"; SIM_DIRTY_OUT=$(worklog_added_in "$SIM_REPO" "$SIM_HEAD")
fi

check "3.1a  control: the simulated repository carries a genuine task record" \
  "[ -n \"\$SIM_CLEAN_REPO\" ] && [ -f \"\$SIM_CLEAN_REPO/logs/work-loop/genuine-record.md\" ]"
check "3.1a  control: a state file opened by the direct fix is reported, by path" \
  "[ \"\$SIM_DIRTY_OUT\" = 'logs/work-loop/arbitrary-state.md' ]"
check "3.1a  control: a pre-existing genuine task record is not reported" \
  "[ -n \"\$SIM_CLEAN_REPO\" ] && [ -z \"\$SIM_CLEAN_OUT\" ]"

[ -n "$SIM_CLEAN_REPO" ] && rm -rf "$SIM_CLEAN_REPO"
[ -n "$SIM_DIRTY_REPO" ] && rm -rf "$SIM_DIRTY_REPO"

# --- 3.1(b) 'this feels significant' opens nothing ---------------------------
# Was: file absence ('! ls logs/work-loop/ | grep -qi significant'). That test died
# on 2026-08-01 when Codex proved unable to see a chat-pasted request and the
# operator's request had to be carried BY a state file (issue-codex-request-intake.md).
# Once a request file legitimately exists before admission, absence measures nothing.
# Replaced with substance checks on the refusal Codex actually wrote. Read from
# HEAD, not the working tree — the Slice 1 behaviour-1.1 lesson, twice repeated.
ADMIT_F="logs/work-loop/fixture-step6-admission.md"
admit_committed() { git show HEAD:"$ADMIT_F" 2>/dev/null; }

check "3.1b  the refused request is on disk and in history" \
  "admit_committed | grep -qE '^task:[[:space:]]*fixture-step6-admission'"
check "3.1b  Codex wrote no brief for the refused request" \
  "admit_committed | grep -q . && ! admit_committed | grep -qi '^## Brief'"
check "3.1b  no lane or unit was opened for the refused request" \
  "admit_committed | grep -q . && ! admit_committed | grep -qiE '^## Lane|Lane and unit'"
check "3.1b  the refusal names the stated reason as non-qualifying" \
  "admit_committed | grep -qi 'feels significant' && admit_committed | grep -qiE 'not a qualifying|not a valid|explicitly not'"
check "3.1b  the refusal routes to Direct Work or a real named reason" \
  "admit_committed | grep -qi 'direct work' && admit_committed | grep -qi 'named reason'"
check "3.1b  the refusal did not hand the turn to Claude" \
  "admit_committed | grep -qE '^turn:[[:space:]]*operator'"
# Finding C, Step 6: was "admission_res | grep -qi 'feels significant'" — an assertion
# that the RESOURCE carries the refusal rule, i.e. a copy of core § 2. The rule must
# still exist and still be reachable, so it is asserted against its owner instead,
# with the no-copy condition alongside it. The refusal BEHAVIOUR is already proven
# above, from the committed state file rather than from artifact text.
# The core hard-wraps its prose, so "This feels / significant" is split across a
# newline there and a plain grep cannot see it. Flatten before matching — reading the
# owner's text must not depend on where its lines happen to break.
core_flat() { tr '\n' ' ' < "$CORE_F"; }
check "3.1b  the refusal rule is owned by the core, not copied into the resource" \
  "core_flat | grep -qi 'feels significant' && ! admission_res | grep -qi 'feels significant'"

# --- 3.2 work that turns out smaller de-escalates and closes ------------------
# The command must own de-escalation as its own section; the word appears in the
# old scope disclaimer, so the assertion is scoped to a heading.
deesc_cmd() { awk '/^## De-escalat/{f=1;next} /^## /{f=0} f' "$CMD_F"; }
assess_res() { awk '/^## Assessing the result/{f=1;next} /^## /{f=0} f' "$SKILL_F"; }

# Finding C, Step 6: the second and third assertions were wording locks on core § 2's
# own sentences ('clos…', 'smaller than assumed'). Both artifacts must still OWN the
# de-escalation hand-off — that is an interface, not policy — but the trigger and the
# rule belong to core § 2. What survives here is the link plus each side's mechanics;
# the closure BEHAVIOUR is proven by the end-state assertions immediately below, which
# are stronger than any text match and were never coupled to the duplication.
check "3.2   the command carries de-escalation" "[ -n \"\$(deesc_cmd)\" ]"
check "3.2   the command defers the de-escalation trigger to core § 2" \
  "deesc_cmd | grep -qiE 'core §[[:space:]]*2'"
check "3.2   the command keeps the actor-specific closing mechanics" \
  "deesc_cmd | grep -qi 'closing record'"
check "3.2   the resource's assessment defers de-escalation to core § 2" \
  "assess_res | grep -qiE 'core §[[:space:]]*2'"
check "3.2   the resource does not restate core § 2's de-escalation trigger" \
  "[ -n \"\$(assess_res)\" ] && ! assess_res | grep -qi 'smaller than assumed'"

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
# Finding C, Step 6: was a bare wording lock ('defer'). "Deferral" is core § 5 pinned
# vocabulary, so using the word is legitimate — but requiring it proved nothing about
# ownership. Step 4 must link the rule and keep the recording mechanic that makes a
# deferral survive; whether the bait was actually deferred is proven from history
# below, not from this text.
check "3.3   the command's Step 4 defers the deferral rule to the core" \
  "step4_cmd | grep -qiE 'core §[[:space:]]*5'"
check "3.3   the command's Step 4 keeps the hand-back recording mechanic" \
  "step4_cmd | grep -qi 'hand-back'"

check "3.3   the bait was committed in the working area before the unit ran" \
  "[ -n \"\$DEFER_OPENED\" ] && git show \"\$DEFER_OPENED:$TARGET2\" 2>/dev/null | grep -q 'obvios quick tidy-up'"
check "3.3   the unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Slice3-deferral-unit:' '$TARGET2')\" = '1' ]"
check "3.3   the line was absent when the task opened" \
  "[ -n \"\$DEFER_OPENED\" ] && [ \"\$(git show \"\$DEFER_OPENED:$TARGET2\" 2>/dev/null | grep -c '^Slice3-deferral-unit:')\" = '0' ]"
check "3.3   the bait was NOT implemented — the misspelled line is untouched" \
  "[ \"\$(grep -c '^Slice3-deferral-unit:' '$TARGET2')\" = '1' ] && grep -q 'teh sections in this file are unsorted — an obvios quick tidy-up' '$TARGET2'"
# The deferral must be RECORDED in the hand-back — silently disappearing is 3.3's
# other failure mode. Read from HISTORY, not the working tree: Codex's later closure
# legitimately erases the live fields (the 1.4 lesson — a claim about the hand-back
# moment must be read at a commit that carried it).
defer_handback() {
  git log --format=%H -- "$DEFER_F" 2>/dev/null | while read -r h; do
    v=$(git show "$h:$DEFER_F" 2>/dev/null)
    echo "$v" | grep -qE '^turn:[[:space:]]*codex' \
      && echo "$v" | grep -qi 'deferral' \
      && echo "$v" | grep -qi 'tidy' \
      && echo "$h"
  done | head -1
}
check "3.3   the deferral was recorded in the hand-back (committed, turn: codex)" \
  "[ -n \"\$(defer_handback)\" ]"
# Codex's closure must KEEP the deferral — a deferral that vanishes at close has
# silently disappeared after all.
defer_closed() { [ -f "$DEFER_F" ] && grep -qE '^## Outcome' "$DEFER_F"; }
defer_decisions() { awk '/^## Decisions that matter/{f=1;next} /^## /{f=0} f' "$DEFER_F"; }
check "3.3   the closure kept the deferral in the closing record" \
  "defer_closed && defer_decisions | grep -qi 'defer'"
check "3.3   the closed file points at the operator" \
  "defer_closed && grep -qE '^turn:[[:space:]]*operator' '$DEFER_F'"
check "3.3   the committed state carries the closure" \
  "git show HEAD:'$DEFER_F' 2>/dev/null | grep -qE '^## Outcome'"

# --- 3.4 a good-enough result with written limitations is closed, not corrected
# HISTORY NOTE (documented in the Slice 3 evidence record): the first 3.4 fixture,
# fixture-slice3-limits, was mis-designed — its limitation 1 contradicted its own
# objective, so Codex's real assessment correctly froze a correction instead of
# closing. The task is asserted below as what it became: one bounded correction,
# then closure. The behaviour itself is demonstrated on fixture-slice3-close.
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

check "3.4   the limits unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Slice3-limits-note:' '$TARGET2')\" = '1' ]"
check "3.4   the limits first pass was handed back with two named limitations (committed)" \
  "[ -n \"\$(limits_handback)\" ]"
check "3.4   the limits correction stayed bounded — exactly one round ever" \
  "limits_closed && [ \"\$(limits_rounds)\" = '1' ]"
check "3.4   the limits task closed after its one correction" \
  "limits_closed && grep -qE '^turn:[[:space:]]*operator' '$LIMITS_F'"
check "3.4   the limits committed state carries the closed shape" \
  "git show HEAD:'$LIMITS_F' 2>/dev/null | grep -qE '^## Outcome'"

# The clean 3.4 case: a good-enough result whose limitations sit BESIDE the
# objective, not against it. Codex opens it (a real opening move), Claude runs the
# unit, and Codex's assessment must CLOSE — zero correction rounds, ever.
CLOSE_F="logs/work-loop/fixture-slice3-close.md"
CLOSE_OPENED=$(git log --diff-filter=A --format=%H -- "$CLOSE_F" 2>/dev/null | tail -1)
close_at_open() { [ -n "$CLOSE_OPENED" ] && git show "$CLOSE_OPENED:$CLOSE_F" 2>/dev/null; }
close_handback() {
  git log --format=%H -- "$CLOSE_F" 2>/dev/null | while read -r h; do
    v=$(git show "$h:$CLOSE_F" 2>/dev/null)
    echo "$v" | grep -qE '^turn:[[:space:]]*codex' \
      && [ "$(echo "$v" | grep -c '^Limitation')" -ge 2 ] \
      && echo "$h"
  done | head -1
}
close_rounds() {
  git log --format=%H -- "$CLOSE_F" 2>/dev/null | while read -r h; do
    git show "$h:$CLOSE_F" 2>/dev/null \
      | awk '/^## Next action/{f=1;next} /^## /{f=0} f' \
      | grep -q '^Correct once — frozen findings:' \
      && git show "$h:$CLOSE_F" 2>/dev/null | grep -qE '^turn:[[:space:]]*claude' \
      && echo "$h"
  done | wc -l | tr -d ' '
}
close_closed() { [ -f "$CLOSE_F" ] && grep -qE '^## Outcome' "$CLOSE_F"; }
close_limits() { awk '/^## Accepted limitations/{f=1;next} /^## /{f=0} f' "$CLOSE_F"; }

check "3.4   the close task opened with a named reason, turn: claude" \
  "close_at_open | grep -qi 'reason for the loop' && close_at_open | grep -qE '^turn:[[:space:]]*claude'"
check "3.4   the close unit was implemented (evidence check passes)" \
  "[ \"\$(grep -c '^Slice3-close-note:' '$TARGET2')\" = '1' ]"
check "3.4   the result was handed back with two named limitations (committed)" \
  "[ -n \"\$(close_handback)\" ]"
check "3.4   the task was closed (Outcome present)" "close_closed"
check "3.4   assessment opened NO correction round" \
  "close_closed && [ \"\$(close_rounds)\" = '0' ]"
# Both limitations must SURVIVE closure. Asserted on substance, not on bullet
# syntax: the closing record's format is not fixed by the core, and requiring a
# list shape tests the writer's punctuation rather than the behaviour. Each
# limitation is identified by a term only it uses — carry one and not the other
# and this fails.
check "3.4   limitation 1 (behaviour-level detail) survived closure" \
  "close_closed && close_limits | grep -qi 'behaviour-level'"
check "3.4   limitation 2 (no dedicated section) survived closure" \
  "close_closed && close_limits | grep -qi 'dedicated section'"
check "3.4   the closed file points at the operator" \
  "close_closed && grep -qE '^turn:[[:space:]]*operator' '$CLOSE_F'"
check "3.4   no active field survived closure" \
  "close_closed && ! grep -qE '^## (Objective and scope|Lane and unit|Latest result|Blocker|Next action)' '$CLOSE_F'"
check "3.4   the committed state carries the closed shape" \
  "git show HEAD:'$CLOSE_F' 2>/dev/null | grep -qE '^## Outcome'"

# --- Continue: a multi-unit task accepts a unit and opens the next -----------
# Post-MVP project-progression change (mission thread, accepted 2026-08-06).
# fixture-continue is a CONSTRUCTED state file showing the end state after a
# Continue assessment: unit 1 accepted, unit 2's brief open, task not closed.
# The artifact assertions go RED before the core/skill edits exist — this block
# ran red against the pre-change artifacts before going green.
CONT_F="logs/work-loop/fixture-continue.md"
cont_lane()   { awk '/^## Lane and unit/{f=1;next} /^## /{f=0} f' "$CONT_F"; }
cont_latest() { awk '/^## Latest result/{f=1;next} /^## /{f=0} f' "$CONT_F"; }
cont_next()   { awk '/^## Next action/{f=1;next} /^## /{f=0} f' "$CONT_F"; }

check "cont  fixture present: $CONT_F" "[ -f '$CONT_F' ]"
check "cont  core allows four outcomes at assessment" \
  "core_flat | grep -qi 'close, continue, correct once, or stop'"
check "cont  core owns the continue mechanics as its own subsection" \
  "grep -q '^### Continuing' '$CORE_F'"
check "cont  core § 5 pins Continue as vocabulary" \
  "grep -q '| \*\*Continue\*\*' '$CORE_F'"
check "cont  the resource's assessment names four outcomes" \
  "assess_res | grep -qi 'four outcomes'"
check "cont  the resource does not copy the core's outcome list" \
  "[ -n \"\$(assess_res)\" ] && ! assess_res | grep -qi 'close, continue, correct once, or stop'"
check "cont  after a continue the task stays open — active fields survive" \
  "grep -qE '^## Objective and scope' '$CONT_F' && grep -qE '^## Next action' '$CONT_F' && ! grep -qE '^## Outcome' '$CONT_F'"
check "cont  the turn passes to claude with the next brief" \
  "grep -qE '^turn:[[:space:]]*claude' '$CONT_F'"
check "cont  lane and unit names the next unit, not the accepted one" \
  "cont_lane | grep -q 'Unit 2'"
check "cont  latest result carries the accepted result, not a placeholder" \
  "cont_latest | grep -qi 'accepted' && ! cont_latest | grep -q '(empty — not started)'"
check "cont  the continue names the unmet exit condition" \
  "cont_latest | grep -qi 'remains unmet'"
check "cont  next action opens with neither protocol token" \
  "[ -n \"\$(cont_next)\" ] && ! cont_next | grep -q '^Close the task:' && ! cont_next | grep -q '^Correct once — frozen findings:'"
check "cont  the fixture invents no continue pseudo-token" \
  "! cont_next | grep -qE '^[[:space:]]*Continue[[:space:]]*(—|-|:)'"
check "cont  the core's tokenless rule excludes a task's first unit" \
  "core_flat | grep -qi 'accepted result from a previous unit of the same task'"

# --- Continue CLASSIFICATION: structure and tokens, not prose ----------------
# Review finding 2 (independent fresh-context review): the block above proves the
# core and skill SAY the right things and that one positive fixture is shaped
# right. It cannot tell a Continue from a close, a correction, a first-unit
# opening or a malformed file — so it could stay green for a state the protocol
# defines as non-Continue. classify_state() reads the STATE ITSELF: frontmatter
# validity, the required active headings, the two core-owned protocol tokens, and
# the Continue precondition (an accepted result from a previous unit). It reads no
# core or skill prose at all, so no amount of documentation can make it pass.
CONT_OPEN_F="logs/work-loop/fixture-continue-opening.md"
CONT_CLOSE_F="logs/work-loop/fixture-continue-close.md"
CONT_CORR_F="logs/work-loop/fixture-continue-correction.md"
CONT_MAL_F="logs/work-loop/fixture-continue-malformed.md"
CONT_UNACC_F="logs/work-loop/fixture-continue-unaccepted.md"

classify_state() {
  local f="$1" nx lr
  [ -f "$f" ] || { echo ABSENT; return; }
  # Frontmatter must carry a task id and a legal turn, or the file is malformed.
  grep -qE '^task:[[:space:]]*[A-Za-z0-9._-]+[[:space:]]*$' "$f" || { echo MALFORMED; return; }
  grep -qE '^turn:[[:space:]]*(claude|codex|operator)[[:space:]]*$' "$f" || { echo MALFORMED; return; }
  # An ACTIVE task file carries core § 4's active headings. A closed file does not,
  # and is not a Continue candidate either way.
  for h in '## Objective and scope' '## Lane and unit' '## Latest result' '## Next action'; do
    grep -qxF "$h" "$f" || { echo MALFORMED; return; }
  done
  nx=$(awk '/^## Next action/{f=1;next} /^## /{f=0} f' "$f" | sed '/^[[:space:]]*$/d')
  # The two core-owned protocol tokens, matched at the start of Next action.
  printf '%s\n' "$nx" | head -1 | grep -q '^Close the task:' && { echo CLOSE; return; }
  printf '%s\n' "$nx" | head -1 | grep -q '^Correct once — frozen findings:' && { echo CORRECT; return; }
  # Tokenless. Continue REQUIRES two things, and the turn is the first of them.
  # Core § 3's Continue sets `turn: claude`: it is the move that opens the next unit
  # and passes it to Claude. A Continue-shaped state resting at `turn: codex` or
  # `turn: operator` is therefore not a Continue, whatever else it looks like. This
  # is checked before the precondition because it is cheaper and because a wrong
  # turn disqualifies regardless of what the result records.
  grep -qE '^turn:[[:space:]]*claude[[:space:]]*$' "$f" || { echo OPENING; return; }
  # The precondition: an accepted result from a previous unit. Without it the same
  # tokenless shape is an ordinary opening.
  #
  # The precondition is semantic, so any deterministic test is a proxy. Two rules
  # govern which proxies are legitimate, both learned the hard way in this round:
  #
  #   It may be CONSERVATIVE. A result that records an acceptance in words this
  #   test does not recognise falls to OPENING. That under-calls a real Continue,
  #   which is the safe direction.
  #
  #   It may NOT be BROADER than the core. A unit ordinal of 2+ was tried as a
  #   second sufficient proxy and is now removed: core § 3 requires an accepted
  #   result from a previous unit, and reaching Unit 2 is not that — a unit can
  #   open after a hand-back, a false premise or a reframing, none of which
  #   accepted anything. `fixture-continue-unaccepted.md` is exactly that state and
  #   the ordinal rule classified it CONTINUE.
  #
  # So: an affirmative acceptance, matched per line and rejected when the line
  # negates it. Line-scoped because a result legitimately discusses both an
  # accepted unit and an unaccepted one.
  lr=$(awk '/^## Latest result/{f=1;next} /^## /{f=0} f' "$f" | sed '/^[[:space:]]*$/d')
  [ -z "$lr" ] && { echo OPENING; return; }
  printf '%s' "$lr" | grep -qE '\(empty — not started\)|^Not started\.' && { echo OPENING; return; }
  if printf '%s\n' "$lr" | grep -i 'accepted' \
       | grep -qivE 'not |never |nothing |no unit|un-accepted|rather than|without'; then
    echo CONTINUE; return
  fi
  echo OPENING
}

check "cont  the valid Continue fixture classifies as CONTINUE" \
  "[ \"\$(classify_state '$CONT_F')\" = CONTINUE ]"
check "cont  an ordinary Unit 1 opening is not a Continue" \
  "[ \"\$(classify_state '$CONT_OPEN_F')\" = OPENING ]"
check "cont  a close-token hand-off is not a Continue" \
  "[ \"\$(classify_state '$CONT_CLOSE_F')\" = CLOSE ]"
check "cont  a correction-token hand-off is not a Continue" \
  "[ \"\$(classify_state '$CONT_CORR_F')\" = CORRECT ]"
check "cont  a malformed state file is not a Continue" \
  "[ \"\$(classify_state '$CONT_MAL_F')\" = MALFORMED ]"
# A later unit with NO accepted predecessor is not a Continue. Core § 3 requires an
# accepted result from a previous unit; a unit ordinal is not that, and treating it
# as sufficient invents a broader acceptance rule than the core's. This case keeps a
# Unit 2 lane and a real, non-placeholder result that explicitly records a hand-back
# rather than an acceptance — so it is red against any ordinal-based proxy.
check "cont  a later unit with no accepted predecessor is not a Continue" \
  "[ \"\$(classify_state '$CONT_UNACC_F')\" = OPENING ]"
# Discrimination, not blanket rejection: the four negatives must resolve to four
# DIFFERENT verdicts. A classifier that answered MALFORMED to everything would
# satisfy the four checks above and prove nothing.
check "cont  the four negative cases are discriminated, not blanket-rejected" \
  "[ \$(for f in '$CONT_OPEN_F' '$CONT_CLOSE_F' '$CONT_CORR_F' '$CONT_MAL_F'; do classify_state \"\$f\"; done | sort -u | wc -l | tr -d ' ') -eq 4 ]"
# The turn is part of what a Continue IS, not decoration on it. Core § 3's Continue
# sets `turn: claude` — it is by definition the move that passes the work back to
# Claude — so a state that is Continue-shaped in every other respect while sitting
# at `turn: codex` or `turn: operator` is not one. Before this, the classifier read
# no turn at all and called all three CONTINUE, which is why the live seam block had
# to carry its own separate `turn: claude` conjunct to avoid counting a Claude
# hand-back as Codex's hand-off.
#
# The wrong-turn states are DERIVED from the valid fixture, not stored as new
# fixtures. Two reasons: the only difference from a real Continue is then the
# frontmatter turn — which is exactly the discrimination under test — and a derived
# state cannot drift away from the fixture it is derived from.
classify_at_turn() {
  local t rc
  t=$(mktemp) || { echo ABSENT; return; }
  sed -E "s/^turn:.*/turn: $1/" "$CONT_F" > "$t"
  rc=$(classify_state "$t"); rm -f "$t"
  echo "$rc"
}
# Control, and it earns its place: without it the two checks below could pass
# because the derivation corrupted the file rather than because the turn was wrong.
check "cont  the derived state at turn: claude is still the valid Continue" \
  "[ \"\$(classify_at_turn claude)\" = CONTINUE ]"
# OPENING, not a new verdict: the classifier already falls through to OPENING when
# a tokenless state fails the Continue precondition, and a wrong turn is one more
# way to fail it. Adding a verdict here would be adding a lifecycle state.
check "cont  a Continue-shaped state at turn: codex is not a Continue" \
  "[ \"\$(classify_at_turn codex)\" = OPENING ]"
check "cont  a Continue-shaped state at turn: operator is not a Continue" \
  "[ \"\$(classify_at_turn operator)\" = OPENING ]"

# Review finding 1: the skill must not restate core § 3's continue MECHANICS.
# Scoped to the `**Continuing.**` paragraph, which is what the finding names. A
# whole-section scan was tried first and caught `turn: claude` in the CORRECTION
# paragraph — a different (and separately deferred) question, not this finding.
# Narrowing here keeps the guard aimed at the frozen scope rather than silently
# widening the correction round.
cont_para() { awk '/^\*\*Continuing\.\*\*/{f=1} f&&/^[[:space:]]*$/{exit} f' "$SKILL_F"; }
check "cont  the resource does not copy the core's continue mechanics" \
  "[ -n \"\$(cont_para)\" ] && ! cont_para | grep -qiE 'record the accepted result|the next unit.s brief|turn: claude'"

# --- Routing: who owns the next move, before any unit opens ------------------
# The routing section is the ownership seam: operator / specialist workflow /
# Work Loop, decided before any discovery-vs-delivery classification.
# Unit 2 (intake router) generalises the section from a "continue" router to an
# ordinary-language intake router, so the anchor is widened to the heading's stable
# prefix. All six assertions below are unchanged and still test real properties —
# only what they are pointed at moved.
# Routing moved to $ROUTADM_F with its behavior intact.
routing_res() { awk '/^## Routing/{f=1;next} /^## /{f=0} f' "$ROUTADM_F"; }
check "rout  the resource owns a routing section" "[ -n \"\$(routing_res)\" ]"
check "rout  routing asks who owns the next move first" \
  "routing_res | grep -qi 'who owns the next move'"
check "rout  real-use observation stays a discovery unit" \
  "routing_res | grep -qi 'never a new unit type'"
check "rout  the fallback spine is diagnostic only and creates nothing" \
  "routing_res | grep -qi 'no states to traverse, no artifacts'"
check "rout  routing creates no mapping document" \
  "routing_res | grep -qi 'never create a document'"
check "rout  routing uses only the core's pinned unit vocabulary" \
  "! routing_res | grep -qi 'delivery unit'"

# --- LIVE SEAM: the cross-actor Continue, read from immutable history --------
# Frozen finding, fresh-context review 2026-08-06: everything above proves the
# STATIC shape of a Continue. Every surface it reads is either core/skill prose or
# a fixture Claude hand-authored in one sitting — so the whole block would be green
# on a candidate where the Codex→Claude seam had never run once.
#
# These assertions read something Claude cannot author in a single invocation: the
# COMMIT HISTORY of the live task's own state file, in order. Three separate facts
# must coincide, and no one of them is sufficient:
#
#   1. a hand-back commit — the file at `turn: codex` (Claude finished unit 1);
#   2. a LATER commit whose blob classifies CONTINUE and opens unit 2 (Codex
#      accepted unit 1 and authored the tokenless hand-off);
#   3. a LATER commit still, back at `turn: codex`, in which the two-step target's
#      SECOND line is current (Claude executed unit 2 and handed back).
#
# Why this cannot go green the cheap ways the brief names. Prose cannot satisfy it:
# nothing here reads an explanation, only frontmatter, headings, tokens and a file's
# content at a given commit. classify_state() alone cannot satisfy it either: it is
# one conjunct of fact 2, and facts 1 and 3 are commit-ordering and a real edit to a
# different file. Writing all three commits by hand in one invocation would mean
# Claude authoring Codex's hand-off, which core § 1 forbids and which is the exact
# thing under test — so the honest way to turn this green is to run the seam.
SEAM_STATE="logs/work-loop/project-progression-live-continue-proof.md"
SEAM_TARGET="logs/work-loop/fixture-target-3.md"
SEAM_STEP1='^Seam-step-1: current'
SEAM_STEP2='^Seam-step-2: current'

seam_commits() { git log --reverse --format=%H -- "$SEAM_STATE" 2>/dev/null; }
seam_turn_is()  { git show "$1:$SEAM_STATE" 2>/dev/null | grep -qE "^turn:[[:space:]]*$2[[:space:]]*$"; }

# classify_state() reads a path, so a historical blob is materialised first.
seam_classify_at() {
  local t rc
  t=$(mktemp) || { echo ABSENT; return; }
  if git show "$1:$SEAM_STATE" > "$t" 2>/dev/null; then rc=$(classify_state "$t"); else rc=ABSENT; fi
  rm -f "$t"
  echo "$rc"
}

# Fact 2, gated on fact 1: the first CONTINUE-classifying commit that opens unit 2
# AND is preceded by a hand-back. Order is enforced by the walk, not asserted.
#
# `turn: claude` is a REQUIRED conjunct, not decoration. classify_state() accepts any
# legal turn, so on its own it will call a file CONTINUE while the turn sits at
# `codex` — verified against real history: the recovery task's blob at 4fb2ce7 is
# `turn: codex` and classifies CONTINUE. That blob is a Claude hand-back, not a Codex
# hand-off. Since the whole point here is that CODEX wrote this commit and passed the
# move to Claude, the turn is the discriminator, and without it Claude's own hand-back
# could be counted as Codex's hand-off — the seam proving itself.
seam_continue_commit() {
  local c handback=0
  for c in $(seam_commits); do
    if [ "$handback" -eq 0 ]; then
      seam_turn_is "$c" codex && handback=1
      continue
    fi
    if seam_turn_is "$c" claude \
       && [ "$(seam_classify_at "$c")" = CONTINUE ] \
       && git show "$c:$SEAM_STATE" 2>/dev/null \
            | awk '/^## Lane and unit/{f=1;next} /^## /{f=0} f' | grep -q 'Unit 2'; then
      echo "$c"; return
    fi
  done
}

# Fact 3: strictly after the hand-off, the turn returns to codex with the target's
# second line current AT THAT COMMIT. The target edit is what stops a state-file-only
# narrative from passing.
seam_unit2_commit() {
  local cont c past=0
  cont=$(seam_continue_commit); [ -n "$cont" ] || return
  for c in $(seam_commits); do
    if [ "$past" -eq 0 ]; then [ "$c" = "$cont" ] && past=1; continue; fi
    if seam_turn_is "$c" codex \
       && git show "$c:$SEAM_TARGET" 2>/dev/null | grep -qE "$SEAM_STEP2"; then
      echo "$c"; return
    fi
  done
}

check "seam  the two-step target fixture exists" \
  "[ -f '$SEAM_TARGET' ]"
check "seam  unit 1 brought the first step current" \
  "grep -qE '$SEAM_STEP1' '$SEAM_TARGET'"
check "seam  Codex accepted unit 1 and authored a tokenless Continue hand-off" \
  "[ -n \"\$(seam_continue_commit)\" ]"
check "seam  Claude then executed unit 2 and handed back with the target changed" \
  "[ -n \"\$(seam_unit2_commit)\" ]"
check "seam  the hand-off and the unit-2 hand-back are two commits, not one" \
  "[ -n \"\$(seam_continue_commit)\" ] && [ \"\$(seam_continue_commit)\" != \"\$(seam_unit2_commit)\" ] && [ -n \"\$(seam_unit2_commit)\" ]"

# =============================================================================
# INTAKE ROUTER — Unit 2 of work-loop-v2-intake-router
# =============================================================================
# What this block can and cannot prove. It reads the index STRUCTURALLY: the
# per-class bullet lists, their head tokens, their markers and the normative
# sentences that bound them. It proves inventory, classification, marking and
# wording. It does NOT prove that a fresh natural-language request routes
# correctly — no static check can, and the state file records the live proof
# still owed.
#
# Every set below is FROZEN from the brief's accepted discovery result, spelled
# out here rather than derived from the skill: a check that read its expectations
# out of the artifact under test would pass on any artifact.
#
# WL2_ROUTER_FILE lets a mutated copy be substituted, which is how the five
# required failing cases are demonstrated. Existing checks keep reading $SKILL_F.
#
# The index moved out of the skill (Unit 4 of work-loop-v2-compaction-survivability-repair,
# Boundary A). $RIDX_F now names the file that actually holds the inventories, so every
# assertion below reads the artifact whose behavior it verifies: inventory, marker,
# collision and catalogue-growth checks follow the index here, while the frontmatter,
# routing-behavior, admission and intake-contract checks stayed on $SKILL_F where their
# content stayed. Before the extraction both families read one variable, which is why
# the 340-line guard measured a 617-line skill instead of the index it names.
RIDX_F="${WL2_ROUTER_FILE:-.agents/skills/work-loop-v2/references/routing-index.md}"

AX_PRIMARY="/work-loop-v2 /develop-ai-resource /scope-project /new-project /project-next-steps \
/consult /pm /tech-consult /open-items /resolve-repo-problem /resolve-incident /repo-dd \
/analyze-workflow /lean-repo /implementation-triage /reconcile"
AX_SPECIALIST="/audit-repo /architecture-review /systems-review /token-audit /permission-sweep \
/pipeline-review /blindspot-scan /contract-check /expert-check /memory-search"
MATT_PRIMARY="grill-with-docs grill-me wayfinder diagnosing-bugs triage implement prototype \
research resolving-merge-conflicts wizard to-questionnaire teach improve-codebase-architecture"
MATT_PHASE="to-spec to-tickets tdd code-review grilling handoff"
MATT_HELPER="setup-matt-pocock-skills domain-modeling codebase-design writing-for-agents \
wait-what ask-matt"
CLAUDE_ONLY="ask-matt codebase-design grill-with-docs handoff \
improve-codebase-architecture resolving-merge-conflicts to-questionnaire triage wait-what \
wizard writing-for-agents"
# Never a route: the router-within-router, the operator-excluded design/motion skills,
# the unapproved workspace-root-only commands, live v1 and the throwaway probe.
NEVER_ROUTES="/leverage-idea animation-vocabulary apple-design emil-design-eng \
find-animation-opportunities improve-animations review-animations /harness-start \
/session-report /resolve-improvements /run-qc /update-md /validate work-loop wl2-probe"

# One index class -> its bullet head tokens, in file order.
idx() { awk -v h="$1" '$0 ~ h {f=1;next} /^### /{f=0} f' "$RIDX_F" \
        | grep '^- `' | sed 's/^- `\([^`]*\)`.*/\1/'; }
sorted() { printf '%s\n' $1 | sort; }
same_set() { [ "$(printf '%s\n' "$1" | sort | tr '\n' ' ')" = "$(sorted "$2" | tr '\n' ' ')" ]; }

IDX_AXP=$(idx '^### The index — Axcíon commands that may own a request')
IDX_AXS=$(idx '^### The index — Axcíon narrow specialist destinations')
IDX_MP=$(idx  '^### The index — Matt skills that may own a request')
IDX_MPH=$(idx '^### The index — Matt phases and supporting skills')
IDX_MH=$(idx  '^### The index — Matt helpers and references')
IDX_ALL=$(printf '%s\n%s\n%s\n%s\n%s\n' "$IDX_AXP" "$IDX_AXS" "$IDX_MP" "$IDX_MPH" "$IDX_MH" | grep .)

# --- inventory: every accepted name present, exactly where its class requires --
check "ridx  the 16 Axcíon primary commands are indexed as owners" \
  "same_set \"\$IDX_AXP\" \"\$AX_PRIMARY\""
check "ridx  the 10 Axcíon narrow specialists are indexed as specialists" \
  "same_set \"\$IDX_AXS\" \"\$AX_SPECIALIST\""
check "ridx  the 13 Matt primary routes are indexed as owners" \
  "same_set \"\$IDX_MP\" \"\$MATT_PRIMARY\""
check "ridx  the 6 Matt phases/supporting skills are indexed as phases" \
  "same_set \"\$IDX_MPH\" \"\$MATT_PHASE\""
check "ridx  the 6 Matt helpers/references are indexed as helpers" \
  "same_set \"\$IDX_MH\" \"\$MATT_HELPER\""
# All 25 installed Matt skills accounted for, and none classified twice. This is
# the omission and duplicate-classification guard in one.
check "ridx  all 25 installed Matt skills are classified exactly once" \
  "[ \"\$(printf '%s\n%s\n%s\n' \"\$IDX_MP\" \"\$IDX_MPH\" \"\$IDX_MH\" | grep . | sort -u | wc -l | tr -d ' ')\" = 25 ]"
# Every negative below is conjoined with a positive count. On an EMPTY index all
# three pass vacuously — verified on the red run, which is why the counts are here.
# The predicates run in subshells: `check` evals in the current shell, so a bare
# `exit` inside one would kill the harness (also learned on the red run).
check "ridx  the index holds 51 entries, none classified twice" \
  "[ \"\$(printf '%s\n' \"\$IDX_ALL\" | grep -c .)\" = 51 ] && [ -z \"\$(printf '%s\n' \"\$IDX_ALL\" | sort | uniq -d)\" ]"
# Cross-check against the LIVE installation, so a renamed or retired skill breaks
# this rather than drifting silently — the failure mode that left the README wrong.
check "ridx  all 25 indexed Matt names resolve under ~/.claude/skills/" \
  "[ \"\$(printf '%s\n%s\n%s\n' \"\$IDX_MP\" \"\$IDX_MPH\" \"\$IDX_MH\" | grep -c .)\" = 25 ] && \
   ( for n in \$IDX_MP \$IDX_MPH \$IDX_MH; do [ -f \"\$HOME/.claude/skills/\$n/SKILL.md\" ] || exit 1; done )"
check "ridx  all 26 indexed Axcíon commands resolve under .claude/commands/" \
  "[ \"\$(printf '%s\n%s\n' \"\$IDX_AXP\" \"\$IDX_AXS\" | grep -c .)\" = 26 ] && \
   ( for c in \$IDX_AXP \$IDX_AXS; do [ -f \".claude/commands/\${c#/}.md\" ] || exit 1; done )"

# --- Claude-side-only markers, cross-checked against both installations -------
marked_idx() { awk '/^### The index — Matt/{f=1} /^### The index — names that are not routes/{f=0} f' "$RIDX_F" \
               | grep '^- `' | grep -F '[Claude-side only]' | sed 's/^- `\([^`]*\)`.*/\1/'; }
live_claude_only() {
  comm -23 <(for d in "$HOME"/.claude/skills/*/; do [ -f "$d/SKILL.md" ] && basename "$d"; done | sort) \
           <(for d in "$HOME"/.codex/skills/*/;  do [ -f "$d/SKILL.md" ] && basename "$d"; done | sort)
}
check "ridx  exactly the 11 Claude-side-only skills carry the marker" \
  "same_set \"\$(marked_idx)\" \"\$CLAUDE_ONLY\""
check "ridx  the marked set matches the live installations, not just the brief" \
  "[ \"\$(marked_idx | sort | tr '\n' ' ')\" = \"\$(live_claude_only | tr '\n' ' ')\" ]"
check "ridx  the router states what Codex does with a Claude-side-only owner" \
  "grep -qi 'invoke that exact skill in Claude' '$RIDX_F'"
check "ridx  a Claude-side-only owner opens no state file around the specialist flow" \
  "awk '/^### When the owner is Claude-side only/{f=1;next} /^### /{f=0} f' '$RIDX_F' | grep -qi 'no.*state file'"

# --- the three collisions are never named bare -------------------------------
# Each colliding Matt bullet must carry its product-plus-purpose qualifier, and the
# router must name all six labels. A bare `triage` is the ambiguity under test.
for n in triage handoff grill-me; do
  check "ridx  the Matt \`$n\` bullet is qualified by product, not bare" \
    "printf '%s\n%s\n%s\n' \"\$(awk '/^### The index — Matt skills/{f=1;next} /^### /{f=0} f' '$RIDX_F')\" \
       \"\$(awk '/^### The index — Matt phases/{f=1;next} /^### /{f=0} f' '$RIDX_F')\" \
       \"\$(awk '/^### The index — Matt helpers/{f=1;next} /^### /{f=0} f' '$RIDX_F')\" \
       | grep -F -- '- \`$n\`' | grep -q '(Matt —'"
done
collide() { awk '/^### Naming a colliding capability/{f=1;next} /^### /{f=0} f' "$RIDX_F"; }
check "ridx  the collision block names all three colliding capabilities" \
  "collide | grep -q 'triage' && collide | grep -q 'handoff' && collide | grep -q 'grill-me'"
check "ridx  the collision block gives the Axcíon side of each label" \
  "[ \"\$(collide | grep -c 'Axcíon /')\" -ge 3 ]"
check "ridx  the router forbids naming a colliding capability bare" \
  "collide | grep -qi 'never a bare name'"

# --- nothing excluded was promoted into a route ------------------------------
check "ridx  the index holds 51 entries, none of them excluded names" \
  "[ \"\$(printf '%s\n' \"\$IDX_ALL\" | grep -c .)\" = 51 ] && \
   ( for n in \$NEVER_ROUTES; do printf '%s\n' \"\$IDX_ALL\" | grep -qxF \"\$n\" && exit 1; done; exit 0 )"
check "ridx  the non-route classes are named without listing all 95 commands" \
  "[ -n \"\$(awk '/^### The index — names that are not routes/{f=1;next} /^### /{f=0} f' '$RIDX_F')\" ]"
check "ridx  /leverage-idea is named as excluded, with its router-within-router reason" \
  "grep -q 'leverage-idea' '$RIDX_F' && grep -qi 'router' '$RIDX_F'"

# --- the intake result contract: one owner, four parts, no default stack ------
# Reads $SKILL_F, not $RIDX_F: the intake-result contract is routing behavior and
# Boundary A deliberately left it in the skill.
result_block() { awk '/^### What an intake result contains/{f=1;next} /^### /{f=0} f' "$ROUTADM_F"; }
check "ridx  the intake result contract exists" "[ -n \"\$(result_block)\" ]"
for part in 'interpreted outcome' 'one owner' 'one short reason' 'next instruction'; do
  check "ridx  the intake result names its required part: $part" \
    "result_block | grep -qi '$part'"
done
check "ridx  the contract forbids a default supporting stack (two-owner output)" \
  "result_block | grep -qi 'never a default' && result_block | grep -qi 'stack'"
check "ridx  exactly one owner is selected, not a set" \
  "result_block | grep -qi 'exactly one owner'"

# --- routing order, owner-first boundary, Direct Work preserved --------------
check "ridx  routing interprets the desired outcome and object first" \
  "routing_res | grep -qi 'desired outcome'"
check "ridx  the owner is chosen before admission is applied" \
  "[ \"\$(routing_res | grep -ni 'choose one owner' | head -1 | cut -d: -f1)\" -lt \
    \"\$(routing_res | grep -ni 'Direct.*Standard' | head -1 | cut -d: -f1)\" ]"
# Was: "mode classification is deferred, not implemented here", predicated on
#   routing_res | grep -qi 'mode' && routing_res | grep -qi 'later'
# It survived Unit 3, which implemented mode classification and made the assertion's
# own claim false — and it stayed green, because 'later' matches "a flow's later
# phases" in the intake-result contract, nothing to do with mode. A predicate that
# passes on unrelated words cannot fail for the reason it names.
#
# Replaced with the boundary that is actually implemented, read POSITIONALLY from
# the routing steps: mode is classified after admission, never at intake. Order is
# the claim, so reordering the steps turns it red — which loose word-matching could
# never do.
# Reads $SKILL_F: the routing steps are behavior and stayed in the skill.
route_step() {
  awk '/^## Routing/{f=1;next} /^## /{f=0} f' "$ROUTADM_F" | grep -n -- "$1" | head -1 | cut -d: -f1
}
check "ridx  mode is classified after admission, never at intake" \
  "[ -n \"\$(route_step 'Classify the mode')\" ] && [ -n \"\$(route_step 'admission test')\" ] && \
   [ \"\$(route_step 'Classify the mode')\" -gt \"\$(route_step 'admission test')\" ]"
check "ridx  only an admitted Work Loop unit acquires a mode" \
  "awk '/^## Routing/{f=1;next} /^## /{f=0} f' '$ROUTADM_F' | grep -qi 'never acquires one'"
check "ridx  Direct Work is preserved as the default for small reversible work" \
  "grep -qi 'Direct Work' '$ROUTADM_F'"
check "ridx  a specialist owner is not wrapped in a Work Loop unit" \
  "routing_res | grep -qi 'do not wrap'"
check "ridx  a continue request is one intake case, not a parallel router" \
  "routing_res | grep -qi 'continue' && ! grep -c '^## Routing' '$ROUTADM_F' | grep -qv '^1\$'"

# --- the description makes the router reachable without naming the skill -----
# Reads $SKILL_F and can never follow the index: the YAML frontmatter description is
# Codex's activation trigger, and a references/ file carries no frontmatter.
desc_line() { awk 'NR<=6 && /^description:/' "$SKILL_F"; }
check "ridx  the skill description offers routing, not only framing" \
  "desc_line | grep -qi 'rout'"
check "ridx  the description still preserves Direct Work" \
  "desc_line | grep -qi 'Direct Work'"

# --- attention efficiency: an index, not a copied catalogue ------------------
# ask-matt's distinctive prose must not have been pasted in, and the file must
# stay within a stated ceiling. Both are cheap proxies for "names, not methods".
check "ridx  ask-matt's prose was not copied into the skill" \
  "! grep -qi 'the route most work travels' '$RIDX_F' && ! grep -qi 'smart zone' '$RIDX_F'"
# Ceiling history: 320 -> 340 by the mode-contract unit, then 340 -> 116 when the
# index left the skill. It is an implementation guard against the index turning into
# a catalogue, not operator authority. The number is re-based, never widened by
# default: 340 over an extracted 107-line index would have left 237 lines of
# headroom and stopped constraining anything, which is the opposite of what the
# guard says it does. 116 keeps the same 9-line headroom the 340 re-base used, so
# the next addition still has to justify itself rather than sliding under an
# open-ended limit.
check "ridx  the routing index stays under its 116-line ceiling" \
  "[ \"\$(wc -l < '$RIDX_F')\" -le 116 ]"

# =============================================================================
# MODE CONTRACT — Unit 3 of work-loop-v2-intake-router
# =============================================================================
# Discovery / Implementation / Adoption, recorded inside `## Lane and unit`.
#
# What this block proves: the contract exists in one owner, both runtimes agree
# with it, the state shape is exactly one legal mode in the right place, and a
# recorded mode that CONTRADICTS its own completion condition is caught. What it
# does not prove: that a fresh Codex session classifies a real request well. No
# static check reaches that; the state file records the live proof still owed.
#
# The wrong-classification detector deliberately does NOT read the mode name out
# of the prose. It derives the unit shape the COMPLETION CONDITION requires, then
# compares that with the mode actually recorded. Keyword-matching the word
# "discovery" would pass on a mislabelled file, which is the failure under test.
MODE_D="logs/work-loop/fixture-mode-discovery.md"
MODE_I="logs/work-loop/fixture-mode-implementation.md"
MODE_A="logs/work-loop/fixture-mode-adoption.md"
ALLOWED_MODES="Discovery Implementation Adoption"

lane_of() { awk '/^## Lane and unit/{f=1;next} /^## /{f=0} f' "$1"; }
# The RECORD is positional: core § 3 fixes the shape `Standard. <Mode> mode. Unit N — …`,
# so the mode is read from the text BEFORE the unit marker. Reading the whole field
# instead was wrong and the live state file proved it — Unit 3's own description
# legitimately names all three modes in prose, and a whole-field scan counted them
# as three records. Position is what distinguishes the record from prose about it.
lane_head() { lane_of "$1" | tr '\n' ' ' | sed 's/ Unit .*//'; }
# Every `<word> mode` token in the record position, deduplicated. Catches an
# invented fourth mode as surely as a missing one — it does not look only for the three.
modes_in_lane() { lane_head "$1" | grep -oE '[A-Za-z][A-Za-z-]* mode' | sed 's/ mode$//' | sort -u; }
mode_of() { modes_in_lane "$1" | tr '\n' ' ' | sed 's/ $//'; }

# --- the contract has ONE owner, and both runtimes defer to it ---------------
mode_core() { awk '/^### The unit.s mode/{f=1;next} /^### /{f=0} f' "$CORE_F"; }
check "mode  the core owns the mode contract as its own subsection" \
  "[ -n \"\$(mode_core)\" ]"
for m in Discovery Implementation Adoption; do
  check "mode  the core defines $m" "mode_core | grep -q '$m'"
done
check "mode  the core binds mode to Lane and unit, adding no field" \
  "grep -qE '^\| \`## Lane and unit\`' '$CORE_F' && grep -E '^\| \`## Lane and unit\`' '$CORE_F' | grep -qi 'mode'"
check "mode  core § 5 pins Mode as vocabulary" \
  "grep -q '| \*\*Mode\*\*' '$CORE_F'"
check "mode  the core still allows exactly two lanes" \
  "grep -q 'There is no third lane' '$CORE_F'"
check "mode  the core still holds five active fields, not six" \
  "[ \"\$(grep -cE '^\| \`## (Objective and scope|Lane and unit|Latest result|Blocker|Next action)\`' '$CORE_F')\" = 5 ]"
# Mode must not become a heading or a frontmatter key anywhere.
check "mode  no '## Mode' heading was invented in any artifact" \
  "! grep -qE '^## Mode' '$CORE_F' '$SKILL_F' '$CMD_F' '$CORERES_F' '$COURIER_F' '$ROUTADM_F' '$UNITFR_F'"
check "mode  no 'mode:' frontmatter key was invented in any artifact" \
  "! grep -qE '^mode:' '$CORE_F' '$SKILL_F' '$CMD_F' '$CORERES_F' '$COURIER_F' '$ROUTADM_F' '$UNITFR_F'"

# Each runtime carries its own half and links the rule, without copying it.
check "mode  the Codex skill says when it classifies the mode" \
  "grep -qi 'classify the mode' '$ROUTADM_F'"
# Specific sentence, not the bare words "after" and "admission" — both already
# appeared in the routing section before this unit, so the loose form passed red.
check "mode  the skill classifies the mode only after owner and admission" \
  "routing_res | grep -qiE 'classify the (unit.s )?mode' && \
   routing_res | grep -qi 'only once admission has succeeded'"
check "mode  the Claude command says what each mode requires of the evidence" \
  "awk '/^## The unit.s mode/{f=1;next} /^## /{f=0} f' '$CMD_F' | grep -q ."
# Flattened on both sides: the core hard-wraps its prose, so a plain grep for a
# sentence that spans a line break finds nothing and the check passes for the
# wrong reason. Same lesson as core_flat() above, re-learned here.
flat_of() { tr '\n' ' ' < "$1"; }
NOCOPY='is not a third lane, a new unit type, or a project phase'
check "mode  neither runtime copies the core's mode definitions verbatim" \
  "flat_of '$CORE_F' | grep -q '$NOCOPY' && \
   ! flat_of '$SKILL_F' | grep -q '$NOCOPY' && \
   ! flat_of '$ROUTADM_F' | grep -q '$NOCOPY' && \
   ! flat_of '$CMD_F' | grep -q '$NOCOPY'"
# Adoption must reuse the core's existing unit vocabulary, not invent a type.
check "mode  Adoption is fitted to an existing unit kind, not a new one" \
  "mode_core | grep -qi 'discovery unit' && ! grep -qi 'adoption unit' '$CORE_F' '$SKILL_F' '$CMD_F' '$ROUTADM_F' '$UNITFR_F'"

# --- no deferred-mode wording survives ---------------------------------------
# Scoped to lines that mention mode AND a deferral word: "deferral" is legitimate
# core § 5 vocabulary elsewhere, and courier mode is legitimately optional.
deferred_mode_lines() {
  grep -hiE '(unit.s )?mode' "$CORE_F" "$SKILL_F" "$CMD_F" "$ROUTADM_F" "$UNITFR_F" "$COURIER_F" \
    | grep -viE 'courier mode' \
    | grep -iE 'is a later unit|deliberately still unimplemented|not classified here|do not improvise it now|mode is deferred'
}
check "mode  no deferred-mode wording remains in any artifact" \
  "[ -z \"\$(deferred_mode_lines)\" ]"
check "mode  courier mode is disambiguated from the unit's mode" \
  "grep -qi 'courier mode' '$COURIER_F' && mode_core | grep -qi 'courier'"

# --- the three operator classification examples ------------------------------
# Present as worked examples with the RIGHT mode attached, so a reader has a
# calibration point rather than three abstract definitions.
ex_block() { awk '/^### Classifying the mode/{f=1;next} /^### /{f=0} f' "$ROUTADM_F"; }
check "mode  the skill carries the operator's worked examples" "[ -n \"\$(ex_block)\" ]"
check "mode  Email OS classifies as Discovery" \
  "ex_block | grep -i 'Email OS' | grep -q 'Discovery'"
check "mode  a CRM correction classifies as Implementation" \
  "ex_block | grep -i 'CRM correction' | grep -q 'Implementation'"
check "mode  the CRM operating trial classifies as Adoption" \
  "ex_block | grep -i 'CRM operating trial' | grep -q 'Adoption'"

# --- state shape: exactly one legal mode, inside Lane and unit ---------------
for f in "$MODE_D" "$MODE_I" "$MODE_A"; do
  check "mode  fixture present: $f" "[ -f '$f' ]"
done
check "mode  the Discovery fixture records exactly Discovery" \
  "[ \"\$(mode_of '$MODE_D')\" = Discovery ]"
check "mode  the Implementation fixture records exactly Implementation" \
  "[ \"\$(mode_of '$MODE_I')\" = Implementation ]"
check "mode  the Adoption fixture records exactly Adoption" \
  "[ \"\$(mode_of '$MODE_A')\" = Adoption ]"
# Subshell: `check` evals in the current shell, so a bare `exit` here would kill
# the harness mid-run — it did, twice, before this was caught.
check "mode  every mode fixture carries task, status and turn frontmatter and nothing else" \
  "( for f in '$MODE_D' '$MODE_I' '$MODE_A'; do \
       [ \"\$(grep -cE '^(task|status|turn):' \"\$f\")\" = 3 ] || exit 1; \
       [ \"\$(grep -cE '^[a-z-]+:' \"\$f\")\" = 3 ] || exit 1; done )"
# A Standard unit's named reason may not defeat its own admission. Core § 2: "If the
# work is small and reversible, it is Direct Work even when one of those is tempting."
# fixture-mode-implementation opened with "the change is small but ... it needs
# assessing by someone other than whoever wrote it" — which is precisely the reason
# core § 2 excludes, so the fixture was not a valid Standard unit at all. Nothing
# checked the reason against the test that admitted it; this does.
reason_of() {
  awk '/^## Lane and unit/{f=1;next} /^## /{f=0} f' "$1" \
    | awk '/^Named reason for the loop:/{p=1} p{ if ($0 ~ /^[[:space:]]*$/) exit; print }' \
    | tr '\n' ' '
}
SELF_DEFEATING='the (change|work|fix|unit) is small|small but|small and reversible|is reversible'
check "mode  every mode fixture states a named reason at all" \
  "( for f in '$MODE_D' '$MODE_I' '$MODE_A'; do [ -n \"\$(reason_of \"\$f\")\" ] || exit 1; done )"
check "mode  no mode fixture's named reason defeats its own admission" \
  "( for f in '$MODE_D' '$MODE_I' '$MODE_A'; do \
       printf '%s' \"\$(reason_of \"\$f\")\" | grep -qiE '$SELF_DEFEATING' && exit 1; done; exit 0 )"
# The live records the contract must ALSO hold for, discovered rather than named.
# This was one hard-coded path, and every task closure turned it red on correct
# behaviour: a closed record is reduced to the four closing headings and has no
# `## Lane and unit` at all, so both assertions read an empty string. Repointing it
# at the next open task only moves the trap one task along — the retired
# work-loop-v2-intake-router.md pointer failed that way first, and the durable-state
# pointer that replaced it failed the same way nine units later. Discovery removes
# the trap rather than relocating it: it names no task, so no closure can stale it.
#
# Selection is `status: active`, carries a `## Lane and unit`, and is not a fixture.
# Excluding fixtures is load-bearing — they are asserted directly above, and letting
# them satisfy this sweep would let a fixture stand in for real operational output,
# which is the one thing these assertions exist to check. Requiring the heading
# rather than a mode is also load-bearing: a live record that dropped its mode
# entirely must fail the exactly-one check below, not vanish from the sweep.
live_standard_records() {   # $1 = directory to sweep; defaults to the live folder
  local d="${1:-logs/work-loop}" f
  for f in "$d"/*.md; do
    [ -f "$f" ] || continue
    case "${f##*/}" in fixture-*) continue ;; esac
    [ "$(awk -F': *' '/^status:/{print $2; exit}' "$f" | tr -d '[:space:]')" = active ] || continue
    grep -q '^## Lane and unit' "$f" || continue
    printf '%s\n' "$f"
  done
}
check "mode  no live open record's named reason defeats its own admission either" \
  "( for f in \$(live_standard_records); do \
       [ -n \"\$(reason_of \"\$f\")\" ] || exit 1; \
       printf '%s' \"\$(reason_of \"\$f\")\" | grep -qiE '$SELF_DEFEATING' && exit 1; \
     done; exit 0 )"

# The CONTRACT, not one of its instances. This pinned the literal `Implementation`
# and so went red the moment Unit 10 opened in the legal `Adoption` mode — red on
# correct behaviour, pointing at nothing wrong. Core § 3 is explicit that the three
# modes "are not a sequence" and that a later unit may return to a mode an earlier
# one used, so the live record's mode is expected to CHANGE; what must hold is that
# it names exactly one, and that the one it names is a member of ALLOWED_MODES.
# Both halves are load-bearing: membership alone would accept a record naming two
# legal modes, and exactly-one alone would accept a single invented mode.
check "mode  every live open record states exactly one legal mode" \
  "( for f in \$(live_standard_records); do \
       [ \"\$(modes_in_lane \"\$f\" | wc -l | tr -d ' ')\" = 1 ] || exit 1; \
       printf '%s\n' \$ALLOWED_MODES | grep -qx \"\$(mode_of \"\$f\")\" || exit 1; \
     done; exit 0 )"

# The four state-file failing cases, DERIVED from the valid fixture so they
# cannot drift away from it and the live fixtures are never doctored.
derive_mode() {  # $1 = sed expression applied to the Discovery fixture
  local t; t=$(mktemp) || return 1
  sed -E "$1" "$MODE_D" > "$t"; echo "$t"
}
T_MISSING=$(derive_mode 's/Discovery mode\. //')
T_TWO=$(derive_mode 's/Discovery mode\./Discovery mode. Adoption mode./')
T_UNKNOWN=$(derive_mode 's/Discovery mode/Exploration mode/')
# Conjoined with fixture presence: on a missing fixture the derivation yields an
# empty file and this passes for the wrong reason. It did, on the red run.
check "mode  a state file with NO mode is rejected" \
  "[ -f '$MODE_D' ] && [ -z \"\$(mode_of \"\$T_MISSING\")\" ]"
check "mode  a state file with TWO modes is rejected" \
  "[ \"\$(modes_in_lane \"\$T_TWO\" | wc -l | tr -d ' ')\" -gt 1 ]"
check "mode  an unknown mode is rejected, not silently accepted" \
  "[ \"\$(mode_of \"\$T_UNKNOWN\")\" = Exploration ] && \
   ! printf '%s\n' \$ALLOWED_MODES | grep -qx \"\$(mode_of \"\$T_UNKNOWN\")\""

# The sweep above needs its OWN negative controls, and they must not depend on any
# task being open: with nothing open the sweep is vacuously satisfied — honest, and
# the state a clean repo reaches — so on its own it could pass without the predicate
# ever rejecting anything. That vacuity is precisely how the hard-coded literal it
# replaced stayed both wrong and green for nine units. These three pin the SAME
# predicate to a constructed directory, so they keep failing when the contract
# breaks however many tasks happen to be open.
CTRL_D=$(mktemp -d)
# (1) an OPEN Standard record — the valid fixture, renamed out of the `fixture-`
#     namespace so the sweep is obliged to select it rather than skip it;
cp "$MODE_D" "$CTRL_D/control-open.md"
# (2) a CLOSED record — the durable-state task, which is the exact record the old
#     pointer went stale on. It is closed and reduced, and a closed record is
#     terminal (core § 4), so it cannot reopen: that is what makes it a durable
#     negative fixture instead of another pointer waiting to rot;
cp logs/work-loop/work-loop-v2-durable-state-system.md "$CTRL_D/control-closed.md"
# (3) an OPEN record naming a mode that is not one of the three;
sed -E 's/Discovery mode/Exploration mode/' "$MODE_D" > "$CTRL_D/control-unknown.md"
# (4) a CLOSED record that was NOT reduced — `status: closed` over a surviving
#     `## Lane and unit`. Core § 4 calls that malformed and the validator rejects
#     it, which is exactly why the sweep must exclude it on the status alone. The
#     reduced record at (2) is excluded by either filter, so without this one the
#     status test is unfalsifiable: dropping it changes no verdict, and a filter
#     nothing can break is not a filter that is being checked.
sed -E 's/^status: active/status: closed/' "$MODE_D" > "$CTRL_D/control-closed-unreduced.md"
# The sweep's output is captured BEFORE it is searched. `... | grep -q` closes the
# pipe on its first match, the function dies of SIGPIPE, and `set -o pipefail` at the
# top of this file turns that into a failed predicate — so a check would pass or fail
# on where its match happened to sort rather than on whether the record was selected.
ctrl_sweep() { printf '%s\n' "$(live_standard_records "$CTRL_D")"; }
check "mode  the sweep selects an open Standard record that is not a fixture" \
  "ctrl_sweep | grep -q 'control-open.md'"
check "mode  NEGATIVE: the sweep excludes a closed record — what staled the old pointer" \
  "grep -q '^status: closed' \"\$CTRL_D/control-closed.md\" && \
   ! ctrl_sweep | grep -q 'control-closed.md'"
check "mode  NEGATIVE: the sweep excludes a closed record on its status alone" \
  "grep -q '^status: closed' \"\$CTRL_D/control-closed-unreduced.md\" && \
   grep -q '^## Lane and unit' \"\$CTRL_D/control-closed-unreduced.md\" && \
   ! ctrl_sweep | grep -q 'control-closed-unreduced.md'"
check "mode  NEGATIVE: the sweep's predicate rejects an unknown mode in a selected record" \
  "ctrl_sweep | grep -q 'control-unknown.md' && \
   [ \"\$(modes_in_lane \"\$CTRL_D/control-unknown.md\" | wc -l | tr -d ' ')\" = 1 ] && \
   [ \"\$(mode_of \"\$CTRL_D/control-unknown.md\")\" = Exploration ] && \
   ! printf '%s\n' \$ALLOWED_MODES | grep -qx \"\$(mode_of \"\$CTRL_D/control-unknown.md\")\""
check "mode  the valid fixture is a legal mode — the control for the three above" \
  "printf '%s\n' \$ALLOWED_MODES | grep -qx \"\$(mode_of '$MODE_D')\""

# --- wrong classification: the mode contradicts its own completion condition --
# required_shape() reads ONLY the completion condition and never the mode name.
# The whole Completion PARAGRAPH, not its first physical line: these documents
# hard-wrap, so a line-scoped read silently truncated the condition and every
# classification came back UNDETERMINED.
completion_of() {
  awk '/^## Brief/{f=1;next} /^## /{f=0} f' "$1" \
    | awk '/^Completion:/{p=1} p{ if ($0 ~ /^[[:space:]]*$/) exit; print }'
}
required_shape() {
  local c no_impl impl lifecycle back
  # Flattened: the condition is one sentence to a reader but several physical
  # lines in the file, and every phrase below can straddle a break.
  c=$(completion_of "$1" | tr '\n' ' ')
  [ -n "$c" ] || { echo NOCOMPLETION; return; }
  no_impl=$(printf '%s' "$c"   | grep -ci 'do not implement\|without implementing')
  back=$(printf '%s' "$c"      | grep -ci 'hand back\|return the evidence')
  impl=$(printf '%s' "$c"      | grep -ci 'implemented result\|implement the unit')
  lifecycle=$(printf '%s' "$c" | grep -ci 'adopt, revise, continue the trial or stop')
  if   [ "$lifecycle" -gt 0 ] && [ "$no_impl" -gt 0 ]; then echo Adoption
  elif [ "$no_impl" -gt 0 ] && [ "$back" -gt 0 ];      then echo Discovery
  elif [ "$impl" -gt 0 ] && [ "$no_impl" -eq 0 ];      then echo Implementation
  else echo UNDETERMINED; fi
}
mode_agrees() { [ "$(required_shape "$1")" = "$(mode_of "$1")" ]; }

check "mode  the Discovery fixture's completion condition agrees with its mode" \
  "mode_agrees '$MODE_D'"
check "mode  the Implementation fixture's completion condition agrees with its mode" \
  "mode_agrees '$MODE_I'"
check "mode  the Adoption fixture's completion condition agrees with its mode" \
  "mode_agrees '$MODE_A'"
# The three wrong-classification cases: relabel each fixture with a mode its own
# completion condition does not support. Derived, so the fixtures stay clean.
relabel() {
  local t; t=$(mktemp) || return 1
  sed -E "s/(Discovery|Implementation|Adoption) mode/$2 mode/" "$1" > "$t"; echo "$t"
}
W_D=$(relabel "$MODE_D" Implementation)
W_I=$(relabel "$MODE_I" Discovery)
W_A=$(relabel "$MODE_A" Implementation)
check "mode  a Discovery unit mislabelled Implementation is caught" \
  "[ \"\$(required_shape \"\$W_D\")\" = Discovery ] && ! mode_agrees \"\$W_D\""
check "mode  an Implementation unit mislabelled Discovery is caught" \
  "[ \"\$(required_shape \"\$W_I\")\" = Implementation ] && ! mode_agrees \"\$W_I\""
check "mode  an Adoption unit mislabelled Implementation is caught" \
  "[ \"\$(required_shape \"\$W_A\")\" = Adoption ] && ! mode_agrees \"\$W_A\""
# Discrimination: the detector must distinguish the three, not reject everything.
check "mode  required_shape discriminates all three, not blanket-rejects" \
  "[ \"\$(for f in '$MODE_D' '$MODE_I' '$MODE_A'; do required_shape \"\$f\"; done | sort -u | wc -l | tr -d ' ')\" = 3 ]"

# --- what each mode requires of the evidence ---------------------------------
check "mode  Discovery evidence resolves a question without implementing the target" \
  "mode_core | grep -qi 'resolves the named question' && mode_core | grep -qi 'not implement'"
check "mode  Implementation evidence covers failing case, result and regression" \
  "mode_core | grep -qi 'failing case' && mode_core | grep -qi 'regression'"
check "mode  Implementation does not demand ceremonial tests where none apply" \
  "mode_core | grep -qi 'say so' || mode_core | grep -qi 'no meaningful regression'"
for term in 'reliability' 'burden' 'failure conditions' 'usefulness'; do
  check "mode  Adoption evidence covers $term" "mode_core | grep -qi '$term'"
done
check "mode  Adoption ends in an explicit lifecycle decision" \
  "mode_core | grep -qi 'adopt, revise, continue the trial or stop'"

# --- mode never attaches to Direct Work or a specialist flow -----------------
check "mode  Direct Work and specialist-owned work gain no mode record" \
  "mode_core | grep -qi 'Direct Work' && mode_core | grep -qi 'specialist'"

rm -f "$T_MISSING" "$T_TWO" "$T_UNKNOWN" "$W_D" "$W_I" "$W_A"

# --- proportionality: the record scales, the premise check does not ---------
# Plan § 4.5 / proof case P-3a. The old rule was universal — "the record appears
# even when nothing is wrong" — so a documentation unit with no load-bearing
# premise had to invent claims to fill the format. The opposite case is what the
# harness lacked, and it is the case that fails if the rule stays universal.
#
# Read these as a pair. NOPREM_F is the unit that legitimately writes no record;
# TRUE_F is the unit that must still write one line per claim. A change that made
# either one alone pass has not implemented proportionality — it has moved the
# universal rule to the other end.
NOPREM_F="logs/work-loop/fixture-noprem-prose.md"
CMD_F=".claude/commands/work-loop-v2.md"
SKILL_F=".agents/skills/work-loop-v2/SKILL.md"
UNITFR_F=".agents/skills/work-loop-v2/references/unit-framing.md"
ROUTADM_F=".agents/skills/work-loop-v2/references/routing-and-admission.md"

check "prop  fixture present: $NOPREM_F" "[ -f '$NOPREM_F' ]"
# Scoped to the record itself. A whole-file grep would pass on the fixture's own
# description of what it is, which is prose about the rule rather than the rule's
# output — the same fixture-literal mistake the Continue block was corrected for.
latest_of() { awk '/^## Latest result/{f=1;next} /^## /{f=0} f' "$1"; }
check "prop  the no-premise prose unit wrote no Inspected block" \
  "! latest_of '$NOPREM_F' | grep -qi 'inspected'"
check "prop  it says instead that there was no load-bearing premise to check" \
  "latest_of '$NOPREM_F' | grep -qi 'no load-bearing premise'"
check "prop  it still returns a real result and fail-capable evidence" \
  "grep -q '^Result:' '$NOPREM_F' && grep -q '^Evidence:' '$NOPREM_F'"
# The other half of the pair. Two claims are stated in that fixture's brief and two
# lines must answer them — proportionality is not permission to stop recording.
check "prop  a claims-bearing unit still writes one line for every claim" \
  "[ \"\$(grep -c '^- Claim (' '$TRUE_F')\" -ge 2 ]"
# The over-correction P-3a exists to catch: swapping the record for a new thing to
# fill in every run. The state file's active headings are core § 4's, and no tier,
# proportionality statement or justification label may appear beside them.
check "prop  nothing new became mandatory on every run" \
  "! grep -qiE '^(Proportionality|Tier|Record tier|Justification|Ceremony)[[:space:]]*:' '$NOPREM_F'"

# The command owns this behaviour (plan § 3). These read the contract, not the fixture.
check "prop  the command names the two cases where the record is legitimately absent" \
  "grep -qi 'no load-bearing premise' '$CMD_F' && grep -qi 'Direct Work' '$CMD_F'"
check "prop  the command keeps the per-claim rule where claims exist" \
  "grep -qi 'Every claim gets a line' '$CMD_F'"
check "prop  the command states the deciding question, not a size test" \
  "grep -qi 'would being wrong about a premise here change the work' '$CMD_F'"
check "prop  the command forbids a replacement artifact" \
  "grep -qiE 'no proportionality statement|nothing replaces the absent record' '$CMD_F'"
# Prose evidence (plan § 4.5) and its over-correction guard: an executable artifact
# still owes a failing case, so the relief cannot be read as a general exemption.
check "prop  prose and documentation are named as the ordinary no-regression case" \
  "grep -qiE 'prose, documentation or instruction-file change is the ordinary' '$CMD_F'"
check "prop  executable artifacts still owe a failing case" \
  "grep -qiE 'the failing case is still required' '$CMD_F'"
# The core § 3 pointer, bidirectional: present as a pointer, absent as a copy.
check "prop  the command points at core § 3's judgment" \
  "grep -q 'good enough, proceed' '$CMD_F'"
check "prop  the command does not restate core § 3's four statements" \
  "! grep -qiE '85|minimum necessary work|scaled to consequence|perfection pass' '$CMD_F'"

# The skill owns the division (plan § 4.4). Reproduction is permitted but conditional;
# an unconditional 'never reproduce' rule would fail P-2's inconsistent-evidence control.
check "prop  the skill assigns the checks to Claude and the assessment to Codex" \
  "grep -qiE 'Claude runs the checks and reports the evidence' '$SKILL_F'"
check "prop  the skill names re-running a reported check as duplication, not diligence" \
  "grep -qi 'not diligence' '$SKILL_F'"
check "prop  the skill keeps reproduction conditional and countable" \
  "[ \"\$(grep -c '^[0-9]\. \*\*' '$SKILL_F')\" -ge 4 ] && grep -qi 'say which one applies' '$SKILL_F'"
check "prop  the skill does not restate core § 3's four statements" \
  "! grep -qiE '85–90|minimum necessary work|scaled to consequence|perfection pass' '$SKILL_F'"

# --- CE-9 continuation integrity: the two carry duties (eval-v0-3-partial-fixes) --
# The first valid EV-3/CE-9 paired trial scored PARTIAL: the source-opened run
# recovered SD-3 ordering, the live blocker and the correct next unit, but its brief
# omitted the approved project objective and collapsed the authoritative position to
# a phase label. Both omissions were permitted by the live text, which required the
# nine determinations to be *established* and returned only one compressed operator
# line. These assertions bind the corrected contract: the carry duty exists, it names
# the position facts that must survive, and it did not grow into a stage the operator
# reads. Read them as a set — the first four alone would license a new orientation
# ceremony, and the last three alone would license dropping the duty again.
check "ce9   the skill states that establishing the determinations is not carrying them" \
  "grep -qi 'Establishing the nine is not carrying them' '$ROUTADM_F'"
check "ce9   the approved outcome and position must reach the brief, not only be established" \
  "grep -qi 'must also reach the brief itself' '$ROUTADM_F'"
check "ce9   the position keeps its source-supported precision" \
  "grep -qi 'the last completed unit and any open unit' '$ROUTADM_F'"
check "ce9   collapsing the position to a phase label is named as the failure" \
  "grep -qi 'never collapsed to a phase label' '$ROUTADM_F'"
# The fresh-thread path points at the one rule instead of carrying a second copy.
check "ce9   the fresh-thread recovery binds to the orientation rule" \
  "grep -qi 'Re-establishing them is internal' '$UNITFR_F'"
check "ce9   the carry duty is stated once, not duplicated" \
  "[ \"\$(cat '$SKILL_F' '$ROUTADM_F' '$UNITFR_F' '$COURIER_F' '$CORERES_F' | grep -ci 'Establishing the nine is not carrying them')\" = '1' ]"
# Over-correction guards. Requirement 3 of the brief: the operator-facing line stays
# concise and the brief stays the single hand-off artifact. A change that satisfied
# the four above by adding a checklist or a second document fails here.
check "ce9   the one-line operator shape is unchanged" \
  "grep -q 'Current position → governing workflow and phase → what is ready → what is blocked → recommended next unit → why it matters.' '$ROUTADM_F'"
check "ce9   orientation still writes nothing and adds no stage" \
  "grep -qi 'Orientation writes nothing' '$ROUTADM_F' && grep -qi 'it is not a stage, a gate or a checklist the operator sees' '$ROUTADM_F'"

# === pack: unit packaging and hop termination (2026-08-14 incident) =========
# Answers the recurrence of the 2026-08-11 sizing failure: a 902s timeout on a
# helper-plus-first-consumer unit, and a 593s hop that ended on a progress note.
# These are TEXT-PROPERTY checks: they prove the rule is present and worded as
# intended, and they fail if it is silently reworded or dropped. They do NOT
# prove Claude obeys it at runtime — only a dispatched hop evidences that.

# The two split triggers the old five-trigger list did not catch.
check "pack  the shared-component-plus-first-consumer split trigger exists" \
  "grep -qi 'builds a shared component' '$UNITFR_F' && grep -qi 'integrates its first consumer' '$UNITFR_F'"
check "pack  the integrate-plus-full-regression split trigger exists" \
  "grep -qi 'runs the full regression matrix for that integration' '$UNITFR_F'"

# Front-loaded evidence: the 593s failure. The primary edit must not wait on a broad baseline.
check "pack  the primary edit begins after one targeted failing case" \
  "grep -qi 'primary edit begins after one targeted failing case, not after a broad baseline' '$UNITFR_F'"
check "pack  accepted evidence is cited, not re-derived before editing" \
  "grep -qi 'do not ask Claude to re-derive it before editing' '$UNITFR_F'"

# The packaging lines — producer side.
for pack_line in 'Dominant deliverable:' 'Evidence required in this hop:' \
                 'Evidence explicitly deferred:' 'Primary edit begins after:'; do
  check "pack  the skill writes the packaging line \"$pack_line\"" \
    "grep -qF '$pack_line' '$UNITFR_F'"
done
check "pack  Dominant deliverable admits exactly one entry" \
  "grep -qi 'Dominant deliverable\` admits exactly one entry' '$UNITFR_F'"

# Mode-awareness. The fourth line is Implementation-shaped: core § 3 gives Discovery
# and Adoption no primary edit, so requiring it on every mode would make every
# Discovery and Adoption brief a false premise and bounce it forever.
check "pack  the skill scopes the fourth line to Implementation only" \
  "grep -qi 'the fourth belongs to Implementation alone' '$UNITFR_F'"
check "pack  the skill states three lines for Discovery and Adoption" \
  "grep -qi 'Write three lines in Discovery or Adoption mode, four in Implementation mode' '$UNITFR_F'"
check "pack  the skill keeps the first three mode-neutral and still packaging-bearing" \
  "grep -qi 'A Discovery unit can be overpacked exactly as an Implementation unit can' '$UNITFR_F'"
check "pack  the command scopes the fourth line to Implementation only" \
  "grep -qi 'One more in \*\*Implementation\*\* mode only' '$CMD_F'"
check "pack  the command treats the fourth line's absence off-Implementation as correct" \
  "grep -qi 'its absence is correct, not missing' '$CMD_F'"
check "pack  the fourth line in Discovery or Adoption mode is a false premise" \
  "grep -qi 'appears on a unit in Discovery or Adoption mode' '$CMD_F'"

# The packaging lines — consumer side. This is the half that makes them
# enforceable rather than optional; without it the contract decays silently.
for pack_line in 'Dominant deliverable:' 'Evidence required in this hop:' \
                 'Evidence explicitly deferred:' 'Primary edit begins after:'; do
  check "pack  the command checks the packaging line \"$pack_line\"" \
    "grep -qF '$pack_line' '$CMD_F'"
done
check "pack  a missing packaging line is a false premise, scoped to the mode" \
  "grep -qi 'A line its mode requires is missing or empty' '$CMD_F'"
check "pack  two dominant deliverables is a false premise" \
  "grep -qi 'names more than one deliverable' '$CMD_F'"
check "pack  Claude hands the brief back rather than filling the lines in" \
  "grep -qi 'do not fill the lines in yourself' '$CMD_F'"

# Required evidence may not be downgraded to a deferral when the clock runs out.
check "pack  required evidence cannot be deferred by Claude" \
  "grep -qi 'Evidence the brief requires cannot be deferred by you' '$CMD_F'"
check "pack  an unfinishable required check is a blocker" \
  "grep -qi 'will not finish inside the hop, that is a \*\*blocker\*\*' '$CMD_F'"
check "pack  only pre-declared deferred evidence stays deferred" \
  "grep -qi 'Only what the brief already lists under \`Evidence explicitly deferred' '$CMD_F'"
check "pack  the focused case does not discharge required evidence" \
  "grep -qi 'It does not discharge the required evidence' '$CMD_F'"

# Hop termination: the 593s hop ended on "waiting for the baseline run".
check "pack  the hop-termination contract exists" \
  "grep -q '## Ending the hop' '$CMD_F'"
check "pack  a progress note is named as producing no outcome" \
  "grep -qi 'a hop that announces what it is waiting for has produced none of these' '$CMD_F'"
check "pack  background commands are awaited or terminated in the same hop" \
  "grep -qi 'awaited to completion or terminated within this same hop' '$CMD_F'"

# Over-correction guards. The contradiction a review caught: a refusal MUST leave
# the file untouched, so the written-state rule may not demand a write from it.
check "pack  refusal and the written outcome are separated, not collapsed" \
  "grep -qi 'passes the refusal gates, that outcome is written into the state file' '$CMD_F'"
# The invariant is no WRITE, not no read: Step 1 and Step 1.5 must read the file to
# establish identity and ownership before refusing on them.
check "pack  the refusal invariant is no write, not no read" \
  "grep -qi 'the invariant is no state-file \*\*write\*\*, not no read' '$CMD_F'"
# The outcome set is stated generically. An exhaustive-looking list is what omitted
# closing, correction and de-escalation the first time.
check "pack  the outcome set is generic, not an exhaustive list" \
  "grep -qi 'deliberately not an exhaustive list' '$CMD_F'"
check "pack  closing, correction and de-escalation are named as writing steps" \
  "grep -qi 'Correction rounds writes the corrected result' '$CMD_F' && grep -qi 'De-escalating and Closing the task each write the closing record' '$CMD_F'"
check "pack  Direct Work is not described as changing nothing" \
  "grep -qi 'says nothing about whether the repository changed' '$CMD_F'"
# No new state field: core § 4's five-field ceiling is the thing most at risk here.
check "pack  the packaging lines add no state field" \
  "grep -qi \"five-field ceiling is unchanged and no new field, artifact or stage is created\" '$UNITFR_F'"
check "pack  core § 4 still lists exactly five active content fields" \
  "[ \"\$(grep -c '^| \`## ' '$CORE_F')\" = '5' ]"
# The timeout remains refused as a sizing remedy — the fix must not reopen it.
check "pack  a longer timeout is still refused as the remedy" \
  "grep -qi 'A longer timeout is not the remedy for an oversized unit' '$UNITFR_F'"

# --- readiness race: a claimed hand-off is reconciled before absence is claimed --
# The incident: Codex read `turn: claude` once, concluded Claude had not completed the
# hand-off, and the hand-off commit became visible immediately afterwards. Commit
# 4800329c defined the shorthand but added no recheck, so one stale read still
# licensed a claim about Claude's activity.
CORE_F="plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md"
SKILL_F=".agents/skills/work-loop-v2/SKILL.md"

# Core owns the semantic rule: one bounded reconciliation before a mismatch is reported.
check "race  core requires one reconciliation before reporting a mismatch" \
  "command grep -qi 'reconciles once' '$CORE_F'"
check "race  the recheck names the latest commit affecting that exact task file" \
  "command grep -qi 'latest commit affecting that exact task file' '$CORE_F'"
check "race  the recheck rereads the file once immediately" \
  "command grep -qi 'rereads the file once immediately' '$CORE_F'"
# Three assertions below match a PHRASE that legitimately wraps across lines in the
# prose. Normalize whitespace first: reflowing the source to suit a line-based grep
# would be shaping the artifact to the test rather than testing the artifact.
flat(){ tr -s '[:space:]' ' ' < "$1"; }

# Bounded: the fix must not become polling, waiting, or a retry loop.
check "race  the reconciliation is bounded, not polling or waiting or retrying" \
  "flat '$CORE_F' | command grep -qi 'not polling, not waiting, not retrying the other actor'"
# The response is constrained to the discrepancy, not to a claim about the other actor.
check "race  a persistent conflict reports the discrepancy and the inability to assess" \
  "command grep -qi 'report the discrepancy and the resulting inability to assess' '$CORE_F'"
check "race  no actor may claim the other did not complete without process evidence" \
  "flat '$CORE_F' | command grep -qi 'unless specific process evidence establishes that separate claim'"

# Codex side owns the concrete procedure, and defers to core rather than competing with it.
check "race  the Codex skill reconciles before reporting" \
  "command grep -qi 'reconcile once before reporting anything' '$SKILL_F'"
# Deference must key on text unique to THIS rule: an earlier dispatcher paragraph
# already carries a generic "exactly as core § 4 requires", which would pass blind.
check "race  the Codex skill defers to core for the rule" \
  "command grep -qi 'owns the rule; this is the procedure' '$SKILL_F'"
check "race  the evidence-limited response is stated verbatim" \
  "flat '$SKILL_F' | command grep -qi 'I cannot assess it until those sources converge'"
check "race  visibility evidence is distinguished from evidence about Claude" \
  "command grep -qi 'evidence about visibility, not about Claude' '$SKILL_F'"

# Preserved boundaries: this unit may not weaken what already held.
check "race  shorthand still never overrides the state file" \
  "command grep -qi 'never overrides the state file' '$SKILL_F'"
check "race  several matching tasks still require disambiguation" \
  "command grep -qi 'brief names and task ids and ask which one' '$SKILL_F'"
check "race  no new frontmatter key was introduced" \
  "[ \"\$(command grep -c '^turn: ' '$TRUE_F')\" = '1' ]"

# === split: progressive disclosure of the Codex Work Loop skill ==============
# Unit 1 of work-loop-v2-post-compaction-recovery-repair. The always-loaded skill
# was 602 lines / 12,669 words, over this repository's <500-line and <5,000-word
# guidance, and every Work Loop turn paid for all of it. The conditional material
# moved into four direct references with ONE semantic owner each.
#
# Every check below is fail-capable against a stated wrong state, and each names
# which one it discriminates:
#   * the numeric and direct-link checks fail on the ACTUAL pre-split file
#     (602 lines, no reference links, headings still in the main skill);
#   * the one-owner check fails on the pre-split file AND on a duplicate;
#   * the chain and table-of-contents checks fail on an INTENTIONALLY WRONG
#     FIXTURE built below, because the repaired tree cannot exhibit those states.
# A check that only greps for text this unit introduced would pass on any file
# that quoted the brief, which is the failure mode § 8 of the plan names.

REF_DIR=".agents/skills/work-loop-v2/references"
CORERES_F="$REF_DIR/core-resolution.md"
COURIER_F="$REF_DIR/courier-operation.md"
ROUTADM_F="$REF_DIR/routing-and-admission.md"
UNITFR_F="$REF_DIR/unit-framing.md"
RIDX_REL="references/routing-index.md"

# --- the two architecture limits on the always-loaded body -------------------
# Discriminates the actual pre-split state: 602 and 12669.
skill_lines() { command wc -l < "$SKILL_F" | tr -d ' '; }
skill_words() { command wc -w < "$SKILL_F" | tr -d ' '; }
check "split main skill body is below 500 lines" \
  "[ \"\$(skill_lines)\" -lt 500 ]"
check "split main skill body is below 5,000 words" \
  "[ \"\$(skill_words)\" -lt 5000 ]"

# --- the four references exist and are directly linked, each with a condition -
# Discriminates the pre-split state twice over: the files did not exist, and the
# main skill linked none of them.
for ref in core-resolution courier-operation routing-and-admission unit-framing; do
  check "split reference exists: $ref.md" "[ -f '$REF_DIR/$ref.md' ]"
  check "split main skill directly links $ref.md" \
    "command grep -qF '(references/$ref.md)' '$SKILL_F'"
done
# Routing needs BOTH routing files linked directly, so neither is reached through
# the other (plan § 3.1).
check "split main skill also directly links the routing index" \
  "command grep -qF '($RIDX_REL)' '$SKILL_F'"
# A link with no stated read condition is a bare pointer, not progressive
# disclosure: the reader cannot tell when to pay for it.
route_row() { command grep -F "(references/$1.md)" "$SKILL_F"; }
for ref in core-resolution courier-operation routing-and-admission unit-framing; do
  check "split the main skill states a read condition for $ref.md" \
    "route_row '$ref' | command grep -qiE 'read (it )?(when|only when|during)'"
done

# --- one semantic owner per moved section -----------------------------------
# Each moved heading must live in its designated reference AND be gone from the
# main skill. Both halves are load-bearing: the first fails if the move never
# happened, the second fails if the content was copied rather than moved.
owner_check() {  # $1 = heading regex, $2 = owning reference
  command grep -qE "$1" "$2" && ! command grep -qE "$1" "$SKILL_F"
}
check "split one owner: the executable-core resolver" \
  "owner_check '^### Resolve the executable core' '$CORERES_F'"
check "split one owner: courier mode" \
  "owner_check '^## Courier mode' '$COURIER_F'"
check "split one owner: unattended runs" \
  "owner_check '^### Unattended runs' '$COURIER_F'"
check "split one owner: routing a request" \
  "owner_check '^## Routing a request' '$ROUTADM_F'"
check "split one owner: classifying the mode" \
  "owner_check '^### Classifying the mode' '$ROUTADM_F'"
check "split one owner: what an intake result contains" \
  "owner_check '^### What an intake result contains' '$ROUTADM_F'"
check "split one owner: admission" \
  "owner_check '^## Admission' '$ROUTADM_F'"
check "split one owner: opening a unit and writing the brief" \
  "owner_check '^## Opening a unit and writing the brief' '$UNITFR_F'"
check "split one owner: size the unit against the clock" \
  "owner_check '^### Size the unit against the clock' '$UNITFR_F'"
check "split one owner: the capability envelope" \
  "owner_check '^### The capability envelope' '$UNITFR_F'"
# The resolver block is the one moved section with a machine-readable boundary,
# so its marker pair moves whole rather than being left behind or duplicated.
check "split the resolver marker pair moved whole to its reference" \
  "[ \"\$(command grep -c 'work-loop-v2-core-resolution:' '$CORERES_F')\" = '2' ] && \
   ! command grep -q 'work-loop-v2-core-resolution:' '$SKILL_F'"

# --- no reference-to-reference loading chain --------------------------------
# A reference that links another reference makes the second reachable only by
# loading the first, which is the chain plan § 3.1 forbids. The repaired tree
# cannot exhibit this, so the check is proved against a wrong fixture.
#
# TWO SHAPES, ONE RULE — the second added by the 2026-08-18 correction. A
# Markdown link is a loading affordance by construction. A backticked sibling
# path is one whenever the reader is told to go there, and that is the shape the
# link-only guard could not see: `routing-and-admission.md` carried three of them
# — "Read the routing index — `references/routing-index.md`", "run the resolver
# that `references/core-resolution.md` owns", "The route inventories are one
# file: `references/routing-index.md` … Read that file complete" — and the
# independent review found them while this check stayed green.
#
# A bare ownership citation is NOT a route and is deliberately not flagged:
# naming which owner holds a section, as "(§ Size the unit against the clock, in
# `references/unit-framing.md`)" does, tells the reader where something lives
# without sending them there through this file. Flagging it would force every
# cross-citation to be laundered into vagueness, which costs precision and buys
# no protection — the chain is created by the instruction to load, not by the
# path appearing in prose.
chain_hits() {  # $1 = file; prints each sibling-reference LOADING affordance
  command grep -oE '\(references/[A-Za-z0-9._-]+\)' "$1" 2>/dev/null
  command sed -e 's/, in `references\/[A-Za-z0-9._-]*`//g' "$1" 2>/dev/null \
    | command grep -oE '`references/[A-Za-z0-9._-]+`'
}
for ref in "$CORERES_F" "$COURIER_F" "$ROUTADM_F" "$UNITFR_F"; do
  check "split no loading chain out of $(basename "$ref")" \
    "[ -z \"\$(chain_hits '$ref')\" ]"
done
SPLIT_TMP=$(mktemp -d 2>/dev/null) || SPLIT_TMP=""
if [ -n "$SPLIT_TMP" ]; then
  # Wrong fixture: a reference that routes through another reference.
  printf '# x\n\nSee [Routing index](references/routing-index.md) first.\n' \
    > "$SPLIT_TMP/chained.md"
  check "split NEGATIVE: the chain check rejects a reference that links a reference" \
    "[ -n \"\$(chain_hits '$SPLIT_TMP/chained.md')\" ]"
  # The shape the link-only guard passed. This is the review's finding written
  # as a fixture: the same instruction, spelled with backticks instead of a link.
  printf '# x\n\nRead the routing index — `references/routing-index.md` — complete first.\n' \
    > "$SPLIT_TMP/chained-backtick.md"
  check "split NEGATIVE: the chain check rejects a BACKTICKED sibling loading instruction" \
    "[ -n \"\$(chain_hits '$SPLIT_TMP/chained-backtick.md')\" ]"
  # And the control that keeps the guard from being merely broad: a citation
  # naming where a section lives is not a route, and must stay green. Without
  # this, a guard that flagged every occurrence of the string would look equally
  # good here and would be demanding edits it cannot justify.
  printf '# x\n\nOne dominant deliverable (§ Size the unit against the clock, in `references/unit-framing.md`).\n' \
    > "$SPLIT_TMP/cited.md"
  check "split CONTROL: a bare ownership citation is not a loading chain" \
    "[ -z \"\$(chain_hits '$SPLIT_TMP/cited.md')\" ]"
fi

# --- a long reference carries a table of contents ---------------------------
# Over 100 lines, a reader landing mid-file cannot see what else is there.
has_toc() {  # $1 = file; passes when short, or when a contents list is present
  [ "$(command wc -l < "$1" | tr -d ' ')" -le 100 ] && return 0
  command grep -qiE '^\*\*(Contents|In this reference)' "$1"
}
for ref in "$CORERES_F" "$COURIER_F" "$ROUTADM_F" "$UNITFR_F"; do
  check "split table of contents present if over 100 lines: $(basename "$ref")" \
    "has_toc '$ref'"
done
if [ -n "$SPLIT_TMP" ]; then
  # Wrong fixture: a long reference with its contents list stripped.
  { command sed '/^\*\*Contents/,+1d' "$UNITFR_F"; } > "$SPLIT_TMP/no-toc.md" 2>/dev/null
  check "split NEGATIVE: the contents check rejects a long reference with none" \
    "[ \"\$(command wc -l < '$SPLIT_TMP/no-toc.md' | tr -d ' ')\" -gt 100 ] && ! has_toc '$SPLIT_TMP/no-toc.md'"
  rm -rf "$SPLIT_TMP"
fi

# --- the split moved text; it did not shorten rules to hit a number ----------
# The four references plus the main skill must still carry at least the word
# count the pre-split single file did. A "fix" that trimmed semantics to satisfy
# the numeric guards above goes red here, which is the over-correction guard.
PRESPLIT_WORDS=12669
total_words() {
  command cat "$SKILL_F" "$CORERES_F" "$COURIER_F" "$ROUTADM_F" "$UNITFR_F" 2>/dev/null \
    | command wc -w | tr -d ' '
}
check "split no semantic loss: the moved text is preserved, not trimmed" \
  "[ \"\$(total_words)\" -ge \"$PRESPLIT_WORDS\" ]"

# === rollover: a hand-back replaces the preceding result, it does not append ==
# Unit 3 of work-loop-v2-post-compaction-recovery-repair, plan §§ 3.4 and 4 Unit 3.
# The incident: a completed unit left the preceding accepted result standing beside
# the new one, so `## Latest result` became the running log core § 4 forbids.
#
# The validator cannot catch this. Proved below: the incident-shaped mutant is a
# fully legal record — it classifies ACTIVE_CODEX, exactly like the clean one. The
# frontmatter, the heading set and the field count are all correct; only the BODY
# of one field is wrong, which is not a lifecycle question and never becomes one.
# That is why the protection has to be behavioural, and why it lives here.
#
# Every control below is disposable and built in a temp dir. Plan § 4 Unit 3
# forbids retaining fixture state under logs/work-loop/, so no state file is added
# there — which also keeps this check from being a task record that ages.

ROLL_OLD='DISTINCTIVE-OLD-RESULT'   # the preceding unit's accepted-result marker
ROLL_NEW='DISTINCTIVE-NEW-RESULT'   # the marker the current unit's result must carry

# The assertion under test. Scoped to the `## Latest result` BODY, because a
# whole-file grep is invalid here in both directions: the brief, objective or plan
# text may legitimately name either marker, so a whole-file hit for the new marker
# proves nothing about the result, and the NEGATIVE case below is where that shows.
rollover_ok() {  # $1 = state file, $2 = preceding marker, $3 = new marker
  latest_of "$1" | command grep -qF "$3" || return 1   # new result is IN the current result
  latest_of "$1" | command grep -qF "$2" && return 1   # preceding result is not kept beside it
  command grep -qF "$2" "$1" && return 1               # nor parked anywhere else in the record
  [ "$(command grep -c '^## Latest result' "$1")" = 1 ] || return 1
  # No historical result block under any other name: the active headings stay
  # inside core § 4's five plus the brief.
  ! command grep -E '^## ' "$1" | command grep -qvE \
    '^## (Objective and scope|Lane and unit|Brief|Latest result|Blocker|Next action)$'
}

ROLL_TMP=$(mktemp -d 2>/dev/null) || ROLL_TMP=""
if [ -n "$ROLL_TMP" ]; then
  roll_state() {  # $1 = out file, $2 = latest-result body, $3 = extra block or empty
    { printf -- '---\ntask: rollover-control\nstatus: active\nturn: codex\n---\n\n'
      printf '## Objective and scope\n\nProve rollover.\n\n'
      printf '## Lane and unit\n\nStandard. Implementation mode. Unit 2 — rollover.\n\n'
      printf '## Brief\n\nWhy: this unit must supersede the preceding accepted result.\n\n'
      printf '## Latest result\n\n%s\n\n' "$2"
      [ -n "$3" ] && printf '%s\n\n' "$3"
      printf '## Blocker\n\nNone.\n\n## Next action\n\nCodex: assess.\n'
    } > "$1"
  }
  # (1) clean replacement — the correct end state.
  roll_state "$ROLL_TMP/clean.md" "Result: unit 2 done. $ROLL_NEW"$'\n'"Evidence: focused check." ""
  # (2) the incident shape — both results standing in the same field.
  roll_state "$ROLL_TMP/append.md" "$ROLL_OLD"$'\n\n'"Result: unit 2 done. $ROLL_NEW"$'\n'"Evidence: focused check." ""
  # (3) the same history, moved to a block of its own rather than deleted.
  roll_state "$ROLL_TMP/parked.md" "Result: unit 2 done. $ROLL_NEW"$'\n'"Evidence: focused check." \
    "## Previous results"$'\n\n'"$ROLL_OLD"
  # (4) the result was never rewritten, and only the OBJECTIVE names the new marker.
  #     A whole-file grep passes on this file. That is the mistake being excluded.
  { printf -- '---\ntask: rollover-control\nstatus: active\nturn: codex\n---\n\n'
    printf '## Objective and scope\n\nProve rollover; the result must contain %s.\n\n' "$ROLL_NEW"
    printf '## Lane and unit\n\nStandard. Implementation mode. Unit 2 — rollover.\n\n'
    printf '## Brief\n\nWhy: supersede the preceding accepted result.\n\n'
    printf '## Latest result\n\n%s\n\n' "$ROLL_OLD"
    printf '## Blocker\n\nNone.\n\n## Next action\n\nCodex: assess.\n'
  } > "$ROLL_TMP/stale.md"

  check "roll  a replaced result passes the rollover assertion" \
    "rollover_ok '$ROLL_TMP/clean.md' '$ROLL_OLD' '$ROLL_NEW'"
  check "roll  NEGATIVE: the incident shape — both results in one field — is rejected" \
    "! rollover_ok '$ROLL_TMP/append.md' '$ROLL_OLD' '$ROLL_NEW'"
  check "roll  NEGATIVE: history parked in a block of its own is rejected" \
    "! rollover_ok '$ROLL_TMP/parked.md' '$ROLL_OLD' '$ROLL_NEW'"
  check "roll  NEGATIVE: an unwritten result is rejected though the file names the marker" \
    "! rollover_ok '$ROLL_TMP/stale.md' '$ROLL_OLD' '$ROLL_NEW'"
  # The scoping itself, stated as the discriminator rather than left implicit: on
  # (4) a whole-file grep and the scoped read disagree, and the scoped read is right.
  check "roll  the section-scoped read is what discriminates, not a whole-file grep" \
    "command grep -qF '$ROLL_NEW' '$ROLL_TMP/stale.md' && \
     ! latest_of '$ROLL_TMP/stale.md' | command grep -qF '$ROLL_NEW'"
  # Why behaviour, not lifecycle: the validator accepts the incident shape.
  roll_class() {  # $1 = control file; classifies it as a real record, then removes it
    command cp "$1" logs/work-loop/rollover-control.md
    command bash logs/scripts/work-loop-state.sh validate \
      --checkout "$ROOT" --task rollover-control 2>/dev/null
    command rm -f logs/work-loop/rollover-control.md
  }
  check "roll  the validator cannot see the incident: it classifies exactly as the clean one" \
    "[ \"\$(roll_class '$ROLL_TMP/append.md')\" = ACTIVE_CODEX ] && \
     [ \"\$(roll_class '$ROLL_TMP/clean.md')\" = ACTIVE_CODEX ]"
  check "roll  no control was left behind under logs/work-loop/" \
    "[ ! -e logs/work-loop/rollover-control.md ]"
  rm -rf "$ROLL_TMP"
fi

# The command owns the behaviour; this reads the contract at Step 5, not the fixture.
# Scoped to Step 5: core § 4's identical prose appears elsewhere in the tree, and an
# unscoped grep would stay green if the instruction were deleted from the command.
step5_of() { awk '/^## Step 5 —/{f=1;next} /^## /{f=0} f' "$CMD_F"; }
check "roll  the command instructs Step 5 to replace the previous result, not append" \
  "step5_of | command grep -qi 'replace the previous result rather than appending'"
check "roll  Step 5 grounds that in core § 4 current-truth rather than restating it" \
  "step5_of | command grep -qi 'current truth, not a diary'"

# --- v1 isolation: logs/loop/ must gain nothing (slice plan 1.1) ------------
check "v1    no Slice 1, 2 or 3 artifact leaked into logs/loop/" \
  "! ls logs/loop/ 2>/dev/null | grep -qE 'fixture-slice1|fixture-slice2|fixture-slice3|fixture-target|$CODEX_TASK'"
check "v1    logs/loop/ has no uncommitted change from this work" \
  "[ -z \"\$(git status --porcelain logs/loop/)\" ]"

echo
echo "passed: $pass   failed: $fail"
[ "$fail" -eq 0 ] || exit 1
