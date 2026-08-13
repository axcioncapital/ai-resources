# Session Plan — 2026-08-02

## Intent
Run Claude's turn of Work Loop v2 Context Engineering per Codex's brief — verify the brief's premises, write the operator's exact content-bound reapproval into the implementation plan's approval header, update the task-state file to current truth, commit both together, and set `turn: codex`.

## Model
opus — match (active session model is `claude-opus-5[1m]`). The mechanical half (editing header metadata) is trivial; the load-bearing half is judgment: deciding whether the working-tree plan is *substantively* unchanged from `e1ce895…`, and whether recording the approval can be done without touching anything outside the approval-metadata header. Getting that wrong writes a false approval record into a governing plan.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/context-engineering-implementation.md` — the task-state file carrying Codex's brief; `turn: claude`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` — the plan whose approval header is the single edit target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` — governing specification (read-only context)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` — candidate; hash must remain `956c76f3…`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md` — the protocol's own instructions for Claude's turn
- git history at `e1ce895b3da1387bae7ce50623afc3875cb050ba` (content to approve) and `cc635d4` (prior approval to retain)

## Findings / Items to Address
Source: Codex's brief, `logs/work-loop/context-engineering-implementation.md` § Brief.

1. **Premise 1 — accepted content.** The plan content at `e1ce895…` is the fully corrected content Codex accepted across both bounded correction rounds. Verify against the recorded plan blob `8517a7ef871ace5141b50e3ff16e5264913c9e1a`.
2. **Premise 2 — working tree unchanged.** The working-tree plan's *substantive* content is unchanged from `e1ce895…`. Verify by diff; any hit outside approval metadata is a stop condition.
3. **Premise 3 — header still open.** The plan header still reads draft / reapproval outstanding. If it already records the reapproval, the unit is done and nothing should be written.
4. **Premise 4 — canonical state.** The canonical state is `context-engineering-implementation` as named in the task-state frontmatter.
5. **Edit — approval metadata.** Record the exact reapproval statement, the commit hash, and the date 2026-08-02; restore stage/current approval status to plan of record; retain the prior `cc635d4` approval and the material-edit history. The approval binds to content at `e1ce895…`; this commit is necessarily later, since an approval record cannot sit inside the content it approves.
6. **Edit — task-state file.** Update § Current lane and unit and § Next action to say the reapproval is recorded; set `turn: codex`.
7. **Explicitly not repaired** (Codex's exclusion, carried as a deferral): the stale O-1 status wording in the plan header. It sits in the same header block as the edit target — do not opportunistically fix it.

## Execution Sequence
1. **Read the plan header and the recorded state.** Read the plan's approval-metadata block and § Next action. *Verify:* the exact line numbers of the approval block are identified before any edit is composed.
2. **Verify premises 1–2 by diff.** `git diff e1ce895 -- <plan path>` and confirm the blob hash at that commit is `8517a7ef…`. *Verify:* diff is empty, or every hunk falls inside the approval-metadata header. Any substantive hunk → STOP and report.
3. **Verify premises 3–4 by inspection.** *Verify:* header reads draft / reapproval outstanding; task-state frontmatter names `context-engineering-implementation`.
4. **Verify the two negative evidence points.** Candidate SHA-256 is `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`; `trials/slice-a-evidence.md` is absent. *Verify:* hash matches exactly; path test returns absent. (Absence already confirmed at plan time — re-confirm at commit time.)
5. **Write the approval record.** Edit only the approval-metadata header lines. *Verify:* re-diff against `e1ce895…` shows changes confined to those lines and nowhere else.
6. **Update the task-state file.** Current lane, § Next action, `turn: codex`. *Verify:* frontmatter reads `turn: codex`; no other section altered.
7. **Write falsifiable evidence into the task-state file** — the exact lines changed, the diff-confinement result, the candidate hash, the absence check. *Verify:* each evidence item names something that could have come out false.
8. **Commit plan and state together**, one commit. *Verify:* both paths in the same commit; nothing else staged. Do not push.

## Scope Alternatives
Single scope — no alternatives. Codex's brief fixes the scope to the approval metadata and the canonical state; the excluded list is explicit and the two stop conditions are the only branch points.

## Autonomy Posture
Full autonomy — the work is bounded to two files, the edit surface is a single header block, the exit condition is observable on disk and in git, and Codex holds the next turn as the independent check.

**Stop points:**
- The plan content no longer matches the accepted commit `e1ce895…` (any substantive diff hunk outside approval metadata) — stop, write nothing, report to the operator.
- Recording the approval would require changing anything outside the approval-metadata header — stop, write nothing, report.
- The candidate hash no longer matches `956c76f3…`, or `trials/slice-a-evidence.md` has appeared — either falsifies the recorded state; stop and report.

## Risk
No structural change classes apparent — re-size the review if scope changes. No hook, permission, CLAUDE.md, command, skill, or symlink is touched; the two edited files are a plan document and a task-state file.

The consequence that *is* real here is not structural but evidential: writing an approval record that binds to the wrong content, or that silently absorbs an out-of-scope edit, corrupts the plan of record for every downstream Work Loop v2 session. Step 2's diff-confinement check and Step 5's re-diff are what make that failure visible rather than silent. The independent review is Codex's closure check on the next turn, per the Work Loop v2 protocol — no separate Claude-side review runs.
