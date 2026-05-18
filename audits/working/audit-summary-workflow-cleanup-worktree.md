# Section 4 summary — /cleanup-worktree (2026-05-18 re-audit)

**Workflow:** /cleanup-worktree (command + worktree-cleanup-investigator skill + 2 references + qc-reviewer + triage-reviewer agents)
**Total findings:** 5 flagged (1 HIGH-boundary, 2 MEDIUM, 2 LOW) + 2 positive controls (not findings)

**Mandatory floor (per invocation):** ~8,361 tokens (command 165 lines + SKILL.md 247 lines).
**Realistic ceiling with references resolved:** ~16,908 tokens main-session before per-path reads.
**Typical main-session total per run:** ~18,881–26,688 tokens (structural inference; no telemetry).

**Subagents per run:** baseline 3 (1st QC always + triage always + 2nd QC unless quick-tier skip); quick-tier-skip minimum 2; max permitted 5 (cycle-3 forced stop).
**Subagent return contract:** ≤20-line summary + path to disk-written report. Output-to-disk pattern correctly implemented (Steps 17/21/26). No HIGH "subagent returning >200 lines" finding.

**Top 3 findings:**
1. HIGH (boundary) — `execution-protocol.md` reference file at 337 lines / ~5,912 tokens; 12.3% above the 300-line HIGH threshold (within ±15% boundary band). Trigger points span Steps 5/6/7/9/11; cumulative load approaches full file in a typical run.
2. MEDIUM — Mandatory command + skill load ~8,361 tokens per invocation. SKILL.md at 247 lines (150–300 MEDIUM band). Portions are skill-discovery / post-execution content rather than per-turn-needed.
3. MEDIUM (structural) — Plan-mode content (8-section schema for 10–14 paths = ~1,000–2,500 tokens) lives in main-session context across Steps 5–11. Non-delegable — agent IS the plan author.

**Positive controls noted:** compact breakpoints present (Steps 4/7 conditional); `find-template.sh` correctly bundled as execute-only.

**Operator-brief item flags confirmed:** (a) command+skill combined cost ~8,361 tokens loaded every run — confirmed. (b) Plan-mode output IS main-session context — confirmed (F3). (c) Subagents write to disk + return summaries — confirmed (F4). (d) QC auto-loop fires every run — confirmed (F5), bounded at 3 typical / 5 worst case.

**Full evidence in** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-cleanup-worktree.md. Main session should read the full notes only if a specific finding needs deeper review.
