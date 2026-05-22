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

- **Status:** applied 2026-04-18 (Prevention Session 2)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R1 (both audits) and R4 (buy-side). Every new project ships without `Read(...)` denies and without a Sonnet default. The audit catches these findings on every project; preventing them at project-creation time would eliminate the recurrence.
- **Proposal:**
  - Update `/new-project` pipeline's post-enrichment stage to write `.claude/settings.json` with a sensible `permissions.deny` block. Minimum: `Read(archive/**)`. Research-workflow-derived projects should also get `Read(output/**)`, `Read(parts/**/drafts/**)`, `Read(usage/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.
  - Update the same stage to write `.claude/settings.local.json` with `{"model": "sonnet"}` as default.
  - Update the research-workflow template's `.claude/settings.json` at `ai-resources/workflows/research-workflow/.claude/settings.json` so `/deploy-workflow` propagates the canonical state.
  - Apply the "Applying Audit Recommendations" rule (workspace CLAUDE.md) when finalizing the deny list — list the top-3 commands each path affects and confirm no regression before committing the template.
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` (pipeline orchestrator)
  - `ai-resources/workflows/research-workflow/.claude/settings.json` (template)
  - Any pipeline-stage-N agent that writes project `.claude/settings.json`

### Sequencing note (five entries combined)

Suggested three-session sequence:

- **Session 1 (rules, ~45 min):** Entry "Extend Model Tier rule to agents" + Entry "Codify subagent-summary cap + /usage-analysis discipline". Purely CLAUDE.md + one `/wrap-session` edit. Lowest risk, highest per-turn leverage.
- **Session 2 (templates, ~1–2 hrs):** Existing entries — canonical project settings template + canonical project CLAUDE.md template. Touches `/new-project` pipeline + research-workflow templates. Before implementing, re-read the 2026-04-13 decision ("Commit Rules propagate by explicit copy") to confirm whether the inheritance workaround is still needed.
- **Session 3 (detection + automation, ~45 min):** Entry "Add three questionnaire items to /repo-dd" + Entry "Pre-commit skill-size warning hook". Depends on Session 1 (Agent Tier Table) and Session 2 (canonical templates) landing first so the new questionnaire items have stable references.

### 2026-04-25 — Make /wrap-session leaner

- **Status:** logged (pending)
- **Review-cycle:** reviewed 2026-05-18, deferred — structural command edit needs dedicated /improve session scoped to wrap-session.md; sub-5 already obsolete; sub-1 through sub-4 still valid but touch command flow ordering
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

- **Status:** logged (pending)
- **Review-cycle:** reviewed 2026-05-18, deferred — agent-definition edit requires /risk-check per Autonomy Rule #9; needs dedicated risk-gate session; no active false-positive harm beyond noise in friday-checkup reports
- **Category:** Audit-recurrence prevention
- **Source:** `/permission-sweep` run 2026-04-27 / 2026-04-28 (report at `ai-resources/audits/permission-sweep-2026-04-27.md`). Auditor flagged `ai-resources/workflows/research-workflow/.claude/settings.json` line 35 (`"additionalDirectories": ["{{WORKSPACE_ROOT}}"]`) as a HIGH Rule 8 violation ("stale `additionalDirectories`") because the value is an unfilled placeholder. The placeholder is intentional — the most recent commit on that file (`81cb6c2 update: research-workflow template — additionalDirectories placeholder + SETUP step`) explicitly added it as a deploy-time fill-in consumed by `/deploy-workflow` / `/new-project`. Replacing it with a resolved path would corrupt new deployments. Auditor cannot currently distinguish template source from deployed instance.
- **Friction observation:** Held finding will re-fire on every future `/permission-sweep` run (including weekly `/friday-checkup --dry-run`) until the auditor learns to skip it. Each re-fire wastes operator attention on a non-issue and risks accidental "fix" by a future agent.
- **Proposal:**
  - Update `ai-resources/.claude/agents/permission-sweep-auditor.md` to add a template-class classification step before applying Rule 8. Heuristic: any file whose path matches `**/workflows/*/.claude/settings.json` (template source under the workflow library) is template-class; for template-class files, skip Rule 8 entirely or accept `{{...}}` placeholder values as PASS rather than HIGH. Optionally also detect `{{...}}` Mustache placeholders in any allow/deny entry as a secondary template-class signal.
  - Apply via `/risk-check` per Autonomy Rules pause-trigger #9 (agent-definition edit is a harness-level structural change). Confirm no regression on the 2 currently-scanned files before landing.
- **Target files:**
  - `ai-resources/.claude/agents/permission-sweep-auditor.md`

### 2026-04-28 — Bulk backfill of model: and effort: to all 69 skills

- **Status:** completed
- **Category:** bulk-backfill-exception (per `docs/ai-resource-creation.md` § Bulk-backfill Exception)
- **Files modified:** 69 — all `skills/*/SKILL.md`
- **Fields added:** `model:` and `effort:` (2-line insert per file, after `description:` in frontmatter; body untouched)
- **Tier mapping source:** `audits/working/skills-tier-inventory-2026-04-28.md` (69 skills: 38 opus/high, 30 sonnet/medium, 1 haiku/low)
- **Bulk QC verification (substitutes for 69 per-file passes):**
  - `grep -rL "^model:"  skills/*/SKILL.md` → 0 results
  - `grep -rL "^effort:" skills/*/SKILL.md` → 0 results
  - `grep -rh "^model:"  skills/*/SKILL.md | grep -vE ":(opus|sonnet|haiku)$"` → 0 lines
  - `grep -rh "^effort:" skills/*/SKILL.md | grep -vE ":(low|medium|high)$"` → 0 lines
- **Commits:** `a533595` (Phase A pipeline foundation), `a4f32e8` (Phase C bulk sweep)
- **Exception justification:** 69 per-file pipeline runs would produce identical fix passes with no QC signal. One-time mechanical frontmatter insert only; no body changes. Documented in `docs/ai-resource-creation.md` before execution.

### 2026-05-22 — Friction logging produced an unusable stub entry ("note this")

- **Status:** logged (pending)
- **Category:** process
- **Friction source:** friction-log.md session 2026-05-18 10:00 — the only friction event is the literal text `note this.` (logged via `/note friction:` or `/friction-log`)
- **Proposal:** Add a post-capture stub-detection step to `.claude/commands/note.md` Step A (friction routing) and `.claude/commands/friction-log.md` Step 3. After appending the entry, if the logged text is under ~15 characters or matches a placeholder pattern (`^(note this|todo|tbd|fixme|xxx|\.\.\.)\.?$` case-insensitive), append a bracketed reminder on the same line — `[STUB — expand before next /improve]` — and print one chat line: `Logged as a stub. Add detail with another /note friction: ... when you have a moment.` Keeps capture frictionless (still logs immediately, no blocking question) but flags the entry so the operator and the next `/improve` run both see it is incomplete. Effort trivial; impact medium; first occurrence. Batch with the next entry — both touch `note.md`.
- **Target files:** `ai-resources/.claude/commands/note.md`, `ai-resources/.claude/commands/friction-log.md`

### 2026-05-22 — /note friction: and /friction-log write incompatible session-header formats

- **Status:** logged (pending)
- **Category:** command
- **Friction source:** structural pattern — cross-referencing `note.md`, `friction-log.md`, and `friction-log-auto.sh` against the actual `friction-log.md` file
- **Proposal:** `friction-log.md` and `friction-log-auto.sh` write `## Session — {date}` + `### Friction Events` + `#### Write Activity`; `note.md` Step A writes `### Session: {date} — Manual entry` + `#### Friction Events` (colon, heading-level shift, wrong hash count). Consequence: `/note friction:` never detects an auto-created session block (auto writes `### Friction Events`, note.md looks for `#### Friction Events`), always appends a second differently-formatted block; and `log-write-activity.sh` keys on `#### Write Activity`, which `note.md` never writes — so `/note`-initiated sessions capture no write activity. Fix: make `note.md` Step A emit the exact same block as the other two writers (`## Session — {YYYY-MM-DD HH:MM}` / `### Friction Events` / `#### Write Activity`); change Step A step 2 to detect `### Friction Events` (three hashes), step 3 to append before `#### Write Activity`. Effort trivial; impact medium; first occurrence. Pairs with the entry above.
- **Target files:** `ai-resources/.claude/commands/note.md`

