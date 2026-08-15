---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Discovery mode. Unit 35 final tightly bounded fix — repair the four technical defects found by the fresh review of the corrected exact T7 candidate.

Named reason for the loop: T7 changes a permission surface, machine-wide configuration outside the repository, and carrier runtime behaviour. The correction round was used; the required fresh review found four bounded technical defects, so Codex selected the executable core's one-final-fix menu option rather than accepting unsafe limitations, reverting a viable mechanism, or reframing the tracer.

## Brief
Unit 34 is accepted: commit `323332d6788487f989a5d45d0ddf303aeed36c55` re-froze the plan status-only and made T6 live. T7 is now the nearest unmet tracer, but the governing plan forbids implementation until an exact candidate has received one fresh risk-aware review. This unit prepares that candidate read-only so the review can happen next.

**Governing authority.** Use the re-frozen implementation plan's § 3.5 and T7 exactly as live at Unit 34. The operator has already authorized machine-wide placement under `~/.codex/rules/`, accepted symmetric direct-route refusal-request plus symmetric process observation as satisfying proposal §14 item 7 for this MVP, accepted shell-wrapper evasion as a limitation, and deferred full descendant containment. This unit does not reopen those decisions and does not implement them.

**Required outcome.** Inspect the current repository and local Codex rules surface, then return one self-contained **exact unapplied candidate** inside `## Latest result`. It must contain:

- the collision-safe exact path and complete proposed content for the dedicated machine-wide execpolicy rules file, together with the relevant prior-state identity;
- the exact unified diff proposed for the Codex branch of `scripts/axcion-harness-v0.2/carry-turn.sh`, leaving the Claude branch byte-identical;
- the exact unified diff proposed for `scripts/axcion-harness-v0.2/carry-turn.test.sh`;
- the precise requested approval-policy/argv shape, the fail-capable positive and negative checks, the known wrapper-evasion checks, and the evidence each check can and cannot establish;
- a rollback procedure tied to the observed prior state for both repository and machine-wide surfaces; and
- a short risk inventory covering machine-wide blast radius, normal-user interference, self-bypass/wrapper evasion, failure mode, observability, and rollback.

**Claims to verify before drafting.** (1) Resolve the physical `~/.codex/rules/` destination read-only, including whether it or the proposed dedicated file is a symlink, and identify any collision without exposing unrelated sensitive content. (2) Recheck the installed Codex CLI's execpolicy grammar and decision set using static `codex execpolicy check` only; do not run `codex exec` or launch any Claude/Codex actor. (3) Inspect the current Codex launch branch and test seams named by T7, recording their blob identities and the exact argv/test facts the candidate relies on. (4) Confirm the candidate touches no Claude branch, skill, command, core, dispatcher, proposal, plan, or state-contract surface. A false or unresolved premise is a valid hand-back; do not improvise past it.

**Evidence boundary.** Static direct matches may prove only that `prompt` rules match direct `claude` and `codex` commands. They do not prove runtime refusal, wrapper-proof prevention, or descendant containment. Keep the prompt-matched live disposition explicitly **unverified**; confirming it is not a precondition of T7. Preserve wrapper evasion and full descendant containment as accepted/deferred boundaries, not defects to solve in this candidate.

**Scope and stop conditions.** This is a discovery unit. Do not edit `~/.codex/rules/`, the carrier, its tests, or any repository target other than this state file; do not create a parallel candidate artifact. Stop if a collision-free dedicated rules file cannot be proposed, the installed grammar differs materially from the plan, rollback cannot preserve the observed prior state, the candidate needs a surface T7 excludes, or any actor launch would be required to complete the candidate.

**Capability subset.** Baseline only: read/search/inspect the named repository and rules surfaces, run local static non-actor checks, write the exact candidate into this state file, and make the local handoff commit through Claude. Nothing is selected from the pre-authorizable set, which is empty today, and no operator-reserved capability is exercised because no permission/configuration change is applied. This is an operator-carried interactive Claude turn, not an attended-carrier hop; report that honestly and make no carrier argv, `denials=`, `nested=`, sandbox, or network claim about this unit's own runtime.

**Completion.** Return the exact candidate and verification evidence in `## Latest result`, state that every implementation/configuration target remained unchanged, set `turn: codex`, commit only this state handback, and stop. Codex will then subject that exact candidate to the required fresh risk-aware review before any implementation brief exists.

## Latest result

Final tightly bounded fix, 2026-08-15. All four frozen defects were reproduced by inspection before anything was rewritten. The candidate below **replaces** the previous one; no competing candidate exists and no implementation target changed.

