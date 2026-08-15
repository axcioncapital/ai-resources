---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 36 — implement T7's reviewed symmetric direct-route nested-actor request exactly.

Named reason for the loop: T7 changes a permission surface, machine-wide configuration outside the repository, and carrier runtime behaviour. Its exact candidate has now completed the required risk-aware review, correction, and final-fix closure check; implementation still needs independent evidence before it counts as landed.

## Brief
T7 is the nearest unmet tracer and its exact candidate at commit `31d201d9becf9f8675bfe23116b569decb589605` has now passed the executable core's final-fix closure check. Implement it now because the plan's pre-implementation risk gate is satisfied and T8 cannot start honestly while the Codex path still lacks the requested restriction. This unit changes only the three approved T7 surfaces and proves the result without claiming runtime refusal or containment.

**Governing authority and exact change.** The re-frozen implementation plan's § 3.5 and T7 govern. Apply the exact candidate preserved below in `## Latest result`: create `/Users/patrik.lindeberg/.codex/rules/axcion-nested-actor.rules` with the exact 381-byte content and reviewed sha256 `b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303`; apply the exact `carry-turn.sh` and `carry-turn.test.sh` patches with mode `100755`. Do not redesign, broaden, or substitute another mechanism.

**Operator authority already granted.** The operator explicitly authorized this bounded machine-wide placement, accepted symmetric direct-route request plus observation as the MVP interpretation of proposal §14 item 7, accepted wrapper and absolute-path evasion, accepted the Codex-mediated `codex --version` allow-to-prompt interference, and deferred full descendant containment. That authorization covers only this exact machine-wide file and the reviewed carrier/test changes; it does not authorize another policy, path, capability, or residual risk.

**Check before writing.** Verify the state and checkout identity; both repository targets remain exactly blobs `45f52ab4e343925f14bcba4fc940ac3fd692b284` and `7e4af79364d1e6f5a996c592bca31e3c495f96b6` at mode `100755`; the physical rules directory is the recorded regular non-symlink directory; the candidate target is absent and not a dangling symlink; and `default.rules` is a regular non-symlink file at sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`. Run the candidate's fail-closed guards before creating anything. A mismatch is a hand-back, not permission to reconcile live state.

**Implementation order.** (1) Run the exact pre-write guards. (2) Write the exact external file and verify its reviewed identity. (3) Apply both exact patches without mode warnings. (4) Run the implementation evidence below. If a repository step fails after the external file is installed, preserve the evidence and use only the identity-guarded rollback needed to restore a coherent prior state; never remove an unexpected or changed external file.

**Required fail-capable evidence.** Record: the installed external file's physical path, regular/non-symlink status, byte count and sha256; `git apply --check` or equivalent pre-application exactness evidence and the resulting full blob identities/modes; `bash -n` for both scripts; the patched `carry-turn.test.sh` result (expected reviewed shape: 318/0 on this host); `--prove-failure` including M19 (reviewed shape: 43/0); direct `claude` and `codex` policy matches; empty-policy negatives; wrapper and absolute-path unmatched results; adjacent `-c`/`approval_policy=never` argv; absence of `--ignore-rules`; and proof that the Claude branch plus its four mandatory rules remain byte-identical. Demonstrate both rollback procedures in isolated fixtures or simulated `HOME`, including dangling-symlink, absent, changed-content and `default.rules` preservation cases; do not roll back the successful live installation merely to prove reversibility.

**Evidence boundary.** Report only that the execpolicy rules and `approval_policy=never` are **requested** and that symmetric process observation remains. Automatic rule loading is a documented premise, not an observation. A matched command's live disposition, effective containment, wrapper-proof prevention, and descendant containment remain unverified or deferred. Do not run `codex exec`, do not launch Claude/Codex actors for evidence, and do not convert an unverified property into a success claim.

**Scope and exclusions.** Allowed targets are exactly the dedicated external rules file, the Codex path plus minimum truthful header/help paragraph in `carry-turn.sh`, `carry-turn.test.sh`, this state file, and the already-existing review-notes handoff. The Claude branch must remain byte-identical. Excluded: skills, commands, core, dispatcher, proposal, plan, state contract, `default.rules`, unrelated dirty `logs/friction-log.md`, routing-index drift, descendant containment, and every other machine-wide setting.

**Capability subset.** Baseline repository reads, local edits/tests, and Claude-owned local commit, plus the already explicitly authorized bounded machine-wide write to the exact rules path above. No network, push, merge, deployment, credential access, destructive shared-state action, or control weakening is selected.

**Stop conditions.** Stop and hand back if any identity or symlink guard fails; the exact patches no longer apply; the reviewed external identity cannot be installed; any required check fails; the Claude path changes; additional scope or authority is needed; live actor execution would be required; or rollback cannot preserve the recorded prior state.

**Completion.** Install and verify the exact T7 candidate, replace `## Latest result` with concise implementation evidence and honest limitations, set `turn: codex`, and commit the repository targets plus state handback. Record the external file's full identity because it is outside Git. Do not begin T8.

