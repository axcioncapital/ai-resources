# T6/T7 amendment review — 2026-08-15

## Review identity

- Verdict: **REVISE**
- Reviewed commit: `18b6aae1aa79fe50f47d9e2d6284051c386d652c`
- Reviewed plan blob: `51ab5d8899b379b0cc08eadcc83d7c12cbbeb51f` (recomputed from the commit and matched)
- Review type: fresh, isolated, bounded content review; no implementation target or Git state changed
- Governing operator decision: machine-wide `~/.codex/rules/` placement authorized; symmetric direct-route refusal-request plus symmetric process observation accepted as proposal §14 item 7 for the MVP; shell-wrapper evasion accepted; full descendant containment deferred

## Sources inspected

- The exact amended plan at the commit/blob above and its parent diff.
- `logs/work-loop/autonomy-authority-capability.md` at commits `44d1582e` (Unit 31), `ee83353b` (Unit 32), and `18b6aae1` (Unit 33).
- Approved proposal `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`, blob `e2a50c5e6e82482ed81a37000ac927af4f5bc672`, especially §§7, 11, and 14 item 7.
- Live `scripts/axcion-harness-v0.2/carry-turn.sh` and its test assertions around actor argv, mandatory Claude denies, sandbox request, `denials=`, and nested-process observation.
- Local Codex CLI `0.147.0-alpha.6.5`: `exec --help`, `doctor`, `doctor` with `approval_policy=never`, and non-model `execpolicy check` against the existing user rules plus the proposed prompt prefixes.

No Claude or Codex model session was launched. The CLI checks were static/configuration checks only.

## Material finding

### F1 — The plan claims Codex live refusal behavior that it simultaneously and correctly labels unverified

The amendment is built around the operator-approved, deliberately narrower outcome of **request plus observation**, and most of it preserves that ceiling correctly. Three statements exceed it:

1. §3.4 line 964: a matched command “is refused rather than approved.”
2. §3.4 line 968: the Codex target “blocks the ordinary direct route.”
3. T7 Behaviour line 1479: with an ungrantable policy “a matched command is refused rather than approved.”

Those are claims about the live disposition of a prompt-matched tool request. But §3.5 lines 1051–1055 and T7 lines 1490–1495 explicitly say the available evidence proves only that the policy was **requested**, and that live-runtime refusal under the ungrantable approval policy remains unverified until observed. Unit 32 states the same boundary: `approval_policy=never` is accepted by configuration and relevant block/error strings exist, but whether a live exec hop reports or handles the prompt match as a block was not established without a live model turn.

This is material because T7's exit permits landing without that live observation. The plan would therefore allow completion while continuing to state as fact a behavior its own evidence contract does not prove. That violates the amendment's central “do not round requested up to prevented” rule and review requirement (5).

**Bounded correction:** in the §3.4 target and T7 Behaviour, state only that the rules request `prompt` and the carrier pins an approval policy that cannot grant it; keep the live disposition explicitly unverified. Replace “blocks/refused” claims with the already-approved “direct-route refusal-request” / “requested restriction” language. Do not add a live-turn prerequisite, because the review brief expressly says that would be a scope question and the operator approved the narrower MVP outcome.

## Required review checks

1. **Thirteen amended surfaces:** the disclosed carrier-row addition and status-currency corrections are present and necessary to prevent direct contradictions. The changed regions otherwise reconcile §3.4, §3.5, T6, T7, S5/S9, traceability, internal consistency, and both status records. F1 is the only remaining internal contradiction found.
2. **Actor-specific control truth:** current-state descriptions are accurate: Claude has permission policy, mandatory direct-route deny requests, no sandbox, and observation; Codex requests `workspace-write`, has no current deny request, and shares observation. Network/sandbox claims are scoped as carrier-selected/verified versus child/runtime facts. F1 concerns only the proposed Codex live refusal result.
3. **`denials=` evidence:** every live use is corrective or limited to child-reported `permission_denials`. Requested rules are proved through per-argument argv/configuration. S5/S9 do not misuse `denials=`.
4. **T6:** remains documentation-only, skill-only, normal/consequential review. Its three-set envelope, empty pre-authorized set, actor-scoped control map, paired non-nested fake-binary argv proof, and requested-not-effective wording are implementable and fail-capable.
5. **T7 scope/risk/reversibility:** correctly includes the machine-wide rules surface, Codex carrier branch, and carrier tests; excludes Claude/core/skill/state/dispatcher changes; requires a risk-aware review before implementation; retains exact rollback evidence. Static policy checks have positive and negative legs. The existing `allow ["codex","--version"]` rule does not defeat a new `prompt ["codex"]` prefix: the checker returns the stronger `prompt` decision when both match. `approval_policy=never` is accepted and reported as `Never` by `codex doctor`. Neither fact proves live matched-command behavior, which is why F1 remains.
6. **T8 S5/S9:** both rows name the Claude path, make argv/configuration fail-capable, require a clean repository/effect outcome, and keep semantic and mechanical legs distinct. Their exits are adequate.
7. **Proposal false premise:** proposal line 378 is dispositioned as superseded factual context without editing the approved blob or weakening §14 item 7. The operator's current interpretation is stated explicitly.
8. **Preserved invariants:** T1–T5 execution contracts were not changed by the amendment; the three capability-envelope sets and empty pre-authorized set remain; tracer names/order are unchanged; T8/T9 strict exits, S4/S8 blocked limitation, and descendant-containment deferral remain.
9. **Disclosed additions:** correcting the Repository Delta carrier row is required because otherwise it would contradict rewritten §3.5/T7. Updating the two status records to show T3a/T4/T5 landed is a necessary currency correction, not scope drift.
10. **Approval readiness:** **not ready for content-bound operator approval until F1 is corrected.** The correction is narrow and should need a closure check against F1 only, not another broad review, unless the correction changes T7's outcome or evidence contract.

## Non-findings / boundaries

- I did not require live prompt-plus-never verification before T7 lands; the brief explicitly reserves that as a scope choice, and the operator approved request plus observation for the MVP.
- I did not require full wrapper or descendant containment; both remain explicitly accepted/deferred.
- The exact external rules filename can be fixed in T7's exact pre-implementation candidate and risk-aware review. The plan already fixes the authorized directory, control shape, blast radius, rollback duty, and repository surfaces.
