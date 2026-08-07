---
name: "work-loop-v2"
description: "Use only when the request (1) names the Work Loop, (2) points at an existing logs/work-loop/{task-id}.md task, hand-off or assessment to act on, (3) says 'continue this project' or 'what is next on this project', or (4) asks Codex to frame a bounded unit for another actor to execute. Then route it to the one capability that owns it — the operator, an Axcíon command, a Matt skill, or the Work Loop itself — and, where the Work Loop owns it, frame and assess one bounded unit: write the brief that opens it, and judge the evidence that comes back. Do not use for an ordinary repository or project change described in natural language without naming a capability (that is Direct Work), a request naming a command, skill or agent to run, a question answered by reading or explaining with no repository change, a small reversible fix, or work already inside another skill's flow. Claude executes and makes every commit; you do neither."
---

# work-loop-v2 — Codex side

You frame the work and judge the result. **Claude owns repository reality: it checks claims, implements, produces evidence, and makes every commit.** You never both frame a unit and approve its implementation without evidence in front of you.

This file says what *you* do. It does not restate `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, and where the two disagree the core wins — report the disagreement as a defect rather than picking a side. The core's read point is fixed at § Routing step 3, because most routing outcomes are not the Work Loop and do not need the contract at all.

---

## The seam

Core § 4 defines the interface between you and Claude, and places the operator outside it. Four consequences for how you work:

- **Do not wait for a state file before engaging with a request.** The operator reaches you directly, in conversation, before any file exists — core § 4 says why it cannot be otherwise. There is nothing to wait for.
- You **write** the state file, at the path core § 4 fixes. You have repository write access; use it.
- You **never run git.** Not `add`, not `commit`, not `checkout`. Claude commits — including the file you just wrote.
- The operator carries the turn. So **every reply you give ends with an explicit next instruction to them**, in plain words.

**Name the actor whose turn it actually is** — the one you just wrote into `turn:`. The three cases:

| `turn:` you set | The Next line says |
|---|---|
| `claude` | **Next:** run `/work-loop-v2` in Claude. |
| `operator` | **Next:** {the decision or information you need from them}. |
| — (Direct Work, no file) | **Next:** have Claude do this directly — no loop task. |
| — (a specialist owner, no file) | **Next:** run {the owner} — naming it, and saying `in Claude` where it is Claude-side only. |
| `claude`, **with an unattended run in flight** | **Next:** nothing to do — the run is carrying it. Name the deadline and where the evidence will be. See *Unattended runs*. |

**The carve-out in the last row matters.** "The operator carries the turn" is why every reply ends with an instruction to them. While an unattended run is in flight, the dispatcher carries the turn instead, and an instruction to go and paste something would be wrong. The Next line then reports rather than directs.

Sending the operator to Claude when the turn is theirs stalls the loop as surely as saying nothing: Claude opens the file, finds nothing owed by it, and hands straight back. Omitting the line altogether is the most likely way this loop silently stops — the operator is left holding a turn with no stated destination. Treat it as part of the output, not as courtesy.

**The folder is core § 4's, not a choice.** Create `logs/work-loop/` if it does not exist. There is no fallback path — if you cannot write there, say so and stop.

### The checkout a task lives in, and starting a new one

**The task file's location is the binding.** The checkout holding `logs/work-loop/{task-id}.md` is the checkout that task lives in. Nothing records this in the file — a state field would be a second copy, free to drift from the path it duplicates.

- **Verify before you create.** Before writing a new state file, confirm the working directory you are *actually* in — not the one you meant to be in — and that it is the checkout the work belongs to.
- **Both actors verify at every handoff.** Claude's Step 1 already resolves the file under the checkout it is running in.
- **A mismatch stops and goes to the operator** (core § 7). **Never copy the task file to another checkout as a repair.** That produces two files claiming one task's truth, which is the failure core § 4's single interface exists to prevent.

**Isolation — the whole policy, applied where a new task or run starts:**

| Situation | Default |
|---|---|
| Concurrent work in **different repositories** | Each uses its own local checkout. **No worktree.** |
| Ordinary work in one repository, one writer | Local checkout. |
| **Concurrent writers in one repository** | Deliberate isolation — a worktree or a branch. |
| **Unattended run** | Isolation, on a branch off a clean tree (§ *Unattended runs*). |
| **Genuinely large implementation** | Isolation. |

A worktree is a cost, not a default. The table is the policy — do not build a decision procedure on top of it.

**When a new Codex task starts at all.** Only where the thread has ended or must end: a fresh session, a compaction that lost the thread, or a deliberate hand-off. **Ordinary Claude ↔ Codex turns carried by the state file do not open a new task** — the state file is the interface, and multiplying visible tasks for a routine turn is the ceremony this rule excludes.

- **Prefer a genuinely fresh task over a transcript-preserving fork.** A fork carries conversational memory, and conversational memory cannot establish authority or current state. A fresh task is forced to read the durable sources, which is the property wanted.
- **Choose Local or Worktree explicitly**, per the table above, when the chat is created.
- **Verify the working directory as the first action**, before anything is read or written. Do not infer it.
- **Then read the durable sources, in this order:** the state file `logs/work-loop/{task-id}.md`; the governing plan; the applicable approved workflow; authoritative current state. Re-establish the seven fresh-thread recovery items inside that same preparation pass — § *Mark what must be verified* owns them — never as a stage of its own.

**The existing-worktree fallback.** Where the work must continue in a permanent, user-created worktree: open that directory as a **Local** checkout for the new task, and verify the working directory first. Do **not** use "create a worktree" on a fresh task expecting it to attach to the existing one — that silently creates a *different* worktree, which is the failure this fallback exists to avoid. Codex-managed worktrees are disposable and are not a continuity surface.

### Courier mode — carrying the turn yourself

Core § 4 *An approved courier may carry the turn* permits this and sets its limits. Read them there. This section is the approved courier and how you operate it. **It is optional and off by default**: unless the operator has approved it for the session, end your reply with the Next line and stop, exactly as above.

**There are two approved shapes, and the operator's presence picks which.**

| Shape | Flag | Use it when |
|---|---|---|
| **Attended carry** | `--carry-one` | The operator is at the machine. You carry **one** hop, then read the file and assess. The loop does not run on without you. |
| **Unattended run** | loop mode (no `--carry-one`) | The operator is leaving. You frame the unit, launch, and get out of the way. The loop alternates Claude ↔ Codex until `turn: operator`, the deadline, or a guard. |

Everything below applies to both unless it names one. The hard rules are written for the attended carry, which is the default; *Unattended runs* at the end of this section states what changes.

**What you drive is a terminal command, not Claude.** You never type into a Claude window, never read Claude's interface for progress, and never click through its prompts. You run one command and read its exit code. The dispatcher launches Claude, validates the state file before and after, and stops on anything unexpected — that instrumentation is the reason this is the approved courier and screen-driving Claude directly is not.

**Neither shape is context-bounded, and it is worth being clear why.** Every hop is a **fresh process** (`claude -p`, `codex exec`). Nothing accumulates across hops; `logs/work-loop/{task-id}.md` is the entire shared memory. A run ends at `turn: operator`, at its hop limit, at its deadline, or at a guard — never because a context window filled. Do not plan around a context budget that does not exist.

The command, in full — all three `--allow-path` values are required, because supplying any one **replaces both defaults**, and a `PostToolUse` hook keeps `logs/friction-log.md` modified in this repository:

```
plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh \
  --checkout <absolute checkout path> \
  --task <task-id> \
  --carry-one \
  --allow-path '^logs/work-loop/' \
  --allow-path '^plans/work-loop-v2-v0\.2/handoff-automation-spike/' \
  --allow-path '^logs/friction-log\.md$'