Reproduced (2026-08-15):

- Defect 1: **REPRODUCED.** The previous section (h) wrote its own `t7.rules` into `$TMPROOT` and asserted against that. It proved execpolicy works on *a* file, not that the reviewed machine-wide file is installed and intact — it would have passed with the real file absent, symlinked or corrupted.
- Defect 2: **REPRODUCED, demonstrated.** The pre-write guard used `[ -e "$TARGET" ]`. A dangling symlink fails `-e` (the test follows the link to a missing target), so the guard **passes** and the subsequent write follows the link to an attacker-or-accident-chosen path. Probed directly: `[ -e ]` MISSES a dangling symlink; `[ -L ]` catches it. `default.rules` was also never proven regular or non-symlink, only hashed.
- Defect 3: **REPRODUCED.** Five assertions compared whole `2>&1` output to an exact JSON literal. Merging stderr makes any warning line a failure with no explanation, and the shape cannot tell "no match" from "the probe failed". Confirmed: a malformed policy returns exit 1 with an `Error:` line, which under the old shape is indistinguishable from any other mismatch.
- Defect 4: **REPRODUCED.** The real repository tracks both files `100755`; my fixture committed them `100644` because `git cat-file -p >` creates a non-executable file. Both patches carried `index … 100644`, so applying them would have silently dropped the executable bit from two scripts.

---

### The corrected exact unapplied T7 candidate

#### 1. Machine-wide execpolicy rules file

**Path:** `/Users/patrik.lindeberg/.codex/rules/axcion-nested-actor.rules` — free.
**Prior state:** does not exist. Directory physical path `/Users/patrik.lindeberg/.codex/rules`, regular directory, not a symlink, no symlinks inside. `default.rules` sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`.
**Reviewed identity once written:** sha256 `b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303`, 381 bytes. This identity is now **bound into the test** (§ 3), so the file and the suite cannot drift apart.

```
# Axcion Work Loop v2 — T7 direct-route nested-actor request.
# REQUESTED policy, not containment. Execpolicy parses only `allow` and
# `prompt`; there is no `deny`. Wrapper and absolute-path routes are UNMATCHED
# and are an accepted limitation, not a defect this file solves.
prefix_rule(pattern=["claude"], decision="prompt")
prefix_rule(pattern=["codex"], decision="prompt")
```

**Implementation-time ordering** — the file is deliberately **not created by this discovery unit**, so the order is stated rather than performed:

1. Run the fail-closed pre-write guards (§ 4). Any refusal stops T7.
2. Write the file above; verify its sha256 equals the reviewed identity.
3. Apply the two patches (§ 2, § 3).
4. Run `carry-turn.test.sh`. The external leg is now mandatory and must pass.

Reversing steps 2 and 3 leaves a window in which the launcher requests a policy whose file does not exist — which the suite would correctly fail.

#### 2. Patch — `scripts/axcion-harness-v0.2/carry-turn.sh`

```diff
diff --git a/scripts/axcion-harness-v0.2/carry-turn.sh b/scripts/axcion-harness-v0.2/carry-turn.sh
index 45f52ab..982c3df 100755
--- a/scripts/axcion-harness-v0.2/carry-turn.sh
+++ b/scripts/axcion-harness-v0.2/carry-turn.sh
@@ -107,11 +107,23 @@
 # the rules are requested on every Claude launch. Enforcement belongs to the
 # child, and only attended operation makes that trustworthy.
 #
-# The Codex actor path carries NO equivalent. `codex exec` (0.147.0-alpha.6.5)
-# offers sandbox modes and config overrides, not a per-command deny list, so
-# there is no native already-used mechanism to request the same of a Codex hop.
-# This policy therefore covers the Claude child only, and saying otherwise would
-# be a claim this script cannot support.
+# The Codex actor path REQUESTS direct-route refusal by a different mechanism,
+# because `codex exec` (0.147.0-alpha.6.5) offers sandbox modes and config
+# overrides, not a per-command deny list. A dedicated machine-wide execpolicy
+# rules file marks a direct `claude` or `codex` command `prompt`, and this
+# launcher requests approval_policy=never.
+# Execpolicy parses only `allow` and `prompt` — there is no `deny` — so that
+# pairing is the only shape this mechanism offers.
+#
+# READ IT AS REQUESTED, exactly like the Claude rules above: not OS containment,
+# not a sandbox, not a process limit, and NOT proof that nesting is impossible.
+# Three things are UNVERIFIED here, and this script claims none of them:
+#   1. that the rules file is loaded on any given run
+#      (`--ignore-rules` is the documented opt-out);
+#   2. that the requested policy is effective;
+#   3. what a matched command's runtime disposition then is.
+# Wrapper and absolute-path routes (`bash -lc 'claude -p x'`, `env claude -p x`)
+# are UNMATCHED — an accepted limitation this surface records rather than solves.
 #
 # Exit codes. 0 is the only success, and the RESULT line says which success it is
 # — read that line, not the code alone.
