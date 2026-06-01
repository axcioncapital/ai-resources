# Option 2 marker fix — redesign (Option 2′): key the marker by `CLAUDE_CODE_SESSION_ID`

**Date:** 2026-06-01 (S3, Wave 4)
**Status:** GO-ELIGIBLE SPEC — plan-time `/risk-check` = PROCEED-WITH-CAUTION (`audits/risk-checks/2026-06-01-option2-marker-redesign-claude-session-id-keyed.md`); system-owner second opinion concurs. Implementation deferred to a fresh dedicated session (see § Completion criteria). Both reviewers advised against implementing in this already-loaded multi-wave session.
**Supersedes:** the improvement-log "Option 2" mechanism (`CLAUDE_SESSION_MARKER` env var set at /prime), which is **infeasible** (proven below).

## Completion criteria (fold these into the implementation session — from risk-check mitigations M1–M3 + system-owner refinements)

1. **Atomic single commit** across all writer/guard consumers + the doc, with a **per-consumer edit manifest** written before the first edit (mechanical antidote to the repeat consumer-undercount defect). A half-landed contract is the worst outcome (`risk-topology § 5` drift). Any context pressure mid-edit → hard stop + revert, never a half-commit.
2. **Edit set (corrected):** the 3 writers (`prime.md`, `session-start.md` Step 3, `session-plan.md`), `wrap-session.md` Step 3.5 guard, the canonical `docs/session-marker.md`, AND the **workspace-root `.claude/commands/wrap-session.md` Phase 3 sibling** (PAIRED CONTRACT — must move in lockstep). **DROP `session-start.md` Step 0.5 from scope** — it reads `.prime-mtime`, not `.session-marker`, so it is not part of this oracle (system-owner correction).
3. **Keep the shared `logs/.session-marker` file in addition to, not instead of,** the per-id files at v1 — removal is a separable later change (`DR-7`/`AP-7`). The shared file still serves the `S{N}` increment lookup; the per-id file becomes the identity oracle.
4. **Document the harness-var dependency** in `docs/session-marker.md`: record the two assumed properties (stable-within-session, distinct-across-sessions), and flag a **CLI upgrade as a re-verify event** (`OP-11`). This crosses the deliberately-held `OP-10` harness boundary — the loud fallback bounds *absence* of the var, NOT *changed meaning* (e.g., `/compact` resume re-keying), so resume re-keying must be documented as an expected loud-fallback path.
5. `.gitignore`: add `logs/.session-marker-*`.
6. Orphan-file cleanup: prune `logs/.session-marker-*` not dated today, at `/prime`.

---

## The finding that forces a redesign

The improvement-log specced Option 2 as: *"session-scoped marker via env var `CLAUDE_SESSION_MARKER` set at /prime."* This cannot work:

- **Probe (2026-06-01, S3):** `export PROBE_MARKER_TEST=...` in one Bash tool call → read in the next Bash tool call → **empty.** The Bash tool's own description confirms it: *"Shell state (env vars, functions) does not persist; the shell is initialized from the user's profile."* Each tool call is a fresh shell. A var `/prime` exports is gone before `/session-start` (let alone `/wrap-session`) runs.
- So a self-set env var has the *same* fatal property as the rejected Option 1: it looks like a fix on paper but does nothing at runtime. Shipping it would reproduce the Option-1 failure.

**But the harness already provides what we need.** Every Bash tool call's environment contains, injected by Claude Code itself:

- `CLAUDE_CODE_SESSION_ID` — e.g. `ff905513-46d9-46dc-baa8-7f9574f02b1c`. **Probed stable across separate Bash calls in the same session.** Unique per session → distinct across concurrent sessions. Not a file → cannot be clobbered by a foreign `/prime`. This is the clean identity oracle Option 2 wanted; it exists already.
- `$PPID` of the Bash shell = the `native-binary/claude` CLI process (also stable per session) — a fallback signal, but `CLAUDE_CODE_SESSION_ID` is cleaner (a string id, not a recyclable pid).

## Option 2′ — the design

**Core idea:** stop using the shared-mutable `logs/.session-marker` as the *identity oracle*. Key each session's marker state by `CLAUDE_CODE_SESSION_ID`, which no other session can overwrite.

### Marker write (at `/prime`)
Write a **per-session-id marker file** in addition to (or instead of) the shared one:

```
logs/.session-marker-${CLAUDE_CODE_SESSION_ID}   # contains: "{YYYY-MM-DD} S{N}"
```

