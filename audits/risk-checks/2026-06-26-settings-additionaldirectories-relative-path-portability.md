# Risk Check — 2026-06-26

## Change

Make tracked Claude Code settings.json files machine-portable: replace the single absolute workspace-root path in each file's `permissions.additionalDirectories` array with a launch-dir-relative path. Scope this session: Group 1 = 9 files (7 project-level `.claude/settings.json` using depth `../..`, plus 2 submodule vaults `projects/repo-documentation/vault` and `projects/axcion-ai-system-owner/vault` using `../../..`), carrying Patrik's path `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. Group 2 = 2 knowledge-base submodules (`projects/interpersonal-communication/knowledge-base`, `projects/interpersonal-communication-copy/knowledge-base`) carrying Daniel's path `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo`, depth `../../..`. Change is config-only (only the additionalDirectories string in each file's permissions block), no permission allow/deny semantics changed, no hooks changed, no env changed. Out of scope: Group 3 (the two inert Edit()/Write() permission globs in `ai-resources/.claude/settings.json`, blocked on Patrik) and `audits/working/` throwaway copies. The relative-path form was verified portable on 2026-06-25 per Claude Code docs (additionalDirectories relative paths resolve against the launch dir; `../..` from a `projects/<name>/` repo reaches the workspace root; `../../..` from a `projects/<name>/vault/` or `projects/<name>/knowledge-base/` submodule reaches the workspace root). Commits are per-repo, staged verify-first; submodule edits commit in the submodule repo then bump the parent pointer; all pushes operator-gated. Part of the settings-path-portability mission (mission contract at ai-resources/logs/missions/settings-path-portability.md).

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/project-planning/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/brand-book/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/strategic-os/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/market-positioning/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/repo-documentation/vault/.claude/settings.json — exists (submodule)
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/vault/.claude/settings.json — exists (submodule)
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/interpersonal-communication/knowledge-base/.claude/settings.json — exists (submodule)
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/interpersonal-communication-copy/knowledge-base/.claude/settings.json — exists (submodule)

## Verdict

RECONSIDER

**Summary:** The change directly contradicts the canonical `permission-template.md` design decision (tracked `additionalDirectories` must be removed and the grant relocated to gitignored `settings.local.json`, not made relative-and-tracked) AND its core portability premise is contradicted by the canonical `/new-project` scaffold note ("Claude Code resolves `additionalDirectories` relative to session CWD, which varies by how the project is opened") — an unresolved technical conflict that could silently break cross-repo `ai-resources/` visibility if the relative form does not resolve in every launch context.

## Consumer Inventory

The 1105 raw `additionalDirectories` grep hits are overwhelmingly **documentary** (audit reports, session notes, scratchpads, decisions logs) — they record the path, they do not functionally consume it. The functional/contract consumers are below.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/nordic-pe-screening-project/.claude/settings.json | co-edits (G1 target, consumed by Claude Code at launch) | yes |
| projects/project-planning/.claude/settings.json | co-edits (G1 target) | yes |
| projects/brand-book/.claude/settings.json | co-edits (G1 target) | yes |
| projects/strategic-os/.claude/settings.json | co-edits (G1 target) | yes |
| projects/market-positioning/.claude/settings.json | co-edits (G1 target) | yes |
| projects/repo-documentation/.claude/settings.json | co-edits (G1 target) | yes |
| projects/axcion-ai-system-owner/.claude/settings.json | co-edits (G1 target) | yes |
| projects/repo-documentation/vault/.claude/settings.json | co-edits (G1 submodule target) | yes |
| projects/axcion-ai-system-owner/vault/.claude/settings.json | co-edits (G1 submodule target) | yes |
| projects/interpersonal-communication/knowledge-base/.claude/settings.json | co-edits (G2 submodule target) | yes |
| projects/interpersonal-communication-copy/knowledge-base/.claude/settings.json | co-edits (G2 submodule target) | yes |
| ai-resources/docs/permission-template.md | documents (canonical contract for the `additionalDirectories` home; states tracked-file should carry NO `additionalDirectories`, abs-path-in-local instead) | yes (contract conflict — see D5/D6) |
| ai-resources/.claude/commands/new-project.md | documents + scaffolds (emits `additionalDirectories`; explicitly prescribes ABSOLUTE not relative, lines 265/377/397) | yes (scaffold still re-introduces the defect / contradicts the form) |
| ai-resources/.claude/agents/permission-sweep-auditor.md | parses (Detection Rule 8 / value-class signal reads `additionalDirectories` path-type field) | no (advisory detector; flags the field, does not break) |
| Two parent repos (repo-documentation, axcion-ai-system-owner) | co-edits (submodule pointer bump after vault edit) | yes (pointer commit required) |
| Two parent repos (interpersonal-communication, -copy) | co-edits (submodule pointer bump after knowledge-base edit) | yes (pointer commit required) |

Total: 17 distinct consumers, ~15 must-change (11 settings files edited directly; ~4 parent-repo pointer bumps; permission-template.md and new-project.md must change for the change to be consistent with the canonical contract). The 1105 documentary hits are not counted as functional consumers. **Two consumers not named in CHANGE_DESCRIPTION:** `permission-template.md` (canonical contract that prescribes the opposite home) and `new-project.md` (scaffold that prescribes the opposite form) — both surfaced by the inventory and both drive the verdict.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Config-only string swap inside an already-present `permissions.additionalDirectories` array; no content added to any always-loaded CLAUDE.md, no new hook, no new `@import`, no new skill/subagent. Evidence: all 11 referenced settings files already contain the `additionalDirectories` key (e.g. strategic-os settings.json:50–52; repo-documentation/vault settings.json:29–31) — the change replaces one string value, net token delta ≈ 0.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The change does NOT touch any `allow`/`deny` entry — CHANGE_DESCRIPTION asserts "no permission allow/deny semantics changed," confirmed by inspection (the edit is scoped to the `additionalDirectories` string only). On that axis: Low.
- But `additionalDirectories` IS a permission-surface field: it controls which directories outside the project root a session may read/write. Replacing an absolute grant that resolves to a fixed path with a relative grant whose resolution depends on launch CWD can **silently narrow or void** the grant if the relative form fails to resolve. This is not a widening — it is a potential *unintended narrowing/breakage* of an existing cross-repo grant. The mission's own acceptance contract requires the form be "confirmed to resolve on Daniel's machine" (mission file:45) — i.e., per-machine confirmation is still required, which concedes resolution is not guaranteed by form alone.
- Net: no widening, but a real risk of silent narrowing of an existing capability → Medium.

### Dimension 3: Blast Radius
**Risk:** High

- From the Step 1.5 inventory: 17 distinct consumers, ~15 must-change. Eleven tracked settings files edited directly across **at least 8 distinct git repos** (the workspace repo + 4 submodules + 2 vault submodules), each requiring a per-repo commit; 4 of those are submodules requiring a parent-repo pointer bump after the submodule commit (CHANGE_DESCRIPTION: "submodule edits commit in the submodule repo then bump the parent pointer").
- Contract change touching a field two canonical resources depend on: `permission-template.md` (the authoritative home-of-record for `additionalDirectories`) and `new-project.md` (the scaffold that emits it). The change introduces a *third* form (tracked + relative) that neither canonical resource currently sanctions — `permission-template.md:185` says tracked files should carry NO `additionalDirectories`; `new-project.md:377` says the grant must be ABSOLUTE. Leaving both unchanged means the repo's canonical docs and its live config disagree.
- Submodule pointer-bump blast radius: each of the 4 submodule edits is a two-commit operation (submodule repo commit + parent pointer commit). A partial landing (submodule committed/pushed, parent pointer not, or vice versa) leaves the superproject pointing at a stale or detached commit — a known footgun that multiplies the per-repo commit count and the revert surface.
- >5 must-change consumers, multiple distinct repos, a contract two canonical resources depend on, and shared cross-repo infrastructure (the `ai-resources/` visibility grant) → High.

### Dimension 4: Reversibility
**Risk:** Medium

- For the 7 non-submodule project files, the edit is a single-line string swap that `git revert` (or re-edit) restores cleanly within the same working tree → Low on that subset.
- For the 4 submodule files, revert is multi-step: revert the commit inside the submodule repo, then bump the parent pointer back, in two repos each. CHANGE_DESCRIPTION confirms the two-stage commit model. A clean revert therefore requires the same two-stage dance per submodule — more than one extra step.
- Pushes are operator-gated (CHANGE_DESCRIPTION + mission non-negotiables), so state does not propagate beyond local git until approved — this caps reversibility risk: nothing has reached a shared remote without a human in the loop. As long as the revert happens before push, it is git-local.
- One genuine non-git cleanup path exists: if the relative form fails to resolve at launch on any machine, each affected operator must add their own absolute path to their gitignored `settings.local.json` to restore `ai-resources/` visibility (the recovery procedure documented at permission-template.md:214–217). That is a per-machine manual step a `git revert` cannot perform.
- Multi-step submodule revert + a possible per-machine manual recovery → Medium.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Resolution-context coupling (the load-bearing one).** The portability premise is that a relative `additionalDirectories` resolves against the launch dir, so `../..` reaches the workspace root. The canonical scaffold doc states the opposite assumption directly: `new-project.md:377` — "Use an absolute path, not a relative one — Claude Code resolves `additionalDirectories` relative to session CWD, **which varies by how the project is opened**." The relative form silently depends on the session always being launched from the project root. If a session is opened from a vault subdir, a worktree, an editor-integrated launcher with a different CWD, or via `claude --add-dir` from elsewhere, `../..` resolves to the wrong directory and the `ai-resources/` grant evaporates with no error — symlinked commands/agents and shared skills simply stop being reachable. This is the exact silent-narrowing failure D2 flags, and it is the conflict the system's own Design Judgment Principle ("conflicts must be surfaced, not silently resolved") requires escalating.
- **Canonical-home coupling.** `permission-template.md:185/194` establishes the home contract: the workspace-root grant is machine-specific and belongs in gitignored `settings.local.json`, NOT in tracked config. The change keeps the grant in the tracked file (just relative). Two systems now disagree about where the grant lives — and `permission-sweep-auditor` Detection Rule 8 (permission-template.md:396) will still treat a tracked `additionalDirectories` as an ADVISORY "relocate to local," so the sweep tool will keep flagging the very files this change "fixes."
- **Scaffold-drift coupling.** Even after this change, `new-project.md:397` re-injects an absolute tracked `additionalDirectories` on every new project. The mission acknowledges this (mission file:48, "fix the repo-scaffolding source") but it is OUT OF SCOPE this session. So new repos keep being born with the old defect form while existing repos move to a third form — three coexisting conventions.
- Multiple implicit dependencies, a silent-failure mode in unexpected launch contexts, and an undocumented new contract (tracked+relative) that no canonical resource sanctions → High.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.

- **AP-1 / Design Judgment "Conflicts must be surfaced, not silently resolved" (workspace CLAUDE.md §Design Judgment Principles).** The strongest finding. Two canonical inputs conflict with the change and with each other-vs-the-change: `permission-template.md` says "remove from tracked, put absolute in local"; `new-project.md` says "absolute, not relative, because CWD varies"; the change says "relative, tracked." This is a live three-way conflict on a load-bearing field. The principle requires listing it and asking the operator which to trust — not picking the relative form and proceeding. The change as described does not surface this; it asserts the relative form is "verified portable" on the strength of a docs reading that the repo's own canonical scaffold note contradicts.
- **DR-1 / DR-3 (placement / canonical home).** `permission-template.md` Layer D′ is the declared canonical home for the workspace grant (gitignored local file). The change places the grant in the wrong tier relative to the canonical doc (tracked Layer D instead of local Layer D′). This is a placement tension, though the change's *intent* (portability) is legitimate.
- **OP-11 / OP-3 (loud revision, never silent drift).** IF the operator's intent is genuinely to revise the canonical decision (move from "absolute-in-local" to "relative-in-tracked"), that is a permitted principle/convention revision — but only if done loudly and recorded (update `permission-template.md` and `new-project.md` in the same change). Doing the config edits while leaving the canonical docs prescribing the opposite is exactly the silent-drift failure OP-11/OP-3 forbid.
- No speculative-abstraction (OP-9/DR-7/AP-7) issue — the consumers exist today. No OP-10 boundary issue, no OP-12 detection-without-closure issue, no OP-5 advisory→enforcement issue. The misalignment is conflict-surfacing + placement + loud-revision, all of which are *resolvable by process* (surface the conflict, get the operator's call, update the canonical docs in lockstep) → Medium, not High. This is a tension that a recorded decision converts to alignment, not a clear unacknowledged violation.

## Mitigations

(Verdict is RECONSIDER — see Recommended redesign. Mitigations section omitted per template.)

## Recommended redesign

- **Resolve the three-way conflict before editing any file (this is the gating step).** Put the conflict to the operator explicitly: (a) canonical `permission-template.md:185` says tracked files should carry NO `additionalDirectories` and the grant lives in gitignored `settings.local.json` with an absolute path; (b) canonical `new-project.md:377` says the grant must be absolute because "CWD varies by how the project is opened"; (c) this change makes it relative-and-tracked. These cannot all be right. Ask which convention is now authoritative. Do not proceed on the relative-form reading until this is the operator's recorded decision (satisfies the Design Judgment "surface conflicts" principle and OP-11).
- **If the operator confirms relative-tracked is the new standard:** make the revision loud (OP-11) — update `permission-template.md` (Layer D / Layer D′ text + Detection Rule 8) and `new-project.md` (lines 265/377/397) in the SAME change set so canonical docs, scaffold, and live config agree; otherwise `permission-sweep` keeps flagging the "fixed" files and new projects keep being born in the old form. AND empirically confirm the relative form resolves from a non-project-root launch context (vault subdir, worktree) on Daniel's machine before relying on it — the mission contract already requires per-machine confirmation (mission file:45), which concedes form alone is not sufficient.
- **Lower-risk alternative that sidesteps the resolution-context coupling entirely:** follow the canonical doc as written — remove `additionalDirectories` from the 11 tracked files and have each operator add their absolute path once to their gitignored `settings.local.json` (recovery snippet already documented at permission-template.md:214–217). This is portable-by-construction (nothing machine-specific is tracked), needs no docs revision, and clears Detection Rule 8 cleanly — at the cost of a one-time per-operator local-file setup. It collapses D2, D5, and D6 to Low.
- **Sequence submodule edits to avoid a detached-pointer state:** for each of the 4 submodules, commit in the submodule repo and bump the parent pointer as a paired unit, and confirm both before moving to the next submodule, to keep the superproject from pointing at a stale/detached commit between steps.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the 11 settings files, `permission-template.md`, `new-project.md`, `principles-base.md`, and the mission contract; grep counts for the consumer inventory; verbatim quotes from CHANGE_DESCRIPTION and referenced files). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is RECONSIDER._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-26-settings-additionaldirectories-portability.md

**Verdict: we concur with RECONSIDER.** The recommended path (surface the three-way conflict; prefer canonical remove-from-tracked + `settings.local.json`) is the right answer — we strengthen it from fallback to primary.

**Routing position.** The canonical home for the workspace-root grant is `settings.local.json` (Layer D′), absolute path, gitignored — not tracked `settings.json` in any form (`permission-template.md` Layer D line 185, D′ lines 192–194). Relative-and-tracked is the wrong *layer*, not just the wrong path style.

**Why RECONSIDER stands** (either ground sufficient; DR-8 makes the verdict binding and bars downgrade):
- Re-opens the 2026-06-03 design decision that deliberately removed tracked `additionalDirectories` — silent drift past a closed decision (OP-11, AP-1).
- Portability premise is contradicted in writing by the canonical scaffold note: `/new-project` line 377 says "use an absolute path, not a relative one — Claude Code resolves `additionalDirectories` relative to session CWD, which varies." `settings.json` is Critical load-bearing (symlinks break if the grant fails).

**The three-way conflict is genuine and unresolved.** (1) permission-template says remove + absolute-in-local; (2) `/new-project` says relative is unsafe; (3) the mission thread (line 66) claims docs confirm relative resolves. (2) and (3) cannot both be true. The operator launches via the VS Code extension, so whether `../..` climbs correctly from the opened folder is the load-bearing unknown — not yet confirmed for G1/G2 in that launch context.

**The risk the dimension review missed:** fixing the 9+2 leaf files leaves the *generator* un-fixed. `/new-project` step 3 still writes the grant into tracked `settings.json` (line 220 pending-alignment item), so the next scaffolded project re-introduces the defect. Leaf fix without scaffold fix is AP-9 (correcting symptoms, not the recurrence source). The scaffold edit is its own gated change class (canonical command edit → own `/risk-check`).

**Right answer:** remove from tracked config + per-machine `settings.local.json` (canonical, portability-by-construction, no dependence on the unresolved relative-resolution question) + fix `/new-project` to write the grant to the local file. Do not adopt relative-and-tracked even if it tests green — that trades a portability bug for a standing `/permission-sweep` drift item.

**Grounding-integrity flag:** the canonical vault (`projects/repo-documentation/vault/`) is verified-absent on this machine; I grounded in the archived v1 baseline (`output/phase-1/`) plus the live `permission-template.md`. The recommendation is fully groundable, so no decline — but the vault should be restored or re-pointed before the next consultation.
