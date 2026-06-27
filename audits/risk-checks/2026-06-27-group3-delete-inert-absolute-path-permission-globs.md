# Risk Check — 2026-06-27

## Change

Delete 6 inert, redundant absolute-path Edit()/Write() permission-glob lines across two tracked settings.json files (Group 3 of mission settings-path-portability): ai-resources/.claude/settings.json lines 20-21, and workspace-root .claude/settings.json lines 21-24. Both files run defaultMode=bypassPermissions so the allow-rules are ignored at runtime; the globs use a single leading slash (project-root-relative) so they match nothing. These are the last /Users/ absolute paths in any tracked settings.json — deletion closes mission acceptance assertion #1. Rewrite none. Also a documentation-only fix to the mission Open-threads note (correct 4 stale facts). Push deferred to wrap (operator-gated).

The exact lines:
- ai-resources/.claude/settings.json:20 — "Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)"
- ai-resources/.claude/settings.json:21 — "Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)"
- workspace-root .claude/settings.json:21 — "Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)"
- workspace-root .claude/settings.json:22 — "Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)"
- workspace-root .claude/settings.json:23 — "Edit(/Users/patrik.lindeberg/.claude/projects/**)"
- workspace-root .claude/settings.json:24 — "Write(/Users/patrik.lindeberg/.claude/projects/**)"

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/settings-path-portability.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The deletions are runtime-inert and revert-clean, but they silently diverge the two deployed settings files from the canonical `permission-template.md`, which still declares these exact lines canonical (line 146: "intentional and canonical... Document such findings as resolved without action") — so the change must be paired with a loud, recorded update to the template (OP-11), or `/permission-sweep` will re-flag and re-add the deleted lines.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/docs/permission-template.md` (Layer B, lines 68-69; Layer C, lines 127-128; key-assertion line 146) | parses (canonical drift-comparison source for `/permission-sweep`) | yes |
| `ai-resources/.claude/hooks/check-permission-sanity.sh` | parses (SessionStart drift nudge) — checks only `defaultMode` + safety-floor denies, NOT allow-list contents (lines 29, 48-64) | no |
| `ai-resources/logs/missions/settings-path-portability.md` (acceptance assertion #1, Group 3 open thread, lines 44, 69) | documents | yes (the doc-only Open-threads fix is in scope of this change) |
| `ai-resources/audits/permission-sweep-2026-05-08-v2-restricted-applied.md`, `audits/working/permission-sweep-2026-05-*.md` (Rule 9 / canonical allow-list snapshots) | documents (historical audit records) | no |
| `ai-resources/audits/repo-health-report-2026-05-16*.md`, `reports/repo-health-report-2026-05-16-*.md` | documents (historical finding records) | no |
| `ai-resources/audits/risk-checks/2026-05-*.md` (×8 prior risk-checks citing `Write(/Users/.../Axcion AI Repo/**)` as the authorizing grant for hook writes) | documents (historical justification; not live config) | no |
| `ai-resources/logs/decisions-archive-2026-04.md` (line 71), `decisions-archive-2026-05.md` (line 485) | documents (decision history) | no |
| `projects/*/pipeline/repo-snapshot.md` (×4+ — axcion-website, nordic-pe-screening, marketing-positioning, axcion-copy-factory) | documents (point-in-time config snapshots) | no |
| `projects/axcion-copy-factory/logs/session-plan-2026-06-27-S3.md` (lines 17-18) | documents (this session's own plan) | no |

Total: 9 distinct consumer classes, 2 must-change (the canonical template, and the mission doc whose fix is already in scope). The `.git/worktrees/...` and `../Personal Repo`, `travel-os` hits are untracked worktree copies and out-of-mission repos respectively — not consumers of these two files' contract.

**Blast-radius gap not anticipated by CHANGE_DESCRIPTION:** the change names only the two settings files and the mission note. It does NOT mention `permission-template.md`, which is the canonical source `/permission-sweep` compares deployed settings against. Lines 68-69 and 127-128 of that template list the deleted globs as canonical Layer B / Layer C entries, and line 146 explicitly instructs tools to treat removal-recommendations as false positives. This is the primary finding (Dimensions 3, 5, 6).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Net token reduction. Six allow-list lines are removed from two always-present `settings.json` files; nothing is added to any always-loaded file. Evidence: lines 20-21 of `ai-resources/.claude/settings.json` and 21-24 of `.claude/settings.json` (confirmed against file bytes).
- No hook registered, no `@import` added, no subagent brief expanded. The documentation-only mission-note fix edits `ai-resources/logs/missions/settings-path-portability.md`, which is not auto-loaded (read only via `/mission`).

### Dimension 2: Permissions Surface
**Risk:** Low

- The change REMOVES allow entries; it does not widen the surface. No `deny` rule is removed or narrowed (deny arrays at `ai-resources/.claude/settings.json:24-33` and `.claude/settings.json:27-35` are untouched).
- The removed grants are runtime-inert: both files carry `"defaultMode": "bypassPermissions"` (confirmed at `ai-resources/.claude/settings.json:34` and `.claude/settings.json:26`), so the entire `allow` list is not consulted at runtime. Removing inert entries cannot change effective capability.
- Glob-form fact confirmed against bytes: all six globs use a single leading slash (`/Users/...`), which Claude Code reads as project-root-relative, so they match nothing even if `allow` were consulted (corroborated by mission note line 66 and the canonical glob-form table). No capability is lost in practice.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 2 settings files + 1 mission doc (in-scope doc fix) = 3.
- Consumer inventory (above): 9 consumer classes, 2 must-change. The only live (non-historical) must-change consumer is `ai-resources/docs/permission-template.md`.
- Contract touched: the canonical allow-list shape that `/permission-sweep` Rule 9 / canonical-comparison reads from `permission-template.md`. After deletion, the deployed Layer B and Layer C `allow` lists no longer match the template's canonical lists (`permission-template.md:64-71` Layer B, `:122-130` Layer C). A future `/permission-sweep` will compute the deleted lines as missing-canonical drift and propose re-adding them — re-introducing the defect the mission is trying to close.
- Shared infra: `ai-resources/.claude/settings.json` is the shared (committed) Layer C file consumed by every ai-resources session; the workspace-root file is local-only/non-shared per the mission scope (line 31). Removing inert entries does not break any session at runtime (Dimension 2), so the blast radius is contract-divergence, not functional breakage — hence Medium, not High.
- The SessionStart hook `check-permission-sanity.sh` is NOT a must-change consumer: it inspects only `defaultMode` and the two safety-floor denies (lines 29, 56), never the allow-list contents — so it will not nudge on this deletion.

### Dimension 4: Reversibility
**Risk:** Low

- Pure single-tree text deletions in two tracked files plus a doc edit; `git revert` (or re-adding the six lines) fully restores prior state. No sibling files created, no log/registry mutation, no `settings.json` structural change beyond allow-list lines.
- No state propagates beyond git: push is explicitly deferred to wrap and operator-gated (CHANGE_DESCRIPTION; corroborated by mission non-negotiable line 54). Nothing fires between landing and a potential revert — no hook keys off the allow-list.
- The workspace-root file is local-only/non-shared, so a revert there has no cross-machine footprint.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Implicit dependency on `permission-template.md` not named in the change. The two settings files are derived artifacts of the canonical template (Layer B and Layer C "Canonical shape" blocks). Editing the deployed files without editing the template creates a silent practice-vs-spec divergence that only surfaces later when `/permission-sweep` runs — a delayed, non-obvious coupling.
- Direct contradiction with the canonical key-assertion. `permission-template.md:146` states the absolute-path allow entries are "intentional and canonical... cannot be replaced... Audit tools that flag these as 'stale hardcoded paths' are producing a false positive against this layer. Document such findings as resolved without action." The change does the opposite of the standing canonical instruction, and the change description does not acknowledge or resolve that contradiction.
- Mild internal tension in the mission record itself: the mission resume pointer (lines 64-66) frames Group 3 as a "delete-or-rewrite" decision and treats deletion as the lean canonical path, but the canonical template (line 146) has not been updated to match — so two canonical-ish sources disagree. Per the workspace Design Judgment Principle "Conflicts must be surfaced, not silently resolved," this conflict must be made explicit before landing.
- No silent auto-firing introduced; no functional overlap created. Medium (not High) because there is exactly one undocumented contract dependency (the template) and it is fully resolvable by a paired edit.

### Dimension 6: Principle Alignment
**Risk:** Medium

- Principles-base read successfully at `projects/strategic-os/ai-strategy/principles-base.md`.
- **OP-11 / OP-3 (loud revision, never silent drift) — primary.** Removing lines that `permission-template.md:146` declares canonical is, in effect, a revision of the canonical permission spec. OP-11 permits revising a guardrail/principle, but only as "an explicit, recorded evolution, never silent drift" (principles-base line 49), and OP-3 requires loud surfacing of practice-vs-principle divergence (line 41). The change is legitimate IF the template is updated in the same pass to record that the absolute-path globs are retired as portability defects; it is a violation if the deployed files are quietly diverged and the template left contradicting them. Because the change is mid-mission with a recorded decision trail (mission resume pointer, two prior risk-checks, an SO consult) AND a viable loud-recording path exists, this is scored Medium (tension), not High — the revision is on-the-record at the mission level but not yet propagated to the canonical doc.
- **OP-5 (advisory vs enforcement) — not triggered.** No advisory mechanism is moved toward enforcement; the change removes inert config, it does not grant auto-action authority.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** The change removes config rather than building for an absent consumer; if anything it reduces surface.
- **DR-1 / DR-3 (placement) — aligned.** Machine-specific absolute paths belong in gitignored `settings.local.json`, not tracked `settings.json` (per `permission-template.md:185`, Layer D′). Removing them from tracked files moves toward correct placement.
- **OP-12 (closure before detection) — aligned.** This is closure work (closing mission acceptance assertion #1), not new detection.

## Mitigations

- **Dimension 3 / 5 / 6 (the single paired mitigation that covers all three):** In the SAME change, update `ai-resources/docs/permission-template.md` so the canonical Layer B (lines 64-71) and Layer C (lines 122-130) shapes drop the two `Edit(/Users/.../**)` / `Write(/Users/.../**)` entries, and rewrite the line-146 key-assertion ("intentional and canonical... document as resolved without action") to record that these absolute-path globs are RETIRED as portability defects under the settings-path-portability mission (cite the mission and the 2026-06-26 canonical decision). This converts a silent drift into a loud, recorded revision (OP-11/OP-3), keeps `/permission-sweep`'s canonical-comparison aligned so it will not re-add the deleted lines (Dimension 3), and removes the undocumented template dependency (Dimension 5). Without this paired edit, the deletion regresses on the next `/permission-sweep`.
- **Dimension 5 (conflict-surfacing):** Before committing, state the `permission-template.md:146`-vs-deletion conflict explicitly to the operator (per workspace Design Judgment Principle "Conflicts must be surfaced, not silently resolved") and confirm the template update is the agreed resolution.
- **Secondary (workspace-root `.claude/projects/**` lines 23-24):** confirm these two lines are genuinely inert before deletion. `~/.claude/projects` exists on disk, but the single-leading-slash form means the glob resolves project-root-relative (not home-relative), so it does not match that directory — inert as claimed. No separate mitigation needed; noted for completeness since these two lines are absent from the canonical template entirely (they are local-only extras, so deleting them does not create template drift).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references verified against actual bytes (both settings files read in full; `permission-template.md` lines 55-146 and 185-397 read; `check-permission-sanity.sh` read in full; principles-base grepped by ID; mission doc read in full), plus grep counts across the repo and the workspace root for the deleted glob strings. The `defaultMode: bypassPermissions` and single-leading-slash glob facts were confirmed against the actual file bytes as requested. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

I verified the conflict against bytes rather than trusting the relayed claims. One finding the brief did not flag: **the line-146 citation "(See logs/decisions.md 2026-05-16.)" points to an entry that does not exist** — the workspace-root decisions journal jumps 2026-05-12 → 2026-05-19, and ai-resources has no 2026-05-16 permission entry either. The rationale's own authority is unverifiable.

> **CORRECTION (main session, end-gate scan).** The SO finding above is partly wrong: the 2026-05-16 decision IS real — it lives in `ai-resources/logs/decisions-archive-2026-05.md` ("Reject audit finding: hardcoded absolute paths in ai-resources Layer C settings.json"). The live `decisions.md` jumps 2026-05-12 → 2026-05-19 only because the May entries were moved to the monthly archive; the citation went **stale at archival, not phantom**. The decision is still correctly overturned — its premise (single-slash `/Users/...` matches absolute edits via "literal matching") is **verified false** against the official Claude Code docs (single-slash = project-root-relative; absolute needs `//`), confirmed via the `claude-code-guide` agent ([code.claude.com/docs/en/permissions](https://code.claude.com/docs/en/permissions.md)). So the conclusion (delete + replace the rationale) stands; only the "non-existent citation" sub-claim is corrected.

**Q1 — Concur with PROCEED-WITH-CAUTION and folding the template fix in: yes.** This supersedes my earlier "low blast radius" read on one point — I scoped blast radius to runtime; `/risk-check` did the consumer inventory I deferred and found a documentation-plane consumer (`permission-template.md`, read by `/permission-sweep` + `/new-project`). Deleting deployed lines without fixing the spec diverges config from spec (OP-11/OP-3) and creates a self-reverting re-addition loop (line 146 tells the next sweep to re-add them). Fold the update in; PROCEED-WITH-CAUTION is binding, do not downgrade (DR-8).

**Q2 — Mission wins; the 2026-05-16 premise is factually wrong.** The two sources make a testable claim that can't both be true. The lines are demonstrably inert (match nothing) — that falsifies line 146's "they match absolute paths" premise. Correcting it matters more than deleting the lines: line 146 *instructs audits to suppress findings* ("document as resolved without action") — that's the mechanism keeping the defect alive. Replace the rationale, don't just delete the lines. `[CITATION NEEDED]`: verify the precise single-slash/double-slash glob rule against Claude Code docs before writing the new canonical fact — don't repeat line 146's error by asserting the inverse unverified.

**Q3 — Lands today as one atomic change** (settings deletes + template correction Layer B/C/line-146 + a superseding decisions entry). The template fix is root-cause closure of the same defect, not a new workstream — mission-in-scope even if outside the original acceptance assertions. One carve-out: the new decisions entry must record that the prior premise was false AND its cited authority couldn't be located; write the entry that should have existed, don't cite the phantom one. Log the dangling-citation pattern (canonical doc → non-existent decision) to `/friday-checkup` as a possible class defect — separate audit, not chased now (DR-7).

_Full SO advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-27-group3-template-conflict-second-opinion.md`._