## Latest result

Inspected (2026-08-15):

- Claim (1) — state and checkout identity: **HOLDS** — `logs/work-loop/autonomy-authority-capability.md` frontmatter reads `task: autonomy-authority-capability` matching the resolved task id; `work-loop-owner.sh check --depth repo` returned `PROCEED` (this checkout already declares the task).
- Claim (2) — both repository targets are exactly blobs `45f52ab4…` and `7e4af793…` at mode `100755`: **HOLDS** — `git ls-files -s scripts/axcion-harness-v0.2/carry-turn.{sh,test.sh}` returned `100755 45f52ab4e343925f14bcba4fc940ac3fd692b284` and `100755 7e4af79364d1e6f5a996c592bca31e3c495f96b6`; `git hash-object` on the worktree copies returned the same two ids; `git status --porcelain` on both paths was empty.
- Claim (3) — the physical rules directory is a regular non-symlink directory: **HOLDS** — `[ -L "$HOME/.codex/rules" ]` false, `[ -d ]` true, `cd … && pwd -P` resolved to `/Users/patrik.lindeberg/.codex/rules` (no indirection).
- Claim (4) — the candidate target is absent and not a dangling symlink: **HOLDS** — searched `/Users/patrik.lindeberg/.codex/rules` for `axcion-nested-actor.rules`; `[ -L ]` false **and** `[ -e ]` false, in that order; `ls -la` listed only `default.rules`.
- Claim (5) — `default.rules` is a regular non-symlink file at sha256 `47532190…`: **HOLDS** — `[ -L ]` false, `[ -f ]` true, `shasum -a 256` returned `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`.
- Claim (6) — the exact patches still apply: **HOLDS** — `git apply --check --verbose` on both extracted patches exited `0` with no warning line; both patch headers read `index … 100755`.

Result: **T7 is installed.** The exact reviewed candidate was applied unchanged to all three approved surfaces — the machine-wide execpolicy rules file, `carry-turn.sh`, and `carry-turn.test.sh`. Nothing was redesigned, broadened or substituted, and no other surface was touched. The patches were extracted from this file's own recorded candidate rather than retyped, so exactness is mechanical rather than asserted.

### Evidence

| # | Check | Observed |
|---|---|---|
| E1 | `git apply --check --verbose`, both patches, against the frozen blobs | clean, **no warnings**; both headers `index … 100755` |
| E2 | external file installed, physical identity | path `/Users/patrik.lindeberg/.codex/rules/axcion-nested-actor.rules`; **not a symlink**; regular file; **381 bytes**; sha256 `b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303` — equal to the reviewed identity. Mode `644`, matching its `default.rules` sibling; the candidate specified no mode, so this is recorded rather than claimed as reviewed. Identity was verified in the scratchpad **before** the write and again after |
| E3 | post-patch repository identity | `git hash-object` → `982c3df54af7acbd527b2c44bc89289ba92156bc` and `031b60ea9f603bddd6941ebcb8b689ee897244f9`, exactly the patches' declared post-images `982c3df` / `031b60e`; `ls -l` shows `-rwxr-xr-x` on both — the executable bit survived, which is defect 4's fix holding in the live repository |
| E4 | `bash -n` | `carry-turn.sh` → 0; `carry-turn.test.sh` → 0 |
| E5 | patched suite against the **live installed** policy | **318 passed / 0 failed** — the reviewed shape, against the 285/0 pre-T7 baseline measured on this host immediately before the change |
| E6 | the external-policy leg (5b (h)) individually | all twelve assertions `ok`: file exists, not a symlink, is a regular file, carries the reviewed sha256; both direct matches; both empty-policy negatives; all three unmatched-route limitations; and execpolicy still refusing a `deny` decision |
| E7 | `--prove-failure` including M19 | **43 passed / 0 failed**; M19 strips `-c approval_policy=never` from the Codex launch line and **both** argv assertions correctly fail (`missing '[-c]'`, and the adjacency assertion `wanted '[-c] [approval_policy=never]', got ''`), with the control confirming the hop still launched |
| E8 | direct probes, carrier's own binary `codex-cli 0.147.0-alpha.6.5` | `claude -p x` → `decision=prompt matches=1`; `codex exec x` → `decision=prompt matches=1` |
| E9 | rule-absent negatives, empty policy | `claude` → `decision=none matches=0`; `codex` → `decision=none matches=0` |
| E10 | accepted-limitation routes, against the installed file | `bash -lc 'claude -p x'`, `env claude -p x`, `/usr/local/bin/claude -p x` → all `decision=none matches=0` |
| E11 | `deny` is still not a decision execpolicy parses | `PROBE-FAILED:exit=1:Error: failed to parse policy …` |
| E12 | adjacent `-c` argv, and no rules opt-out | asserted inside E5's suite: exactly one `[-c]`, immediately followed by `[approval_policy=never]`, `[--sandbox] [workspace-write]` still present, no `--disallowedTools`, no `--ignore-rules` on the argv. M19 (E7) is what makes these able to fail. `--ignore-rules` appears once in `carry-turn.sh`, at line 122, inside the header comment only — no executable line carries it |
| E13 | Claude branch of `launch_actor()`, pre vs post | pre lines 863–903, post lines 879–919; **41 lines, sha256 `b0393ce2643b7a51af760d3e4dcb24b1295859f12985e9729ed2bb4d4d2f6bf8`, `diff` empty — byte-identical**. Its four mandatory rules are asserted intact inside E5's suite (5b (g)) |

