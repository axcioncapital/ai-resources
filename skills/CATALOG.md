# Skill Catalog

Quick-reference index for the 80 skills in this library, grouped by domain. Each skill lives in its own folder with a `SKILL.md` file.

> **Reconciled 2026-07-12 (W3.2 M-A4)** against the live `skills/` inventory: 20 skills were on disk but absent from this catalog (the header had read "60" since April while the library grew to 80). No dead rows. Ground truth is the set of `skills/*/SKILL.md` files — not this file.

---

## Research Pipeline

Core research workflow from planning through evidence extraction.

| Skill | Purpose |
|-------|---------|
| `task-plan-creator` | Co-author foundational Task Plans for Axcion projects |
| `research-plan-creator` | Transform Task Plans into sequenced, answerable research questions |
| `answer-spec-generator` | Generate Answer Specs from research questions or Research Plans |
| `answer-spec-qc` | QC gate for Answer Specs before they enter execution |
| `execution-manifest-creator` | Route research questions to appropriate execution tools |
| `research-prompt-creator` | Transform manifests + specs into execution prompts |
| `research-prompt-qc` | Quality check on execution prompts before operator approval |
| `research-extract-creator` | Structure raw research output into claims inventories |
| `research-extract-verifier` | Adversarial verification of extracts against source reports |
| `source-class-mapper` | Assign each research question a primary source-class plus ordered fallback ladder |
| `fund-triage-scanner` | Batch-native PE fund triage — fetch, extract signals, classify PASS/FAIL/INSUFFICIENT |

## Supplementary Research

Gap-filling via Perplexity after primary research.

| Skill | Purpose |
|-------|---------|
| `supplementary-query-brief-drafter` | Draft targeted Perplexity queries for thin/missing components |
| `supplementary-research-qc` | Filter Perplexity results before merge |
| `supplementary-evidence-merger` | Integrate QC-approved supplementary evidence into packs |

## Analysis and Synthesis

From evidence to analytical memos and editorial decisions.

| Skill | Purpose |
|-------|---------|
| `cluster-analysis-pass` | Produce structured analytical memos from research extracts |
| `cluster-memo-refiner` | Six-check refinement of cluster analytical memos |
| `cluster-synthesis-drafter` | Draft preliminary prose from pre-analyzed cluster inputs |
| `gap-assessment-gate` | Go/no-go decision on evidence sufficiency before architecture |
| `analysis-pass-memo-review` | Surface editorial decisions from cluster memos |
| `editorial-recommendations-generator` | Generate recommended answers for editorial decisions |
| `editorial-recommendations-qc` | Independent QC of editorial recommendations |
| `claim-permission-gate` | Assign each claim a permission class, capped by its risk tier |
| `country-parity-checker` | Per-cluster country-parity verdict — flags single-country dominance and thinness |
| `transaction-table-builder` | Build a structured transaction-evidence table (13 mandatory fields per deal) |

## Report Production

From section directives through prose to final chapters.

| Skill | Purpose |
|-------|---------|
| `section-directive-drafter` | Transform cluster memos into structured section directives |
| `evidence-to-report-writer` | Transform evidence-organized prose into narrative sections |
| `decision-to-prose-writer` | Transform structured decision documents into narrative prose |
| `research-structure-creator` | Design unified document architecture from multiple drafts |
| `citation-converter` | Convert inline claim IDs to formatted citations |
| `h3-title-pass` | Add and refine H3 subheadings for readability |
| `chapter-revision-applier` | Apply operator inline-edit markers to a chapter draft; emit the revised file |

## Prose Quality and Compliance

Review, verification, and formatting gates.

| Skill | Purpose |
|-------|---------|
| `chapter-prose-reviewer` | Diagnose chapter draft quality across multiple dimensions |
| `chapter-review` | Review chapter draft against upstream artifacts |
| `evidence-prose-fixer` | Resolve fidelity flags from fact verification |
| `evidence-spec-verifier` | Verify evidence packs against originating answer specs |
| `report-compliance-qc` | Compliance gate for individual report chapters |
| `prose-compliance-qc` | Final compliance gate before H3 titles |
| `document-integration-qc` | Editorial QC per report module |
| `prose-formatter` | Apply mechanical formatting without changing words |
| `formatting-qc` | QC a formatted module — formatting integrity, visual rhythm, standalone coherence |
| `ai-prose-decontamination` | Five-pass removal of AI writing patterns (ornament, repetition, register) |
| `prose-refinement-writer` | Fix unclear sentence-to-sentence logic and underdeveloped hardest claims |
| `jargon-gloss` | Insert short parenthetical glosses on first mention of undefined domain terms |

