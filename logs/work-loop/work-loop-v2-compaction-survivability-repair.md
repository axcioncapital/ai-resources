---
task: work-loop-v2-compaction-survivability-repair
turn: codex
---

## Objective and scope

Make Work Loop v2 reliably recover its authoritative task after Codex compaction in every intended Work-Loop-enabled project, without adding parallel state, weakening actor boundaries, or duplicating recovery authority. The task exits only when the instruction layer is review-clean, the approved deployment scope is installed, and one representative project-repository compaction proves recovery or a safe stop.

In scope across the task: the instruction-layer correction following commit `df35ddd`; deployment only to verified Work-Loop-enabled projects and future eligible scaffolds; the operator-approved compact-hook carrier; proportionate operational proof. Excluded: distributing these skills to every project, a five-compaction endurance exercise, broad Work Loop redesign, a second recovery artifact, and approving or rewriting the executable core without an explicit operator decision.

## Lane and unit

Standard. Implementation mode. Unit 1 — correct the three bounded instruction-layer defects established by the independent review of `df35ddd`.

Named reason for the loop: the complete repair crosses multiple sessions and repositories, includes operator-owned deployment and authority decisions, and must be assessed independently from Claude before it counts as complete.

Why this unit, why now: deployment would propagate the current instruction defects into project sessions. Correcting the bounded contradictions and duplicated ownership first preserves the approved lean recovery design and makes the later deployment unit reviewable on stable instructions.

Governing authority: the operator's 2026-08-13 instruction to run this repair through Work Loop v2; the executable core resolved by `.agents/skills/work-loop-v2/SKILL.md`; repository `AGENTS.md`. Verify-first current evidence: commit `df35ddd`, the four changed instruction files, and the independent review findings recorded below. Non-governing background: `/Users/patrik.lindeberg/.codex/attachments/1cce4518-9dfb-47ba-b494-5f9b0479bf23/pasted-text.txt` and `audits/working/2026-08-13-resolve-verify-and-qualify-the-work-loop-v2-compaction.md`—use them as leads, never as authority.

Codex framing decision: this unit is limited to three fixable instruction defects because deployment, the `work-loop-v2` size-standard finding, and executable-core approval each require a different deliverable or an operator decision. Holding them outside prevents one correction unit from becoming a redesign.

## Brief

Required outcome: make the instruction layer internally consistent while preserving the exact-path → validated local `.owner` → safe-stop design and keeping Reorient as the single owner of recovery procedure.

Check against the repository before editing:

1. In `.agents/skills/reorient/SKILL.md` Step 2, verify whether “stop at the first step that fails” can literally stop when the preserved path is unavailable, before the documented `.owner` fallback runs. The finding is false if the surrounding instructions unambiguously distinguish route unavailability from a validation failure.
2. In `docs/compaction-protocol.md`, compare the new Work Loop authority list against Reorient Step 3 and the executable core. Verify whether it conflates governing-rule authority with current task-state authority, allowing a task file to outrank the instructions that validate it.
3. In `.codex/hooks/work-loop-reorient.sh`, compare the emitted message with Reorient Step 2. Verify whether the hook now restates the exact-path/`.owner` decision sequence despite declaring Reorient the procedure owner.
4. Verify the current checkout and repository-depth ownership at Claude Step 1. Confirm this task file is unique to this checkout and that the only unrelated working-tree change is `logs/friction-log.md`; do not modify, stage, or commit that unrelated change.

Implement only if those claims hold. Correct the three defects with the smallest edits that preserve behavior. The hook may identify the checkout, explicitly invoke `$reorient`, and require a safe stop, but must remain read-only, non-discovering, non-mutating, and fail-open. Do not edit `.agents/skills/work-loop-v2/SKILL.md`, the executable core, project repositories, manifests, project `AGENTS.md` files, `/new-project`, or any user-level settings in this unit. Do not attempt to retroactively describe this work as the pre-implementation risk-aware review that the earlier hook edit should have received.

Required evidence capable of failure:

- Show the pre-correction failing text or behavior for each confirmed claim, and the post-correction result that reads differently.
- Execute the compact hook with representative valid input and with empty stdin; report exit codes and actual output.
- Demonstrate that emitted JSON remains valid, `$reorient` survives literally, and no task identity is selected or state mutated by the hook.
- Report the exact changed paths and confirm `logs/friction-log.md` was excluded from the commit.
- Update this state file with the result, evidence, commit, deviations, and remaining blockers; set `turn: codex`; commit the bounded correction and state-file handback together. Do not push.

Completion condition: all three confirmed defects are corrected without widening scope, the hook's existing safety properties still pass executable checks, and Claude returns evidence sufficient for Codex to accept, correct once, or stop.

