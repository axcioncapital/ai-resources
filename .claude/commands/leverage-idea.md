---
description: Process a pasted idea dump (ChatGPT export, brainstorm) into a structured Idea Brief, investigate workspace evidence and repo attach-points, generate 2–4 distinct leverage options, and recommend one with a worth-doing verdict and implementation plan — or PARK to improvement-log.md. Advisory only — writes analysis to audits/working/ and (on PARK) a pending entry to logs/improvement-log.md; applies no other change.
model: opus
argument-hint: "[pasted idea dump / notes, or a path to a notes file — leave blank to use the pasted block]"
---

# /leverage-idea — idea dump → leverage options → worth-doing verdict → implementation plan

Take a messy idea dump about adding or improving an Axcíon AI resource and route it to the **best way to plug it into the system**. The pipeline distills the dump into a clean Idea Brief, checks whether the workspace shows real evidence of the need, investigates where in the repo the idea could attach, generates 2–4 **distinct** leverage options, and recommends one with a worth-doing verdict and an implementation plan — or concludes "don't build this" and PARKs it. **Advisory only: it stops at the implementation plan and applies no change.**

**Boundary vs `/tech-consult` (nearest scope-neighbour).** `/tech-consult` translates a broad business or project need into a build-ready technical plan — need-first, pre-idea, spanning project/business scope. `/leverage-idea` starts from an already-captured idea about **workspace AI resources** (the Claude Code substrate) and routes it to the best attach point — idea-first, system-routing. Reach for `/tech-consult` when you have a need and no solution yet; reach for `/leverage-idea` when you already have an idea for a resource and need the best way to build it.

**Boundary vs siblings.** `/request-skill` is intake-only (no investigation) — `/leverage-idea` feeds it. `/implementation-triage` judges an *already-proposed* implementation — `/leverage-idea` *produces* the proposal. `/resolve-repo-problem` handles faults, not ideas.

Input: `$ARGUMENTS` — the idea dump itself (pasted notes, a ChatGPT export), or a path to a notes file. If empty, use the most recent pasted block in the conversation. If nothing is present, ask the operator for the notes and stop.

---

## Step 0 — Input resolution + multi-idea split

1. Resolve the raw notes: `$ARGUMENTS` verbatim if it is prose; if it is a readable file path, Read that file; if empty, use the most recent pasted idea block in the conversation. If no notes can be found, emit `/leverage-idea needs an idea dump — paste your notes or give a file path.` and stop.
2. Scan for **multiple distinct ideas**. If the notes carry more than one separable idea, pick the strongest to process now (decision-point posture — state the pick + the runner-up in one line each), and record the rest under `## Deferred Ideas` in the analysis file (Step 9). One idea → skip the split.

## Step 1 — Distill the Idea Brief (inline)

The notes are already in main-session context — distill them here; do **not** pass the raw dump downstream.

**Strip packaging, keep substance.** A ChatGPT export carries non-substantive scaffolding — preambles, restated prompts, decorative headers, hedging, "in summary" recaps, sign-offs. Strip all of it. But for an *exhaustive* dump, do not flatten the real content to fit five terse lines: let the fields carry every load-bearing specific the notes provide (concrete mechanisms, examples, numbers, named constraints), because Steps 4–5 reason from this brief, not the raw dump. Strip the packaging; keep the signal.

Write a 5-field Idea Brief:

- **Core idea** — what is being proposed, in 1–2 sentences.
- **Problem it solves** — the gap or friction it addresses.
- **Claimed benefits** — what the notes assert it will improve.
- **Constraints & assumptions** — anything the notes fix or presume.
- **Source** — where the dump came from (ChatGPT export, brainstorm, dated note).

Any claim in the notes about the *current workspace state* ("we don't have X", "Y is broken") is a **workspace-assertion** — tag it `[verify]` and pass it to Step 4 for checking. Do not accept it as fact.

## Step 2 — Fast-path gates (inline, pre-subagent)

Before spending a subagent, run two cheap gates:

- **Duplicate gate.** Glob/grep `ai-resources/.claude/commands/` and `ai-resources/.claude/agents/`, and scan `ai-resources/skills/*/SKILL.md` frontmatter, for a resource that already does this. **Exact duplicate** → point the operator to the existing resource and recommend `/improve-skill` (skills) or `/tweak` / direct edit (commands, agents); end, write no files. **Partial overlap** → carry it forward as a candidate "extend existing" attach point (do **not** short-circuit).
- **Triviality gate.** If the idea is a ≤1-file cosmetic change (wording, a single line), recommend `/tweak "..."`; end, write no files.

If either gate ends the run, report the routing in chat only.

## Step 3 — Path setup

