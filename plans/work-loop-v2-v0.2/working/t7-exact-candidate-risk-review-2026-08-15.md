# T7 exact-candidate risk-aware review — 2026-08-15

## Verdict

**OPERATOR ESCALATION REQUIRED. Do not implement this candidate.**

The candidate cannot pass in its present form for two independent reasons:

1. the broader machine-wide `codex` `prompt` rule measurably overrides the operator's existing narrower `codex --version` `allow` rule, creating a new residual-risk/normal-use tradeoff that the operator has not yet accepted; and
2. the exact candidate has several technical defects that must be corrected regardless of that decision, including two non-applicable unified diffs, an unsafe/ineffective rollback, overclaimed runtime behavior, and test assertions that can pass spuriously.

This review does **not** reopen the already accepted wrapper-evasion limitation or the deferral of full descendant containment.

## Review boundary and authority

Reviewed independently against:

- `logs/work-loop/autonomy-authority-capability.md`, Unit 35's exact unapplied candidate and evidence;
- the re-frozen implementation plan, especially § 3.5 and T7, approved substantive blob `0fabe8601871c5f7c49ff1e8628d4922c4422ba2`;
- canonical Work Loop executable core §§ 6–8;
- the current carrier/help/launch surfaces in `scripts/axcion-harness-v0.2/carry-turn.sh`;
- the relevant fake-actor, argv-recording, nested-policy and mutation-proof surfaces in `scripts/axcion-harness-v0.2/carry-turn.test.sh`;
- `/Users/patrik.lindeberg/.codex/rules/default.rules` and its observed identity; and
- static behavior of the carrier's actual default Codex binary, `/Applications/ChatGPT.app/Contents/Resources/codex` (`codex-cli 0.147.0-alpha.6.5`).

No implementation, configuration, carrier, test, plan, skill, command, core, dispatcher, proposal, or state file was changed. No actor was launched.

## Explicit determinations requested by Unit 35

### 1. Carrier header/help hunk

**Allowed; no plan amendment or operator action is required for this hunk.**

The plan authorizes the Codex actor surface in `carry-turn.sh`, and the leading Codex-only paragraph is the carrier's live `--help` output. Leaving it unchanged after the approved launch change would make the carrier state a known falsehood (`NO equivalent`). Replacing that paragraph is the minimum truth-preserving companion to the authorized Codex launch change. It adds no behavior, file, actor path, capability, or state surface and is not a material scope expansion under core §§ 6.4 and 8.

The revised help text must nevertheless be technically honest: it may say that the carrier requests `approval_policy=never` and depends on the user-rules loader contract; it may not say the policy **blocks**, is loaded/effective, or leaves **no route** in a way that implies an observed live refusal.

### 2. `codex --version` allow-to-prompt interaction

**Operator decision required.**

The current user rules contain `prefix_rule(pattern=["codex", "--version"], decision="allow")`. With the candidate's broader `prefix_rule(pattern=["codex"], decision="prompt")`, the actual default carrier binary reports both matches and an effective decision of `prompt`; the stricter broad rule wins. This means a rules-evaluated, model-generated direct `codex --version` command loses the existing allow disposition. It does **not** mean that launching the Codex application or CLI from a terminal is itself prompted; the candidate's risk inventory should state the interference at the rules-evaluated command surface precisely.

The operator must choose one of two bounded paths:

- accept and record this loss of the existing allow as a known machine-wide limitation of the approved broad-prefix mechanism; or
- reject that interference and authorize a different mechanism/scope, which materially changes the approved solution and returns the plan to amendment/reapproval before a new candidate is reviewed.

The prefix policy shown here has no narrower `allow` exception that can beat a broader `prompt`, so the reviewer cannot silently preserve both behaviors.

### 3. Automatic loading of `~/.codex/rules/*.rules`

**Acceptable only as a documented/requested premise; no live turn is required by T7, but loading must remain unverified.**

