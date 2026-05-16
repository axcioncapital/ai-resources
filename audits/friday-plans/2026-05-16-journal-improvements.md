# Friday Act Plan — 2026-05-16 — journal-improvements

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 5

## Items

### 1. [high] Add SessionStart hook chain: mandate capture → /session-plan → /qc-pass → /scope
- **Source:** journal-derived
- **Risk-check required:** yes — change class: settings.json (SessionStart hook)
- **W2.4 auto-draft:** no
- **Detail:** Files: `.claude/settings.json` (SessionStart hook), `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/session-plan.md`. Add a SessionStart hook that captures the mandate and waits for operator confirmation. Once confirmed, the hook chain auto-invokes `/session-plan` → `/qc-pass` on the resulting session-plan.md → `/scope`. No further operator prompting needed after the initial mandate confirmation. Run `/risk-check` before implementing (shared-state automation + new hook wiring). Source: friday-journal-2026-05-16.md item 1.

### 2. [high] Fix /new-project to install all canonical commands and a decisions.md template
- **Source:** journal-derived
- **Risk-check required:** yes — change class: shared-state automation (affects every newly created project)
- **W2.4 auto-draft:** no
- **Detail:** File: `ai-resources/.claude/commands/new-project.md` (pipeline stages 3a–5). Two sub-issues: (1) New commands (session-start, session-plan, open-items, others added since last template update) are not being installed into newly created projects — update the canonical install list in the pipeline. (2) New projects don't receive a `logs/decisions.md` scaffold — add it to the project template. Run `/risk-check` before implementing (shared-state automation, affects all future project creation). Source: friday-journal-2026-05-16.md item 2.

### 3. [high] Update CLAUDE.md decision-point posture: Claude picks and proceeds, never asks "what do you recommend"
- **Source:** journal-derived
- **Risk-check required:** yes — change class: workspace CLAUDE.md
- **W2.4 auto-draft:** no
- **Detail:** Files: workspace root `CLAUDE.md` (§Decision-Point Posture section, already exists). Strengthen the wording: explicitly state Claude makes recommendations and proceeds automatically, never seeks operator confirmation on the recommendation itself, trusts downstream /qc-pass + /refinement-pass to catch issues. Add an explicit anti-pattern line: do not ask "what do you recommend" or equivalent. Run `/risk-check` before implementing (cross-cutting workspace CLAUDE.md edit). Source: friday-journal-2026-05-16.md item 3. Note: the section already exists — this is a targeted wording strengthening, not a new section.

### 4. [high] Expand /friday-act Step 1.5 required-reads beyond 30-line peek
- **Source:** journal-derived
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** File: `ai-resources/.claude/commands/friday-act.md` (Step 1.5 and Step 16a). Current spec limits SO advisory and Systems Review reads to first 30 lines (lightweight peek). This session demonstrated the gap: SO Recommendations and Systems Review Leverage Points are typically past line 30. Update the spec to: full-read for SO Recommendations + Observations sections; full-read for Systems Review Leverage Points; add improvement-log files for scoped projects as required reads; add project-internal session-notes + friction-logs as Loop 2 reads. Include a token-cost note in the spec. Source: friday-journal-2026-05-16.md item 4.

### 5. [med] Investigate /audit-repo vs /repo-dd overlap and produce written recommendation
- **Source:** journal-derived
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** Files to read: `ai-resources/.claude/commands/audit-repo.md`, `ai-resources/.claude/commands/repo-dd.md`. Output: written recommendation to `ai-resources/audits/repo-audit-commands-recommendation-2026-05-16.md` covering: keep both (with clear role separation), merge into one, or deprecate one. Include migration plan if recommending merge/delete. This is a read-and-synthesize task — no code changes in this session. Source: friday-journal-2026-05-16.md item 6.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- Items 1, 2, 3 require `/risk-check` before executing — run the check, implement only if verdict allows.
- Item 4 is a command-spec edit only — no risk-check required per literal change-class list. However, the new behavior (Loop 2 reads, improvement-log reads) is close to shared-state automation; re-evaluate the risk-check boundary at execution time before landing.
- Item 5 produces an analysis artifact only — no structural changes.
- Run `/wrap-session` when all items in this plan are done.
