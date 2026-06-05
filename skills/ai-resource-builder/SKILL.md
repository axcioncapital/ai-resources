---
name: ai-resource-builder
description: >
  Creates, evaluates, and improves AI resources (skills, prompts, project
  instructions). Use when: (1) building a new skill or prompt from scratch,
  (2) evaluating a resource for quality against the eight-layer framework,
  (3) improving an existing resource from feedback or bug reports.
  Do NOT use for: workflow design (use workflow-creator), non-AI documents,
  or executing/running skills.
model: opus
effort: high
---

# AI Resource Builder

Create, evaluate, and improve AI resources. Enforces Axcion's structure, progressive disclosure, and quality standards.

## Mode Selection

Identify which mode applies, then follow that workflow.

| Mode | Trigger | Jump to |
|------|---------|---------|
| **Create** | Building a new skill, prompt, or project instruction from scratch | Create Workflow |
| **Evaluate** | Reviewing an existing resource for quality without modifying it | Evaluate Workflow |
| **Improve** | Modifying an existing resource based on feedback or bug reports | Improve Workflow |

If the user provides feedback on an existing resource, use **Improve** even if they say "make it better." If they want a quality report without changes, use **Evaluate**. If ambiguous, ask.

## Skill Architecture

For the full architecture reference — folder structure, the 500-line size budget, the three-level progressive disclosure rules (metadata / SKILL.md body / bundled resources), the bundled resource types (`scripts/`, `references/`, `assets/`), and naming conventions — read [`references/skill-architecture.md`](references/skill-architecture.md). Load it whenever designing a new skill folder, restructuring an existing one, or deciding whether to add a sibling file.

## Frontmatter Standards

### Name Field

Max 64 characters. Lowercase letters, numbers, and hyphens only. Must match folder name.

### Description Field

The description is the primary trigger mechanism. Claude decides whether to load a skill based on this field alone.

**Critical: 250-character truncation.** In the `/skills` listing, descriptions are capped at 250 characters. Anything past 250 characters is silently cut. Front-load the key use case and trigger phrases within the first 250 characters.

Rules:
- **Third person.** "Analyzes spreadsheets..." not "I can help you analyze..."
- **Structure:** `[What it does] + [When to use it]` — front-loaded within 250 chars.
- **Be "pushy."** Claude tends to under-trigger skills. Make descriptions assertive: "Builds data dashboards. Use when user mentions dashboards, metrics, or data display."
- **Include negative triggers** when the skill risks over-triggering or conflicts with another skill: "Do NOT use for simple data exploration (use data-viz instead)."
- **Max 1024 characters** total, but aim for under 200 when possible.

For good and bad description examples, plus the full operational frontmatter field table (allowed-tools, paths, context, effort, model, hooks, and more), read [`references/operational-frontmatter.md`](references/operational-frontmatter.md).

**Companion hooks principle:** If a check is binary (pass/fail), runs the same way every time, and doesn't need Claude's reasoning — it should be a hook, not a skill instruction. Examples: linting after code generation, blocking commits with sensitive files.

## Create Workflow

Progress: [ ] Understand [ ] Plan resources [ ] Initialize [ ] Write [ ] Validate

### Step 1: Understand the Resource

Clarify concrete examples of how the skill will be used. Ask targeted questions:

- What functionality should the skill support?
- What would a user say that should trigger this skill?
- Can you give examples of typical usage?
- What should it NOT do? (Exclusions matter as much as inclusions)

Avoid overwhelming — start with the most important questions and follow up as needed. Conclude by summarizing: use cases, trigger conditions, and exclusions.

Skills operate in a multi-tool ecosystem. They may interact with GPT-5 (via API/CustomGPT), Perplexity (via API), Notion, and NotebookLM. Account for cross-tool workflows where applicable.

**If requirements contradict each other**, surface the conflict and ask the user to resolve it before proceeding.

### Step 2: Plan Bundled Resources

Analyze each concrete example:

1. How would you execute this from scratch?
2. What scripts, references, or assets would help when doing this repeatedly?

| Example Task | Analysis | Resource |
|-------------|----------|----------|
| "Rotate this PDF" | Same rotation code rewritten each time | `scripts/rotate_pdf.py` |
| "Build me a todo app" | Same frontend boilerplate each time | `assets/hello-world/` template |
| "How many users logged in?" | Need to rediscover table schemas each time | `references/schema.md` |

