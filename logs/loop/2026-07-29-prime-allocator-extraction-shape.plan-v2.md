UNIT: 2026-07-29-prime-allocator-extraction-shape    STREAM: 2026-07-29-prime-allocator-extraction
PHASE: shape    REPO: ai-resources
BASE: 6a2cd0b119c9370c31363700f0ec9077dcb5e226    NEXT: operator — G1

PLAN (v2 — supersedes plan.md at e57e72d; v1 retained immutable)

## What changed from v1, and why

Four corrections, all from Codex `review-1` (`{unit}.review-1.md`, c9a2b1d). Each was tested
before acceptance, not taken on the reviewer's word.

| # | Change | Trigger |
|---|---|---|
| **C1** | Runtime of record is **zsh**, end to end, and self-enforced by the script | F1 |
| **C2** | P3's keyword heuristic replaced by a **16-guard anchored inventory** with a positive control | F2 |
| **C3** | New **caller-seam** contract and check (P9) — the parser must reject malformed output before any header write | F3 |
| **C4** | Stale-worktree paragraph reworded; the check was actually run | F4 |

## Objective, stated at the size it can actually reach

Give the session-marker allocator **one executable owner** and remove the runtime rationale that
`/prime` restates. Behaviour-preserving: no change to marker format, allocation semantics,
session artifacts, task routing or auto mode.

**Honest arithmetic.** `prime.md` is 830 lines. The allocator is the fenced block at lines
370–509 — 138 content lines (49 executable, 88 comment-only, 1 blank). Removing it and inserting
a call block of roughly 20 lines is a net reduction of about **118 lines, ~14% of the file**. It
does **not** touch auto mode (`8c`, lines 595–830, 236 lines), the task menu, mission binding, or
Steps 0–6. The plan makes no larger claim, and P7 enforces that.

## Design decisions

### D1 — Resolution model is **cwd-relative**, never `$0`-relative. Load-bearing.

`logs/friction-log.md` (2026-07-19, S3-30d, severity **high**): three shared scripts share a
walk-up *calling convention* but not a *resolution model*. `check-archive.sh` resolves from `$0`
(`PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"`); invoked through the documented walk-up it
archived **ai-resources' own `logs/decisions.md`** — a shared canonical log with another session's
uncommitted work in the tree — while the project's real log went unchecked. It would have failed
**silently** had the file been under threshold.

For an allocator the same mistake writes markers into the wrong namespace, defeating the one
invariant the mechanism exists to protect. Therefore:

- Every path resolves from **cwd**: `logs/.session-marker`, `logs/session-notes.md`,
  `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, and all `git rev-parse` calls. The embedded
  block already does this, so extraction preserves it — the requirement is that Build introduces
  **no** `$0` / `BASH_SOURCE` / `${0:A}` path derivation.
- The script prints its resolved working directory to **stderr** on every run, the diagnostic the
  friction entry prescribes, so a wrong-target invocation is visible even when nothing looks odd.
- T-CWD ships in the same slice that creates the script.

### D2 — The walk-up resolves the **canonical copy only**, diverging from `run-manifest.sh`.

`run-manifest.sh`'s walk-up (mirrored at `prime.md:787-793`) tries `$d/ai-resources/logs/scripts/X`
then `$d/logs/scripts/X` at each ancestor level. The project-level path is tested **before** the
walk reaches the workspace root, so a project-local copy shadows canonical.

Verified this unit: **26 projects already carry their own `logs/scripts/`** holding **real files**
(not symlinks) — `check-archive.sh`, `split-log.sh`, in places `log-archiver.sh`.
`logs/decisions-archive-2026-06.md:594` records eleven project-local `split-log.sh` copies being
overwritten with a fixed canonical. Local copies are an established habit here.

A local `run-manifest.sh` would be harmless — it writes a per-session JSON locally. A local
allocator **is a second allocator on one cross-checkout namespace**, which is the collision class
the atomic claim exists to prevent. Different consequence, different rule:

```
walk up from cwd, testing ONLY "$d/ai-resources/logs/scripts/allocate-session-marker.zsh"
```

If the walk-up finds nothing the script is **not** silently skipped — `/prime` stops and says so,
because an unallocated marker breaks `/session-start` Step 3 and `/session-plan` Step 0, which
both require this session's marker-bearing header. This is deliberately the opposite of
`run-manifest.sh`'s skip-silently posture, which is right there because nothing reads the manifest
yet (`principles.md § OP-5`).

### D3 — Runtime of record is **zsh**, end to end, and the script enforces it. *(new in v2 — F1)*

Measured this unit inside the harness that actually runs `/prime`:

```
$0=/bin/zsh   ZSH_VERSION=5.9   BASH_VERSION=unset   ps -p $$ -o comm= → /bin/zsh
```

So the allocator **today executes under zsh**, inline in the Bash tool's shell. v1 gave the new
script `#!/usr/bin/env bash`. That would have made the caller run bash while
`prime-allocator.test.sh` kept running zsh — the caller and the suite on different interpreters,
which is the exact inversion of the harness's founding lesson (*"a bash-only test PASSES while the
real shell CRASHES"*, `prime-allocator.test.sh:3-6`). It would also have made "verbatim,
behaviour-preserving" false: identical text, different interpreter.

