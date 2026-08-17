# QC memo: proposed post-compaction recovery fix

**Date:** 2026-08-17  
**Scope:** QC of the four-part fix proposed after the immediate context-refill incident  
**Method:** Candidate-falsification against current repository authority and history, the current Codex skill-loading contract, and official OpenAI documentation  
**Implementation changes:** None

## Verdict

**REVISE.** The diagnosis is sound, and the proposed separation of `$reorient` from `$realign` is a good correction. The central optimization — making `$reorient` read only the marker-bounded Work Loop core resolver instead of the complete `work-loop-v2/SKILL.md` — is not safe as written. It conflicts with the current skill-loading contract, contradicts `$reorient`'s explicit authority rule, and omits Work Loop behavior that the executable core does not contain.

The stronger repair is:

1. make `$realign` route immediately to `$reorient` after compaction and end the realignment pass;
2. execute the repository's already-triggered progressive-disclosure split of `work-loop-v2/SKILL.md`, keeping `$reorient`'s full read of the now-smaller main skill plus the full executable core;
3. fix state growth as a behavioral compliance failure, not by adding another copy of the existing prose rule;
4. add a live recovery regression scenario plus static/read-budget checks, while labeling repository-read bytes as a proxy rather than the application's total context.

The proposed 12/16 KB control must not be described as already approved. Its source plan is explicitly **PROVISIONAL** and says it does not authorize implementation (`plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md:3-5`). It is also scoped to refusing another **automatic dispatcher launch**, not to interactive `$reorient` or the whole Work Loop (`:205-215`).

## Primary-source findings

### 1. A selected skill is a full-file load

