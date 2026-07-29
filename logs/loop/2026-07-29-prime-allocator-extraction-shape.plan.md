UNIT: 2026-07-29-prime-allocator-extraction-shape    STREAM: 2026-07-29-prime-allocator-extraction    PHASE: shape
REPO: ai-resources                                    BASE: 6a2cd0b119c9370c31363700f0ec9077dcb5e226    NEXT: Codex — review this plan

PLAN

## Objective, stated at the size it can actually reach

Give the session-marker allocator **one executable owner** and remove the runtime rationale that
`/prime` currently restates. Behaviour-preserving: no change to marker format, allocation
semantics, session artifacts, task routing or auto mode.

**Honest arithmetic, so this is not over-claimed.** `prime.md` is 830 lines. The allocator is the
fenced block at lines 370–509 — 138 content lines (49 executable, 88 comment-only, 1 blank).
Removing it and inserting a call block of roughly 18 lines is a net reduction of about **120
lines, ~14% of the file**. It does **not** touch auto mode (`8c`, lines 595–830, 236 lines), the
task menu, mission binding, or Steps 0–6. Any claim that this "leans `/prime`" beyond the
allocator boundary is false and the plan does not make one.

## The two design decisions, and the evidence behind each

### D1 — Resolution model is **cwd-relative**, never `$0`-relative. Load-bearing.

`logs/friction-log.md` (2026-07-19, S3-30d, severity **high**) records this failure directly:
three shared scripts share a walk-up *calling convention* but not a *resolution model*. Two
resolve from `cwd`; `check-archive.sh` resolves from `$0`
(`PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"`). Invoked through the documented walk-up, it
archived **ai-resources' own `logs/decisions.md`** — a shared canonical log with another session's
uncommitted work in the tree — while the project's actual log was never checked. It failed
silently: had the file been under threshold, the run would have produced no output at all.

For the allocator the same mistake is worse. A `$0`-resolving allocator invoked from
`projects/axcion-website/` would write `ai-resources/logs/.session-marker`, scope its claim
namespace to ai-resources, and hand the project a marker from the wrong namespace — defeating the
one invariant the whole mechanism exists to protect. So:

- The script resolves **every** path from `cwd`: `logs/.session-marker`,
  `logs/session-notes.md`, `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, and
  `git rev-parse` calls. This is what the embedded block already does, so extraction preserves it
  by default — the requirement is that Build introduces **no** `$0`/`BASH_SOURCE` path derivation.
- The script prints its resolved working directory to **stderr** on every run — the diagnostic the
  friction entry prescribes, so a wrong-target invocation is visible even when it writes nothing
  unusual.
- A regression test asserting the cwd model ships **in the same slice** that creates the script
  (see Slice 1, test T-CWD).

### D2 — The walk-up resolves the **canonical copy only**, deliberately diverging from `run-manifest.sh`.

`run-manifest.sh`'s walk-up (mirrored at `prime.md:787-793`) tries, at each ancestor level,
`$d/ai-resources/logs/scripts/X` then `$d/logs/scripts/X`. Because the project-level `$d/logs/scripts/X`
is tested **before** the walk reaches the workspace root, a project-local copy shadows canonical.

That is not hypothetical here. Verified this unit: **26 projects already carry their own
`logs/scripts/` holding real copies** (not symlinks) of `check-archive.sh` and `split-log.sh` —
e.g. `projects/axcion-website/logs/scripts/{check-archive.sh,split-log.sh}`, both regular files.
`logs/decisions-archive-2026-06.md:594` records eleven project-local `split-log.sh` copies being
overwritten with a fixed canonical. Project-local script copies are an established habit in this
repo, so a shadowing path will eventually be taken.

For `run-manifest.sh` a local copy is harmless — it writes a per-session JSON into the local repo.
For the allocator a second implementation **is** a second allocator arbitrating one cross-checkout
namespace, which is precisely the collision class the atomic claim exists to prevent. Different
consequence, therefore a different rule:

```
walk up from cwd, testing ONLY "$d/ai-resources/logs/scripts/allocate-session-marker.sh"
```

A project-local copy then cannot shadow canonical. If the walk-up finds nothing, the script is
**not** silently skipped — `/prime` stops and says so, because an un-allocated marker breaks
`/session-start` Step 3 and `/session-plan` Step 0, which both require this session's
marker-bearing header. (This is the opposite of `run-manifest.sh`'s "skip silently" posture, which
is correct there because nothing reads the manifest yet — `principles.md § OP-5`.)

## Ownership path and call path

**Owner:** `ai-resources/logs/scripts/allocate-session-marker.sh` — the single executable
implementation. Placement is a sibling inside an established directory (30 scripts already live
there, including the `run-manifest.sh` precedent), so `/placement` does not fire.

**Contract owner remains `docs/session-marker.md`** — verified this unit: § Marker allocation
(lines 65–137) states the four-source rule (a)–(d) as a table, plus § Why (c) exists, § Why (d)
exists and § Known gap (line 103). The script implements that contract and does not redefine it,
exactly as `run-manifest.sh` states for `docs/spine-schemas.md`.

**Caller stays `/prime`,** unchanged in its responsibilities. `8k` keeps its prose and its
caller-contract paragraph; only the fenced implementation is replaced by a call.

**Script I/O contract:**

| Channel | Content |
|---|---|
| stdout | exactly one line: `${TODAY} ${MARKER}` — byte-identical to what it writes into `logs/.session-marker` |
| stderr | one diagnostic line naming the resolved working directory (D1) |
| files written | `logs/.session-marker` and `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` — same paths, same format, same conditions as today |
| exit | 0 on success; non-zero only if it cannot determine a marker |

Printing to stdout is **not** a semantic change: it surfaces a value the caller already needs.
Today the block writes files and emits nothing, so `/prime` must re-read the file to learn
`${MARKER}` — and the existing test has to append `echo "MARKER=$MARKER"` to observe it at all.
The single stdout line makes the value returnable; the diagnostic goes to stderr so stdout stays
a deterministic one-line parse.

## Build slices

Two vertical slices. Each is one commit, revert-reversible, and leaves the tree in a working state
with tests connected to running code.

### Slice 1 — Move the implementation (mechanical, atomic)

**Nothing may be split out of this slice.** Creating the script without repointing `/prime` leaves
two implementations; repointing `/prime` without repointing the test leaves the suite scraping
removed text. Both are named falsification conditions, so all three land together.

Files touched — exactly three:

1. **`logs/scripts/allocate-session-marker.sh`** *(new)* — shebang `#!/usr/bin/env bash`; the
   allocator transplanted **verbatim**, every one of the 88 comment lines preserved in place
   beside the code it guards; a header naming `docs/session-marker.md` as contract authority and
   stating the cwd resolution model (D1) as a rule, not a description; the stderr diagnostic; the
   single stdout line. No logic edit of any kind in this slice.
