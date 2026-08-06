---
task: work-loop-v2-intake-router
turn: codex
---

## Objective and scope

Codex can receive an ordinary-language request, recognise the operator's current core capabilities,
and select exactly one appropriate route without requiring the operator to remember skill names.
When Work Loop v2 owns the request, Codex also classifies the active mode as Discovery,
Implementation or Adoption and records it inside `## Lane and unit`.

The router must cover the operator's current core skills, including every relevant skill in the
installed Matt Pocock stack. It must not preserve the earlier proposed nine-route list: the operator
has explicitly said that several of those commands are outdated and no longer used.

This task closes only when the current inventory and routing boundaries are established, the router
is implemented from that evidence, and representative ordinary-language cases can expose a wrong
route. Unit 1 is discovery only; it changes no router or protocol artifact.

## Lane and unit

Standard. Discovery mode. Unit 1 — establish the authoritative current skill inventory, classify
which capabilities are genuine intake routes versus supporting or setup skills, and recommend the
smallest maintainable router shape.

Named reason for the loop: the operator corrected a load-bearing premise after the first brief was
written. Implementing from the stale list would encode unused commands and omit current core skills;
the true inventory and ownership boundaries must be evidenced before implementation.

Plan justification: this discovery directly resolves the requirement and ownership uncertainty now
blocking the requested Work Loop v2 router. The operator's instruction to start this task remains a
task-specific exception to the mission's no-self-hosting rule, not a standing exception.

## Brief

The previous brief treated nine selected Axcíon routes as an accepted catalogue. The operator
rejected that premise, reviewed Codex's replacement command classification, and approved the router
behaviour and candidate set below. Establish the live inventory, verify the approved routing
classification against current definitions, and recommend the maintainable router shape; then hand
back without implementing.

### Governing operator decisions

1. The earlier nine-route list is superseded and non-governing:
   Direct Work · Work Loop v2 · `/leverage-idea` · `/scope-project` · `/develop-ai-resource` ·
   `/resolve-repo-problem` · `/project-next-steps` · `/consult` · `/pm`.
   Do not assume any named command in that list remains a current core route.
2. At minimum, the router must account for every relevant installed Matt Pocock skill.
3. The final list must include all of the operator's current core skills, not a hand-picked sample.
4. Preserve one-owner routing. A skill flow may contain several phases, but an intake result must
   not invent a default stack of simultaneous owners.
5. Discovery, Implementation and Adoption remain the three Work Loop modes. Mode stays inside
   `## Lane and unit`; no new state field is created.
6. Unit 1 returns evidence and a recommendation only. It must not edit the Work Loop skill, core,
   harness, Claude command, user-level skill installations or any capability catalogue.
7. Exclude these installed design/motion skills from the router's core list:
   `animation-vocabulary`, `apple-design`, `emil-design-eng`, `find-animation-opportunities`,
   `improve-animations`, and `review-animations`.
8. The Axcíon personal-command classification below is approved. Verify its factual boundaries but
   do not reopen its membership merely because other commands remain installed.

### Verify-first sources and known observations

- Inspect the installed Claude skill surface at `~/.claude/skills/*/SKILL.md`. The observed
  `ask-matt` skill describes itself as a router and currently organises the Matt stack into a main
  flow, on-ramps, codebase health, vocabulary, phase-boundary helpers, standalone skills and a setup
  precondition. Verify that observation and treat its current content as evidence about the
  installed Matt flow, not as authority over Axcíon.
- Inspect the installed Codex personal skill surface at `~/.codex/skills/*/SKILL.md` and compare it
  with the Claude surface. Record which skills exist on both sides, only on Claude, or only on
  Codex, and which carry `disable-model-invocation: true`.
- Inspect the repo-local Codex surface at `.agents/skills/*/SKILL.md`. Distinguish current general
  routing capabilities from project-specific source commands, the live v1 Work Loop, v2 and
  throwaway probes.
- Inspect `plans/work-loop-v2-mvp/README.md` § “Where the Playbook's named commands live.” The
  observed inventory there is older than the live Claude installation and says
  `diagnosing-bugs` was absent. Verify the drift; do not use that list as current truth.
- Inspect current skill descriptions rather than inferring use from folder names. A skill being
  installed establishes availability, not that it is a core intake route.
- Inspect `.claude/commands/*.md` as the live Axcíon personal-command surface. There are 88 command
  files at the current inspection. Distinguish an ordinary-language destination from a lifecycle
  phase, cadence command, session utility, deployment operation or explicit maintenance tool.
- The operator's approved command set establishes current intended use. Repository presence cannot
  promote another command into the router. If a current command definition materially contradicts
  the approved boundary, report the exact conflict rather than silently changing membership.

### Required discovery result

Return one concise proposed inventory with these classes:

1. **Primary intake routes** — capabilities that may directly own an ordinary-language request.
2. **Flow phases or supporting skills** — capabilities selected inside another owner or at a phase
   boundary, not competing top-level owners by default.
3. **Setup, corrective or vocabulary helpers** — discoverable and retained, but not normal first
   routes.
4. **Unavailable, legacy, duplicate or uncertain** — present in a stale document, only one product,
   duplicated under two names, or awaiting the operator's current-use decision.

