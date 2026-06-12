# Resource Brief: decision-report

**Requested:** 2026-06-12
**Origin:** marketing-positioning — operator request after the second proven instance of the pattern. The S1 session produced `output/surface-lock-decision-report.md` ("what exactly needs to be decided, why, and how" for the deferred surface-lock sitting); the S3 session produced `output/r1-selection-decision-report.md` (same shape for the three pending R1 selections). Operator: "decision prep reports [are] to be a reusable skill/command I can invoke when I need it. Write a spec so I can build the skill later. Call it 'decision report'."
**Status:** SPEC READY — build deferred by operator. Route through `/create-skill` when picked up.

## Capability

Produce a **decision-preparation report** for a set of pending operator decisions: a self-contained markdown brief that explains, per decision, **what** is being decided, **why** it is a real decision (the tension, constraints, and consequences), and **how** to decide it (options verbatim, trade-offs, a concrete decision test, and a clearly-labeled executor recommendation). The report prepares operators to decide — it never decides for them.

## Trigger Conditions

- The operator defers one or more decisions to a later session or a joint sitting (e.g., a second decision-maker must be present) and asks for decision prep — typical phrasings: "write a decision report," "what/why/how doc," "prep this for the sitting."
- The executor has just surfaced multiple pending operator-gate decisions (tier-C gates, QC DISAGREE items, plan forks) and the operator wants them packaged for asynchronous review rather than resolved in-chat.
- Operator-invoked only. Do NOT auto-fire.

## Exclusions

- **Does NOT decide.** The autonomous-resolution posture is `/decide`'s job (and the two are duals: `/decide` settles a list without the operator; `decision-report` packages a list *for* the operator). Never chain into applying a recommendation.
- **Does NOT re-litigate settled decisions.** Settled gates are fenced off in a dedicated "not on the table" section, never reopened.
- **Does NOT invent options or evidence.** Options come verbatim from existing drafts/artifacts; where an option text exists on disk, the report quotes it exactly (see Verbatim Rule below). Gaps are flagged, never filled.
- **Not for code/architecture changes** — `/risk-check` and `/implementation-triage` own verdict-shaped advisories on structural changes.
- **Not a status report or project briefing** — `/project-next-steps` owns "where does the project stand."

## Context

Two production instances exist and define the shape (read both before building):

- `projects/marketing-positioning/output/surface-lock-decision-report.md` — multi-cluster variant: 9 findings grouped into decision clusters, decision-sequence table, per-cluster what/why/how.
- `projects/marketing-positioning/output/r1-selection-decision-report.md` — small-set variant: 3 selections, at-a-glance table with executor reads and decision effort, per-decision sections, "how the rest runs" sequence, "what is NOT on the table" fence.

The pattern earns reuse because it solved a recurring operating problem: a two-operator firm where one operator (Daniel) is intermittently available, so tier-C/joint decisions batch into sittings — and the sitting is only as good as its preparation. The report is the sitting's agenda, evidence pack, and option sheet in one artifact.

## Existing Skills Reviewed (2026-06-12)

- `/decide` (command) — autonomous resolution of a decision list; the opposite posture. No overlap in output.
- `decision-to-prose-writer` (skill) — converts approved decision documents into narrative prose; consumes decisions, does not prepare them.
- `/scope`, `/clarify`, `/grill-me` — pre-work scoping/interrogation; in-chat, not a durable operator-facing brief.
- `/risk-check`, `/implementation-triage` — verdict-shaped advisories (GO/NO-GO, WORTH-DOING) on a single proposed change; not multi-decision operator prep.
- `/qc-pass` + `/resolve` — produce findings and importance verdicts that often *feed* a decision report; they do not produce one.
- No exact match. Gap confirmed.

---

# Spec (build-ready)

## 1. Resource shape

**Command, not skill** — recommended. The capability is operator-invoked, session-scoped, and produces one artifact from in-context material; it has no multi-file reference payload that would justify a skill directory. Home: `ai-resources/.claude/commands/decision-report.md`. YAML frontmatter: `model: opus` (judgment-heavy synthesis — per the agent-tier table, analytical commands → opus). If at build time the builder finds the output template too large for a command file, fall back to a skill with the template as a reference file — builder's call via `/create-skill`.

**Invocation:** `/decision-report [optional: which decisions / pointer to the list]`. With no argument, auto-detect pending operator decisions from recent context (the `/decide` Step 1 source-detection logic is the proven pattern to mirror: QC findings flagged "needs operator judgment," scope forks, explicitly deferred gates). Ambiguity guard: if multiple candidate decision sets exist, ask which — never silently pick.

