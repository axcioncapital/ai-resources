# Fix plan — Wave 2 (Commands/Hooks) — 2026-05-28 19:02

**Source command:** `/fix-repo-issues`
**Wave:** 2 of 3 — single-file `/prime` + hook + documentation edits (Groups B + C + D)
**Scopes scanned:** ai-resources, project ai-development-lab, project axcion-ai-system-owner, project nordic-pe-macro-landscape-H1-2026, project nordic-pe-screening-project
**Scanner notes (per scope):** see [Wave 1 plan file](fix-repo-issues-2026-05-28-1902-wave1-hygiene.md) for the per-scope working-notes links.
**Plans directory:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/`
**Items:** 8
**Estimated effort:** 60–90 min. No `/risk-check` items per the source improvement-log entries. Each item is single-file or bounded multi-file (project command + canonical pointer at most).

## Sibling waves

- **Wave 1 (Hygiene):** [fix-repo-issues-2026-05-28-1902-wave1-hygiene.md](fix-repo-issues-2026-05-28-1902-wave1-hygiene.md) — 9 log/config hygiene fixes + new log entries.
- **Wave 3 (Structural):** [fix-repo-issues-2026-05-28-1902-wave3-structural.md](fix-repo-issues-2026-05-28-1902-wave3-structural.md) — 4 `/risk-check`-gated TOCTOU patches.

## Sequencing notes

- Items 1 (Step 8b rewrite) and 2 (Step 1a dual-repo) both edit `ai-resources/.claude/commands/prime.md`. Apply them as ONE coordinated edit pass to avoid two consecutive commits on the same file.
- Item 3 (`work/` README scan) also edits `prime.md` — bundle with items 1+2 into a single `/prime` edit session if time allows.

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in.

Instruct fresh-session Claude:

> Execute the fix plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave2-commands.md`.

Each item below is self-contained. Commit per logical batch (the 3 `/prime` edits make one natural batch; everything else is per-item). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [project-nordic-pe-macro-landscape-H1-2026/id-08] Rewrite `/prime` Step 8b to mirror Step 8a's lettered sub-step structure
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (canonical command lives in ai-resources; nordic-pe project surfaces the friction)
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):109
- **Fix:** Read `ai-resources/.claude/commands/prime.md` lines 166–179 (the current Step 8b free-text-intent path). Rewrite Step 8b to mirror Step 8a's lettered sub-step structure:
  - a. Append today's session-notes header + work-description line; write `.prime-mtime` marker (same logic as Step 8a.3.a).
  - b. Invoke `/session-start` with the work description as mandate.
  - c. After `/session-start` finishes, invoke `/session-plan` with the work description as intent.
  - d. After `/session-plan` finishes, begin execution immediately under full autonomy (no go/proceed gate — this is 8b's delta vs 8a's pause).
  Remove the free-floating `**Next:**` footer that currently coexists with the "Begin execution immediately" directive — that tension is the cause of non-deterministic chaining.
- **Post-fix log update:** flip improvement-log.md:109 (nordic-pe-macro) entry status to `**Status:** applied 2026-05-28` + `**Verified:** 2026-05-28 — Step 8b rewrite landed; lettered sub-steps a-d in place; free-floating Next: footer removed`.
- **QC needed:** yes — `/qc-pass` on the rewritten Step 8b (it's a canonical command body change, even though NOT `/risk-check` class per the source entry).

### [project-nordic-pe-macro-landscape-H1-2026/id-10] Extend `/prime` Step 1a git-log cross-check to traverse both repos
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):128
- **Fix:** Read `ai-resources/.claude/commands/prime.md` Step 1a (the git-log cross-check block, around line 43 of the file per the source entry). Replace the single `git -C "$CWD_REPO" log --since=...` invocation with a conditional pair: if `$CWD_REPO != $AI_RESOURCES`, also run the same command against `$AI_RESOURCES`. Merge results before the keyword-match pass. The `$AI_RESOURCES` variable is already established in Step 0 — reuse it. Add one comment line citing the dual-repo Cluster A blindspot that motivated the fix.
- **Post-fix log update:** flip improvement-log.md:128 (nordic-pe-macro) entry status to `**Status:** applied 2026-05-28` + `**Verified:** 2026-05-28 — Step 1a now traverses both repos; verified by reading the edited file`.
- **QC needed:** yes — `/qc-pass` on the Step 1a edit.

### [ai-resources/id-33] Add `work/{Wn}-README.md` scan to `/prime`
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md):258
- **Fix:** Add a new step (or extend an existing exception-check step) to `ai-resources/.claude/commands/prime.md` that scans the project's `work/` directory (if present) for files matching `Wn-*-README.md` (or `W*-*-README.md`). Surface their existence in the step-6 brief as an exception line: `⚠ Phase READMEs detected: {paths}; read before opening the relevant work unit.` Surface ONLY the file path + first-line title, not the content. Skip silently if `work/` is absent or contains no matching files.
- **Post-fix log update:** flip improvement-log.md:258 (ai-resources) entry status to `**Status:** applied 2026-05-28` + `**Verified:**` line.
- **QC needed:** yes — `/qc-pass` on the new `/prime` step (canonical command edit).

