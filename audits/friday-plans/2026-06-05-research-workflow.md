# Friday Act Plan — 2026-06-05 — research-workflow

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 2

## Items

### 1. [med] Add `scripts/fix-mojibake.sh` UTF-8 normalization to the research-workflow raw-report intake (Step 2.2b)
- **Source:** checkup
- **Risk-check required:** no — new standalone utility script (not a hook, not auto-wired into a hook); confirm wiring at execution
- **W2.4 auto-draft:** no

Manual raw-report intake corrupts UTF-8 (mojibake) every Step 2.2b in research-pe. Add a `scripts/fix-mojibake.sh` normalization step to the research-workflow raw-report intake. If the fix wires the script into a hook (auto-run on intake) rather than a manual step, re-evaluate as a hook (.sh) risk-check class at execution.

### 2. [med] Reroute `improvement-analyst` archive de-dup to avoid the `Read(logs/*archive*.md)` deny (recurrence confirmed this run)
- **Source:** checkup
- **Risk-check required:** no — agent-definition logic edit (unless it changes a settings deny rule, then yes)
- **W2.4 auto-draft:** no

W2.4 recurrence CONFIRMED: `improvement-analyst` could NOT read `improvement-log-archive.md` this run because of the `Read(logs/*archive*.md)` deny, so de-dup ran against the active log only. Reroute the archive de-dup via Bash/grep, or pass archived titles in the payload, so the deny rule is not hit. Agent-definition logic edit; only escalate to risk-check if the chosen fix instead loosens the settings deny rule.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
