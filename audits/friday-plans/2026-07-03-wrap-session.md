# Friday Act Plan — 2026-07-03 — wrap-session

**Source report:** friday-checkup-2026-07-03.md (quarterly tier)
**Journal report:** (none)
**Generated:** 2026-07-03
**Items:** 1

## Items

### 1. [low] /wrap-session foreign-session guard false-positives under nested-repo paths (recurring 3+ occurrences)
- **Source:** so-derived (axcion-copy-factory improvement-log, recurring 2026-06-29+)
- **Risk-check required:** yes — change class: automation with shared-state effects (canonical `/wrap-session` Step 3.5 foreign-session guard, shared session-notes/log staging)
- **W2.4 auto-draft:** no
- The Step 3.5 foreign-session pre-write guard has false-positived at least 3 times specifically when the session's working directory involves nested-repo paths (a project repo nested under the workspace, or a similar path-depth mismatch the guard's marker/header matching doesn't handle cleanly). Structural-fix candidate per the source project's own flag — investigate the specific path shapes that trigger the false-positive (likely a relative-vs-absolute path mismatch in the marker file lookup) before editing the guard logic.

## Execution notes
- Commit separately (workspace commit-behavior rules).
- Risk-check required — `/wrap-session`'s Step 3.5 guard is the primary defense against a lost-update collision on shared logs; a bad fix here could re-open that hazard class (see friction-log's extensive history of concurrent-session collision incidents on this exact guard).
- Reproduce the false-positive first (pull the specific nested-repo path shape from the axcion-copy-factory session that hit it) before changing the guard — do not fix blind.
- Run `/wrap-session` when done.
