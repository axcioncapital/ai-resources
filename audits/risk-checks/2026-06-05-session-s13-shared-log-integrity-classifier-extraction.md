# Risk Check — 2026-06-05

## Change

Combined structural change set for session S13 (three improvement-log items):

(id-14) Add a pre-append integrity check into shared-log writers (.claude/agents/session-feedback-collector.md body, .claude/commands/improve.md) that does Read-then-Write-full-content on logs/improvement-log.md / logs/friction-log.md: before persisting a full-file rewrite, assert the working entry count (or byte size) is not sharply below the committed HEAD baseline (git show HEAD:logs/improvement-log.md | grep -c '^### ') and STOP-loud on a sharp shortfall (read-during-rewrite truncation signature). Also document the hazard + minimal-append-over-full-rewrite preference in docs/commit-discipline.md.

(id-15) Extend the read-only FOREIGN_SHARED concurrent shared-dir advisory scan in .claude/commands/prime.md Step 1a AND .claude/commands/session-start.md Step 0.5 (lockstep, identical edit) to also cover non-append shared logs under logs/ (minimally logs/improvement-log.md; reasonably logs/improvement-log-archive.md + logs/decisions.md). Keep append-only logs/session-notes.md OUT of scope.

(id-16) Extract the change-shape classifier list (Files / Commands / Agents / Models / Folder structure / Hooks / Workflows / Project boundaries / Permissions) — currently duplicated verbatim in .claude/commands/consult.md Step 2 and .claude/agents/project-manager.md Phase 3 — into a new "Change-shape classifier" subsection in docs/repo-architecture.md, and convert both consumers from verbatim copies to read-and-apply references.

All three are in-scope ai-resources structural edits flagged worth-doing by the System Owner. Evaluate the combined set.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/project-manager.md — exists

## Verdict

RECONSIDER

**Summary:** id-14 and id-15 are low-to-medium-risk, well-scoped guards, but id-16 is built on a stale premise — the change-shape classifier was already extracted to `docs/change-shape-classifier.md` on 2026-05-29 and both named consumers already read it, so re-extracting it into `repo-architecture.md` would create a duplicate/contradictory contract; the combined set must be rescoped to drop id-16 (and id-16 alone should re-verify what problem, if any, remains).

## Consumer Inventory

Search terms: `improvement-log`, `friction-log`, `commit-discipline`, `FOREIGN_SHARED`, `change-shape-classifier`, plus the named files' basenames. Greps run across `ai-resources/.claude`, `scripts`, `skills`, `docs`, and workspace-root `.claude`. Audit/plan/log historical mentions excluded (they document, they do not consume the contract operationally). Rows below are the functional consumers per change item.

### id-14 — shared-log integrity check (writers of improvement-log.md / friction-log.md)

The change edits two writers (session-feedback-collector.md, improve.md) but the *contract* it touches — the integrity/shape of `improvement-log.md` and `friction-log.md` — is shared by many readers/writers. The most coupling-relevant rows:

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/session-feedback-collector.md | co-edits (target writer) | yes |
| ai-resources/.claude/commands/improve.md | co-edits (target writer) | yes |
| ai-resources/docs/commit-discipline.md | co-edits (target doc) | yes |
| ai-resources/.claude/commands/resolve-improvement-log.md | invokes (append-only writer; archives entries) | no |
| ai-resources/.claude/commands/wrap-session.md | invokes (writes session block; reads logs) | no |
| ai-resources/.claude/commands/friction-log.md | invokes (appends friction events) | no |
| ai-resources/.claude/commands/note.md | invokes (appends to friction-log) | no |
| ai-resources/.claude/hooks/friction-log-auto.sh | invokes (auto-append hook) | no |
| ai-resources/.claude/hooks/log-write-activity.sh | invokes (logs write activity) | no |
| ai-resources/.claude/commands/{prime,open-items,monday-prep,friday-checkup,friday-act,fix-repo-issues}.md | parses (read HIGH/urgent items, status fields) | no |
| ai-resources/.claude/agents/{improvement-analyst,diagnostics-scanner,fix-repo-issues-scanner,collaboration-coach,...}.md | parses (read log entries) | no |

Note: ~30 functional consumers reference these two logs; only the 3 explicitly named in the change must change. The remaining readers/append-writers stay compatible — the change adds a *guard* (a STOP-loud abort on shortfall) and a doc note, not a schema change to the entry format the readers parse.

