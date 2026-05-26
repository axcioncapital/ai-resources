---
name: source-class-mapper
description: >
  Assigns each research question a primary source-class plus ordered fallback
  ladder from the project's source-class hierarchy. Use when /run-preparation
  enters its Pass 1 sub-agent step. Do NOT use to classify collected sources
  or draft prompts.
model: sonnet
effort: medium
---

# Source-Class Mapper

> **Reference dependency.** This skill reads `reference/source-class-hierarchy.md` (project-level). The reference file is a project-side deliverable, not part of this skill's bundle. Until a project provides it, the skill exits at pre-flight with a remediation prompt naming the missing file. See the project's pipeline documentation for the project-specific unblock plan.

## Purpose

The research workflow's four-pass model (Discovery → Extraction → Sufficiency → Synthesis) splits *evidence acquisition* from *sufficiency adjudication*. Pass 1 (Discovery) ends with research prompts that target the strongest available source class per claim type. This skill is the step that decides which source class each research question should target *before* prompts are drafted — separating the "what evidence are we looking for?" decision from the "how do we phrase the query?" decision.

Without this step, `research-prompt-creator` has to do both jobs at once, which conflates source-quality judgment with prompt-phrasing craft. Splitting them lets prompts be written against an explicit source-class assignment and lets the assignment be audited independently.

## When to Use

- Invoked by `/run-preparation` once per section, after research questions land in `preparation/research-plans/{section}-research-plan-v{N}.md` and before `research-prompt-creator` runs.
- One invocation per section. Positional argument: section identifier (e.g., `1.1`).
- Re-run only on an explicit operator request (e.g., the source-class hierarchy was updated and the existing map is stale). There is no sentinel-based re-entry contract — Pass 1 does not share the `/run-sufficiency` re-entry semantics.

## When Not to Use