2. **`.claude/commands/prime.md`** — `8k`'s fenced block (lines 370–509) replaced by a call block
   of roughly 18 lines: canonical-only walk-up (D2), invoke, capture the stdout line into
   `${TODAY}` / `${MARKER}`, hard-stop with a named message if resolution fails. `8k`'s heading,
   its caller-contract paragraph and the closing "same-day re-invocations increment" line are
   retained unchanged. `8a`, `8b`, `8c` are **not** edited — they already say "Run the Step 8k
   marker-allocation sub-step", which stays true.
3. **`logs/scripts/prime-allocator.test.sh`** — `ALLOC_SRC` repointed from `.claude/commands/prime.md`
   to the new script; the awk extractor and its nine-space dedent deleted; every test now invokes
   the **real shipped script** under zsh from each fixture cwd. All 19 existing assertions keep
   their current expected values. The suite's own header rule — "the thing under test is the thing
   that runs. Do not reintroduce a copy" — is better satisfied after this change than before, and
   the header is updated to say so.

   **Plus T-CWD (new, required in this slice):** invoke the script by absolute path from a fixture
   directory that is not its own location, and assert (a) `logs/.session-marker` is created **in
   the fixture**, and (b) no marker file is created next to the script. This is the D1 guard; the
   hazard becomes live the moment the script exists, so the guard ships with it.

Evidence for Slice 1: full suite run (must be **20/0** — the 19 existing assertions plus T-CWD);
a differential run (below) showing identical markers pre- and post-change; `git diff --stat`
showing exactly three files.

### Slice 2 — Compress duplicated rationale (editorial, deferrable)

Touches **only** `logs/scripts/allocate-session-marker.sh`. No behaviour change, no other file.

- **Retained verbatim, beside the code:** every line-local anti-regression warning — the
  fail-safe invariant on `HIGH` seeding; the suffix-tolerant `case` parse warning; "`find`, NOT a
  glob" (the zsh NOMATCH lesson); `--path-format=absolute` is REQUIRED; the namespace-scoping
  rationale; the `rm -rf` containment note; "Do not re-add a date-based prune". These guard
  specific lines and a warning separated from its line has already failed.
- **Compressed to a pointer:** the multi-paragraph incident history (2026-07-13 S6 and S11, the
  four collisions, the worktree explanation, the accepted known gap) — already owned by
  `docs/session-marker.md` § Why (c) exists / § Why (d) exists / § Known gap. Replaced by a
  one-line citation to those sections.

Evidence for Slice 2: suite re-run 20/0; a warning-inventory diff proving every warning present
before the slice is present after it (Prove check P3 below).

**Slice 2 may be dropped without harming Slice 1.** If G2 or review judges the compression
unsafe, Slice 1 stands alone and still satisfies the objective — the rationale has already left
`/prime`, which is what the brief asked for.

## Rollback

Each slice is a single commit reverted with `git revert <sha>`; no manual reconstruction.

**Rollback touches no marker state, by construction.** Both slices change only code location and
comments — neither writes, moves, deletes or reformats `logs/.session-marker`, the per-id marker,
or any claim directory. Reverting Slice 1 restores the embedded block, and any marker allocated by
the script remains valid input to it, because the file path, the file format and the four-source
algorithm are identical. A mid-day revert is therefore safe with sessions already numbered.

