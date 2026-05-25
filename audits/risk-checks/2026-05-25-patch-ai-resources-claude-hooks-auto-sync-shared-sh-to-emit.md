# Risk Check — 2026-05-25

## Change

Patch ai-resources/.claude/hooks/auto-sync-shared.sh to emit relative-path symlinks instead of absolute-path symlinks.

**Proposed change:** At lines 80 and 93 (the `ln -s "$src" "$target"` calls in the commands-sync and agents-sync loops), compute the relative path from the target's parent directory to `$src` before linking. Concrete patch shape:

```bash
# BEFORE (line 80, line 93):
ln -s "$src" "$target"

# AFTER:
rel_src=$(python3 -c "import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$src" "$(dirname "$target")")
ln -s "$rel_src" "$target"
```

(`realpath --relative-to` would be cleaner but is GNU-only; Python's `os.path.relpath` is portable on macOS where this workspace lives.)

**Motivation:** repo-dd C1.3 finding. The current script produces absolute-path symlinks for every newly synced file in every project on the workspace. Absolute-path symlinks break if the workspace directory is relocated. The fix is workspace-wide leverage — every project benefits, every future sync benefits.

**Blast radius / who is affected:**
- This hook runs at SessionStart in every project that has `.claude/shared-manifest.json` (i.e., every project under the workspace using the shared-resource model).
- The hook only creates NEW symlinks for files that don't yet exist at the target — it does not overwrite existing symlinks (line 78, 91: `[ -e "$target" ] || [ -L "$target" ] && continue`). So pre-existing absolute symlinks in projects (76 already exist relative + 6 cleaned up in today's earlier session) are untouched. Only NEW shared files added to ai-resources going forward emit symlinks under the new code path.
- Existing functionality preserved: idempotency, drift-detection, manifest-honoring exclusions — none affected by the patch.

**What I have ruled out:**
- Not changing the symlink target paths in existing projects. Not running a cleanup pass. Only the emission code path changes.
- Not removing or reordering any existing logic. Pure substitution at two lines.

