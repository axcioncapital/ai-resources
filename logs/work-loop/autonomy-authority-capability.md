---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 33 correction — resolve the one frozen review finding in the draft T6/T7 plan amendment.

Named reason for the loop: verified repository evidence falsified several approved-plan control and acceptance premises, and the operator has now settled the two risk/authority choices needed to draft one exact replacement before implementation resumes.

## Brief
The operator approved the recommended direction on 2026-08-15: authorize a machine-wide Codex execpolicy rules placement, accept symmetric direct-route refusal-request plus process observation as satisfying proposal § 14 item 7 for this MVP, record shell-wrapper evasion as an accepted limitation, and keep full descendant containment deferred. This approval settles direction and residual-risk authority; it is not yet content-bound approval of amended plan prose.

Unit 31 proved `RESULT denials=` measures child-reported permission denials, not requested rules. Unit 32 proved the actor paths differ: Claude receives mandatory `--disallowedTools` nested-actor rules but no sandbox; Codex receives `--sandbox workspace-write` but no deny request; observation is symmetric; execpolicy supports `prompt` but not `deny`; a non-self-bypassable rules file must be machine-wide; direct commands match while wrapper routes such as `bash -lc` evade static matching. Preserve these distinctions exactly and do not round a requested or observed control up to prevented.

Required outcome: amend only the implementation plan so it becomes one coherent draft reflecting the verified facts and the operator's decision. Do not implement T6/T7, edit the proposal, or touch runtime/config/test/skill targets. The amendment must cover all of these surfaces in one pass:

1. Change the plan status/readiness to **Draft — bounded T6/T7 evidence-and-control amendment**, recording the prior approved content identity, the operator's approved direction, the verified cause, and the remaining gates: fresh bounded review, correction if needed, then content-bound operator approval.
2. In § 3.4, split sandbox/network truth by actor: attended Claude hops have no sandbox/network containment; Codex hops request `workspace-write` with restricted network; neither is a carrier-selected or carrier-verified capability profile, and connected-development/full descendant containment remain deferred.
3. In § 3.4's nested-actor row, state Claude gets mandatory direct-route refusal requests plus observation; Codex currently gets observation only. Replace the false symmetric-prevention claim with the operator-approved target: machine-wide `prompt` rules plus a Codex-hop approval policy that cannot grant them, symmetric direct-route request/observation, and the explicit wrapper-evasion limitation.
4. In § 3.4's baseline-deny row, scope `--claude-deny` to Claude hops. Make recorded per-argument argv the fail-capable evidence that rules were requested. State `denials=` only for its true meaning: whether child permission-denial evidence was readable and what it contained.
5. In § 3.4's enforced/requested and failure language, remove every actor-generic overclaim while keeping the envelope's three sets and current empty pre-authorized set unchanged.
6. In T6, make the documented baseline map actor-specific; replace verification (e) with safe non-nested paired argv evidence; keep `denials=` only as runtime observation; scope deferred profile language correctly; retain documentation-only scope and its normal/consequential Codex review.
7. Convert T7 from evidence-recording to implementation. Its bounded outcome is the operator-approved machine-wide execpolicy `prompt` rules for direct `claude`/`codex` commands, a Codex carrier launch policy that cannot approve them, symmetric observation retained, exact tests/evidence for requested policy, and the wrapper/descendant-containment limitation recorded. Its review row becomes high-consequence/risk-aware because it changes a permission surface, machine-wide configuration and carrier runtime behavior.
8. Specify T7 honestly: static direct-match evidence plus carrier argv/config evidence may prove policy was requested; they do not prove wrapper-proof prevention. Any live-runtime behavior not yet observed is labelled unverified rather than claimed. Scope must identify the repository targets and the operator-authorized external `~/.codex/rules/` surface, with rollback evidence.
9. Correct T8 S5 so success is the exact capability named, withheld subset visible, no bypass/effect, and correct handback — not `denials=` claiming a restriction was in force. Name the actor path for each leg.
10. Correct T8 S9 so recorded argv/config proves the rule/request was present, child denial evidence proves only an attempted action was refused when such an attempt occurs, no-forbidden-effect evidence remains mandatory, and the semantic leg remains separately required. Name the actor path for each leg.
11. Update traceability/internal-consistency/status statements affected by T7's new shape and review tier, without renumbering tracers or changing T1–T5, the T6 shape, T8/T9 strict exits, the envelope, or deferred descendant containment.
12. Explicitly disposition proposal line 378 as a verified false factual premise superseded by repository evidence while preserving proposal § 14 item 7 as the governing outcome interpreted by the operator's current decision. Do not edit or silently rewrite the approved proposal blob.

Scope: `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md` and this state handback only. Excluded: proposal, core, skills, commands, carrier, tests, user Codex configuration, T6/T7 implementation, scenarios, and unrelated `logs/friction-log.md` changes.

Claims to verify before editing:

- The live plan still has the eleven invalid surfaces inventoried by Unit 32 and no later commit has corrected them.
- The operator-approved direction above is sufficient to resolve every material choice in the amendment without inventing further intent.
- No plan occurrence inside the named § 3.4/T6/T7/T8/status/traceability boundary would remain contradictory after the amendment.

Required evidence: show a bounded diff inventory mapping each of the twelve amendment requirements to exact changed plan text; prove no implementation target changed; prove T1–T5 identities/contracts, the three envelope sets, empty pre-authorized set, tracer numbering, T8/T9 strict exits and deferred descendant containment are semantically unchanged; report resulting plan blob/commit. Run deterministic text/consistency checks that fail on the old false `denials=`/symmetric claims and pass on the draft.

