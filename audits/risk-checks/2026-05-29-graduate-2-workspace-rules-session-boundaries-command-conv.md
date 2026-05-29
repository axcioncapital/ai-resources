# Risk Check — 2026-05-29

## Change

Graduate two rules from the nordic-pe project CLAUDE.md (`projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`) up to the workspace-root CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — always-loaded content on every turn in every project):

(1) "Session Boundaries" — verbatim project text: "When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context. Stale context from a prior task compounds and contaminates the next one."

(2) "Command Conventions" — project text (project-framed): "Pipeline command files in `.claude/commands/` declare their tier and behavior flags via **YAML frontmatter** at the top of the file (e.g., `friction-log: true`, `model: opus`), not via a `Usage:` line. This is the project-wide convention, consistent with the workspace `CLAUDE.md` Model Tier rule that names frontmatter as the only permitted mechanism for declaring a tier outside the live session. Do not 'fix' the absence of `Usage:` lines — frontmatter is the intentional form." (At workspace level this would be genericized — "workspace-wide convention" rather than "project-wide".)

IMPORTANT evaluation note: The workspace CLAUDE.md ALREADY has a "Model Tier" section that states "Per-command, per-agent, and per-skill tiering via YAML `model:` frontmatter is the only permitted mechanism for declaring a tier outside the live session." Assess whether the "Command Conventions" rule is REDUNDANT with the existing Model Tier section — the incremental content over Model Tier is (a) behavior flags (e.g. friction-log: true) also go in frontmatter, and (b) the "don't fix absence of Usage: lines" instruction. Redundant always-loaded content is a real cost (token cost on every turn + contradiction/drift risk). Weigh this in the hidden-coupling and usage-cost dimensions.

The third project rule ("Review Presentation") is intentionally NOT being graduated (research-report-specific, stays local). Scope is exactly these two rules.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Graduating "Session Boundaries" is a clean, low-cost de-duplication win, but "Command Conventions" is largely redundant with the existing Model Tier section AND its "don't fix absence of `Usage:` lines" clause contradicts 52 command files repo-wide that legitimately use `Usage:` lines — the two rules carry materially different risk profiles and should not be graduated as one undifferentiated unit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Both rules land in the workspace-root CLAUDE.md, which is always-loaded on every turn in every project — this is the highest-cost surface in the repo. Confirmed always-loaded: the file carries no conditional-load guard (`/Users/.../CLAUDE.md` lines 1–217 are unconditional section content).
- Rule (1) "Session Boundaries" is ~2 sentences / ~35 tokens. Below the ~50-token Medium floor on its own.
- Rule (2) "Command Conventions" is ~4 sentences / ~80 tokens. Combined the two add roughly 110–120 tokens to always-loaded content — squarely in the Medium band (~50–150 tokens to always-loaded files).
- Rule (2) is substantially redundant with the existing Model Tier section (`CLAUDE.md` line 161: "Per-command, per-agent, and per-skill tiering via YAML `model:` frontmatter is the **only** permitted mechanism for declaring a tier outside the live session"). The only net-new content rule (2) adds over Model Tier is (a) behavior flags (`friction-log: true`) also belong in frontmatter, and (b) the "don't fix absence of `Usage:` lines" instruction. Roughly half of rule (2)'s token cost is paying for content the operator already loads every turn.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched. The change is CLAUDE.md prose only; no `.claude/settings.json` or `.claude/settings.local.json` is referenced or modified.
- No new tool-invocation pattern, no scope escalation, no external/cross-repo capability introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 2 (root CLAUDE.md gains two sections; nordic-pe CLAUDE.md presumably loses or shortens them — graduation implies source removal, though the CHANGE_DESCRIPTION does not state the source disposition explicitly).
- **"Session Boundaries" duplicate enumeration:** the section text appears in 16 CLAUDE.md files today. Grep `Session Boundaries` across all CLAUDE.md → 16 hits: `ai-resources/CLAUDE.md`, `ai-resources/workflows/research-workflow/CLAUDE.md`, and 14 project files (`nordic-pe-macro-landscape-H1-2026`, `buy-side-service-plan`, `repo-documentation`, `project-planning`, `nordic-pe-screening-project`, `strategic-os`, `corporate-identity`, `obsidian-pe-kb`, `interpersonal-communication`, `axcion-ai-system-owner`, `personal/travel-os`, `axcion-brand-book`, `global-macro-analysis`, `ai-development-lab`). The workspace ROOT does NOT yet have it (grep `Session Boundaries` ./CLAUDE.md → 0). Graduating to root makes all 16 existing copies redundant duplicates of an always-loaded root rule.
- **"Command Conventions" enumeration:** the section appears in exactly 1 CLAUDE.md (nordic-pe). Grep `Command Conventions` across all CLAUDE.md → 1 hit. It is genuinely project-local today, so graduating it is a true scope-widening, not a de-dup.
- **`Usage:` line enumeration (the contract rule (2) governs):** 52 command files repo-wide contain a `Usage:` line (grep `Usage:` across `*/.claude/commands/*.md` → 52 of 1137). In `ai-resources/.claude/commands/` specifically, 3 canonical commands use `Usage:` lines (`sync-workflow.md:5`, `deploy-workflow.md:5`, `project-consultant.md`). Rule (2)'s clause "Do not 'fix' the absence of `Usage:` lines — frontmatter is the intentional form" would, if read workspace-wide, frame 52 existing files as anomalies, when in fact `Usage:` lines are an established and intentional convention elsewhere. This is a contract change that is NOT backwards-compatible with current command-file practice → pushes blast radius to Medium for rule (2).
- No callers (commands/agents/hooks) parse these CLAUDE.md sections programmatically — they are guidance prose, so no schema/marker contract breaks.

