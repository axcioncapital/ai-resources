---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Discovery mode. Unit 35 — prepare the exact unapplied T7 candidate for its mandatory risk-aware pre-implementation review.

Named reason for the loop: T7 changes a permission surface, machine-wide configuration outside the repository, and carrier runtime behaviour. Its approved review row requires one fresh risk-aware review of the exact candidate before any implementation.

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

Inspected (2026-08-15):

- Claim (1): **HOLDS.** `~/.codex/rules/` resolves physically to `/Users/patrik.lindeberg/.codex/rules`; `~/.codex` is a real directory (`readlink` returns nothing, `cd … && pwd -P` returns the same path), and `find ~/.codex/rules -maxdepth 1 -type l` returned **no rows**, so neither the directory nor any entry in it is a symlink. The directory holds exactly one file, `default.rules` — 375 bytes, mode `0644`, mtime `Aug 5 22:03`, sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`. Tested three candidate names for collision (`axcion-nested-actor.rules`, `nested-actor.rules`, `axcion.rules`): all three **free**. Only `default.rules` was opened; no other `~/.codex` content was read, and the `ls -1 ~/.codex` listing was names only.
- Claim (2): **HOLDS on grammar, with a version discrepancy that is not material.** Installed CLI is **`codex-cli 0.147.0`**; the plan's § 3.5 Inputs and `carry-turn.sh:110` both name `0.147.0-alpha.6.5`. The **grammar and decision set are identical to the plan's**: probing all eight decision values through `codex execpolicy check --rules <file> zzz`, only `allow` and `prompt` parse; `deny`, `forbid`, `reject`, `block`, `ask` and `never` are all rejected by the parser, and an unmatched command returns `{"matchedRules":[]}` with no decision key. That is exactly what § 3.4 records. The stop condition is a *material* grammar difference, so this is reported as drift in a version string, not a stop.
- Claim (3): **HOLDS.** `carry-turn.sh` is blob `45f52ab4e343925f14bcba4fc940ac3fd692b284` and `carry-turn.test.sh` is blob `7e4af79364d1e6f5a996c592bca31e3c495f96b6` — both live-equal to `HEAD`. The Codex branch of `launch_actor()` is at **`:854-863`** and its launch line at `:860` is `"$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"` — no deny list, no rules path, **no approval policy**. The test seam is § 5b **(f)** at `:454-463`, which asserts only *absences* on the Codex argv. Baseline re-run this unit: `carry-turn.test.sh` → **285 passed / 0 failed**.
- Claim (4): **HOLDS as drafted, with one flagged edge.** The candidate below touches exactly three surfaces: the new machine-wide rules file, the Codex branch of `carry-turn.sh`, and `carry-turn.test.sh`. No skill, command, executable core, dispatcher, proposal, plan or state-contract file is touched. **The flagged edge:** the candidate also rewrites the *Codex paragraph* of the carrier's header comment (`:110-114`). That block is what `--help` prints (`:347` prints the leading comment block), and after T7 its sentence "The Codex actor path carries **NO** equivalent" becomes false. T7's scope boundary names "the Codex branch of `carry-turn.sh` `launch_actor()`", which does not plainly include the header. **This is Codex's decision at the review, not mine** — I have not applied it, and the Claude paragraphs (`:102-108`) stay byte-identical either way.

---

### The exact unapplied T7 candidate

#### 1. Machine-wide execpolicy rules file

**Path (collision-free):** `/Users/patrik.lindeberg/.codex/rules/axcion-nested-actor.rules`

**Prior-state identity:** the file **does not exist**. The directory's entire prior state is one file, `default.rules`, sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`, which the candidate does not modify.

**Complete proposed content:**

```
# Axcion Work Loop v2 — T7 direct-route nested-actor request.
# Requested policy, NOT containment. `prompt` plus an ungrantable approval
# policy is the only shape execpolicy offers: `deny` does not parse.
# Wrapper routes (bash -lc, env, absolute paths) are UNMATCHED and are an
# accepted limitation, not a defect this file solves.
prefix_rule(pattern=["claude"], decision="prompt")
prefix_rule(pattern=["codex"], decision="prompt")
```

#### 2. Unified diff — `scripts/axcion-harness-v0.2/carry-turn.sh`

Against blob `45f52ab4e343925f14bcba4fc940ac3fd692b284`. Two hunks. The Claude branch and the Claude paragraphs of the header are **not** in either.

