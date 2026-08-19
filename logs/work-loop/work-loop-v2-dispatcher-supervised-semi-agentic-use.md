---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 22 — make Git path accounting lossless

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 21 is accepted at `02c1f747b5faa0dec82b21e36b6304a1ccaf3409`. It established that checkout, derived state-file and capture/result paths already have canonical identity and containment, and that the lease helper correctly re-anchors a relative Git common directory. The one real gap is Git-reported changed/dirty paths: production reads line-delimited, possibly C-quoted output and strips only outer quotes. This can false-stop allowed committed work and, more importantly, can hide an actor's second edit to an already-dirty path from partial-effect and `changed_paths_since_launch` evidence.

The approved plan requires hostile paths not to hide effects or change routing. This unit replaces that lossy boundary using Git's standard raw NUL-delimited path interfaces. It does not create a decoder, general path abstraction or new policy layer.

Dominant deliverable: lossless Git path ingestion for every dispatcher decision that classifies changed, dirty or committed paths.
Evidence required in this hop: one targeted failing hostile-path case before the edit; the corrected partial-effect and committed-allowlist behavior; one narrow mutation/control that removes the raw NUL-delimited property or restores the lossy reader and makes the case fail; focused tests only.
Evidence explicitly deferred: unrelated path canonicalization already adjudicated as covered; the default-evidence-location end-to-end coverage gap; broad filename matrices; the experimental `--unattended` stream-json denial proof; `too-many-lines` defence-in-depth proof; Change set B execution budgets; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused case shows an already-dirty allowlisted path containing a Git-quoted byte is edited by the actor but omitted from partial-effect or changed-path evidence under the current reader.

Required outcome:

- Replace every production use of line-delimited Git path output in `foreign_worktree`, `allowlisted_dirty`/`allowlisted_dirty_snapshot`, and `committed_foreign` with lossless raw path ingestion. Use Git's NUL-delimited interfaces and shell reads that preserve each path as one value; do not write a C-quote decoder.
- Preserve the existing semantics: foreign dirty work stops before launch; allowed dirty work is fingerprinted so a second actor edit is visible; staged work is detected; committed paths are checked against the same allowlist; and terminal-result counts and partial-effect reporting remain truthful.
- Handle Git rename output deliberately. Do not carry a line-oriented `orig -> dest` assumption into the NUL-delimited form, and ensure a rename whose relevant path is foreign cannot disappear from classification.
- Render any operator-facing hostile pathname in a bounded, non-injecting form. A newline or control byte in a filename must not create a fake `STOP`, `RESULT`, `PARTIAL FILE EFFECTS` or other control line.
- Use one combined hostile fixture where practical to cover quote/backslash/non-ASCII/control-byte handling. Do not add an exhaustive per-character matrix unless one combined case cannot distinguish the required behavior.
- Keep the change inside existing dispatcher functions and focused tests. Add no helper script, parser, path-policy abstraction, configuration switch or dependency.

Check against the repository:

1. Verify Unit 21 commit `02c1f747b5faa0dec82b21e36b6304a1ccaf3409` and its state-only scope without rerunning discovery.
2. Verify the current lossy transformations and all consumers named by Unit 21 before editing; if any consumer already receives raw lossless paths, stop and hand back the false premise.
3. Verify the exact installed Git output contract used for status, diff and rename paths from local Git documentation/help or executable behavior inside a disposable fixture; no network is needed.
4. Preserve `staged_paths` and `state_dirty` behavior even where their current emptiness-only checks make quoting not applicable.

Required fail-capable evidence:

- Quote the pre-edit failure for an already-dirty allowlisted hostile path changed during the actor hop: the path is absent from partial-effect/changed-path evidence despite the content change.
- After the edit, show that the same path is classified as allowed, its before/after content fingerprint differs, and it appears exactly once in bounded operator-facing partial-effect evidence without creating a fake control line.
- Show an allowed committed hostile path no longer false-stops as committed foreign, while a genuinely foreign hostile path still stops.
- Show one rename case exercises the NUL-delimited rename shape and preserves foreign/allowed classification.
- Provide a narrow mutation/control proving the hostile-path test fails when the lossless boundary is removed or bypassed.
- Run only new and directly affected focused cases. Report exact commands and counts; defer the full suite.
- Report the implementation commit and confirm only `dispatch.sh`, `dispatch.test.sh` and this state file were committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read Unit 21 evidence and current dispatcher/tests; inspect local Git help or disposable local fixtures; edit `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its existing test file and this task state; run focused local shell tests; and make local commits. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No live model launch, authentication attempt, network, external service, full-suite run, merge, push, deployment, destructive cleanup or other operator-reserved capability is permitted.

Completion condition: one committed implementation handback makes every trusted Git path decision lossless and control-line-safe, proves the hidden-effect and false-stop cases with focused fail-capable evidence, changes only the bounded files, and returns with `turn: codex`.

Stop and hand back if Bash cannot preserve the required raw paths without a new parser/helper, if NUL-delimited rename semantics cannot be established locally, if operator-facing safety requires a new result schema, or if the focused change expands into general path policy.

## Latest result

### Correction round — finding 1: RESOLVED

**Reproduced first, both ways.** By inspection: `worktree_entries()` emitted `<oid>` as field 2 and `<XY> <display path>` as field 4, and `allowlisted_dirty_snapshot()` projected exactly those two into the record it compares across a hop — so the record's identity was the display form, and `disp_path()` maps every control byte to the same `?`. By execution, new case 70g against the accepted Unit 22 commit `4730569b`:

```
  PASS  70g — the actor really did swap the two files' contents
  FAIL  70g — both swapped paths are reported as partial effects
        partial block: PARTIAL FILE EFFECTS — since launch, the hop changed these ALLOWED paths and left them modified and uncommitted:
  FAIL  70g — changed_paths_since_launch counts both swaps plus the state file
        got: 1
```

Two allowed files, `logs/hostile-c<TAB>d.md` and `logs/hostile-c<NEWLINE>d.md`, both rendering as `logs/hostile-c?d.md`, both already dirty at launch, contents swapped by the actor. The swap demonstrably happened, and the run reported the state file alone.

**Why a swap and not an edit.** Each file's oid does move, so neither path looks unchanged on its own. The comparison is `comm(1)` over the **sorted** records, and swapping two contents between two same-display paths permutes that multiset back onto itself — before and after compare equal, and two real content changes vanish from the partial-effect block and from `changed_paths_since_launch`.

**The correction, one seam.** Field 2 of the snapshot record now carries `<oid>.<16-hex digest of the RAW pathname>`. A digest, not an encoding: bounded, line-safe by construction, one-way, so it keys the comparison without putting a raw control byte anywhere a person or a parser reads. `shasum -a 256` is already this script's hashing primitive (`RUN_DISCRIMINATOR`), so no dependency is added. It is carried **inside** field 2 rather than as a new column because both consumers project the record with `cut -f2-` and never parse the first field — verified at `dispatch.sh:3247` and `:3282`/`:3284` — so no consumer, no operator-facing output and no terminal-result field changes.

The display form is untouched and still does all matching and all printing. Nothing else was opened: NUL ingestion, allowlist policy, rename handling, the untracked-mode asymmetry and every other deferral are as they were.

**Evidence.**

| Check | Pre-correction (`4730569b`) | Corrected |
|---|---|---|
| Focused cases 70a–70g | `pass=21 fail=2` | **`pass=23 fail=0`** |
| Directly affected legacy cases 40–50b | `pass=157 fail=6` | **`pass=157 fail=6`, `diff`-identical failure set** |

Both closure questions:

1. **Finding 1 resolved** — 70g's two failing assertions now pass: both swapped paths appear in the partial-effect block, and `changed_paths_since_launch` reports `3` (the pair plus the state file) rather than `1`. A fourth assertion confirms no raw control byte reached operator output through the new identity.
2. **Nothing already accepted broke** — every Unit 22 case 70a–70f still passes, including the M16 mutation control, which continues to hide 70a's evidence when the fingerprint is taken from the display path. The legacy extract's six failures are the same six as at Unit 22 acceptance (cases 40/40b, nested-actor deny and fake `claude` binary — extract artifacts, no path-accounting assertion among them), compared line by line rather than by count.

Newly noticed during the correction and **not implemented**, recorded as a candidate deferral: the digest bounds the identity at 16 hex characters, so distinct raw pathnames could in principle collide there. It is a 64-bit space against filenames the actor would have to author deliberately, and widening it is a one-character change if Codex judges it worth doing — but it is outside the frozen finding, so it was left alone.

Only `dispatch.sh`, `dispatch.test.sh` and this state file changed. `logs/friction-log.md` left unstaged.

---

### Unit 22 implementation record (accepted at `4730569b`, retained for context)

Inspected (2026-08-19):

- Claim (1): HOLDS — `git show --stat --name-only 02c1f747b5faa0dec82b21e36b6304a1ccaf3409` lists exactly one file, `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md`. State-only, as Unit 21 reported; discovery not rerun.
- Claim (2): HOLDS, and no consumer already receives raw paths — so the false-premise stop did **not** fire. Re-read before editing: `dispatch.sh:3087` (`status --porcelain`, line-delimited) and `:3089`, `:3136`, `:3158` (the three `p="${p%\"}"; p="${p#\"}"` pairs), plus `:3837` (`diff --name-only`, no strip at all). All four consumers named by Unit 21 were still reading the line-delimited forms.
- Claim (3): HOLDS — verified by executing the installed Git in a disposable fixture outside the checkout, not from memory. `git version 2.50.1 (Apple Git-155)`; `git config --get core.quotePath` unset, so quoting defaults to on. Findings: `status --porcelain` emits `"logs/work-loop/t\303\245sk.md"` where `status --porcelain -z` emits the raw bytes; a rename is `R  "old" -> "new"` in the line form but **`R  <new>NUL<old>NUL` in the `-z` form — the extra path moves to its own record and the order reverses**; `diff --name-only -z` is raw; and with rename detection on (the default) `diff --name-only` prints **only the destination**, while `--no-renames` restores both sides.
- Claim (4): HOLDS — `staged_paths` (`dispatch.sh:3200`) and `state_dirty` (`:3856`) both consume only emptiness (`:4446-4448`, and `state_dirty`'s own `[ -n ... ]`). Both left unchanged; a comment now records why converting them would add risk without gain.

### Pre-edit failure, quoted (the `Primary edit begins after:` condition)

New case 70a, unchanged, run against the dispatcher at `HEAD` (`git show HEAD:...dispatch.sh`). An allowlisted path named with a quote, a backslash, a tab and a non-ASCII byte is already dirty at launch; the actor edits it again:

```
  FAIL  70a — the actor's edit to the hostile path IS reported as a partial effect
        partial block: PARTIAL FILE EFFECTS — since launch, the hop changed these ALLOWED paths and left them modified and uncommitted:
  FAIL    70a — changed_paths_since_launch=2
        got: 1
