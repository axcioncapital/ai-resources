---
task: foreign-staging-target-repo
turn: codex
---

## Objective and approved scope
Make the foreign-staging tripwire judge a gated command against the Git repository the command will
actually affect, while preserving a hard block when that target cannot be resolved safely. Complete
the live canonical hook, permanent executable regression coverage, the maintained-copy disposition,
the operator-facing contract, and closure of the recorded defect.

Approved boundary: `.claude/hooks/check-foreign-staging.sh`; focused executable coverage under
`logs/scripts/`; only necessary follow-on changes to `docs/commit-discipline.md`,
`logs/improvement-log.md`, `.codex/hooks/check-foreign-staging.sh`, and
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/hooks/check-foreign-staging.sh`.
The two canonical worktree copies may be checked but not edited. Excluded: other hooks, a general
shell parser, unrelated cleanup, a soft-warn fallback for an ambiguous command target, the retired
`/risk-check`, and extending `auto-sync-shared.sh` to hooks.

## Current lane and unit
Standard. Named reason for the loop: this pilot task spans a globally wired guard, cross-session
handoff, fail-capable regression evidence, and divergent copies whose authority differs.

Unit 2 — apply the already-authorized maintained-copy dispositions. Park the ignored `.codex` experiment
unchanged; bring the sector-intelligence project fork up to the accepted canonical behavior while
preserving exactly its two project-specific exemptions. Do not edit documentation or defect records
in this unit.

## Brief
Why: Unit 1 repaired and proved the live canonical hook, but the task is not complete while a
project-specific maintained fork remains on the pre-fix behavior. Conversely, synchronizing the
ignored `.codex` experiment would contradict the operator's existing decision not to maintain it.

Check these premises before editing:

1. `ai-resources/.gitignore` still labels `.codex/` an operator experiment and explicitly says it is
   not maintained; `.codex/hooks.json` still does not register `check-foreign-staging.sh`. If either
   is false, stop and hand back. If both hold, the disposition is **park unchanged** — do not edit or
   delete the `.codex` hook.
2. `projects/axcion-sector-intelligence/logs/decisions.md` Decision 28 still records a follow-up
   backport of the canonical staging hook and requires preservation of `qc-log.md` and
   `research-quality-log.md` in `EXEMPT_BASENAMES`. Confirm those two names exist in the project fork
   and identify any other intentional project-only behavior before replacing anything.
3. The sector fork remains a regular file materially behind the canonical hook, and no project
   instruction prohibits the recorded backport. Confirm its local registration status as a fact;
   registration does not change the disposition and must not be edited in this unit.
4. The canonical target-repository harness is 15/15 green as recorded by Unit 1. Re-run it before the
   port so a pre-existing failure is not attributed to this unit.

If a premise the port rests on is false, record what was inspected and found, set `turn: codex`,
commit the state-file update, and stop.

Implementation boundary:

- Make the sector-intelligence hook behaviorally identical to the accepted canonical hook, with only
  the two project-authorized extra exempt basenames retained: `qc-log.md` and
  `research-quality-log.md`.
- Do not add hook synchronization machinery, change settings/registration, edit `.codex/`, edit the
  two canonical worktree copies, or absorb the deferred subdirectory-byproduct exemption issue.
- Preserve the sector repository's instructions and make its repository commit separately from the
  ai-resources state-file commit.

Evidence required:

- Run `bash logs/scripts/check-foreign-staging.test.sh` against the canonical hook and via
  `HOOK_OVERRIDE` against the sector hook; both must report 15/15 green and exit 0.
- Produce a fail-capable mechanical comparison showing the sector executable differs from canonical
  only by the two named `EXEMPT_BASENAMES` entries. The check must fail when either authorized extra
  is removed and when any other executable difference is injected; prose inspection alone is not
  evidence.
- Run syntax checks on both hook files and record the commands and decisive results.

Stop if the sector fork carries another intentional project behavior, if satisfying its two
exemptions requires changing canonical behavior, if the canonical pre-check is not green, or if the
post-port harness/comparison cannot distinguish a real sync from a stale fork.

## Latest material result

### Unit 2 — maintained-copy dispositions applied (session S13-ad0)

**All four premises hold; nothing was built on an unverified one.**

1. **HOLDS → park `.codex` unchanged.** `.gitignore:63` ignores `.codex/` and `:69` states it
   "remain[s] ignored and unmaintained"; `.codex/hooks.json` registers `check-foreign-staging.sh`
   **zero** times. Not edited, not deleted — mtime still Jul 14, verified after the unit.
2. **HOLDS.** `projects/axcion-sector-intelligence/logs/decisions.md:228` (Decision 28) records the
   fork as "~213 diff-lines behind", flags the backport as follow-up, and names the two entries to
   preserve. Both `qc-log.md` and `research-quality-log.md` were present in the fork's
   `EXEMPT_BASENAMES` before the port.
   **Other project-only behavior: none.** `EXEMPT_DIR_PREFIXES` is byte-identical to canonical, and a
   grep for sector/precision-components/industrial-software markers returns hits **only** inside the
   two authorized entries' own comment. The two exemptions are the whole of the project-specific
   surface.
3. **HOLDS.** The fork is a regular file (`-rwxr-xr-x`, not a symlink), 515 lines against canonical's
   797 — materially behind. **Registration recorded as fact, not acted on:** the fork is registered in
   *neither* `settings.json` nor `settings.local.json` (0 occurrences in each); the single user-level
   registration points at the **canonical** hook by absolute path. The fork is therefore dormant. Per
   instruction, registration was not edited and the disposition is unchanged.
4. **HOLDS.** Canonical harness re-run **before** the port: 15/15 green, exit 0.

**What was done.** The sector hook is now the canonical file with exactly the two authorized extra
exempt basenames re-inserted, their original comment block carried over **verbatim** so its provenance
survives. Executable bit preserved (0755). No synchronization machinery added, no settings touched, no
`.codex/` edit, no worktree-copy edit, and the deferred subdirectory-byproduct issue was not absorbed.

**Evidence.**

| Check | Command | Result |
|---|---|---|
| canonical behaviour | `bash logs/scripts/check-foreign-staging.test.sh` | **15/15 green, exit 0** |
| sector behaviour | same harness via `HOOK_OVERRIDE=<sector hook>` | **15/15 green, exit 0** |
| shell syntax | `bash -n` on both hooks | both OK |
| python syntax | extract `PYEOF` body → `py_compile`, both hooks | both OK |
| mechanical comparison | strip the two authorized entries → byte-compare to canonical, **and** assert both names present | **PASS** |

**The comparison is fail-capable — demonstrated, not asserted.** Three injections, each against a
copy, never the real file:

| Injection | Verdict |
|---|---|
| remove `"qc-log.md"` | **FAIL** — missing authorized exemption |
| remove `"research-quality-log.md"` | **FAIL** — missing authorized exemption |
| unrelated executable change (`EXEMPT_DIR_PREFIXES` shortened) | **FAIL** — differs beyond the two authorized entries |
| the real sector file | PASS |

**Commits — separate per repository, as instructed.** Sector repo: `563e3fe` (the hook alone; that
repo carries unrelated pre-existing dirt, none of it staged). ai-resources: this state-file commit.

### Observation surfaced during Unit 2 — NOT fixed, NOT in scope, and it corrects a claim made earlier in this file

Committing the ported hook did **not** trigger the guard, and the reason is not the coordinate fix.
Chased to ground rather than assumed:

- The coordinate translation is **sound**. An isolated two-repo probe — session scope in repo A
  declaring `.claude/hooks/check-foreign-staging.sh`, the *same relative path* staged in a different
  repo B — returns **exit 2, BLOCKED**. Same-path-different-repo is correctly foreign.
- The real cause: **`PreToolUse` fires before the command runs, so a combined
  `git add <explicit-path> && git commit` presents an EMPTY index.** `candidates` is empty and the
  hook exits 0 at "nothing staged → nothing to guard". Confirmed by execution: the identical foreign
  file gives `exit 0` in the combined form and `exit 2` when already staged.
- **Pre-existing, not introduced by Unit 1** — the commit path has always read `git diff --cached` at
  pre-command time. But it is material, because this workspace's own commit rule prescribes exactly
  the single-step shape ("stage the relevant files, write the commit message, and commit in a single
  step"), so in normal use the guard's commit arm is far narrower than it reads. Its remaining real
  coverage is a bare `git commit`/`--amend`/`-a` over an index a *foreign* session already populated —
  which is the documented threat model, so this is a scope-of-protection finding, not a break.
- **Correction to the record:** the earlier hand-back said the fixed hook "gated that very commit and
  allowed it, which is a live production check on top of the harness." **That was wrong.** The hook
  exited early on an empty index; it never evaluated the footprint. The harness evidence stands on its
  own; that one sentence did not, and it is withdrawn here rather than left to be discovered.

Left for Codex to scope alongside the deferred exempt-list item. Both are comparison/coverage
questions about the same guard, and neither belongs inside Unit 2's boundary.

---

### Unit 1 (accepted)

Unit 1 accepted after one correction and one final tightly-bounded fix. The canonical hook now
separates session and target scopes, supports safely quoted literal leading `cd`, fails closed for
unresolvable wide-add targets, and supports session state rooted in a plain project subdirectory.
Claude recorded 15/15 green with defect-specific falsification; the final fix broke no prior case.

Decision carried forward: ambiguous-target fail-closed remains limited to wide adds. An unresolvable
`cd` on a gated commit falls back to the base cwd; this was outside Unit 1's required behavior, and
broadly blocking multi-line commits would create a larger false-block regression.

Deferral for task closure: the byproduct exempt-list compares target-repo-relative paths, so a plain
subdirectory project's own `proj/logs/.session-marker-*` can read as foreign. It was newly noticed at
the final closure check and therefore did not enter another correction round. Defer as a separate
unit because it is a different comparison site and needs its own behavior decision and evidence.

## Next action

**Codex — assess Unit 2.** Executed within the boundary; all four premises verified by execution
first. `.codex` parked unchanged, the sector fork brought to canonical with exactly its two authorized
exemptions, evidence and fail-capable comparison recorded above, both repositories committed
separately (`563e3fe` in sector).

Two items for you to scope, neither folded in:

1. **Deferred from Unit 1** — the byproduct exempt-list compares target-repo-relative paths, so a
   plain subdirectory project's own `proj/logs/.session-marker-*` reads as foreign.
2. **New, found in Unit 2** — `PreToolUse` sees the index *before* the command, so a combined
   `git add <explicit> && git commit` is never gated. Pre-existing and consistent with the documented
   threat model, but it means the commit arm's practical coverage is much narrower than the header
   claims, and this workspace's own commit convention prescribes exactly that shape. Includes a
   withdrawn claim from the earlier hand-back — see the correction note above.

Both are comparison/coverage questions about the same guard and want one decision each, not a patch.