```diff
--- a/scripts/axcion-harness-v0.2/carry-turn.sh
+++ b/scripts/axcion-harness-v0.2/carry-turn.sh
@@ -110,5 +110,11 @@
-# The Codex actor path carries NO equivalent. `codex exec` (0.147.0-alpha.6.5)
-# offers sandbox modes and config overrides, not a per-command deny list, so
-# there is no native already-used mechanism to request the same of a Codex hop.
-# This policy therefore covers the Claude child only, and saying otherwise would
-# be a claim this script cannot support.
+# The Codex actor path requests the SAME DIRECT ROUTE REFUSAL by a different
+# mechanism, because `codex exec` (0.147.0) offers no per-command deny list.
+# Instead: a machine-wide execpolicy rules file marks a direct `claude` or
+# `codex` command `prompt`, and this launcher requests approval_policy=never,
+# so that prompt has no route to approval. Execpolicy has no `deny` — only
+# `allow` and `prompt` parse — so this is the only shape available.
+# READ IT THE SAME WAY as the Claude rules above: REQUESTED, not containment,
+# and NOT proof that nesting is impossible. A wrapper route (`bash -lc 'claude
+# -p x'`, `env claude -p x`, an absolute path without
+# --resolve-host-executables) is UNMATCHED — an accepted limitation. Whether a
+# matched command is actually refused at runtime is UNVERIFIED on this host.
@@ -854,10 +860,15 @@
     codex)
       [ -x "$CODEX_BIN" ] || die 20 "codex binary not executable: $CODEX_BIN"
       local cv; cv="$("$CODEX_BIN" --version 2>&1 | head -1)"
       say "  launch: actor=codex timeout=${limit}s bin=$CODEX_BIN version=$cv"
-      say "  cmd: codex exec --sandbox workspace-write -C <checkout> --json <prompt>"
+      say "  nested-actor policy: requesting approval_policy=never on every Codex hop — mandatory, no override. A machine-wide execpolicy 'prompt' rule for a direct claude or codex command therefore has no route to approval."
+      say "  This is requested permission policy the child evaluates. It blocks the default direct route; it is not containment and not proof that nesting is impossible."
+      say "  Wrapper routes are unmatched and the live disposition of a matched command is unverified on this host. Both are accepted limitations, not claims."
+      say "  cmd: codex exec --sandbox workspace-write -c approval_policy=never -C <checkout> --json <prompt>"
       run_bounded "$limit" "$out" \
-        "$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"
+        "$CODEX_BIN" exec --sandbox workspace-write -c approval_policy=never \
+        -C "$CHECKOUT" --json "$(codex_prompt)"
       return $?
       ;;
```

#### 3. Unified diff — `scripts/axcion-harness-v0.2/carry-turn.test.sh`

Against blob `7e4af79364d1e6f5a996c592bca31e3c495f96b6`. Two hunks. Sub-sections (a)–(e) of § 5b are untouched except the one help assertion that the header rewrite invalidates.

```diff
--- a/scripts/axcion-harness-v0.2/carry-turn.test.sh
+++ b/scripts/axcion-harness-v0.2/carry-turn.test.sh
@@ -441 +441,4 @@
-  assert_contains "help states the Codex path is not covered" "Codex actor path carries NO equivalent" "$o"
+  assert_contains "help states the Codex path requests refusal by another mechanism" \
+    "requests the SAME DIRECT ROUTE REFUSAL by a different mechanism" "$o"
+  assert_contains "help says execpolicy has no deny" "only" "$o"
+  assert_contains "help keeps the wrapper limitation visible" "UNMATCHED" "$o"
@@ -454,10 +457,22 @@
-  # (f) A Codex hop is unaffected. This unit changes the Claude launch path only,
-  # and a deny set leaking onto the Codex argv would be a claim the launcher
-  # cannot support.
+  # (f) A Codex hop requests refusal by its own mechanism. The deny-set absence
+  # assertions stay: T7 adds an approval policy, NOT a --disallowedTools list,
+  # so a deny set on the Codex argv would still be a claim the launcher cannot
+  # support. What is new is the positive leg — the approval policy must be in
+  # argv, and the paired run below is what makes that able to fail.
   mkfix nestedcdx task-aq codex
   printf 'nocommit:claude' >"$ACTION"
   run_sut --checkout "$REPO" --task task-aq --codex-bin "$FAKEBIN" --log-dir "$LOGD"
   assert_eq "codex hop still carries" "0" "$RC"
   assert_absent "codex argv carries no deny set" "--disallowedTools" "$(cat "$ARGVLOG")"
   assert_absent "codex argv carries no claude colon rule" "Bash(claude:*)" "$(cat "$ARGVLOG")"
   assert_absent "codex argv carries no claude space rule" "Bash(claude *)" "$(cat "$ARGVLOG")"