## Knowledge File Production

Condensing research into Chat-consumable knowledge files.

| Skill | Purpose |
|-------|---------|
| `knowledge-file-producer` | Condense cited chapters into Chat-consumable knowledge files |
| `knowledge-file-completeness-qc` | Cross-check knowledge file against source chapters |

## Project Infrastructure

Planning and implementing Claude Code projects.

| Skill | Purpose |
|-------|---------|
| `context-pack-builder` | Transform vague assignments into precise, AI-ready context packs |
| `spec-writer` | Write technical specifications from context packs |
| `implementation-project-planner` | Create implementation project plans for Claude Code infrastructure |
| `architecture-designer` | Design Claude Code architecture from project plans |
| `architecture-qc` | Independent QC of architecture specifications |
| `implementation-spec-writer` | Translate architecture into line-level implementation specs |
| `project-implementer` | Execute approved implementation specs mechanically |
| `project-tester` | Run verification checks on completed implementations |
| `session-guide-generator` | Generate session-by-session execution guides |
| `project-scoping` | Scope a multi-workstream build into a control pack + planning brief |
| `technical-solution-consultant` | Translate business intent into a justified, build-ready technical plan |
| `grill-me` | Interview the operator until shared understanding, then emit a mandate brief |

## AI Resource Development

Creating and improving skills, prompts, and instructions.

| Skill | Purpose |
|-------|---------|
| `ai-resource-builder` | Create, evaluate, and improve AI resources (unified methodology) |
| `prompt-creator` | Create effective prompts for Claude |
| `specifying-output-style` | Crystallize document type, depth, and voice specifications |

## Workflow Design

Designing and evaluating multi-tool AI workflows.

| Skill | Purpose |
|-------|---------|
| `workflow-creator` | Design multi-tool AI workflows from scratch |
| `workflow-consultant` | Decompose unfamiliar problems into workflow-shaped solutions |
| `workflow-documenter` | Format and document workflow ideas |
| `workflow-evaluator` | Evaluate workflows on architectural soundness |
| `claude-code-workflow-builder` | Adapt workflows for Claude Code execution |
| `workspace-template-extractor` | Extract reusable project templates from working workspaces |
| `workflow-system-analyzer` | Inventory and trace a workflow's deployed infrastructure |
| `workflow-system-critic` | Prioritized findings on a workflow system's infrastructure coherence |

## Personal Knowledge Management

Living knowledge base from personal notes.

| Skill | Purpose |
|-------|---------|
| `journal-thinking-clarifier` | Socratic dialogue on vague personal notes |
| `journal-wiki-creator` | Create new wiki articles from clarified notes |
| `journal-wiki-improver` | Improve prose quality of existing wiki articles |
| `journal-wiki-integrator` | Weave new thinking into existing articles |

## Knowledge Base Construction

Scaffolding and populating Obsidian knowledge-base vaults.

| Skill | Purpose |
|-------|---------|
| `obsidian-kb-builder` | Define and scaffold Claude Code-queryable Obsidian vaults (4-folder schema) |
| `intake-processor` | Two-stage intake — decompose raw notes into atomic units, route to themes |

## Session and Workspace Operations

Session state handoff and working-tree hygiene.

| Skill | Purpose |
|-------|---------|
| `handoff` | Unified session handoff — continuity mode (save state) or fork mode (compress) |
| `worktree-cleanup-investigator` | Investigate a dirty git working tree and plan a safe cleanup |

## Content and Analytics

Standalone content processing and workspace analysis.

| Skill | Purpose |
|-------|---------|
| `curiosity-hub-article-writer` | Rewrite GPT-drafted articles into polished prose |
| `repo-health-analyzer` | Workspace-level health check and audit |
| `session-usage-analyzer` | Analyze token efficiency from session summaries |
| `summary` | Compress long documents into faithful summaries for stakeholder distribution |
