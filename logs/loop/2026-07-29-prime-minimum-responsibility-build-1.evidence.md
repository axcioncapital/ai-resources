EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-build-1
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: bd0ca61
NEXT: Claude — open Build unit for Slice 3

Status: complete

---

## Premise verification (step 4)

| Premise | What was run | What was observed |
|---|---|---|
| `prime.md` 830 lines, untouched; both worktrees clean | `wc -l`; `git worktree list`; `git status --porcelain` in each checkout | `830`. Two checkouts (`ai-resources` @ `1dc38b3`, `ai-resources-2` @ `83d4adc`, branch `session/2026-07-29-2`). Neither had any change to the three command files; `git diff main` on them was empty |
| `files_inferred` set at `:106`, cleared at `:243` | `sed -n '106p;243p' session-start.md` | Both confirmed verbatim |
| `:253` suppresses re-emit on 2 of 4 engine outcomes | `sed -n '253p'` | `For \`engine-skipped\` / \`engine-error\`: do NOT re-emit` — confirmed |
| `session-plan.md:239` emits "Begin execution" | `sed -n '239p'` | `> Plan written to \`{OUTPUT_TARGET}\` ({autonomy posture}). Begin execution.` — confirmed |
| **Slice 1 census complete for files needing an edit** | Rebuilt census (below) | **Confirmed after correction** — see Finding 1 |

## Finding 1 — the census method was broken, and the census was incomplete

**Material. Disposition: `fixed` for the census, `deferred` for the proof design it invalidates.**

The plan's file census — including review-2's F4 "corrected" version — was produced with `grep -r`.
On this machine `grep` is **ugrep 7.5.0**, and it silently under-reports:

| Test | Command | Result |
|---|---|---|
| Ground truth | `grep -cn "auto-prime" .codex/agents/context-discovery.toml` | **3** |
| Recursive | `grep -rn "auto-prime" . \| grep -c "\.toml"` | **2** |
| Recursive + filter | `grep -rn "auto-prime" --include="*.toml" .` | **0** |

`--include="*.toml"` returns **zero** for a file that demonstrably contains three matches. A census
built on this primitive cannot establish completeness, and **P-CITE — the plan's completeness proof
for the whole citation repoint — is specified to use it.** Run as written, P-CITE would return a
false green.

Rebuilt with `find … -print0 | xargs -0 grep` (accurate per the ground-truth test above). Against the
**pre-change** tree it returns the full known set — 9 files, 29 hits — which is the positive control
review-2 F3 asked for and which the old primitive fails.

Two consequences:

1. **`.codex/hooks/check-foreign-staging.sh` is missing from the plan's census.** Re-verified: it
   carries **zero** sub-step citations — its only reference is a bare `Step 8c` in a comment at
   `:406`, and Step 8c keeps its number, so the reference stays true. **No edit needed**, and the
   actionable file count remains 10. Recorded so the omission is not rediscovered as a surprise.
2. **Two genuine stale citations survived the plan's census**, both at sites inside files already in
   scope that the plan did not enumerate: `prime.md:362` (Step 8m's wiring note claimed 8c writes the
   `- Mission:` bullet inline at 8c.7) and `session-start.md:388` (claimed the bullet is written by
   `/prime` Step 8c.7). Both fixed in this slice. Both were invisible to the old primitive and
   surfaced only on the rebuilt sweep.

**Deferred to Prove:** P-CITE must be re-specified to the `find`-based primitive before it runs. The
finding is recorded here rather than fixed in the plan, because plan-v3 is immutable by contract.

## What was implemented

| File | Change |
|---|---|
| `.claude/commands/prime.md` | 8c rewritten, **236 → 48 lines**. Derivation, echo, mandate/manifest/plan writes all delegated. Retains picking, the two guards, marker/header/mtime, mission auto-bind, `DIRECT`, `MANDATE_TEXT` composition, `STRUCTURAL_RISK`, dispatch, `/risk-check`, execution. Honest abort copy. `:362` wiring note corrected |
| `.claude/commands/session-start.md` | Step 1 captures `{gate:auto}` + `{plan:overwrite}`; Step 2 suppresses echo and wait under `AUTO_GATE`; Step 2.4 re-emit suppressed under `AUTO_GATE` on all four outcomes; **new Step 2.6** holds the gate; Step 4 forwards both tokens; `:388` note corrected |
| `.claude/commands/session-plan.md` | Step 0 consumes `{plan:overwrite}` (skips the 3-option prompt) and `{gate:auto}`; **Step 8 gains an `AUTO_GATE` branch, checked first**, that returns to `/prime` without emitting "Begin execution" |
| `docs/session-marker.md` | 5 citations repointed; **new § Auto-mode done-condition check** holding the rationale 8c.2 now cites |
| `docs/context-pack-schema.md` · `.claude/agents/context-discovery.md` · `.codex/agents/context-discovery.toml` · `.claude/commands/build-context.md` · `.claude/hooks/check-foreign-staging.sh` · `logs/scripts/run-manifest.sh` | 4 · 3 · 3 · 1 · 1 · 1 citation sites repointed; `INVOCATION_MODE: auto-prime` retired in both agent definitions |

