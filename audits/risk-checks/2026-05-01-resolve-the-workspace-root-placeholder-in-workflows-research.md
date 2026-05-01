# Risk Check — 2026-05-01

## Change

Resolve the {{WORKSPACE_ROOT}} placeholder in workflows/research-workflow/.claude/settings.json — the additionalDirectories entry contains a literal {{WORKSPACE_ROOT}} template placeholder that was never filled in. The fix is to replace it with the correct absolute path to the workspace root (/Users/patrik.lindeberg/Claude Code/Axcion AI Repo) or remove the entry if it is not needed. This settings.json is the workflow's local Claude Code config, not the main ai-resources settings.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo — exists

## Verdict

RECONSIDER

**Summary:** The change description's stated premise — that the placeholder "was never filled in" and is a settings bug — contradicts the documented design: the file is a template, the placeholder is intentional, the prior 2026-04-27 risk-check explicitly approved introducing it, and SETUP.md Step 1.5 documents it as the deploy-time fill-in. Resolving the placeholder in-place would corrupt the template and break future deployments.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Edit touches a single value inside `workflows/research-workflow/.claude/settings.json`. Whether substituted with an absolute path or the entry is deleted, the per-session token cost of the file does not change in a way that affects always-loaded budgets — this template's settings.json is loaded only inside an instantiated project session, not in the ai-resources repo session. Evidence: file lives at `ai-resources/workflows/research-workflow/.claude/settings.json:34-36`.
- No new hooks, skills, subagents, or `@import` chains introduced by either fix variant.

### Dimension 2: Permissions Surface
**Risk:** High

- The change touches `additionalDirectories` — a permission entry that grants cross-directory read scope. Evidence: `workflows/research-workflow/.claude/settings.json:34-36` (`"additionalDirectories": ["{{WORKSPACE_ROOT}}"]`).
- **Fix variant A (substitute the absolute path `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`)** corrupts the template: any future project deployed via the template's SETUP.md will ship with Patrik's personal workspace path baked in. On any other operator's machine, the resulting deployed project resolves the path to a non-existent directory and pipeline commands silently fail. Evidence: SETUP.md:18-30 documents Step 1.5 as the deploy-time substitution step; SETUP.md:28 explicitly warns "If left as `{{WORKSPACE_ROOT}}` or pointed at the wrong directory, every skill symlink resolves to a path Claude cannot read and pipeline commands silently fail." Verbatim from `permission-sweep-2026-04-27.md:35` (the prior auditor self-correction): "Replacing the placeholder would corrupt new deployments via `/deploy-workflow` / `/new-project`. Auditor mis-classified template-source-as-deployed."
- **Fix variant B (remove the entry)** narrows permission scope for any deployment of this template — projects deployed from it lose read access to `ai-resources/` files (skills, commands, agents). Evidence: SETUP.md:28: "This grants Claude Code read access to `ai-resources/` files (skills, commands, agents) from inside the project."
- Both variants therefore either (1) widen the deployed permission scope to a hard-coded path that is wrong on most machines, or (2) narrow it to break deployed pipeline commands. This is a structural change to the deployed permission surface, not a settings cleanup.

### Dimension 3: Blast Radius
**Risk:** High

- The file is a template, not a deployed config. Affects every future deployment of the research-workflow template. Evidence: `SETUP.md:1-30` is the project-instantiation checklist; Step 1.5 specifically documents the placeholder substitution.
- Grep enumeration of `WORKSPACE_ROOT` across ai-resources (32 references): 1 in the template settings.json (the change site); 1 in SETUP.md Step 1.5 (the documented substitution step); 1 in SETUP.md Placeholder Reference table (`SETUP.md:177`); 5 in the prior 2026-04-27 risk-check that approved introducing the placeholder; 7 in audit working notes; 1 in the 2026-04-27 permission-sweep self-correction noting prior misclassification. The template, the SETUP doc, and the prior risk-check all assume `{{WORKSPACE_ROOT}}` stays in the file as a placeholder.
- Contract change: substituting the placeholder with `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` breaks the documented SETUP.md contract (Step 1.5 instructs the operator to perform that very substitution at deploy time). Evidence: `SETUP.md:18-30`. Removing the entry breaks the documented permission contract that the deployed project depends on `ai-resources/` access. Evidence: `SETUP.md:28`.
- The change description also claims "This settings.json is the workflow's local Claude Code config, not the main ai-resources settings." That framing is incorrect: the file is the **template** that future projects deploy from, not a runtime-active config for the workflow itself.