```

**The hard rules.** Each is a stop, not a preference:

1. **Read the state file first.** Confirm the exact task id and that `turn:` is `claude`, by opening the file. Not from what you remember writing.
2. **Run the command once.** In the **attended carry**, `--carry-one` carries exactly one hop, so Claude moves and you assess — the loop does not run on without you. *This is a property of the attended shape, not of the dispatcher:* an unattended run is defined by the loop running on without you, and is governed by the deadline and hop limit instead. Either way you run the command **once** and never re-run it to try again (rule 5).
3. **The exit code is the result.** `0` means the carry completed. Anything else is a stop: report the code and its meaning to the operator, and do not re-run.
4. **Read the file before assessing.** Exit `0` has two causes — the turn moved, or `turn:` was already `operator` and nothing was carried. Only the file distinguishes them, and the file is authoritative over the exit code either way (core § 4).
5. **Never re-run to "try again".** A second run is only ever justified when the dispatcher's own run log shows the first launch never started. A completed run that did not produce what you expected is something to inspect, not to repeat.
6. **`turn: operator`, a malformed state file, and a permission prompt are terminal.** Stop and tell the operator. You do not approve prompts and you do not work around them.

**An unchanged `turn: claude` does not mean the command failed to land.** Claude leaves the file *completely untouched* when it rejects one — an identity mismatch or unreadable frontmatter is a correct read-only refusal (core § 6 rule 2), not a lost message. There are three causes and the dispatcher already separates them: `14` identity mismatch (Claude was never launched), `22` no transition (Claude ran and changed nothing), `21` timeout (Claude was still working). Read the code. Do not infer the cause from the turn, and never treat an unchanged turn as permission to send again.

**Operating defaults — preferences, not protocol.** Do not report a breach of these as a failure: a target for how many interactions a carry should take is a cost guide, and corrections, closures, permission prompts and genuine blockers can legitimately exceed it; a fresh Claude session is a sensible default for a new unit but not required for a short correction or a closing hand-off; inspecting accessibility state before taking a screenshot is an efficiency habit; and an unlocked machine is a preflight reminder rather than a Work Loop safety rule.

**This does not loosen "you never run git."** Launching the dispatcher is not running git. The dispatcher reads git state to validate the hop — `status`, `rev-parse`, `diff --cached` — and writes nothing through git; the commit inside the carry is Claude's, made by Claude, exactly as core § 4 requires. You still never run `add`, `commit` or `checkout` yourself, and you may not substitute any other command for the one above.

#### Unattended runs — when the operator is leaving

Same dispatcher, same guards, `--carry-one` dropped. What changes:

**Add a clock, and isolate the run.** `--deadline <seconds>` is the operator's absence in seconds; without it the real bound is `--max-hops × --timeout`, which is hours. The run goes on a branch off a **clean** tree, and the launch is wrapped in `caffeinate -i` — a Mac that sleeps kills the run. The worked invocation is in the spike `README.md`; use it rather than assembling one.

**Contain the child: pass `--unattended`.** An unattended Claude hop runs with less authority than an attended one, and this is the flag that applies it — not `--claude-deny`, which is a permission-layer narrowing that leaves the network wide open. `--unattended` gives the child an OS-backed sandbox with an empty network allowlist, shell and Skill tools only, no MCP, hooks, connectors, remote control, subagents, built-in file tools or push, and credentials stripped from subprocesses. It fails closed (exit `31`) rather than running uncontained, and refuses to combine with `--actor-cmd`. `--claude-deny` still composes and can only narrow further.

Three things to know rather than discover mid-incident. **The run log records the *requested* policy, not the effective one** — array settings keys merge across scopes, so another scope on the host can widen what the child reads; the effective policy was measured once, on one host (`runs/probe-unattended-integration-2026-08-07.md`). **Where the effective policy *is* readable:** an unattended hop is captured as `--output-format stream-json`, so the hop's `.out` opens with the product's own `system/init` event, and that states the tool roster and MCP servers the runtime actually resolved. Read that, not the argv and not the child's account of itself. And **`~/.gitconfig` is one deliberate exception** inside an otherwise denied home directory, because Git exits before touching the repository without it; if a real secret is ever put in that file, the exception stops being safe.

**The allowlist becomes a per-task input.** The dispatcher now checks what Claude **committed** against `--allow-path`, not only what it left uncommitted. So the allowlist has to describe what *this unit* may legitimately touch. Derive it when you write the brief. Too narrow stops correct work; too wide and the check means nothing.

**The Next line changes shape.** The rule that every reply ends with an explicit next instruction (§ The seam) assumes the operator carries the turn. While a run is in flight they do not, and telling them to go and paste something would be wrong. **When you have launched a run, the Next line names the run, its deadline, and where its evidence will be** — not an instruction to act.

**Once you have launched, the state file is not yours until the run exits.** You write that file by hand and the lock does not stop you; a hand-edit mid-hop is a real corruption path. Check before touching it:

```
dispatch.sh --checkout <path> --task <task-id> --status
```

`--status` is read-only — no lock, no log, no write — and safe against a live run. It reports whether a run is in flight, its pid, how to stop it, the current `turn:`, and where the log is.

**Do not mix the shapes.** A chat Codex carrying hops while a loop run is in flight is two instances of one actor driving one state file. `--status` is how you tell.

**Three outcomes, never blurred.** When the operator returns, the run ended in exactly one of these, and saying which is the first thing you owe them:

| Outcome | Looks like |
|---|---|
| **Finished** | `0` — and `turn: operator` with a core § 4 closing record |
| **A decision is theirs** | `0` — and `turn: operator` with `## Blocker` / `## Next action` still present |
| **Stopped** | any other code — a guard (`18`,`19`,`24`,`25`,`30`), a failure (`20`,`21`,`22`), the hop limit (`23`), an interruption (`28`), or the budget (`29`) |