Official Codex documentation says skills use progressive disclosure in two layers: name/description first, then the **full `SKILL.md`** when the skill is selected; `references/` is the optional mechanism for material outside that always-loaded file. The documentation repeats that the initial-list budget does not alter the full-file read on selection. [OpenAI, Build skills](https://learn.chatgpt.com/docs/build-skills#how-chatgpt-and-codex-use-skills)

That matches the active Codex runtime instructions for this session. Therefore, “select `work-loop-v2` but read only its resolver markers” is not a valid optimization. A partial read becomes valid only if the Work Loop skill is **not** selected — but this repository currently makes that distinction unavailable during reorientation because `$reorient` itself requires the complete Work Loop skill (`.agents/skills/reorient/SKILL.md:13-21,99-115`).

The proposal also assumes the executable core is a sufficient substitute for the Work Loop skill. It is not. Recovery-relevant rules currently live only in the skill, including:

- the compaction gate and ownership of `$reorient` (`.agents/skills/work-loop-v2/SKILL.md:19-24`);
- actor-correct `Next:` behavior and the unattended-run carve-out (`:136-163`);
- checkout binding and routine same-thread compaction recovery (`:164-216`);
- post-compaction project orientation, including the nine project-position determinations (`:340`); and
- assessment/recheck boundaries and closing mechanics (`:535-570`).

Reading only the resolver plus the core would either lose these rules or force `$reorient` to restate them, creating the parallel authority the Work Loop deliberately rejects.

### 2. The repository had already selected the structural remedy

On 2026-08-14 the operator accepted a temporary 580-line overrun only to avoid folding a structural split into an unrelated incident fix. The decision deferred the split to the next body-line addition and required a dedicated progressive-disclosure design (`logs/decisions.md:68-98`). The improvement log added a second trigger: increase severity if a session reports the skill's length caused a missed instruction (`logs/improvement-log.md:3870-3882`).

Both triggers have now fired:

- the skill grew from 580 lines / 71,586 bytes at commit `16de1622` to 602 lines / 79,166 bytes at the current checkout; and
- this incident identifies the mandatory full skill load as a major contributor to immediate context refill and records an instruction miss during the resulting recovery sequence.

The same improvement entry already proposes the right shape: move conditional courier and routing/intake detail into `references/`, while keeping the seam, unit-sizing rule, and “What you never do” in the always-loaded body (`logs/improvement-log.md:3894-3912`). Official OpenAI guidance supports this direction: selected skills always load their full `SKILL.md`, and references are the progressive-disclosure surface. OpenAI's current model guidance also recommends stating instructions once, trimming repeated prompt material, and validating changes on representative tasks. [OpenAI, Model guidance — Favor leaner prompts](https://developers.openai.com/api/docs/guides/latest-model#favor-leaner-prompts)

This means the earlier recommendation chose the wrong seam. The safe context reduction is to make the **complete selected skill smaller**, not to make `$reorient` violate full-skill loading.

### 3. `$realign` and `$reorient` should remain separate

The repository decision that created `$realign` explicitly rejected broadening `$reorient`: recovery and live course correction have different triggers and jobs (`logs/decisions.md:100-126`). The current `$realign` description already says not to use it after compaction (`.agents/skills/realign/SKILL.md:1-4`), and its failure behavior says uncertain task identity invokes `$reorient` and stops the pass (`:142-152`).

The incident nevertheless shows one real ambiguity. `$realign` currently tells the model to load the full Work Loop skill at Step 1 before the identity/compaction branch (`:25-42`), while Work Loop says that once `$reorient` establishes state the model may “continue” (`.agents/skills/work-loop-v2/SKILL.md:19-24`). That can be read as permission to resume realignment in the same pass.

The proposed explicit stop is therefore good, with two refinements:

- put the known-compaction branch immediately after `pwd` and **before** `$realign` loads Work Loop authority; `$reorient` will own that load once;
- after reporting `REORIENTED`, emit no `ALIGNED`, `REALIGNED`, `OPERATOR DECISION NEEDED`, or realignment state edit in that pass. A new `$realign` invocation is required if the recovered move still needs correction.

This preserves the operator-approved distinction and eliminates same-pass authority duplication. A broad “reuse previously loaded authority” rule should not be added: it can conflict with the platform's requirement to load a selected skill completely. Making the selected skill smaller solves the cost without weakening the load rule.

### 4. State compaction is correct doctrine but the proposed mechanism is insufficient

The canonical core already says the state file is “current truth, not a diary,” that `## Latest result` holds what happened last rather than history, and that Git holds history (`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:347-353,389-401,450-496`). The Claude command is even more explicit: “replace the previous result rather than appending to it” (`.claude/commands/work-loop-v2.md:300-312`).

The incident state at commit `3fb45c1e` was nevertheless 20,799 bytes and retained three layers under `## Latest result`: “Unit 8 final fix,” “Unit 8's hand-back evidence follows, unchanged,” and “Unit 7's acceptance record follows, unchanged.” The replacement rule was already present in that same commit. Adding equivalent prose to another skill or plan would therefore duplicate a rule that demonstrably failed to control behavior.

The fix needs a fail-capable behavior check at the write boundary:

- begin with a fixture whose `## Latest result` contains a unique prior-unit sentinel;
- perform a normal handback, correction handback, and Continue transition;
- require the new last material result to be present and the prior sentinel/history to be absent;
- require every non-result field to remain semantically intact and the canonical validator classification to remain correct.

A size guard may be useful as a backstop, but it is not yet authorized and does not replace the semantic replacement test. The provisional 12/16 KB proposal leaves several decisions unresolved: exact byte-counting method, whether the threshold covers the whole file or only hot state, behavior at the boundary, who compacts the record after refusal, and whether any interactive path is included. Those must be settled before implementation.

### 5. A recovery regression fixture is warranted, but its claims must be observable

The existing approved post-compaction proof already supplies the right behavioral skeleton: one durable fact absent from the transcript, a no-hook control, several open tasks, exact-task recovery, and a first action matching `## Next action` (`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md:814-835`). Reuse and extend this scenario rather than introducing a second recovery model.

Official compaction documentation supports the narrow claim that compaction reduces context while preserving the state needed for subsequent turns; it does not promise an empty window or expose the Codex app's context meter. [OpenAI, Compaction](https://developers.openai.com/api/docs/guides/compaction)

Consequently:

- “mandatory repository reads total N bytes” is testable;
- “no captured tool output was truncated” is testable in a recorded run;
- “the app retained X% of its context” is not established by repository evidence;
- “every authority source was loaded once” is testable only where the recorded tool/skill trace exposes those loads, not by a static shell fixture alone.

Use a repository-read manifest as a labeled **cost proxy**, with a measured baseline and target after the structural split. Do not present it as total model context.

## QC of the four proposed changes

| Proposed change | Verdict | Reason |
|---|---|---|
| 1. `$realign` routes to `$reorient` and stops | **Keep, refine** | Correctly preserves the operator-approved separation. Branch before the Work Loop load and prohibit a realignment verdict/edit in that pass. |
| 2. `$reorient` reads only the Work Loop resolver + full core | **Reject as written** | Conflicts with full selected-skill loading, `$reorient`'s current contract, and recovery behavior held only in the Work Loop skill. Replace with the already-triggered progressive-disclosure split, then keep a full read of the smaller skill. |
| 3. Compact accepted state and enforce 12/16 KB | **Split** | Replacing history with current truth is already canonical and needs behavioral enforcement. The 12/16 KB control is provisional, dispatcher-only, and underspecified; it needs separate approval/specification. |
| 4. Add recovery regression/context budget | **Keep, reframe** | Add a behavioral compaction trial and static read-budget checks. Treat bytes as a proxy and include negative controls; do not claim access to total context or the UI meter. |

## Recommended repair package

### A. Make the recovery handoff unambiguous

Add one early branch to `$realign`:

> If this invocation follows compaction or suspected context degradation, run `pwd`, invoke `$reorient`, report its result, and stop this realignment pass. Do not load Work Loop authority a second time, assess alignment, edit state, or emit a realignment verdict in this pass. If realignment is still wanted after recovery, it requires a new `$realign` invocation.

Keep `$reorient` as the sole recovery owner and `$realign` as the manually invoked corrective. Do not merge their outputs or workflows.

### B. Execute the deferred Work Loop progressive-disclosure split

Keep in the main `SKILL.md` the rules every selected Work Loop invocation needs: activation/compaction gate, core resolver, seam and actor/turn behavior, checkout/task binding, unit sizing, brief/assessment/continue/correct/close essentials, and “What you never do.”

Move conditional detail behind explicit one-hop references, beginning with the two areas already named by the accepted deferral:

- courier/dispatcher operation and exit-code detail;
- routing/intake detail, with the existing routing index remaining the sole route inventory.

Load each reference only at the section's actual trigger. References must not link onward to more references. Keep the full executable core read for Work-Loop-owned moves and recovery until a separately approved design proves a safe modular core. Do not create a “compact core” or duplicate recovery summary.

### C. Enforce current-truth replacement behavior

Do not add another standalone prose rule. Add a fail-capable transition fixture and make every producer path demonstrate replacement of the prior `## Latest result`. If a size guard is wanted, specify and approve it separately; preserve its original automatic-dispatcher scope unless the operator explicitly expands it.

### D. Extend the existing P-7 recovery proof

Use the existing exact-task/hidden-fact/no-hook/multiple-open-task scenario. Add the `$realign`-after-compaction path, a captured read manifest, no-truncation assertion, no-routing-index assertion, and post-split reference-loading assertions.

## Exact acceptance tests

### AT-1 — Full-skill contract and progressive disclosure

1. `work-loop-v2/SKILL.md` is at or below the repository's 500-line body budget.
2. A selected `work-loop-v2` run loads the complete main `SKILL.md`; no instruction tells the model to read only selected line ranges of that file.
3. A recovery run loads no courier or routing reference.
4. A new-request routing run loads the routing reference and complete routing index before naming an owner.
5. A courier run loads the courier reference before operating the carrier.
6. Mutating either loader out makes the corresponding behavioral scenario fail.
7. `logs/scripts/work-loop-v2-core-resolver.test.sh` remains green, proving the protected resolver behavior did not drift during extraction.

### AT-2 — `$realign` after compaction

1. Start from a compacted active Work Loop session and invoke `$realign`.
2. The trace is `pwd` → `$reorient`; `$realign` does not first load Work Loop/core and does not read the routing index.
3. The response contains the `REORIENTED` contract and an explicit `Next:` line.
4. It contains none of the four `$realign` verdicts and makes no state edit.
5. A subsequent explicit `$realign` invocation on the recovered context can produce a normal realignment verdict.
6. Negative control: remove the early stop; the test must fail when a same-pass realignment verdict appears.

### AT-3 — Recovery correctness

1. Preserve one exact task path, checkout, governing plan/workflow/phase, and `## Next action` through compaction.
2. Put one material fact only in durable authority and a conflicting/stale fact in the transcript.
3. Keep at least three open task files in the repository.
4. Recovery must select exactly the preserved task, surface the durable-only fact, correct the stale transcript fact, and issue a first move matching the task's actual turn and next action.
5. The canonical validator, not an ad hoc parse, supplies lifecycle classification.
6. With the hook/preserved pointers removed, recovery must stop or differ observably; it may not guess.

### AT-4 — Recovery cost and truncation

1. Capture every repository file read during AT-2/AT-3, its bytes, and whether the read was complete.
2. The complete main Work Loop skill and complete executable core appear once each in the captured recovery trace.
3. The routing index and courier references do not appear.
4. Plan/current-state reads are bounded to the sections needed to establish objective, position, constraints, and next action.
5. No tool result reports truncation.
6. The unique mandatory-read byte total stays under a target set from the post-split baseline. Record the threshold as a repository-read proxy, not total context.
7. Negative control: force all conditional references into the recovery path; the budget test must fail.

### AT-5 — State is current truth

1. Seed `## Latest result` with `PRIOR_UNIT_SENTINEL` and a valid previous result.
2. Exercise three transitions: ordinary handback, correction handback, and Continue/new-unit handback.
3. After each new result, `PRIOR_UNIT_SENTINEL` and the previous result are absent; the new result and fail-capable evidence are present.
4. Objective/scope, lane/unit, blocker, next action, task identity, status, and turn remain correct for the transition.
5. `work-loop-state.sh validate` returns the expected canonical classification.
6. Negative control: append rather than replace; the test must fail.

### AT-6 — Optional 12/16 KB guard, only after authorization

Before implementation, freeze: what is counted, exact warning/refusal boundaries, applicable transports, and the remediation owner. Then prove:

1. below-warning state launches without a size warning;
2. warning-boundary state warns but does not change lifecycle;
3. above-ceiling state refuses **before** an automatic actor launch and reports the exact compaction action;
4. no model request starts and no lease/state is falsely advanced on refusal;
5. after lawful compaction below the ceiling, the same run can resume through the approved path;
6. interactive `$reorient` is unaffected unless the operator explicitly approved expanding the control beyond automatic dispatcher launches.

## Final assessment

The earlier proposal identified the right failure class but optimized around the wrong authority boundary. The complete Work Loop read is expensive because the selected skill has grown beyond its own budget; partial-reading that selected skill would make recovery cheaper by weakening the contract that protects it. The repository already chose the safer remedy and set a trigger for it. This incident fires that trigger.

Proceed with the early `$realign` stop, the dedicated progressive-disclosure split, behavioral enforcement of state replacement, and the extended P-7 recovery proof. Hold the partial Work Loop read and the 12/16 KB enforcement until their authority and exact semantics are corrected.
