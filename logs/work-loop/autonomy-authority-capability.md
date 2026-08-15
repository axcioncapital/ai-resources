---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 33 — draft one complete, internally consistent plan amendment for the T6/T7 control-evidence correction.

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

Inspected (2026-08-15):
- Claim (1): HOLDS — the plan is blob `e12970a96325aee50b54be0bd81edc20ef5d9484` live and at `HEAD`, unchanged since Unit 26's re-freeze (`git log -1 -- <plan>` → `db9ff2e9`). All eleven Unit 32 surfaces were still present: `grep -n 'denials='` returned the four false-evidence sites (`:915`, `:1340`, `:1350-1351`, `:1398`, `:1402`) and `grep -n 'symmetric'` returned the three false-symmetry sites (`:914`, `:933`, `:959`) plus the traceability row at `:1484`. No later commit corrected any of them.
- Claim (2): HOLDS — the operator's four recorded decisions (machine-wide placement, direct-route request accepted for §14 item 7, wrapper evasion accepted as a limitation, descendant containment left deferred) resolve every material choice the amendment needed. No further intent had to be invented. Two things that *looked* like choices were settled by evidence rather than preference and are recorded as such: execpolicy's decision set is `allow`/`prompt` only, so `prompt` is not a design option but the only one that parses; and `~/.codex/rules/` is the only non-self-bypassable placement, because a repo-local file is writable by a `workspace-write` child.
- Claim (3): HOLDS **after two disclosed additions** — see below. As briefed, the boundary would have left live contradictions; both are removals of contradiction the amendment itself creates, neither changes the approved direction, and both are named here rather than folded in silently.

**Disclosed additions beyond the briefed boundary.** (a) **A thirteenth surface.** § Repository Delta's carrier nested-actor row read §14 item 7 as "functionally satisfied; only an explicit evidence record is missing" — the same falsified premise, outside the named § 3.4/T6/T7/T8/status/traceability boundary. Left standing it would contradict the rewritten § 3.5 and T7 directly. Corrected. (b) **Currency corrections in the two status records.** Both still described T3a as the nearest unmet tracer awaiting its review, and named the skill at blob `965583db…`. T3a, T4 and T5 have since landed (`7e037662`, `b5d79aa1`, `2a50b321`). Left standing, a plan that says T6 is next would contradict its own readiness record. Corrected, with the superseded readings preserved as history.

Result: the plan is amended and in **Draft — bounded T6/T7 evidence-and-control amendment**. Blob `e12970a96325aee50b54be0bd81edc20ef5d9484` → **`51ab5d8899b379b0cc08eadcc83d7c12cbbeb51f`**, +341 / −115 lines. Thirteen surfaces changed. No implementation target was touched and nothing was built.

### Diff inventory — each briefed requirement to the exact changed text

| # | Requirement | Where it landed |
|---|---|---|
| 1 | Draft status, prior identity, direction, cause, remaining gates | Status block rewritten (`Draft — bounded T6/T7 evidence-and-control amendment, 2026-08-15`), and § Plan-readiness statement rewritten to match. Both carry the prior approved identity `ff1827b4`/`6cda1462`, the two falsified premises as the verified cause, the operator's four decisions, and the three remaining gates in order |
| 2 | § 3.4 sandbox/network split by actor | The two generic "Deferred" rows became four: sandbox and network, each **Claude hop** (deferred; `--permission-mode` is not containment, `:53-54`; `:306-307` refuses `--unattended`) and **Codex hop** (`--sandbox workspace-write` at `:860`; "requested, and neither carrier-selected nor carrier-verified"). A closing paragraph keeps connected-development and full descendant containment deferred |
| 3 | § 3.4 nested row + operator-approved target | One row became two — Claude hop "Requested (direct route) + observed", Codex hop "Observed only — no request of any kind today", each citing the branch that proves it. A new paragraph states the approved target with its four non-negotiable properties: request not prevention, wrapper evasion accepted, execpolicy has no deny, placement machine-wide |
| 4 | § 3.4 baseline-deny row | Retitled "**Claude hop only**", with "this surface exists on the Claude path alone". Evidence is now "the recorded per-argument launch argv, and only that", with `denials=` explicitly excluded and its true meaning stated, citing `read_denials` (`:508-525`) and `R_DENIALS` (`:967-970`) |
| 5 | § 3.4 enforced/requested + failure language | The clause now assigns a verb per control and per path (enforces / detects / observes / requests) and forbids replacing any with "enforces". Failure behavior gained four named failure shapes. **The envelope's three sets and its empty pre-authorized set are untouched** |
| 6 | T6 corrections | Baseline-deny paragraph actor-scoped; verification (d) now requires the actor path; **verification (e) replaced** with the non-nested paired-argv proof via `--claude-bin`, and the superseded `denials=` pairing named as unable to fail; exit condition states the deferred boundary per path. Documentation-only scope, skill-only surface and normal/consequential review row all retained |
| 7 | T7 converted to implementation | Rewritten end to end: behaviour, starting evidence, intended change (external rules file + Codex branch + tests), verification (a)–(f), exit condition, scope boundary, and **review row raised to high-consequence/risk-aware** on three stated grounds. § 3.5 rewritten to match, so tracer and specification agree |
| 8 | T7 honesty | A dedicated "What the evidence may and may not claim" bullet: static match plus argv proves **requested**, not wrapper-proof prevention; unobserved runtime behaviour is recorded **unverified**; scope names the repository targets and the external `~/.codex/rules/` surface; verification (d) records the wrapper cases as unmatched and (f) requires a rollback proof |
| 9 | T8 S5 | Setup names the **Claude actor path** for both legs and says why. Success is the exact capability named, the withheld subset visible in argv, no forbidden effect, correct hand-back. `denials=` explicitly not cited |
| 10 | T8 S9 | Both legs named to the Claude path. Argv/config proves the rule was requested; no-forbidden-effect evidence made mandatory; child denial evidence admissible only for a refused **attempt**, with an empty `denials=` explicitly not a failure of leg B; the semantic leg stays separately required |
| 11 | Traceability, consistency, status | §14 rows for items 4, 6 and 7 corrected; § Internal consistency check gained the T7↔3.5 conversion note, the one external surface and why it is not a new tracer, and the amendment's own thirteen-surface count and boundary. **No tracer renumbered, resequenced or added** |
| 12 | Proposal `:378` disposition | A dedicated paragraph in § Internal consistency check records it as a verified false factual premise, superseded by repository evidence, and states that the approved proposal blob is **not** edited. §14 item 7 is preserved as the governing outcome, interpreted by the operator's decision |

