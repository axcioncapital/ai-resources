# Live `--carry-one` transport — measured 2026-08-06

**What this records:** one real Claude hop carried by `dispatch.sh --carry-one`, end to end, with
live products. Not simulated. The controller suite (`dispatch.test.sh`, 99 assertions) proves
controller logic only and explicitly cannot prove this.

**What it does not establish:** repeat reliability (this is one observation), a Codex hop under
`--carry-one` (only the Claude direction was exercised), and anything about Computer Use — no
courier drove this run. The operator launched it from a shell. The courier's own proof is separate
and still owed.

## Isolation

The run used a **linked worktree**, not the main checkout:

```
git worktree add -b spike/carry-one-proof <scratchpad>/carry-proof-wt HEAD
```

Reason: a live carry in `ai-resources` itself would add a file to `logs/work-loop/`, and the `3.1a`
closed-set assertion reddens on exactly that (`logs/improvement-log.md`, promoted item
`6c396d56cbb8`). Isolating the proof kept a known-fragile assertion out of it. The worktree and its
branch were removed after the evidence was captured, so nothing from this run survives in the
repository except this record.

## Setup

Task file `logs/work-loop/carry-one-live-proof.md`, committed in the worktree before the run:
a **discovery unit** with two checkable claims about `dispatch.sh` itself, `turn: claude`, and a
completion condition of *record the findings, set `turn: codex`, commit, stop*.

Command:

```
dispatch.sh --checkout <worktree> --task carry-one-live-proof --carry-one \
  --timeout 600 --log-dir <scratchpad>/runs \
  --allow-path '^logs/work-loop/' \
  --allow-path '^plans/work-loop-v2-v0\.2/handoff-automation-spike/' \
  --allow-path '^logs/friction-log\.md$'
```

All three `--allow-path` values were required: supplying any one replaces both defaults, and the
`PostToolUse` hook keeps `logs/friction-log.md` modified.

## Measured

| Field | Value |
|---|---|
| `run` | `20260806T221734-carry-one-live-proof` |
| `mode` | `live` |
| Claude binary | `/Users/patrik.lindeberg/.local/bin/claude` — `2.1.220 (Claude Code)` |
| Launch | `claude -p '/work-loop-v2 carry-one-live-proof' --output-format json` (cwd = worktree) |
| Actor exit | `0`, duration `66s` |
| State `sha256` | `bd116cff…` → `c7bc35ef…` |
| `turn:` | `claude` → `codex` |
| `HEAD` | `6bd9bf8b…` → `95b19c36…` |
| Transition verdict | `claude -> codex (allowed)` |
| Dispatcher exit | **`0`** |

The dispatcher's closing lines named both turns and pointed the reader at the state file rather than
at the exit code:

```
carry-one: the turn moved claude -> codex. One hop carried; not continuing to 'codex'.
carry-one: read turn: from <path>. Neither this exit code nor any screen is
authoritative over the file (core § 4).
```

## What Claude actually did

The run is only evidence of transport if the hop did real work. It did:

- Both claims were checked **by inspection**, and the record cites line numbers
  (`--carry-one` parse branch at `:118`; `CARRY_ONE` terminal block at `:629`, after the transition
  table at `:611–616`).
- The record carries a falsifiability clause of its own — it states what would have made each claim
  read `FALSE`, which core § 6 rule 5 requires and which a turn-flip alone would not produce.
- It stayed a discovery unit: nothing was implemented, and `git show --stat` confirms the commit
  touched **one** file, the state file.
- Claude made the commit (`95b19c3`), as core § 4 requires. Codex never ran git.

Claude's own commit subject:
`update: carry-one-live-proof — discovery unit inspected, both claims hold, turn to codex`

## The claim this settles

`--carry-one` carries one real hop between live products and exits `0` on it. Before this change the
same single hop ended at `23 HOP_LIMIT` — a failure code for the expected outcome, which is what
made the mode necessary. `dispatch.test.sh` case 23 asserts that differential in simulation; this
run is the live half.

## Related live evidence in this directory

- `20260805T152939-*`, `20260805T154555-*` — loop-mode live transport, 4 and 3 hops.
- `live-permission-denial-2026-08-05.md` — how a refused permission actually surfaces (`22` / `25`).
- `parallel-worktree-proof-2026-08-05.md` — two dispatchers, two linked worktrees.
