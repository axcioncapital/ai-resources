---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make concurrent Claude and Codex work a safe, supported Work Loop v2 operating model: when another useful task starts, the system should handle the routine isolation mechanics, preserve task-to-checkout continuity across handoffs, make ownership visible, and refuse duplicate ownership of either a logical task or a writable checkout.

The target operator experience is automatic creation or reuse of a dedicated task worktree when concurrent writing requires isolation, without requiring the operator to reason through Git mechanics. Human control remains mandatory for whether tasks genuinely belong together, merge and final landing decisions, conflict resolution, and destructive cleanup. Excluded are automatic push, merge, branch deletion, worktree deletion, conflict resolution, universal one-worktree-per-session behavior, a general scheduler, a persistent task registry, and any second semantic state system.

Task exit condition: the repository contains an implemented and evidenced minimum mechanism, integrated with Work Loop v2's existing entry and handoff surfaces, that safely supports two concurrent tasks in one repository on separate worktrees, rejects the same logical task in two worktrees, rejects two dispatched writers in one physical checkout, reuses the bound task worktree on later handoffs, and presents the operator with understandable ownership/status information.

## Lane and unit

Standard. Discovery mode. Unit 1 — establish the failure proof and confirm or reroute the provisional structural qualification before any diagnosis or solution design.

Named reason for the loop: the work spans planning, implementation, and independent evidence assessment; its scope crosses several existing concurrency and transport controls and must be bounded before code changes begin.

## Brief

Concurrent sessions are already part of the intended operating model and collisions have already occurred, so treating safe parallel operation as speculative is no longer acceptable. The operator has prioritized resolving it now and has directed this task to use the structural-problem methodology from the Repository Problem Resolution SOP. This unit establishes the failure before later units diagnose or design the intervention.

Required outcome for this unit: establish through safe reproduction or reliable current forensic evidence exactly which concurrent-session failures still exist, what behavior is expected instead, and whether this remains a structural problem. Do not diagnose a preferred cause, propose a solution, create a plan artifact, or implement the target in this unit.

Applicable methodology and authority:

- Current operator decision, recorded here: use the methodology in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` for this fix session, adapted inside Work Loop v2 so it survives compaction without creating the SOP's separate case-document system. Claude must read that exact main-worktree source before acting and report if it is inaccessible or materially different from the methodology recorded below.
- Codex's provisional qualification is the SOP's structural route because the observed problem crosses Claude/Codex ownership and Work Loop/session/worktree boundaries, involves shared writable state and ambiguous ownership, has a collision history, and changes the operating model. This is a checkable provisional judgment: reroute to a bounded repair or return `Not confirmed` if current evidence does not support it.
- The operator has already made the priority decision: address the problem now. Claude supplies technical qualification and consequence evidence but does not reopen whether it is worth doing.
- Current operator outcome requirement: automatic task worktree creation/reuse is worth testing when concurrent writing requires isolation. This does not predetermine the causal diagnosis or implementation, and it does not authorize automatic landing, merging, conflict resolution, destructive cleanup, or deciding that two tasks belong together.
- Governing semantic authority remains `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`, the executable core it authorizes, and the deployed Claude/Codex Work Loop v2 resources. The SOP supplies problem-resolution methodology; it does not replace Work Loop v2's one task, one state file, actor roles, turn protocol, or bounded-unit cycle.
- `plans/axcion-harness-v0.2/mvp-plan.md`, `plans/axcion-harness-v0.2/task-scoped-concurrency-investigation-2026-08-08.md`, and prior model diagnoses are non-governing leads. Do not let their recommendations establish the failure or anchor this unit's interpretation. The closed `logs/work-loop/work-loop-v2-production-readiness-policy.md` is current-state evidence only to the extent its claims remain verifiable now.

Durable procedure for this task, adapted from the SOP and to be retained through future unit rewrites and compaction:

1. Failure proof: Claude preserves and reports repository state, bounds the context, safely reproduces or forensically establishes the current failures, and labels every material statement `OBSERVED`, `INFERRED`, `PROPOSED`, or `UNKNOWN`. No diagnosis or solution yet.
2. Blind evidence review: before seeing Claude's diagnosis, a genuinely fresh Codex context receives only the observable problem, bounded context manifest, and raw failure evidence. Diagnosis-bearing research or summaries are excluded from that review. The operator will be explicitly told when this fresh context is required; the current Codex conversation cannot substitute because it has already seen proposed explanations.
3. Causal model and options: only after the blind reading, Claude builds `observed failure -> immediate mechanism -> enabling system property -> failure class -> intervention point`, addresses competing explanations, states what would disprove the diagnosis, and compares removal/simplification/reuse before new controls.
4. Design challenge and scope lock: Codex challenges causality and permanent complexity; the operator approves the trade-off and locks the implementation boundary. The default complexity budget is zero, and new permanent machinery requires evidence that removal, simplification, restoration, or reuse is insufficient.
5. Controlled implementation: Claude implements only the locked scope in the task-bound isolated checkout, with failing behavior cases first, real invocation-path regression protection, rollback instructions, no unrelated changes, and no merge or landing.
6. Independent technical verification: because concurrent-session changes are high-risk, Codex may invoke the Work Loop v2 consequential-claim exception to execute the original failure cases, regressions, failure paths, and surrounding workflow from a clean or separate checkout. Codex verifies; it does not authorize integration.
7. Operator integration and operational closure: the operator decides landing. The task closes only after representative fan-out-2 concurrent use shows the original failure no longer occurs, ownership/status remains understandable, rollback remains usable, and limitations are recorded.

This sequence is durable task context, not seven pre-opened units. At each handoff Codex still chooses the smallest next justified unit under the Work Loop core; later evidence may reroute or stop the task.

Context boundary for this failure-proof unit:

- Inspect current Work Loop v2 task/checkout binding and mismatch behavior in `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, and `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.
- Inspect current dispatcher locking, status, launch validation, and relevant test fixtures in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `dispatch.test.sh`, and directly linked evidence records.
- Inspect current manual concurrency and worktree paths in `.claude/commands/new-worktree-session.md`, `.claude/commands/concurrent-session-check.md`, `.claude/commands/close-worktree-session.md`, and `docs/parallel-sessions-playbook.md`.
- Use historical collision and parallel-proof records only as forensic leads, then confirm every current-behavior claim against code or safe execution. Record the exact searched surface for every absence claim.
- Exclude unrelated harness architecture, repository cleanup, landing automation, general scheduling, semantic registries, and implementation design.

Required evidence returned in `## Latest result`:

- current branch, worktree, base commit, Git status, uncommitted state, and confirmation that unrelated work was untouched;
- a bounded context manifest naming the affected repository, current base, sources inspected, safe reproduction/forensic route, scope, exclusions, and authority gaps, contained in this state-file result rather than a new artifact;
- observed behavior versus expected behavior for the suspected duplicate-task and shared-checkout writer failures, plus the manual worktree-continuity burden the operator wants removed;
- safe reproduction commands and actual outputs, or an explicit explanation of why reproduction is unsafe/impractical and the current forensic evidence used instead;
- affected components and workflows, practical consequences, recurrence evidence, and verified prior attempted corrections;
- candidate explanations only, with no preferred diagnosis or intervention;
- every material statement classified as `OBSERVED`, `INFERRED`, `PROPOSED`, or `UNKNOWN` and every observed claim tied to a file/line, commit, test, or command output;
- one qualification outcome: structural; bounded repair with the evidence that justifies rerouting; or `Not confirmed` with what would establish or eliminate the problem.

Completion condition: return the raw failure proof and qualification in `## Latest result`, set `turn: codex`, commit the handback, and stop. A persuasive explanation, stale report, or inspection-only assertion that current executable behavior fails is insufficient.

Stop and hand back without diagnosis if safe evidence cannot be produced, if a premise is false, if the scope would widen beyond the bounded surfaces above, or if the current state depends on unrelated uncommitted work. Challenge stale or false direction instead of improvising around it.