**Open questions for /risk-check:**
- Is `python3` reliably present on the operator's macOS environment? (Default on modern macOS, yes. But hooks are SessionStart-blocking with a 10s timeout — if python3 is absent, the hook fails silently or terminates the loop.)
- Should the patch include a fallback (e.g., test for python3 then fall back to absolute paths with a warning) or fail loudly? My instinct is fail loudly because silent fallback would mask the drift the patch is supposed to fix.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The patch is mechanically isolated (two-line substitution in a SessionStart hook) and aligns with prior art (`/fix-symlinks` already uses `os.path.relpath`), but it adds a new latent dependency on `python3` inside a hook that fires at SessionStart across ~14 projects and one workflow template; the hook's silent-failure mode under a missing `python3` is the load-bearing concern that requires explicit mitigation.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook only emits a SessionStart `additionalContext` message when at least one file is newly synced or drifted (auto-sync-shared.sh:122–134, gated by `if [ -n "$synced" ] || [ -n "$drifted" ]`). The patch does not change the output shape or volume — same status message format.
- No new always-loaded content. No `@import` chain. No new subagent or skill auto-trigger surface.
- Per-invocation overhead is one extra `python3 -c …` subprocess per newly created symlink. On steady-state sessions (no new ai-resources files since last open), the for-loops at lines 72 and 85 skip every target via the `[ -e ] || [ -L ] && continue` guard at lines 78 / 91, so no python invocation fires at all. Worst case (a wave of new shared files in ai-resources) is bounded by the number of new files and is one-time per project.
- Token cost to chat context: unchanged. The hook's stdout JSON is identical in shape.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` permission entries added or modified.
- The script already had implicit access to `bash`, `jq`, `ln`, `diff`, `basename`, `dirname` via the SessionStart shell. Adding `python3` as an additional binary call is within the existing implicit-shell-access posture — no new allow/deny entries needed.
- Scope of writes is unchanged: still only creates symlinks under `$PROJECT_DIR/.claude/commands/` and `$PROJECT_DIR/.claude/agents/` (auto-sync-shared.sh:79, 92 `mkdir -p`; :80, :93 `ln -s`).

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 1 (`auto-sync-shared.sh`).
- Hook invocation surface (grep `auto-sync-shared` across `projects/`, `ai-resources/workflows/`, and ancestor `.claude/settings.json`): the upward-walk SessionStart launcher is registered in at least 14 distinct settings.json files. Verified callers found:
  - `projects/buy-side-service-plan/.claude/settings.json` (line 81)
  - `projects/personal/travel-os/.claude/settings.json` (line 42)
  - `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (line 161)
  - Plus 11+ other project `.claude/settings.json` files enumerated under the workspace (`projects/axcion-brand-book`, `projects/interpersonal-communication`, `projects/axcion-ai-system-owner`, `projects/global-macro-analysis`, `projects/corporate-identity`, `projects/ai-development-lab`, `projects/project-planning`, `projects/obsidian-pe-kb`, `projects/repo-documentation`, plus vault subprojects and `knowledge-bases/pe-kb-vault`).
  - Workflow template: `ai-resources/workflows/research-workflow/.claude/settings.json` (deployed into future projects via `/deploy-workflow`).
- Contract: the on-disk symlink-target path string. Existing absolute-path symlinks are not touched (the `continue` guard at lines 78 / 91 already protects them), so no caller needs to be rewritten. The new emission shape (relative-path target) is read by:
  - Claude itself when traversing `.claude/commands/` (no contract concern — Claude resolves symlinks transparently).
  - `/fix-symlinks` (already emits relative-path repairs via `os.path.relpath` at fix-symlinks.md:115). Aligned, not breaking.
  - `repo-dd` and audit tooling that may report symlink-target paths verbatim — reports going forward will mix absolute (legacy) and relative (new) target strings until a workspace-wide cleanup. This is cosmetic / inventory only, not a functional break.
- Drift-detection branch (auto-sync-shared.sh:97–120) is untouched.
- No caller requires modification to keep working. Backwards-compatible.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file `git revert` fully restores prior emission behavior.
- Any new relative-path symlinks created under the new code path survive the revert without functional regression — they continue to resolve to the same canonical files. A subsequent SessionStart under the reverted hook would emit absolute paths for any further new files, mirroring the pre-patch posture. No mixed state on disk causes a fault.
- No external writes (no `git push`, no Notion, no API calls).
- No state propagates beyond the local repo.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New implicit dependency on `python3`.** The hook previously used only `bash`, `jq`, `ln`, `basename`, `dirname`, `diff` — all POSIX-ish or already-required tools. Adding `python3` as an inline call adds an unstated host-environment requirement. The CHANGE_DESCRIPTION itself flags this ("Is `python3` reliably present on the operator's macOS environment?"). Verified locally at `/Library/Frameworks/Python.framework/Versions/3.14/bin/python3` — present on this machine. But the hook is invoked under the SessionStart shell environment, whose `PATH` is set by Claude Code, not by the operator's interactive shell. If that PATH excludes Python (or if a future macOS removes the system stub), `python3 -c …` returns a non-zero exit and an empty `rel_src` — and `ln -s "" "$target"` creates a broken zero-byte-target symlink. The hook does not check the exit status (no `set -e`, no explicit `|| { … }` guard).
- **Silent-failure failure mode.** If `python3` is absent or fails, `$(…)` substitution yields empty string; `ln -s "" "$target"` succeeds at the syscall level (creates a symlink whose target is the empty string), producing a broken symlink that the next SessionStart will skip via the `[ -e ] || [ -L ] && continue` guard (line 78 / 91) — meaning a single bad session permanently poisons a target name and prevents the next session from auto-healing. The CHANGE_DESCRIPTION proposes "fail loudly" but the patch shape as written ("AFTER:" block) does not fail loudly — it uses unguarded command substitution.
- **Cross-script alignment is favorable but not enforced.** `/fix-symlinks` already emits relative-path symlinks (fix-symlinks.md:115 `rel = os.path.relpath(matches[0], link_dir)`). The patch brings the SessionStart hook into the same convention. This is consistent prior art (Dimension 5 plus), but no central documentation declares "relative-path symlinks" as a contract — the convention is implicit across two scripts.
- **Hook ordering / overlap concern: none.** `check-template-drift.sh` uses a distinct prefix ("Template drift detected:") and operates on a different target tree, per the explanatory comment at auto-sync-shared.sh:20–23. No overlap.

## Mitigations

- **Dimension 5 (`python3` silent-failure):** Replace the bare `rel_src=$(python3 …)` with an explicit guard. Suggested shape:
  ```bash
  if ! rel_src=$(python3 -c "import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"auto-sync-shared.sh: python3 unavailable or relpath failed; skipping symlink emission for ${name}.md\"}}"
    continue
  fi
  ln -s "$rel_src" "$target"
  ```
  This fails the per-file loop iteration (so the next session can re-try) instead of writing a broken empty-target symlink that the idempotency guard would then permanently skip.
- **Dimension 3 (blast radius / convention is implicit):** Add a one-line comment near each `ln -s` call documenting that emission is relative-path by convention (matches `/fix-symlinks` repairs). Cheap; raises the contract from implicit to explicit at the change site.
- **Optional verification step (recommended, not strictly required):** After landing, open one fresh session in a project where `shared-manifest.json` exists and confirm the SessionStart hook output reports no errors and no broken symlinks were emitted. Trigger a new symlink by adding a throwaway file under `ai-resources/.claude/commands/` (then remove it) or rely on the next genuine command addition.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### Routing position

The change lands at `ai-resources/.claude/hooks/auto-sync-shared.sh`, the canonical home for ai-resources hooks (`repo-architecture.md § Canonical homes — Hook` and `principles.md § DR-3`). It is a Q5 structural change class (hook edit) and correctly went through `/risk-check` per `principles.md § DR-8`. Routing is not in dispute — the question is whether the patch shape and mitigations are right.

### Architectural commentary

**We concur with PROCEED-WITH-CAUTION, and the mitigation set is necessary but incomplete.** Three reasons to concur:

1. **The patch aligns the hook with the documented contract.** `repo-architecture.md § Symlink topology rule 5` already declares the convention ("Symlinks are relative"). The current implementation violates the documented architecture — the patch closes a written-vs-actual drift, which `principles.md § OP-11` explicitly identifies as a recurring obligation ("when practice diverges from written principles … the divergence must be surfaced explicitly. Either the practice is corrected to match the principle, or the principle is revised"). Correcting practice is the right resolution direction here.

2. **`auto-sync-shared.sh` is on the Critical load-bearing list.** `risk-topology.md § 1 — Critical` names it explicitly ("Distributes commands/agents to all projects | All project sessions lose access to shared resources"). A silent-failure mode in this hook degrades every project session simultaneously — the caution posture is warranted, not theatrical.

3. **The silent-failure concern is the load-bearing risk, and the mitigation as drafted addresses it correctly.** `principles.md § OP-3` ("loud failure over silent continuation") is the governing principle. The Dimension 5 finding — `ln -s ""` succeeds at the syscall level and the idempotency guard then permanently skips the poisoned target — is the textbook OP-3 violation: a plausible-looking sync run that has silently broken the project. The guarded `if ! rel_src=… || [ -z "$rel_src" ]; then … continue` mitigation converts the silent failure into an `additionalContext` warning that surfaces in chat. That is the right shape.

### Downstream impact

Per `risk-topology.md § 2 — Shared infrastructure → projects`, the reverse map names `auto-sync-shared.sh → All 7 projects`. The risk-check verifies the actual surface is ~14 settings.json files plus the research-workflow template — wider than the risk-topology table records. **This is itself a drift signal:** `risk-topology.md` undercounts the blast radius. We flag it for the next risk-topology refresh, but it does not change the verdict on this patch.

The new on-disk emission shape (relative paths) coexists with legacy absolute-path symlinks (76 already relative + 6 cleaned earlier today, per the report). Mixed inventory until cleanup is cosmetic — no caller breaks. `/fix-symlinks` already emits relative paths (`os.path.relpath` per fix-symlinks.md:115), so the corrective tool exists when a workspace-wide cleanup is decided.

### Risk the dimension review missed

**Missed risk — DR-9 top-3 command analysis was not performed.** `principles.md § DR-9` and `risk-topology.md § 4 — Change process` both state hook edits derived from audit findings require top-3 command analysis. The change originates from repo-dd C1.3 — an audit finding — yet the risk-check report enumerates affected settings.json files (Dimension 3) without enumerating which top-3 commands or workflows depend on the synced symlink emission and confirming the new emission shape doesn't degrade them. The omission is mild here because Claude resolves symlinks transparently and `/fix-symlinks` is already aligned, but **the analysis was skipped, not satisfied.** Run DR-9 before commit: name the top-3 commands most affected by the symlink emission shape (candidates: `/permission-sweep`, `/fix-symlinks`, `/audit-repo` symlink-inventory reporting) and confirm no caller depends on absolute-path target strings verbatim. The Dimension 3 analysis already covered `/fix-symlinks` and audit tooling reporting — completing it formally as DR-9 closes the gate.

**Missed risk — the patch is auto-detected innovation territory.** `detect-innovation.sh` (PostToolUse) logs hook edits to `innovation-registry.md` (`system-doc.md § 4.4`). The patch will land in the Friday innovation triage queue automatically. The risk-check is silent on this — not a functional concern, but worth knowing the change is tracked downstream without operator effort. No action required; cited for completeness.

### Position

**The right answer is: apply the patch with all three stated mitigations, plus a formal DR-9 top-3 command analysis recorded in the commit message.** The mitigations as drafted are correct in shape and substance — particularly the guarded `python3 -c` call, which is the load-bearing fix. Add the one-line `ln -s` site comments to convert the relative-path convention from implicit cross-script alignment into an explicit at-the-change-site contract (`principles.md § OP-3` — loud over silent). Run the post-land verification in one fresh session under a project with `shared-manifest.json` — this is the cheapest closure for `principles.md § QS-3` (verify against requirements before announcing complete).

**Do not downgrade the verdict to GO.** The patch is mechanically isolated but the failure mode is the kind that compounds invisibly across 14 settings.json files, which is exactly what PROCEED-WITH-CAUTION is for. `principles.md § DR-8` explicitly prohibits downgrading the verdict to push a change through.

### Reference paths cited

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/principles/principles.md` (OP-3, OP-11, DR-3, DR-8, DR-9, QS-3)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md` (§ 1 Critical, § 2 reverse map, § 4 Change process)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` (§ Symlink topology rule 5, § Canonical homes, Q5)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-25-patch-ai-resources-claude-hooks-auto-sync-shared-sh-to-emit.md` (subject report)
