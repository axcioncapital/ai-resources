# Fix plan — Wave 1 (Hygiene) — 2026-05-28 19:02

**Source command:** `/fix-repo-issues`
**Wave:** 1 of 3 — log/config hygiene + new log entries (Groups A + E)
**Scopes scanned:** ai-resources, project ai-development-lab, project axcion-ai-system-owner, project nordic-pe-macro-landscape-H1-2026, project nordic-pe-screening-project
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-05-28-1902-ai-resources.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1902-ai-resources.md)
- project ai-development-lab: [audits/working/fix-repo-issues-2026-05-28-1902-project-ai-development-lab.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1902-project-ai-development-lab.md)
- project axcion-ai-system-owner: [audits/working/fix-repo-issues-2026-05-28-1902-project-axcion-ai-system-owner.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1902-project-axcion-ai-system-owner.md) (0 items)
- project nordic-pe-macro-landscape-H1-2026: [audits/working/fix-repo-issues-2026-05-28-1902-project-nordic-pe-macro-landscape-H1-2026.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1902-project-nordic-pe-macro-landscape-H1-2026.md)
- project nordic-pe-screening-project: [audits/working/fix-repo-issues-2026-05-28-1902-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-05-28-1902-project-nordic-pe-screening-project.md)
**Plans directory:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/`
**Items:** 9
**Estimated effort:** 30–45 min. No `/risk-check` items. Clean wins, low blast radius.

## Sibling waves

- **Wave 2 (Commands/hooks):** [fix-repo-issues-2026-05-28-1902-wave2-commands.md](fix-repo-issues-2026-05-28-1902-wave2-commands.md) — 8 single-file `/prime` + hook + doc edits.
- **Wave 3 (Structural):** [fix-repo-issues-2026-05-28-1902-wave3-structural.md](fix-repo-issues-2026-05-28-1902-wave3-structural.md) — 4 `/risk-check`-gated TOCTOU patches.

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave1-hygiene.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [project-ai-development-lab/id-02] Mark pipeline/ WRITE PERMISSION BLOCK as Resolved in friction-log
- **Scope:** project ai-development-lab — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/friction-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/ai-development-lab/logs/friction-log.md):8
- **Fix:** The pipeline/ WRITE PERMISSION BLOCK friction event was fixed 2026-05-21 (deny rule removed; cross-ref `projects/ai-development-lab/logs/decisions.md` 2026-05-21 entry). The friction-log entry has no `Resolved:` field. Add a `**Resolved:** 2026-05-21 — deny rule removed (see logs/decisions.md 2026-05-21)` line beneath the entry.
- **Post-fix log update:** none (the fix IS the log update).
- **QC needed:** no — log-hygiene-only edit.

### [project-ai-development-lab/id-04] Fix 4-vs-5-vs-6 count-drift in ref-implementation-starter.md Synthesis rules
- **Scope:** project ai-development-lab — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/session-notes.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/ai-development-lab/logs/session-notes.md):361 (notes the bug at line 60 of the template file)
- **Fix:** Read `ref-implementation-starter.md` (find via Glob from the project root or follow the path in the session-notes entry). The Synthesis rules section near line 60 contains inconsistent counts (4 vs 5 vs 6). Determine the correct number by reading the surrounding rules and aligning all three references; edit the line so all counts match.
- **Post-fix log update:** none required. Optionally annotate the source session-notes line with "Resolved: applied YYYY-MM-DD via wave-1 hygiene plan."
- **QC needed:** yes — `/qc-pass` after edit because the fix involves judgment on which count is correct.

### [project-nordic-pe-macro-landscape-H1-2026/id-07] Remove redundant `Bash(rm *)` entry from project settings.json
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):102
- **Fix:** Open `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`. The `permissions.allow` array has both `"Bash(*)"` and `"Bash(rm *)"`. Remove the `"Bash(rm *)"` line; keep `"Bash(*)"` and the `"Bash(rm -rf *)"` entry in `deny`. Verify the file is still valid JSON after edit.
- **Post-fix log update:** flip improvement-log.md:102 entry status to `**Status:** applied 2026-05-28` + add `**Verified:** 2026-05-28 — confirmed by operator or by reading the post-edit settings.json` line. Schema per `ai-resources/.claude/commands/resolve-improvement-log.md`.
- **QC needed:** no — log-hygiene + redundant-line removal.

### [ai-resources/id-13–id-19 — bundle of 7] Flip stale `triaged:graduate` status on 7 innovation-registry rows
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/innovation-registry.md) lines 99, 100, 101, 102, 103, 104, 105 (7 rows)
- **Fix:** Read the 7 rows. For each row:
  1. Check the `Graduated To` field. If populated with a real target path → change status from `triaged:graduate` to `graduated`. Verify the target file exists.
  2. If `Graduated To` is empty after 12 days → change status to `triaged:graduate-stale` (new status value indicating triaged but not landed). Add an inline note `12d stale at 2026-05-28 fix-plan wave-1`.
  3. If a row's graduation actually happened but `Graduated To` was never populated → populate it from the relevant commit history (check `git log --grep="graduate"`).
  Per-row decisions belong to the executor — bundle is structural, not blind.
- **Post-fix log update:** none separately; the edit IS the log update.
- **QC needed:** no — log status flips with explicit per-row criteria.

### [ai-resources/id-08] Add cross-ref line to Concurrent TOCTOU race friction-log entry
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/friction-log.md):77 (2026-05-28 10:05 entry)
- **Fix:** Append one line to the entry: `**Cross-ref:** logs/improvement-log.md — "2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files" (phased marker approach, structural fix proposal). Targeted in wave 3 of fix-plan 2026-05-28-1902.`
- **Post-fix log update:** none separately.
- **QC needed:** no — single-line cross-ref.

### [project-nordic-pe-macro-landscape-H1-2026/id-09] Append 2026-05-27 update annotation to prior improvement-log entry
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):118 (the "/prime Step 8b 'skipped chaining' claim — non-determinism vs deterministic failure" entry already exists; the prior entry to annotate is at line 109 — "/prime Step 8b free-text-intent path skipped /session-start and /session-plan chaining")
- **Fix:** This item is partially done — the annotation entry already exists at line 118. Confirm: read both entries (line 109 and line 118). The line-118 entry IS the annotation to the line-109 entry. Verify line 118 contains the chained-correctly evidence (mtimes + line numbers) and references `audits/working/2026-05-27-resolve-prime-step-8b-chaining-claim-vs-evidence.md`. If the annotation is missing the explicit `- **2026-05-27 update:**` bullet inside the line-109 entry's body, add it there citing line 118 as the supersession/non-determinism record. Otherwise, mark the line-118 entry as `**Status:** applied 2026-05-28` + `**Verified:** 2026-05-28 — annotation confirmed in place`.
- **Post-fix log update:** flip line-118 entry status to `applied` + `Verified:`.
- **QC needed:** no — annotation cross-link verification.

### [ai-resources/id-20] Codify bright-line review-principle in ai-resource-builder review-principles.md
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/coaching-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/coaching-log.md) (One Thing carried 3 cycles)
- **Fix:** Open `ai-resources/skills/ai-resource-builder/references/review-principles.md` (or the canonical review-principles surface — verify by reading `ai-resources/skills/ai-resource-builder/SKILL.md` to confirm the references directory layout). Add a new bullet/section: "**Name the bright-line before reviewing it.** When reviewing a draft or artifact, first state the explicit pass/fail criterion in one sentence ('A passing version of this artifact does X / does NOT do Y'). Review against the stated bright-line. Without a named bright-line, reviews drift into subjective preference. (Coaching One Thing 2026-05-{date}; carried 3 cycles before codification.)"
- **Post-fix log update:** annotate `logs/coaching-log.md` to mark the One Thing actioned: append a `→ Codified 2026-05-28 in skills/ai-resource-builder/references/review-principles.md (fix-plan wave-1)` line beneath the original One Thing entry.
- **QC needed:** yes — `/qc-pass` on the new review-principle wording (judgment call on phrasing).

### [ai-resources/id-21] Add bright-line-review row to gate-calibration.md
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/gate-calibration.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/gate-calibration.md) (Note: durable enforcement flagged for separate gate)
- **Fix:** Read `logs/gate-calibration.md` to find the existing row format. Add a new row for `bright-line-review` gate following the same schema. Skip-detection criterion: "review-class work produced without an explicit bright-line statement in the same turn." Cross-link to id-20 fix.
- **Post-fix log update:** none separately.
- **QC needed:** no — gate-calibration row addition follows the established schema.

### [project-nordic-pe-macro-landscape-H1-2026/id-04] Log mandate-alignment open question as new ai-resources improvement-log entry
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (the question is about a canonical `/session-start` behavior, so it logs to ai-resources, not the nordic-pe project)
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md):613
- **Fix:** Append a new entry to `ai-resources/logs/improvement-log.md` (most recent end of file):
  ```
  ### 2026-05-28 — Mandate-alignment recovery: should `/session-start` be re-invoked when a session pivots immediately after `/prime`?

  - **Status:** logged (pending)
  - **Category:** session-issue / command-design
  - **Source:** nordic-pe-macro-landscape-H1-2026 session 2026-05-28 — session opened with mandate "FX-B1+B2 implementation"; pivoted immediately to drafting `templating-plan-v2-resolution-plan.md` per operator direction. Recorded mandate diverged from actual work for the session's full duration.
  - **Friction source:** Decision-point-posture pivots (operator-driven, non-drift) currently leave the recorded mandate stale. `/wrap-session` then journals work against a mandate that does not describe what happened. Downstream `/drift-check` and `/contract-check` would mis-classify the pivot as drift.
  - **Proposal:** Consider adding a `/session-start --re-mandate` re-invocation path that the operator can fire mid-session when a pivot happens. Alternatively, document a "Pivot Acknowledged" annotation pattern in the session-notes body so `/wrap-session` can detect and journal the pivot explicitly.
  - **Target files (when executed):** `ai-resources/.claude/commands/session-start.md` (optional re-mandate flag), `ai-resources/.claude/commands/wrap-session.md` (pivot-detection in Step 7a).
  - **Triage cadence:** `/improve` consideration; not urgent.
  ```
- **Post-fix log update:** the new entry IS the log update.
- **QC needed:** no — improvement-log entry append.

## Parked items (not this wave — see waves 2/3 or other commands)

- All build-shaped briefs (ai-resources/id-01, 02, 07, 10) — needs-/create-skill
- All innovation-registry pending-triage (ai-resources/id-03, 04, 05, 06) — needs-/innovation-sweep
- All `/risk-check` change-class items — wave 3
- All `/prime` / hook / doc edits — wave 2
- Multi-file refactors (ai-resources/id-35, 36, 37) and id-34 research — deferred

## Skipped items

- [ai-resources/id-30] — superseded by id-31 per scanner note. Reason: already-handled-elsewhere.
