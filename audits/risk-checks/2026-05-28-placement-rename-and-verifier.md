# Risk Check — 2026-05-28

## Change

Plan-time gate. Plan artifact: ai-resources/plans/placement-rename-and-verifier-2026-05-28.md. Summary: (1) Rename canonical command /route-change → /placement; rename file ai-resources/.claude/commands/route-change.md → placement.md; update two internal self-references inside the file; update workspace CLAUDE.md lines 37 and 46 (workspace-level always-loaded); clean up resulting dangling route-change.md symlinks in projects/*/.claude/commands/ via find -delete. (2) Add placement verifier procedure: new file ai-resources/docs/placement-verifier.md (procedure, not SKILL.md, not agent); integrate references into five canonical pipelines — /create-skill, /improve-skill, /migrate-skill, /graduate-resource, /new-project — at two firing points each (plan-time placement check before first Write, end-time placement check before commit-prompt); MISMATCH at end-time appends a friction-log entry. Append-only edits to pipelines; no rewrites of existing pipeline logic. Risk classes invoked per audit-discipline.md: cross-cutting CLAUDE.md edit, canonical command edit (six commands touched: /placement plus the five pipelines), new process documentation. Deliberately rejected anti-patterns (recorded in plan): no PreToolUse hook auto-firing /placement, no promotion to confirmation gate, no embedding /placement as Step 0 of /create-skill. Deferred to improvement-log: SO advisory items #2 (shared placement skill), #3 (architecture-gap loop), #4 (skip-rate tracking), #5 (trigger tightening).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/placement-rename-and-verifier-2026-05-28.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/route-change.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/placement.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/placement-verifier.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve-skill.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/migrate-skill.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/graduate-resource.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Stage A rename is mechanically safe with the planned symlink cleanup; Stage B touches five canonical pipelines plus a workspace-always-loaded rule, raising blast-radius and hidden-coupling risk that the plan's acceptance criteria only partially cover.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Stage A is a pure rename. Workspace `CLAUDE.md` § Placement Discipline (lines 35–48) already exists and is already always-loaded — changing `/route-change` → `/placement` on lines 37 and 46 does not add tokens, only renames a string. Net delta: ~0 tokens in the always-loaded surface.
- The new `docs/placement-verifier.md` is loaded **on demand** by pipelines, not always-loaded. Plan line 55 explicitly confirms procedure shape was chosen "to keep it out of the always-loaded surface." No CLAUDE.md import; no SessionStart hook auto-firing it.
- Pipeline integrations are described in the plan (lines 75–83) as "one paragraph referencing `docs/placement-verifier.md` at the plan-time firing point, and one paragraph at the end-time firing point." Each pipeline runs only when operator-invoked, so per-paragraph token cost is pay-as-used.
- One ongoing-cost consideration the plan does not quantify: the verifier procedure itself, once referenced from five pipelines × two firing points = 10 read-on-demand calls per pipeline run. Verifier procedure size is unknown (file not yet present), but plan implies a short procedure (4-step lookup against `repo-architecture.md § Canonical homes by artifact type`). Acceptable Low at the described scope.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description names no `settings.json` edits, no `allow` / `ask` / `deny` rule changes, no MCP server additions, no Write-path widening, no new Bash invocation patterns.
- The `find projects/ -name route-change.md -type l -delete` cleanup (plan line 37) is a one-shot operator-executed command, not a permission grant.
- No new tool invocations introduced by the verifier procedure beyond Read (already always-allowed) and the existing pipelines' Write/Edit footprint.

### Dimension 3: Blast Radius
**Risk:** High

- **Canonical command rename touches more files than the plan enumerates explicitly.** Grep across `ai-resources/.claude/commands/` returned 10 occurrences of `route-change` across three command files, not just the renamed file:
  - `route-change.md` itself: 7 occurrences (lines 10, 11, 12, 13, 25, 26, 120) — covered by plan Stage A.
  - `risk-check.md` line 11: example `/risk-check add new slash command /route-change and docs/repo-architecture.md` — NOT enumerated in plan, but covered implicitly by Stage A acceptance criterion "`grep -rn "route-change" --include="*.md"` returns zero hits outside archived session-notes" (plan line 44).
  - `consult.md` lines 70 and 108: two load-bearing references explaining why `/consult` does NOT invoke `/route-change` — these are decision-rationale prose, renaming the slug to `/placement` is mechanical but the text now reads slightly oddly ("does NOT invoke `/placement` as a slash command"). Functional but worth a re-read.
- Two further canonical docs reference `route-change`: `ai-resources/docs/ai-resource-creation.md` line 3 (the "before invoking a creation pipeline, if placement is non-obvious, run `/route-change` first" pointer) and `ai-resources/docs/repo-architecture.md` lines 3 and 177. Both are caught by the grep-zero acceptance criterion but not enumerated as separate files in the Stage A surface (plan lines 22–37 lists only `route-change.md` + workspace `CLAUDE.md`).
- **Project-level symlinks:** verified 13 symlinks via `find projects/ -name route-change.md -type l | wc -l` plus 3 more outside `projects/` (workspace root `.claude/commands/route-change.md`, `knowledge-bases/pe-kb-vault/.claude/commands/route-change.md`, and the canonical `ai-resources/.claude/commands/route-change.md`). The plan's mitigation `find projects/ -name route-change.md -type l -delete` covers the 13 under `projects/` but does **not** cover the workspace-root symlink (`.claude/commands/route-change.md`) or the `knowledge-bases/pe-kb-vault/.claude/commands/route-change.md` symlink. Both will become dangling after rename. Auto-sync-shared.sh (lines 82–96) will create new `placement.md` symlinks in projects on next session start but the workspace-root `.claude/commands/` directory is not in auto-sync's scope (auto-sync walks projects via `$CLAUDE_PROJECT_DIR`).
- **Stage B touches five canonical pipelines** (`create-skill.md` 132 LOC, `improve-skill.md` 158 LOC, `migrate-skill.md` 119 LOC, `graduate-resource.md` 96 LOC, `new-project.md` 666 LOC — total 1,171 LOC of always-symlinked-into-every-project canonical surface). Append-only edits per plan, but the pipelines are heavily wired into operator muscle memory and the project workflow.
- Plan's claim "Each pipeline can be reverted independently if a downstream regression appears" (plan line 131) is correct for the verifier integration but not for the rename — the rename ripples across `risk-check.md`, `consult.md`, `repo-architecture.md`, `ai-resource-creation.md`, workspace `CLAUDE.md`, the canonical command file, and 13+2 symlinks in one atomic surface.

### Dimension 4: Reversibility
**Risk:** Medium

- Stage A rename is git-revertible inside `ai-resources/`, but the symlink cleanup is **outside git** for most projects — only some projects are git-tracked, and symlink deletions across 13 project directories happen via `find -delete`. A `git revert` in ai-resources would restore `route-change.md` but the deleted project symlinks would only repopulate as `placement.md` on the next SessionStart auto-sync, leaving the projects without the renamed command's symlink for `route-change.md` until manually recreated or the revert triggers a new auto-sync cycle. Plan does not document this asymmetry.
- Workspace `CLAUDE.md` lines 37 and 46 changes are clean git-reverts (workspace root is git-tracked).
- Stage B per-pipeline append-only paragraphs are clean git-reverts; `placement-verifier.md` deletes standalone (plan line 136). Consistent with plan's reversibility claim.
- One reversibility hazard the plan does not address: if `/placement` ships and operators build muscle memory around the new name (typing `/placement` instead of `/route-change`), a later revert to `/route-change` requires reversing the muscle-memory shift, which is a behavioral cost git cannot revert. Low concern given the rename is the entire point of Stage A and the operator approved it; flagged for completeness.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **`/consult` command silently couples to `/route-change` semantics.** `consult.md` lines 70 and 108 reference `/route-change` to explain why `/consult` does not separately invoke routing. After rename, these references become `/placement`, and the prose still reads coherently — but `consult.md` was not enumerated as a Stage A touch-point in the plan (plan lines 22–37). The grep-zero criterion catches it; the rationale prose still holds; this is a documentation-coherence coupling, not a functional one.
- **`logs/innovation-registry.md` line 87 and `logs/decisions.md` lines 87 and 100 reference `/route-change` and `.claude/commands/route-change.md` as the canonical file path** — these are historical log entries. Plan says zero hits "outside archived session-notes" (plan line 44) but does not enumerate non-archived `logs/` files. Strict literal reading would require updating these too. Operator-judgment call; historical log entries arguably should preserve the original `/route-change` name as the name at the time of the decision. The plan is silent on this; suggest the operator either explicitly exempts `logs/decisions.md` and `logs/innovation-registry.md` from the grep-zero criterion or accepts they will be edited.
- **Verifier procedure depends on `docs/repo-architecture.md § Canonical homes by artifact type`** (plan line 58 names "the table at line 91"). If `repo-architecture.md` is reorganized and that table moves, the verifier procedure breaks silently — line numbers are brittle anchors. The procedure should reference the section name, not the line number; plan's wording suggests "the table at line 91" as a parenthetical — verify this is descriptive in the procedure file, not a hard line-number lookup.
- **Verifier MISMATCH friction-log entry contract:** plan line 69 says end-time MISMATCH "append[s] an entry to `ai-resources/logs/friction-log.md`." Format of the entry is not specified. Multiple pipelines writing to the same log with different entry shapes creates a parse-ambiguity coupling — the friction-log feedback loop named in workspace `CLAUDE.md` line 48 will eventually want to be machine-readable. Suggest the verifier procedure pins a single entry schema.
- **Two-gate verifier mirrors `/risk-check` semantics** (plan line 67 — "the 'two-gate' pattern, mirrors `/risk-check`"). This is intentional and helpful for operator mental model, but creates an implicit contract: if `/risk-check`'s gate semantics change in `audit-discipline.md`, the placement verifier's two-gate logic may need to follow. Worth a one-line cross-reference in the procedure file.

## Mitigations

- **Blast radius (High) → enumerate the full file surface before Stage A.** Before applying Stage A, run `grep -rn "route-change" ai-resources/ ~/Claude\ Code/Axcion\ AI\ Repo/CLAUDE.md --include="*.md"` and update the Stage A touch-list to include: `consult.md`, `risk-check.md`, `docs/ai-resource-creation.md`, `docs/repo-architecture.md`, and an explicit operator decision on `logs/innovation-registry.md` line 87 + `logs/decisions.md` lines 87 and 100 (rename vs. preserve as historical name).
- **Blast radius (High) → extend the symlink-cleanup `find` to cover all dangling targets, not just `projects/`.** Replace the plan's `find projects/ -name route-change.md -type l -delete` with `find ~/Claude\ Code/Axcion\ AI\ Repo -name route-change.md -type l -delete` (which covers the workspace-root `.claude/commands/` symlink and `knowledge-bases/pe-kb-vault/.claude/commands/` symlink in addition to the 13 project symlinks). Verify post-delete with `find ~/Claude\ Code/Axcion\ AI\ Repo -name route-change.md` returning only archived session-notes or zero file hits.
- **Reversibility (Medium) → document the symlink-asymmetry caveat in the commit message.** Note that a future `git revert` of the rename commit will restore `ai-resources/.claude/commands/route-change.md` but will not recreate the deleted project symlinks — the next SessionStart auto-sync will re-create them. This is acceptable but should be documented so a future operator does not panic.
- **Hidden coupling (Medium) → in `docs/placement-verifier.md`, anchor lookups by section heading, not by line number.** Plan line 58 mentions "the table at line 91" of `repo-architecture.md`; the procedure file should reference the section heading "Canonical homes by artifact type" instead. Also pin a single friction-log entry schema for the end-time MISMATCH case and include a one-line cross-reference noting the two-gate pattern mirrors `/risk-check` per `audit-discipline.md § When to fire`.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to the plan artifact (lines 22–37, 44, 55, 58, 67, 69, 75–83, 131, 136), to workspace `CLAUDE.md` (lines 35–48, with verified 3 hits via `grep -c`), to `audit-discipline.md` (Risk-check change classes section, lines 15–25), to canonical pipelines (line counts from `wc -l`: create-skill 132, improve-skill 158, migrate-skill 119, graduate-resource 96, new-project 666), to verified symlink counts (13 `route-change.md` symlinks under `projects/`, plus 2 additional symlinks at workspace root and `knowledge-bases/pe-kb-vault/`), and to grep counts (10 `route-change` references inside `ai-resources/.claude/commands/`, additional references in `docs/`, `logs/innovation-registry.md`, `logs/decisions.md`). No training-data fallback was used.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

## Concurrence on PROCEED-WITH-CAUTION

**Concur with the verdict.** PROCEED-WITH-CAUTION is the right tier, not GO and not RECONSIDER. The Stage A surface is mechanical and well-bounded; the Stage B surface touches a workspace-always-loaded rule plus five canonical pipelines (auto-synced to every project — `risk-topology.md § 2 — auto-sync-shared.sh fan-out`). That fan-out is the canonical "High blast radius" pattern (`risk-topology.md § 3 — New canonical command/agent + Canonical command/agent edit`). Three change classes fire here (`audit-discipline.md` per Q5: cross-cutting CLAUDE.md edit, canonical command edit ×6, new process documentation); none of them is dismissible.

**The mitigation set is necessary but not sufficient.** The four reviewer mitigations address symptoms the dimension review surfaced. The grounding base says three additional concerns are load-bearing — they sit underneath the dimensions, not inside them.

## What the dimension review missed

### M1 — DR-7 / AP-7 challenge to the two-firing-point pattern itself

The verifier procedure is the right architectural fit (procedure not skill — satisfies DR-3 canonical home `ai-resources/docs/<name>.md` and aligns with `repo-architecture.md § Canonical homes` line 99). That part is sound. But the two-firing-point pattern across five pipelines is structurally speculative under `principles.md § DR-7` (generalize only when a second confirmed consumer exists) and `principles.md § AP-7` (speculative abstraction).

The justification chain reads: "mirrors `/risk-check`'s two-gate model." That's a *pattern analogy*, not a *second confirmed consumer*. The actual evidence of a placement leak — the failure mode the verifier is meant to catch — exists at one observed point (the `/route-change`-recommended path being ignored by downstream writes). The plan extrapolates that single observed failure across five pipelines, with two firing points each, before any of the five has independently demonstrated the leak.

**The right answer is** to ship the verifier as documentation + integrate at the *one* highest-leverage point first, then add the other four when each independently demonstrates a placement miss. The plan itself names `/graduate-resource` as "highest-leverage" — start there. (`principles.md § DR-7`; `principles.md § AP-7`.)

This is not the reviewer's mitigation #4; it's a verdict-changing observation about scope. It does not flip the verdict to RECONSIDER, but it argues the PROCEED-WITH-CAUTION should be paired with **scope reduction**, not just additional mitigations layered onto the existing five-pipeline scope.

### M2 — Q6 violation is more serious than mitigation #4 captures

The plan has the end-time verifier append MISMATCH entries directly to `ai-resources/logs/friction-log.md`. `repo-architecture.md § Q6` (line 208) names `logs/friction-log.md` as written by `/friction-log` — not by arbitrary procedures. Reading the command body confirms the log has a structured schema: session blocks (`## Session — {YYYY-MM-DD HH:MM}`), `### Friction Events` heading, timestamp-prefixed entry lines with `(context: …)` suffix, and a STUB-detection rule. A verifier appending raw `MISMATCH` lines bypasses all of this. The reviewer's mitigation #4 ("pin a single friction-log entry schema") names the symptom but the right structural fix is different: **the verifier writes to `ai-resources/logs/maintenance-observations.md` instead** (the canonical home per Q6 for "Repo-health observations from `/friday-act`"), or it calls `/friction-log` as the writer.

Direct writes to a logged-by-`/friction-log` file violate the two-end contract pattern called out in `risk-topology.md § 5 — Signals that elevate to structural risk` ("Change modifies a string literal matched by another component"). Pinning a schema in placement-verifier.md just freezes the violation in place — it does not resolve it. (`principles.md § OP-3` — loud-failure over silent two-end-contract drift; `repo-architecture.md § Q6`.)

### M3 — Workspace `CLAUDE.md` edit fan-out is wider than Stage A enumerates

The reviewer's mitigation #1 expands the file-surface enumeration. Good. But the workspace `CLAUDE.md` edit itself is the higher-leverage concern: it is one of two `Critical — system-wide effect if broken` components (`risk-topology.md § 1`) — every session in the workspace loads it. The Stage A acceptance criterion *"`grep -rn "route-change" --include="*.md"` returns zero hits outside archived session-notes"* is the right end-state check, but the plan does not call out the load-bearing nature of the file edited. A botched workspace `CLAUDE.md` edit (e.g., breaking the `## Placement Discipline` heading anchor that some downstream check may key off — see `risk-topology.md § 5` "removes a section heading used as a W2.1 H4 parser target") has different blast radius than the canonical command edit alongside it.

**The right answer is** Stage A acceptance also includes a `grep -rn "Placement Discipline" --include="*.md"` check, to confirm no implicit downstream consumer is broken by the rename. (`risk-topology.md § 1 + § 5`.)

## Conflict with operator-stated direction — named per `persona.md § 5 voice rule 7`

The plan's "Operator decision: Ship rename + #1" specifies five-pipeline integration as part of #1. Concern M1 above flags that this specification is in tension with `principles.md § DR-7`. We name the trade-off explicitly:

- **Operator path as planned:** ship verifier across all five pipelines. Higher coverage from day one. Higher revert surface if any pipeline misbehaves. ROI per pipeline is unmeasured.
- **Principle-aligned path:** ship verifier procedure + one pipeline (`/graduate-resource`). Lower coverage. Lower revert surface. Each additional pipeline integration triggered by an observed placement miss, not pre-emptive scope.

The verdict does not change either way — both fit PROCEED-WITH-CAUTION. The trade-off is whether to accept DR-7 drift in exchange for one-shot deployment, or to ship lean and re-integrate per observed evidence.

## Recommendation on the verdict

**Hold PROCEED-WITH-CAUTION.** Do not relax to GO. Do not escalate to RECONSIDER. The four reviewer mitigations are necessary; concerns M1–M3 above are additive, not replacing.

**Add three mitigations to the set:**

1. **(M2)** Re-route MISMATCH writes from `friction-log.md` to `maintenance-observations.md`, OR invoke `/friction-log` as the writer. Do not pin a schema for direct writes — that locks in a Q6 violation. (`repo-architecture.md § Q6`; `risk-topology.md § 5`.)
2. **(M3)** Add `grep -rn "Placement Discipline"` to Stage A acceptance criteria, confirming the workspace `CLAUDE.md` section heading anchor is not silently depended on elsewhere. (`risk-topology.md § 1 + § 5`.)
3. **(M1 — operator decision)** Decide between the planned five-pipeline scope and a lean one-pipeline-first scope. The principle-aligned answer is one pipeline first (`/graduate-resource`, the plan's own highest-leverage call); accepting DR-7 drift for one-shot deployment is a defensible operator override but should be named in the commit message as deliberate. (`principles.md § DR-7`; `principles.md § AP-7`.)

The architectural-fit choices the plan already locked in — procedure not skill (DR-3-compliant canonical home), no PreToolUse hook auto-fire, no promotion of `/placement` from advisory to gate — are sound and should not be revisited. The plan's "Anti-patterns rejected" section is correct on all three. (`risk-topology.md § 3` — automation with shared-state effects would have been a fourth risk class fired; rejecting the hook approach was the right call.)
