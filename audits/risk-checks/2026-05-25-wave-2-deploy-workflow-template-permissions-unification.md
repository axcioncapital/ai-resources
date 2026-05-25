# Risk Check — 2026-05-25

## Change

Plan-time gate on Wave 2 of a friction-cleanup session: unify `deploy-workflow.md:209` to read canonical permissions from `ai-resources/templates/project-settings.json.template` instead of an inline JSON literal.

**Proposed change:**
1. In `.claude/commands/deploy-workflow.md` at line ~167–196: replace the inline "Canonical permissions block" prose + JSON literal with a short pointer paragraph referencing the template file as the source of truth.
2. In `.claude/commands/deploy-workflow.md` at line ~202–215 (the bash merge procedure): add a walk-up resolver block (mirrors `new-project.md:330–337`) that finds `AI_RES`, then replace the `CANONICAL_PERMS='{...inline literal...}'` line with `CANONICAL_PERMS=$(jq -c '.permissions' "$TEMPLATE")` reading from `$AI_RES/templates/project-settings.json.template`.

**Discovered drift (the load-bearing risk dimension):** the template contains MORE in its permissions block than the current inline literal:
- `"defaultMode": "bypassPermissions"` (not in inline) — auto-approves permission prompts
- `"Edit(**/.claude/**)"`, `"Write(**/.claude/**)"`, `"Bash(rm *)"` (not in inline)
- Deny list matches.

After this change, **new `/deploy-workflow` runs will deploy the template's expanded permission set**, not the current narrower inline set. Existing deployed projects are unaffected unless they run `/sync-workflow` (which also consumes the same code path).

**Why it's being proposed:** Pair-unification with `/new-project` (commit `39b27b5` earlier today) that already reads from the same template. Currently `/new-project` and `/deploy-workflow` deploy two different permission shapes — `/new-project` deploys the canonical template, `/deploy-workflow` deploys a lagging subset. Convergence is the unification's intended outcome.

**Operator memory context:** `feedback_zero_permission_prompts.md` confirms bypassPermissions is the agreed floor for the operator. The expanded `allow` entries (`.claude/**` edits, `rm *`) align with the operator's bypass-mode workflow.

