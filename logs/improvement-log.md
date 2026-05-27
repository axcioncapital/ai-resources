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

- **Status:** logged (pending)
- **Category:** session-issue
- **Source:** `/resolve-repo-problem 2026-05-27`
- **Friction source:** Expected: this session's `/prime`-appended task header + `/session-start`-written mandate to remain in `logs/session-notes.md` through wrap. Actual: a concurrent `/contract-check` session's `/wrap-session` ran `git add logs/session-notes.md` (which stages the entire working-tree content, not just its own additions), shipping my uncommitted mandate lines under commit `14d2a04` — the contract-check session's wrap commit. My session subsequently saw no `session-notes.md` modifications and committed its work without a wrap entry. Plan 2's mtime guard (`/session-start` Step 0.5, shipped 2026-05-26) only covers the `/prime` → `/session-start` upstream window; the failure here is post-`/session-start`, in the concurrent-wrap window — Plan 2's symmetric blind spot.
- **Proposal:** Add a wrap-time pre-commit guard to `wrap-session.md` (the canonical `ai-resources/.claude/commands/wrap-session.md` plus the workspace-root Phase 3 copy). Before staging `logs/session-notes.md`, compare on-disk content to the session's own writes: detect any `## YYYY-MM-DD` headers or `**Mandate:**` lines authored by another session and stop with a chat prompt asking the operator to resolve (commit only own work, or commit the union). Symmetric counterpart to Plan 2 — closes the post-`/session-start` window the same way Plan 2 closed the pre-`/session-start` window. **/risk-check change class:** YES (canonical-command edit) — run `/risk-check` before landing.
- **Target files:** `ai-resources/.claude/commands/wrap-session.md`, `~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (Phase 3 wrap copy)
- **Notes:** `ai-resources/audits/working/2026-05-27-resolve-concurrent-session-overwrite-session-notes.md`
