# Work Loop v2 — handoff dispatcher spike

**Throwaway spike. Not production, not installed anywhere.** Everything in this directory exists to
answer one question: can two products carry a Work Loop v2 turn between them, in one checkout,
without the operator moving the file by hand?

The controller is `dispatch.sh`. It carries **one exact task** through routine Codex ↔ Claude turns:
it launches at most one actor at a time, re-reads the authoritative state file from disk after every
process exit, and stops visibly rather than guessing. It creates no queue and no shadow state —
`logs/work-loop/{task-id}.md` stays the only semantic interface, and the controller's entire memory
is the task id it was given at launch.

Files here:

| File | What it is |
|---|---|
| `dispatch.sh` | The controller. |
| `dispatch.test.sh` | Failing-case harness for the controller. Entirely simulated. |
| `ps-sampler.sh` | Helper that samples running processes during a live run. |
| `runs/` | Per-run evidence: one `.log` per run plus one `.out` per hop, and any written-up **live** product evidence. |

---

## Running the dispatcher

```
dispatch.sh --checkout <abs-path> --task <task-id> [options]
```

Both `--checkout` and `--task` are required. `--checkout` must be a directory that is a Git
checkout; `--task` must match `^[A-Za-z0-9][A-Za-z0-9._-]*$` and is rejected before any path is
built from it.

| Option | Default |
|---|---|
| `--carry-one` | off — carry exactly one hop, then exit `0` (see below) |
| `--max-hops N` | `4` — absolute hop limit; forced to `1` by `--carry-one` |
| `--timeout S` | `900` — per-actor wall-clock seconds |
| `--deadline S` | none — whole-run wall-clock budget (see below) |
| `--codex-bin PATH` | `/Applications/ChatGPT.app/Contents/Resources/codex` |
| `--claude-bin PATH` | `claude` resolved from `PATH` |
| `--allow-path RE` | `^logs/work-loop/` and `^plans/work-loop-v2-v0\.2/handoff-automation-spike/` (repeatable; supplying any replaces both defaults) |
| `--claude-deny RULE` | none — repeatable; passed to the Claude child as `--disallowedTools RULE` |
| `--log-dir DIR` | `<spike>/runs` |
| `--dry-run` | off |
| `--status` | off — read-only report; takes no lock, writes nothing |
| `--actor-cmd CMD` | none |

### The four modes

- **`--help`** — prints the header block and exits. Validates nothing, launches nothing.
- **`--status`** (`mode=status`) — reports whether a run is in flight for this checkout + task, what
  the state file says, which branch `HEAD` is on, and where the run log is. It takes **no lock**,
  creates **no log directory**, and writes nothing at all, so it is safe to run against a live run —
  which is the whole point of it. Returns `0` even while another dispatcher holds the lock.
- **`--dry-run`** (`mode=dry-run`) — validates the checkout, the task id, the state file and the
  restart condition, then names the actor it *would* launch and stops. Launches nothing and writes
  nothing to the state file. Unlike `--status`, it **does** take the lock.
- **loop mode** (`mode=live`, or `mode=simulated` when `--actor-cmd` is given) — actually runs the
  turns until the state file reaches `turn: operator`, or until something stops it.

`--status` and `--dry-run` answer different questions and are refused together (`10`) rather than one
silently winning.

### `--deadline` — a wall-clock budget for the whole run

Without it, the real upper bound is `--max-hops × --timeout`; the defaults make that **one hour**, and
a walk-away invocation of `--max-hops 12 --timeout 900` makes it **three hours**. That is not a bound
for someone expecting to be back in forty minutes, so the dispatcher now prints the bound it is
actually running under at startup either way.

`--deadline` is a deadline, not a start gate. The clock starts at the **first statement of the
script**, before argument parsing or any setup. Before every launch — including a retry — the actor's
effective timeout is clamped to `min(--timeout, time remaining)`, and an actor still running when the
clock expires is terminated through the same path as an interruption. The run then exits `29`.

