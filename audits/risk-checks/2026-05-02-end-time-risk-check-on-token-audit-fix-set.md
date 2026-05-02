# Risk Check — 2026-05-02

## Change

End-time risk-check on the executed change set committed in 9992cf2 (12 files, ~74 insertions / ~9 deletions). Implements 5 token-audit recommendations:

(M1) settings.json: added "Read(audits/working/**)" to deny array.
(M3) Added "## Return Contract" sections (4-line additions, ≤30-line return cap) to 5 pipeline-stage agents (3a, 3b, 3c, 4, 5) used by /new-project orchestrator.
(H3) workflows/research-workflow/CLAUDE.md template: replaced 4 "@reference/X.md" import directives with backtick-wrapped prose pointers ("`reference/X.md`"). The "@" prefix unconditionally loads files; backtick form is a non-loading reference. Net: ~6,200 tokens/turn saved in deployed research-workflow projects. Template only — does not affect ai-resources main session.
(H5) NEW agent: .claude/agents/findings-extractor.md (haiku tier, tools: Read only, ≤30-line return). Modified friday-checkup.md Step 7.16 to delegate findings extraction to this new agent rather than reading 893 lines / ~10,300 tokens of sub-reports into main session.
(M2) Added "▸ /compact" advisory breakpoints at:
  - new-project.md Gate Protocol (NEXT case): suggestion before spawning next stage subagent.
  - repo-dd.md: between Step 7 (factual commit) and Deep Operational Assessment header; between Step 60 (deep report saved) and Step 13 (Pipeline Testing).
  - friday-checkup.md: between sections D (/audit-claude-md) and E (/token-audit) in Step 5.
  - friday-act.md: between Step 3 (tactical loop) and Step 4 (policy review).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/findings-extractor.md — exists (created this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-3a.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-3b.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-3c.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-4.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-5.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/repo-dd.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists (template; deployed via /sync-workflow)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change set is net token-positive and most dimensions are Low/Medium, but the M1 deny rule `Read(audits/working/**)` collides with two existing commands (`/innovation-sweep` Step 7.27 and `/audit-critical-resources` Step 26) that read main-session working-notes from that directory — a viable mitigation exists (allow-list those specific reads or scope the deny rule), so verdict stays at PROCEED-WITH-CAUTION rather than RECONSIDER.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Net token impact is strongly positive. H5 alone removes a documented ~10,300 tokens/turn from `/friday-checkup` Step 7.16 by delegating to a haiku subagent — evidence: `friday-checkup.md:362` ("Spawn the `findings-extractor` subagent (haiku tier)... do not read sub-reports directly into main-session context").
- H3 removes 4 `@reference/...` always-load imports from deployed research-workflow projects (~6,200 tokens/turn saved per active research project). Verified: `grep` against `workflows/research-workflow/CLAUDE.md` shows zero remaining `@reference` imports — only backtick-prose pointers (lines 11, 36, 49, 73, 85, 89).
- M3 adds ~4 lines × 5 agents = ~20 lines total to subagent briefs, but these agents are pay-as-spawned (only when `/new-project` is run), not always-loaded. Marginal cost.
- M2 adds advisory text (`▸ /compact` lines) to 4 commands. These are pay-as-loaded (only when the slash command runs), not always-loaded. ~2 lines per insertion, 6 insertions total — negligible.
- New agent file `findings-extractor.md` (37 lines) is pay-as-spawned, not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- M1 adds a deny entry only — does not widen any allow surface. Evidence: `settings.json:19` adds `"Read(audits/working/**)"` to the `deny` array (line 10–20).
- No allow entries added; no deny entries removed; defaultMode unchanged (`bypassPermissions`, line 21).
- The new deny rule narrows the read surface (restrictive direction). From a permissions-surface perspective this is a tightening, not a widening.
- (Note: the operational consequence of this tightening is captured under Dimension 3 — it breaks existing read patterns. Permissions-surface dimension scores the direction of permission change, not the downstream effect.)

### Dimension 3: Blast Radius
**Risk:** High

- **Enumeration of grep'd components:**
  - `findings-extractor` referenced in: 1 caller (`friday-checkup.md` line 362). Single caller; clean.
  - `pipeline-stage-3a/3b/3c/4/5` referenced in: 1 caller (`new-project.md`, the orchestrator) plus the agent files themselves. Single caller; clean.
  - `audits/working/` is referenced from 4 places under `.claude/`:
    - `settings.json:19` (the new deny rule)
    - `hooks/auto-qc-nudge.sh:14` (skip pattern — read-only via grep, not affected by deny)
    - `commands/audit-critical-resources.md:147` (grep exclusion — `--exclude` does not invoke `Read` so not affected) and `commands/audit-critical-resources.md:200` (orchestrator main-session reads working-notes file body — **AFFECTED**)
    - `commands/innovation-sweep.md:134` ("Read `{WORKING_NOTES_PATH}` once into main session") and `commands/innovation-sweep.md:258` (note about gitignored — not a read) — **AFFECTED at line 134**
- **Confirmed contract break, single direction:** `/innovation-sweep` Step 7.27 (line 134) explicitly performs `Read` on a path under `audits/working/`. `/audit-critical-resources` Step 26 (line 200) likewise reads working-notes file bodies. The deny rule blocks both. Verbatim from `innovation-sweep.md:134`: "Read `{WORKING_NOTES_PATH}` once into main session."
- No `settings.local.json` allow-override exists for `Read(audits/working/**)` — checked: only `{"model": "claude-sonnet-4-6[1m]"}`.
- M3 (return contract additions) is purely additive documentation — no contract change for the orchestrator (`/new-project` already expects ≤30-line returns per the workspace-level subagent contract). Zero callers need modification.
- M2 advisory text changes are inert prose — no caller depends on them; no contract impact.
- H5 new agent (`findings-extractor`) has exactly 1 caller (`friday-checkup` Step 7.16). Forward-compatible.
- H3 template change affects future `/sync-workflow` propagations, not running ai-resources sessions. The deployed research-workflow projects already have the old `@import` form; until `/sync-workflow` runs, they continue to work as before. No live blast.

### Dimension 4: Reversibility
**Risk:** Low

- Commit `9992cf2` is local-only (not pushed per operator's note). `git revert 9992cf2` (or `git reset` since it's the most-recent commit) cleanly reverts all 12 files in one operation.
- New file `findings-extractor.md` is tracked and revert removes it cleanly.
- No data/log mutations: change set does not write to `innovation-registry.md`, `improvement-log.md`, `session-notes.md`, or any append-only history.
- No external state propagation (no push, no Notion write, no API call).
- No new automation hooks — the change adds advisory prose and a manually-invoked subagent, not a SessionStart/PostToolUse trigger.
- The audit/risk-checks artifact written by this very session (`2026-05-02-end-time-risk-check-on-token-audit-fix-set.md`) is outside commit `9992cf2` and would not be auto-cleaned by revert; manual delete required as one cleanup step. Borderline-Medium but fits Low because it's a single file delete in a documented location.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One implicit dependency surfaced:** The M1 deny rule presupposes that `audits/working/**` is purely subagent-internal scratch space. The token-audit recommendation that motivated M1 likely treated working-notes as out-of-context-budget for the main session — but `/innovation-sweep` and `/audit-critical-resources` deliberately read these notes back into the main session at the synthesis stage. The deny rule contradicts that established pattern without updating the affected commands. Evidence: `innovation-sweep.md:134`, `audit-critical-resources.md:200`.
- M3 return-contract additions document a contract that the workspace-level subagent contract (`ai-resources/CLAUDE.md` § Subagent Contracts: 30-line cap) already establishes. The new sections make the contract explicit at the change site (positive). One implicit dependency: callers (`/new-project` orchestrator) must continue to honor the ≤30-line return convention — which they already do. Low residual coupling.
- M2 advisory `▸ /compact` text is operator-targeted prose — no automation, no parsed marker, no auto-firing. Self-contained.
- H5 `findings-extractor` agent: contract is explicit at the change site (input = list of paths; output = ≤30-line structured findings list). Single caller. Sub-report shape (HIGH/CRITICAL/Top findings/RED) is an existing convention. One soft dependency on report-shape convention — explicitly documented in the agent body lines 16–20. Low.
- H3 backtick-prose form for reference pointers depends on the convention that `@filename` triggers auto-load while backtick `` `filename` `` does not. This is an established Claude Code mechanism, not a new contract. Low.

### Dimension 5 Summary

The deny-rule conflict with two main-session reads is the only material hidden-coupling concern. Everything else in the change set has explicit contracts at the change site or follows established conventions.

## Mitigations

Required because Dimension 3 is High. Applied before next run of `/innovation-sweep` or `/audit-critical-resources`:

- **Dimension 3 (mandatory):** Either (a) scope the M1 deny rule more narrowly so `Read` from main session for synthesis is permitted — for example replace `Read(audits/working/**)` with `Read(audits/working/scratch/**)` or `Read(audits/working/*-tmp.md)` and migrate scratch files into that subpath; OR (b) update `innovation-sweep.md:134` and `audit-critical-resources.md:200` to consume the working-notes file via a synthesis subagent (haiku, Read-only) that returns the body as its summary — mirroring the H5 `findings-extractor` pattern. Option (b) is more consistent with the token-audit's intent (keep working-notes out of main-session context). Either is viable; pick one and apply before either command runs again.
- **Dimension 5 (recommended, not blocking):** Add a comment to `settings.json` (in a sibling docs file, since JSON does not support comments) recording the rationale for the `audits/working/**` deny rule and the intended pattern for synthesis (subagent-mediated read). Prevents a future operator from interpreting a synthesis-time read failure as a bug rather than a designed pattern.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from referenced files and CHANGE_DESCRIPTION). The Dimension 3 contract break was confirmed by reading `innovation-sweep.md:130–145` and `audit-critical-resources.md:200`, and verifying no settings.local.json override exists. No training-data fallback was used.
