UNIT: 2026-07-29-prime-lean-down-shape   STREAM: 2026-07-29-prime-lean-down   PHASE: shape
REPO: ai-resources   BASE: fd3ae2608fb05f5d63a95cc6df96247559db0132   NEXT: Codex — re-brief a fresh stream

EVIDENCE

OUTCOME: rejected-premise

## The rejected premise

Brief premise 3: *"27 consumers are symlinks; axcion-design-studio remains a byte-identical
real fork."*

The second clause is **false**. `projects/axcion-design-studio/.claude/commands/prime.md` is not
a fork, not a copy, and not a separate file. It **is** `ai-resources/.claude/commands/prime.md`,
reached through a symlinked parent directory.

What was run, and what was observed:

```
stat -f '%i  %N' ai-resources/.claude/commands/prime.md \
                 projects/axcion-design-studio/.claude/commands/prime.md
  → 13363220  ai-resources/.claude/commands/prime.md
  → 13363220  projects/axcion-design-studio/.claude/commands/prime.md
```

Identical inode. One file, two paths.

```
ls -ld projects/axcion-design-studio/.claude/commands
  → lrwxr-xr-x ... .claude/commands -> ../../../ai-resources/.claude/commands
cd projects/axcion-design-studio/.claude/commands && pwd -P
  → /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands
git -C projects/axcion-design-studio ls-files .claude/commands/
  → (empty — nothing under that path is tracked in the design-studio repo)
```

## Why Frame got it wrong — the method error, not a data change

Nothing changed on disk between Frame and Shape. Frame's method could not distinguish the two
cases it needed to tell apart.

1. `test -L "$f"` on the **file** returned false. Correct, and misleading: the file is not a
   symlink — its **parent directory** is. `test -L` answers a question about one path component,
   and the relevant symlink was one level up.
2. `diff -q canonical fork` reported no differences. Correct, and misleading: `diff` reports no
   differences because it is comparing a file with itself.

Neither primitive can separate *a copy whose bytes happen to match* from *the same inode*. Both
were run, both returned true readings, and the conclusion drawn from the pair was false. The
check that resolves it — `stat -f %i`, or `pwd -P` — was not run.

A secondary symptom pointed at this in Frame and was not chased: `find . -name 'prime.md'` never
returned the design-studio path at all (`find` does not descend into symlinked directories by
default), while the `projects/*/` glob did return it. Frame reconciled two enumerations that
disagreed by reporting a total ("30 instances: 27 symlinks, 3 real files") that matched **neither**
of them. A disagreement between two counts was resolved by averaging them instead of by
explaining them.

## Corrected inventory (re-derived, authoritative)

Method: enumerate `{dir}/.claude/commands/prime.md` by glob across the workspace — which follows
symlinked parents — and classify each hit by `test -L` plus, where it is a real file, `stat -f %i`
against canonical.

| Class | Count | Detail |
|---|---|---|
| Consumers via **file** symlink → canonical | 28 | workspace root, `harness/`, `knowledge-bases/pe-kb-vault/`, `archive/nordic-pe-macro-landscape-H1-2026/`, and 24 under `projects/` |
| Consumers via **directory** symlink → canonical | 1 | `projects/axcion-design-studio/` (`.claude/commands` → `../../../ai-resources/.claude/commands`) |
| Unrelated 33-line variants, **no allocator** | 2 | `projects/axcion-sector-intelligence/`, `ai-resources/workflows/research-workflow/` |
| Canonical source | 1 | `ai-resources/.claude/commands/prime.md` |
| **Total instances** | **32** | Frame reported 30 |

**Consequence, and it is favourable.** Every consumer of the canonical file — all 29 — tracks it
live. **No frozen copy of the allocator exists anywhere in the workspace.** Frame's F2 asserted
the opposite and built an argument on it: that moving the allocator into a walk-up-resolved script
would let a frozen fork run current logic and thereby narrow the accepted known gap at
`prime.md:398-403`. That argument is void. The known gap remains real for *worktrees on stale
branches* (which is what `prime.md:398-403` actually describes) but there is no stale checkout in
the workspace today, and this change would not address the worktree case either.

## Why this stops the unit

