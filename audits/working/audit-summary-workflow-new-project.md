# Summary — Workflow /new-project (Section 4)

**Total findings:** 7 (1 HIGH, 4 MEDIUM, 2 LOW). 1 affirmative observation.
**Severity counts:** HIGH 1 | MEDIUM 4 | LOW 2 (1 boundary)

**Workflow surface:**
- Orchestrator: `.claude/commands/new-project.md` — 698 lines / 6,883 words / ~8,948 tokens (largest command in repo).
- 6 stage subagents (3a–5 + optional Stage 6) + 1 gate-spawn (`/implementation-triage`) = 5–7 spawns per typical run.
- Orchestrator-session start cost: ~11,747 tokens (workspace CLAUDE.md + ai-resources CLAUDE.md + command file).

**Top 3 findings:**
1. HIGH — Orchestrator file is 698 lines / ~8,948 tokens; loads in full at every turn including continuation invocations that only need the Gate Protocol.
2. MEDIUM — Canonical Commit Rules / Input File Handling / Compaction / Session Boundaries blocks duplicated twice inside the orchestrator (lines 452–492 heredoc vs lines 497–523 printf-fallbacks) — ~100 lines of duplicated canonical content.
3. MEDIUM — Step 11a (line 153) does a main-session full `Read` of `projects/buy-side-service-plan/CLAUDE.md` to verify one model-ID string; delegable to grep / subagent / inline constant.

**Other findings:**
- MEDIUM — No quantitative `/compact` breakpoints; only 2 operator-discretion suggestions (line 184, 199); no compact prelude before the ~460-line Post-Pipeline Enrichment block.
- MEDIUM — Continuation mode loads ~1,300 tokens of First-Run-only setup logic on every resume.
- LOW — Stage 3c reads 5 input files (subagent context bloat, blast-radius bounded by ≤30-line return cap).
- LOW (boundary) — Workflow exceeds [COST] threshold (≥4 subagents) by design with 5–7 spawns/run.
- Affirmative — All 6 stage agents enforce ≤30-line return contracts with disk-persisted artifacts (no return-volume waste).

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-new-project.md`. Main session should read the full notes only if a specific finding needs deeper review.