1. `AI_RESOURCES = "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.
2. `DATE` = today (`YYYY-MM-DD`).
3. Compute `SLUG` from the Idea Brief's Core idea: lowercase, replace non-alphanumeric runs with a single `-`, strip leading/trailing `-`, truncate to 50 characters at a `-` boundary. If empty, fall back to `idea-{HHMMSS}`.
4. `ANALYSIS_PATH = {AI_RESOURCES}/audits/working/{DATE}-idea-{SLUG}.md`. If it already exists, append `-2`, `-3`, … until unique.
5. `NOTES_PATH = {AI_RESOURCES}/audits/working/{DATE}-idea-{SLUG}-investigation.md` (subagent working notes — internal plumbing; carry the same uniqueness suffix as `ANALYSIS_PATH`).

## Step 4 — Investigation (one general-purpose subagent, inline brief)

Spawn **one** general-purpose investigator subagent (fresh context) via the `Task` tool with the brief below. It receives the **distilled Idea Brief only** — never the raw dump.

```
You are an AI-resource idea investigator. Gather evidence and map repo attach-points for a proposed workspace resource. You produce no recommendation and apply no change — investigation only.

IDEA BRIEF (distilled by the main session):
{the 5-field Idea Brief, including any [verify] workspace-assertion tags}

AI_RESOURCES: {AI_RESOURCES}

Procedure:

Part A — Use-case evidence. Search the workspace evidence logs for signs this need is real:
- {AI_RESOURCES}/logs/friction-log.md
- {AI_RESOURCES}/logs/improvement-log.md
- {AI_RESOURCES}/logs/defect-log.md
- {AI_RESOURCES}/logs/session-notes.md (recent blocks)
- recent {AI_RESOURCES}/audits/ report headers
Cite specific entries (date + one-line quote) or state "no evidence found" — never infer a use case that is not written down. Resolve each [verify] workspace-assertion tag: confirm or refute it against repo state, and say which.

Part B — Repo surface & attach points. Find existing resources that touch this space and candidate attach points (with paths). Search SEMANTICALLY — by capability and purpose, not just name-match — across the full command, skill, and agent libraries under {AI_RESOURCES}. This is the backstop for near-duplicates a name-only scan misses. For each candidate attach point, give the path and one line on what it currently does.

Write your FULL findings to: {NOTES_PATH}
Use these exact headings:
## Idea Brief (as received)
## Use-Case Evidence
## Repo Surface & Attach Points
## Investigator Observations

Then return a summary of AT MOST 30 lines to the main session:
- Use-case evidence: 2–4 bullets (cited, or "no evidence found").
- Repo surface: the 2–4 strongest attach points, one line each with path.
- Any near-duplicate the fast-path gate would have missed.
- The last line must be exactly: NOTES: {NOTES_PATH}

Do not edit, create, or delete any file other than {NOTES_PATH}.
```

Read **only the returned summary** (per the `ai-resources/CLAUDE.md` Subagent Contract — do not re-read the full notes unless a specific finding needs context). Capture the `NOTES:` path. If the summary lacks the `NOTES: {NOTES_PATH}` last line, re-invoke once with the same brief; if it is still malformed, note that in chat and proceed with the summary you have.

## Step 5 — Leverage options (inline — the heart)

Generate **2–4 distinct** leverage options from the lever menu. They must be different *levers*, not size variants of one lever:

- **Extend an existing resource** (name it + attach point).
- **New command + agent.**
- **New CLAUDE.md rule or doc.**
- **New hook.**
- **Park** (don't build).

Per-option block:
- **Shape** — 1–2 sentences: what it is + the attach point (cite a Step 4 path).
- **Fit** — how well it serves the Core idea.
- **Effort** — S / M / L.
- **Risk** — including the `/risk-check` change class if one matches (per `ai-resources/docs/audit-discipline.md`: new command/skill, hook edit, cross-cutting CLAUDE.md, new symlink, shared-state automation).
- **Evidence** — cite the Step 4 use-case evidence, or mark "speculative".

**Cross-model check.** If the idea's best home is another tool in the ecosystem (GPT via API/CustomGPT, Perplexity, Notion, NotebookLM) rather than the Claude Code substrate, the option must carry that **tool assignment** explicitly — do not default an inherently non-Claude idea into a Claude Code build (workspace cross-model rules).

End with one **Ranking** line ordering the options.

## Step 6 — Recommendation + verdict (inline)

State the recommended option and the main rejected alternative — one line each. Then a verdict, reusing `/implementation-triage` vocabulary:

- **WORTH-DOING** / **MARGINAL** / **NOT-WORTH-DOING**.

No workspace evidence does **not** auto-fail the verdict, but it must flag the value case as **speculative**. `MARGINAL`-with-no-evidence or `NOT-WORTH-DOING` → route to the PARK path (Step 8).

**Complexity-budget cap (enforcement, not advisory).** If the recommended option introduces a **new component** — a new command, agent, mandatory stage/gate, or permanent always-loaded doc — it must clear the complexity-budget gate (`docs/ai-resource-creation.md` rule #7): at least one of prong (a) net-simplification or prong (b) cited-evidence, and, for a new *detection* component, a named closure channel. An option that fails the gate is **capped at `MARGINAL`** — this cap is an explicit gate action (OP-5 enforcement), so state it as such: name the failed prong and, if the operator still wants to build, require the OP-11 waiver in `logs/decisions.md`. An extend-existing option (no net-new component) is not subject to the cap.

**This is a routing verdict, not a context-isolated ROI certification** — it is self-generated by the same reasoning that built the options. For a big or contested call, the operator can chain `/implementation-triage` for an independent ROI read. State this line in the output.

## Step 7 — Implementation plan (skip on PARK)

For a WORTH-DOING (or operator-accepted MARGINAL) recommendation, write the plan:

- **Target files** — what gets created / edited.
- **Step sequence** — the build order.
- **Gates** — the `/risk-check` change class if matched; `/qc-pass` after the artifact is written; `/blindspot-scan` post-approval when it is a risk-check class.
- **Effort** — S / M / L.
- **Open assumptions** — anything the operator must confirm.

If the recommendation is a **new skill**, embed the inbox brief **verbatim** in `/request-skill` format (`# Resource Brief:` name / Requested / Origin / Capability / Trigger Conditions / Exclusions / Context / Existing Skills Reviewed), ready to copy into `ai-resources/inbox/` on approval. The command itself never writes to `inbox/`.

