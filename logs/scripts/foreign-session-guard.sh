#!/usr/bin/env bash
# foreign-session-guard.sh — pre-write foreign-session detector for logs/session-notes.md.
#
# Extracted verbatim from /wrap-session Step 3.5 (2026-07-04 leanness refactor) so BOTH
# wrap-session copies (ai-resources canonical + workspace-root) call ONE source instead of
# hand-syncing ~230 inline lines. This file IS the PAIRED CONTRACT — there is no longer an
# inline sibling to drift against. Consumers locate it by walking up to ai-resources/ (the
# same ancestor-walk auto-sync-shared.sh uses); it reads logs/session-notes.md relative to
# the CALLER's cwd, so it correctly guards each checkout's own notes.
#
# Emits to stdout: a single GUARD: diagnostic line, and (when FOREIGN>=1) the today-header
# and mandate-line grep output. The calling command reads that stdout and branches on
# FOREIGN / FOREIGN_CLASS / OWN_CONTENT_IN_HEAD. This script writes NO files.
#
# PAIRED CONTRACT — format dependencies (keep in sync with the writers):
#   Symmetric counterpart: /session-start Step 0.5 mtime guard (covers the /prime -> /session-start
#     window; this guard covers post-/session-start -> wrap). Both may fire on the same incident.
#   Detection signals: (1) count of `^## YYYY-MM-DD` today-headers, (2) count of `^**Mandate:**`
#     lines. These depend on conventions set by /wrap-session Step 4 (header), session-start.md
#     Step 3 (mandate line), and check-archive.sh (archive). A non-conforming today-header or
#     mandate line returns a FALSE NEGATIVE (foreign content silently clobbered) — keep formats
#     in sync with their writers. Marker lifecycle + attribution rationale: docs/session-marker.md.
#   Own-contribution attribution is marker-aware (per-id logs/.session-marker-${CLAUDE_CODE_SESSION_ID}),
#     with shared-marker fallback, NO_OWN_MARKER guard, clobber-safe recovery, and a PRIME_RAN legacy
#     path — full rationale in docs/session-marker.md. The FOREIGN_CLASS classifier
#     (CONCURRENT/REMNANT/MIXED/UNKNOWN) and the id-14 date-rollover grace window are preserved here.

# Foreign-session detector for logs/session-notes.md.
# Signals: today-header count + mandate-line count. See PAIRED CONTRACT block above for format dependencies.
TODAY=$(date '+%Y-%m-%d')

# Assignment-only capture: grep -c exits 1 on zero matches but assignments ignore exit codes.
# Then ${VAR:-0} defaults to 0 if grep produced empty output (e.g., missing file).
WT_HEADERS=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null)
WT_HEADERS=${WT_HEADERS:-0}
HEAD_HEADERS=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^## ${TODAY}")
HEAD_HEADERS=${HEAD_HEADERS:-0}

WT_MANDATES=$(grep -c "^\*\*Mandate:\*\*" logs/session-notes.md 2>/dev/null)
WT_MANDATES=${WT_MANDATES:-0}
HEAD_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^\*\*Mandate:\*\*")
HEAD_MANDATES=${HEAD_MANDATES:-0}

ADDED_HEADERS=$((WT_HEADERS - HEAD_HEADERS))
ADDED_MANDATES=$((WT_MANDATES - HEAD_MANDATES))

# Determine this session's own contribution to today-headers and today-mandate-lines.
# Two paths: marker-aware (preferred, post-Phase-2+3) and PRIME_RAN binary (legacy fallback).
# See PAIRED CONTRACT block above for the attribution rationale.
MARKER=""
MARKER_DATE=""   # date the own-marker carries — usually TODAY, but YESTERDAY for overnight (date-rollover) sessions (id-14)
# Date-rollover grace window (id-14, fix-plan 2026-06-04-1823): a session that starts before midnight
# and wraps after it carries an own-marker dated YESTERDAY. Accept it as own (not just TODAY) so the
# own-contribution subtraction below classifies this session's prior-day header+mandate correctly,
# instead of mis-flagging its own work as a REMNANT orphan. MARKER_DATE records which date matched.
YESTERDAY=$(date -v-1d "+%Y-%m-%d" 2>/dev/null || date -d "yesterday" "+%Y-%m-%d" 2>/dev/null || echo "")
# Identity oracle (Option 2′): this session's per-session-id marker file, un-clobberable by a foreign /prime.
# See docs/session-marker.md § Marker resolution. This is the payoff: the oracle is no longer the thing being clobbered.
if [ -n "${CLAUDE_CODE_SESSION_ID}" ] && [ -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" ]; then
  MARKER_LINE=$(cat "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" 2>/dev/null)
  case "${MARKER_LINE}" in
    "${TODAY} "*)                                  MARKER=$(echo "${MARKER_LINE}" | awk '{print $2}'); MARKER_DATE="${TODAY}";;
    "${YESTERDAY} "*) [ -n "${YESTERDAY}" ] && { MARKER=$(echo "${MARKER_LINE}" | awk '{print $2}'); MARKER_DATE="${YESTERDAY}"; };;
  esac
