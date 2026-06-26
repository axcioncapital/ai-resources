# Risk Check — 2026-06-26

## Change

Canonical settings-portability fix (replaces the earlier RECONSIDER'd relative-path plan, per operator decision 2026-06-26). Two parts, both gated here:
(PART A — leaf removal) REMOVE the `permissions.additionalDirectories` array entirely from 11 tracked `settings.json` files — 7 project-level (projects/nordic-pe-screening-project, project-planning, brand-book, strategic-os, market-positioning, repo-documentation, axcion-ai-system-owner — each `.claude/settings.json`), 2 submodule vaults (projects/repo-documentation/vault, projects/axcion-ai-system-owner/vault — each `.claude/settings.json`), and 2 KB submodules (projects/interpersonal-communication/knowledge-base, projects/interpersonal-communication-copy/knowledge-base — each `.claude/settings.json`). Each file currently has a single `additionalDirectories` entry pointing at the workspace root via an absolute machine path (Patrik's path in Group 1, Daniel's path in Group 2). The workspace-root grant, where a machine still needs cross-repo visibility, moves to that machine's gitignored `settings.local.json` (absolute path) as per-machine operator follow-up — NOT a committed edit. This is the canonical home per permission-template.md (grant belongs in settings.local.json, not tracked settings.json in any form). No allow/deny rules change; only the `additionalDirectories` array is deleted. Submodule edits commit in the submodule repo, then the parent gets a pointer bump.
(PART B — generator fix, canonical command edit) Fix `/new-project` (its settings-writing step) and `ai-resources/templates/project-settings.json.template` so newly scaffolded projects do NOT write `additionalDirectories` into the tracked `settings.json` — closing the root cause so the defect cannot reappear.
Out of scope: Group 3 (the two inert Edit()/Write() permission globs in `ai-resources/.claude/settings.json`, still blocked on Patrik) and `audits/working/` throwaway copies. All pushes operator-gated; commits are per-repo, staged verify-first. Part of the settings-path-portability mission (contract at ai-resources/logs/missions/settings-path-portability.md). The prior risk-check (2026-06-26, relative-path plan, report at ai-resources/audits/risk-checks/2026-06-26-settings-additionaldirectories-relative-path-portability.md) returned RECONSIDER and BOTH the risk-check-reviewer AND the System Owner recommended exactly this removal-based approach as the correct fix — this risk-check evaluates that recommended redesign as the concrete plan.

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
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/templates/project-settings.json.template — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is the canonical, principle-aligned fix (removal + generator close-out) that resolves the prior RECONSIDER; its only elevated dimension is blast radius (11 tracked files across multiple repos plus a per-machine `settings.local.json` recovery step), which is mitigable with a staged verify-first sequence and a per-machine recovery snippet that already exists in `permission-template.md`.

## Consumer Inventory

Functional/contract consumers of the `additionalDirectories` field and of the `/new-project` generator contract. The ~16 `settings.json` grep hits include 5 non-target files (`knowledge-base/pe-kb-vault`, three `audits/working/` throwaway copies, and the `research-workflow` template with an intentional `{{PLACEHOLDER}}`) — none are in scope; they are noted under Blast Radius, not counted as must-change.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/nordic-pe-screening-project/.claude/settings.json | co-edits (PART A target) | yes |
| projects/project-planning/.claude/settings.json | co-edits (PART A target) | yes |
| projects/brand-book/.claude/settings.json | co-edits (PART A target) | yes |
| projects/strategic-os/.claude/settings.json | co-edits (PART A target) | yes |
| projects/market-positioning/.claude/settings.json | co-edits (PART A target) | yes |
| projects/repo-documentation/.claude/settings.json | co-edits (PART A target) | yes |
| projects/axcion-ai-system-owner/.claude/settings.json | co-edits (PART A target) | yes |
| projects/repo-documentation/vault/.claude/settings.json | co-edits (PART A target, nested in parent repo) | yes |
| projects/axcion-ai-system-owner/vault/.claude/settings.json | co-edits (PART A target, nested in parent repo) | yes |
| projects/interpersonal-communication/knowledge-base/.claude/settings.json | co-edits (PART A target, nested in parent repo) | yes |
| projects/interpersonal-communication-copy/knowledge-base/.claude/settings.json | co-edits (PART A target, nested in parent repo) | yes |
| ai-resources/.claude/commands/new-project.md | invokes/scaffolds (PART B target — step 3 jq merge writes the grant into tracked settings.json, line 397) | yes |
| ai-resources/templates/project-settings.json.template | imports/documents (PART B named target) | **no — already carries no `additionalDirectories` key** (verified: grep returns no hit) |
| ai-resources/docs/permission-template.md | documents (canonical home-of-record; Layer D′ + Detection Rule 8 already prescribe removal — change conforms to it) | no (already aligned; change makes live config match it) |
| ai-resources/.claude/commands/permission-sweep.md | parses + writes (Rule 8 remediation, lines 211–216, jq-writes `additionalDirectories` into the tracked file) | **no per scope, but unaligned — see Blast Radius / Hidden Coupling** |
| ai-resources/.claude/commands/deploy-workflow.md | writes (lines 209–229, same jq pattern writes the grant into a deployed project's tracked settings.json) | **no per scope, but unaligned — see Blast Radius / Hidden Coupling** |
| ai-resources/.claude/agents/permission-sweep-auditor.md | parses (value-class signal reads the `additionalDirectories` path-type field, line 103) | no (advisory detector; tolerant of absence) |

Total: 17 distinct consumers, 12 must-change (11 leaf settings files + `new-project.md` step 3). The named template target is already compliant (no change needed). Two consumers NOT named in CHANGE_DESCRIPTION and explicitly out of scope but materially relevant: `permission-sweep.md` and `deploy-workflow.md` both still write `additionalDirectories` into tracked settings.json via the same jq idiom — leaving them unaligned means the same root-cause writer survives in two other generators (AP-9 residual). Flagged, not blocking the verdict.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pure deletion from config files + one generator edit; no content added to any always-loaded CLAUDE.md, no new hook, no `@import`, no new skill/subagent. Net token delta is negative (removing a 3-line array from 11 files). Evidence: each target carries exactly one `additionalDirectories` array (e.g. strategic-os/.claude/settings.json:50–52; interpersonal-communication/knowledge-base/.claude/settings.json:23–25).
- PART B edits `new-project.md` (a `model: sonnet` orchestrator command, frontmatter line 2) — invoked on demand at project scaffold time, not per session/turn, so no ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`deny` entry is touched — CHANGE_DESCRIPTION asserts "No allow/deny rules change; only the `additionalDirectories` array is deleted," confirmed by inspection of all 11 files.
- `additionalDirectories` IS a permission-surface field (it grants read/write to a directory outside the project root), but the change *removes* a grant from tracked config rather than widening one — the opposite of escalation. The grant is relocated, not destroyed: it moves to the gitignored `settings.local.json` per machine (CHANGE_DESCRIPTION; canonical home at permission-template.md:190–212, Layer D′).
- The relocation is a per-machine *operator follow-up*, explicitly NOT part of this committed change — so the committed surface only ever narrows. No new tool family, no glob widening, no scope escalation, no removed deny. Low.

### Dimension 3: Blast Radius
**Risk:** High

- From the inventory: 12 must-change consumers (11 leaf settings files + `new-project.md`). Eleven tracked files edited directly across multiple git repos: the 7 project repos plus the 4 nested vault/KB directories. >5 must-change consumers ⇒ High by the heuristic.
- **Submodule framing is checkout-dependent — verified.** CHANGE_DESCRIPTION and the mission contract describe the 4 vault/KB files as submodules requiring a parent "pointer bump." In *this* checkout there is **no `.gitmodules`** at the workspace root (file absent), and the 4 directories have **no `.git`** of their own — `git -C projects/repo-documentation ls-files -s vault` returns ordinary blob entries (mode 100644), not gitlinks (mode 160000), and `git -C projects/repo-documentation submodule status` is empty. So here the 4 files commit as ordinary files inside their parent project repos; **no pointer-bump occurs in this checkout.** This *reduces* blast radius on this machine but means the operator's mental model (submodule + pointer bump) may apply on a different clone (e.g. Patrik's). Treat the pointer-bump step as conditional — execute it only where `git submodule status` actually lists the path. Acting on the assumed-submodule model where it does not hold would create spurious empty pointer commits.
- **Contract two canonical resources depend on — but the change conforms to it, not against it.** `permission-template.md` (Layer D′:185 and Detection Rule 8:396) and the named template already prescribe *exactly* this removed-from-tracked / local-home shape. Unlike the prior relative-path plan, this change brings live config *into* agreement with the canonical contract rather than introducing a third form. No canonical-doc edit is forced.
- **Two unanticipated same-contract writers survive (out of scope).** `permission-sweep.md` Rule 8 remediation (lines 211–216) and `deploy-workflow.md` (lines 209–229) both still jq-write `additionalDirectories` into a tracked `settings.json`. Neither is named in CHANGE_DESCRIPTION; the mission scopes only `/new-project` for the generator fix. Consequence: after this change lands, a `/permission-sweep` remediation run or a `/deploy-workflow` deploy will re-introduce the tracked grant into whatever file it touches — the root cause is closed for `/new-project` but not for these two paths. This is the residual AP-9 surface; see Mitigations.
- Shared cross-repo infrastructure (the `ai-resources/` visibility grant) is touched: if a machine relies on the tracked grant and the operator has not yet added the local-file grant, ai-resources symlinks stop resolving for that machine until the per-machine recovery step runs (permission-template.md:214–218 migration note). High.

### Dimension 4: Reversibility
**Risk:** Medium

- For the 7 project-level files and (in this checkout) the 4 nested vault/KB files, the change is a deletion that `git revert` / re-add restores cleanly within each repo's working tree — Low on that subset.
- Multi-repo revert: the edits span the 7 project repos (each its own git repo, per `/new-project`'s standalone-repo convention). A clean rollback is one revert per affected repo — more than one step, but each is mechanical and git-local. Where a different checkout DOES treat vault/KB as submodules, revert there is the two-stage submodule+pointer dance (CHANGE_DESCRIPTION's model) — an extra step on that clone.
- Pushes are operator-gated (CHANGE_DESCRIPTION + mission non-negotiables), so nothing reaches a shared remote without a human gate — revert stays git-local as long as it happens before the wrap-time push.
- One genuine non-git cleanup path: the per-machine `settings.local.json` grant is the *recovery* for the removal, and a `git revert` of the tracked deletion does not remove or reconcile a local-file grant an operator may have already added. But the local file is gitignored and additive, so a stale local grant is harmless (it simply re-grants the same workspace root). Net: revert works, requires per-repo repetition + awareness of the local-file recovery step ⇒ Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One real implicit dependency: the per-machine recovery is out-of-band.** Removing the tracked grant silently relies on each operator running the documented `settings.local.json` step (permission-template.md:214–218) on every machine that needs cross-repo visibility. The dependency IS documented at the canonical site (and in `onboarding-daniel-cheatsheet.md:105`), which keeps this at Medium rather than High — but the coupling is real: a machine that pulls the repo and does nothing loses ai-resources symlink resolution with no in-config signal. The `check-permission-sanity.sh` SessionStart hook + Detection Rule 8 are the intended catchers (Rule 8 now treats absence-from-tracked as expected and flags only when the grant is in *neither* place), so the safety net exists.
- **Functional-overlap coupling (the AP-9 residual): three generators write the same field, only one is being fixed.** `/new-project` (PART B), `/permission-sweep` Rule 8, and `/deploy-workflow` all emit `additionalDirectories` into tracked settings via the identical jq idiom. Fixing only `/new-project` leaves two other systems that will re-introduce the defect on their next run. This is undocumented divergence between the three writers and the now-canonical local-home rule. Medium (one documented dependency + one real overlap; not silent auto-firing in an unexpected context).
- No new parse marker / filename convention / output-format contract is introduced — the change removes a field, it does not add a contract.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base read successfully at projects/strategic-os/ai-strategy/principles-base.md (frozen-ID set confirmed: OP-9, OP-12, DR-1, DR-3, DR-7, AP-7, AP-9).
- **AP-9 (fix the type, not the symptom) — actively SERVED.** The prior plan was flagged AP-9 (leaf-only fix without the generator). This change adds the generator fix (PART B), converting a symptom patch into a root-cause close. The change moves *toward* AP-9 compliance. (Residual: two other generators remain unaligned — a partial, not a violation; see Mitigations.)
- **DR-1 / DR-3 (correct tier / correct home) — actively SERVED.** The change relocates machine-specific config from tracked `settings.json` (wrong home) to gitignored `settings.local.json` (canonical home per Layer D′). This is exactly the home-conventions-are-fixed principle.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — not triggered.** The change removes config and closes a defect for *existing* consumers (11 live files, a live generator); it builds no infrastructure for an absent consumer. The generator fix is licensed by present, repeated breakage, not a hypothetical future.
- **OP-12 (closure before detection) — not triggered / mildly served.** No new detection is added. The existing Detection Rule 8 is *relaxed* to stop flagging the now-correct absence — detection is brought in line with the closure, not added ahead of it.
- No principle is violated; the change either is neutral to or actively serves AP-9, DR-1, DR-3. Low. (No loud principle *revision* is occurring — the canonical decision was already recorded 2026-06-03 in permission-template.md; this change implements it.)

## Mitigations

- **Blast radius (High) — staged, verify-first, per-repo sequence with a portability gate.** Edit and commit one repo at a time; after each commit, grep the just-edited file to confirm the `additionalDirectories` key is gone and `allow`/`deny` are byte-identical to before. Run a workspace-wide `grep -rl "/Users/" --include=settings.json` (excluding `settings.local.json` and `audits/working/`) at the end to confirm zero tracked absolute paths remain — this is the mission's acceptance assertion #1. Do not batch-commit across repos (mission non-negotiable + DR-10).
- **Blast radius (High) — gate the pointer-bump on actual submodule status.** Before any parent "pointer bump," run `git submodule status <path>` (or check for a mode-160000 gitlink) for each of the 4 vault/KB paths. Bump only where the path is a real submodule. In this checkout they are ordinary nested files in the parent project repo — committing them needs no pointer bump, and a forced bump would create a spurious empty commit.
- **Blast radius (High) / Hidden coupling (Medium) — close the residual AP-9 surface or record it as an open thread.** Either (a) fold the same removal into `/permission-sweep` Rule 8 remediation (lines 211–216) and `/deploy-workflow` (lines 209–229) so no generator re-introduces the tracked grant, or (b) if they stay out of scope this session, add an explicit open-thread entry to the mission contract naming both files as remaining root-cause writers — so the close-out is known to be partial and a `/permission-sweep` run is not mistaken for safe. The mission already names only `/new-project` for the generator fix; these two are unlisted.
- **Hidden coupling (Medium) — ship the per-machine recovery step with the change.** When the leaf removals land, surface the ready-to-paste `settings.local.json` snippet (permission-template.md:217) to the operator and confirm each working machine (at minimum Daniel's, given Group 2 carried Daniel's path) has applied it before the session that relies on cross-repo `ai-resources/` visibility. This converts the silent out-of-band dependency into an explicit hand-off.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the 11 target settings.json files were read or grepped (absolute paths confirmed present, 9 Patrik / 2 Daniel); `new-project.md` step 3 jq merge (line 397) and the template's absence of an `additionalDirectories` key were verified directly; submodule status was checked via `.gitmodules` absence, `git -C ... ls-files -s` blob modes, and empty `git submodule status`; principle IDs were read from principles-base.md; the two residual generator writers (`permission-sweep.md`, `deploy-workflow.md`) were located by grep with line numbers. No training-data fallback was used.

## Architectural Commentary

_Standing system-owner second opinion (no fresh `/consult` spawned for this PROCEED-WITH-CAUTION verdict — a cost-conscious deviation from risk-check Step 4a, documented here)._

The System Owner was consulted earlier in this same session (2026-06-26) on the immediately-prior RECONSIDER verdict, and adjudicated the removal-based approach — **"remove from tracked config + per-machine `settings.local.json` + fix `/new-project`"** — as the correct *primary* path (advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-26-settings-additionaldirectories-portability.md`). This risk-check evaluates exactly that recommended redesign, and the verdict softened from RECONSIDER to PROCEED-WITH-CAUTION. The architectural question is settled; the residual CAUTION is mechanical (blast radius across 11 files + two newly-found generators). A second consult on the same approach would add no new architectural signal, so it was skipped deliberately. The four required mitigations are tracked and applied in execution; the two newly-surfaced generators (`/permission-sweep` Rule 8, `/deploy-workflow`) are recorded as mission open-threads (partial close-out, per mitigation #3).

**Empirical correction to the change scope (verified 2026-06-26):** the 4 vault/KB directories are NOT git submodules on this checkout — `git submodule status` is empty in all four parents, and each vault/KB `.claude/settings.json` is tracked by its parent project repo. So there are **no submodule pointer bumps**; `axcion-ai-system-owner` and `repo-documentation` each commit their project-level and vault settings together. Mitigation #2 (gate pointer-bump on real `git submodule status`) is thereby resolved: no bump applies.
