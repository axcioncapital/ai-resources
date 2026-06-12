# Project Setup Checklist

Use this checklist to initialize a new research project from this template.

**Estimated time:** 15–20 minutes.

---

## 1. Copy the template

```bash
cp -r workflows/active/research-workflow/project-template/ projects/[project-name]/
cd projects/[project-name]/
```

Replace `[project-name]` with a kebab-case identifier (e.g., `market-entry-analysis`).

## 1.5 Update settings.json workspace path

Open `.claude/settings.json` and replace the `{{WORKSPACE_ROOT}}` placeholder in `additionalDirectories` with the absolute path to your workspace root — the directory that contains `ai-resources/`.

```json
"additionalDirectories": [
  "/absolute/path/to/your/workspace-root"
]
```

This grants Claude Code read access to `ai-resources/` files (skills, commands, agents) from inside the project. If left as `{{WORKSPACE_ROOT}}` or pointed at the wrong directory, every skill symlink resolves to a path Claude cannot read and pipeline commands silently fail.

**Verify:** after starting Claude Code in the project, `Read /your/workspace-root/ai-resources/CLAUDE.md` succeeds.

## 2. Initialize git

```bash
git init
```

## 3. Fill CLAUDE.md placeholders

Open `CLAUDE.md` and replace all `{{PLACEHOLDER}}` values:

| Placeholder | What to fill in | Example |
|------------|----------------|---------|
| `{{PROJECT_TITLE}}` | Human-readable project title (used in headings) | `Research Workflow — Market Entry Analysis` |
| `{{PROJECT_DESCRIPTION}}` | 2-3 sentences: what the project produces, for whom | `A market entry feasibility study for...` |
| `{{ANALYTICAL_LENS}}` | The analytical framework anchoring the research | `Porter's Five Forces adapted to...` |
| `{{CURRENT_SECTION}}` | Initial section identifier | `1.1 — Market Overview` |
| `{{DOCUMENT_ARCHITECTURE}}` | Document structure (parts, sections, sequence) | `Part 1 (Research, 1.1–1.3) → Part 2 (Strategy, 2.1–2.4)` |
| `{{EVIDENCE_CALIBRATION}}` | Evidence availability and calibration note | `No primary research available. Each section must...` |
| `{{OPERATOR_NAME}}` | Operator's name | `Alex` |

## 4. Fill stage-instructions.md sequence constraints

Open `reference/stage-instructions.md` and replace `{{PROJECT_TITLE}}` in the title and `{{SECTION_SEQUENCE}}` with your project's section ordering rules. See the HTML comment in that section for an example.

## 5. Fill file-conventions.md title

Open `reference/file-conventions.md` and replace `{{PROJECT_TITLE}}` in the title.

## 5b. Fill quality-standards.md title

Open `reference/quality-standards.md` and replace `{{PROJECT_TITLE}}` in the title.

## 5c. Customize style-guide.md

Open `reference/style-guide.md` and replace `{{PROJECT_TITLE}}` in the title. Review the default document specification and voice notes — customize for your project after the first content draft establishes the voice.

## 5d. Instantiate stage-entry reference files (gate-checked)

The pipeline runs a **Stage-Entry Reference-File Completeness Gate** (`reference/stage-instructions.md` § Stage-Entry Reference-File Completeness Gate): at the entry of each consuming stage, certain per-project reference files must be present **AND filled** — a file that still carries its template placeholders fails the gate. The full contract (which file, consuming stage, hard-vs-soft class) is `docs/required-reference-files.md` § Stage-entry reference files.

Instantiate from the `.template.md` shapes in `reference/` when the project reaches the consuming stage (or now, if known):

- `reference/stage-5-paths.md` (from `stage-5-paths.template.md`) — **hard blocker** for Stage 4–5 (`run-report`, `produce-*`). If absent or unfilled at Stage 5 entry, the commands halt with a remediation prompt.
- `reference/claim-permission.md` (from `claim-permission.template.md`) — **soft fallback** for Pass 3 (`run-sufficiency` Phase A). If absent or unfilled, the gate proceeds in an explicitly-disclosed GENERIC-BAR regime (one generic bar for all claim types) and logs the degraded regime at entry — legitimate for generic-only projects, but the disclosure line will appear every run.

Also instantiate `reference/known-limits.md` (from `known-limits.template.md`) and `reference/source-class-hierarchy.md` (from `source-class-hierarchy.template.md`) before Stage 1 — `run-preparation` Step 3c (Researchability Triage) and the Stage-2 supplementary register-hit gate read them.

## 6. Create skill symlinks

Symlink all skills from the skill library. From your project root:

```bash
SKILLS_DIR="../../ai-resources/skills"  # adjust relative path if project is not in projects/

for skill in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill")
  # Skip if a local copy already exists (knowledge-file-producer only — do not keep local copies of other skills)
  [ -d "reference/skills/$skill_name" ] && continue
  ln -s "$skill" "reference/skills/$skill_name"
done
```

