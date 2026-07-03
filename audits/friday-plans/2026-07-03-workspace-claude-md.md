# Friday Act Plan — 2026-07-03 — workspace-claude-md

**Source report:** friday-checkup-2026-07-03.md (quarterly tier)
**Journal report:** (none)
**Generated:** 2026-07-03
**Items:** 1

## Items

### 1. [med] Trim the workspace CLAUDE.md rare-firing gate blocks to trigger+pointer form (230 → under 200 lines)
- **Source:** checkup
- **Risk-check required:** yes — change class: workspace CLAUDE.md edit (always-loaded)
- **W2.4 auto-draft:** no
- From the concurrent session's committed workspace+redesign claude-md audit (5 HIGH / 12 MEDIUM / 6 LOW; ~1,035 tok/turn savings available): a cluster of rare-firing gate blocks (e.g., Blind-Spot Scan Gate, Assumptions Gate, QC → Triage Auto-Loop pointers) carry full trigger/skip mechanics inline where a one-line trigger + pointer to the referenced doc would serve. See `audits/claude-md-audit-2026-07-03-project-axcion-ai-system-redesign.md` for the full per-block findings.

## Execution notes
- Commit separately (workspace commit-behavior rules).
- Risk-check required — always-loaded workspace CLAUDE.md is read into every session in this repo tree; a bad trim risks losing load-bearing rule content, not just token savings.
- Verify the target doc each gate points to (e.g. `docs/audit-discipline.md`, `docs/qc-independence.md`) already carries the full mechanics before trimming the inline copy — do not trim before confirming the pointer target is current.
- Run `/wrap-session` when done.