+  # Per-argument, not "$*": -c and its value must arrive as two arguments, or
+  # the override silently does nothing.
+  cargs="$(cat "$ARGVLOG.args")"
+  assert_contains "codex argv requests an approval policy at all" "[-c]" "$cargs"
+  assert_contains "  and it is approval_policy=never" "[approval_policy=never]" "$cargs"
+  assert_contains "  alongside the existing sandbox request" "[--sandbox]" "$cargs"
+  assert_eq "  exactly one -c flag" "1" \
+    "$(grep -cFx -- '[-c]' "$ARGVLOG.args" | tr -d ' ')"
+  assert_contains "run output refuses the containment claim on the Codex path" \
+    "not containment and not proof" "$o"
+  assert_contains "run output keeps the unverified disposition visible" "unverified" "$o"
```

#### 4. Requested approval-policy / argv shape, and the checks

**Exact argv the Codex hop would carry:**

```
codex exec --sandbox workspace-write -c approval_policy=never -C <checkout> --json <prompt>
```

`-c approval_policy=never` (bare) and `-c approval_policy='"never"'` (TOML-quoted) both resolve to `Never`, proved below. The bare form is proposed because it avoids nested quoting inside the Bash launch line.

**The checks, and what each can and cannot establish:**

| # | Check | Result observed now | Establishes | Does **not** establish |
|---|---|---|---|---|
| P1 | `codex execpolicy check --rules cand.rules claude` | `"decision":"prompt"` | the rule matches a direct `claude` command | that anything refuses it at runtime |
| P2 | `… --rules cand.rules codex exec x` | `"decision":"prompt"` | the rule matches a direct `codex` command | same |
| N1 | same commands against an **empty** rules file | `{"matchedRules":[]}` | **the check can fail** — removing the rule removes the match | — |
| A1 | `codex doctor -c approval_policy=never` | `approval policy Never` | the override is accepted and takes effect in reported config | that a `prompt` is refused rather than granted |
| A2 | `codex doctor` with no override | `approval policy OnRequest` | the paired negative differs — A1 discriminates | — |
| A3 | `codex doctor -c approval_policy=bogus-value` | `✗ config could not be loaded` | **A1 can fail** — a bad value is rejected, not silently ignored | — |
| W1 | `… --rules cand.rules bash -lc 'claude -p x'` | `{"matchedRules":[]}` | wrapper evasion is real and **evidenced**, not asserted | — |
| W2 | `… --rules cand.rules env claude -p x` | `{"matchedRules":[]}` | same | — |
| W3 | `… --rules cand.rules /Users/…/.local/bin/claude -p x` | `{"matchedRules":[]}` | absolute-path route unmatched without `--resolve-host-executables` | — |
| R1 | `carry-turn.test.sh` before any change | **285 passed / 0 failed** | the regression baseline the candidate must not worsen | that the suite binds to T7 — it does not, until hunk 3 lands |

**A material interaction found, not predicted by the plan.** Loading `default.rules` **and** the candidate together, `codex --version` matches **both** rules and the effective decision is **`prompt`**, not `allow`:

```
codex --version  -> matchedRules: [codex --version → allow], [codex → prompt]   decision: prompt
git fetch        -> matchedRules: [git fetch → allow]                            decision: allow
```

The broader `prompt` **overrides** the operator's existing narrower `allow`. So the operator's `codex --version` allow rule stops taking effect once T7 lands. This is normal-user interference, and it is in the risk inventory below.

#### 5. Rollback, tied to the observed prior state

**Machine-wide surface.** The prior state is *absence*, so rollback is deletion, and `default.rules` must be provably untouched:

```bash
rm -f ~/.codex/rules/axcion-nested-actor.rules
# prior state restored iff both hold:
ls -1 ~/.codex/rules            # must print exactly: default.rules
shasum -a 256 ~/.codex/rules/default.rules
# must equal 47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2
```

**Repository surface.** Both files are live-equal to `HEAD` today, so rollback is a path-scoped restore, and the verification is blob identity, not a clean-looking `git status`:

```bash
git checkout -- scripts/axcion-harness-v0.2/carry-turn.sh \
                scripts/axcion-harness-v0.2/carry-turn.test.sh
