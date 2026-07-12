# Risk Check — 2026-07-09

## Change

RE-RUN (2nd pass) on the STAGED consolidation migration — required gate before the one-way Stage 3. The original atomic plan got RECONSIDER (2026-07-07); it was decomposed into 5 verifiable stages, and Stages 0–2 have now been executed as design+verify (no files moved, all reversible). Assess whether the DECOMPOSED plan is now safe to proceed to Stage 3 (physical move + git dissolution).

The change: dissolve projects/strategic-os/ into projects/management-os/ as ONE project with two subfolders — strategyos/ (today's strategic-os) and operationsos/ (today's management-os + a playbook/ layer). Boundary = time horizon. Spans 3 git repos (strategic-os, management-os, kb-strategic-os).

What the completed stages established (please weigh these — they change the original risk picture):
- Stage 0 (findings): empirically verified via Claude Code docs that a session applies only its OWN settings — additionalDirectories grants file access, not the target's deny rules (verdict "a"). CONSEQUENCE: the strategic-os repo boundary was NEVER a technical write-barrier against a management-os session; the folder-scoped deny added in Stage 1 is a NET-NEW hard protection, not a downgrade. The exposure exists TODAY, independent of the merge. 3-repo rollback baselines captured.
- Stage 1 (design): the permission wall is now a same-project path-scoped deny (no cross-directory subtlety), covering Write/Edit/MultiEdit + promote gate (defense-in-depth). DR-9 top-3 done. ONE OPEN DECISION remains: the merged settings allow Bash(*), which bypasses the Write/Edit deny — narrow the Bash posture (as strategic-os already does) vs accept the residual under the promote gate. The two confidentiality/staleness silent-breaks were re-derived AND scratch-tested green.
- Stage 2 (changeset): the 5 canonical ai-resources consumers have exact line-level edits mapped and grounded in real file contents, to be applied as a discrete verified commit AFTER the move (not before — repointing early would break shared infra). Vault-name decision settled: KEEP — the merge auto-resolves the 2026-06-29 basename-collision defect for free. Silent-break #3 (risk-check-reviewer's own hardcoded principles-base path) is in the changeset.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/audits/working/2026-07-07-management-os-consolidation-migration-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/management-os/audits/working/2026-07-09-migration-stage-0-findings.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/management-os/audits/working/2026-07-09-migration-stage-1-design.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/management-os/audits/working/2026-07-09-migration-stage-2-changeset.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-07-consolidate-strategic-os-into-management-os.md — exists

## Verdict

**RECONSIDER**

**Summary:** Staging materially reduced the compounding risk (4 High dimensions → 3), and closed two of three named silent-breaks with actual scratch-tested evidence — but three dimensions (Permissions Surface, Blast Radius, Reversibility) remain High for the Stage 3 step evaluated in isolation, and the aggregation rule for two-or-more-High is RECONSIDER regardless of individual mitigability; the specific, newly-surfaced driver is that Stage 3 (the move) is decomposed to land *before* Stage 4 (the permission wall) and before the Stage 2 reference-sweep is confirmed committed, which reopens a version of the exact compounding pattern the original RECONSIDER was about.

## Consumer Inventory