**No `/prime` step was renumbered.** Every cited sub-step that disappeared (`8c.4.5`, `8c.7`, `8c.7.5`,
`8c.8`) did so because its *responsibility moved out*, and each citation was repointed to the new
owner in the same commit. `8k`, `8m`, `8a`, `8b`, `8c` all keep their identifiers.

## Verification

| Check | What was run | What was observed |
|---|---|---|
| Allocator tripwire (Slice 2's guard, must not break) | `bash logs/scripts/prime-allocator.test.sh` | **19 passed, 0 failed** — matches the 19/0 baseline. The awk extraction anchors in 8k are intact |
| Validation precedes the gate; gate precedes the write | `grep -n "^### Step" session-start.md` | `2.4 (211) → 2.5 (272) → 2.6 (299) → 3 (359)` — correct order. The gate cannot approve unvalidated engine paths |
| `AUTO_GATE` branch precedes the "Begin execution" default | `grep -n` on session-plan.md Step 8 | `AUTO_GATE` at `:235`, `POST_PLAN_GATE` set at `:241`, unset/default at `:247` — correct |
| No stale sub-step citations remain | Rebuilt `find`-based sweep for `8c.4.5\|8c.7\|8c.8` | **Empty.** Positive control on the pre-change tree returned 9 files / 29 hits |
| Line counts | `wc -l` | `prime.md` **830 → 642**; `session-start.md` **405 → 473**; `session-plan.md` **247 → 257** |

## Finding 2 — one in-scope file is gitignored, so Slice 1's rollback is incomplete

**Material. Disposition: `operator` — it changes a rollback property G1 approved, and no rulebook
path covers it.**

`.codex/agents/context-discovery.toml` is in the plan's census (review-2 F4 added it explicitly:
"Three sites, not one"). It is **untracked** — `.gitignore:59` ignores all of `.codex/`:

```
$ git ls-files .codex          → (empty)
$ git check-ignore -v .codex/agents/context-discovery.toml
  .gitignore:59:.codex/  .codex/agents/context-discovery.toml
```

Consequences:

- The edit **cannot be committed**. `git add` refuses it without `-f`, and forcing it would defeat a
  deliberate ignore rule — not a call this unit should make on its own.
- **Slice 1's stated rollback is `git revert`, and revert will not undo this file.** Reverting the
  commit restores the nine tracked files and leaves the `.codex/` mirror in its edited state — a
  silent divergence between the canonical agent and its Codex port, in the direction that makes the
  port describe an `INVOCATION_MODE` the canonical agent no longer offers.

The edit was **kept**, not reverted: it is correct on its own terms (it keeps the Codex mirror
consistent with the canonical `.claude/agents/context-discovery.md`), and leaving the mirror stale
would be the worse of the two divergences. But it now sits outside version control, and that is a
property of the change the operator approved without knowing.

**This also means the F4 "corrected census" was never fully actionable** — one of the three files it
added cannot be committed by any slice. Worth settling before Slice 2, which touches
`logs/scripts/` (tracked) and is unaffected, and before Prove, whose P-CITE sweep will keep finding
this file in a state no commit explains.

## Deviations from plan-v3

1. **8c came in at 48 lines, not 55** — 7 better than budget. `prime.md` fell 830 → 642 (−188 against
   a projected −181).
2. **`session-start.md` grew +68, not the estimated +42 — a 62% overrun.** Review-2's F7 flagged this
   estimate as understated and asked for a re-estimate after F1/F2; the re-estimate was itself
   understated. The four-outcome gate block and the edit-revalidation contract are the bulk of it.
   This does not threaten `/prime`'s ≤300 target, but it **does weaken the plan's net-workspace-leanness
   claim**: Slice 1's real net is **−110 lines**, not the −181 a `prime.md`-only reading suggests.
3. **`session-plan.md` grew +10, not +7.**
4. **Two extra citation sites** fixed beyond the census (Finding 1).