### [project-nordic-pe-macro-landscape-H1-2026/id-06] Broaden `backup-session-plan.sh` path-filter regex
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):95
- **Fix:** Open `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh`. On line 14, broaden the path-filter regex from `grep -qE '(^|/)logs/session-plan\.md$'` to `grep -qE '(^|/)logs/session-plan(-[a-zA-Z0-9]+)?\.md$'`. Update the `SRC`/`BACKUP` logic so it backs up whichever matched file is being written: set `SRC="$file_path"`, derive backup name from `basename "$file_path"`. Add a comment citing the pass2 gap as the motivation.
- **Post-fix log update:** flip improvement-log.md:95 (nordic-pe-macro) entry status to `**Status:** applied 2026-05-28` + `**Verified:** 2026-05-28 — confirmed by reading the edited script + verifying regex against test paths`.
- **QC needed:** yes — `/qc-pass` on the shell edit (verify the regex matches both `session-plan.md` and `session-plan-pass2.md` but does NOT match unrelated files like `session-plan-archive.md` if those would be undesirable).

### [project-nordic-pe-macro-landscape-H1-2026/id-11] Create `required-reference-files.md` template-level contract doc
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (template lives under `ai-resources/workflows/research-workflow/`)
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):147
- **Fix:** Create `ai-resources/workflows/research-workflow/docs/required-reference-files.md` listing:
  1. `reference/source-class-hierarchy.md` — role: source taxonomy used by run-execution / run-cluster / run-report
  2. `reference/quality-standards.md` — role: chapter QC criteria
  3. `reference/known-limits.md` — role: scope/limit declarations consumed by run-report
  4. `reference/style-guide.md` — role: prose style enforcement for chapter output
  For each: filename, expected path (relative to project root), one-line role description, which canonical command(s) read it. Cross-link from the workflow template's CLAUDE.md if a natural insertion point exists (read `workflows/research-workflow/CLAUDE.md` first to decide).
- **Post-fix log update:** flip improvement-log.md:147 (nordic-pe-macro) entry status to `**Status:** applied 2026-05-28` + `**Verified:**` line + cross-ref the new file path.
- **QC needed:** yes — `/qc-pass` on the new doc (judgment on completeness — are the 4 files actually the complete set?).

### [project-nordic-pe-macro-landscape-H1-2026/id-01 + id-05 — bundle] Add chapter-review presentation rule to project commands
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):88 (the RECURRING entry id-05) — also surfaced as friction-log id-01
- **Fix:** Add an explicit instruction to the chapter-review presentation step in BOTH:
  - `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/review-chapter.md`
  - `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-report.md` (the chapter-review step inside it — likely Step 4.2e per the source entry)
  Wording: "Operator presentation: output ONLY the QC verdict, score, and committed file path. Do NOT paste chapter prose inline — the committed file in the IDE is the operator's reading surface. This applies regardless of how prior chapters in this run were presented."
- **Post-fix log update:** flip improvement-log.md:88 (nordic-pe-macro) entry status to `**Status:** applied 2026-05-28` + `**Verified:**` line. Cross-ref to the original passive CLAUDE.md rule (which can now be removed or left as a defense-in-depth pointer).
- **QC needed:** yes — `/qc-pass` on the new rule wording across both files (must be identical or cross-reference each other to avoid drift).

### [ai-resources/id-29] Add workflow-diagnosis boundary note to ai-resource-creation.md
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md):76
- **Fix:** Open `ai-resources/docs/ai-resource-creation.md`. Add a new short section (`## Workflow-improvement surfaces`) OR a one-paragraph note in an existing section. Content: the boundary between (a) `improvement-analyst` agent (session-friction-driven workflow fixes) and (b) the planned `workflow-diagnosis` skill / `/diagnose-workflow` command (artifact-defect-driven workflow fixes). Include trigger phrasing for each: "When a session produces friction events that suggest a workflow weakness → improvement-analyst. When a delivered artifact has a defect that traces back to a workflow gap → workflow-diagnosis."
- **Sequencing note:** This fix sequences naturally with the `/create-skill` run that fulfills `inbox/workflow-diagnosis.md`. If that skill has not yet been built, the boundary doc can land first (documentation only, no new tooling).
- **Post-fix log update:** flip improvement-log.md:76 (ai-resources) entry status to `**Status:** applied 2026-05-28` + `**Verified:**` line.
- **QC needed:** yes — `/qc-pass` on the boundary description (judgment on whether the trigger phrasing is unambiguous).

### [project-nordic-pe-macro-landscape-H1-2026/id-12] Add workflow-template CLAUDE.md row to risk-topology.md
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (risk-topology is canonical reference under axcion-ai-system-owner)
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md):160
- **Fix:** Locate `risk-topology.md` (likely path: `projects/axcion-ai-system-owner/references/risk-topology.md` — verify via Glob). Read § 1 (the load-bearing-classes table). Add a new row for "Deployable-template always-loaded" — workflow-template `CLAUDE.md` as a distinct class. Blast radius: bounded by `/deploy-workflow` consumption count (currently 1 active + 1 frozen). Gate trigger maps to `/risk-check` change-class "cross-cutting CLAUDE.md edits" but mitigation calibration is lower than workspace-level. Cross-link from `ai-resources/docs/audit-discipline.md § Risk-check change classes` if a one-line addition fits cleanly there.
- **Post-fix log update:** flip improvement-log.md:160 (nordic-pe-macro) entry status to `**Status:** applied 2026-05-28` + `**Verified:**` line.
- **QC needed:** yes — `/qc-pass` on the new row (judgment on class label + blast-radius wording).

## Parked items (not this wave)

- Group A items (log/config hygiene) — wave 1.
- Group F items (`/risk-check` change class) — wave 3.
- Multi-file refactors and research — deferred (Group G + H).

## Skipped items

(none new; see wave 1 plan for skipped items.)
