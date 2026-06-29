# Risk Check — 2026-06-29

## Change

Remove the hardcoded absolute workspace-root path (`additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`) from the tracked `settings.json` of 3 already-deployed project repos — `marketing-positioning`, `corporate-identity`, `axcion-brand-book` — to close the `settings-path-portability` mission's retrofit thread (#74). This is the canonical REMOVE approach (NOT relative-path, NOT auto-populating settings.local.json — both rejected by prior risk-check/SO on 2026-06-26). The `additionalDirectories` key and its single-element array are deleted from each tracked file; all sibling keys are preserved (notably `corporate-identity`'s adjacent `"defaultMode": "bypassPermissions"`). Per-machine workspace-root visibility recovery is explicitly OUT of this change — it is left to the operator's gitignored `settings.local.json` recovery snippet documented at `docs/settings-local-recovery.md`. Commit per-repo (3 independent git repos) with explicit-path staging (a concurrent session is live elsewhere in the workspace). Push is gated to session wrap.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/.claude/settings.json — exists (abs path at line 32)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/.claude/settings.json — exists (abs path at line 31; adjacent defaultMode bypassPermissions)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json — exists (abs path at line 67)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/settings-local-recovery.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/settings-path-portability.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** This is the direct, principle-aligned continuation of an already-executed and already-risk-checked campaign (same change shape applied to 11 files on 2026-06-26 under PROCEED-WITH-CAUTION); the only elevated dimension is a moderate blast radius (3 independent git repos, one per-machine recovery dependency), fully mitigable with the verify-first per-repo sequence and a recovery hand-off that already exists in `settings-local-recovery.md`.

## Consumer Inventory