## LIMITATIONS

- **Nothing here was executed. No behavioural proof was run, and none was possible in this unit.**
  Every check above is structural — line counts, ordering, citation sweeps, and one pre-existing test
  suite that guards a *different* slice's surface. `{gate:auto}` has still never been exercised.
- **Six of the plan's proofs remain unrun and are Prove's to execute:** P-GATE4 (a gate on all four
  engine outcomes), P-VALIDATE, P-EDITVALID, P-RETURN, P-RISKORDER, P-FIELDS. Each needs a live
  auto-mode dispatch against a fixture project. Under the contract a slice that cannot be verified is
  a **finding at Prove, not a fourth gate** — so this is the expected shape, not a shortfall of this
  unit, but it does mean the largest assumption in the stream is still untested.
- **P-CITE cannot be run as specified** — see Finding 1. Re-specify before Prove.
- **The gate block's rendering has been reviewed by nobody.** Build carries no review by contract,
  and plan-v3 itself reached G1 unreviewed after the F1/F2 corrections. The operator-facing block in
  Step 2.6 is therefore the least-scrutinised artifact in the stream.
- **The `/session-start` hard-fail at `:330` was not re-tested.** Slice 1 does not move marker
  allocation (that is Slice 3), so the marker `/session-start` resolves is still written by `/prime`
  8c.5 before dispatch — but this is reasoned, not demonstrated.
- **Not checked:** whether any of `prime.md`'s 28 symlinked consumers reads an 8c sub-step by number
  at runtime. They are symlinks to the same file, so content propagates; the risk is a *reader* that
  parses for `8c.7`, and no such reader was searched for beyond the citation sweep.

## CLOSE

**Outcome:** `close` — Slice 1 landed. `/prime` 8c went 236 → 48 lines, auto mode's single approval
gate now sits in `/session-start` Step 2.6 after discovery and validation, and the mandate, manifest
and plan writes belong to their owners.

**Commits:** `bd0ca61` (brief) · `1b96aa6` (implementation + evidence).

**What closed:** the Build unit `2026-07-29-prime-minimum-responsibility-build-1`.

**Stream:** **stays open.** Slice 1 is the first of five. Next by the G1-approved order is **Slice 3**
(consolidate marker → header → mtime into 8h; depends on Slice 1 only), then Slice 2 — which remains
**blocked** until the Option A capability record is opened and `/develop-ai-resource` is run in
upstream mode for `prime-marker.sh` — then Slice 4, measure, and Slice 5 if the live count still
exceeds 300.

**Two findings carried forward, neither resolved by this unit:** the census primitive is unreliable
and P-CITE must be re-specified before Prove (Finding 1); and one in-scope file is gitignored, so
`git revert` does not fully roll this slice back (Finding 2, disposition `operator`).

---

## Post-close resolutions (operator, 2026-07-29)

Appended after the unit closed. The three items below were decided by the operator in response to
this evidence; each supersedes the disposition recorded above where they differ.

### R1 — P-CITE re-specified

Supersedes Finding 1's `deferred` disposition. **Prove runs the version below, not plan-v3's.**

**Correction to Finding 1's framing.** The earlier text called `grep` broken. That is wrong and is
withdrawn. `grep` is not defective — the fault was the **primitive chosen**: a recursive walk with
`--include` filtering behaved unsuitably over hidden directories in this tree, so the sweep it
produced could not support a completeness claim. The defect is in the method selected for P-CITE,
not in the tool.

**P-CITE (re-specified).** Search **tracked, active surfaces only**, using `git grep` — which indexes
the git object store rather than walking the filesystem, so hidden-directory traversal and
`--include` filtering are not in the path at all, and untracked files are excluded by construction
rather than by pattern.

```bash
# Sweep — tracked files only, historical/generated surfaces excluded by pathspec.
git grep -n -E '8c\.4\.5|8c\.7|8c\.7\.5|8c\.8|auto-prime' -- \
  ':(exclude)logs/loop/**'            ':(exclude)logs/runs/**' \
  ':(exclude)logs/scratchpads/**'     ':(exclude)logs/session-notes*' \
  ':(exclude)logs/session-plan-*'     ':(exclude)logs/improvement-log*' \
  ':(exclude)logs/decisions*'         ':(exclude)logs/friction-log*' \
  ':(exclude)logs/usage-log*'         ':(exclude)logs/incident-log.md' \
  ':(exclude)logs/coaching-*'         ':(exclude)logs/maintenance-observations*' \
  ':(exclude)audits/**'               ':(exclude)plans/**' \
  ':(exclude)output/**'
```

