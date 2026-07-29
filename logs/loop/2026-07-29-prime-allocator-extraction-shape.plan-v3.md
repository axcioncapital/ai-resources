UNIT: 2026-07-29-prime-allocator-extraction-shape    STREAM: 2026-07-29-prime-allocator-extraction
PHASE: shape    REPO: ai-resources
BASE: 6a2cd0b119c9370c31363700f0ec9077dcb5e226    NEXT: operator — G1

PLAN (v3 — supersedes plan-v2.md at dcc876a; v1 at e57e72d and v2 both retained immutable)

## Revision history

| Version | Trigger | Change |
|---|---|---|
| v1 (`e57e72d`) | — | Initial plan |
| v2 (`dcc876a`) | `review-1` (`c9a2b1d`) | C1 zsh runtime · C2 guard inventory · C3 caller seam · C4 worktree wording |
| **v3 (this)** | `review-2` (R2-F1) | **C5 — the seam's oracle changes from the shared marker to the per-id identity oracle** |

**C5 in one sentence:** v2's seam cross-checked the script's stdout against
`logs/.session-marker`, which `docs/session-marker.md` designates clobber-vulnerable and "no
longer the identity oracle" — reintroducing the very read-after-write race that justified stdout
in the first place. v3 compares against `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` instead.

Everything else is unchanged from v2 and is restated here in full, because this file — not v2 —
is what Build follows.

## Objective, stated at the size it can actually reach

Give the session-marker allocator **one executable owner** and remove the runtime rationale that
`/prime` restates. Behaviour-preserving: no change to marker format, allocation semantics,
session artifacts, task routing or auto mode.

**Honest arithmetic.** `prime.md` is 830 lines. The allocator is the fenced block at lines
370–509 — 138 content lines (49 executable, 88 comment-only, 1 blank). Removing it and inserting
a call block of roughly 24 lines is a net reduction of about **114 lines, ~14% of the file**. It
does **not** touch auto mode (`8c`, lines 595–830, 236 lines), the task menu, mission binding, or
Steps 0–6. P7 enforces this.

*(The call block grew from ~20 to ~24 lines in v3: the seam now implements the doc's two-tier
oracle resolution rather than a single comparison.)*

## Design decisions

### D1 — Resolution model is **cwd-relative**, never `$0`-relative. Load-bearing.

`logs/friction-log.md` (2026-07-19, S3-30d, severity **high**): three shared scripts share a
walk-up *calling convention* but not a *resolution model*. `check-archive.sh` resolves from `$0`
(`PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"`); invoked through the documented walk-up it
archived **ai-resources' own `logs/decisions.md`** — a shared canonical log with another session's
uncommitted work in the tree — while the project's real log went unchecked. It would have failed
**silently** had the file been under threshold.

For an allocator the same mistake writes markers into the wrong namespace. Therefore:

- Every path resolves from **cwd**: `logs/.session-marker`, `logs/session-notes.md`,
  `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, and all `git rev-parse` calls. The embedded
  block already does this; the requirement is that Build introduces **no** `$0` / `BASH_SOURCE` /
  `${0:A}` path derivation.
- The script prints its resolved working directory to **stderr** on every run — the diagnostic the
  friction entry prescribes.
- T-CWD ships in the same slice that creates the script.

### D2 — The walk-up resolves the **canonical copy only**, diverging from `run-manifest.sh`.

`run-manifest.sh`'s walk-up (mirrored at `prime.md:787-793`) tries `$d/ai-resources/logs/scripts/X`
then `$d/logs/scripts/X` at each ancestor level, so a project-local copy shadows canonical.

Verified: **26 projects already carry their own `logs/scripts/`** holding **real files** (not
symlinks) — `check-archive.sh`, `split-log.sh`, sometimes `log-archiver.sh`.
`logs/decisions-archive-2026-06.md:594` records eleven project-local `split-log.sh` copies being
overwritten with a fixed canonical. Local copies are an established habit here.

A local `run-manifest.sh` is harmless — per-session JSON, written locally. A local allocator **is
a second allocator on one cross-checkout namespace**. Different consequence, different rule:

```
walk up from cwd, testing ONLY "$d/ai-resources/logs/scripts/allocate-session-marker.zsh"
```

If the walk-up finds nothing, `/prime` **stops and says so** rather than skipping silently,
because an unallocated marker breaks `/session-start` Step 3 and `/session-plan` Step 0. This is
deliberately the opposite of `run-manifest.sh`'s skip-silently posture, which is right there
because nothing reads the manifest yet (`principles.md § OP-5`).

### D3 — Runtime of record is **zsh**, end to end, self-enforced.

Measured inside the harness that actually runs `/prime`:

```
$0=/bin/zsh   ZSH_VERSION=5.9   BASH_VERSION=unset   ps -p $$ -o comm= → /bin/zsh
```

The allocator **today executes under zsh**, inline in the Bash tool's shell. v1's
`#!/usr/bin/env bash` would have run the caller under bash while `prime-allocator.test.sh` kept
running zsh — caller and suite on different interpreters, the exact inversion of the harness's
founding lesson (`prime-allocator.test.sh:3-6`), and it would have made "verbatim,
behaviour-preserving" false.