**Verify:** `ls -la reference/skills/` should show symlinks pointing to `ai-resources/skills/`. Local skills (`knowledge-file-producer`) remain as real directories; all others use the canonical ai-resources path.

**Required skills (minimum set for the research workflow):**
- analysis-pass-memo-review
- answer-spec-generator
- answer-spec-qc
- chapter-prose-reviewer
- citation-converter
- cluster-analysis-pass
- cluster-memo-refiner
- cluster-synthesis-drafter
- context-pack-builder
- document-integration-qc
- evidence-prose-fixer
- evidence-spec-verifier
- evidence-to-report-writer
- gap-assessment-gate
- research-plan-creator
- repo-health-analyzer
- research-structure-creator
- section-directive-drafter
- task-plan-creator

Additional skills in the library are symlinked automatically by the loop above. Unused skills have zero cost; missing skills interrupt execution.

## 7. Optional: Create context folder

If the project needs domain-specific reference documents beyond the standard `reference/` files:

```bash
mkdir context/
```

Use this for project briefs, domain knowledge files, content architecture docs, etc.

## 8. Required: Configure Confidentiality Boundaries

Open `CLAUDE.md` and populate the `## Confidentiality Boundaries` section with any confidential identifiers (deal names, company names, financial terms) that must not appear in outbound GPT-5 API calls. The `/verify-chapter` command checks this section before every fact-verification call.

If the project has no confidentiality constraints, replace the placeholder list with: "No confidentiality constraints for this project."

## 8b. Required: Populate Fact-Verification Prompt

Open `reference/sops/fact-verification-prompt.md` and fill the `{{FACT_VERIFICATION_SYSTEM_PROMPT}}` placeholder with your project's domain-specific framing (the subject entity, the report's domain, and the source-availability posture). **Keep the supplied "Verification rules" and "Output format" scaffolding below the placeholder** — it is the domain-agnostic verification floor (sourced+dated, evidence≠interpretation, no category-leakage, fixed discrepancy output) and should not be deleted. The `/verify-chapter` command reads this whole file in Step 2.

## 8c. Optional: Customize SOPs

Review and adjust `reference/sops/` if the project uses different API configurations or system prompts for Research Execution GPT or Perplexity.

## 9. Write initial task plan draft

Create the first task plan draft:

```bash
touch preparation/task-plans/[section]-task-plan-draft.md
```

Fill it with the section's objective, scope, constraints, and audience. This is the input for `/run-preparation`.

## 10. Initial commit

```bash
git add -A
git commit -m "init: [project-name] workspace from research template"
```

## 11. Validate

Start Claude Code in the project directory, then:

1. Run `/status` — confirm it returns a coherent project summary
2. Run `/run-preparation` — confirm it picks up the task plan draft and begins Stage 1

If either fails, check:
- Skill symlinks resolve correctly (`ls -la reference/skills/`)
- CLAUDE.md has no remaining `{{PLACEHOLDER}}` markers
- settings.json is valid JSON

---

## Placeholder Reference

All placeholders used in template files:

| Placeholder | Files | Purpose |
|------------|-------|---------|
| `{{PROJECT_TITLE}}` | CLAUDE.md, reference/stage-instructions.md, reference/file-conventions.md, reference/quality-standards.md, reference/style-guide.md | Project name in headings |
| `{{PROJECT_DESCRIPTION}}` | CLAUDE.md | Project scope description |
| `{{ANALYTICAL_LENS}}` | CLAUDE.md | Analytical framework |
| `{{CURRENT_SECTION}}` | CLAUDE.md | Starting section |
| `{{DOCUMENT_ARCHITECTURE}}` | CLAUDE.md | Document structure |
| `{{EVIDENCE_CALIBRATION}}` | CLAUDE.md | Evidence availability note |
| `{{OPERATOR_NAME}}` | CLAUDE.md | Operator's name |
| `{{SECTION_SEQUENCE}}` | reference/stage-instructions.md | Section ordering constraints |
| `{{WORKSPACE_ROOT}}` | .claude/settings.json | Absolute path to workspace root containing ai-resources/ (set at step 1.5, before any session loads) |
| `{{PART_TWO_DIR}}` | .claude/commands/produce-architecture.md | Part-2 source directory slug under `parts/` (e.g., `part-2-service`). Only needed if the project uses `/produce-architecture` (parts-based document model) |
| `{{PART_THREE_DIR}}` | .claude/commands/produce-architecture.md | Part-3 source directory slug under `parts/` (e.g., `part-3-strategy`). Only needed if using `/produce-architecture` |
| `{{PART_TWO_PROSE_DIR}}` | .claude/commands/produce-architecture.md | Part-2 prose-output directory slug under `output/` (e.g., `part-2-prose`). Only needed if using `/produce-architecture` |
| `{{PART_THREE_PROSE_DIR}}` | .claude/commands/produce-architecture.md | Part-3 prose-output directory slug under `output/` (e.g., `part-3-prose`). Only needed if using `/produce-architecture` |
