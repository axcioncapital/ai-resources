---
description: Route a rough idea to the command that owns its next step. Distils a pasted dump (ChatGPT export, brainstorm) into an Idea Brief, checks workspace evidence, classifies the idea's domain, generates 2–4 distinct leverage options, and hands the recommended one to its lifecycle owner with a self-contained payload — or PARKs it. Writes analysis to audits/working/ (supporting evidence), a Resource Brief to inbox/ on the new-AI-resource route, and a pending entry to logs/improvement-log.md on PARK. Applies no other change.
model: opus
argument-hint: "[pasted idea dump / notes, or a path to a notes file — leave blank to use the pasted block]"
---

# /leverage-idea — idea dump → leverage options → verdict → handoff to the owner

Take a messy idea dump and land it with **the command that owns its next step**. The pipeline distils the dump into a clean Idea Brief, checks whether the workspace shows real evidence of the need, investigates where the idea could attach, classifies which **domain** it belongs to, generates 2–4 **distinct** leverage options, and recommends one — then hands it over.

**An idea leaves this command in someone's hands.** Every run ends in one of two states: a **named owner** (an exact existing command, with a payload it can act on) or a **terminal outcome** (reuse as-is, `/tweak`, or PARK with a concrete review trigger). A run that ends in a plan and no owner has not finished. This command still applies no change to the system itself — handing over is not executing.

**Where the routes go.** `/leverage-idea` is idea-first and owner-finding; the commands it routes to are need-first or already-decided. Reach for it when you have rough notes and do not yet know who owns them.

- `/tech-consult` — a broad business or project need with no solution yet. This command *routes to* it; it is not a wall.
- `/work-loop-v2` — an operating capability inside a project that already exists, or a settled correction to something that exists. It sizes the work itself on arrival.
- `/scope-project` — a new enduring programme, or work no existing owner fits.
- `/develop-ai-resource` — any new or materially expanded durable AI resource, of **every** class.
- `/implementation-triage` — judges an *already-proposed* implementation; `/leverage-idea` *produces* the proposal, and the operator may chain triage for an independent ROI read.
- `/request-skill` — intake-only, no investigation. Use it to capture a brief when no investigation is wanted.
- Codex `$resolve-repository-problem` — specific repository faults, not ideas.

Input: `$ARGUMENTS` — the idea dump itself (pasted notes, a ChatGPT export), or a path to a notes file. If empty, use the most recent pasted block in the conversation. If nothing is present, ask the operator for the notes and stop.

---

## Step 0 — Input and repo resolution + multi-idea split

1. Resolve the raw notes: `$ARGUMENTS` verbatim if it is prose; if it is a readable file path, Read that file; if empty, use the most recent pasted idea block in the conversation. If no notes can be found, emit `/leverage-idea needs an idea dump — paste your notes or give a file path.` and stop.

2. **Resolve `AI_RESOURCES` from the session, never from a fixed path** — before any step reads or writes. Several worktrees of this repository are live at once (`git worktree list`), so a pinned absolute path makes a session on one branch read and write another's tree, including the Step 2 duplicate scan and the Step 8 PARK append. Resolve in this order and stop at the first that succeeds:

   a. **Session is inside an ai-resources worktree.** Take `git rev-parse --show-toplevel` from the session directory. If that directory contains **both** `skills/ai-resource-builder/SKILL.md` and a **regular-file** (not symlink) `.claude/commands/leverage-idea.md`, set `AI_RESOURCES` to it. Those two together identify the canonical repo rather than a project that symlinks it.

   b. **Session is a project.** Walk up from the session directory to the nearest ancestor holding **both** `ai-resources/` and `projects/` — the workspace root, the same idiom `auto-sync-shared.sh` and `/reconcile` use. Set `AI_RESOURCES = {that ancestor}/ai-resources`.

   c. **Neither resolves.** Emit `/leverage-idea cannot locate ai-resources from this session — run it from a project or from an ai-resources worktree.` and stop. **Do not fall back to a hardcoded path**; writing into the wrong worktree is the failure this step exists to prevent.

   State the resolved `AI_RESOURCES` in one line so a run from an unexpected tree is visible before anything is written.