- Script is `allocate-session-marker.zsh` with `#!/usr/bin/env zsh`.
- `/prime` invokes `zsh "$ALLOC"` — explicit, not shebang-dependent.
- The suite continues to run every allocator execution under zsh.
- **Self-enforcing:** the script's first executable statement asserts `[ -n "$ZSH_VERSION" ]` and
  exits non-zero with a named message otherwise, so a future edit copying the `bash "$RM"` idiom
  cannot silently switch runtimes.

*Recorded honestly:* the historical NOMATCH crash no longer reproduces — the code uses `find`, not
a glob; tested, it survives under both shells. D3 is **not** fixing a live bug. It keeps caller,
suite and current behaviour on one interpreter so "behaviour-preserving" is true by construction.

*Named plainly:* this is the second deliberate divergence from `run-manifest.sh` (D2 is the
first). Both follow from the same asymmetry — that script writes local per-session JSON, this one
arbitrates a shared cross-checkout namespace — but two divergences from one precedent is a smell
worth surfacing, and preferring uniformity instead is a legitimate G1 call.

## Ownership path and call path

**Owner:** `ai-resources/logs/scripts/allocate-session-marker.zsh` — the single executable
implementation. A sibling in an established directory (30 scripts, including the `run-manifest.sh`
precedent), so `/placement` does not fire.

**Contract owner remains `docs/session-marker.md`** — § Marker allocation (lines 65–137) states
the four-source rule (a)–(d), plus § Why (c) exists, § Why (d) exists, § Known gap. The script
implements that contract and does not redefine it.

**Caller stays `/prime`.** `8k` keeps its heading, its caller-contract paragraph and its closing
"same-day re-invocations increment" line; only the fenced implementation becomes a call.

### Script I/O contract

| Channel | Content |
|---|---|
| runtime | **zsh** — asserted by the script; non-zero exit under any other shell (D3) |
| stdout | **exactly one line**, `${TODAY} ${MARKER}` — byte-identical to what it writes into both marker files |
| stderr | one diagnostic line naming the resolved working directory (D1) |
| files written | `logs/.session-marker` **and** `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` — written **together**, per § Both-or-neither writer invariant (BLOCKING). Same paths, same format, same conditions as today |
| exit | `0` on success; non-zero, with neither marker file written, if it cannot determine a marker |

Printing to stdout is not a semantic change: it surfaces a value the caller already needs. Today
the block writes files and emits nothing, so `/prime` must re-read a file to learn `${MARKER}` —
and that shared file is clobber-vulnerable, which is precisely why stdout is the safer channel.

### Caller-seam contract *(revised in v3 — C5 / R2-F1)*

`/prime`'s call block treats the script's stdout as untrusted input. Before **any** use of
`${MARKER}` — specifically before the `grep -Fxq` header-existence check and the
`session-notes.md` header append — it must:

1. Capture stdout and exit status separately.
2. **Reject and stop loudly, writing nothing**, on any of: non-zero exit · zero lines of stdout ·
   more than one line · a line not matching
   `^[0-9]{4}-[0-9]{2}-[0-9]{2} S[0-9]+(-[A-Za-z0-9]{1,3})?$`.
3. **Cross-check against the correct oracle**, mirroring `docs/session-marker.md` § Marker
   resolution rather than inventing a second read pattern:

   | Condition | Oracle | On disagreement |
   |---|---|---|
   | `CLAUDE_CODE_SESSION_ID` set, per-id file present | `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` — **un-clobberable** | **Stop.** Nothing else writes this session's per-id file. |
   | `CLAUDE_CODE_SESSION_ID` set, per-id file **absent** | — | **Stop.** Per § Both-or-neither writer invariant (BLOCKING) this state must not occur; treating it as a fallback would mask a violated invariant that the no-own-marker rule reads as "this session authored zero headers". *(Claude's addition beyond R2-F1's prescription — flagged as such.)* |
   | `CLAUDE_CODE_SESSION_ID` unset (old CLI) | `logs/.session-marker`, with the doc's loud-fallback line emitted | **Stop.** Disagreement in the fallback path remains a stop, per R2-F1. |

   **The shared file is deliberately NOT consulted when the per-id oracle is available**, and a
   shared-file value that differs from stdout in that case is **normal, not an error** — it means
   a concurrent `/prime` allocated after this one returned. v2 got this wrong: it compared against
   the shared file unconditionally, so a legitimate concurrent session would have made this
   session reject its own valid allocation and skip its header. That is the same read-after-write
   race stdout exists to avoid, reintroduced one layer up.