**`29` is not completion.** A run that ran out of clock is unfinished and resumable. Never report it as done.

**Separate repository facts from model claims.** Report from the state file and the run log, and keep the two kinds of statement apart: *"the dispatcher observed exit 0"* is a repository fact; *"Claude reports the tests passed"* is a claim Claude made. Neither means you accepted the evidence — that is still your assessment to make (§ Assessing the result), and an unattended run does not do it for you.

---

## Routing a request — who owns the next move

The operator describes what they want in ordinary language and rarely names a capability. Route it before anything else, in this order:

1. **Interpret the desired outcome and its object** — what should be different afterwards, and to what. Not the remedy they proposed; the outcome behind it.
2. **Choose one owner** from the index below — the single capability whose purpose covers that outcome.
3. **If the Work Loop is the owner** — and only then — **read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` now, before your first Work-Loop-owned move.** It is the contract: roles, the unit cycle, the state file, the vocabulary, the five safety rules, and when to stop. Then apply the Direct-versus-Standard admission test (Admission below). Where any other capability owns it, admission does not arise and the core is not read.
4. **Classify the mode** — Discovery, Implementation or Adoption — **only once admission has succeeded**, and record it inside `## Lane and unit`. Core § 3 *The unit's mode* defines the three and what each requires of the evidence.
5. **Choose the bounded unit** and write the brief.

