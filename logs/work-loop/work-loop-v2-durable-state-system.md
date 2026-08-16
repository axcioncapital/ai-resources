---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 7 — Tracer bullet 5: make Work Loop deployment complete or visibly unavailable.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration; it crosses command entry, recovery, deployment, synchronization, and template boundaries whose completeness must be independently assessed before operational proof begins.

## Brief

Unit 6 / Tracer bullet 4 is accepted at implementation commit `f3eec25d` and handback commit `f7d5adaa`: Work Loop execution and recovery no longer depend on legacy session state, while non-Work-Loop legacy sessions retain their prior path. Tracer bullet 5 is next because a checkout must not expose `/work-loop-v2` while silently lacking part of the durable recovery bundle.

**Required outcome:** A checkout exposing `/work-loop-v2` must either carry the complete five-component capability or fail early with a diagnostic naming the missing prerequisite. The components are the state validator, owner helper, Reorient skill, compact-recovery hook including the registration needed for it to fire, and the live `.owner` ignore rule; absence of the command makes the capability not applicable.

**Authority and constraints:**

- The frozen plan governs: Fixed decisions 5–7, 11, 14, and 15; Capability G; Safe ordering step 7; and Tracer bullet 5.
- The accepted validator, owner, Reorient, compact-recovery, and entry contracts govern their own semantics. Reuse them; add no fallback parser, alternate state reader, registry, or second deployment-state system.
- Preserve project-specific settings and ignore content by checking or adding the required entries, not replacing whole files. Where deployment uses copied canonical helpers, drift must be visible and the required copies byte-identical.
- Admissions remain paused. Tracer bullets 6–8, deployment to existing projects without operator selection, general template redesign, unrelated workflow synchronization, merge, push, landing, and production deployment remain outside this unit.

**Verify first:**

1. Reconfirm the exact checkout/task, HEAD `f7d5adaa`, `ACTIVE_CLAUDE`, unique repository-depth ownership, and free shared leases. Stop on ambiguity or a competing actor.
2. In `.claude/commands/sync-workflow.md`, `.claude/commands/deploy-workflow.md`, `.claude/hooks/auto-sync-shared.sh`, and the current research-workflow deployment sources, verify the frozen plan's starting claims: only owner-plus-ignore is declared today; the research template has an owner-helper copy but no validator; and generic synchronization can expose the command without the rest of the bundle.
3. In `.claude/commands/work-loop-v2.md`, verify where execution can currently begin before the complete five-component readiness contract has been established.
4. In `.codex/hooks.json`, `.codex/hooks/work-loop-reorient.sh`, `.agents/skills/reorient/SKILL.md`, and the relevant project/template settings and manifests, establish the exact deployable form and activation requirement of Reorient and compact recovery. Bound this inspection to active canonical and research-template deployment surfaces; do not inventory existing projects.

If a load-bearing premise is false, return the exact inspected surface and stop rather than widening or redesigning the unit.

**Implement the frozen tracer:**

- Make the canonical deploy/sync contract treat the five components as one capability at reporting, dry-run remediation, and readiness validation.
- Bring the relevant current deployable template/copies into that complete contract, and prevent the generic command-sync path from presenting a partial Work Loop capability as ready.
- Add early `/work-loop-v2` readiness diagnostics so a missing or mismatched prerequisite stops before task execution and names the component. A checkout without the command remains N/A.
- Preserve existing project content and generic non-Work-Loop synchronization behavior. Use the smallest existing-style focused proof surface; do not create a general deployment framework.
- Commit one coherent Tracer 5 slice including the handback. Leave hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside the commit.

**Proportionate evidence:**

- Show a pre-change failing case in which a Work Loop-enabled deployment is incomplete but the existing readiness/sync path does not report the full deficiency.
- Show one complete deployment fixture passing and five derived fixtures, each missing exactly one component, failing with that component named. Show a no-command fixture reporting N/A rather than broken.
- Show that a partial checkout cannot begin `/work-loop-v2`, while the complete fixture reaches the existing validator/ownership seam rather than being rejected by the new readiness check.
- Show byte identity for canonical and deployed validator/owner-helper copies wherever the chosen deployment model requires copies.
- Show sync and deploy dry-runs proposing the exact missing additions while preserving unrelated project-specific settings and `.gitignore` content; no real project is deployed.
- Report exact counts and exits for the focused proof and directly affected regression suites. Report the final commit and exact path list, demonstrating that no existing project, excluded subsystem, friction log, or innovation registry entered the commit and that this record validates as `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 5 implementation and return the evidence above in `## Latest result`, with `status: active` and `turn: codex`. State that admissions remain paused, no existing project was deployed, nothing was merged, pushed, or landed, and Tracer 6 has not started.

**Stop conditions:** Stop if the five-component boundary cannot be made exact; readiness would require a private lifecycle parser or a second state/deployment registry; project-specific settings or ignore files would have to be replaced; the generic sync path cannot avoid partial exposure without broader redesign; or required fail-capable evidence is unavailable or red.

Capability subset: baseline only — read and inspect repository state, run local tests, edit active canonical deployment/sync/entry surfaces and directly relevant template copies, and make the local coherent commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

## Latest result

Correction round on Unit 7 / Tracer bullet 5. One frozen finding, reproduced by inspection, fully resolved.

Reproduced (2026-08-16):

