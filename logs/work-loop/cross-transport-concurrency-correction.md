---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation as product behavior, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push. The operator wants Phase 1 finished and merged as soon as the plan's final gates support it; merge follows task closure and final review.

## Lane and unit

Standard. Discovery mode. Unit 9 — resolve the smallest safe orchestration for genuine live case 24. The one correction round is delivered; awaiting the closure check.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1–8 are accepted. Live case 23 completed at commit `8f43438c` through a real attended carrier: carrier exit 0, all seven plan steps passed in one observation, no losing actor launched, the checkout was unchanged by the loser, both leases released normally, and the durable refusal record remains under the Git common lease root.

The only purpose of this unit is to remove one load-bearing execution uncertainty before the final live gate: identify the minimum safe way to run case 24 with two real Work Loop tasks in two linked worktrees, one real attended carrier and one real dispatcher, without nested model invocation or commandeering an unrelated task. Do not execute case 24, launch a model, create a worktree, alter another task, or implement anything in this unit.

Governing sources:

- The approved correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially `### Case 24 — genuine fan-out two` and its instruction to coordinate two top-level sessions explicitly.
- The current Work Loop v2 carrier/dispatcher rules, including: attended carrier is one hop; unattended dispatcher loop behavior and stop codes are not completion; no hop may invoke a nested Claude or Codex actor.

Resolve these questions from current repository and command surfaces:

1. What exact top-level transport arrangement can prove both tasks and both checkouts are admitted concurrently, allow each task to complete at least one later handoff, and let both lease pairs release normally without treating a hop-limit or timeout stop as success?
2. Can the existing active `autonomy-authority-capability` task safely serve as the second participant without changing its approved unit, forcing additional progression, or introducing unrelated failure risk? Treat its current state as read-only evidence; do not edit or launch it. If it is unsuitable, say why and specify the minimum dedicated witness task/worktree setup instead.
3. Does the dispatcher have a supported bounded invocation that ends successfully after the needed real handoff, or must a dedicated witness task be shaped to reach `turn: operator` through normal Work Loop closure? Cite exact dispatcher/README behavior and exit semantics.
4. What exact evidence must be captured during and after the concurrent interval to prove: two authoritative state files and declarations; four distinct leases under one shared root at the same moment; each transport launched the intended real actor; each later handoff landed only in its bound checkout; neither commit/log/state contains the other task's paths; and all four leases released normally?
5. Return the leanest executable operator sequence: which checkout/task is participant A and B, what must be prepared in each before launch, which two top-level commands run concurrently, what order/timing is required, and how the evidence returns to this task for assessment. Explicitly distinguish required setup from optional convenience.

Required evidence: cite the exact current task states, owner declarations, dispatcher/carrier command semantics, and any relevant clean/dirty checkout constraints. Challenge the premise if no safe supported route exists. Do not write a separate plan or report; put the concise recommendation and exact commands in this state handback.

Authorized repository change: this state file only. Existing hooks may modify `logs/friction-log.md`; leave it unstaged and uncommitted. Do not touch `logs/harness-runs/`, the live refusal record, another worktree, another task file, production, tests, plans, or the closing record.

Completion condition: the case-24 execution route is concrete, safe, minimal, supported by current command semantics, and ready for Codex to frame as the next live unit; Claude records the findings here, sets `turn: codex`, commits only this state file, and stops. This is discovery only, not live-case completion.

Stop and hand back if the only route requires nested actors, an unsupported success interpretation, changing an unrelated active task, automatic product worktree creation, destructive shared-state cleanup, or an operator decision about interfering with other work.

## Latest result

Inspected (2026-08-15). This unit is read-only discovery; nothing was launched, no worktree was created, no other task was touched, and the only file changed is this one. This invocation is a top-level interactive session, not an actor inside a transport — process ancestry is `zsh(34716) <- claude(1935, VS Code extension binary) <- Code Helper(54615) <- Code(20308) <- launchd`, so no lease was held while inspecting. Confirmed against the shared root: `<git-common-dir>/work-loop-dispatch-locks/` currently holds only `refusals/`, whose single entry is case 23's `20260815T154142-30771-cross-transport-concurrency-correction.refusal`. Mode check: `## Lane and unit` records Discovery, and the completion condition asks for a route and a hand-back rather than a built result — mode and completion condition agree.

