# {{PROJECT_TITLE}}

## Project Context

**What:** {{PROJECT_DESCRIPTION}}

**Analytical lens:** {{ANALYTICAL_LENS}}

**Current Section:** {{CURRENT_SECTION}}

**Document architecture:** {{DOCUMENT_ARCHITECTURE}}. See `reference/stage-instructions.md` for full sequence constraints.

**Evidence calibration:** {{EVIDENCE_CALIBRATION}}

## Operator Profile

{{OPERATOR_NAME}} is the sole operator. They review outputs at defined gates, make editorial decisions requiring domain judgment, and approve stage transitions. Claude Code executes; the operator reviews and directs.

## Project Config

> **Forward contract — no live consumer reads this block yet (as of canonical landing 2026-05-27).** The 12 fields below are the declarative project values that ~6 downstream consumers (Stage 5 commands, three Stage-2 skills, `country-parity-checker`, Bundle-2 reference docs) are *intended* to read at runtime. As of this landing, zero of those consumers parse the block. The schema is landed one work-unit ahead of the first confirmed consumer-builder (Stage 5 parameterization in the parent fix-phase plan). When you read this section, assume no automated reader sees it unless you've separately verified a consumer parser exists. Full schema documentation, per-consumer field-fan-out, single-source-of-truth rules, canonical parse format, and migration-trigger conditions live at `docs/project-config-schema.md`.

```markdown
**Report set:** [{{REPORT_SET}}]  # parameterizes Stage 5 commands; report-count derived from list length
**Section IDs:** [{{SECTION_IDS}}]  # parameterizes per-section paths
**Country set:** [{{COUNTRY_SET}}]  # CANONICAL; reference/source-class-hierarchy.md § Project Country Set is the derived mirror
**Country superset:** [{{COUNTRY_SUPERSET}}]  # for "pan-region" leakage detection; always a superset of Country set
**Languages:** [{{LANGUAGES}}]  # ISO 639-1 codes; parameterizes research-prompt-creator language blocks; empty = English-only
**Deal-size lens:** "{{DEAL_SIZE_LENS}}"  # operator-facing only; cited in size-class tags
**Domain:** "{{DOMAIN}}"  # parameterizes jargon-gloss whitelist activation
**Verification posture:** "{{VERIFICATION_POSTURE}}"  # per-claim-cited | lighter-than-formal | interpretive-only
**Source-availability:** "{{SOURCE_AVAILABILITY}}"  # public-only | mixed | paid-databases-allowed
**Research-area-phrase:** "{{RESEARCH_AREA_PHRASE}}"  # parameterizes Perplexity-prefix in run-execution.md and stage-instructions.md
**Current period:** "{{CURRENT_PERIOD}}"  # parameterizes freshness classes (CURRENT, RECENT, BASELINE)
**Delivery vault:** "{{DELIVERY_VAULT}}"  # optional; consumed by produce-knowledge-file; default no-op
```

For full field documentation (types, examples, canonical parse format, consumer fan-out, GR-2 migration triggers), read `docs/project-config-schema.md`.

## Confidentiality Boundaries

<!-- REQUIRED SETUP: Replace this section before running /verify-chapter. -->
<!-- List all confidential identifiers (deal names, company names, financial terms) that must NOT appear in outbound GPT-5 API calls. /verify-chapter checks this list before constructing each API call. -->

Confidential identifiers for this project:
- {{CONFIDENTIAL_IDENTIFIER_1}}
- {{CONFIDENTIAL_IDENTIFIER_2}}

If this project has no confidentiality constraints, replace the list with: "No confidentiality constraints for this project."

## Workflow Overview

Five-stage pipeline: Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production.

Artifact chain: Task Plan → Research Plan → Answer Specs → Deep Research Reports → Research Extracts → Cluster Analytical Memos → Section Directives → Report Prose

**IMPORTANT:** For detailed stage instructions, read `reference/stage-instructions.md`. For file naming rules, read `reference/file-conventions.md`. For QC standards and evidence handling, read `reference/quality-standards.md`. For writing voice and style, read `reference/style-guide.md`. Only load these when actively working on the relevant stage or task.

## Skill Dependency Chain

Research workflow skills form a pipeline. When modifying any skill in this chain, check downstream skills for impact:

```
research-plan-creator → answer-spec-generator → [external: GPT-5 execution]
→ cluster-analysis-pass → evidence-to-report-writer
```

## Workflow Status Command

`/workflow-status` — Read-only command that displays a structured status view of every stage in the research workflow, then runs a QC health check via subagent using the `workflow-evaluator` skill. Both phases always run together. Source workflow: `reference/stage-instructions.md`. Skill reference integrity is checked against `ai-resources/skills/`.

