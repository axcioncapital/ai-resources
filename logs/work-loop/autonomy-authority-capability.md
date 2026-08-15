---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Discovery mode. Unit 35 correction — correct the exact unapplied T7 candidate against the risk review's frozen findings.

Named reason for the loop: T7 changes a permission surface, machine-wide configuration outside the repository, and carrier runtime behaviour. The first mandatory review did not pass; its technical findings are frozen for one candidate-only correction before a fresh review.

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

Correction round, 2026-08-15. Every frozen finding was reproduced by inspection before anything was rewritten; the candidate below **replaces** the previous one rather than sitting beside it.

Reproduced (2026-08-15):

- Finding 1: **REPRODUCED.** The previous diffs were hand-written prose, not patches. Regenerated mechanically and both now pass `git apply --check` against the frozen blobs (evidence below).
- Finding 2: **REPRODUCED, and worse than stated.** The previous candidate said "blocks the default direct route" and "has no route to approval", and claimed a `workspace-write` child "cannot edit `~/.codex/rules/`" — three unverified effectiveness claims. The provenance error is also confirmed: `carry-turn.sh:196` sets `CODEX_BIN="/Applications/ChatGPT.app/Contents/Resources/codex"`, and **that binary reports `codex-cli 0.147.0-alpha.6.5`** — exactly what the plan says. My previous "version discrepancy" measured `~/.local/bin/codex` (`0.147.0`), which the carrier never launches. **The plan was right and my claim (2) was wrong.** Every probe has been re-run on the carrier's own binary; all results are identical, so the evidence stands and only its provenance changes.
- Finding 3: **REPRODUCED.** The previous test candidate used the needle `only` — which matches unrelated help text — asserted `[-c]` and `[approval_policy=never]` separately (both pass even if the two are non-adjacent and the override silently does nothing), had no real paired negative, bound nothing to the external rules file, and never asserted the absence of `--ignore-rules`.
- Finding 4: **REPRODUCED.** The previous repository rollback used `git checkout -- <path>`, which after a committed T7 restores *the T7 content* from `HEAD` rather than removing it. The external rollback resolved no physical path, refused no symlink, and checked no identity before `rm`.
- Finding 5: **REPRODUCED as under-scoped.** The override was recorded as a risk but not as the operator's accepted limitation, and its blast radius was left unbounded.
- Finding 6: **REPRODUCED.** The previous text treated auto-loading as an open defect needing a live Codex turn. It is a documented premise; the carrier binary's own `exec --help` names the opt-out.
- Finding 7: **REPRODUCED as a standing instruction** — obeyed below.

---

### The corrected exact unapplied T7 candidate

#### 1. Machine-wide execpolicy rules file