**Stop here — no execution.**

## Step 8 — PARK path

For a PARK outcome, append one `logged (pending)` entry to `{AI_RESOURCES}/logs/improvement-log.md` using its schema:

```
### {DATE} — {short idea title}

- **Status:** logged (pending)
- **Category:** command/skill (leverage-idea PARK)
- **Review-cycle:** reviewed {DATE}, deferred to → {concrete trigger — a date, a quarter, or a named event}
- **Friction source:** {the idea + why it is parked rather than built now}
- **Proposal:** {the parked idea in 2–4 sentences; note the strongest leverage option for if it is revisited}
- **Target files:** {likely attach point(s) if built later}
- **Notes:** analysis — {ANALYSIS_PATH}
```

The `Review-cycle:` trigger is a **hard requirement, not a guideline** — it must be concrete (a date, a quarter, or a named event), never "later"/"someday". A park with no real trigger never drains, and `/resolve-improvement-log` Step 3b rejects a vague trigger. This shape matches the schema `/resolve-improvement-log` archives against.

## Step 9 — Write the analysis file

Write `{ANALYSIS_PATH}` — the one operator-facing deliverable:

```
# Leverage-Idea Analysis — {idea title} — {DATE}

## Idea Brief
{the 5 fields}

## Evidence Findings
{from the Step 4 summary — do not re-read the full notes}

## Repo Surface
{candidate attach points from Step 4}

## Leverage Options
{the 2–4 option blocks + Ranking}

## Recommendation & Verdict
{recommended + rejected alternative + verdict + the routing-not-ROI line}

## Implementation Plan   — or —   ## Park Rationale
{Step 7 plan, or the PARK rationale + concrete Review-cycle trigger}

## Deferred Ideas
{any ideas split off in Step 0 — omit this heading if none}

---
Investigation notes: {NOTES_PATH}
```

## Step 10 — Chat report + handoff bridge

Print to chat:
- The verdict line.
- Recommended option + rejected alternative (one line each).
- `Analysis: {ANALYSIS_PATH}`.
- Exactly **one** advisory bridge line from the matrix below. The bridge never auto-invokes — it is a suggestion the operator acts on.

| Recommendation | Bridge |
|---|---|
| New skill | `/create-skill` — inbox brief drafted in the analysis file; copy to `ai-resources/inbox/` on approval |
| New command / agent / hook / other structural class | Plan's Gates name the `/risk-check` class; the bridge repeats it |
| Extend existing resource (non-class) | The plan is the execution spec — run it on approval or in a follow-up session |
| PARK | Logged to `improvement-log.md` with a concrete Review-cycle trigger |
| Tiny tweak (Step 2) | `/tweak "..."` — chat only |
| Duplicate (Step 2) | Existing resource named + `/improve-skill` — chat only |

Remind the operator to run `/wrap-session` if the work is complete.

---

$ARGUMENTS
