# Friction Log

## Session — 2026-04-18 (post-prevention cleanup 2)

### Friction Events

- **Prime Step 2 innovation-registry count wrong.** Registry is a pipe-delimited markdown table (rows like `| 2026-04-18 | agent | .../file.md | detected | — |`), but Prime Step 2 greps for `^- **detected**` / `status: detected` / `"status": "detected"` — list-item and JSON patterns, not table-cell patterns. Result: registry with 5 `detected` rows reported 0. Last session's wrap already flagged this as "status-check needed" — root cause is the Prime grep pattern, not registry state. Fix: Prime should grep for `| detected |` (table-cell pattern) or parse the status column directly.
- **Prime git-status snapshot can be stale vs actual HEAD.** This session's Prime reported `M .claude/hooks/pre-commit` and `?? .claude/hooks/check-skill-size.sh`, but both were actually committed in `bbd2261` and `a0c79fc` — `git diff --stat HEAD` showed those paths clean. Cost: full diagnostic detour to confirm what "loose ends" were outstanding. Not a Prime bug per se (snapshot is explicitly point-in-time), but a systematic hazard when Prime flags next-steps that depend on status claims. Possible fix: Prime's status block should invite a re-check (`git status` at step 7 or similar) rather than being treated as ground truth.

#### Write Activity

## Session — 2026-05-08 14:05

### Friction Events

- **14:05** — During /friday-act this morning, I read the spec for SO advisory + systems-review as "first 30 lines peek" and stopped there. I made claims like "the SO advisory's priority filter mirrors all 12 checkup items" based on 30 lines — claims I could not actually verify. The disposition decisions for 31 journal items + 12 checkup items were grounded in incomplete context. Operator caught this and said "this was supposed to be your job as well" — meaning judgment about reading scope was supposed to be mine, not a literal-spec compliance issue. The autonomy-axis target the operator set in the SAME session ("Autonomy → loosen — operator trusts Claude to make decisions on its own; operator input rarely brings more value") was actively undermined by me hiding behind spec literalism within minutes of it being set. The right move was to read the full SO advisory + systems review before proposing a disposition; the spec's 30-line peek is a floor, not a ceiling, especially on a heavy-disposition Friday.
- **18:26** — /consult invoked when a 5-min targeted Read of /deploy-workflow.md would have answered the same question — overkill for a case where I already had a confident structural recommendation. Burned ~95k tokens and 2.5min on Opus when I could have done a focused file-read first and only escalated to /consult if the read surfaced a genuine ambiguity. Lesson: when I've already given a recommendation, do the cheapest verification read first; reserve /consult for genuinely contested or load-bearing system-shape questions.

#### Write Activity

## Session — 2026-05-11

### Friction Events

- **/session-start confirmation token ambiguous.** The mandate-confirmation prompt says *"Confirm, or correct any field."* but does not define the canonical confirmation token. Operator replied `c. Next /session-plan` meaning "confirm; next session will be /session-plan" — Claude parsed `c.` as a correction to field c ("Done when") and silently baked /session-plan into the current session's mandate. Net effect: session ran an extra command that wasn't supposed to be in this session. Fix: /session-start should state the confirmation token explicitly (e.g., `"Reply 'y' to confirm, or list specific field corrections like 'b: ...'"`) and reject single-letter ambiguous replies.

- **/session-plan semantics conflate "current session" vs "next session" when invoked from /monday-prep C15.** /session-plan's Step 0 checks for today's `/prime` header and Step 5 talks about "this session's autonomy posture" — language that assumes the active session. But /monday-prep C15 invokes /session-plan as *"Run /session-plan for the first work session"* — meaning the *next* session. The mismatch made today's conversation feel like a topic shift mid-session (Monday prep → resolve-scratchpads-convention) when the operator only meant to run /monday-prep. Fix: either (a) /session-plan should know which mode it's in (pass a flag from C15), or (b) /monday-prep C15 should write a planning scaffold for the next session rather than invoking /session-plan inline. Related: the relationship between the week mandate (/monday-prep) and the per-session plan (/session-plan) is not documented anywhere — operator could reasonably expect them to be separate sessions.

- **/session-plan template produces sparse plans that don't carry the essential information.** Ran /session-plan for the new-project drift-fix session. The plan I wrote followed the skill's template skeleton literally (one-sentence Intent, three-bullet Source Material, short Risk paragraph) and ended up as a pointer to the drift report rather than a self-contained execution brief. QC reviewer flagged "Recommended-scope shorthand" as advisory only — but the operator caught it as load-bearing: *"why is there so little information in the session plan?"* A session plan should be readable on its own and tell a future-me (or a fresh session resume) what's going to happen, why, in what order, and with what verification — not just point at a separate file. Fix: /session-plan skill's Step 7 template needs to require (or strongly suggest) sections for **Findings/items to address** (one-line summary of each, not just a link), **Execution sequence** (numbered steps), and **Scope alternatives** (when multiple execution depths are on the table). Current template treats these as optional and the skeleton fills cleanly without them — which is the bug. The minimum-viable-plan should still be a self-contained read.

