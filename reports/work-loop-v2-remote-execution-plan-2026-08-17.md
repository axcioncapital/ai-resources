# Work Loop v2 — Remote Execution Investigation and Plan

**Date:** 2026-08-17
**Status:** PROPOSAL — investigation complete, no implementation performed. Requires three operator policy decisions (§ 6.4) before any build.
**Mandate:** Turn Work Loop v2 into a system that can dispatch, execute, review, and continue bounded work remotely with minimal operator attention — durable task state belonging to Work Loop and Git, not to an AI session or the laptop.

---

## Summary

The investigation found that Work Loop v2 is **closer to remote-executable than expected — by design, not by accident**. The semantic layer (the git-committed state file, the pure-shell validator, the token protocol, the escalation classes, the "every hop is a fresh process" rule) is already transport-agnostic and travels with the repo. Everything laptop-bound is confined to the transport layer: the 2,885-line `dispatch.sh` spike, filesystem leases, the `.owner` declaration, macOS sandbox profiles, `caffeinate`, and the supervised terminal.

Meanwhile, the cloud side has matured to exactly the shape Work Loop needs: **Claude Code cloud sessions** are launchable from the CLI (`claude --cloud "…"`), run asynchronously in Anthropic-managed VMs that survive the laptop closing, clone the repo from GitHub (bringing `.claude/commands/work-loop-v2.md` and the validator scripts with them), push `claude/`-prefixed branches, and open PRs. **Cloud routines** (already provisioned on this account — the RemoteTrigger API is live and one old routine exists from May 2026) can fire on a schedule, on GitHub events, or via API, and each fire is a fresh full-autonomy cloud session. **Codex Cloud** is scriptable from the local CLI (`codex cloud exec/list/status/diff/apply`) and `@codex review` posts reviews directly on GitHub PRs.

The recommended architecture is therefore **not a new platform but a third transport**: the same state file, the same validator, the same four lifecycle pairs — carried by cloud sessions instead of local processes, with **git branches as the remote lease** and a **scheduled cloud routine as the dispatcher tick**. Notably, the two blockers that have kept the local unattended dispatcher from its walk-away pilot (descendant-process escape and unproven worktree isolation) **do not exist in the cloud transport** — VM isolation replaces both.

---

## 1. Current-state diagnosis — where laptop dependency exists today

### 1.1 What actually runs today

