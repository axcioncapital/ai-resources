# Session Plan — 2026-05-25

## Intent
Fix the main↔subagent file-read duplication pattern in the `/session-start` command (SF1 structural fix wave, scoped to `/session-start`).

## Class
design

## Model
opus — → /model opus

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md`

## Findings / Items to Address
1. **Duplicate read of `logs/session-notes.md` (last 10 lines)** — Step 0 reads the file to check for today's header; Step 3 reads it again to locate today's header before writing the mandate line. The same file, same line window, same purpose (find today's `## YYYY-MM-DD` header). Source: `.claude/commands/session-start.md`, Steps 0 and 3.

## Execution Sequence
1. Read `.claude/commands/session-start.md` in full — confirm exact wording of both read instructions
2. Design the fix: Step 3's read instruction becomes a reference to the Step 0 result already in the model's context for this invocation
3. **Stop point** — state the proposed edit text; proceed only after this plan is approved
4. Edit `.claude/commands/session-start.md` to remove the duplicate read
5. Run `/qc-pass` on the edited file
6. Run `/risk-check` (plan-time gate already covers this if approved now; end-time gate before commit)
7. Commit

## Scope Alternatives
- **Min:** Remove the duplicate read in Step 3 only; reference the Step 0 result already held in context
- **Recommended:** Same as min — the duplication is isolated to these two steps; no wider refactor warranted in this session
- **Max:** Audit all other commands in `ai-resources/.claude/commands/` for the same two-read pattern (out of scope for this session per the mandate)

## Autonomy Posture
Gated

**Stop points:**
- After step 2 (design) — state the exact edit text and wait for plan approval before touching the file

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

Reason: editing an existing command that reads and writes `logs/session-notes.md` — removing a read instruction is a change to an automation with shared-state effects, which is a structural change class per the `audit-discipline.md` tripwire added in this week's `/wrap-session` refactor session.