**The frozen finding reproduces, by inspection.** `.agents/skills/work-loop-v2/SKILL.md:223` tables exactly two approved courier shapes — attended one-hop via `carry-turn.sh`, and "**Unattended run** | `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, loop mode". Line 225 then states the prohibition in terms: "These are two different programs, and neither does the other's job. ... So do not carry an attended hop with the spike dispatcher, and never reach for the carrier when the operator is leaving." Line 262 confirms the unattended shape is loop mode with "`--carry-one` dropped". Unit 9's answer 3 read `--carry-one`'s own documentation (`dispatch.sh:114-119`, `262-276`) and concluded it was available; it is available in the program and forbidden by the governing contract, and the contract wins. The finding is correct and the route below is rebuilt around it.

**Answer 1 (corrected) — the transport arrangement.** Two top-level processes, one per checkout, both started by the operator, each in one of the two approved shapes:

- Participant A: `carry-turn.sh` in this checkout on this task — the attended one-hop shape. It has no loop mode and no flag to ask for one, and refuses `--carry-one`, `--unattended`, `--max-hops` and `--status` with exit 10 before anything launches (`SKILL.md:225`; `carry-turn.sh:10-12`). Its exit 0 has the single meaning "the one stated turn was carried", recorded at Unit 8 as `RESULT outcome=CARRIED code=0 ... turn_before=claude turn_after=codex denials=0 partial=0 actors=1 nested=0`. A is also the live observer.
- Participant B: `dispatch.sh` in **unattended loop mode with `--unattended`**, in a dedicated witness worktree on a deliberately minimal witness task — the second approved shape, unchanged from the skill. It runs to a genuine `turn: operator` and exits 0 there. `--carry-one` is not used, and neither is any attended flag.

Neither shape can turn a stop into a success. Loop mode returns 0 **only** after the state file reached `turn: operator` (`dispatch.sh:274-276`; README lines 652-653), so hop limit (23), actor timeout (21), budget exhaustion (29) and malformed terminal (26) all remain visible failures.

Concurrent admission is still proven from **inside** the window rather than reconstructed from two clocks — that accepted part of Unit 9 is preserved. What changes is the ordering, and it becomes simpler: because the dispatcher acquires both leases once at startup (`dispatch.sh:1415`) and releases them only through `trap 'release_lock' EXIT` at line 1402, B holds its lease pair for its **entire** multi-hop loop. So B is started first and confirmed admitted, then A is started inside B's run; A's Claude actor reads four lease directories immediately, with no polling window that can be missed. The rejected alternative remains two witness tasks with overlap inferred afterwards from timestamps — weaker, because simultaneity would rest on clock arithmetic instead of one live read.

**Answer 2 — `autonomy-authority-capability` is unsuitable. Use a dedicated witness task.** Five independent reasons, each from read-only evidence, any one of which is sufficient:

1. **Its turn does not point at a runnable actor.** Line 3 reads `turn: codex` in both `HEAD` (`44d1582e`) and the working tree, while its uncommitted `## Next action` reads "Claude: perform Unit 32's read-only discovery". A transport launched now would launch the **Codex** actor against a file that is mid-write. That is not a state to drive.
2. **Its state file is uncommitted.** `git diff --stat` against `44d1582e` shows 23 insertions and 62 deletions — Codex's Unit 32 brief, unwritten to Git. A hop over a state file that was already dirty before launch is exactly the case dispatcher exits 36 and 25 exist to stop.
3. **Driving it forces progression on an approved unit of an unrelated task.** Its Unit 32 is a substantial read-only discovery over the carrier's Codex path. Carrying it would execute that work as a side effect of a concurrency proof, which the brief forbids.
4. **Its checkout would refuse admission anyway.** `logs/friction-log.md` is modified there, and that path is outside both default allow sets — the carrier's `('^logs/work-loop/' '^logs/harness-runs/')` at `carry-turn.sh:404` and the dispatcher's `('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')` at `dispatch.sh:456`. Without an explicit `--allow-path` it stops at 18 FOREIGN_UNSTAGED.
5. **It imports unrelated failure risk into the evidence.** A 900-second actor timeout (21), a permission denial (37) or a false premise inside Unit 32 would be recorded during the case-24 window and would have nothing to do with concurrency.