A concurrent `/prime` in another session writes a *different* file (different session id) — no clobber. The shared `logs/.session-marker` MAY be retained for the same-day `S{N}` increment lookup (read newest across sibling files) and for back-compat, but it is no longer the identity oracle.

### Marker read (canonical resolution, all consumers)
```bash
TODAY=$(date '+%Y-%m-%d')
MARKER=""
if [ -n "$CLAUDE_CODE_SESSION_ID" ] && [ -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" ]; then
  CONTENT=$(cat "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}")
  [ "${CONTENT%% *}" = "$TODAY" ] && MARKER="${CONTENT##* }"
fi
# LOUD FALLBACK (OP-3): harness var absent (older CLI) OR per-session file missing
if [ -z "$MARKER" ]; then
  echo "[marker] Note: CLAUDE_CODE_SESSION_ID-keyed marker unavailable — falling back to shared logs/.session-marker (clobber-vulnerable)."
  # ... existing shared-file resolution block ...
fi
```

### `/wrap-session` Step 3.5 guard — the payoff
The guard reads **its own** `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` to learn its true marker, instead of the clobberable shared file. In the original incident (S9's /prime clobbered shared `.session-marker` from S8→S9), the S8 session's per-id file `.session-marker-${S8_ID}` is untouched, so the guard correctly knows it is S8 and attributes the S9 header as foreign. **The silent false-negative cannot occur** — the oracle is no longer the thing being clobbered.

### `S{N}` increment (same-day re-invocation)
`/prime` still needs to compute `S{N}`. Read the max `S{N}` across all sibling `logs/.session-marker-*` files dated today (not just one shared file), then this session's N = max+1. Concurrent same-day `/prime`s could still race on the *number* (both compute S2) — but that is a benign cosmetic collision (two sessions labeled S2) that does NOT corrupt identity, because each still owns its session-id-keyed file and its own header is disambiguated by id, not by N. (Optional hardening: append `-${SHORT_ID}` to the header, but the marker file already disambiguates.)

## Edge cases / risks to weigh at `/risk-check`
1. **Harness-version dependency.** `CLAUDE_CODE_SESSION_ID` verified **live via env probe (2026-06-01)** in the running CLI. Version provenance to confirm at implementation: the VS Code extension path shows `2.1.156` but the risk-check `claude --version` probe reported `2.1.114` — the var is live regardless; the discrepancy is extension-vs-CLI versioning, not a feasibility concern. If a future/older CLI lacks it, the loud fallback (OP-3) restores current behavior with a visible notice — no silent regression. **Must verify the var is contractual, not incidental** (it crosses the `OP-10` harness boundary, governed separately — treat CLI upgrade as a re-verify event).
2. **Subagent environment.** The writers (`/prime`, `/session-start`, `/session-plan`) and the wrap guard all run in the **main session**, so the main-session id is what matters — confirmed available there. Whether subagents inherit the same id is irrelevant to this path but should be noted.
3. **`/compact` / session resume.** If a resumed session gets a new `CLAUDE_CODE_SESSION_ID`, its earlier per-id marker file is orphaned and resolution falls to the loud fallback. Acceptable (degrades to today's behavior, loudly), but document it.
4. **Orphan-file accumulation.** `.session-marker-${id}` files accumulate (one per session). Need a cleanup: prune `.session-marker-*` older than today at `/prime`, or gitignore + periodic sweep. Low harm (small files, gitignored).
5. **Blast radius:** 3 writers + wrap guard + session-start Step 0.5 + the canonical contract doc + the 5 read-only auxiliary consumers' resolution block (if they re-derive) = the 9 consumers in `docs/session-marker.md`. The read-only auxiliary consumers mostly use the `session-plan-*` glob (no marker resolution), so the real code change concentrates in the 3 writers + wrap guard + session-start guard + the doc.
6. **`.gitignore`:** add `logs/.session-marker-*` (per-machine, per-session state — same class as `.session-marker`).

## Recommendation
Option 2′ is feasible and closes the root cause cleanly. It is a **different and more delicate design than the improvement-log assumed** — harness-var dependency + orphan cleanup + the loud fallback are all new considerations. This warrants the plan-time `/risk-check` the mandate already gates it behind, and — given it lands across the marker contract's 9-consumer surface — careful implementation. If context is constrained at risk-check time, landing this as a GO-verdict design spec for a fresh implementation session is the responsible path (per the S2 "validate before invest" lesson and `Context constraint deferral`).