### Step 3: Initialize Structure

Create the directory with only the subdirectories that will contain files:

```
skill-name/
├── SKILL.md
├── scripts/      (if needed)
├── references/   (if needed)
└── assets/       (if needed)
```

### Step 4: Write the Resource

The skill is written for another Claude instance. Include information that is beneficial and non-obvious to Claude. Challenge each piece: "Does Claude really need this?" and "Does this justify its token cost?"

#### 4a. Start with Bundled Resources

Implement scripts, references, and assets first. Test added scripts by running them — if a script fails, fix it before writing SKILL.md. This prevents SKILL.md from referencing nonexistent or broken files.

#### 4b. Write the Frontmatter

Apply the rules from the Frontmatter Standards section. After writing the description, verify the first 250 characters contain the primary trigger phrases.

**Declare `model:` and `effort:`.** Both are required for every skill. The Claude Code harness honors them — when the skill is invoked, it swaps to the declared model and effort for that turn, then reverts on the next user prompt. Without them the skill inherits the session model and may underperform (e.g., an Opus-tier judgment skill silently running on Sonnet).

Use the decision heuristic: *"Is the hard part deciding, or doing?"*

| Work type | `model:` | `effort:` |
|---|---|---|
| Judgment (deciding under ambiguity, synthesis, design, prose review) | `opus` | `high` |
| Structured / execution (repeatable factual workflows, scaffolding, orchestration) | `sonnet` | `medium` |
| Mechanical (counts, format checks, log appends, pattern matching) | `haiku` | `low` |

Use the short form (`opus` / `sonnet` / `haiku`) and the 3-tier effort scale (`low` / `medium` / `high`). Do not use `xhigh` or `max` — outside the current convention. Full mapping table and examples in [`references/operational-frontmatter.md`](references/operational-frontmatter.md).

#### 4c. Write the Body

Use imperative/infinitive form. Explain the *why* behind instructions — Claude works better with reasoning than rote commands.

**Degrees of freedom** — match specificity to the task's fragility:

- **High freedom** (text instructions): Multiple valid approaches, context-dependent. "Analyze the code and suggest improvements based on what you observe."
- **Medium freedom** (pseudocode): Preferred pattern exists, some variation. A parameterized function signature with comments.
- **Low freedom** (exact scripts): Fragile operations, consistency critical. "Run `scripts/migrate.py --verify --backup`. Do not modify the command."

Think of Claude exploring a path: a narrow bridge needs guardrails (low freedom), an open field allows many routes (high freedom).

#### 4d. Counter Default Biases

For any skill that generates text, analysis, or recommendations, include bias-countering instructions adapted to the domain:

```
If the provided information is insufficient to answer confidently, say so
rather than inferring. It is acceptable — and expected — to leave gaps rather
than invent plausible-sounding details. If the user's premise contains an
error or questionable assumption, flag it constructively. Prioritize accuracy
over comprehensiveness.
```

Core principles: permit "I don't know," accept gaps, encourage pushback on flawed premises, accuracy over comprehensiveness.

#### 4e. Apply Output Gating (when applicable)

For skills that produce substantial outputs (documents, plans, reports, code files), embed output gating to prevent premature generation.

**Apply when:** Substantial text outputs requiring user review before finalization.
**Do not apply when:** Script-based operations, inline answers, or very short outputs.

Embed this pattern:

```markdown
## Output Protocol
**Default mode: Refinement**
Before producing final output, provide:
- Structural outline with section headers
- Key assumptions being made
- Questions only if answers would significantly change the output

**Do not produce the full output until user says `RELEASE ARTIFACT`.**
```

#### 4f. Apply Two-Step Prompting (when applicable)

For skills handling heavy outputs (>600 words) or ambiguous tasks, embed a plan-then-execute pattern.

**Apply when:** Heavy outputs or ambiguous tasks with multiple valid interpretations.
**Do not apply when:** Well-defined inputs/outputs, short outputs, deterministic operations.

The pattern: (1) **Plan** — present approach, assumptions, and material questions; (2) **Execute** — produce deliverable after user confirms.

**Ask only questions that materially change the output:**

| Bad (Trivial) | Good (Material) |
|---|---|
| "What format would you like?" | "Should I weight X risk higher than Y given the dependency you mentioned?" |
| "How long should this be?" | "Source A claims 20% but Source B says 12% — which is authoritative?" |
| "Do you want me to include risks?" | "Should I flag this exposure as a dealbreaker or acceptable?" |