### Dimension 4: Reversibility
**Risk:** Medium

- The textual edit is git-revertable. However, if a new project is deployed from the template between landing the change and reverting, that new project will carry the corrupted (variant A) or impoverished (variant B) settings.json forward, and the revert of the template does not propagate to the deployed copy. Evidence: every deployed project has its own settings.json snapshot — see grep of `additionalDirectories` across `projects/*/.claude/settings.json` (8 distinct deployed copies).
- The 2026-04-27 risk-check noted this same propagation hazard for the placeholder introduction (in the desired direction); applying the inverse change inherits the inverse hazard.

### Dimension 5: Hidden Coupling
**Risk:** High

- The placeholder is part of a documented template contract. Evidence: SETUP.md lists 9 placeholders (Step 1.5 + Placeholder Reference table at `SETUP.md:177`), all of which use the `{{NAME}}` convention and are filled at deploy time.
- The 2026-04-27 risk-check (`audits/risk-checks/2026-04-27-replace-hard-coded-additionaldirectories-path-in-workflows.md`) explicitly approved introducing this placeholder and documented the pattern conformance. Reversing that decision without revisiting the prior reasoning is a contradiction-with-the-record.
- The 2026-04-27 permission-sweep (`audits/permission-sweep-2026-04-27.md:35`) explicitly self-corrects on this point and logs as backlog: "real fix is to teach the auditor to treat files under `workflows/*/.claude/` as template-class and skip Rule 8 there." The recurring auditor flag is a known false positive, not a real settings drift.
- Functional overlap: the change description treats the file as a runtime settings config; the documented design treats it as a template artifact. The two interpretations produce opposite correct actions. The discrepancy is the textbook "Assumptions Gate" structural concern (workspace CLAUDE.md § Assumptions Gate) — phase-spec staleness / sibling redundancy / scope ambiguity warrants escalation to the operator, not self-resolution.

## Recommended redesign

- **Do not edit the template file.** Instead, address the recurring auditor flag at its source: either teach `permission-sweep-auditor` and `repo-health` audits to recognize files under `workflows/*/.claude/` as template-class and skip the Rule-8 unfilled-placeholder check there (already logged as backlog in `permission-sweep-2026-04-27.md:35`), or add a top-of-file marker (e.g., `// TEMPLATE — placeholders filled at deploy via SETUP.md Step 1.5`) that auditors can use to suppress the false positive. This resolves the "recurring finding" signal flagged in `friday-checkup-2026-05-01.md:99` without corrupting the template.
- If the goal is genuinely to retire the template (i.e., research-workflow is no longer deployed), retire the whole template directory in a separate planned change with its own risk-check, not by mutating one settings field.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to `workflows/research-workflow/.claude/settings.json:34-36`, `workflows/research-workflow/SETUP.md:18-30,177`, prior risk-check `audits/risk-checks/2026-04-27-replace-hard-coded-additionaldirectories-path-in-workflows.md`, prior permission-sweep self-correction `audits/permission-sweep-2026-04-27.md:35`, friday-checkup recurrence note `audits/friday-checkup-2026-05-01.md:99`, and grep counts across the ai-resources tree (32 `WORKSPACE_ROOT` references and 16 `additionalDirectories` references). No training-data fallback was used.
