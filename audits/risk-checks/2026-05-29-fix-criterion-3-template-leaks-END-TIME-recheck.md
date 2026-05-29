# Risk Check — 2026-05-29

## Change

END-TIME recheck of as-executed criterion-3 leak fix in the canonical research-workflow template (ai-resources/workflows/research-workflow/), found by the Phase 3 Step 5 deployment test:

1. Replaced literal "Nordic mid-market private equity" → "{{RESEARCH_AREA_PHRASE}}" in the Perplexity query-prefix at .claude/commands/run-execution.md (1 occurrence) and reference/stage-instructions.md (2 occurrences). 3 total.

2. Genericized reference/style-guide.md: (a) Context/Audience/Key-output block (was Axcion/Patrik/Daniel/Nordic-PE-specific) now uses {{PROJECT_DESCRIPTION}}, {{OPERATOR_NAME}}, {{DOMAIN}}, {{RESEARCH_AREA_PHRASE}}; (b) two domain-locked Voice Notes ("Define all PE terms…", "…specific to PE or cut it") changed PE → {{DOMAIN}}. The two Voice-Note swaps are a minor in-scope extension beyond the plan-time description (which named lines ~15-21), same placeholder substitution in the same file serving the same "genericize style-guide" intent.

Plan-time risk-check on this same change returned GO (all five dimensions Low): `ai-resources/audits/risk-checks/2026-05-29-fix-criterion-3-template-leaks-research-area-phrase-style-guide.md`.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md — exists (edited)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists (edited)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/style-guide.md — exists (edited)

## Verdict

GO

**Summary:** The as-executed diff matches the approved plan plus two same-kind {{DOMAIN}} Voice-Note swaps in the same file; all introduced placeholders are part of the template's canonical, deploy-auto-discovered set with a zero-residual gate, no project consumes these files by symlink, and the change is a clean single-revert — every dimension remains Low, unchanged from plan-time.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file touched. style-guide.md carries a "Not needed for every turn" gate (style-guide.md:3); run-execution.md and stage-instructions.md are stage-scoped pipeline references loaded only when the relevant stage runs.
- No hook, `@import`, subagent brief, or skill description added or expanded. The diff is literal→placeholder substitution plus genericizing one prose block (style-guide.md:15-19) and two Voice-Note lines (style-guide.md:24, 31).
- Net token delta ≈ zero. The two extra Voice-Note swaps replace "PE" with "{{DOMAIN}}" — a few characters per line, no material cost change versus the plan-time estimate.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` change. No `allow`/`ask`/`deny` entry added, removed, or narrowed; no new tool family, Bash pattern, Write path, external API, or MCP access introduced.
- Deploy-time substitution rides the existing Step 7 mechanism (`find ... | xargs sed -i ''`, deploy-workflow.md:265) that already runs on every deploy. The two extra Voice-Note swaps introduce no new placeholder name and therefore no new authorized substitution target.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 3, all inside the template tree `ai-resources/workflows/research-workflow/`.
- **Symlink consumers of the 3 changed files: ZERO.** `find projects -type l` filtered to the three filenames returned no matches (re-run this recheck). Per-project file-type probe confirms:
  - nordic-pe: all three are REGULAR FILE copies — unaffected, retains correct project-specific content.
  - buy-side-service-plan: run-execution.md and stage-instructions.md are REGULAR FILE copies; style-guide.md is MISSING (not deployed) — unaffected.
- Contract direction: aligns run-execution.md (line 157) and stage-instructions.md (lines 62, 101) with the template's own placeholder convention. `{{RESEARCH_AREA_PHRASE}}` is declared in the template CLAUDE.md:33; the four placeholders introduced into style-guide.md ({{RESEARCH_AREA_PHRASE}}, {{PROJECT_DESCRIPTION}} CLAUDE.md:5, {{OPERATOR_NAME}} CLAUDE.md:17, {{DOMAIN}} CLAUDE.md:30) are all members of the canonical documented set. No new token name introduced. No caller requires modification.
- Effect scope: future deploys only. The two extra Voice-Note swaps reuse {{DOMAIN}}, already present at style-guide.md:24/31 context — no new caller-facing surface.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are in-tree text edits to committed template files; a single `git revert` fully restores prior state. No sibling files/dirs created, no log/data-file mutation, no settings cache, no external/pushed state. The two extra Voice-Note swaps are within the same file revert and add no extra cleanup step.
- No automation fires between landing and revert — no hook added; effect only materializes on the next operator-initiated `/deploy-workflow`.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Deploy placeholder discovery is dynamic, not table-driven: Step 5 runs `grep -roh '{{[A-Z_]*}}' {PROJECT_DIR}/ | sort -u` (deploy-workflow.md:241), so all four placeholders are auto-discovered at deploy time even though the SETUP.md value table lists only PROJECT_DESCRIPTION and OPERATOR_NAME (SETUP.md:45/50/170/175) — RESEARCH_AREA_PHRASE and DOMAIN are still collected by the grep and prompted for. Step 8 gates on zero residual `{{...}}` tokens (deploy-workflow.md:270/273/320). The substitution path for all four tokens is therefore proven, not assumed.
- No new contract, parse marker, or filename convention introduced. The two extra Voice-Note swaps reuse the already-present {{DOMAIN}} token, so they introduce no token a consumer must newly learn.
- Verified no residual literals: `grep -niE "Nordic mid-market private equity|Axcion|Patrik|Daniel"` across all three files returned NONE FOUND.
- No functional overlap with existing mechanisms; no silent auto-firing in unexpected contexts.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, fresh `grep -n`/`find -type l` re-runs against the as-executed files, deploy-workflow.md line citations for the discovery and residual-gate steps, file-type probes on both research-workflow-derived projects, verbatim quotes from the edited files). No training-data fallback was used. The two extra Voice-Note swaps were inspected directly (style-guide.md:24, 31) and confirmed to be same-kind {{DOMAIN}} substitutions in the same file, introducing no risk beyond the plan-time review.
