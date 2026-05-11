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

#### Write Activity