### Dimension 4: Reversibility
**Risk:** Low

- Both rules are prose edits to two tracked CLAUDE.md files. A single `git revert` of the graduation commit fully restores prior state within the working tree.
- No log/registry mutation, no generated sibling files, no settings-cache state, no state pushed beyond git.
- One caveat: if the graduation also deletes the 16 duplicate "Session Boundaries" copies as a follow-on cleanup, that widens the revert to more files but remains a clean single-commit revert. Not elevated.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Rule (2) contradicts an established repo-wide convention.** The "don't fix absence of `Usage:` lines" clause silently relies on the nordic-pe-local fact that its pipeline commands use frontmatter flags instead of `Usage:` lines. Promoted workspace-wide it collides with 52 command files that DO use `Usage:` lines (evidence: grep count above; `ai-resources/.claude/commands/sync-workflow.md:5: Usage: /sync-workflow [project-path]`). Two conventions would both claim authority over the same concern (how a command declares its invocation) — exactly the "functional overlap with existing mechanisms" High trigger.
- **Rule (2) is a partial restatement of Model Tier** (`CLAUDE.md` line 161). Two always-loaded sections now assert overlapping rules about frontmatter-as-tier-mechanism. Redundant always-loaded content invites future drift: an edit to one section's frontmatter wording will silently diverge from the other. This is the contradiction/drift risk the evaluation note flagged.
- **Rule (1) collides with the root's own CLAUDE.md Scoping rule.** Root `CLAUDE.md` line 155 states project CLAUDE.md must not contain "Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not." After graduation, the 16 existing verbatim "Session Boundaries" copies become standing violations of that very rule — an implicit cleanup obligation not named in the change. (This is a documented, resolvable contract, so it alone would be Medium; combined with the rule-(2) collisions the dimension is High.)
- Net: multiple implicit dependencies + functional overlap with two existing mechanisms (Model Tier section; the `Usage:`-line convention in 52 files) → High.

## Mitigations

- **Split the change (Hidden Coupling + Blast Radius, rule 2):** Graduate "Session Boundaries" alone now. Do NOT graduate "Command Conventions" as written. The Session-Boundaries graduation is a clean de-dup with no convention collision.
- **Hidden Coupling (rule 2 redundancy):** If any frontmatter-conventions content is wanted at workspace level, fold ONLY the net-new piece — "behavior flags (e.g. `friction-log: true`) also go in YAML frontmatter" — into the existing Model Tier section as one clause, rather than adding a second always-loaded section. Drop the "don't fix absence of `Usage:` lines" clause entirely at workspace scope, since it contradicts 52 command files that intentionally use `Usage:` lines; if that anti-fix instruction is still needed for nordic-pe's pipeline commands, leave it in the nordic-pe project CLAUDE.md where its scope is correct.
- **Blast Radius / Scoping cleanup (rule 1):** When graduating "Session Boundaries" to root, plan the follow-on removal of the 16 now-redundant project-level copies (or convert them to short pointers) to satisfy root `CLAUDE.md` line 155 ("verbatim duplication is not" acceptable). Do this in the same commit or an immediately-following one so the duplication window is minimal. Enumerated targets are listed under Dimension 3.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). Grep counts: `Session Boundaries` → 16 CLAUDE.md (root = 0); `Command Conventions` → 1 CLAUDE.md; `Usage:` lines → 52 of 1137 command files (3 in ai-resources canonical). No training-data fallback was used on fetch/read failures.
