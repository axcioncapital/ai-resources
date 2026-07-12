# Fix plan — 2026-07-12 21:32

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, workspace
**Scanner notes (per scope):**
- ai-resources: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-07-12-2132-ai-resources.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-07-12-2132-ai-resources.md)
- workspace: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-07-12-2132-workspace.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-07-12-2132-workspace.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 6 (from 65 raw candidates)

## Concurrent-session exclusion (why these items and not others)

This plan was composed while session **S2** (2026-07-12) held an open mandate on the **W3.2 Phase 0 defect batch (M-A1–M-A4)**. Every item whose target file or subject matter overlapped that mandate was **parked, not planned** — see "Parked items" below. The excluded surface was:

`ai-resources/docs/autonomy-rules.md`, `docs/session-rituals.md`, `docs/session-guardrails.md`, `docs/agent-tier-table.md`, `docs/compaction-protocol.md`, `skills/CATALOG.md`, `.claude/hooks/pre-commit`, workspace `.claude/hooks/model-classifier.sh`, `.claude/commands/` model-tier frontmatter, `/new-project`, and `projects/axcion-ai-system-redesign/output/implementation-prep/`.

**Before executing:** confirm S2 has wrapped and its commits have landed. If any item below now conflicts with what S2 shipped, re-verify it against live state rather than applying blind.

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `ai-resources/audits/fix-plans/fix-repo-issues-2026-07-12-2132.md`.

Each item below is self-contained — apply in order. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-08] Register the canonical agent set in `axcion-design-studio`

- **Scope:** workspace — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/friction-log.md) — entry 2026-07-02 (S1), "canonical subagent type not registered in project sessions — risk-check-reviewer spawn fails"
- **Live state (verified 2026-07-12, and it narrows the item):** 19 of 20 projects already carry `risk-check-reviewer`. The sole exception is `projects/axcion-design-studio/.claude/agents/`, which holds **4 project-local agents only** (`brand-guardian`, `implementation-bridge`, `layout-architect`, `visual-red-team`) and **zero** canonical symlinks. The original friction entry described a general gap; it is now a single-project gap. Do not re-fix the other 19.
- **Consequence if left:** In an `axcion-design-studio` session, `/risk-check`, `/qc-pass`, `/triage`, `/blindspot-scan` and every other canonical gate **cannot spawn its reviewer** — the subagent type does not resolve. Workspace Autonomy Rule #9 makes `/risk-check` mandatory for structural change classes, so a mandatory gate silently cannot run in that project.
- **Fix:** Mirror the registration pattern the other 19 projects use — relative symlinks into the canonical library:
  ```
  ln -s ../../../../ai-resources/.claude/agents/<agent>.md \
        projects/axcion-design-studio/.claude/agents/<agent>.md
  ```
  (Verify the exact depth: `ls -l projects/strategic-os/.claude/agents/` shows the working reference pattern.) Register the canonical agents the project's commands actually dispatch — at minimum `risk-check-reviewer`, `qc-reviewer`, `triage-reviewer`, `refinement-reviewer`, `context-discovery`. **Keep the 4 project-local agents** — they are real, not drift.
- **Verify:** After symlinking, confirm dispatchability by name, not just file presence (this is the substance of workspace item id-06, "verify graduated agents are dispatchable by name"). A broken symlink satisfies `ls` but fails at spawn.
- **Post-fix log update:** Annotate the friction-log 2026-07-02 entry as resolved, naming the narrowing (19/20 were already fine; design-studio was the gap).
- **QC needed:** **yes** — this creates new symlinks, a `/risk-check` structural change class. Run `/risk-check` before applying and `/qc-pass` after.

