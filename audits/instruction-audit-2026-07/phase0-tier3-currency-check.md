# Phase 0 — Tier-3 Currency Check (10 candidate docs)

**Date:** 2026-07-03
**Scope:** Read-only currency investigation. Rule applied throughout: do not archive on suspicion — only recommend archiving where genuine dormancy is demonstrated (no live reference AND no plausible future need AND/OR content proven superseded).
**Method per doc:** full read → `grep -rl <filename-stem>` across `.claude/commands/`, `.claude/agents/`, `skills/`, root workspace `CLAUDE.md`, `ai-resources/CLAUDE.md`, and other `docs/*.md` → cross-check referenced commands/hooks/files for existence → cross-check any cadence claims against `weekly-cadence.md` and `operator-maintenance-cadence.md` → date/git-history check.

**Important tooling note (logged so the finding is reproducible):** the interactive shell's `grep` is a wrapped `ugrep --ignore-files ...` function. Run from the **workspace root**, it silently returns zero matches for anything inside `ai-resources/`, because the root `.gitignore` lists `ai-resources/` (correct — it's a separate git repo mounted via `--add-dir`) and `--ignore-files` respects that exclusion even for plain text search. All greps in this audit were run with cwd `ai-resources/` (or an explicit path into it) to get valid results. Any future doc-currency check should do the same or it will falsely conclude every `ai-resources` doc is unreferenced.

---

## ⚠️ Operator correction (2026-07-03, post-audit — authoritative)

**The operator states three of the docs below are old and no longer used**, overriding this audit's `LIVE` verdicts for them:

- `operator-maintenance-cadence.md` (row 2) — **DEAD per operator**, not LIVE.
- `onboarding-daniel.md` (row 7) — **DEAD per operator**, not LIVE.
- `onboarding-daniel-cheatsheet.md` (row 8) — **DEAD per operator**, not LIVE.

Root cause of the miss: this audit inferred "still active" from git history + inbound doc links rather than operator ground truth. Where those signals conflict with the operator, the operator wins. These three become **archive/delete candidates** for the deferred session; the other 7 verdicts stand. Nothing was archived or deleted this session — implementation is deferred.

## Summary table

| # | Doc | Verdict | One-line reason |
|---|---|---|---|
| 1 | `docs/weekly-cadence.md` | **LIVE** | Canonical technical layer; directly read by `monday-prep.md`, `friday-journal.md`, `session-marker.md`; structure matches current runbooks exactly. |
| 2 | `docs/operator-maintenance-cadence.md` | **LIVE** | Cross-referenced by `friday-cadence-runbook.md` as "the wider weekly rhythm"; Session-1 content current. Session-2 has 3 extra steps and a Backlog section that have drifted stale vs. its own newer sibling docs (details below) — flag for edit, not archive. |
| 3 | `docs/parallel-sessions-playbook.md` | **LIVE** | Actively pointed to from a live hook (`detect-concurrent-session.sh`), two live commands, and `friday-cadence-runbook.md`/`commit-discipline.md`. Most recently touched 2026-06-10. No currency issues. |
| 4 | `docs/session-rituals.md` | **LIVE** | Structurally load-bearing: `list-critical-resources.md` parses this file's section headers to classify "lifecycle commands." Also linked from both onboarding docs, `weekly-session-guide.md`, `repo-architecture.md`. Contains one confirmed-stale line (push-gate description) — flagged for correction, not archiving. |
| 5 | `docs/operator-principles.md` | **LIVE** | Referenced from `onboarding-daniel.md` (Week 2+ reading list) and `repo-architecture.md`; evergreen coaching content with no dated/command claims to go stale. |
| 6 | `docs/patrik-ai-vocabulary.md` | **LIVE** (no inbound refs, by design) | Zero grep hits anywhere — but it's a direct-read personal reference (not pipeline-invoked), self-labeled "living doc," last reviewed 2026-06-08 (~3.5 weeks before this audit), content matches current workspace vocabulary. Absence of inbound links is expected for this doc class, not a dormancy signal. |
| 7 | `docs/onboarding-daniel.md` | **LIVE** | "Daniel" is a real, currently active co-partner with push access to the shared `ai-resources` repo (git history shows his commits and 2026-06-11/12 concurrent-session coordination work with Patrik). Companion cheat sheet cross-references it. Minor content staleness flagged, not archive-worthy. |
| 8 | `docs/onboarding-daniel-cheatsheet.md` | **LIVE** | Same basis as #7; cross-references `onboarding-daniel.md`. `/save-session` recommendation and "5 risk dimensions" figure are both now stale (see below) — correction candidates, not archive candidates. |
| 9 | `docs/daniel-concurrent-session-hooks-setup.md` | **LIVE** | One-time per-machine handoff doc closing an explicitly load-bearing residual (R1) from the 2026-06-11/12 hook-registration migration. No repo-side evidence the residual was ever closed (Daniel's machine-local settings.json can't be observed from this repo) — task appears to still be open. Zero inbound doc references is expected (personal handoff, not pipeline-invoked), not a dormancy signal. |
| 10 | `docs/hook-rollback-recipes.md` | **LIVE** | Its only entry documents `friction-log-auto.sh`, which is still installed and registered live in `.claude/settings.json` today; the hook's own source comment points back to this doc by path. Designed as a growing index for future hook rollbacks — active infrastructure documentation. |

