# Friday Act Plan — 2026-06-05 — coach-agent

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 1

## Items

### 1. [med] Add a guardrail so the collaboration-coach agent anchors to its assigned project root (3/9 misrouted this run)
- **Source:** checkup
- **Risk-check required:** no — agent-definition / command-text edit (not a structural change class)
- **W2.4 auto-draft:** no

The `collaboration-coach` agent misrouted on 3 of 9 scopes this run — it abandoned its assigned project root for a richer corpus (ai-resources / buy-side) when local logs looked sparse. All 3 were re-run with hard path-anchoring and produced correct analyses. Add a guardrail in the `/coach` command (or the agent definition) that hard-anchors the agent to its assigned project root and forbids wandering to a richer corpus when local logs are sparse. Agent/command-text edit; no risk-check class.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