fi
# NO-OWN-MARKER guard (clobber false-negative fix, 2026-06-04 — folds with the id-14 region).
# When CLAUDE_CODE_SESSION_ID is SET but no per-id marker file exists, this session ran neither
# /prime task-selection nor /session-start, so it authored ZERO tracked headers/mandates. It must
# claim no ownership: skip BOTH the shared-marker loud fallback (below) AND the PRIME_RAN/.prime-mtime
# path (further down) — both read shared mutable state a concurrent /prime can clobber, and here it is
# foreign-owned. Without this, the loud fallback reads a clobbered shared .session-marker, counts a
# foreign header as own (OWN_HEADERS_SUBTRACT=1), and returns FOREIGN=0 — the silent false-negative
# this guard exists to prevent. Option 2′ per-id keying only protects sessions that HAVE a per-id marker.
NO_OWN_MARKER=0
if [ -n "${CLAUDE_CODE_SESSION_ID}" ] && [ ! -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" ]; then
  NO_OWN_MARKER=1
fi
# LOUD FALLBACK (OP-3): genuine old-CLI case only (CLAUDE_CODE_SESSION_ID unset). A no-own-marker session
# (var SET, per-id file absent) must NOT fall back to the clobber-vulnerable shared marker, so the fallback
# is gated on NO_OWN_MARKER=0. With the var unset, NO_OWN_MARKER is 0 and the legacy fallback runs as before.
if [ -z "${MARKER}" ] && [ -f logs/.session-marker ] && [ "${NO_OWN_MARKER}" = "0" ]; then
  echo "[wrap Step 3.5] Note: CLAUDE_CODE_SESSION_ID-keyed marker unavailable — falling back to shared logs/.session-marker (clobber-vulnerable)."
  MARKER_LINE=$(cat logs/.session-marker 2>/dev/null)
  case "${MARKER_LINE}" in
    "${TODAY} "*)                                  MARKER=$(echo "${MARKER_LINE}" | awk '{print $2}'); MARKER_DATE="${TODAY}";;
    "${YESTERDAY} "*) [ -n "${YESTERDAY}" ] && { MARKER=$(echo "${MARKER_LINE}" | awk '{print $2}'); MARKER_DATE="${YESTERDAY}"; };;
  esac
fi