Decision: **zsh is the runtime of record.**

- Script is `allocate-session-marker.zsh` with `#!/usr/bin/env zsh`.
- `/prime` invokes it as `zsh "$ALLOC"` — explicit, not shebang-dependent.
- `prime-allocator.test.sh` continues to invoke every allocator run under zsh, unchanged in that
  respect.
- **Self-enforcing:** the script's first executable statement asserts `[ -n "$ZSH_VERSION" ]` and
  exits non-zero with a named message otherwise. Without this, a future edit copying the
  `bash "$RM"` idiom from `run-manifest.sh` would silently switch runtimes — convention alone is
  what D1's source incident proves insufficient.

*Note, stated plainly:* this is the **second** deliberate divergence from the `run-manifest.sh`
precedent (D2 is the first). Two divergences from one precedent is a smell worth naming rather
than burying. Both are justified by the same underlying asymmetry — that script writes local
per-session JSON, this one arbitrates a shared cross-checkout namespace — but if the operator
prefers consistency over either divergence, that is a legitimate G1 call.

*Recorded honestly:* the specific historical NOMATCH crash no longer reproduces, because the code
already uses `find` rather than a glob. Tested this unit — the current construct survives under
both zsh and bash. So D3 is **not** motivated by a live bug; it is motivated by keeping caller,
suite and today's behaviour on one interpreter so that "behaviour-preserving" is true by
construction rather than by luck.

## Ownership path and call path

**Owner:** `ai-resources/logs/scripts/allocate-session-marker.zsh` — the single executable
implementation. A sibling in an established directory (30 scripts, including the `run-manifest.sh`
precedent), so `/placement` does not fire.

**Contract owner remains `docs/session-marker.md`** — verified: § Marker allocation (lines 65–137)
states the four-source rule (a)–(d) as a table, plus § Why (c) exists, § Why (d) exists, § Known
gap (line 103). The script implements that contract and does not redefine it, exactly as
`run-manifest.sh` states for `docs/spine-schemas.md`.

**Caller stays `/prime`.** `8k` keeps its heading, its caller-contract paragraph and its closing
"same-day re-invocations increment" line; only the fenced implementation becomes a call.

### Script I/O contract

| Channel | Content |
|---|---|
| runtime | **zsh** — asserted by the script itself; non-zero exit under any other shell (D3) |
| stdout | **exactly one line**, `${TODAY} ${MARKER}` — byte-identical to what it writes into `logs/.session-marker` |
| stderr | one diagnostic line naming the resolved working directory (D1) |
| files written | `logs/.session-marker` and `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` — same paths, same format, same conditions as today |
| exit | `0` on success; non-zero, with no marker file written, if it cannot determine a marker |