@@ -855,9 +867,13 @@ launch_actor() { # actor, timeout -> exit status of the launch
       [ -x "$CODEX_BIN" ] || die 20 "codex binary not executable: $CODEX_BIN"
       local cv; cv="$("$CODEX_BIN" --version 2>&1 | head -1)"
       say "  launch: actor=codex timeout=${limit}s bin=$CODEX_BIN version=$cv"
-      say "  cmd: codex exec --sandbox workspace-write -C <checkout> --json <prompt>"
+      say "  nested-actor policy: requesting approval_policy=never on every Codex hop, beside a dedicated machine-wide execpolicy rules file that marks a direct claude or codex command 'prompt'."
+      say "  This is REQUESTED policy only. It is not containment and NOT proof that nesting is impossible, and this launcher does not observe whether it took effect."
+      say "  Unverified, and not claimed: that the rules file was loaded on this run, that the requested policy is effective, and the runtime disposition of a matched command. Wrapper and absolute-path routes are unmatched — an accepted limitation."
+      say "  cmd: codex exec --sandbox workspace-write -c approval_policy=never -C <checkout> --json <prompt>"
       run_bounded "$limit" "$out" \
-        "$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"
+        "$CODEX_BIN" exec --sandbox workspace-write -c approval_policy=never \
+        -C "$CHECKOUT" --json "$(codex_prompt)"
       return $?
       ;;
     claude)
```

#### 3. Patch — `scripts/axcion-harness-v0.2/carry-turn.test.sh`

```diff
diff --git a/scripts/axcion-harness-v0.2/carry-turn.test.sh b/scripts/axcion-harness-v0.2/carry-turn.test.sh
index 7e4af79..031b60e 100755
--- a/scripts/axcion-harness-v0.2/carry-turn.test.sh
+++ b/scripts/axcion-harness-v0.2/carry-turn.test.sh
@@ -297,6 +297,36 @@ section() { printf '\n%s\n' "$1"; }
 
 run_suite() {
 
+CODEX_DEFAULT_BIN="$(awk -F'"' '/^CODEX_BIN=/{print $2; exit}' "$SUT")"
+
+# Normalized execpolicy probe. Whole-output equality against raw JSON is brittle:
+# any warning line, or a probe that failed outright, changes the string without
+# saying why — and an empty result must never read as a clean no-match.
+#
+# Prints exactly one of:
+#   decision=<d> matches=<n>     a parsed result
+#   PROBE-FAILED:<reason>        non-zero exit, or output that is not a result
+# stderr is captured separately, never merged and never discarded.
+xp() { # rules-file, command tokens...
+  local rf="$1"; shift
+  local out rc err="$TMPROOT/xp.err" n d
+  : >"$err"
+  out="$("$CODEX_DEFAULT_BIN" execpolicy check --rules "$rf" "$@" 2>"$err")"; rc=$?
+  if [ "$rc" -ne 0 ]; then
+    printf 'PROBE-FAILED:exit=%s:%s\n' "$rc" "$(tr '\n' ' ' <"$err" | cut -c1-100)"
+    return
+  fi
+  case "$out" in
+    *'"matchedRules"'*) ;;
+    *) printf 'PROBE-FAILED:malformed:%s\n' "$(printf '%s' "$out" | tr '\n' ' ' | cut -c1-100)"
+       return ;;
+  esac
+  n="$(printf '%s' "$out" | grep -o '"prefixRuleMatch"' | wc -l | tr -d ' ')"
+  d="$(printf '%s' "$out" | grep -o '"decision":"[a-z]*"' | tail -1 | sed 's/.*:"//;s/"//')"
+  [ -n "$d" ] || d=none
+  printf 'decision=%s matches=%s\n' "$d" "$n"
+}
+
 section "1. Static checks"
   bash -n "$SUT" 2>/dev/null; assert_eq "launcher parses (bash -n)" "0" "$?"
   bash -n "$HERE/carry-turn.test.sh" 2>/dev/null; assert_eq "suite parses (bash -n)" "0" "$?"
