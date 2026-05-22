---
name: grill-me
description: >
  Interviews the user relentlessly about every aspect of a planning question until
  shared understanding is reached, then produces a structured mandate brief. Use
  before writing any project plan or complex skill brief. Do NOT use for simple
  scoped requests or routine execution sessions.
model: opus
effort: high
disable-model-invocation: true
allowed-tools: Read, Glob, Write
argument-hint: "[topic or planning question — optional]"
---

## Purpose

Force genuine shared understanding before any plan is written. The skill exists because agents jump to plan documents too early — before the real question behind the stated question has been found, and before key sub-decisions have been surfaced.

The grilling *is* the work. The mandate brief is a byproduct of having actually reached shared understanding, not a substitute for it.

**End state:** A mandate brief that a downstream skill (project plan writer, skill brief writer) can execute against without follow-up questions.

**Boundary:** This skill does not write the plan. It produces the conditions under which a good plan can be written.

---

## When to Use

**Use:**
- Before writing a project plan — primary use case (context pack creation → project plan stage)
- Before writing a brief for a complex `/create-skill` or `/improve-skill` — when thin input is producing thin output

**Do NOT use:**
- At session start for execution sessions — harness sessions have a mandate already; grilling adds friction before known work
- For simple, clearly-scoped requests — grilling adds cost where clarity already exists
- During `/friday-checkup`, `/audit-repo`, or other cadence commands — scope is predefined by the cadence

---

## Input Contract

- **Argument (optional):** The topic or planning question, passed as `$ARGUMENTS`
- **No argument:** The skill opens with one meta-question — "What are we planning, and what outcome would make this session a success?" — then grills from the answer
- **Existing artifacts:** Any prior plans, skills, reports, or CLAUDE.md files in scope — consulted at Step 1 before asking the user

---

## Execution Workflow

### Step 1 — Artifact Scan

Before asking the first question, read any obviously relevant existing artifacts:
- Prior project plans in `output/`
- Related SKILL.md files (for skill-creation use case)
- Reports and audit artifacts relevant to the stated topic
- CLAUDE.md files in scope

Goal: do not ask the user something the repo already answers. Only scan artifacts directly relevant to the stated topic — do not load large background docs speculatively. State in one line what was found (or that nothing relevant was found) before opening the interview.

### Step 2 — Open With the Core Question

- If no argument: "What are we planning, and what outcome would make this session a success?"
- If argument given: acknowledge the topic and begin grilling immediately

### Step 3 — Interview Loop

Ask one question per turn (or a tight cluster of ≤2 tightly linked questions — never more). For each answer:

1. **Walk the design tree** — each decision opens sub-decisions; surface and resolve them before moving on. Do not advance to implementation questions before framing questions are resolved.
2. **Challenge loose language** — when the user describes something verbosely that has a sharper named equivalent in existing artifacts, push back and use the artifact's term.
3. **Probe the framing itself** — the user's opening description embeds assumptions. Early questions challenge the framing, not just fill in details within it.
4. **Probe abstract nouns** — treat every abstract noun as a potential ambiguity; follow with "what does that mean concretely in this context?"

**Bike-Shedding Stop:** After ~3 refinement rounds on the same concept without convergence, surface the best current definition, state it is "good enough to be load-bearing," and offer to lock it and move on.

### Step 4 — Continue Until

- No unanswered question remains that would change the plan, OR
- The operator explicitly ends the session

Do not stop because answers feel satisfactory. Stop because nothing remains that would affect the plan.

### Step 5 — Produce the Mandate Brief

Write the brief to: `output/{project-or-topic}/grill-mandate.md`

If no project context exists yet, write to: `output/grill-mandate-{topic-slug}.md`

---

## Output Structure — The Mandate Brief

```
# Mandate Brief: [Topic]

## Objective
[One sentence: what we are building/doing and why.]

## Scope
- In: [list]
- Out: [list]

## Key Decisions Resolved
[Each non-obvious decision taken during grilling, with the chosen direction
and one-line rationale.]

## Non-Obvious Constraints
[Constraints that would surprise someone reading the plan cold.]

## Open Questions
[Any remaining questions the operator chose not to resolve — flagged for
downstream handling.]

## Recommended Next Step
[Which skill or command to run next, and what to hand it.]
```

**Compression rule:** The brief is a handoff doc, not a transcript summary. One page maximum. If a downstream skill can infer something from the Objective + Scope, do not repeat it in Key Decisions.

---

## Artifact Exploration Rule

Before asking a question, check whether existing artifacts answer it:
- Prior project plans in `output/`
- Relevant SKILL.md files (for skill-creation use case)
- Reports and audit artifacts
- CLAUDE.md files in scope

