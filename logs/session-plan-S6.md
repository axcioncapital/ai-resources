# Session Plan — 2026-06-05 — S6

## Intent
Implement as many remaining unimplemented 2026-06-05 friday-act plan items as possible — coach-agent guardrail, research-workflow fixes (fix-mojibake.sh + improvement-analyst reroute), session-harness non-structural fixes (date-qualify session-plan filename, per-item done-condition check, CONCURRENT block decision), repo-hygiene (fix-symlinks extension, cleanup-worktree, vault W2.4 triage) — explicitly deferring items requiring /risk-check or large effort.

## Model
sonnet — doing work (executing defined fixes across multiple files). Active: claude-sonnet-4-6 — **match**, no `/model` switch.

## Source Material
- `audits/friday-plans/2026-06-05-coach-agent.md`
- `audits/friday-plans/2026-06-05-research-workflow.md`
- `audits/friday-plans/2026-06-05-session-harness.md`
- `audits/friday-plans/2026-06-05-repo-hygiene.md`
- `audits/friday-plans/2026-06-05-vault-integrity.md`
- `.claude/agents/collaboration-coach.md`
- `.claude/agents/improvement-analyst.md`
- `.claude/commands/prime.md`
- `.claude/commands/session-plan.md`
- `.claude/commands/wrap-session.md`
- `.claude/commands/fix-symlinks.md`
- `docs/session-marker.md`
- `docs/audit-discipline.md`
- `projects/repo-documentation/output/phase-2/w2-4-improvements-2026-06-05.md`

## Findings / Items to Address

