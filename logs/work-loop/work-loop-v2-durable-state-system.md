---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 4 — Tracer bullet 2: migrate every tracked Work Loop task record to an explicit, validator-classified lifecycle without switching runtime consumers.

Named reason for the loop: this is a high-risk, multi-unit lifecycle-state migration whose scope must remain bounded and whose implementation requires independent assessment before it can progress.

## Brief

Unit 3 established the plan's pre-migration baseline at commit `0a904934`: new admissions are paused, the three authorized old-semantics workflows are retired with their unfinished conditions preserved, and no other non-current live workflow remains. This unit now performs the frozen plan's one-time tracked-record migration while the old runtime is still deliberately in force; the next consumer cutover remains a separate tracer.

**Required outcome:** Account for every tracked `logs/work-loop/*.md` file and leave each one in exactly one evidenced class: valid active, valid blocked, valid closed, intentional negative fixture, or non-state target fixture. Every record intended to be valid must use the accepted explicit lifecycle contract and pass `logs/scripts/work-loop-state.sh`; intentional negatives must remain invalid for their intended reason, and the old Work Loop deterministic baseline must still function with the migrated records. Migrate this implementation task's own record during the unit so that the committed handback is `status: active`, `turn: codex`, and classifies as `ACTIVE_CODEX`.

**Governing authority and source dispositions:**

- Frozen plan `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`, Fixed decisions 1–6, Safe ordering step 3, and Tracer bullet 2 govern the destination, verification, and boundary. Its content-bound status is `FROZEN — approved for sequential implementation`.
- Accepted Unit 3 result and commit `0a904934d68ee4bcac0c199ae349c3d97e163e78` govern the starting position: the admission pause remains in force through operational proof and final landing; the three retirements are accepted; the pre-Tracer-2 inventory reported 46 canonical old-contract records, two noncanonical closed migration inputs, 25 fixtures, one current record, and zero other live workflows.
- `logs/scripts/work-loop-state.sh` and its focused tests are the already-proven inactive implementation of the accepted final record contract. Use its exact validation result to establish lifecycle validity; do not duplicate or loosen the contract in migration-specific logic.
- The currently canonical executable core and runtime consumers still describe/read the old state shape. They remain governing for this handoff and for old-runtime continuity only; this unit must not edit them or infer that their current no-`status` examples override the frozen plan's migration destination. Tracer 3 owns the coherent semantic cutover.
- Current operator decision, 2026-08-15, keeps all new Work Loop admissions in this repository paused. It authorized the three completed retirements; progression into this tracer is authorized by the already frozen sequential implementation plan, not by expanding that retirement decision.

**Check against the repository before editing:**

1. Reconfirm the exact task/checkout, repository-depth ownership, shared-lease state, HEAD `0a904934`, and the pre-existing hook-owned `logs/friction-log.md` modification. Stop if another task or actor now owns or leases a record to be migrated, if HEAD moved unexpectedly, or if the only-authoritative-copy premise is ambiguous.
2. Produce a complete tracked-file inventory from the tracked `logs/work-loop/*.md` surface. Verify the Unit 3 total and categories rather than trusting the reported counts; every path must have exactly one intended post-migration class, and the inventory must distinguish task records from intentional negative fixtures and non-state targets by repository evidence, not filename alone.
3. Run the inactive validator against the intended-valid records before migration and retain fail-capable starting evidence showing the old records do not yet satisfy the explicit lifecycle contract. Establish the relevant failure distribution or representative failures without turning the state file into an exhaustive transcript.
4. For every `turn: operator` record, decide from its own durable wording whether it is an unambiguous retrospective closure or an unresolved operator wait. Normalize the former to `status: closed` and the exact four closing headings; classify the latter as `status: blocked` with all five active/blocked headings and a real blocker. Stop rather than guess where the record is ambiguous.
5. Reconfirm the two known noncanonical closed inputs: `context-engineering-implementation-plan.md` and `foreign-staging-target-repo.md`. If their own records still unambiguously establish retrospective closure, normalize their headings and lifecycle as planned while preserving their substantive outcome, decisions, evidence, and limitations; do not reinterpret their history.
6. Determine each fixture's recorded intent from its tests and use. Preserve intentional negative fixtures as invalid by intent, update state-focused assertions where necessary so each fails for its intended invariant rather than an earlier accidental defect, and keep non-state target fixtures classified rather than forcing them into the state contract.