- Finding 1: REPRODUCES — read `.claude/commands/sync-workflow.md` Step 7 at `e2823253`; it said, without qualification, "Copy the canonical file to the project location, overwriting if it exists." Step 4b hands its five remedies to that step, and three of them target files the project owns (`.gitignore`, `.claude/shared-manifest.json`, `.codex/hooks.json`), so the two steps contradicted each other and the destructive reading was the literal one. The evidence for preservation was also absent: nothing in the harness applied a remedy or looked at what survived it.

Result: the Work Loop bundle-remediation path now states, at both surfaces, that those three files are merged into and never overwritten, and the existing focused proof surface applies both remediations to a fixture and shows which one preserves project content. Generic synchronization is untouched — Step 7's overwrite behaviour for commands, agents, hooks and the two helper copies is unchanged, and no new deployment framework or dry-run mode was created.

- `.claude/commands/sync-workflow.md` — new subsection under Step 7, "The three merge-only files — never through step 1 above": a three-row table naming each file, what overwriting it would destroy, and the exact one-entry addition to apply instead. It ends by saying `READY` alone is not evidence the remedy was applied correctly, because the capability check cannot see the rest of the file.
- `.claude/commands/deploy-workflow.md` — the manifest step now says to add the one `skills.shared` entry and explicitly forbids writing the manifest from the template's, which would un-own every `commands.local` and `agents.local` file; the hook step already said to preserve existing entries. The same "`READY` does not prove this was applied correctly" caution is stated for both additions.
- `logs/scripts/work-loop-capability.test.sh` — new Part C (11 assertions) and five new B7 assertions. No new file, no new harness.

Evidence:

- Pre-correction failing case — the five new B7 assertions run against `git show e2823253:` copies of both command files: **4 of 5 fail** (`merge-only` carve-out absent from `/sync-workflow`; the "not evidence" caution absent from both; the manifest-replacement prohibition absent from `/deploy-workflow`). The fifth is the deploy hook step, which already carried "preserving any entries already there". Post-correction all five pass.
- Preservation demonstration, Part C — one fixture project carrying the command, none of the five components, and real project-owned content in all three merge-only files (`exports/scratch/` in `.gitignore`; `commands.local: [run-analysis, verify-chapter]` and `skills.shared: [project-only-skill]` in the manifest; its own `SessionStart` hook in `.codex/hooks.json`). C1: starts `INCOMPLETE` naming all five — those are the exact proposed additions. C2–C6, after applying the remedies exactly as the two commands now write them: `READY` (exit 0); all three sentinels survive; the `.gitignore` diff removes **0** existing lines and adds exactly `logs/work-loop/.owner`; the manifest gains `reorient` and still holds both local commands; `hooks.json` holds **2** `SessionStart` entries — the project's own and the compact one.
- Fail-capability, and why it is not decorative — C7 applies the Step 7 overwrite form to a copy of the same fixture and asserts it **also** reports `READY` (exit 0) while every sentinel is gone. The capability check therefore cannot distinguish a correct remediation from a destructive one, which is what makes C3–C6 the assertions that can fail: the same `sentinels_present` predicate returns true for the merged tree and false for the overwritten one in the same run. An assertion set that only checked for `READY` would have passed either way.
- Regression — `work-loop-capability` **77/0** (was 59/0; +18 new assertions, none of the existing 59 changed), `work-loop-state` 96/0, `work-loop-owner` 103/0, `work-loop-session-preflight` 60/0, `work-loop-v2-slice-1` 308/0, `work-loop-v2-core-resolver` 4/0. All exit 0. `bash -n` clean on the changed harness. The capability helper itself, the entry Step 0, the sweep and every template copy are byte-unchanged by this correction.
- Accepted limitation, unchanged — Part B remains a mechanical check over instruction text. Part C proves the documented remedy preserves content when applied; it cannot prove a model applies it. Interactive enforcement stays instruction-borne.
- Correction commit `{FINAL_COMMIT}` — exact paths: `.claude/commands/deploy-workflow.md`, `.claude/commands/sync-workflow.md`, `logs/scripts/work-loop-capability.test.sh`, `logs/work-loop/work-loop-v2-durable-state-system.md`. No existing project, no excluded subsystem, and neither `logs/friction-log.md` nor `logs/innovation-registry.md` entered it; both remain uncommitted. This record validates `ACTIVE_CODEX`.

Newly noticed, recorded as a candidate deferral and not implemented: `/sync-workflow` Step 6 asks the operator to approve "updates available" and "new canonical files" from Step 3's classification, and the three merge-only files appear in neither list — they reach Step 7 only through Step 4b. That is not wrong today, but the two routes into Step 7 are described in different places, and someone reading Step 6 alone would not know the merge-only route exists. Left alone: reworking Step 6 is generic synchronization, which this correction is frozen out of.

Deferrals from the implementation round stand unchanged: existing projects carrying `/work-loop-v2` without the bundle are not remediated here, and `.codex/hooks.json` registering hooks by absolute path into the main checkout is untouched. The third — Step 7's generic language — is what this correction resolved for the Work Loop path and is no longer open.

Admissions remain paused. No existing project was deployed, nothing was merged, pushed or landed, and Tracer bullet 6 has not started.

## Blocker

None.

## Next action

Codex: run the closure check on frozen finding 1 only — is the merge-only carve-out at both surfaces sufficient to establish the preservation guarantee, and did it break any directly affected capability check? Part C's C7 discriminator is the fail-capability claim to test. Do not reopen the five-component design, existing-project deployment, Tracer 6, or any deferral.
