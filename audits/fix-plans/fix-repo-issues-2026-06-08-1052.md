# Fix plan — 2026-06-08 10:52

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, workspace, project ai-development-lab, project marketing-positioning, project nordic-pe-screening-project, project research-pe-regime-shift-advisory-gap
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-06-08-1052-ai-resources.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-08-1052-ai-resources.md)
- workspace: [audits/working/fix-repo-issues-2026-06-08-1052-workspace.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-08-1052-workspace.md)
- project ai-development-lab: [audits/working/fix-repo-issues-2026-06-08-1052-project-ai-development-lab.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-08-1052-project-ai-development-lab.md)
- project marketing-positioning: [audits/working/fix-repo-issues-2026-06-08-1052-project-marketing-positioning.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-08-1052-project-marketing-positioning.md)
- project nordic-pe-screening-project: [audits/working/fix-repo-issues-2026-06-08-1052-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-08-1052-project-nordic-pe-screening-project.md)
- project research-pe-regime-shift-advisory-gap: [audits/working/fix-repo-issues-2026-06-08-1052-project-research-pe-regime-shift-advisory-gap.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-06-08-1052-project-research-pe-regime-shift-advisory-gap.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 5

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in.

Instruct fresh-session Claude:

> Execute the fix plan at `audits/fix-plans/fix-repo-issues-2026-06-08-1052.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

---

## Items

### [workspace/id-01] Fix QC verbatim-purity false REVISE on plan-mandated additions

- **Scope:** workspace — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`
- **Source:** [`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/friction-log.md`](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/friction-log.md) (entry ~line 7, dated ~35 days before 2026-06-08)  *(absolute path — plan lives in ai-resources/audits/fix-plans/; source spans workspace scope)*
- **Background:** The QC reviewer triggered a false REVISE verdict on content that was explicitly called for by the approved plan (plan-mandated additions). The reviewer's scope instruction uses a "verbatim-purity" framing that does not carve out additions the plan explicitly required. This blocks valid approved work and forces unnecessary rework cycles.
- **Fix:** Read the workspace friction-log entry (~line 7) for full context. Then locate the QC handoff instruction — likely in `ai-resources/.claude/commands/qc-pass.md` or `ai-resources/docs/qc-independence.md`. Add a clarifying note to the QC scope instruction: the reviewer should not issue REVISE on additions that are explicitly required by the approved plan/mandate; verbatim-purity applies to content the operator did NOT authorize, not to additions the plan called for. One to three sentences added to the scope description.
- **Post-fix log update:** Annotate the workspace friction-log entry (~line 7) with `[FADING-GATE] verified 2026-06-08 — QC handoff clarified` so it does not resurface in future scanner runs.
- **QC needed:** yes — run `/qc-pass` on the edited command/doc file after applying

---

### [project-research-pe-regime-shift-advisory-gap/id-01] Add UTF-8 encoding normalization to raw-report intake (Step 2.2b)

- **Scope:** project research-pe-regime-shift-advisory-gap — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap`
- **Source:** [`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md`](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md) (Session 2026-06-02 S4)  *(absolute path — plan lives in ai-resources/audits/fix-plans/; source is in research-pe project)*
- **Background:** Manual raw-report intake (workflow Step 2.2b) silently corrupts non-ASCII content (em-dashes, accented characters, smart quotes) due to a missing encoding-normalization step. The corruption recurred on multiple reports and is caught only downstream (e.g., at citation conversion), requiring re-intake.
- **Fix:** Read the friction-log Session 2026-06-02 S4 entry for full context and the exact file path. Then locate the project's intake workflow file (likely `.claude/commands/run-analysis.md` or a workflow step doc). Add a Step 2.2b encoding-normalization instruction: before the report content is parsed or passed downstream, convert/strip non-UTF-8 bytes — e.g., a Bash `iconv -f utf-8 -t utf-8 -c` pass or a Python `open(..., encoding='utf-8', errors='replace')` read. The instruction should be explicit about which tool handles normalization so it is not skipped.
- **Post-fix log update:** Annotate the friction-log Session 2026-06-02 S4 entry with `[FADING-GATE] verified 2026-06-08 — encoding step added to Step 2.2b`.
- **QC needed:** yes — run `/qc-pass` on the edited command/doc after applying; check that the encoding step does not alter valid UTF-8 content

---

### [project-ai-development-lab/id-02] Prevent concurrent-session commit bundling via explicit staging rule

- **Scope:** project ai-development-lab — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab`
- **Source:** [`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/friction-log.md`](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/friction-log.md) (entry ~line 10, Session 2026-05-20 area)  *(absolute path — source is in ai-development-lab project)*
- **Fix target:** [`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md`](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md)  *(canonical commit-discipline doc in ai-resources)*
- **Background:** Commit `9fc3c7d` in the ai-development-lab project accidentally swept another concurrent session's edits because staging was done with a broad `git add` rather than explicit file paths. The commit included content from a session the committer did not own, causing misattribution and potential lost-update risk.
- **Fix:** Read the friction-log entry (~line 10) for full context. Then edit `ai-resources/docs/commit-discipline.md` to add an explicit rule in the staging section: "Before committing, inspect which files are modified (`git status --short`); never use `git add .` or `git add -A` without first confirming no concurrent-session files are present; always stage by explicit path (`git add <file1> <file2>`) to avoid sweeping foreign content." One to three sentences added.
- **Post-fix log update:** Annotate the ai-development-lab friction-log entry (~line 10) with `[FADING-GATE] verified 2026-06-08 — commit-discipline.md staging rule added`.
- **QC needed:** yes — run `/qc-pass` on `docs/commit-discipline.md` after applying

---

### [ai-resources, FADING-GATE cleanup] Annotate 3 ai-resources friction-log entries for already-shipped fixes

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md`](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md)
- **Background:** Three friction-log entries describe issues whose structural fixes have shipped but whose log entries were never annotated. Without a `[FADING-GATE] verified` annotation, future scanner runs will keep re-surfacing these as open items.
  - Entry for "Concurrent-session guards blind to foreign writes on command/doc files" (Session 2026-06-04 S6(a)) — fix shipped in commit `2bc89d9` (S13 id-15 advisory-scan extension, 2026-06-05).
  - Entry for "Auto-multi-item bundle: no per-item done-condition check before bundle presented" (Session 2026-06-04 S6(b)) — fix shipped in 2026-06-05 friday-act sweep (prime Step 8c.1.5 done-condition presence-check, per monday-prep B10 note).
  - Entry for "Partial marker setup leaves NO_OWN_MARKER guard exposed to false-positive at wrap" (Session 2026-06-05 S6(b) area) — fix shipped in commit `dd618d4` (wrap-session Step 3.5 NO_OWN_MARKER hardening, S9).
- **Fix:** For each of the 3 entries, append an annotation line immediately after the entry body:
  - Entry 1 (S6(a) concurrent-session guards): `[FADING-GATE] verified 2026-06-08 — fix shipped in commit 2bc89d9 (S13 id-15 advisory-scan extension)`
  - Entry 2 (S6(b) done-condition check): `[FADING-GATE] verified 2026-06-08 — fix shipped in 2026-06-05 friday-act sweep (prime Step 8c.1.5 done-condition gate)`
  - Entry 3 (NO_OWN_MARKER): `[FADING-GATE] verified 2026-06-08 — fix shipped in commit dd618d4 (wrap-session Step 3.5 NO_OWN_MARKER hardening)`
  Read the friction-log file to locate the exact entry text before editing. Each annotation goes on its own line directly after the entry content.
- **Post-fix log update:** none — this item IS the log update.
- **QC needed:** no — log-hygiene annotation only; no command or doc semantics changed

---

### [project-research-pe-regime-shift-advisory-gap, FADING-GATE cleanup] Annotate 4 research-pe friction-log entries for already-shipped fixes

- **Scope:** project research-pe-regime-shift-advisory-gap — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap`
- **Source:** [`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md`](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/friction-log.md)
- **Background:** Four friction-log entries describe issues whose structural fixes have shipped but whose entries were never annotated.
  - "/run-analysis Step 2.5 hard PAUSE bypassed by default full-autonomy posture" (Session 2026-06-03 S3) — fix shipped in commit `2add1f2` (F4 unconditional gate precedence rule + run-analysis PAUSE hardening).
  - "Cross-day session-plan-S{n} filename collision" (Session 2026-06-04 S2) — fix committed in `6be1d77` (settle session-plan-S5.md cross-day marker collision).
  - "Citation-converter misclassified Auto-commit [report] hook commits as prior-session output" (Session 2026-06-04 S5) — fix shipped in commit `1021bfe` (F7 auto-commit filter).
  - "Concurrent sessions on one checkout: shared logs, git index, session-marker all collide; 5+ incidents" (Session 2026-06-05 S1) — fix shipped in commit `93abf16` (same-checkout auto-nudge + /new-worktree-session).
- **Fix:** For each of the 4 entries, append an annotation line immediately after the entry body:
  - Entry (S3 PAUSE bypass): `[FADING-GATE] verified 2026-06-08 — fix shipped in commit 2add1f2 (F4 run-analysis PAUSE hardening)`
  - Entry (S2 cross-day collision): `[FADING-GATE] verified 2026-06-08 — fix shipped in commit 6be1d77 (session-plan cross-day marker settled)`
  - Entry (S5 citation-converter): `[FADING-GATE] verified 2026-06-08 — fix shipped in commit 1021bfe (F7 auto-commit filter)`
  - Entry (S1 concurrent-checkout): `[FADING-GATE] verified 2026-06-08 — fix shipped in commit 93abf16 (same-checkout auto-nudge + /new-worktree-session)`
  Read the friction-log file to locate each entry before editing.
- **Post-fix log update:** none — this item IS the log update.
- **QC needed:** no — log-hygiene annotation only; no command or doc semantics changed

---

## Parked items (not this plan)

- [ai-resources/id-04] QC gate silently unreachable with 1M-credit exhaustion — reason: `needs-dedicated-session` (structural credit-check design required before committing a command edit)
- [ai-resources/id-05] inbox brief: audit-workflow-pipeline.md — reason: `needs-/create-skill`
- [ai-resources/id-06] inbox brief: workflow-diagnosis.md — reason: `needs-/create-skill`
- [ai-resources/id-07] inbox brief: codex-second-opinion-brief.md — reason: `needs-/create-skill`
- [ai-resources/id-08] inbox brief: repo-review-brief.md — reason: `needs-/create-skill`
- [ai-resources/id-09] gate-calibration: bright-line-review durable enforcement — reason: `watch-threshold`
- [ai-resources/id-10] coaching carry-forward: serialize same-day sessions on shared infra — reason: `watch-threshold`
- [ai-resources/id-11–34] T2/T3 improvement-log pending + innovation-registry loose-ends (19 items) — reason: `low-roi` / `watch-threshold`
- [workspace/id-02] Governor QC loop: 2 schema errors caught late — reason: `needs-dedicated-session`
- [workspace/id-03] strategic-os /promote-to-live first run pending — reason: `watch-threshold`
- [workspace/id-04] W2.1 cross-project state-retrieval pattern — reason: `watch-threshold` (2nd consumer trigger)
- [project-ai-development-lab/id-01] Ambiguous-referent misread investigation — reason: `needs-dedicated-session`
- [project-ai-development-lab/id-03] Word-cap doc conflict (analyze-transcript vs ref-memo-template) — reason: `decision-needed`
- [project-ai-development-lab/id-04] Lean R&D trade-off: Gap 2 QC gate vs thin-pipeline — reason: `decision-needed`
- [project-ai-development-lab/id-05] Gate 1.5 auto-select option A pause (explicitly deferred) — reason: `decision-needed`
- [project-ai-development-lab/id-06–13] T3 improvement-log pending items — reason: `low-roi`
- [project-marketing-positioning/id-02] Context engine false-negative for --add-dir sources — reason: `needs-dedicated-session`
- [project-marketing-positioning/id-03] Warmth-ceiling Checkpoint A open — reason: `decision-needed`
- [project-marketing-positioning/id-04] GitHub remote + push decision — reason: `decision-needed`
- [project-marketing-positioning/id-05] positioning.md reconciliation pending operator go — reason: `decision-needed`
- [project-marketing-positioning/id-06] Statement opener decision — reason: `decision-needed`
- [project-marketing-positioning/id-07] Gate-reopener scope confirm — reason: `decision-needed`
- [project-marketing-positioning/id-08] Uncommitted side-build files in working tree — reason: `decision-needed`
- [project-marketing-positioning/id-09–11] T3 improvement-log watch items — reason: `low-roi`
- [project-nordic-pe-screening-project/id-01] FO/E4 boundary per-fund re-litigated — reason: `decision-needed`
- [project-nordic-pe-screening-project/id-02] qc-reviewer fails under 1M-context model — reason: `needs-dedicated-session` (same class as ai-resources/id-04)
- [project-nordic-pe-screening-project/id-03] No working GitHub remote (~21+ unpushed) — reason: `watch-threshold` (operator action needed)
- [project-nordic-pe-screening-project/id-04] T3 watch — reason: `low-roi`
- [project-research-pe-regime-shift-advisory-gap/id-04] 1M-context credit blocks subagent dispatch — reason: `needs-dedicated-session` (same class as ai-resources/id-04)
- [project-research-pe-regime-shift-advisory-gap/id-06] 1M-context gate re-fired from [1m] session — reason: `needs-dedicated-session`
- [project-research-pe-regime-shift-advisory-gap/id-07] innovation-registry: ai-resources log-sweep.md command — reason: `needs-/innovation-sweep`
- [project-research-pe-regime-shift-advisory-gap/id-08] innovation-registry: run-report project copy — reason: `needs-/innovation-sweep`
- [project-research-pe-regime-shift-advisory-gap/id-09] innovation-registry: run-report canonical workflow — reason: `needs-/innovation-sweep`
- [project-research-pe-regime-shift-advisory-gap/id-11] innovation-registry: run-analysis canonical workflow — reason: `needs-/innovation-sweep`
- [project-research-pe-regime-shift-advisory-gap/id-12–21] T3 improvement-log watch items — reason: `low-roi`

---

## Skipped items (already resolved — reconcile-at-read 2026-06-08)

- [ai-resources/id-01] Concurrent-session guards blind to foreign writes on command/doc files — reason: `already-resolved (commit 2bc89d9)` — S13 id-15 advisory-scan extension covers .claude/commands + docs + non-append logs
- [ai-resources/id-02] Auto-multi-item bundle: no per-item done-condition check — reason: `already-resolved` — prime Step 8c.1.5 done-condition presence-check shipped in 2026-06-05 friday-act sweep (monday-prep B10)
- [ai-resources/id-03] NO_OWN_MARKER false-positive at wrap — reason: `already-resolved (commit dd618d4)` — wrap-session Step 3.5 NO_OWN_MARKER hardening (S9)
- [project-marketing-positioning/id-01] Intra-day session-numbering collision — reason: `already-resolved (commit 2bc89d9 + 93abf16)` — TOCTOU Phase 2+3 atomic markers + same-checkout auto-nudge
- [project-research-pe-regime-shift-advisory-gap/id-02] /run-analysis Step 2.5 hard PAUSE bypassed — reason: `already-resolved (commit 2add1f2)` — F4 unconditional gate precedence rule + run-analysis PAUSE hardening
- [project-research-pe-regime-shift-advisory-gap/id-03] Cross-day session-plan-S{n} filename collision — reason: `already-resolved (commit 6be1d77)` — cross-day marker collision settled
- [project-research-pe-regime-shift-advisory-gap/id-05] Citation-converter auto-commit hook misclassification — reason: `already-resolved (commit 1021bfe)` — F7 auto-commit filter
- [project-research-pe-regime-shift-advisory-gap/id-10] Concurrent sessions on one checkout (5+ incidents) — reason: `already-resolved (commit 93abf16)` — same-checkout auto-nudge + /new-worktree-session
