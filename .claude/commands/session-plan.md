---
model: opus
effort: high
argument-hint: "[session intent — or leave blank to use next steps from last session]"
---

Session orchestrator. Run after `/prime` to plan HOW the session will run before execution starts. Produces a written plan at `logs/session-plan-${YYYY-MM-DD}-${MARKER}.md` (date + marker-scoped per `docs/session-marker.md`; overwrite each same-session re-invocation). Not to be confused with the research-workflow's per-section `session-plan.md` under `workflows/research-workflow/`.

---

## Step 0 — Confirm `/prime` ran this session, resolve marker, check for same-session re-invocation

**Leading-token normalization — run this FIRST, before anything reads `$ARGUMENTS`.** Callers may prefix the intent with zero or more literal `{key:value}` tokens. Strip leading tokens in a loop until the remaining text begins with something else, capturing each:

- `{gate:post-plan}` → set `POST_PLAN_GATE = true`. The invoking branch has declared that it will hold an approval gate after this command finishes. Consumed by Step 8.
- Any other `{key:value}` token → strip and ignore (forward-compatible; an unrecognized token must never reach `INTENT`).

If no leading token is present, `POST_PLAN_GATE` is unset — **this is the common case and the default**, and it reproduces this command's pre-2026-07-18 behaviour exactly.

**Everywhere below, `$ARGUMENTS` denotes the stripped remainder, never the raw argument string.** This normalization must precede the `UPCOMING_INTENT` assignment further down this step: that assignment caches `$ARGUMENTS` *verbatim*, so a token stripped only at Step 1 would already have leaked into `UPCOMING_INTENT` and from there into the plan file's `## Intent` line. (Caught by `/risk-check`, 2026-07-18 — the first design of this change stripped at Step 1 and had exactly that hole.)

Read `logs/session-notes.md`. Resolve this session's marker via `docs/session-marker.md` § Marker resolution (per-session-id oracle first, loud fallback to the shared file). If `MARKER` is empty (absent or stale), hard-fail per the uniform writer contract: `[/session-plan Step 0] HARD-FAIL: session marker unresolved (logs/.session-marker-${CLAUDE_CODE_SESSION_ID} and shared logs/.session-marker both absent or stale). Run /prime to populate the marker for this session, then retry.`

Locate the marker-bearing header `## YYYY-MM-DD — Session ${MARKER}` in `session-notes.md`. If absent, hard-fail: `[/session-plan Step 0] HARD-FAIL: this session's marker-bearing header missing from logs/session-notes.md. Run /prime to seed the header.`

Set `TODAY` = today in `YYYY-MM-DD` format (`date '+%Y-%m-%d'` or the date prefix of the marker-bearing header). All plan file paths below use `${TODAY}-${MARKER}` as the filename stem.

**Same-session re-invocation check.** Check whether `logs/session-plan-${TODAY}-${MARKER}.md` exists. If yes, this is THIS session's prior plan (no other session writes to this path under TOCTOU Phase 2+3 atomic — each session writes its own marker-scoped plan). Emit the 3-option prompt:

> `session-plan-${TODAY}-${MARKER}.md` already exists from this session (modified {HH:MM}, intent: '{Intent value}'). Options:
> 1. Keep current plan — stop here, no changes made
> 2. Overwrite with new intent — continue to Step 1
> 3. Write new plan to `logs/session-plan-${TODAY}-${MARKER}-pass2.md` instead — continue to Step 1, output to pass2
>
> Default (no response within the turn): **option 1 — keep current plan**.

Apply the chosen option: Option 1 → stop, no changes. Option 2 → continue to Step 1 (OUTPUT_TARGET = `logs/session-plan-${TODAY}-${MARKER}.md`). Option 3 → continue to Step 1 (OUTPUT_TARGET = `logs/session-plan-${TODAY}-${MARKER}-pass2.md`).

**Determine `UPCOMING_INTENT`** for Step 1 caching:
- If `$ARGUMENTS` is non-empty → `UPCOMING_INTENT` = `$ARGUMENTS` verbatim.
- Else → within this session's marker-bearing header in `session-notes.md`, scan forward for `### Next Steps`. Use the first bullet → `UPCOMING_INTENT`.
- If neither resolves → set `UPCOMING_INTENT` = sentinel `(none derived)`. Step 1 handles the sentinel via re-ask.

Pass `UPCOMING_INTENT` and `OUTPUT_TARGET` forward to Step 1.

Removed in atomic Phase 2+3 (Option A): the intent-comparison, sentinel guard, normalization contract, MATCH/MISMATCH branches, wrap-state check, auto-pass2 routing, and the 6-hour mtime window. Per-session marker scoping eliminates the shared-file race that those mechanisms detected.

---

## Step 1 — Determine session intent

**Cache shortcut:** Step 0 always sets `UPCOMING_INTENT` as a forward-pass to Step 1 (TOCTOU Phase 2+3 atomic — same-session re-invocation check completes; UPCOMING_INTENT is computed regardless of branch). If `UPCOMING_INTENT` is a non-sentinel value, reuse it: set `INTENT` = `UPCOMING_INTENT` and skip the sub-step 1 derivation logic below. Then:
- If `$ARGUMENTS` was non-empty → proceed directly to Step 2.
- If `$ARGUMENTS` was empty → run sub-steps 2 and 3 (display the inferred intent with source freshness, then ask the operator to confirm or restate). Do not skip the display — the operator must see what they're confirming.

