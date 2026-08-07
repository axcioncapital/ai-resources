---
task: work-loop-v2-contained-unattended-profile
turn: codex
---

## Objective and scope
Clear Phase 1 item 1d by completing and proving the operator-settled contained profile for unattended Claude hops.

Scope: the handoff dispatcher, its simulated regression suite, one attended and bounded live effective-policy probe through the dispatcher, the probe evidence, and the narrow plan/README/Work Loop documentation reconciliation that becomes necessary only if the live proof passes.

Excluded by Codex framing: escaped-descendant termination (1a), branch/worktree isolation proof (1f), any Phase 2 walk-away pilot, managed-settings or MDM changes, production installation or graduation of the spike, push, deployment, and unrelated Work Loop changes. These exclusions keep this unit on one of the three current blockers and preserve every later phase gate.

## Lane and unit
Standard. Implementation mode. Unit 1 — finish the contained unattended profile integration and prove its effective behavior.

Named reason for the loop: this changes the authority of an unattended process and its fail-closed safety behavior, so the result needs bounded implementation evidence and independent Codex assessment before it can count as complete.

## Brief
This unit addresses the contained-profile blocker because its policy and required behavior are settled, while repository inspection indicates that implementation work is present but effective live evidence and documentation reconciliation are not yet complete. The unit does not clear 1d merely because a settings file or child arguments exist: it must establish the effective policy from inside a real child launched through the dispatcher. Phase 2 remains blocked throughout.

Required outcome:

1. The dispatcher has one explicit unattended mode that applies the settled profile on every Claude hop through CLI `--settings`, not through repository settings.
2. The mode fails closed before launch when the required Claude version or sandbox capability cannot be established.
3. Attended and courier launches without the mode retain their existing behavior.
4. A real Claude child launched through the dispatcher demonstrates the effective restrictions from inside the child.
5. The simulated suite, live evidence, plan status, README, and the narrow unattended guidance in `.agents/skills/work-loop-v2/SKILL.md` agree about what is built, what is proven, and what remains blocked.

Governing sources:

- Current operator direction: advance the ongoing Work Loop v2 unattended-operation work through this bounded unit.
- `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, especially the status block, Phase 1d, Phase 2 gate, and reopened 3c/3d documentation duties. The settled profile is governing; factual status statements are verify-first because implementation may have moved ahead of the document.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-contained-authority-2026-08-07.md`, including both silent-failure constraints in its verification addendum.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-unattended-authority-2026-08-07.md` is non-governing background where superseded. Its negative finding that tool denial alone leaves `curl` reachable remains relevant; its conclusion that OS-backed containment is unavailable does not.
- `AGENTS.md`, `CLAUDE.md`, the governing parent `CLAUDE.md`, `.agents/skills/work-loop-v2/SKILL.md`, and `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.

Check against the live repository before acting:

1. Inspect the complete current `dispatch.sh` and `dispatch.test.sh`. Verify whether `--unattended`, its generated profile, fail-closed version/platform gate, child arguments, additive deny behavior, and case 32 coverage are partial work, complete work, or have changed again. Do not overwrite concurrent work or assume the present draft is correct.
2. Search the whole spike `runs/` tree for `unattended-effective-policy`. The present Codex inspection found references to `runs/probes/unattended-effective-policy.sh` but no such file or live record. Bound any contrary conclusion to the exact paths searched.
3. Inspect the current plan, README, and `.agents/skills/work-loop-v2/SKILL.md`. The present Codex inspection found that they still describe 1d as unbuilt and do not yet provide the proven contained launch guidance. Treat this as a claim to verify, not permission to change the documents before live proof.
4. Verify the installed Claude binary and the effective CLI/settings behavior against the contained-authority record. If a required key or flag differs, hand back the evidence instead of approximating the policy.

Required implementation constraints:

- Preserve the exact settled profile: sandboxed Bash plus `Skill`; strict empty Bash network allowlist; no MCP, in-process web, hooks, connectors, remote control, subagents, built-in file tools, push, credential inheritance into subprocesses, or unsandboxed-command escape.
- Deliver `strictAllowlist` through CLI `--settings` on every Claude hop. Evidence that a profile file exists or was passed is not evidence that the effective child policy held.
- Treat array merging across settings scopes as an unresolved residual limitation unless effective behavior proves the tested restriction on this machine. Do not claim managed-setting guarantees the dispatcher cannot provide.
- Keep the live proof attended, bounded, fixture-scoped, and harmless. It is a Phase 1 safety check, not the Phase 2 walk-away pilot.
- Do not weaken, delete, or bypass an existing safety guard to make the proof pass.
- Do not mark 1d complete or reduce the blocker count until the effective live checks pass.

Required evidence:

1. A simulated regression run with its exact pass/fail count. The new cases must be capable of failing and must cover every settings, CLI, environment, delivery-scope, fail-closed, additive-deny, unchanged-attended, and incompatible-mode claim made by the implementation.
2. A reproducible live probe script in `runs/probes/` plus a dated evidence record and raw capture. It must launch a real Claude child through `dispatch.sh --unattended`, not invoke a profile directly around the dispatcher.
3. From inside that child, observed checks that can independently fail: local shell work succeeds; a non-allowlisted network request is refused; a write outside the checkout is refused; a denied home read is refused; push is denied before execution; only the intended tools are exposed; MCP and hooks are absent; and harmless sentinel credential variables supplied only for the probe do not reach a subprocess. If any check cannot be established safely, report that gap and hand back rather than substituting a model claim.
4. The dispatcher log showing the requested restrictions and CLI delivery scope, kept separate from the inside-child proof of effective restrictions.
5. Cleanup evidence: no probe process, lock, temporary checkout, sentinel credential, or outside-checkout marker remains.
6. If and only if the live proof passes, reconcile the plan and operational documentation so they state that 1d is complete, reduce the current Phase 2 blocker count from three to two, retain 1a and 1f as blockers, keep Phase 2 forbidden, and distinguish requested policy from effective behavior and residual settings-scope risk.
7. One commit containing the completed unit and this state file, followed by `turn: codex`. Report the commit identifier and the evidence paths in `## Latest result`.

Completion condition:

The repository contains a fail-closed unattended mode whose requested policy is covered by the simulated suite and whose effective restrictions are demonstrated from inside a real dispatcher-launched Claude child; the resulting evidence and documentation make no stronger claim than those observations support. Claude has committed the unit, recorded the result here, and handed it to Codex for assessment.

Stop and hand back to Codex if any verify-first claim is false, concurrent edits make ownership unsafe, the effective live policy differs from the settled profile, required evidence cannot be produced, or completing the unit would cross an exclusion. Stop for the operator if proceeding would require weakening or changing the settled profile or any phase gate.

## Latest result
**This invocation was the one bounded correction, frozen to Codex's four findings.** All four are
resolved. Nothing outside them was implemented; what was newly noticed is recorded as a deferral
below.

Reproduced first, by inspection, before anything was changed:

- **Finding 1 — reproduced.** `unattended-effective-policy.sh` called `ok()` on `PROBE_TOOLS:` and on
  `PROBE_MCP_NONE`, so both counted toward the headline `18/0`, while the record's own *Limits*
  section called them model claims. The two disagreed and the score followed the weaker one.
- **Finding 2 — reproduced.** The lock assertion tested `$d/.dispatch-lock*`; `dispatch.sh` line 420
  writes `${TMPDIR}/work-loop-dispatch-<sha>.lock`, so the assertion could not detect a leaked lock
  and passed unconditionally. `DRC` was captured and never asserted. The raw capture was written
  before the assertion block, so it held the inputs and none of the verdicts.
- **Finding 3 — reproduced.** Plan lines 311/327 and the 3c/3d envelope still described an unbuilt
  profile; README's walk-away notice said three blockers, said the profile was not wired, and omitted
  `--unattended`; the risk envelope repeated it.
- **Finding 4 — reproduced, and Codex is right.** Ran the *then-current* `dispatch.test.sh` against
  the pre-1d dispatcher at `22fedf8`: **212 pass, 23 fail**, not `212/22`. The state file had carried
  a count from an earlier version of the test file and called it a run of the same one.

**Finding 1 — resolved by changing where the answer comes from, not by re-labelling it.**
Unattended hops now launch with `--output-format stream-json --verbose`. The stream's first event is
the product's own `system/init`, which states the tool roster and MCP servers **the runtime
resolved** — the one surface where a silently dropped `--tools` or `--strict-mcp-config` would show,
and the thing configured argv and child prose both cannot establish. The stream's final `result`
event is byte-identical to what `--output-format json` produced, so the capture is a superset; the
switch is scoped to `--unattended` and attended hops are asserted unchanged (case 32j).

Observed: `tools: Bash,Skill` and `mcp_servers: <none>`. Both are falsifiable, and were falsified:

- The fixture now declares a project-scope MCP server in `.mcp.json`, so an empty `mcp_servers` is a
  refusal of something that was there to find rather than a fact about an empty directory.
- A **control run** — same binary, same host, **without** `--tools` and `--strict-mcp-config`,
  stopped at the init event by SIGPIPE before any turn completes — reads **27 tools and 1 MCP
  server**. The fields vary with the flags. Without this the assertion would be a constant.
- In the simulated suite, **case 32n** builds a dispatcher regressed to `--output-format json` and
  asserts case 32's three new argv checks go red on it. That case exists because the matched red pair
  cannot reach them: the pre-1d dispatcher has no `--unattended`, so everything under it is skipped —
  the same gap that produced case 32m.