## Latest result

Failure proof only (SOP Lane B, Steps B1–B2). No diagnosis, no preferred cause, no intervention.

### Methodology source check

`OBSERVED` — the SOP is readable at the exact main-worktree path the brief names: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md`, regular file (not a symlink), 1024 lines, 59752 bytes, mtime 2026-08-11 09:27.
`OBSERVED` — it is **absent from this worktree** (`ls` on the same relative path under `ai-resources-work-loop-ceremony/` returns "No such file or directory"), so the brief's instruction to read the main-worktree copy is load-bearing rather than incidental.
`OBSERVED` — it is **not materially different** from the seven-step procedure recorded in the brief. SOP Lane B gates map onto the brief's steps: B1+B2 → 1, B3 → 2, B4 → 3, B5+B6 → 4, B7 → 5, B8 → 6, B9 → 7. This unit is Gate 2 (Failure proof), whose completion condition is failure established plus an explicit Observed/Inferred split, or `Not confirmed`.

### B1 — Repository state and preservation

`OBSERVED` — branch `session/2026-08-11-work-loop-ceremony`; worktree `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-work-loop-ceremony`; base commit `0ccf397c2e5e486ae8b297bd90aceec01bfbaab4` ("improvement-log: two destructive-liveness hook defects found by execution").
`OBSERVED` — `git status --porcelain` shows exactly two entries: ` M logs/friction-log.md` and `?? logs/work-loop/work-loop-v2-concurrent-task-isolation.md`. Nothing staged (`git diff --cached --name-only` empty). No merge, rebase or cherry-pick in progress. One pre-existing stash from 2026-07-17, untouched.
`OBSERVED` — the state file is **untracked**: Codex wrote it and cannot run git, so this handback is its first commit.
`OBSERVED` — the `logs/friction-log.md` delta is 2 inserted lines, no deletions, both appended by the ambient hook during this unit: `- 09:38 — logs/work-loop/work-loop-v2-concurrent-task-isolation.md` and `- 09:34 — /private/tmp/.../scratchpad/race-probe.sh`.
`OBSERVED` — unrelated work was not modified, staged or committed. All reproduction ran in a `mktemp -d` sandbox with its own `git init`; the probe script lives outside the repository in the session scratchpad.

### B1 — Bounded context manifest

- **Repository:** `ai-resources` (this linked worktree). **Base:** `0ccf397`.
- **Sources inspected:** `.agents/skills/work-loop-v2/SKILL.md`; `.claude/commands/work-loop-v2.md`; `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`; `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `dispatch.test.sh`; `.claude/commands/new-worktree-session.md`, `concurrent-session-check.md`, `close-worktree-session.md`; `docs/parallel-sessions-playbook.md`; `.claude/hooks/log-write-activity.sh`, `detect-concurrent-session.sh`; `.claude/settings.json`; `.gitignore`; closed records `logs/work-loop/work-loop-v2-parallel-worktree-proof.md` and `work-loop-v2-production-readiness-policy.md`.
- **Route:** safe reproduction in a throwaway sandbox, plus forensic reading of current code. No destructive or production reproduction attempted.
- **Scope:** current task/checkout binding, dispatcher locking and status, manual worktree paths.
- **Exclusions honoured:** no harness architecture, repository cleanup, landing automation, scheduling, semantic registries, or implementation design.
- **Authority gaps** `OBSERVED` — the non-governing investigation `plans/axcion-harness-v0.2/task-scoped-concurrency-investigation-2026-08-08.md` contains two stale citations: it states the readiness policy "is still at `turn: codex`" (its line 40) when that file is closed at `turn: operator`, and cites `LOCK_KEY` at "lines 450–467" when the code is at line 484. Treated as leads only, per the SOP authority hierarchy.

### B2 — Observed versus expected

