# Session Plan — 2026-06-05 S9

## Intent
Make the `wrap-session.md` Step 3.5 NO_OWN_MARKER attribution branch robust to **partial marker setup** (a session that wrote the shared `logs/.session-marker` but not its per-id `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` file), so its own session-notes header is attributed to it instead of being false-flagged FOREIGN — **without** weakening the clobber-false-negative protection the NO_OWN_MARKER guard exists to provide.

## Model
opus — deciding work: subtle, safety-critical guard logic on a shared attribution path. Active model `claude-opus-4-8[1m]` — **match**, no `/model` switch.

## Source Material
- `logs/improvement-log.md` L300–306 — the canonical guardrail-candidate (Status: PARTIAL 2026-06-05 S8; writer-side both-or-neither invariant shipped; reader-side robustness fix deferred, needs `/risk-check`, touches both paired copies).
- `ai-resources/.claude/commands/wrap-session.md` L82–161 — the marker-resolution + NO_OWN_MARKER branch (canonical copy).
- `.claude/commands/wrap-session.md` (workspace-root paired copy) — same logic, condensed comments.
- `docs/session-marker.md` — both-or-neither writer invariant (BLOCKING, S8); the reader-side complement to document.
- `logs/friction-log.md` (S6 entry) — the near-miss that generated the candidate.

## Findings / Items to Address
- **Current behavior (L106–108, L153–161):** `NO_OWN_MARKER=1` whenever `CLAUDE_CODE_SESSION_ID` is set AND the per-id marker file is absent. On that path the guard claims zero own-contribution (`OWN_*_SUBTRACT=0`), so any added today-header/mandate counts as FOREIGN → STOP.
- **The false-positive:** a session that *did* author its header but wrote only the shared marker (partial setup) hits NO_OWN_MARKER=1 and gets its own header flagged FOREIGN. Observed as a near-miss at S6 and S8 wrap (caught by manual FOREIGN=0 verification).
- **Why a naive fix is unsafe:** simply trusting the shared `.session-marker` (the improvement-log proposal's literal wording) is clobber-vulnerable — a concurrent `/prime` overwrites the shared marker with its own SX and authors a foreign `## TODAY — Session SX` header, so a naive grep would subtract foreign content as own → the exact silent false-negative NO_OWN_MARKER was built to prevent.
- **The clobber-safe disambiguator:** under the both-or-neither writer invariant (now BLOCKING), any *compliant* session that authored header SX wrote BOTH the shared marker AND its per-id marker file. So:
  - foreign clobber → some `logs/.session-marker-<foreign-id>` file claims SX → do NOT recover (stay conservative).
  - own partial-setup → no per-id file anywhere claims SX → safe to recover and attribute as own.
  - Residual (out of scope, documented): two *non-compliant* partial-setup sessions claiming the same SX — requires a double invariant-violation; strictly narrower than today's false-positive surface.

## Execution Sequence
1. **Insert the recovery block** into the canonical copy, placed after the loud-fallback block (L120) and before `if [ -n "${MARKER}" ]` (L122). Logic: when `MARKER` is still empty AND `NO_OWN_MARKER=1`, read the shared `.session-marker`; if it is dated TODAY/YESTERDAY and points to SX, scan all `logs/.session-marker-*` per-id files — if NONE claims `${DATE} SX` AND a `## ${DATE} — Session SX` header exists, set `MARKER`/`MARKER_DATE` (which routes into the existing marker-aware counting path). Otherwise fall through to the existing zero-claim.
2. **Mirror the identical shell logic** into the workspace-root paired copy, matching that copy's condensed comment style (PAIRED CONTRACT = logic byte-identical, comments may differ).
3. **Dry-run harness** (scratch script, not committed): exercise both scenarios against synthetic `.session-marker` / per-id / session-notes fixtures — (a) partial-setup own → recovers, FOREIGN=0; (b) foreign-clobber → does NOT recover, FOREIGN≥1. Confirm the existing genuine-no-contribution case still claims zero.
4. **Verify byte-identity** of the executable lines between the two copies after the edit (the only permitted divergence is comments).
5. **One-line reader-side note** in `docs/session-marker.md` next to the both-or-neither invariant (the reader cross-checks per-id claims before recovering).
6. **`/qc-pass`** on the guard edit (independent review of the shell logic + scenario coverage).
7. **`/risk-check`** — structural class (paired safety-guard edit). Plan-time gate per Autonomy Rule 9.
8. **Flip improvement-log L300** PARTIAL → applied, recording the clobber-safe-recovery design and the documented residual.
9. **Commit** (no push — batched to wrap).

## Scope Alternatives
- **Minimal (chosen):** clobber-safe recovery in the two paired copies + doc note + status flip.
- **Lighter:** document the writer invariant only and leave the reader conservative (status quo) — rejected: the false-positive recurs every partial-setup session and the operator picked the reader-side fix.
- **Heavier:** also build the wrap-lite remediation path (let a no-own-marker CONCURRENT session complete its wrap without staging session-notes) — out of scope; separate improvement-log entry; not picked.

## Autonomy Posture
Gated — structural change class (paired safety-guard logic edit). `/risk-check` runs before landing. Commit direct, no push (batched to wrap).

## Risk
- **Primary risk:** the recovery reintroduces a silent false-negative (foreign content shipped under own commit). Mitigated by the per-id-claim cross-scan, which is provably safe under the BLOCKING both-or-neither invariant, and by the Stage-3 dry-run that explicitly tests the foreign-clobber scenario. **Stop-if:** dry-run shows any false-negative → revert to conservative claim-zero.
- **Paired-copy drift:** mitigated by Stage-4 byte-identity check on executable lines.
- **Blast radius:** 2 real files edited; ~17 project copies inherit via symlink; 1 workflow variant lacks the guard (untouched). Inventory verified this session.