# CLOBBER-SAFE OWN-MARKER RECOVERY (reader-side robustness for partial marker setup, 2026-06-05 S9 —
# improvement-log L300 guardrail-candidate; PAIRED CONTRACT). A session that wrote the shared
# logs/.session-marker but NOT its per-id logs/.session-marker-${CLAUDE_CODE_SESSION_ID} (partial setup)
# reaches here with MARKER empty and NO_OWN_MARKER=1, so the conservative elif below would claim zero
# own-contribution and false-flag its OWN header as FOREIGN. Recover the marker from the shared file — but
# ONLY when it is provably own, not a foreign clobber. Disambiguator (safe under the both-or-neither writer
# invariant in docs/session-marker.md): any COMPLIANT session that authored header SX wrote BOTH the shared
# marker AND its per-id file. So if the shared marker points to SX and NO per-id file (for ANY session)
# claims "${DATE} SX", the marker was written shared-only — the partial-setup signature of THIS session,
# not a foreign clobber (a clobber by a COMPLIANT session would have left a per-id file claiming SX). A
# matching authored header is also required, so we never recover a marker with no header behind it. On any
# non-match we fall through to the conservative claim UNCHANGED. SAFETY (precise — do not overstate): this
# recovery fires ONLY in invariant-violation space (a compliant session resolves its per-id marker above and
# never reaches here). It removes the own-partial-setup false-positive, and adds NO false-negative PROVIDED
# foreign sessions honour the both-or-neither invariant. Residual false-negative (ACCEPTED, narrower than the
# false-positive removed): a SINGLE non-compliant FOREIGN partial-setup session (wrote shared + header SX, no
# per-id) running concurrently with a genuine no-own-marker reader — the reader cannot tell that from
# own-partial-setup, so it recovers SX and zeroes the foreign delta. This is NOT eliminable reader-side
# (no per-session signal distinguishes own- from foreign-partial-setup); it is closed at the WRITER layer by
# enforcing the both-or-neither invariant so partial setup never occurs. The pre-recovery NO_OWN_MARKER
# behaviour fails safe (loud false-positive) in this same case; the recovery trades that for a fail-unsafe
# guess, justified only because the triggering state is itself an invariant violation.
if [ -z "${MARKER}" ] && [ "${NO_OWN_MARKER}" = "1" ] && [ -f logs/.session-marker ]; then
  SHARED_LINE=$(cat logs/.session-marker 2>/dev/null)
  CAND=""; CAND_DATE=""
  case "${SHARED_LINE}" in
    "${TODAY} "*)                                  CAND=$(echo "${SHARED_LINE}" | awk '{print $2}'); CAND_DATE="${TODAY}";;
    "${YESTERDAY} "*) [ -n "${YESTERDAY}" ] && { CAND=$(echo "${SHARED_LINE}" | awk '{print $2}'); CAND_DATE="${YESTERDAY}"; };;
  esac
  if [ -n "${CAND}" ]; then
    # Does any per-id marker file claim "${CAND_DATE} ${CAND}"? If yes → foreign-owned; do NOT recover.
    CLAIMED=0
    for mf in logs/.session-marker-*; do
      [ -f "${mf}" ] || continue
      if [ "$(cat "${mf}" 2>/dev/null)" = "${CAND_DATE} ${CAND}" ]; then CLAIMED=1; break; fi
    done
    # Does an authored header for the candidate actually exist? (do not recover a header-less marker)
    CAND_HDR=$(grep -c "^## ${CAND_DATE} — Session ${CAND}" logs/session-notes.md 2>/dev/null)
    CAND_HDR=${CAND_HDR:-0}
    if [ "${CLAIMED}" = "0" ] && [ "${CAND_HDR}" -ge 1 ]; then
      echo "[wrap Step 3.5] Recovered own marker ${CAND} (${CAND_DATE}) from shared logs/.session-marker — no per-id file claims it and an authored header exists, so it is partial-setup own (not a foreign clobber). Running marker-aware attribution."
      MARKER="${CAND}"; MARKER_DATE="${CAND_DATE}"
    fi
  fi
fi