Output gating and two-step prompting can co-exist: two-step handles planning, output gating handles release.

#### 4g. Include Required Sections

See the Required Sections Checklist below. Ensure each applicable section is present.

### Step 5: Validate

1. Run the Evaluate Workflow on the draft
2. Fix any Critical or Major issues before proceeding
3. If the body exceeds 500 lines, identify content to split into reference files before continuing
4. Run the Misinterpretation Check (see below) — close the top 2-3 plausible misreadings before declaring done
5. Test the skill on real tasks
6. Iterate: notice struggles, update SKILL.md or resources, test again

## Evaluate Workflow

### Step 1: Identify Resource Type and Inputs

Determine: Skill, prompt, or project instruction. If ambiguous, default to best-fit and note it.

Include when available: resource name, target platform, dependencies, intended runtime context. If the resource is too incomplete to evaluate meaningfully (e.g., only a title or a few bullet points), say so and recommend what to add before evaluation can proceed.

### Step 2: Apply Eight-Layer Evaluation

For each layer, ask four questions: (1) Present? (2) Complete? (3) Consistent with other layers? (4) Appropriate for this resource type?

| Layer | What It Checks | Key Weakness Signal |
|-------|---------------|---------------------|
| **Purpose** | Role and primary intent | Optimizes for wrong outcome; tries too many things |
| **Context Boundary** | Where model draws information | Invents data not in source material |
| **Interpretation** | Handling ambiguity in input | Misunderstands informal requests |
| **Reasoning Constraints** | Confidence calibration, bias counters | Over-helpful, falsely confident |
| **Decision** | Action principles, tiebreakers | Inconsistent judgment across similar cases |
| **Constraints** | Hard rules and boundaries | Violates intended limits |
| **Failure Behavior** | What to do when uncertain/blocked | Hallucinates rather than admitting uncertainty |
| **Output Contract** | Format and structure of output | Unpredictable response formats |

### Scoring

| Status | Meaning |
|--------|---------|
| ✓ Present | Explicit and testable |
| ⚠️ Weak | Implied or incomplete |
| ✗ Missing | Absent or unidentifiable |
| N/A | Does not apply (Interpretation for non-conversational; Decision for minimal prompts) |

**Severity flows from layer priority:**
- Critical-priority layer missing/weak → Critical issue
- Important-priority layer missing/weak → Major issue
- Optional-priority layer missing → Minor or no issue

### Single-Responsibility Check

Flag as Critical under Purpose when a resource tries to accomplish multiple unrelated goals, combines unrelated domains, or serves multiple audiences with conflicting needs. Exception: multi-phase workflows with clear phase boundaries.

### Step 3: Report

For the full evaluation framework including the priority matrix, type-specific criteria, and convention gate, read `references/evaluation-framework.md`. The subagent evaluation step in the pipeline commands uses that standalone reference file.

Condensed output format:

```
## Evaluation: [Resource Name]
Resource type: [Skill / Prompt / Project Instruction]

### Layer Coverage
| Layer | Status | Notes |
|-------|--------|-------|
[8 rows]

### Issues Found
**1. [Severity: Critical / Major / Minor]** — [Layer]
- Issue: [Description]
- Location: [Where]
- Fix: [Specific suggestion]

### Summary
Critical: [n] | Major: [n] | Minor: [n]
```

## Improve Workflow

Progress: [ ] Confirm [ ] Triage [ ] Propose [ ] Approve [ ] Iterate [ ] Quality check [ ] Deliver

### Inputs

1. **Existing resource** — the current skill, prompt, or project instructions
2. **Improvement suggestions** — bug reports, enhancement ideas, or behavioral fixes

If the existing resource is unparseable or incomplete, ask for a clean version.

### Step 1: Confirm Understanding

Restate what resource is being modified and what each suggestion asks for.

For vague or informal feedback, surface interpretations as hypotheses ("I think you're saying...") and confirm. If suggestions contradict each other, surface the conflict.

**Hard gate:** Wait for user confirmation before proceeding.

### Step 2: Triage Each Suggestion