The Matt inventory must reconcile every currently installed skill named by
`~/.claude/skills/ask-matt/SKILL.md`, including:

`ask-matt`, `code-review`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grill-me`,
`grill-with-docs`, `grilling`, `handoff`, `implement`, `improve-codebase-architecture`, `prototype`,
`research`, `resolving-merge-conflicts`, `setup-matt-pocock-skills`, `tdd`, `teach`,
`to-questionnaire`, `to-spec`, `to-tickets`, `triage`, `wait-what`, `wayfinder`, `wizard`, and
`writing-for-agents`.

Do not silently omit an installed Matt skill. If one is not relevant to intake routing, place it in
a supporting/helper class and state the boundary in one line.

The Codex inventory must also reconcile the current personal/core skill families observed under
`~/.codex/skills/`, including the engineering overlap above.

Also classify `work-loop-v2` from the repo-local surface. Identify any other live personal Codex
skill that the named sets missed. Keep platform-owned system and plugin skills separate from the
operator's personal/core list so the categories cannot be confused.

The operator explicitly excludes these installed design/motion skills from the router's core list:
`animation-vocabulary`, `apple-design`, `emil-design-eng`, `find-animation-opportunities`,
`improve-animations`, and `review-animations`. Their installation does not make them routing
candidates.

### Approved Axcíon personal-command set

Codex's current recommendation is to add these as ordinary-language destinations:

- **General work:** `/work-loop-v2`.
- **Durable resources and projects:** `/develop-ai-resource`, `/scope-project`, `/new-project`.
  `/new-project` is selected only when the need is sufficiently qualified; otherwise
  `/scope-project` owns the first move.
- **Orientation and advice:** `/project-next-steps`, `/consult`, `/pm`, `/tech-consult`,
  `/open-items`.
- **Faults and investigation:** `/resolve-repo-problem`, `/resolve-incident`, `/repo-dd`,
  `/analyze-workflow`, `/lean-repo`.
- **Value and outcome judgment:** `/implementation-triage`, `/reconcile`.

These remain visible specialist destinations when the request clearly names their narrower purpose,
but should not be generic fallbacks: `/audit-repo`, `/architecture-review`, `/systems-review`,
`/token-audit`, `/permission-sweep`, `/pipeline-review`, `/blindspot-scan`, `/contract-check`, and
`/expert-check`.

Do not add these as competing first routes:

- `/leverage-idea` — it is itself a router and would create router-within-router ambiguity; include
  neither it nor its route map in this router.
- `/create-skill`, `/improve-skill`, `/request-skill`, `/migrate-skill`, `/graduate-resource` —
  build or lifecycle phases under durable-resource work, not general intake owners.
- `/mission`, `/new-worktree-session`, `/close-worktree-session`, `/build-context`, `/handoff`,
  `/prime`, `/session-start`, `/session-plan`, `/save-session`, `/wrap-session`, `/usage-analysis`,
  `/drift-check`, `/concurrent-session-check` — state, transport or session-control machinery.
- `/friday-checkup`, `/friday-so`, `/friday-act`, `/friday-journal`, `/so-monthly`,
  `/monday-prep`, `/pipeline-review` — fixed-cadence operations; `pipeline-review` remains a
  narrow specialist destination above when explicitly requested.
- Deployment, migration, cleanup, logging and backlog-fix commands — explicit operations or
  downstream actions, selected after an owner has established the need rather than at broad intake.
- Conversational controls such as `/clarify`, `/decide`, `/recommend`, `/triage`, `/explain`,
  `/scope`, `/summary`, `/note`, `/grill-me` — operator controls or duplicate skill entry points,
  not enduring capability owners in this router.

### Questions the evidence must settle

1. Is `ask-matt` already the best source for the Matt portion of the route map, or would linking to
   it make the Codex router depend on a Claude-only user-home artifact?
2. Can all current core skills stay discoverable without copying their full procedures into the
   Work Loop skill?
3. Does the larger current inventory invalidate the earlier “no catalogue” recommendation? Compare
   a compact in-skill index, a small maintained catalogue, and reliance on live skill metadata.
   Recommend the smallest shape that is current across Codex and Claude and explain its drift risk.
4. Which entries are top-level owners, and which are phases, primitives, setup or corrective tools?
5. Do the live definitions support the approved Axcíon command boundaries? Report any factual
   collision or stale description without adding or removing membership.
6. How should one-owner selection interact with a Matt flow such as
   grill → prototype/spec/tickets → implement/TDD/review without pretending the whole flow is one
   simultaneous skill stack?
7. What exact implementation boundary remains before an Implementation-mode Unit 2 can be safely
   briefed?

### Required evidence

- Report the exact installed skill names and counts for both `~/.claude/skills/` and
  `~/.codex/skills/`, with the searched paths.
- Show the Claude-only, Codex-only and shared sets.
- Show the current `ask-matt` categories and account for every named skill once in the proposed
  routing classification.
- Identify stale claims in the Work Loop README by comparing them with the live installed surface.
- Identify duplicate or alias pairs such as wrapper versus primitive, without deleting or choosing
  between them.
- Demonstrate that the proposed inventory includes every named Matt skill and every current personal
  Codex skill; the check must fail when a name is omitted.
- Return a compact verified representation of the approved Axcíon set, with any factual definition
  conflict clearly separated rather than silently resolved.

### Scope and stop conditions

Allowed repository change: this state file only. Reading the named user-level skill directories is
allowed; changing them is not.

Excluded: implementing the router; editing any skill, command, core, harness, settings or
installation; creating a catalogue; changing the approved skill or command membership;
mode-contract implementation; tests; v1 retirement; broader v0.2 work.

Stop and hand back if the installed Matt inventory conflicts materially with `ask-matt`; a current
core list cannot be distinguished from merely installed skills; an authoritative source requires a
repository change; or a classification depends on operator preference. Report the smallest exact
question rather than guessing.

Completion: write the verified inventory, classifications, recommendation, unresolved operator
choices and evidence into `## Latest result`; keep repository artifacts unchanged except this state
file; commit the state-file handback; set `turn: codex`; stop. This is a discovery unit, so do not
implement the eventual router.