if [ -n "${MARKER}" ]; then
  # Marker-aware path: count own marker-bearing headers + mandates under those headers in WT and HEAD.
  # Own headers are matched on ${MARKER_DATE} (= TODAY for same-day sessions, YESTERDAY for overnight
  # rollover sessions per the grace window above) so the own-contribution count is correct in both cases.
  OWN_WT_HEADERS=$(grep -c "^## ${MARKER_DATE} — Session ${MARKER}" logs/session-notes.md 2>/dev/null)
  OWN_WT_HEADERS=${OWN_WT_HEADERS:-0}
  OWN_HEAD_HEADERS=$(git show HEAD:logs/session-notes.md 2>/dev/null | grep -c "^## ${MARKER_DATE} — Session ${MARKER}")
  OWN_HEAD_HEADERS=${OWN_HEAD_HEADERS:-0}
  OWN_ADDED_HEADERS=$((OWN_WT_HEADERS - OWN_HEAD_HEADERS))

  OWN_WT_MANDATES=$(awk -v marker="${MARKER}" -v own_date="${MARKER_DATE}" '
    /^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ {
      in_own = ($0 ~ ("^## " own_date " — Session " marker "$"))
    }
    /^\*\*Mandate:\*\*/ && in_own { c++ }
    END { print c+0 }
  ' logs/session-notes.md 2>/dev/null)
  OWN_WT_MANDATES=${OWN_WT_MANDATES:-0}
  OWN_HEAD_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | awk -v marker="${MARKER}" -v own_date="${MARKER_DATE}" '
    /^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ {
      in_own = ($0 ~ ("^## " own_date " — Session " marker "$"))
    }
    /^\*\*Mandate:\*\*/ && in_own { c++ }
    END { print c+0 }
  ')
  OWN_HEAD_MANDATES=${OWN_HEAD_MANDATES:-0}
  OWN_ADDED_MANDATES=$((OWN_WT_MANDATES - OWN_HEAD_MANDATES))

  OWN_HEADERS_SUBTRACT=${OWN_ADDED_HEADERS}
  OWN_MANDATES_SUBTRACT=${OWN_ADDED_MANDATES}
  PRIME_RAN=0  # legacy field; not used on marker-aware path; logged as 0 for trace continuity
elif [ "${NO_OWN_MARKER}" = "1" ]; then
  # No-own-marker session (CLAUDE_CODE_SESSION_ID set, per-id file absent): ran neither /prime
  # task-selection nor /session-start, so it authored zero tracked headers/mandates. Claim no
  # ownership and SKIP the clobber-vulnerable shared .prime-mtime path entirely — all added
  # today-content is foreign and the guard must STOP. (clobber false-negative fix, 2026-06-04.)
  echo "[wrap Step 3.5] No own per-id marker (CLAUDE_CODE_SESSION_ID set, no logs/.session-marker-* file) — this session authored no tracked headers; claiming zero own-contribution."
  PRIME_RAN=0
  OWN_HEADERS_SUBTRACT=0
  OWN_MANDATES_SUBTRACT=0
else
  # Legacy PRIME_RAN binary path: marker absent AND no-own-marker not in force — i.e. old CLI with
  # CLAUDE_CODE_SESSION_ID unset (workspace-root, pre-Phase-2 session).
  # Uses the `logs/.prime-mtime` marker that /prime Step 8a/8b/8c writes after appending today's header.
  PRIME_RAN=0
  if [ -f logs/.prime-mtime ]; then
    MTIME_MARKER=$(cat logs/.prime-mtime 2>/dev/null | tr -dc '0-9')
    MTIME_MARKER=${MTIME_MARKER:-0}
    TODAY_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TODAY} 00:00:00" "+%s" 2>/dev/null \
      || date -d "${TODAY} 00:00:00" "+%s" 2>/dev/null \
      || echo 0)
    # Marker mtime ≥ today-midnight → /prime ran this session today.
    if [ -n "${MTIME_MARKER}" ] && [ "${MTIME_MARKER}" -ge "${TODAY_EPOCH}" ] 2>/dev/null; then
      PRIME_RAN=1
    fi
  fi
  OWN_HEADERS_SUBTRACT=${PRIME_RAN}
  OWN_MANDATES_SUBTRACT=${PRIME_RAN}
fi

# If EITHER signal indicates content beyond OWN_*_SUBTRACT, STOP.
FOREIGN_HEADERS=$((ADDED_HEADERS - OWN_HEADERS_SUBTRACT))
FOREIGN_MANDATES=$((ADDED_MANDATES - OWN_MANDATES_SUBTRACT))
FOREIGN=${FOREIGN_HEADERS}
if [ "${FOREIGN_MANDATES}" -gt "${FOREIGN}" ]; then
  FOREIGN=${FOREIGN_MANDATES}
fi

# FOREIGN<0 discriminator: distinguishes the common mid-session-commit case (this session's
# today-header + mandate were shipped to HEAD by an intermediate commit) from genuinely odd
# FOREIGN<0 states (plan-mode /prime, manual prune, skipped /session-start). Used by the
# Step 3 edge-case interpretation below to silence the common case.
OWN_CONTENT_IN_HEAD=0
if [ "${HEAD_HEADERS}" -ge 1 ] && [ "${HEAD_MANDATES}" -ge 1 ]; then
  OWN_CONTENT_IN_HEAD=1
fi

