# Summary — Workflow /new-project (Section 4)

**Total findings:** 8 (1 PASS + 5 MEDIUM + 2 LOW)
**By severity:** HIGH 0 | MEDIUM 5 (3 boundary-tagged) | LOW 2 | PASS 1

**Workflow surface:** orchestrator `.claude/commands/new-project.md` (527 lines / ~6863 tokens) + 6 spawned agents (`pipeline-stage-3a/3b/3c/4/5`, `session-guide-generator`). Total agents 387 lines / ~1955 tokens. Estimated main-session start-of-workflow context: ~12,261 tokens (workspace CLAUDE.md + ai-resources CLAUDE.md + orchestrator body).

**Top 3 findings:**
1. [MEDIUM] Five pipeline-stage agents (3a/3b/3c/4/5) lack an explicit return-size cap; only `session-guide-generator` declares "under 30 lines."
2. [MEDIUM, boundary] Orchestrator file is 527 lines / ~6863 tokens with canonical blocks duplicated ~3× across reference text + heredoc + printf fallback (~60–90 redundant lines).
3. [MEDIUM] No `/compact` breakpoint declared between pipeline stages; full 6-subagent run accumulates returns + gate exchanges without structural compaction prompt.

**Other findings:** Stage 3a inventory output structurally enables large-table echo if operator prompts (MEDIUM, boundary). Stages 3b and 3c both Read `repo-snapshot.md` — subagent-side duplication on opus tier (LOW). No QC/refinement subagents wired into pipeline; operator gates substitute (LOW). Model tiering correct: orchestrator + 3a/4/5/6 sonnet, 3b/3c opus (PASS).

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-new-project.md`. Main session should read the full notes only if a specific finding needs deeper review.
