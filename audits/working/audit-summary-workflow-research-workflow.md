# Section 4 Summary — research-workflow (full pipeline)

**Audit date:** 2026-05-02 (overwrites 2026-05-01 prior content).
**Scope:** End-to-end research-workflow at `ai-resources/workflows/research-workflow/` — 28 commands, 4 agents, reference docs, two embedded skills.
**Telemetry:** None. All findings are structural inferences from file content.

**Findings:** 15 total — HIGH: 5 (F1, F2, F3, F7, F8); MEDIUM: 7 (F4, F5, F6, F9, F11, F13, F15); LOW: 3 (F10, F12, F14).

**Top 3 findings:**
1. **F1 (HIGH)** — Subagent return contract enforced at only 6/50 launch sites (~12%); ~44 sites use unbounded "Return: ..." instructions. `run-report.md` Step 4.2a literally returns "chapter draft content" to main session.
2. **F2 (HIGH)** — `run-report.md` Step 4.0 pre-loads ~30,000+ tokens (all extracts, memos, directives, recommendations) into main session; held resident for ~30+ subsequent dispatches per Stage 4.
3. **F3 (HIGH)** — CLAUDE.md `@`-imports four reference files (~6,197 tokens) on every turn despite a "load when working" instruction the `@` mechanism cannot honor; per-turn fixed cost ~7,679 tokens.

**Other HIGH:** F7 (review/verify-chapter load 7+ inputs in main session before delegating), F8 (chapter prose returned to main).

**Notable boundary/spec finding:** F15 (MEDIUM) — `run-cluster.md` command file still implements content-pass sequential pattern; updated `stage-instructions.md` Step 3.2 specifies path-pass parallel pattern. Command-vs-spec divergence.

**Boundary findings (±15% of threshold):** F3, F5, F13 — main-session protocol confidence ratings.

Full evidence in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-research-workflow.md`. Main session should read the full notes only if a specific finding needs deeper review.