@@ -438,7 +468,19 @@ section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
   assert_contains "help calls it requested permission rules" "REQUESTED PERMISSION RULES" "$o"
   assert_contains "help refuses the containment claim" "not OS" "$o"
   assert_contains "help refuses the impossibility claim" "NOT proof that nesting is" "$o"
-  assert_contains "help states the Codex path is not covered" "Codex actor path carries NO equivalent" "$o"
+  assert_contains "help says the Codex path requests refusal by another mechanism" \
+    "REQUESTS direct-route refusal by a different mechanism" "$o"
+  assert_contains "help states the only decision pair execpolicy parses" \
+    "parses only \`allow\` and \`prompt\`" "$o"
+  assert_contains "help names the documented rules-loading opt-out" \
+    "(\`--ignore-rules\` is the documented opt-out)" "$o"
+  assert_contains "help keeps the wrapper routes unmatched" \
+    "are UNMATCHED" "$o"
+  # The Codex paragraph must claim no more than the Claude one. These three
+  # needles are the exact overclaims the risk review froze.
+  assert_absent "help claims no route-blocking for the Codex path" "no route to approval" "$o"
+  assert_absent "help claims no prevention for the Codex path" "prevents nesting" "$o"
+  assert_absent "help claims no observed loading" "rules file was loaded" "$o"
 
   # (e) The run output an operator actually reads must say the same thing.
   mkfix nestedsay task-ap claude
@@ -451,9 +493,11 @@ section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
   assert_contains "  says operator rules append" "--claude-deny appends" "$o"
   assert_contains "  and does not sell it as containment" "not containment and not proof" "$o"
 
-  # (f) A Codex hop is unaffected. This unit changes the Claude launch path only,
-  # and a deny set leaking onto the Codex argv would be a claim the launcher
-  # cannot support.
+  # (f) A Codex hop requests refusal by its own mechanism. The deny-set absences
+  # below STAY: T7 adds an approval policy, not a --disallowedTools list, so a
+  # deny set on the Codex argv would still be a claim the launcher cannot
+  # support. What is new is the positive leg, and the paired negative in (g) is
+  # what makes it able to fail.
   mkfix nestedcdx task-aq codex
   printf 'nocommit:claude' >"$ACTION"
   run_sut --checkout "$REPO" --task task-aq --codex-bin "$FAKEBIN" --log-dir "$LOGD"
@@ -461,6 +505,92 @@ section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
   assert_absent "codex argv carries no deny set" "--disallowedTools" "$(cat "$ARGVLOG")"
   assert_absent "codex argv carries no claude colon rule" "Bash(claude:*)" "$(cat "$ARGVLOG")"
   assert_absent "codex argv carries no claude space rule" "Bash(claude *)" "$(cat "$ARGVLOG")"