```

The block header prints and **the path is absent from it**; the machine record counts 1 where 2 changed. The same run confirms classification was never the problem — `worktree_allowlisted_dirty_paths=2` passes. Case 70c returned exit 30 on legitimate in-allowlist committed work: the false stop, reproduced.

Focused RED baseline against `HEAD`: **`pass=12 fail=6`**.

### Result

Every trusted Git path decision now reads raw bytes through Git's own NUL-delimited interfaces. No decoder was written — the hand-rolled quote-stripping was deleted, not replaced.

- One new scanner, `worktree_entries()`, reads `status --porcelain -z` once and emits classified entries. `foreign_worktree()`, `allowlisted_dirty_snapshot()` and (now derived from the snapshot) `allowlisted_dirty()` are consumers of that one scan, so they can no longer disagree about which paths are allowed.
- `committed_foreign()` reads `diff --name-only -z --no-renames`. `--no-renames` is not about quoting: with detection on, a commit that renamed a foreign path *into* the allowlist showed only the allowed destination and the foreign origin vanished from classification entirely.
- Renames are handled in their `-z` shape at both readers, and an entry is allowed only when **both** sides are — so a foreign origin cannot be laundered by renaming into the allowlist.
- `disp_path()` renders any operator-facing or allowlist-matched path with control bytes replaced by `?`. This pays two costs that reading raw newly incurs and that Git's quoting used to cover for free: a raw newline would forge a `STOP`/`RESULT`/`PARTIAL FILE EFFECTS` line, and — less obvious — `grep -E '^...'` is line-oriented, so a raw newline would offer a **second line to anchor `^` against**, letting `foreign/x⏎logs/work-loop/y` match `^logs/work-loop/` and be admitted as allowed work.

The split is the whole design: **raw bytes decide and fingerprint, the display form matches and prints.**

### Evidence

| Check | Before | After |
|---|---|---|
| Focused new cases 70a–70f | `pass=12 fail=6` | **`pass=18 fail=0`** |
| Directly affected legacy cases 40–50b | `pass=157 fail=6` | **`pass=157 fail=6`, identical failure set** |

Exact commands (extracts built into the scratchpad; `REPO_ROOT`/`OWNER_BIN`/`LEASE_BIN`/`STATE_BIN` pinned to this checkout, `DISPATCH_BIN` selecting the version under test):

```
DISPATCH_BIN=<HEAD copy>  bash case70.test.sh   -> pass=12 fail=6
DISPATCH_BIN=<implemented> bash case70.test.sh  -> pass=18 fail=0
DISPATCH_BIN=<HEAD copy>  bash legacy.test.sh   -> pass=157 fail=6
DISPATCH_BIN=<implemented> bash legacy.test.sh  -> pass=157 fail=6
```

The legacy six were `diff`-compared line by line and are **the same six**, all inside cases 40/40b (nested-actor deny set, fake `claude` binary). They are extract artifacts — those cases depend on stub setup defined outside the extracted range — and are untouched by this unit: no path-accounting assertion is among them.

**Mutation control (case 70f), narrow by construction.** One substitution, `hash-object -- "$p"` → `hash-object -- "$d_p"`: fingerprint the display path instead of the raw one, leaving the `-z` reads and every allowlist verdict exactly as shipped. `disp_path` differs from the raw path for precisely the bytes this unit is about — the tab in the fixture name — so the mutant reproduces the original defect: the oid becomes a constant on both sides of the hop, the snapshots compare equal, and 70a's evidence disappears. Both mutant assertions pass, including `changed_paths_since_launch` dropping back to `1`. 70a is fail-capable.

The remaining cases are controls rather than discriminators, and are labelled as such: 70d (a genuinely foreign hostile commit still stops at 30) prevents 70c being satisfied by a `committed_foreign()` that stopped classifying anything; 70e's exit 24 holds before and after, its display-form assertion being the half that moves.

### Deferral noticed mid-unit, recorded and not done

`foreign_worktree()` scans with `--untracked-files=normal` while `allowlisted_dirty()` uses `all`, so an untracked file inside an untracked directory is reported as the collapsed `dir/` by one reader and individually by the other. This predates the unit, is unrelated to quoting, and is not part of the lossless boundary — implementing it here would be the scope expansion the brief's stop condition names.

### Accepted limitation

The display form is lossy on purpose, so two different names can render identically in operator-facing output. It never decides anything: classification runs on the display form only for line-anchoring safety, and the content fingerprint that distinguishes files runs on the raw path.

### Bounded-scope confirmation

Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `.../dispatch.test.sh` and this state file were committed. No plan or documentation file changed. The full dispatcher suite was not run and stays deferred. `logs/friction-log.md` left unstaged.

## Blocker

None.

## Next action

Codex: closure check on frozen finding 1 only — the snapshot record now carries a lossless digest of the raw pathname alongside the oid, the collision case 70g is red at `4730569b` and green after, and the accepted Unit 22 cases plus the legacy extract are unchanged at an identical failure set. One out-of-scope observation (the 16-hex identity bound) is recorded as a candidate deferral, not implemented.

<!-- superseded — the frozen findings this round answered are kept below for the closure check -->

Correct once — frozen findings:

1. The internal snapshot identity is still lossy even though Git ingestion is now raw. `worktree_entries()` fingerprints file contents from raw `$p`, but emits only `<oid> + <lossy display path>` into `allowlisted_dirty_snapshot`; `disp_path()` maps every control byte to the same `?`. Two distinct allowed filenames that differ only by control byte can therefore produce identical snapshot identities. If their contents are swapped during a hop, the sorted before/after snapshots can be identical and the effect disappears from `partial_effect_paths()` and `changed_paths_since_launch`. Correct this one seam by carrying a bounded, line-safe, lossless identity derived from the raw pathname in the internal snapshot comparison while retaining the deliberately lossy display form only for matching and operator output. Do not print raw control bytes, write a general encoder/parser, change the terminal-result schema, or reopen NUL ingestion, allowlist policy, rename handling, untracked-mode asymmetry, or other deferred work. Add one focused collision case with two allowed paths whose display forms are identical but raw names differ, and a content swap (or equally small discriminator) that is invisible under the current `<oid> + display>` representation and visible after the correction.

Closure check: answer only whether finding 1 is resolved and whether its correction broke any already-accepted Unit 22 behavior. Report the correction commit, focused before/after evidence and exact focused counts; set `turn: codex` and stop.