4. On any rejection, emit a named message identifying the failure class and **do not** create a
   header, a mandate, or `logs/.prime-mtime`.

**Where the stop lands.** `8k` is a shared sub-step called by `8a`, `8b` and `8c`, each of which
performs its own header check and append *after* `8k` returns. A rejection therefore aborts the
**calling branch's dispatch**, not just `8k`: Build must state this in `8k`'s caller-contract
paragraph — which already assigns marker → header → mtime ordering to the caller — and P9 asserts
it against all three branches, not only the shared sub-step.

A failed allocation must leave the session with **no** marker-bearing header rather than a wrong
one: a missing header is loudly diagnosable by `/session-start` Step 3; a wrong one is not.

## Build slices

Two vertical slices. Each is one commit, revert-reversible, tests connected to running code
throughout.

### Slice 1 — Move the implementation (mechanical, atomic)

**Nothing may be split out.** Creating the script without repointing `/prime` leaves two
implementations; repointing `/prime` without repointing the test leaves the suite scraping removed
text. Both are named falsification conditions.

Files touched — exactly three:

1. **`logs/scripts/allocate-session-marker.zsh`** *(new)* — `#!/usr/bin/env zsh`; the zsh runtime
   assertion (D3); a header naming `docs/session-marker.md` as contract authority and stating the
   cwd resolution model (D1) as a rule; the allocator transplanted **verbatim**, all 88 comment
   lines preserved beside the code they guard; the stderr diagnostic; the single stdout line;
   both marker files written together (§ Both-or-neither).
2. **`.claude/commands/prime.md`** — `8k`'s fenced block replaced by a call block of roughly 24
   lines implementing the canonical-only walk-up (D2), the `zsh` invocation (D3) and the full
   caller-seam contract above, plus the sentence in `8k`'s caller-contract paragraph making the
   abort-the-branch semantics explicit. `8a`, `8b`, `8c` are **not** otherwise edited — they
   already say "Run the Step 8k marker-allocation sub-step", which stays true.
3. **`logs/scripts/prime-allocator.test.sh`** — `ALLOC_SRC` repointed to the script; the awk
   extractor and its nine-space dedent deleted; every test invokes the **real shipped script**
   under zsh from each fixture cwd. All 19 existing assertions keep their current expected values.

   Plus two new tests, both required in this slice:
   - **T-CWD** — invoke the script by absolute path from a fixture that is not its own directory;
     assert `logs/.session-marker` is created **in the fixture** and no marker file appears beside
     the script. (D1 guard.)
   - **T-SEAM** — exercise the caller-seam contract against stubbed script outputs:
     - valid line → accepted;
     - empty output, two lines, malformed line → each rejected, **no header written**;
     - `CLAUDE_CODE_SESSION_ID` set + per-id file absent → rejected (§ Both-or-neither);
     - old-CLI path (var unset) + shared-file disagreement → rejected, loud-fallback line emitted;
     - **the concurrency case (R2-F1):** shared marker overwritten by another allocation while
       this session's per-id marker still equals captured stdout → **accepted, session continues.**
       This is the case v2 would have failed.

Evidence: suite green at **21/0** (19 + T-CWD + T-SEAM); differential run (P4) identical;
`git diff --stat` showing exactly three files.

### Slice 2 — Compress duplicated rationale (editorial, deferrable)

Touches **only** the new script. No behaviour change.

- **Retained verbatim, beside their code:** all 16 guards in the inventory below.
- **Compressed to a pointer:** the multi-paragraph incident history (2026-07-13 S6 and S11, the
  four collisions, the worktree explanation) — already owned by `docs/session-marker.md`
  § Why (c) exists / § Why (d) exists / § Known gap.

Evidence: suite re-run 21/0; P3 passes with its positive control.

**Slice 2 is droppable.** If G2 judges the compression unsafe, Slice 1 stands alone and still
meets the objective.

## The guard inventory

v1's P3 matched comment lines containing `Do NOT|never|REQUIRED|LOAD-BEARING|MUST`. Tested against
the baseline (`6a2cd0b:.claude/commands/prime.md`, lines 370–509): it catches **9 of 88** comment
lines and misses **5 of the 6** guards `review-1` named. Replaced by this inventory, derived from
the baseline, every anchor verified present. Anchors are **text**, not line numbers, per this
repo's own lesson that a line number in a live document has a short shelf life
(`logs/decisions.md:218`).

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
embedded block, and any marker the script allocated remains valid input to it: same paths, same
format, same algorithm. P6 verifies this rather than assuming it.

## Prove checks — one per falsification criterion