**Path:** `/Users/patrik.lindeberg/.codex/rules/axcion-nested-actor.rules` — free (checked; the directory holds only `default.rules`).
**Prior state:** the file **does not exist**. Directory physical path `/Users/patrik.lindeberg/.codex/rules`, not a symlink, no symlinks inside. `default.rules` sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`.
**Candidate identity once written:** sha256 `b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303`, 381 bytes.

```
# Axcion Work Loop v2 — T7 direct-route nested-actor request.
# REQUESTED policy, not containment. Execpolicy parses only `allow` and
# `prompt`; there is no `deny`. Wrapper and absolute-path routes are UNMATCHED
# and are an accepted limitation, not a defect this file solves.
prefix_rule(pattern=["claude"], decision="prompt")
prefix_rule(pattern=["codex"], decision="prompt")
```

#### 2. Patch — `scripts/axcion-harness-v0.2/carry-turn.sh`

```diff
diff --git a/scripts/axcion-harness-v0.2/carry-turn.sh b/scripts/axcion-harness-v0.2/carry-turn.sh
index 45f52ab..982c3df 100644
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
index 7e4af79..74330f5 100644
--- a/scripts/axcion-harness-v0.2/carry-turn.test.sh
+++ b/scripts/axcion-harness-v0.2/carry-turn.test.sh
@@ -297,6 +297,8 @@ section() { printf '\n%s\n' "$1"; }
 
 run_suite() {
 
+CODEX_DEFAULT_BIN="$(awk -F'"' '/^CODEX_BIN=/{print $2; exit}' "$SUT")"
+
 section "1. Static checks"
   bash -n "$SUT" 2>/dev/null; assert_eq "launcher parses (bash -n)" "0" "$?"
   bash -n "$HERE/carry-turn.test.sh" 2>/dev/null; assert_eq "suite parses (bash -n)" "0" "$?"
@@ -438,7 +440,19 @@ section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
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
@@ -451,9 +465,11 @@ section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
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
@@ -461,6 +477,78 @@ section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
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
+  # (h) The external rules file this policy depends on, bound to real matches
+  # from the CARRIER'S OWN default Codex binary — not whatever `codex` PATH
+  # resolves to, which is a different install at a different version. A host
+  # without that binary cannot evidence this leg, and the skip is announced
+  # rather than passing silently.
+  T7RULES="$TMPROOT/t7.rules"
+  printf 'prefix_rule(pattern=["claude"], decision="prompt")\nprefix_rule(pattern=["codex"], decision="prompt")\n' >"$T7RULES"
+  : >"$TMPROOT/t7-empty.rules"
+  if [ -x "$CODEX_DEFAULT_BIN" ]; then
+    xp() { "$CODEX_DEFAULT_BIN" execpolicy check --rules "$1" "${@:2}" 2>&1; }
+    assert_contains "external rule marks a direct claude command prompt" \
+      '"decision":"prompt"' "$(xp "$T7RULES" claude -p x)"
+    assert_contains "external rule marks a direct codex command prompt" \
+      '"decision":"prompt"' "$(xp "$T7RULES" codex exec x)"
+    # Rule-absent negative: the same commands, an empty policy. This is the leg
+    # that proves the two assertions above are not tautologies.
+    assert_eq "  claude matches nothing once the rule is absent" '{"matchedRules":[]}' \
+      "$(xp "$TMPROOT/t7-empty.rules" claude -p x)"
+    assert_eq "  codex matches nothing once the rule is absent" '{"matchedRules":[]}' \
+      "$(xp "$TMPROOT/t7-empty.rules" codex exec x)"
+    # Accepted limitations, EVIDENCED rather than asserted.
+    assert_eq "  bash -lc wrapper is unmatched (accepted limitation)" '{"matchedRules":[]}' \
+      "$(xp "$T7RULES" bash -lc 'claude -p x')"
+    assert_eq "  env wrapper is unmatched (accepted limitation)" '{"matchedRules":[]}' \
+      "$(xp "$T7RULES" env claude -p x)"
+    assert_eq "  absolute path is unmatched without --resolve-host-executables" \
+      '{"matchedRules":[]}' "$(xp "$T7RULES" /usr/local/bin/claude -p x)"
+    # `deny` is not a decision execpolicy has. If this ever parses, the whole
+    # "prompt is the only shape available" rationale needs rewriting.
+    printf 'prefix_rule(pattern=["zzz"], decision="deny")\n' >"$TMPROOT/t7-deny.rules"
+    assert_contains "  execpolicy still refuses a deny decision" "failed to parse policy" \
+      "$(xp "$TMPROOT/t7-deny.rules" zzz)"
+  else
+    printf '  SKIP external-rule leg: %s is not present on this host\n' "$CODEX_DEFAULT_BIN"
+  fi
 
 section "5c. Per-run attended permission mode (real argv, fake binary)"
   # The ONE authorised widening, and the boundary around it. What is proved here
@@ -1432,6 +1520,30 @@ prove_failure() {
     EXPECT_FAIL=0
     assert_contains "M18 control: the hop still launched" "actors=1" "$o"
   fi
+
+  section "M19. Drop the approval policy from the Codex launch"
+  # The T7 request lives in argv and nowhere else — no RESULT field reports it.
+  # Without this mutant, section 5b(f) would only prove that a string appeared
+  # in a log the suite itself produced.
+  mut="$TMPROOT/mutant-codexapproval.sh"
+  sed -e 's/^\( *\)exec --sandbox workspace-write -c approval_policy=never \\$/\1exec --sandbox workspace-write \\/' \
+      -e 's/^\( *\)"\$CODEX_BIN" exec --sandbox workspace-write -c approval_policy=never \\$/\1"$CODEX_BIN" exec --sandbox workspace-write \\/' "$SUT" >"$mut"
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

#### 4. Requested shape, and the checks

**Argv the Codex hop would carry:**

```
codex exec --sandbox workspace-write -c approval_policy=never -C <checkout> --json <prompt>
```

All execpolicy and approval evidence below was produced with the **carrier's own default binary**, `/Applications/ChatGPT.app/Contents/Resources/codex` (`codex-cli 0.147.0-alpha.6.5`), not the PATH CLI.

| # | Check | Observed | Establishes | Does **not** establish |
|---|---|---|---|---|
| G1 | decision-set probe, all 8 values | only `allow` and `prompt` parse; `deny`/`forbid`/`reject`/`block`/`ask`/`never` → `failed to parse policy` | `prompt` + a restrictive approval policy is the only available shape | anything about runtime |
| P1 | `execpolicy check --rules <cand> claude -p x` | `"decision":"prompt"` | the rule matches a direct `claude` command | that it is refused |
| P2 | `… codex exec x` | `"decision":"prompt"` | the rule matches a direct `codex` command | that it is refused |
| N1 | P1/P2 against an **empty** policy | `{"matchedRules":[]}` | **P1/P2 can fail** | — |
| A1 | `doctor -c approval_policy=never` | `approval policy Never` | the override is accepted and reported | that a `prompt` is refused |
| A2 | `doctor`, no override | `approval policy OnRequest` | **A1 discriminates** — the pair differs | — |
| A3 | `doctor -c approval_policy=bogus-value` | `✗ config could not be loaded` | **A1 can fail** — bad values are rejected, not ignored | — |
| W1–W3 | `bash -lc 'claude -p x'`, `env claude -p x`, absolute path | `{"matchedRules":[]}` (all three) | wrapper/absolute evasion **evidenced**, not asserted | — |
| R1 | patched suite, in an isolated fixture | **314 passed / 0 failed** (baseline 285/0) | 29 new assertions, no regression | — |
| R2 | `--prove-failure` with new mutant **M19** | both new argv assertions **correctly fail** when the policy is stripped | the argv assertions are fail-capable by the suite's own standard | — |
| R3 | `git apply --check` of both patches against the frozen blobs | clean | the patches are mechanically exact | — |
| R4 | Claude branch of `launch_actor()`, pre vs post | 129 lines, sha `6f8cc966…` **identical**; Claude header paragraphs identical | the Claude path is untouched | — |

**Every line removed across both patches** — the complete list, so "additive" is checkable rather than asserted:

```
carry-turn.sh       5 header lines (the "carries NO equivalent" paragraph)
                    2 launch lines (the cmd: say, and the run_bounded argv)
carry-turn.test.sh  1 help assertion (the needle the header rewrite invalidates)
                    3 comment lines heading section 5b(f)
```

No mandatory-rule assertion and no Claude-branch line is removed; the four mandatory-rule assertions rise from 33 to 37 occurrences, all additions.

#### 5. Identity-safe pre-write checks and rollback

**Fail-closed pre-write checks** (external surface, run before anything is created):

```bash
set -eu
[ -L "$HOME/.codex/rules" ] && { echo "REFUSE: rules dir is a symlink"; exit 1; }
RULES_DIR="$(cd "$HOME/.codex/rules" && pwd -P)"
TARGET="$RULES_DIR/axcion-nested-actor.rules"
[ -e "$TARGET" ] && { echo "REFUSE: target already exists"; exit 1; }
# the pre-existing file must be exactly what was recorded, or state has moved
[ "$(shasum -a 256 "$RULES_DIR/default.rules" | cut -d' ' -f1)" \
  = 47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2 ] \
  || { echo "REFUSE: default.rules is not the recorded identity"; exit 1; }
```

**External rollback** — resolves the physical path, refuses symlinks, and removes only a file that still carries the installed identity:

```bash
set -eu
[ -L "$HOME/.codex/rules" ] && { echo "REFUSE: rules dir is a symlink"; exit 1; }
RULES_DIR="$(cd "$HOME/.codex/rules" && pwd -P)"
TARGET="$RULES_DIR/axcion-nested-actor.rules"
[ -L "$TARGET" ] && { echo "REFUSE: target is a symlink"; exit 1; }
[ "$(shasum -a 256 "$TARGET" | cut -d' ' -f1)" \
  = b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303 ] \
  || { echo "REFUSE: not the identity T7 installed — someone else edited it"; exit 1; }
rm -f -- "$TARGET"
[ "$(shasum -a 256 "$RULES_DIR/default.rules" | cut -d' ' -f1)" \
  = 47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2 ] \
  || { echo "ROLLBACK FAILED: default.rules changed"; exit 1; }
ls -1 "$RULES_DIR"   # must print exactly: default.rules
```

**Repository rollback** — restores the **recorded pre-T7 blobs by identity**. This is the finding-4 correction: after T7 is committed, `HEAD` carries the T7 content, so `git checkout -- <path>` would restore the change rather than remove it.

```bash
set -eu
git cat-file -p 45f52ab4e343925f14bcba4fc940ac3fd692b284 \
  > scripts/axcion-harness-v0.2/carry-turn.sh
git cat-file -p 7e4af79364d1e6f5a996c592bca31e3c495f96b6 \
  > scripts/axcion-harness-v0.2/carry-turn.test.sh
chmod +x scripts/axcion-harness-v0.2/carry-turn.sh \
         scripts/axcion-harness-v0.2/carry-turn.test.sh
[ "$(git hash-object scripts/axcion-harness-v0.2/carry-turn.sh)" \
  = 45f52ab4e343925f14bcba4fc940ac3fd692b284 ] || { echo "ROLLBACK FAILED"; exit 1; }
[ "$(git hash-object scripts/axcion-harness-v0.2/carry-turn.test.sh)" \
  = 7e4af79364d1e6f5a996c592bca31e3c495f96b6 ] || { echo "ROLLBACK FAILED"; exit 1; }
bash scripts/axcion-harness-v0.2/carry-turn.test.sh   # must return to 285 passed / 0 failed
```

#### 6. The operator's accepted limitation, carried explicitly

The machine-wide `codex` `prompt` rule **overrides the existing narrower `codex --version` `allow` rule inside Codex-mediated execution**. Measured on the carrier binary with both files loaded: `codex --version` matches both rules and resolves to `prompt`, while an unrelated rule (`git fetch`) still resolves to `allow`, so the effect is specific and not a blanket loss of the file.

Three bounds, stated because the acceptance depends on them:

- It applies to commands **mediated by Codex execpolicy**. Ordinary Terminal use of `codex --version` is **unaffected** — execpolicy governs what a Codex session may run, not the operator's own shell.
- It is **reversible** by the identity-guarded external rollback above.
- The operator accepted **this** limitation. It is not approval of any other residual risk discovered later, and nothing here should be read as extending it.

#### 7. Risk inventory

1. **Machine-wide blast radius.** `~/.codex/rules/` applies to every Codex session on this host. This is the ground for T7's risk-aware review row, and the placement the operator authorized on 2026-08-15.
2. **Normal-user interference.** The `codex --version` override, bounded as in § 6.
3. **Self-bypass and wrapper evasion.** W1–W3 are unmatched. Accepted limitation, recorded not solved. **No claim is made** that a `workspace-write` child cannot reach the file — that was an unverified claim in the previous candidate and has been removed.
4. **Failure mode is silent.** If the rules file is not loaded on a run, the hop proceeds with no direct-route request, and nothing in the `RESULT` line reports it.
5. **Observability unchanged.** No new observed field. `nested=` remains the only nested-actor observation on both paths. Everything T7 adds is visible in argv and configuration only.
6. **Rollback.** Both surfaces restore to byte-identified prior state, guarded against symlinks and third-party edits.
7. **Residual asymmetry outside scope.** `dispatch.sh:2115` launches Codex with the same unpolicied argv. T7 excludes the dispatcher, so that path keeps today's asymmetry.

#### 8. Automatic rules loading — a documented, requested premise

Treated as a **premise**, not an observation and not a defect. Its support is the carrier binary's own `exec --help`:

```
--ignore-rules
    Do not load user or project execpolicy `.rules` files
```

A documented flag to *not* load user `.rules` files is the documented statement that they are otherwise loaded. That is the whole basis, and it is a requested premise. **No live Codex turn was run or is required**, and loading is **not** claimed to have been observed. The candidate's own text says the same, and the test asserts the carrier never passes `--ignore-rules`.

---

### Closure check against findings 1–6

| Finding | Status | What settles it |
|---|---|---|
| 1 — mechanically exact patches | **Resolved** | R3: `git apply --check` clean against both frozen blobs, singly and together; proved on an isolated fixture, neither target touched |
| 2 — no unverified effectiveness claims | **Resolved** | all three overclaims removed; wording is `REQUESTED`/`UNVERIFIED` throughout; provenance switched to the carrier's own binary and version, and the test asserts the three overclaim needles are **absent** from help |
| 3 — fail-capable and exact tests | **Resolved** | generic needle `only` gone; adjacency asserted as `[-c] [approval_policy=never]`; real paired negative in (g); external rules bound to positives, rule-absent negatives and wrapper/absolute evasions in (h); `--ignore-rules` absence asserted; Claude branch byte-identical (R4); M19 proves the argv assertions fail when the policy is stripped |
| 4 — identity-safe rollback | **Resolved** | repository rollback restores recorded blobs via `git cat-file`, not `git checkout --`; external rollback resolves the physical path, refuses symlinks, verifies installed identity before removal, and proves `default.rules` survives |
| 5 — accepted limitation carried | **Resolved** | § 6, with the Codex-mediated scope, the Terminal-unaffected bound, reversibility, and an explicit statement that it does not extend to other risks |
| 6 — loading as documented premise | **Resolved** | § 8, grounded in the carrier binary's `--ignore-rules` help text; no live turn run or required; loading not claimed as observed |

**Did the correction break anything?** No. The patched suite is **314 passed / 0 failed** against a 285/0 baseline — 29 additions, no pre-existing assertion removed or weakened. The fail-capability proof is **43 passed / 0 failed** with M19 added. The Claude branch and the Claude header paragraphs are byte-identical. Both patches were exercised only in an isolated fixture repository.

**One correction to my own prior work, stated plainly:** Unit 35's claim (2) reported a version discrepancy between the plan and the installed CLI. That was measured against the wrong binary. The carrier's default Codex binary is `0.147.0-alpha.6.5`, exactly as the plan records. There is no discrepancy.

### Targets unchanged

`~/.codex/rules/` still holds exactly `default.rules` at sha256 `47532190…`; no `axcion-nested-actor.rules` was created. `carry-turn.sh` and `carry-turn.test.sh` are still blobs `45f52ab4…` and `7e4af793…`, live-equal to `HEAD`. Every patch application and suite run happened in a scratchpad fixture repository. No `codex exec` was run and no Claude or Codex actor was launched — only `--version`, `help`, `execpolicy check` and `doctor`.

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

Codex: run the fresh risk-aware review of the corrected candidate above. The three questions the previous handback raised are now answered inside it — the header/help paragraph is included as the minimum truthful change and is proven not to touch the Claude paragraphs; the `codex --version` override is carried as the operator's bounded accepted limitation; and automatic loading is stated as a documented requested premise with no live turn required. Nothing in T7 has been implemented, and every target is unchanged.
