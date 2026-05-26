---
model: opus
effort: high
argument-hint: "[session intent — or leave blank to use next steps from last session]"
---

Session orchestrator. Run after `/prime` to plan HOW the session will run before execution starts. Produces a written plan at `logs/session-plan.md` (overwrite each session). Not to be confused with the research-workflow's per-section `session-plan.md` under `workflows/research-workflow/`.

---

## Step 0 — Confirm `/prime` ran this session, and detect concurrent-session collisions

Read `logs/session-notes.md`. Look for a `## {YYYY-MM-DD}` header matching today's date (the entry `/prime` appends when the operator names the work).

- If not found: tell the operator "Run `/prime` first to orient the session, then return to `/session-plan`." Stop. Do not proceed.

- If found: check whether `logs/session-plan.md` exists AND was last modified within the past 6 hours (use `stat -f %m` on macOS, `stat -c %Y` on Linux, or `date -r`). If no: proceed to Step 1.

  If yes, perform intent-comparison conflict detection:

  1. **Determine `UPCOMING_INTENT`** for this invocation (preview of Step 1; cache and reuse there):
     - If `$ARGUMENTS` is non-empty → `UPCOMING_INTENT` = `$ARGUMENTS` verbatim.
     - Else → read `logs/session-notes.md`, locate the last `## ` entry, scan forward for `### Next Steps`. Use the first bullet → `UPCOMING_INTENT`.
     - If neither resolves (file missing, no Next Steps subsection, blank) → set `UPCOMING_INTENT` = sentinel `(none derived)`.
  2. **Read `EXISTING_INTENT`** from the existing `logs/session-plan.md`'s `## Intent` line. If no `## Intent` line is present (malformed plan), set `EXISTING_INTENT` = sentinel `(none derived — existing plan malformed)` — the sentinel guard in sub-step 4 will fall through to the MATCH branch.
  3. **Normalization contract** (pinned inline — do not infer from behavior): lowercase both strings, trim leading/trailing whitespace, strip trailing punctuation `.,;:!?`. Nothing else (no stop-word removal, no token-overlap heuristics).
  4. **Sentinel guard:** if either normalized string starts with `(none derived` → SKIP comparison, fall through to the MATCH branch (3-option prompt). Sentinels are too ambiguous to auto-route to pass2; loud-failure-over-silent-continuation applies.
  5. **Match contract:** case-insensitive substring containment in either direction. `EXISTING_INTENT` contains `UPCOMING_INTENT`, OR `UPCOMING_INTENT` contains `EXISTING_INTENT` → MATCH. (Asymmetry note: a scope-expanded second invocation — e.g., "fix X" vs "fix X and add Y" — counts as MATCH by design; the operator's mental model is "same work, broader scope.")
  6. **Apply the result:**

     **MATCH → same-session re-invocation.** Emit the existing 3-option prompt:

     > `session-plan.md` already exists from this session (modified {HH:MM}, intent: '{Intent value}'). Options:
     > 1. Keep current plan — stop here, no changes made
     > 2. Overwrite with new intent — continue to Step 1
     > 3. Write new plan to `logs/session-plan-pass2.md` instead — continue to Step 1, output to pass2
     >
     > Note: `logs/session-plan-next.md` is a separate file written by `/monday-prep` for cross-session handoffs and is not the same as `session-plan-pass2.md`.
     >
     > Default (no response within the turn): **option 1 — keep current plan**.

     Apply the chosen option: Option 1 → stop, no changes. Option 2 → continue to Step 1 (output target = `logs/session-plan.md`). Option 3 → continue to Step 1 (output target = `logs/session-plan-pass2.md`).

     **MISMATCH → concurrent-session collision detected.** Auto-default to pass2 without prompting. Emit one notification line:

     > Concurrent session detected. Existing intent: '{EXISTING_INTENT_truncated_60}'. This session's intent: '{UPCOMING_INTENT_truncated_60}'. Writing new plan to `logs/session-plan-pass2.md` to avoid collision (preserves both). To overwrite `session-plan.md` instead, re-run `/session-plan` after the other session wraps.

     Set output target = `logs/session-plan-pass2.md` and continue to Step 1.

  In every path that continues to Step 1, pass `UPCOMING_INTENT` forward — Step 1 reuses it instead of re-deriving.

  Known-debt note: `/drift-check` currently reads `logs/session-plan.md`, not pass2. When the auto-pass2 branch fires, `/drift-check` will use the prior session's plan as mandate baseline — possible false ALIGNED verdict. Tracked in `logs/maintenance-observations.md` for a future `/drift-check` Step 3 enhancement.

---

## Step 1 — Determine session intent

**Cache shortcut:** if Step 0 already set `UPCOMING_INTENT` (intent-comparison conflict detection ran), reuse it: set `INTENT` = `UPCOMING_INTENT` and skip the sub-step 1 derivation logic below. Then:
- If `$ARGUMENTS` was non-empty → proceed directly to Step 2.
- If `$ARGUMENTS` was empty → run sub-steps 2 and 3 (display the inferred intent with source freshness, then ask the operator to confirm or restate). Do not skip the display — the operator must see what they're confirming.

Otherwise (Step 0 did not cache — e.g., no prior plan within 6 hours):

If `$ARGUMENTS` is non-empty, set `INTENT` = `$ARGUMENTS` verbatim. Proceed to Step 2.

If `$ARGUMENTS` is empty:

1. Read `logs/session-notes.md`. Locate the last entry by scanning from end of file backward for the last `## ` header line. Within that block, scan forward for `### Next Steps`. Use the first bullet in that subsection as `INTENT`.

   Edge cases:
   - File missing or empty → set `INTENT` = `(none derived — file missing or empty)`
   - No `### Next Steps` subsection in last entry → set `INTENT` = `(none derived — no next steps in last entry)`
   - Subsection is empty or contains only "None" → set `INTENT` = `(none derived — next steps blank)`
   - If `INTENT` resolves to `(none derived)`: ask the operator "What are we working on today?" and wait. Do not proceed to Step 2 with the sentinel.

2. Read the last-modified timestamp of `logs/session-notes.md` (use `stat` or equivalent). Display the inferred intent with its source freshness:

   > **Inferred intent** (from `logs/session-notes.md`, last updated {YYYY-MM-DD HH:MM}): {INTENT}

3. Ask the operator one question and **wait**:

   > Confirm, or state a different intent.

   Accept the first response. If corrected, update `INTENT` to the operator's stated text. Do not loop.

---

## Step 1.5 — Classify session

Ask the operator one question and **wait**:

> Is this session **design** (creating or drafting something new — a skill, command, plan, brief, agent definition), **execution** (running or applying something that already exists — an audit, triage, research stage, edits from a clear plan), or **mixed**?
>
> Default if unsure: **design**.

Set `CLASS` = the operator's answer (`design`, `execution`, or `mixed`). If mixed, note which class dominates in parentheses.

If the response does not match one of the three canonical values exactly (case-insensitive), normalize by mapping to the closest canonical value (e.g., "Design" → `design`, "design session" → `design`, "exec" → `execution`). If no clear match, re-ask once with the three options listed explicitly. Do not loop.

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

**Compaction discipline:** for long-running sessions, see `ai-resources/docs/compaction-protocol.md` § Named checkpoints for the four state-saving points (post-inspection, post-implementation, post-QC, pre-closeout) and what to write to disk at each.

---

## Step 6 — Risk pointer

If `INTENT` suggests the work may touch a structural change class (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, automation with shared-state effects — full class list: `ai-resources/docs/audit-discipline.md`):

Emit: "Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate)."

If no structural class appears likely: state "No structural change classes apparent — run `/risk-check` if scope changes."

**Tripwire:** any edit that *reorders* operations against shared state (logs, session files, cross-session artifacts) qualifies as automation-with-shared-state-effects — even when the command being edited already exists. The "existing-command refactor" framing does NOT exempt the change from `/risk-check`.

Do not evaluate structural risk yourself. Point to `/risk-check`.

---

## Step 7 — Write the plan file

Set `DATE` = today in `YYYY-MM-DD` format.

**Resolve `OUTPUT_TARGET`** (set by Step 0):
- Default → `logs/session-plan.md`.
- If Step 0's MATCH branch fired with Option 3 selected (operator picked pass2) → `logs/session-plan-pass2.md`.
- If Step 0's MISMATCH branch fired (auto-pass2 on concurrent-session collision) → `logs/session-plan-pass2.md`.

**Precondition:** If `INTENT` references a separate report, spec, or drift file (e.g., "apply findings from audit-X.md", "execute the drift-fix plan"), the `## Findings / Items to Address` section below MUST inline a one-line summary of each item with a source-doc anchor. A bare link to the file is invalid — the plan must be readable without opening the referenced doc.

Write to `OUTPUT_TARGET` (overwrite if present):

```markdown
# Session Plan — {DATE}

## Intent
{INTENT — one sentence}

## Class
{design | execution | mixed}

## Model
{recommended tier} — {match | → /model {shortname}}

## Source Material
{bulleted list of absolute paths, or "(none identified)"}

## Findings / Items to Address
{numbered list — one line per item with source-doc anchor, or "(none — intent does not reference a prior report)"}

## Execution Sequence
{numbered steps with per-item verification criteria, or "(single step — no sequencing required)"}

## Scope Alternatives
{min / recommended / max scope options, or "Single scope — no alternatives"}

## Autonomy Posture
{Full autonomy | Gated | Operator-in-the-loop}

**Stop points:**
{bulleted list or "None"}

## Risk
{risk-check pointer, or "No structural change classes apparent — run /risk-check if scope changes."}
```

**Self-check before writing.** A plan is a self-contained execution brief, not a pointer to other docs. The draft must pass ALL of the following before write — if any fails, expand the relevant section first:

1. **Length floor:** at least 25 lines of substantive content (excluding the schema headers).
2. **Findings/Items concreteness:** `## Findings / Items to Address` must contain a numbered list with one inline summary per item AND a source-doc anchor where applicable. Reject placeholders that read as "see audit-X.md" or "apply findings from Y" — those are bare links, not summaries. The placeholder `(none — intent does not reference a prior report)` is acceptable ONLY for sessions whose `INTENT` does not reference any prior artifact.
3. **Execution Sequence concreteness:** `## Execution Sequence` must contain numbered steps with per-step verification criteria when the work has discrete stages. The placeholder `(single step — no sequencing required)` is acceptable ONLY for genuinely single-step work (e.g., one targeted edit). Multi-wave or multi-file sessions MUST enumerate steps.
4. **Scope Alternatives realism:** `## Scope Alternatives` declares min / recommended / max only when multiple execution depths are genuinely on the table (e.g., context-gated stretch waves, optional stages). `Single scope — no alternatives` is acceptable when the intent has no degrees of freedom. Do not invent alternatives for a fixed-scope session.

A plan that cannot be understood without opening a separate doc fails this check. A plan that uses `(single step)` or `(single scope)` for non-trivial multi-step work also fails.

After writing `OUTPUT_TARGET`, locate today's `## {YYYY-MM-DD}` header in `logs/session-notes.md` (the entry `/prime` created in Step 0). Check whether a `Class: ` line already exists immediately below that header. If it does, replace its value with `Class: {CLASS}` using `Edit`. If it does not exist, insert `Class: {CLASS}` as a new line immediately below the header, before any existing content. The line should be in plain text form (not a heading, not a bullet) so downstream rules can grep for `^Class: ` reliably.

Step 0 has already verified today's entry exists; if for any reason the header is missing at this point, skip the append and emit a one-line warning to the operator.

---

## Step 8 — QC trigger

After writing, notify the operator:

> Plan written to `logs/session-plan.md`. Run `/qc-pass` to review it, then proceed.

Do not invoke `/qc-pass` automatically.

$ARGUMENTS