**Failure 1 — the same logical task runs in two worktrees.**
Expected: one active dispatched run per logical task, repository-wide. Observed: both admitted.
`OBSERVED` — `dispatch.sh:484` keys the lock as `LOCK_KEY="$(printf '%s|%s' "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"`, and `dispatch.sh:367` canonicalizes `CHECKOUT` to the *physical* worktree path (`cd "$CHECKOUT" && pwd -P`). Two worktrees of one repository therefore produce two different keys for one task.

**Failure 2 — two tasks write one physical checkout.**
Expected: one dispatched writer per checkout. Observed: both admitted.
`OBSERVED` — the same line 484 includes `TASK` in the key, so two task ids in one checkout produce two different keys.

**Failure 3 — task-to-worktree continuity is carried by operator memory.**
Expected (per the task objective): a later handoff finds the checkout the task is bound to. Observed: nothing derives it.
`OBSERVED` — `.agents/skills/work-loop-v2/SKILL.md:155` makes the binding implicit and deliberately unrecorded: "The task file's location is the binding … Nothing records this in the file — a state field would be a second copy, free to drift from the path it duplicates."
`OBSERVED` — `.claude/commands/new-worktree-session.md` Step 1 composes the worktree path from an operator-supplied `UNIT` label and `WORKTREE_PATH="${REPO_ROOT}/../${REPO_NAME}-${UNIT}"`, with no reference to any Work Loop task id.
`OBSERVED` (absence) — searched `.claude/commands/`, `.claude/hooks/`, `.agents/skills/work-loop-v2/`, `docs/`, `logs/scripts/`, `plans/work-loop-v2-mvp/` (`*.md`, `*.sh`) for `task.{0,50}(worktree|checkout).{0,50}(own|bind|lease|registr|map)`, its reverse ordering, and the literals `task-to-worktree`, `worktree-for-task`, `task worktree`: **no match**. Searched `logs/` for a lease/registry/owner artifact: only `innovation-registry.md`, unrelated. Searched `dispatch.sh` for `git worktree`: no match — its only worktree awareness is reading `--git-common-dir` to widen the sandbox (line 1200).

### B2 — Reproduction: commands and actual output

Route taken: **safe reproduction**. Sandbox created with `mktemp -d`, its own `git init`, one linked worktree via `git worktree add`; simulated actors (`--actor-cmd 'sleep 8; exit 0'`); second dispatcher launched 3 s into the first. Script retained at the session scratchpad path `…/scratchpad/race-probe.sh`. The real repository was never a `--checkout` target.

```
RACE A — same task id, two different worktrees of ONE repository
lock key (main checkout, shared-task):   42ea9d68674d82d1
lock key (linked worktree, shared-task): 622473f3a5cce316
second dispatcher (linked worktree) exit: 22
  hop=1 actor=claude
  launch: mode=simulated timeout=30s cmd=sleep 8; exit 0
  STOP [22] actor 'claude' exited cleanly but left the state file byte-identical (hop 1)
VERDICT A: ADMITTED (exit 22, not 17)

RACE B — two different task ids, ONE physical checkout
lock key (main checkout, shared-task): 42ea9d68674d82d1
lock key (main checkout, task-two):    3267a7d8e154828a
second dispatcher (task-two) exit: 22
  hop=1 actor=claude
  launch: mode=simulated timeout=30s cmd=sleep 8; exit 0
VERDICT B: ADMITTED (exit 22, not 17)

CONTROL — same task, SAME checkout (the matched pair)
second dispatcher exit: 17
VERDICT CONTROL: REFUSED
```

`OBSERVED` — the control is what makes this falsifiable: the probe demonstrably *can* observe a refusal (exit 17, `LOCK_HELD`), so A and B admitting is a property of the lock key, not of the harness.
`OBSERVED` — exit 22 is reached **after** `launch:` — the second actor was started in both races. The refusal did not merely arrive late; it never applied.
`OBSERVED` — `dispatch.test.sh` contains 75 cases. Case 12 asserts exit 17 for the identical checkout+task pair; cases 27k and 27L assert exit 17 for a pinned lock. No case pairs one task across two worktrees, or two tasks in one checkout.