Completion condition: the complete amended plan is committed in Draft status, only the plan plus this state handback are committed, `turn: codex`, and Claude stops before any implementation or review. The returned exact content must be ready for one fresh independent bounded review.

Stop conditions: challenge and hand back if another operator decision is needed, a named contradiction cannot be removed without changing the approved direction, runtime design must be invented beyond what Unit 32 established, a target outside scope must change, or any accepted T1–T5 outcome/boundary would move.

## Latest result

Correction round. Frozen finding 1 only. No new work was opened and no other plan semantics were touched.

**Reproduced first, by inspection.** All three overclaims the review named were present in the reviewed blob `51ab5d8899b379b0cc08eadcc83d7c12cbbeb51f`:
- § 3.4 line 964 — "so a matched command **is refused rather than approved**."
- § 3.4 line 968 — "It **blocks** the ordinary direct route on the Codex path."
- T7 *Behaviour* line 1479 — "so a matched command **is refused rather than approved**."

Each asserts the live disposition of a prompt-matched command as fact, while § 3.5 and T7's *What the evidence may and may not claim* bullet both record that same disposition as unverified. The contradiction is real and reproduces exactly where the review placed it.

**Corrected.** Plan blob `51ab5d8899b379b0cc08eadcc83d7c12cbbeb51f` -> **`0fabe8601871c5f7c49ff1e8628d4922c4422ba2`**. All three now state the requested configuration and record the live disposition as unverified. § 3.4's target paragraph and T7's *Behaviour* both say the configuration is the target and that a matched command's live disposition has not been observed; § 3.4's first property now says the mechanism asks of the Codex path what the Claude path already asks of its child, and that what then happens to the direct route is the child's to decide and is not something the carrier observes.

**No live-turn prerequisite was added.** T7's exit condition is unchanged, and T7's *Behaviour* now points at the existing bullet that already states confirming the disposition is *not* a precondition of the tracer. The operator-approved direction, the three envelope sets, T7's scope and review row, and every passed review dimension were left alone.

### Closure check — the two questions, and nothing else

**(1) Are the three overclaims gone?** Yes, by exact string count against the reviewed blob and the corrected file:

| String | Reviewed blob | Corrected |
|---|---|---|
| `is refused rather than approved` | 2 | **0** |
| `It blocks the ordinary direct route on the Codex path` | 1 | **0** |

The replacement language is present at all three sites (`grep -n 'live disposition'` returns 965 and 1482, and the third site is the reworded property bullet at 970-972). The check can fail: restoring any of the three original sentences puts its count back above zero.

**(2) Did the correction break anything that passed?** No.

- **The diff is exactly the three sites.** `diff` against the reviewed blob yields 13 changed-line markers in three hunks, at lines 964, 968-969 and 1479. Nothing else in the file moved.
- **Eleven structural invariants: 11 passed / 0 failed**, unchanged from the reviewed draft — the two per-actor splits, T7's risk-aware review row, the absence of T7's old small/mechanical row, the Draft status line, the intact tracer enumeration, the empty pre-authorized set, the three envelope sets, T8/T9's strict exits, deferred descendant containment, and T6 still documentation-only at its normal/consequential row.
- **The paragraph-scoped claim check is still clean** — 8 paragraphs mention `denials=` and 15 mention symmetry, all corrective, 0 violations. It fails on the pre-amendment blob, so it remains fail-capable.
- **No implementation target moved.** All seven compared byte-for-byte against `HEAD` and matched: core `fb0ba8b6`, skill `b21cf350`, autonomy-rules `cd74f214`, session-plan `bfca768a`, carrier `45f52ab4`, carrier tests `7e4af793`, approved proposal `e2a50c5e`.

### Noticed during the closure check — recorded as a candidate deferral, not corrected

§ 3.4's **Claude-hop** nested row still says the mandatory rules "block the ordinary direct route". That is the same claim shape as frozen finding 1, but about the already-shipped Claude path, and it quotes the carrier's own wording at `carry-turn.sh:102-108` ("They block the DEFAULT DIRECT ROUTE"). The review named three sites and this was not among them, so it stays unchanged. Whether the plan should mirror the carrier's phrasing here or hold the stricter requested-only line everywhere is a judgment for Codex; it does not affect the Codex path, T7's outcome, or the evidence contract.

Also carried forward, still not done: `logs/friction-log.md`'s uncommitted insertions, untouched by this unit, and the routing-index/live-installation suite failure.

## Blocker

None.

## Next action

Codex: run the closure check on frozen finding 1 only — are the three overclaims resolved, and did the correction break anything. The corrected plan is blob `0fabe8601871c5f7c49ff1e8628d4922c4422ba2`; the review notes are committed at `plans/work-loop-v2-v0.2/working/t6-t7-amendment-review-2026-08-15.md`. One item is recorded above as a candidate deferral and was deliberately not corrected: § 3.4's Claude-hop row still says the mandatory rules "block the ordinary direct route", quoting the carrier's own wording, and the review did not name it. Per the review's own check 10, this correction was narrow and changed neither T7's outcome nor its evidence contract, so it should need no second broad review. After closure, the amended content needs the operator's content-bound approval before T6 may begin. T6 and T7 remain unimplemented.
