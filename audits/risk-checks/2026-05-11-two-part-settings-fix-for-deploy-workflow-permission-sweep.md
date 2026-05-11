# Risk Check — 2026-05-11

## Change

Two-part settings fix for deploy-workflow + permission-sweep-auditor:

CHANGE 1 — deploy-workflow.md Step 4 bash snippet (command edit):
Current jq merge: `.permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + [$dir] | unique)`
Proposed fix: `.permissions.additionalDirectories = ((.permissions.additionalDirectories // [] | map(select(startswith("{{") | not))) + [$dir] | unique)`
Effect: When /deploy-workflow instantiates a workflow template, Step 4 now strips any {{...}} placeholder entries from additionalDirectories before adding the actual workspace path. Previously, both the placeholder AND the real path ended up in the deployed settings.json; now only the real path survives.

CHANGE 2 — permission-sweep-auditor.md (agent definition edit):
Add a template-class recognition rule: when a settings.json file (or any settings file) has a value matching the pattern `{{[A-Z_]+}}` in additionalDirectories (or other path-type fields), classify that entry as INTENTIONAL-TEMPLATE, not Rule 9 (stale path). This prevents the permission-sweep from flagging the research-workflow template settings.json as a broken path.

Files in scope:
- ai-resources/.claude/commands/deploy-workflow.md
- ai-resources/.claude/agents/permission-sweep-auditor.md

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both changes are surgical and well-targeted, but Change 2 introduces a new classification contract whose canonical home is `docs/permission-template.md` (which the auditor reads as source of truth), not the auditor's own prompt body — and two sibling commands carry the identical pre-fix jq merge pattern that Change 1 leaves unfixed.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change 1 swaps one jq expression for a slightly longer one inside an existing bash snippet in `deploy-workflow.md` Step 4 (lines 244–246). No new section, no new file, no new always-loaded content. Net delta ~50 characters in a command loaded only when `/deploy-workflow` runs.
- Change 2 adds a recognition rule to `permission-sweep-auditor.md` — a subagent definition loaded only when `/permission-sweep` spawns the agent (referenced from `permission-sweep.md` and `friday-checkup.md` per grep). Pay-as-used; no always-loaded surface.
- Neither file is `@import`ed into a CLAUDE.md or auto-loaded by a hook.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change 1 modifies how `additionalDirectories` is written during deploy; it does not widen or narrow the set of tools, paths, or globs that any settings.json grants. The post-fix output (`[<real workspace root>]`) is a strict subset of the pre-fix output (`["{{WORKSPACE_ROOT}}", <real workspace root>]`) — strips a non-functional placeholder, retains the real grant.
- Change 2 is an auditor classification rule; it changes what gets flagged, not what is permitted. No allow/deny/defaultMode mutation.
- No deny rule is removed; no scope is escalated; no new tool family is introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file changes: 2 (deploy-workflow.md, permission-sweep-auditor.md).
- Sibling commands carrying the identical pre-fix jq merge pattern (NOT in scope of this change):
  - `ai-resources/.claude/commands/new-project.md:362` — same `.permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + [$dir] | unique)` merge.
  - `ai-resources/.claude/commands/permission-sweep.md:212` — same merge, used during `/permission-sweep` remediation Step 8.
  - Implication: a project deployed via `/new-project` (not `/deploy-workflow`) into a template-bearing source would still suffer the same placeholder-leak bug. `/permission-sweep` remediation of a project whose settings already contain a stray `{{...}}` would also re-`unique` it rather than strip it.
- Callers of `permission-sweep-auditor`: 2 commands invoke the agent — `permission-sweep.md` (primary) and `friday-checkup.md` (via tier dispatch). Both consume the agent's findings as plain markdown, so adding a new `INTENTIONAL-TEMPLATE` tag does not break the consumer parse — but neither consumer currently recognizes the tag and may render it verbatim in chat reports.
- The auditor reads `TEMPLATE_PATH` (`docs/permission-template.md`) as its rulebook and is explicitly instructed "Do not invent new rules. Apply only the rules defined in the template." (line 34). Change 2 violates this contract by embedding a new classification rule directly in the auditor's prompt body without updating the template.
- 4 audit-history references to "auditor template-class classification" / "Rule 8 backlog" indicate this fix has been in the backlog since 2026-04-27 (`permission-sweep-2026-04-27.md:46`, `friday-checkup-2026-05-01.md:137`, `permission-sweep-2026-05-01.md:21`, `risk-checks/2026-05-01-resolve-the-workspace-root-placeholder-in-workflows-research.md:58`). Each prior audit framed it as a **Rule 8** false-positive ("Missing or stale additionalDirectories"), not Rule 9 ("Absolute-path allow entries with stale workspace paths"). The change description targets Rule 9. Either the change is misclassifying which rule fires on `{{WORKSPACE_ROOT}}` in `additionalDirectories`, or the auditor will silently fail to suppress the Rule 8 false-positive that historical audits actually surfaced.

### Dimension 4: Reversibility
**Risk:** Low