**`logs/scripts/` is INCLUDED** — it holds live consumers (`run-manifest.sh`,
`prime-allocator.test.sh`) that the slices themselves modify, and review-2 F3 was correct that
excluding all of `logs/` omits them. Only the historical and generated paths above are excluded, each
named explicitly rather than by a blanket directory rule.

**`.codex/**` is excluded, and by construction rather than by pathspec** — it is untracked
(`.gitignore:52-59`), so `git grep` never sees it. This is the correct outcome, not a gap: see R2.

**Positive control — required, and it runs against the pre-change tree.** An empty result proves
nothing until the same query has been shown to detect the thing it looks for:

```bash
git stash -q                                    # or: git grep … <pre-change-SHA> -- …
<the sweep above>                               # MUST return the full known set
git stash pop -q
```

**The known pre-change set, executed and confirmed at SHA `1dc38b3`: 8 tracked files, 28 matching
lines** — `.claude/commands/prime.md` 12 · `docs/session-marker.md` 5 · `docs/context-pack-schema.md`
4 · `.claude/agents/context-discovery.md` 3 · `.claude/commands/build-context.md` 1 ·
`.claude/commands/session-start.md` 1 · `.claude/hooks/check-foreign-staging.sh` 1 ·
`logs/scripts/run-manifest.sh` 1. **A control returning fewer than this falsifies the sweep, and the
post-change result must be discarded rather than reported.**

*(This corrects the "9 files, 29 hits" figure stated earlier in this evidence. That count came from
the unsuitable primitive and was itself wrong in two ways: it counted the now-out-of-domain
`.codex/agents/context-discovery.toml`, and it scored that file **1** matching line where the file
actually contains **3** — the same undercount that motivated re-specifying the sweep. The corrected
figure above was produced by `git grep` and re-run against the pre-change SHA to confirm it.)*

**Post-change result, run and confirmed:** one hit —
`.claude/agents/context-discovery.md:22`, the note recording that `auto-prime` was retired. A
retirement note naming the retired value is intended, not a stale citation. Every other site is
repointed.

### R2 — `.codex/` stays untracked; the three local edits are reverted

Supersedes Finding 2's `operator` disposition. **Resolved: do not force-track.**

`.gitignore:52-59` does not merely ignore `.codex/` — it *classifies* it: a Codex CLI harness mirror,
"operator experiment, NOT a maintained artifact" (operator call, 2026-07-13 S12), carrying its own
unsynced copies of canonical logic, ignored specifically "so it cannot be committed by accident. If
Codex is ever adopted for real, the decision to track and sync this mirror is a deliberate one to
make." Editing it as part of a slice was exactly the un-decided sync that rule exists to prevent —
the earlier judgement that a stale mirror is "the worse divergence" assumed the mirror is maintained,
and the classification says it is not.

**Action taken:** all three edits to `.codex/agents/context-discovery.toml` reverted to their original
text (`:2`, `:14`, `:217` restored to their `auto-prime` wording; verified — 3 occurrences present).
The file is byte-restored and no longer diverges from the state Slice 1 found.

**Consequences, all resolved rather than carried:**
- Slice 1's census is now **9 actionable tracked files**, not 10. Every one is committed in `1b96aa6`.
- **`git revert` on `1b96aa6` is now a complete rollback.** The gap Finding 2 raised does not exist.
- The Codex mirror keeps its own pre-existing staleness, which is its normal condition under the
  classification and is not this stream's to fix. If Codex is adopted, tracking and syncing the
  mirror is its own lifecycle decision.

### R3 — `session-start.md` +68 accepted as a disclosed Build variance

Supersedes Deviation 2's framing. **Slice 1 is not reopened for line count.**

The approved estimate was +42; the measured growth is +68. Accepted as a **disclosed Build variance**:
Slice 1 moved each responsibility to its correct owner and delivered a real net reduction of **110
lines**, which is the outcome the slice was approved for. Growth in a delegate is the expected shape
of a delegation, and re-opening a landed slice to shave a command that is now correctly-owned would
trade a real architectural gain for a cosmetic count.

**Carried to G2 as a limitation**, not closed here: the workspace-leanness figure presented at G1
understated the delegate's growth by 62%, and the same estimating method produced plan-v3's remaining
per-slice budgets. Prove should treat the outstanding slice estimates as carrying comparable
uncertainty and report the measured totals rather than the projected ones.
