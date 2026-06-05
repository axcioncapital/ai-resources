# Risk Check — 2026-06-05

## Change

Batch of 7 vetted Do-now structural/harness-config changes in ai-resources, from /diagnostics-plan (SO-triaged 2026-06-05). Evaluate as one batch:

1. id-01/02/03 — Edit ai-resources/.claude/settings.local.json: restore `defaultMode: bypassPermissions` and add bare allow entries (Edit, Write, Bash(*)) so the zero-prompt working mode is restored. Currently the file lacks defaultMode (shadows bypassPermissions, prompts every session) and the allow list has only 5 narrow Bash entries. STANDING RULE: NEVER add a "model" field; bypassPermissions is the agreed floor (operator-confirmed setup).

2. id-06 — Add `Read(audits/working/**)` deny rule to ai-resources settings (226 stale-scratch files, ~24,700 lines never needed at read time).

3. id-22 — Narrow the existing `Read(logs/*archive*.md)` deny so improvement-analyst can read logs/improvement-log-archive.md for archive de-dup (recurrence confirmed: the analyst could not read the archive this run).

4. id-10/11/12/25/26 — One ai-resources CLAUDE.md de-dup pass: trim cross-file mirror blocks (Commit Rules, Model Selection, Session Boundaries) to pointers, delete the within-file Git Rules push-clause dup, refresh the stale Maintenance Cadence subsumption clause + unresolvable R-id refs. KEEP the model-default-prohibition text verbatim (standing rule).

5. id-04 — /new-project Step 5b: replace autonomous `git push` with the gated-push confirmation prompt (contradicts the gated-push rule; auto-synced to 3 projects).

6. id-18 — /wrap-session push gate: add a pre-push `git fetch` + divergence check / pull before push (concurrent-machine push rejection currently structurally guaranteed).

7. id-37 — Replace 3 byte-copy research-workflow command files with relative symlinks to canonical (DR-1/DR-3 home-convention correctness; new-symlink class).

