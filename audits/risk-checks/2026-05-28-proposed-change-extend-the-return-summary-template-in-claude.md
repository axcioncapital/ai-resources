# Risk Check — 2026-05-28

## Change

Proposed change: extend the return-summary template in `.claude/agents/fix-repo-issues-scanner.md` to expose coverage-audit transparency.

**What changes (Option A from triage report `audits/working/2026-05-28-resolve-fix-repo-issues-scanner-coverage-confidence-gap.md`):**
1. Add a new "Coverage report" block to the mandated return-summary template, with these lines:
   - `Sources scanned: {list of source files actually read}`
   - `Out-of-contract sources: {explicit list of source classes the scanner does NOT read — e.g., session-notes Next Steps, audit reports, audits/working/ pending notes}`
   - `Exclusion counts by category: {N FADING-GATE verified, N STUB discarded, N applied+Verified, N parked-with-reason, N watch-only, ...}`
   - `Deferred counterweight: {M decisions.md Defer entries observed, K currently triggered}`
2. Re-segment "Top candidates" by item-type BEFORE priority ranking:
   - `Fix-shaped (actionable now): {list}`
   - `Build-shaped (separate /create-skill session): {list}`
   - `Watch-shaped (park/threshold, no action): {list}`
3. Bump the 30-line summary cap to ~40 to accommodate the audit trail.

**Files touched:** `ai-resources/.claude/agents/fix-repo-issues-scanner.md` (single-file edit).