**Net result: none of the 10 candidates qualify for archiving under the "genuine dormancy" bar.** Every one is either directly wired into a live command/hook, cross-referenced by another currently-used doc, or (for the three no-inbound-reference cases — vocabulary doc, Daniel hooks-setup doc) explainable as a direct-read/personal-handoff doc rather than a dormant one. Several carry internal staleness worth a follow-up *edit* pass (listed per-doc below); none of that staleness rises to "the doc itself is dead."

---

## 1. `docs/weekly-cadence.md`

**Grep results (within `ai-resources`):**
- `.claude/commands/friday-journal.md` — references it
- `.claude/commands/monday-prep.md` — references it
- `docs/session-marker.md` — references it
- `docs/operator-maintenance-cadence.md`, `docs/weekly-session-guide.md`, `docs/friday-cadence-runbook.md`, `docs/session-rituals.md` — all cross-reference it as "full technical detail"

**Currency check:** Commands referenced inside it all exist and were verified present: `/monday-prep`, `/friday-checkup`, `/friday-so`, `/so-monthly`, `/systems-review`, `/friday-journal`, `/friday-act`, `/graduate-resource`, `/resolve-improvement-log`, `/audit-claude-md`, `/repo-dd` (implicitly via `harness` mentions). Friday F0–F6 step table matches `weekly-session-guide.md`'s and `friday-cadence-runbook.md`'s tables exactly (same step letters, same cwd, same ordering, same tier-gating logic for F2/F2b). Last touched 2026-06-05 (`update: session-harness — date-qualify session-plan filename`) — recent.

**Verdict: LIVE.** No action.

---

## 2. `docs/operator-maintenance-cadence.md`

**Grep results:** Only `docs/friday-cadence-runbook.md` references it directly by filename, but that reference is explicit and load-bearing: `friday-cadence-runbook.md`'s header names it as one of four "deeper reference" docs ("the wider weekly rhythm").