| Check | Question | If Fails |
|-------|----------|----------|
| **Clarity** | Specific enough to act on? | Ask clarifying question |
| **Logic** | Solves a real problem? | Flag as dubious, propose alternative |
| **Compatibility** | Conflicts with existing behavior? | Flag contradiction, ask user to resolve |
| **Complexity** | Requires 2+ new sections or major restructuring? | Recommend new skill instead |

**Breaking change detection** — flag any change that:
- Alters output schema or required fields
- Removes or overrides a core constraint
- Renames required sections or headings
- Changes defaults that downstream resources depend on
- **Renames or removes a resource path** (command, doc, hook, skill, symlink, template) → before proposing it in Step 3, run the **Consumer-Inventory Gate** (see section below).

**Pushback calibration:** If a flagged suggestion is insisted upon after explanation, implement it but note the concern in the change summary.

### Step 3: Propose Changes

For each suggestion that passes triage:

```
**Change [#]:** [Short label]
- Location: [Exact section/heading]
- Current: "[Brief quote]"
- Proposed: "[New text]"
- Rationale: [Link to feedback]
- Unchanged: [What stays the same]
```

### Step 4: Approve and Implement

Wait for explicit approval. Implement only the approved subset. Preserve original structure unless a change specifically requires restructuring.

### Step 5: Iteration Suggestions

Generate 2-4 improvements identified during modification that the user did not request.

Rules:
- Must go beyond the original feedback
- Focus on issues surfaced by the modifications
- Include at least one targeting failure behavior or edge cases
- Stay within the resource's existing scope

Apply non-conflicting suggestions automatically; skip any that would modify or reverse a Step 4 change and note what was skipped and why. One additional round max.

### Step 6: Quality Check

Scan the modified resource for:

| Issue | Detection |
|-------|-----------|
| **Contradictions** | New instruction conflicts with existing? MUST/NEVER conflicts? |
| **Ambiguity** | Vague terms introduced without definitions? |
| **Regression** | Existing functionality still works? Each step has clear output? |
| **Scope bloat** | Resource exceeding its stated purpose? |

Then run the Misinterpretation Check (see below) on the changed sections.

If issues found: flag specifically, propose alternative, prompt user before finalizing.

### Step 7: Deliver

Present the change summary first. Wait for user confirmation before delivering the full updated resource.

### Complexity Threshold

Flag as "too complex for improvement" when implementing requires:
- Adding 2+ new sections
- Restructuring existing sections significantly
- Combining unrelated behaviors

If changes span 3+ sections significantly but don't require new sections, flag as "substantial refactor" and confirm modification is the right approach vs. creating a new skill.

## Consumer-Inventory Gate (rename/remove specs)

**Fires only when a spec renames or removes a resource path** (command, doc, hook, skill, symlink, template) — not on content-only edits. Complete this gate BEFORE the rename/remove spec is written. Skipping it has shipped half-finished renames (filename changed, a reader still on the old path → silent "not found"); this under-count has recurred 3+ times.

1. **Grep the invariant stem, never the templated form.** Search the bare filename stem (e.g. `session-plan`), not a placeholder spelling (`session-plan-${MARKER}`, `{MARKER}`, `$MARKER`) — placeholder variance hides consumers. Run `grep -rn '<stem>' .claude/ docs/ skills/ workflows/ templates/ CLAUDE.md`.
2. **Enumerate every match** into the spec's affected-file list, each classified: writer (emits the path) / exact-path reader (constructs the path — silent-break risk) / glob reader (matches `name-*` — safe unless the rename changes the stem the glob anchors on) / hook regex / doc reference / paired copy (lockstep edit required).
3. **Reconcile against the contract registry, both directions.** If the path has a two-end/contract registry (e.g. `docs/session-marker.md`), diff it against the grep result: add any consumer the grep found but the registry lacks, and re-classify any load-bearing runtime parser the registry misfiled as "narrative." The registry is authoritative only after this reconciliation.

The grep is mechanical; the inventory miss is consistent across authors. Close it here, before the spec is written — not at `/risk-check`, which is downstream of the cheap fix point.

## Misinterpretation Check

Before declaring a new or modified resource done, simulate a fresh-context executor reading it for the first time. The executor cannot ask clarifying questions — wording that ships is wording that fires.

For the resource (Create mode) or the changed sections (Improve mode), list the top 2-3 plausible misreadings:

- **Quote** the exact phrasing that produces each misreading.
- **Describe** what the executor would do under that misreading.
- **Propose** the minimum rewrite that closes the interpretation gap.

