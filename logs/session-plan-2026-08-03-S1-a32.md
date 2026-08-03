# Session Plan — 2026-08-03

## Intent
Run Claude's turn of Work Loop v2 Context Engineering unit S3b (shadow slice) — verify the four stated premises, write the shadow observation record, update the canonical task-state file, set `turn: codex`, and stop.

## Model
opus — match (active session model is Opus 5, and the unit turns on judging evidence and writing findings capable of failing, not on mechanical edits).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — the contract; read first, every invocation
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md` — Claude's half of the unit cycle
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/context-engineering-implementation.md` — the task-state file (`turn: claude`); carries the S3b brief
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` — premise 1's hash target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/trials/slice-a-evidence.md` — the S3 precedent for evidence shape
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` — plan of record (read-only)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` — governing specification (read-only)

## Findings / Items to Address

**Premises to verify** (state file § Brief, `logs/work-loop/context-engineering-implementation.md:28-38`):

1. `trials/candidate/SKILL.md` still hashes SHA-256 `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`.
2. Systems Builder's `logs/work-loop/crm-derived-answer-authority.md` is the closed four-field record; implementation commit `3855947` and closing-state commit `a0ae384` are separate.
3. `trials/shadow-slice-record.md` is absent at that exact path, and no genuine-unit change is present in this repository.
4. Claude's explicit verdict is **yes, the candidate-produced brief was sufficient** — nothing asked back, no premise failed, correct work began without guessing, one pass, no correction round.

**Content the record must carry** (state file § Scope, `:40-46`): the genuine objective and task path; both Systems Builder commits; the explicit sufficiency verdict quoted; ask-back count (0) and operator context-assembly-action count (0) with derivation for each; an explicit statement that this was the isolated shadow proof, not the integrated proof. The manual Codex↔Claude turn-carrying after work began is disclosed **separately, as integration friction** — never relabelled as context assembly and never omitted.

**Four negative usability findings to record verbatim as S4–S7 constraints** (state file `:51-58`), not as new behaviours or candidate changes:

1. An `exactly these surfaces` claim combined with an instruction to search for more must say what happens when the search finds the same defect inside an already-allowed file — same-defect findings inside the allowed set may be corrected; a new file or defect requires hand-back.
2. Where established section numbers carry external citations, state that existing numbering must remain stable or require citation repair inside scope.
3. A request for the `minimum structural distinction` needs a checkable floor as well as a ceiling.
4. A negative scan's searched surface must match its pass condition; historical rationale quoting a wrong phrase is not a stale record claim and must not make an otherwise-correct record-surface scan impossible.

**Evidence-capable-of-failing obligations** (state file `:65-69`): quote the verdict; state both counts and their derivation; list at least one negative finding and the attempt that found it; show real-unit and shadow-record commits are separated by repository and purpose; show the candidate hash unchanged and that only the shadow record plus the state file changed here.

## Execution Sequence

1. **Read the core, then the command.** `work-loop-v2-executable-core-v0.1.md` first, every invocation — it is the contract and it wins over the command on any disagreement. *Verify:* the five safety rules and the unit cycle are in context before any file is touched.
2. **Orient on the state file.** Confirm frontmatter `task: context-engineering-implementation` matches the resolved task id and `turn: claude`. *Verify:* both match; on a mismatch, report both values and change nothing (core § 6 rule 2).
3. **Verify premise 1 by inspection.** `shasum -a 256` the candidate `SKILL.md`. *Verify:* digest equals the stated hash character-for-character. Mismatch → stop and hand back.
4. **Verify premise 2 by inspection.** Locate the Systems Builder repository, read `logs/work-loop/crm-derived-answer-authority.md`, confirm the four-field closed record, and confirm `3855947` and `a0ae384` are two distinct commits with distinct purposes. *Verify:* both commit objects resolve and their subjects differ in kind (implementation vs. closing state).
5. **Verify premise 3 by inspection.** `test -e` the exact shadow-record path; confirm this repository's working tree carries no genuine-unit change. *Verify:* path absent, and `git status` shows no crm-derived-answer-authority artifacts here.
6. **Verify premise 4.** Confirm the sufficiency verdict is Claude's own explicit statement on record, not a reconstruction. *Verify:* the verdict is quotable from a durable source; if it is only recallable, that is a failed premise — hand back rather than manufacture it.
7. **Write `trials/shadow-slice-record.md`.** Every item from Findings above, with the friction disclosure kept structurally separate from the context-assembly count. *Verify:* each of the six Scope items and each of the five evidence obligations is present and individually checkable.
8. **Update the task-state file.** Rewrite § Latest material result and § Next action to current truth; set `turn: codex`. *Verify:* `turn: codex` on disk; carried deferrals list preserved unchanged.
9. **Commit both files together in `ai-resources`.** *Verify:* one commit, exactly two paths, message in `update:` form. No push.

## Scope Alternatives
Single scope — no alternatives. The brief fixes the deliverable, its contents and its exclusions; the only branch is premise-failure, which halts rather than reduces scope.

## Autonomy Posture
Full autonomy — the deliverable, its contents and its exclusions are fully specified by the state file, and the exit condition is observable on disk.

**Stop points:**
- Any of the four premises is false → hand back to Codex per core § 3, change nothing else, do not write the record.
- Writing the record would require altering the genuine unit or the candidate → stop and surface.
- Premise 4's verdict turns out to be recall rather than record → treat as a failed premise; do not reconstruct it.

## Risk
No structural change classes apparent — the work adds one markdown record under `plans/` and edits one task-state log; no hooks, permissions, CLAUDE.md, commands, skills, symlinks or shared-state automation are touched. Re-size the review if scope changes.