- Both changes are single-file in-place edits to .md files. `git revert` of the change-commit restores the prior jq line and prior auditor body.
- No log/registry append, no external system call, no deployed-project propagation built into the change itself. A subsequent `/deploy-workflow` run after revert would re-emit the pre-fix behavior (placeholder + real path), which is the prior baseline — no orphaned state.
- One caveat: any project deployed *between* the change landing and a hypothetical revert would have a `settings.json` with only the real path (correct), while a future `/sync-workflow` on that project under reverted code would re-add the placeholder. That is a forward-only drift, not a revert blocker — but it means projects deployed during the change's lifetime carry the corrected shape regardless of revert.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Change 2 violates the auditor's stated contract.** The auditor explicitly reads `docs/permission-template.md` as the source of truth for rules and is instructed "Apply only the rules defined in the template" (`permission-sweep-auditor.md:34`). Embedding the template-class recognition in the auditor body — instead of adding it to `docs/permission-template.md` as a documented detection-rulebook entry or as a top-level INTENTIONAL-TEMPLATE override (paired with the INTENTIONAL-NARROW override at lines 86–96) — creates a silent rule that diverges from the published rulebook. Future audits, future maintenance, and the `/improve-skill` / `/improve` pipeline will treat the template as authoritative and may regenerate the auditor without the embedded rule.
- **Rule-number mismatch.** Change description says "classify as INTENTIONAL-TEMPLATE, not Rule 9 (stale path)." Per `docs/permission-template.md:263–264`, Rule 8 is "Missing or stale `additionalDirectories`" and Rule 9 is "Absolute-path allow entries with stale workspace paths (path no longer exists on disk)." A `{{WORKSPACE_ROOT}}` literal inside `additionalDirectories` is most naturally a Rule 8 trigger (it is neither a valid absolute path nor present on disk), not a Rule 9 trigger (Rule 9 scopes to the `allow` list, not `additionalDirectories`). The four prior audits (cited under Blast Radius) all classified this case as Rule 8 in their findings. Change 2 as written may suppress a rule that does not fire on this case while failing to suppress the rule that actually does.
- **Sibling-pattern unaddressed.** The fixed jq idiom in `deploy-workflow.md` is duplicated verbatim in `new-project.md:362` and `permission-sweep.md:212`. The change description names "Two-part settings fix" but the underlying root cause (the merge appends rather than reconciles) exists in three locations. Fixing one creates an inconsistency between the three siblings.
- **Pattern coverage assumption.** The proposed jq filter strips entries starting with `{{` but the change description hand-waves "other path-type fields" for Change 2's auditor rule. Change 1 only filters `additionalDirectories`; it does not filter `allow`/`deny` entries that could theoretically also contain `{{...}}` if a future template puts a placeholder in a Read/Edit glob. The narrow scope is fine for the current bug, but the asymmetry between Change 1 (narrow: `additionalDirectories` only) and Change 2 (broad: "any settings file ... in additionalDirectories or other path-type fields") creates a coverage gap.

## Mitigations

- **Dimension 3 — sync sibling merge sites.** Before or alongside landing the change, apply the same `map(select(startswith("{{") | not))` strip to `new-project.md:362` (the inline jq merge under "Grant ai-resources filesystem visibility") and `permission-sweep.md:212` (the Rule 8 remediation idiom). Otherwise `/new-project` and `/permission-sweep` remediation will re-introduce the placeholder leak that `/deploy-workflow` now prevents.
- **Dimension 3 / 5 — confirm rule-number target.** Verify on a synthetic template settings.json which rule actually fires today: run the auditor against `ai-resources/workflows/research-workflow/.claude/settings.json` mentally (or via dry-run if possible) and check whether the `{{WORKSPACE_ROOT}}` in `additionalDirectories` triggers Rule 8 (missing/stale `additionalDirectories`) or Rule 9 (stale absolute-path allow). The four historical audits classified this as Rule 8. Update Change 2's wording from "not Rule 9 (stale path)" to "not Rule 8 (stale additionalDirectories) and not Rule 9 (stale absolute-path allow)" — or whichever rule actually fires — so the suppression covers the correct rule.
- **Dimension 5 — promote the rule to the template.** Add `INTENTIONAL-TEMPLATE` as a documented override section in `docs/permission-template.md`, sibling to the existing `INTENTIONAL-NARROW` override (lines 86–96 of permission-sweep-auditor.md). Keep the auditor body change as a thin reference to the template section, not a freestanding rule. This honors the auditor's "Apply only the rules defined in the template" contract and survives future auditor regeneration.
- **Dimension 5 — document the consumer behavior.** `permission-sweep.md` Step 5 (lines 100–117) maps rules 1–13 to plain-language causes. Add a row for the new `INTENTIONAL-TEMPLATE` classification so the chat report renders it as "Template file with unfilled placeholder — intentional, not a real broken path" rather than dropping it or labeling it as an unrecognized tag.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: explicit file/line citations for the jq merge in `deploy-workflow.md:244–246`, `new-project.md:362`, `permission-sweep.md:212`; rulebook line references in `docs/permission-template.md:263–264`; auditor contract quote at `permission-sweep-auditor.md:34`; intentional-narrow override at `permission-sweep-auditor.md:86–96`; four prior audit citations for the historical Rule-8 framing; template settings.json content at `ai-resources/workflows/research-workflow/.claude/settings.json:34–36`. No training-data fallback was used on fetch/read failures.