**Cross-check against `weekly-cadence.md` (the brief's flagged discrepancy risk):**

Read both in full. They do **not** conflict on Session 1 (F0–F3.5) — identical step order, identical cwd switches, identical tier-gating language for F2/F2b. They are complementary layers (this doc = personal rhythm + rationale; `weekly-cadence.md` = full mechanical detail), not duplicates.

They **do** show drift on Friday Session 2 and in the Backlog section:

- `operator-maintenance-cadence.md`'s Session 2 table lists **six** items: F4, F5, F6, plus three items absent from `weekly-cadence.md`'s canonical F4–F6 list and absent from the newer `friday-cadence-runbook.md`'s Session-2 table (which has only F4/F5/F6): **"Graduate to docs"** (review resources for the repo-documentation repo), **"Log hygiene"** (manual, "no command yet"), and **"Repo audit — run `/repo-dd` on every project worked on this week"**. Neither of the two more-recently-toutouched sibling docs (`weekly-cadence.md` 2026-06-05, `friday-cadence-runbook.md` 2026-06-05) carries these three items forward. This reads as the newer docs having quietly dropped them rather than this doc inventing them — but it means an operator following only the newer runbook would miss them. Flag for a follow-up edit to reconcile (out of scope for this currency check to fix).
- **Backlog section is stale on 2 of 3 items:**
  1. *"`/archive-logs` skill... current gap: log hygiene in Session 2 is fully manual"* — superseded. `.claude/commands/log-sweep.md` exists (created 2026-06-04, i.e. functionally covers this gap, though under a different name/shape than imagined).
  2. *"`/lean-resources` command... reviews skills/commands for token efficiency"* — superseded/covered. `.claude/commands/token-audit.md` exists and does this.
  3. *"`logs/learning-log.md` — create this file"* — still **not** superseded. Verified: `logs/learning-log.md` does not exist. This item is still genuinely open.
- The "Subsumed `/audit-critical-resources` on 2026-05-29" note is **accurate** — verified `.claude/commands/audit-critical-resources.md` does not exist, consistent with the doc's own claim that it was folded into `/pipeline-review`.

**Verdict: LIVE** (still the named "wider weekly rhythm" reference from a currently-read sibling doc). Recommend a follow-up edit — not an archive — to: (a) either reconcile or explicitly retire the 3 extra Session-2 steps, and (b) trim the two stale Backlog items now that their functionality shipped under different names, leaving only the `learning-log.md` item open.

---

## 3. `docs/parallel-sessions-playbook.md`

**Grep results:**
- `.claude/hooks/detect-concurrent-session.sh` — references it
- `.claude/commands/new-worktree-session.md` — references it
- `.claude/commands/concurrent-session-check.md` — references it
- `docs/friday-cadence-runbook.md` — references it (pre-flight step explicitly tells the operator to "Read `parallel-sessions-playbook.md` first" before any parallel work)
- `docs/commit-discipline.md` — references it

**Currency check:** Internally self-aware about its own evidentiary limits (explicitly labels its claims "reasoned, not measured" and cites a single origin run — this is a documented design choice, not staleness). Cross-references `docs/session-marker.md`, `docs/autonomy-rules.md`, `.claude/hooks/detect-concurrent-session.sh`, `docs/compaction-protocol.md` — all verified to exist. Most recent touch 2026-06-10 (`commit-discipline` Fix 4(a) reconciliation), i.e. actively maintained.

**Verdict: LIVE.** No action.

---

## 4. `docs/session-rituals.md`

**Grep results:**
- `.claude/commands/list-critical-resources.md` — **structural dependency**, not just a mention: that command's Step 11 says "a command is a lifecycle command if it appears as a step in `session-rituals.md`'s `## Session Start` list, the `## Phase 3` ... diagram, or the `## Session End` list" — i.e. `/list-critical-resources` parses this file's headings to do its own classification work.
- `docs/onboarding-daniel-cheatsheet.md`, `docs/onboarding-daniel.md` — both link to it as "Full session ritual detail" / companion doc.
- `docs/weekly-session-guide.md`, `docs/repo-architecture.md` — both reference it.

**Currency check — one confirmed stale line:** Under "Before Committing" the doc states: *"Push happens automatically after commit."* Git history shows this line was introduced by the 2026-05-28 commit `batch: remove git-push gate — push proceeds autonomously after commit`. Per the operator's own memory record, the push rule was **inverted back** to gated-and-batched on 2026-05-29 (one day later) and that is the current canonical rule (workspace `CLAUDE.md` → "Push behavior": batched to `/wrap-session`, single y/n confirmation, never mid-session). `session-rituals.md` was never touched again after the 2026-05-28 edit, so it still asserts the now-superseded autonomous-push behavior — a direct, provable contradiction with the live rule, not a suspicion. This is the single highest-value correction found in this whole Tier-3 batch.

Everything else in the file (Session Start sequence, Phase 3 ritual, `/friction-log`/`/note`/`/triage` usage, QC/refinement sequence, pre-compact and mid-session checkpoint guidance, Friday cadence summary, on-demand command list) checks out against currently-existing commands and current cadence structure.

**Verdict: LIVE** — too heavily and structurally referenced to archive, and the one wrong line is a targeted one-line fix, not evidence the whole doc is dead. Recommend a follow-up edit to correct the push-gate line (out of scope to fix in this read-only currency pass).

---

## 5. `docs/operator-principles.md`

**Grep results:** `docs/onboarding-daniel.md` (Week 2+ reading list: "the most useful guide for becoming a skilled operator"), `docs/repo-architecture.md`.

**Currency check:** Content is meta-level (how to give feedback, classify failures, use Claude as a thinking partner, "constraints over procedures") — it makes no claims about specific commands, file paths, or cadence structure that could go stale. Nothing to falsify. Header says "re-read during the weekly improvement flush if it's been more than 2 weeks" — advisory, not a currency claim.

**Verdict: LIVE.** No action.

---

## 6. `docs/patrik-ai-vocabulary.md`

**Grep results:** Zero hits across `.claude/commands/`, `.claude/agents/`, `skills/`, both `CLAUDE.md` files, and every other `docs/*.md` file. This is the only doc in the batch with a completely clean (zero) inbound-reference result.

**Why this is not a dormancy signal:** The doc is explicitly framed as a personal, directly-consulted reference ("This is a living doc. Add words as you find phrasings that didn't land.") — it exists to be read by Patrik himself, not to be invoked by a command or pointed to by a pipeline doc, so an absence of inbound links is exactly what a healthy doc of this class looks like. Corroborating signals of currency: last reviewed 2026-06-08 (~3.5 weeks before this audit — recent), and its vocabulary ("materiality bar," "evidence vs. interpretation," "[SCOPE]" tag, "structural" vs. patch, "parked") all match terms currently live in workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` verbatim.

**Verdict: LIVE**, with the caveat noted in the summary table (no inbound refs by design, not by neglect). Do not archive.

---

## 7. `docs/onboarding-daniel.md`

**Grep results:** Only `docs/onboarding-daniel-cheatsheet.md` (mutual cross-reference — each names the other as its companion file). No command or other doc references it.

**Who is Daniel:** The doc's own header states "For: Daniel — co-partner, new to Claude Code," onboarding him onto the `projects/interpersonal-communication/` project. This is corroborated well beyond the onboarding doc itself — `ai-resources` git history shows Daniel is a **real, currently active collaborator with commit/push access to the shared `ai-resources` repo**, not a fictional or one-off new-hire:
- `logs/session-notes-archive-2026-06.md`: *"rebasing local commits onto Daniel Niklander's remote `prime.md` fix `4d72509`"* — Daniel pushed a live fix to a shared command file.
- `logs/improvement-log.md` (line 391): a non-fast-forward push friction event traced to a commit that *"came from Daniel's machine"*.
- `logs/decisions.md` (2026-06-11 S1/S2 entries) and `audits/2026-06-10-concurrent-session-coverage-audit.md`: an entire concurrent-session-hook redesign was driven by the fact that Patrik and Daniel run sessions against the same shared repo, sometimes simultaneously, and needed coordinated tooling.
- Most recent evidence found: 2026-06-12 (commit `0ddea67`, "...Daniel handoff doc shipped").

So Daniel is not "someone who may return" (the DORMANT-BUT-VALID archetype the brief describes) — he appears to be presently active, roughly 3 weeks before this audit's date.

**Currency check on content:**
- References `/save-session` as the mid-session-checkpoint command (Section 4, Section 9). `.claude/commands/save-session.md` now opens with **"> Deprecated — use `/handoff` instead."** This is stale — should say `/handoff`.
- References `docs/weekly-session-guide.md` (exists, verified), `docs/repo-architecture.md` (exists), `docs/plan-mode-discipline.md`, `docs/autonomy-rules.md`, `docs/session-guardrails.md`, `docs/commit-discipline.md`, `docs/file-write-discipline.md`, `docs/ai-resource-creation.md`, `docs/cross-model-rules.md`, `docs/qc-independence.md`, `docs/compaction-protocol.md` — all verified to exist.
- Push-behavior description (Section 6a: "pushing requires your explicit approval — Claude will ask before pushing") is **consistent** with the current gated/batched rule (unlike `session-rituals.md`'s stale line above) — this doc happened to not be touched during the brief 2026-05-28 autonomous-push window, so it was never contaminated.
- Guardrail flags (four: HEAVY/SCOPE/AMBIGUOUS/COST) match the current `session-guardrails.md` set exactly.
- Autonomy-rule trigger count (10 numbered triggers) matches the current `autonomy-rules.md` structure.

**Verdict: LIVE** — real, currently active person; content is ~95% current with one clear correction candidate (`/save-session` → `/handoff`). Not archive-worthy.

---

## 8. `docs/onboarding-daniel-cheatsheet.md`

**Grep results:** Only `docs/onboarding-daniel.md` (mutual cross-reference).

**Currency check:**
- Same `/save-session` staleness as the full guide (listed in the "Session lifecycle" command table and the "I'm about to..." decision table) — same correction candidate.
- States "`/risk-check` | Evaluate a proposed structural change across **5** risk dimensions." Current `.claude/commands/risk-check.md` description states **six** risk dimensions (usage cost, permissions, blast radius, reversibility, hidden coupling, principle alignment). This is a confirmed numeric staleness — the command gained a 6th dimension sometime after this cheat sheet was written (2026-05-11) or after its last touch (2026-06-12), and the cheat sheet was never updated to match.
- The "Week 2+ commands (skip for now)" list and "Key file paths" table were spot-checked against current command/file existence — all still exist.

**Verdict: LIVE** — same basis as #7 (companion doc, same active person). Two correction candidates found (`/save-session` reference, "5" vs "6" risk dimensions); neither rises to archive-worthy.

---

## 9. `docs/daniel-concurrent-session-hooks-setup.md`

**Grep results:** Zero hits in `.claude/commands/`, `.claude/agents/`, `skills/`, both `CLAUDE.md` files, or any other `docs/*.md`. Like the vocabulary doc, this is explained by its nature rather than by neglect: it is a **one-time, per-machine, one-recipient handoff doc** ("For: Daniel / From: Patrik... You do this once, on your own machine"), not something any pipeline doc would link to.

**Currency check — is the underlying task still open?** This doc exists to close a specific, explicitly load-bearing residual (labeled "R1" in `logs/decisions.md` and `audits/2026-06-10-concurrent-session-coverage-audit.md`): a 2026-06-11 hook-registration redesign moved `check-foreign-staging.sh` and `detect-concurrent-session.sh` registration from portable repo-level config (`$CLAUDE_PROJECT_DIR`-relative, which covered Daniel's clone automatically) to machine-absolute user-level config (which does **not** transfer across machines) — leaving Daniel with **zero concurrent-session coverage** until he manually registers both hooks on his own machine. This doc (committed 2026-06-12, commit `23daa8c`) is the delivery vehicle for that fix.

Searched for confirmation the residual was closed: `logs/improvement-log.md` (current, non-archived) has no entry marking R1 resolved; `logs/session-notes-archive-2026-06.md` shows repeated to-do lines through 2026-06-12 ("Send `docs/daniel-concurrent-session-hooks-setup.md` to Daniel — R1 residual") with no later confirmation found. This is expected — Daniel's actual registration lives in *his own* `~/.claude/settings.json`, which is machine-local and cannot appear in this repo's git history regardless of whether he did it. **The repo-side evidence cannot prove completion either way**, so per the "do not archive on suspicion" rule the safe conclusion is: treat as still potentially needed.

Both scripts referenced in the doc (`check-foreign-staging.sh`, `detect-concurrent-session.sh`) still exist in `.claude/hooks/` and are still registered live in `ai-resources/.claude/settings.json`, so the doc's instructions remain mechanically accurate regardless of Daniel's completion status.

**Verdict: LIVE** (or at minimum, not safely archivable) — the closure status of the task this doc supports is unverifiable from repo state alone; recommend Patrik confirm directly with Daniel before any future disposition of this file.

---

## 10. `docs/hook-rollback-recipes.md`

**Grep results:** `.claude/hooks/friction-log-auto.sh` references it — and this is a load-bearing, code-level pointer, not a doc cross-reference: the hook's own source has an inline comment reading *"Rollback recipe: docs/hook-rollback-recipes.md."*

**Currency check:** The doc's one entry describes rolling back `friction-log-auto.sh` (landed 2026-06-12, "C6"). Verified: the script still exists at `.claude/hooks/friction-log-auto.sh`, and is currently registered live (twice) in `ai-resources/.claude/settings.json`. So the hook this recipe would roll back is still in production — the recipe is standing by for a rollback that hasn't happened (and may never happen), which is exactly its intended, healthy state, not staleness. The doc explicitly frames itself as a **growing index** ("Add a section here whenever a hook commit introduces runtime writes to live state") rather than a single-use artifact, and it is the only doc in scope whose content is directly cited from live production code.

**Verdict: LIVE.** No action.

---

## Cross-cutting findings worth carrying into Phase 1 (not archive decisions — noted for completeness)

1. **`session-rituals.md` push-gate line is factually wrong** and should be corrected to match the current gated/batched push rule (workspace `CLAUDE.md` → "Push behavior"). Highest-value single fix in this batch — this doc is structurally load-bearing (`/list-critical-resources` parses it) and read by both onboarding docs, so a wrong statement here has real reach.
2. **`/save-session` is deprecated in favor of `/handoff`**, but both Daniel onboarding docs still teach `/save-session` as the mid-session-checkpoint command. Two-file correction.
3. **`onboarding-daniel-cheatsheet.md` says `/risk-check` has 5 risk dimensions; it currently has 6.** One-line correction.
4. **`operator-maintenance-cadence.md`'s Backlog section is 2/3 stale** (log-archival and lean-resources ideas already shipped as `/log-sweep` and `/token-audit` respectively, under different names than imagined) — only the `logs/learning-log.md` item is still genuinely open. Its Friday Session-2 table also carries 3 steps ("Graduate to docs," "Log hygiene," "Repo audit") that the newer `weekly-cadence.md`/`friday-cadence-runbook.md` no longer list — worth a reconciliation pass to decide whether those steps are still wanted or were deliberately dropped.
5. **Daniel is a real, currently active collaborator**, not a hypothetical. This should inform how the campaign treats all three Daniel-named docs going forward — they are current operational reference material for an active second user of the shared repo, not onboarding scaffolding for someone who "may return."