Files in scope: ai-resources/.claude/settings.local.json, ai-resources/CLAUDE.md, ai-resources/.claude/commands/new-project.md (+ paired/synced copies), ai-resources/.claude/commands/wrap-session.md (+ workspace-root paired copy), 3 research-workflow command files. The SO advisory (consult-2026-06-05-diagnostics-plan-ai-resources.md) vetted all 7 as Do-now and flagged each gated. Evaluate the batch across the six risk dimensions and return a verdict, ideally per-item where risk diverges.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Six of seven items are low-risk config/doc hygiene, but a material grounding gap — several items (id-01/02/03 defaultMode, id-04 push, id-18 fetch/divergence) already appear shipped on disk and contradict the "currently absent" framing in the change description — plus the cross-machine semantics of the deny narrowing (id-22) and the symlink class (id-37) raise blast-radius and reversibility risk that needs paired mitigation before landing.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/settings.json | co-edits | yes (id-06/id-22 denies live here, NOT in settings.local.json) |
| ai-resources/.claude/commands/resolve-improvement-log.md | parses | yes (id-22: explicit "do NOT read archive — deny at settings.json line 32" guard must be revised) |
| ai-resources/.claude/commands/improve.md | parses | yes (id-22: line 21 "archive excluded due to Read(logs/*archive*.md) deny" rationale becomes stale) |
| ai-resources/.claude/commands/friday-checkup.md | invokes | no (id-22: improvement-analyst brief at line 236 already passes the archive "if present" — this is the recurrence the change fixes) |
| ai-resources/.claude/agents/session-feedback-collector.md | parses | no (dedup reads archive "if supplied"; benefits from id-22, no change required) |
| ai-resources/.claude/agents/fix-repo-issues-scanner.md | parses | no (id-22: line 112 treats archive as "closed by design / not scanned" — independent of read-deny; verify) |
| ai-resources/.claude/commands/post-project-review.md | parses | no (reads project-local archive "if present"; ai-resources deny narrowing does not affect project layer) |
| ai-resources/docs/permission-template.md | documents | yes (id-22: line 134 lists `Read(logs/*-archive-*.md)` as canonical shape — narrowing must be reflected or template drifts) |
| ai-resources/.claude/hooks/check-permission-sanity.sh | parses | no (id-01/02/03: nudges on missing defaultMode; restoring it keeps the hook quiet) |
| Workspace-root /.claude/commands/wrap-session.md | co-edits | yes (id-18: PAIRED non-symlink copy; Step 6 push gate must stay in sync — already mirrored on disk) |
| Workspace-root /.claude/commands/new-project.md | co-edits | yes (id-04: paired copy; push clause must stay in sync — already mirrored on disk) |
| Workspace-root /.claude/commands/{analyze,sync,deploy}-workflow.md | co-edits | yes (id-37: byte-identical copies; symlink decision affects which is canonical) |
| projects/*/.claude/commands/{analyze,sync,deploy}-workflow.md (~9 projects) | imports | no (id-37/id-04: already relative symlinks INTO ai-resources canonical; inherit changes automatically via auto-sync hook) |
| ai-resources/.claude/hooks/auto-sync-shared.sh | invokes | no (id-37: emits relative symlinks; mismatch-detection at line 17 flags byte-copies that differ from canonical — relevant to symlink topology) |
| ai-resources/CLAUDE.md (self) | co-edits | yes (id-10/11/12/25/26: the de-dup target file itself) |

Total: 15 distinct consumers, 8 must-change. Notable gap vs change description: the deny rules id-06 and id-22 target `settings.json`, not `settings.local.json` (evidence: settings.json lines 22-31 hold the deny block; settings.local.json has no deny key). The change description's framing ("ai-resources settings") is correct only if it means settings.json — the operator must edit the right file.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- id-01/02/03 add ~3 short allow strings + one `defaultMode` key to settings.local.json — not an always-loaded context file; zero per-turn token cost. Evidence: settings.local.json is a permissions config, not `@import`-ed into any CLAUDE.md.
- id-06/id-22 add/narrow deny strings in settings.json — config only, no token cost. id-06 (`Read(audits/working/**)`) *reduces* future Glob/Grep/Read exposure to 226 files / ~24,700 lines (token-audit-2026-06-05 line 250) — a usage-cost *improvement*.
- id-10/11/12/25/26 trim ai-resources/CLAUDE.md, which IS always-loaded (project instructions). Net effect is *removal* of mirror blocks (Commit Rules lines 73-85, Model Selection lines 29-31 cross-refs, Session Boundaries lines 96-98) → fewer always-loaded tokens. Improvement, not cost.
- id-04/id-18/id-37 edit command files (pay-as-used, not always-loaded) — no ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** Medium

- id-01/02/03 restore `defaultMode: bypassPermissions` in settings.local.json. **Grounding contradiction:** the change states the file "lacks defaultMode" — but settings.local.json line 9 already contains `"defaultMode": "bypassPermissions"`. On disk this item is largely already applied; verify before editing to avoid a no-op or accidental duplication.
- The broad allow entries the change wants "added bare" (`Bash(*)`, `Edit`, `Write`) **already exist in settings.json** (lines 4, 6, 7). Adding them again to settings.local.json is redundant surface, not new capability — but `Bash(*)` is the maximal Bash grant; duplicating it across two settings layers widens nothing but muddies which layer is authoritative.
- Per the operator standing rule (workspace CLAUDE.md → Autonomy Rules; MEMORY zero-permission-prompts), bypassPermissions is the agreed floor — so restoring/keeping it is *aligned*, not an escalation. Net new capability: none. Risk is Medium only because `Bash(*)` duplication across layers is a surface-clarity concern, and the standing "NEVER add a model field" rule must be honored (it is — no model field proposed).
- id-22 *narrows* a deny (removes archive-read protection for one file) — a deliberate, scoped widening of read surface for the improvement-analyst. Bounded to `improvement-log-archive.md`; acceptable but must be done by tightening the glob, not deleting the deny wholesale (two denies match: `Read(logs/*-archive-*.md)` line 28 AND `Read(logs/*archive*.md)` line 32 — both match the archive filename; **both** must be narrowed or the deny still bites).

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory found **15 consumers, 8 must-change** — above the Low ceiling (0-2 callers).
- **id-22 is the widest-radius item.** Narrowing the archive-read deny touches a documented contract honored by at least 3 must-change consumers: `resolve-improvement-log.md` (line 103: "Do NOT read the archive... denies `Read(logs/*archive*.md)` (line 32)... will hit the deny rule"), `improve.md` (line 21: archive "excluded... due to a `Read(logs/*archive*.md)` deny rule"), and `permission-template.md` (line 134, canonical shape). If the deny is narrowed but these rationales are not updated, the codebase will carry stale "you cannot read the archive" guidance contradicting the new reality — a silent contract drift. Two deny globs match the archive (settings.json lines 28 + 32); a partial narrow leaves the file still blocked.
- **id-37 symlink class:** the 3 research-workflow command files exist as byte-identical copies at BOTH workspace-root `/.claude/commands/` and `ai-resources/.claude/commands/` (verified IDENTICAL). ~9 project copies are ALREADY relative symlinks into the ai-resources canonical (verified: `nordic-pe-screening-project/...sync-workflow.md -> ../../../../ai-resources/.claude/commands/sync-workflow.md`). So the canonical home is unambiguously ai-resources; the change replaces the *workspace-root byte-copies* with symlinks. Project symlinks inherit automatically and need no change — but the auto-sync hook's mismatch-detector (auto-sync-shared.sh line 17, flags byte-copies that differ from canonical) means any future divergence between the two byte-copies would already warn; collapsing to a symlink removes that divergence risk.
- **id-04 / id-18 paired-copy coupling:** wrap-session.md and new-project.md each have a workspace-root paired NON-symlink copy (wrap-session.md line 40-49 PAIRED CONTRACT block names it explicitly). Both copies must stay in sync. **Grounding contradiction:** on disk, BOTH copies already contain the gated push (id-04: new-project.md line 648 "do NOT push here... gated-push rule"; id-18: wrap-session.md lines 447-455 AND workspace-root copy lines 387-391 already have `git fetch origin` + `git rev-list HEAD..@{u} --count` divergence check). These two items appear **already applied** — the change description's "currently autonomous push" / "structurally guaranteed rejection" framing does not match disk state. If re-applied blindly, risk of double-edit / merge noise.
- id-10/11/12/25/26 edits one always-loaded file (ai-resources/CLAUDE.md); self-contained, no external caller parses its section structure mechanically (it is prose instructions, not a parsed schema).

### Dimension 4: Reversibility
**Risk:** Medium

- id-01/02/03: settings.local.json is **gitignored** (new-project.md line 173 / line 170 confirm settings.local.json is a per-operator gitignored file). A `git revert` will NOT restore prior settings.local.json state — the operator must manually undo. This is a per-machine manual rollback, not a clean git revert. Medium.
- id-06 / id-22 (settings.json): tracked, clean `git revert`. Low for these two.
- id-10/11/12/25/26 (CLAUDE.md): single tracked file, clean `git revert`. Low.
- id-04 / id-18 (command files + paired copies): tracked, clean `git revert` — BUT the paired workspace-root copies and ~16 project symlinks mean a revert must touch each non-symlink copy; symlinked copies follow canonical automatically. One extra cleanup step (re-sync paired copy). Medium.
- id-37 (symlinks): replacing a tracked byte-copy file with a symlink is git-tracked and revertible, but symlink creation/deletion is the kind of change where `git revert` behavior depends on how git recorded the mode change — a revert restores the symlink-or-file as committed, generally clean. Low-Medium.
- No state propagates beyond git except the gitignored settings.local.json (already noted) — no external writes, no push, no log mutation in this batch.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **id-22 ↔ multiple deny-rationale sites (undocumented-at-change-site coupling).** The archive-read deny is referenced by name in at least 4 command/agent/doc files (resolve-improvement-log.md, improve.md, permission-template.md, session-feedback-collector.md) as a *load-bearing constraint that shapes their logic* (e.g., resolve-improvement-log.md's entire append-only-never-read design exists BECAUSE of this deny — line 103). Narrowing the deny silently invalidates that design rationale without the change touching those files. Classic hidden coupling: the contract (the deny glob) lives in settings.json but its consumers are scattered and assume it stays.
- **Two-glob coupling (id-22):** `improvement-log-archive.md` is matched by BOTH `Read(logs/*-archive-*.md)` (line 28) and `Read(logs/*archive*.md)` (line 32). A naive narrow of only one leaves the file blocked — the operator could believe the fix landed while the analyst still cannot read it (the exact recurrence the change targets). Must narrow both.
- **id-37 symlink topology assumes the auto-sync convention** (relative targets, repo-architecture.md § Symlink topology rule 5; auto-sync-shared.sh line 72-94). The change must emit RELATIVE symlinks to match the existing project-copy convention — an absolute symlink would diverge from the established pattern and break portability. Documented at hook level, so coupling is to an established repo convention (one implicit dependency) → Medium, not High.
- id-01/02/03 couple to the check-permission-sanity.sh SessionStart hook (nudges when defaultMode absent) — restoring defaultMode keeps that hook quiet; benign, established coupling.
- id-10/11/12/25/26: the de-dup trims Commit Rules to a pointer, but the SAME text is deliberately duplicated per the 2026-04-13 "Commit Rules propagate by explicit copy" decision (new-project.md line 408 documents this). Trimming the ai-resources/CLAUDE.md copy to a pointer is safe ONLY if the duplication being removed is *within-repo cross-file mirror*, not the *project-propagation* copies. The change must not collapse the propagation mechanism — coupling to a documented decision.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (projects/strategic-os/ai-strategy/principles-base.md) — checks grounded in frozen IDs.
- **id-37 actively SERVES DR-1 / DR-3** (line 54: shared resources belong in ai-resources/; line 56: component-type determines home, home conventions fixed). Collapsing byte-copies to symlinks-into-canonical is the correct home-convention move. Aligned.
- **id-06 actively SERVES OP-12** (line 50: closure before detection / prefer consolidation) — it consolidates/closes a long-standing deferred token-audit finding rather than adding new detection. Aligned.
- **id-04 / id-18 SERVE OP-2** (line 40: gate judgment) — replacing autonomous push with a confirmation gate restores operator oversight on a hard-to-reverse external action (push). Aligned with the gated-push standing rule. (Caveat: appear already applied — see Dim 3.)
- **id-10/11/12/25/26 align with OP-11 / OP-3** (lines 49, 32: surface and resolve practice-vs-principle divergence loudly) — the de-dup is a recorded, deliberate cleanup, KEEPING the model-default-prohibition verbatim (the one standing rule that must not be touched). No silent principle revision.
- **No speculative abstraction (OP-9 / DR-7 / AP-7, lines 47/60/85):** every item has a confirmed present consumer (the recurrence in id-22, the 226 files in id-06, the existing symlink convention in id-37). No "hooks for later," no absent-consumer generalization.
- **No boundary expansion (OP-10, line 48):** all changes are internal Claude Code harness config; no cross-tool governance added.
- No principle is violated; several are actively served. Low.

## Mitigations

- **id-22 (Blast Radius / Hidden Coupling — the load-bearing item):** Before landing, (a) narrow BOTH matching deny globs in settings.json (lines 28 AND 32), not just one — verify with a post-edit grep that no remaining glob matches `improvement-log-archive.md`; and (b) in the SAME commit, update the now-stale rationale in `resolve-improvement-log.md` (line 103), `improve.md` (line 21), and `permission-template.md` (line 134) so no file still asserts "you cannot read the archive." Otherwise the contract drifts silently.
- **id-01/02/03 + id-04 + id-18 (grounding contradiction):** Before editing, RE-READ each target file's current state — settings.local.json already has `defaultMode` (line 9); new-project.md already has the gated push (line 648); wrap-session.md + its workspace-root copy already have the `git fetch` + divergence check (lines 447-455 / 387-391). Treat these as verify-and-skip-if-present, not blind re-apply, to avoid double-edits and merge noise. If genuinely already applied, mark the item DONE in the diagnostics plan rather than re-shipping.
- **id-01/02/03 (settings layer + reversibility):** Confirm the intended target is `settings.local.json` (gitignored, per-machine, non-revertible) vs `settings.json` (tracked). The broad allows (`Bash(*)`, `Edit`, `Write`) already live in tracked settings.json — do not duplicate them into the local layer; restore only `defaultMode` if it is actually missing on the operator's machine. Note the manual (non-git) rollback path in the plan.
- **id-37 (symlink class + hidden coupling):** Emit RELATIVE symlinks (matching the existing `../../../../ai-resources/...` project-copy convention and auto-sync-shared.sh line 72-94); verify each new symlink resolves (`test -e`) before committing; confirm the byte-copies being replaced are the workspace-root copies (canonical = ai-resources, already the target of ~9 project symlinks).
- **id-10/11/12/25/26 (hidden coupling):** Trim only the within-repo cross-file mirror blocks; do NOT collapse the project-propagation Commit Rules copy mechanism (documented 2026-04-13 decision, new-project.md line 408). Keep the model-default-prohibition text verbatim.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from settings.json, settings.local.json, CLAUDE.md, new-project.md, wrap-session.md; grep counts across ai-resources and the workspace root; principle IDs quoted from principles-base.md). The notable grounding finding — that several batch items (id-01/02/03, id-04, id-18) already appear applied on disk, contradicting the change description's "currently absent" framing — is itself evidenced (settings.local.json line 9; new-project.md line 648; wrap-session.md lines 447-455 and workspace-root copy lines 387-391). No training-data fallback was used on any read.