1. **Coach-agent project-root guardrail** (coach-agent.md #1 [med]) — `collaboration-coach` abandoned its assigned project root for ai-resources/buy-side corpus when local logs were sparse; 3/9 misroutes confirmed this cycle. Fix: add hard-anchor instruction in agent definition forbidding corpus wandering outside the assigned project root.

2. **improvement-analyst archive de-dup reroute** (research-workflow.md #2 [med]; vault W2.4 finding #3) — agent hits `Read(logs/*archive*.md)` deny when checking recurrence; de-dup runs against active log only. Recurrence CONFIRMED twice. Fix: reroute archive title check via Bash grep on caller side or pass titles in payload — agent never reads the archive file directly.

3. **fix-mojibake.sh new script** (research-workflow.md #1 [med]) — UTF-8 corruption on every research-workflow raw-report intake (Step 2.2b). Fix: create `scripts/fix-mojibake.sh` normalization script and add a reference in research-workflow Step 2.2b as a manual (non-hook) call. If wired as a hook, escalates to /risk-check — keep manual.

4. **Vault W2.4 triage** (vault-integrity.md #2 [med]) — 5 findings from the W2.4 report not auto-imported:
   - Finding #1 (per-item done-condition check): handled in-session as item 6 below
   - Finding #2 (flip id-34 no-own-marker to applied+Verified): bookkeeping only → flag for /resolve-improvement-log, no new entry
   - Finding #3 (archive-read deny gap): handled in-session as item 2 above
   - Finding #4 (pre-spec consumer-inventory grep checklist): new improvement-log entry
   - Finding #5 (.claude/ git-hygiene shared-resource): already logged as dedicated-session item, no action

5. **Date-qualify session-plan filename** (session-harness.md #3 [med]) — `session-plan-S{N}.md` collides across days; this session hit the exact bug (today's S6 overwrote a 2026-06-04 S6 plan). Fix: rename pattern to `session-plan-{YYYY-MM-DD}-S{N}.md` in `docs/session-marker.md` (table + contract), `prime.md` (Steps 8a/8b/8c write sites), `session-plan.md` (Step 0 check + Step 7 write). Glob consumer `open-items.md` uses `logs/session-plan-*.md` — still matches, no change needed. **Tripwire:** touches commands that write session files → automation-with-shared-state-effects → /risk-check required before commit.

6. **Per-item done-condition check in /prime Step 8c** (session-harness.md #4 [med]; vault W2.4 finding #1) — auto-multi-item bundles can include items with no specifiable done-condition; they consume the approval gate before being recognized as unscoped. Fix: add Stage-0 gate in `prime.md` Step 8c: before presenting the bundle, each item must carry a one-line done-condition; items without one are held back with "needs a concrete deliverable — define before running." **Tripwire:** same as item 5 — batched together for a single /risk-check.

7. **SESSION-ISSUE: CONCURRENT block strands no-own-marker sessions** (session-harness.md #5 [med]) — wrap-session Step 3.5 guard fires CONCURRENT on sessions with no marker whose work is already committed (orphan false positive). Any fix restructures shared-state-automation write logic → /risk-check required, medium effort. **Decision: DEFER** — log candidate approach (detect OWN_CONTENT_IN_HEAD=true + no staged session-notes delta as REMNANT-not-CONCURRENT shape) in improvement-log.

8. **fix-symlinks: extend scan for regular-file-where-symlink-expected** (repo-hygiene.md #3 [med]) — current scan only detects broken symlinks; misses a regular file sitting where a symlink is expected (logged 2026-06-02). Fix: add a second pass after the broken-symlink scan checking known expected-symlink paths for regular-file presence. Command-text edit only; no /risk-check class.

9. **cleanup-worktree** (repo-hygiene.md #4 [med]) — working tree has `logs/session-notes.md` and `logs/session-plan-S5.md` modified-uncommitted (S5 setup that never executed), plus other repo drift. Fix: run `/cleanup-worktree` to investigate paths and plan safe disposition.

## Execution Sequence

### Stage 1 — Agent edits: coach-agent guardrail + improvement-analyst reroute (items 1 & 2)
1. Read `collaboration-coach.md` fully; identify the corpus-reading Phase 1 block.
2. Edit agent: insert project-root anchor instruction — "Read only files within the assigned project root. Do not read from ai-resources/, buy-side/, or any other project when local logs are sparse. If data is insufficient, report as a data gap."
3. Read `improvement-analyst.md` fully and the `/improve.md` caller; identify how archive path is passed (or not) to the agent.
4. Edit improvement-analyst: replace direct archive Read with Bash grep reroute — caller passes a pre-extracted list of applied+verified titles (via `grep` against the archive file) in the agent input payload; agent consumes the list, never calls Read on the archive.
5. Verify: re-read both agents; confirm no `Read(logs/*archive*.md)` in improvement-analyst; confirm anchor text in collaboration-coach.
6. Commit: `update: collaboration-coach + improvement-analyst — project-root guardrail + archive de-dup reroute`

### Stage 2 — fix-mojibake.sh new script (item 3)
1. Locate research-workflow Step 2.2b — check `workflows/research-workflow/` and `.claude/commands/` for the command file.
2. Create `ai-resources/scripts/fix-mojibake.sh` — UTF-8 normalization using `iconv -f UTF-8 -t UTF-8 -c` or `uconv`; include usage comment and a verify-pass at the end.
3. Add one-line reference in research-workflow Step 2.2b as a manual call (not hooked); mark as optional if iconv not installed.
4. Verify: script file exists, research-workflow text references it, no hook wiring present.
5. Commit: `new: scripts/fix-mojibake.sh — UTF-8 normalization for research-workflow raw-report intake`

### Stage 3 — Vault W2.4 triage (item 4)
1. Confirm findings #1 and #3 are handled in-session (items 6 and 2 above).
2. Append improvement-log entry for finding #4 (pre-spec consumer-inventory grep checklist): new `logged (pending)` entry.
3. Note finding #2 as /resolve-improvement-log bookkeeping for id-34; no new entry.
4. Note finding #5 as already logged; no action.
5. Verify: improvement-log contains new entry for finding #4.
6. Commit: `update: improvement-log — vault W2.4 finding #4 (pre-spec consumer-inventory checklist)`

### Stage 4 — Harness edits: date-qualify filename + done-condition check (items 5 & 6)
**[/risk-check required before commit]**
1. Read `docs/session-marker.md`, `prime.md` (full), `session-plan.md` (full).
2. Edit `docs/session-marker.md`: update filename table (both rows: canonical plan + re-invocation fork) and the writer-list contract line.
3. Edit `prime.md` Steps 8a.3.c, 8b.3.c, 8c.8: change `logs/session-plan-${MARKER}.md` → `logs/session-plan-${DATE}-${MARKER}.md` at all three write sites; ensure `DATE` is set to today's `YYYY-MM-DD` at each site.
4. Edit `session-plan.md` Step 0: update the existence-check path pattern; Step 7: update OUTPUT_TARGET default.
5. Edit `prime.md` Step 8c auto-mode: add Stage-0 gate before bundle presentation — check each picked item for a one-line done-condition; hold back items without one with a named message.
6. **Run /risk-check** on this batch before committing.
7. On GO/PROCEED-WITH-CAUTION: commit `update: session-harness — date-qualify session-plan filename + /prime Step 8c done-condition gate`
8. On RECONSIDER/NO-GO: log in improvement-log, stop Stage 4 without commit.

### Stage 5 — SESSION-ISSUE decisions (items 7 & 8)
1. Item 7 (CONCURRENT defer): append improvement-log entry with DEFER decision and candidate fix approach.
2. Item 8 (fix-symlinks extend): read `fix-symlinks.md` fully; find the symlink scan loop in Step 2; add second pass after broken-symlink detection — scan for regular files at expected-symlink paths.
3. Verify: fix-symlinks.md contains second-pass logic; improvement-log contains CONCURRENT defer entry.
4. Commit: `update: /fix-symlinks — detect regular-file-where-symlink-expected drift` (improvement-log changes bundled separately in Stage 3 commit or here if cleaner).

### Stage 6 — cleanup-worktree (item 9)
1. Run `/cleanup-worktree` against both repos.
2. Follow the command's QC + triage output to disposition each dirty path.
3. Commit any changes per /cleanup-worktree guidance.

## Scope Alternatives

**Min (items 1–3, ~2 commits):** Stages 1–2 only — agent edits + fix-mojibake.sh. No /risk-check needed. Lowest risk, highest certainty of completion.

**Recommended (items 1–8, ~5 commits):** Stages 1–5 — all of the above plus vault W2.4 triage, date-qualify filename, done-condition check, and SESSION-ISSUE decisions. Excludes cleanup-worktree (open-ended). /risk-check gates Stage 4.

**Max (all 9 items, ~6+ commits):** Adds cleanup-worktree in Stage 6. Duration depends on what the command finds; add only if context allows.

## Autonomy Posture
Gated

**Stop points:**
- Stage 4 step 6: run /risk-check before committing harness edits; pause on RECONSIDER or NO-GO.
- Stage 6 step 2: review /cleanup-worktree's plan before acting on dirty paths.

All other stages: full autonomy within declared scope.

## Risk
Stage 4 (items 5 + 6) edits `prime.md` and `session-plan.md`, both of which write to session-plan files and session-notes — automation-with-shared-state-effects tripwire per `docs/audit-discipline.md`. Run `/risk-check` before Stage 4 commit (plan-time gate) and again before the final commit (end-time gate per workspace autonomy rules).

Stages 1–3 and 5: no structural change classes apparent — run `/risk-check` if scope expands into hook wiring or settings changes.

Item 7 (CONCURRENT block) deferred because any fix hits the structural class — no commit planned this session.