+  cargs="$(cat "$ARGVLOG.args")"
+  assert_contains "codex argv requests an approval policy at all" "[-c]" "$cargs"
+  assert_eq "  exactly one -c flag" "1" \
+    "$(grep -cFx -- '[-c]' "$ARGVLOG.args" | tr -d ' ')"
+  # ADJACENCY, not mere presence. `-c` and its value must be consecutive
+  # arguments; separated, codex reads them as unrelated tokens and the override
+  # silently does nothing. Asserting each alone would pass on exactly that bug.
+  assert_eq "  -c is immediately followed by approval_policy=never" \
+    "[-c] [approval_policy=never]" \
+    "$(grep -A1 -Fx -- '[-c]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
+  assert_contains "  the sandbox request is still made" "[--sandbox]" "$cargs"
+  assert_contains "  with its existing value" "[workspace-write]" "$cargs"
+  # The launcher must not opt out of the very rules file this policy needs.
+  assert_absent "  and the hop does not opt out of rules loading" "--ignore-rules" "$cargs"
+  assert_contains "run output refuses the containment claim on the Codex path" \
+    "not containment and NOT proof" "$o"
+  assert_contains "run output keeps the unverified premises visible" \
+    "Unverified, and not claimed" "$o"
+
+  # (g) PAIRED NEGATIVE, same launcher, other actor. If approval_policy leaked
+  # onto the Claude hop this fails; if it were absent from BOTH paths, (f) fails.
+  # The pair is what stops either assertion from being unfalsifiable.
+  mkfix nestedcdxneg task-ar claude
+  printf 'transition:codex' >"$ACTION"
+  run_sut --checkout "$REPO" --task task-ar --claude-bin "$FAKEBIN" --log-dir "$LOGD"
+  assert_eq "claude hop still carries" "0" "$RC"
+  assert_absent "claude argv carries no approval policy" \
+    "approval_policy=never" "$(cat "$ARGVLOG.args")"
+  assert_absent "claude argv carries no -c override" "[-c]" "$(cat "$ARGVLOG.args")"
+  # The Claude branch is byte-identical under T7: its four mandatory rules must
+  # still arrive exactly as section (a) proved them.
+  nargs="$(cat "$ARGVLOG.args")"
+  assert_contains "  claude mandatory rule 1 intact" "[Bash(claude:*)]" "$nargs"
+  assert_contains "  claude mandatory rule 2 intact" "[Bash(claude *)]" "$nargs"
+  assert_contains "  claude mandatory rule 3 intact" "[Bash(codex:*)]" "$nargs"
+  assert_contains "  claude mandatory rule 4 intact" "[Bash(codex *)]" "$nargs"
+
+  # (h) The external policy this request depends on, bound to the ACTUAL
+  # machine-wide file T7 installs — NOT a scratch duplicate, which would only
+  # prove that execpolicy works on some file somewhere.
+  #
+  # The leg is mandatory exactly when the launcher requests the policy. Before
+  # T7 lands, the launcher carries no approval_policy flag and the file is not
+  # installed, so this skips. After T7 it is required, and an absent, symlinked,
+  # non-regular, hash-mismatched or malformed file FAILS here.
+  T7_RULES="$HOME/.codex/rules/axcion-nested-actor.rules"
+  T7_RULES_SHA="b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303"
+  if ! grep -qF -- 'approval_policy=never' "$SUT"; then
+    printf '  SKIP external-policy leg: launcher does not request approval_policy yet (pre-T7)\n'
+  elif [ ! -x "$CODEX_DEFAULT_BIN" ]; then
+    printf '  SKIP external-policy leg: %s is not present on this host\n' "$CODEX_DEFAULT_BIN"
+  else
+    # Identity of the installed file, checked before it is trusted as evidence.
+    assert_eq "installed policy file exists" "yes" \
+      "$([ -e "$T7_RULES" ] && echo yes || echo no)"
+    assert_eq "  and is not a symlink" "no" \
+      "$([ -L "$T7_RULES" ] && echo yes || echo no)"
+    assert_eq "  and is a regular file" "yes" \
+      "$([ -f "$T7_RULES" ] && [ ! -L "$T7_RULES" ] && echo yes || echo no)"
+    assert_eq "  and carries the reviewed identity" "$T7_RULES_SHA" \
+      "$(shasum -a 256 "$T7_RULES" 2>/dev/null | cut -d' ' -f1)"
+    # Positives, against that same installed file.
+    assert_eq "installed policy marks a direct claude command prompt" \
+      "decision=prompt matches=1" "$(xp "$T7_RULES" claude -p x)"
+    assert_eq "installed policy marks a direct codex command prompt" \
+      "decision=prompt matches=1" "$(xp "$T7_RULES" codex exec x)"
+    # Rule-absent control. An EMPTY policy, not a copy of the installed one —
+    # it is the absence the positives above are measured against.
+    : >"$TMPROOT/t7-absent.rules"
+    assert_eq "  claude matches nothing with the rule absent" \
+      "decision=none matches=0" "$(xp "$TMPROOT/t7-absent.rules" claude -p x)"
+    assert_eq "  codex matches nothing with the rule absent" \
+      "decision=none matches=0" "$(xp "$TMPROOT/t7-absent.rules" codex exec x)"
+    # Accepted limitations, EVIDENCED against the installed file.
+    assert_eq "  bash -lc wrapper unmatched (accepted limitation)" \
+      "decision=none matches=0" "$(xp "$T7_RULES" bash -lc 'claude -p x')"
+    assert_eq "  env wrapper unmatched (accepted limitation)" \
+      "decision=none matches=0" "$(xp "$T7_RULES" env claude -p x)"
+    assert_eq "  absolute path unmatched without --resolve-host-executables" \
+      "decision=none matches=0" "$(xp "$T7_RULES" /usr/local/bin/claude -p x)"
+    # `deny` is not a decision execpolicy has. If this ever parses, the whole
+    # "prompt is the only available shape" rationale needs rewriting.
+    printf 'prefix_rule(pattern=["zzz"], decision="deny")\n' >"$TMPROOT/t7-deny.rules"
+    assert_contains "  execpolicy still refuses a deny decision" "PROBE-FAILED" \
+      "$(xp "$TMPROOT/t7-deny.rules" zzz)"
+  fi
 
 section "5c. Per-run attended permission mode (real argv, fake binary)"
   # The ONE authorised widening, and the boundary around it. What is proved here