Re-verified 2026-07-09 (no drift since the 2026-07-07 pass — confirmed via fresh grep: `operationsos` = 0 hits repo-wide, `ingest-initiative` = 0 hits repo-wide; three repos' HEAD SHAs match the Stage 0 baseline exactly: strategic-os `7c8121b`, management-os `4a45b73`, kb-strategic-os `5aeafc8` — confirming Stages 0–2 made no file changes as claimed). Spot-checked file contents cited in Stage 1/2 docs directly (`risk-check-reviewer.md` line ~160 still hardcodes the old path; `refresh-project-state.md` lines 9/33 match the Stage 2 changeset's citations; `state-retrieval-agent.md` lines 58–63 and `project-state-snapshot-agent.md` line 41 match Stage 1's problem statements) — all grounded correctly.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/refresh-project-state.md` | parses | yes |
| `ai-resources/.claude/agents/project-state-scrub-verifier.md` | parses | yes |
| `ai-resources/.claude/agents/project-state-snapshot-agent.md` | parses | yes |
| `ai-resources/.claude/agents/risk-check-reviewer.md` (this reviewer's own definition) | imports | yes |
| `ai-resources/.claude/commands/consult.md` | documents | no |
| `ai-resources/.claude/commands/prime.md` | documents | no |
| `ai-resources/docs/agent-tier-table.md` | documents | yes |
| `ai-resources/docs/settings-local-recovery.md` | documents | no |
| `projects/management-os/CLAUDE.md` | parses | yes |
| `projects/management-os/.claude/commands/monday-brief.md` | invokes | yes |
| `projects/management-os/.claude/settings.json` (committed) | co-edits | yes |
| `projects/management-os/.claude/settings.local.json` | co-edits | yes |
| `projects/management-os/.claude/shared-manifest.json` | co-edits | yes |
| `projects/management-os/` git repo (own origin `github.com/axcioncapital/management-os.git`, local `main` not tracking upstream) | co-edits | yes |
| `projects/strategic-os/.claude/agents/state-retrieval-agent.md` | parses | yes |
| `projects/strategic-os/.claude/agents/conflict-detector-agent.md` | parses | yes |
| `projects/strategic-os/.claude/commands/*.md` (8 files: prioritize, promote-to-live, promote-sandbox, strategic-decision, strategic-review, strategic-state, strategic-state-refresh, sandbox-new, os-self-review) | invokes | yes |
| `projects/strategic-os/.claude/settings.json` (own deny list, dissolved with the repo) | co-edits | yes |
| `projects/strategic-os/.claude/shared-manifest.json` | co-edits | yes |
| `knowledge-bases/strategic-os/CLAUDE.md` | documents | yes (per Stage 2 §B: vault name KEPT, only internal path prose stale) |
| `knowledge-bases/strategic-os/_master-index.md` | documents | yes |
| `knowledge-bases/strategic-os/project-state/_index.md` | documents | yes |
| `knowledge-bases/strategic-os/project-state/strategic-os.md` | documents | yes |
| `knowledge-bases/strategic-os/` own git repo (origin `kb-strategic-os.git`, 1 ahead of origin, unpushed) | co-edits | yes |
| `projects/repo-documentation/vault/architecture/repo-state.md` | documents | no |
| `projects/repo-documentation/vault/projects/projects.md` | documents | no |
| `.gitignore` (workspace root — `projects/strategic-os/` line 25 becomes orphaned) | co-edits | no |

**Total: 27 consumers, 19 must-change** (one item from the 2026-07-07 inventory, `projects/repo-documentation/vault/components/projects.md`, could not be re-confirmed as a distinct file this pass and is folded into the adjacent `projects.md` row above — immaterial to the count-based Blast Radius scoring either way). **New consumer this pass, surfaced by direct file inspection rather than grep (not a keyword hit):** the literal Stage 3 instruction "preserve internal structure so relative paths survive" (parent plan §7 Stage 3) would carry `strategic-os/.claude/` — its own nested `settings.json`, `shared-manifest.json`, and 3 agents + 8 commands — physically into `management-os/strategyos/.claude/`, creating a **second, nested `.claude/` folder** inside a project whose target architecture (parent plan §4) specifies **one** `.claude/`. This is flagged under Dimension 5 (Hidden Coupling) — it is a structural ambiguity in the plan's own wording (§7 vs §4), not a contract any file currently depends on, so it is not scored as an additional must-change consumer, but it is a genuine gap this review is the first to name.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Unchanged from the 2026-07-07 pass — nothing in Stages 0–2 adds always-loaded content, hooks, or broad-trigger skills. The merged `CLAUDE.md` (parent plan §7 Stage 4) is a project-level file, loaded only inside management-os sessions, not workspace-wide.
- No new `SessionStart`/`PreToolUse` hook is introduced — both projects' `settings.json` already run the same two `SessionStart` hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`); confirmed identical in both files read directly this pass.
- `/ingest-initiative` remains deferred and unbuilt — `grep -rn "ingest-initiative"` returns 0 hits repo-wide (re-confirmed 2026-07-09), consistent with the parent plan's explicit deferral (§5).

### Dimension 2: Permissions Surface
**Risk:** High

- **Real, concrete design progress since 2026-07-07** (this is the main de-risking this pass should credit): the folder-scoped deny is drafted (`Write`/`Edit`/`MultiEdit` on `strategyos/state/live/**` and `strategyos/inputs/**`), grounded against the repo's own "deny-shadows-allow" convention, and covers a gap the *old* strategic-os deny had (missing `MultiEdit`) — Stage 1 design doc §1.
- **Genuinely open, self-graded HIGH-severity residual, explicitly punted to this gate.** Stage 1's own DR-9 table grades failure mode #1 — "Bash write-vector bypass: merged settings allow `Bash(*)`... `> file`, `tee`, `cp`, `mv`, `sed -i` all reach `strategyos/state/live/` unblocked" — as **`Severity: HIGH (residual)`**, its own words, and explicitly defers the decision: "This is a real design decision, not a mechanical step. **Flag for the re-run `/risk-check`.**" This review is that flag landing, and the decision (narrow the merged `Bash(*)` posture, as `strategic-os/.claude/settings.json` already does, vs. accept the residual under the promote gate) is still unresolved. Verified directly: `projects/management-os/.claude/settings.json` still grants unscoped `"Bash(*)"` with `"defaultMode": "bypassPermissions"` (read 2026-07-09).
- **Sequencing gap: the wall lands at Stage 4, not with Stage 3.** Stage 1 design doc §4: "Permission wall → applied at **Stage 4** (config merge)." Stage 3 (move + drop `additionalDirectories` + rewire `/monday-brief` + archive) does **not** itself touch `settings.json`. The parent plan's own staging philosophy explicitly licenses running Stage 3 and Stage 4 as separately-timed, independently-schedulable units ("each independently verifiable and small enough to re-run its own lightweight check... **do not** collapse into one atomic pass," §7 preamble) — meaning Stage 3 could land today and Stage 4 land next session or next week. In that window, `strategyos/state/live/` sits inside `projects/management-os/.claude/settings.json` — confirmed blanket-permissive, zero deny protecting any strategy-state path (read directly 2026-07-09) — with the git-repo boundary already dissolved and no `additionalDirectories` indirection needed to reach it (it is now a plain in-project subfolder). This is the SO's own **"[HIGHEST] Authority wall = defense-in-depth... rebuild BOTH guards, each independently sufficient... Make-or-break"** condition (parent plan §0 Condition 1) landing unmet at the exact moment Stage 3 completes.
- Mitigating factor Stage 0 supplies: the exposure this creates is not *worse* than today's baseline in a strict technical sense (Stage 0 verdict (a): a management-os session can already reach `strategic-os/state/live/` today via its blanket-permissive settings + workspace-wide `additionalDirectories`, guarded only by the same behavioral CLAUDE.md constraint) — but Stage 3 removes the repo-boundary *friction* (no directory hop, no separate checkout, same repo/tree as the active weekly-loop editing) without adding the compensating *technical* control at the same moment, which is a real increase in the odds of an accidental (not malicious) write landing in strategy-live state during routine `operationsos/` editing.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: **27 consumers, 19 must-change** — still far above the ">5 must-change" High threshold. This is a static, count-driven fact that Stages 0–2's *readiness* work does not change (it changes execution risk, not breadth).
- Shared/canonical infrastructure is directly touched: `refresh-project-state.md` + 2 of its agents (`project-state-scrub-verifier.md`, `project-state-snapshot-agent.md`) are used by **every** Axcíon project's `/refresh-project-state` runs, not just the two merging projects.
- **What has genuinely improved:** unlike the 2026-07-07 pass (where the sweep was an unexamined "must update ~5 files" line item), the Stage 2 changeset gives exact line numbers and old→new text for all 5 canonical consumers, spot-checked against real file content this pass and found accurate (`risk-check-reviewer.md`, `refresh-project-state.md` lines verified directly above). Execution risk on the sweep itself is now low.
- **Residual, narrower than pass 1 but not zero:** the Stage 2 sweep is explicitly sequenced as "a discrete, separately-verified commit **immediately after** the Stage 3 move, not before" (Stage 2 doc, sequencing decision). Between the Stage 3 move commit landing and that follow-up commit landing, the 5 canonical consumers point at a path that no longer exists — any other project's session invoking `/refresh-project-state` or `/risk-check` during that window hits a broken contract reference (hard-abort for `refresh-project-state.md`'s ABORT-message contract ref; soft-fallback for `risk-check-reviewer.md`, per its own graceful-degradation design). The Stage 2 authors already intend this gap to be short ("immediately after"), which is the right instinct — but nothing enforces "same session, no gap" as a hard rule, and DR-10 ("no directory wildcards for `git add` during disclosed concurrent sessions") is the relevant existing guardrail that should gate this specifically.

### Dimension 4: Reversibility
**Risk:** High

- The parent plan's own language is unchanged and unambiguous: Stage 3 is named **"the one-way door"** / **"the one-way step"** (§7 preamble, §7 Stage 3 heading) — self-classified as irreversible by the plan's own authors, and nothing in Stages 0–2 touches this classification (they explicitly stop short of Stage 3; Stage 0/1/2 are all reversible design-and-verify work by design).
- **What has genuinely improved:** Stage 0 captured concrete 3-repo rollback baselines (exact HEAD SHAs + ahead/behind + dirty-file inventory) — re-verified this pass as still accurate (`strategic-os` `7c8121b`, `management-os` `4a45b73`, `kb-strategic-os` `5aeafc8`, all unchanged from the Stage 0 snapshot). This makes a rollback *attempt* well-informed rather than blind, which is real risk reduction — but it does not change the mechanical fact that undoing "start fresh + archive" (parent plan §8.1) is a multi-step manual process (resurrect the archived repo, re-split merged commits back out of management-os history, restore the `additionalDirectories` grant, un-merge `settings.json`, revert `/monday-brief`'s read path), not a `git revert`.
- **A genuinely favorable fact for reversibility, worth weighting:** none of the 3 repos have pushed anything related to this migration yet — `strategic-os` is 4 ahead/0 behind (unpushed), `management-os`'s local `main` is not configured to track any upstream branch at all (confirmed via `git branch -vv`, even though `origin` points at a real GitHub URL), `kb-strategic-os` is 1 ahead/0 behind (unpushed). Per the workspace's own push-gating rule (push only at `/wrap-session`, batched, single confirmation), a pre-push local rollback is realistic **if the operator holds all pushes across all three repos until Stage 3 (+ Stage 2 sweep, + Stage 4 wall) is verified working** — but this requires deliberate discipline across a potential multi-session gap, not something the current staging enforces structurally.
- The archived-not-deleted design (§8.1: "its origin + history live on in the archive") means recovery is *possible* in principle, which keeps this at High (multi-step manual, real but non-trivial recovery path) rather than escalating past High into "unrecoverable."

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Two of the three named silent-breaks are now closed with actual evidence, not just design intent.** Stage 1's confidentiality-glob re-derivation for `state-retrieval-agent.md` was scratch-tested (TEST 1: the new rule correctly classifies `strategyos/inputs` → READ, `operationsos/inputs` → EXCLUDE, external projects → EXCLUDE; the old one-level glob was shown to miss both two-level dirs entirely). The `project-state-snapshot-agent.md` staleness fix was scratch-tested (TEST 2: an `operationsos`-only commit left the subtree-scoped `source_commit` unchanged while the old whole-repo-HEAD rule would have falsely marked `strategyos` stale). Both are real before/after empirical demonstrations, not assertions — this is the strongest, most concrete risk-reduction evidence in the whole staged effort.
- **New residual, first identified this pass:** the parent plan's Stage 3 instruction to "preserve internal structure so relative paths survive" (§7) would carry `strategic-os/.claude/` (its own `settings.json`, `shared-manifest.json`, 3 agents, 8 commands) into `projects/management-os/strategyos/.claude/` — a **second, nested `.claude/` folder** — which is in tension with the plan's own target architecture (§4: "`.claude/` # one settings.json"). Whether Claude Code reads/merges a nested `.claude/` folder inside a session's own project tree (as opposed to a wholly separate project reached via `additionalDirectories`, which Stage 0 *did* verify) is an untested assumption specific to this scenario. Repo precedent (`projects/repo-documentation/vault/.claude`, `projects/axcion-ai-system-owner/vault/.claude` — nested `.claude/` folders inside other projects' subdirectories that are inert unless a session is rooted directly there) suggests this is likely harmless, but it is not empirically confirmed the way Stage 0 confirmed the `additionalDirectories` case, and it is not named anywhere in Stages 0–2.
- The functional-overlap point from the 2026-07-07 pass (a same-project deny now doing the job the repo boundary used to do implicitly) is an already-documented repo pattern (`ai-resources/docs/permission-template.md` line 391, "deny-shadows-allow... sometimes intentional") — low incremental novelty, not scored as a fresh finding.

### Dimension 6: Principle Alignment
**Risk:** Medium

Ground: `projects/strategic-os/ai-strategy/principles-base.md` (read directly this pass — reachable at its pre-move path, as expected pre-Stage-3) plus workspace/repo `CLAUDE.md` (already loaded).

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — still satisfied.** `/ingest-initiative` remains deferred with zero current consumers (re-confirmed via grep this pass); no new speculative build has crept in during Stages 0–2.
- **OP-2 (automate execution, gate judgment) — satisfied, and this review is the mechanism.** Stage 3 is correctly treated as the load-bearing, hard-to-reverse, future-shaping decision that stays operator/gate-reviewed (this `/risk-check` re-run) rather than auto-executed once Stages 0–2 designs looked clean.
- **OP-3 / OP-11 (loud revision, never silent drift) — a tension, not a violation.** The Permissions Surface finding above (wall deferred to Stage 4, not landed with Stage 3) is stated as a plain fact in the Stage 1 doc ("applied at Stage 4") but is **not** explicitly flagged anywhere in Stages 0–2 as an *accepted, named risk* — i.e., nobody wrote "we are knowingly leaving a gap between Stage 3 and Stage 4; here is why that's acceptable." OP-3's spirit is to surface this kind of gap loudly rather than let it sit implicit in a stage-numbering choice. This is the same underlying issue as the Dimension 2 finding, viewed through the surfacing lens — not a second independent violation, so it does not by itself push this dimension to High, but it is the reason this dimension does not drop to Low.
- **DR-1 / DR-3 (placement) — satisfied**, unchanged from the 2026-07-07 pass.
- **The core tension carried from pass 1 persists, now more precisely located.** The philosophical downgrade (structural repo-boundary guarantee → convention-based deny-rule guarantee) is exactly what Stage 1 is trying to close — and closes well in *design* — but the Stage-3-before-Stage-4 sequencing means the downgrade is realized at Stage 3 while the compensating convention is not yet realized. This is a technical finding wearing a principle-shaped hat, same framing as the 2026-07-07 report's Dimension 6 — Medium, not High, because it is not an unacknowledged violation of a specific named principle ID, but an incompleteness in how loudly the sequencing gap is surfaced.

## Recommended redesign

The verdict is not a rejection of the migration's design — Stages 0–2 did real, verified work (2 of 3 silent-breaks scratch-tested closed; the permission wall is drafted and DR-9-analyzed; the reference-sweep changeset is exact and grounded) and the compounding-risk count genuinely dropped from 4 High dimensions to 3. The remaining 3 Highs (Permissions, Blast Radius, Reversibility) are driven by one structural choice: **the decomposition drew the "Stage 3" boundary at the physical move alone, stopping before the two steps that close its residual risk (Stage 4's permission wall, the Stage 2 reference-sweep commit) — which reopens a narrower version of the exact compounding pattern that drove the original 2026-07-07 RECONSIDER.**

