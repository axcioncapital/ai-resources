# Work Loop v2 core resolver — argument-substitution defect report

**Date:** 2026-08-10
**Status:** Verified defect; correction proposed, not implemented.
**Scope:** The executable-core resolver in the deployed Claude command, and the same block mirrored in the deployed Codex skill.
**Trigger:** `/work-loop-v2` was invoked on the `contacting-operations-phase-5-needs` task with a multi-line operator decision packet as its argument.
**Decision in one line:** remove `$1` and `$2` from the embedded resolver, because a fenced block that must run character-for-character may not contain tokens the slash-command expander owns.

## Executive finding

The `/work-loop-v2` command body contains a Bash resolver that the command instructs the reader to run **before any other Work Loop action**. That resolver defines shell functions taking their input through the Bash positional parameters `$1` and `$2`.

Claude Code also treats `$1` and `$2` in a slash-command body as **argument placeholders**. When the command is invoked with an argument, the expander rewrites those tokens before the reader ever sees them. The resolver therefore arrives with its own parameters replaced by fragments of the operator's argument text.

**The command then cannot run.** The corrupted resolver fails, and the command's own contract makes that terminal: *"A nonzero exit is terminal: report it and stop without a relative-path fallback."*

The defect is **argument-shape dependent**, which is its most dangerous property. A short single-token argument passes through untouched and the command works. Only longer arguments — the kind real operator hand-offs carry — trigger it.

## Verified facts

### 1. The source uses `$1`/`$2` as Bash positionals

`ai-resources/.claude/commands/work-loop-v2.md`, six occurrences across five functions:

```
29:  wl2_top="$(git -C "$1" rev-parse --show-toplevel 2>/dev/null)" || return 1
33:  local wl2_w="$1"
40:  wl2_c="$(git -C "$1" rev-parse --git-common-dir 2>/dev/null)" || return 1
41:  case "$wl2_c" in /*) ;; *) wl2_c="$1/$wl2_c" ;; esac
47:  wl2_common="$(wl2_git_common "$1")" || return 1
72:  local wl2_candidate="$1" wl2_source_root="$2" wl2_dir
```

The same file uses `$ARGUMENTS` twice (lines 9 and 128) as the intended argument placeholder. **Both mechanisms fired on the same invocation**, which is the direct evidence that the body is expander-processed.

### 2. Exact reproduction

Invocation argument began:

> `Yes—the missing piece is a self-contained answer for Claude. Paste this into Claude after running /work-loop-v2:`

The resolver was delivered as:

```
wl2_top="$(git -C "missing" rev-parse --show-toplevel 2>/dev/null)" || return 1
local wl2_w="missing"
wl2_c="$(git -C "missing" rev-parse --git-common-dir 2>/dev/null)" || return 1
case "$wl2_c" in /*) ;; *) wl2_c="missing/$wl2_c" ;; esac
wl2_common="$(wl2_git_common "missing")" || return 1
local wl2_candidate="missing" wl2_source_root="piece" wl2_dir
```

Every `$1` became `missing`; every `$2` became `piece`.

### 3. The index mapping is offset, and this is unexplained

Whitespace tokens of the argument are `["Yes—the", "missing", "piece", …]`. `$1` received `missing` and `$2` received `piece` — that is **token[1] and token[2] of a zero-indexed list**, not the first and second arguments.

**This report does not assert the expander's rule.** The substitution is certain and reproduced; the off-by-one is a consistent observation offered to whoever implements the fix, not a verified specification. It should be confirmed against Claude Code's documented behaviour before any fix relies on it.

### 4. Positive control — a short argument is not corrupted

In the **same session, on the same machine, against the same file**, an earlier invocation of `/work-loop-v2 phase5` delivered the block **intact**, with `git -C "$1"` unsubstituted. The resolver ran and returned the correct core path.

This is the load-bearing fact for triage. **The defect does not reproduce under the argument shape a maintainer is most likely to test with.**

### 5. The observed failure is closed, not silent

Simulated directly:

```bash
wl2_git_top() { local t; t="$(git -C "missing" rev-parse --show-toplevel 2>/dev/null)" || return 1; (cd "$t" && pwd -P); }
wl2_git_top; echo $?      # -> 1
```

`git -C "missing"` fails, `wl2_git_top` returns 1, `wl2_repo_root` is never set, and the resolver exits 1 with `ERROR: Work Loop v2 cannot resolve its repository boundary.`

**No silent misresolution was observed or demonstrated.** In the observed shape the command fails loudly, which is the correct behaviour for a boundary check.

### 6. The containment check is parameterised by a substitutable token

The check that keeps the resolved file inside the permitted root is:

```bash
wl2_try_semantic() {
  local wl2_candidate="$1" wl2_source_root="$2" wl2_dir
  ...
  case "$wl2_dir/" in "$wl2_source_root/"*) ;; *) return 1 ;; esac
```

`wl2_source_root` — the boundary itself — is built from `$2`.

**This is a shape finding, not an exploit.** No argument was found that makes containment pass wrongly, and none was sought. The point stands independently: a security boundary should not be assembled from a token another layer may rewrite.

