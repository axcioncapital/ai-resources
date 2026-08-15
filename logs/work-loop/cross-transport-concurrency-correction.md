---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation as product behavior, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push. The operator wants Phase 1 finished and merged as soon as the plan's final gates support it; merge follows task closure and final review.

## Lane and unit

Standard. Discovery mode. Unit 9 — resolve the smallest safe orchestration for genuine live case 24. Delivered; awaiting assessment.

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

**Answer 1 — the transport arrangement.** Two top-level shells, one per checkout, both started by the operator; neither is loop mode, so neither depends on reaching `turn: operator`, and neither can reach a hop-limit or timeout stop and be mistaken for success.

- Participant A: `carry-turn.sh` in this checkout on this task. It is attended, one hop per invocation, with no loop mode and no flag to ask for one (`carry-turn.sh:10-12`). Its exit 0 is the single meaning "the one stated turn was carried" — the proven shape, recorded at Unit 8 as `RESULT outcome=CARRIED code=0 ... turn_before=claude turn_after=codex denials=0 partial=0 actors=1 nested=0`.
- Participant B: `dispatch.sh --carry-one` in a dedicated witness worktree on a dedicated witness task. See answer 3 for why this is the bounded success the question asks for.

Concurrent admission is proven from **inside** the window rather than reconstructed from two clocks: participant A's own Claude actor — the next unit of this task — polls the shared lease root and reads participant B's two lease directories while A's own two are held. That is the same first-person method Unit 8 used for case 23 and it is why A must be this task rather than a second witness. The rejected alternative was two witness tasks with the overlap inferred afterwards from two run logs' acquire/release timestamps; it is weaker, because simultaneity would then rest on timestamp arithmetic instead of one live read of four lease directories.

**Answer 2 — `autonomy-authority-capability` is unsuitable. Use a dedicated witness task.** Five independent reasons, each from read-only evidence, any one of which is sufficient:

1. **Its turn does not point at a runnable actor.** Line 3 reads `turn: codex` in both `HEAD` (`44d1582e`) and the working tree, while its uncommitted `## Next action` reads "Claude: perform Unit 32's read-only discovery". A transport launched now would launch the **Codex** actor against a file that is mid-write. That is not a state to drive.
2. **Its state file is uncommitted.** `git diff --stat` against `44d1582e` shows 23 insertions and 62 deletions — Codex's Unit 32 brief, unwritten to Git. A hop over a state file that was already dirty before launch is exactly the case dispatcher exits 36 and 25 exist to stop.
3. **Driving it forces progression on an approved unit of an unrelated task.** Its Unit 32 is a substantial read-only discovery over the carrier's Codex path. Carrying it would execute that work as a side effect of a concurrency proof, which the brief forbids.
4. **Its checkout would refuse admission anyway.** `logs/friction-log.md` is modified there, and that path is outside both default allow sets — the carrier's `('^logs/work-loop/' '^logs/harness-runs/')` at `carry-turn.sh:404` and the dispatcher's `('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')` at `dispatch.sh:456`. Without an explicit `--allow-path` it stops at 18 FOREIGN_UNSTAGED.
5. **It imports unrelated failure risk into the evidence.** A 900-second actor timeout (21), a permission denial (37) or a false premise inside Unit 32 would be recorded during the case-24 window and would have nothing to do with concurrency.

**Answer 3 — yes, the dispatcher has a supported bounded success: `--carry-one`.** `dispatch.sh:114-119` defines it as COURIER MODE — "Launch exactly the actor named by the current `turn:`, then stop once the turn has moved in an allowed direction — exit 0 rather than continuing to the next actor. Every validation and post-hop check is unchanged; this is a terminal condition, not a weaker one. Implies a single hop, so `--max-hops` is moot." The exit-0 table at `dispatch.sh:262-276` lists five distinct meanings of 0 and gives `--carry-one` its own: "EITHER the turn moved exactly once in an allowed direction, OR `turn:` was already operator and nothing was carried. Read `turn:` from the state file to tell them apart." Only `loop mode` carries the whole-loop `turn: operator` meaning. So no witness task needs to be shaped to reach closure, and no hop-limit (23), timeout (21) or budget (29) stop can be read as completion. The one obligation `--carry-one` adds is that the state file must be read to disambiguate its 0 — which the plan's case-24 step 3 requires regardless.

**Answer 4 — the evidence to capture, mapped to the plan's five case-24 steps.**