The actual default carrier binary's `codex exec --help` says `--ignore-rules` means “Do not load user or project execpolicy .rules files,” and the proposed launch argv does not pass that flag. That is sufficient at this plan's explicitly static evidence bar to say the candidate is configured under the installed CLI's default user-rules loader contract. It is not observation that this particular dedicated file was discovered or that a matching command was refused. The carrier has no field that reports either fact.

The corrected test must assert that `--ignore-rules` is absent from the Codex argv, and the corrected help/run text must say that external rule discovery and matched-command disposition are not carrier-verified. T7's handback must keep the distinction: **configured/requested under the loader contract**, not **loaded**, **effective**, or **blocking**.

## Material technical findings

### F1. The two “exact unified diffs” are not applicable

Read-only `git apply --check -` against the exact fenced diffs failed:

- carrier diff: `error: corrupt patch at line 36` (exit 128);
- test diff: `patch failed ... carry-turn.test.sh:441` / `patch does not apply` (exit 1).

The carrier's second hunk describes 9 old and 13 new lines, not the declared 10/15. The test's second hunk describes 10 old and 24 new lines, not the declared 10/22. Because other wording must also change under F2–F4, the remedy is to regenerate both diffs from the byte-identified current files and require `git apply --check` to exit 0; merely editing the count headers is insufficient.

### F2. Candidate wording exceeds the verified evidence

The proposed run output says the requested policy “blocks the default direct route.” That asserts the live disposition which § 3.5 and T7 explicitly leave unverified and identify as a failure to claim. The external-file comments and risk inventory also overreach when they state wrapper/absolute-path behavior without limiting it to static `execpolicy check`, and when they say a `workspace-write` child “cannot edit” `~/.codex/rules/`. The carrier only requests that sandbox and does not verify its enforcement; the canonical Work Loop skill expressly forbids promoting it to effective containment.

Required wording:

- “requests refusal of the default direct route,” never “blocks” or “prevents”;
- wrapper and absolute-path results are **static matcher results**, not observed runtime bypass behavior;
- `workspace-write` is requested and not carrier-verified, so self-edit resistance is unestablished; and
- rule discovery and matched-command disposition remain unverified.

### F3. Version provenance is wrong for the carrier path

The candidate changes the help paragraph from `0.147.0-alpha.6.5` to `0.147.0`, based on the PATH-installed `/Users/patrik.lindeberg/.local/bin/codex`. The attended carrier defaults instead to `/Applications/ChatGPT.app/Contents/Resources/codex`, which is still `codex-cli 0.147.0-alpha.6.5`.

The mechanism itself survives this defect: static checks against the actual default binary returned `prompt` for direct `claude` and `codex`, `approval Never` for `-c approval_policy=never`, the same wrapper non-matches, and the same `codex --version` prompt-over-allow interaction. Correct the evidence provenance and make the help version-neutral (preferred, because the launcher already prints the live binary/version) or name the actual default version.

### F4. Proposed regression assertions can pass for the wrong reason and do not bind rule matching

Material examples:

- `assert_contains ... "only" "$o"` can pass on many unrelated occurrences in the full help block; it does not establish “execpolicy has no deny.”
- Separate containment checks for `[-c]` and `[approval_policy=never]` do not prove adjacency even though the comment says `-c` and its value must be two adjacent arguments. A misplaced value could pass.
- “the paired run below” is false: the proposed hunk contains one Codex run and adds no mutation/negative run with the approval override removed.
- The proposed test never reads or evaluates the external rules file, so it does not bind direct-match semantics. Those semantics remain one-off static implementation evidence, not regression protection supplied by the test change.
- Nothing asserts absence of `--ignore-rules`, even though default external-rule discovery is load-bearing.

Bounded correction:

- assert exact multi-line argument pairs, including `[-c] [approval_policy=never]`, exactly one `-c`, the existing `[--sandbox] [workspace-write]` pair, and absence of `[--ignore-rules]`;
- use exact, distinctive help/run phrases rather than `only` or similarly generic needles;
- add one focused fail-capability proof (a launcher-copy mutant removing the `-c approval_policy=never` pair while leaving the hop launchable), or accurately cite a before/after negative that demonstrates the same assertion fails;
- keep the evidence lanes separate: `carry-turn.test.sh` binds argv and honest output; static positive/negative `codex execpolicy check` against the exact installed file binds matcher behavior at implementation time. Do not claim the suite tests the external rule semantics unless the corrected candidate actually adds such a test within approved scope.

### F5. Rollback is not safe or effective as written

The repository rollback uses `git checkout -- <paths>`. After T7 is committed, `HEAD` contains the T7 versions, so this command restores the candidate, not blobs `45f52ab4...` and `7e4af793...`. Before commit, it also destroys overlapping uncommitted edits. It therefore does not demonstrate restoration of the recorded prior state.

The machine-wide rollback uses unconditional `rm -f`. That can silently delete a file another actor or the operator changed after T7 landed, and it follows neither the physical-path nor byte-identity guard that this machine-wide surface requires.

Required rollback contract:

- **repository after commit:** Claude performs a normal `git revert` of the exact T7 commit, then verifies the two original blob identities and the suite; before commit, use the verified reverse of the exact patch only after confirming the candidate blobs and no overlapping edits;
- **external file:** before removal, resolve the physical directory again, require a regular non-symlink file at the exact path, require its sha256 to equal the final candidate bytes, and require `default.rules` to retain `47532190...`; any mismatch stops and preserves the file for operator inspection;
- **pre-write:** immediately before creation, re-resolve the physical directory and require the destination still absent; create without overwrite, verify exact bytes/mode/owner, and stop/roll back on any partial failure.

### F6. Machine-wide blast-radius and observability text needs precision

The dedicated file affects every Codex invocation on this host that uses the same `CODEX_HOME`, follows the default user-rules loader contract, and does not opt out. It does not literally prompt every act of launching or using Codex. The carrier neither selects the rules path nor reports whether it loaded. `nested=` remains observation of processes in one process group/window and does not prove the requested rule was active or that no alternate route existed.

Correct the risk inventory and launch text to state these limits. The dispatcher's separate Codex launch remains an explicitly out-of-scope deferral, not a T7 defect.

## Exact bounded remedy before another review

1. Obtain the operator's explicit decision on the measured `codex --version` allow-to-prompt interference. If rejected, stop and amend/reapprove the mechanism before drafting another candidate.
2. If accepted, record that exact residual limitation and revise only the same three T7 surfaces: the dedicated machine-wide rules file, the Codex-related carrier help/launch lines, and the carrier test.
3. Correct F1–F6 without touching the Claude branch, skill, command, core, dispatcher, proposal, plan, state contract, or deferred containment work.
4. Return a new complete candidate with exact prior/final identities, fail-closed pre-write and rollback steps, and two unified diffs proven by `git apply --check`.
5. Re-run one fresh risk-aware review of that corrected exact candidate before implementation. This review cannot pass a candidate that has not yet been written and whose operator-owned risk choice is unresolved.

## Evidence reproduced in this review

- Actual carrier default binary: `codex-cli 0.147.0-alpha.6.5`; PATH binary: `codex-cli 0.147.0`.
- Actual default carrier binary, static only:
  - direct `claude` candidate rule → `decision: prompt`;
  - direct `codex exec x` candidate rule → `decision: prompt`;
  - `-c approval_policy=never` → `approval policy Never`;
  - `bash -lc`, `env`, and absolute-path checks → no match under the static check shape used;
  - existing `codex --version` allow plus candidate `codex` prompt → effective `prompt`;
  - `codex exec --help` documents default user/project `.rules` loading by defining `--ignore-rules` as the opt-out.
- Existing `default.rules`: sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`; its `codex --version` allow is the rule displaced by strictest-match evaluation.
- Both candidate patch blocks failed `git apply --check` without changing the worktree.