Mode belongs to an admitted Work Loop unit and to nothing else: a request routed to the operator, to a specialist owner, or to Direct Work never acquires one. It is also not the **courier** mode of core § 4, which is transport.

**Who owns the next move** has three kinds of answer:

- **The operator** — the next move is a decision only they can make: intent, priority, authority, or risk. Open nothing. End with the Next line naming the decision you need.
- **A specialist owner** — an Axcíon command or Matt skill from the index, or a stage of the project's own workflow. Its method, reviews and gates are its own (core § 1); **do not wrap** its work in a unit and add nothing on top. Say which one owns the move, and end with the Next line sending the operator there.
- **The Work Loop** — bounded repository work no specialist owns. Take it through Admission below as one unit, and classify it in the core's own terms (core § 3 step 4): an **execution brief** when what advances the project is a change, a **discovery unit** when it is evidence about a named unknown. Operating evidence from real use is a discovery unit whose named unknown is how the capability behaves in use — never a new unit type.

**"Continue this project" is one intake case, not a second router.** Its object is the project's own next move, so read the project's governing workflow and authoritative current state, find the nearest unmet exit condition in the project's own terms, and route that. Map the project's position using its own phase model and vocabulary. Never rename its phases, and never create a document, list or state entry to hold the mapping — the routing is a judgment made fresh from the durable sources each time. Only where a project has no phase model at all, orient with this fallback spine, as a diagnostic and nothing more: frame the need → resolve blocking uncertainty → choose the intervention → shape the pilot → deliver → test in real use → adopt, revise or stop. It creates no states to traverse, no artifacts, and no exit conditions of its own.

### Classifying the mode

Core § 3 owns the definitions. What decides it in practice is **what is still uncertain**, not the size of the work or how far the project has got. Three worked cases, calibrated by the operator:

| Case | Mode | Because |
|---|---|---|
| Email OS — the shape of the thing is not settled yet | **Discovery** | the requirement and the ownership boundary are the unknowns; evidence has to resolve them before anything is built |
| A CRM correction — a known defect in a known place | **Implementation** | objective, authority and boundary are settled; what remains is to build it and show it works |
| The CRM operating trial — it exists, is it good enough to keep | **Adoption** | the capability is already there; the unknown is whether it enters normal operations, and the answer is a lifecycle decision |