3. Scan for **multiple distinct ideas**. If the notes carry more than one separable idea, pick the strongest to process now (decision-point posture — state the pick + the runner-up in one line each), and record the rest under `## Deferred Ideas` in the analysis file (Step 9). One idea → skip the split.

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

- **Duplicate gate.** Glob/grep `{AI_RESOURCES}/.claude/commands/` and `{AI_RESOURCES}/.claude/agents/`, and scan `{AI_RESOURCES}/skills/*/SKILL.md` frontmatter, for a resource that already does this. **Exact duplicate** → point the operator to the existing resource; end, write no files. If it needs a change to serve the idea, name the owner: `/improve-skill` for a skill, `/tweak` for a ≤1-file cosmetic edit, `/work-loop-v2` for a settled correction to a command, agent, script or hook — it sizes the correction itself, so a small reversible one becomes Direct Work rather than a tracked task. **Partial overlap** → carry it forward as a candidate "extend existing" attach point (do **not** short-circuit). This gate scans the Claude Code substrate only: for an idea that turns out not to be an AI resource it finds nothing, which is correct — Step 5a is where that idea gets its domain.
- **Triviality gate.** If the idea is a ≤1-file cosmetic change (wording, a single line), recommend `/tweak "..."`; end, write no files.

If either gate ends the run, report the routing in chat only.

## Step 3 — Path setup

`AI_RESOURCES` is already resolved (Step 0.2).

1. `DATE` = today (`YYYY-MM-DD`).
2. Compute `SLUG` from the Idea Brief's Core idea: lowercase, replace non-alphanumeric runs with a single `-`, strip leading/trailing `-`, truncate to 50 characters at a `-` boundary. If empty, fall back to `idea-{HHMMSS}`.
3. `ANALYSIS_PATH = {AI_RESOURCES}/audits/working/{DATE}-idea-{SLUG}.md`. If it already exists, append `-2`, `-3`, … until unique.
4. `NOTES_PATH = {AI_RESOURCES}/audits/working/{DATE}-idea-{SLUG}-investigation.md` (subagent working notes — internal plumbing; carry the same uniqueness suffix as `ANALYSIS_PATH`).

## Step 4 — Investigation (one general-purpose subagent, inline brief)

Spawn **one** general-purpose investigator subagent (fresh context) via the `Task` tool with the brief below, **pinning `model: opus` on the spawn**. It receives the **distilled Idea Brief only** — never the raw dump.

`general-purpose` carries no frontmatter, so an un-pinned spawn silently inherits the session model: this dispatch would run at Haiku on a Haiku session with no signal, and Part B's semantic near-duplicate sweep — the backstop for what Step 2's mechanical gate misses — is judgment work that degrades invisibly at a lower tier. Pinning per-dispatch is the permitted form (workspace `CLAUDE.md` § Model Tier carve-out; roster in `docs/agent-tier-table.md`).