| # | Criterion | Check |
|---|---|---|
| **P1** | *multiple canonical implementations* | `grep -rlE 'Allocate N = 1\|axcion-session-markers'` across the **workspace** returns exactly one executable, and zero fenced allocators in any `prime.md`. Assert no `allocate-session-marker.*` under any `projects/*/logs/scripts/`. Positive control: the grep must return the canonical script; a silent empty result is not a pass. |
| **P2** | *tests disconnected from running code* | At **every** Build commit the suite runs green and `ALLOC_SRC` resolves to an existing path. Assert no awk-extraction remains. |
| **P3** | *dropped guarded invariants* | All **16** inventory anchors present in the post-change script, each adjacent to the code it guards, not collected in a preamble. **Positive control:** delete one guard in a scratch copy and show the check fails. |
| **P4** | *changed observable allocation* | Differential harness: pre-change implementation (from `6a2cd0b`) vs post-change script, **both under zsh**, identical fixtures, all 8 scenarios. Identical `MARKER` strings and identical contents in **both** marker files. |
| **P5** | *changed marker format or session artifacts* | Both marker files match `^[0-9]{4}-[0-9]{2}-[0-9]{2} S[0-9]+(-[A-Za-z0-9]{1,3})?$`. Files written are exactly the two marker paths — `find` the fixture before and after and diff the list. Assert both are written together (§ Both-or-neither), never one alone. `session-notes.md` untouched by the script. |
| **P6** | *irreversible without altering marker state* | In a fixture: allocate with the script, `git revert` Slice 1, allocate again with the restored embedded block, assert the second reads the first's marker and increments from it. Assert the revert rewrote no marker file. |
| **P7** | *over-claiming the lean* | `wc -l .claude/commands/prime.md` before and after: delta within **−114 ± 10**. Lines 595–830 byte-identical to `6a2cd0b`. Any evidence or `CLOSE` text claiming more fails. |
| **P8** | *D1 — wrong-target resolution* | T-CWD re-run, plus invocation from three separate project fixtures; each writes into its own fixture, never beside the script and never into `ai-resources/logs/`. |
| **P9** | *the caller seam* | T-SEAM re-run against the **actual** `8k` call block, not a paraphrase, and asserted for **all three branches** (`8a`, `8b`, `8c`) — a rejection must abort the calling branch's dispatch, leaving no header, no mandate, no `logs/.prime-mtime`. Must include the R2-F1 concurrency case: shared marker changed by another allocation, own per-id marker still matching stdout → **accepted**. |
| **P10** | *D3 — runtime agreement* | Shebang is zsh; `8k` invokes with `zsh`; the suite invokes with `zsh`; running the script under `bash` exits non-zero on the runtime assertion rather than proceeding. |

## What this plan does not do

- Does not touch auto mode (`8c`). The `/session-start` Step 2.4 / 2.5 / 3.5 duplication stays
  **deferred** — reopening on an explicit auto-mode brief, or on a defect caused by `8c.7.5` and
  `/session-start` Step 3.5 drifting apart.
- Does not change the marker **format**, so the read path and its consumers are untouched. v3 now
  *mirrors* that read path in the seam rather than inventing a second one, but does not alter it.
- Does not address the accepted known gap at `prime.md:398-403`. A worktree on a branch predating
  the current allocator would carry a stale `prime.md` with the old embedded block and never call
  the script: no regression, no fix. **`git worktree list` was run — only the main worktree**
  (`/…/ai-resources`, `[main]`); Codex ran it independently and observed the same.
- Does not create any project-local copy; D2 prevents one from shadowing canonical regardless.
- Does not modify `docs/session-marker.md`. It already owns the contract correctly.

## Residual risks, named

1. **Two divergences from one precedent.** D2 and D3 both depart from `run-manifest.sh`. Each is
   justified, but the shared-script family is now less uniform — and D1's source incident happened
   *because* three scripts looked alike and behaved differently. Mitigated by making both
   divergences self-enforcing in code rather than documented-and-remembered. **A legitimate G1
   decision point, not settled.**
2. **`8a`/`8b`/`8c` are not exercised in a live dispatch.** P9 now asserts the seam against all
   three branches, but no automated test drives a full `/prime` run end to end. The gap predates
   this work and is not closed by it.
3. **Slice 2 draws the history/guard boundary by hand.** The inventory makes the retained set
   checkable; what counts as compressible history is still judgement.
4. **zsh becomes an explicit hard dependency of allocation.** It is the Bash tool's shell, the
   macOS default, and already required by the suite — so not new in practice, but newly explicit,
   and a non-zsh environment now fails loudly instead of silently working.
5. **The seam now depends on the both-or-neither writer invariant holding.** If a future edit ever
   writes the shared marker without the per-id file, the seam stops the session rather than
   silently degrading. That is the intended direction of failure, but it converts a previously
   tolerated inconsistency into a hard stop.
