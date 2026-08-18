# Why Work Loop v2 keeps stopping at Step 0

**Date:** 2026-08-18  
**Status:** Diagnosis and durable-patch recommendation; no production fix applied  
**Symptom:** `/work-loop-v2` stops before reading the task because
`work-loop-capability.sh` reports `INCOMPLETE`, commonly naming the compact-recovery hook.

## Executive conclusion

Step 0 is not the defect. It is correctly detecting that a checkout exposes the Work Loop command
without carrying the complete five-part capability needed to finish a task safely.

The repeated symptom currently has **two different causes**:

1. **The Unit 4 disposable case deliberately broke its own deployment.** Commit `d99e7eda` removed
   the one `SessionStart` / `compact` registration from `.codex/hooks.json` so the operator prompt
   would be the only recovery trigger. That made the checkout intentionally fail the same capability
   gate that `/work-loop-v2` must pass before it can execute the later rollover unit. Commit
   `208ec67a` restored the exact 11-line block and returned the checkout to `READY`.
2. **Many existing worktrees predate the atomic Work Loop capability bundle.** The command is a
   shared symlink and can appear in an old checkout at session start, while the validator, owner
   helper, Reorient skill, compact hook registration and ignore rule are branch content or explicit
   deployment additions. The old checkout therefore looks Work-Loop-enabled but is structurally
   incomplete.

The second cause explains why this feels constant: repairing one checkout with `/sync-workflow`
does not update the other old worktrees. The same gate is encountered again in the next stale
checkout.

The recommended durable patch is therefore **not** to weaken Step 0 or special-case a missing hook.
It is:

- keep every execution checkout capability-complete, including test checkouts;
- simulate “no hook delivery” at the test transport boundary instead of deleting deployment;
- add a capability preflight to worktree creation before the new window opens; and
- do one controlled cleanup or forward-sync of the existing stale worktree fleet.

## The exact incident

### What created the failure

The prepared Unit 4 fixture commit says what it did:

> The compact hook registration is removed from THIS checkout only, so the operator prompt is the
> sole recovery trigger the case supplies.

Its only deletion from `.codex/hooks.json` was this component:

- event: `SessionStart`;
- matcher: `compact`;
- command: `work-loop-reorient.sh`;
- size: 11 JSON lines.

The hook script itself remained present. That is why the checker accurately reported “the script is
installed but never registered.”

### Deterministic reproduction

The committed `d99e7eda` tree was replayed into an isolated temporary Git repository and checked
against canonical `ai-resources`:

```text
verdict: INCOMPLETE
missing: compact-recovery-hook — .codex/hooks/work-loop-reorient.sh is present but
.codex/hooks.json has no SessionStart entry with matcher "compact" that runs it.
repro_exit=3
```

This is a tight reproduction of the operator-supplied Step 0 output. No other capability component
was removed.

Restoring only that registration in `208ec67a` makes the same checker return:

```text
verdict: READY
reason: all five Work Loop v2 components are present, and every copied component is byte-identical
to canonical ai-resources.
```

### Why `/sync-workflow` appeared to be the fix

`/sync-workflow` is the documented repair because the registration is a merge-only addition to a
checkout-owned `.codex/hooks.json`. It adds the missing entry without overwriting other hooks.

That advice is correct for accidental deployment drift. In this case it also undid the fixture's
intentional degradation. It fixed the Step 0 symptom while invalidating the fixture's original
“registration absent” control. The conflict was in the test design, not in the checker.

## Why the problem recurs across worktrees

### The capability arrived after many worktrees already existed

The five components were introduced across several commits:

| Date | Commit | Addition |
|---|---|---|
| 2026-08-08 | `42f3d7fd` | compact hook and registration |
| 2026-08-11 | `f74bd5da` | Codex Reorient skill |
| 2026-08-14 | `bc5e9add` | shared state validator |
| 2026-08-16 | `e2823253` | atomic five-component deployment check and Step 0 gate |

`e2823253` deliberately excluded deploying the bundle to every existing checkout. It made partial
deployment visible; it did not rewrite historical branches or worktrees.

### Current fleet evidence

A read-only scan of registered, existing worktrees that expose `.claude/commands/work-loop-v2.md`
found:

- **21 applicable worktrees**;
- **6 READY**;
- **15 INCOMPLETE**.

The correlation is exact in this scan:

- all 6 READY worktrees contain `e2823253` in their ancestry;
- all 15 INCOMPLETE worktrees do not.

The oldest Codex-managed detached worktrees, dated 2026-08-02 through 2026-08-09, generally lack all
five components. Several August 14–15 branches have only the later validator/owner-helper gap. This
is branch age, not intermittent behavior.

### Why the command can be present when its capability is not

Work Loop v2 travels through several independent deployment paths:

| Component | How it arrives |
|---|---|
| `/work-loop-v2` command | generic SessionStart shared-command symlink sweep |
| state validator | tracked/template-deployed file |
| owner helper | tracked/template-deployed file |
| Reorient skill | manifest opt-in plus generated symlink |
| compact recovery | hook script plus checkout-owned `hooks.json` registration |
| owner declaration ignore rule | checkout `.gitignore` addition |

The generic sweep intentionally remains fail-open. It can install the shared command into an old
checkout, then only warn that the rest of the capability is incomplete. It does not update tracked
branch files or merge checkout-owned JSON and ignore rules.

That design creates the recurring user experience:

1. open an old checkout;
2. SessionStart exposes the current shared Work Loop command;
3. invoke it;
4. the current command runs its current Step 0 checker;
5. the old checkout fails because its branch never received the other components;
6. sync one checkout;
7. encounter the same condition later in another old checkout.

The checker is turning a previously silent partial deployment into a visible stop. The visible stop
is repetitive because the stale fleet is repetitive.

## Hypotheses tested

### 1. The no-hook Unit 4 fixture collided with the unconditional capability gate — confirmed

Evidence:

- `d99e7eda` deliberately deleted the exact registration Step 0 requires;
- the isolated replay deterministically returns exit 3;
- restoring only those 11 lines returns `READY`;
- the approved Unit 4 evidence record explicitly says the registration was removed.

### 2. Old worktrees preserve pre-bundle deployment state — confirmed

Evidence:

- 15/21 applicable worktrees are incomplete;
- every incomplete worktree lacks `e2823253` ancestry;
- every ready worktree contains it;
- the missing-component patterns match the dates on which individual bundle parts landed.

### 3. `/sync-workflow` repairs one checkout but does not prevent future stale-checkout failures — confirmed

Evidence:

- the disposable checkout became `READY` after its registration was restored;
- the remaining old worktrees stayed incomplete;
- worktrees are independent working directories at independent commits, so one checkout's merge-only
  JSON addition does not rewrite another's branch.

### 4. The current sync merger is dropping the compact entry — not supported

Evidence:

- `work-loop-capability.test.sh` passes **81/0**;
- its merge fixture preserves an existing project hook while adding the compact entry;
- the canonical checkout and current synced checkouts return `READY`;
- no observed failing checkout contains `e2823253` and then loses the entry accidentally—the Unit 4
  checkout lost it through an explicit fixture commit.

There is still an instruction-borne risk because `/sync-workflow` is a command document executed by
an agent, not a single transactional merger binary. That is a possible hardening target, but it is
not the cause established here.

## Why Step 0 should remain strict

Starting a unit in an incomplete checkout can leave an active task that cannot survive compaction,
cannot validate lifecycle, or cannot enforce checkout ownership. The stop occurs before the task is
read or edited so the checkout is not left half-open.

Weakening the rule for the compact hook would create a special state in which:

- the command reports itself usable;
- the recovery script exists and looks installed;
- no event can invoke it; and
- a later compaction silently loses the recovery cue.

That is the precise false-green the checker was built to prevent. An `--ignore-missing-hook` flag or
hand-patched bypass would turn a deterministic safety property into caller judgment and should not
be the durable patch.

## Recommended durable patch

### Patch 1 — separate test stimulus from deployment state

Do not create a “no-hook” control by deleting a capability component from the same checkout that
must later run `/work-loop-v2`.

For the Unit 4 case:

- keep `.codex/hooks.json` fully registered and keep Step 0 `READY`;
- make the operator prompt—not a compaction event—the recovery trigger;
- prove that the chosen test transport did not deliver a compact-hook event;
- keep the no-hook negative control in an isolated preflight fixture that never executes a real Work
  Loop unit; and
- assert `work-loop-capability.sh ... --canonical ...` returns `READY` immediately before the real
  Claude rollover begins.

The property under test is “explicit `$realign` / `$reorient` recovers without help from a hook,” not
“the execution checkout is partially deployed.” Those are different conditions and should no longer
be represented by the same missing JSON entry.