Verification that this holds is an explicit Prove check (P6), not an assumption.

## Prove checks — one per falsification criterion

Prove judges against these, not against whether the work looks reasonable.

| # | Falsification criterion | Check |
|---|---|---|
| **P1** | *permits multiple canonical allocator implementations* | `grep -rlE 'Allocate N = 1\|axcion-session-markers' --include='*.sh' --include='*.md'` across the **workspace** (not just this repo) returns exactly one executable — the canonical script — and zero fenced allocators in any `prime.md`. Separately assert no `allocate-session-marker.sh` exists under any `projects/*/logs/scripts/`. Positive control: the same grep must return the canonical script (a silent empty result is not a pass). |
| **P2** | *temporarily disconnects tests from running code* | At **every** Build commit, `bash logs/scripts/prime-allocator.test.sh` runs green, and `ALLOC_SRC` resolves to a path that exists. Assert the suite invokes the shipped script — not a copy, not an extract — by checking no awk-extraction remains. |
| **P3** | *drops guarded invariants* | Extract the warning set from the pre-change block (`git show 6a2cd0b:.claude/commands/prime.md`, lines 370–509) as the set of comment lines containing an imperative guard (`Do NOT`, `never`, `REQUIRED`, `LOAD-BEARING`, `MUST`). Assert each appears in the post-change script, and that each sits adjacent to the code it guards rather than collected in a preamble. |
| **P4** | *changes observable allocation* | Differential harness: run the pre-change implementation (extracted from `6a2cd0b`) and the post-change script against **identical fixtures**, across all 8 scenarios the suite already models (first-run-of-day, in-flight claim, worktree visibility, no-git fail-safe, concurrent mutex, stale-claim prune, namespace scoping, suffix uniqueness + degrade-safe). Assert identical `MARKER` strings and identical `logs/.session-marker` contents in every scenario. |
| **P5** | *changes marker format or session artifacts* | Assert both marker files match `^[0-9]{4}-[0-9]{2}-[0-9]{2} S[0-9]+(-[A-Za-z0-9]{1,3})?$`; assert the set of files written is exactly the two marker paths and nothing else (`find` the fixture before/after and diff the file list). Assert `session-notes.md` is untouched by the script — header writing stays the caller's job per `8k`'s caller contract. |
| **P6** | *cannot be reversed without altering marker state* | In a fixture: allocate with the post-change script, `git revert` Slice 1, allocate again with the restored embedded block, and assert the second allocation reads the first's marker correctly and increments from it. Assert no marker file was rewritten by the revert itself. |
| **P7** | *claims to lean more of /prime than the 138-line boundary can reach* | `wc -l .claude/commands/prime.md` before and after: the delta must be within the −120 ± 10 range this plan states. Assert lines 595–830 (auto mode) are byte-identical to `6a2cd0b`. Any evidence or `CLOSE` text claiming a larger reduction fails this check. |
| **P8** | *the D1 hazard* | T-CWD from Slice 1 re-run, plus: invoke the script from three different project fixtures and assert each writes into its own fixture, never into the script's own directory or into `ai-resources/logs/`. |

## What this plan does not do

- Does not touch auto mode (`8c`). The `/session-start` Step 2.4 / 2.5 / 3.5 duplication is real
  and confirmed, and stays **deferred** — it reopens only on an explicit brief for auto mode, or
  on a defect caused by `8c.7.5` and `/session-start` Step 3.5 drifting apart.
- Does not change the marker **format**, so the read path (`docs/session-marker.md` § Marker
  resolution) and its consumers are untouched and were deliberately not surveyed.
- Does not address the accepted known gap at `prime.md:398-403` (a worktree on a branch predating
  the current allocator). That checkout would carry a stale `prime.md` with the old embedded block
  and would never call the script, so its behaviour is unchanged — no regression, no fix. Verified
  this unit: no such worktree exists today; `git worktree list` was **not** run, so this is stated
  as design reasoning, not as an observation.
- Does not create any project-local copy of the script, and D2 makes one unable to shadow
  canonical if someone creates it anyway.
- Does not modify `docs/session-marker.md`. It already owns the contract correctly.

## Residual risks, named

1. **The stdout contract is new surface.** If `/prime`'s call block mis-parses the line, the
   session gets no marker and stops loudly (by design) rather than allocating wrongly. Loud
   failure is the intended posture; it is still a new way for `/prime` to stop, and G1 should
   accept that trade explicitly.
2. **`8a`/`8b`/`8c` are not re-tested end-to-end.** They call `8k` by reference and are unedited,
   so the change is invisible to them — but no automated test exercises a full `/prime` dispatch,
   and this plan does not add one. That gap predates this work and is not closed by it.
3. **Slice 2 is a judgement call about which comments are "history" and which are "guards".**
   P3 makes the guard set explicit and checkable, but the boundary is still drawn by hand.