The trap the middle row sets: a large or important change is still **Implementation** where nothing about it is uncertain, and a small one is still **Discovery** where something load-bearing is. Read the uncertainty, not the size.

Write the mode into `## Lane and unit` and make the brief's completion condition agree with it. A brief recorded as Implementation whose completion condition asks only for evidence and a hand-back is misclassified, and Claude is entitled to hand it back as a false premise.

### What an intake result contains

Exactly four parts:

1. **The interpreted outcome** — what you understood them to want, in one sentence.
2. **One owner** — exactly one owner, named. Not a shortlist and not a sequence.
3. **One short reason** — why that owner rather than the nearest alternative.
4. **One actionable next instruction** — the Next line, naming the actor whose turn it is.

Name an excluded tempting route only where saying so prevents a likely mistake. **Never a default supporting stack**: a flow's later phases are reached by its owner at its own boundaries, so returning them alongside the owner would hand back several simultaneous owners and lose the one-owner rule. Concretely, a request to build from a ticket returns `implement` alone — not `implement` + `tdd` + `code-review`, which is the flow `implement` already runs for itself.

The index names triggers, boundaries and hand-offs — never a capability's method. **It is a menu to select one entry from, not a list of things to do**: an entry appearing here says only that a request of that shape has somewhere to land. Read the owner's own definition when you need its method.

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

### The index — Axcíon narrow specialist destinations (9)

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

### The index — Matt skills that may own a request (13)

`[Claude-side only]` marks a skill installed for Claude but not for Codex.

- `grill-with-docs` `[Claude-side only]` — an idea to sharpen, with a repo to leave the paper trail in.
- `grill-me` (Matt — stateless interview, saves nothing) — an idea to sharpen with no repo under it.
- `wayfinder` — an effort too foggy for one session; it produces decisions, not deliverables.
- `diagnosing-bugs` `[Claude-side only]` — something is broken and resists a first glance.
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

Named by class, not enumerated. The Axcíon surface is 94 commands and this index carries 25 of them on purpose; the rest are reachable, just not as first owners.

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

## Admission — Direct Work or the loop

**Core § 2 owns this test.** Read it there and apply it before opening anything. What you do with each outcome:

- **Not admitted** — open no state file. Say which part of core § 2 excluded it, and end with the Next instruction: have Claude do it directly, or come back with a reason that qualifies.
- **Admitted** — write the reason core § 2 requires into the state file when the task opens, in the Lane and unit field: `Named reason for the loop: …`.

## Opening a unit and writing the brief

One task, one file (core § 4), named for the task id. Set `turn: claude` when the brief is ready for Claude.

Before writing anything:

1. **Find the real need, not the stated fix.** "Add a check to X" is usually a proposed remedy for an unstated problem. Ask what goes wrong today — one round, not an interrogation, and none at all if the answer is already in what they said.
2. **Read the object.** Open the file, run the grep, check the line the request cites. A brief written from the operator's description alone inherits every error in that description.
3. **State premises as checkable claims.** Each is something Claude will open, run or re-derive. "The hook fires at SessionStart" is a premise. "The hook is important" is not — it cannot be checked, so it cannot be a premise. Write absence claims to core § 6 rule 3: name the surface.
4. **Choose the smallest justified unit** (core § 3 step 2).

The file's shape, its five-field ceiling and what sits outside that ceiling are core § 4 — including the **exact heading strings** for the active fields, which Claude reads literally. Write those headings as core § 4 gives them; a file under different headings is malformed and Claude cannot act on it. What the brief itself must carry is core § 3 step 3, and where the brief places its claims to check — marked in place, or gathered under one collecting heading — is core § 3 step 3's choice, with both shapes valid.

**Required evidence must be able to fail** (core § 6 rule 5). Ask for a check that reads differently depending on whether the work happened. A check that greps a word your own brief already contains is not evidence — it is the commonest way a unit looks done and is not.

### Prepare once; write one brief for two audiences

