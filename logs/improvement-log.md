# Improvement Log

## Schema

Each entry is a `### YYYY-MM-DD — {title}` block. Fields:

- **Status:** `logged` | `proposed` | `pending` | `applied YYYY-MM-DD`
  *De facto convention: all current unresolved entries use `logged (pending)` as a combined compound state. The `/friday-checkup` [STALE] detection rule (added 2026-05-06) matches this compound form — not `pending` alone. If entries are normalized to the single-token schema in future, update the [STALE] match string in `friday-checkup.md` Step 6 accordingly.*
- **Verified:** present when Status is `applied` and the operator has confirmed the fix is live. Both `Status: applied` AND `Verified:` are required for `/resolve-improvement-log` to classify an entry as resolved.
- **Age:** auto-computed from the header date by `/resolve-improvement-log`; surfaced when > 6 weeks without resolution.
- **Review-cycle:** for items not yet resolved — records the last review date and disposition (e.g., `reviewed 2026-04-24, deferred to next quarterly`).
- **Category:** broad classification (e.g., `Audit-recurrence prevention`, `command/skill`).
- **Proposal:** the proposed change.
- **Target files:** files to be edited when executed.

Resolved entries (Status: applied + Verified) are archived to `improvement-log-archive.md` via `/resolve-improvement-log`.

---

## Triage — 2026-05-22 (friday-act improvement-log plan, item 1)

Read-only triage of the 4 entries logged this friday-checkup cycle. No fixes executed.

- **Friction logging stub entry ("note this")** — MED. Bundle with the 2 entries below — all 3 touch `note.md` / `friction-log.md`; one ~1 h session. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **/note + /friction-log incompatible session-header formats** — MED-HIGH. Load-bearing fix of the trio: the format mismatch makes `/note friction:` append duplicate blocks and silently drop write-activity capture. Do first in the bundled session. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **No trigger/context on manual friction entries** — MED. Bundle with the 2 above. — **SHIPPED 2026-05-22 commit `3a7ad4c`; archived.**
- **workflow-diagnosis / improvement-analyst boundary doc** — MED, dependent. Do inside the `/create-skill` run that fulfills `inbox/workflow-diagnosis.md` — not standalone. — **Still pending** (entry retained below as `### 2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst`).

Queue: one bundled `note.md` / `friction-log.md` session for the 3 friction-logging entries; the boundary-doc entry rides with the workflow-diagnosis skill build.

**Annotation 2026-05-25:** Three of four entries shipped same-day (2026-05-22, commit `3a7ad4c` — unified session headers, stub detection, context capture). Triage block retained as historical record of the friday-act planning process. Only the workflow-diagnosis boundary-doc entry remains active.

---

### Sequencing note (five entries combined)

Suggested three-session sequence:

- **Session 1 (rules, ~45 min):** Entry "Extend Model Tier rule to agents" + Entry "Codify subagent-summary cap + /usage-analysis discipline". Purely CLAUDE.md + one `/wrap-session` edit. Lowest risk, highest per-turn leverage. — **VERIFIED-DONE 2026-05-25:** Both source entries already codified by drift. Workspace `CLAUDE.md` § Model Tier names agents explicitly and references `docs/agent-tier-table.md` ("Extend Model Tier rule to agents" — done). `ai-resources/CLAUDE.md` § Subagent Contracts states the 30/20-line cap + notes-to-disk + summary-only rule and names existing implementations ("Codify subagent-summary cap" — done). `ai-resources/CLAUDE.md` § Session Telemetry codifies the `/usage-analysis`-every-substantive-session rule and `/wrap-session` prompt integration ("/usage-analysis discipline" — done). [FADING-GATE] pattern — booking was carried forward from when these rules did not yet exist; no edits required.
- **Session 2 (templates, ~1–2 hrs):** Existing entries — canonical project settings template + canonical project CLAUDE.md template. Touches `/new-project` pipeline + research-workflow templates. Before implementing, re-read the 2026-04-13 decision ("Commit Rules propagate by explicit copy") to confirm whether the inheritance workaround is still needed. — **VERIFIED-DONE 2026-05-25:** Templates extracted to `ai-resources/templates/` (settings template + 5 CLAUDE.md fragments + README); `/new-project` step 2 + step 4 rewired to consume via walk-up to `ai-resources/`; research-workflow CLAUDE.md aligned (2 within-section drift fixes; `## File Verification and Git Commits` preserved as workflow-local per risk-check mitigation #3). 2026-04-13 decision re-checked → **KEEP** (uneven per-project mirroring across 5 projects confirms inheritance still unreliable; rationale recorded in `templates/README.md`). Mitigations: plan-time `/risk-check` PROCEED-WITH-CAUTION + system-owner-added architecture-map update = 4 mitigations total; end-time `/risk-check` GO (all 5 dimensions Low). QC found bash-native substitution unsafe under apostrophes in description + agent global-substitution collision → swapped to python3 + mustache `{{NAME}}` / `{{PROJECT_DESCRIPTION}}` placeholders. Commits: `8b44015` (templates + arch map + cross-refs), `39b27b5` (`/new-project` rewire), `c692864` (research-workflow alignment), `54bf85b` (risk-check reports). Follow-on for a future session: `deploy-workflow.md:209` still carries an inline `CANONICAL_PERMS` literal — second consumer candidate for `templates/` unification.
- **Session 3 (detection + automation, ~45 min):** Entry "Add three questionnaire items to /repo-dd" + Entry "Pre-commit skill-size warning hook". Depends on Session 1 (Agent Tier Table) and Session 2 (canonical templates) landing first so the new questionnaire items have stable references. — Session 1 dependency satisfied (verified-done 2026-05-25); Session 2 dependency satisfied (verified-done 2026-05-25). — **VERIFIED-DONE 2026-05-25:** Both source entries shipped 2026-04-18 — commit `0962c0c` (source entries logged), commit `bbd2261` (`.claude/hooks/check-skill-size.sh` informational pre-commit warning at >300 lines), commit `e3f6dfe` (Prevention Session 3 wrap confirming "questionnaire + skill-size hook + broadened allowlist" both landed). Pre-commit hook present at `.claude/hooks/check-skill-size.sh` and wired in `.claude/hooks/pre-commit` lines 76–79. `/repo-dd` questionnaire concept present (command line 61). [FADING-GATE] pattern — booking carried forward through 2026-05-22 Sequencing note and 2026-05-25 dependency-satisfaction annotation when the underlying work had already shipped 5 weeks prior. No edits required.

### 2026-04-25 — Make /wrap-session leaner

- **Status:** applied 2026-05-25
- **Verified:** 2026-05-25 — sub-1 through sub-4 landed in commit `a9d3321`; QC pass returned GO verdict (qc-reviewer on sonnet override; opus saturated). Executed 1 day ahead of the 2026-05-26 booking. The paired permission-sweep-auditor entry remains booked for 2026-05-26.
- **Review-cycle:** BOOKED 2026-05-22 — dedicated session targeted for **2026-05-26** (W22), paired with the 2026-04-28 permission-sweep-auditor entry below (~1.5–2 h combined). Not deferred again: two review cycles (2026-05-18, 2026-05-22) have now passed without execution; a third deferral is exactly the cycle-waste this booking exists to break. Scope when executed: port sub-1 through sub-4 (sub-5 is obsolete); sub-2 (reorder archive before session-note append) is the highest-leverage change.
- **Category:** command/skill
- **Source:** Mid-wrap conversation 2026-04-25 — operator asked why /wrap-session was taking so long. Audit of the wrap's actual tool-call count surfaced ~3-4 round-trips of avoidable cost.
- **Friction observation:** A typical /wrap-session reads 3 full log files (innovation-registry, improvement-log, friction-log) when single greps would do, and runs the archive AFTER appending today's entry, which forces a freshness-failure re-read of session-notes.md when the archive trims it.
- **Proposal:**
  1. **Replace full-file Reads with greps in steps 7, 9, 10.** Step 7 (innovation triage): grep for `| detected |` in `logs/innovation-registry.md`. Step 9 (improvement verification): scan for entries with `Status: applied` missing a `Verified:` line via awk/grep. Step 10 (friction reminder): grep for today's date (`$(date +%Y-%m-%d)`) in `logs/friction-log.md`. Saves ~150 lines of content streaming through context per wrap.
  2. **Reorder Step 11 (archive) BEFORE Step 3 (append session note).** Archive script rewrites session-notes.md when threshold exceeded; appending FIRST then archiving causes Edit-after-archive freshness invalidation, forcing a re-read of ~60 lines of the just-written note. Archive operates only on existing entries — running it before today's note is written is safe and avoids the re-read entirely.
  3. **Drop the wc -l + Read pattern in steps 1-2.** Spec says "last 5 lines only" but a `wc -l` probe before tail-reading is redundant. Tail-read directly with a known offset.
  4. **Drop the file-existence inventory before content reads.** Six `if -f` checks pre-empting reads in the current flow — let Read error on the rare missing case rather than pre-checking each.
  5. **Auto-pass dirt check when all dirty paths match Files Created/Files Modified verbatim.** Step 12a currently only short-circuits on empty git-status. Extending the silent-skip rule to "all matched" would skip the operator prompt for clean wraps where every dirty path was produced this session and is already enumerated. **Obsolete (2026-04-28):** Step 12a removed entirely; auto-pass refinement no longer applicable.
- **Target files (when executed):**
  - `ai-resources/.claude/commands/wrap-session.md`

### 2026-04-28 — permission-sweep-auditor: classify template sources, skip Rule 8

- **Status:** applied 2026-05-25
- **Verified:** 2026-05-25 — agent edit shipped in this session. Step 4a rewritten with two-signal template-class detection (path-class + value-class); SILENCE behavior replaces the previous ADVISORY downgrade because ADVISORY was empirically insufficient (see "Regression incident" below). `permission-template.md` § Intentional-template exceptions updated to mirror the new logic. Template file `workflows/research-workflow/.claude/settings.json` line 34 restored from hardcoded path to `{{WORKSPACE_ROOT}}` placeholder. Risk-check verdict was PROCEED-WITH-CAUTION (report: `audits/risk-checks/2026-05-25-edit-ai-resources-claude-agents-permission-sweep-auditor-md.md`); system-owner second opinion concurred and added the silencing recommendation.
- **Review-cycle:** BOOKED 2026-05-22 — executed 2026-05-25, one day before the booked date.
- **Regression incident (2026-05-11):** Between this entry being logged (2026-04-28) and the booked execution (2026-05-26), the exact failure mode this entry warned about occurred. A `permission-sweep Bundle 1` session (commit `0514590`) treated the `{{WORKSPACE_ROOT}}` placeholder as an actionable Rule 8 violation despite the ADVISORY tag, and replaced it with a literal absolute path — breaking the template. This incident demonstrates that downgrading to ADVISORY is insufficient protection; the placeholder case is now SILENCED entirely (no finding at any severity), and the path-class signal actively detects the regression mode (template file whose placeholders have been replaced).
- **Open sub-question resolved:** Agent-definition edits are NOT explicitly named in the `/risk-check` change-class list per `docs/audit-discipline.md` lines 19-24. However, this particular change has audit-cycle effects (every future `/permission-sweep` and `/friday-checkup --dry-run` uses the new logic), so `/risk-check` was invoked discretionarily. Verdict PROCEED-WITH-CAUTION; system-owner second opinion concurred.
- **Category:** Audit-recurrence prevention
- **Source:** `/permission-sweep` run 2026-04-27 / 2026-04-28 (report at `ai-resources/audits/permission-sweep-2026-04-27.md`). Auditor flagged `ai-resources/workflows/research-workflow/.claude/settings.json` line 35 (`"additionalDirectories": ["{{WORKSPACE_ROOT}}"]`) as a HIGH Rule 8 violation ("stale `additionalDirectories`") because the value is an unfilled placeholder. The placeholder is intentional — the most recent commit on that file (`81cb6c2 update: research-workflow template — additionalDirectories placeholder + SETUP step`) explicitly added it as a deploy-time fill-in consumed by `/deploy-workflow` / `/new-project`. Replacing it with a resolved path would corrupt new deployments. Auditor cannot currently distinguish template source from deployed instance.
- **Friction observation:** Held finding will re-fire on every future `/permission-sweep` run (including weekly `/friday-checkup --dry-run`) until the auditor learns to skip it. Each re-fire wastes operator attention on a non-issue and risks accidental "fix" by a future agent.
- **Proposal:**
  - Update `ai-resources/.claude/agents/permission-sweep-auditor.md` to add a template-class classification step before applying Rule 8. Heuristic: any file whose path matches `**/workflows/*/.claude/settings.json` (template source under the workflow library) is template-class; for template-class files, skip Rule 8 entirely or accept `{{...}}` placeholder values as PASS rather than HIGH. Optionally also detect `{{...}}` Mustache placeholders in any allow/deny entry as a secondary template-class signal.
  - Apply via `/risk-check` per Autonomy Rules pause-trigger #9 (agent-definition edit is a harness-level structural change). Confirm no regression on the 2 currently-scanned files before landing.
- **Target files:**
  - `ai-resources/.claude/agents/permission-sweep-auditor.md`

### 2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst — document the boundary before building

- **Status:** logged (pending)
- **Category:** process
- **Friction source:** resource brief `inbox/workflow-diagnosis.md` (requested 2026-05-19), Exclusions section — explicitly lists "Analyze session-level friction or process issues (that's `improvement-analyst` agent)" as a non-goal
- **Proposal:** The boundary between the planned `workflow-diagnosis` skill (artifact-defect-driven workflow fixes) and the `improvement-analyst` agent (session-friction-driven workflow fixes) currently lives only in the inbox brief's prose, which is archived to `inbox/archive/` once fulfilled. When `/create-skill` processes `inbox/workflow-diagnosis.md`, add a one-paragraph routing note to `ai-resources/docs/ai-resource-creation.md` (or a short `## Workflow-improvement surfaces` section) stating the split: `improvement-analyst` agent = session-friction-driven; `workflow-diagnosis` skill / `/diagnose-workflow` = artifact-defect-driven; with trigger phrasing for each. Documentation only, no new tooling. Sequence with the `/create-skill` run that fulfills the brief. Effort small; impact medium; first occurrence.
- **Target files:** `ai-resources/docs/ai-resource-creation.md`

### 2026-05-25 — /token-audit numbered project menu
- **Status:** applied
- **Category:** command
- **Friction source:** friction-log 09:07 — /token-audit scope-selection required 3 rounds of AskUserQuestion; desired UX: list all projects numbered upfront
- **What changed:** Replaced the empty-args branch in `/token-audit` Step 1 with a numbered scope menu (1=ai-resources, 2=workspace, 3a/3b/…=projects). Keyword args (`ai-resources`, `workspace`, `project <name>`) retained as power-user shortcuts. Menu pattern mirrors `/friday-checkup` Step 3.
- **Verified:** 2026-05-25 — confirmed by operator

### 2026-05-25 — /monday-prep B7 seeds always-loaded CLAUDE.md layer
- **Status:** applied
- **Category:** command
- **Friction source:** friction-log 09:13 — monday-prep B7 skips workspace CLAUDE.md and ai-resources/CLAUDE.md; operator caught during W22 monday-prep diagnostics
- **What changed:** Prepended a two-step always-loaded layer audit (workspace CLAUDE.md + ai-resources/CLAUDE.md) to the B7 block before the ACTIVE_PROJECTS loop. No skip exemption for the always-loaded layer (skip rule is projects-only). Invokes `/audit-claude-md workspace` and `/audit-claude-md ai-resources` respectively.
- **Verified:** 2026-05-25 — confirmed by operator

### 2026-05-25 — Risk-check rule clarified to cover reorders of existing shared-state ops
- **Status:** applied
- **Category:** rule
- **Friction source:** friction-log 09:53 — /wrap-session leaner refactor reordered archive-vs-append (shared-state ops); risk-check was skipped under "existing-command refactor" framing
- **What changed:** (a) Added clarifying clause to `docs/audit-discipline.md` line 24: reordering existing shared-state ops qualifies, not only new automation. (b) Added tripwire note to `session-plan.md` Step 6: "existing-command refactor" framing does NOT exempt from /risk-check when shared-state ops are reordered.
- **Verified:** 2026-05-25 — confirmed by operator

### 2026-05-25 — Canonical scope-selection pattern doc (parked)
- **Status:** logged (pending)
- **Category:** process
- **Friction source:** cross-reference of friction 09:07 against existing /monday-prep and /friday-checkup scope-selection idioms — three different encodings across sibling commands
- **Proposal:** Create `docs/scope-selection-pattern.md` (reference the `/friday-checkup` Step 3 lines 82–95 as canonical pattern) and add a one-line pointer in `ai-resources/CLAUDE.md` under a "Command Conventions" section. Prevents the next audit-class command from inventing a fourth encoding. Triage verdict: park — N=2 pattern occurrences, premature to formalize; Finding 1 covers the concrete friction. Revisit when a third command needs the pattern.
- **Target files:** `docs/scope-selection-pattern.md` (new), `ai-resources/CLAUDE.md`

### 2026-05-25 — Pattern to watch: operator-caught review-class gaps (2 occurrences)
- **Status:** logged (pending)
- **Category:** process
- **Friction source:** friction-log 09:13 (B7 always-loaded skip) and 09:53 (risk-check existing-command exemption) — both caught by operator post-execution, not by /qc-pass or the plan
- **Proposal:** If the pattern recurs in the next 1–2 sessions (3+ total instances), add either (a) a review principle to `skills/ai-resource-builder/references/review-principles.md` ("When a command audits layer N, verify the candidate list includes the always-loaded layer above N") or (b) a /qc-pass checklist item for plan-time risk-class enumeration. Current count: 2 in one session — at watch threshold, below escalation threshold. No action this round.
- **Target files:** `skills/ai-resource-builder/references/review-principles.md` or qc-pass protocol (if escalated)

### 2026-05-25 — Extract shared rendering convention doc
- **Status:** logged (pending)
- **Category:** infrastructure
- **Friction source:** /session-start rendering fix (mandate confirmation) — current rendering rules (icon set + bold-label discipline + section-structure rules) are inlined in `session-start.md` Step 2 with a `<!-- TODO: extract to shared rendering convention -->` marker. One consumer today; deferred per DR-7 (generalize only when a second confirmed consumer exists).
- **Proposal:** When a second consumer appears (e.g., another confirmation-output command, or a friction event around `/prime` rendering inconsistency), extract the rules to `ai-resources/docs/rendering-conventions.md` and reference from `session-start.md` (replacing the inlined block) and `prime.md`. Side note: `/prime`'s output template currently uses plain-text labels (not bold inline) — minor inconsistency to harmonize in the same extraction session.
- **Target files:** `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/prime.md`, new `ai-resources/docs/rendering-conventions.md`

### 2026-05-26 — repo-architecture.md is stale on `knowledge-bases/` (top-level directory + canonical-homes row)
- **Status:** applied 2026-05-26
- **Verified:** 2026-05-26 — workspace-root tree gained `├── knowledge-bases/` entry; canonical-homes table gained `**Obsidian KB vault** (cross-project reuse)` row. `pe-kb-vault/` confirmed sole vault via `ls knowledge-bases/`.
- **Category:** documentation
- **Friction source:** `/consult` system-owner advisory during `/context-builder` for the `strategic-os` project (chat session 2026-05-26). Operator asked where a planned Karpathy-style Obsidian frameworks KB should be deployed via `/deploy-kb` — inside-project vs. standalone. System-owner flagged that `ai-resources/docs/repo-architecture.md` does not document the `knowledge-bases/` top-level directory (which exists at workspace root and contains `pe-kb-vault/`) and that the canonical-homes table has no row for "Obsidian KB vault" as an artifact type. Both gaps surfaced because `/deploy-kb` already offers `knowledge-bases/{name}/` as a first-class deployment option and one such vault is in active use. System-owner cited OP-11 (surfacing tacit principles) and `system-doc.md § 4.5` (documentation-accuracy open loop). Verdict: documentation-drift item, not a blocker for the strategic-os work; route to the next `/friday-checkup` cadence.
- **Proposal:** Single edit pass on `ai-resources/docs/repo-architecture.md`:
  (a) **§ Top-level layout (workspace-root tree).** Add `knowledge-bases/` as a documented top-level directory with a one-line description (e.g., "standalone Obsidian KB vaults intended for cross-project reuse, deployed via `/deploy-kb`").
  (b) **§ Canonical homes by artifact type.** Add a new row: `**Obsidian KB vault (cross-project reuse)** | `knowledge-bases/{name}/` | Deployed via `/deploy-kb` standalone option; project-scoped vaults instead live under `projects/{name}/vault/`.` Wording captures the implicit principle ("KB vaults intended for cross-project reuse live in `knowledge-bases/{name}/`") that is currently tacit.
  (c) **§ When this file needs to change.** No change needed — "new top-level directory" already qualifies.
  `repo-architecture.md` is documentation, not a CLAUDE.md or settings file, so `/risk-check` is not required by change-class. Light-touch verification: confirm `pe-kb-vault/` is the only existing standalone vault before writing the row.
- **Target files:** `ai-resources/docs/repo-architecture.md`

### 2026-05-27 — Concurrent-session wrap clobbers in-progress session's session-notes.md additions

- **Status:** applied 2026-05-27
- **Verified:** 2026-05-27
- **Category:** session-issue
- **Source:** `/resolve-repo-problem 2026-05-27`
- **Friction source:** Expected: this session's `/prime`-appended task header + `/session-start`-written mandate to remain in `logs/session-notes.md` through wrap. Actual: a concurrent `/contract-check` session's `/wrap-session` ran `git add logs/session-notes.md` (which stages the entire working-tree content, not just its own additions), shipping my uncommitted mandate lines under commit `14d2a04` — the contract-check session's wrap commit. My session subsequently saw no `session-notes.md` modifications and committed its work without a wrap entry. Plan 2's mtime guard (`/session-start` Step 0.5, shipped 2026-05-26) only covers the `/prime` → `/session-start` upstream window; the failure here is post-`/session-start`, in the concurrent-wrap window — Plan 2's symmetric blind spot.
- **Proposal:** Add a wrap-time pre-commit guard to `wrap-session.md` (the canonical `ai-resources/.claude/commands/wrap-session.md` plus the workspace-root Phase 3 copy). Before staging `logs/session-notes.md`, compare on-disk content to the session's own writes: detect any `## YYYY-MM-DD` headers or `**Mandate:**` lines authored by another session and stop with a chat prompt asking the operator to resolve (commit only own work, or commit the union). Symmetric counterpart to Plan 2 — closes the post-`/session-start` window the same way Plan 2 closed the pre-`/session-start` window. **/risk-check change class:** YES (canonical-command edit) — run `/risk-check` before landing.
- **Implementation 2026-05-27:** Shipped commits `6b1b018` (ai-resources canonical Step 3.5 + risk-check report) + `5157a5d` (workspace-root Phase 3 copy Step 1.5). Detection uses TWO independent signals — today-header count AND mandate-line count — so the guard catches both the separate-header incident shape (original 2026-05-27 commit `14d2a04` failure) AND the shared-header incident shape (when /prime's header-reuse rule means both concurrent sessions share one today-header but each writes a mandate line under it). Mechanical disambiguator via `.prime-mtime` marker existence + today-midnight epoch check; default-to-stop on FOREIGN >= 1; no union-reply branch. Risk-check verdict PROCEED-WITH-CAUTION with 5+2 mitigations applied (SO second opinion). QC verdict REVISE → 2 findings addressed (bash `grep -c` zero-match arithmetic bug + header-reuse blind spot via mandate-line signal); 1 finding deferred (marker semantics simplification — optional, non-blocking).
- **Target files:** `ai-resources/.claude/commands/wrap-session.md`, `~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (Phase 3 wrap copy)
- **Notes:** `ai-resources/audits/working/2026-05-27-resolve-concurrent-session-overwrite-session-notes.md`; risk-check report `ai-resources/audits/risk-checks/2026-05-27-wrap-session-foreign-session-detection-guard.md`

### 2026-05-27 — Foreign-files-in-working-tree alarm — diagnostic refinement (symlink-check-first)

- **Status:** applied 2026-05-27
- **Verified:** 2026-05-27
- **Category:** session-issue
- **Source:** /resolve-repo-problem 2026-05-27
- **Friction source:** During this session's Cluster 1 commit, `git status` returned 12+ "untracked" `.claude/commands/*.md` files under workspace-root that appeared to be new command additions from a runaway session. Investigation revealed 12 of 13 are SYMLINKS to ai-resources canonical command bodies (already committed); only 1 (`harness-start.md`) is a real abandoned file from May 25. Separately, 4 ai-resources file modifications + 2 fx-c1 risk-checks appeared in working tree mid-session and committed 1 second after the Cluster 1 commit — a parallel session's commit-in-progress, not a concurrent-session contention. Net: false alarm, but the operator/Claude spent a /resolve-repo-problem cycle (~5 min + investigator subagent) to triage it.
- **Proposal:** Add a one-line diagnostic-shortcut to `docs/commit-discipline.md` (or workspace CLAUDE.md § Working Principles): when `git status` flags many `?? .claude/commands/*.md` files under workspace-root, run `find .claude/commands -type l -newer /dev/null | wc -l` (or equivalent) BEFORE escalating to /resolve-repo-problem — most will be symlinks to ai-resources canonical bodies. Separately, log the abandoned `harness-start.md` and the 2-day-old harness/* leftovers as candidates for `/cleanup-worktree` at next Friday cadence.
- **Implementation 2026-05-27:** Shipped commit `94e0cf2` (ai-resources) — new "Foreign-files diagnostic shortcut" subsection appended to `docs/commit-discipline.md` with the symlink-check command (`find .claude/commands -type l | wc -l`) and the rule to compare its count against the untracked-file count before escalating. Abandoned `harness-start.md` left as a separate `/cleanup-worktree` candidate.
- **Target files:** `docs/commit-discipline.md` OR workspace `CLAUDE.md` (add 1–2 sentence diagnostic-shortcut rule); `harness-start.md` abandoned file separately surfaced.
- **Notes:** `audits/working/2026-05-27-resolve-concurrent-session-foreign-files-cluster-1-investigation.md`

### 2026-05-28 — /fix-repo-issues scanner output lacks coverage-confidence transparency

- **Status:** applied 2026-05-28
- **Verified:** 2026-05-28 — confirmed by operator (operator selected "Option A" at the triage gate; edit shipped same session)
- **Category:** session-issue
- **Source:** `/resolve-repo-problem 2026-05-28`
- **Friction source:** Expected: /fix-repo-issues scanner summary self-evidently conveys what was scanned, what was excluded and why, and which items are fix-shaped vs build-shaped vs watch-shaped — so the operator can trust the "Plan-into-batch" tier without re-reading source logs. Actual: scanner returned 9 items with a Top-candidates list intermixing T1 fix items (id-04) with T1 inbox build briefs (id-01/02/03/05), the working-notes file held 16 exclusion bullets but the 30-line summary stripped them, and the operator had to push back ("Are you sure there's only one problem?") to trigger a manual cross-check across friction-log, improvement-log, and decisions.md. Trigger: `/fix-repo-issues` Step 1 (scanner invocation) + Step 3 (plan preview).
- **Proposal:** Apply Option A (Quick patch) — extend the scanner agent's return-summary template to include explicit lines for sources scanned, out-of-contract source classes, exclusion counts by category, deferred-but-not-triggered counterweight, and item-type classification (fix / build / watch); re-segment Top candidates by type before priority ranking. Bump the agent's 30-line summary cap to ~40 to accommodate the audit trail. Edit confined to `.claude/agents/fix-repo-issues-scanner.md` — no command-body change required. **/risk-check change class:** YES (canonical-agent body edit) — run `/risk-check` before landing per audit-discipline.md.
- **Implementation 2026-05-28:** Shipped commit `0c4544f` — single-file edit to `.claude/agents/fix-repo-issues-scanner.md`: new Step 5.5 (item-type classification: fix/build/watch by source, with priority-signal lift rule), new Step 5.6 (audit-trail counters), Step 6 working-notes schema gains `type` column + "By type" count + "## Coverage report" block, Step 7 return-summary gains Coverage block + per-type segmented Top candidates (Fix-shaped / Build-shaped / Watch-shaped), line cap bumped 30→40 consistently across 3 references. Risk-check verdict GO (all 5 dimensions Low; report `audits/risk-checks/2026-05-28-proposed-change-extend-the-return-summary-template-in-claude.md`); single-consumer agent; LLM-driven downstream consumption tolerates added blocks; `NOTES:` parse anchor preserved.
- **Target files:** `ai-resources/.claude/agents/fix-repo-issues-scanner.md` (Option A); optionally `ai-resources/.claude/commands/fix-repo-issues.md` Step 3 if Option B is chosen instead.
- **Notes:** `audits/working/2026-05-28-resolve-fix-repo-issues-scanner-coverage-confidence-gap.md`; risk-check report `audits/risk-checks/2026-05-28-proposed-change-extend-the-return-summary-template-in-claude.md`

### 2026-05-28 — /session-start Step 0.5 mtime guard misses foreign writes that arrive DURING the Mandate Confirmation wait

- **Status:** logged — superseded by the broader 2026-05-28 entry below ("Concurrent sessions cause TOCTOU races on shared log files"). The narrow Step 2.5 patch proposed here is no longer the recommended fix; the structural per-session-marker approach replaces it. Retained for trace-history of how the problem was first observed.
- **Category:** session-issue
- **Source:** Surfaced live during axcion-brand-book session 2026-05-28 — operator explicitly attributed the trigger to "I start concurrent sessions."
- **Friction source:** /session-start Step 0.5 runs the concurrent-session mtime guard exactly once, immediately after Step 0's session-notes.md read and before Step 1 reads the mandate. It compares `SESSION_NOTES_MTIME` against `PRIME_MTIME` (or against `NOW - 120s` fallback) at that single instant. Today the guard returned `DELTA=0` (clean) at Step 0.5; Step 1 used the supplied mandate verbatim; Step 2 echoed the Mandate Confirmation block and waited for the operator's `y`. During that wait, the operator started a second /prime session, selected a different menu task (task 3 — backfill `_appendix/rejected_directions.md`), and that concurrent /prime wrote a `**Work (redirected via /prime task selection):**` line to logs/session-notes.md. The operator's `y` then arrived in the original session against the original (specimen) mandate echo — but session-notes.md by then contained the redirect line for the backfill task. The original session would have proceeded to Step 3 and written the specimen mandate alongside the foreign redirect line if the operator had not corrected the path via AskUserQuestion. Reproduction is reliable whenever a foreign session writes to session-notes.md between Step 0.5 (clean) and Step 3 (write).
- **Proposal:** Add a second mtime check at Step 3 immediately before locating today's header for the mandate-line write — call it "Step 2.5 — Re-check mtime guard at write time." Capture `WRITE_TIME_MTIME = stat session-notes.md` and compare to the `SESSION_NOTES_MTIME` value already captured in Step 0.5 (must persist that value into Step 3's scope). If `WRITE_TIME_MTIME > SESSION_NOTES_MTIME`, a foreign write happened during the Mandate Confirmation wait → surface a conflict block before applying the operator's confirmation: re-read the last ~20 lines of session-notes.md, show the diff to the operator, offer (1) proceed with the originally-confirmed mandate, (2) re-echo a new Mandate Confirmation reflecting whatever the foreign write redirected to, (3) stop. Default on no-response = (3) stop. Edits confined to `ai-resources/.claude/commands/session-start.md` (new Step 2.5 between Step 2 and Step 3). **/risk-check change class:** YES (canonical-command body edit; /session-start runs at every session start) — run /risk-check as advisory gate before landing. Secondary consideration: today's Step 0.5 tuning notes call out the 120s threshold and freshness window but do not anticipate the during-Step-2 window. Update the tuning-notes block in Step 0.5 to forward-reference the new Step 2.5 so operators reading Step 0.5 understand its coverage limit.
- **Target files:** `ai-resources/.claude/commands/session-start.md` (insert Step 2.5 between Step 2 and Step 3; update Step 0.5 tuning notes to forward-reference Step 2.5). Also worth considering: a one-line companion note in `ai-resources/.claude/commands/prime.md` Step 8a.3 reminding that the marker-write at Step 8a.3.a does not protect /session-start's Step 2 confirmation window.

### 2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files (broader entry — supersedes the narrow `/session-start` Step 0.5 entry above)

- **Status:** logged (pending)
- **Category:** session-issue / cross-cutting architecture
- **Source:** Live recurrence during axcion-brand-book session 2026-05-28; operator explicitly attributed cause to deliberate concurrent-session use. Friction-log entry 2026-05-28 10:05 records the live event. This entry is broader than the earlier same-day `/session-start` Step 0.5 entry (which only proposed a Step 2.5 patch); supersede that proposal with the structural fix below.
- **Supersedes:** the same-day "2026-05-28 — /session-start Step 0.5 mtime guard misses foreign writes that arrive DURING the Mandate Confirmation wait" entry above. Mark that entry's Status as "logged — superseded by broader 2026-05-28 entry below" when applying this one. The narrow Step 2.5 patch from the prior entry is no longer the recommended fix; the structural per-session-marker approach replaces it.

#### Problem class

Three commands (`/prime`, `/session-start`, `/session-plan`) read shared log files (`logs/session-notes.md`, `logs/session-plan.md`) at command entry, make decisions based on the read, and later write back to those same files. Between the read and the write, an arbitrary number of conversation turns elapse (mandate confirmation echoes, class/intent confirmation prompts, AskUserQuestion blocks, Read calls for source material). When a second session is active in the same project, ANY write the second session makes to a shared log during the first session's read-to-write window is invisible to the first session's point-in-time mtime guard. This is a classic TOCTOU (time-of-check-to-time-of-use) race.

Today's session demonstrated the race three times in one startup sequence:

1. **`/session-start` Step 0.5 → Step 2 wait → Step 3 write.** Step 0.5 mtime check returned clean. Foreign write arrived during the Mandate Confirmation echo wait. Operator's `y` was applied against an echoed mandate that no longer matched on-disk content.
2. **`/session-plan` Step 0 → Step 7 write.** Step 0 mtime check found `session-plan.md` 25 hours old (clean). Foreign session's `/session-plan` rewrote the file during Step 1.5 / Step 2 / Step 3 confirmations. Step 7 Write tool errored with "File has been modified since read"; the only reason this race was visible was because Claude Code's Write tool happens to enforce read-before-write integrity at the tool level.
3. **`/session-notes.md` mandate-block overwrite.** Foreign session's `/session-start` Step 3 wrote its own mandate block under the same `## 2026-05-28` header that I had just written my mandate to. My mandate block was fully replaced.

The prior fix for `/session-plan` Step 0 (commit `8ab5685`, MISMATCH auto-route to pass2) was a one-off patch to one command. The race class survives in every other shared-log read-write site.

#### Proposed structural fix — per-session markers on all shared writes

Each session at `/prime` time generates a 4-character session marker (e.g., `S1`, `S2`, `a3f7`) and persists it to `logs/.session-marker` (single file, last writer wins — but this file is only read by the SAME session's later commands, so the race surface is small).

All subsequent shared-log writes scope themselves with this marker:

- **`logs/session-notes.md`** — `/prime` writes `## YYYY-MM-DD — Session {marker}` instead of bare `## YYYY-MM-DD`. Each concurrent session gets its own header. Existing readers that grep `^## ${DATE}` still match (and the `/prime` Step 1a sibling-entry sweep already handles multiple same-day headers as a known pattern). `/session-start` Step 3 appends its Mandate block under THIS session's marker-bearing header (located by reading `.session-marker`, not by date-only match).
- **`logs/session-plan.md`** — replaced by `logs/session-plan-{marker}.md`. The collision detection in `/session-plan` Step 0 simplifies dramatically: there is no shared file to collide on. Each session writes to its own scoped file. `pass2` becomes unnecessary (and the existing pass2 mechanism graduates from "race-condition safety valve" to "explicit operator-initiated re-plan within one session").
- **Downstream readers** (`/drift-check`, `/wrap-session`, `/qc-pass`, etc.) read `.session-marker` first, then read the marker-scoped files. A symlink or alias from `logs/session-plan.md` to the current session's plan can preserve backward compatibility for readers that don't know about markers yet.

The marker is short and deterministic per session — the first existing `.session-marker` value on disk plus a deterministic increment (`S1` → `S2` → `S3`), wrapping at `S9` → `Sa` → `Sz`. `/prime` Step 0 reads the existing value (if present and same-day) to increment; otherwise resets to `S1` and writes `YYYY-MM-DD` + value. A same-day re-read of `.session-marker` returning a different value than the session's own cached marker is itself a concurrent-session signal that `/prime` can surface.

This eliminates the TOCTOU race at its root: there is no longer a shared mutable file for concurrent sessions to collide on. The remaining synchronization concern is `.session-marker` itself, but the file is small, atomic-write-friendly (single short token), and is read ONLY by the same session that wrote it — not cross-session — except during `/prime` increment.

#### Alternatives considered

- **(a) Atomic re-read at each write site.** Every shared-log write site re-reads mtime immediately before write and abort/restart if changed. Lower-magnitude change, but requires patching ~6 write sites across 4 commands and only narrows the race window (does not eliminate it). Rejected.
- **(b) Per-session subdirectory.** Each session writes to `logs/sessions/{marker}/{file}.md`. Cleaner separation than markers in filenames, but requires every consumer command to know about the subdirectory convention. Higher-friction migration. Rejected for now; can be a later step.
- **(c) Advisory file locks (`flock`).** Standard Unix pattern. Adds shell-state complexity, doesn't survive across tool boundaries (Claude Code Write tool doesn't acquire flocks), and would require wrapping every Write/Edit in a Bash flock dance. Rejected.
- **(d) Refuse concurrent sessions.** `/prime` detects an active session via marker file and refuses to start a second one. Operator preference is to RUN concurrent sessions (today's evidence), so refusing would block a workflow they actively use. Rejected.
- **(e) Status quo + Step 2.5 patches.** Each command gets a TOCTOU-narrowing patch like the one in the prior 2026-05-28 entry. The race class survives across the ~6 write sites and recurs whenever a new write site is added. This is the trajectory we've been on (the 2026-05-25 14:10 friction entry was the third recurrence). Rejected in favor of structural fix.

#### Migration plan

Phased, low-risk:

1. **Phase 1 — `/prime` writes the marker.** `/prime` Step 8a.3 / 8b.1 generates and persists the marker; existing today's-header behavior unchanged. No other command reads the marker yet. Risk: zero (additive).
2. **Phase 2 — `/session-start` and `/session-plan` consume the marker for header location and file naming.** Commands prefer marker-scoped files; fall back to legacy paths if marker absent (interop with sessions that started before Phase 2 rollout). Risk: low (each command's behavior gracefully degrades).
3. **Phase 3 — downstream consumers (`/drift-check`, `/wrap-session`, `/contract-check`, `/qc-pass` plan-reading) update to read marker first.** Risk: medium — many touchpoints.
4. **Phase 4 — deprecate legacy code paths.** Once Phase 3 is verified, remove the fallback paths in `/session-start` / `/session-plan`. Risk: low (Phase 3 has verified the new path).

**/risk-check change class:** YES (this is a cross-cutting protocol change across 5+ commands and 2+ shared log files; explicit shared-state coordination redesign). Run `/risk-check` before EACH phase, not as a one-shot.

#### Target files (by phase)

- Phase 1: `ai-resources/.claude/commands/prime.md` (Step 8a.3.a / 8b.1 — generate and persist `.session-marker`); new `ai-resources/.gitignore` line for `logs/.session-marker` (it's per-machine session state, not committed).
- Phase 2: `ai-resources/.claude/commands/session-start.md` (Step 3 — locate header by marker, not by date); `ai-resources/.claude/commands/session-plan.md` (Step 0 simplification — drop the 6-hour-window pass2 routing, write directly to `session-plan-{marker}.md`; Step 7 OUTPUT_TARGET changes).
- Phase 3: `ai-resources/.claude/commands/drift-check.md`, `ai-resources/.claude/commands/wrap-session.md`, `ai-resources/.claude/commands/contract-check.md`, `ai-resources/.claude/commands/qc-pass.md` (plan-reading branch), `ai-resources/skills/friday-checkup/SKILL.md` (any references to `session-plan.md`).
- Phase 4: cleanup of legacy fallback branches across Phase 2 commands.

#### Notes

- The friction-log 2026-05-28 10:05 entry is the live-event record; this is the proposal record. `/fix-repo-issues` will surface both.
- The narrow same-day `/session-start` Step 0.5 entry written earlier in this session is superseded — apply the supersede marker (`Status: logged — superseded by broader 2026-05-28 entry`) when this proposal is taken to plan.
- This is not a hotfix-able item; it requires a phased rollout. Suggested cadence: a dedicated `/friday-act` wave dedicated to Phase 1 (marker introduction) with `/risk-check` as advisory gate.

### 2026-05-28 — wrap-session foreign-guard misfires on prior-day uncommitted remnant

- **Status:** logged (pending)
- **Category:** session-issue
- **Source:** /resolve-repo-problem 2026-05-28
- **Friction source:** /wrap-session Step 3.5 foreign-session pre-write guard fired today (FOREIGN=1, mandate count 7 in WT vs 6 in HEAD). Working tree contains an orphan mandate from yesterday's W22 housekeeping session — that session ran /prime + /session-start but never invoked /wrap-session, leaving the mandate line unstaged. Today's guard treated the prior-day remnant as live foreign-session content and steered the operator toward the wrong remediation ("switch to the other terminal").
- **Proposal:** Patch Step 3.5 to parse the enclosing `## YYYY-MM-DD` header of each extra mandate and classify the delta as CONCURRENT (today-dated), REMNANT (prior-day), or MIXED. Branch the remediation text per class: CONCURRENT stays as-is; REMNANT offers a "commit the orphan as a standalone wrap-recovery commit" path; MIXED warns about both and asks the operator to pick. Update both `ai-resources/.claude/commands/wrap-session.md` Step 3.5 and the paired workspace-root copy. This is a /risk-check change class (cross-cutting workflow guard with shared-state semantics) — plan-time gate required.
- **Target files:** ai-resources/.claude/commands/wrap-session.md, ~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md (paired copy per existing PAIRED CONTRACT comment block)
- **Notes:** audits/working/2026-05-28-resolve-wrap-session-foreign-guard-prior-day-remnant.md

### 2026-05-28 — /prime does not surface per-unit `work/{Wn}-{NAME}-README.md` files

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** nordic-pe-screening-project W0 kick-off session 2026-05-28 — System Owner advisory (verdict accepted, see `projects/nordic-pe-screening-project/logs/decisions.md` row #3 and `logs/session-notes.md` 2026-05-28 wrap entry).
- **Friction source:** `/prime` reads `logs/session-notes.md` and carries forward its Next Steps verbatim, but does not scan `work/*.md` for phase-scoped README files that may overrule the general program rubric. In 2026-05-28's W0 kick-off, a 29-line `work/W0-SETUP-README.md` ("Layer 2 child cycle: No") was missed; `/prime` carried forward yesterday's "Open the W0 child cycle…" Next Step under the general "each phase opens a child cycle" rubric. Outcome: ~190k subagent tokens + ~3 h operator time spent producing a Layer 2 context pack that the README would have prevented at turn 1. AP-1 silent-conflict-resolution failure mode.
- **Proposal:** Add a step to `/prime` that scans the project's `work/` directory (if present) for `Wn-*-README.md` (or similar phase-README) files and surfaces their existence in the brief as an exception line. Surface only the presence (path + first-line title), not the content — read on demand at the start of the work unit, not at every `/prime`. Optional second proposal: have `/wrap-session` warn when a Next Steps line references a phase whose `work/Wn-README.md` exists, to catch silent-rubric-override at write time rather than next-session read time.
- **Target files:** ai-resources/.claude/commands/prime.md (primary); optionally ai-resources/.claude/commands/wrap-session.md (paired warning).

### 2026-05-28 — /pm forward-looking handling: re-evaluate after 3 paste cycles into /session-start

- **Status:** logged (pending)
- **Category:** command/skill
- **Source:** project-manager agent + /pm command landing 2026-05-28 — System Owner Function-B advisory flagged the design choice. Per `principles.md § DR-7` (generalize only on confirmed second-consumer evidence), v1 ships with forward-looking project-content handling (mandate generation, session-plan suggestions) inside `/pm`, with the operator manually pasting the verdict into `/session-start` or `/session-plan`. The architecturally cleaner answer — having `/session-start` and `/session-plan` natively read constitution docs — was deferred for lack of second-consumer evidence.
- **Trigger:** after the operator has used `/pm` for forward-looking questions (mandate or session-plan shapes) **three or more times** (counted by manual paste-into-`/session-start` cycles), re-evaluate whether forward-looking logic should move from PM into `/session-start` and `/session-plan` natively. Friday cadence review.
- **Proposal:** if the paste-step is recurring without complaint, status-quo is fine — close as `applied (no-op confirmed)`. If the paste-step is causing friction (forgotten paste, copy errors, divergence between PM verdict and final mandate), extract forward-looking logic into `/session-start` and `/session-plan` natively (they would invoke project-manager internally, or grow their own constitution-doc read).
- **Target files (when triggered):** `ai-resources/.claude/commands/session-start.md`, `ai-resources/.claude/commands/session-plan.md`, possibly `ai-resources/.claude/agents/project-manager.md` (Phase 3 forward-looking branch).

### 2026-05-28 — investigate sub-subagent dispatch (Task-from-agent) limitation

- **Status:** logged (pending)
- **Category:** command/skill / runtime-limitation
- **Source:** project-manager agent BLOCKING gate trace test (2026-05-28). The PM agent was designed to spawn `system-owner` via the `Task` tool for structure-general escalation. The trace test surfaced that the agent reports `Task` is not in its available toolset — despite the frontmatter declaring `tools: - Task`. Sub-subagent dispatch (agent → agent via Task) does not work in the current Claude Code runtime, regardless of frontmatter declaration. PM gracefully degrades to its DISPATCH FAILED fallback (per `principles.md § OP-3` loud failure rule), telling the operator to run `/consult` directly for structure questions.
- **Impact:** PM ships in degraded mode for structure escalation. Project-content advisory (retrospective + forward-looking — the primary use cases) works as designed. Structure-general questions emit a clear "run /consult directly" output instead of seamlessly folding in a system-owner consultation.
- **Investigation tasks:**
  1. Verify whether the tool name in agent frontmatter should be `Task` (current convention across system-owner.md, qc-reviewer.md, etc.) or `Agent` (the runtime-exposed tool name in main-session context). Check Claude Code documentation / release notes.
  2. If the convention is correct but Claude Code doesn't yet support sub-subagent dispatch, file a feature request upstream or accept the limitation as architectural (agents are leaf nodes; only commands and main session can spawn agents).
  3. If sub-subagent dispatch IS supported via a different mechanism (e.g., a wrapper, a different SDK call), update PM's Phase 4 to use the working pattern.
  4. Decide between three v1.1 design options: (a) seamless sub-subagent dispatch if supportable; (b) restructure PM to never attempt escalation (Phase 4 removed; structure questions always emit "/consult redirect"); (c) accept degraded mode as designed and update docs.
- **Proposal:** time-box the investigation to one Friday-act wave (~1 h). If sub-subagent dispatch can be made to work cleanly, ship the fix. If not, redesign PM Phase 4 to always emit the "/consult redirect" output deterministically (remove the conditional dispatch attempt; same operator-facing experience, simpler agent body).
- **Target files (when executed):** `ai-resources/.claude/agents/project-manager.md` (Phase 4); `ai-resources/.claude/commands/pm.md` (notes section if behavior changes); possibly `ai-resources/docs/agent-tier-table.md` notes column.
- **Triage cadence:** next Friday `/friday-act` wave.

### 2026-05-28 — /pm internal QC step: data-gated review after 3 invocations (pass-rate + verbatim-shape contract)

- **Status:** logged (pending)
- **Category:** command/skill / data-gated simplification
- **Source:** End-time `/risk-check` 2026-05-28 (PROCEED-WITH-CAUTION verdict). The `/pm` command Step 4 includes an internal QC pass via `qc-reviewer` with pass cap of 2. This was a **plan divergence** — the approved plan said no internal QC, mirroring `/consult`; the operator added the QC step mid-implementation because PM "will be solving quite important issues." The risk-checker promoted D1 Usage cost Low → Medium because each `/pm` invocation now lights up the High-tier `qc-reviewer` agent (per `risk-topology.md § 1`), with worst-case 4 Opus calls per invocation (PM → qc-reviewer → revised PM → qc-reviewer). System-owner end-time Function-B advisory concurred and asked that this v1.1 review entry name the verbatim-shape contract on `qc-reviewer` output (GO / REVISE / FLAG FOR EXTERNAL QC) explicitly so future audits catch drift if qc-reviewer's verdict tokens change.
- **Two coupled risks to track:**
  1. **QC pass-rate.** If the first-pass QC verdict is GO on >90% of invocations, the QC step is largely noise — the data points to removing it. If it surfaces real REVISE findings >30% of the time, it earns the cost. Operator should sample after first 3 invocations.
  2. **Verbatim-shape contract on qc-reviewer output.** `/pm` Step 5 parses `qc-reviewer`'s output for the tokens `GO`, `REVISE`, `FLAG FOR EXTERNAL QC` (exact strings). If `qc-reviewer.md` ever changes those token names or output structure, `/pm` Step 5 silently misclassifies the verdict. This is an implicit two-end contract — name it explicitly in this entry per `risk-topology.md § 1 — qc-reviewer agent` (High tier, every-pm-call dependency). Mitigation option for v1.1: extract the verdict-token list into a sibling reference doc both `qc-reviewer.md` and `/pm` Step 5 read, OR add a defensive shape check in `/pm` Step 5 that falls back to "GO" if the verdict token is unrecognized (loud-failure variant per `principles.md § OP-3`).
- **Trigger:** after the operator has used `/pm` three or more times, review the first-pass qc-reviewer pass-rate. Friday cadence.
- **Decision matrix (when triggered):**
  - **Pass-rate ≥90% on first pass** → QC step is mostly noise; consider removing Step 4 and converging back to /consult precedent. Document the data and rationale in the closure.
  - **Pass-rate 60–90%** → QC step is earning some signal; keep it but consider relaxing pass cap (currently 2) to 1, OR adding a fast-path that skips QC for retrospective questions (which are more constrained than forward-looking).
  - **Pass-rate <60%** → QC step is essential; PM rulings are routinely degraded without it. Keep as-is. Investigate why PM's first-pass quality is low (may indicate constitution-doc grounding issues, not QC necessity).
- **Verbatim-shape contract check (always, regardless of pass-rate):** review whether `qc-reviewer.md` has changed its verdict tokens or output shape since 2026-05-28. If yes, update `/pm` Step 5 parser in lockstep.
- **Target files (when executed):** `ai-resources/.claude/commands/pm.md` (Step 4 / Step 5 — possibly remove QC step, relax pass cap, or update verdict parser); possibly `ai-resources/.claude/agents/qc-reviewer.md` (if verdict-token shape stabilizes via shared reference doc).
- **Triage cadence:** next Friday `/friday-act` wave, gated on ≥3 `/pm` invocations having occurred.

### 2026-05-28 — extract change-shape classifier to shared reference (eliminate two-end contract)

- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention / architectural deduplication
- **Source:** project-manager agent + /pm command landing 2026-05-28 — System Owner Function-B advisory (risk-check second opinion) named this as the architecturally correct v1.1+ state. The change-shape classifier list (Files / Commands / Agents / Models / Folder structure / Hooks / Workflows / Project boundaries / Permissions) is currently duplicated verbatim in `ai-resources/.claude/commands/consult.md` Step 2 and `ai-resources/.claude/agents/project-manager.md` Phase 3 (under `structure (change-shaped)`). The duplication is a **two-end contract per `risk-topology.md § 5`** — silent drift between the two copies causes routing inconsistency between `/consult` and `/pm`.
- **Mitigation in place at v1:** both files carry an explicit two-end-contract comment naming the sibling file. Comments decay per `principles.md § QS-7` — this is a stopgap, not the architectural fix.
- **Proposal:** extract the change-shape classifier to a shared reference doc that both commands `Read` at runtime. Candidate location: `ai-resources/docs/repo-architecture.md` § new "Change-shape classifier" subsection (it's a routing concept and lives naturally alongside repo-architecture's Q5 classifier reference). Both `consult.md` Step 2 and `project-manager.md` Phase 3 then become "read this section; apply the list" instead of carrying verbatim copies. Per `principles.md § DR-7` — generalize on confirmed second-consumer evidence (PM is the second consumer; the trigger is met).
- **Target files (when executed):** `ai-resources/docs/repo-architecture.md` (add classifier subsection); `ai-resources/.claude/commands/consult.md` (replace verbatim list with Read-and-apply reference); `ai-resources/.claude/agents/project-manager.md` (same).
- **Triage cadence:** next Friday `/friday-act` wave.

### 2026-05-28 — /session-plan Step 0 same-session short-circuit (4th-recurrence MISMATCH false-positive resolved)

- **Status:** applied 2026-05-28 — `ai-resources/.claude/commands/session-plan.md` Step 0 carries a new sub-step 0 (own-session marker check using `logs/.prime-mtime`) and a sub-step 6 override that forces MATCH (3-option keep/overwrite/pass2 prompt) regardless of intent comparison when `SAME_SESSION = true`. Fix-plan 2026-05-28-1121 item `[project-axcion-brand-book/id-02]`.
- **Verified:** 2026-05-28 — risk-check verdict GO (all 5 dimensions Low) at `audits/risk-checks/2026-05-28-session-plan-same-session-short-circuit.md`; QC verdict REVISE → applied finding-4 fix (stale-marker freshness window mirroring `/session-start` Step 0.5). Friction-log entry at `projects/axcion-brand-book/logs/friction-log.md` 2026-05-26 19:56 carries `[FADING-GATE] verified 2026-05-28` annotation.
- **Category:** session-orchestration / concurrent-session safety
- **Friction source:** Recurring MISMATCH false-positive in `/session-plan` Step 0 — Phase 3 lock following Phase 2 QC was classified as a "concurrent session collision" and auto-routed to `session-plan-pass2.md` without prompting, because the new intent string differed from the existing plan's intent. Logged 4× in brand-book project across 4 sequential same-day sessions (friction-log 2026-05-23, 2026-05-25, 2026-05-26 (twice), 2026-05-27). Original remediation proposal in brand-book usage-log 2026-05-26 named a heuristic ("detect wrap-format entry: `### Summary` + `### Next Steps` within today's `## ` block"); the executed fix uses the cleaner own-session marker (`logs/.prime-mtime`) introduced in May for `/session-start` Step 0.5.
- **Resolution path:** Two structural additions to `session-plan.md` Step 0:
  - **Sub-step 0** (new) — reads `logs/.prime-mtime` (mtime of `session-notes.md` at the moment `/prime` appended today's header — written by `/prime` Steps 8a.3.a / 8b.1 / 8c.3); compares to `session-plan.md`'s mtime. `PLAN_MTIME > PRIME_MTIME` → set `SAME_SESSION = true` (this session's `/prime` ran BEFORE the existing plan was written → must be this session's plan). Freshness window: marker older than today's start-of-day → treat as stale → `SAME_SESSION = false` (mirrors `/session-start` Step 0.5).
  - **Sub-step 6 override** — at the top of "Apply the result", check `SAME_SESSION`. If true, force MATCH regardless of sub-steps 1-5's intent comparison. The MATCH branch's 3-option prompt surfaces; operator chooses keep / overwrite / pass2 explicitly instead of getting silent-auto-pass2.
- **Coverage gaps documented:** Marker-missing case → falls through to existing intent comparison (no regression). Marker-stale case → same. Concurrent-foreign-write-after-this-session's-/prime case → would misclassify as same-session and surface the 3-option prompt instead of silent-auto-pass2 (operator still gets explicit choice; not a degradation). All three fall-through paths preserve the existing MISMATCH branch's foreign-session protection.

### 2026-05-28 — B-04 deferred companion: extract S-04 from execution-manifest-creator

- **Status:** logged (pending)
- **Category:** Cross-skill contract enforcement / half-extracted-state prevention
- **Source:** FX-B2 plan-time `/risk-check` System Owner Function-B advisory (2026-05-28) — `audits/risk-checks/2026-05-28-fx-b2-extract-swedish-finnish-norwegian-language-search.md § Architectural Commentary § Risk the Dimension Review Did Not Surface`. FX-B2 landed S-04 extraction on the `research-prompt-creator` skill (lines 143–166 → loader stanza; Self-Check line ~242 → Project-Config-driven), with per-language term content moved to `ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md` + per-project `reference/language-search-blocks.md`. After FX-B2, S-04 has three canonical surfaces — `research-prompt-creator/SKILL.md` (now generalized), `execution-manifest-creator/SKILL.md` (still hardcoded with Nordic countries in its routing table), and `docs/project-config-schema.md` field 5 (the `Languages:` declaration). There is no automated check that S-04 contracts agree across all three surfaces (W2.2 accountability automation does not yet exist per `system-doc.md § 2.3, § 4.5`).
- **Risk if left undone:** Drift-without-detection at system scale (`principles.md § OP-3, § OP-11`). The half-extracted state is invisible technical debt — a future audit will surface "execution-manifest-creator still hardcodes Sweden/Norway/Finland" as a "you missed this" finding (AP-11 territory).
- **Proposal:** Apply the same FX-B3/B4/B5/B6/B2 extraction pattern to `execution-manifest-creator/SKILL.md` — move country-routing values out of the canonical skill into a per-project fillable reference (likely paired with the same `Languages:` / `Country set:` Project Config fields that drive `research-prompt-creator`). Use FX-B2's 3-case absent-file contract as precedent.
- **Sibling consideration (flagged by FX-B2 QC out-of-scope observation):** `research-prompt-creator/SKILL.md § S-03 (Country-Parity Enforcement Gate)` — at the time of the FX-B2 commit, line 142 still hardcodes `Sweden block → Norway block → Finland block → pan-Nordic synthesis last` and lists SVCA / Bolagsverket / NVCA / Brønnøysund / FVCA / PRH as example sources. This is S-03 (country routing), not S-04 (language blocks), so FX-B2 left it untouched — but it is the same "Nordic project content baked into a canonical skill" pattern. When B-04 is scheduled, evaluate whether the S-03 country-routing chunk in `research-prompt-creator` itself should be extracted in the same wave (likely as a `reference/country-routing.md` per-project file paired with the existing `Country set:` Project Config field). Defer-or-bundle decision belongs to the Friday-cadence triage.
- **Trigger (whichever fires first):**
  - The next research project declares `Languages:` with a non-Nordic set OR `Country set:` outside `[SE, NO, FI, DK]` (the current canonical-skill-hardcoded set).
  - Next Friday `/friday-checkup` cadence.
  - Operator explicitly raises it.
- **Target files (when executed):** `ai-resources/skills/execution-manifest-creator/SKILL.md` (loader stanza replacing hardcoded country routing); new `ai-resources/workflows/research-workflow/reference/{routing-or-country-set}.template.md` (canonical fillable); project-side instance file(s) for nordic-pe + buy-side + any future research projects.
- **Triage cadence:** next Friday `/friday-act` wave; treated as the Phase 2 follow-on companion to FX-B2.

### 2026-05-28 — placement-verifier four-pipeline extension (deferred Stage B scope)

- **Status:** logged (pending)
- **Category:** Placement-discipline / canonical-pipeline coverage
- **Source:** `/route-change` → `/placement` rename + verifier session (2026-05-28). SO advisory item #1 (post-write placement verifier) shipped lean — `docs/placement-verifier.md` procedure + integration into `/graduate-resource` only. Four other canonical creation pipelines (`/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`) were deliberately left untouched per SO `Architectural Commentary § M1` and `principles.md § DR-7` (generalize on confirmed second-consumer evidence, not by analogy).
- **Risk if left undone:** placement misses inside the four un-integrated pipelines remain silent — same leak the verifier exists to close. Acceptable at v1 because `/graduate-resource` is the highest-leverage placement decision; other pipelines have stronger structural defaults (skill scaffolds always land in `skills/<name>/`; project scaffolds always land in `projects/<name>/`).
- **Proposal:** Extend the placement-verifier integration into a second pipeline when ANY of these fire: (a) an observed placement miss inside `/create-skill`, `/improve-skill`, `/migrate-skill`, or `/new-project` surfaces in `friction-log.md` (the canonical signal for placement misses per workspace CLAUDE.md § Placement Discipline); (b) the `/graduate-resource` verifier integration generates ≥2 MISMATCH events in a Friday-checkup window (indicates the pattern is load-bearing); (c) operator dispositions this in a Friday-act wave on judgment alone. When triggered, integrate one pipeline at a time — DR-7 / AP-7 still bites if all four are added pre-emptively.
- **Target files (when executed):** `ai-resources/.claude/commands/{create-skill | improve-skill | migrate-skill | new-project}.md` (one at a time) — add Step Xa (plan-time gate) and Step Yb (end-time gate) mirroring `/graduate-resource` Steps 3a and 5a. No changes to `docs/placement-verifier.md` itself (already designed to support any pipeline).
- **Triage cadence:** opportunistic — gated on the three triggers above, not on a fixed cadence.

### 2026-05-28 — Extract Q1–Q8 placement logic into shared SKILL.md (SO advisory item #2)

- **Status:** logged (pending)
- **Category:** Placement-discipline / DR-7 shared-judgment surface
- **Source:** SO advisory delivered as part of the `/route-change` → `/placement` rename session (2026-05-28). Original advisory recommended a shared SKILL.md that both `/placement` and the verifier consume; operator chose to ship only item #1 first.
- **Proposal:** Extract the Q1–Q8 placement heuristics currently embedded in `docs/repo-architecture.md § Placement heuristics` into a shared `skills/placement-classification/SKILL.md`. Both `/placement` and `docs/placement-verifier.md` then `Read` the SKILL.md instead of carrying their own classification logic. DR-7 trigger: `/placement` (consumer 1), `placement-verifier.md` (consumer 2) — second consumer is confirmed and the bar is met.
- **Risk if left undone:** classification logic remains split between `/placement`'s Step 3 (Q1–Q8 walk) and `placement-verifier.md`'s canonical-home lookup. Drift between the two is currently unguarded — a future edit to one could leave the other behind.
- **Target files (when executed):** new `ai-resources/skills/placement-classification/SKILL.md`; `ai-resources/.claude/commands/placement.md` Step 3 (Read-and-apply the SKILL.md); `ai-resources/docs/placement-verifier.md` Method (Read-and-apply the SKILL.md); `ai-resources/docs/repo-architecture.md § Placement heuristics` (becomes a pointer to the SKILL.md rather than the source of truth).
- **Triage cadence:** next Friday `/friday-act` wave that also touches `/placement` or `placement-verifier.md`, OR when item #1's four-pipeline extension fires (above) — that extension's second integration is the natural moment to extract the shared skill.

### 2026-05-28 — Architecture-gap report loop (SO advisory item #3)

- **Status:** logged (pending)
- **Category:** Placement-discipline / feedback-loop closure
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). `/placement` Step 14 surfaces architecture gaps (cases where `docs/repo-architecture.md` does not cover a proposed change) as a recommendation field in chat. Currently those gap reports live and die in chat — no aggregation, no Friday-act consumption.
- **Proposal:** When `/placement` populates the `**Architecture gap:**` field, also append a structured entry to `ai-resources/logs/maintenance-observations.md` under a new "Architecture gaps surfaced" subsection within the current week's session block. Friday-act consumes the section, decides whether `docs/repo-architecture.md` needs amendment, and dispositions accordingly.
- **Risk if left undone:** placement recommendations degrade silently as the architecture map staleness accumulates. The feedback loop named in workspace CLAUDE.md § Placement Discipline (friction-log as the upgrade signal) only catches *misses*, not *gaps*.
- **Target files (when executed):** `ai-resources/.claude/commands/placement.md` Step 14 (add maintenance-observations append after chat output); `ai-resources/logs/maintenance-observations.md` schema (document the new subsection); `ai-resources/.claude/commands/friday-act.md` (add the new subsection to its consumption sweep).
- **Triage cadence:** next monthly `/friday-act` wave (low priority — slow signal, low blast radius).

### 2026-05-28 — Track /placement skip-rate in gate-calibration (SO advisory item #4)

- **Status:** logged (pending)
- **Category:** Placement-discipline / fading-gate observability
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). The `gate-calibration.md` system (shipped 2026-05-18) tracks high-confirmation gates and surfaces `[FADING-GATE]` candidates in monthly `/friday-checkup`. `/placement` is exactly the kind of gate that's easy to "remember" early and skip when work is flowing — its skip-rate should be observable.
- **Proposal:** Add `/placement` to the gate-calibration tracking surface. Each session start, the gate-calibration mechanism increments either an "invoked" or "skipped" counter for `/placement`. The skip detection: when a file is created in a new top-level directory or new artifact category (the triggers listed in workspace CLAUDE.md § Placement Discipline) AND `/placement` was not invoked during the session, mark a skip. Monthly checkup surfaces a fading-gate candidate when skips exceed invocations for two consecutive months.
- **Risk if left undone:** placement-discipline drift is invisible until an audit catches a misplaced file. Today the operator has no way to see whether `/placement` is actually being used or being silently skipped.
- **Target files (when executed):** `ai-resources/docs/gate-calibration.md` (add `/placement` to tracked gates); a new SessionStart or Stop hook to detect file-creation events satisfying the trigger conditions; `ai-resources/.claude/commands/friday-checkup.md` Step 6 (consume the new tracking signal).
- **Triage cadence:** quarterly `/friday-act` wave — depends on the gate-calibration system maturing; low priority.

### 2026-05-28 — Tighten Placement Discipline trigger to constraint-on-Write checklist (SO advisory item #5)

- **Status:** logged (pending)
- **Category:** CLAUDE.md polish / always-loaded surface tightening
- **Source:** SO advisory (`/route-change` → `/placement` rename session, 2026-05-28). The current workspace CLAUDE.md § Placement Discipline trigger list (lines 39–42) reads as four prose bullets describing when to run `/placement`. SO suggested converting to a stricter "before any `Write` whose target path is not already in scratch context this session, ask: …" — makes the gate harder to skip rhetorically by reframing it as a constraint on Write actions rather than a procedure to remember.
- **Proposal:** Rewrite workspace CLAUDE.md § Placement Discipline trigger list as a constraint-on-Write checklist. Keep the "skip when" bullet list intact. Net token delta probably <0 (constraint phrasing is usually tighter than procedural).
- **Risk if left undone:** low — cosmetic vs. structural. Current prose is functional and operator already invokes `/placement` consistently. SO classified this as item #5 (lowest in the ranked list) for that reason.
- **Target files (when executed):** `~/Claude Code/Axcion AI Repo/CLAUDE.md` § Placement Discipline only.
- **Triage cadence:** opportunistic — bundle with the next workspace CLAUDE.md edit pass; do not schedule standalone.
