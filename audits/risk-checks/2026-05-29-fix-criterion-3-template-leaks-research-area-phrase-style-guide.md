# Risk Check — 2026-05-29

## Change

Fix two criterion-3 leaks in the canonical research-workflow template (ai-resources/workflows/research-workflow/), discovered by the Phase 3 Step 5 deployment test:

1. [HIGH] Replace the hardcoded literal string "Nordic mid-market private equity" with the {{RESEARCH_AREA_PHRASE}} placeholder in the Perplexity query-prefix at 3 locations: .claude/commands/run-execution.md:157, reference/stage-instructions.md:62, reference/stage-instructions.md:101. The schema doc (docs/project-config-schema.md:54) already documents {{RESEARCH_AREA_PHRASE}} as the parameter for exactly these locations, and the placeholder is already used in the template's CLAUDE.md — so this aligns the files with the documented contract. Deploy Step 7 placeholder-replacement (sed over all .md files) will substitute it at deploy time.

2. [MED] Genericize the template's reference/style-guide.md — strip Axcion/Patrik/Daniel/Nordic-PE-specific content from the Context/Audience/Key-output block (lines ~15-21) and replace with generic, placeholder-shaped guidance (using existing placeholders like {{PROJECT_TITLE}}, {{OPERATOR_NAME}}, {{RESEARCH_AREA_PHRASE}}, {{DOMAIN}} where appropriate).

Blast-radius facts already verified by the main session: the live nordic-pe project holds LOCAL regular-file copies (not symlinks) of run-execution.md, stage-instructions.md, and style-guide.md — so it is unaffected by template changes and keeps its correct project-specific content. The change affects only future deploys from the template. You should independently verify this symlink-vs-copy claim if you can.

Out of scope (deferred to Friday cadence, not part of this fix): manifest reconciliation (phantom produce-architecture, omitted produce-jargon-gloss) and the 4 drifted shared-command template copies (note/qc-pass/refinement-pass/update-claude-md) — criteria 4 and 5 passed, so these don't block Phase 3.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/style-guide.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/project-config-schema.md — exists

## Verdict

GO

**Summary:** A documented-contract-aligning placeholder fix plus a template genericization, both confined to template `.md` files that no project consumes by symlink, deploy-substituted by an existing idempotent sed pass with a no-residual-placeholder verification gate — every dimension is Low.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The three edited files are template references/commands loaded only when the research-workflow pipeline runs the relevant stage, not per turn — stage-instructions.md and style-guide.md both carry "Not needed for every turn" / "When to read this file" gating headers (style-guide.md:3; stage-instructions.md is a stage-scoped reference).
- No hook, `@import`, subagent brief, or skill description is added or expanded. The change is text substitution (literal → placeholder) plus genericizing one prose block in style-guide.md (lines ~15-21).
- Net token delta is approximately zero — `{{RESEARCH_AREA_PHRASE}}` is comparable in length to "Nordic mid-market private equity"; the style-guide block swaps PE-specific prose for placeholder-shaped prose of similar size.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` change. No `allow`/`ask`/`deny` entry added, removed, or narrowed; no new tool family, Bash pattern, Write path, external API, or MCP access introduced.
- The deploy-time substitution uses the existing Step 7 mechanism (`sed -i ''` over `.md`/`.json`, deploy-workflow.md:265) that already runs on every deploy — no new capability is being authorized.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 3 (run-execution.md, stage-instructions.md, style-guide.md), all inside the template tree `ai-resources/workflows/research-workflow/`.
- **Symlink consumers of the 3 changed files: ZERO.** `find projects -type l` filtered to the three target filenames returned no matches. Independently confirms the main session's claim.
  - nordic-pe: all three are REGULAR FILE copies (not symlinks) — unaffected, retains its correct project-specific content.
  - buy-side-service-plan (the only other research-workflow-derived project): run-execution.md and stage-instructions.md are REGULAR FILE copies; style-guide.md is MISSING (not deployed). It symlinks only Stage-5/shared commands (produce-formatting, produce-prose-draft, produce-jargon-gloss, produce-architecture, status, verify-chapter, run-report) — none of the three files in scope. So buy-side is also unaffected and keeps its own (already-substituted) literal phrase at run-execution.md:146, stage-instructions.md:43/68.
- Contract direction: the change *aligns* run-execution.md and stage-instructions.md WITH the documented contract in project-config-schema.md:54, which already names `{{RESEARCH_AREA_PHRASE}}` as the parameter for "the Perplexity-prefix in run-execution.md" and "the framing line in stage-instructions.md." The template CLAUDE.md:33 already declares the placeholder. No caller requires modification.
- Effect scope: future deploys only. No live project re-derives these files from the template.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are in-tree text edits to committed template files; a single `git revert` fully restores prior state. No sibling files/dirs created, no log/data-file mutation, no settings cache, no external/pushed state.
- No automation fires between landing and a potential revert — the change adds no hook and only takes effect when an operator next runs `/deploy-workflow`, which is gated and operator-initiated.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The introduced `{{RESEARCH_AREA_PHRASE}}` token honors an already-established, already-documented convention rather than inventing a new contract: schema doc line 54 documents it; CLAUDE.md:33 already uses it; deploy Step 7 already substitutes all `{{...}}` tokens and verifies none remain (deploy-workflow.md:273 grep `{{`, :320 "Confirm no {{...}} placeholders remain"). The deploy-substitution path for this exact placeholder is therefore proven, not assumed.
- Sub-question (a) — consistency with deploy Step 7: CONFIRMED consistent. Step 7 runs `find {PROJECT_DIR}/ -type f -name "*.md" ... | xargs sed -i '' 's/{{PLACEHOLDER}}/value/g'` (deploy-workflow.md:265), then Step 5/6 collect the value for every discovered placeholder and Step 8 verifies zero residual tokens. Adding the placeholder to `.md` files is exactly the input this mechanism expects.
- Sub-question (b) — other projects exposed to an unreplaced literal placeholder via symlink: NONE. No project symlinks any of the three changed files (Dimension 3 evidence). An un-deployed live project cannot inherit a literal `{{RESEARCH_AREA_PHRASE}}` because it does not read the template file at runtime. The only path to an unreplaced token is a future deploy where the operator skips/fat-fingers the value — but Step 8's no-residual-placeholder gate catches that before the deploy is declared complete.
- Style-guide genericization (item 2) uses only placeholders already present elsewhere in the template ({{PROJECT_TITLE}} already heads style-guide.md:1); no new placeholder name is introduced, so no new SETUP.md description is required and no consumer must learn a new token.
- No functional overlap with existing mechanisms; no silent auto-firing in unexpected contexts.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, `find -type l` symlink scans, deploy-workflow.md line citations, file-type probes on both research-workflow-derived projects, verbatim quotes from CHANGE_DESCRIPTION and referenced files). No training-data fallback was used on fetch/read failures.