**Implementation boundary:** Add the explicit `status` lifecycle and mandatory body shape to all intended-valid tracked Work Loop records, performing only the lifecycle/body normalization required to make their already-recorded meaning valid. Preserve historical substance: do not upgrade an outcome, erase a limitation, invent an operator decision, resume a retired workflow, or reinterpret session history. Update existing state-focused fixture assertions only where required to preserve their stated discrimination under the new contract. A disposable migration operation may be used locally if useful, but do not add a permanent migration framework or runtime fallback.

This unit may edit tracked `logs/work-loop/*.md` records and the minimum existing state-focused test/fixture assertions required by the migration. It must not edit `.owner`, the executable core, either Work Loop actor instruction, Reorient, the owner helper, carrier, dispatcher, legacy session records, the frozen plan, deployment assets, or runtime consumer semantics. Do not archive tasks, create a second inventory artifact, clean `logs/friction-log.md`, merge, push, or begin Tracer 3.

**Codex framing decisions:** Treat repository-wide coverage as one dominant migration deliverable because Tracer 2's exit condition explicitly requires no unclassified tracked record; the word “every” is consequence-driven here, not an invitation to adjacent cleanup. Hold consumer cutover, owner-format change, legacy isolation, operational proof, closure, and landing outside this unit because the frozen safe ordering assigns them to later tracers. Treat lifecycle/body normalization as preservation work: wording may be compressed only where the existing meaning remains provably unchanged.

**Capability subset:** Baseline only — read/search/history inspection, repository-depth ownership and lease checks, local tests, edits within the tracked Work Loop records and minimum existing state-focused test assertions, and local commits by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed; no merge, push, deployment, network, credential, destructive action, policy expansion, or runtime consumer switch is authorized. This is an operator-carried interactive turn, so no courier runtime profile is claimed.

**Required evidence:**

- A before/after inventory accounting for every tracked `logs/work-loop/*.md` path in exactly one of the five permitted classes, with totals that reconcile and no unclassified record.
- Failing-first validator evidence from old intended-valid records, followed by `logs/scripts/work-loop-state.sh validate` success for every intended-valid record and the exact classification totals after migration.
- For every intentional negative fixture, an assertion or inventory mapping to its intended validator failure, plus evidence that it fails for that reason rather than an earlier unrelated defect; non-state targets must remain explicitly accounted for.
- Evidence that no ambiguous operator-turn record was guessed. For each migrated operator-turn record, preserve a concise mapping from old recorded meaning to either blocked or closed; call out any record whose disposition required more than mechanical heading/lifecycle normalization.
- Focused validator regression from `logs/scripts/work-loop-state.test.sh` and the original old-runtime deterministic baseline from `logs/scripts/work-loop-v2-slice-1.test.sh`, with exact pass/fail counts and exit status. If another existing state-focused assertion is changed, run its owning focused suite as well.
- Direct validation of this task's committed handback shape as `ACTIVE_CODEX` while the old runtime still accepts it.
- A scoped diff review showing no semantic history rewrite beyond explicit lifecycle/body normalization, no `.owner` or consumer change, and a commit/path summary that accounts for all changed tracked files. Keep the hook-owned `logs/friction-log.md` modification outside the commit and untouched.

**Completion condition:** Commit the complete Tracer 2 migration and its minimum test updates, including this migrated task record. Replace `## Latest result` with the reconciled inventory, classification, ambiguity, validator, negative-fixture, old-runtime, scope, and commit evidence; retain `status: active`, set `turn: codex`, and hand back for assessment. State explicitly that `.owner` remains in old `{task-id} {date}` form, runtime consumers have not switched, admissions remain paused, and Tracer 3 has not started.

**Stop conditions:** Stop without guessing if any tracked operator-turn record has ambiguous lifecycle meaning; a task record has multiple plausible authoritative copies; a live owner or lease conflicts with migration; preserving an intentional negative's reason requires weakening the validator; the old runtime does not tolerate the migrated valid records; the migration would require `.owner` or consumer changes; repository evidence materially invalidates the frozen contract; or completing the inventory would require interpreting legacy session history. Report the exact paths and evidence, set `turn: codex` for a technical/premise handback, and do not partially claim Tracer 2 complete.

## Latest result

**The final tightly-bounded fix is done and the old-runtime deterministic baseline is green.** The two-sided installation premise held, so the stale routing fact was corrected rather than accepted as a limitation. `.owner` remains in the old `{task-id} {date}` form, runtime consumers have not switched, admissions remain paused, and Tracer 3 has not started.

