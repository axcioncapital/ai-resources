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
| `--max-hops N` | `4` — absolute hop limit |
| `--timeout S` | `900` — per-actor wall-clock seconds |
| `--codex-bin PATH` | `/Applications/ChatGPT.app/Contents/Resources/codex` |
| `--claude-bin PATH` | `claude` resolved from `PATH` |
| `--allow-path RE` | `^logs/work-loop/` and `^plans/work-loop-v2-v0\.2/handoff-automation-spike/` (repeatable; supplying any replaces both defaults) |
| `--log-dir DIR` | `<spike>/runs` |
| `--dry-run` | off |
| `--actor-cmd CMD` | none |

### The three modes

- **`--help`** — prints the header block and exits. Validates nothing, launches nothing.
- **`--dry-run`** (`mode=dry-run`) — validates the checkout, the task id, the state file and the
  restart condition, then names the actor it *would* launch and stops. Launches nothing and writes
  nothing to the state file.
- **loop mode** (`mode=live`, or `mode=simulated` when `--actor-cmd` is given) — actually runs the
  turns until the state file reaches `turn: operator`, or until something stops it.

`--actor-cmd` is the **test seam**. It replaces the live product launch with an arbitrary command
and marks the run `mode=simulated` in all evidence, so a simulated pass can never be read as live
transport.

In live mode the launches are:

```
codex exec --sandbox workspace-write -C <checkout> --json <prompt>
claude -p "/work-loop-v2 <task-id>" --output-format json      (cwd = <checkout>)
```

The dispatcher adds no permission flags of its own — the Claude child inherits the project's normal
settings policy.

### Example

```bash
bash dispatch.sh \
  --checkout "/Users/you/Claude Code/Axcion AI Repo/ai-resources" \
  --task spike-live-transport \
  --dry-run
```

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

**Exit `0` means three different things depending on how you invoked the dispatcher:**

- `--help` returns `0` after printing the header. Nothing was validated.
- A completed `--dry-run` returns `0` after validation. **No turn was taken.**
- A loop-mode run returns `0` **only** after the state file reached `turn: operator` — automation is
  terminal there (core § 7). This is the only invocation for which `0` carries the loop meaning.

> **Known source inconsistency — do not treat either side as the whole contract.**
> `dispatch.sh` line 31 says *"0 is the ONLY success, and it means the loop reached turn: operator"*.
> That sentence is true of loop mode only; `--help` and `--dry-run` both return `0` without reaching
> `turn: operator`. Lines 48–49 of the same header now say so, but line 31 was left standing, so the
> header disagrees with itself.
> The `--help` truncation recorded here is **fixed** (2026-08-05): it printed a fixed line window
> (`sed -n '2,45p'`) and so under-reported the exit-code set. It now prints the whole leading comment
> block whatever length it grows to, which is what let codes `18` and `19` be added without silently
> re-truncating. The line-31 wording contradiction is still standing and still a deferral.
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
pass=69 fail=0  (all cases SIMULATED — no live product transport)
```

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

Red-to-green for those seven, against the pre-change controller from `HEAD`:

```
DISPATCH_BIN=<pre-change dispatch.sh> bash dispatch.test.sh   →  pass=49 fail=20  (exit 1)
bash dispatch.test.sh                                         →  pass=69 fail=0   (exit 0)
```

Case `21` was added later, by the parallel proof below, and has its own red-to-green:
`pass=71 fail=2` against the pre-correction controller, `pass=73 fail=0` after.

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
  It is checked in two directions: as a *delta* across each hop (`24`), and as a **pre-hop gate** on
  work that was already there (`18`). The dispatcher's own `--log-dir` is added to the allowlist when
  it sits inside the checkout, so a run never flags its own evidence as foreign work.
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