Only ask the user when artifacts do not resolve the question, or when the answer requires a value judgment only the user can make.

---

## Bike-Shedding Discipline

After 3 refinement rounds on the same concept:
1. Surface the best current definition
2. State: "This is good enough to be load-bearing — I'll lock it and move on unless you want to redirect."
3. Proceed

The goal is a definition that survives execution, not a perfect one.

---

## Runtime Recommendations

- **Model:** Opus — judgment-heavy; shallow grilling on a smaller model defeats the purpose
- **Effort:** high
- **Tools:** Read, Glob (artifact scan); Write (mandate brief output)
- **Context:** No special context loading required beyond the artifact scan at Step 1
- **Session type:** Interactive — runs in the main conversation, not a forked subagent; needs the operator's live responses

---

## Bias Countering

**Premature closure bias:** The agent may feel pressure to stop grilling once answers seem "good enough." Counter: keep asking until nothing remains that would change the plan — not until answers feel satisfactory.

**Flattery acceptance:** Users give verbose, high-level answers that sound complete but leave key sub-decisions open. Counter: treat every abstract noun as a potential ambiguity; probe with "what does that mean concretely in this context?"

**Anchoring on the first framing:** The user's opening description embeds assumptions. Counter: early questions probe the framing itself, not just fill in details within it. The real question is rarely the stated question.

**Completeness illusion:** A long list of resolved decisions can feel like full coverage even when one undiscovered constraint would invalidate the plan. Counter: after the decision list feels complete, ask one more — "Is there anything about this that would surprise someone reading the plan cold?"

---

## Known Pitfalls

- **Running on an already-understood topic** — adds friction with no payoff; if the topic is clearly scoped before invocation, skip the skill
- **Too many questions per turn** — clusters of 5+ questions scatter the operator's thinking; one question anchors it
- **Mandate brief that is too long** — the brief is a handoff doc, not minutes-of-meeting; compress to what the downstream skill actually needs
- **Skipping the artifact scan** — asking the user something the repo already answers erodes trust and wastes turns
- **Grilling on implementation before framing** — asking "how should we structure the output?" before "what outcome would make this a success?" inverts the design tree; walk top-down

---

## Failure Behavior

- **Operator ends grilling early:** Produce the mandate brief immediately with unresolved items in Open Questions — do not withhold the brief because coverage is incomplete
- **No existing artifacts found to scan:** State in one line that no relevant artifacts were found, then proceed to Step 2
- **Topic too vague to grill from:** Ask one clarifying question — "What's the most important thing this needs to get right?" — then grill from the answer
- **Operator redirects mid-grill:** Treat the redirect as a new sub-decision, update the design tree accordingly, continue

---

## Validation Checklist (Pre-Delivery)

- [ ] Artifact scan completed before first question
- [ ] Framing was challenged (not just details filled in within the original framing)
- [ ] Every decision that would affect the plan has been resolved or explicitly deferred
- [ ] Mandate brief fits on one page
- [ ] Recommended next step names a specific skill or command
- [ ] No open questions remain that the operator answered but the brief missed

---

## Example

**Invocation:** `/grill-me Nordic PE fund triage — new research project`

**Artifact scan:** Prior Nordic PE project plan found at `output/nordic-pe-macro-landscape/project-plan.md`. Read before asking.

**First 4 questions (design tree, top-down):**

1. "The prior project plan covers the macro landscape. Is this new project building on that, replacing it, or addressing a different question entirely?"
2. "Who is the primary reader of this triage output — you as analyst, or a client-facing document?"
3. "What makes a fund worth triaging in this context — what's the minimum bar for inclusion?"
4. "Is the output a ranked list, a memo, a set of one-pagers, or something else?"

**Sample mandate brief (abbreviated):**

```
# Mandate Brief: Nordic PE Fund Triage

## Objective
Produce a structured triage of 8–12 Nordic PE funds against Axcíon's client
mandate, suitable for analyst review before client presentation.

## Scope
- In: funds with AUM >€500M, Nordic primary focus, vintages 2018–2024
- Out: secondaries, credit funds, non-Nordic GPs with Nordic allocation

## Key Decisions Resolved
- Output: one-pager per fund + summary ranking table (not a memo)
- Triage criteria: strategy fit, track record, fee structure, LP concentration
- Builds on macro landscape project — do not re-derive macro context

## Non-Obvious Constraints
- Client has existing relationship with two GPs — flag but do not exclude

## Open Questions
- Whether to include co-investment capacity as a criterion (deferred)

## Recommended Next Step
Run context-pack-builder with this brief as the input mandate.
```
