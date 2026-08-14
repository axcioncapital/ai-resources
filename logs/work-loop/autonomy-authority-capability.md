---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Bring `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` to content-bound approval, then progress through bounded units until the approved capability is implemented and verified.

The operator wants the proposal implemented after readiness/QC. `/implementation-triage` remains explicitly excluded as evidence, authority, or a route for this task.

## Lane and unit
Standard. Implementation mode. Unit 2 — revise the proposal to resolve the five accepted readiness findings and accurately encode the operator's three decisions.

Named reason for the loop: the proposal spans semantic policy, agent adapters, capability enforcement, carrier behavior, and evaluation, so its scope must remain bounded across sessions and each consequential result must be assessed independently from the actor that implements it.

## Brief
Unit 1 established `REVISE BEFORE APPROVAL`, and Codex accepted its risk-aware evidence at discovery commit `0367759a8fa0a9cac737911a4ccf4b4bd6e3276c`. On 2026-08-14 the operator answered `approved all three`, binding to the three recommendations recorded in the Unit 1 handoff; this clears the proposal revision now, but does not approve the materially revised proposal content or authorize target implementation. This unit aligns with the approved direction by making that one proposal honest and approval-ready before any executable policy, adapter, permission, carrier, or evaluation change is framed.

Governing operator decisions:

1. Approve the seven-part direction in proposal §15 subject to F1–F5 being corrected; this authorizes revision and planning, not implementation.
2. The intended formal-authority outcome is an identifiable approved executable-core revision that becomes canonical, while `work-loop-v2-mvp-proposal-v0.4.md` becomes historical rationale and the core's current `Proposal wins` line is replaced.
3. Retain `docs/autonomy-rules.md`'s audit-derived harness-configuration confirmation and the audit-discipline no-self-waiver rule for the MVP. The proposal may evaluate whether they create unnecessary interruption, but may not remove them without later evidence and operator authority.

Required outcome: revise only `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` so F1–F5 are materially resolved, its status accurately records the limited direction approval above, and it is ready for a fresh content-bound operator approval decision. Preserve one proposal rather than creating a second version or companion plan.

Check before editing:

- Verify the proposal working copy still matches the content reviewed in Unit 1 or identify the intervening diff and hand back; settle this with `git diff 2aa8474252c7793da70d723a370046d463d76161 -- <proposal path>` and the proposal's current status line.
- Re-open the exact current text that produced F1–F5: core authority and proposal §14 steps 1–3; proposal §§9, 11 and §14 step 6; proposal §§2, 12 and §14 step 8; proposal §6 and §14 step 3 against the retained incident-derived rules; and proposal §15's high-consequence list. If a premise is no longer true, stop rather than silently changing the frozen finding.

Required proposal corrections:

1. **F1 — formal authority.** Make §14's first steps explicitly produce the approved outcome: the executable core is revised and approved at an identifiable commit as canonical; its current subordination line is replaced; proposal v0.4 is retained as historical rationale rather than live overriding authority. Do not claim this has already happened.
2. **F2 — enforcement surfaces.** Reconcile §§9, 11 and §14 step 6 with repository reality by naming both the attended one-hop carrier and the dispatcher/contained profile, allocating only the enforcement responsibilities each can actually host. Preserve the current prohibition on claiming unattended safety while descendant containment blockers remain.
3. **F3 — evaluation reality and cost.** Replace claims that an existing runner/path already exists with the two mechanisms that actually exist: deterministic textual/controller checks for their layer and paired live behavioural trials for semantic behaviour. State the paired-trial cost and keep runner implementation/authorization as future work rather than an accomplished prerequisite.
4. **F4 — incident-derived safeguards.** Reconcile §§6 and 14 without removing or weakening the audit-derived harness-configuration confirmation or the audit-discipline no-self-waiver rule. Distinguish the already-compatible structural-class risk-aware review from the retained class-keyed operator confirmation, and make any future removal evidence-dependent and operator-owned.
5. **F5 — blast-radius disclosure.** Add `docs/autonomy-rules.md` and workspace `CLAUDE.md` cross-cutting edits to §15's high-consequence list and require their proportional pre-implementation review.

Status/authority constraint: record that the operator approved the seven-part direction on 2026-08-14 subject to F1–F5, and that the revised content still awaits content-bound approval. Keep `No implementation authorized` true. Do not imply that approval attached to the original commit automatically attaches to this material revision.