Printing to stdout is not a semantic change: it surfaces a value the caller already needs. Today
the block writes files and emits nothing, so `/prime` must re-read the file to learn `${MARKER}` —
which, as `review-1` F3 observes, is the *less* safe option, because a concurrent `/prime` may
replace the shared file between write and read. The per-run stdout line is not subject to that
race.

### Caller-seam contract *(new in v2 — F3)*

`/prime`'s call block must treat the script's stdout as untrusted input. Before **any** use of
`${MARKER}` — and specifically before the `grep -Fxq` header-existence check and the
`session-notes.md` header append — it must:

1. Capture stdout and exit status separately.
2. **Reject** and stop loudly, writing nothing, on any of: non-zero exit · zero lines of stdout ·
   more than one line · a line not matching `^[0-9]{4}-[0-9]{2}-[0-9]{2} S[0-9]+(-[A-Za-z0-9]{1,3})?$`.
3. **Cross-check against the script's own written oracle:** the captured line must equal the
   contents of `logs/.session-marker`. A disagreement means something wrote between the two, and
   is a stop, not a tiebreak.
4. On any rejection emit a named message identifying the failure class, and **do not** create a
   header, a mandate, or `logs/.prime-mtime`.

A failed allocation must leave the session with **no** marker-bearing header rather than a wrong
one — a missing header is loudly diagnosable by `/session-start` Step 3; a wrong one is not.

## Build slices

Two vertical slices. Each is one commit, revert-reversible, leaving tests connected to running
code.

### Slice 1 — Move the implementation (mechanical, atomic)

**Nothing may be split out.** Creating the script without repointing `/prime` leaves two
implementations; repointing `/prime` without repointing the test leaves the suite scraping removed
text. Both are named falsification conditions.

Files touched — exactly three:

1. **`logs/scripts/allocate-session-marker.zsh`** *(new)* — `#!/usr/bin/env zsh`; the zsh runtime
   assertion (D3); a header naming `docs/session-marker.md` as contract authority and stating the
   cwd resolution model (D1) as a rule; the allocator transplanted **verbatim**, all 88 comment
   lines preserved beside the code they guard; the stderr diagnostic; the single stdout line. No
   logic edit in this slice.
2. **`.claude/commands/prime.md`** — `8k`'s fenced block replaced by a call block of roughly 20
   lines implementing the canonical-only walk-up (D2), the `zsh` invocation (D3) and the full
   caller-seam contract above. `8a`, `8b`, `8c` are **not** edited — they already say "Run the
   Step 8k marker-allocation sub-step", which stays true.
3. **`logs/scripts/prime-allocator.test.sh`** — `ALLOC_SRC` repointed to the script; the awk
   extractor and its nine-space dedent deleted; every test invokes the **real shipped script**
   under zsh from each fixture cwd. All 19 existing assertions keep their current expected values.

   Plus two new tests, both required in this slice:
   - **T-CWD** — invoke the script by absolute path from a fixture that is not its own directory;
     assert `logs/.session-marker` is created **in the fixture** and that no marker file appears
     beside the script. (D1 guard; the hazard is live the moment the script exists.)
   - **T-SEAM** — exercise the caller-seam contract against stubbed script outputs: valid line
     accepted; and each of empty output, two lines, a malformed line, and a line disagreeing with
     `logs/.session-marker` rejected with **no header written**. (F3.)

Evidence: full suite green at **21/0** (19 + T-CWD + T-SEAM); differential run (P4) identical;
`git diff --stat` showing exactly three files.

### Slice 2 — Compress duplicated rationale (editorial, deferrable)

Touches **only** `logs/scripts/allocate-session-marker.zsh`. No behaviour change.

- **Retained verbatim, beside their code:** all 16 guards in the inventory below.
- **Compressed to a pointer:** the multi-paragraph incident history (2026-07-13 S6 and S11, the
  four collisions, the worktree explanation) — already owned by `docs/session-marker.md`
  § Why (c) exists / § Why (d) exists / § Known gap — replaced by a one-line citation.

Evidence: suite re-run 21/0; P3 guard inventory passes with its positive control.

**Slice 2 is droppable.** If review or G2 judges the compression unsafe, Slice 1 stands alone and
still meets the objective — the rationale has already left `/prime`.

