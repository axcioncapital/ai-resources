---
description: Analyse the workspace through a systems-thinking lens and write a structured report to disk
model: opus
---

Analyse the workspace through a systems-thinking lens — diagnosing feedback-loop health, binding constraints, delays, and highest-leverage intervention points — and write a structured report the operator can act on in a separate session.

**When to use this vs. `/architecture-review`:** Use `/systems-review` when you want a systems-dynamics diagnosis (feedback loops, constraints, delays, leverage points) regardless of whether audit artifacts exist on disk. Use `/architecture-review` when you have existing audit outputs (repo-health reports, token-audit reports) to synthesise into an architectural-health assessment. The two commands use different inputs and different analytical lenses; they are complementary, not redundant.

**When to use this vs. `/consult`:** Use `/consult` for a targeted architectural question or pre-change advisory. Use `/systems-review` for a structured systems-level scan that produces a report.

## Step 1 — Scope gate

Read `$ARGUMENTS`.

If `$ARGUMENTS` is empty, output the following and halt — do not proceed to Step 2:

```
/systems-review requires a scope. Specify what to analyse:

  1. Full AI infrastructure — skills, commands, agents, CLAUDE.md, settings, and operational
     cadences (Friday cadence, QC loop, innovation pipeline).
  2. A specific project — name the project (e.g., "axcion-ai-system-owner").
  3. A specific subsystem — name it (e.g., "QC loop", "Friday cadence", "skill library").

Re-run: /systems-review <scope description>
```

If `$ARGUMENTS` is non-empty, set SCOPE = `$ARGUMENTS` and proceed to Step 2.

## Step 2 — Verify systems-thinking reference

Read the file at:

```
projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md
```

If the file is missing, halt with:

```
/systems-review: systems-thinking reference not found.
Expected: projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md
Check that the vault is present and the file has not been moved.
```

## Step 3 — Delegate to the system-owner agent (Function E)

Set TODAY = today's date in `YYYY-MM-DD` format.

Derive SCOPE_SLUG from SCOPE: lowercase, replace spaces and non-alphanumeric characters with hyphens, truncate to 30 characters.

Set OUTPUT_PATH = `projects/axcion-ai-system-owner/output/systems-reviews/systems-review-{TODAY}-{SCOPE_SLUG}.md`.

Spawn the `system-owner` subagent via the `Task` tool with this verbatim brief:

---

**Function E — Systems review**

**Scope:** {SCOPE}

**Output path:** {OUTPUT_PATH}

**Systems-thinking reference:** `projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md`

Apply your standard Phase 1–5 procedure. This is a Function E invocation. Follow the Function E read map in `references/grounding.md` § 2 and the Function E output shape in your Phase 5 instructions. Write the full report to the output path using your `Write` tool, then echo the "Binding Constraint" and "Leverage Point Assessment" sections to chat.

---

## Step 4 — Return the agent's response

Return the agent's echoed output unmodified. Do not summarize or wrap it. The full report is on disk at OUTPUT_PATH.