Apply the rewrites that close real failure modes; skip cosmetic ones. Skip the whole check for trivial artifacts (single-rule fix, one-line correction).

This catches authoring-time ambiguity before `/qc-pass` (post-edit) or `[AMBIGUOUS]` (consumption-time) — both downstream of the cheap fix point.

## Required Sections Checklist

For the full required-sections table (Known Pitfalls, Validation Loop, Runtime Recommendations, Examples, Failure Behavior, Bias Countering — what each is for and which resource types they apply to), read [`references/required-sections.md`](references/required-sections.md). These sections are the implementation mechanism for several evaluation layers (Failure Behavior, Output Contract, Reasoning Constraints).

## Writing Standards

For the full writing standards guide including degrees of freedom, anti-railroading, capability vs. preference skills, bias countering, skill composition, and the complete anti-patterns table, read `references/writing-standards.md`.

**Key principles** (always apply, no need to load the reference):
- Match specificity to fragility: high freedom for analysis, low freedom for migrations
- Explain *why* constraints matter — Claude works better with reasoning than rote rules
- Preference skills (encoding how you want work done) are more durable than capability skills (extending what the model can do)
- One skill, one job — don't mix unrelated responsibilities
- Don't teach Claude what it already knows

## Reference Files

Read these on demand. Do not load all references at the start of a session.

| File | Read When |
|------|-----------|
| `references/skill-architecture.md` | Designing a skill folder, restructuring an existing one, or deciding whether to add a sibling file. Contains folder structure, size budget, progressive disclosure rules, bundled resource types, and naming conventions. |
| `references/evaluation-framework.md` | Running a full evaluation, or the pipeline commands need to pass a standalone framework to a subagent. Contains the complete 8-layer definitions, priority matrix, type-specific criteria, convention gate, and combined output format. |
| `references/operational-frontmatter.md` | Configuring frontmatter fields beyond `name` and `description`. Contains the canonical mapping for the REQUIRED `model:` and `effort:` fields, plus the full table of optional fields (allowed-tools, paths, context, hooks, disable-model-invocation, and more). |
| `references/writing-standards.md` | Writing or reviewing SKILL.md body content. Contains degrees of freedom with examples, anti-railroading, capability vs. preference skills, bias countering, skill composition, and the full anti-patterns table. |
| `references/required-sections.md` | Verifying which sections a resource should include (Known Pitfalls, Validation Loop, Runtime Recommendations, Examples, Failure Behavior, Bias Countering) and which resource types each applies to. |
| `references/examples.md` | Needing calibration on what good output looks like for each mode. Contains condensed worked examples for Create, Evaluate, and Improve. |

All references link directly from this file. References do not link to other references.

## Runtime Recommendations

- **Create mode:** Expect to iterate. First pass produces a draft; run Evaluate on it before declaring done.
- **Evaluate mode:** Works best on complete drafts. Partial resources get partial evaluations — note what could not be assessed.
- **Improve mode:** Always work on a copy. Present the change summary before the full modified resource.
- **Context budget:** When operating on a resource with multiple reference files, prioritize loading SKILL.md and the most relevant reference rather than all references.
- **Tool access:** This skill requires write access (Create/Improve modes), so no `allowed-tools` restriction is applied.
- **Paths:** No `paths` restriction — this skill may be invoked from any directory context.

## Failure Behavior

- **Resource too incomplete to evaluate (Evaluate mode):** Say so. List what's missing before evaluation can proceed.
- **Improvement suggestions contradict each other (Improve mode):** Surface the conflict. Do not silently choose one.
- **Resource exceeds 500-line limit after changes:** Identify content to split into reference files before finalizing.
- **User's feedback is ambiguous (Improve mode):** Restate as a hypothesis ("I think you're saying...") and confirm before acting.
- **Resource type is ambiguous:** Default to best-fit and note the assumption.

## Validation

After completing any mode, run these checks:

- [ ] Does the output resource stay under the 500-line limit?
- [ ] Does the frontmatter front-load the first 250 characters with trigger phrases?
- [ ] Are all required sections present or explicitly marked N/A?
- [ ] Does the resource avoid the anti-patterns listed above?
- [ ] Has failure behavior been defined?
- [ ] If creating: self-evaluate using the condensed 8-layer check before delivering.