**The honest worst case**, because a deadline is worth what its bound is:

```
overrun <= 1s (poll interval) + 5s (TERM→KILL grace) + reaping  ≈ 6s
```

So `--deadline 2400` ends at roughly 2406s. It never ends at exactly 2400s, and — the point of the
clamp — it never ends at `2400 + --timeout`. Test case 28 asserts this arithmetic rather than a round
number.

**`29` is not completion.** The state file and Git are untouched by the stop, so the work is
resumable: re-run the dispatcher and it continues from the file. But a killed actor carries the same
partial-effect risk as an interruption, so it is **never** retried automatically — inspect first.

### `--claude-deny` — narrowing the unattended child's authority

Plumbing, not a policy. With no `--claude-deny` the Claude launch is byte-for-byte what it always
was, and the child holds the checkout's normal authority.

What it is for: a run nobody is watching may warrant less authority than an attended one. A rule
passed here reaches the child as `--disallowedTools`, applies to **that child only**, and does not
touch any `settings.json` or the operator's interactive sessions.

**Two facts about it are measured, not assumed** (`runs/probe-unattended-authority-2026-08-07.md`):

- A deny passed this way **beats `bypassPermissions`**. `--claude-deny 'Bash(git push:*)'` stops the
  child pushing, moving that guarantee off a model-side CLAUDE.md rule and onto the permission layer.
- It **cannot** buy network isolation. Denying `WebFetch`/`WebSearch` just sends the child to `curl`
  via Bash — observed, twice, unprompted. Denying `Bash` outright works but stops the child doing the
  work it was launched for. Network containment needs an OS-level sandbox, not a permission rule.

  **That last sentence is true, and Claude Code provides the sandbox** (corrected 2026-08-07,
  `runs/probe-contained-authority-2026-08-07.md`). A macOS Seatbelt sandbox covers Bash and every
  child process, and `strictAllowlist` with an empty `allowedDomains` refuses non-allowlisted hosts
  outright — `curl` was measured being refused. So network isolation *is* available; it simply is not
  available through `--claude-deny`, which remains a permission-layer flag only.

  **`--claude-deny` is therefore not the operator's chosen unattended profile, and must not be
  described as it.** The operator settled on the contained profile (sandbox settings + a restricted
  tool set + push denial together). The dispatcher does not implement it yet. Until it does, running
  unattended with `--claude-deny` alone leaves the network open.

`--carry-one` is a **terminal condition on loop mode**, not a fourth mode: it launches exactly the
actor the current `turn:` names, applies every validation and post-hop check unchanged, and then
exits `0` once the turn has moved in an allowed direction instead of continuing to the next actor.

It exists because a one-hop carry otherwise ends at `23 HOP_LIMIT` — a failure code for the expected
outcome, which no caller can use as a success signal. `--carry-one` pins `--max-hops` to 1, so the
loop guard and the terminal condition cannot drift apart.

This is the mode a **courier** uses (core § 4, *An approved courier may carry the turn*). It keeps
the framing and assessing model in the conversation: the courier carries one turn, then reads the
state file and assesses, rather than handing the whole task to a chain of headless processes.
`dispatch.test.sh` cases 23–26 assert both halves — that a carry exits `0`, and that the same single
hop *without* `--carry-one` still exits `23`.

`--actor-cmd` is the **test seam**. It replaces the live product launch with an arbitrary command
and marks the run `mode=simulated` in all evidence, so a simulated pass can never be read as live
transport.

In live mode the launches are:

```
codex exec --sandbox workspace-write -C <checkout> --json <prompt>
claude -p "/work-loop-v2 <task-id>" --output-format json      (cwd = <checkout>)
```

The dispatcher adds no permission flags of its own unless `--claude-deny` is given — otherwise the
Claude child inherits the project's normal settings policy.