Scope: the proposal and this state file only. Excluded: the executable core, proposal v0.4, Codex/Claude adapters, `docs/autonomy-rules.md`, `docs/audit-discipline.md`, workspace `CLAUDE.md`, settings, permissions, hooks, carrier/dispatcher code, evaluation artifacts, logs other than this state file, and every actual capability implementation. These exclusions are Codex's framing decision because this unit's single deliverable is an approval-ready proposal revision; mixing target implementation into it would evade the required content approval.

Required fail-capable evidence:

- Before/after mapping for F1–F5: quote or precisely identify the failing current section, identify the revised section, and state how the new text removes the concrete consequence Unit 1 found.
- A targeted contradiction check whose failure condition is explicit: no remaining proposal statement may (a) leave proposal v0.4 overriding the future canonical core, (b) assign containment/network enforcement solely to `carry-turn.sh`, (c) claim the behavioural eval runner/path is already implemented, (d) authorize bypass of the retained incident-derived rules, or (e) omit the two cross-cutting governance surfaces from the high-consequence disclosure.
- Verify every relative Markdown link in the proposal resolves after editing, and report the command/result.
- Run `git diff --check` and report the result.
- Report `git diff --name-only` and show that only the proposal and this state file changed for the unit. If an unrelated pre-existing change exists, distinguish it rather than absorbing it.

There is no meaningful automated regression test for a proposal-only semantic revision. The regression protection is the five-item before/after mapping plus the contradiction and link checks above; inventing a test that only greps terms supplied by this brief would not be fail-capable evidence.

Completion condition: revise the proposal, record the result and evidence in this state file, set `turn: codex`, commit the proposal and state-file handback, and stop. Do not begin any proposal §14 implementation step.

Stop conditions: hand back if the proposal changed materially after Unit 1; if resolving a finding requires an operator decision beyond the three approved decisions; if a correction would touch an excluded file; or if any F1–F5 consequence cannot be removed without changing the approved seven-part direction. Challenge a false premise or stale direction rather than improvising.

## Latest result

### Correction round (frozen findings 1–2)

Reproduced by inspection before correcting:
- Finding 1 reproduced: HOLDS — pre-correction §9 named the dispatcher's contained profile as a co-host of §11's requirements for "the two enforcement surfaces named in §9", and §11's sandbox/network bullets were tagged "(dispatcher's contained profile, where selected)" as if selectable within the same attended MVP list; §14 step 6 said to "use the dispatcher's contained `--unattended` profile only for the sandbox/network items the carrier cannot host" — treating an unattended-only program as a composable add-on to attended Standard turns, which is the mode-mixing the finding names.
- Finding 2 reproduced: HOLDS — the prior state-file evidence's contradiction check (b) tested only "does the text name both surfaces," not whether their operating modes are compatible, and carved §15 item 5 out of the check ("outside F2's named scope") even though item 5 is part of the seven approval decisions and still asserts the carrier is *the* Standard enforcement surface.

Correction applied, scoped to the proposal only:
- §9 "Current release posture" rewritten: the carrier is stated as the sole Standard enforcement surface (matching §15 item 5 without qualifying it); the carrier's refusal of `--sandbox`/`--contained`/`--unattended` is named as a real unclosed gap in per-invocation sandbox/network enforcement; the dispatcher's contained profile is described as a structurally separate program for a structurally separate operator-presence condition — evidence that containment is buildable, not a second live surface an attended turn can invoke. No implementation mechanism is prescribed; the gap and the connected-development trial are instead deferred out of the MVP sequence.
- §11 "MVP enforcement" rewritten to match: sandbox/network bullets are marked "target for the carrier; not enforced today — deferred," not attributed to the dispatcher. The connected-development-profile paragraph now states its trial is deferred until the carrier itself enforces sandbox/network restriction. The "Later only after evidence" bullet's "beyond the one narrow MVP trial" (which presupposed the trial ran in MVP) is corrected to "beyond the one narrow connected-development trial, once that trial runs."
- §14 step 4 rewritten: defines the baseline capability envelope only; states the connected-development profile is deferred and that this sequence does not yet schedule the carrier-side enforcement it needs.
- §14 step 6 rewritten: the carrier is "the sole Standard enforcement surface"; its sandbox/network gap and the connected-development trial are deferred out of MVP scope rather than routed through the dispatcher, which is named explicitly as "a different program for a different operator-presence condition" that "cannot supply controls to an attended turn."
- §15 item 5 was not edited — after the above, its existing text is accurate rather than contradicted, so no change was needed there; the closure check below verifies this rather than assuming it.