### [workspace/id-13] QC→Triage auto-loop: halt and surface on cap-exhaustion

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/logs/improvement-log.md):50–54 — "2026-07-03 — QC→Triage auto-loop cap-exhaustion escalation" (Status: logged/pending; recurrence 2×, from friction-log 2026-05-21 and 2026-05-04)
- **Target file:** `ai-resources/docs/qc-independence.md` § **QC → Triage Auto-Loop** (section begins line 14; the operative line is the closing one: *"Cap the loop at two post-edit passes — if two passes don't clean the artifact, the problem is structural and the operator decides."*)
- **Consequence if left:** The doc says the operator decides, but specifies no mechanism to *tell* them. The loop reaches its cap on an unresolved REVISE and simply stops, so an unresolved QC finding can be silently dropped. Recorded 2× as the "feels stuck" recurrence.
- **Fix:** Amend step 5 / the cap line so that on cap-exhaustion with an **unresolved REVISE**, the loop **halts and surfaces a summary to the operator** — what remains unresolved, which passes ran, and the final verdict — rather than terminating quietly. Keep the two-pass cap itself; only add the mandatory surface-on-exhaustion behavior.
- **Post-fix log update:** Flip the workspace improvement-log entry (line 50) to `**Status:** applied YYYY-MM-DD` + `**Verified:**`.
- **QC needed:** yes — it edits a behavior-governing doc every QC pass reads.

### [workspace/id-12] Shared-state schema read-completeness rule → `ai-resource-builder`

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/logs/improvement-log.md):44–48 — "2026-07-03 — Shared-state schema read-completeness rule for ai-resource-builder" (from friction-log 2026-05-21, sub-issue #2, `mandate.json` schema)
- **Target file:** `ai-resources/skills/ai-resource-builder/SKILL.md` — the Create Workflow **Step 1: Understand the Resource** (line 61), which is the load-source-material step.
- **Consequence if left:** A component that reads/writes shared state gets built against a partially-read schema set, and schema-conformance errors surface late — after the component is written. This already happened once (the `mandate.json` schema case).
- **Fix:** Add a rule to Step 1: when building a component that reads or writes **shared state**, read **every** schema the component touches (e.g. all of `harness/schemas/`) before drafting — not just the obvious one.
- **Post-fix log update:** Flip the workspace improvement-log entry (line 44) to `**Status:** applied YYYY-MM-DD` + `**Verified:**`.
- **QC needed:** yes — SKILL.md is a canonical library file.

### [ai-resources/id-50] `foreign-session-guard.sh` — GUARD echo omits two rendered variables

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md):425–432 — "2026-07-04 — foreign-session-guard.sh GUARD echo omits EXTRA_TODAY/PRIOR_MANDATES"
- **Target file:** `ai-resources/logs/scripts/foreign-session-guard.sh` — the `GUARD:` echo, **line 247**. (Note: the script is in `logs/scripts/`, **not** `.claude/hooks/` — do not go looking for it there.)
- **Consequence if left:** The script computes `EXTRA_TODAY_MANDATES` / `EXTRA_PRIOR_MANDATES` inside the `FOREIGN>=1` classifier block, but never echoes them. Both `wrap-session` copies render those values into their REMNANT and MIXED remediation messages, so on a REMNANT/MIXED STOP the model cannot populate the message precisely from stdout. The STOP itself still fires correctly — only the diagnostic is incomplete. Rare path (concurrent + prior-day-orphan states).
- **Fix (one line, as specified by the log entry):** append to the `GUARD:` echo line:
  ```
  EXTRA_TODAY_MANDATES=${EXTRA_TODAY_MANDATES:-0} EXTRA_PRIOR_MANDATES=${EXTRA_PRIOR_MANDATES:-0}
  ```
  Low-risk: both vars default to `0` when `FOREIGN<1`.
- **Note on the entry's own advice:** the log entry says "do in a dedicated small session, not folded into unrelated work." A focused fix-plan execution session satisfies that intent — but apply and commit it **as its own commit**, not bundled with the doc edits above.
- **Post-fix log update:** Flip the ai-resources improvement-log entry (line 425) to `**Status:** applied YYYY-MM-DD` + `**Verified:**`.
- **QC needed:** no — single-line diagnostic echo, verified by running the script.

### [new/id-53] `fix-repo-issues-scanner` counts "None" open-questions blocks as open items

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** Discovered during this scan (2026-07-12). Self-disclosed by the scanner in its own workspace notes, "Skipped" section: *"session-notes.md OQ entries whose literal text starts 'None —' / 'None blocking.' followed by substantive trailing content were treated as non-None per the exact-match rule and surfaced as id-01/02/07."*
- **Target file:** `ai-resources/.claude/agents/fix-repo-issues-scanner.md`
- **Consequence if left:** **3 of 13 workspace items in this very run were phantoms** — a 23% false-positive rate on that scope. All three came from `### Open Questions` blocks that literally answer *"None"*:
  - line 474: `None — the remaining mission work is a known, bounded follow-up.` → surfaced as `id-01`
  - line 530: `None blocking. Three plan-level decisions stay open but resolve at build/proof time…` → surfaced as `id-02`
  - line 443: `None — both pending items (git setup, worktree cleanup) are operator decisions, not blockers.` → surfaced as `id-07`

  Every future `/fix-repo-issues` run re-surfaces these, and one (`id-01`) ranked as a **top-2 fix-shaped candidate**, i.e. the noise reached the front of the triage queue.