## Latest result

Inspected (2026-08-06):

- Claim (1) `~/.claude/skills/ask-matt/SKILL.md` exists and is a router with the described
  categories: HOLDS — read the file; frontmatter `name: ask-matt`,
  `description: "…A router over the skills in this repo."`, `disable-model-invocation: true`;
  section headings found are exactly `The main flow: idea → ship`, `On-ramps`, `Codebase health`,
  `Vocabulary underneath`, `Phase boundaries`, `Standalone`, `Precondition`.
- Claim (2) a personal Codex skill surface exists at `~/.codex/skills/*/SKILL.md`: HOLDS — listed
  `~/.codex/skills/`; 19 directories, 19 `SKILL.md` files.
- Claim (3) the repo-local Codex surface at `.agents/skills/*/SKILL.md` mixes general capability,
  project-specific source commands, live v1, v2 and throwaway probes: HOLDS — listed
  `.agents/skills/`; 7 directories, 7 `SKILL.md`: `work-loop` (v1), `work-loop-v2`, `wl2-probe`
  (self-describes `Throwaway Step 2 transport probe. Delete me.`), and four
  `source-command-{explore-section,friday-so,refresh-project-state,so-monthly}`.
- Claim (4) `plans/work-loop-v2-mvp/README.md` § "Where the Playbook's named commands live" is
  stale and says `diagnosing-bugs` was absent: HOLDS, and the drift is confirmed real — grepped the
  README, line 78 reads "**`diagnosing-bugs` is the one exception — not found**" (verified
  2026-08-01) and lists 11 present skills; `~/.claude/skills/diagnosing-bugs/SKILL.md` **now
  exists**, and the live count is 25, so the README is short by 14 names and wrong on
  `diagnosing-bugs`. The README is evidence of the past, not current truth. Not implemented — the
  brief excludes editing it.
- Claim (5) `.claude/commands/*.md` holds 88 command files: HOLDS for `ai-resources/.claude/commands`
  — counted 88 `.md`. **Boundary correction, not a false claim:** a second Axcíon command surface
  exists at workspace-root `.claude/commands/` with 63 `.md`, of which 57 are symlinks back into
  `ai-resources` and 6 are root-only real files. Distinct Axcíon commands = **94**, not 88.
- Claim (6) `ask-matt` names 25 skills and they are the installed Matt stack: HOLDS — the 25 names
  the brief lists are exactly the 25 directories under `~/.claude/skills/`; set difference in both
  directions is empty.
- Claim (7) the six design/motion skills are installed: HOLDS with a side correction — all six are
  installed on the **Codex** side only (`~/.codex/skills/`); searched `~/.claude/skills/` for each
  of the six, no match. They are Codex-only, so excluding them costs the Claude side nothing.
- Claim (8) every command in the approved / specialist / excluded lists exists as named: HOLDS —
  tested all 26 approved-plus-specialist names and all 33 excluded names for
  `ai-resources/.claude/commands/<name>.md`; every one resolved, none missing, none root-only.

### Inventory A — `~/.claude/skills/` (searched path, 25 skills, 25 `SKILL.md`)

`ask-matt`(DMI) · `code-review` · `codebase-design` · `diagnosing-bugs` · `domain-modeling` ·
`grill-me`(DMI) · `grill-with-docs`(DMI) · `grilling` · `handoff`(DMI) · `implement`(DMI) ·
`improve-codebase-architecture`(DMI) · `prototype` · `research` · `resolving-merge-conflicts` ·
`setup-matt-pocock-skills`(DMI) · `tdd` · `teach`(DMI) · `to-questionnaire`(DMI) · `to-spec`(DMI) ·
`to-tickets`(DMI) · `triage`(DMI) · `wait-what`(DMI) · `wayfinder`(DMI) · `wizard` ·
`writing-for-agents`

`(DMI)` = `disable-model-invocation: true` — operator-invoked only, never auto-selected. 14 of 25.

### Inventory B — `~/.codex/skills/` (searched path, 19 skills, 19 `SKILL.md`)

`animation-vocabulary` · `apple-design` · `code-review` · `domain-modeling` · `emil-design-eng` ·
`grill-me`(DMI) · `grilling` · `implement`(DMI) · `find-animation-opportunities` ·
`improve-animations` · `prototype` · `research` · `review-animations`(DMI) ·
`setup-matt-pocock-skills`(DMI) · `tdd` · `teach`(DMI) · `to-spec`(DMI) · `to-tickets`(DMI) ·
`wayfinder`(DMI)

