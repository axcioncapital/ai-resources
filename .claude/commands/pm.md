---
description: Consult the Axcíon AI Project Manager — project-content advisory grounded in the active project's constitution docs. Pairs with /consult (which handles repo/workspace structure).
model: opus
---

Consult the Axcíon AI Project Manager on a mid-session question grounded in the active project's constitution docs (project `CLAUDE.md`, plan, context-pack, decisions, architecture). Delegates to the `project-manager` agent (Opus); the agent reads the project's constitution docs, classifies the question, optionally escalates to `system-owner` for general structure questions, and returns a three-part ruling (Verdict, Reasoning with citations, Recommended action) in chat.

**For repo/workspace structure questions, use `/consult` instead — `/pm` is project-content scoped.**

Two question shapes:

- **Retrospective** — "is X consistent with the plan?", "what does decision 5 imply for Phase 2?"
- **Forward-looking** — "propose a mandate for this session", "what should the next session focus on?", "suggest a session plan for completing W1"

Input: `$ARGUMENTS` — free-text question, or empty (in which case `/pm` reads the most recent inline conversation). Examples:

- `/pm` (no args — reads recent inline conversation to identify the open question)
- `/pm "Should W2 source enrichment data from Perplexity or GPT-5?"` (retrospective)
- `/pm "Propose a mandate for this session."` (forward-looking — mandate generation)
- `/pm "What should I focus on next given W0 is complete?"` (forward-looking — next-step)
- `/pm "Suggest a session plan for completing W1 Phase 2."` (forward-looking — session plan)
- `/pm "Use docs/spec.md as the plan. Does the spec allow Phase 3 to use synthetic data?"` (steering — token ending in `.md` overrides constitution-doc discovery for the plan slot)

**Reserve for genuinely contested or load-bearing project-content questions, not for verification of already-confident recommendations.**

---

### Step 0 — Read-first gate

Before invoking `/pm`, answer:

(a) Have I already given a recommendation on this question?
(b) If yes, is there a single file (≤ 300 lines) whose contents would either confirm or refute it?

If both (a) and (b) are yes: do the Read first. Only proceed to `/pm` if the Read surfaces a genuine ambiguity or a load-bearing conflict that cannot be resolved from the file.

---

### Step 1 — Identify the open question

If `$ARGUMENTS` is **non-empty**:
- Set `OPEN_QUESTION` = `$ARGUMENTS` verbatim.
- Set `OPTIONAL_STEERING` = `$ARGUMENTS` (same field at v1 — the argument carries both the question and any steering tokens such as `Use X.md as the plan`).

If `$ARGUMENTS` is **empty**:
- Scan the ~30 most recent turns of the conversation for an explicit operator question, an unresolved `[AMBIGUOUS]` flag, or a load-bearing decision the main session was about to make on the fly without grounding.
- Restate the identified question in one sentence and set that as `OPEN_QUESTION`. Set `OPTIONAL_STEERING` = empty.
- **State the restatement in chat before invoking the agent**, so the operator can catch a misread before the agent burns time. Format:
  ```
  Identified open question: "{restatement}"
  Proceeding with /pm.
  ```
- If no question can be identified, abort with:
  ```
  /pm could not identify an open question in the recent conversation.
  Re-invoke with: /pm "your question here"
  ```

---

### Step 2 — Capture the working directory

Set `CWD` = current working directory of the invoking session. Do not walk for `projects/<name>/` here; that's the agent's Phase 1 responsibility.

---

### Step 3 — Delegate to the `project-manager` agent

Spawn the `project-manager` subagent via the `Task` tool with this brief (verbatim structure):

```
You are the Axcíon AI Project Manager.

Operator's open question:
{OPEN_QUESTION verbatim}

Steering (may be empty):
{OPTIONAL_STEERING verbatim}

Working directory of the invoking session:
{CWD}

Apply your full procedure (Phase 1 project detection → Phase 2 constitution-doc discovery → Phase 3 classification → Phase 4 escalation if needed → Phase 5 ruling). Output the three-part ruling to chat per your agent definition. Apply fallback 5a / 5b / 5c / 5d when applicable.
```

Wait for the agent's response. Capture it verbatim as `PM_RULING`.

Capture it as `FINAL_RULING`.

*(An internal `qc-reviewer` pass with a 2-pass cap sat here until 2026-07-29. It was removed with the rest of the automatically-stacked review layer — a `/pm` ruling is an advisory chat answer, not a committed artifact, and `/consult` answers harder questions with no internal review at all. The `qc-reviewer` agent itself was deleted on 2026-07-30.)*

---

### Step 6 — Return the final ruling unmodified

Output `FINAL_RULING` verbatim to the operator. Do NOT add a preamble, do NOT summarize, do NOT add an "I hope this helps" closing. The agent's voice is the Project Manager voice; wrapping it in command-shell prose dilutes it. Where the ruling is load-bearing enough to cite downstream, say so in one line — the review belongs to the change the ruling informs, not to the ruling itself.

---

### Notes for the executor

- `/pm` writes nothing to disk at v1. Output is chat-only.
- `/pm` is **advisory with strong precedence** — the main session treats the ruling as the default answer. Operator retains veto.
- `/pm` runs **no internal review**, matching `/consult`. A ruling is an advisory chat answer, not a committed artifact; the change it informs is what gets reviewed, once, per `ai-resources/docs/qc-independence.md` § The rule.
- `/pm` does NOT auto-fire from any hook; operator-invoked only.
- The agent decides whether to escalate to `system-owner` internally; the operator does not pre-route.
- For change-shaped structure questions (operator proposes a specific repo modification), the agent emits Fallback 5d (REDIRECT TO /consult) — re-invoke `/consult` directly for those.
- **Plan-divergence note, now closed:** the approved plan specified no internal QC step (mirroring `/consult`). A 2026-05-28 operator direction added one; it was removed again on 2026-07-29 with the rest of the stacked review layer, so the command is back to the plan as originally approved.
