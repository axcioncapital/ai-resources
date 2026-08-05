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
| `runs/` | Per-run evidence: one `.log` per run plus one `.out` per hop. |

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
| `20` | `ACTOR_FAILED` | loop only | The actor exited non-zero, or the Codex/Claude binary was not executable or not resolvable. |
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
> Separately, `--help` prints lines 2–45 of the script (`sed -n '2,45p'`), so its output stops one
> line short of exit code `25` and never shows the lines 48–49 note at all — **`--help` under-reports
> the exit-code set.**
> Both are defects in `dispatch.sh`, which this README's task was explicitly forbidden to change.
> They are recorded as deferrals; this table is generated from the source header, not from `--help`.

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
pass=33 fail=0  (all cases SIMULATED — no live product transport)
```

**Case 0 is the harness's own falsifiability proof:** it points the suite at an *absent* dispatcher
and asserts that the suite fails. A harness that stays green with the thing under test removed is not
evidence. The remaining cases cover exact-task routing against decoy state files, identity-mismatch
rejection, path traversal, missing and malformed state, `turn: operator` as terminal, no-op actors,
actor failure and timeout, the hop limit, foreign staged state, out-of-allowlist writes and Codex
moving `HEAD`, an unattended simulated round trip, the lock, and the uncommitted-handback seam.

---

## Safety boundaries

- **One task, one checkout, serial.** Not multi-loop. Same-checkout concurrency is unsafe — see
  `docs/parallel-sessions-playbook.md` § 4.
- **The dispatcher never writes the state file.** Only the actors do. It reads, hashes and compares.
- **A lock** keyed on `checkout|task` (a directory under `TMPDIR`) refuses a second dispatcher on the
  same pair.
- **An allowlist** bounds which repo-relative paths an actor may change; anything else stops the run.
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
- **Concurrency safety.** The lock is exercised for one checkout + task pair. Nothing here tests
  parallel checkouts or parallel tasks.
- **Repeat reliability.** One successful run is one observation. The run log records that run and
  nothing about the distribution of outcomes across runs.
- **Unattended handling of operator decisions.** Reaching `turn: operator` is where the automation
  *stops*. What happens to the decision after that is outside the dispatcher entirely.
- **Anything about the quality of the work the models did.** The dispatcher checks that the file
  moved in an allowed direction and that no unexpected repository effect occurred. It does not read
  the content.

Where this README describes behaviour that was reproduced (exit statuses, the test summary), it says
so. Anything beyond the list of recorded fields above is inference, not evidence.
