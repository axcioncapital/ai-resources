# Risk Check — 2026-04-27

## Change

Replace hard-coded `additionalDirectories` path in workflows/research-workflow/.claude/settings.json with the placeholder `{{WORKSPACE_ROOT}}`. Add a new SETUP.md step (1.5) between "Copy the template" and "Initialize git" instructing the operator to update this value to their local workspace root (the directory containing ai-resources/). Add `WORKSPACE_ROOT` to the SETUP.md Placeholder Reference table. Files affected: workflows/research-workflow/.claude/settings.json (1 line); workflows/research-workflow/SETUP.md (~10 lines added: new step + placeholder reference row). Rationale: existing hard-coded path breaks all ai-resources references on any machine other than mine; placeholder pattern matches the template's existing design (other placeholders like {{PROJECT_TITLE}} already use this style and get filled at setup). Scope: research-workflow template only — not deployed to any project today.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md — exists

## Verdict

GO

**Summary:** Template-only edit using the established placeholder pattern; no deployed project is touched, no permissions or contracts change, and the cleanup step is documented in SETUP.md alongside the eight existing placeholders.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded files in ai-resources or workspace. The change touches `workflows/research-workflow/.claude/settings.json` and `SETUP.md` only — neither is auto-loaded outside an instantiated project session.
- SETUP.md is a one-time setup checklist read by the operator at template instantiation, not by every turn. ~10 added lines do not register as ongoing token cost.
- settings.json placeholder is a one-character-equivalent swap (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` → `{{WORKSPACE_ROOT}}`) — line count and per-session cost unchanged, evidence: `workflows/research-workflow/.claude/settings.json:34-36`.
- No new hooks, subagents, skills, or `@import` chains introduced.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`, `ask`, or `deny` entries added or removed. The edit replaces a path *value* inside an existing `additionalDirectories` array — the array itself, its scope semantics, and surrounding allow/deny blocks remain unchanged. Evidence: `workflows/research-workflow/.claude/settings.json:34-36`.
- After the operator fills `{{WORKSPACE_ROOT}}` at setup, the resolved permission grant is identical to what the template ships today on Patrik's machine — and explicitly intended-equivalent on other machines. No widening of capability.
- No tool family, glob pattern, or scope (project → user) is altered. CHANGE_DESCRIPTION confirms scope is template-only, not deployed.

### Dimension 3: Blast Radius
**Risk:** Low

- Two files touched directly: `workflows/research-workflow/.claude/settings.json` (1 line) and `workflows/research-workflow/SETUP.md` (~10 lines added). Evidence: CHANGE_DESCRIPTION verbatim.
- Grep enumeration: `additionalDirectories` appears in ai-resources at 16 locations; only **1** is in the research-workflow template itself (`workflows/research-workflow/.claude/settings.json:34`). The other 15 are audit reports (read-only historical records) or `/new-project`'s enrichment logic, which computes `additionalDirectories` dynamically via `jq` and does not reference this template's value. Evidence: grep results across `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`.
- No deployed project depends on this template's settings.json today (CHANGE_DESCRIPTION: "not deployed to any project today"). New projects use `/new-project` which writes a different settings.json; existing projects already have their own copies and are not retroactively updated.
- The placeholder pattern (`{{NAME}}`) is well-established: 8 placeholders already in the SETUP.md reference table (`SETUP.md:155-162`), and adding a 9th does not change the contract — operators already replace placeholders during setup.
- Note: `permission-sweep-auditor.md` uses the notation `{WORKSPACE_ROOT}` (single braces) as an internal parameter — distinct namespace from `{{WORKSPACE_ROOT}}` (double braces, template placeholder). No naming collision risk for tooling that doesn't string-match across namespaces.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are textual, contained in two files under git. `git revert` cleanly restores the prior state.
- No state propagates beyond git: no log mutations, no external API writes, no symlink creation, no automation registered.
- Template is not deployed to any project, so no downstream copy needs synchronizing on revert. Evidence: CHANGE_DESCRIPTION explicit scope statement.
- One residual consideration: if the operator instantiates a new project from the template *between* the change landing and a hypothetical revert, that new project will have already had `{{WORKSPACE_ROOT}}` resolved to a concrete path during setup — so it is unaffected by the revert (the revert restores the template, not the deployed project). This is the desired behavior, not a coupling problem.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Pattern conformance: the change uses the identical `{{NAME}}` style already in active use across the template — `{{PROJECT_TITLE}}`, `{{PROJECT_DESCRIPTION}}`, `{{ANALYTICAL_LENS}}`, `{{CURRENT_SECTION}}`, `{{DOCUMENT_ARCHITECTURE}}`, `{{EVIDENCE_CALIBRATION}}`, `{{OPERATOR_NAME}}`, `{{SECTION_SEQUENCE}}` (`SETUP.md:155-162`). Operators already understand the contract.
- New contract is documented at the change site: SETUP.md gets both a procedural step (Step 1.5) and a row in the Placeholder Reference table — matching how every other placeholder is documented.
- Validation step in SETUP.md already exists: "CLAUDE.md has no remaining `{{PLACEHOLDER}}` markers" (`SETUP.md:144`). Operators following the checklist will catch a missed `{{WORKSPACE_ROOT}}`. Note: this validation is currently scoped to CLAUDE.md; the operator should generalize it (or apply manual due diligence) to also cover settings.json, but the template's existing language ("All placeholders used in template files" — `SETUP.md:151`) already implies cross-file coverage in the table.
- No silent auto-firing context: the placeholder is inert until the operator replaces it at setup. If left unreplaced, Claude Code's settings parser will treat `{{WORKSPACE_ROOT}}` as a literal directory string that does not exist — producing a visible failure, not a silent miscompile. This is the intended fail-loud behavior.
- No functional overlap with `/new-project` enrichment: `/new-project` writes `additionalDirectories` via `jq` based on a runtime-discovered ancestor that contains `ai-resources/` (`new-project.md:340-362`). The research-workflow template's settings.json is a separate artifact for projects instantiated *from this template* (rather than via `/new-project`). The two paths have distinct entry mechanisms; the change does not alter either contract.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts across `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`, verbatim quotes from CHANGE_DESCRIPTION and the two referenced files). No training-data fallback was used on fetch/read failures.
