# Decision Journal

> Archive: [decisions-archive-2026-04.md](decisions-archive-2026-04.md)

## 2026-05-01 — permission-sweep CRITICAL (Rule 4): confirmed false positive

**Context.** /permission-sweep 2026-05-01 flagged a CRITICAL Rule 4 finding: "allow list missing entries" for ai-resources/.claude/settings.json. The report itself noted a bypass-mode caveat.

**Decision.** Finding is a false positive. No changes to settings.json. Auditor Rule 4 needs a bypass-mode exception.

**Rationale.** `defaultMode: bypassPermissions` is the agreed operator setup (per memory feedback_zero_permission_prompts.md). Under bypass mode, the allow list is a secondary safety layer, not the primary enforcement mechanism. The auditor's "missing entries" rule does not model this design. The correct fix is an auditor rule exception, not a file change.

**Alternatives considered.**
- *Add all flagged allow entries.* Rejected: redundant under bypass mode; adds noise to an intentionally minimal list; contradicts operator's zero-permission-prompt posture.

---

## 2026-05-02 — MCP servers culled to github-only

**Context.** Session evaluated 16 installed MCP plugins against actual Axcion workflow usage. Claude Code loads every enabled plugin's tool schema on every turn regardless of use — each plugin consumes context permanently.

**Decision.** Keep only github. Disable all 15 others (asana, context7, discord, fakechat, firebase, gitlab, greptile, imessage, laravel-boost, linear, playwright, serena, supabase, telegram, terraform) by renaming their `.mcp.json` to `.mcp.json.disabled`.

**Rationale.** Operator confirmed only github is actually used in Axcion sessions. 15 unused plugins were loading tool schemas into context on every turn with zero benefit. Disabling is reversible — rename `.mcp.json.disabled` back to `.mcp.json` to re-enable any plugin.

**Alternatives considered.**
- *Keep linear:* considered given Axcion uses Linear for task tracking. Operator declined — not accessed via Claude Code sessions.
- *Keep all and rely on ≤10 guideline:* rejected — guideline is from source document, not authoritative; actual usage confirmed 15 of 16 unused.

---

## 2026-05-02 — Context engineering checks: token-audit Section 8 vs. alternatives

**Context.** Operator found Anthropic's context engineering article and wanted to incorporate its best practices into the audit infrastructure. Three structural options were considered: (1) standalone context-audit command, (2) new section in friday-checkup, (3) extending token-audit Section 8.

**Decision.** Extend token-audit Section 8 (Best Practices Comparison). Added items 13–15 covering inter-skill trigger disambiguation, structured agent/skill prompts, and few-shot examples. Protocol bumped to v1.3.

**Rationale.** Token-audit already runs monthly via friday-checkup; extending Section 8 gives automatic friday cadence coverage with no structural changes to either command. Section 8 is already an "article-derived best practices" checklist — the new items fit the existing pattern exactly. Creating a standalone command or new friday-checkup section would add maintenance surface for the same analytical work.

**Alternatives considered.**
- *Standalone /context-audit command.* Rejected: separate command to maintain; same coverage achievable by extending token-audit.
- *New §L section in friday-checkup.* Rejected: requires friday-checkup edits; token-audit already runs monthly there.
- *Extend token-audit + add to friday-checkup.* Rejected: redundant; token-audit already wired in.

## 2026-05-02 — Cluster analysis gate granularity

**Context:** Rewriting /run-cluster to use parallel subagents required choosing whether the operator review gate stays per-cluster (one pause per cluster as each memo is produced) or consolidates to per-section (one pause after all clusters complete).

**Decision:** Per-section gate. All refined cluster memos reviewed together at the end of /run-cluster.

**Rationale:** Parallel subagents produce all memos simultaneously, so per-cluster gating would require an artificial serialization that defeats the parallelism benefit. Per-section review is also more coherent — the operator sees all analytical threads at once before deciding whether to proceed. This matches the existing pattern in /run-synthesis. Operator confirmed without modification.

**Alternatives considered:**
- *Per-cluster gate (status quo).* Rejected: incompatible with parallel execution; would require sequential dispatch with artificial waits.
- *Hybrid: per-section but with early-abort option.* Not needed — if a cluster memo has issues, the operator reviews them all anyway and can redirect before /run-analysis.

---

## 2026-05-02 — Quality log location for cross-project extract tracking

**Context:** Adding a cross-project extract quality log raised the question of where it lives: inside ai-resources/logs/ (portfolio-level, one file) vs inside each deployed project's own logs/ directory (local, per-project).

**Decision:** Local log at `workflows/research-workflow/logs/research-quality-log.md`. Each deployed project writes its own quality log; cross-project aggregation is manual when needed.

**Rationale:** Workspace CLAUDE.md prohibits editing ai-resources skill files from project workspaces. While log-append is a different operation, putting the log in ai-resources would introduce a new cross-repo write convention that needs explicit policy exception. Local logging keeps each project self-contained and requires no policy change. The cost is that cross-project comparison requires manually aggregating individual project logs.

**Alternatives considered:**
- *ai-resources/logs/research-quality-log.md.* Rejected: requires cross-repo write from project sessions; introduces new convention that contradicts existing "no editing ai-resources from project workspaces" posture.
