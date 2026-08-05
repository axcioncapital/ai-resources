# Work Loop v2 handoff automation — feasibility investigation

**Date:** 2026-08-05  
**Scope:** discovery only; no automation implemented.  
**Decision in one line:** automate the **transport of an already explicit turn**, not the judgment that creates it. Prove one task with a small external dispatcher that launches one-shot Codex/Claude runs and validates the same task-state file after every run; do not make the two products' `Stop` hooks launch each other directly.

## Executive finding

The opportunity is real. Both installed products now expose enough lifecycle and non-interactive capability to remove the operator from routine Codex → Claude → Codex transport:

- Codex has a real `Stop` hook plus `codex exec`, JSONL events, and resumable session IDs.
- Claude Code has a real `Stop` hook plus `claude -p`, structured output, session resume, and background-session management.
- Both can run a command that starts the other product.

The unsafe part is not process launch; it is **routing and ownership**. A `Stop` hook fires for every finished turn, has no matcher on either product, and does not intrinsically know which `logs/work-loop/{task-id}.md` belongs to that session. The live folder currently contains 22 Markdown files: three say `turn: codex`, one says `turn: claude`, sixteen say `turn: operator`, and two are non-state fixtures. The sole `turn: claude` file intentionally has a filename/`task:` mismatch. Therefore “scan the folder and start whoever has a turn” is already disproven by the repository.

The smallest safe design is a task-scoped dispatcher invoked with an **exact task id and checkout path**. It treats the existing file as the only semantic interface, runs at most one actor at a time in that checkout, and stops on `turn: operator`, invalid state, no state transition, process failure, timeout, dirty-tree ambiguity, or a hop limit. This preserves the Work Loop while removing routine babysitting.

## Governing repository boundaries

This investigation is justified because the approved proposal explicitly puts automatic triggering, automatic session creation, and hooks in post-MVP work once real operation supplies a trigger (`plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`, **§ 7 Post-MVP**). The operator has now named the trigger: babysitting several live loops.

The design still must preserve these approved decisions:

- **No self-hosting:** Work Loop v2 did not govern this investigation or its eventual build (`work-loop-v2-mvp-proposal-v0.4.md`, **§ 6 Standing rules — No self-hosting**).
- **One authoritative interface:** physical form may evolve, but no competing semantic state system may appear (`work-loop-v2-mvp-proposal-v0.4.md`, **§ 3 decision 6** and **§ 6 One interface, not one dogma**).
- **Behavior before transport:** the complete-system reference deliberately leaves hooks, polling, session IDs, retries, automatic session creation, and crash recovery undefined until justified (`plans/work-loop-v2-mvp/the-work-loop-explained-complete-system-v0.2.md`, **§ 24 The automation boundary**).
- **Role boundary:** Codex frames and assesses; Claude verifies repository reality, implements, tests, supplies evidence, and makes every commit; the operator owns priorities, scope, and hard-to-reverse decisions (`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, **§ 1 Who does what** and **§ 4 Who commits**).
- **Operator stops stay stops:** `turn: operator` is terminal for automation. The specific operator triggers are fixed in executable core **§ 7 When to stop and ask**.
- **Fresh-session durability remains the standard:** conversation is not the interface; the file and Git must let fresh sessions continue (`work-loop-v2-executable-core-v0.1.md`, **§ 3 Orient** and **§ 4 The task-state file**).

One authority caveat should be kept visible: the proposal is marked “Approved direction,” while the executable core's own header still says “draft for operator approval.” The deployed Codex skill and Claude command both treat the core as their contract, so this report uses it as deployed behavior without silently upgrading its recorded approval status (`.agents/skills/work-loop-v2/SKILL.md`, opening contract; `.claude/commands/work-loop-v2.md`, opening contract).

## Exact product capabilities

### Codex

- Codex hooks include `Stop`, `SessionStart`, and `SessionEnd`. Project hooks can live in `.codex/hooks.json`; project-local hooks run only for a trusted project layer, and every changed non-managed command hook must be reviewed and trusted by exact hash. [`Codex hooks`](https://learn.chatgpt.com/docs/hooks)
- `Stop` runs at the end of a turn, receives `session_id`, `cwd`, `turn_id`, `permission_mode`, `stop_hook_active`, and `last_assistant_message`, and does **not** support a matcher. Returning `decision: "block"` creates a new continuation prompt; the hook must inspect `stop_hook_active` so it does not create an endless continuation loop. [`Codex Stop`](https://learn.chatgpt.com/docs/hooks#stop)
- Codex command hooks are synchronous today. The default timeout is 600 seconds for most hooks; `async` is parsed but unsupported, and only `type: "command"` handlers run. Multiple matching hooks launch concurrently. [`Codex hook runtime`](https://learn.chatgpt.com/docs/hooks#config-shape)
- `SessionEnd` is not an immediate handoff signal: it may occur on close/archive/delete or after 30 minutes idle with no connected client, and its output cannot steer Codex. [`Codex SessionEnd`](https://learn.chatgpt.com/docs/hooks#sessionend)
- `codex exec` is the official scripted/CI entry point. It is read-only by default; `--sandbox workspace-write` allows repository edits. `--json` emits events including `thread.started`, `turn.completed`, and `turn.failed`, and the returned thread ID can be targeted later with `codex exec resume <SESSION_ID>`. The documentation exposes no overall wall-clock timeout flag, so the dispatcher must enforce one externally. [`Codex non-interactive mode`](https://learn.chatgpt.com/docs/non-interactive-mode)
- For a later persistent controller, the Codex SDK can start, continue, and resume local threads from TypeScript or Python, while App Server exposes JSON-RPC methods for thread start/resume/fork and turn start/steer/interrupt plus streamed events and approval requests. Those interfaces offer cleaner supervision than shell nesting, but are unnecessary for the first process-exit pilot. [`Codex SDK`](https://learn.chatgpt.com/docs/codex-sdk) [`Codex App Server`](https://learn.chatgpt.com/docs/app-server)
- **Local observation (2026-08-05):** `/Applications/ChatGPT.app/Contents/Resources/codex --version` reports `0.146.0-alpha.9.2`; the bare `codex` on `PATH` remains the non-working launcher already recorded in `plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md`, **§ 5 The command-line tool**. Any spike must use the explicit app binary and re-check it before every launch.
- This repo already proves Codex project hooks are a live mechanism: `.codex/hooks.json` has `PreToolUse`, `PostToolUse`, `SessionStart`, and three `Stop` handlers. The new capability therefore does not require introducing a new configuration surface.

### Claude Code

- `Stop` fires when the main agent finishes responding, but not on user interruption; API failures fire the non-controlling `StopFailure` event instead. It receives `session_id`, `cwd`, `permission_mode`, `stop_hook_active`, `last_assistant_message`, background-task state, and scheduled wakeups. After eight consecutive Stop-driven continuations, Claude Code ends the turn. [`Claude Code Stop`](https://code.claude.com/docs/en/hooks#stop)
- `Stop` has no matcher. A hook can return `decision: "block"` plus a reason, or non-error `additionalContext`, to continue Claude. Hooks normally block until completion. Command hooks may be async, but async output cannot decide the completed action; in `-p` mode an unfinished async hook is killed at teardown unless it starts a fully detached process. [`Claude Code hooks`](https://code.claude.com/docs/en/hooks#run-hooks-in-the-background)
- Claude command hooks run with the operating-system user's full permissions, not a narrow repository sandbox. Hook input must therefore be treated as untrusted and paths validated/canonicalized. [`Claude hook security`](https://code.claude.com/docs/en/hooks#security-considerations)
- `claude -p` is the official non-interactive entry point and supports `text`, `json`, and `stream-json` output, explicit `--max-turns`, `--max-budget-usd`, permission modes, and a permission-prompt tool. A session can be resumed by ID, continued from the directory's latest conversation, or forked. [`Claude Code CLI`](https://code.claude.com/docs/en/cli-reference) The Agent SDK exposes the same loop as a Python/TypeScript library if application-owned orchestration later earns its cost. [`Claude Agent SDK`](https://code.claude.com/docs/en/agent-sdk/overview)
- Claude's background-agent supervisor can persist and report multiple sessions (`claude --bg`, `claude agents --json`) across terminal closure and supervisor restarts. However, background sessions automatically move into an isolated Git worktree before editing unless isolation is disabled or the session already started in a linked worktree. That makes a casual `claude --bg` launch incompatible with a main-checkout state file: Codex would not see the branch-local handback. [`Claude agent view and isolation`](https://code.claude.com/docs/en/agent-view#how-file-edits-are-isolated)
- **Local observation (2026-08-05):** the installed Claude Code reports `2.1.220`. The relevant Stop and background-session fields appear in the current official documentation, but their exact installed behavior remains a spike premise. This repo already has project `Stop` hooks in `.claude/settings.json`; no new settings surface is needed.

## Can either side trigger the other safely?

**Mechanically, yes. Directly and generally, no.**

A Codex command hook can start `claude -p`, and a Claude command hook can start the explicit Codex app binary with `exec`. But reciprocal `Stop` hooks would create a nested process chain with six unresolved hazards:

1. **No task routing.** Neither Stop event has matcher support or a Work Loop task id. `session_id` identifies a product conversation, not `logs/work-loop/{task-id}.md`.
2. **Every session fires it.** A project-level Stop hook also runs after unrelated Codex and Claude work. Guessing from the latest file or from `last_assistant_message` is not an identity contract.
3. **Blocking lifecycle.** Codex has no async command hooks. If its hook waits for Claude, the Codex turn remains inside the hook for the full Claude run; if it detaches Claude, Codex supplies no durable supervision or completion result.
4. **Recursive failure.** Claude's Stop would launch Codex, whose Stop launches Claude again. `turn:` can prevent correct-path recursion, but a stale/malformed file, no-op completion, or wrong task selection can loop or strand child processes unless an external owner imposes a hop limit and idempotency check.
5. **Crash ambiguity.** A process can fail after editing but before updating/committing the state file. Product session resume exists, but blindly resuming or rerunning after partial side effects is not safe.
6. **Permissions expand invisibly.** Claude's hook itself has full user permissions; bypass flags on either child would turn a transport mechanism into an approval bypass. Hook trust and model-tool permissions are separate boundaries.

The safe interpretation of hooks here is **signal or wakeup**, not “be the orchestrator.” A hook may notify one task-scoped dispatcher that a known actor stopped. The dispatcher, not the hook, owns validation, deduplication, process lifetime, and the next launch.

## Repository routing and concurrency hazards

The deployed interface deliberately supports explicit routing and rejects guessing:

- Claude accepts a task id, or an empty invocation only when exactly one file says `turn: claude`; if several qualify it lists them and asks. It validates filename/`task:` identity and `turn:` before mutation (`.claude/commands/work-loop-v2.md`, **Step 1 — Orient**).
- Codex writes one file per task and never runs Git; its current response tells the operator which actor holds the new `turn:` (`.agents/skills/work-loop-v2/SKILL.md`, **The seam**).
- Core safety rule 2 requires a missing, malformed, stale, or foreign file to be rejected read-only (`work-loop-v2-executable-core-v0.1.md`, **§ 6 Safety rules**).

The present folder proves why exact routing matters: 22 Markdown files coexist, including several old fixtures that still advertise Codex turns and a deliberately foreign Claude fixture. An automated glob cannot distinguish “live work” from test residue because the schema has no `status`, checkout identity, actor session id, generation number, or lease. Adding those as new protocol fields might be possible inside the one interface, but the minimal pilot does not need them: its exact task id is supplied once at launch and retained in dispatcher memory.

More importantly, **several automated loops must not share one checkout**. The repository's parallel-session authority says same-checkout concurrency silently overwrites uncommitted edits and requires a worktree per parallel unit after a file-ownership map (`docs/parallel-sessions-playbook.md`, **§ 1–2** and **§ 4 Operating procedure**). The current concurrency hook states the same limit and admits detection is a nudge, not full enforcement (`.claude/hooks/detect-concurrent-session.sh`, header contract). Explicit-path staging reduces cross-session commit contamination but does not protect co-edited working-tree files (`docs/commit-discipline.md`, **Concurrent-session staging discipline**).

Therefore:

- one dispatcher may serialize several task ids in one checkout, but not run their actors concurrently;
- true simultaneous Work Loops require one pre-created linked worktree per task, both actors launched with that worktree as `cwd`, and a deliberate serial landing pass;
- a Claude `--bg` session's automatic worktree is not enough by itself because the paired Codex process must be launched in the exact same resulting worktree, and integration still has to be owned.

## Architecture options

| Option | Shape | Benefit | Main problem | Verdict |
|---|---|---|---|---|
| 1. Reciprocal Stop hooks | Codex Stop shells to Claude; Claude Stop shells to Codex | Few files; immediate | No task identity, nested processes, Codex hook blocks, recursion/crash supervision missing | **Reject** |
| 2. Task-scoped process-exit dispatcher | One operator command receives checkout + task id; alternates `codex exec` and `claude -p`, re-reading the file after each exit | Small, inspectable, no new semantic state, easy crash restart | Initially one task per checkout; dispatcher must enforce strict stops | **Recommended pilot** |
| 3. Stop hooks → local dispatcher/daemon | Hooks send session/turn events to a persistent service; service routes and launches | Can supervise many tasks and survive terminal closure | Requires durable session↔task registration, queue dedupe, service lifecycle, and a second operational state surface | **Defer until Option 2 proves the seam** |
| 4. Per-task worktree supervisors | One Option-2 dispatcher per linked worktree; optional Claude background supervisor; serial landing | Safest route to real parallel loops | Adds worktree creation, branch/merge/teardown, overlap policy, and operator-owned conflict decisions | **Likely target for multi-loop use, but not the first spike** |

## Minimal recommended pilot

Run a throwaway **single-task, single-checkout, two-to-four-hop dispatcher spike**. Start from a valid fixture whose `turn:` is already `codex` or `claude`; new-request intake remains operator → Codex as core § 4 requires.

The dispatcher contract should be only this:

1. Receive an absolute trusted checkout path and exact task id; resolve one canonical path `logs/work-loop/{task-id}.md` and reject path traversal.
2. Validate filename = frontmatter `task`, allowed exact headings, and `turn ∈ {codex, claude, operator}` before every launch.
3. Acquire one OS-level lock for the checkout/task. For the pilot, refuse any other active dispatcher in the same checkout.
4. Snapshot file hash, Git HEAD, and scoped working-tree state.
5. If `turn: codex`, launch the explicit app binary with `codex exec --sandbox workspace-write -C <checkout>` and a prompt that explicitly names `$work-loop-v2` and the exact task file. Prefer a fresh run; capture JSONL and the thread id for diagnostics, not continuity.
6. If `turn: claude`, launch `claude -p` with the exact `/work-loop-v2 <task-id>` instruction, structured/streamed output, a bounded budget/turn count, and the project's normal permission policy. Do not use `--dangerously-skip-permissions`.
7. After exit, revalidate the same file and require an allowed state transition plus actor-specific evidence: Codex must change the intended task and never change HEAD; Claude must move the turn and, where the command contract requires it, commit the state/result by explicit path.
8. Continue only for `codex ↔ claude`. Stop and notify on `operator`, invalid/no transition, non-zero exit, timeout, unexpected files, conflicting/dirty worktree, or a small absolute hop limit.
9. On controller restart, require the operator to name the task again and derive truth from the state file and Git. Store no semantic queue or shadow copy in the repository.

Why this is the 80/20 pilot: it tests the real benefit—no manual carrying of routine turns—without changing the Work Loop schema, deploying a daemon, resuming hidden conversation state, or pretending same-checkout parallelism is safe. If it works, the next bounded experiment is the identical dispatcher in two pre-created, file-disjoint worktrees.

## What the spike must prove before implementation

The spike is successful only if execution evidence demonstrates all of the following:

1. **Codex launch:** the explicit installed binary successfully runs `$work-loop-v2`, edits only the named state file, emits a parseable thread/turn completion, and exits without attempting Git.
2. **Claude launch:** `claude -p` expands and executes `/work-loop-v2 <task-id>`, honors the command's configured model/effort or an explicitly approved equivalent, updates only allowed paths, commits as required, and exits with machine-detectable success/failure.
3. **Turn proof:** one normal Codex → Claude → Codex round trip completes with no operator transport; a close token reaches Claude and ends at `turn: operator` without another launch.
4. **Routing proof:** with several misleading files present exactly as today, only the named file runs; the filename/`task:` mismatch fixture is rejected read-only.
5. **No-op/idempotency proof:** an actor exit that leaves the file hash/turn unchanged stops once; repeating the same completion event does not launch twice.
6. **Recursion proof:** product Stop hooks firing during the child runs do not create another dispatcher or actor process.
7. **Permission proof:** a requested approval or unapproved tool does not hang forever or get auto-approved; the controller stops visibly for the operator.
8. **Timeout/failure proof:** Codex failure, Claude `StopFailure`/non-zero exit, hook timeout, killed child, and network/auth failure each stop with task id, actor, and recoverable next action.
9. **Crash-recovery proof:** crash before edits can be retried once; crash after any uncommitted edit or malformed/partial state stops for inspection. Restarting the controller reads file + Git and never trusts an old in-memory turn.
10. **Working-tree proof:** Codex's intentionally uncommitted state-file write is accepted only as the expected handoff; foreign dirt, staged foreign paths, Git lock contention, or an in-progress merge/rebase stops the loop.
11. **Operator-boundary proof:** every core § 7 case represented by `turn: operator` causes zero further model launches; neither product decides scope, risk acceptance, hard-to-reverse change, merge conflict, push, or destructive recovery for the operator.
12. **Parallel proof (separate second spike):** two file-disjoint tasks in two pre-created linked worktrees can alternate independently; both actors stay in the correct worktree; main remains a clean landing target; serial landing and teardown follow `docs/parallel-sessions-playbook.md` **§ 5**. Do not claim multi-loop support before this passes.

## Implementation decision boundary

Proceed to a real implementation only after the single-task spike passes items 1–11. Proceed to unattended multiple-loop operation only after the separate worktree spike passes item 12 and the operator approves the worktree/landing policy. If either spike shows that product CLI behavior, slash-command expansion, permissions, or hooks are not stable enough, keep Work Loop semantics unchanged and fall back to notification-only hooks; that still reduces watching without granting unsafe autonomy.