**Answer 3 (corrected) — the witness task must be shaped to close, and a minimal one can, inside the default hop budget.** The dispatcher has no compliant bounded courier invocation, because the only bounded one it offers is the forbidden `--carry-one`. So the answer is the second branch of the frozen finding: shape a deliberately minimal witness task to reach `turn: operator` through normal Work Loop closure under unattended loop mode.

*The minimal lifecycle is three hops, and it fits.* Starting the witness state file at `turn: claude`: hop 1 Claude performs the tiny unit and hands back `turn: codex`; hop 2 Codex assesses and writes core § 3's close token, `turn: claude`; hop 3 Claude reduces the file to core § 4's four-heading closing record and sets `turn: operator`. The loop then stops and returns 0. Three hops is inside the default `--max-hops 4` (`dispatch.sh:305`), so no flag is needed to permit it and the limit still catches a runaway.

*This shape has run for real.* `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/20260805T154555-spike-live-transport.log` records exactly it — hop 1 `actor=claude exit=0 duration=420s`, hop 2 `actor=codex exit=0 duration=113s`, hop 3 `actor=claude exit=0 duration=38s`, each transition logged as allowed, ending `hop=3 turn=operator — stopping for the operator (core § 7). No further launches.` It is a live, three-hop loop-mode run that reached the terminal, so the lifecycle is observed rather than theorised. Two honest differences from what is proposed here: that run ended at a core § 7 operator question rather than a § 4 close, and it was **not** launched with `--unattended`.

*The `--unattended` gate passes on this host, checked rather than assumed.* It fails closed at exit 31 on three conditions and all three hold: platform must be Darwin (`dispatch.sh:1809-1810`) — `uname -s` returns `Darwin`, `uname -m` returns `arm64`; the claude binary must be readable and at least `UNATTENDED_MIN_VERSION="2.1.219"` (`dispatch.sh:364`, `1817-1830`) — `/Users/patrik.lindeberg/.local/bin/claude` reports `2.1.220 (Claude Code)`; and the profile file must be writable (`dispatch.sh:1837`). The Codex hop is unaffected by the flag, which applies the contained profile to Claude hops only, and `/Applications/ChatGPT.app/Contents/Resources/codex` is present and executable.

*The Work Loop itself runs under containment.* `runs/probe-unattended-integration-2026-08-07.md` launched `/work-loop-v2` **through** `dispatch.sh --unattended` and reports "Dispatcher: exit `0`, one hop, `claude → codex` transition allowed, one commit inside the allowlist", with the child's tool roster measured from the product's own `system/init` event as `PROBE_TOOLS: Bash, Skill` and `PROBE_MCP_NONE`. So a contained Claude hop can read the brief, edit the state file through the shell alone, and commit — the three things the witness lifecycle needs. `~/.gitconfig` is the one deliberate read exception, which is what lets Git commit at all.

*The gap, stated plainly rather than smoothed over.* No existing run combines both halves. The three-hop loop to a terminal was uncontained; the contained run was, by its own limitation line, "attended, single-hop and fixture-scoped". The witness run would therefore be the first **contained multi-hop** loop this repository has executed. That is a real first, and it is why the deadline and hop limit below are set explicitly. It is not a route failure: every way it can go wrong is a visible non-zero stop — 20, 21, 23, 26, 29 or 31 — and none of them is exit 0, so a failure cannot be mistaken for case-24 evidence.

*Safeguards against the witness doing unrelated work*, in the order they bite:

- The contained profile itself: OS-backed sandbox, empty network allowlist, Bash and Skill tools only, no MCP, web, hooks, connectors, remote control, subagents, built-in file tools, or push, credentials scrubbed from subprocesses (`dispatch.sh:62-68`). Measured, not merely requested, by the integration probe above.
- A narrow `--allow-path` set, so any change outside it stops the run at 24 (working tree) or 30 (already committed) rather than being swept along.
- The witness brief's own completion condition: one bounded read-only inspection, with the eventual target and every adjacent improvement excluded by name.
- Explicit `--max-hops 4` and `--deadline`, so a loop that does not converge stops at 23 or 29 — neither of which is success.
- Separation of checkouts: B is its own worktree with its own ownership declaration, so nothing it does can reach A, and both transports check repository-depth ownership before launching (`dispatch.sh:2602`, `carry-turn.sh:1587`).

