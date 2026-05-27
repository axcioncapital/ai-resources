# Resource Brief: decision-resolver

**Requested:** 2026-05-27
**Origin:** nordic-pe-macro-landscape-H1-2026 — recurring daily friction when Claude surfaces mixed-shape decision lists mid-session (after `/qc-pass`, `/scope`, `/clarify`, or any structured output that produces operator-decision questions).

## Capability

A command that takes a list of open-ended decision questions Claude just surfaced in the conversation, and for each question attempts evidence-grounded resolution from project files BEFORE asking the operator. For each item, output one of three buckets with reasoning shown:

1. **Self-resolved** — Claude settled the question from project state alone. Presents: resolution + reasoning + file refs the operator can audit.
2. **Recommendable** — partial evidence supports a recommendation, but the operator should confirm. Presents: recommendation + supporting evidence + the specific gap that prevents full confidence + the question in the operator's original framing.
3. **Operator-only** — genuinely requires operator taste, strategic direction, or knowledge not in any file. Presents: the question + relevant project context + a brief note on why this cannot be evidence-grounded.

The command's value over current ad-hoc handling: it moves "evidence check first, ask second" from operator-discipline-by-memory into a named tool, with structured output the operator can scan and approve/override fast.

## Trigger Conditions

- Operator invokes the command (e.g., `/decision-resolver` or chosen name) referencing the most recent decision list in context.
- Common upstream triggers (the command picks up findings from any of these):
  - After `/qc-pass` produces REVISE findings that mix mechanical fixes with operator-judgment items.
  - After `/scope` summary contains "Decisions I am making on your behalf" items the operator wants verified.
  - After `/clarify` produces operator-decision questions Claude flagged as load-bearing.
  - After any mid-stream Claude turn that surfaced a list of pending decisions to the operator.

The command does NOT auto-fire — it is operator-invoked at moments of decision-list friction.

## Exclusions

- Does NOT auto-apply decisions silently — every resolved item must show reasoning and file evidence the operator can audit. Self-resolved items are presented for operator scan, not skipped.
- Does NOT replace `/recommend` — `/recommend` is for when the operator wants Claude to drive blanket, without back-and-forth. This command is the opposite: explicit per-item recommendation with anti-narrowing protection.
- Does NOT replace `/resolve` — the two compose: `/resolve` triages QC findings to Real/Low-signal/Skip, this command then picks up Real items in the "Needs operator judgment" bucket and grounds them in evidence.
- Does NOT escalate decisions the operator already made earlier in the session — must check `logs/session-notes.md`, `logs/session-plan.md`, and conversation history for prior decisions before treating an item as open.
- Does NOT extend its scope beyond the most recent decision list — the operator names a target list (or it inherits from the previous turn); it does not sweep the whole session for open decisions unprompted.

## Context

**Failure mode this command exists to prevent — silent narrowing.** Earlier in the session that requested this skill, Claude rewrote the operator's verbatim audience phrasing "PE, M&A, Macro, etc." as "financial/advisory research + adjacent" inside a `/scope` summary. The QC pass caught the rewording. This kind of invisible narrowing — Claude making a small decision that is not surfaced as a decision — is the single most important pattern this command must protect against. Every recommendation it produces must show:

- (a) The evidence that supports the recommendation (file paths + relevant excerpts).
- (b) The question in the operator's exact framing where that framing exists in conversation.
- (c) A `[narrowing-check]` note where the recommendation may have constrained or reframed the original question.

**Composition with existing tools (must integrate cleanly):**

- `/qc-pass` → produces findings → `/resolve` triages to Real/Low-signal/Skip → operator runs this command → picks up the "Needs operator judgment" Real items and pre-researches them.
- `/scope` → produces "Decisions I am making on your behalf" → operator runs this command → grounds each Claude-made decision in evidence and flags any narrowing.
- `/clarify` → produces operator-decision questions → operator runs this command → pre-researches each question and gives a recommendation to accept/override.

**Why a new command rather than extending `/resolve`:**

- `/resolve` is scoped to QC findings. The friction pattern this skill addresses recurs in non-QC contexts too (mid-session forks, `/scope` verification, post-`/clarify` questions). Folding cross-context evidence-research into `/resolve` overloads it.
- A separate command gives the pattern a clear name and lets the two compose.
- `/create-skill` should reconfirm this architectural choice — if the design pass reveals tighter overlap than the brief identifies, an extension may still be the right call.

**Token efficiency consideration:**

The command will read project files per question. To avoid blowing token budget, the design should specify a read-scope cap (e.g., max files read per question, max bytes per file) and a deferral mechanism (if a question requires more reads than the cap allows, escalate to operator with the partial evidence found rather than recursing).

## Existing Skills Reviewed

- **`/resolve`** (`ai-resources/.claude/commands/resolve.md`) — Triages QC findings → Real/Low-signal/Skip; drafts concrete fixes; surfaces "Needs operator judgment" rows separately. **Gap:** QC-scoped only; does not pre-research project files for evidence-grounded recommendation on operator-judgment rows; just defers them.
- **`/recommend`** (`ai-resources/.claude/commands/recommend.md`) — Tells Claude to use own judgment on all open questions and proceed. **Gap:** blanket-judgment shape with high silent-narrowing risk by design; this command is the opposite posture (explicit per-item evidence + anti-narrowing protection).
- **`/clarify`** (`ai-resources/.claude/commands/clarify.md`) — Produces clarifying questions BEFORE work begins. **Gap:** different stage; operates upstream of work, not mid-stream when decisions surface as side-effects of structured outputs.
- **`/triage`** (`ai-resources/.claude/commands/triage.md`) — Independently ranks suggestions/findings. **Gap:** ranking, not resolution; no evidence-research step.
- **`/consult`** (`ai-resources/.claude/commands/consult.md`) — Architectural consultation via System Owner subagent. **Gap:** different scope (architectural questions), not per-item operator decisions.

**Specific delta the new command provides:** per-item evidence-grounded pre-research before operator escalation, broad scope across any structured output (not just QC findings), with explicit anti-narrowing design.
