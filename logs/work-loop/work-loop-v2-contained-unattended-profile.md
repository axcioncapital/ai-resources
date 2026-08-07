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
**This invocation was the protocol's final tightly bounded fix** (core § 3, *If the correction was
not enough*) — Codex's menu choice after accepting findings 1, 2 and 4 and finding 3 not fully
resolved. Documentation only. The three named plan edits were made and nothing else was touched.

**Where the unit stands.** 1d is built, measured live, and complete. The two remaining Phase 2
blockers are 1a (escaped descendants survive the stop) and 1f (branch/worktree isolation unproven).
Phase 2 remains forbidden. Codex's independent checks confirmed the `system/init` evidence and its
control sound, the raw capture complete at 21/0, the real lock and probe artifacts absent, the
shipping suite at 284/0, and the pre-1d pair at 216/24 on the same current test file.

Result: the three stale statements in `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` are
corrected. The plan no longer contradicts its own status block or the accepted evidence.

Evidence — the three corrected passages, quoted:

1. **Suite arithmetic** (status block): "*all simulated (149 at `c8b2172`, plus 22 for the 1g
   three-state fix, 27 for the pid-validation correction that followed it, **75** for the 1d
   contained-profile integration, and 11 for the 1d correction of 2026-08-07)*". The stated components
   now add to the stated total: 149 + 22 + 27 + 75 + 11 = **284**. They previously summed to 279.
2. **Open question 1**: "*No longer an open question — and **no longer a blocker at all.** The profile
   was built as `dispatch.sh --unattended` and its effective policy measured from inside a child the
   dispatcher launched (`runs/probe-unattended-integration-2026-08-07.md`, 21/0). 1d is complete. The
   two remaining Phase 2 blockers are **1a** (escaped descendants survive the stop) and **1f**
   (branch/worktree isolation unproven).*"
3. **Final sentence**: "*What is left is unbuilt and unproven work — the **two** Phase 2 blockers —
   not decisions.*"

Evidence — searches of the whole plan file, each returning **0** matches:

- `70 for the 1d` → 0
- `still blocking it` → 0
- `the three Phase 2 blockers` → 0

Evidence — scope held. `git status` across `plans/` and `.agents/` shows exactly two modified files:
this state file and the plan. No code, test, README, `SKILL.md`, run record, raw evidence or phase
gate was touched.

Commit: recorded below in a follow-up commit. The identifier cannot exist inside the commit that
creates it, so it is added afterwards rather than left out or approximated — the same way the two
earlier rounds of this task handled it.

Deferrals — carried forward from the correction round, still recorded and still not done:

- **The declared sandbox write policy does not read like the enforced one.** The policy shown to the
  child lists `**` among write-allowed paths, yet its write outside the checkout was refused.
  Enforcement is the stricter of the two, so the result is the safe one — but the description cannot
  be used to predict behaviour.
- **A refusal cannot be double-checked from inside the child.** Confirming no file was created at a
  denied path requires reading that path, which is itself denied. The probe checks it from outside.
- **The marker vocabulary does not distinguish a sandbox refusal from a permission-layer refusal.**
- **Scope merging remains untested and open.** Array keys such as `allowRead` merge across settings
  scopes, so this measured the containment *this host* produces. Closing it needs managed settings,
  which no dispatcher can set for itself.

## Blocker
None.

## Next action
Codex: the closure check covers **only** the three plan edits above and whether they introduced an
immediate contradiction. Specifically — does the suite arithmetic now add to 284, does open question 1
state 1d complete with 1a and 1f as the two blockers, and does the final sentence say two. Anything
else noticed is a deferral, not a further round.