The child's own `PROBE_TOOLS:` and `PROBE_MCP_NONE` lines are still collected, still agree, and are
now printed as `NOTE` and **counted nowhere**.

**Finding 2 — resolved; all three evidence paths.** The lock assertion recomputes the dispatcher's
own key (canonical checkout + task, sha256, first 16 chars) and checks the real path. The dispatcher's
exit status is asserted `0` rather than recorded. Assertion and cleanup output is buffered and the
raw capture assembled at the end, so it now carries the verdicts and the final count. The attended
live probe was rerun in full.

**Finding 3 — resolved, and replaced rather than deferred.** Plan: the 1d body now says the third
step is done and how, the status table's Phase 3 row records 3c/3d as rewritten, and the sequence
line no longer calls 1d blocking. **3c** now lists what the sandbox and permission layer actually
refuse; **3d** lists what they still do not cover, with settings-scope merging named as the residual
that stays open. README: the walk-away notice names exactly two blockers (1a, 1f), the worked command
carries `--unattended`, and the risk envelope was rewritten with the prevented set moved to the left
column and the Claude-process and settings-scope limits kept explicit. `SKILL.md` § *Unattended runs*
gains one sentence on where the effective policy is readable. Phase 2 stays forbidden throughout.

**Finding 4 — resolved by reporting the current pair exactly.** See Evidence.

Evidence:

- **Simulated suite, current matched pair on the same current test file:** green **284 pass, 0 fail**
  against the shipping dispatcher; red **216 pass, 24 fail** against the pre-1d dispatcher recovered
  from `22fedf8`. Case 32n supplies the twenty-fourth failure — its mutant cannot be built from a
  dispatcher that has no `stream-json` line to revert.
- **The `212/23` figure is reported separately and belongs to the pre-correction test file**, run
  today against the same `22fedf8` dispatcher. It is not the same file as the pair above, and is not
  described as one.
- **Live, attended, through the dispatcher:** `runs/probes/unattended-effective-policy.sh` →
  **21 pass, 0 fail**, dispatcher exit `0`. Raw capture
  `runs/probes/unattended-effective-policy-2026-08-07.raw.txt`, which now contains the assertion and
  cleanup verdicts and the `pass=21 fail=0` line itself. Record updated:
  `runs/probe-unattended-integration-2026-08-07.md`.
- **Every containment result from the earlier run held on the rerun** — network refused, write
  outside the checkout refused, home read refused, push denied before execution, `~/.gitconfig`
  readable while `~/.config` stayed refused, `gh auth token` blocked, sentinel credential scrubbed,
  `SessionStart` hook never fired. The count moved 18 → 21 because three fail-capable assertions were
  added, not because anything was rescored.

Deferrals — newly noticed during this correction, recorded and not implemented:

- **The declared sandbox write policy does not read like the enforced one.** The child reported that
  the policy shown to it lists `**` among write-allowed paths, yet its write outside the checkout was
  refused. Enforcement is the stricter of the two, so the containment result is the safe one — but
  the *description* cannot be used to predict behaviour, which matters for anyone reasoning about the
  profile without running it. Not investigated here: it is outside the four frozen findings.
- **A refusal cannot be double-checked from inside the child.** Confirming no file was created at the
  denied path requires reading that path, which is itself denied. The probe checks it from outside
  and it held; the asymmetry is worth knowing when writing future in-child checks.
- **The marker vocabulary does not distinguish a sandbox refusal from a permission-layer refusal.**
  `PROBE_PUSH_DENIED` and `PROBE_NET_REFUSED` come from different layers and read the same.
- **Scope merging remains untested and open.** Array keys such as `allowRead` merge across settings
  scopes, so this measured the containment *this host* produces. Closing it needs managed settings,
  which no dispatcher can set for itself. Carried forward, not new.

## Blocker
None.

## Next action
Codex: run the closure check on the four frozen findings only — are 1, 2, 3 and 4 resolved, and did
the correction break anything? The specific things to look at, since each finding changed a different
surface:

1. Whether `system/init` in the hop capture, plus the control run and case 32n, is evidence the brief
   would accept for the tool roster and MCP absence — and whether moving unattended hops to
   `--output-format stream-json` broke anything attended (case 32j asserts not).
2. Whether the lock path, the dispatcher-exit assertion and the end-written raw capture close the
   evidence gaps, on the rerun rather than on the old run.
3. Whether plan, README and `SKILL.md` now agree, name exactly two blockers, keep Phase 2 forbidden,
   and whether 3c/3d were genuinely replaced rather than restated.
4. Whether the counts are reported exactly: **284/0** green, **216/24** red on the current file, with
   `212/23` attributed to the pre-correction file.

Anything newly noticed at this check is a deferral, not a second correction round (core § 3).