# Classify FOREIGN by enclosure-date of mandates (id-32, 2026-05-28).
# Walks awk over WT + HEAD, tracks each mandate's enclosing `^## YYYY-MM-DD` header, counts by today vs prior-day.
# CONCURRENT = today-extras only (parallel terminal); REMNANT = prior-day-extras only (orphan from a prior session that ran /prime + /session-start but never /wrap-session); MIXED = both; UNKNOWN = neither (FOREIGN by header-count only — STOP with the neutral classify-manually branch below; do NOT emit CONCURRENT-shape remediation).
FOREIGN_CLASS="UNKNOWN"
if [ "${FOREIGN}" -ge 1 ]; then
  WT_TODAY_MANDATES=$(awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d==today {c++} END{print c+0}' logs/session-notes.md 2>/dev/null)
  WT_TODAY_MANDATES=${WT_TODAY_MANDATES:-0}
  WT_PRIOR_MANDATES=$(awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d!=today && d!="" {c++} END{print c+0}' logs/session-notes.md 2>/dev/null)
  WT_PRIOR_MANDATES=${WT_PRIOR_MANDATES:-0}
  HEAD_TODAY_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d==today {c++} END{print c+0}')
  HEAD_TODAY_MANDATES=${HEAD_TODAY_MANDATES:-0}
  HEAD_PRIOR_MANDATES=$(git show HEAD:logs/session-notes.md 2>/dev/null | awk -v today="${TODAY}" '/^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{match($0,/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/);d=substr($0,RSTART,RLENGTH)} /^\*\*Mandate:\*\*/ && d!=today && d!="" {c++} END{print c+0}')
  HEAD_PRIOR_MANDATES=${HEAD_PRIOR_MANDATES:-0}
  # The own-contribution subtractor goes in the bucket matching MARKER_DATE: the today bucket for
  # same-day sessions, the prior bucket for overnight (date-rollover) sessions whose own header+mandate
  # are dated YESTERDAY (id-14). Without the conditional, a rollover session running concurrently with a
  # genuine foreign today-session would leave its own prior-day mandate in EXTRA_PRIOR and mis-add a
  # REMNANT component to the classification.
  if [ -n "${MARKER_DATE}" ] && [ "${MARKER_DATE}" != "${TODAY}" ]; then
    EXTRA_TODAY_MANDATES=$((WT_TODAY_MANDATES - HEAD_TODAY_MANDATES))
    EXTRA_PRIOR_MANDATES=$((WT_PRIOR_MANDATES - HEAD_PRIOR_MANDATES - OWN_MANDATES_SUBTRACT))
  else
    EXTRA_TODAY_MANDATES=$((WT_TODAY_MANDATES - HEAD_TODAY_MANDATES - OWN_MANDATES_SUBTRACT))
    EXTRA_PRIOR_MANDATES=$((WT_PRIOR_MANDATES - HEAD_PRIOR_MANDATES))
  fi
  if [ "${EXTRA_TODAY_MANDATES}" -ge 1 ] && [ "${EXTRA_PRIOR_MANDATES}" -ge 1 ]; then
    FOREIGN_CLASS="MIXED"
  elif [ "${EXTRA_TODAY_MANDATES}" -ge 1 ]; then
    FOREIGN_CLASS="CONCURRENT"
  elif [ "${EXTRA_PRIOR_MANDATES}" -ge 1 ]; then
    FOREIGN_CLASS="REMNANT"
  fi
fi

echo "GUARD: headers WT=${WT_HEADERS} HEAD=${HEAD_HEADERS} added=${ADDED_HEADERS} | mandates WT=${WT_MANDATES} HEAD=${HEAD_MANDATES} added=${ADDED_MANDATES} | MARKER=${MARKER:-none} OWN_HEADERS_SUBTRACT=${OWN_HEADERS_SUBTRACT} OWN_MANDATES_SUBTRACT=${OWN_MANDATES_SUBTRACT} PRIME_RAN=${PRIME_RAN} FOREIGN=${FOREIGN} FOREIGN_CLASS=${FOREIGN_CLASS} OWN_CONTENT_IN_HEAD=${OWN_CONTENT_IN_HEAD} EXTRA_TODAY_MANDATES=${EXTRA_TODAY_MANDATES:-0} EXTRA_PRIOR_MANDATES=${EXTRA_PRIOR_MANDATES:-0}"
if [ "${FOREIGN}" -ge 1 ]; then
  echo "--- Today-headers in working tree ---"
  grep -n "^## ${TODAY}" logs/session-notes.md 2>/dev/null
  echo "--- Mandate lines in working tree ---"
  grep -n "^\*\*Mandate:\*\*" logs/session-notes.md 2>/dev/null
fi
