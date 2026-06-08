# Patrik's AI Vocabulary

> **For:** Patrik | **Last reviewed:** 2026-06-08
> **Purpose:** A working list of words that carry intent. Each one removes ambiguity about *how thorough*, *how invasive*, and *in what order* you want me to work. "Fix this" is vague; "reproduce it, find the root cause, then a minimal fix, then verify" is a whole workflow in one sentence.

**How to read the markers:**
- `★` — you already use this well in your sessions. Listed so you keep it consistent, not to teach it.
- `NEW` — a genuine gap; worth adding to your habits.

This is a living doc. Add words as you find phrasings that didn't land.

---

## 1. Investigating before acting

| Word | What it tells me |
|---|---|
| **triage** `★` | Assess and prioritize across many issues instead of fixing the first thing seen. |
| **trace** | Follow the actual execution path / data flow, don't guess at it. |
| **root cause** | Find the real cause, not a band-aid. *"Fix the root cause, not the symptom."* |
| **reproduce** ("repro") | Confirm the problem actually exists before changing anything. |
| **audit** `★` | Systematic sweep across a whole category against a standard or spec. |
| **micro-audit** `NEW` | Verify *one specific claim or set* — not a full sweep. You currently say "audit" for both the big systematic pass and the one-line check, which makes me over- or under-scope. Naming the small one fixes that. |

---

## 2. Controlling scope

| Word | What it tells me |
|---|---|
| **explicit** | Spell it out, don't infer. *"Be explicit about your assumptions."* |
| **minimal diff / surgical** | Make the smallest change that works. Don't rewrite the surrounding code. |
| **scope** `★` | Define the boundary. *"Keep this scoped to the auth section."* |
| **constraints / "don't touch X"** | Hard guardrails I will respect. |

*You already do this well — your `[SCOPE]` tag and ALL-CAPS "Do NOT" are both clear scope signals. Keep using them.*

---

## 3. Planning

| Word | What it tells me |
|---|---|
| **plan first / "don't write yet"** | Give me a plan before any edits. Biggest lever on large tasks. |
| **step by step** | Force sequential reasoning instead of jumping to an answer. |
| **acceptance criteria / "done-when"** `NEW` | State up front what *finished* looks like. Your logs show gates like "operator review of §2.2" with no finish line — so I can't tell when the gate has passed. *"…done-when: top-3 gaps picked or approved as-is."* |

---

## 4. Quality & closing the loop

| Word | What it tells me |
|---|---|
| **idiomatic** | Match the conventions already in the file/codebase, don't invent a new style. |
| **refactor** (vs. rewrite) | Restructure without changing behavior. |
| **edge cases** | Handle the boundaries, not just the happy path. |
| **verify / "run the tests"** `★` | Don't trust — confirm against live state. |
| **regression** | Make sure the change didn't break something else. |

*These apply whenever you edit commands, skills, or hooks — not just "real" code.*

---

## 5. Research & analysis — your domain

This is the section the generic "AI words" lists skip, and it's where your actual work lives.

| Word | What it tells me |
|---|---|
| **triangulate / corroborate** `NEW` | Confirm a claim across independent sources before trusting it. |
| **disconfirming evidence** `NEW` | Actively hunt for what would *break* the thesis, not just what supports it. |
| **steelman** `NEW` | Argue the strongest version of the opposing case before judging it. |
| **evidence vs. interpretation** `NEW` | Keep the fact separate from my reading of it. (Already a workspace rule — saying it as a *request* word makes me apply it on demand.) |
| **materiality / "so what"** `NEW` | Does this finding actually change a decision? You live this via the materiality bar — naming it makes me filter for it. |
| **decision-relevant / load-bearing** `★` | Is this the part the conclusion actually rests on? |
| **provided-sources-only / closed-book** `NEW` | Answer only from the material I gave you; flag gaps instead of filling them from training. |

---

## 6. Workflow & orchestration

| Word | What it tells me |
|---|---|
| **failure mode** `NEW` | The specific way something breaks. Sharper than "what's not working." |
| **blocking vs. non-blocking** `NEW` | Whether a deferred item *must* be reopened before the next step, or can wait. |
| **gate** `★` | An approval / decision point in a flow. |
| **parked** `★` | Postponed pending a decision or a dedicated session. |
| **escalate** `★` | Push the decision up a tier, or switch to a stronger model. |
| **structural** `★` | A self-maintaining fix, not a patch. |

---

## 7. Words you already command — keep them consistent

You use these precisely and often. Consistency is the only thing to protect here:

**reconcile** · **drift** · **disposition** · **signal** · **friction** · **mandate** · **ROI** · **lean** · **atomic-batch** · **assumption** · **canonical**

---

## 8. Three habit-fixes — straight from your own logs

These are the highest-value items. Each is a single phrasing change that came out of a recurring pattern in your sessions.

**1. "Next steps" overload → label by urgency.**
Your next-steps lists mix four different things in one bullet list, so I can't always tell what's must-do-now. Label them:
> **Action (this session)** · **Next (next session)** · **Carryover (standing)** · **Optional (if bandwidth)**

**2. Gates without a finish line → add "done-when:".**
You set review gates without saying what makes them pass.
> *Instead of:* "Operator review of §2.2."
> *Say:* "Operator review of §2.2 — **done-when:** top-3 gaps picked, or approved as-is."

**3. Defer without urgency → say what it blocks.**
You park items cleanly, but don't always flag which ones hold up downstream work.
> *Instead of:* "Deferred to next session."
> *Say:* "Parked — **blocks §3 and §6; resurface before Phase 1 execution.**"

---

*The pattern behind all of it: these words remove ambiguity about how thorough, how invasive, and in what order I should work. A precise verb is a whole workflow in one word.*