### 7. Two deployed surfaces, with asymmetric exposure

| Surface | `$1`/`$2` | `$ARGUMENTS` | Exposure |
|---|---|---|---|
| `.claude/commands/work-loop-v2.md` (Claude side) | 6 | 2 | **Confirmed vulnerable** — reproduced above |
| `.agents/skills/work-loop-v2/SKILL.md` (Codex side) | 6 | 0 | **Latent, untested** |

The Codex skill carries the identical resolver but **never uses the `$ARGUMENTS` convention**, so it may not participate in placeholder expansion at all. That is **inference from the absence, not a verified exemption** — it was not tested, and it must be before the skill copy is declared safe.

The two resolver regions were diffed and are otherwise identical; the only difference is three lines of surrounding command-specific prose.

### 8. No test executes the resolver

No test harness runs this block. Both defects found in it to date were found by a human or agent hitting them during real use.

## Root cause

**One namespace, two owners.** The resolver is written as executable Bash and embedded verbatim in a document that a templating layer rewrites. `$1` and `$2` are meaningful to both layers, and the outer layer runs first.

Nothing about the resolver's *logic* is wrong. The defect is entirely in its *delivery*.

**Not the cause:** the resolver's boundary rules, the workspace-detection logic, and the shared-store-plus-name trust test are all unaffected and behave correctly when the block arrives intact — as fact 4 demonstrates.

## Impact

### Verified

- `/work-loop-v2` cannot start when invoked with a multi-word argument.
- The failure is total for that invocation and occurs before any Work Loop action.
- Nothing is corrupted or lost; the command stops before touching the repository.
- The operator must re-invoke with a short argument, or the reader must recognise the corruption and substitute a correct resolver — which is what happened here, and which requires knowing the resolver well enough to spot it.

### Inference, bounded by the verified logic

- Any argument containing shell-significant or multi-token text will hit this.
- Because short arguments pass, the defect will survive routine testing and reappear in production hand-offs.
- The Codex skill copy is probably unaffected in practice, for the reason in fact 7 — but this is untested.

## Immediate workaround

Invoke with a **short, single-token task id** and pass long content in a separate message:

```
/work-loop-v2 contacting-operations-phase-5-needs
```

A reader who receives a visibly corrupted block should **not** run it, and should not fall back to a relative path. Running the uncorrupted resolver from the canonical source is correct; guessing the core's location is not.

## Recommended correction

### Preferred fix (proposal, not implemented)

**Eliminate `$1` and `$2` from the embedded block.** Give the functions their input through named variables assigned before each call, so no expander-owned token appears in code intended to run verbatim. This keeps every existing check — file, symlink, canonical-path, repository-boundary, shared-store-plus-name — and changes only how values reach them.

**Apply to both copies.** The command is confirmed; the skill is latent and should not be left divergent.

**Record the general rule once**, in `command-instruction-release-pass-guide.md`: *a fenced block meant to be executed character-for-character may not contain tokens owned by the slash-command expander.* This defect class will otherwise recur in any future embedded script.

### Rejected shortcuts

- **Escaping `$1` as `\$1`.** Depends on the expander honouring an escape, which was not verified, and leaves the collision in place for the next editor to reintroduce.
- **Documenting "do not pass long arguments".** Moves a structural defect onto the operator, and the command's own input contract explicitly accepts a task id as an argument.
- **Fixing only the command copy.** Leaves the two mirrored surfaces divergent, which fact 7 of the 2026-08-09 report already flagged as a maintenance hazard in this same block.

## Falsifiable acceptance checks

A fix is accepted when all four hold:

1. `grep -nE '\$1|\$2' .claude/commands/work-loop-v2.md | grep -v ARGUMENTS` returns **nothing**, and the same for the skill copy.
2. `/work-loop-v2` invoked with a **multi-word** argument delivers the resolver with no substituted tokens, and the resolver returns the canonical core path.
3. `/work-loop-v2` invoked with a **single-token** argument still returns the same path — the positive control must not regress.
4. The resolver still rejects a checkout that fails the shared-store-plus-name test, proving the boundary logic was preserved rather than loosened to make the fix pass.

## Sources and evidence boundary

**Verified in this repository on 2026-08-10:** all line numbers and occurrence counts in facts 1 and 7; the diff of the two resolver regions; the fail-closed simulation in fact 5.

**Verified by direct observation during the invocation:** the corrupted block quoted in fact 2, and the intact block in fact 4.

**Not verified, and marked as such above:** Claude Code's documented substitution rules and the off-by-one in fact 3; whether the Codex skill route substitutes positionals; whether any argument can make the fact-6 containment check pass wrongly.

**Prior art.** `core-resolver-worktree-defect-report-2026-08-09.md` documents a different, unrelated defect in the same block one day earlier, whose fix — the shared-store-plus-name trust test — is present in the current source and is not implicated here. **Two independent defects in one embedded resolver in two days is itself the signal:** the block is long, security-bearing, duplicated across two files, and untested.