### Example

```bash
bash dispatch.sh \
  --checkout "/Users/you/Claude Code/Axcion AI Repo/ai-resources" \
  --task spike-live-transport \
  --dry-run
```

### The walk-away invocation, as a worked example

> # ⛔ DO NOT RUN — 2026-08-07
>
> **This is a worked example of a shape that is not cleared for use.** Five Phase 2 blockers stand
> between it and a real walk-away run (full list: `unattended-operation-plan-v0.2.md`, status block).
> Four of them change how *this very command* behaves:
>
> 1. **The contained profile is not wired in.** Nothing below restricts the child. The run has an
>    open network and full file authority, whatever the settled 1d policy says.
> 2. **`--status` (step 4) can lie.** Against a live run it reports `STALE LOCK` whenever it cannot
>    inspect the PID — measured in Phase 0 from inside a Codex sandbox. The one instrument this
>    example offers for checking on the run is the one that misreports it as dead.
> 3. **The stop (step 3) reaches a process group, not a tree.** A descendant that calls `setsid`
>    survives `kill`, after you believe the run is stopped.
> 4. **The `… &` detached shape does not survive a Codex-command launch.** Phase 0 § 0b: the
>    background process is reaped before the dispatcher starts — empty console, no lock, no run log.
>    A supervised terminal is currently the only launch that works, so `&` here is misleading.
>
> Keep this example for its structure — the four surrounding steps are right. Do not execute it
> until the blockers are cleared and this notice is removed.

Four things around the command matter as much as the command. Copying the middle line alone is not
the invocation.

```bash
# 1. Clean tree, own branch. Unattended hops commit; this keeps them off main and
#    makes the whole run droppable with one command.
git -C "$REPO" status --porcelain          # must be empty
git -C "$REPO" checkout -b "work-loop/$TASK"

# 2. Prevent sleep. Without this the Mac sleeps and the run dies mid-hop.
#    caffeinate -i wraps the command and lifts as soon as it exits.
caffeinate -i bash dispatch.sh \
  --checkout "$REPO" \
  --task "$TASK" \
  --max-hops 12 \
  --timeout 900 \
  --deadline 2400 \
  --allow-path '^logs/work-loop/' \
  --allow-path '<what THIS unit may legitimately touch>' \
  > "runs/walkaway-$TASK.console" 2>&1 &
echo $! > /tmp/walkaway.pid          # 3. how you stop it later

# 4. On return — or at any point, from another terminal:
bash dispatch.sh --checkout "$REPO" --task "$TASK" --status
```

- **`--deadline 2400`** is the forty minutes. `--max-hops 12` is the secondary bound.
- **`--allow-path` is a per-task input, not boilerplate.** `1c` checks what the actor *committed*
  against it, so it has to describe what this unit may legitimately change. Too narrow gives false
  stops; too wide and the check means nothing. Whoever writes the unit brief derives it.
- **To stop the run:** `kill -TERM $(cat /tmp/walkaway.pid)`. The dispatcher terminates the actor's
  process group and exits `28`. `--status` prints this same command back at you.
- **Nobody opens the checkout while the run is live.** A branch shares the working directory and index
  with any other session in that checkout — see *Isolation* under Safety boundaries.

---

## Exit codes

The source declares this set. Read the middle column as *which modes can return it*, because that is
where the code's meaning actually differs.

