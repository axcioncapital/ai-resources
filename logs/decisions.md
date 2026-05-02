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