@@ -1432,6 +1562,29 @@ prove_failure() {
     EXPECT_FAIL=0
     assert_contains "M18 control: the hop still launched" "actors=1" "$o"
   fi
+
+  section "M19. Drop the approval policy from the Codex launch"
+  # The T7 request lives in argv and nowhere else — no RESULT field reports it.
+  # Without this mutant, section 5b(f) would only prove that a string appeared
+  # in a log the suite itself produced.
+  mut="$TMPROOT/mutant-codexapproval.sh"
+  sed -e 's/^\( *\)"\$CODEX_BIN" exec --sandbox workspace-write -c approval_policy=never \\$/\1"$CODEX_BIN" exec --sandbox workspace-write \\/' "$SUT" >"$mut"
+  chmod +x "$mut"
+  if grep -qF -- '-c approval_policy=never \' "$mut"; then
+    bad "M19 mutant did not apply" "the codex launch line did not match"
+  elif ! mutant_ok "$mut"; then bad "M19 mutant does not parse" "bad mutation"; else
+    mkfix m19 task-m19 codex
+    printf 'nocommit:claude' >"$ACTION"
+    run_bin "$mut" --checkout "$REPO" --task task-m19 --codex-bin "$FAKEBIN" --log-dir "$LOGD"
+    EXPECT_FAIL=1
+    assert_contains "codex argv requests an approval policy at all" "[-c]" \
+      "$(cat "$ARGVLOG.args")"
+    assert_eq "  -c is immediately followed by approval_policy=never" \
+      "[-c] [approval_policy=never]" \
+      "$(grep -A1 -Fx -- '[-c]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
+    EXPECT_FAIL=0
+    assert_eq "M19 control: the hop still launched" "0" "$RC"
+  fi
 }
 
 # --------------------------------------------------------------------- main
```

#### 4. Fail-closed pre-write guards and identity-safe rollback

**Pre-write** — refuses an existing target *and* a dangling symlink, and proves `default.rules` is a regular non-symlink file at its recorded identity before anything is created:

```bash
set -eu
RULES_LINK="$HOME/.codex/rules"
[ -L "$RULES_LINK" ] && { echo "REFUSE: rules dir is a symlink"; exit 1; }
[ -d "$RULES_LINK" ] || { echo "REFUSE: rules dir missing"; exit 1; }
RULES_DIR="$(cd "$RULES_LINK" && pwd -P)"
TARGET="$RULES_DIR/axcion-nested-actor.rules"
# -L FIRST: a dangling symlink fails -e, so -e alone would pass and the write
# would follow the link. This ordering is the defect-2 correction.
[ -L "$TARGET" ] && { echo "REFUSE: target is a symlink (dangling or not)"; exit 1; }
[ -e "$TARGET" ] && { echo "REFUSE: target already exists"; exit 1; }
DEF="$RULES_DIR/default.rules"
[ -L "$DEF" ] && { echo "REFUSE: default.rules is a symlink"; exit 1; }
[ -f "$DEF" ] || { echo "REFUSE: default.rules is not a regular file"; exit 1; }
[ "$(shasum -a 256 "$DEF" | cut -d' ' -f1)" \
  = 47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2 ] \
  || { echo "REFUSE: default.rules is not the recorded identity"; exit 1; }
```

**External rollback** — same symlink and regular-file proofs for `default.rules` **before and after** removal, and removal only of a file still carrying the installed identity:

```bash
set -eu
RULES_LINK="$HOME/.codex/rules"
[ -L "$RULES_LINK" ] && { echo "REFUSE: rules dir is a symlink"; exit 1; }
RULES_DIR="$(cd "$RULES_LINK" && pwd -P)"
TARGET="$RULES_DIR/axcion-nested-actor.rules"
DEF="$RULES_DIR/default.rules"
check_default() { # before and after — a rollback that damages it is not a rollback
  [ -L "$DEF" ] && { echo "FAIL: default.rules is a symlink"; exit 1; }
  [ -f "$DEF" ] || { echo "FAIL: default.rules is not a regular file"; exit 1; }
  [ "$(shasum -a 256 "$DEF" | cut -d' ' -f1)" \
    = 47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2 ] \
    || { echo "FAIL: default.rules identity changed"; exit 1; }
}
check_default
[ -L "$TARGET" ] && { echo "REFUSE: target is a symlink — not removing"; exit 1; }
[ -f "$TARGET" ] || { echo "REFUSE: target absent or not regular"; exit 1; }
[ "$(shasum -a 256 "$TARGET" | cut -d' ' -f1)" \
  = b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303 ] \
  || { echo "REFUSE: not the identity T7 installed — someone else edited it"; exit 1; }