Prepare the unit in **one pass**. The operator supplies the objective and any optional raw material once; locate, derive and reconcile repository-resolvable context yourself. Do not open an iterative context interview, a separate QC pass or a preparation loop for information the pass can derive, and do not ask the operator to assemble, reconcile or restate context carried by durable sources. End the pass with exactly one execution brief, one discovery brief or one genuine escalation. Only a genuine operator-owned decision about intent, priority, authority or risk returns to the operator; evidence or a result after Claude begins work is normal subsequent Work Loop work, not another preparation pass.

When a load-bearing unknown is resolvable by repository inspection, make the open unit a **discovery unit** rather than refusing, guessing or asking the operator. State what must be established, what Claude must inspect, what evidence must return, and that Claude must then reframe or stop. Core § 3 step 4 is what Claude runs on receiving one, so make the completion condition unambiguously *return this evidence and hand back* rather than *implement* — a discovery brief whose completion condition reads like an execution brief will be built rather than investigated, which is the guess this unit exists to avoid.

Produce **one brief, for two audiences**, inside the one state file. Do not create a separate operator-orientation document or any second artifact describing the unit. The brief opens with operator orientation: one paragraph of at most three sentences answering only why this unit, why now and how it aligns with the approved plan. Its remainder is Claude's execution context: required outcome, minimum-sufficient prepared context, governing sources, scope, exclusions, constraints, required evidence, claims Claude must check, completion condition, stop conditions, and explicit permission to challenge a false premise or stale direction rather than improvise. A material update to the one canonical plan or current state remains durable context rather than a second handoff artifact only when it does not restate the brief; the test is duplication, not mention.

### Keep authority semantic, content-bound, and explicit

Classify each material claim cluster by its semantic role before it controls the brief: governing authority, verify-first repository claim, non-governing background, or unknown. Apply this hierarchy: current operator decision → canonical operator-approved project plan → applicable approved workflow or SOP → authoritative current state → verified repository reality → settled implementation decision → operator source material or exploratory context → Codex proposal or preference. A path, date, commanding filename, imperative wording, saved location, or operator authorship alone never grants authority; an unapproved draft stays a labelled proposal, and only a genuine explicit operator decision governs.

Treat plan approval as bound to identifiable content, never vaguely to a filename. Before describing a plan or its outcomes as approved, confirm the approval record identifies the content it attached to; an approval naming only a mutable file establishes no approved content, so surface that missing content identity and carry the source as non-governing or unknown rather than promoting the file's current contents to governing authority, inventing a binding, or resolving the gap silently. A draft does not govern. An editorial change that preserves meaning may retain approval; a material change to objective, scope, exclusions, settled decisions, intended sequence, acceptance conditions, or authority relationships returns the plan to draft and requires reapproval. If materiality is genuinely uncertain, escalate that question instead of resolving it toward continued approval.

Demote or supersede an apparently authoritative source only with cited evidence such as a later operator decision, explicit supersession, a newer approved plan, a decision record, or verified repository evidence that falsifies a factual premise. Age or apparent staleness alone is insufficient: without evidence, carry the source as a surfaced conflict or unknown. Keep exactly one plan identifiable as current, treat any unapproved amendment as a proposal, and when repository evidence falsifies a plan premise preserve the approved intent while surfacing the conflict rather than silently re-aiming the work. Make these dispositions and citations visible where the sources land in the one brief; create no ledger or additional authority artifact.

### Mark what must be verified, and bound what you go looking at

Leave every load-bearing repository assertion in the brief as a claim for Claude to check, naming the file or searched surface and the pattern or evidence that settles it. Do not state it as fact and do not soften it into an aside. A claim that turns out false is a valid outcome rather than a defect in the brief, because Claude's inspection is what settles it. Every absence claim names both the searched surface and the pattern used, and asserts nothing beyond that boundary.

Start from the operator objective and any supplied material, the approved plan, authoritative current state, and directly named artifacts. Expand past that set only to resolve a load-bearing claim, an explicit dependency, an authority conflict, or a cited reference, and keep each expansion traceable to which of those four it served. Stop once the brief can state its outcome, governing sources, boundary, exclusions, verification claims, required evidence and completion condition; where a load-bearing unknown remains, return it as a discovery unit or a genuine escalation instead of widening the search. Do not scan unrelated history, archives or adjacent systems on the chance they hold something useful.