### Inventory C — set comparison (the load-bearing finding)

**Shared (13):** `code-review`, `domain-modeling`, `grill-me`, `grilling`, `implement`, `prototype`,
`research`, `setup-matt-pocock-skills`, `tdd`, `teach`, `to-spec`, `to-tickets`, `wayfinder`.

**Claude-only (12):** `ask-matt`, `codebase-design`, `diagnosing-bugs`, `grill-with-docs`,
`handoff`, `improve-codebase-architecture`, `resolving-merge-conflicts`, `to-questionnaire`,
`triage`, `wait-what`, `wizard`, `writing-for-agents`.

**Codex-only (6):** the six operator-excluded design/motion skills, and nothing else.

**The asymmetry is the discovery.** Codex — the actor the router is meant to run in — cannot invoke
12 of the 25 Matt destinations, including `ask-matt` itself. `ask-matt`'s described main flow starts
at `grill-with-docs` (Claude-only) and both its on-ramps, `triage` and `diagnosing-bugs`, are
Claude-only. On the Codex side the flow degrades to `grill-me → to-spec → to-tickets → implement →
tdd → code-review`, with no stateful grilling, no issue-triage on-ramp and no bug-diagnosis on-ramp.

### Inventory D — repo-local Codex surface `.agents/skills/` (7)

- `work-loop-v2` (190 lines) — the Codex half of this loop; already carries a **Routing** section
  answering "who owns the next move?" with three answers (operator / specialist workflow / the Work
  Loop). **This is the router's true insertion point** — the router extends this section, it does
  not become a new skill.
- `work-loop` (119 lines) — live v1. Legacy, being superseded; the only `.agents` file referencing
  `.claude/commands`.
- `wl2-probe` — throwaway, self-marked for deletion.
- `source-command-explore-section`, `source-command-friday-so`,
  `source-command-refresh-project-state`, `source-command-so-monthly` — project-specific Codex ports
  of 4 of the 94 Axcíon commands. Not general routing capability.

### Inventory E — Axcíon command surface (94 distinct)

- `ai-resources/.claude/commands/` — 88 `.md`. The canonical surface.
- workspace-root `.claude/commands/` — 63 `.md`; 57 symlinks into ai-resources, plus 6 root-only
  real files: `harness-start` (Agent Harness session launcher), `session-report` (harness end-of-
  session report), `resolve-improvements` (archives `improvement-log.md`), `run-qc`
  (`/run-qc {workflow-file}`), `update-md` (edits workspace CLAUDE.md), `validate` (validates an
  analytical output). None appears in any of the brief's three lists.

### Platform-owned skills — kept separate, and unenumerable

`~/.claude/plugins/` contains only an empty `marketplaces/`; no plugin `SKILL.md` exists;
`~/.claude/commands/` is empty. The harness-supplied skills visible in a live Claude session
(`dataviz`, `update-config`, `keybindings-help`, `simplify`, `fewer-permission-prompts`, `loop`,
`schedule`, `claude-api`, `run`, `init`, `review`, `security-review`) exist on **no scannable disk
surface**. They therefore cannot be confused with the personal/core list — but equally, a Codex-side
router cannot enumerate them by inspection. They stay out of the router.

### The four required classes

**Class 1 — Primary intake routes (may directly own an ordinary-language request).**

*Axcíon (16, the approved set, all verified present):* `/work-loop-v2` · `/develop-ai-resource` ·
`/scope-project` · `/new-project` · `/project-next-steps` · `/consult` · `/pm` · `/tech-consult` ·
`/open-items` · `/resolve-repo-problem` · `/resolve-incident` · `/repo-dd` · `/analyze-workflow` ·
`/lean-repo` · `/implementation-triage` · `/reconcile`.

*Matt (13)* — *(C)* marks the seven that are **Claude-side only**: Codex may select them and must
then say the work runs Claude-side.