**Answer 4 — the evidence to capture, mapped to the plan's five case-24 steps.**

1. *Two authoritative state files and correct declarations.* `logs/work-loop/<A>.md` exists only in A's working tree and `logs/work-loop/<witness>.md` only in B's; `logs/work-loop/.owner` names this task in A and the witness task in B; `work-loop-owner.sh check --depth repo` returns PROCEED in each. Current declarations read across all 18 registered worktrees: this checkout → `cross-transport-concurrency-correction 2026-08-15`, `ai-resources-autonomy-authority` → `autonomy-authority-capability 2026-08-14`, `ai-resources-durable-state` → `work-loop-v2-durable-state-system 2026-08-14`; no other worktree declares anything, so a fresh witness declaration collides with nothing.
2. *Four distinct leases under one shared root at one moment.* Read `<git-common-dir>/work-loop-dispatch-locks/` during the overlap: expect `task-<hashA>.lock`, `checkout-<hashA>.lock`, `task-<hashW>.lock`, `checkout-<hashW>.lock` — four directories, A's pair carrying `program=carry` and B's `program=dispatch`, each with its own live `pid`, `task` and `checkout` (the metadata files `wl_lease__read_holder` reads, `work-loop-lease.sh:174-179`). Both pids confirmed live with `kill -0`. The read is falsifiable and has already returned other values: the same directory held exactly two entries during case 23 and holds zero now.
3. *Each transport launched the intended real actor.* From each run log: A's `launch: actor=claude ... bin=<path> version=<v>` and `cmd: claude -p '/work-loop-v2 <A>' --output-format json --permission-mode default --disallowedTools ...` (`carry-turn.sh:1238`); B's contained equivalent at `dispatch.sh:2459`, which logs `--output-format stream-json --verbose --settings <profile> --tools Bash,Skill --strict-mcp-config` and no `--carry-one`, plus its Codex hop at `dispatch.sh:2379` (`codex exec --sandbox workspace-write`). Because B's hops are captured as `stream-json`, each `.out` opens with the product's own `system/init` event, which states the tool roster and MCP servers the runtime actually resolved — read that for B's effective containment rather than the argv or the child's prose (`SKILL.md:268`). Plus `actors: 1 top-level actor(s)` and `nested=0` on A. Live corroboration rather than log-only: each actor's process ancestry back to its own launcher, and `lsof -a -d cwd -p <actor-pid>` showing each actor's working directory is its own checkout — the method the 2026-08-05 fan-out proof used across 209 sampled actor processes.
4. *Each handoff landed only in its bound checkout.* `git show --stat` on each transport's commit contains only its own task's paths; `git -C <other-checkout> status --porcelain` and `rev-parse HEAD` are unchanged across the other's interval; neither run log, state file nor commit message names the other task. A completes one handoff; B completes three, so step 3 of the plan's case 24 is met on both sides with room to spare.
5. *All four leases released normally, and B's completion is genuine.* After both processes exit, all four lease directories are gone from the shared root, `refusals/` still holds only case 23's single pre-existing entry — proving neither run was refused. A ends `RESULT outcome=CARRIED code=0`. B ends with dispatcher **exit 0 from loop mode**, its log's final line naming `turn=operator` as the reason it stopped, and its witness state file reduced to core § 4's four-heading closing record with `turn: operator` — the three read together, because exit 0 in loop mode is only earned by that terminal and the file is authoritative over the exit code (core § 4). Any of 20, 21, 23, 26, 29 or 31 is a failed case, not a qualified pass.

**Answer 5 (corrected) — the leanest executable operator sequence.** Absolute paths abbreviated as `<A>` = `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2` and `<B>` = the new witness worktree.

*Required setup, before any launch:*

