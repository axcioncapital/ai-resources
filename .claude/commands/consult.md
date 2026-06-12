---
description: Consult the Axcíon AI System Owner — architectural judgment on systems-thinking questions or proposed repo changes.
model: opus
argument-hint: "<question or situation>"
---

<!-- DO NOT add `disable-model-invocation: true` here. /consult is auto-invoked by name from
     risk-check.md (Step 17b), resolve-incident.md, and pm.md (Fallback 5d) as a designed
     second-opinion step; the flag removes /consult from the model-invocable set and silently
     breaks all three. The spontaneous-firing concern it was meant to address is already
     covered by Step 0's read-first gate + the preamble line below. (Regression: added
     2026-05-29 in 51b69dc, reverted 2026-06-10.) -->

Consult the Axcíon AI System Owner on a structural question or a proposed repo change. Delegates to the `system-owner` agent (Opus); the agent reads the project's persona / grounding / toolkit-relationship references plus selected vault architectural reference docs and returns a grounded judgment in System Owner voice.

**For project-content questions grounded in a specific project's plan/decisions, use `/pm` instead — `/consult` is repo/workspace structure scoped.**

Input: `$ARGUMENTS` — free-text question or situation. Examples:

- `/consult I want to add a new /analyze-logs command — where should it live and what does it break?`
- `/consult How should I think about token efficiency when adding a new orchestration command?`
- `/consult Should the friday-checkup auto-fire from a Stop hook?`

**Reserve for genuinely contested or load-bearing system-shape questions, not for verification of already-confident recommendations.**

---

### Step 0 — Read-first gate

Before invoking `/consult`, answer:

(a) Have I already given a recommendation on this question?
(b) If yes, is there a single file (≤ 300 lines) whose contents would either confirm or refute it?

If both (a) and (b) are yes: do the Read first. Only proceed to `/consult` if the Read surfaces a genuine ambiguity or a load-bearing conflict that cannot be resolved from the file.

---

### Step 1 — Input validation

If `$ARGUMENTS` is empty, abort with:

```
/consult requires a question or situation.
Example: /consult Should I move /token-audit to fire from /friday-checkup?
```

Set `QUESTION` = `$ARGUMENTS` verbatim.

---

### Step 2 — Apply the change-shape detection rule

Read `ai-resources/docs/change-shape-classifier.md` for the canonical definition (categories + bias rules). Apply the routing rule below at this consumer:

If `QUESTION` matches the change-shaped definition in the classifier doc, set `SHAPE = change-shape` and proceed to Step 3 (read routing context). Otherwise, set `SHAPE = general` and skip to Step 4.

> **One-end contract** — the classifier is canonical in `docs/change-shape-classifier.md`. The `project-manager` agent reads the same doc at its Phase 3. Edit the categories there, not here. (Refactored 2026-05-29 from a two-end verbatim-copy contract; see classifier doc § Provenance.)

---

### Step 3 — Read routing context (change-shape only)

If `SHAPE = change-shape`:

1. Read `ai-resources/docs/repo-architecture.md` from disk. (This is the same source `/placement` reads. Per locked Decision 3 + Architecture Decision 4, the System Owner reads it in-line; the operator does not need to run `/placement` separately.)
2. Capture the routing baseline as `ROUTING_CONTEXT` — pass it through to the agent in Step 4.

If `SHAPE = general`, set `ROUTING_CONTEXT` = empty.

---

### Step 4 — Delegate to the `system-owner` agent

Spawn the `system-owner` subagent via the `Task` tool with this brief (verbatim structure):

```
You are the Axcíon AI System Owner. Apply Function {A or B} per references/grounding.md.

Function: {A — General consultation | B — Pre-change advisory}

Operator's question/situation:
{QUESTION verbatim}

{If SHAPE = change-shape, append:}
Routing context (read from ai-resources/docs/repo-architecture.md by /consult before delegation):
{ROUTING_CONTEXT verbatim}

Apply the procedure in your agent definition: read the three references + systems-building-principles.md, apply the per-function read map, and produce a response in System Owner voice. Cite specific principles / blueprint sections / risk-topology entries for each load-bearing recommendation. Apply the decline-when-ungrounded rule if grounding is insufficient.

Output contract: write the full advisory to projects/axcion-ai-system-owner/output/consultations/consult-{DATE}-{SLUG}.md per your agent definition's Phase 5 output contract, then return a ≤30-line structured summary. First line of the summary must be the verbatim path-back line `**Full advisory on disk:** {path}`, followed by a blank line, then the summary body.
```

Wait for the agent's response.

---

### Step 5 — Verify the advisory file, then return the agent's response unmodified

**5a — Post-return existence check.** Parse the path from the agent's first line (`**Full advisory on disk:** {path}`). Check that the file actually exists at that path (e.g., `ls {path}`). The path-back line is a model claim, not a verified artifact — on 2026-06-10 the agent returned it three times in one session with no file written, silently losing the architectural audit trail.

- **File exists** → proceed to 5b.
- **File missing** → persist the agent's returned summary verbatim to that path, prefixed with a one-line provenance header: `> Recovered by /consult Step 5a — the system-owner agent returned this summary but did not write its full advisory; only the summary below was received. {DATE}`. Persist ONLY what the agent actually returned — never synthesize or expand the full advisory it didn't deliver. Note the repair in one chat line: `Note: SO advisory file was missing — returned summary persisted to {path}.`

**5b — Return the response.** Output the agent's response verbatim to the operator. Do NOT add a preamble, do NOT summarize, do NOT add an "I hope this helps" closing. The agent's voice is the System Owner voice; wrapping it in command-shell prose dilutes it.

---

