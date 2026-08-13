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

Inspected (2026-08-13):

- Claim (1): HOLDS — read `.agents/skills/reorient/SKILL.md` Step 2 (L35–48). The controlling sentence was `Resolve the task in this order, and stop at the first step that fails.` The distinguishing language existed only in body prose (`the fallback below applies only when it is unavailable`; `Only if the exact path did not survive`), never in the sentence that governs. The brief's falsification test required the distinction to be *unambiguous*; it was not, so the finding stands.
- Claim (2): HOLDS — compared `docs/compaction-protocol.md` § *Exception* against `.agents/skills/reorient/SKILL.md` Step 3 and the executable core. The list ranked the task-state file at 1 and omitted the instruction layer entirely; Reorient Step 3 ranks `Permanent repository and agent instructions, plus the canonical Work Loop v2 skill and executable core` at 1 and the task file at 2. Read literally, a task file outranked the core that validates it — governing-rule authority and current-state authority were collapsed.
- Claim (3): HOLDS — compared the hook's emitted `additionalContext` against Reorient Step 2. The message carried `Use the exact preserved task path first; only if it did not survive, use a strictly validated logs/work-loop/.owner declaration in this checkout. If neither establishes the task, stop and say so`, which is Reorient Step 2's decision sequence restated. `.agents/skills/work-loop-v2/SKILL.md:23` pledges the opposite: `The reorient skill owns that procedure and it is deliberately not restated here`.
- Claim (4): HOLDS — `work-loop-owner.sh check --depth repo` returned `PROCEED` (`this checkout already declares task 'work-loop-v2-compaction-survivability-repair'`). Enumerated all 15 registered worktrees; this task file is present in exactly one, this checkout. `git status --porcelain` showed exactly `M logs/friction-log.md` (unrelated, excluded) plus this untracked task file.

Result: all four premises held; the three bounded instruction defects are corrected. Reorient Step 2's controlling sentence now separates an unavailable route (advance) from a failed validation (stop, no later route). `compaction-protocol.md` now distinguishes governing-rule authority from current-state authority and ranks the instruction layer above the task file, giving a five-item order aligned with Reorient Step 3. The hook message no longer restates the recovery sequence; it names Reorient as its owner and requires a safe stop. `.agents/skills/work-loop-v2/SKILL.md`, the executable core, project repositories, manifests, project `AGENTS.md`, `/new-project` and user-level settings were not touched.

Evidence:

- Pre/post text for all three defects is in the commit diff; each replaced line reads differently, and the pre-correction text is quoted verbatim in the inspection record above.
- Hook executed, representative valid input (`{"cwd":"<this checkout>","hook_event_name":"SessionStart","source":"compact"}`): exit 0, `jq -e .` confirms valid JSON, message emitted in full.
- Hook executed, empty stdin: exit 0, no output. Malformed stdin (`not json`): exit 0, no output. Fail-open intact.
- `$reorient` survives literally — 1 occurrence in the emitted `additionalContext`. The jq program is single-quoted, so the shell never expands it.
- Non-discovering / non-mutating, by inspection of the script: `logs/work-loop` appears only at L9 (a comment) and inside the emitted string at L48 — never as a path opened. Every redirect is `2>/dev/null`, `>/dev/null 2>&1` or a here-string; there are no file writes and no `mkdir`/`rm`/`mv`/`cp`/`touch`/`tee`/`sed -i`. The only git subcommand is `rev-parse`. The only read is `cat` from stdin. No task identity is selected and no state is mutated.
- Changed paths, exactly three: `.agents/skills/reorient/SKILL.md`, `docs/compaction-protocol.md`, `.codex/hooks/work-loop-reorient.sh` — plus this state file. `logs/friction-log.md` was excluded from the commit; it remains modified and unstaged in the working tree.
- Evidence capable of failure: the hook checks would have failed on invalid JSON, a non-zero exit, a shell-expanded `$reorient`, or any write construct in the script. Each was run and each returned the passing value. The three instruction edits are prose and carry no automated check that could distinguish success from failure, so their evidence is the quoted pre/post text — stated here rather than substituted with a grep for wording the brief already supplied.

Deviations: none. Scope held to the three defects.

## Blocker

None for Unit 1. Later units remain gated by the operator's hook-carrier choice and executable-core authority decision.

## Next action

Codex: assess Unit 1 against its completion condition — accept, correct once, or stop.

One candidate deferral, noticed mid-unit and deliberately not implemented: the hook message still enumerates the four preserved pointers (`the exact active logs/work-loop/{task-id}.md path, the bound checkout, the governing plan path with its workflow and phase, and the current ## Next action`) while naming `AGENTS.md § Compaction` as their owner. That is the preservation contract rather than the recovery decision sequence Claim (3) named, so removing it was outside this unit's frozen scope — but it is the same duplication pattern one layer down, and Codex may want it reduced to a bare pointer in a later unit.