- **Root cause:** the scanner's None-detection uses an **exact-match** rule, so a "None" answer that continues with an explanatory clause (`None — …`, `None blocking. …`) fails the match and is classified as substantive.
- **Fix:** Relax the rule from exact-match to **prefix-match**: an Open-Questions block whose first non-whitespace token is `None` (case-insensitive), optionally followed by punctuation and an explanatory clause, is an **empty** block. Trailing prose after "None" is explanation, not an open question.
- **Post-fix log update:** Add an improvement-log entry recording the defect and the fix (it has no existing entry — it was found by this run).
- **QC needed:** yes — it changes classification logic in an agent every `/fix-repo-issues` run depends on.

### [hygiene] Close two backlog entries whose fixes already shipped

- **Scope:** both (see per-entry paths)
- **Consequence if left:** Both entries still read as open, so they re-enter **every** backlog scan and consume triage attention. One of them (the git remote) was ranked *"High impact / trivial effort — do now"* and is in fact **already done** — it would have sent an execution session chasing a non-problem.
- **Fix — entry 1: workspace git remote.**
  - File: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/improvement-log.md`, line 38 — "2026-07-03 — Workspace-root git remote broken (workspace commits unpushable)", `**Status:** logged (pending)`.
  - **Verified resolved 2026-07-12:** `git ls-remote --heads origin` at the workspace root succeeds and returns `refs/heads/main` = `ef00294`. The remote `axcioncapital/workspace-root.git` exists and is reachable; the entry's "Repository not found" symptom no longer reproduces. The workspace is simply 1 commit ahead (`f22f41c`, unpushed).
  - Action: flip to `**Status:** applied YYYY-MM-DD` + `**Verified:** ls-remote reachable, refs/heads/main present (2026-07-12)`.
- **Fix — entry 2: concurrent-session TOCTOU race.**
  - File: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md`, entry at **line 103** (`## Session — 2026-05-28 10:05`) — flagged by the scanner as a 3rd recurrence carrying **no closure stamp**.
  - **Verified resolved:** the structural fix shipped across commits `93c6cdc` (`detect-concurrent-session.sh` per-id liveness), `f5e013c` (`check-foreign-staging.sh` PreToolUse tripwire), `04d33e7` (`cc-worktree.sh` default worktree launch), `dd44220` (P1–P3 coverage + settings dedup). The marker protocol is now documented as "TOCTOU Phase 2+3 atomic" throughout `/prime` and `docs/session-marker.md`.
  - Action: add a closure stamp to the entry citing those commits.
  - **Do NOT mark the whole class closed.** The friction-log itself records (line 144) that the *class* persists — each instance got a narrow guard patch, and the shared-staging-index surface (line 193) remains only partially guarded. Stamp **this entry's** TOCTOU-on-shared-logs instance as resolved; leave the open class items (parked below) untouched.
- **QC needed:** no — log hygiene only.

## Parked items (not this plan)