**Change class:** Canonical-agent body edit (Autonomy Rule #9 / audit-discipline.md).

**Motivation:** Scanner output today returned 9 items, only 1 fix-shaped, but the terse summary intermixed T1 fix items with T1 inbox build briefs and stripped the 16 exclusion bullets from the working-notes file. Operator pushback was the only signal coverage was insufficient. Triage option A from MANUAL `/resolve-repo-problem` cycle today; logged-pending in `improvement-log.md`.

**Blast radius:** Only `/fix-repo-issues` consumes this agent. No other commands invoke `fix-repo-issues-scanner`. Output format change does not break the command body — Step 2 reads the summary in main context and Step 3 builds the plan preview from it; both are LLM-driven reads, not regex extractions.

**Reversibility:** Single file. Trivial to revert via git if the new summary shape proves noisy.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/fix-repo-issues-scanner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/2026-05-28-resolve-fix-repo-issues-scanner-coverage-confidence-gap.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/fix-repo-issues.md — exists

## Verdict

GO

**Summary:** Single-file, fully reversible agent-body edit on a sole-consumer agent; LLM-read downstream contract tolerates the shape change; no permission, hook, or shared-state effect.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Agent is loaded only when `/fix-repo-issues` invokes it (Step 1 of `.claude/commands/fix-repo-issues.md` lines 23-37); it is not auto-loaded, not registered to a SessionStart/Stop/PreToolUse hook, and not @imported by any always-loaded CLAUDE.md.
- Summary cap rises from 30 to ~40 lines (per CHANGE_DESCRIPTION item 3). The added cost lives in *agent output* returned per `/fix-repo-issues` invocation — not in always-loaded context — and `/fix-repo-issues` is itself rare (operator-invoked, currently ~2× in 2 days per the triage report).
- Agent-body itself grows by an estimated ~15-25 lines of template text (new Coverage report block + re-segmented Top candidates structure + cap bump touches lines 106, 116-121, 133 of `fix-repo-issues-scanner.md`). This is pay-as-used: loaded only when the agent is spawned.
- No `@import` chain added. No skill auto-load trigger added.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION names no `settings.json` edit, no `allow`/`ask`/`deny` adjustment, no new tool-family invocation.
- Agent frontmatter `tools:` block (`fix-repo-issues-scanner.md` lines 5-9: Read, Glob, Grep, Write) is not in the proposed change scope.
- No new Bash patterns, no Write targets outside the existing working-notes directory, no MCP / external API.

### Dimension 3: Blast Radius
**Risk:** Low

- Grep across `ai-resources/` for `fix-repo-issues-scanner` returns 7 hits across 5 files; the only *invoking* reference is `.claude/commands/fix-repo-issues.md` (lines 23-37). The other 6 hits are documentation/audit references (`docs/agent-tier-table.md` line 23, `logs/improvement-log.md` lines 168-170, two `audits/repo-due-diligence-...` files) — none consume the summary format.
- The sole consumer `/fix-repo-issues` reads the summary via LLM context in Step 2 (line 52: "Read the scanner summary in main context") and Step 3 (lines 73-90: plan preview built from summary). Both are LLM-driven, not regex/grep extractions, so they tolerate added blocks and re-segmented lists without code change.
- The one machine-extracted contract — the trailing `NOTES: {WORKING_NOTES_PATH}` line (Step 7 line 120 of agent body; consumed by command Step 1 line 37: "The last line of the summary has shape `NOTES: ...`") — is unchanged by the proposed edit. CHANGE_DESCRIPTION items 1-3 all modify content *before* the NOTES line, preserving the "last line" parse anchor.
- Working-notes file schema (lines 78-102 of agent body) is not modified by Option A; the triage report explicitly scopes the change to the *summary* template only (working notes already contain the audit trail in 16 Skipped bullets per the triage report § Root-cause diagnosis).
- Enumeration: 1 invoking caller (`/fix-repo-issues`), 0 callers requiring modification, 0 broken contracts.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to `.claude/agents/fix-repo-issues-scanner.md`. Clean `git revert` fully restores prior state.
- No sibling files created. No log/data file mutated. No settings.json edit. No external write. No hook registered.
- Operator workflow continuity: the consuming command `/fix-repo-issues` is invoked manually; rolling back the agent simply restores the prior summary shape on the next invocation. No muscle-memory or cached-state penalty.
- Triage report `improvement-log.md` line 168 already records the proposal as logged-pending; a revert would also require updating the improvement-log entry's `Status:` to reflect the reversal — one-line edit, but worth noting. Not blocking.

### Dimension 5: Hidden Coupling
**Risk:** Low

- One explicit contract preserved: `NOTES: {WORKING_NOTES_PATH}` as last line of summary (agent line 123: "The `NOTES:` line MUST be the last line of the summary so the main session can extract the path reliably"; consumed at command Step 1 line 37). CHANGE_DESCRIPTION items 1-3 add content *before* this line and re-segment a list *within* the summary body — the trailing NOTES anchor is unaffected.
- One implicit contract preserved: command Step 2 (line 52) reads the summary in main context with LLM judgment, not a regex. Re-segmenting Top candidates by item-type (fix / build / watch) before priority ranking is interpretable by the downstream LLM read; the command's Step 3 plan-preview groupings (Plan-into-batch / Park / Skip — lines 78-90) are *triage decisions* over the items, orthogonal to the scanner's item-type tagging. The two layers do not collide.
- No silent auto-fire context: the agent only runs when `/fix-repo-issues` Step 1 invokes it explicitly.
- No functional overlap introduced: item-type segmentation (fix / build / watch) is a *new* axis the scanner exposes; the command's Plan-into-batch / Park / Skip groupings continue to handle triage. The triage report § Root-cause diagnosis explicitly identifies this as a non-conflict ("build briefs and fix items both land in 'Plan-into-batch' undifferentiated" — the new typing *informs* the triage rather than replacing it).
- Line-cap bump 30 → 40: the agent body references the cap in three places per the triage report § Implementation notes (Step 7 intro, Step 7 closing rule, Rules section line 133). All three must be updated consistently or the agent's self-enforcement of the cap diverges from the template. This is a localized within-file consistency requirement, not cross-file coupling — flagged as an implementation-detail to watch but not a coupling risk.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). No training-data fallback was used on fetch/read failures. Grep across `ai-resources/` for `fix-repo-issues-scanner` returned 7 hits across 5 files (one invoking caller `.claude/commands/fix-repo-issues.md`, four documentation/audit references). Agent body, command body, and triage report all read in full.
