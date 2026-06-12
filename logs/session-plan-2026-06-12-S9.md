# Session Plan — 2026-06-12 S9

## Intent
Execute a staleness-verified fix batch: 6 small structural fixes confirmed still-open against live file state, prioritized by recurrence severity and per-run impact.

## Model
Operating model: Opus (1M). Work is mixed deciding/doing — canonical command and agent edits with judgment on wording and contract preservation. Opus is the right tier; no switch needed.

## Source Material
- `logs/improvement-log.md` entries: "Harden session-feedback-collector to append-only" (2026-06-10, medium, weekly); "system-owner agent reports Full advisory on disk without writing" (2026-06-10, medium, weekly); "/risk-check Step 17b mandates a /consult call that can never succeed" (2026-06-09); "/resolve-improvement-log resolved-classification rule matches zero real entries" (2026-06-12); "Mid-session commit can stage a sibling session's session-notes.md content" (2026-06-09); "Pre-build environment-fit check" (2026-06-10).
- `logs/friction-log.md` 2026-06-09 S5 + 2026-06-10 S1 (collector overwrites), 2026-06-12 S8 (classification rule).
- Live-state verification done this session (S9 pre-plan): all 6 confirmed unfixed in the live files.

## Findings / Items to Address

### Item 1 — session-feedback-collector hardening
Agent toolset is `Read, Glob, Grep, Write` — no `Edit`, no `Bash`. The body says "prefer minimal append-only edits (the Edit tool)" but the agent cannot use Edit, so it falls back to whole-file `Write`. 3 failures in 3 consecutive substantive sessions: 2 destructive overwrites (improvement-log → `placeholder`; friction-log → 1-line header), 1 no-write. Fix: add `Edit` and `Bash` to the toolset; replace `Write` access guidance with an explicit append-only contract (Edit-append or Bash heredoc only; whole-file Write forbidden); keep Constraint E as the fallback guard.

### Item 2 — /risk-check Step 17b dispatch contradiction
Line 115 instructs invoking `/consult` via the Skill tool; `consult.md` carries `disable-model-invocation`, so the call is refused model-side on every run — the mandated second opinion is structurally always unavailable (17d fallback fires every time). Fix (improvement-log recommended default, Option 1): re-point 17b at the `system-owner` agent directly via the Agent tool with `subagent_type: system-owner`, same prompt template; update 17d to describe agent-dispatch failure instead of /consult failure.

### Item 3 — /consult Step 5 post-return existence check
The system-owner agent returned `**Full advisory on disk:** {path}` 3× on 2026-06-10 without writing any file. consult.md Step 5 has no verification. Fix: after the agent returns, check the file at the returned path exists; if missing, persist the returned summary to that path and note the repair in chat. (Other SO callers deferred — one consumer fixed first per DR-7; noted in the entry for Friday follow-up.)

### Item 4 — /resolve-improvement-log classification rule
Line 18 classifies resolved as strict `**Status:** applied` + `**Verified:**` — matches zero real entries; the log's de facto convention is `resolved YYYY-MM-DD` markers. S8 (today) needed full operator adjudication. Fix: widen the Resolved test to also accept entries whose Status line carries `resolved`/`RESOLVED` with a date, keeping the strict form as tier-1; document both forms in the command.

### Item 5 — wrap-owns-session-notes discipline
`commit-discipline.md` has no rule preventing mid-session commits from staging `logs/session-notes.md` when a sibling session's header is present (live contamination observed 2026-06-09 S1). Fix: add the Option-1 documented-discipline rule — mid-session commits never stage session-notes.md; it is wrap-owned.

### Item 6 — environment-fit check in /session-plan
No check exists. Fix: one short clause in session-plan.md — when the planned work product is a launch/runtime-gated executable, confirm the operator's trigger environment (VS Code extension per auto-memory) before building.

## Execution Sequence
1. Plan-time `/risk-check` on the structural set (items 1–4 are canonical command/agent edits; 5–6 are doc/command additions). One combined check — same change family, all single-file reversible edits.
2. Item 1 (highest severity, data-loss class).
3. Items 2 + 3 (consult/SO dispatch pair — adjacent surfaces, edit together).
4. Item 4.
5. Items 5 + 6 (light doc additions).
6. `/qc-pass` on the edited set.
7. Commit (explicit-path staging only; never stage improvement-log.md / improvement-log-archive.md / claim-permission.template.md — foreign uncommitted work).

## Scope Alternatives
- **Minimal:** items 1–2 only (the two with active per-run impact). Fall back here if risk-check returns RECONSIDER on the batch.
- **Chosen:** all 6 — each verified open, each small, single session.
- **Maximal (rejected):** also close mission + process inbox briefs — read-heavy, separate sessions.

## Autonomy Posture
Full autonomy after the risk-check gate. Improvement-log status flips explicitly deferred (S8 owns the file uncommitted). Stop-if: S8 commits mid-session and sweeps S9 files; any fix turning out to require improvement-log.md edits.

## Risk
Structural class present (canonical command + agent edits) → plan-time /risk-check required (Autonomy Rule 9). Collision risk with live S8 bounded: zero file overlap; explicit-path staging throughout. Items 2/3 touch the risk-check/consult dispatch surface itself — the risk-check runs BEFORE those edits, so the gate uses the current (degraded) dispatch; SO second opinion via direct agent dispatch if non-GO.
