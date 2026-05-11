---
model: sonnet
---

The operator wants a plain-language re-explanation of the most recent meaningful unit of work in this conversation.

## Step 1: Pick the target

Look back through your recent turns and pick the most recent **meaningful unit** — usually the last assistant turn, but if that turn was trivial (one-line acknowledgment, a tool-call-only turn with no chat content), step back to the last substantive turn: an output produced, a decision made, or a pending ask raised.

State the target in one line at the top:

> *Re-explaining: {one-line description of the target turn}.*

## Step 2: Produce three fixed sections

Use these exact headings, in this order. If a section has nothing to report, write `Nothing — {short reason}` instead of omitting the heading.

### What I just did

The visible output **plus any load-bearing silent actions** — files written, subagents spawned, tools called — that produced it. Don't dump every tool call; only the ones that affected the visible result or that the operator would want to know about.

### What I decided

Visible decisions stated in the target turn **plus silent decisions** where you picked a default per the Autonomy Rules / Decision-Point Posture (e.g., "I picked option A because the plan said pick the recommended option and proceed").

### What I need from you

Any pending question, blocker, or `[AMBIGUOUS]` flag. If nothing is blocking, write `Nothing — you can keep going` or similar.

## Step 3: Language rules

- Stay at the existing CEFR B2 baseline already used in chat (short sentences, common words, no idioms).
- Gloss every piece of technical jargon **on first use in this response**, with one short clause. Examples:
  - "subagent (a helper Claude spawns to do a focused task)"
  - "stash (a temporary save of uncommitted work)"
  - "frontmatter (the YAML block at the top of a markdown file)"
- Structured tags stay verbatim — `[AMBIGUOUS]`, `[HEAVY]`, `[SCOPE]`, `[COST]`, etc.

## Step 4: No side effects

Pure chat output. No file writes. No subagent spawns. No tool calls beyond reading the conversation context you already have. Do not re-do the work or produce new analysis — only explain what already happened.