### 2026-05-22 — No mechanism ties a friction entry to the session/command that produced it

- **Status:** logged (pending)
- **Category:** process
- **Friction source:** friction-log.md session 2026-05-18 10:00 — manual entry has no `**Trigger:**` line, unlike auto-created sessions which `friction-log-auto.sh` stamps with `**Trigger:** /skill-name`
- **Proposal:** Manually-started friction sessions (`/note friction:`, `/friction-log`) record no context for what command/workflow stage was running. Add lightweight context capture to `note.md` Step A and `friction-log.md` Step 3: before appending, run `git log -1 --pretty=%H` and grep for the most recent `## <today>` header in `logs/session-notes.md`; append a `(context: <last-commit-short-hash>, <session-note-title-if-any>)` suffix. If neither available, append `(context: none captured)`. One grep + one `git log -1` — cheap, stays non-blocking. Gives every future analysis a Location anchor even for one-line operator notes. Effort small; impact medium; first occurrence.
- **Target files:** `ai-resources/.claude/commands/note.md`, `ai-resources/.claude/commands/friction-log.md`

### 2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst — document the boundary before building

- **Status:** logged (pending)
- **Category:** process
- **Friction source:** resource brief `inbox/workflow-diagnosis.md` (requested 2026-05-19), Exclusions section — explicitly lists "Analyze session-level friction or process issues (that's `improvement-analyst` agent)" as a non-goal
- **Proposal:** The boundary between the planned `workflow-diagnosis` skill (artifact-defect-driven workflow fixes) and the `improvement-analyst` agent (session-friction-driven workflow fixes) currently lives only in the inbox brief's prose, which is archived to `inbox/archive/` once fulfilled. When `/create-skill` processes `inbox/workflow-diagnosis.md`, add a one-paragraph routing note to `ai-resources/docs/ai-resource-creation.md` (or a short `## Workflow-improvement surfaces` section) stating the split: `improvement-analyst` agent = session-friction-driven; `workflow-diagnosis` skill / `/diagnose-workflow` = artifact-defect-driven; with trigger phrasing for each. Documentation only, no new tooling. Sequence with the `/create-skill` run that fulfills the brief. Effort small; impact medium; first occurrence.
- **Target files:** `ai-resources/docs/ai-resource-creation.md`