- Create B as a linked worktree at the corrected commit: `git worktree add -b wl2-case24-witness "<B>" 8f43438c`. This is required rather than convenient. The only clean spare worktree that exists, `.../ai-resources/.claude/worktrees/concurrency-fix` at `212fa918`, predates the correction and does not carry `logs/scripts/work-loop-lease.sh` — verified by `git show 212fa918:logs/scripts/work-loop-lease.sh`, which fails. A dispatcher run against it exits 11 BAD_CHECKOUT and launches nothing, because an absent lease library fails closed by design (`dispatch.sh:128-137`).
- In B, write `logs/work-loop/wl2-case24-witness.md` as a task shaped to **close**, not merely to hand back: frontmatter `task: wl2-case24-witness` and `turn: claude`; `## Objective and scope` naming one bounded read-only inspection inside B and excluding everything else; `## Lane and unit` recording Standard, Discovery mode, unit 1, and the named reason for the loop; `## Blocker` `None.`; a `## Brief` whose completion condition is that the inspection's evidence is recorded and the task is then **ready to close**; and `## Next action` addressed to Claude. Commit it in B. The three-hop lifecycle in answer 3 depends on this shape — a witness written to hand back forever never reaches `turn: operator`, and the loop would end at hop limit 23 instead of 0.
- In B, `bash logs/scripts/work-loop-owner.sh claim --checkout "<B>" --task wl2-case24-witness`. Both transports enforce ownership before launching (`dispatch.sh:2602`, `carry-turn.sh:1587`), and an undeclared replicated file is exit 34, not a guess.
- In A, nothing to prepare. The declaration is present, the branch is current, and the only working-tree dirt is this state file plus the two operator-owned paths.

*Launch — two terminals at top level. B first, then A inside B's run:*

```bash
# Terminal 1 — participant B, started FIRST and left alone
bash "<A>/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh" \
  --checkout "<B>" --task wl2-case24-witness \
  --unattended --max-hops 4 --deadline 2700 \
  --allow-path '^logs/work-loop/' \
  --allow-path '^logs/friction-log\.md$'

# Terminal 2 — participant A, started once B's log shows it admitted and in hop 1
bash "<A>/scripts/axcion-harness-v0.2/carry-turn.sh" \
  --checkout "<A>" --task cross-transport-concurrency-correction \
  --allow-path '^logs/work-loop/' \
  --allow-path '^logs/harness-runs/' \
  --allow-path '^logs/friction-log\.md$'
```

Order is load-bearing and it is now the reverse of Unit 9's. B is started first because it holds both leases for its whole loop (`dispatch.sh:1402`, `1415`), so once B is admitted the four-lease window is open continuously and A's short hop sits safely inside it — no polling interval that can be missed. B is confirmed admitted by reading its run log for the hop-1 launch line, not by its screen. Nothing in that check is a decision: it is transport, and the state files stay authoritative (core § 4).

`--deadline 2700` is sized from the only comparable live evidence — the 2026-08-05 three-hop loop ran 420s + 113s + 38s ≈ 9.5 minutes — leaving generous headroom without being unbounded; exit 29 remains a failure, not a slow pass. `--max-hops 4` is the default, restated so the bound is visible in the command the operator runs.

`--allow-path` **replaces** the defaults rather than adding to them, so each list above restates what that transport needs. `^logs/friction-log\.md$` is required in both because `.claude/hooks/log-write-activity.sh` is registered in the tracked `.claude/settings.json` (line 70) and appends to each checkout's own `logs/friction-log.md` on every Write or Edit — the same ambient shared writer the 2026-08-05 fan-out proof deleted in its sandbox and that cannot be deleted here. B's `--log-dir` is left at its default, which the dispatcher allowlists for itself (`dispatch.sh:1600-1606`).

*How the evidence returns:* A's Claude actor is the next unit of this task. Because B is already admitted when A starts, that brief instructs the actor to read the shared lease root **first**, capture answer 4's items 1–4 while all four leases are held, then complete its own hop normally, writing into this state file and committing — the identical route Unit 8 used. Answer 4's item 5 cannot be observed by A, because A's single hop finishes while B is still looping; it is necessarily the following unit's read, exactly as Unit 8 left its own release check to Codex. That following unit reads three things: the empty lease root, B's dispatcher exit code, and B's witness state file reduced to the § 4 closing record.

*Optional convenience, not required:* a background sampler for a denser overlap record; before/after checkout fingerprints of the kind Unit 8 took for step 6; `--timeout` tuning; removing worktree B after the case is accepted.

