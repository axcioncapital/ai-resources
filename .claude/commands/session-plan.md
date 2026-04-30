---
model: opus
effort: high
argument-hint: "[session intent — or leave blank to use next steps from last session]"
---

Session orchestrator. Run after `/prime` to plan HOW the session will run before execution starts. Produces a written plan at `logs/session-plan.md` (overwrite each session). Not to be confused with the research-workflow's per-section `session-plan.md` under `workflows/research-workflow/`.

---

## Step 0 — Confirm `/prime` ran this session

Read `logs/session-notes.md`. Look for a `## {YYYY-MM-DD}` header matching today's date (the entry `/prime` appends when the operator names the work).

- If found: proceed to Step 1.
- If not found: tell the operator "Run `/prime` first to orient the session, then return to `/session-plan`." Stop. Do not proceed.

---

## Step 1 — Determine session intent

If `$ARGUMENTS` is non-empty, set `INTENT` = `$ARGUMENTS` verbatim. Proceed to Step 2.

If `$ARGUMENTS` is empty:

1. Read `logs/session-notes.md`. Locate the last entry by scanning from end of file backward for the last `## ` header line. Within that block, scan forward for `### Next Steps`. Use the first bullet in that subsection as `INTENT`.

   Edge cases:
   - File missing or empty → set `INTENT` = `(none derived — file missing or empty)`
   - No `### Next Steps` subsection in last entry → set `INTENT` = `(none derived — no next steps in last entry)`
   - Subsection is empty or contains only "None" → set `INTENT` = `(none derived — next steps blank)`
   - If `INTENT` resolves to `(none derived)`: ask the operator "What are we working on today?" and wait. Do not proceed to Step 2 with the sentinel.

2. Display the inferred intent:

   > **Inferred intent:** {INTENT}

3. Ask the operator one question and **wait**:

   > Confirm, or state a different intent.

   Accept the first response. If corrected, update `INTENT` to the operator's stated text. Do not loop.

---

## Step 2 — Model selection

Apply the three-tier heuristic from `ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md`:

> *"Is the hard part deciding, or doing?"*
> - **Deciding** (synthesis, design, triage, architectural review, judgment under ambiguity) → `opus`
> - **Doing** (executing a defined process: scaffolding, log appends, spec-following, mechanical edits) → `sonnet`
> - **Mechanical** (counts, format checks, pattern matching) → `haiku`

Map `INTENT` to one tier. Set `RECOMMENDED_MODEL`.

Read `ACTIVE_MODEL` from the system-prompt context (the model identifier already in context, e.g., `claude-sonnet-4-6[1m]`). Do not run any external command. Compare against the **active session model only** — not the project default. (`/prime` Step 4b handles project-default alignment; this step checks task-requirement fit.)

- If `RECOMMENDED_MODEL` tier matches `ACTIVE_MODEL` tier: note `match`.
- If mismatch: emit one line `→ /model {shortname}` (e.g., `→ /model opus`). No confirmation prompt.

---

## Step 3 — Source material

Based on `INTENT`, list files, skills, and docs to load for the session. Verify path existence via `Read` head-of-file or a single `ls` call before listing — do not list phantom paths.

- If work involves an existing skill: `ai-resources/skills/<name>/SKILL.md`
- If work involves a command: `ai-resources/.claude/commands/<name>.md`
- If work involves an agent: `ai-resources/.claude/agents/<name>.md`
- If work touches structural change classes: `ai-resources/docs/audit-discipline.md`
- If work involves repo placement: `ai-resources/docs/repo-architecture.md`
- If work involves model/effort selection for a new resource: `ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md`
- If work involves permissions: `ai-resources/docs/permission-template.md`
- If intent is too broad to identify specific material: note `(none identified — intent too broad)`

Produce a bulleted list of absolute paths.

---

## Step 4 — Resolve reminder (conditional)

Check conversation context for recent QC findings (a `/qc-pass` result with unresolved findings in this session).

- If QC findings are present in context: emit "Invoke `/resolve` to address the QC findings before proceeding."
- If no QC findings in context: omit this step entirely.

---

## Step 5 — Autonomy posture

Based on `INTENT` and the source material in Step 3, recommend one posture:

**Full autonomy** — proceed to wrap without operator pause. Use when:
- Work is additive and clearly scoped
- No structural change classes likely (see Step 6)
- Exit condition is unambiguous

**Gated** — pause at named decision points. Use when:
- Work involves judgment calls at identifiable junctures
- Iterative drafting with operator review gates
- One or more structural classes touched but scope is bounded

**Operator-in-the-loop** — pause before each major change. Use when:
- Work spans multiple structural classes
- Cross-cutting CLAUDE.md edits or new always-loaded content
- Broad scope with high drift risk

Name specific stop points (or state "None").

---

## Step 6 — Risk pointer

If `INTENT` suggests the work may touch a structural change class (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, automation with shared-state effects — full class list: `ai-resources/docs/audit-discipline.md`):

Emit: "Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate)."

If no structural class appears likely: state "No structural change classes apparent — run `/risk-check` if scope changes."

Do not evaluate structural risk yourself. Point to `/risk-check`.

---

## Step 7 — Write the plan file

Set `DATE` = today in `YYYY-MM-DD` format.

Write to `logs/session-plan.md` (overwrite if present):

```markdown
# Session Plan — {DATE}

## Intent
{INTENT — one sentence}

## Model
{recommended tier} — {match | → /model {shortname}}

## Source Material
{bulleted list of absolute paths, or "(none identified)"}

## Autonomy Posture
{Full autonomy | Gated | Operator-in-the-loop}

**Stop points:**
{bulleted list or "None"}

## Risk
{risk-check pointer, or "No structural change classes apparent — run /risk-check if scope changes."}
```

---

## Step 8 — QC trigger

After writing, notify the operator:

> Plan written to `logs/session-plan.md`. Run `/qc-pass` to review it, then proceed.

Do not invoke `/qc-pass` automatically.

$ARGUMENTS
