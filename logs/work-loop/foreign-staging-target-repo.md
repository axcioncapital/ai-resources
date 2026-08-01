---
task: foreign-staging-target-repo
turn: claude
---

## Objective and scope
Make the foreign-staging tripwire judge a gated command against the Git repository that the command will actually affect, while preserving a hard block when that target cannot be resolved safely. The completed task must cover the live canonical hook, permanent executable regression coverage, the maintained-copy decision, the operator-facing contract, and closure of the recorded defect.

Approved task boundary: `.claude/hooks/check-foreign-staging.sh`; a focused executable harness and fixtures under `logs/scripts/`; only the necessary follow-on changes to `docs/commit-discipline.md`, `logs/improvement-log.md`, `.codex/hooks/check-foreign-staging.sh`, and `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/hooks/check-foreign-staging.sh`. The two byte-identical worktree copies may be checked but not edited. Excluded: other hooks, a general shell parser, unrelated cleanup, any soft-warn fallback for an ambiguous command target, and the retired `/risk-check` command.

## Lane and unit
Standard. Named reason for the loop: this is the pilot's designated cross-session handoff task, and the defect spans a globally wired guard, ambiguous shell-command handling, permanent regression evidence, and divergent maintained copies whose disposition must be assessed separately from the implementation.

Unit 1 — repair and prove target-repository resolution in the live canonical `.claude/hooks/check-foreign-staging.sh`. Add the focused permanent harness needed to prove it. Do not edit documentation, the defect record, or any other hook copy in this unit.

## Brief
Why: the guard currently produces both kinds of dangerous error around nested repositories. It can block on dirty paths that the command cannot stage, and it can silently pass while inspecting none of the paths the command is about to stage. An unrecognised subshell form can bypass gating entirely. The required outcome is accurate protection, not merely removal of the false block.

Check these premises against repository reality before editing:

1. In the 668-line canonical hook, repository and footprint resolution starts from `CLAUDE_PROJECT_DIR` or the hook process cwd, rather than from the repository targeted by the command. Candidate probes then use that resolved repository.
2. The existing single-leading-`cd` parser scopes candidate path strings inside the already chosen repository; it does not select the nested repository itself. The command-boundary/gating logic recognises `cd <path> && git add .` but does not gate `(cd <path>; git add .)`.
3. Reproduce the three reported behaviors against the unmodified canonical hook in isolated temporary repositories: simple nested-repo cwd inspects parent-repo paths; root cwd plus `cd nested && git add .` silently inspects no nested changes; the subshell form exits without a protective check. Record actual exit codes and decisive output. Do not run the reproduction against live working-tree state.
4. No dedicated executable regression harness for `check-foreign-staging.sh` exists under `logs/scripts/` as currently searched; the existing hits there concern other hooks or Work Loop acceptance. Confirm that absence on that named surface before choosing the harness shape.
5. Confirm that `.claude/hooks/check-foreign-staging.sh` is the live canonical target before changing it. Recheck the reported copy census (668-line canonical, 464-line `.codex` fork, 515-line sector-intelligence copy, plus two worktree copies byte-identical to canonical) for scope safety only; do not modify the other copies in Unit 1.

If a premise that the repair rests on is false, write what was checked and found into this state file, set `turn: codex`, commit the state-file update, and stop.

Required behavior for Unit 1:

- A gated command issued while the payload cwd is already inside a nested repository must inspect that nested repository's candidate set and applicable footprint, never parent- or sibling-repository dirt.
- A single parseable leading `cd <literal-path> &&` must resolve the repository targeted after the directory change and make the same allow/block decision as the equivalent command issued from inside that repository.
- A compound form that contains a gated wide add but whose target cannot be parsed safely — including `(cd <path>; git add .)` — must fail closed with exit 2 and a clear reason. It must not exit early, warn-and-allow, or infer a repository from the pre-command cwd.
- Existing ordinary same-repository gated commands and explicit-path `git add <pathspec>` behavior must remain intact.

Implementation freedom: choose the smallest command-target resolver that satisfies those behaviors. A single leading literal `cd` is in scope; nested `cd`s, variable-derived paths, arbitrary shell evaluation, and a general parser are not. Unsupported wide-add shapes are detected and blocked, not evaluated.

Evidence required:

- Add a permanent isolated harness that first demonstrates the three pre-fix failures and then distinguishes the repaired outcomes. Its assertions must inspect exit status and decisive output/candidate identity, so they can fail if the hook checks the wrong repository or merely stops emitting the old message.
- At minimum, green fixtures must prove: nested cwd uses only nested-repo dirt; parseable `cd nested && git add .` matches that nested-repo decision; an out-of-footprint nested file still blocks; `(cd nested; git add .)` hard-blocks as unresolved; an ordinary same-repo wide add retains its prior allow/block behavior; and an explicit-path add remains ungated.
- Run the complete new harness against the built canonical hook and record the command plus case-by-case result in `Latest material result`. A prose inspection, regex-only grep, or test that never went red is insufficient.

Stop if the behavior requires edits outside Unit 1, if correct footprint translation cannot be established from the existing session/marker contract, if a supported command would need arbitrary shell execution to resolve, or if the required executable evidence cannot be produced.

This task is the pilot's mid-task session-handoff test. If the Claude session ends before Unit 1 is ready for Codex assessment, preserve current truth here: replace `Latest material result` with what is implemented and the latest red/green evidence, name any real blocker, leave one executable resumption instruction under `Next action`, keep `turn: claude`, and commit that checkpoint. Do not present partial work as a completed result.

## Latest result
Not started.

## Blocker
None.

## Next action
Claude: execute the Unit 1 brief, beginning with the premise checks and isolated red fixtures.
