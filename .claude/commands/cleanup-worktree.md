---
model: sonnet
friction-log: true
---

Investigate dirty paths in the git working tree, plan a safe cleanup with one independent risk-aware review, and execute behind hard gates for irreversible operations.

Input: $ARGUMENTS (optional) — any operator notes about what triggered the cleanup, what to prioritize, or which files to handle specially. Treated as the "original operator request" recorded in the plan file Section 1. If empty, use the operator's invocation statement as the request.

**This command is not a trivial wrapper.** It encodes the invocation contract for `worktree-cleanup-investigator`: mandatory plan mode, one independent risk-aware review of the plan before execution, hard gates with named confirmation phrases, execution-time re-verification guards, post-commit filesystem verification. Deviating from the sequence is a safety failure. Read the skill's SKILL.md; load reference files on demand per Step 3.

---

## Step 1: Verify prerequisites

**Concurrent-session disclosure (mandatory, run before any other prereq).** Ask the operator: "Is any other Claude Code session currently active on this repo or on this machine? (yes/no)". If yes, STOP and instruct the operator to wrap or close the other session(s) first, then re-invoke. `/cleanup-worktree` commits and untracks files — running it concurrently with another session can clobber that session's in-flight work. Do not attempt a programmatic process check (`pgrep` and equivalents return false positives because Claude Code spawns helper processes within a single session); operator disclosure is the contract per workspace `CLAUDE.md → Concurrent-session staging discipline`. If no, proceed to item 1 below.

1. Confirm `ai-resources/` is mounted — required because `worktree-cleanup-investigator` depends on `find-template.sh` walking up from CWD to find the `ai-resources` sibling. If `ai-resources/` is not accessible from the current working directory, STOP and surface to the operator — do not attempt a text-based fallback for template detection.
2. Confirm git state is clean-baseline — run `git status` and check for in-progress rebase, merge conflict, or detached HEAD. If any of those apply, STOP and instruct the operator to resolve the underlying state first.
3. Locate the skill: `ai-resources/skills/worktree-cleanup-investigator/SKILL.md`. If missing, STOP — the command cannot run without the skill.

## Step 2: Enter plan mode

4. Enter plan mode immediately. All subsequent steps up through Step 7 run in plan mode. No mutations to the working tree, the index, the filesystem, or `.gitignore` occur before `ExitPlanMode` is called in Step 10.
5. Read-only operations permitted throughout: `Read`, `Glob`, `Grep`, `Bash` for `git status`, `git diff`, `git log`, `cat`, `ls`, and `scripts/find-template.sh`. Every other tool is off-limits until plan mode exits.

## Step 3: Load the skill (on-demand reference loading)

6. Read `ai-resources/skills/worktree-cleanup-investigator/SKILL.md` in full.
7. Do NOT pre-load the reference files. The two references (`decision-taxonomy.md`, `execution-protocol.md`) are loaded at their specific trigger points:
   - `decision-taxonomy.md` — load in Step 4, immediately before beginning per-path classification. Read sections as needed; the TOC supports grep-based section-level reads.
   - `execution-protocol.md` — load sections on demand: § 1 + "Plan file schema" in Step 5 (writing the plan); § 3 in Step 6 (the review launch), § 4 in Step 7 (revision); § 7 + § 8 in Step 11 (before each destructive operation); § 11 when finalizing the commit split in the plan. Do not read the full reference at Step 3 "just in case".

This on-demand loading matches `SKILL.md → Reference Files` and keeps the main session lean across the 45–90 min workflow.

## Step 4: Investigate dirty paths

9. Run `git status --porcelain=v1` and capture the full output.
10. For each dirty path in the output, apply the investigation protocol from `execution-protocol.md` section 2:
    - Read the file content (`Read` — actually open it, do not classify from filename). For deleted paths (status codes `D` or `AD`, where the file no longer exists on disk), use `git show HEAD:<path>` to recover the last-tracked content. Do not skip the read step for deletions — classification still requires inspecting what was deleted.
    - Note the git status code.
    - **Run `find-template.sh` for every path that could plausibly have a canonical template elsewhere in `ai-resources/`.** This includes (but is not limited to) `.claude/commands/*.md`, `.claude/agents/*.md`, `.claude/hooks/*`, and any path whose directory structure mirrors a known `ai-resources/` subdirectory (skills/, prompts/, workflows/, scripts/, docs/). Never check subdirectories manually — the script mechanically walks all ai-resources locations and is the root-cause fix for the false-negative class. If the script exits with code 3 (ERROR), STOP and surface to operator.
    - Check `.gitignore` interactions.
    - Check for canonical-destination content (CLAUDE.md, user-scoped memory, reference files) if the file carries rules, rationale, or operational knowledge.
    - Assign a decision from `decision-taxonomy.md`.