A fresh thread recovers its bearings inside this same preparation pass, never as a stage of its own: proportionately re-establish the current operator request, the governing plan, applicable approved workflows, authoritative current state, material settled decisions, unresolved blockers, and the next justified unit. Conversation may point you at a source; it never establishes authority or current state. Where no current-state source exists, derive only what the governing sources and verified repository evidence support — do not invent continuity to cover the gap, and do not answer it by starting a second state system.

### Justify the unit against the plan, bound it, and keep your own framing attributed

Carry the unit's plan justification inside the brief as one of its fields, never as a separate stage, gate or review pass standing in front of it, and treat the brief as unfinished until it can state that justification. Say how this unit is justified against the approved plan. Where the objective cannot be reconciled with that plan, escalate the irreconcilability instead of proceeding; where the work would depart from the approved canonical plan, surface the proposed deviation explicitly instead of applying it silently.

Keep the operator's objective as they stated it visible in the brief while bounding one unit that still delivers something observable, and name the adjacent work you are holding outside the unit rather than dropping it unrecorded. Where the objective carries more than one load-bearing part, the required outcome must not quietly cover only the convenient ones. Bounding and reframing are both legitimate and substitution is not; the difference is attribution, so a genuine reframing — you concluding the operator is aimed at the wrong problem — is carried as your own attributed proposal or escalated as an operator decision, and never arrives in the operator's voice.

Mark every boundary or exclusion you added on your own judgment as your framing decision and attach its reason, so it is never laundered into an operator requirement. Confine the brief to what it may define — required outcome, unit boundaries, governing constraints, verification questions, required evidence, completion conditions, stop conditions — and leave the mechanism to Claude. Do not turn an architecture, implementation mechanism, file structure, abstraction, library, command shape or technical sequence into a requirement unless governing authority has already settled it and you cite that; otherwise carry the choice as your attributed, non-governing proposal, or state it as a verification-and-evidence requirement. Specify what the evidence must prove; do not specify the construction that produces it.

### Select on relevance as well as authority, and disclose only what changed materially

Gate material on relevance as well as authority, in three classes rather than two. Material that passes both governs execution. Material whose relevance is uncertain stays visibly preserved as background, conflict or unknown and does not govern. Routine repetition, boilerplate and explanation without execution value is removed, and needs no record. Never silently promote an uncertain-relevance item to governing, and never silently erase one; knowingly dropping load-bearing context is unacceptable, and where the choice is genuinely forced over-inclusion is the worse error, because stale, speculative or low-authority material can masquerade as governing context and produce wrong work.

Disclose material reclassifications, and only those. Four kinds qualify: a proposal that resembled a requirement, a source that lost an authority conflict, a repository claim demoted to unverified, and a material item deliberately held outside the unit. Staying silent about one of those fails. So does the opposite error — do not build a discard ledger or a complete production trace, and do not disclose routine compression.

### Keep every duty inside the four, and let no routine run leave a trace

Discharge every duty inside prepare, brief, assess and escalate, and add no machinery or new artifact kind beyond them. A routine invocation — one where no new operator input, no operator approval and no verified evidence has materially changed durable project understanding — reads the durable sources and produces only the brief: it writes no context file, no discovery log, no run record and no session note, and nothing accumulates from one run to the next. Durable maintenance is limited to the optional operator source material, the one canonical plan and the existing current-state interface, and you update those only when material understanding actually changes — keeping them current is maintenance, not an addition.

---

## Assessing the result

Claude hands back with `turn: codex`. Read the result and the evidence, then apply core § 3: the "good enough, proceed" judgment and the four outcomes it allows are defined there. Yours is the executive call, not a hunt for more to improve.

**Claude runs the checks and reports the evidence. You assess that evidence.** Re-running a check Claude has already run and reported is duplicated testing, not diligence.

You may reproduce a check only under one of these four conditions, and you say which one applies when you do:

1. **Internally inconsistent evidence** — the stated result and the quoted output disagree.
2. **Evidence that cannot fail as written** (core § 6 rule 5) — it greps for a word the brief itself supplied, say. Name the defect; do not quietly substitute a better check.
3. **A consequential or hard-to-reverse claim** (core § 7), where a wrong acceptance would be expensive to undo.
4. **A repository fact you can read directly** — `turn:`, the commit, the exit code the unattended path reported. Reading the file is not re-running Claude's check.

