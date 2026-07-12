# Risk Check — 2026-07-12

## Change

M-A Wave 2 — shared-infra items only (narrower gate per the Wave 1 RECONSIDER's own redesign recommendation). (1) M-A2b — DELETE the workspace-root hook `.claude/hooks/model-classifier.sh`. An invariant-stem grep (`model-classifier`) across all settings.json / settings.local.json / commands / skills / agents / docs found zero live consumers — only two historical prose mentions (an archived session note and a merged-os inventory note), neither a caller. It is registered in no hook array at any settings layer. It also recommends `sonnet[1m]` / "Sonnet 1M", so deleting it closes part of the open `[1m]`-purge item (improvement-log 2026-06-18 item 3). (2) M-A3b — SYNC the stale installed git hook `ai-resources/.git/hooks/pre-commit` (mtime 2026-02-20; carries old check-numbering and OMITS the `check-skill-size.sh` invocation entirely) to the repo source `ai-resources/.claude/hooks/pre-commit`. The installed hook gates every commit in the ai-resources repo. NOTE: `.git/hooks/` is UNTRACKED by git, so `git revert` does NOT restore it — a pre-overwrite snapshot is planned as the rollback path. (3) M-A3c — REMOVE the banned model-declaration from the `/new-project` generator: `new-project.md:170` templates a default-model line into the GENERATED project's CLAUDE.md ("Default model for this project is {Sonnet 1M | Opus 4.7} … set in `.claude/settings.local.json`"), and a generator task writes that model default into settings.local.json. Workspace `CLAUDE.md` § Model Tier bans BOTH halves (no `model` field in any settings layer including settings.local.json; no default-model line in ANY CLAUDE.md). Cross-references at new-project.md L375/379/402 refer to "the model default (task 2)" and must be repaired so the remaining task numbering stays coherent.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/model-classifier.sh — exists (DELETION target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/pre-commit — exists (repo source, the sync SOURCE)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/hooks/pre-commit — exists (installed, stale, UNTRACKED — the sync TARGET)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-skill-size.sh — exists (the call the stale installed hook omits)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists (generator; L170, L375, L379, L402)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists (§ Model Tier — the canonical ban)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/M-A-phase0-defects.md — exists (the packet)

## Verdict

RECONSIDER

**Summary:** Both shared-infra edges the packet itself flagged as sharpest turn out to have a real, evidence-confirmed gap — the pre-commit sync's `check-skill-size.sh` delegation silently stops working at the installed location (a path-resolution bug my own prior Wave-1 review verified as "safe" without testing), and the `/new-project` model-line removal leaves `prime.md`'s Model-Alignment contract with an undefined case for every future project — so Blast Radius and Hidden Coupling both independently clear High, and the rubric's "two or more High" rule forces RECONSIDER even though both gaps have small, concrete fixes.

## Consumer Inventory

Search terms: invariant stem `model-classifier`; `pre-commit` + `check-skill-size.sh` (companion-script contract); `new-project.md` / `/new-project`; the `## Model Selection` section heading (the contract `/new-project` step 11a writes and `prime.md` reads); the informal `"task 2"` cross-reference phrase at new-project.md L375/379/402. Grepped `ai-resources/` and the workspace root one level up, plus all 58 `settings.json`/`settings.local.json` files at every layer (user `~/.claude/settings.json`, workspace root, `ai-resources`, every project).

| Consumer path | Reference type | Must change? |
|---|---|---|
| All `settings.json`/`settings.local.json` (58 files, every layer incl. user-level `~/.claude/settings.json`) | (checked for `model-classifier` registration) | no — zero hits confirmed independently; corroborates the packet's zero-consumer claim |
| `ai-resources/docs/repo-architecture.md:17` ("hooks/ # workspace-level hooks (model-classifier, sync, etc.)") | documents | no — goes stale post-deletion, out of packet scope |
| `ai-resources/logs/innovation-registry.md:81` (historical row) | documents | no — appropriate to leave as history |
| `artifacts/merged-os-context/.../inventory-notes.md:83` + `projects/strategic-os/ai-strategy/working/inventory-notes.md:83` (duplicate copy) | documents | no — working notes, goes stale, out of scope |
| `projects/repo-documentation/**` (≈15 vault/blueprint/component files documenting `model-classifier.sh`) | documents | no — a documentation-snapshot project; already describes the hook as unwired |
| `.claude/hooks/session-start.sh` | (checked — near-miss pattern the packet itself flags) | n/a — independently re-confirmed NOT a consumer of `model-classifier.sh`; correctly excluded from deletion |
| `ai-resources/.git/hooks/pre-commit` (installed, untracked) | co-edits (direct sync target) | **yes** — in scope |
| Every future `git commit` inside `ai-resources/` | invokes (git itself calls this hook on every commit) | **yes** — shared infra, unbounded caller set |
| `ai-resources/.claude/hooks/check-skill-size.sh` | invoked by the source hook via `$(dirname "$0")` | **yes** — path resolution breaks at the installed location (see Dimension 5); the sync as scoped does not actually restore this call |
| `ai-resources/.claude/commands/prime.md:173` (Model Alignment check reads the `## Model Selection` heading from the nearest project CLAUDE.md) | parses | **yes** — newly surfaced; not in the packet's M-A3c scope (see Dimension 5) |
| `new-project.md` general backbone-spine consumers (`deploy-workflow.md`, `permission-sweep.md`, `placement.md`, `repo-dd.md`, `list-critical-resources.md`, 5× `pipeline-stage-*.md`, `session-guide-generator.md`, `session-guide.md`) | invoke/document `/new-project` generally | no — none parse step 11a specifically |
| Previously-scaffolded project `CLAUDE.md` files already carrying a `## Model Selection` section (e.g. `projects/buy-side-service-plan/CLAUDE.md` and ≈15 others found in the section-heading grep) | documents (pre-existing output) | no — existing sections are untouched; only future scaffolds are affected |
| `ai-resources/logs/decisions.md`, `logs/improvement-log.md`, `logs/session-notes.md` (pre-existing recorded conflicts) | documents | no — this edit *closes* these already-logged findings |
| `ai-resources/docs/settings-local-recovery.md:48` ("preserves every other key already in settings.local.json (e.g. the model default)") | documents | **yes** — a fourth dangling cross-reference the packet's own L375/379/402 list did not name |

Total: **15 distinct consumer rows, 5 must-change** (`.git/hooks/pre-commit` direct target; the unbounded "every future commit" shared-infra row; `check-skill-size.sh`'s broken path dependency; `prime.md`'s undefined Model-Selection fallback; `settings-local-recovery.md`'s uncounted dangling reference). `model-classifier.sh` itself has genuinely **zero** functional consumers — that sub-item's inventory is empty and clean, confirming the packet's disposition is correct as scoped.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- M-A2b deletes a `UserPromptSubmit` hook that fires once per session — a net *reduction* in per-session token cost, not an addition (`.claude/hooks/model-classifier.sh:1-47`).
- M-A3b touches a git hook that fires at commit time only — not session-loaded, not per-turn, no `@import` chain.
- M-A3c removes one scaffolding step from a pay-as-used generator command (`/new-project` runs once per project setup) — no ongoing cost either way.
- No always-loaded file (workspace or `ai-resources` `CLAUDE.md`) is touched by any of the three items.

### Dimension 2: Permissions Surface
**Risk:** Low

- Zero `settings.json`/`settings.local.json` edits anywhere in this batch (verified: 58 settings files at every layer checked, none touched).
- `.git/hooks/pre-commit` sits outside the Claude Code permission system entirely — it is a native git hook invoked by `git` itself, not gated by `permissions.allow`/`deny`; replacing its logic changes no permission grant.
- M-A3c *removes* an instruction that told the generator to prompt the operator to hand-write a model field into `settings.local.json` (confirmed: the generator script itself never auto-writes `settings.local.json` — `new-project.md:173`, "Do not write `.claude/settings.local.json` automatically"). Net effect is narrowing, not widening.

### Dimension 3: Blast Radius
**Risk:** High

Per the Consumer Inventory: 15 distinct rows, 5 must-change.

- **M-A2b** — 0 functional consumers (confirmed independently across 58 settings files and the whole repo); Low blast radius standing alone.
- **M-A3b** — satisfies the rubric's High bar on its own: "shared infra touched in a way that affects multiple workflows." The installed `.git/hooks/pre-commit` gates every future commit in `ai-resources`, i.e. every maintenance session across every command/skill/workflow in the repo, regardless of how well the sync is executed.
- **M-A3c** — the packet's own consumer check ("no command/agent/hook machine-parses the templated line") is narrower than the actual contract: `prime.md:173` parses the `## Model Selection` *section heading*, not the literal templated line, and this consumer is not named anywhere in the packet's M-A3c change spec. A fourth dangling cross-reference (`docs/settings-local-recovery.md:48`) was also found outside the packet's named L375/379/402 list.
- **Any caller requires modification to keep working** — both `check-skill-size.sh`'s path dependency (Dimension 5) and `prime.md`'s undefined fallback case need a companion edit for the fix to be complete, which independently satisfies the High threshold.

### Dimension 4: Reversibility
**Risk:** Medium

- M-A2b: ordinary tracked-file deletion; `git revert` fully restores it; zero consumers means no residual state to clean up.
- M-A3c: ordinary tracked-file text edit; clean `git revert`.
- **M-A3b is the swing factor, and it is self-disclosed by the packet.** `ai-resources/.git/hooks/pre-commit` is untracked (confirmed: it is a `.git/` internal path, `git ls-files`/`git status` return nothing for it), so `git revert` cannot restore it if the sync goes wrong. The packet's own § 7 names the correct mitigation shape ("capture a copy of the current installed hook before overwriting") but does not specify a concrete backup path or an automatic verification step — it is "planned," not yet operationalized. A single `cp` before and a single `cp` to restore is genuinely one extra step (Medium, not High) *if* the backup is actually taken; this review's own Read of the installed hook (reproduced in full above and in the tool transcript) is an incidental, non-load-bearing extra copy — the packet must not rely on that.

### Dimension 5: Hidden Coupling
**Risk:** High

- **The path-resolution bug (the operator's flagged concern, confirmed).** The source hook resolves its companion script via `hook_dir="$(dirname "$0")"` then `"$hook_dir/check-skill-size.sh"` (`ai-resources/.claude/hooks/pre-commit:88-91`). This is correct only when the script runs from `.claude/hooks/pre-commit`, where `check-skill-size.sh` is a sibling. Independently verified via `ls -la ai-resources/.git/hooks/` that the installed location contains **only** `pre-commit` — no `check-skill-size.sh`. Regardless of whether git invokes the hook with a relative or absolute path, `dirname` of any path ending in `.git/hooks/pre-commit` is `.git/hooks`, which does not and will not contain `check-skill-size.sh` after a byte-for-byte `cp` sync. Effect: `[ -x "$hook_dir/check-skill-size.sh" ]` is false at the installed location, the `if` block silently no-ops (no `set -e` trip — a failed test inside an `if` never trips `set -e`), the hook still prints "All skill checks passed." and exits 0. **The commit path is not broken, but the fix's own stated purpose — restoring the `check-skill-size.sh` invocation the installed hook currently omits — is not actually achieved by a plain copy.** This is silent: nothing in the packet's §6 functional-verification step ("a real test commit … runs the skill checks and succeeds") would catch it, because that test only requires the commit to succeed, and it does succeed either way; the informational size-warning would need a staged SKILL.md >300 lines to be checked explicitly, and even then the WARN line would silently never print.
- **This exact question was checked once before and missed.** My own prior Wave-1 review (`audits/risk-checks/2026-07-12-m-a-phase0-defect-batch-docs-hooks-precommit-newproject.md`, Dimension 4) wrote: "independently confirmed the source hook … is behavior-equivalent to the installed hook … except that `check-skill-size.sh` is verified present, executable, and informational-only (always exits 0) — so the sync introduces no new blocking behavior." That check verified the script exists and is non-blocking *in the source location* but never tested path resolution *at the installed location* — an incomplete verification this narrower gate closes.
- **The `prime.md` coupling (newly surfaced, independent of the operator's flagged point).** `.claude/commands/prime.md:173` reads the nearest project `CLAUDE.md`'s `## Model Selection` section for its Model-Alignment nudge, with an explicit fallback defined only for "session opened at the workspace root with no project `CLAUDE.md` loaded" (→ Sonnet 1M). There is no defined behavior for "project `CLAUDE.md` loaded but has no `## Model Selection` section" — the exact state every project scaffolded after M-A3c ships will be in, since step 11a (the only writer of that section) is removed outright rather than replaced with a compliant recommendation-only version (workspace `CLAUDE.md` § Model Tier explicitly permits — does not require — a "recommended posture" Model Selection section). This is an undocumented contract dependency: the packet's M-A3c change spec names L170/375/379/402 but not `prime.md:173`, and the prior Wave-1 consumer inventory checked only "who parses the literal templated line" (answer: nobody) rather than "who parses the section heading" (answer: `prime.md`).
- **Two independent implicit dependencies, one of them silent** (the `check-skill-size.sh` path bug) — this satisfies the rubric's High bar directly ("multiple implicit dependencies, OR silent auto-firing in unexpected contexts … OR an undocumented new contract that callers must honor").

### Dimension 6: Principle Alignment
**Risk:** Low

Ground: `projects/strategic-os/ai-strategy/principles-base.md` (readable; consistent with the Wave-1 review's grounding of the same index).

- **OP-11 / OP-3 (loud revision, never silent drift).** All three items are themselves corrections of previously-recorded, already-loud divergences: `model-classifier.sh` was a built-but-never-wired hook (never a live rule, nothing to silently revise); the installed `pre-commit` drift is a straightforward staleness fix restoring the committed source's already-approved behavior; the `/new-project` model-line removal closes a conflict workspace `CLAUDE.md` § Model Tier already states loudly and `logs/decisions.md` already records (per the Wave-1 inventory). None of these are silent principle drift — they are drift *correction*.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction).** Not implicated as a violation — if anything all three items are principle-positive: M-A2b removes a never-wired speculative hook; M-A3c removes speculative/banned scaffolding. No new command, agent, gate, or always-loaded doc is being created.
- **OP-12 (closure before detection), OP-10 (system boundary), OP-5 (advisory vs. enforcement), DR-1/DR-3 (placement).** Not implicated — no new detection/scan is added, no cross-tool coordination, no enforcement upgrade, no resource re-homed.
- **Note (not a principle violation, but adjacent):** M-A3b's own verification table labels the sync "mechanical" — file-copy-and-diff. The path-resolution bug found in Dimension 5 shows this particular copy needed a judgment check (does the companion-script path still resolve at the new install location?) that a purely mechanical diff would not surface. This is a methodology/process gap worth carrying into the redesign, not a principle-ID violation in itself.

## Recommended redesign

- **M-A3b — fix the path dependency before syncing, not after.** Either (a) rewrite the source hook's companion-script lookup to be install-location-independent (e.g. resolve the repo root via `git rev-parse --show-toplevel` and reference `$TOPLEVEL/.claude/hooks/check-skill-size.sh` instead of `$(dirname "$0")`) and sync the corrected source, or (b) copy `check-skill-size.sh` into `.git/hooks/` alongside `pre-commit` and explicitly document that the two installed files must be kept in sync going forward (weaker — creates a second drift surface, not recommended as the primary fix). Either way, upgrade the packet's §6 functional-verification step from "a test commit succeeds" to "a test commit that stages a SKILL.md >300 lines actually prints the `check-skill-size.sh` WARN line" — the current test would pass even with the bug present. Also name a concrete backup path (e.g. `cp ai-resources/.git/hooks/pre-commit /tmp/pre-commit.bak-$(date +%s)`) in § 7 Rollback before the overwrite, closing the Dimension 4 gap.
- **M-A3c — close the `prime.md` loop in the same change, not as a follow-on.** Either (a) replace step 11a's banned "Default model … set in `.claude/settings.local.json`" template with a compliant, recommendation-only Model Selection scaffold (workspace `CLAUDE.md` § Model Tier explicitly permits this form), so `prime.md:173` keeps a section to read, or (b) if step 11a is removed outright as the packet currently scopes it, add an explicit third case to `prime.md:173` ("project `CLAUDE.md` exists but has no `## Model Selection` section → skip the model-alignment line silently, same as the no-project-CLAUDE.md case") in the same commit. Also fold `docs/settings-local-recovery.md:48` into the cross-reference repair list alongside the named L375/379/402.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: full reads of both `pre-commit` hooks with a line-level `diff` (repo source lines 70-91 vs. installed lines 70-96 — the installed copy carries an inline 500-line body-length WARN the source replaced with the `check-skill-size.sh` delegation); `ls -la` of both `.claude/hooks/` and `.git/hooks/` confirming `check-skill-size.sh` exists only at the source location; `stat` confirming installed-hook mtime (Feb 20 17:52) vs. source mtime (Apr 18 13:14); independent `grep -rniI` for the invariant stem `model-classifier` across `ai-resources/` and the workspace root (83 raw hits, all traced — zero live callers, zero settings-file registrations at any of 58 checked files including `~/.claude/settings.json`); direct read of `ai-resources/.claude/commands/new-project.md` lines 150-178 (step 11a) and 370-405 (the three cross-references) plus `ai-resources/.claude/commands/prime.md` lines 160-190 (the `## Model Selection` consumer contract); `grep` for `## Model Selection` across the repo and workspace surfacing `docs/settings-local-recovery.md:48` as an uncounted fourth reference; direct comparison against my own prior Wave-1 risk-check (`audits/risk-checks/2026-07-12-m-a-phase0-defect-batch-docs-hooks-precommit-newproject.md`) to identify the specific verification gap this narrower gate closes. No training-data fallback was used on any read.
