# Routing index — work-loop-v2

**Read this file complete whenever you select the owner of a request.** `SKILL.md` § Routing a
request, step 2 sends you here, and it holds no copy of what is below. Everything here is lookup
content: the five route classes, the names that are not routes, the collision table, and what a
Claude-side-only owner changes. Routing behavior, admission, mode classification and the
intake-result contract stay in `SKILL.md` and are not repeated here.

### The index — Axcíon commands that may own a request (16)

- `/work-loop-v2` — bounded repository work no specialist owner covers.
- `/develop-ai-resource` — a durable skill, command or agent may need to exist.
- `/scope-project` — a complex build needs its control documents before it starts.
- `/new-project` — the need is already qualified and the project scaffold is what is missing.
- `/project-next-steps` — where a project stands and what to do next.
- `/consult` — a workspace-structure or architecture judgment call.
- `/pm` — a question about an active project's own content.
- `/tech-consult` — a business need with no technical plan yet.
- `/open-items` — what is still unresolved in a project.
- `/resolve-repo-problem` — something is wrong and the cause is not yet established.
- `/resolve-incident` — a fault to classify, fix, verify and log end to end.
- `/repo-dd` — due diligence on a repository's actual state.
- `/analyze-workflow` — a deployed workflow's infrastructure end to end.
- `/lean-repo` — accumulated operational complexity to diagnose.
- `/implementation-triage` — is this proposed implementation worth doing.
- `/reconcile` — did the output actually fulfil its mandate.

### The index — Axcíon narrow specialist destinations (10)

Selected only where the request names their purpose. Never a generic fallback.

- `/audit-repo` — a workspace health audit.
- `/architecture-review` — a prioritised architecture-health report from existing audits.
- `/systems-review` — the workspace through a systems-thinking lens.
- `/token-audit` — token-usage efficiency.
- `/permission-sweep` — permission-prompt drift across settings layers.
- `/pipeline-review` — a deep design review of one named pipeline.
- `/blindspot-scan` — an adversarial blind-spot scan; operator-invoked only.
- `/contract-check` — has the artifact drifted from its original mandate.
- `/expert-check` — a draft against reference principles.
- `/memory-search` — has this been seen before; the recorded history in `logs/` and `audits/`. Returns historical evidence, never current state, so it never owns a live fault — `/resolve-repo-problem` and `/resolve-incident` keep that.

### The index — Matt skills that may own a request (13)

`[Claude-side only]` marks a skill installed for Claude but not for Codex.

- `grill-with-docs` `[Claude-side only]` — an idea to sharpen, with a repo to leave the paper trail in.
- `grill-me` (Matt — stateless interview, saves nothing) — an idea to sharpen with no repo under it.
- `wayfinder` — an effort too foggy for one session; it produces decisions, not deliverables.
- `diagnosing-bugs` — something is broken and resists a first glance.
- `triage` (Matt — incoming issues and PRs) `[Claude-side only]` — requests you did not create, piling up.
- `implement` — build from a spec or a ticket.
- `prototype` — a design question needing a runnable answer.
- `research` — reading legwork against primary sources.
- `resolving-merge-conflicts` `[Claude-side only]` — already mid-merge or mid-rebase.
- `wizard` `[Claude-side only]` — steps only a human can take.
- `to-questionnaire` `[Claude-side only]` — the blocking knowledge is in someone else's head.
- `teach` — learn a concept across sessions.
- `improve-codebase-architecture` `[Claude-side only]` — the codebase is getting hard for agents to work in.

### The index — Matt phases and supporting skills (6)

Reached by an owner at its own phase boundary. Direct entry only in the case named.

- `to-spec` — no direct entry: it collapses an existing thread or decision map.
- `to-tickets` — no direct entry: it splits an existing spec.
- `tdd` — direct entry only for one concrete behaviour with no spec behind it.
- `code-review` — direct entry only for an explicit branch or PR against a fixed point.
- `grilling` — direct entry only where the interview is wanted with no wrapper and no artifact.
- `handoff` (Matt — a portable file for another agent or directory) `[Claude-side only]` — direct entry only for a new harness, a new directory, a colleague, or forking a side task mid-phase.

### The index — Matt helpers and references (6)

Discoverable, never a first route.

- `setup-matt-pocock-skills` — the run-once precondition before a first engineering flow.
- `domain-modeling` — direct entry where the domain *words* are the problem, not the process.
- `codebase-design` `[Claude-side only]` — direct entry where one module's shape is being designed.
- `writing-for-agents` `[Claude-side only]` — reference for documents agents consume.
- `wait-what` `[Claude-side only]` — a mid-conversation corrective, inside any other skill.
- `ask-matt` `[Claude-side only]` — the Matt router. Never a destination from here: routing into a router nests them.

### The index — names that are not routes

Named by class, not enumerated. The Axcíon surface is 95 commands and this index carries 26 of them on purpose; the rest are reachable, just not as first owners.

- **Lifecycle phases** — `/create-skill`, `/improve-skill`, `/request-skill`, `/migrate-skill`, `/graduate-resource`: build phases under durable-resource work, reached by its owner.
- **Conversational controls** — operator controls and duplicate entry points, not capability owners.
- **Session machinery** — state, transport and session control.
- **Fixed cadence** — the Friday and Monday operations and the monthly review: scheduled, not intake destinations.
- **Deployment, migration, cleanup, logging and backlog-fix commands** — explicit operations chosen after an owner established the need.
- **`/leverage-idea`** — itself a router. Indexing it, or copying its route map here, would nest one router inside another.
- **Installed but excluded** — the six design/motion skills the operator excluded; the six workspace-root-only commands no approved set names; Work Loop v1 and the `wl2-probe` throwaway.

### Naming a colliding capability

Three names resolve to two different capabilities. Name them by product plus purpose — **never a bare name**, which would route to whichever the harness happened to resolve first.

| Say | Because |
|---|---|
| Matt `triage` — incoming issues and PRs | Axcíon /triage reviews the suggestions Claude just proposed |
| Matt `handoff` — a portable file for another agent | Axcíon /handoff saves session state or forks a child session |
| Matt `grill-me` — a stateless interview | Axcíon /grill-me produces a structured mandate brief |

### When the owner is Claude-side only

You cannot invoke a `[Claude-side only]` skill. Name it, label it `Claude-side only`, and tell the operator to **invoke that exact skill in Claude**. Do not substitute a Codex-side near-equivalent, and open **no state file** around the specialist flow — wrapping it is the second state system core § 1 forbids.