## The guard inventory *(new in v2 — replaces v1's keyword heuristic, F2)*

v1's P3 matched comment lines containing `Do NOT|never|REQUIRED|LOAD-BEARING|MUST`. Tested this
unit against the baseline (`6a2cd0b:.claude/commands/prime.md`, lines 370–509): the filter catches
**9 of 88** comment lines and misses **5 of the 6** guards `review-1` named. The finding is
correct — a guard could vanish and v1's P3 would still pass.

Replaced by this explicit inventory, derived from the baseline and verified present there (each
anchor returned ≥1 hit when checked this unit). Anchors are **text**, not line numbers, per this
repo's own recorded lesson that a line number in a live document is a citation with a short shelf
life (`logs/decisions.md:218`).

| # | Guard | Anchor text |
|---|---|---|
| G1 | HIGH seeded from the marker file before any scan; scans only raise it | `FAIL-SAFE INVARIANT` |
| G2 | Source (a) must be read first | `Must stay first` |
| G3 | Suffix-tolerant marker parse; never `##*S` | `MOST DANGEROUS LINE` |
| G4 | `mkdir` claim is a genuine mutex, not advisory | `CLAIMING IS ATOMIC` |
| G5 | Do not make worktrees pre-reserve markers | `reserve markers up front` |
| G6 | Stale-copy gap is accepted, not fixed here | `KNOWN GAP, ACCEPTED` |
| G7 | Empty CLAIMS degrades safely to (a)–(c) | `Empty CLAIMS` |
| G8 | `--path-format=absolute` is required | ``path-format=absolute` is REQUIRED`` |
| G9 | Claim namespace scoped by in-repo prefix | `SCOPE the namespace` |
| G10 | `find`, not a glob (zsh NOMATCH) | `NOT a glob` |
| G11 | Prune cannot escape the claims dir | `never follows symlinks here` |
| G12 | Session-id suffix is what makes collisions impossible | `SESSION-ID SUFFIX` |
| G13 | No session id degrades to legacy bare `S{N}` | `Degrades safe` |
| G14 | Runaway guard at N>999 | `runaway guard` |
| G15 | Per-id identity oracle is unclobberable | `Identity oracle` |
| G16 | Date-based orphan prune must not return | `Do not re-add a date-based prune` |

## Rollback

Each slice reverts with `git revert <sha>`; no manual reconstruction.

**Rollback touches no marker state, by construction.** Both slices change only code location,
runtime declaration and comments — neither writes, moves, deletes nor reformats
`logs/.session-marker`, the per-id marker, or any claim directory. Reverting Slice 1 restores the
embedded block, and any marker the script allocated remains valid input to it: same path, same
format, same algorithm. A mid-day revert is safe with sessions already numbered. P6 verifies this
rather than assuming it.

## Prove checks — one per falsification criterion

| # | Criterion | Check |
|---|---|---|
| **P1** | *permits multiple canonical allocator implementations* | `grep -rlE 'Allocate N = 1\|axcion-session-markers'` across the **workspace** returns exactly one executable — the canonical script — and zero fenced allocators in any `prime.md`. Separately assert no `allocate-session-marker.*` under any `projects/*/logs/scripts/`. Positive control: the same grep must return the canonical script; a silent empty result is not a pass. |
| **P2** | *temporarily disconnects tests from running code* | At **every** Build commit the suite runs green and `ALLOC_SRC` resolves to an existing path. Assert no awk-extraction remains — the suite must invoke the shipped script. |
| **P3** | *drops guarded invariants* | Assert all **16** inventory anchors appear in the post-change script, each adjacent to the code it guards rather than collected in a preamble. **Positive control:** delete one guard in a scratch copy and show the check fails; a check that passes on a mutilated input proves nothing. |
| **P4** | *changes observable allocation* | Differential harness: pre-change implementation (extracted from `6a2cd0b`) vs post-change script, **both under zsh**, against identical fixtures across all 8 scenarios the suite models. Assert identical `MARKER` strings and identical `logs/.session-marker` contents in every scenario. |
| **P5** | *changes marker format or session artifacts* | Both marker files match `^[0-9]{4}-[0-9]{2}-[0-9]{2} S[0-9]+(-[A-Za-z0-9]{1,3})?$`. The set of files written is exactly the two marker paths — `find` the fixture before and after and diff the file list. `session-notes.md` is untouched by the script; header writing stays the caller's job per `8k`'s caller contract. |
| **P6** | *cannot be reversed without altering marker state* | In a fixture: allocate with the script, `git revert` Slice 1, allocate again with the restored embedded block, assert the second reads the first's marker and increments from it. Assert the revert itself rewrote no marker file. |
| **P7** | *claims to lean more of /prime than the 138-line boundary can reach* | `wc -l .claude/commands/prime.md` before and after: delta within **−118 ± 10**. Lines 595–830 (auto mode) byte-identical to `6a2cd0b`. Any evidence or `CLOSE` text claiming a larger reduction fails this check. |
| **P8** | *D1 — wrong-target resolution* | T-CWD re-run, plus invocation from three separate project fixtures; each must write into its own fixture, never beside the script and never into `ai-resources/logs/`. |
| **P9** | *F3 — the caller seam* | T-SEAM re-run against the **actual** `8k` call block, not a paraphrase: valid line accepted; empty / two-line / malformed / oracle-disagreeing outputs each rejected with a named message and **no header, no mandate, no `logs/.prime-mtime` written**. |
| **P10** | *D3 — runtime agreement* | Assert the script's shebang is zsh, that `8k` invokes it with `zsh`, that the suite invokes it with `zsh`, and that running it under `bash` exits non-zero on the runtime assertion rather than proceeding. |

## What this plan does not do

- Does not touch auto mode (`8c`). The `/session-start` Step 2.4 / 2.5 / 3.5 duplication is
  confirmed and stays **deferred** — reopening on an explicit auto-mode brief, or on a defect
  caused by `8c.7.5` and `/session-start` Step 3.5 drifting apart.
- Does not change the marker **format**, so the read path (`docs/session-marker.md` § Marker
  resolution) and its consumers are untouched and were deliberately not surveyed.
- Does not address the accepted known gap at `prime.md:398-403` — a worktree on a branch predating
  the current allocator would carry a stale `prime.md` with the old embedded block and never call
  the script, so its behaviour is unchanged: no regression, no fix. **`git worktree list` was run
  this unit and returned only the main worktree** (`/…/ai-resources`, `c9a2b1d [main]`); Codex ran
  it independently and observed the same. *(v1 called this "verified" while stating the check had
  not been run — a self-contradiction in an immutable artifact. Corrected per F4.)*
- Does not create any project-local copy of the script; D2 prevents one from shadowing canonical
  even if someone creates it.
- Does not modify `docs/session-marker.md`. It already owns the contract correctly.

## Residual risks, named

1. **Two divergences from one precedent.** D2 and D3 both depart from `run-manifest.sh`. Each is
   individually justified, but the shared-script family is now less uniform, and uniformity is
   itself a safety property — D1's source incident happened *because* three scripts looked alike
   and behaved differently. Mitigated by making both divergences self-enforcing (canonical-only
   resolution; runtime assertion) rather than documented-and-remembered. **This is a legitimate
   G1 decision point, not a settled matter.**
2. **`8a`/`8b`/`8c` are not exercised end-to-end.** They call `8k` by reference and are unedited,
   so the change is invisible to them — but no automated test drives a full `/prime` dispatch, and
   this plan does not add one. P9 covers the seam in isolation, not in a live dispatch. The gap
   predates this work and is not closed by it.
3. **Slice 2 draws the history/guard boundary by hand.** The 16-guard inventory makes the retained
   set explicit and checkable; what counts as compressible history is still a judgement.
4. **zsh becomes a hard dependency of allocation.** It is the Bash tool's shell and the macOS
   default, and the suite already requires it, so this is not new in practice — but it is newly
   explicit, and a non-zsh environment would now fail loudly instead of silently working.