The change deletes the `additionalDirectories` field from 3 tracked files and depends on the gitignored `settings.local.json` recovery contract. Functional consumers of the field/contract were grepped across `ai-resources/` and the workspace root. The ~45 `additionalDirectories` grep hits in `ai-resources/audits/**` are historical audit records (point-in-time snapshots), NOT live consumers — they are excluded from the table. No command, agent, or hook hard-wires any of the 3 target file paths (`grep` of `ai-resources/.claude`, `skills`, `workflows` for the three `*/.claude/settings` paths returns empty).

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/marketing-positioning/.claude/settings.json | co-edits (PART A target — abs path line 32) | yes |
| projects/corporate-identity/.claude/settings.json | co-edits (PART A target — abs path line 31) | yes |
| projects/axcion-brand-book/.claude/settings.json | co-edits (PART A target — abs path line 67) | yes |
| ai-resources/docs/settings-local-recovery.md | documents (the recovery contract this change relies on; names the post-removal per-machine snippet) | no (already aligned; change is exactly what this doc anticipates) |
| ai-resources/docs/permission-template.md | documents (canonical home-of-record; Layer D′ + Detection Rule 8 prescribe removed-from-tracked / local-home — change conforms) | no (already aligned; Rule 8 line 392 explicitly names this retrofit as the remaining open thread) |
| ai-resources/.claude/agents/permission-sweep-auditor.md | parses (value-class signal reads the `additionalDirectories` path-type field) | no (advisory detector; tolerant of absence — Rule 8 treats absence-from-tracked as expected, not a finding) |
| ai-resources/.claude/commands/permission-sweep.md | parses + writes (Rule 8 remediation — already aligned 2026-06-27 to relocate any tracked grant to local) | no (already aligned this same mission) |
| ai-resources/.claude/commands/deploy-workflow.md | writes (grant sub-step — already aligned 2026-06-27 to write to settings.local.json) | no (already aligned this same mission) |
| ai-resources/.claude/commands/new-project.md | writes (step 3 — already aligned 2026-06-26 to write to settings.local.json) | no (already aligned this same mission) |
| ai-resources/logs/missions/settings-path-portability.md | documents (mission contract — open thread #74 is exactly this retrofit) | no (operator updates thread state via `/mission` after landing; not a code consumer) |

Total: 10 distinct consumers, 3 must-change (the 3 leaf settings files). Every functional generator/auditor that previously wrote or read this field was already aligned earlier in this same mission (2026-06-26 / 2026-06-27) — so unlike the 2026-06-26 batch, there is NO residual AP-9 writer to flag here. The retrofit closes the last consumers of the defect class, not the first.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pure deletion from 3 config files; no content added to any always-loaded CLAUDE.md, no new hook, no `@import`, no new skill/subagent. Net token delta is negative (removing a 3-line array ×3). Evidence: each target carries exactly one `additionalDirectories` array (marketing-positioning:31–33, corporate-identity:30–32, axcion-brand-book:66–68).
- No generator/template edit this round (those were fixed earlier in the mission) — so no command body grows. Zero ongoing per-session or per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`deny` entry is touched — CHANGE_DESCRIPTION asserts "all sibling keys are preserved," confirmed by inspection: marketing-positioning allow/deny (lines 4–29), corporate-identity allow/deny (lines 3–28), axcion-brand-book allow/deny (lines 4–64) are all outside the deleted array.
- `additionalDirectories` IS a permission-surface field (grants read/write to a directory outside the project root), but the change *removes* a grant from tracked config rather than widening one — the opposite of escalation. The committed surface only ever narrows.
- The grant is relocated, not destroyed: per-machine recovery to the gitignored `settings.local.json` (canonical home, permission-template.md Layer D′ lines 186–214). That relocation is explicitly OUT of this committed change (operator follow-up), so this change introduces no new tool family, no glob widening, no scope escalation, no removed deny. Low.

### Dimension 3: Blast Radius
**Risk:** Medium

- From the inventory: 3 must-change consumers (the 3 leaf settings files), all directly named in CHANGE_DESCRIPTION. 3 files ≤ 5 ⇒ the must-change count alone is Medium-band, not High.
- **Three independent git repos — verified.** Each target has its own `.git` (`git -C <project>` confirms OWN .git present for all three). So the change is 3 separate per-repo commits, not one — this is what lifts it above a single-isolated-file Low. No submodule pointer-bump applies (none of the three is a submodule of the workspace repo).
- **Contract conformance, not contract break.** The two canonical docs that depend on this field's placement — `permission-template.md` (Layer D′; Detection Rule 8 line 392) and `settings-local-recovery.md` — already prescribe *exactly* the removed-from-tracked shape. Rule 8 line 392 names this retrofit as "the one remaining open thread." So the change brings live config INTO agreement with the canonical contract; no canonical-doc edit is forced and no parser breaks.
- **Shared cross-repo infrastructure touched (the visibility grant).** After removal, a project session on a machine that relied on the tracked grant loses `ai-resources/` symlink resolution until the per-machine `settings.local.json` recovery snippet runs. This is a real downstream effect but is the *accepted, operator-approved* trade-off (mission thread #74; heads-up SENT 2026-06-27) and is bounded to this machine. Not >5 callers, no contract break ⇒ Medium, not High.
- No unanticipated consumer surfaced: the inventory grep found no command/agent/hook hard-wiring the 3 target files, and every functional field-writer was already aligned earlier in the mission.

### Dimension 4: Reversibility
**Risk:** Medium

- Each edit is a deletion that `git revert` / re-add restores cleanly within that repo's working tree — Low on the per-file mechanics.
- Multi-repo revert: a clean rollback is one revert per affected repo (3 independent repos). More than one step, but each is mechanical and git-local ⇒ Medium by the heuristic (revert works, requires per-repo repetition).
- Pushes are operator-gated and batched to wrap (CHANGE_DESCRIPTION + mission non-negotiables) — nothing reaches a shared remote without a human gate, so revert stays git-local as long as it happens before the wrap-time push.
- One non-git awareness item: the per-machine `settings.local.json` grant is the *recovery* for the removal; a `git revert` of the tracked deletion does not remove or reconcile a local-file grant the operator may have already added. But that local file is gitignored and additive — a stale local grant is harmless (it simply re-grants the same workspace root). Net: Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One real implicit dependency: the per-machine recovery is out-of-band.** Removing the tracked grant silently relies on each operator running the documented `settings.local.json` snippet (settings-local-recovery.md lines 25–52; permission-template.md migration note lines 210–214) on every machine that needs cross-repo visibility. The dependency IS documented at the canonical site AND the heads-up was sent (mission thread #76, SENT 2026-06-27), which keeps this at Medium not High — but the coupling is real: a machine that pulls and does nothing loses `ai-resources/` symlink resolution with no in-config signal. The `check-permission-sanity.sh` SessionStart hook + Detection Rule 8 are the intended catchers (Rule 8 flags only when the grant is in *neither* tracked nor local).
- **gitignore-source nuance for axcion-brand-book (newly surfaced).** marketing-positioning and corporate-identity ignore `settings.local.json` via their own project `.gitignore` (`.claude/settings.local.json` line present). axcion-brand-book's project `.gitignore` does NOT contain that pattern — its `settings.local.json` is ignored only via the per-machine global ignore `~/.config/git/ignore` (`**/.claude/settings.local.json`). `git check-ignore` confirms the local file IS ignored on THIS machine, so the recovery layer is safe here — but the protection is machine-global config, not repo-tracked. On a different clone whose global ignore lacks that line, a recovery `settings.local.json` in axcion-brand-book could be accidentally committed. This is a latent coupling, not a defect in this change; flag it so the recovery hand-off for axcion-brand-book notes the repo-local gitignore gap.
- No new parse marker / filename convention / output-format contract is introduced — the change removes a field. No functional-overlap residual (all field-writers already aligned). Medium (driven by the out-of-band recovery + the axcion-brand-book gitignore-source nuance).

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base read successfully at projects/strategic-os/ai-strategy/principles-base.md (frozen-ID set confirmed: OP-9, OP-10, OP-12, DR-1, DR-3, DR-7, DR-10, AP-7, AP-9).
- **AP-9 (fix the type, not the symptom) — actively SERVED.** This retrofit is the closing move on a root-cause campaign: the generators were already fixed (`/new-project`, `/deploy-workflow`, `/permission-sweep`), and this removes the last leaf instances of the same defect class. It is symptom-cleanup behind an already-closed root cause, not a leaf-only patch that leaves the generator open.
- **DR-1 / DR-3 (correct tier / correct home) — actively SERVED.** Relocates machine-specific config from tracked `settings.json` (wrong home) to the gitignored `settings.local.json` (canonical home per Layer D′). Textbook home-conventions-are-fixed compliance.
- **DR-10 (no directory wildcards for git add during concurrent sessions) — actively SERVED.** CHANGE_DESCRIPTION specifies "explicit-path staging (a concurrent session is live elsewhere)" and per-repo commits — exactly DR-10's requirement. The change honours the principle rather than tensioning it.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — not triggered.** The change removes config for *existing* live files; it builds no infrastructure for an absent consumer. Closes a defect; adds nothing.
- **OP-12 (closure before detection) — not triggered / mildly served.** No new detection added; this is closure of an existing, already-detected finding (Rule 8 / mission thread #74).
- **OP-10 (system boundary) — not triggered.** Change is entirely within Claude Code config; no cross-tool reach.
- No principle is violated; the change actively serves AP-9, DR-1, DR-3, DR-10. No loud principle *revision* is occurring — the canonical decision was recorded 2026-06-03 (permission-template.md Layer D line 181) and re-affirmed across the mission; this change implements it. Low.

## Mitigations

- **Blast radius (Medium) — verify-first, per-repo, explicit-path staging.** Edit and commit one repo at a time. After each edit, re-read the just-edited file and confirm (a) the `additionalDirectories` key is gone, (b) the file is valid JSON, (c) `allow`/`deny` and — for corporate-identity — the adjacent `"defaultMode": "bypassPermissions"` (line 33) are byte-identical to before. Stage each file by explicit path (never `git add -A` / directory wildcards) because a concurrent session is live (DR-10). Do not batch-commit across the 3 repos.
- **Hidden coupling (Medium) — ship the per-machine recovery hand-off, and note the axcion-brand-book gitignore gap.** When the removals land, surface the ready-to-paste `settings.local.json` snippet (settings-local-recovery.md lines 29–52) for each of the 3 projects, and confirm any working machine that relies on cross-repo `ai-resources/` visibility has applied it. For axcion-brand-book specifically, note in the hand-off that its `settings.local.json` is ignored only via the machine-global `~/.config/git/ignore` — recommend adding `.claude/settings.local.json` to the project's own `.gitignore` so the recovery file is protected on any clone, not just this machine.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the 3 target files were read (abs paths confirmed at marketing-positioning:32, corporate-identity:31, axcion-brand-book:67; sibling keys and the corporate-identity defaultMode at line 33 inspected); repo independence verified via per-project `.git` presence and empty submodule status; `settings.local.json` gitignore status verified per-repo via `git check-ignore -v` (marketing-positioning + corporate-identity via project `.gitignore`, axcion-brand-book via `~/.config/git/ignore`); the consumer set was grepped across `ai-resources/` and the workspace root (no command/agent/hook hard-wires the 3 files; all field-writers already aligned); the canonical contract (permission-template.md Layer D′ lines 186–214, Detection Rule 8 line 392) and the recovery doc were read; principle IDs were read from principles-base.md. The prior risk-check for the identical change shape (2026-06-26 removal, PROCEED-WITH-CAUTION) was read for continuity. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-29-risk-check-2nd-opinion-settings-retrofit-remove-additionaldirectories.md

**Concurrence:** Concur with PROCEED-WITH-CAUTION. Dimension scoring sound; mitigations are the right ones.

**Why the verdict holds:**
- Closing leaf-cleanup behind an already-fixed generator set — the served side of AP-9, not a leaf patch (principles.md § AP-9).
- Committed permission surface only narrows; removing a grant is the opposite of escalation (§ DR-3; risk-topology.md § 3).
- Explicit-path per-repo staging under a live concurrent session is exactly § DR-10.
- Blast radius Medium correctly floored: 3 files (≤5), 3 independent repos, no submodule bump, no contract break — live config brought into agreement with canonical contract.

**Recommended path endorsed** — verify-first per-repo staging + ship the recovery snippet + add `.claude/settings.local.json` to axcion-brand-book's repo-local `.gitignore`. The gitignore line is the correct structural call, not a patch.

**Two additions:**
1. Fold axcion-brand-book's `.gitignore` line into the SAME commit as its key removal — one logical unit; splitting leaves a window where its recovery file is unprotected on a fresh clone.
2. Currency defect the dimension review under-weighted [load-bearing]: `settings-local-recovery.md` lines 18-21 state the retrofit "across existing projects" already happened on 2026-06-26. It did not — thread #74 is still open and this IS that change. Tighten that sentence in the same session (§ OP-11 doc-vs-system drift).

**One residual named plainly:** Rule 8 only fires when the grant is in neither tracked nor local — so on a machine that never had a local grant, lost visibility is silent until a skill fails mid-session. Treat "confirm each machine applied the snippet" as a GATE on declaring #74 done, not a courtesy (§ OP-3).

**Position:** Proceed under PROCEED-WITH-CAUTION with the recommended mitigations plus the two additions. No principle violated; the change serves AP-9, DR-1/DR-3, DR-10. Shared-remote push stays operator-gated to wrap.