Closure-check evidence, testing mode compatibility and the full §15 text (not mere co-presence of both surface names):
- No remaining sentence states or implies the dispatcher's `--unattended` profile is invoked by, selectable within, or supplies enforcement to an attended Standard turn: `grep -n "dispatch" plans/.../work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` (4 hits — §9 twice, §11's nested-actor bullet, §14 step 6) — each hit explicitly states the dispatcher is a separate program for a separate operator-presence condition, not a co-host; none pairs "dispatcher" with "attended" as compatible.
- §15's full text (not the single item 5 line) re-read end to end: items 1–7 and the closing paragraph are consistent with the corrected §9/§11/§14 — item 5's "the carrier is the Standard enforcement surface" now matches §9's "it is the *only* Standard enforcement surface" exactly, and item 6 ("pre-authorized capability profiles are part of the strategic model... MVP implements only the smallest baseline") is consistent with deferring the connected-development trial rather than claiming the MVP already runs it.
- F1, F3, F4, F5's prior resolutions re-verified unchanged: "Proposal wins" appears only in §14 step 1 (quoting the clause being replaced); no "already provides the intended runner" / "existing evaluation path" phrasing found; the no-self-waiver/audit-derived-harness-configuration carve-outs are intact in §6 and §14 step 3; §15's closing paragraph still names `docs/autonomy-rules.md` and workspace `CLAUDE.md`.
- All 7 relative Markdown links still resolve (re-run after the correction edits).
- `git diff --check`: exit 0, no output.
- `git diff --name-only` before this commit: `logs/friction-log.md` (excluded, same automatic Write Activity tracker as the prior handback — not part of this unit), `logs/work-loop/autonomy-authority-capability.md`, and the proposal file. No other file changed.

Both frozen findings are resolved; the correction did not break F1, F3, F4, or F5, any link, the status/authority statement, or the proposal/state-file scope boundary.

### Prior unit result (unchanged by this correction; retained for context)

Inspected (2026-08-14):
- Check-before-editing (1) — proposal working copy still matches the content reviewed in Unit 1: HOLDS — `git diff 2aa8474252c7793da70d723a370046d463d76161 -- plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` returned empty before any edit in this unit, and the pre-edit status line read "Proposal for operator approval. No implementation is authorized by this document." — the exact text Unit 1 quoted. No intervening diff exists.
- Check-before-editing (2) — the exact current text that produced F1–F5 is unchanged since Unit 1: HOLDS — re-read core `:3` ("draft for operator approval") and `:9-10` ("Where this file and the Proposal disagree, the Proposal wins"); proposal §14 steps 1–3; §§9, 11 and §14 step 6; §§2, 12 and §14 step 8; §6's "may modify autonomously" bullet against `docs/autonomy-rules.md:18-19` and `docs/audit-discipline.md`'s no-self-waiver rule; and §15's closing paragraph. Every passage matched what Unit 1 quoted verbatim before this unit's edits began.

Result: revised `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` to resolve F1–F5 and record the limited direction approval. Status line (top of file) now states the operator approved §15's seven-part direction on 2026-08-14 subject to F1–F5, that this revision resolves F1–F5, that the revised content awaits its own fresh content-bound approval, and that no implementation is authorized. `No implementation authorized` remains true throughout. No file outside the proposal and this state file was edited; §14 step 1 explicitly does not claim the core revision has happened.

Evidence — before/after mapping for F1–F5:

- **F1 (formal authority).** Before: §14 steps 1–2 said "resolve and approve the executable core's formal authority" without naming what change that requires; the core's `:9-10` subordination line stood unaddressed. After (§14 step 1): "replace its `:9-10` … line, and record `work-loop-v2-mvp-proposal-v0.4.md` as historical rationale … Obtain operator approval of that revision at an identifiable commit — that approval is what makes the core canonical; it has not happened yet." The concrete consequence Unit 1 found (a governing clause that loses to v0.4 on the day it lands) is removed because the subordination line is now named for replacement before or with that approval, and the "has not happened yet" clause blocks any reading that this already occurred.
- **F2 (enforcement surfaces).** Before: §9's "Current release posture" and §11's "MVP enforcement" named only `carry-turn.sh`; `dispatch.sh --unattended` appeared nowhere in the proposal. After: §9 names both surfaces and allocates identity/path/timeout/terminal-evidence to the carrier and per-invocation sandbox/network restriction to the dispatcher's contained profile, preserving "may not be claimed as a safe unattended release surface" while descendant containment is incomplete; §11's enforcement list is tagged per item to the surface that hosts it; §14 step 6 states the same split. The consequence Unit 1 found (half the MVP enforcement list has no home in the named surface) is removed because that surface is now named.
- **F3 (evaluation reality and cost).** Before: §2 said the evaluation proposal "already provides the intended runner"; §12 said to "extend the existing evaluation path"; §14 step 8 said to add scenarios "to the existing evaluation path." After: §2 and §12 both state no runner exists, name the two real mechanisms (`logs/scripts/work-loop-v2-slice-1.test.sh` for textual/controller checks, the `eval-v0-3-restart` paired-live-trial shape for semantic behavior), and §12 states the ~twelve-paired-trial cost explicitly; §14 step 8 says scenarios run as paired live trials and that a runner is separate future work. The consequence Unit 1 found (§14 step 8 has no executable home and the cost is unstated) is removed.
- **F4 (incident-derived safeguards).** Before: §14 step 3 said "remove conflicting implications" without naming what must survive; §6 authorized CI/config changes with no carve-out for audit-derived harness-configuration changes. After: §14 step 3 names `docs/autonomy-rules.md:18` and the no-self-waiver rule as retained, distinguishes the already-compatible `:19` structural-class review as the reconciliation target, and requires new evidence and operator authority for any future removal; §6's bullet excludes audit-derived harness-configuration changes and other structural change classes from the autonomous-modify grant. The consequence Unit 1 found (a rollback of an incident-derived rule presented as reconciliation) is removed.
- **F5 (blast-radius disclosure).** Before: §15's closing paragraph named "the executable core, permissions, hooks, or carrier" only. After: it adds `docs/autonomy-rules.md` and workspace `CLAUDE.md`, with a clause requiring review "proportionally to its blast radius" and naming their cross-cutting reach. The consequence Unit 1 found (the widest-reaching edit in the sequence omitted from its own high-consequence list) is removed.

Evidence — targeted contradiction check (failure condition explicit, checked by re-reading the revised text rather than by keyword match alone):
- (a) No remaining statement leaves proposal v0.4 overriding the future canonical core: §14 step 1 is the only place "Proposal wins" now appears, and it appears as the clause being replaced, with the replacement and the operator-approval requirement stated in the same sentence — pass.
- (b) No remaining statement assigns containment/network enforcement solely to `carry-turn.sh`: every §9/§11/§14-step-6 passage that names the carrier now also names the dispatcher's contained profile as the surface for sandbox/network items — pass. (§3.2's and §15 item 5's pre-existing generic uses of "the carrier" are unchanged, outside F2's named scope of §§9, 11 and §14 step 6, and do not themselves claim sole enforcement.)
- (c) No remaining statement claims the behavioural eval runner/path is already implemented: `grep -n -i "already provides the intended runner\|existing evaluation path\b"` returns no match — pass.
- (d) No remaining statement authorizes bypass of the retained incident-derived rules: §14 step 3 and §6 both name the retained rules and exclude them from the reconciliation/autonomous-modify grant — pass.
- (e) The high-consequence disclosure no longer omits the two cross-cutting governance surfaces: §15's closing paragraph now names both — pass.

Evidence — link check: all 7 relative Markdown links in the proposal resolved with `[ -e ]` against the file's own directory after editing (`../../docs/autonomy-rules.md`, `../../docs/qc-independence.md`, `../../scripts/axcion-harness-v0.2/carry-turn.sh`, `../axcion-harness-v0.2/mvp-plan.md`, `../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, `context-engineering-spec-v0.1.md`, `eval-mvp-proposal-v0.2.md`).

Evidence — `git diff --check`: exit 0, no output (no whitespace errors).

Evidence — `git diff --name-only` before this commit: `logs/friction-log.md`, `logs/work-loop/autonomy-authority-capability.md`, `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`. `logs/friction-log.md` is distinguished, not absorbed: it is the session's automatic Write Activity tracker (`docs/session-guardrails.md`); it was already modified before this unit started (two pre-existing entries timestamped 12:31/12:33, unrelated to this unit), and Unit 1's own commit `0367759a` did not include it despite that unit also writing files — the established pattern is that this tracker rides outside Work Loop commits. This unit's edits appended eight more auto-generated entries to it as a side effect of editing the proposal; it is excluded from this commit's pathspec.

## Blocker
None.

## Next action
Codex: closure check on frozen findings 1–2 only. Confirm (a) whether both are resolved — §9/§11/§14 now state the carrier as the sole Standard enforcement surface with an explicit, unclosed sandbox/network gap, the dispatcher named only as a structurally separate program that cannot supply controls to an attended turn, and the connected-development trial deferred out of MVP scope; and (b) whether the correction broke F1, F3, F4, F5, any link, the status/authority statement, or the proposal/state-file scope boundary — none did, per the evidence above. Decide close, a further bounded step under the § 3 menu, or reframe.