### Evidence

- **No implementation target changed.** `git status --porcelain` shows exactly three files: the plan, this state file, and the pre-existing untouched `logs/friction-log.md`. The seven targets that must not move all hold their `HEAD` blobs — core `fb0ba8b6…`, skill `b21cf350…`, autonomy-rules `cd74f214…`, session-plan `bfca768a…`, carrier `45f52ab4…`, carrier tests `7e4af793…`, **approved proposal `e2a50c5e…`**. The proposal in particular was read and dispositioned, never edited.
- **Two claim shapes are gone from every live paragraph — paragraph-scoped, and it fails on the old blob.** A line-scoped grep is the wrong instrument here: the plan is hard-wrapped, so a corrective clause routinely lands on a different physical line from the term it corrects, and a line check reports corrective prose as a violation. The check therefore splits the file on blank lines and requires **every paragraph mentioning the term to carry a corrective marker**. Against the pre-amendment blob it reports 3 violating paragraphs; against the draft, 0 — 8 paragraphs mention `denials=` and 15 mention symmetry, all corrective. It can fail: reinstating any of the original sentences puts back a paragraph with no marker.
- **Eleven structural checks, all failing on the old blob where they should.** Old: 6 passed / 5 failed. Draft: 11 passed / 0 failed. The five that flip are the two per-actor splits, T7's new review row, the absence of T7's old "small/mechanical" row, and the Draft status line. The six that pass on both are the invariants — tracer set intact, empty pre-authorized set retained, three envelope sets present, T8/T9 strict exits retained, descendant containment still deferred, T6 still documentation-only at its normal/consequential row. Those six are the proof that the amendment did not move what it was told not to move.
- **Semantic invariants, checked individually.** T1–T5 keep their contracts and their landed commit identities (the readiness record now lists all seven landed tracers with commits). The capability envelope's three sets and empty pre-authorized set are byte-unchanged. Tracer numbering is unchanged — no `T10` exists and the `T1, T1a, T2, T3, T3a, T4–T9` enumeration line is intact. T8's and T9's strict exits and the accepted S4/S8 blocked limitation are unchanged. Full descendant containment remains deferred at §14 item 14.

Deferral carried forward, still not done: `logs/friction-log.md`'s uncommitted insertions, unrelated and untouched by this unit; and the routing-index/live-installation suite failure.

## Blocker

None. The draft is complete and ready for one fresh independent bounded review.

## Next action

Codex: assess Unit 33, then dispatch one fresh, isolated bounded review of the amended plan content at blob `51ab5d8899b379b0cc08eadcc83d7c12cbbeb51f`. Two things to weigh when deciding. **First**, two additions beyond the briefed boundary are disclosed above and should be ruled on explicitly: the thirteenth surface (§ Repository Delta's carrier row, which repeated the falsified premise) and the currency corrections in the two status records (which still described T3a as pending and named a stale skill blob). Both remove contradictions the amendment itself would otherwise create; neither changes the approved direction. **Second**, the review should test the one place the draft deliberately declines to be decisive: T7's evidence contract says static matching plus argv proves the policy was *requested* and explicitly records live-runtime refusal as **unverified**, because confirming it needs a live Codex turn. If a reviewer wants that verified before T7 lands, that is a scope decision, not a wording fix. After the review and any bounded correction, the amended content needs the operator's content-bound approval before T6 may begin. T6 and T7 remain unimplemented and nothing was built.