**What this round was authorised to do,** carried into the record because Codex's instruction was never committed: reconfirm the two-sided installation, then "remove only its stale `[Claude-side only]` marker from `.agents/skills/work-loop-v2/references/routing-index.md` and update only the corresponding `CLAUDE_ONLY` expectation and human-readable count in `logs/scripts/work-loop-v2-slice-1.test.sh`", preserving `diagnosing-bugs` as the same routed capability, with the closure check covering this final fix only.

**Premise — the two-sided installation still holds.** Checked by inspection, not recall:

- `~/.claude/skills/diagnosing-bugs/SKILL.md` — present.
- `~/.codex/skills/diagnosing-bugs/SKILL.md` — present.

Both sides carry the skill, so the index's `[Claude-side only]` marker on that one bullet was a false fact about the live environment. A second premise was checked before editing: the routing index states no numeric total of Claude-side-only skills anywhere, so removing one marker required no count edit inside the index. The only human-readable count lives in the harness.

**The fix — three lines across two files.**

1. `routing-index.md` line 50: `` - `diagnosing-bugs` `[Claude-side only]` — something is broken… `` became `` - `diagnosing-bugs` — something is broken… ``. Only the marker was removed. The bullet, its name and its purpose text are unchanged.
2. `work-loop-v2-slice-1.test.sh` `CLAUDE_ONLY`: `diagnosing-bugs` removed from the expectation list, 12 names to 11.
3. The same file's human-readable check name: `exactly the 12 Claude-side-only skills carry the marker` became `exactly the 11 …`.

**`diagnosing-bugs` is still the same routed capability.** It remains in `MATT_PRIMARY` in the harness and remains an indexed owner bullet with its original purpose. Route membership, routing behaviour, skill contents and both installations are untouched. What changed is one claim about where it is installed.

**The two sets now agree at 11, and they agree by name, not by count:**

```
marked in index (11): ask-matt codebase-design grill-with-docs handoff improve-codebase-architecture
                      resolving-merge-conflicts to-questionnaire triage wait-what wizard writing-for-agents
live claude-only (11): (identical, in the same order)
```

**Fail-capable negative — the live-installation cross-check still rejects a mismatch, in both directions.** Each probe ran the real harness against a mutated copy of the index through the existing `WL2_ROUTER_FILE` override; the real index was never modified by a probe.

| Probe | What it does | Harness result |
|---|---|---|
| A | reintroduces the stale `[Claude-side only]` marker on `diagnosing-bugs` | 306 passed, **2 failed** — the live-installation check red again |
| B | drops the marker from `wizard`, a genuinely Claude-only skill | 306 passed, **2 failed** — the live-installation check red again |
| control | the real index | 308 passed, 0 failed |

Probe B matters as much as A: it shows the check is not merely tolerant of a shorter list but rejects a marker that is missing where the live installation requires one. The sibling `exactly the 11 …` assertion goes red alongside it in both probes, which is the intended pairing — the brief-side and live-side checks are meant to fail together on a drifted index.

**Old-runtime deterministic baseline.** `logs/scripts/work-loop-v2-slice-1.test.sh`: **308 passed, 0 failed, exit 0** — green, from 307 passed / 1 failed at the start of this round and 305 / 3 before the correction.

**Focused validator regression.** `logs/scripts/work-loop-state.test.sh`: **63 passed, 0 failed, exit 0** — unchanged. This record validates as `ACTIVE_CODEX` at hand-back.

**Scope.** Exactly the three allowed files changed: the routing index, the harness, and this record. No migrated record content, no `mode` assertion, no validator or its test, no `.owner`, no consumer, no core, no other skill, and no installation was touched. `logs/friction-log.md` remains a hook-owned modification, untouched and outside the commit.

**Carried forward** (Git holds the full text at `a1c81caf` and `f3390f7b`): the Tracer 2 inventory reconciles all **74** tracked `logs/work-loop/*.md` paths into 55 valid closed, 13 valid active, 0 valid blocked, 3 intentional negative fixtures and 3 non-state target fixtures; all 68 intended-valid records exit 0 and the 3 negatives fail at exits 16, 14 and 16 on their own invariants. Finding 1 of the correction round — the two `mode` assertions repointed at this task's own open record through a single `LIVE_TASK_F` pointer — remains resolved and green.

## Blocker

None.

## Next action

Codex: run the closure check on this final fix only — is the stale routing fact corrected, and did the fix break anything?

The two questions the § 3 menu leaves: whether the index's factual currency now needs a standing check of its own, given that this marker went stale silently when a skill was installed on the Codex side, and whether Tracer 2 is now accepted. Both are yours. Tracer 3 has not started.