rm -f -- "$TARGET"
check_default
ls -1 "$RULES_DIR"   # must print exactly: default.rules
```

**Repository rollback** — restores the recorded pre-T7 blobs **by identity**, including the tracked executable mode. After a committed T7, `HEAD` carries the T7 content, so `git checkout --` would restore the change rather than remove it:

```bash
set -eu
git cat-file -p 45f52ab4e343925f14bcba4fc940ac3fd692b284 \
  > scripts/axcion-harness-v0.2/carry-turn.sh
git cat-file -p 7e4af79364d1e6f5a996c592bca31e3c495f96b6 \
  > scripts/axcion-harness-v0.2/carry-turn.test.sh
chmod 755 scripts/axcion-harness-v0.2/carry-turn.sh \
          scripts/axcion-harness-v0.2/carry-turn.test.sh
[ "$(git hash-object scripts/axcion-harness-v0.2/carry-turn.sh)" \
  = 45f52ab4e343925f14bcba4fc940ac3fd692b284 ] || { echo "ROLLBACK FAILED"; exit 1; }
[ "$(git hash-object scripts/axcion-harness-v0.2/carry-turn.test.sh)" \
  = 7e4af79364d1e6f5a996c592bca31e3c495f96b6 ] || { echo "ROLLBACK FAILED"; exit 1; }
git ls-files -s scripts/axcion-harness-v0.2/   # both must read 100755
bash scripts/axcion-harness-v0.2/carry-turn.test.sh   # must return to 285 passed / 0 failed
```

#### 5. The normalized probe that replaced whole-output equality

```
decision=<d> matches=<n>   a parsed result
PROBE-FAILED:<reason>      non-zero exit, or output that is not a result
```

stderr is captured to a file, never merged into the compared value and never discarded — its first 100 characters ride inside `PROBE-FAILED`. Observed behaviour across every case the suite relies on:

| Case | Normalized result |
|---|---|
| direct `claude -p x` against the installed policy | `decision=prompt matches=1` |
| direct `codex exec x` against the installed policy | `decision=prompt matches=1` |
| either, against an empty rule-absent control | `decision=none matches=0` |
| `bash -lc 'claude -p x'`, `env claude -p x`, absolute path | `decision=none matches=0` |
| policy file missing | `PROBE-FAILED:exit=1:Error: failed to read policy …` |
| policy malformed (`decision="deny"`) | `PROBE-FAILED:exit=1:Error: failed to parse policy …` |

A failed probe can no longer read as a clean no-match, which was the specific hazard in defect 3.

#### 6. Evidence

All execpolicy and approval evidence uses the **carrier's own default binary**, `/Applications/ChatGPT.app/Contents/Resources/codex` (`codex-cli 0.147.0-alpha.6.5`), read from `carry-turn.sh:196` by the test itself rather than restated.

| # | Check | Observed |
|---|---|---|
| E1 | `git apply --check`, both patches, against the frozen blobs | clean, **no warnings**; patches carry `index … 100755` |
| E2 | patched suite, policy file **absent** | external leg **FAILS** — presence, regular-file, identity and all five probes; this is defect 1's required fail-capability |
| E3 | patched suite, policy file **present** (simulated `HOME`, real `~/.codex/rules/` untouched) | **318 passed / 0 failed** |
| E4 | installed file **hash-mismatched** | identity guard fails |
| E5 | installed file replaced by a **symlink** | `is not a symlink` and `is a regular file` both fail |
| E6 | installed file **malformed** (`decision="deny"`) | identity guard fails **and** the positive probe returns `PROBE-FAILED` |
| E7 | `--prove-failure` with mutant **M19** | **43 passed / 0 failed**; both argv assertions correctly fail when the policy is stripped |
| E8 | Claude branch of `launch_actor()`, pre vs post | 129 lines, sha `6f8cc966…` **identical**; Claude header paragraphs identical |
| E9 | decision-set probe, all 8 values, carrier binary | only `allow` and `prompt` parse; six others `failed to parse policy` |
| E10 | `doctor -c approval_policy=never` / no override / `bogus-value` | `Never` / `OnRequest` / `✗ config could not be loaded` — the pair discriminates and the check can fail |

**Every line removed across both patches**, so "additive" stays checkable:

```
carry-turn.sh       5 header lines (the "carries NO equivalent" paragraph)
                    2 launch lines (the cmd: say, and the run_bounded argv)