### id-15 — FOREIGN_SHARED scan extension

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/prime.md | co-edits (Step 1a scan — target) | yes |
| ai-resources/.claude/commands/session-start.md | co-edits (Step 0.5 scan — target, lockstep) | yes |
| ai-resources/.claude/commands/concurrent-session-check.md | documents (shares the collision-audit source `2026-06-05-concurrent-session-collision-diagnostics-fix.md`) | no |

`FOREIGN_SHARED` is a local shell variable, not an exported contract — grep confirms it lives only in prime.md and session-start.md (the two lockstep targets). No downstream parser depends on its value.

### id-16 — change-shape classifier extraction

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/docs/change-shape-classifier.md | **already the canonical home** (created 2026-05-29) | n/a |
| ai-resources/.claude/commands/consult.md | imports (Step 2 already reads change-shape-classifier.md) | no |
| ai-resources/.claude/agents/project-manager.md | imports (Phase 3 already reads change-shape-classifier.md) | no |
| ai-resources/docs/repo-architecture.md | documents (the proposed *new* home) | yes (per change intent) |

**Critical inventory finding:** the change premise ("currently duplicated verbatim in consult.md Step 2 and project-manager.md Phase 3") is **stale**. Grep shows both named consumers already read `docs/change-shape-classifier.md` at runtime, not verbatim copies. `consult.md:48` reads `ai-resources/docs/change-shape-classifier.md`; `consult.md:52` states "the classifier is canonical in `docs/change-shape-classifier.md` … Edit the categories there, not here. (Refactored 2026-05-29 from a two-end verbatim-copy contract)". `project-manager.md:63` reads the same doc; `project-manager.md:65` carries the identical one-end-contract note. The verbatim duplication id-16 proposes to fix was already removed six days ago.