`grill-with-docs` *(C)* (idea, repo present) · `grill-me` (idea, no repo) · `wayfinder` (fog
too big for one session) · `diagnosing-bugs` *(C)* (something broken) · `triage` *(C)* (unowned
issues piling up) · `implement` (build from spec/ticket) · `prototype` (design question needing a
runnable answer) · `research` (reading legwork) · `resolving-merge-conflicts` *(C)* (already
mid-conflict) · `wizard` *(C)* (steps only a human can take) · `to-questionnaire` *(C)* (the
knowledge is in someone else's head) · `teach` (learn a concept) ·
`improve-codebase-architecture` *(C)* (the codebase is getting hard to work in).

`improve-codebase-architecture` is a **primary route, not an edge case** — the earlier draft left it
counted out of the 12 while calling it a route, and that ambiguity is corrected here. Evidence:
`~/.claude/skills/improve-codebase-architecture/SKILL.md` carries `disable-model-invocation: true`,
so it is entered by the operator and never auto-selected, and `ask-matt` files it under its own
top-level heading `Codebase health` — "run whenever you have a spare moment", not inside another
skill. That it then *generates* an idea which enters the main flow at `grill-with-docs` is a
hand-off at its own phase boundary, exactly like `wayfinder` handing to `to-spec`; handing onward is
what an owner does at the end of its turn, not what makes it a phase of someone else's.

Class-1 count after this correction: **16 Axcíon + 13 Matt = 29 primary intake routes.**

**Class 2 — Flow phases or supporting skills (selected inside an owner or at a phase boundary).**

*Matt (6), each with its direct-use boundary — the one case where the operator may enter it head-on:*

- `to-spec` — phase after grilling or wayfinder. **No direct entry:** it collapses an existing
  thread or decision map; with neither in hand there is nothing to collapse.
- `to-tickets` — phase after `to-spec`. **No direct entry:** it splits an existing spec.
- `tdd` — driven inside `implement`. **Direct entry:** one concrete behaviour, built test-first,
  with no spec behind it.
- `code-review` — closes `implement`. **Direct entry:** an explicit branch or PR reviewed against a
  fixed point.
- `grilling` — the interview primitive under `grill-me`, `grill-with-docs`, `triage`, `wayfinder`
  and `improve-codebase-architecture`. **Direct entry:** the interview with no wrapper and no
  artifact wanted.
- `handoff` *(Claude-side only)* — phase-boundary transport. **Direct entry, narrow:** a new
  harness, a new directory, a colleague, or forking a side task mid-phase.

*Axcíon lifecycle phases:* `/create-skill` · `/improve-skill` · `/request-skill` · `/migrate-skill`
· `/graduate-resource`.

*Axcíon specialist destinations* — reachable when the request names their narrow purpose, never a
generic fallback: `/audit-repo` · `/architecture-review` · `/systems-review` · `/token-audit` ·
`/permission-sweep` · `/pipeline-review` · `/blindspot-scan` · `/contract-check` · `/expert-check`.

**Class 3 — Setup, corrective or vocabulary helpers (retained, discoverable, not first routes).**

*Matt (6), with direct-use boundaries:*

- `setup-matt-pocock-skills` — run-once precondition before the first engineering flow. **Direct
  entry:** first-time setup only.
- `domain-modeling` — the domain-language layer underneath. **Direct entry:** when the *words* are
  the problem — a fuzzy term, an overloaded word, a decision to record as an ADR.
- `codebase-design` *(Claude-side only)* — the deep-module vocabulary layer. **Direct entry:** when
  designing one module's shape and the vocabulary, not the process, is what is missing.
- `writing-for-agents` *(Claude-side only)* — reference. **Direct entry:** writing a skill,
  AGENTS.md, or a doc an agent will consume.
- `wait-what` *(Claude-side only)* — mid-conversation corrective. **Direct entry:** inside any other
  skill, when the last message did not land.
- `ask-matt` *(Claude-side only)* — the Matt router itself. **No entry from this router:** naming it
  as a destination would nest routers, exactly the ground on which `/leverage-idea` was excluded.

*Axcíon conversational controls:* `/clarify` · `/decide` · `/recommend` · `/triage` · `/explain` ·
`/scope` · `/summary` · `/note` · `/grill-me`.
*Axcíon session machinery:* `/mission` · `/new-worktree-session` · `/close-worktree-session` ·
`/build-context` · `/handoff` · `/prime` · `/session-start` · `/session-plan` · `/save-session` ·
`/wrap-session` · `/usage-analysis` · `/drift-check` · `/concurrent-session-check`.
*Axcíon fixed cadence:* `/friday-checkup` · `/friday-so` · `/friday-act` · `/friday-journal` ·
`/so-monthly` · `/monday-prep`.

**Class 4 — Unavailable, legacy, duplicate or uncertain.**

- *Not invocable from Codex:* the 12 Claude-only Matt skills in Inventory C. This is a **marker that
  crosses the other three classes, not a fourth membership** — each of the 12 keeps its single
  Class 1/2/3 place above and additionally carries `Claude-side only`. Treating "Codex cannot run
  it" as a class of its own is what would have dropped them from the router (finding 2, choice 2).
- *Excluded by the operator:* the six Codex-only design/motion skills.
- *Legacy / throwaway:* `.agents/skills/wl2-probe` (marked for deletion) · `.agents/skills/work-loop`
  (v1, being superseded) · `/save-session` (its own file opens "**Deprecated — use `/handoff`
  instead.**", yet the brief lists it among session machinery — consistent, but it is dead weight).
- *Name collisions — same trigger word, two different definitions* (see below).
- *Wrapper/primitive pairs, neither deleted nor chosen between:* `grill-me` / `grill-with-docs` over
  `grilling`; Axcíon `/grill-me` over `skills/grill-me/SKILL.md`; `tdd` and `code-review` as both
  standalone skills and phases inside `implement`.
- *Router-shaped, excluded:* `/leverage-idea` (verified: "Route a rough idea to the command that
  owns its next step") and `ask-matt`.
- *Present but unapproved, excluded:* the 6 workspace-root-only commands in Inventory E
  (`harness-start`, `session-report`, `resolve-improvements`, `run-qc`, `update-md`, `validate`).
  Recorded so membership can be reopened deliberately; presence alone does not promote them.
- *Stale:* the README inventory (claim 4).

### The three name collisions — reported, not resolved

Each name resolves to two different definitions in a live Claude session. The router cannot name
these without saying which it means.

| Name | Axcíon `.claude/commands/` | Matt `~/.claude/skills/` |
|---|---|---|
| `grill-me` | Pre-plan interview producing a **structured mandate brief**; delegates to `skills/grill-me/SKILL.md` | Stateless relentless interview; saves nothing |
| `handoff` | **Session** state save, or fork a scoped child session | Compact the conversation into a **portable file** for another agent |
| `triage` | Independent review of **suggestions Claude just proposed** | Move **incoming issues and PRs** through a triage state machine |

`triage` is the worst: the two meanings do not overlap at all. Which one wins at a bare `/triage` is
a harness precedence question that file inspection cannot settle — **and the router does not need it
settled, because the router never writes a bare name.** Applying the governing decisions, each
colliding entry is named by product plus purpose:

| Router label | Resolves to |
|---|---|
| `Axcíon /triage — review the suggestions Claude just proposed` | `ai-resources/.claude/commands/triage.md` |
| `Matt triage — move incoming issues and PRs to agent-ready` | `~/.claude/skills/triage/SKILL.md` |
| `Axcíon /handoff — save session state, or fork a scoped child session` | `ai-resources/.claude/commands/handoff.md` |
| `Matt handoff — compact this thread into a portable file for another agent or directory` | `~/.claude/skills/handoff/SKILL.md` |
| `Axcíon /grill-me — pre-plan interview producing a structured mandate brief` | `ai-resources/.claude/commands/grill-me.md` |
| `Matt grill-me — stateless relentless interview, saves nothing` | `~/.claude/skills/grill-me/SKILL.md` |

One caveat carried forward rather than resolved: Axcíon `/grill-me` **delegates to**
`~/.claude/skills/grill-me/SKILL.md`, so those two are wrapper and primitive rather than rivals —
the label still distinguishes them, because what the operator gets back differs (a mandate brief
versus nothing saved).

### Answers to the seven questions

1. **`ask-matt` as the Matt source — no, not for a Codex-hosted router.** It is Claude-only, it is
   `disable-model-invocation: true` (so Codex could not invoke it even if installed), and 12 of the
   25 skills it maps do not exist on the Codex side. Linking to it would make the router depend on a
   Claude-only user-home artifact *and* advertise destinations Codex cannot reach. Its *content* is
   excellent evidence about the Matt flow — which is how this unit used it — and should be read at
   authoring time, not linked at runtime.
2. **Yes — discoverability does not require copying procedures.** Every skill and command carries a
   `description:` line that already states when to reach for it. The router needs the trigger
   condition and the name, never the method. Copying procedure would also fork the Axcíon rule that
   skills are edited only in `ai-resources`.
3. **The larger inventory does not invalidate "no catalogue" — it sharpens why.** Comparing the
   three shapes: *live skill metadata* is always current but Codex cannot read the Claude-only 12 or
   the platform skills at all, so it cannot be the whole answer; *a maintained catalogue* would be a
   94+25-entry file drifting from two directories and 94 command files, which is a maintenance
   liability with no owner; *a compact in-skill index* — trigger conditions and names only, inside
   `work-loop-v2/SKILL.md`'s existing Routing section — is the smallest shape that is current across
   both products. **Recommendation: a compact in-skill index inside `work-loop-v2/SKILL.md`'s
   existing Routing section — trigger conditions and names only, never procedures.**

   The earlier draft scoped that index to Class 1 only. That was wrong and is corrected here: a
   Class-1-only index names 13 of the 25 installed Matt skills and silently drops the other 12, which
   is the omission governing decisions 2 and 3 forbid. **Every one of the 25 Matt skills is named
   and classified in the index**, in three groups:

   - **13 Matt primary routes** — may own an ordinary-language request outright.
   - **6 Matt phases/supporting skills** — each with the direct-use boundary stated in Class 2 above,
     so the operator can still enter `tdd`, `code-review`, `grilling` or `handoff` head-on in the one
     case where that is right, and knows when it is not.
   - **6 Matt helpers** — setup, vocabulary, corrective and the Matt router itself, each with its
     boundary from Class 3 above.

   One-owner routing is preserved by the shape of the entry, not by shortening the list: a
   supporting skill's line states the condition under which it may be entered directly, and every
   other line routes to a flow's **entry** rather than its stack (answer 6).

   On the Axcíon side the index stays at the approved sets — **16 primary + 9 specialist = 25 named
   commands** — and does not expand toward 94. The remaining Axcíon classes (5 lifecycle phases, 9
   conversational controls, 13 session-machinery commands, 6 fixed-cadence commands) are named **by
   class in one line each**, so the router says why they are not routes without listing them.

   Index size after this correction: **50 named entries** (25 Matt + 25 Axcíon), of which 29 are
   primary intake routes, plus four one-line non-route class notes. That is larger than the
   28-entry draft and still far short of a catalogue: no procedure is copied, and nothing is
   duplicated from a command file beyond its trigger condition.

   Drift risk, stated plainly: a renamed or retired command silently misroutes, and nothing detects
   it — so the index carries a one-line existence check the acceptance harness can run, which is the
   same mechanism that caught the stale README here. With all 25 Matt names present, that check also
   catches a future installed skill going unclassified.
4. **Answered in the four classes above.** The dividing test that did the work: a capability is a
   top-level owner only if an ordinary-language request can *arrive* at it; if it is only ever
   reached because another owner is already running, it is a phase.
5. **The live definitions support the approved boundaries, with three factual collisions and one
   count correction — none resolved here.** The collisions are the table above. The count correction
   is claim (5): 94 distinct Axcíon commands across two surfaces, not 88. `/pipeline-review` appears
   in both the specialist list and the cadence-exclusion list, but the brief reconciles that itself,
   so it is not a conflict. No membership added or removed.
6. **One-owner routing survives a multi-phase flow by routing to the flow's *entry*, not its
   stack.** An ordinary-language request enters at exactly one of `grill-with-docs`/`grill-me`,
   `wayfinder`, `triage` or `diagnosing-bugs`; `to-spec`, `to-tickets`, `implement`, `tdd` and
   `code-review` are then reached by the owner at its own phase boundaries. The router names the
   entry and stops. This matches how `work-loop-v2/SKILL.md`'s Routing section already answers "who
   owns the next move?" — one owner, decided fresh, no stack.
7. **The implementation boundary — corrected and stated precisely.** The earlier draft made this
   answer wait on three operator calls and then described the whole remainder of the task as
   "Unit 2". Both parts were wrong: the three calls are resolved above from decisions already in the
   file, and the router index is **not** the whole remainder.

   One design decision Codex owns and this unit recommends: the index lives in
   `.agents/skills/work-loop-v2/SKILL.md`'s existing Routing section, not in the core. The core is
   contract; the index is content that changes whenever a command or skill changes.

   **What remains, as two separate bounded units:**

   - **The router index — one Implementation unit, ready to brief now.** Extend one section of one
     file with the 50 named entries and four class notes, plus a name-existence check in the
     acceptance harness. Nothing in the core, the Claude command, the harness contract or any
     installation moves.
   - **The Discovery / Implementation / Adoption mode contract — still unimplemented, still
     required, and a later bounded unit of its own.** The objective (lines 8–11 of this file)
     requires that when Work Loop v2 owns a request, Codex classifies the active mode and records it
     inside `## Lane and unit`. This unit did not implement it and this correction does not: the
     brief's exclusions name "mode-contract implementation" explicitly. It is a change to how Codex
     writes `## Lane and unit`, which is a different surface from the router index and must not be
     smuggled into the index unit.

   The task therefore does not close when the index ships. Its stated exit condition — inventory
   established, router implemented from that evidence, and representative ordinary-language cases
   able to expose a wrong route — additionally needs the mode contract and the exposure cases, which
   are not yet briefed.

### Operator choices — resolved from the governing decisions already in this file

The earlier draft raised three questions for the operator. None of them was a genuine open choice:
each is settled by a decision the brief already carries, so asking would have handed back work the
operator had already done. All three are applied above and recorded here.

1. **The `triage` / `handoff` / `grill-me` collisions — resolved by disambiguating labels.**
   Product-plus-purpose, never a bare name; the six labels are in the collision table above. Ground:
   governing decision 4 (one-owner routing). A bare name that resolves two ways cannot name one
   owner, so the label is what makes one-owner routing true rather than merely asserted.
2. **The 12 Claude-only Matt skills — advertised, each carrying a `Claude-side only` marker.**
   Ground: governing decisions 2 and 3 (the router must account for every relevant installed Matt
   skill, and the list must include all current core skills, not a hand-picked sample) plus the fact
   established in Inventory C — Claude is where they execute, and the operator works in both
   products. Omitting them would hide 12 real destinations to spare a Codex-hosted router the
   inconvenience of naming what it cannot itself run. The marker states the boundary instead: Codex
   may select such an owner and must then say the work runs Claude-side.
3. **The 6 workspace-root-only commands — excluded.** Ground: governing decision 8 approves an
   Axcíon personal-command set drawn from `ai-resources`, and decision 1's superseded-list rule
   ("repository presence cannot promote another command into the router"). `harness-start`,
   `session-report`, `resolve-improvements`, `run-qc`, `update-md` and `validate` are present but
   unapproved, which is exactly the case that rule covers. They stay out; their existence is
   recorded in Inventory E so a later unit can reopen membership deliberately rather than by
   accident.

### Deferrals noticed and not done

- `plans/work-loop-v2-mvp/README.md` line 78 is factually wrong about `diagnosing-bugs` and 14 names
  short. Not corrected — the brief's exclusions forbid editing it, and it is a build record rather
  than a runtime contract. Worth a one-line fix in a later unit.
- `.agents/skills/wl2-probe` self-describes as throwaway and marked for deletion. Not deleted — out
  of scope, and deletion is the operator's call.
- *Noticed during this correction, not implemented:* advertising 12 destinations Codex cannot invoke
  creates a case the router must answer in one line — what Codex **does** when the selected owner is
  Claude-side only. The answer is almost certainly "name it and hand the turn to the operator",
  which is already how `turn: operator` works, but it is router wording and belongs to the index
  Implementation unit, not to this correction.
- *Noticed during this correction, not implemented:* the classification and marker checks below run
  from the shell and are not persisted anywhere, because this brief allows changing the state file
  only. The index Implementation unit should fold them into
  `logs/scripts/work-loop-v2-slice-1.test.sh`, or the next drift goes undetected exactly as the
  README's did.

Result: Discovery complete, and the four frozen findings are corrected. The live inventories stand
unchanged (25 Claude skills, 19 Codex skills, 7 repo-local Codex skills, 94 Axcíon commands) and all
eight brief claims still hold. What changed: `improve-codebase-architecture` is placed
unambiguously as a primary route, so the Matt primary set is **13, not 12**, and the index
arithmetic is **16 + 13 = 29** primary intake routes; the three questions previously put to the
operator are resolved from governing decisions already in this file (disambiguating
product-plus-purpose labels for the `triage` / `handoff` / `grill-me` collisions, all 12 Claude-only
Matt skills advertised with a `Claude-side only` marker, the 6 workspace-root-only commands
excluded); the recommended index now names **all 25 Matt skills** — 13 routes, 6 phases, 6 helpers,
each supporting skill carrying its direct-use boundary — alongside the 16 approved Axcíon primary
and 9 specialist commands, 50 named entries plus four one-line class notes, still without expanding
toward 94 or copying any procedure; and the implementation boundary is split into two units, the
router index (ready to brief) and the still-unimplemented Discovery / Implementation / Adoption mode
contract, which the objective requires and which the index unit must not absorb. Two candidate
deferrals were noticed and recorded, not done. No repository artifact was changed except this state
file.

Evidence: three checks, run from the shell against this file. They create no repository artifact —
the brief allows changing this state file only, so nothing was written to `logs/scripts/`.

- **A — omission** (unchanged from the previous round): every directory carrying a `SKILL.md` under
  `~/.claude/skills/`, `~/.codex/skills/` and `.agents/skills/` must appear in the text between
  `## Latest result` and `## Blocker`.
- **B — classification** (new, and the check the corrected findings needed): the 25 Matt skills are
  parsed back out of the three class blocks — all backticked names in the Class 1 paragraph, the
  first backticked name of each Class 2 and Class 3 bullet — and must equal the installed set with
  **no name classified twice and none unclassified**, with each block's listed length matching the
  count its own heading states. It also requires the literal line `16 Axcíon + 13 Matt = 29 primary
  intake routes`, which is the arithmetic finding 1 was about.
- **C — Claude-side-only markers** (new): the marked set is parsed from the `*(C)*` markers in
  Class 1 and the `(Claude-side only)` markers in Classes 2–3, and must equal
  `comm -23 ~/.claude/skills ~/.codex/skills` exactly — neither short nor over-marked.

Run against this file on 2026-08-06: `A/claude 25/25`, `A/codex 19/19`, `A/agents 7/7`,
`B/class sizes: 1=13 2=6 3=6 (sum 25)`, `C/marked 12 (Claude-only set: 12)`, `PASS`, exit 0.

**Six failing cases were built first**, each against a throwaway copy so this file was never
doctored: (1) deleting `to-questionnaire` from the Class 1 list → `class 1 says (13), lists 12` +
`installed but unclassified: to-questionnaire`, exit 1; (2) adding `wizard` as a second Class 2
bullet → `classified more than once: wizard`, exit 1; (3) restating the Class 1 heading as `(12)` →
`class 1 says (12), lists 0` plus 13 unclassified, exit 1; (4) stripping the `*(C)*` from `wizard` →
`Claude-only but unmarked: wizard`, exit 1; (5) marking `research`, which does run on Codex →
`marked but runs on Codex too: research`, exit 1; (6) reverting the arithmetic line to `12 Matt =
28` → `Class-1 arithmetic line absent or wrong`, exit 1.

Case 1 is the one that shows why check B had to exist: check A passed at `25/25` on that same
mutated copy, because `to-questionnaire` still appeared elsewhere in the prose. A name-presence
check proves nothing was dropped from the *document*; only B proves nothing was dropped from the
*classification*. Neither judges whether a name was classified **correctly** — that is Codex's
closure check, not something a script can settle.

## Blocker

None.

## Next action

Closure check on the four frozen findings only — are they resolved, and did the correction break
anything?

1. Finding 1 — `improve-codebase-architecture` is placed in Class 1 with its ground stated; the Matt
   set reads 13 and the arithmetic line reads `16 Axcíon + 13 Matt = 29 primary intake routes`.
2. Finding 2 — the three questions are replaced by *Operator choices — resolved from the governing
   decisions already in this file*, with the collision labels in the table above, 12 markers applied,
   and the 6 workspace-root-only commands moved from "uncertain" to "present but unapproved".
3. Finding 3 — the recommendation now names all 25 Matt skills across three groups with direct-use
   boundaries, plus 16 Axcíon primary and 9 specialist commands; 50 named entries and four class
   notes.
4. Finding 4 — answer 7 now splits the remainder into the router-index unit and a separate,
   still-required mode-contract unit, and states that the task does not close when the index ships.

Two candidate deferrals are recorded under *Deferrals noticed and not done* and were not
implemented: the router's one-line answer for a Claude-side-only owner, and folding checks B and C
into `logs/scripts/work-loop-v2-slice-1.test.sh`. Both are Codex's to accept or drop at closure.

Only this state file changed.