- **Re-sequence, don't re-scope: fold the permission-wall application (currently Stage 4) and the Stage 2 reference-sweep commit into the same continuous session as the Stage 3 move — with the DR-9 #2 runtime acceptance test (throwaway write-and-confirm-blocked to `strategyos/state/live/`) run before the session ends.** Treat "Stage 3 landed" as meaning move + sweep + wall + acceptance-test all landed, not just the file move. This directly closes the Permissions sequencing gap and shrinks the Blast Radius gap-window to the same near-zero duration the Stage 2 authors already intend but don't yet enforce.
- **Before starting that combined session: (a) explicitly resolve DR-9 #1** (narrow the merged `Bash(*)` posture for at least the `strategyos/` subtree, or log an explicit, loud acceptance of the residual per OP-11 — do not leave it implicit), **and (b) hold all pushes across all three repos** (`strategic-os`, `management-os`, `kb-strategic-os` — none are currently pushed for this migration) until the combined Stage 3+sweep+wall landing is verified working end-to-end, maximizing the one reversibility lever staging has not yet spent.
- **Resolve the nested-`.claude/` ambiguity explicitly before the move**, either by empirically testing it the way Stage 0 tested `additionalDirectories` (open a session rooted at `projects/management-os/`, check whether a nested `strategyos/.claude/settings.json` is ever consulted) or by simplifying Stage 3's own instruction to merge `.claude/` contents directly into the parent project's `.claude/` during the move, rather than literally "preserving internal structure" into a second nested config folder that Stage 4 would have to clean up regardless.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from `CHANGE_DESCRIPTION` or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