Total across set: ~33 distinct consumers; 5 must-change (3 for id-14, 2 for id-15); id-16's proposed must-change (repo-architecture.md) is built on a stale premise.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- id-14 adds bounded logic to two non-always-loaded artifacts (an on-demand agent invoked by `/wrap-session` Step 6.5, and the `/improve` command) — pay-as-used, no per-turn cost. Evidence: `session-feedback-collector.md:3` "Invoked by /wrap-session Step 6.5"; `improve.md` is operator-invoked.
- id-14's doc note lands in `docs/commit-discipline.md`, a load-on-demand doc ("When to read this file: …" at `commit-discipline.md:3`) — not always-loaded.
- id-15 adds a few lines to `/prime` and `/session-start` (Sonnet commands, `prime.md:2` / `session-start.md:3`). The scan is one extra `git status --short` path arg per session — negligible. The scan only fires when `SIBLING_COUNT > 1` / `FOREIGN_WRITE=1` (`prime.md:81`, `session-start.md:58`), so most sessions never run it.
- id-16 would add a subsection to `repo-architecture.md` (load-on-demand) — but see Dimension 6; the extraction is misdirected.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` edits proposed in any of the three items. No new tool family, no scope escalation.
- id-14's integrity check uses `git show HEAD:logs/improvement-log.md | grep -c '^### '` — verified runnable (returns 23, matching the working count of 23). `Bash(git show:*)` and `Bash(grep:*)`-class reads are within established read-only patterns already used pervasively across `/prime`, `/session-start` (e.g., `prime.md:84` `git status --short`).
- id-15's `git status --short -- … logs/…` is read-only and already the exact idiom in use (`prime.md:84`, `session-start.md:61`); extending the path list adds no capability.
- Note: `settings.json:28,32` deny `Read(logs/*archive*.md)`. id-14 names `improvement-log.md` (active log, not denied) for its baseline check and id-15 *reasonably* names `improvement-log-archive.md` — but only inside a `git status --short` scan (which lists dirty paths, it does not `Read` the file content), so the deny rule is not tripped. Confirm at implementation that the archive is only ever passed to `git status`, never to `Read`.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory: ~33 distinct consumers across the set; 5 must-change. id-14 touches 3 files (2 writers + 1 doc); id-15 touches 2 (lockstep). All explicitly named.
- id-14 changes no entry-format contract — it adds a pre-write abort guard. The ~30 log readers/appenders (`improve`, `wrap-session`, `friction-log`, `note`, hooks, scanner agents) parse `### ` entry headers and status fields; none are affected by an abort-on-shortfall guard. Backwards-compatible. Evidence: the guard's grep marker `'^### '` matches the existing entry-header convention the readers already use.
- id-14 leaves a coverage gap: it guards only 2 of the writers. `resolve-improvement-log.md` is the other heavy mutator of these logs (it archives entries — an intentional large delete from the active log). The guard's "sharp shortfall vs HEAD baseline" signature would *false-positive* on a legitimate `/resolve-improvement-log` archive run if that command ever shared the guard — call this out so the guard is scoped to the truncation-prone full-rewrite path only, not blanket-applied.
- id-15: `FOREIGN_SHARED` is a local var, no downstream parser — extending its path coverage is isolated to the 2 lockstep files.
- id-16: the would-be must-change consumer (`repo-architecture.md`) plus a *latent* blast-radius hit — converting consult.md/project-manager.md "from verbatim copies to references" would, if applied literally, **repoint two working references** (`consult.md:48`, `project-manager.md:63`) away from the already-canonical `change-shape-classifier.md` to a new `repo-architecture.md` subsection, breaking the existing one-end contract. This is the inventory gap that drives the Dimension 6 finding.

### Dimension 4: Reversibility
**Risk:** Low

- id-14, id-15, id-16 are all edits to versioned source files (commands, agent, docs) — clean `git revert` fully restores prior state within the working tree. No data/log mutation persists, no external write, no automation fires between landing and revert.
- id-14's guard, if it ships and mis-fires, fails *loud and read-only* (STOP-loud, no write) — a mis-fire blocks a write rather than corrupting state, so even a bad guard is safe to back out.
- No symlink, hook-registration, cron, or settings change in the set. `commit-discipline.md` note is plain prose, revert-clean.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- id-14 introduces an implicit dependency on the `'^### '` entry-header convention as a *count proxy* for log integrity. This convention is real and shared (the same marker the readers parse), but it is now load-bearing for a safety guard — if a future entry format changes the header depth, the guard silently mis-counts. Document the dependency in `commit-discipline.md` alongside the hazard note (the change already plans a doc note — fold the contract into it).
- id-14's "working count not sharply below HEAD baseline" assumes the working tree is *ahead of or equal to* HEAD for these logs. That holds for an append-only-growth log, but `/resolve-improvement-log` legitimately shrinks the active log at archive time (`resolve-improvement-log.md:103–110` append-to-archive + remove-from-active). If the guard ever runs in a session where archiving already happened pre-commit, "sharp shortfall" is the *expected* state, not a truncation. The guard must be scoped to the read-during-rewrite path only — name this exclusion explicitly.
- id-15: low coupling — the scan is advisory, names the surface only, does not block (`prime.md:87` "The advisory only names the surface; it does not block").
- id-16: **functional overlap with an existing mechanism** — the classifier already has a canonical one-end home (`change-shape-classifier.md`). Re-homing it in `repo-architecture.md` creates two docs that both claim to define the change-shape categories — exactly the two-source drift the 2026-05-29 refactor eliminated. This is the high-coupling failure id-16 would re-introduce.

### Dimension 6: Principle Alignment
**Risk:** High

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present).

- **id-14 — aligned (serves OP-12 / OP-3).** A pre-append integrity guard that STOPs loud on a truncation signature is *closure-side* (it prevents silent log-data loss) and is loud-failure-over-silent-continuation (OP-3, `principles-base.md:41`). It detects *and* closes (refuses the bad write) rather than adding orphan detection (OP-12, `principles-base.md:50`). The paired doc note + minimal-append preference is consolidation, not speculation. Low principle risk.
- **id-15 — aligned (DR-7 satisfied).** Extending an *existing* advisory scan to cover additional already-existing shared logs has a confirmed live consumer (the scan itself, shipped 2026-06-05) — this is widening proven infrastructure, not building for an absent consumer. Keeping append-only `session-notes.md` out of scope is correct (it is protected by the marker protocol; scanning it would be redundant detection). Low principle risk.
- **id-16 — VIOLATES DR-7 / AP-7 / OP-9 (speculative/contradictory re-abstraction) and OP-11 (silent drift).** id-16's stated trigger — "currently duplicated verbatim" — is **false as of 2026-05-29**. The classifier was already extracted to `change-shape-classifier.md` precisely because "DR-7 trigger (two confirmed consumers sharing the same logic) was met" (`change-shape-classifier.md:41`, Provenance). Both consumers already read that doc (`consult.md:48,52`; `project-manager.md:63,65`). Re-extracting the same list into a *different* doc (`repo-architecture.md`) does not generalize on a new consumer — it duplicates an already-canonical contract into a second home, the exact AP-7 / two-source-drift failure mode the system already closed. Re-homing a canonical contract without acknowledging it was already homed elsewhere is silent drift (OP-11, `principles-base.md:49`) on a recorded prior decision. This is a clear, unacknowledged principle conflict — no technical patch fixes it; the change must be rescoped or the prior 2026-05-29 decision must be loudly revisited.

## Recommended redesign

- **Drop id-16 from the set, or rescope it to a verification-only task.** The change-shape classifier is already canonical in `docs/change-shape-classifier.md` (created 2026-05-29) with both `consult.md` Step 2 and `project-manager.md` Phase 3 already reading it as a one-end contract. There is nothing to extract. If the real intent is "make `repo-architecture.md` *point to* the classifier doc" (a cross-reference, not a re-home), that is a one-line pointer addition — frame it as such and keep the single source of truth in `change-shape-classifier.md`. If id-16 genuinely wants to *move* the canonical home from `change-shape-classifier.md` to `repo-architecture.md`, that is a deliberate revision of the 2026-05-29 decision and must be made loud and recorded (OP-11) — not slipped in as a "fix verbatim duplication" item whose premise no longer holds. Re-verify against `change-shape-classifier.md` § Provenance before doing anything to id-16.
- **Land id-14 and id-15 on their own.** Both are well-scoped, reversible, principle-aligned (Low/Medium across dims 1–5, Low on dim 6). For id-14, add two scoping constraints at implementation: (a) apply the guard only to the truncation-prone full-rewrite path, never to the legitimate-shrink path that `/resolve-improvement-log` archiving represents, and (b) record the `'^### '` count-proxy dependency in the same `commit-discipline.md` note so the guard's assumption is documented, not hidden. With id-16 removed, the remaining two-item set is a GO.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (e.g., `consult.md:48,52`; `project-manager.md:63,65`; `change-shape-classifier.md:41`; `settings.json:28,32`), grep-based consumer inventory counts, a runtime verification of id-14's proposed integrity command (`git show HEAD:logs/improvement-log.md | grep -c '^### '` → 23, matching working count 23), and principle IDs cited from `principles-base.md` (OP-3, OP-9, OP-11, OP-12, DR-7, AP-7). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion step (risk-check Step 4a, triggered by the non-GO verdict). Resolved by direct main-session verification rather than a fresh `/consult` / `/pm` spawn — proportionality call per the workspace materiality bar and the `/pm` Step 0 read-first gate: the single load-bearing finding (id-16 stale premise) is settled fact, not contested architectural judgment, so a second Opus agent adds no signal._

**Direct verification of the id-16 finding (main session, 2026-06-05 S13):**
- `docs/change-shape-classifier.md` exists (created 2026-05-29 20:07) — the classifier already has a canonical single home.
- `.claude/commands/consult.md:48` reads it: "Read `ai-resources/docs/change-shape-classifier.md` for the canonical definition." Line 52 carries a one-end-contract provenance note: "Refactored 2026-05-29 from a two-end verbatim-copy contract."
- `.claude/agents/project-manager.md:63` reads it: "Apply the change-shape definition from `ai-resources/docs/change-shape-classifier.md`." Line 65 carries the matching provenance note.

**Conclusion:** id-16's source entry (improvement-log, dated 2026-05-28) predates its own fix (2026-05-29). The work is already done. The proposed re-homing into `repo-architecture.md` would create a SECOND canonical home for the classifier — re-introducing the exact two-source drift (DR-7 / AP-7) the 2026-05-29 refactor eliminated. **Drop id-16.** Concur with the RECONSIDER verdict and the recommended rescope: land id-14 + id-15 alone.

**Process note (diagnostics-lag, 3rd instance today):** id-16 entering the executable set is the third recurrence today of the "diagnostics scan surfaces an already-resolved item" pattern (morning /diagnostics-plan id-26/25; afternoon /fix-project-issues id-09/07/05; now id-16). Root cause is consistent: candidate scans built from dated audits/log-entries over-report when later work has already moved the files, and the scanner does not reconcile against live state before handing candidates downstream. This is the structural fix already proposed in the last session's Next Steps ("a live-state reconciliation pass in the diagnostics-scanner that culls already-resolved candidates before SO vetting") — id-16 is fresh evidence for it. Carry to wrap as a friction-log recurrence.