Nothing is autonomous today. The live, evidenced mode is: operator asks Codex in chat → Codex routes, admits, writes brief + `.owner` + state file → operator (or, with per-session approval, a one-hop courier `carry-turn.sh`) carries the turn to Claude → Claude validates, implements, commits, sets `turn: codex` → operator carries back. The unattended loop dispatcher (`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, 2,885 lines) exists and is harness-proven in simulation, but:

- The **walk-away pilot has never happened** (`plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md:35-40`).
- Phase 2 is **BLOCKED** on two items: a fully detached descendant process survives the stop, and branch/worktree isolation is documented but never demonstrated (`unattended-operation-plan-v0.2.md:18-25`).
- The current forward plan (`work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md:29`) explicitly **does not target unattended or walk-away execution**.
- Admissions are paused pending the durable-state landing decision (`logs/work-loop/work-loop-v2-durable-state-system.md:19`).

### 1.2 The laptop dependencies, enumerated

**Binaries and OS.** `codex` is a macOS app-bundle path (`/Applications/ChatGPT.app/Contents/Resources/codex`, `dispatch.sh:293`); `claude` comes from local PATH with a ≥ 2.1.219 version gate; `--unattended` fails closed on non-Darwin; `caffeinate -i` is required and lid-close still kills runs unreliably; the OS-backed sandbox profile was measured on one host and can be widened by other local settings scopes.

**Process supervision.** The only proven launch shape is a foreground terminal that stays open — the detached form was measured being reaped before start (`handoff-automation-spike/README.md:508-513`). There is no launchd job, no cron, no daemon anywhere in the repo (verified by exhaustive grep — every launchd mention is prose about a hypothetical future).

**Exclusivity mechanisms.** The live lease lives in `.git/work-loop-dispatch-locks/` (the git common dir — never pushed, meaningless across machines; `work-loop-lease.sh:157-169`). The `.owner` declaration is gitignored and per-physical-checkout; ownership is defined as *a filesystem location* ("the checkout holding `logs/work-loop/{task-id}.md`", SKILL.md:166). Repo-depth ownership checks require `git worktree list` on this machine's filesystem.

**Operator presence.** The operator selects every task (the dispatcher deliberately selects nothing — `dispatch.sh:10-11` and both entry points forbid scanning `logs/work-loop/` for candidates), creates worktrees by hand (production-readiness policy D4), approves Courier mode per session, and carries the turn by default.

### 1.3 What is already remote-ready

- **State is in git.** All 75 task-state files under `logs/work-loop/` are tracked and committed. The repo has a live GitHub remote (`github.com/axcioncapital/ai-resources`).
- **The lifecycle authority travels with the repo.** `logs/scripts/work-loop-state.sh` is 342 lines of pure POSIX shell + awk — no git, no network, no host assumptions. Any checkout that has the repo has the validator.
- **Every hop is already a fresh stateless process** with the state file as the entire shared memory (SKILL.md:234). A cloud session that clones, works, commits, and dies is *exactly* a Work Loop hop — no adaptation of the mental model needed.
- **Handoff is protocol tokens in a committed text field**, not RPC. Resumability is defined as "read the state file and the repository; do not rebuild from memory or chat" (core § 3 step 1).
- **The governance layer names no products or machines.** The core deliberately refuses to name the courier's mechanism (core:322-323) — a cloud courier is contractually anticipated.

The clean seam: **semantic layer portable, transport layer local.** The only two mechanisms with no portable equivalent are the pid-keyed lease and the path-bound `.owner` declaration — both solvable with git-native equivalents (§ 3.3).

---

## 2. Available cloud capabilities (verified August 2026)

### 2.1 Claude (Anthropic) — verified against code.claude.com / platform.claude.com docs

| Capability | Status | Key facts |
|---|---|---|
| **Cloud sessions** (claude.ai/code) | Research preview; Pro/Max/Team/Enterprise | Launch from CLI: `claude --cloud "task"`. Clones repo from GitHub, runs commands/tests, commits, pushes `claude/`-prefixed branches (always accepted), opens PRs. **Runs asynchronously; survives browser close and laptop offline.** Follow-ups from any device: `claude -p "msg" --cloud <session-id>`. Auth via Claude GitHub App or `/web-setup` (syncs the local `gh` token — already authenticated on this machine with `repo`+`workflow` scopes). Anthropic-managed VM, configurable network policy. Billed against subscription quota; no separate compute charge. |
| **Cloud routines** (scheduled/triggered agents) | Research preview | Saved prompt + repo + environment + trigger. Triggers: **cron (hourly minimum)**, one-off timestamp, **GitHub events (PR opened/updated/closed, release; with filters)**, or **API POST** (returns `{session_id, session_url}`). Each fire = fresh full-autonomy cloud session that clones the default branch, can commit/push `claude/` branches and open PRs. Daily run cap; webhook rate caps. **This account already has the RemoteTrigger API live** (one legacy routine from 2026-05, auto-disabled after repo access lapsed — proof of prior working setup, and a reminder that the routine's repo connection must point at `ai-resources`, not the dead `ai-repository`). |
| **Managed Agents API** | Beta (`managed-agents-2026-04-01`) | Anthropic-hosted agent harness; **sessions are stateful and resumable**, pollable via `/sessions/{id}/events`. Pay-per-token at API rates. More capable but a second billing model and credential provisioning burden — **not needed for the MVP**. |
| **claude-code-action** (GitHub Actions) | Stable v1 | Runs Claude Code inside an Actions job (6 h ceiling). Triggers: `@claude` mentions, issue assignment, `workflow_dispatch`, cron. Can commit, push, open PRs. **Accepts subscription OAuth token (`claude setup-token`)** — no API key required. |
| Remote Control / push notifications | Preview | Steer a *local* session from phone; **does not solve laptop-closed** (local machine must stay awake). Not part of this architecture. |

### 2.2 Codex (OpenAI) — verified against learn.chatgpt.com docs and local CLI 0.147.0

| Capability | Status | Key facts |
|---|---|---|
| **Codex Cloud tasks** | GA | OpenAI-hosted containers; clones connected GitHub repo, runs setup script + tests, produces diff → follow-ups → PR. Created from web, IDE, Slack, GitHub `@codex` comments, or **the local CLI: `codex cloud exec --env ENV_ID` (with `--attempts 1-4` best-of-N), `codex cloud list/status/diff/apply`** — verified present in the installed CLI. **No public REST API**; environment IDs must be set up once in the web UI; no message/cancel/logs primitives (open issue #24777). Shares the ChatGPT-plan usage window. |
| **`@codex review` on GitHub PRs** | GA | Posts a PR review flagging P0/P1 issues; **automatic review of every newly opened PR** is a per-repo toggle; `@codex security review` in research preview. Guidance via `AGENTS.md` `## Code Review Rules`. **This runs entirely in OpenAI's cloud, triggered by GitHub — zero laptop involvement.** |
| Codex SDK | GA | Local-only (drives the local app-server) — not a cloud-task API. |
| openai/codex-action | GA | Runs `codex exec` in Actions, **API-key only** (no subscription auth). |

### 2.3 GitHub

- **GitHub Mobile**: full PR review/approve/merge loop from the phone; agent-task panels.
- **Actions**: 6 h/job hosted, API-drivable (`workflow_dispatch`), 20+ concurrent jobs.
- State-file edits are possible from GitHub mobile/web (answering a `## Blocker` by editing the file on the branch), so the operator can unblock a task from a phone.

### 2.4 The decisive facts for the architecture

1. A cloud worker session **clones the repo — so it automatically has** `.claude/commands/work-loop-v2.md`, `logs/scripts/work-loop-state.sh`, `work-loop-owner.sh`, and the skill. Deployment-completeness (`work-loop-capability.sh`) is satisfied by the clone itself.
2. A routine's fire is a **fresh, stateless, full-autonomy session** — identical in shape to a Work Loop hop. No resumability is needed because the loop never relied on process-level resumability: the state file is the memory.
3. **Codex's cloud presence is strongest as a PR reviewer**, which happens to be exactly the assessor role the workspace Independent Review Rule already assigns to Codex.
4. Both worker paths bill against existing subscriptions; no new infrastructure, accounts, or servers are required.

---

## 3. Recommended architecture — the cloud transport

### 3.1 Principle

**Do not port the dispatcher. Port the contract.** The 2,885-line `dispatch.sh` exists to make a hostile environment (a shared laptop, a bypassPermissions checkout, escaping descendants, sleep, shared worktrees) safe for unattended hops. The cloud environment eliminates the hazards that script exists to contain: each hop runs in an isolated fresh VM (no descendant escape, no lease contention, no foreign worktrees, no sleep, no local settings-scope merging). What must survive the move is the **semantic contract**: validator-established lifecycle, the four legal state pairs, the allowed transitions, one bounded correction round, `BLOCKED_OPERATOR`/`CLOSED` terminal for all automation, and evidence-that-can-fail.

### 3.2 The model

```
Operator (before leaving)
   │  approves a bounded, ordered queue of admitted tasks
   │  (each with brief + state file, committed and pushed)
   ▼
Work Loop control plane  =  the repo on GitHub
   • logs/work-loop/queue.md          ← the bounded queue (committed)
   • logs/work-loop/{task-id}.md      ← per-task state (committed)
   • work-loop/{task-id} branches     ← remote claim + workspace per task
   ▼
Dispatcher tick  =  a Claude cloud routine (hourly cron + optional PR-event trigger)
   1. clone repo, run work-loop-state.sh on queue head
   2. ACTIVE_CLAUDE  → launch/continue the execution hop for that task
      ACTIVE_CODEX   → check for Codex PR review / run assessment path
      BLOCKED_OPERATOR / CLOSED → skip to next queue entry (terminal for automation)
   3. enforce per-task hop cap and one-retry rule; write attention notes
   ▼
Workers
   • Claude cloud session: executes the unit on the task branch,
     commits state + work, pushes, opens/updates the task PR
   • Codex: @codex auto-review posts the assessment on the PR
     (zero-laptop path); richer Codex assessment optional later
   ▼
Results  =  git + PRs
   • task branch with commits + updated state file
   • PR per task, reviewed by Codex
   • logs/work-loop/attention.md — concise operator-attention list
   ▼
Operator (on return, or from phone)
   • reads attention.md / PR list
   • answers blockers (edit state file via GitHub mobile, or
     `claude -p "…" --cloud <session-id>` from any device)
   • merges PRs (operator-only, unchanged)
```

The Work Loop **remains the control plane** — but the control plane's substrate moves from "a shell process on the laptop" to "the repo on GitHub, advanced by a scheduled tick." Claude/Codex cloud environments are pure workers, exactly as the mandate asks.

### 3.3 Git-native replacements for the two non-portable mechanisms

- **Remote claim (replaces the lease + `.owner` for the remote transport):** one task = one branch, `work-loop/{task-id}`. Branch existence on `origin` = the task is claimed by the remote transport; branch deleted after merge/close = released. Branch creation is atomic on GitHub (a second create fails), giving the same one-writer-per-task guarantee the lease provides locally. The local `.owner`/lease machinery stays untouched for local transports — and the branch claim is *visible to it*: a small addition to Claude's Step 1.5 refuses local work on a task whose `work-loop/{task-id}` branch exists on origin (and vice versa: the remote dispatcher refuses tasks with a local `.owner` claim pushed... which cannot be seen — so the rule is one-directional: **a task enters the queue only after local closure or explicit local release**, checked at queue-build time by the operator's session).
- **Hop accounting (replaces the dispatcher's in-process hop counter):** count commits touching the state file on the task branch, or a `hops:` line in the run log section of `queue.md`. Durable, derivable from git alone, idempotent across tick restarts.

### 3.4 What is deliberately NOT built

- No Managed Agents API, no database, no queueing service, no webhook server, no self-hosted runner, no new billing relationship. (GitHub Actions with `claude-code-action` is the documented **fallback transport** if cloud sessions/routines prove too preview-unstable — it is stable v1 and takes the subscription OAuth token — but it is not the primary path.)
- No port of `dispatch.sh`. The local spike remains the local transport, unchanged, for supervised use.
- No autonomous task *selection*. The queue is operator-authored and ordered; the tick only walks it. This preserves the spirit of "the dispatcher selects nothing" while enabling continuation — see decision D2 in § 6.4.

---

## 4. Dispatcher changes — what Work Loop v2 needs

Three small additions, all riding on existing components:

### 4.1 A queue format: `logs/work-loop/queue.md` (new, committed)

Frontmatter-plus-list, deliberately minimal:

```markdown
---
queue: 2026-08-21-overnight
approved: 2026-08-21
max-hops-per-task: 4
expires: 2026-08-23
---
1. crm-follow-up-date
2. prose-pipeline-subagent-returns
3. reorient-hook-portability
```

Rules: every listed task id must already have a valid admitted state file (validator-checked at queue build); ordering is priority; `expires` bounds the automation window; an exhausted or expired queue stops the tick cold. The queue is built and committed by the operator's normal (local or cloud) session before leaving — this is the **authorization artifact**.

### 4.2 A remote worker profile inside `/work-loop-v2` (edit, not new)

The existing command needs a small cloud-awareness pass:

- **Step 0/1.5 adaptation:** in a cloud clone, `work-loop-capability.sh` and the validator run as-is (they travel with the repo). Ownership: the clone is its own checkout, so `.owner` semantics work *within* the session; the cross-machine claim is the `work-loop/{task-id}` branch (§ 3.3). Step 1.5 gains the branch-claim check.
- **Branch discipline:** work happens on `work-loop/{task-id}` (or the `claude/`-prefixed equivalent if branch-push rules require it — to be confirmed in Tracer A, § 7); state file committed on that branch; push at end of hop is **in-scope for the remote profile only** (decision D1, § 6.4).
- **End-of-hop contract unchanged:** valid state, legal transition, explicit-pathspec commits, `turn:` handed to `codex` or `operator`.

### 4.3 A tick command: `/work-loop-remote-tick` (new, small)

The routine's saved prompt invokes this command. It is the *entire* remote dispatcher — target under ~150 lines of command prose because the guards it needs already exist as scripts:

1. Read `queue.md`; if absent/expired/exhausted → stop (write nothing).
2. For the first non-terminal entry: run `work-loop-state.sh` (on the branch if claimed, else on main). **Lifecycle unestablished → skip task, note in attention file** (fail-closed, matching existing doctrine).
3. `ACTIVE_CLAUDE` → perform the execution hop in this session (the tick session *is* the worker — simplest form; one task-hop per tick keeps runs bounded and inspectable).
4. `ACTIVE_CODEX` → check the task PR for a Codex review; if present, apply the § 4 core protocol (close token / continue / one frozen correction round) as far as the review's content supports; if absent, ensure the PR exists so auto-review fires, then stop.
5. `BLOCKED_OPERATOR` / `CLOSED` → terminal for automation (unchanged core rule); append to `attention.md`; move to next entry.
6. Enforce `max-hops-per-task` from git history; on breach → mark blocked-for-operator with the hop evidence.
7. One-retry rule: a hop that provably changed nothing (state sha + branch HEAD identical) may be retried once per task, mirroring `dispatch.sh:2724-2762`.
8. Always finish by committing `attention.md` updates to the queue branch.

**Codex's role in the remote loop, MVP form:** enable **automatic `@codex review`** on the repo so every task PR gets an independent Codex review with zero laptop involvement. The tick treats that review as the assessment input. This keeps "Codex is the reviewer" (workspace Independent Review Rule) intact in the cloud. The fuller symmetric form — `codex cloud exec` running the `$work-loop-v2` skill as assessor and writing the turn itself — is a Phase-3 option, gated on decision D3 (§ 6.4), because Codex-in-cloud *can* produce commits, which collides with the measured local "Codex never runs git" constraint the current contract encodes.

---

## 5. Persistence and recovery

**Everything durable is in git; everything ephemeral is disposable.**

| State | Where it lives | Survives what |
|---|---|---|
| Task lifecycle + latest result | `logs/work-loop/{task-id}.md`, committed on the task branch | Everything — session death, routine failure, laptop loss |
| Queue + authorization window | `logs/work-loop/queue.md`, committed | Everything |
| Work product | commits on `work-loop/{task-id}` branch + PR | Everything |
| Assessment | Codex PR review on GitHub | Everything |
| Remote claim | branch existence on origin | Everything (released by delete-after-merge) |
| Hop count | commit history on the task branch | Everything |
| Operator-attention list | `logs/work-loop/attention.md`, committed | Everything |
| A running hop's in-flight context | the cloud session | **Nothing — and by design that is fine** |

Recovery semantics fall directly out of existing doctrine:

- **A worker session dies mid-hop:** the branch holds whatever was pushed; the state file's `turn:` is unchanged, so the next tick sees the same classification and the one-retry rule governs. Un-pushed partial work is lost — acceptable, because a hop is bounded (core: minimum necessary work, 85–90% bar) and "every hop is a fresh process" was already the contract. This mirrors `PARTIAL FILE EFFECTS` handling in the local dispatcher.
- **The routine itself fails to fire or errors:** nothing corrupts — the tick is idempotent because it derives everything from git truth and never trusts memory (core § 3 step 1). The next hourly fire resumes. Routine run history is inspectable via `RemoteTrigger list_runs` / `get_run_log` from any later session.
- **Conflicting writes:** structurally excluded — one branch per task, one tick at a time (hourly cadence + the branch claim), state file only ever written by the actor holding the turn.
- **The known local-dispatcher blockers do not carry over:** descendant escape (VM teardown is Anthropic's problem, and a leaked process inside a dead VM touches nothing of ours) and worktree isolation (every session is a fresh clone — isolation is the default, not an achievement).

One genuine new risk: **preview-stage platform behavior** (routines and cloud sessions are research previews; caps and semantics can change). Mitigation: the queue's `expires` field bounds blast radius; the tick's fail-closed skips mean platform misbehavior produces *skipped work plus attention notes*, not wrong work. Fallback transport documented in § 3.4.

---

## 6. Operator controls — autonomous vs escalate

### 6.1 What continues autonomously while away

- Every hop on a **queued, admitted** task, within `max-hops-per-task` and the queue's `expires` window.
- The Codex PR review, the continue path, and **one** frozen correction round per task (existing core § 5 bound — unchanged).
- Progression to the **next queue entry** when a task closes or blocks.
- Writing/committing state, branches, PRs, and the attention file.

### 6.2 What stops for the operator (unchanged from the core, now enforced by the tick)

The entire core § 7 escalation catalogue stays word-for-word: scope expansion, ungranted capabilities, residual-risk acceptance, destructive/shared-state actions, credential use, reopening operator-owned decisions, invented intent, stale/foreign state. `BLOCKED_OPERATOR` and `CLOSED` remain **terminal for all automation** — the tick may never continue past them on that task (it may only move to the *next* task, which is queue-walking, not decision-making). **Merging any PR remains operator-only** ("Neither actor merges or authorizes its own work", core:197) — and GitHub Mobile makes that a from-the-phone action.

### 6.3 The attention surface

On return (or from the phone at any point) the operator reads exactly two things:

1. **`logs/work-loop/attention.md`** — one line per item: blocked tasks with their `## Blocker` question, hop-cap breaches, skipped/unestablished tasks, queue exhaustion.
2. **The PR list** — one PR per task, each carrying the Codex review and the state file diff.

Answering a blocker from the phone: edit the state file on the branch via GitHub mobile (set the answer into `## Next action`, flip `status: active` / `turn: claude`) — the next tick picks it up. No special tooling required.

### 6.4 Three policy decisions required before building (surfaced, not resolved — these are operator-owned)

- **D1 — Push gating.** The workspace rule "push is gated and batched to wrap; never push mid-session" is incompatible with any remote transport (workers must push to hand off). Proposed amendment: a **scoped standing authorization** — pushes of `work-loop/*` and `claude/*` branches by remote workers are pre-authorized; pushes to `main` and all other branches remain gated exactly as today. Cloud sessions already can't push to protected branches, so the platform enforces part of this.
- **D2 — Selection doctrine.** "The dispatcher selects nothing" was ratified against *autonomous* selection (scanning for candidates). The queue walk is selection from an operator-authored ordered list inside an operator-set window. Proposed reading: the queue **is** the operator's selection, made in advance; the tick executes it. If you consider this a material change to a settled decision, it needs your explicit sign-off (it is one, in my judgment — hence this line).
- **D3 — Codex's git abstinence.** "Codex never runs git / Claude commits" encodes a *measured local sandbox fact*, not a governance principle. In the MVP, Codex's cloud role (PR reviews) writes no git state, so the contract is untouched. Before any Phase-3 symmetric Codex worker, the core's § 4 would need a deliberate amendment — flagged now so it is never drifted into.

Also worth stating: remote workers consume the same subscription quota as interactive use, and routines have a daily run cap. The hourly tick with one task-hop per fire is deliberately modest; an overnight window is ~8–10 hops, which matches the intended "bounded queue" posture rather than fighting the caps.

---

## 7. Implementation path — smallest sequence that proves it

Sequencing note: the repo's own plans gate new dispatcher work on the durable-state branch landing (`work-loop-v2-durable-state-system.md:19` — admissions paused). Tracers A/B below touch no Work Loop state files and can run immediately; Phase 1+ should follow the landing decision.

**Tracer A — one manual cloud hop (half a day, no new files).**
From a local session: pick a trivial real task, write its state file locally, commit, push a `work-loop/{task-id}` branch, then `claude --cloud "/work-loop-v2 {task-id}"`. Close the laptop. Later, verify from the phone/web: the session ran, the command file was honored, the validator gated correctly, work + state were committed and pushed, a PR exists.
*Proves:* cloud sessions execute the existing entry point unmodified; branch push mechanics; the laptop-closed property. *Also answers:* whether cloud workers can push `work-loop/*` branch names or must use `claude/*` (affects § 3.3 naming).

**Tracer B — zero-laptop review (an hour).**
Enable automatic `@codex review` on `axcioncapital/ai-resources`. Confirm the Tracer-A PR receives a Codex review with the laptop closed.
*Proves:* the assessor half runs remotely with no new machinery.

**Phase 1 — the remote profile (one session).**
Amend `/work-loop-v2` per § 4.2 (cloud-checkout detection, branch claim in Step 1.5, remote-profile push authorization per D1). Add the queue format doc. Everything validator-checked; no behavior change for local transports.

**Phase 2 — the tick (one session).**
Write `/work-loop-remote-tick` per § 4.3. Create the routine via the RemoteTrigger API (hourly cron; repo `axcioncapital/ai-resources`; prompt = invoke the tick command), pointing at a **correct, currently-accessible repo connection** (the May routine died of `auto_disabled_repo_access` — re-verify the GitHub app grant). Dry-run: an empty queue must produce a clean no-op; a one-task queue must reproduce Tracer A end-to-end without any manual step.

**Phase 3 — the walk-away pilot (the MVP acceptance test).**
A real queue of 2–3 admitted low-consequence tasks, `expires` +48 h, laptop closed overnight. Success = the mandate's own sentence: completed and verified results (branches + PRs + Codex reviews + valid `CLOSED`/`BLOCKED_OPERATOR` state files) plus a concise attention list — with zero mid-run operator involvement.

**Deferred (explicitly not now):** symmetric Codex cloud workers (D3), `codex cloud exec` integration, GitHub-event-triggered ticks (the hourly cron is enough; PR-event triggers are an optimization), Managed Agents, any Actions-based fallback build-out.

---

## Appendix — source basis

- **Implementation map:** end-to-end read of `dispatch.sh`, `carry-turn.sh`, `work-loop-state.sh`, `work-loop-owner.sh`, `work-loop-lease.sh`, `work-loop-capability.sh`, `work-loop-session-preflight.sh`, both entry points, the executable core v0.1, the production-readiness policy, and the unattended-operation plan v0.2 (file:line citations inline above).
- **Claude capabilities:** code.claude.com/docs (claude-code-on-the-web, routines, github-actions), platform.claude.com/docs (managed-agents). Live verification in this session: RemoteTrigger API reachable; one legacy routine on the account; `gh` authenticated (`repo`, `workflow`); origin = github.com/axcioncapital/ai-resources.
- **Codex/GitHub capabilities:** learn.chatgpt.com/docs (cloud, cloud-environment, developer-commands, codex-sdk, third-party/github, pricing, remote), openai/codex issue #24777, docs.github.com (Actions limits, Copilot cloud agent). Live verification: `codex-cli 0.147.0` installed with `cloud exec/list/status/diff/apply` subcommands present.