### Both rollback procedures, demonstrated in isolation

Demonstrated under simulated `HOME` directories and an isolated fixture repository. **The live installation was not rolled back.**

External rollback, five cases:

| Case | Setup | Result |
|---|---|---|
| a | correctly installed file | removed; `ls -1` printed exactly `default.rules`; `default.rules` identity checked before and after; exit 0 |
| b | **dangling symlink** at the target | `REFUSE: target is a symlink — not removing`, exit 1; the symlink was left in place |
| c | target absent | `REFUSE: target absent or not regular`, exit 1 |
| d | target content changed by someone else | `REFUSE: not the identity T7 installed — someone else edited it`, exit 1; the file was left in place |
| e | `default.rules` damaged beforehand | `FAIL: default.rules identity changed`, exit 1; nothing was removed |

Repository rollback: a fixture repo was built carrying the two pre-T7 blobs at `100755`, committed, then patched and committed again — so `HEAD` carried T7 and `git checkout --` would have restored the change rather than removed it. The recorded rollback ran verbatim: both files returned to `45f52ab4…` and `7e4af793…`, `git ls-files -s` read `100755` for both, and the suite returned to **285 passed / 0 failed**. Applying the patches inside that fixture also preserved `100755`, independently confirming defect 4. The live repository and the live external file were unchanged by any of this and were re-verified afterwards.

### Limitations — what this unit does not claim

- The execpolicy rules and `approval_policy=never` are **requested**, not enforced. This unit observed the request in argv and the policy file's parse result; it observed **no runtime disposition**.
- Automatic rules loading remains a **documented premise**, not an observation. No live Codex turn was run.
- A matched command's live disposition, effective containment, wrapper-proof prevention and descendant containment are **unverified or deferred**.
- Wrapper and absolute-path routes are unmatched — evidenced above as an accepted limitation, not solved.
- The `codex` `prompt` rule overrides the narrower `codex --version` `allow` inside Codex-mediated execution. This is the interference the operator accepted; ordinary Terminal use is unaffected.

**Runtime profile.** Operator-carried interactive Claude turn, not an attended-carrier hop. No carrier ran, so no `denials=`, `nested=`, sandbox or network claim is made about this unit's own runtime. No `codex exec` was run and no Claude or Codex actor was launched — only `--version` and `execpolicy check`. Capability subset: baseline read/search/inspect, local edits and static non-actor tests, the one authorized bounded machine-wide write, the state-file write, and this local commit. No network, push, merge, deployment, credential access, destructive shared-state action or control weakening.

### Candidate deferrals — recorded, not implemented

- Pre-write physical-path resolution before editing any file (from Unit 34's symlink incident).
- The `ridx` routing-index drift in `work-loop-v2-slice-1.test.sh`.
- The § 3.4 Claude-hop wording note deferred at the Unit 33 correction.
- `logs/friction-log.md`'s uncommitted insertions — still dirty, deliberately untouched by this unit.
- The dispatcher's unpolicied Codex launch line (`dispatch.sh:2115`), outside T7's scope.
- **New, noticed this unit:** Unit 35's E8 recorded the Claude branch as "129 lines, sha `6f8cc966…`" while E13 above records 41 lines at `b0393ce2…`. These are two different extraction ranges, not a contradiction — Unit 35 evidently measured a wider span. Worth pinning one range in the plan so a later reader cannot read them as disagreeing.
- **New, noticed this unit:** the external file's mode was not specified by the reviewed candidate. `644` was chosen to match `default.rules`. If mode matters to loading, it belongs in the recorded identity alongside the sha256.

## Blocker

None.

## Next action

Codex: assess Unit 36. T7 is installed and verified against the reviewed candidate — the three approved surfaces carry the exact change, the suite is 318/0 with the external leg mandatory and fail-capable, `--prove-failure` is 43/0 including M19, the Claude branch is byte-identical, and both rollback procedures are demonstrated in isolation. Decide whether T7 counts as landed and whether T8 may open, and rule on the two new candidate deferrals above.