### Patch 2 — preflight new worktrees before opening them

Add one read-only post-create check to `/new-worktree-session` after `git worktree add` and before the
new VS Code window opens:

1. if the new checkout does not expose Work Loop, continue normally;
2. if it exposes Work Loop and the capability is `READY`, open it;
3. if it is `INCOMPLETE`, do not present it as ready for Work Loop work—name the components and
   require either a current base or an explicit `/sync-workflow` pass.

The default base is current `main`, so new ordinary worktrees are already safe today. This check
protects named historical bases, long-lived branches and future bundle migrations.

Apply the same principle wherever Codex-managed worktrees can be created from a selected old commit:
the selected base must be capability-complete before a Work Loop task is admitted there.

### Patch 3 — perform a one-time stale-worktree disposition

The existing 15 incomplete worktrees will keep recreating the symptom until they are handled.

For each one:

- remove it through the guarded cleanup command if it is obsolete;
- if active, integrate the capability-bundle commit or run `/sync-workflow`, review the merge-only
  additions, and commit them on that branch;
- do not batch-overwrite `.codex/hooks.json`, `.gitignore` or the shared manifest; and
- re-run the capability checker with `--canonical` before calling the checkout ready.

This should be an explicit inventory pass, not an automatic rewrite of every worktree. Several
worktrees are historical or disposable, and branch-specific hook/manifest content must be preserved.

### Patch 4 — make capability exposure atomic in the shared-command sweep

Longer term, the generic auto-sync path should not make `/work-loop-v2` look available in a checkout
that cannot pass its prerequisites.

The clean design is conditional exposure:

- inspect the five prerequisite components independently of command presence;
- expose/symlink `/work-loop-v2` only when the bundle is complete;
- otherwise report “Work Loop unavailable: sync required,” rather than symlinking a command that is
  guaranteed to stop; and
- add no registry or persistent deployment state—the live checkout remains the evidence.

This needs a separate design pass because current applicability is defined by command presence and
the sweep currently promises to symlink every shared command. It is not required to repair the Unit
4 case or clean the stale fleet, but it closes the architectural source of “command visible,
capability absent.”

### Optional hardening — make merge-only sync executable

If the same hook-registration loss is later observed in a checkout that already contains
`e2823253` and was not deliberately modified, replace instruction-borne JSON merging with one small,
idempotent helper that:

- adds exactly one `SessionStart` / `compact` entry;
- preserves every unrelated hook;
- refuses invalid JSON;
- is exercised by the existing preservation sentinels; and
- is called by both deploy and sync.

Current evidence does not justify this as the first patch. The 81/0 suite and the observed histories
point to stale bases and the deliberate fixture, not a broken merger.

## Acceptance tests for the durable patch

The patch is complete when all of these can fail and pass for the intended reason:

1. A new worktree from current `main` is `READY` before its window opens.
2. A worktree deliberately based before `e2823253` is refused as Work-Loop-ready before any task is
   opened.
3. The representative no-hook recovery case keeps the execution checkout `READY` while proving no
   compact-hook event supplied the recovery prompt.
4. Removing only the registration still makes the capability checker return exit 3.
5. Syncing an incomplete fixture reaches `READY` without deleting an existing project hook,
   manifest entry or ignore rule.
6. The active-worktree inventory contains no `INCOMPLETE` checkout that is still intended for Work
   Loop work.
7. `work-loop-capability.test.sh` remains green (currently 81/0), together with the Work Loop entry,
   recovery and rollover regressions.

## Immediate disposition

- The disposable Unit 4 checkout currently returns `READY`; do not sync it again merely because of
  the earlier report.
- Treat `d99e7eda`'s absent registration as a superseded fixture mechanism, not as evidence of a
  production deployment bug.
- Continue the live case only from a `READY` checkout.
- Schedule the stale-worktree inventory before using Work Loop in another older branch; otherwise
  the same correct Step 0 stop will recur.

## Bottom line

You keep seeing the message because the system now detects partial deployment correctly, while many
old worktrees still carry partial deployment—and this particular test deliberately recreated it.

The durable fix is to make **checkout creation and test setup preserve capability completeness**, not
to teach Work Loop to proceed without recovery. Clean the existing stale fleet once, gate future
worktrees before opening, and represent “no hook delivery” as a transport condition rather than a
broken `.codex/hooks.json`.