11. Apply all four bias counters from the skill explicitly: (1) never fabricate file details — re-read files before making any factual claim; (2) always run `find-template.sh` — never check ai-resources subdirectories manually; (3) the plan's one independent review is required and is never skipped — an operator-requested skip is always refused; (4) hard gates require named confirmation phrases — "ok" / "proceed" / "sure" do NOT clear a gate.

▸ **Compact breakpoint (pre-plan).** Investigation is complete and the plan has not yet been written. If context usage is above ~50%, write a short scratchpad naming: every dirty path with its assigned decision, all `find-template.sh` verdicts, any canonical-destination candidates already identified, and the path to this command's arguments. Then prefer `/clear` + restart (reading the scratchpad) over `/compact`. If neither is needed, continue. See workspace `CLAUDE.md → Working Principles` → pre-compact checkpoint.

## Step 5: Write the plan file

12. Write the plan to `~/.claude/plans/cleanup-worktree-<YYYY-MM-DD-HHMM>.md`, following the eight-section schema defined in `execution-protocol.md` → "Plan file schema":
    1. Original operator request (from $ARGUMENTS or the invocation statement)
    2. Git status snapshot (raw output from Step 4 step 9)
    3. Per-path classification table (path, status, decision, evidence, gate?, commit group)
    4. Hard-gate inventory (one block per gate: operation, files affected, confirmation phrase, abort scope, justification)
    5. Commit split (ordered list: #, subject, paths, depends on, gate reference)
    6. Execution-time re-verification checklist (one line per destructive operation)
    7. Bias-counter checklist (declared acknowledgment)
    8. Revision history (initially empty)
13. A plan missing any section is structurally invalid. Before proceeding, verify all eight sections are present AND cross-check that every irreversible operation is gated: scan Sections 3 (per-path classification) and 5 (commit split) for any decision of `delete`, `convert-to-symlink` (type change via `rm` + `ln -s`), `migrate-then-delete` (the delete step), or `git rm --cached` paired with filesystem removal. Every such operation MUST appear as a hard-gate block in Section 4. An ungated irreversible operation is a structural failure — fix before the first QC pass, not after.
13b. Populate Section 7 (bias-counter checklist) with an enumerated acknowledgment of all four bias counters: (1) "Counter 1 — files re-read before classification on YYYY-MM-DD HH:MM (no claims from filename alone)"; (2) "Counter 2 — find-template.sh run for paths: \<list>"; (3) "Counter 3 — independent review of the plan completed at Step 6, report at \<path>, every material finding applied or defended in Section 8"; (4) "Counter 4 — confirmation phrases declared in Section 4 hard-gate blocks". Section 7 is the audit artifact the QC subagents verify against. An empty Section 7 is a structural failure.

## Step 6: The plan's one independent review

14. A cleanup plan is destructive, so it takes the risk-aware review row of `ai-resources/docs/qc-independence.md` § The rule — **one** review, before execution. Codex is that review when the session has it. When it does not, spawn a subagent as the named fallback: type `qc-reviewer` (or `qc-gate` if the current project provides that alias in `.claude/agents/`), briefed with the seven risk dimensions in addition to the criteria below. Mirror the path-passing + write-to-disk contract already used by `repo-dd-auditor` and `token-audit-auditor`.
15. Inputs the subagent receives:
    - **`PLAN_PATH`** — absolute path to the plan file written in Step 5. The subagent reads the plan at invocation time. Do NOT paste the plan content into the subagent brief. Path-passing satisfies the workspace `CLAUDE.md → Input File Handling` rule and preserves context isolation (the subagent still does not see the creation conversation).
    - The original operator request (Section 1 of the plan) — quoted inline in the subagent brief.
    - The git status snapshot (Section 2 of the plan) — quoted inline in the subagent brief.
    - The evaluation criteria: structural completeness (all 8 sections present), factual accuracy (claims about files match file content), gate coverage (every irreversible operation has a hard-gate block), abort-scope completeness (every gate specifies what other sub-steps survive a decline).
16. Inputs the subagent does NOT receive: this conversation, the creation context, any private reasoning about why decisions were made. Context isolation is enforced by what is withheld, not by in-lining the plan.
17. Output contract — the reviewer's full report is written to `<PLAN_PATH>.review.md` (same directory as the plan), and a ≤20-line structured summary plus the absolute path is returned. Capture the summary and the path. Read the full report from disk only if a summary item requires deeper context. This mirrors `ai-resources/CLAUDE.md → Subagent Contracts`.

## Step 7: Plan revision

22. Revise the plan file to address every material finding from Step 6, and any non-material one the operator confirms. Use `Edit` on the plan file only. Do not touch any other file.

23. Where you disagree with a finding, say so in the plan's Section 8 with the reason — a defended disagreement is a resolution. A finding left neither applied nor defended is **unresolved**: halt and surface it to the operator (`docs/qc-independence.md` § Findings). Do not proceed to Step 10 with an unresolved material finding.

24. **No second review.** Revising is applying the review, not a new artifact to review. A second pass happens only if a finding forced a genuine redesign of the plan — a different set of operations, not a reworded one.

▸ **Compact breakpoint (post-revision).** The plan is revised and execution has not started. If context usage is above ~50%, write a scratchpad naming: every material finding with its resolution, any first-class alternative adopted, and the paths to the plan and the review report. Then prefer `/clear` + restart (reading the scratchpad) over `/compact`.

---

## Step 10: ExitPlanMode and operator approval

28. Call `ExitPlanMode` with the revised plan as the argument. The harness will present the plan to the operator.
29. Wait for explicit operator approval. Do not proceed to execution without it.

## Step 11: Execute commits in order

30. For each commit in Section 5 (Commit split) of the plan, execute in order:
    a. For each destructive operation in this commit, run the execution-time re-verification guard from Section 6 of the plan — immediately before the destructive command, not at investigation time. If the guard fires (diff non-empty, inventory mismatch, git ls-files verdict wrong, etc.), STOP the current commit, surface the guard failure to the operator, and ask how to proceed. Do NOT silently fall back.
    b. For each hard-gate block referenced by this commit (Section 4 of the plan), run the hard-gate protocol:
       - Display the content being destroyed.
       - State the irreversibility.
       - Require the named confirmation phrase verbatim. Generic affirmatives ("ok", "proceed", "sure") DO NOT clear the gate.
       - If the operator declines, apply the abort scope from the gate block exactly as specified. Do not improvise.
    c. After all destructive operations in this commit pass their gates and guards, execute the operations.
    d. Stage the changes with `git add` (specific paths, not `-A`).
    e. Commit with the subject line specified in the plan's Commit split.

31. After each commit lands, run post-commit verification from the filesystem (not `git status` or `git diff`):
    - Read each committed file and confirm content matches intent.
    - For each symlink conversion, `readlink` the symlink and `cat` through it to confirm the target resolves.
    - For each deletion, confirm the path no longer exists on disk.
    - For each `.gitignore` edit, re-read `.gitignore` and confirm the new pattern is present.

## Step 12: Report and wrap

32. Report to the operator:
    - Number of commits landed with hashes and subject lines
    - Hard-gate confirmation phrases received (verbatim, for audit)
    - Any residual unresolved issues from MINOR findings that were logged but not fixed
    - Reminder: "Push manually when ready. Then run `/wrap-session` to log this session's work and decisions."
33. DO NOT push. DO NOT run `/wrap-session` from inside this command. Both are separate manual operator steps.

---

## Failure escalation

If any step fails in a way not covered by the plan's abort scope:

- **`find-template.sh` exits 3 (ERROR)** — abort the cleanup session entirely. The skill depends on `ai-resources/` being accessible.
- **A material finding cannot be resolved, or resolving it keeps producing new material findings** — stop. Surface it to the operator. Something structural is wrong with the plan.
- **Hard gate declined and abort scope is ambiguous** — stop the commit. Ask the operator to clarify which sub-steps should still execute.
- **Execution-time re-verification guard fires** — stop the commit. Do not fall back to a safer operation. Surface the guard failure.
- **Working tree becomes dirty from an unexpected source mid-execution** — stop. Something outside the cleanup flow is making changes. Investigate before continuing.
- **Operator requests to skip the review or shorten the sequence** — REFUSE. The plan's one independent review is the load-bearing safety property of this command; it was already cut from three passes to one on 2026-07-29, and there is nothing left to trim. Surface the refusal explicitly ("a cleanup plan is destructive, so it gets one independent review before execution — that pass is not optional") and continue the protocol as written. If the operator insists after the explanation, surface the risk in writing, only proceed if they confirm they accept responsibility for a cleanup without independent review, and log the exception explicitly in the plan's Section 8 (revision history) so the decision is auditable.

## Not this command's job

- **Pushing to remote.** Push stays manual per project rules.
- **Running `/wrap-session`.** Separate command, separate invocation.
- **Workspace health audit.** Use `/audit-repo`.
- **Structural or judgment audit of repo contents.** Use `/repo-dd`.
- **Creating or modifying skills.** Use `/develop-ai-resource` for a new resource (it qualifies the need, then hands off to the build engine) or `/improve-skill` for a settled improvement to an existing skill.
- **Single-file commits.** Regular commit flow.
- **Running during an active content-production session.** Cleanup is a dedicated session, not a sidebar.
