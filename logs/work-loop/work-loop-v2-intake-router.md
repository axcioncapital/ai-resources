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

*Matt (12):* `grill-with-docs` (idea, repo present) · `grill-me` (idea, no repo) · `wayfinder` (fog
too big for one session) · `diagnosing-bugs` (something broken) · `triage` (unowned issues piling
up) · `implement` (build from spec/ticket) · `prototype` (design question needing a runnable answer)
· `research` (reading legwork) · `resolving-merge-conflicts` (already mid-conflict) · `wizard`
(steps only a human can take) · `to-questionnaire` (the knowledge is in someone else's head) ·
`teach` (learn a concept). `improve-codebase-architecture` sits at the edge — it is upkeep the
operator initiates, so it is a route, but it *generates* an idea rather than delivering one.

**Class 2 — Flow phases or supporting skills (selected inside an owner or at a phase boundary).**

*Matt:* `to-spec` · `to-tickets` (phases after grilling or wayfinder) · `tdd` (driven inside
`implement`; a route only for a single concrete behaviour) · `code-review` (closes `implement`; a
route only for an explicit branch/PR review) · `grilling` (the primitive under `grill-me`,
`grill-with-docs`, `triage`, `wayfinder`, `improve-codebase-architecture`) · `handoff` (phase-
boundary transport).

*Axcíon lifecycle phases:* `/create-skill` · `/improve-skill` · `/request-skill` · `/migrate-skill`
· `/graduate-resource`.

*Axcíon specialist destinations* — reachable when the request names their narrow purpose, never a
generic fallback: `/audit-repo` · `/architecture-review` · `/systems-review` · `/token-audit` ·
`/permission-sweep` · `/pipeline-review` · `/blindspot-scan` · `/contract-check` · `/expert-check`.

**Class 3 — Setup, corrective or vocabulary helpers (retained, discoverable, not first routes).**

*Matt:* `setup-matt-pocock-skills` (run-once precondition) · `domain-modeling` and `codebase-design`
(the two vocabulary layers that run underneath) · `writing-for-agents` (reference) · `wait-what`
(mid-conversation corrective) · `ask-matt` (the Matt router itself — a router, so including it as a
destination would nest routers, exactly the ground on which `/leverage-idea` was excluded).

*Axcíon conversational controls:* `/clarify` · `/decide` · `/recommend` · `/triage` · `/explain` ·
`/scope` · `/summary` · `/note` · `/grill-me`.
*Axcíon session machinery:* `/mission` · `/new-worktree-session` · `/close-worktree-session` ·
`/build-context` · `/handoff` · `/prime` · `/session-start` · `/session-plan` · `/save-session` ·
`/wrap-session` · `/usage-analysis` · `/drift-check` · `/concurrent-session-check`.
*Axcíon fixed cadence:* `/friday-checkup` · `/friday-so` · `/friday-act` · `/friday-journal` ·
`/so-monthly` · `/monday-prep`.

**Class 4 — Unavailable, legacy, duplicate or uncertain.**

- *Unavailable to Codex:* the 12 Claude-only Matt skills in Inventory C.
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
- *Uncertain current use — awaiting the operator:* the 6 workspace-root-only commands in Inventory E.
- *Stale:* the README inventory (claim 4).

### The three name collisions — reported, not resolved

Each name resolves to two different definitions in a live Claude session. The router cannot name
these without saying which it means.

| Name | Axcíon `.claude/commands/` | Matt `~/.claude/skills/` |
|---|---|---|
| `grill-me` | Pre-plan interview producing a **structured mandate brief**; delegates to `skills/grill-me/SKILL.md` | Stateless relentless interview; saves nothing |
| `handoff` | **Session** state save, or fork a scoped child session | Compact the conversation into a **portable file** for another agent |
| `triage` | Independent review of **suggestions Claude just proposed** | Move **incoming issues and PRs** through a triage state machine |

`triage` is the worst: the two meanings do not overlap at all. Which one wins at `/triage` is a
harness precedence question I could not settle by file inspection — flagged below as an operator/
Codex item, not guessed.

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
   both products. **Recommendation: the compact in-skill index, listing Class 1 only** (16 Axcíon +
   12 Matt = 28 entries), with Classes 2–4 named as non-routes in one line each rather than
   enumerated. Drift risk, stated plainly: a renamed or retired command silently misroutes, and
   nothing detects it — so the index should carry a one-line existence check the acceptance harness
   can run, which is the same mechanism that caught the stale README here.
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
7. **The implementation boundary before Unit 2.** Four things must be settled first, three of them
   operator calls (below), plus one design decision Codex owns: whether the index lives in
   `work-loop-v2/SKILL.md`'s Routing section (recommended) or in the core. The core is contract, the
   index is content that changes when commands change — so it belongs in the skill. Once those are
   settled, Unit 2 is bounded: extend one section of one file, plus a name-existence check. Nothing
   in the core, the Claude command, the harness or any installation needs to move.

### Unresolved operator choices — reported, not guessed

1. **`/triage`, `/handoff`, `/grill-me` collide.** Which definition should the router name for each?
   Or should the router use disambiguating labels rather than the bare names?
2. **Should the router advertise the 12 Claude-only Matt skills?** They are real destinations for
   the operator working in Claude, but Codex cannot invoke them. Advertise with a "Claude-side only"
   marker, or omit them from a Codex-hosted router?
3. **The 6 workspace-root-only commands** (`harness-start`, `session-report`, `resolve-improvements`,
   `run-qc`, `update-md`, `validate`) appear in none of the brief's lists. In current use or not?

### Deferrals noticed and not done

- `plans/work-loop-v2-mvp/README.md` line 78 is factually wrong about `diagnosing-bugs` and 14 names
  short. Not corrected — the brief's exclusions forbid editing it, and it is a build record rather
  than a runtime contract. Worth a one-line fix in a later unit.
- `.agents/skills/wl2-probe` self-describes as throwaway and marked for deletion. Not deleted — out
  of scope, and deletion is the operator's call.

Result: Discovery complete. The live inventories are established (25 Claude skills, 19 Codex skills,
7 repo-local Codex skills, 94 Axcíon commands), all eight brief claims hold, and every named skill
is classified exactly once. The material finding is that the Claude and Codex skill surfaces are
asymmetric — 12 of the 25 Matt destinations are Claude-only, including `ask-matt` itself — so a
Codex-hosted router cannot link to `ask-matt` and must decide what to do about destinations Codex
cannot reach. Recommended shape: a compact Class-1-only index (28 entries) inside the existing
Routing section of `.agents/skills/work-loop-v2/SKILL.md`. No repository artifact was changed except
this state file.

Evidence: the omission check runs from the shell and creates no repository artifact — the brief
allows changing this state file only, so it was **not** written to `logs/scripts/`. It extracts the
text between `## Latest result` and `## Blocker`, then requires every directory carrying a
`SKILL.md` under `~/.claude/skills/`, `~/.codex/skills/` and `.agents/skills/` to appear in that
text, exiting 1 on the first miss:

```bash
BODY=$(awk '/^## Latest result$/{f=1;next} /^## Blocker$/{f=0} f' "$SF")
for d in "$DIR"/*/; do [ -f "$d/SKILL.md" ] || continue
  printf '%s' "$BODY" | grep -qF -- "$(basename "$d")" || { echo "FAIL: $(basename "$d")"; exit 1; }
done
```

Run against this file on 2026-08-06: `claude: 25/25`, `codex: 19/19`, `agents: 7/7`, `PASS`,
exit 0. **The failing case was built first and in both directions**, against throwaway copies so
this file was never doctored: replacing `to-questionnaire` throughout a copy produced
`FAIL: missing from Latest result: to-questionnaire (claude)`, `claude: 24/25`, exit 1; replacing
`improve-animations` produced `FAIL: … improve-animations (codex)`, `codex: 18/19`, exit 1. The
original still contains `to-questionnaire` (6 occurrences). It is a name-presence check, so it
proves no name was silently dropped; it does not judge whether a name was classified correctly.
Before this unit no such check existed, which is why the README's 14-name gap survived undetected
since 2026-08-01.

## Blocker

None.

## Next action

Codex: assess this discovery and decide whether to reframe or stop. Three operator choices are
open — the three name collisions, whether to advertise the 12 Claude-only Matt skills in a
Codex-hosted router, and the current-use status of the 6 workspace-root-only commands. Unit 2 cannot
be safely briefed as Implementation mode until at least choices 1 and 2 are settled, since both
change what the index names.