1. *Two authoritative state files and correct declarations.* `logs/work-loop/<A>.md` exists only in A's working tree and `logs/work-loop/<witness>.md` only in B's; `logs/work-loop/.owner` names this task in A and the witness task in B; `work-loop-owner.sh check --depth repo` returns PROCEED in each. Current declarations read across all 18 registered worktrees: this checkout → `cross-transport-concurrency-correction 2026-08-15`, `ai-resources-autonomy-authority` → `autonomy-authority-capability 2026-08-14`, `ai-resources-durable-state` → `work-loop-v2-durable-state-system 2026-08-14`; no other worktree declares anything, so a fresh witness declaration collides with nothing.
2. *Four distinct leases under one shared root at one moment.* Read `<git-common-dir>/work-loop-dispatch-locks/` during the overlap: expect `task-<hashA>.lock`, `checkout-<hashA>.lock`, `task-<hashW>.lock`, `checkout-<hashW>.lock` — four directories, A's pair carrying `program=carry` and B's `program=dispatch`, each with its own live `pid`, `task` and `checkout` (the metadata files `wl_lease__read_holder` reads, `work-loop-lease.sh:174-179`). Both pids confirmed live with `kill -0`. The read is falsifiable and has already returned other values: the same directory held exactly two entries during case 23 and holds zero now.
3. *Each transport launched the intended real actor.* From each run log: A's `launch: actor=claude ... bin=<path> version=<v>` and `cmd: claude -p '/work-loop-v2 <A>' --output-format json --permission-mode default --disallowedTools ...` (`carry-turn.sh:1238`); B's dispatcher equivalent at `dispatch.sh:2481`, with `--carry-one` in its argv. Plus `actors: 1 top-level actor(s)` and `nested=0` on both. Live corroboration rather than log-only: each actor's process ancestry back to its own launcher, and `lsof -a -d cwd -p <actor-pid>` showing each actor's working directory is its own checkout — the method the 2026-08-05 fan-out proof used across 209 sampled actor processes.
4. *Each handoff landed only in its bound checkout.* `git show --stat` on each transport's commit contains only its own task's paths; `git -C <other-checkout> status --porcelain` and `rev-parse HEAD` are unchanged across the other's interval; neither run log, state file nor commit message names the other task.
5. *All four leases released normally.* After both processes exit, all four lease directories are gone from the shared root, `refusals/` still holds only case 23's single pre-existing entry — proving neither run was refused — and both run logs end in a normal result line rather than a stop code.

**Answer 5 — the leanest executable operator sequence.** Absolute paths abbreviated as `<A>` = `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2` and `<B>` = the new witness worktree.

*Required setup, before any launch:*

- Create B as a linked worktree at the corrected commit: `git worktree add -b wl2-case24-witness "<B>" 8f43438c`. This is required rather than convenient. The only clean spare worktree that exists, `.../ai-resources/.claude/worktrees/concurrency-fix` at `212fa918`, predates the correction and does not carry `logs/scripts/work-loop-lease.sh` — verified by `git show 212fa918:logs/scripts/work-loop-lease.sh`, which fails. A dispatcher run against it exits 11 BAD_CHECKOUT and launches nothing, because an absent lease library fails closed by design (`dispatch.sh:128-137`).
- In B, write `logs/work-loop/wl2-case24-witness.md`: Standard lane, Discovery mode, `turn: claude`, a named reason for the loop, and a completion condition of exactly one bounded read-only inspection recorded and committed in B. Commit it in B.
- In B, `bash logs/scripts/work-loop-owner.sh claim --checkout "<B>" --task wl2-case24-witness`. Both transports enforce ownership before launching (`dispatch.sh:2602`, `carry-turn.sh:1587`), and an undeclared replicated file is exit 34, not a guess.
- In A, nothing to prepare. The declaration is present, the branch is current, and the only working-tree dirt is this state file plus the two operator-owned paths.

*Launch — two terminals at top level, A first:*

```bash
# Terminal 1 — participant A, started first
bash "<A>/scripts/axcion-harness-v0.2/carry-turn.sh" \
  --checkout "<A>" --task cross-transport-concurrency-correction \
  --allow-path '^logs/work-loop/' \
  --allow-path '^logs/harness-runs/' \
  --allow-path '^logs/friction-log\.md$'

# Terminal 2 — participant B, started inside A's polling window
bash "<A>/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh" \
  --checkout "<B>" --task wl2-case24-witness --carry-one \
  --allow-path '^logs/work-loop/' \
  --allow-path '^logs/friction-log\.md$'
```