### B2 — A fourth failure observed live, in this task's own file

`OBSERVED` — while this unit was in flight and `turn:` was `claude`, `logs/work-loop/work-loop-v2-concurrent-task-isolation.md` was rewritten by another writer. The `## Brief` grew from 34 to 50 lines and `## Next action` changed from "verify the marked claims, perform the bounded discovery, write the recommended implementation-ready plan" to "read the operator-supplied SOP … stop without diagnosing, planning, or implementing the target." The editing tool reported the file had changed on disk since it was read.
`OBSERVED` — no protocol signal accompanied the change: `turn:` remained `claude` and `task:` was unchanged, so the identity and turn guards in core § 6 rule 2 and the command's Step 1 both passed.
`UNKNOWN` — whether this was a deliberate operator/Codex revision or an uncoordinated concurrent write. The file records no author, timestamp or revision marker, and none is recoverable from Git because the file is still untracked.
`INFERRED` — regardless of cause, a mid-unit replacement of the brief is not detectable by the current guards, because every guard keys on `task:` and `turn:`, neither of which changes when the brief's body is replaced.
`OBSERVED` — the practical consequence occurred: work completed against the superseded brief had to be discarded, and had it been handed back unnoticed it would have entered the SOP's Step B3 blind review as diagnosis-bearing content, which that step explicitly excludes.

### B2 — Affected components, consequences, recurrence, prior corrections

**Affected:** `dispatch.sh` (lock scope, status output); the Work Loop state-file interface; `/new-worktree-session`, `/concurrent-session-check`, `/close-worktree-session`; `docs/parallel-sessions-playbook.md`; the ambient write-activity hook; interactive and dispatched entry paths alike.

**Practical consequence** `OBSERVED` — two dispatched actors can run one task's state file concurrently in two worktrees, and two can write one checkout. `INFERRED` — the resulting harm is lost or contradictory updates to a file the core designates the single interface; not demonstrated here because the probe used simulated actors that changed nothing.

**Recurrence** `OBSERVED` — `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` is cited by `/concurrent-session-check` as the record that "every collision … came from starting a second session while one was live." `/new-worktree-session` records a 2026-07-14 near-miss that "came within one operator remark of destroying a live session's 173+ lines of uncommitted work." `/close-worktree-session` records a 2026-07-17 incident from an improvised stash→merge→pop. `OBSERVED` — 12 worktrees exist on this machine now (`git worktree list`): 3 Claude session worktrees, 8 Codex-managed, 1 prunable.

**Prior attempted corrections, verified as still present:**
`OBSERVED` — the checkout+task lock (`dispatch.sh:484`), which closes only the matched pair, as Case 12 and the control above show.
`OBSERVED` — `--unattended` containment, which disables the child's hooks; recorded as decision D1 in the closed readiness policy.
`OBSERVED` — `init_session_identity()`, arming the staging guard with the run's own footprint (readiness policy U1).
`OBSERVED` — decision D4, "a dispatched run may not create its own worktree", whose stated ground is that worktree creation is where the file-ownership gate lives (`docs/parallel-sessions-playbook.md` § 1 gate 1).
`OBSERVED` — advisory-only detection: `.claude/hooks/detect-concurrent-session.sh` enumerates via `ps` and prunes ghost markers; `/concurrent-session-check` is explicitly "read-only and advisory … never blocks."
`OBSERVED` — session markers are per-checkout and gitignored (`.gitignore:37–38`: `logs/.session-marker`, `logs/.session-marker-*`), so one worktree's marker is not visible from another through git.
`OBSERVED` — the ambient shared writer survives: `.claude/hooks/log-write-activity.sh` is registered at `.claude/settings.json:67` and `logs/friction-log.md` is tracked (`git ls-files` matches). It fired twice during this unit. The closed parallel-worktree proof records that its sandbox **neutralised** this file rather than solving it, and states the proof "does not authorize real-repository parallelism until the shared-writer question is settled."

### B2 — Confirmed, and still uncertain

