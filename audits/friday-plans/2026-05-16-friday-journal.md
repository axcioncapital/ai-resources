# Friday Act Plan — 2026-05-16 — friday-journal

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 3

## Items

### 1. [med] Add QC sub-agent pass to /friday-journal: flag vague items + merge duplicates
- **Source:** journal-derived
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** File: `ai-resources/.claude/commands/friday-journal.md` (Step 5.5 extension). Extend the existing qc-reviewer handoff to include two new focus areas: (a) vague-content detection — flag items with "TBD," "investigate," or undefined scope; (b) duplicate-merge detection — flag items that overlap significantly and propose merge directives. Approach: agent either asks operator clarifying questions OR searches repo-documentation for answers before flagging. Source: friday-journal-2026-05-16.md item 9.

### 2. [med] Add drop-check step to /friday-journal: verify no journal content silently dropped
- **Source:** journal-derived
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** File: `ai-resources/.claude/commands/friday-journal.md` (new step before Step 6 / archive). After QC + refinement passes, run a deterministic check comparing the original parsed journal entries (preserved verbatim per Step 1.6) against the final Items + Item context Source-entry fields. Any entry not represented in the final report is flagged. Operator dispositions each flagged drop: intentional / restore. Source: friday-journal-2026-05-16.md item 11.

### 3. [low] Add risk-check step to /friday-journal: auto-flag items carrying implementation risk
- **Source:** journal-derived
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** File: `ai-resources/.claude/commands/friday-journal.md` (new step in or after Step 5.5). After QC pass, run a deterministic risk-check that cross-references each Item against `docs/audit-discipline.md` Risk-check change classes (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands, new symlinks, shared-state automation). Items matching a class get a `**Risk-check required:**` bullet in Item context automatically. Step 5.5 already supports manual `f` disposition for this; this item makes the flagging automatic. Source: friday-journal-2026-05-16.md item 14.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- Items 1–3 are flagged no risk-check per literal change-class list (editing an existing command, not a new one). However, all three add new automation logic (subagent, deterministic check, cross-reference step) to a shared command — close to the shared-state-automation boundary. Re-evaluate the risk-check boundary at execution time before landing any of the three.
- Treat items 1 and 2 as a pair: implement in the same session since both extend the Step 5.5 / pre-archive phase.
- Run `/wrap-session` when all items in this plan are done.