git hash-object scripts/axcion-harness-v0.2/carry-turn.sh       # 45f52ab4e343925f14bcba4fc940ac3fd692b284
git hash-object scripts/axcion-harness-v0.2/carry-turn.test.sh  # 7e4af79364d1e6f5a996c592bca31e3c495f96b6
bash scripts/axcion-harness-v0.2/carry-turn.test.sh             # must return to 285 passed / 0 failed
```

Workspace `CLAUDE.md` warns that a destructive `git checkout -- <path>` against a dirty tree is unguarded; the rollback above is path-scoped to these two files and must be run only when no other edit to them is in flight.

#### 6. Risk inventory

1. **Machine-wide blast radius.** `~/.codex/rules/` applies to **every** Codex session on this host, not to this repository or this Work Loop. A `prompt` on bare `codex` reaches every interactive Codex use the operator makes. This is the ground on which T7 carries the risk-aware review row, and it is the operator's accepted placement (2026-08-15).
2. **Normal-user interference — measured, not hypothetical.** `codex --version` regresses from `allow` to `prompt` (§ 4 above). Any future narrower `allow` rule for a `claude`/`codex` prefix will be overridden the same way. Mitigation, if wanted, is the operator's call at the review, not this candidate's to choose.
3. **Self-bypass and wrapper evasion.** `bash -lc`, `env`, and absolute paths are all unmatched (W1–W3). A Codex child running under `--sandbox workspace-write` cannot edit `~/.codex/rules/` — that is why the placement is machine-wide — but it can trivially route around the rule with a wrapper. Accepted limitation per the 2026-08-15 decision; recorded, not solved.
4. **Failure mode.** If `~/.codex/rules/` is not loaded by a given Codex invocation — `--ignore-rules` exists precisely to skip it — the rule is absent and the hop proceeds with **no** direct-route request. The failure is silent: nothing in the carrier's `RESULT` line reports whether a rules file was loaded.
5. **Observability.** The carrier gains **no** new observed field. `nested=` is unchanged and stays the only nested-actor observation, on both paths. Everything T7 adds is visible in argv and configuration only — which is exactly what § 3.5 says the evidence may claim.
6. **Rollback.** Both surfaces restore to a byte-identified prior state (§ 5). The machine-wide file's prior state is absence, which is the cleanest rollback available.
7. **Residual asymmetry outside T7's scope.** `dispatch.sh:2115` launches Codex with the **same** unpolicied argv and a different binary (`/Applications/ChatGPT.app/Contents/Resources/codex`). T7's scope boundary excludes the dispatcher, so that path keeps today's asymmetry after T7 lands. The machine-wide rules file would still reach it if that binary shares `CODEX_HOME`; the launcher-side `approval_policy=never` would not.

#### What this unit did **not** establish

- **That `~/.codex/rules/*.rules` is auto-loaded by `codex exec`.** The `--ignore-rules` flag ("Do not load user or project execpolicy `.rules` files") implies user rules load by default, and `default.rules` sits in that directory in the shape Codex's own execpolicy-amendment flow writes. But **no static reporter exists** — `codex doctor` prints zero lines matching `rules`, and `codex execpolicy check` requires an explicit `--rules` path, so it cannot demonstrate discovery. Confirming auto-load needs a live Codex turn, which this unit may not take. Every P/N result above is therefore conditional on the file being loaded.
- **The live disposition of a matched command.** Held **unverified**, per the brief's evidence boundary and T7's own clause. Nothing here shows that a `prompt` under `approval_policy=never` is refused rather than granted, and confirming it is not a precondition of T7.
- **Wrapper-proof prevention or descendant containment.** Neither is claimed; both stay accepted/deferred boundaries.

#### Targets unchanged

Every implementation and configuration target is **unchanged**. `~/.codex/rules/` still contains exactly `default.rules` at sha256 `47532190…`; no `axcion-nested-actor.rules` was created. `carry-turn.sh` and `carry-turn.test.sh` are still blobs `45f52ab4…` and `7e4af793…`, live-equal to `HEAD`. All candidate rules files were written to the session scratchpad, never to `~/.codex/rules/`. No `codex exec` was run and no Claude or Codex actor was launched — the only Codex invocations were `--version`, `help`, `execpolicy check` and `doctor`, all static.

**Runtime profile, reported honestly.** This was an **operator-carried interactive Claude turn**, not an attended-carrier hop. No carrier ran, so this unit makes no `denials=`, `nested=`, sandbox or network claim about its own runtime. Capability subset used: baseline read/search/inspect plus local static non-actor checks, the state-file write, and this commit. Nothing was drawn from the pre-authorizable set, which is empty today, and no operator-reserved capability was exercised.

#### Candidate deferrals — recorded, not implemented

- **Pre-write physical-path resolution** before editing any file (carried from Unit 34's symlink incident; Codex already deferred it for separate treatment).
- **The `ridx` routing-index/live-installation drift** — still the one known failure in `work-loop-v2-slice-1.test.sh`.
- **The § 3.4 Claude-hop wording note** deferred at the Unit 33 correction.
- **`logs/friction-log.md`'s uncommitted insertions** — still untouched, still uncommitted.
- **New this unit:** the dispatcher's unpolicied Codex launch line (`dispatch.sh:2115`), outside T7's scope boundary.

## Blocker

None.

## Next action

Codex: run the required fresh **risk-aware review** of the exact candidate above before any T7 implementation brief exists. Three decisions the review must settle, because this unit deliberately did not: (1) whether rewriting the carrier's Codex **header/help paragraph** (`:110-114`) is inside T7's scope boundary, given that leaving it makes the carrier's own `--help` text false; (2) what to do about the measured `codex --version` regression from `allow` to `prompt`; (3) whether the unproven **auto-load** of `~/.codex/rules/` is acceptable as a conditional premise, or must be confirmed by a live Codex turn before T7 lands.