## Utility Commands

`/audit-repo` — Run a workspace health check. Analyzes file organization, CLAUDE.md health, skill inventory, commands, settings, and best practices. Report written to `reports/repo-health-report.md`.

## Cross-Model Rules

- Research Execution GPT produces evidence (Stage 2) — Claude does not substitute its own research
- Research Execution GPT verifies Claude's prose for fact-checking (Stage 4) — Claude does not fact-check its own writing
- Perplexity handles factual retrieval and gap-filling — Claude routes queries, does not guess answers

## Autonomy Rules

When executing a process or workflow, proceed through stages automatically unless:
- A step is tagged [Operator] — always pause for input
- A step is tagged [Operator + Claude Code] — proceed if no issues found, pause only if you find something that changes the project's logic, scope, or structure
- An evaluation report contains critical findings — pause and show the findings
- A gate fails — pause and explain what failed

For non-critical issues (formatting, minor wording, small structural fixes), apply the fix and note what you changed. Do not pause for approval on minor fixes.

## Context Isolation Rules

See `reference/stage-instructions.md` § Context Isolation Rules.

## Friction Logging

Pipeline commands auto-start a friction log session via hook (`friction-log: true` in command frontmatter). The operator can also log friction manually:

- `/friction-log start` — start a new session block
- `/friction-log [description]` — append a friction event
- `/improve` — run the improvement analyst on session friction (end-of-session)

## Citation Conversion Rule

See `reference/stage-instructions.md` § Citation Conversion Rule.

## Bright-Line Rule

See `reference/stage-instructions.md` § Bright-Line Rule.

## Input File Handling

Input files — context packs, reference documents, source data, prior artifacts the operator drops into the working directory — are read-only references. Use them by path, do not copy or rewrite them.

- **Default to `Read`.** When the operator points you at an input file (whether it lives in the project folder, an `inputs/` sibling, or an absolute path elsewhere on the filesystem), use the `Read` tool against that path. Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands (`cp`, `cat >`, `tee`, redirection, `install`, etc.) against a file whose content originated outside the current session.
- **Do not materialize chat content.** If an input's content enters the conversation (pasted, quoted, or summarized), that does not make the chat copy canonical. The file on disk remains the source of truth.
- **Do not co-locate inputs with outputs for "provenance."** If provenance matters, record the absolute path of the input in the artifact's frontmatter or a `sources.md` file — do not duplicate the bytes.
- **Outputs are different.** Artifacts your command is *designed to produce* (plans, specs, drafts, reports) are written normally via `Write` into `output/{project}/`. This rule governs inputs only.
- **Operator-pasted content — save verbatim.** When the operator pastes file content and asks you to save it, use `Write` to save exactly as provided. No reformatting, no truncation, no restructuring. If no target path is given, ask before writing. Flag before writing if: target path exists and would be overwritten; content appears incomplete; content conflicts with an approved artifact. Confirm the write by stating target path and line count — do not describe the content.
- **Exception: legitimate copying.** Copy an input only when (a) the operator explicitly asks for an archival snapshot or reproducibility freeze, or (b) a downstream tool requires the file at a specific path and no symlink or path argument will satisfy it. In both cases, record the absolute source path in the copy's frontmatter or in a sibling `SOURCE.md`, and state in your turn-summary that you copied rather than referenced.

This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.

## File Verification and Git Commits

Verify files you just wrote by reading them from the filesystem, not by running git status/diff. The filesystem is the source of truth for files you just created or modified.

If a commit fails with no staged changes, report it once and move on — the most common cause is unchanged content.

## Commit Rules

**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

Do not push. Pushing is a manual operator step. After committing, remind the operator to push and to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.

## Compaction

When `/compact` fires, preserve:
- The current pipeline/stage identifier and active working directory (which section, which stage, which command is mid-run).
- Paths to any subagent-output files the main session has not yet read.
- Any pending operator gate the session is holding at.

Auto-compact drops these by priority; name them explicitly so they survive. Before `/compact`, prefer writing a short session-state scratchpad (current step, decisions, partial findings, artifact paths) and `/clear` + restart from the scratchpad over lossy auto-summarization.

**Post-compact resumption — trust the summary.** When resuming after compaction, treat the summary's "commits made" / "files modified" / "decisions" lists as authoritative. Do NOT re-derive them via `git log`, `git show`, or repeated Reads of `session-notes.md`/`decisions.md`. Verify only when the next action requires a specific detail the summary didn't capture (e.g., line numbers for an Edit). Cost test: if your verification doesn't change the next tool call, skip it.

## Session Boundaries

When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context. Stale context from a prior task compounds and contaminates the next one.