| Code | Name | Modes | Meaning |
|---|---|---|---|
| `0` | — | all three | See the note below — it does **not** mean one thing. |
| `10` | `BAD_USAGE` | all after `--help` | Unknown argument, missing `--checkout`/`--task`, non-integer or `< 1` `--max-hops`, non-integer `--timeout`, or the log directory could not be created. |
| `11` | `BAD_CHECKOUT` | dry-run, loop | `--checkout` is not a directory, cannot be canonicalized, or is not a Git checkout. |
| `12` | `BAD_TASK_ID` | dry-run, loop | Task id contains a path separator, traversal or illegal characters; or the resolved state file does not sit directly inside `logs/work-loop/`. |
| `13` | `STATE_MISSING` | dry-run, loop | The state file is absent or unreadable. |
| `14` | `IDENTITY_MISMATCH` | dry-run, loop | No readable `task:` frontmatter, or the filename stem differs from `task:`. |
| `15` | `BAD_TURN` | dry-run, loop | `turn:` is absent or is not one of `codex`, `claude`, `operator`. (The same code guards an unlaunchable actor inside the loop — a defensive branch `validate_state` should already have excluded.) |
| `16` | `FOREIGN_STAGED` | loop only | Something was already staged before a hop. The spike stops rather than sweeping it into a commit. |
| `17` | `LOCK_HELD` | dry-run, loop | Another dispatcher already holds this checkout + task. |
| `18` | `FOREIGN_UNSTAGED` | loop only | Out-of-allowlist working-tree changes were **already present** before a hop. The before/after delta cannot see these — both snapshots contain them — so they used to pass straight through. `--dry-run` reports them instead of failing. |
| `19` | `GIT_HAZARD` | loop only | The checkout holds a Git `index.lock`, or a merge, rebase, cherry-pick or revert is in progress. A second writer would compound it. `--dry-run` reports instead of failing. |
| `20` | `ACTOR_FAILED` | loop only | The actor exited non-zero, or the Codex/Claude binary was not executable or not resolvable. A failure that left the repository **provably unchanged** (state `sha256`, `HEAD`, foreign working tree and the state file's committed-ness all identical) is retried **once** first; a failure after any change is never retried. |
| `21` | `ACTOR_TIMEOUT` | loop only | The actor exceeded `--timeout` and was killed (`TERM`, then `KILL`). |
| `22` | `NO_TRANSITION` | loop only | The actor exited cleanly but left the state file byte-identical, left `turn:` unchanged, or moved it in a direction that is not allowed. |
| `23` | `HOP_LIMIT` | loop only | `--max-hops` was reached with `turn:` still on an actor. |
| `24` | `UNEXPECTED_EFFECT` | loop only | An actor changed paths outside the allowlist, or the Codex actor moved `HEAD`. |
| `25` | `UNCOMMITTED_HANDBACK` | dry-run, loop | The state file is uncommitted where Claude should have committed it — either found that way at startup with `turn: codex`/`operator`, or left that way after a Claude hop. |
| `26` | `MALFORMED_TERMINAL` | loop only | `turn: operator`, but the file is neither a core § 7 question (it has no `## Blocker` and no `## Next action`) nor a core § 4 closing record (its four headings, and nothing else, are not what survived). No actor is launched; the stop names a recoverable next action. |
| `28` | `INTERRUPTED` | loop only | `SIGINT`/`SIGTERM`. The actor's **process group** is terminated (see the caveat under Safety boundaries — group, not tree), the lock is released once, and the run stops. **Never retried** — the signal may have landed after an effect nobody observed, so the state file and `git status` are where the operator has to look. |
| `29` | `BUDGET_EXHAUSTED` | loop only | `--deadline` expired: either the loop refused to launch the next hop, or a running actor was terminated at the clock. **Not completion.** Resumable — the state file and Git are untouched by the stop — but never retried automatically. Worst-case overrun is `1s poll + 5s TERM→KILL grace + reaping`, roughly 6s — not exact-to-the-second. |
| `30` | `UNEXPECTED_COMMIT` | loop only | An actor **committed** paths outside the allowlist. Detection, not prevention: the commit already exists, and the value is stopping rather than compounding it over the rest of an unattended run. Distinct from `24`, which is the working-tree case, because the recovery differs — `24` is reverted from the working tree, `30` from history. |

> **Why `28`–`30` exist.** `27` is deliberately unused: it was reserved in plan v0.1 for
> `--expect-turn`, which v0.2 dropped (unattended loop mode makes the repeating-courier shape it
> guarded unnecessary, and the lock already refuses a second dispatcher). Leaving the gap is cheaper
> than renumbering if it is ever built.

**Exit `0` means five different things depending on how you invoked the dispatcher:**

- `--help` returns `0` after printing the header. Nothing was validated.
- `--status` returns `0` after reporting what it could read. Nothing was validated beyond
  readability, nothing was launched, nothing was written — including when a run is in flight.
- A completed `--dry-run` returns `0` after validation. **No turn was taken.**
- A `--carry-one` run returns `0` when the turn moved exactly once in an allowed direction — **or**
  when `turn:` was already `operator` and nothing was carried. Read `turn:` from the state file to
  tell those apart; the file is authoritative over the exit code either way (core § 4).
- A loop-mode run returns `0` **only** after the state file reached `turn: operator` — automation is
  terminal there (core § 7). This is the only invocation for which `0` carries the whole-loop meaning.

> **The line-31 contradiction recorded here is now fixed** (2026-08-06). The header's opening line
> read *"0 is the ONLY success, and it means the loop reached turn: operator"* — true of loop mode
> alone, and left standing as a deferral when `--help` and `--dry-run` were documented beneath it.
> Adding `--carry-one` gave `0` a fourth meaning and made that wording actively wrong rather than
> merely incomplete, so it was corrected rather than deferred again. The header now states all four
> meanings in one block.
> The `--help` truncation recorded here was fixed earlier (2026-08-05): it printed a fixed line
> window (`sed -n '2,45p'`) and so under-reported the exit-code set. It now prints the whole leading
> comment block whatever length it grows to, which is what let codes `18` and `19` — and this
> block — be added without silently re-truncating.
> This table is generated from the source header, not from `--help`.

### Allowed turn transitions

`codex → claude`, `codex → operator`, `claude → codex`, `claude → operator`. Anything else is `22`.

---

## Running the tests

```bash
bash dispatch.test.sh
DISPATCH_BIN=/path/to/dispatch.sh bash dispatch.test.sh
```

The suite builds throwaway sandbox checkouts under `TMPDIR` and removes them on exit. It touches no
real repository. It ends with a summary line and exits `1` if any case failed:

```
pass=99 fail=0  (all cases SIMULATED — no live product transport)
```

> **This count was stale.** It read `pass=69` until 2026-08-06, when the suite actually stood at 82 —
> cases had been added without updating the line. Re-measured that day: the pre-`--carry-one` suite
> from `HEAD` returns **82**, and cases 23–26 bring it to **99**. A hand-maintained count drifts
> silently, so treat the number as documentation and the run as the evidence.

**Case 0 is the harness's own falsifiability proof:** it points the suite at an *absent* dispatcher
and asserts that the suite fails. A harness that stays green with the thing under test removed is not
evidence. Cases 1–13b cover exact-task routing against decoy state files, identity-mismatch
rejection, path traversal, missing and malformed state, `turn: operator` as terminal, no-op actors,
actor failure and timeout, the hop limit, foreign staged state, out-of-allowlist writes and Codex
moving `HEAD`, an unattended simulated round trip, the lock, and the uncommitted-handback seam.

Cases 14–20 are the safety gates added on 2026-08-05:

| Case | What it pins |
|---|---|
| `14` | An actor blocked on an approval nobody will give is killed on the clock, the capture shows it stopped *on* the prompt, and no permission surface was touched to get past it. |
| `15` | A crash **before** any repository change is retried exactly once, and the first attempt's output is kept as separate evidence (`.hop1r.` capture). |
| `15b` | A crash **after** a repository change is never retried — a retry would run over a partial effect. |
| `16` | Foreign **unstaged** work (tracked-modified and untracked) stops the run before any launch; the expected uncommitted Codex handoff still launches. |
| `17` | A held Git `index.lock` stops the run before any launch. |
| `18` | `MERGE_HEAD`, `CHERRY_PICK_HEAD`, `REVERT_HEAD`, `rebase-merge/` and `rebase-apply/` each stop the run before any launch. |
| `19` | A duplicate completion event relaunches nothing. |
| `20` | A core § 7 operator question reaches `turn: operator`, is preserved in the file, is surfaced in the output, and is marked unanswered. |
| `21` | `turn: operator` reached by a core § 4 **close** is announced as a close — not as an unanswered question above an empty block. |
| `22` | A `turn: operator` file that is **neither** shape stops `26` for inspection instead of being labelled closed — a partial record, an active field surviving the reduction, the four headings **out of core § 4 order**, or one of them written **twice**. |

Red-to-green for those seven, against the pre-change controller from `HEAD`:

```
DISPATCH_BIN=<pre-change dispatch.sh> bash dispatch.test.sh   →  pass=49 fail=20  (exit 1)
bash dispatch.test.sh                                         →  pass=69 fail=0   (exit 0)
```

Cases `21` and `22` were added later, by the parallel proof below, and `22` took three passes — each
with its own red-to-green against the controller that immediately preceded it:

```
21           pass=71 fail=2  →  pass=73 fail=0
22           pass=74 fail=4  →  pass=78 fail=0
22 (order)   pass=80 fail=2  →  pass=82 fail=0
```

The chain is the point. `21` said "no `## Blocker` and no `## Next action` means closed" — necessary,
not sufficient, so a hop that died mid-reduction was announced as a clean close. `22` required the
four headings and nothing else — but compared them through `sort -u`, so the same four shuffled, or
one of them written twice, still passed. The classifier now compares the literal heading sequence.

**Live product evidence lives in `runs/`, never in this suite.** `runs/live-permission-denial-2026-08-05.md`
records what the real binary does when it is refused permission — the half of safety cluster 1 no
controller test can establish — including one denial carried **through `dispatch.sh` itself**, with
the dispatcher's own exit, launch count and before/after state hashes.
`runs/parallel-worktree-proof-2026-08-05.md` records the two-worktree parallel run (§ below).

## The parallel instruments

Three scripts exist for the two-worktree proof and are not used by the single-checkout suite:

| Script | What it does |
|---|---|
| `parallel-sampler.sh` | Samples the process table every 2 s, recording each dispatcher/actor's pid, ppid, routing argument and **kernel `cwd`** (via `lsof -a -d cwd`). Answers "did the runs genuinely overlap?" and "did each child live in the worktree it was routed to?" |
| `parallel-isolation-check.sh` | Reads a finished run back and asserts nine isolation properties (A1–A9). Expectations are overridable so the checker can be made to fail on purpose — a checker nobody has seen fail is an untested instrument. |
| `parallel-landing-qc.sh` | Both-sides-present integration QC after a serial landing (B1–B9): presence of each result and closing record first, conflict/`[IN FLIGHT]` sweeps second. |

---

## Safety boundaries

- **One task, one checkout, serial — per dispatcher instance.** A single instance is never
  multi-loop. Two *instances* in two linked worktrees were proven to overlap safely on 2026-08-05;
  same-checkout concurrency is still unsafe — see `docs/parallel-sessions-playbook.md` § 4.
- **The dispatcher never writes the state file.** Only the actors do. It reads, hashes and compares.
- **A lock** keyed on `checkout|task` (a directory under `TMPDIR`) refuses a second dispatcher on the
  same pair.
- **An allowlist** bounds which repo-relative paths an actor may change; anything else stops the run.
  It is checked in three directions: as a *delta* across each hop's working tree (`24`), as a
  **pre-hop gate** on work that was already there (`18`), and against what the actor **committed**
  between the hop's before- and after-`HEAD` (`30`). The dispatcher's own `--log-dir` is added to the
  allowlist when it sits inside the checkout, so a run never flags its own evidence as foreign work.
  > **The committed-path check (`30`) closed a real gap, and it is not free.** `18`/`24` read
  > `git status --porcelain`. Claude commits its work each hop, so a clean tree passed them no matter
  > what went into the commit — only stray *uncommitted* files ever tripped the guard. `30` compares
  > `before_head..after_head`, which means the allowlist now has to describe what **this unit** may
  > legitimately touch rather than what the spike touches in general. That makes it a per-task input
  > derived when the unit brief is written. Too narrow gives false stops; too wide and the check is
  > decoration.
  > **Consequence for live runs in *this* repository — read before launching one.** A PostToolUse
  > hook appends to `logs/friction-log.md` continuously, so that file is almost always modified. Gate
  > `18` therefore stops a live run here unless the allowlist covers it. A `--dry-run` on 2026-08-05
  > reported exactly that. And because **supplying any `--allow-path` replaces both defaults**, a
  > live run needs all three:
  >
  > ```
  > --allow-path '^logs/work-loop/' \
  > --allow-path '^plans/work-loop-v2-v0\.2/handoff-automation-spike/' \
  > --allow-path '^logs/friction-log\.md$'
  > ```
  >
  > Run `--dry-run` first. It reports what gate `18` would stop on instead of failing.

- **Hazardous Git states stop the run before any launch** (`19`) — a held `index.lock`, or a merge,
  rebase, cherry-pick or revert in progress. Checked before *every* hop, not once at startup, so a
  restart re-enters the same gate.
- **One retry, and only from proven repository truth.** A failed actor is relaunched once when the
  state file, `HEAD`, the foreign working tree and the state file's committed-ness are all exactly
  where they were. Any doubt is treated as a partial side effect and stops.
- **Asymmetric restart safety.** An uncommitted state file with `turn: claude` is the *expected*
  Codex handoff, because Codex writes the file and never runs Git. An uncommitted file with
  `turn: codex` or `turn: operator` means a Claude hop died between editing and committing, and the
  run stops for inspection instead of relaunching over a partial edit.
- **The run can be stopped.** `SIGINT`/`SIGTERM` terminates the actor's **process group**, releases
  the lock once, and exits `28`. This was not true before 2026-08-07: the old handler released the
  lock without exiting, so a stop attempt left the run going *and* admitted a second dispatcher onto
  the same state file. Both the defect and the fix are OBSERVED —
  `runs/probe-interruption-2026-08-07.md`, with the probe script and a before/after raw capture under
  `runs/probes/`.
  > **It is a process-*group* kill, not a process-*tree* kill.** Descendants that stay in the actor's
  > group die with it; a descendant that leaves the group — `setsid(2)`, its own process group, a
  > double fork — survives. `dispatch.test.sh` case 27b asserts that boundary rather than assuming
  > it. Sufficient for `claude -p` and `codex exec`, which keep their children in-group; not a
  > general guarantee.
- **Isolation is a branch, and a branch is not a worktree.** The pilot runs on
  `work-loop/<task-id>` off a clean tree. This keeps unattended commits off `main` and makes the run
  droppable, but a branch **shares the working directory and index** with anything else open in that
  checkout, and switching it switches what the operator sees. The containment is therefore *"nobody
  opens the checkout while the run is live"*, which walking away satisfies by definition.
  > **Temporary limitation, with a named reason.** A dedicated worktree is the right answer and is
  > blocked: the ambient `friction-log.md` writer appends to a tracked file, which
  > `logs/work-loop/work-loop-v2-production-readiness-policy.md:252` marks as a guaranteed landing
  > conflict under worktrees. Worktrees become available once that is fixed — not before.

### The honest risk envelope for an unattended run

What actually contains a walk-away run, stated plainly because the operator reads this before
leaving rather than after:

| Contains it | Does **not** contain it |
|---|---|
| One task, one checkout, serial (the lock) | Anything outside the checkout — the filesystem at large |
| Local commits on a branch off a clean tree | `main` is protected; the *network* is not |
| A hard `--deadline`, plus `--max-hops` | Nothing bounds what a single hop *does* within its allowlist |
| Stop control that reaches the actor's process **group** (`28`) | **A descendant that leaves the group survives the stop** — anything that calls `setsid` outlives the run. Asserted, not assumed: case 27b. Also: an effect that landed before the signal — never retried, always inspected |
| Allowlist on working tree (`18`/`24`) **and** commits (`30`) | Both are **detection, not prevention**. The change has happened; the run stops rather than compounding |
| `--claude-deny 'Bash(git push:*)'` if the operator chooses it | Network access. Denying `WebFetch` sends the child to `curl` — measured, `runs/probe-unattended-authority-2026-08-07.md` |

`git push` is otherwise held only by a CLAUDE.md rule — a model-side rule, which is weakest exactly
when nobody is watching. `--claude-deny` is how that moves to the permission layer, for the
unattended child alone, if the operator wants it there.

**This table describes the dispatcher as it is built today, and it is still accurate today.** The
operator has since settled on a contained profile that would move three of these rows from the right
column to the left — network access, writes outside the checkout, and push all become OS- or
permission-enforced rather than merely detected (`runs/probe-contained-authority-2026-08-07.md`).
**The dispatcher does not implement that profile yet.** Do not read the settled decision as a
containment you currently have; until the unattended mode is built and live-tested, the table above
is what a walk-away run actually gets.

---

## What this spike does **not** establish

A run records: run id, mode, task, checkout, state path, hop and timeout settings, the allowlist,
and per hop the before/after `sha256`, `turn:`, `HEAD`, actor exit status, duration and transition
verdict — plus one stdout capture per hop. That is the whole evidence base. Nothing in it speaks to:

- **Live product transport, from the test suite.** Every case in `dispatch.test.sh` runs through
  `--actor-cmd`. The suite proves controller logic only. A green suite is not a live run.
- **Production readiness.** This is a throwaway spike in a `plans/` directory, deliberately not
  installed as a hook, command or service.
- **Concurrency safety beyond two isolated worktrees.** The lock is exercised for one checkout +
  task pair. Two dispatchers in two *linked worktrees* were proven to overlap safely on 2026-08-05
  (`runs/parallel-worktree-proof-2026-08-05.md`) — two tasks, one observation, fixture-sized units,
  and both tasks created only new files. Same-checkout concurrency remains untested and unsafe, and
  nothing here speaks to three or more loops.
- **Repeat reliability.** One successful run is one observation. The run log records that run and
  nothing about the distribution of outcomes across runs.
- **Unattended handling of operator decisions.** Reaching `turn: operator` is where the automation
  *stops*. The dispatcher now prints the question and states that nobody answered it (case 20), but
  what happens to the decision after that is outside the dispatcher entirely.
- **Which exit code a refused actor produces.** A denied actor exits `0`, so a real permission denial
  never reaches the dispatcher as `20 ACTOR_FAILED`. It arrives as `22 NO_TRANSITION` if the actor
  changed nothing, or as `25 UNCOMMITTED_HANDBACK` if it edited the state file and was then refused
  the commit — the second measured end-to-end through `dispatch.sh` on 2026-08-05. Both stops are
  correct and bounded, and neither code *names* denial as the cause; the hop capture's
  `permission_denials` does. Full measurement: `runs/live-permission-denial-2026-08-05.md`.
- **Anything about the quality of the work the models did.** The dispatcher checks that the file
  moved in an allowed direction and that no unexpected repository effect occurred. It does not read
  the content.

Where this README describes behaviour that was reproduced (exit statuses, the test summary), it says
so. Anything beyond the list of recorded fields above is inference, not evidence.