## 2. Inputs

1. **The decision set** — from argument or auto-detection. Each item must be a genuine *operator* decision (a tier-C gate, an option pick, an approve/revise/park call). Items the executor can settle itself are filtered out with a one-line note (route those to `/decide`).
2. **The option texts** — located on disk wherever they were drafted (a pack, a findings file, the deliverable). The report references their source paths.
3. **The decision log** (`logs/decisions.md` or project equivalent) — for the settled-decision fence and constraint citations.
4. **Audience note** — who decides (solo operator vs joint), if stated; affects only the framing line, not the structure.

## 3. Method (steps the command encodes)

1. **Acquire + filter the decision set** (per Inputs 1). Confirm count and titles in one line before writing.
2. **Per decision, assemble the what/why/how triple:**
   - *What* — the decision in one sentence + where the chosen result will be applied.
   - *Why* — why it is a real decision: the constraint or tension that makes it non-obvious, citing the governing decisions/rules by ID (e.g., "#15 static-not-widening"). This section carries the consequences of each branch.
   - *How* — the options **verbatim** (see Verbatim Rule), one trade-off line each, a concrete decision test ("ask one question: …"), and the **executor recommendation, explicitly labeled as a recommendation.** Allowed hybrid/refinement moves are stated so the operator knows the menu is not rigid.
3. **At-a-glance table** before the sections: decision · options · executor read · effort to decide.
4. **"How the rest runs"** — the post-decision sequence (what the executor applies, what re-verifies, what gate the decisions unblock).
5. **"What is NOT on the table"** — settled decisions fenced by ID; out-of-scope adjacent calls named.
6. **Self-check before writing** (mirrors `/session-plan` Step 7 posture):
   - Every option text verbatim-matched against its source file (the Verbatim Rule) — this was the one QC REVISE finding in the pattern's second production run; it is the known failure mode.
   - Every recommendation labeled; zero imperative "we will do X" phrasing on undecided items.
   - Every constraint citation resolves to a real log entry.
   - Readable by a non-developer: plain language, jargon glossed on first use.
7. **Write the artifact** to the project's `output/` (name: `{topic}-decision-report.md`), then **run `/qc-pass`** with a scope line that names the verbatim-fidelity check and the never-pre-decides rule. Fix REVISE findings before presenting.

## 4. Verbatim Rule (load-bearing)

When an option text exists on disk, the report quotes it **exactly** — no abridgement, no paraphrase — in a blockquote, with the source path stated once. If a condensed form is editorially necessary, it must be labeled "summarized — full text at {path}". Rationale: operators choose ship-wording from this document; a silently shortened option means the applied text differs from what was chosen. (Empirically caught by QC in the r1-selection report, 2026-06-12.)

## 5. Output template

```markdown
---
project: {project}
artifact: {Topic} decision report — what exactly needs to be decided, why, and how
type: decision-preparation report — executor recommends, operators decide; nothing here is executed until the operators select
status: DRAFT v1 — produced {date} ({session}); {one line of provenance}
reads_from: {source files for the option texts and constraints}
consumer: {who decides — e.g., Patrik + Daniel, the {topic} sitting}
---

# {The N decisions} — what, why, how

## 0. Where things stand
{One short section: what is already settled and executed; what these decisions unblock.}

## 1. What needs to be decided — at a glance
| # | Decision | Options | Executor read | Effort to decide |

## 2..N+1. Decision {k} — {title}
**What.** …
**Why this is a real decision.** … {constraints by ID; consequences per branch}
**The options{, verbatim from {source}}:** … {blockquoted texts + one trade-off line each; recommendation labeled}
**How to decide.** {one concrete test; allowed hybrids}

## N+2. How the rest runs (after the decisions)
{numbered post-decision sequence}

## N+3. What is NOT on the table
{settled decisions fenced by ID; adjacent calls explicitly out of scope}
```

## 6. Acceptance criteria (for the build session)

1. Given a pointer to 2–5 pending decisions with option texts on disk, the command produces a report matching the template, passes `/qc-pass` with the verbatim-fidelity scope line, and contains zero pre-decided items.
2. The settled-decision fence cites real log IDs only.
3. Re-running on the two marketing-positioning production instances' inputs would reproduce their structure (regression sanity check, not byte-match).
4. Frontmatter `model: opus`; command registered in the commands listing; CATALOG/docs touchpoints per `/create-skill` pipeline.