Stop and hand back without implementing if any premise is false, the correction requires changing the executable core or `work-loop-v2/SKILL.md`, or the required evidence cannot be produced. Stop for the operator if repository reality makes either the core-approval decision or hook-carrier decision necessary for this unit.

## Latest result

Correction round (2026-08-13) — frozen finding (1), reproduced then corrected.

Reproduced by inspection: read `docs/compaction-protocol.md` § *Exception — an active Work Loop v2 task* as committed at `c7eb221`. The finding holds. The prose named the two kinds of authority correctly, then the sentence `Authority runs in this order:` reintroduced a single 1–5 ranking across both kinds, with the task-state file at 2 and `The governing plan and the applicable approved workflow` at 3. Read by number, the task file overrode the approved sources that give its contents meaning.

Root cause, stated because it explains the defect rather than excusing it: the ranking was modelled on Reorient Step 3, whose list is a **read order** (`Read only what is needed to establish the next justified move, in this order`). A read sequence was converted into an authority hierarchy. The two are not the same shape, and nothing licensed the conversion.

Result: finding (1) is resolved. The single cross-type ranking is gone. The numbered list is replaced by four role statements, each naming what that source settles and what it does not. The removal works because there is no longer any ordinal relation to read — a bulleted role list has no rank 2 sitting above rank 3, so the text cannot express "task state beats approved workflow" even by misreading. The governing role now carries instructions, skill, core, plan and workflow together in one bullet, so plan and workflow are inside the governing set rather than below the task file. The task-state bullet states its limit twice: authoritative for what the state *is*, never for what the rules are, and it does not outrank the plan or workflow. One further sentence was added for the conflict case the old numbering implied an answer to — where the task file conflicts with a governing source, the governing source settles it and the conflict is reported as a defect in the task file.

Exact pre/post text:

- Pre (removed): `A task-state file carries the second and never the first, so it cannot outrank the instructions that validate it. Authority runs in this order:` followed by `1. Permanent repository and agent instructions, plus the Work Loop v2 skill and its executable core ... 2. The task-state file, logs/work-loop/{task-id}.md ... 3. The governing plan and the applicable approved workflow. 4. Repository and Git evidence. 5. The conversation or the compacted summary.`
- Post (added): `These are not rungs on one ladder: a source that governs interpretation is not competing with a source that reports state, so asking which of the two "wins" is already the wrong question. Each source has one role, and stays inside it:` followed by four unranked roles — **Govern interpretation** (instructions + skill + core + governing plan + applicable approved workflow), **Establish current task state** (the validated task file, within those constraints), **Verify factual claims** (repository and Git evidence), **Orient only** (conversation or compacted summary).
- Also corrected inside the same finding: the closing sentence `this section only settles which source wins` became `this section only settles which source carries which kind of authority`. `which source wins` was the ranking framing surviving one sentence past the list it belonged to.

Evidence:

- The complete pre/post text is in the commit diff for `docs/compaction-protocol.md`; both versions are quoted above and read differently.
- Nothing else references the removed numbering: `grep -rn "first four|first three|Authority runs in this order" --include='*.md' --include='*.sh'` over the repository returns no hit that points at this section — every match is unrelated prose in other documents, plus this task file quoting the assessment. Nothing depended on the ordinal form.
- The accepted Reorient and hook changes were not touched: `git diff c7eb221 -- .agents/skills/reorient/SKILL.md .codex/hooks/work-loop-reorient.sh` is empty.
- The hook's executable checks still pass after the correction: representative valid input gives exit 0 and `jq -e .` confirms valid JSON; empty stdin gives exit 0 with no output.
- Files changed since `c7eb221`: `docs/compaction-protocol.md` and this state file only. `logs/friction-log.md` remains modified, unstaged and excluded.
- Evidence capable of failure: the inbound-reference grep would have named a dependent file, the `git diff` against `c7eb221` would have shown bytes if the accepted fixes had drifted, and the hook checks would have failed on invalid JSON or a non-zero exit. Each was run and each returned the passing value. The correction itself is prose and carries no automated check that could distinguish success from failure; its evidence is the quoted pre/post text.

Nothing was partly resolved. Nothing newly noticed entered this round.

## Blocker

None for Unit 1. Later units remain gated by the operator's hook-carrier choice and executable-core authority decision.

## Next action

Codex: run the closure check on frozen finding (1) only — is it resolved, and did the correction break anything? Then close Unit 1, or use the § 3 menu.

Carried forward, unchanged and not reopened by this round: the hook message still enumerates the four preserved pointers while naming `AGENTS.md § Compaction` as their owner. That is the preservation contract rather than the recovery decision sequence Claim (3) named, so it does not reopen the accepted hook fix.