**If `UPCOMING_INTENT` is the sentinel `(none derived)`** (e.g., `$ARGUMENTS` empty AND no `### Next Steps` in this session's marker-bearing block), fall through to the manual-derivation block below:

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

## Step 2 — Model selection

Apply the three-tier heuristic from `ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md`:

> *"Is the hard part deciding, or doing?"*
> - **Deciding** (synthesis, design, triage, architectural review, judgment under ambiguity) → `opus`
> - **Doing** (executing a defined process: scaffolding, log appends, spec-following, mechanical edits) → `sonnet`
> - **Mechanical** (counts, format checks, pattern matching) → `haiku`

Map `INTENT` to one tier. Set `RECOMMENDED_MODEL`.

Read `ACTIVE_MODEL` from the system-prompt context (the model identifier already in context). Do not run any external command. Compare against the **active session model only**. (`/prime` Step 4's model-alignment check compares the session model against the project's *recommended posture*, where one is declared; this step checks task-requirement fit. Note there is no such thing as a project model *default* — defaults are prohibited at every layer per workspace `CLAUDE.md` § Model Tier.)

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

**Environment-fit check (launch/runtime-gated tooling only):** if the planned work product is an executable or launcher whose value depends on *how the operator triggers it* (terminal script, shell alias, `.zshrc` function, OS entrypoint), confirm the trigger environment fits before the plan is approved. Known baseline: the operator launches Claude Code via the **VS Code extension** (opens a folder/window), not a terminal — terminal-only tooling ships inert (real incident 2026-06-10 S3: `cc-worktree.sh` terminal launcher built through the full gate chain, zero functional value). If the planned artifact assumes a terminal launch, flag the mismatch in the plan's Risk section and prefer a VS Code-native or in-session slash-command shape. Skip this check entirely for non-executable work (docs, commands, skills, analyses).

Do not evaluate structural risk yourself. Point to `/risk-check`.

---

## Step 7 — Write the plan file

Set `DATE` = today in `YYYY-MM-DD` format.

**Resolve `OUTPUT_TARGET`** (set by Step 0):
- Default → `logs/session-plan-${DATE}-${MARKER}.md`.
- If Step 0's same-session 3-option prompt resolved to Option 3 → `logs/session-plan-${DATE}-${MARKER}-pass2.md`.

No legacy or bare-path fallback. The marker is mandatory under TOCTOU Phase 2+3 atomic (Option A); Step 0's hard-fail closes the absent-marker path before this step is reached. See `docs/session-marker.md` for the marker contract.

**Precondition:** If `INTENT` references a separate report, spec, or drift file (e.g., "apply findings from audit-X.md", "execute the drift-fix plan"), the `## Findings / Items to Address` section below MUST inline a one-line summary of each item with a source-doc anchor. A bare link to the file is invalid — the plan must be readable without opening the referenced doc.

Write to `OUTPUT_TARGET` (overwrite if present):

```markdown
# Session Plan — {DATE}

## Intent
{INTENT — one sentence}

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

No `Class:` line is written to `logs/session-notes.md` — the field was removed when the design/execution/mixed gate was eliminated.

---

## Step 8 — Confirm, then either hand back to a caller-declared gate or auto-proceed

**Branch on `POST_PLAN_GATE` (set by Step 0's leading-token normalization).**

**If `POST_PLAN_GATE` is set** — the invoking branch declared a post-plan approval gate. Emit:

> Plan ready — review `{OUTPUT_TARGET}`. Reply `go` to start execution, or run `/qc-pass` on the plan first.

Then **stop and wait for the operator. Do NOT begin execution.** The gate belongs to the caller; this command's job ends at the plan write. Today the only caller that sets this is `/prime` 8a (numbered-menu task selection), whose Step 8a.d owns the pause — see the note below for why it cannot be left to recall.

**If `POST_PLAN_GATE` is unset** (the default — free-text intent via `/prime` 8b, a direct `/session-plan` invocation, or `/session-start` invoked outside a gated branch), emit:

> Plan written to `{OUTPUT_TARGET}` ({autonomy posture}). Begin execution.

Do NOT emit a `/qc-pass` handoff and do NOT pause for operator confirmation. The session begins under the declared autonomy posture immediately. The operator can run `/qc-pass`, `/contract-check`, or `/drift-check` at any time on their own initiative — and `/session-plan` Step 0's collision-detection prompts plus Step 1's `(none derived)` sentinels remain the only *self-imposed* gates that pause this command. Everything else flows through.

> **Why this is a token and not a sentence telling you to remember `/prime` 8a.d.** This command is chain-invoked, so Step 8 is the *most recently loaded* instruction at the decision point, while the caller's pause was loaded many turns earlier and may sit behind intervening tool output. When those two conflict, the recency-favoured reading wins — and before 2026-07-18 the recency-favoured reading was "begin execution", i.e. execute a plan the operator has never seen. The token makes the caller's gate a fact present in *this* step's own inputs rather than something the reader has to recall. **Do not "simplify" this back into an unconditional instruction, and do not resolve a future conflict here by weakening `/prime` 8a's pause** — the 8a/8b split is deliberate: a numbered menu pick is not the operator stating the work, so it gets an approval gate that free-text intent does not. Source: `logs/improvement-log.md` 2026-07-18.

**Manual-QC opt-in:** if the operator wants a plan-time QC sweep before execution, they invoke `/qc-pass` directly. The chained-from-`/session-start` default skips this — judgment errors are caught downstream by `/drift-check` mid-session and `/contract-check` near wrap, per workspace `Decision-Point Posture`.

$ARGUMENTS