**Conflicts with concurrent session S2 (W3.2 M-A1–M-A4):**
- [ai-resources/id-43] Purge `[1m]`/1M-context declarations, item 3 — reason: `conflicts-with-concurrent-session` (S2's M-A2b disposition of `model-classifier.sh` targets the same declarations)
- [ai-resources/id-47] Workspace-root `.claude/commands/` neither subset nor superset of canonical — reason: `conflicts-with-concurrent-session` (S2's M-A2a command-side tier scan)
- [workspace/id-09] `/new-project` step 11a stale default-model line — reason: `conflicts-with-concurrent-session` (S2's M-A3c is adjudicating exactly this)
- [workspace/id-10] `/new-project` Stage 3c should require `.gitkeep` in empty leaf dirs — reason: `conflicts-with-concurrent-session` (same file)
- [workspace/id-03] Promote reusable "Decisions Made" calls into `decisions.md` at wrap — reason: `conflicts-with-concurrent-session` (touches wrap-session, in S2's tier-scan surface)

**Needs a dedicated session:**
- [ai-resources/id-05] Shared git staging-index entanglement (`commit --amend` swept sibling's staged file) — reason: `needs-dedicated-session`
- [ai-resources/id-34] `check-foreign-staging.sh` fails open for footprint-less sessions — reason: `needs-dedicated-session`
- [ai-resources/id-37] Non-`/prime` session-start writes no per-id marker → clobberable shared marker — reason: `needs-dedicated-session`
- [ai-resources/id-29] Step 3.5 CONCURRENT block strands no-own-marker session — reason: `needs-dedicated-session`
- [ai-resources/id-35] Unmarked `/clarify`-first session risks false-CONCURRENT wrap guard — reason: `needs-dedicated-session`
- [ai-resources/id-06] SessionStart hook cannot block (confirmed) — re-check remaining fix-plan steps against hook caps — reason: `needs-dedicated-session`
- [ai-resources/id-52] `/mission` has no thread-level edit action (check-off/remove a single thread) — reason: `needs-dedicated-session` (2nd occurrence; real, but a command-surface change)

> These five concurrency items are one cluster. `friction-log.md:144` states the case plainly: each instance has received a narrow one-off guard patch, and the class persists because every new way two sessions can touch shared state is a new unguarded surface. They should be fixed **together, structurally**, not one at a time — which is precisely why they are parked rather than batched.

**Needs a decision:**
- [ai-resources/id-09] `/tech-consult` built but unwired — orphan, not integrated into the project-planning pipeline — reason: `decision-needed` (where it slots is a design call)
- [ai-resources/id-10] Async subagent misjudged as stalled → premature `TaskStop`; add "verify against the completion signal" guidance — reason: `decision-needed` (no doc home identified yet)
- [ai-resources/id-14] PreToolUse[Bash] decision-block hook unbuilt — reason: `risk-check-class`
- [workspace/id-08] `/new-project` mounts upstream projects read-write under `bypassPermissions` — reason: `risk-check-class`

**Build-shaped (route to `/create-skill`):**
- [ai-resources/id-01] Codex second-opinion auditor pilot (90d) — reason: `needs-/create-skill`
- [ai-resources/id-02] `/workflow-diagnosis` 3-phase command brief (54d) — reason: `needs-/create-skill`
- [ai-resources/id-03] `/audit-workflow` 5-pass pipeline-audit brief (46d) — reason: `needs-/create-skill`
- [ai-resources/id-07] Decision-preparation report command spec (30d) — reason: `needs-/create-skill`
- [ai-resources/id-11] `/repo-review` command brief — reason: `needs-/create-skill`

**Blocked at source:**
- Innovation registry (all 70 rows) — every row carries Status `detected`, which maps to **no** classification bucket in the scanner's contract, so **zero** items were extractable from it. The registry needs a triage-status migration before `/fix-repo-issues` or `/innovation-sweep` can yield anything from it. Reason: `needs-/innovation-sweep`. **This silently zeroed an entire backlog source — worth its own look.**

**Watch / threshold-gated (no action):** ai-resources id-12, id-13, id-15–id-33, id-36, id-38–id-49, id-51; workspace id-04, id-05, id-06, id-11 (superseded by the hygiene item above). These are parked-with-trigger or awaiting a named threshold; they are not actionable now by design.

## Skipped items

- [workspace/id-01] "3 upstream-identity settings files need path-portability retrofit" — reason: `already-resolved (commits b16ec83, f3baee7)` — the `settings-path-portability` mission is **closed and archived**, all 5 acceptance assertions met. **Additionally a scanner false-positive**: the source line reads `None — the remaining mission work is a known, bounded follow-up.` (see item id-53).
- [workspace/id-02] "3 plan-level decisions open on axcion-design-studio" — reason: `low-signal` — scanner false-positive; the source line reads `None blocking.` (see item id-53).
- [workspace/id-07] "Git setup + worktree cleanup pending operator decisions" — reason: `low-signal` — scanner false-positive; source line reads `None — both pending items … are operator decisions, not blockers.` (see item id-53).