Result: the frozen finding is resolved in full. The route now uses only the two courier shapes the governing skill approves — attended one-hop for A, unattended loop mode for B — and every accepted part of Unit 9 survives: a dedicated witness task and worktree, two top-level processes, participant A as the real attended carrier and live observer, four simultaneous distinct leases, isolated handoffs, commits and logs, and normal release. The second branch of the finding did not need to be taken: a minimal witness task **can** reach a genuine `turn: operator` and exit 0 inside the default hop budget, so there is no conflict between the approved case-24 requirement and the courier contract, and no operator decision is requested.

Limitations of this route, stated rather than smoothed over:

- **The one genuine first.** No prior run combines containment with a multi-hop loop. The three-hop run to a terminal (2026-08-05) was uncontained; the contained run (2026-08-07) was attended, single-hop and fixture-scoped by its own admission. B would be the first contained multi-hop loop here. Every way it can fail is a visible non-zero stop, so it cannot be mistaken for a pass, but it may need a second attempt with a corrected witness brief.
- The prior fan-out-2 result (`logs/work-loop/work-loop-v2-parallel-worktree-proof.md`) ran in a throwaway sandbox with the friction-log hook removed at the base commit. This route runs in the real repository with that shared writer live, so it is handled by allow-path rather than removed — a genuine difference from the precedent, not a repeat of it.
- Creating B is an operator repository change (one worktree, one branch) that outlives the run until it is removed. It is test setup, not product behaviour, and the plan's case 24 cannot be satisfied without two linked worktrees.
- B's contained hops report the *requested* policy in argv; the effective policy is readable only from each hop's `system/init` event, and array-valued settings keys merge across scopes on the host (`SKILL.md:268`). This bounds what B's evidence proves about containment — it does not bound what it proves about concurrency, which is what case 24 is for.
- Case 24 proves concurrent admission for *different task and different checkout*. It does not exercise the checkout-resource refusal wording, which Unit 8 already recorded as unexercised live and which remains covered only by the Unit 6 controller matrix.

Newly noticed during this correction, recorded as a candidate deferral and deliberately not implemented: `dispatch.sh`'s header (lines 114-119) and `README.md` (line 353) both document `--carry-one` as a supported mode without noting that the governing Work Loop v2 skill forbids using it to carry an attended hop. That gap is what Unit 9 walked into — the program's own documentation is complete and the constraint lives only in the skill. Fixing it means editing the dispatcher header and README, which this unit authorizes no change to and which is outside this task's scope.

Unit 8 remains accepted at commit `8f43438c`: `RESULT outcome=CARRIED code=0`, one top-level Claude actor, zero observed nested actors, `turn: claude -> codex`, one committed state handoff, both live lease directories gone afterwards. Unit 7 clean gates remain accepted: syntax rc 0; shared lease `127/0`; owner helper `92/0`; attended carrier `423/0`; dispatcher `632/0`; `git diff --check` rc 0; no Phase 2 or executable-core change; no other checkout modified by this correction.

Accepted implementation commits: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`), Unit 5 (`81644987`, correction `d22978ad`), Unit 6 (`a3096a21`), verification record (`faccb92b`), live case 23 record (`8f43438c`).

Items held for task closure and final review: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block remains until no checkout can carry that format; a host unable to execute `ps -g` pins rather than releases on shutdown; an unwritable shared lease root leaves refusal evidence terminal-only; refusal records have no pruning machinery and case 23 created the first live entry; the unassigned `LOCK_KEY` remains excluded; carrier fallback wording retains contextual `another`; dispatcher `STALE LOCK` wording still says a dispatcher died; `wl_lease_init` depends on callers canonicalizing checkout paths, although both shipped callers do; Unit 6 observed one load-sensitive carrier-suite timeout followed by clean later runs.

## Blocker

None. The protocol conflict is corrected: `--carry-one` is gone from the route, participant B is the skill's unattended loop-mode shape, and the minimal witness task closes in three hops inside the default limit. No operator decision is requested — the finding's second branch, an irreconcilable conflict between case 24 and the courier contract, does not apply.

## Next action

Codex: run the closure check on the frozen finding only — is the `--carry-one` route replaced by a compliant one, are the accepted parts of Unit 9 preserved, and did the correction break anything. Nothing else was changed; the one thing newly noticed during the correction is recorded above as a candidate deferral rather than implemented.