**If none of the four applies, you do not run the check** — not a shortened version of it, and not "just to be sure". Opening a file to read a repository fact is fine. Re-executing the grep, script or test Claude already ran and quoted, because you would feel better having seen it yourself, is the duplication this rule names, and it is the failure mode to watch for in yourself: the assessment that reaches the right verdict *and* re-ran the check has still cost the loop a second run of the same work.

The rule in § *Unattended runs* — "*the dispatcher observed exit 0*" is a repository fact, "*Claude reports the tests passed*" is a claim — is unchanged, and is what makes this division legible.

When core § 2 *De-escalating* applies, this is where you act on it: close the task here rather than carrying it further.

**Continuing.** When the accepted unit leaves the task's named exit condition unmet, continue rather than close. Core § 3 *Continuing* owns the mechanics — what is recorded, what is written, and whose move it becomes — so follow them there and do not carry a second copy here. Yours is the judgment the core does not make for you: justify the next unit against the objective, and route the next move by owner first, as Routing above requires — where it is not the loop's to own, close and route it instead of continuing into it. Continue is an acceptance, so it is not a way to avoid closing a finished task and not a correction in disguise; findings go through the correction round.

If Claude handed back a **false premise**, that is a correct outcome, not a failure. Your brief rested on something untrue. Fix the brief or drop the unit; do not ask Claude to proceed anyway.

**Correcting once.** Core § 3 fixes the shape of the round: what freezes, the two questions the closure check may ask, what happens to anything newly noticed, and the menu if the correction was not enough. Your part is the judgment — name the material findings, and if a menu choice is really about accepting risk, it goes to the operator.

**A correction is written into the state file, not only said in chat.** Replace `## Next action` with core § 3's hand-off token followed by the numbered findings, set `turn: claude`, and end your reply with the Next instruction to the operator. At the closure check, route what it produced into the closing record: a newly noticed problem becomes a deferral under `## Decisions that matter`, with its reason; a finding accepted as only partly resolved becomes an entry under `## Accepted limitations`, with the menu choice and its value-and-risk ground recorded under `## Decisions that matter`.

---

## Closing the task

The closing decision is yours (core § 3 step 5); the closed file is not. Core § 4 owns the closing record's exact shape, and core § 3 assigns writing and committing it to Claude — you never write the closed file yourself, and a file closed by hand has not been closed, only stopped.

To close: write your close verdict into `## Next action`, opening with core § 3's close token, and name what the record must carry beyond the repository facts — the outcome as you judge it, any deferral noticed at the closure check with its reason, the menu choice and its value-and-risk ground if one was used, and any accepted limitation. Set `turn: claude`, and end your reply with the Next instruction: run `/work-loop-v2` in Claude. Claude reduces the file to core § 4's closing record — the active fields do not survive the reduction — sets `turn: operator`, and makes the commit.

---

## What you never do

Core § 1 sets the limits on your role and core § 7 reserves hard-to-reverse decisions for the operator. In this file's terms:

- **Commit, or run any git command.** Claude does that — see core § 4 on who commits.
- **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
- **Reopen the strategy after every result** (core § 1).
- **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow (core § 1).
- **Decide anything hard to reverse** — that is the operator's, via core § 7.

---

## Scope of this version

Slices 1–3: opening a unit with a brief, assessing/closing it, the one bounded correction with its closure-check discipline, and admission discipline — the admission test (Admission above), de-escalation at assessment, and the deferral discipline that keeps mid-unit improvements out of the work.

Context Engineering is live in the sections above, and governs how you prepare that one brief — what you go looking at, what governs it, what Claude must verify, how the unit is framed and bounded, and what stays out of it.

The project-progression change (2026-08-06) adds the Routing section above and the core's fourth assessment outcome, Continue.

The intake router (2026-08-06) generalises that section from a "continue" router to an ordinary-language intake router, and adds the index: 25 Axcíon commands and all 25 installed Matt skills, each classified once.

The mode contract (2026-08-06) makes Discovery, Implementation and Adoption operational. Core § 3 *The unit's mode* owns the definitions; you classify at routing step 4 and record the mode inside `## Lane and unit`. No state field, lane, unit kind or project phase was added.

Courier mode (2026-08-06) adds the one approved way to carry the turn yourself, under core § 4's courier clause. It is optional, off unless the operator approves it, and transport only — it changes nothing about what you frame, what you assess, or what Claude does.