Order is load-bearing: A must be alive first because A's actor is the observer. `--allow-path` **replaces** the defaults rather than adding to them, so each list above restates what that transport needs. `^logs/friction-log\.md$` is required in both because `.claude/hooks/log-write-activity.sh` is registered in the tracked `.claude/settings.json` (line 70) and appends to each checkout's own `logs/friction-log.md` on every Write or Edit — the same ambient shared writer the 2026-08-05 proof deleted in its sandbox and that cannot be deleted here. B's `--log-dir` is left at its default, which the dispatcher allowlists for itself (`dispatch.sh:1600-1606`).

*How the evidence returns:* A's Claude actor is the next unit of this task. Its brief must instruct it to poll the shared lease root for a second, differently-keyed lease pair for a bounded interval before doing anything else, capture answer 4's items 1–4 while both pairs are held, then complete its own hop normally. It writes into this state file and commits — the identical route Unit 8 used. Item 5, normal release of all four leases, cannot be observed by A because A exits first; it is necessarily the following unit's read, exactly as Unit 8 left its own release check to Codex.

*Optional convenience, not required:* a background sampler for a denser overlap record; before/after checkout fingerprints of the kind Unit 8 took for step 6; `--timeout` tuning.

Result: a concrete, supported, minimal route exists. It needs no nested model invocation, no unsupported reading of an exit code, no change to any unrelated active task, no automatic product worktree creation, and no destructive cleanup of shared state.

Limitations of this route, stated rather than smoothed over:

- The prior fan-out-2 result (`logs/work-loop/work-loop-v2-parallel-worktree-proof.md`) ran in a throwaway sandbox at fan-out 2 with the friction-log hook removed at the base commit. This route runs in the real repository with that shared writer live, so it is handled by allow-path rather than removed — a genuine difference from the precedent, not a repeat of it.
- Creating B is an operator repository change (one worktree, one branch) that outlives the run until it is removed. It is test setup, not product behaviour, and the plan's case 24 cannot be satisfied without two linked worktrees.
- `--carry-one` exit 0 is two-valued, so B's `turn:` must be read from B's state file before its 0 is called a handoff.
- Case 24 proves concurrent admission for *different task and different checkout*. It does not exercise the checkout-resource refusal wording, which Unit 8 already recorded as unexercised live and which remains covered only by the Unit 6 controller matrix.

Unit 8 remains accepted at commit `8f43438c`: `RESULT outcome=CARRIED code=0`, one top-level Claude actor, zero observed nested actors, `turn: claude -> codex`, one committed state handoff, both live lease directories gone afterwards. Unit 7 clean gates remain accepted: syntax rc 0; shared lease `127/0`; owner helper `92/0`; attended carrier `423/0`; dispatcher `632/0`; `git diff --check` rc 0; no Phase 2 or executable-core change; no other checkout modified by this correction.

Accepted implementation commits: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`), Unit 5 (`81644987`, correction `d22978ad`), Unit 6 (`a3096a21`), verification record (`faccb92b`), live case 23 record (`8f43438c`).

Items held for task closure and final review: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block remains until no checkout can carry that format; a host unable to execute `ps -g` pins rather than releases on shutdown; an unwritable shared lease root leaves refusal evidence terminal-only; refusal records have no pruning machinery and case 23 created the first live entry; the unassigned `LOCK_KEY` remains excluded; carrier fallback wording retains contextual `another`; dispatcher `STALE LOCK` wording still says a dispatcher died; `wl_lease_init` depends on callers canonicalizing checkout paths, although both shipped callers do; Unit 6 observed one load-sensitive carrier-suite timeout followed by clean later runs.

## Blocker

None. A safe supported route exists and no operator decision is requested. The one thing worth Codex's attention when framing the next unit is that the route's setup — creating the `wl2-case24-witness` worktree, writing and committing its state file, and claiming its declaration — is operator work in a second checkout that this task has not previously touched. It is required by the plan's own case-24 wording ("two linked worktrees") and is not a scope change, but it is the first step of this correction that reaches outside this checkout.

## Next action

Codex: assess Unit 9's route and, if accepted, frame the next unit as live case 24 with participant A carried by `carry-turn.sh` in this checkout. That brief must carry the poll-and-capture instruction described in answer 5 — the actor waits for a second lease pair, records answer 4's items 1–4 while all four leases are held, then completes its own hop — and must state which of the setup steps the operator performs before launch and which the actor may assume already done.