- Do NOT use to classify already-collected sources (that is the extract-time job, handled by `research-extract-creator`).
- Do NOT use to generate research prompts (`research-prompt-creator`'s job — it consumes this skill's output).
- Do NOT use to evaluate sufficiency of evidence (Pass 3 / `claim-permission-gate`'s job).
- Do NOT embed source-class definitions inside this skill — they live in the project's `reference/source-class-hierarchy.md`. This skill is project-agnostic; the hierarchy is project-specific.

## Inputs

| Input | Path | Required |
|---|---|---|
| Research plan (the question set) | `preparation/research-plans/{section}-research-plan-v{N}.md` — use the highest `v{N}` present | yes |
| Source-class hierarchy (the taxonomy) | `reference/source-class-hierarchy.md` (project-level) | yes |

If multiple `v{N}` research-plan files exist, use the highest version number.

## Output

Single file: `preparation/source-class-map/{section}-source-class-map.md`.

The output directory is created on first write (project-level `preparation/source-class-map/` may not exist yet).

### Output schema

A frontmatter block followed by one Markdown table:

```markdown
---
section: {section identifier}
research_plan_source: preparation/research-plans/{section}-research-plan-v{N}.md
hierarchy_source: reference/source-class-hierarchy.md
generated_at: {YYYY-MM-DD}
---

# Source-Class Map — Section {section identifier}

| Question ID | Question (short) | Primary class | Fallback ladder | Notes |
|---|---|---|---|---|
| Q1-1 | {short question text — first 60 chars} | {class name from hierarchy} | {class → class → class} | {one-line rationale or "no-class-match: {reason}"} |
| ... | ... | ... | ... | ... |
```

- **Question ID** comes verbatim from the research plan (do not renumber).
- **Question (short)** is a 60-character truncation of the question text — for human scanability, not as the canonical question.
- **Primary class** must be a class name that appears literally in `source-class-hierarchy.md`. Do not invent class names.
- **Fallback ladder** is a `→`-separated chain of class names, each appearing literally in `source-class-hierarchy.md`. Order: best-acceptable-alternative first. Three classes typical; one is acceptable if the hierarchy is shallow.
- **Notes** carries either a one-line rationale or — when no class in the hierarchy fits — the literal text `no-class-match:` followed by a one-line reason (see Failure Behavior below).

### Example

A realistic 3-row sample, for format calibration. Class names are illustrative — actual class names come from each project's `source-class-hierarchy.md`.

Frontmatter:

```yaml
section: {section}
research_plan_source: preparation/research-plans/{section}-research-plan-v3.md
hierarchy_source: reference/source-class-hierarchy.md
generated_at: 2026-MM-DD
```

Body:

> # Source-Class Map — Section {section}
>
> | Question ID | Question (short) | Primary class | Fallback ladder | Notes |
> |---|---|---|---|---|
> | Q1-1 | What is the deal-count trend by country at the targe | industry-statistics-aggregate | industry-trade-publication → primary-corporate-filing | Aggregate series strongest; trade pubs as cross-check |
> | Q2-3 | How do practitioners describe value-creation framewo | practitioner-self-published | industry-interview-transcript | Single-class fallback; positioning evidence only |
> | Q4-2 | What is the founder-sale conversion rate at the targ | NONE | NONE | no-class-match: public series does not track this conversion at the size lens |

Rows illustrate three patterns: standard 3-class assignment (Q1-1), shallow single-class fallback (Q2-3), and `no-class-match` (Q4-2).

## Behavior

1. **Pre-flight.** Verify both inputs exist. If `reference/source-class-hierarchy.md` is absent: exit with the remediation prompt under Failure Behavior — do not invent a fallback hierarchy. If the research plan is absent: exit with a prompt naming the expected path.
2. **Load the hierarchy.** Read `source-class-hierarchy.md` end-to-end. Extract the set of class names exactly as written (case-sensitive, hyphenation-sensitive). These are the only valid values for the Primary class and Fallback ladder columns.
3. **Load the question set.** Read the research plan. Identify each question by its ID and its full text. Capture any per-question scope notes the plan attaches.
4. **Assign per question.** For each question, decide the primary class by reading the question's intent (what kind of evidence would best support a claim answering this question?) against the hierarchy. Then choose 1–3 fallback classes in priority order. Use the hierarchy's own ordering and any explicit fallback annotations it provides; where the hierarchy is silent, pick the next-most-relevant class.
5. **Write the output file.** Use the exact schema above. Do not add columns; do not omit columns.

## Failure Behavior

- **`reference/source-class-hierarchy.md` absent.** Exit. Emit:
  > Source-class-mapper requires `reference/source-class-hierarchy.md` (project-level deliverable). File not found. The hierarchy is a project-side responsibility — consult the project's pipeline documentation for the unblock plan. Skill will be functional once the project provides the file.
- **Research plan absent.** Exit. Emit a one-line prompt naming the expected path and asking the operator whether the section identifier is correct or the research plan still needs to be drafted.
- **A question fits no class in the hierarchy.** Do not invent a class. Set Primary class to the literal string `NONE`, set Fallback ladder to `NONE`, and write `no-class-match: {one-line reason}` in Notes. Continue with the remaining questions. A non-zero count of `no-class-match` rows is a signal for the operator to extend the hierarchy — surface the count in a brief end-of-run summary to chat.
- **Hierarchy is malformed (e.g., no extractable class names).** Exit. Do not guess at the intended class names from prose.
- **Multiple research-plan versions.** Use the highest `v{N}`. State which version was used in a brief end-of-run summary.

## Bias Countering

This skill must not over-promise. Specifically:

- Do not assign a primary class stronger than what the question actually warrants because it would "make the question answerable." Preserve the gap; tag `no-class-match` when honest.
- Do not pad fallback ladders with classes that are nominally adjacent but unhelpful. A two-class ladder is better than a four-class ladder with two filler entries.
- Do not infer claim type from the question's phrasing if the research plan's scope note attaches an explicit claim type — use the explicit one.
- It is acceptable — and expected — to mark questions as `no-class-match` rather than force-fit. Forcing a fit is the failure mode this skill exists to prevent.

## Failure-on-Empty

If after processing all questions the output table has zero rows, do not write the output file. Exit with a one-line message naming the research plan path and noting that no questions were parseable.

## Runtime Recommendations

- **Model rationale.** Sonnet is sufficient because the assignment is taxonomy-matching against an explicit, project-provided list — not open-ended judgment under ambiguity. Escalate to Opus only if the project's source-class hierarchy contains many subtle distinctions, or if a first pass returns more than ~20% `no-class-match` rows (signal that judgment dominates).
- **Effort rationale.** Medium — one structured output file; not heavy synthesis.
- **Context footprint.** Loads two files (one research plan, one hierarchy). Both are typically small (combined under 50 KB).
- **Invocation cardinality.** One invocation per section. NOT safe to parallelize against the same section (same output file). Safe to parallelize across different sections.
- **Model-invocation posture.** Default (enabled). The skill is invoked explicitly by `/run-preparation` in a pipeline context and produces a deterministic file; auto-invocation is acceptable.
- **Tool footprint.** Read + Write only. No shell, no network.

## Cross-References

- The output is consumed by `research-prompt-creator` (Pass 1, after this skill).
- The project-level reference doc that unblocks this skill is `reference/source-class-hierarchy.md`.
- Companion Pass 3 skills that may emit in the same workflow wave: `country-parity-checker`, `claim-permission-gate`. Those run later in the pipeline and have different re-entry semantics (sentinel files under `/run-sufficiency`). This skill does NOT emit a sentinel.