carry-turn.test.sh  1 help assertion (the needle the header rewrite invalidates)
                    3 comment lines heading section 5b(f)
```

No mandatory-rule assertion and no Claude-branch line is removed.

#### 7. Operator's accepted limitation, unchanged

The machine-wide `codex` `prompt` rule overrides the narrower `codex --version` `allow` **inside Codex-mediated execution**; ordinary Terminal use is unaffected; the effect is reversible by the identity-guarded rollback in § 4. This is the limitation the operator accepted, and it extends to nothing else discovered since.

#### 8. Risk inventory, unchanged in substance

Machine-wide blast radius (the ground for the risk-aware review row); the bounded `codex --version` override; wrapper and absolute-path evasion, accepted and evidenced, with **no claim** that a `workspace-write` child cannot reach the file; silent failure if the rules file is not loaded on a run; no new observed field, so `nested=` remains the only nested-actor observation on both paths; rollback to byte-identified prior state on both surfaces; and the residual asymmetry at `dispatch.sh:2115`, outside T7's scope.

#### 9. Automatic rules loading — still a documented, requested premise

Supported by the carrier binary's own `exec --help`: `--ignore-rules — Do not load user or project execpolicy .rules files`. A documented flag to *not* load user `.rules` files is the documented statement that they are otherwise loaded. **No live Codex turn was run or is required**, and loading is not claimed as observed. The test asserts the carrier never passes `--ignore-rules`.

---

### Closure check — findings 1–4 only

| Finding | Status | What settles it |
|---|---|---|
| 1 — bind to the actual installed file | **Resolved** | § 3's leg reads `$HOME/.codex/rules/axcion-nested-actor.rules` and its reviewed sha256; E2 proves it fails when absent, E4/E5/E6 when hash-mismatched, symlinked or malformed; E3 proves it passes when correctly installed. The candidate stays unapplied — ordering is stated in § 1, not performed |
| 2 — fail-closed symlink and identity guards | **Resolved** | § 4 tests `-L` **before** `-e`, closing the dangling-symlink hole; `default.rules` is proven regular and non-symlink at its recorded identity both before and after removal; the sound refusals of an absent, symlinked or changed installed candidate are preserved |
| 3 — warning-tolerant normalization | **Resolved** | § 5 replaces all five equality checks; stderr separated not hidden; fails on non-zero exit, malformed JSON, changed decision or changed match count; a failed probe cannot read as an empty pass |
| 4 — executable mode | **Resolved** | E1: both patches carry `index … 100755` and `git apply --check` is clean and warning-free against both frozen blobs |

**Did the final fix break anything?** No. With the policy installed the suite is **318 passed / 0 failed**, against the 285/0 baseline — 33 additions, no pre-existing assertion removed or weakened. `--prove-failure` is **43 passed / 0 failed**. The Claude branch and its four mandatory-rule assertions are byte-identical (E8). Every patch application and suite run happened in a scratchpad fixture repository under a simulated `HOME`.

### Targets unchanged

`~/.codex/rules/` still holds exactly `default.rules` at sha256 `47532190…`; **no `axcion-nested-actor.rules` was created** — the installed-file evidence was produced under a simulated `HOME` in the scratchpad. `carry-turn.sh` and `carry-turn.test.sh` are still blobs `45f52ab4…` and `7e4af793…` at mode `100755`, live-equal to `HEAD`. No `codex exec` was run and no Claude or Codex actor was launched — only `--version`, `help`, `execpolicy check` and `doctor`.

**Runtime profile.** Operator-carried interactive Claude turn, not an attended-carrier hop. No carrier ran, so no `denials=`, `nested=`, sandbox or network claim is made about this unit's own runtime. Capability subset: baseline read/search/inspect, local static non-actor checks, the state-file write, and this commit. Nothing from the pre-authorizable set, which is empty today.

### Candidate deferrals — recorded, not implemented

- Pre-write physical-path resolution before editing any file (from Unit 34's symlink incident).
- The `ridx` routing-index drift in `work-loop-v2-slice-1.test.sh`.
- The § 3.4 Claude-hop wording note deferred at the Unit 33 correction.
- `logs/friction-log.md`'s uncommitted insertions.
- The dispatcher's unpolicied Codex launch line (`dispatch.sh:2115`), outside T7's scope.

## Blocker

None.

## Next action

Codex: run the closure check on this final fix — findings 1–4 and whether the fix broke anything — and nothing broader, per the executable core's one-final-fix menu. T7 remains unimplemented, both patches remain unapplied, and every implementation and machine-wide target is unchanged.