- **/prime "Next Steps" goes stale when same-day parallel sessions wrap out of order.** Today had four parallel session wraps on 2026-05-11 (Bundle 1+2, Bundle 3, Bundle 4, Bundle 5). Bundle 4 wrapped last and ended up as the bottom entry in session-notes.md. /prime Step 1 reads "the last entry" and copies its Next Steps verbatim — but Bundle 4's Next Steps list was authored mid-execution, before the parallel Bundle 1+2 and Bundle 5 sessions wrapped. Result: /prime reported Bundles 1, 2, 5 as "deferred / remaining" when commits `f44684b`, `851a15d`, `62bf33f` had already shipped them. Operator caught it immediately ("I already did bundle 1,2,5 didn't I?"). Cost: low this time (one operator correction), but the failure mode is generalizable to any day with parallel sessions. Fix options: (a) /prime reads all entries from the current calendar day and filters Next Steps against subsequent same-day entries, or (b) /prime cross-checks each Next Steps item against `git log --oneline` since the entry's timestamp and flags items mentioned in later commits as DONE. Option (b) is more robust because parallel sessions can wrap in any order. Same family as the Apr-18 entry above (Prime git-status snapshot staleness) — /prime trusts one snapshot of state when truth may be elsewhere.

#### Write Activity

## Session — 2026-05-18 10:00

### Friction Events

- **10:00** — note this.

#### Write Activity

## Session — 2026-05-22 14:14

### Friction Events

- **14:14** — QC pass should happen automatically. In this session, /friday-act produced 8 implementation plan files (~350 lines of structured content with risk-check annotations) and committed them with no QC step — the /friday-act command spec has no /qc-pass stage. The operator had to manually ask "did you run /qc-pass?" An independent qc-reviewer then found a real defect: 4 of the items carried incorrect "Risk-check required: yes" annotations for change classes not on the canonical audit-discipline.md list. An automatic QC step in /friday-act Step 3.6 (after plan files are written, before the maintenance-observations commit) would have caught this before commit, instead of requiring an operator catch + a follow-up correction commit. Friction: multi-artifact command outputs (plan files, reports) ship without QC unless the operator remembers to ask. Trigger: /friday-act Step 3.6 plan generation.

- **14:54** — Scratchpad filename clock-skew breaks /prime resume detection. `logs/scratchpads/` filenames (e.g. `14-00`, `16-30`) are skewed ahead of real system time. /prime Step 1b selects the "most recent" scratchpad by lexical filename sort (`YYYY-MM-DD-HH-MM`), so a scratchpad written at the real time (this session: `14-44`) is out-sorted by an earlier session's scratchpad whose filename time is wrong (`16-30`). Result: /prime surfaces a stale scratchpad from an older, different session as the resume point. Observed this session (2026-05-22 journal-commands /friday-act wrap): wrote `2026-05-22-14-44-scratchpad.md`, but `2026-05-22-16-30-scratchpad.md` (from the earlier /friday-journal session) out-sorts it. This is the already-deferred scratchpad-retention work (risk-check M3 from the handoff-integration session) — now actively misrouting /prime, not just a cleanup nicety. Fix options: (a) /prime Step 1b sorts by file mtime instead of, or as a tiebreaker against, filename; (b) scratchpad filenames derive from a guaranteed-monotonic time source; (c) prune stale scratchpads so only the current one is selectable. Trigger: /prime Step 1b scratchpad detection.

#### Write Activity

## Session — 2026-05-25 09:07

### Friction Events

- **09:07** — /token-audit scope selection required 3 rounds of AskUserQuestion before the operator could name the projects to audit. Desired behavior: when invoked with no valid scope, list all available projects numbered (pulling from `projects/`) and wait for the operator to reply with one or more numbers. Single-round selection replaces the current multi-step dialogue. Operator's words: "in the future, when I invoke the command, please list me all projects that I have and I reply with a number which projects/folders I want audited." Trigger: /token-audit Step 1 scope resolution when the passed arg is not a recognized scope keyword. (context: 719b6c1)

- **09:13** — /monday-prep B7 (CLAUDE.md audit step) iterates only ACTIVE_PROJECTS — the projects/ subdirectory selection — and skips the always-loaded workspace CLAUDE.md and ai-resources/CLAUDE.md. Both are loaded into every session in this repo, so a stale or contradictory line in either has higher per-session impact than any single project CLAUDE.md. Caught by operator during 2026-W22 monday-prep diagnostics ("why isn't ai resources in the audit?"); without the catch, this Monday's mandate would have scheduled 4 project audits when 6 were warranted. Trigger: /monday-prep Step 3 Phase B B7. Fix direction: B7 needs to seed the audit candidate list with workspace CLAUDE.md and ai-resources/CLAUDE.md before iterating ACTIVE_PROJECTS — same days-since-edit and line-count rule, no skip exemption for the always-loaded layer. (context: 57258a7, Make /wrap-session leaner (booked entry 2026-04-25))

- **09:53** — /risk-check was not run on the /wrap-session leaner fix even though sub-2 was a structural reorder of operations with shared-state effects (changes when archive runs vs when session-notes.md is appended). The session-plan's Risk section framed it as "existing-command refactor below structural-change threshold" and skipped /risk-check; the operator caught this post-commit. The framing was too lenient — an existing-command edit can still trigger structural change classes when it reorders shared-state operations. The relevant class in audit-discipline.md is "automation with shared-state effects". Trigger: session-plan Risk section. Files: ai-resources/.claude/commands/wrap-session.md (commits a9d3321 + ae99d7b, both unpushed). Proposed rule: any reorder of operations touching shared state (logs, session files) should trigger /risk-check regardless of whether the command is new or existing. The existing-vs-new framing in audit-discipline.md and session-plan should be refined to add "or reorders shared-state operations" as a tripwire. (context: 5e506a6, Make /wrap-session leaner (booked entry 2026-04-25))

#### Write Activity