`docs/work-loop.md` § The eight steps: *"A rejected premise stops at step 4 … Do not repair the
brief's reasoning on its behalf and do not proceed on the surviving premises — a brief whose
foundation is wrong needs re-briefing, not salvage."*

Load-bearing test applied to this unit's deliverable — the plan:

- The brief's **scope** requires the plan to *"explicitly disposition the frozen
  axcion-design-studio fork without writing to that sibling."* There is no fork to disposition.
  The clause cannot be satisfied as written.
- The brief's **falsification** list includes *"silently treats the frozen fork as updated."*
  A criterion about a non-existent object cannot be checked at Prove. Per § The challenged route,
  Prove judges the result against Shape's falsification criteria; a void criterion makes G2
  partly unfalsifiable, which is the specific failure the plan's falsification section exists to
  prevent.

One of six scope clauses and one of six falsification criteria are void. The plan is the whole
deliverable of this unit, and both defects would be baked into an **immutable** artifact
(§ Artifacts: `{unit}.plan.md` is immutable; a revision is `-v2`). Stopping now costs one
re-brief; proceeding would commit a permanent plan built partly on a disproved object.

## What survives, and is re-usable in a fresh brief

Re-derived this unit, against live files:

- **F1 stands.** `prime-allocator.test.sh:17` sets `ALLOC_SRC` to `.claude/commands/prime.md` and
  extracts the block by matching the literal `Allocate N = 1` (test L29; target `prime.md:372`),
  dedenting by exactly nine spaces. Baseline re-run this unit: **19 passed, 0 failed, ALL PASS.**
  Any Build slice that moves the allocator must repoint the suite in the same commit.
- **F3 stands.** Block re-measured: 138 lines — 49 executable, 88 comment-only (64%), 1 blank.
  `docs/session-marker.md` § Marker allocation independently owns the same four-source contract.
  Line-local anti-regression warnings must travel with the code.
- **F4 stands.** Auto mode `8c` spans lines 595–830 (236 lines), unchanged; last commit touching
  `prime.md` is `50cead2`, unrelated to this stream. Still deferred.
- **F2 is withdrawn** and replaced by the corrected inventory above.
- The **need is untouched**: allocation still has no executable owner, and the rationale is still
  stated twice (command comments + `docs/session-marker.md`) and a third time executably (the
  19-assertion suite).

## Adjudication

None. Shape's Codex review never ran — the unit stopped at step 4, before the plan that would
have been its object existed.

## Contract defect to report

§ Closing without a change requires the rejection evidence to be written, and requires the same
commit to close the stream and delete every `logs/loop/{STREAM}-*` file. Followed literally, this
unit's evidence would be created and deleted in one commit and would therefore never exist in
git — while the same section insists the outcome must stay recoverable and that one must "never
delete the evidence without writing the pointer." Those cannot both hold in a single commit.

Resolved here as **two commits**: this evidence is committed first so the rejection proof exists
in history and is recoverable; the closing commit then deletes the stream's artifacts and appends
the `logs/decisions.md` pointer citing the first commit as the recovery SHA. Both stated
guarantees are preserved. Reported rather than silently worked around.

LIMITATIONS:
- The corrected inventory enumerates `{dir}/.claude/commands/prime.md` across the workspace tree.
  A consumer reaching the file by some other route — an `--add-dir` outside this tree, a copy
  under a different filename, a checkout elsewhere on the machine — would not appear. Not
  disproved; out of reach of a repository-local scan.
- The worktree case named at `prime.md:398-403` (a checkout on a branch predating the current
  allocator) was **not** tested. No such worktree exists right now (`git worktree list` not run —
  stating this as unchecked rather than implying it was checked). That case is unaffected by the
  inode finding either way.
- `git log -1 -- .claude/commands/prime.md` establishes the last commit touching the file, not
  that no uncommitted edit exists. `git status` earlier this session showed `prime.md` clean; the
  two files that are dirty in the tree are `.claude/commands/work-loop.md` and `docs/work-loop.md`,
  neither of which is an object of this stream.
- No plan was written, so nothing here has been reviewed by Codex. This evidence is
  single-model output and carries no independent check.
- Zero edits were made to any object under work. This unit wrote only its own `logs/loop/`
  artifacts.

Status: complete