Confirmed `OBSERVED`: both cross-pair races admit a second dispatcher and launch a second actor; the matched pair is refused; no task-to-worktree binding exists in the searched surfaces; the ambient shared writer is live; a mid-unit brief replacement is undetectable by the current guards.

Uncertain:
`UNKNOWN` — whether either race has ever caused real data loss in this repository. No incident record ties a loss to these two shapes specifically; the cited incidents are worktree-teardown and stash incidents.
`UNKNOWN` — behaviour with live actors rather than simulated ones. Both closed records state no live dispatched run has been made.
`UNKNOWN` — behaviour above fan-out 2, which decision D2 caps on a single observation.
`UNKNOWN` — the cause of the mid-unit brief replacement.

### B2 — Candidate explanations only

Listed as candidates, not chosen, and deliberately not ranked. `PROPOSED` in every case:
1. The lock's key encodes the *physical* pair actually being written rather than the *logical* things needing exclusivity, so exclusivity holds only where both coincide.
2. Ownership of a task by a checkout is real but unrepresented, so nothing can be asked about it at launch.
3. The controls that do exist are advisory or per-checkout, so they cannot see across worktrees.
4. Isolation is decided by a human reading a table at chat-creation time, so no automated surface holds the decision.
5. The state file is guarded for identity and turn but not for content revision, so a brief can be replaced without any guard noticing.

### B2 — Reproduction asset

`PROPOSED` — the retained sandbox script re-runs all three cases (A, B, control) and prints a verdict per case; it is safe to run repeatedly because it builds and targets only a throwaway repository. It is a reproduction script, not a regression test, and it currently lives outside the repository.

### Qualification outcome

**Structural (SOP Lane B) — confirmed.** The provisional judgment holds on current evidence. Against SOP § 1.2, five of six Lane B criteria are met on `OBSERVED` evidence:
- *Crosses ownership, workflow, component or repository boundaries* — Claude/Codex actors, Work Loop state, session markers and worktrees.
- *Depends on shared state, hidden coupling or ambiguous authority* — the tracked `friction-log.md` co-writer; the unrepresented task↔checkout binding.
- *Creates false-success behaviour* — in both races the dispatcher launched a second actor and then reported `STOP [22] … no observable transition`, a message about the state file that says nothing about the second writer.
- *Has survived a relevant prior correction* — the checkout+task lock was the correction, and it closes only the matched pair.
- *Requires a change to the operating model or a governing mechanism* — the objective's automatic creation/reuse contradicts decision D4 and two clauses of the deployed skill (SKILL.md:171, "do not build a decision procedure on top of" the isolation table; SKILL.md:180, "Codex-managed worktrees … are not a continuity surface").

The sixth, *repeatedly generates compensating controls*, is `INFERRED`: five advisory or partial controls now surround this area (detector hook, `/concurrent-session-check`, staging guard, destructive-liveness hook, playbook gates), which fits the pattern, but no record states they were added in response to these two races specifically.

Not rerouted to Lane A: the correction is not local to one component, and the objective itself changes the operating model.

## Blocker

None.

## Next action

Codex: assess the Gate 2 failure proof and the `Structural (Lane B) — confirmed` qualification above, then choose the smallest next justified unit. Three things need a decision before Step B4 opens:

1. **Step B3 requires a genuinely fresh Codex context.** The SOP states the current conversation cannot perform the blind review because it has already seen proposed explanations. Per the durable procedure's step 2, the operator must be told explicitly when that fresh context is required. This result deliberately contains no diagnosis so it can be handed to that review unaltered.
2. **A mid-unit brief replacement was observed** (see § B2 — A fourth failure observed live). The first execution of this unit ran against the superseded brief and produced a plan; that output was discarded rather than handed back, because the replacement brief forbids diagnosis and planning and the SOP's blind review excludes diagnosis-bearing content. Confirm the replacement was intended, and decide whether the undetectable-revision finding belongs inside this task's scope or is a separate defect.
3. **Two stale citations** in the non-governing investigation are recorded under authority gaps; decide whether correcting them is in scope.