```
You are an idea investigator. Gather evidence for a proposed idea and map where it could attach. You produce no recommendation and apply no change — investigation only. The idea may or may not be about the Claude Code substrate; do not assume it is, and do not steer findings toward a workspace-resource answer. Report what you find, including "this is not an AI-resource idea" when that is what the evidence shows.

IDEA BRIEF (distilled by the main session):
{the 5-field Idea Brief, including any [verify] workspace-assertion tags}

AI_RESOURCES: {AI_RESOURCES}
WORKSPACE: {the nearest ancestor of AI_RESOURCES holding both ai-resources/ and projects/ — the same walk-up as Step 0.2b, not simply AI_RESOURCES' parent, which is only correct while every worktree sits directly under the workspace root}

Procedure:

Part A — Use-case evidence. Search the workspace evidence logs for signs this need is real:
- {AI_RESOURCES}/logs/friction-log.md
- {AI_RESOURCES}/logs/improvement-log.md
- {AI_RESOURCES}/logs/defect-log.md
- {AI_RESOURCES}/logs/session-notes.md (recent blocks)
- recent {AI_RESOURCES}/audits/ report headers
Cite specific entries (date + one-line quote) or state "no evidence found" — never infer a use case that is not written down. Resolve each [verify] workspace-assertion tag: confirm or refute it against repo state, and say which.

Part B — Surface & attach points. Find what already touches this space and where the idea could attach (with paths). Search SEMANTICALLY — by capability and purpose, not just name-match. This is the backstop for near-duplicates a name-only scan misses. For each candidate attach point, give the path and one line on what it currently does.

Search BOTH, and say which produced each hit:
- {AI_RESOURCES} — the full command, skill and agent libraries, plus docs/.
- {WORKSPACE}/projects/ — each project's CLAUDE.md and its plan / roadmap / decisions files. An idea about a business capability, a programme or a domain decision attaches HERE, not in the resource library, and naming the owning project is the most useful thing you can return for one.

If the resource library yields nothing and a project does, say so plainly — that is a finding, not a gap.

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

## Step 5 — Domain, then leverage options (inline — the heart)

**5a. Classify the domain first.** The lever menu depends on it, and picking levers before the domain is settled is how a project or business idea gets forced through an AI-resource menu it does not fit. Name the domain in one line with the evidence that places it there; where two are arguable, name both and say which governs and why.

| Domain | The idea is… | Lever menu |
|---|---|---|
| **AI resource** | about the Claude Code substrate itself — a skill, command, agent, hook, CLAUDE.md rule, doc, script, prompt or persistent instruction | extend an existing resource (name it + attach point) · a new or materially expanded resource of any class · a bounded correction to one that exists · park |
| **Operating capability** | a business, operational or product ability inside a project that already exists | develop the capability in its owning project · extend an existing capability · park |
| **Project or programme** | new enduring work, or work no existing owner fits | scope it as a project · fold it into an existing project's roadmap · park |
| **Technical need** | a need with no solution chosen yet — the dump describes a problem, not a build | consult for a build-ready plan · adopt an existing tool or service · park |
| **Domain or content decision** | owned by a named project's subject matter (a framework, a methodology, a content call) | hand to the owning project · record it as a decision there · park |
| **Cross-tool** | belongs in GPT, Perplexity, Notion or NotebookLM rather than the Claude Code substrate | assign the tool explicitly (workspace cross-model rules) · park |

An inherently non-Claude idea carries its **tool assignment** in the option itself — name the tool that will do the work rather than letting a Claude Code build become the default answer.

A dump often carries more than one domain. Split it: process the strongest here and record the rest under `## Deferred Ideas` (Step 9), each with its own domain, so a deferred piece resumes with its owner already named.

**5b. Generate 2–4 distinct options** from the domain's lever menu. They must be different *levers*, not size variants of one lever. Where the domain's own menu offers fewer than two live levers, park is always the second.

Per-option block:
- **Shape** — 1–2 sentences: what it is + the attach point (cite a Step 4 path).
- **Fit** — how well it serves the Core idea.
- **Effort** — S / M / L.
- **Risk** — including the structural change class if one matches (per `ai-resources/docs/audit-discipline.md`: new command/skill, hook edit, cross-cutting CLAUDE.md, new symlink, shared-state automation).
- **Evidence** — cite the Step 4 use-case evidence, or mark "speculative".

End with one **Ranking** line ordering the options.

## Step 6 — Recommendation + verdict (inline)

State the recommended option and the main rejected alternative — one line each. Then a verdict, reusing `/implementation-triage` vocabulary:

- **WORTH-DOING** / **MARGINAL** / **NOT-WORTH-DOING**.