**Blast radius:**
- Touched files: 1 (`.claude/commands/deploy-workflow.md`)
- Affected downstream consumers: future `/deploy-workflow` and `/sync-workflow` invocations on projects that don't already have a non-empty `.permissions.allow` (the merge is gated by that predicate, so projects with existing permissions get NO change)
- Reversibility: high — restore the inline literal if the template-driven set proves problematic.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md` — exists (reference pattern at lines 330–337)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-settings.json.template` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/README.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Single-file unification with strong operator-memory alignment and a clean walk-up precedent — but the change crosses a semantic boundary (narrow set → bypassPermissions + dotfile/rm globs) that needs explicit operator acknowledgement and one factual correction to the change brief about `/sync-workflow` scope.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edit replaces inline JSON prose + literal with a shorter pointer paragraph plus a walk-up resolver block. Net token delta in the command body is roughly flat or slightly negative (inline literal at `deploy-workflow.md:168–196` and `:209` is ~30 lines; pointer + resolver replacement mirrors the `new-project.md:323–344` shape which is ~22 lines).
- `deploy-workflow.md` is invoked on-demand (`/deploy-workflow` slash command) — not auto-loaded into every session. No always-loaded CLAUDE.md is touched (workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` are unchanged).
- No new hooks registered; no `@import` chain added.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The change widens the *deployed* project permissions surface on every future `/deploy-workflow` invocation that hits a project without an existing `.permissions.allow`. Concrete additions from `project-settings.json.template:3,19,20,21` not present in the current inline literal at `deploy-workflow.md:168–196`:
  - `"defaultMode": "bypassPermissions"` — disables Edit/Write/Delete prompts for the deployed project entirely.
  - `"Edit(**/.claude/**)"`, `"Write(**/.claude/**)"` — dotfile-path edits without prompts.
  - `"Bash(rm *)"` — narrow `rm` allowed (destructive `rm -rf` stays on deny via `project-settings.json.template:25`).
- The widening is the *intended* outcome of the unification (the brief calls this out explicitly), and it aligns with operator memory `feedback_zero_permission_prompts.md` ("bypassPermissions is the agreed floor"). The bypass posture is also the canonical Layer D shape per `docs/permission-template.md:153–183`.
- Deny list at `project-settings.json.template:23–31` matches the current inline literal at `deploy-workflow.md:186–195` (`Bash(git push*)`, `Bash(rm -rf *)`, `Bash(sudo *)`, four `Read(...)` archival denies). No deny rules are removed or narrowed.
- The change does NOT touch the operator's `~/.claude/settings.json` (Layer A), workspace root settings (Layer B), or `ai-resources/.claude/settings.json` (Layer C) — only what future `/deploy-workflow` runs write into newly-deployed projects.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files modified: 1 (`.claude/commands/deploy-workflow.md`).
- Downstream consumers of the inline literal — enumerated via `grep -rln "CANONICAL_PERMS"`:
  - `.claude/commands/new-project.md` — already template-driven (line 342), so the unification *brings deploy-workflow in line with* this consumer rather than diverging from it. ✓
  - `.claude/commands/deploy-workflow.md` — the change site itself.
  - Other matches are audit/risk-check files (read-only artifacts), not consumers.
- The CHANGE_DESCRIPTION asserts `/sync-workflow` "also consumes the same code path." **This is incorrect.** `sync-workflow.md:48` explicitly states "Exclude `settings.json` and `settings.local.json` from comparison — these are always project-specific." `/sync-workflow` does NOT touch `.permissions` at all — its scope is `commands/`, `agents/`, `hooks/` files. So the consumer surface for this change is narrower than the brief claims: only future `/deploy-workflow` runs. This narrows the blast radius but the misstatement in the brief is itself a small risk signal (it means downstream reasoning in the session may have over-counted impact).
- Existing deployed projects (12 enumerated under `projects/`) are unaffected unless re-deployed — the predicate at `deploy-workflow.md:164` ("parsed JSON has `.permissions.allow` *and* that array is non-empty") returns true for all 15 already-existing `settings.json` files inspected, so the merge would skip on a hypothetical re-run.
- Permission-template documentation (`docs/permission-template.md:157`) already declares the Layer D source of truth is `templates/project-settings.json.template`; the inline-literal path in `deploy-workflow.md` is the *only* remaining inconsistency. Closing it reduces drift surface.
- Contract change: none. `/deploy-workflow`'s external interface (slash command name, arguments, output structure) is unchanged.

### Dimension 4: Reversibility
**Risk:** Low

- The change is a single-file edit to `.claude/commands/deploy-workflow.md`. `git revert` restores the inline literal fully.
- No data files are written by the change itself (the change is a command-definition edit, not a deployment run).
- New projects deployed under the new permissions set after the change lands would not be auto-reverted by reverting the command — but this is the standard cost of any deploy-time change and is bounded because (a) every new project's `settings.json` is regular git content in that project's repo and (b) the operator opt-in `Bash(rm *)` / `defaultMode: bypassPermissions` posture is *already* the canonical Layer D shape per `docs/permission-template.md`, not a novel widening.
- No external writes, no cross-repo state, no hook auto-registration triggered by the change.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Walk-up resolver coupling.** The new resolver assumes `ai-resources/` lives in an ancestor of `{PROJECT_DIR}`. This mirrors `new-project.md:330–337` exactly, and the same idiom is already used in `auto-sync-shared.sh` and in step 3 of `deploy-workflow.md:235–241` for `additionalDirectories`. So the idiom is established repo convention — but it is an *implicit* dependency on workspace topology. Templates living in `ai-resources/templates/` is documented at `templates/README.md:6–14`. Low-to-medium concern.
- **Predicate dependency.** The behavior change is gated by `.permissions.allow` being empty in the deployed project's `settings.json`. The research-workflow template at `ai-resources/workflows/research-workflow/.claude/settings.json` (referenced by `deploy-workflow.md:219`) already ships its own non-empty `permissions` block, so the most common deploy path is a no-op. The brief acknowledges this. ✓ Documented.
- **Template-content drift.** The unification ties `/deploy-workflow`'s deployed permissions to whatever `project-settings.json.template` currently contains. Future template edits will silently flow into the next `/deploy-workflow` run with no audit trail. `templates/README.md:18–22` documents the consumer contract but does not mention `/deploy-workflow` as a consumer — only `/new-project` step 2 + step 4. **Undocumented new consumer relationship.** This is the medium-risk thread.
- **Brief misstatement on `/sync-workflow`.** As noted under Blast Radius — the brief asserts `/sync-workflow` consumes the same code path; it does not (`sync-workflow.md:48` excludes settings files). If a future operator acts on the brief's claim and tries to "fix" `/sync-workflow` to consume the template, they'd cross a real scope boundary (settings files are intentionally project-specific). Documentation cleanup is part of the mitigation.
- No silent auto-firing introduced. No two-system overlap with existing mechanisms — the change is a direct substitution.

## Mitigations

- **Permissions surface (Medium):** In the same Wave 2 commit, add a one-line acknowledgement in `deploy-workflow.md` near the new pointer paragraph stating "Deployed projects receive `defaultMode: bypassPermissions`, `Edit(**/.claude/**)`, `Write(**/.claude/**)`, and `Bash(rm *)` — see `docs/permission-template.md` Layer D for the rationale (root causes #1–#4)." This makes the widening visible in-context to anyone reading the command file later and links to the existing rationale doc, preventing a future audit from flagging the unification as an unexplained surface expansion.

- **Hidden coupling — undocumented consumer (Medium):** In the same Wave 2 commit, update `templates/README.md` "Consumer contract" section to add `/deploy-workflow` Step 4 ("Ensure permissions baseline in deployed settings.json") alongside the existing `/new-project` mention. This closes the documentation gap so the template file's read-only-input contract is clear to both consumers.

- **Brief misstatement on `/sync-workflow` (small-but-named):** Correct the change brief locally before commit — `/sync-workflow` does NOT consume the permissions code path (`sync-workflow.md:48` explicitly excludes settings.json). Strike the "(which also consumes the same code path)" parenthetical from any plan notes or commit message draft so the session record stays factually accurate.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file paths and line numbers for `deploy-workflow.md` (`:164`, `:168–196`, `:202–215`, `:209`, `:219`, `:235–241`), `new-project.md` (`:323–344` for walk-up pattern), `sync-workflow.md` (`:48` excluding settings files from comparison), `project-settings.json.template` (`:3,19,20,21,23–31` for the expanded permission entries and deny list), `templates/README.md` (`:6–14,18–22` for consumer contract), and `docs/permission-template.md` (`:153–183` for canonical Layer D shape; `:157` for source-of-truth statement). Grep counts: 1 active consumer of `CANONICAL_PERMS` (`deploy-workflow.md` itself); 15 existing project `settings.json` files enumerated under `projects/**/.claude/`. Operator-memory ground: `feedback_zero_permission_prompts.md` confirms bypassPermissions floor. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### Concur with PROCEED-WITH-CAUTION

We concur with the verdict and the recommended path. The change is architecturally correct — it closes a Q8-violating duplication (inline JSON literal duplicating canonical bytes from `templates/project-settings.json.template`) and aligns `/deploy-workflow` with the same template-as-canonical-bytes pattern `/new-project` already uses (`repo-architecture.md` Q8 placement heuristic; AP-7 inverse — this is *removing* speculative-divergence rather than adding speculative-abstraction). The PROCEED-WITH-CAUTION level is set correctly because the unification crosses a permissions semantic boundary, not because the architecture is wrong.

The three recommended mitigations are the right path:

1. **In-context acknowledgement of the four widened entries** — correct, because DR-8 (structural changes in gated classes require `/risk-check`) is satisfied only when the operator-visible delta is explicit, not implicit. Hiding `defaultMode: bypassPermissions` behind an "align with template" pointer would be exactly the silent-widening pattern OP-3 (loud failure over silent continuation) and AP-1 (silent conflict resolution) prohibit. (`principles.md § OP-3, AP-1`; `risk-topology.md § 3 Permission change`)

2. **Update `templates/README.md` consumer contract to add `/deploy-workflow` as a Step 4 consumer** — correct, because the README is the two-end contract for the template fragment. Adding a second consumer without updating the contract documentation creates a two-end-contract drift the next maintainer cannot detect. (`principles.md § OP-11` — surfacing tacit assumptions is a recurring obligation; `risk-topology.md § 5` — "Change modifies a string literal matched by another component (two-end contract)" is a structural-risk signal.)

3. **Correct the change brief re: `/sync-workflow`** — confirmed and required. `sync-workflow.md:48` reads "Exclude `settings.json` and `settings.local.json` from comparison — these are always project-specific." `/sync-workflow` does NOT consume the permissions code path, period. Striking this from the brief and commit message is not a polish item — leaving it in encodes a false belief about the consumer set, which downstream maintainers will rely on. (`principles.md § OP-3, QS-4` — evidence/interpretation separation, no fabrication.)

### Risks the dimension review missed (or under-weighted)

**Risk A — Backfill asymmetry between `/new-project` and `/deploy-workflow`.** `/new-project` runs once at project creation and writes the canonical permissions to `.claude/settings.json`. `/deploy-workflow` deploys workflow tooling into an *already-scaffolded* project that already has a `settings.json`. Reading the brief, the unification is at `deploy-workflow.md:209` — confirm this code path actually *writes* `settings.json` for new deployments, or whether it only writes for projects without one. If `/deploy-workflow` writes to a project that already has `settings.json` from `/new-project`, the four widened entries are redundant (already present); if it writes to a workflow-only deployment with no pre-existing project, this is the actual blast radius. The brief should name which case this is. (`principles.md § DR-9` — top-3 command analysis before applying audit-derived or pattern-derived structural changes.) **`[CITATION NEEDED]`** for the actual `/deploy-workflow` write predicate.

**Risk B — Concurrent-session staging.** `repo-state.md § 2` lists ten pending manual steps including unpushed work on both workspace and ai-resources repos, and `principles.md § DR-10` prohibits directory wildcards for git add during concurrent sessions. The unification touches `ai-resources/.claude/commands/deploy-workflow.md` + `ai-resources/templates/README.md` — two ai-resources files in the same commit. Confirm no concurrent session is active before staging. Not a verdict-changer; a pre-commit confirmation.

**Risk C — `templates/README.md` 2026-04-13 KEEP decision interaction.** The README's KEEP-verdict block (lines 24–32) records that the templates pattern was reaffirmed 2026-05-25 (today). Adding `/deploy-workflow` to the consumer contract on the same day as the KEEP re-check is fine — but the commit message should mention this is the verdict's first concrete extension, not paper over it as routine maintenance. The KEEP verdict's evidence base implicitly assumed one consumer (`/new-project`); a second consumer is the first test of "does this pattern scale." (`principles.md § OP-11`.)

**Risk D — `permission-template.md` Layer D documentation.** Mitigation 1 says to link to `docs/permission-template.md` Layer D rationale near the new pointer paragraph. We did not read `permission-template.md` in this consultation, so we cannot confirm Layer D rationale actually documents the four widened entries (`defaultMode: bypassPermissions`, two `.claude/**` globs, `Bash(rm *)`). If Layer D documents only the narrower set, the link is misleading and the operator should update Layer D in the same commit. **`[CITATION NEEDED]`** — operator should verify `permission-template.md` Layer D matches the template before linking to it.

### Clear position

The right answer is: execute the three mitigations as specified, plus address Risks A and D before commit. Risk A is a factual check on the `/deploy-workflow` write predicate (a 2-minute Read); Risk D is a Read of `permission-template.md` Layer D and either confirming the link or adding a one-paragraph update to that doc in the same commit. Risks B and C are commit-message and staging-discipline items.

Do not downgrade the verdict to GO on the strength of "the template pattern is established." That established pattern is exactly what's being *extended* here — it has one prior consumer, not many. PROCEED-WITH-CAUTION is calibrated correctly.