No workspace evidence does **not** auto-fail the verdict, but it must flag the value case as **speculative**. `MARGINAL`-with-no-evidence or `NOT-WORTH-DOING` → route to the PARK path (Step 8).

**Complexity-budget cap (enforcement, not advisory).** If the recommended option introduces a **new component** — a new command, agent, mandatory stage/gate, or permanent always-loaded doc — it must clear the complexity-budget gate (`docs/ai-resource-creation.md` rule #7): at least one of prong (a) net-simplification or prong (b) cited-evidence, and, for a new *detection* component, a named closure channel. An option that fails the gate is **capped at `MARGINAL`** — this cap is an explicit gate action (OP-5 enforcement), so state it as such: name the failed prong and, if the operator still wants to build, require the OP-11 waiver in `logs/decisions.md`. An extend-existing option (no net-new component) is not subject to the cap.

**The cap survives the route — no handoff is a way around it.** The gate keys on whether the *recommended option* introduces a new component, not on which command receives it. Routing a new-component option to `/work-loop-v2`, `/scope-project`, `/tech-consult` or a project owner does not exempt it: apply the cap here, and carry the failed prong into the Step 7 payload so the receiving command inherits the finding rather than meeting the proposal clean. Routes into non-`ai-resources` domains still take the cap when the option would add an `ai-resources` component; a purely project-local artifact (a project `output/` deliverable, a decision record) is not a load-bearing unit under rule #7 and is not capped.

**This is a routing verdict, not a context-isolated ROI certification** — it is self-generated by the same reasoning that built the options. For a big or contested call, the operator can chain `/implementation-triage` for an independent ROI read. State this line in the output.

## Step 7 — Handoff payload (skip on PARK)

For a WORTH-DOING (or operator-accepted MARGINAL) recommendation, write the plan **and** the payload that carries it to its owner.

**The plan:**

- **Target files** — what gets created / edited.
- **Step sequence** — the build order.
- **Review** — if the implementation falls in a change class (`ai-resources/docs/audit-discipline.md` § Structural change classes), it is high-consequence and takes **one** risk-aware review before landing (`docs/qc-independence.md` § The rule). One review, not a stack.
- **Effort** — S / M / L.
- **Open assumptions** — anything the operator must confirm.

**The payload — self-contained, by the standard below.** `{ANALYSIS_PATH}` sits under `audits/working/`, which is **gitignored** (`.gitignore`) and does not survive as a shared address. It is supporting evidence, never the next-action address. So the payload must carry everything the receiving command needs to start:

> **A payload is self-contained when the receiving command can act on it without opening `{ANALYSIS_PATH}`.** Test it by reading the payload alone and asking what the receiver would have to go looking for. Anything it would have to fetch belongs inside the payload.

That means, in every payload: the Core idea and the problem it solves; the domain from Step 5a; the recommended lever and the rejected alternative; the verdict, with the evidence cited *inline* (a date plus the quoted line, not a pointer to the analysis file) or marked speculative; any complexity-budget finding; and the specific ask of the receiving command. Cite `{ANALYSIS_PATH}` at the foot as supporting detail.

Emit the payload as a fenced block the operator pastes into the named command. Where the receiving command defines its own input shape, use that shape:

- **New or materially expanded AI resource** → `/develop-ai-resource`, in the `/request-skill` brief shape (`# Resource Brief:` name / Requested / Origin / Capability / Trigger Conditions / Exclusions / Context / Existing Skills Reviewed). **Render Capability as the `## Capability` heading, exactly as `/request-skill` does — never as a `**Capability:**` bold label.** That label is one of two reserved upstream-provenance fields, and `/develop-ai-resource` Step 1.0 reads a brief carrying exactly one of them as a **malformed upstream handoff**. A brief from here has no upstream capability record, so the heading form is what makes it read correctly as the ordinary raw brief it is. **Write it to `{AI_RESOURCES}/inbox/{DATE}-{SLUG}.md`** (append `-2`, `-3`, … if that path is taken — never overwrite a brief awaiting a decision) — the tracked intake queue is this route's durable address, and it is what lets the route survive the session ending. Say in chat that it was written and give the path. The brief carries no `**Mechanism:**` / `**Evidence:**` field, so it is **raw by construction** — that is expected, and it is what `/develop-ai-resource` supplies. `inbox/` drains by its own convention: `/develop-ai-resource` archives the brief to `inbox/archive/` with a one-line disposition on any of no build, reuse as-is, rejection or deferral, so a written brief cannot sit there unresolved.
- **Operating capability** → `/work-loop-v2`, as a unit brief naming the capability and its owning project. Work Loop v2 owns the operating outcome from here. If that work later turns out to need a durable AI artifact that does not exist, Work Loop v2 routes *that* question to `/develop-ai-resource` when it arises — so name one owner here, not both.
- **Project or programme** → `/scope-project`, as the raw material plus the domain finding.
- **Technical need** → `/tech-consult`, as the need statement — a need, deliberately not a solution.
- **Settled skill improvement** → `/improve-skill`, naming the skill, the improvement and why the mechanism is already settled.
- **Bounded correction to something that exists** → `/work-loop-v2` for a settled correction, or `/tweak` when it is ≤1-file cosmetic. Hand it over sized as a correction and let Work Loop v2 admit it: a small reversible correction is done as Direct Work and opens no state file, and only a correction meeting its named-reason bar opens a Standard unit. That sizing is Work Loop v2's to make on its own test — do not restate the test or pre-decide it here.
- **Named project or domain owner** → the owning project's session. There is no command to name, so the payload *is* the address: state the owning project and, where the ask is a multi-field gap that blocks that project, shape the payload as a requirements doc for its `output/` (workspace `CLAUDE.md` § Requirements-Doc Default). If the operator will not act now, PARK it instead — an unowned payload is not a handoff.
- **Cross-tool** → the assigned tool, with the prompt or brief that tool needs.

**Completion criterion for this step:** the payload names an exact existing command (or a named project owner), and passes the self-contained test above. **Stop here — handing over is not executing.**

## Step 8 — PARK path

For a PARK outcome, append one `logged (pending)` entry to `{AI_RESOURCES}/logs/improvement-log.md` using its schema:

```
### {DATE} — {short idea title}

- **Status:** logged (pending)
- **Category:** {the Step 5a domain} (leverage-idea PARK)
- **Severity:** {low | medium | medium-high | high | critical}
- **Review-cycle:** reviewed {DATE}, deferred to → {concrete trigger — a date, a quarter, or a named event}
- **Friction source:** {the idea + why it is parked rather than built now}
- **Proposal:** {the parked idea in 2–4 sentences; note the strongest leverage option for if it is revisited}
- **Target files:** {likely attach point(s) if built later}
- **Notes:** analysis — {ANALYSIS_PATH}
```

**`Severity:` is mandatory, and it is independent of parking.** A parked idea still carries its true severity — deferral is expressed by `Review-cycle:`, never by omitting or deflating `Severity`. The field has a machine consumer: the wrap-time promotion sweep (`logs/scripts/promote-findings.sh`) anchors on `**Severity:**` and queues only `high` / `medium-high` / `critical` / `urgent` entries into `logs/next-up.md`, which `/prime` Step 2 renders as task-menu candidates, so a PARK entry written without it is **unreachable** rather than merely low-priority. This path has already shipped one such entry (`2026-07-21 — PowerPoint production capability`). Vocabulary: `logs/improvement-log.md` § Schema.

The `Review-cycle:` trigger is a **hard requirement, not a guideline** — it must be concrete (a date, a quarter, or a named event), never "later"/"someday". A park with no real trigger never drains, and `/resolve-improvement-log` Step 3b rejects a vague trigger. This shape matches the schema `/resolve-improvement-log` archives against.

## Step 9 — Write the analysis file

Write `{ANALYSIS_PATH}` — the **working record**: the reasoning behind the recommendation, kept for a reader who wants to audit how the verdict was reached. It is supporting evidence. The next action lives in the Step 7 payload and the Step 8 PARK entry, both of which stand on their own.

```
# Leverage-Idea Analysis — {idea title} — {DATE}

## Idea Brief
{the 5 fields}

## Domain
{the Step 5a classification + the evidence placing it there}

## Evidence Findings
{from the Step 4 summary — do not re-read the full notes}

## Repo Surface
{candidate attach points from Step 4}

## Leverage Options
{the 2–4 option blocks + Ranking}

## Recommendation & Verdict
{recommended + rejected alternative + verdict + the routing-not-ROI line}

## Handoff   — or —   ## Park Rationale
{the Step 7 plan + payload and where the payload was sent, or the PARK rationale + concrete Review-cycle trigger}

## Deferred Ideas
{any ideas split off in Step 0 — each with its own domain — omit this heading if none}

---
Investigation notes: {NOTES_PATH}
```

## Step 10 — Chat report + owner

Print to chat:
- The verdict line, and the Step 5a domain.
- Recommended option + rejected alternative (one line each).
- Exactly **one** row from the table below — the owner, and where the payload went.
- `Supporting analysis: {ANALYSIS_PATH}` — last, and labelled as supporting. It is gitignored; it is not the address.

The handoff never auto-invokes. It names who owns the next step and hands them what they need; the operator makes the call.

| Outcome | Owner | What goes with it |
|---|---|---|
| **New or materially expanded AI resource — *any* class**: skill, command, agent definition, hook, CLAUDE.md rule, doc, script, reusable prompt, persistent instruction | `/develop-ai-resource` | Resource Brief written to `{AI_RESOURCES}/inbox/{DATE}-{SLUG}.md` — give the path. Raw by construction (no `**Mechanism:**`/`**Evidence:**`); that command supplies both. It qualifies the need and hands a qualified brief to `/create-skill` for a skill, or builds directly for the other classes. |
| **Operating capability** in an existing project | `/work-loop-v2` | The Step 7 payload — the capability and its owning project. It owns the operating outcome; a later durable-artifact question is its to route on, not a second owner named here |
| **Project or programme** | `/scope-project` | The Step 7 payload — raw material + the domain finding |
| **Technical need, no solution chosen** | `/tech-consult` | The Step 7 payload — the need, stated as a need |
| **Settled skill improvement** | `/improve-skill` | The skill, the improvement, and why the mechanism is settled |
| **Bounded correction to something that exists** | `/work-loop-v2` (settled correction) or `/tweak` (≤1-file cosmetic) | The Step 7 payload. Work Loop v2 sizes it on arrival: small and reversible is Direct Work with no state file; only a correction needing a named reason opens a Standard unit |
| **Domain or content decision** | the named owning project | The Step 7 payload, or a requirements doc for that project's `output/` |
| **Cross-tool** | the assigned tool | The prompt or brief that tool needs |
| **Reuse as-is** (Step 2 duplicate) | *terminal* | The existing resource named in chat; `/improve-skill` if it needs a change |
| **Tiny tweak** (Step 2 triviality) | *terminal* | `/tweak "..."` — chat only |
| **PARK** | *terminal* | Entry in `logs/improvement-log.md` with `Severity:` and a concrete `Review-cycle:` trigger |

**Every new durable AI resource goes through `/develop-ai-resource`, whatever its class.** Row 1 covers all of them by design: `docs/ai-resource-creation.md` rule #4 and workspace `CLAUDE.md` § AI Resource Creation put the whole class under that command, and a structural change class routing only to a risk review would send the change to a risk gate while skipping the question of whether the resource should exist. A risk-aware review is what the plan's own Gates line names when a class matches; it is not the owner.

Remind the operator to run `/wrap-session` if the work is complete.

---

$ARGUMENTS
