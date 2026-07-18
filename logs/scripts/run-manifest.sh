#!/usr/bin/env bash
# run-manifest.sh — durable per-session run manifest (W3.2 roadmap item R3, Pass 1)
#
# WHAT THIS IS
#   One JSON record per substantive session at `logs/runs/{date}-{marker}.json`.
#   Schema authority: `ai-resources/docs/spine-schemas.md` § 1 (R1 kernel doc).
#   Do NOT fork or restate the schema here — this script implements it, it does not define it.
#
# WHY IT EXISTS
#   Red-team case 6: a session that dies before wrap leaves zero durable trace. The
#   continuity scratchpad (`/wrap-session` Step 0.5) is written AT wrap, so it cannot
#   cover a crash before wrap. The START-STUB — written at mandate confirmation — is the
#   piece that closes that gap. It is the load-bearing 10% of R3.
#
# THE ADVISORY RULE (load-bearing — do not "harden" this into a blocker)
#   An ABSENT manifest is NOT an error. Sessions legitimately skip mandate confirmation
#   (`/friday-checkup` started directly, `/clear`-resumed sessions, trivial wraps), so
#   "manifest absent at wrap" is a ROUTINE path, not an edge case. `validate` therefore
#   exits 0 on absent and says so. Only a manifest that EXISTS and is MALFORMED aborts
#   loudly (non-zero). Rationale: `principles.md § OP-5` (advisory vs enforcement authority)
#   and § OP-3 ("loud failure over silent continuation" means loud SURFACING, not blocking a
#   legitimate operation). Enforcement may be revisited only once R4/M-D2 actually read this
#   substrate — today nothing does.
#
# SUBCOMMANDS
#   start     Write the start-stub (idempotent — never clobbers an existing manifest).
#   update    Merge fields into an existing manifest. `--file` appends to files_changed,
#             de-duplicated, so files_changed is maintained RUNNING, not wrap-only.
#   close     Finalize: set stop_reason / outcome / failure_class, then validate.
#             Absent manifest → writes a wrap-time stub first, emits an advisory, never aborts.
#   validate  Schema check. absent → exit 0 (advisory). malformed → exit 1 (loud).
#   dir       Echo the resolved runs directory (for callers that need the path).
#
# PATH RESOLUTION
#   Manifests live under the CALLER's checkout, same convention as the other log scripts:
#   `${CLAUDE_PROJECT_DIR:-$(pwd)}/logs/runs/`. Override with `--runs-dir`.
#
# Two-end contract: `/session-start` Step 3 and `/prime` Step 8c.7 call `start`;
# `/wrap-session` calls `close`. Consumers R4 / M-D2 will read these files once they land.

set -uo pipefail

# ---------------------------------------------------------------- self-location
# Resolve THIS script's real directory, following symlinks. `dirname "$0"` is NOT
# enough: bash does not resolve the link when populating $0, so invoking this script
# through a symlink yields the *symlink's* directory, the sibling decision_ref_slug.py
# lookup misses, and a --decision-ref-from-header ref is silently DROPPED. That was a
# real, reproduced failure (end-time /risk-check, 2026-07-12 — Dimension 5). The repo
# already symlinks shared scripts across projects, so this is a live shape, not a
# hypothetical. `readlink -f` is unavailable on macOS, hence the portable loop.
_SELF="${BASH_SOURCE[0]}"
while [ -L "$_SELF" ]; do
  _SELF_DIR="$(cd -P "$(dirname "$_SELF")" && pwd)"
  _SELF="$(readlink "$_SELF")"
  case "$_SELF" in
    /*) ;;                       # absolute target — take as-is
    *)  _SELF="$_SELF_DIR/$_SELF" ;;   # relative target — resolve against the link's dir
  esac
done
SCRIPT_DIR="$(cd -P "$(dirname "$_SELF")" && pwd)"

SCRIPT_NAME="run-manifest.sh"

# ---------------------------------------------------------------- schema (mirrors spine-schemas.md §1)
# Kept as data, not prose, so `validate` and the docs cannot drift apart silently.
REQUIRED_KEYS="run_id project date marker model mandate_ref files_changed overrides failure_class validation outcome stop_reason"
LANES="fast standard complex"
STOP_REASONS="completed deferred blocked cap-hit compaction crash"
OUTCOMES="DELIVERED PARTIAL ABANDONED"
LEVELS="mechanical functional mandate independent real-world"
# Closed set, 11 values — spine-schemas.md § 5. Do not add a 12th without updating every consumer.
FAILURE_CLASSES="mandate-drift unsupported-inference generic-output weak-prioritization false-completeness context-omission instruction-conflict excessive-complexity tool-misuse evaluation-blind-spot confidentiality-disclosure"

die()  { printf '%s: %s\n' "$SCRIPT_NAME" "$*" >&2; exit 2; }
note() { printf 'MANIFEST: %s\n' "$*"; }

need_python() {
  command -v python3 >/dev/null 2>&1 || die "python3 not found — required for JSON handling."
}

# ---------------------------------------------------------------- arg parsing
SUBCMD="${1:-}"
[ -n "$SUBCMD" ] || die "usage: $SCRIPT_NAME {start|update|close|validate|dir} [--date D --marker M ...]"
shift || true

DATE=""; MARKER=""; RUNS_DIR=""
PROJECT=""; MODEL=""; MANDATE_REF=""; MISSION=""; LANE=""; PACK_PATH=""
OUTCOME=""; STOP_REASON=""; FAILURE_CLASS=""; INCIDENT_WAIVED=""
FILES=(); DECISION_REFS=(); SKILLS=(); VALIDATIONS=(); OVERRIDES=()

while [ $# -gt 0 ]; do
  case "$1" in
    --date)           DATE="${2:-}"; shift 2 ;;
    --marker)         MARKER="${2:-}"; shift 2 ;;
    --runs-dir)       RUNS_DIR="${2:-}"; shift 2 ;;
    --project)        PROJECT="${2:-}"; shift 2 ;;
    --model)          MODEL="${2:-}"; shift 2 ;;
    --mandate-ref)    MANDATE_REF="${2:-}"; shift 2 ;;
    --mission)        MISSION="${2:-}"; shift 2 ;;
    --lane)           LANE="${2:-}"; shift 2 ;;
    --pack-path)      PACK_PATH="${2:-}"; shift 2 ;;
    --outcome)        OUTCOME="${2:-}"; shift 2 ;;
    --stop-reason)    STOP_REASON="${2:-}"; shift 2 ;;
    --failure-class)  FAILURE_CLASS="${2:-}"; shift 2 ;;
    --incident-waived) INCIDENT_WAIVED="${2:-}"; shift 2 ;;
    --file)           FILES+=("${2:-}"); shift 2 ;;
    --decision-ref)   DECISION_REFS+=("${2:-}"); shift 2 ;;
    # PREFERRED over --decision-ref: pass the decision's header line from decisions.md
    # VERBATIM and the slug is derived in code. Never hand-derive a slug — of the three
    # refs hand-authored before this flag existed, three were orphans (see
    # logs/scripts/decision_ref_slug.py for why this flag exists at all).
    --decision-ref-from-header)
                      _hdr="${2:-}"
                      if [ -n "$_hdr" ]; then
                        _slug="$(python3 "${SCRIPT_DIR}/decision_ref_slug.py" "$_hdr" 2>/dev/null)"
                        if [ -n "$_slug" ]; then
                          DECISION_REFS+=("logs/decisions.md#${_slug}")
                        else
                          # Advisory, never fatal (§ OP-5): a slug we cannot derive is a
                          # dropped ref, not a failed wrap. Say so loudly; do not guess.
                          note "could not derive a slug from header: ${_hdr} — ref DROPPED (advisory)."
                        fi
                      fi
                      shift 2 ;;
    --skill)          SKILLS+=("${2:-}"); shift 2 ;;
    # --validation "output|level"  e.g. --validation "run-manifest.sh|functional"
    --validation)     VALIDATIONS+=("${2:-}"); shift 2 ;;
    # --override "gate|reason"
    --override)       OVERRIDES+=("${2:-}"); shift 2 ;;
    -h|--help)        sed -n '2,40p' "$0"; exit 0 ;;
    *)                die "unknown argument: $1" ;;
  esac
done

# ---------------------------------------------------------------- paths
if [ -z "$RUNS_DIR" ]; then
  RUNS_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/logs/runs"
fi

if [ "$SUBCMD" = "dir" ]; then
  printf '%s\n' "$RUNS_DIR"
  exit 0
fi

# ---------------------------------------------------------------- self-resolving date + marker
# WHY THIS EXISTS (do not "simplify" it back to required flags):
#   The callers are slash-COMMANDS — instructions to a model, not shell scripts. Each Bash
#   invocation gets a FRESH shell (env vars do not persist between tool calls), so a caller
#   writing `--marker "${MARKER}"` would expand it to the EMPTY STRING and the start-stub would
#   never be written — silently killing the one thing R3 exists to do. Rather than trusting every
#   caller to paste the right literal, the script resolves date and marker itself, from the same
#   oracle `/prime` and `/wrap-session` already use (`docs/session-marker.md` § Marker resolution).
#   An explicit --date / --marker still wins, so the tests and any future caller can pin them.
#
#   ⚠ ONE DELIBERATE DIVERGENCE FROM THAT DOC (2026-07-18) — stated here because it is the kind of
#   silent drift this repo keeps paying for. `docs/session-marker.md` describes resolution as
#   TODAY-DATED ONLY. That still holds for the SHARED marker file, but NOT for the per-session-id
#   marker, which this script now trusts regardless of date so a session wrapping after midnight can
#   close its own stub instead of dying. The marker grammar and lifecycle are untouched; this is a
#   consumer-side staleness policy. Full rationale at the CROSS-MIDNIGHT block below.
MARKER_SRC="flag"
DATE_SRC="flag"
if [ -z "$DATE" ]; then
  DATE="$(date '+%Y-%m-%d')"
  DATE_SRC="today"
fi
LOGS_DIR="$(dirname "$RUNS_DIR")"
PERID_MARKER_FILE="${LOGS_DIR}/.session-marker-${CLAUDE_CODE_SESSION_ID:-__unset__}"

# ------------------------------------------------------------------ CROSS-MIDNIGHT CLOSE (2026-07-18)
# THE TWO MARKER SOURCES ARE NOT INTERCHANGEABLE, AND THIS BLOCK IS WHERE THAT STOPS BEING IMPLICIT.
#
#   Per-id  (`.session-marker-$CLAUDE_CODE_SESSION_ID`) — trusted REGARDLESS OF DATE.
#   Shared  (`.session-marker`)                         — trusted ONLY when dated today. Unchanged.
#
# WHY THE PER-ID RELAXATION IS SAFE, AND WHY THE SHARED ONE WOULD NOT BE. Attribution here rests on
#   the FILENAME, not on the date: no other session can write a file named after this session's id,
#   so a per-id marker is ours whatever day it was written. The shared file carries no such proof —
#   `/prime` allocates at its Step 8, which a `/clarify`-first session never reaches, leaving the
#   PREVIOUS session's marker in place at the same date. That is the S4-8c3 incident (2026-07-18,
#   `logs/improvement-log.md`), and the guard at the `MARKER_SRC = .session-marker` branch below is
#   its fix. Relaxing the date on the SHARED path would re-open it exactly; relaxing it on the
#   per-id path cannot, because the date was never what made that path trustworthy.
#
# WHAT WAS BROKEN. `DATE` was re-derived from `date` on EVERY invocation, and BOTH markers were
#   accepted only when prefixed with that fresh date. So a session that started at 23:50 and wrapped
#   at 00:10 had a valid per-id marker dated yesterday, matched nothing, and hit `die` — exit 2,
#   mid-wrap, with its start-stub stranded at `outcome: null` permanently. With `--marker` pinned but
#   `--date` omitted it was worse but quieter: a SECOND manifest under today's date while the real
#   one stayed null. Both reproduced in a sandbox before this fix; both covered by
#   `run-manifest.test.sh` § CROSS-MIDNIGHT, which fails against the pre-fix script.
#
# TRUST IS UNBOUNDED, DELIBERATELY — do not "harden" this with an N-day window.
#   The originating log entry floated bounding it to ~1 day. Rejected on purpose: safety comes from
#   the filename, so a window adds no attribution strength, and ANY boundary just reintroduces this
#   same bug for a session that spans it — a 3-day session is unusual, not wrong. A window would be
#   the appearance of rigour paying for a fresh instance of the defect being fixed here.
#
# DEGRADES SAFE. No `CLAUDE_CODE_SESSION_ID` (older CLI) → no per-id file can be identified → this
#   block is inert and the shared today-only path below behaves exactly as it always did.
#
# NOTE FOR `docs/session-marker.md` READERS: the marker GRAMMAR and lifecycle are untouched. This is
#   a consumer-side staleness policy, and it is a deliberate, documented divergence from the
#   "today-dated only" resolution pattern that doc describes — see the header note above.
PERID_DATE=""; PERID_MARK=""
if [ -n "${CLAUDE_CODE_SESSION_ID:-}" ] && [ -f "$PERID_MARKER_FILE" ]; then
  _pl="$(cat "$PERID_MARKER_FILE" 2>/dev/null)"
  # Shape-check before trusting: "YYYY-MM-DD <marker>". A malformed line is ignored, not guessed at.
  case "$_pl" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\ ?*)
      PERID_DATE="${_pl%% *}"; PERID_MARK="${_pl#* }" ;;
  esac
fi

# (1) No --marker: adopt this session's own marker AND the date it was allocated under.
if [ -z "$MARKER" ] && [ -n "$PERID_MARK" ]; then
  MARKER="$PERID_MARK"
  MARKER_SRC="$(basename "$PERID_MARKER_FILE")"
  if [ "$DATE_SRC" = "today" ]; then DATE="$PERID_DATE"; DATE_SRC="per-id-marker"; fi
fi

# (2) --marker pinned but --date omitted: take the date from this session's own marker when it names
#     the SAME marker. Without this, a pinned-marker wrap forks a second manifest across midnight.
#     The equality test is what keeps it attributable — an unrelated pinned marker is left alone.
if [ "$DATE_SRC" = "today" ] && [ -n "$PERID_MARK" ] && [ "$MARKER" = "$PERID_MARK" ]; then
  DATE="$PERID_DATE"; DATE_SRC="per-id-marker"
fi

# (3) Shared marker — TODAY-ONLY. Deliberately unchanged; see the rationale above.
if [ -z "$MARKER" ]; then
  _shared="${LOGS_DIR}/.session-marker"
  if [ -f "$_shared" ]; then
    line="$(cat "$_shared" 2>/dev/null)"
    case "$line" in
      "${DATE} "*) MARKER="${line#* }"; MARKER_SRC=".session-marker" ;;
    esac
  fi
fi
if [ -z "$MARKER" ]; then
  die "could not resolve the session marker (no --marker; no per-id marker at ${PERID_MARKER_FILE}; and no today-dated ${LOGS_DIR}/.session-marker). Run /prime to seed the marker, or pass --marker explicitly."
fi

# ----------------------------------------------- session-identity cross-check (added 2026-07-18)
# WHY: the shared `logs/.session-marker` is a VALID-LOOKING ORACLE THAT CAN POINT AT ANOTHER
#   SESSION. `/prime` allocates the marker at its Step 8, which is reached only when the operator
#   picks a menu item or states a task. A session opening with `/clarify` (or `/consult`, or any
#   path that never selects a task) allocates nothing — so the shared file still holds the
#   PREVIOUS session's marker, same date, therefore not pruned by the today-check in the loop
#   above. `close` would then resolve to that session's manifest and OVERWRITE ITS RECORD, with
#   no error and nothing to notice. Observed live 2026-07-18, session S4-8c3
#   (`logs/improvement-log.md` 2026-07-18 entry): avoided only because the operator happened to
#   read the marker file by eye.
#
# THE TEST IS PRESENCE OF THIS SESSION'S OWN MARKER — NOT A COMPARISON OF NAMES. Reaching this
#   point already proves the per-id marker `logs/.session-marker-$CLAUDE_CODE_SESSION_ID` did not
#   supply a today-dated marker, because the resolution loop tries it FIRST and would have set
#   MARKER_SRC to that filename. So this session never allocated a marker, and the shared file
#   cannot be attributed to it whatever it contains.
#
#   An earlier version of this guard compared the marker's 3-character id suffix against this
#   session's first three alphanumerics. That was NOT collision-resistant — `/prime` Step 8k cuts
#   the suffix to 3 chars, so two sessions sharing a 3-char id prefix produce the same suffix and
#   the guard waved the second one through (reproduced: session `abc99999-…` accepted marker
#   `S3-abc` from a different `abc…` session and wrote its manifest). Lengthening the suffix was
#   rejected: the suffix is part of the marker GRAMMAR that session-notes headers, plan filenames,
#   manifest filenames and ~21 symlinked command copies all read. Presence needs no comparison at
#   all, so it is both stronger and cheaper. The suffix is now used ONLY to name the likely owner
#   in the warning text — never to decide.
#
# SCOPE — two carve-outs:
#   1. Per-id-resolved markers are trustworthy BY CONSTRUCTION (no concurrent session can write
#      that filename) and skip the check entirely. This is the normal path.
#   2. No CLAUDE_CODE_SESSION_ID (older CLI) → no identity exists to attribute against → skip
#      silently, preserving pre-per-id-marker behaviour exactly.
#   A suffix-less legacy marker gets NO carve-out: with a session id present, `/prime` would have
#   written a suffixed marker, so a bare `S5` is itself evidence of a foreign or stale allocation.
#
# WHY THIS WARNS AND SKIPS RATHER THAN ABORTING — read before "hardening" it.
#   The danger is WRITING to a manifest we cannot claim; it is not the mere fact of a bad marker.
#   Declining to write achieves the whole safety goal, so there is no reason to also fail the
#   command. And an ABSENT manifest is explicitly routine per THE ADVISORY RULE at the top of this
#   file, while a non-zero exit invites a caller to treat a legitimate state as a fault — both
#   `/session-start` Step 3.5 and `/wrap-session` Step 12d state that a manifest failure is
#   surfaced and the session CONTINUES. An earlier draft called `die` here AND told the caller to
#   "pass this session's own values" — advice a `/clarify`-first session cannot follow, because
#   the marker it would need is precisely what was never allocated. So: say what happened, say
#   what was NOT written, name the only real remedy (`/prime`, or an explicit `--marker` if the
#   session genuinely knows its own), and exit 0 without touching anything.
#
# THIS DOES NOT VIOLATE THE ADVISORY RULE AT THE TOP OF THIS FILE. That rule governs ABSENCE — a
#   missing manifest is routine, so never block on it. This guards ATTRIBUTION: declining to
#   write a record the script cannot correctly attribute is not policy enforcement, it is
#   refusing to destroy another session's data. `principles.md § OP-3` (loud failure over silent
#   continuation) governs here — and it is satisfied by SURFACING, which is what the notice does.
#
# THERE MAY BE NO REMEDY AT ALL, AND THAT IS AN ACCEPTABLE OUTCOME — do not write the message as
#   if a fix is always available. The session this fires for most often is a `/clarify`-first one
#   that never allocated a marker: it cannot pass `--marker`, because no marker of its own exists
#   to pass. For that session the correct end state is simply NO MANIFEST, which the ADVISORY RULE
#   already blesses. `--date`/`--marker` helps only a session that genuinely knows its own values,
#   and `/prime` helps only the NEXT session. Never imply the caller can resolve this in-flight.
#
# CONSEQUENCE ACCEPTED DELIBERATELY: this also declines the case where the shared marker really IS
#   this session's — e.g. its per-id marker was already torn down. That is unreachable in the
#   normal flow (`/wrap-session` Step 13 removes the per-id marker as its FINAL action, after Step
#   12d has closed the manifest), and where it does arise the session has no marker of its own
#   anyway, so skipping the write beats a lucky guess at whose record to overwrite.
if [ "$MARKER_SRC" = ".session-marker" ] && [ -n "${CLAUDE_CODE_SESSION_ID:-}" ]; then
  # Rationale lives in the block immediately above — single authority, do not restate it here.
  # The id suffix below is used ONLY to name the likely owner in the notice text. It is never
  # consulted to decide anything; the decision was made by reaching this branch at all.
  _self_id3="$(printf '%s' "$CLAUDE_CODE_SESSION_ID" | tr -cd 'A-Za-z0-9' | cut -c1-3)"
  case "$MARKER" in
    *-*) _owner="most likely the session whose id starts '${MARKER##*-}'" ;;
    *)   _owner="an unidentified session (the marker carries no id suffix)" ;;
  esac
  printf '%s: NOTICE: no manifest written — this session cannot claim a marker.\n' "$SCRIPT_NAME" >&2
  printf '  Resolved %s from the SHARED marker file (%s).\n' "$MARKER" "$_owner" >&2
  printf '  This session (id starts %s) wrote no per-id marker today, so nothing proves the marker\n' "$_self_id3" >&2
  printf '  is ours; writing would risk overwriting %s-%s.json, which belongs to another session.\n' "$DATE" "$MARKER" >&2
  printf '  Cause: /prime allocates the marker at its Step 8, which a /clarify-first session never reaches.\n' >&2
  printf '  This is NOT a failure to fix mid-wrap. An absent manifest is a routine, supported state\n' >&2
  printf '  (see THE ADVISORY RULE above) — surface this line and CONTINUE the session normally.\n' >&2
  printf '  Do not invent a marker, and do not delete a marker file to get past this.\n' >&2
  printf '  Remedy, if this session genuinely knows its own marker: re-run with --date/--marker.\n' >&2
  printf '  Otherwise run /prime at session start so a per-id marker exists. See docs/session-marker.md.\n' >&2
  exit 0
fi

MANIFEST="${RUNS_DIR}/${DATE}-${MARKER}.json"

need_python

# Export for the python heredocs (avoids quoting hazards in interpolated shell values).
export M_FILE="$MANIFEST"
export M_DATE="$DATE" M_MARKER="$MARKER" M_PROJECT="$PROJECT" M_MODEL="$MODEL"
export M_MANDATE_REF="$MANDATE_REF" M_MISSION="$MISSION" M_LANE="$LANE" M_PACK="$PACK_PATH"
export M_OUTCOME="$OUTCOME" M_STOP="$STOP_REASON" M_FAILCLASS="$FAILURE_CLASS"
export M_WAIVED="$INCIDENT_WAIVED"
export M_REQUIRED="$REQUIRED_KEYS" M_LANES="$LANES" M_STOPS="$STOP_REASONS"
export M_OUTCOMES="$OUTCOMES" M_LEVELS="$LEVELS" M_FAILCLASSES="$FAILURE_CLASSES"
# Arrays → newline-delimited strings (a path may contain spaces; it may not contain a newline).
printf '%s\n' "${FILES[@]+"${FILES[@]}"}"          > /tmp/.rm_files.$$   2>/dev/null || true
printf '%s\n' "${DECISION_REFS[@]+"${DECISION_REFS[@]}"}" > /tmp/.rm_decs.$$ 2>/dev/null || true
printf '%s\n' "${SKILLS[@]+"${SKILLS[@]}"}"        > /tmp/.rm_skills.$$ 2>/dev/null || true
printf '%s\n' "${VALIDATIONS[@]+"${VALIDATIONS[@]}"}" > /tmp/.rm_vals.$$ 2>/dev/null || true
printf '%s\n' "${OVERRIDES[@]+"${OVERRIDES[@]}"}"  > /tmp/.rm_ovrs.$$  2>/dev/null || true
export M_FILES_F=/tmp/.rm_files.$$ M_DECS_F=/tmp/.rm_decs.$$ M_SKILLS_F=/tmp/.rm_skills.$$
export M_VALS_F=/tmp/.rm_vals.$$ M_OVRS_F=/tmp/.rm_ovrs.$$
cleanup() { rm -f /tmp/.rm_files.$$ /tmp/.rm_decs.$$ /tmp/.rm_skills.$$ /tmp/.rm_vals.$$ /tmp/.rm_ovrs.$$; }
trap cleanup EXIT

# Shared python prelude: helpers every subcommand reuses.
PY_LIB='
import json, os, sys

def readlines(var):
    p = os.environ.get(var, "")
    if not p or not os.path.exists(p):
        return []
    with open(p) as fh:
        return [ln.rstrip("\n") for ln in fh if ln.strip()]

def load(fp):
    with open(fp) as fh:
        return json.load(fh)

def save(fp, obj):
    os.makedirs(os.path.dirname(fp), exist_ok=True)
    tmp = fp + ".tmp"
    with open(tmp, "w") as fh:
        json.dump(obj, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    os.replace(tmp, fp)   # atomic — a crash mid-write never leaves a half-manifest

def stub():
    return {
        "run_id": f'"'"'{os.environ["M_DATE"]}-{os.environ["M_MARKER"]}'"'"',
        "project": os.environ.get("M_PROJECT") or os.path.basename(os.getcwd()),
        "date": os.environ["M_DATE"],
        "marker": os.environ["M_MARKER"],
        "model": os.environ.get("M_MODEL") or "unknown",
        "lane": os.environ.get("M_LANE") or None,
        "mandate_ref": os.environ.get("M_MANDATE_REF") or "logs/session-notes.md",
        "mission": os.environ.get("M_MISSION") or None,
        "context": {"pack_path": os.environ.get("M_PACK") or None,
                    "always_loaded_estimate_tok": 0},
        "resources": {"skills": [], "subagents": [], "tools_notable": []},
        "files_changed": [],
        "decisions_refs": [],
        "validation": [],
        "evaluator_findings": {"sidecar_refs": [], "verdicts": []},
        "overrides": [],
        "cost": {"turns": 0, "subagents": 0, "token_estimate": None},
        "stop_reason": None,
        "outcome": None,
        "failure_class": None,
        "incidents_refs": [],
    }
'

# ---------------------------------------------------------------- subcommands
case "$SUBCMD" in

  start)
    # Idempotent: an existing manifest is never clobbered (a re-invoked /session-start,
    # or a session that re-confirms its mandate, must not wipe accumulated state).
    if [ -f "$MANIFEST" ]; then
      note "start-stub already present at ${MANIFEST} — left intact (idempotent)."
      exit 0
    fi
    python3 -c "$PY_LIB"'
fp = os.environ["M_FILE"]
save(fp, stub())
print(f"MANIFEST: start-stub written → {fp}")
' || die "failed to write start-stub at ${MANIFEST}"
    ;;

  update)
    if [ ! -f "$MANIFEST" ]; then
      # Advisory, never fatal: a session that never wrote a stub can still be updated
      # once it has one, but we do not invent state behind the operator's back.
      note "absent at ${MANIFEST} — nothing to update (advisory; no start-stub was written)."
      exit 0
    fi
    python3 -c "$PY_LIB"'
fp = os.environ["M_FILE"]
m = load(fp)

# files_changed maintained RUNNING and de-duplicated, order-preserving.
seen = list(m.get("files_changed") or [])
for f in readlines("M_FILES_F"):
    if f not in seen:
        seen.append(f)
m["files_changed"] = seen

for d in readlines("M_DECS_F"):
    m.setdefault("decisions_refs", [])
    if d not in m["decisions_refs"]:
        m["decisions_refs"].append(d)

res = m.setdefault("resources", {"skills": [], "subagents": [], "tools_notable": []})
for s in readlines("M_SKILLS_F"):
    res.setdefault("skills", [])
    if s not in res["skills"]:
        res["skills"].append(s)

for v in readlines("M_VALS_F"):
    out, _, lvl = v.partition("|")
    m.setdefault("validation", []).append({"output": out, "level_reached": lvl})

for o in readlines("M_OVRS_F"):
    gate, _, reason = o.partition("|")
    m.setdefault("overrides", []).append(
        {"gate": gate, "action": "operator-override", "reason": reason})

for env_key, field in (("M_MODEL", "model"), ("M_MANDATE_REF", "mandate_ref"),
                       ("M_MISSION", "mission"), ("M_LANE", "lane")):
    val = os.environ.get(env_key)
    if val:
        m[field] = val

save(fp, m)
n = len(m["files_changed"])
print(f"MANIFEST: updated → {fp} ({n} files_changed)")
' || die "failed to update ${MANIFEST}"
    ;;

  close)
    # THE ADVISORY RULE, part 1: absent at close is ROUTINE, not an error.
    # Write a wrap-time stub so the session still leaves a durable trace, say so once, continue.
    if [ ! -f "$MANIFEST" ]; then
      python3 -c "$PY_LIB"'
fp = os.environ["M_FILE"]
s = stub()
s["stop_reason"] = "completed"
s["lane"] = s.get("lane") or None
save(fp, s)
' || die "failed to write wrap-time stub at ${MANIFEST}"
      # DO NOT ASSERT A CAUSE THIS CODE CANNOT SEE. The old text named exactly one ("session skipped
      # mandate confirmation") and stated it flatly. Across midnight that was simply WRONG — a stub
      # did exist, under yesterday's date — and a confidently wrong diagnosis at 00:10 is how the
      # cross-midnight defect stayed invisible. The resolver above now handles that case; this
      # message still must not out-claim its evidence, because a mis-pinned `--date` reaches here too.
      # `find`, not a glob: an unmatched glob under zsh errors instead of expanding empty.
      _sibling="$(find "$RUNS_DIR" -maxdepth 1 -name "*-${MARKER}.json" \
                    ! -name "$(basename "$MANIFEST")" 2>/dev/null | head -n 2 | tr '\n' ' ')"
      if [ -n "$_sibling" ]; then
        note "no start-stub at $(basename "$MANIFEST") — but marker ${MARKER} already has a manifest under a DIFFERENT date: ${_sibling}. A wrap-time stub was written anyway, so this session may now hold TWO records. If it started on the other date, close that one with --date <that date> and delete this stub."
      else
        note "no start-stub existed for ${DATE}-${MARKER} (no /session-start or /prime mandate step ran, most likely) — wrote a wrap-time stub instead. Advisory only; not an error."
      fi
    fi
    python3 -c "$PY_LIB"'
fp = os.environ["M_FILE"]
m = load(fp)

seen = list(m.get("files_changed") or [])
for f in readlines("M_FILES_F"):
    if f not in seen:
        seen.append(f)
m["files_changed"] = seen

for d in readlines("M_DECS_F"):
    m.setdefault("decisions_refs", [])
    if d not in m["decisions_refs"]:
        m["decisions_refs"].append(d)

for v in readlines("M_VALS_F"):
    out, _, lvl = v.partition("|")
    m.setdefault("validation", []).append({"output": out, "level_reached": lvl})

m["stop_reason"]   = os.environ.get("M_STOP")      or m.get("stop_reason") or "completed"
m["outcome"]       = os.environ.get("M_OUTCOME")   or m.get("outcome")
fc                 = os.environ.get("M_FAILCLASS")
m["failure_class"] = (None if fc in ("", "null", "none") else fc) if fc else m.get("failure_class")
if os.environ.get("M_WAIVED"):
    m["incident_waived"] = os.environ["M_WAIVED"]

save(fp, m)
print(f"MANIFEST: closed → {fp}")
' || die "failed to close ${MANIFEST}"
    # `exec bash "$0"`, never `exec "$0"` — every caller invokes us as `bash <script>` and therefore
    # does NOT depend on the execute bit. Re-entering via `exec "$0"` would silently reintroduce that
    # dependency: lose the +x bit (cp without -p, a zip round-trip, core.fileMode=false) and exec
    # fails with 126 on a perfectly valid manifest — a loud FALSE failure at wrap, i.e. the advisory
    # rule inverted. Keep the `bash` prefix.
    exec bash "$0" validate --date "$DATE" --marker "$MARKER" --runs-dir "$RUNS_DIR"
    ;;

  validate)
    # THE ADVISORY RULE, part 2: absent → exit 0. Only present-and-malformed aborts loudly.
    if [ ! -f "$MANIFEST" ]; then
      note "absent at ${MANIFEST} — nothing to validate (advisory; this is a legitimate path, not a failure)."
      exit 0
    fi
    python3 -c "$PY_LIB"'
fp   = os.environ["M_FILE"]
errs = []

try:
    m = load(fp)
except Exception as e:
    print(f"MANIFEST: INVALID — {fp} is not parseable JSON: {e}", file=sys.stderr)
    sys.exit(1)

if not isinstance(m, dict):
    print(f"MANIFEST: INVALID — {fp} top level is {type(m).__name__}, expected object.", file=sys.stderr)
    sys.exit(1)

for k in os.environ["M_REQUIRED"].split():
    if k not in m:
        errs.append(f"missing required field: {k}")

if "files_changed" in m and not isinstance(m["files_changed"], list):
    errs.append("files_changed must be a list")
if "overrides" in m and not isinstance(m["overrides"], list):
    errs.append("overrides must be a list")

def enum_ok(val, allowed, field, nullable=True):
    if val is None:
        if not nullable:
            errs.append(f"{field} may not be null")
        return
    if val not in allowed.split():
        errs.append(f"{field}={val!r} is not in the closed set: {allowed}")

enum_ok(m.get("lane"),          os.environ["M_LANES"],       "lane")
enum_ok(m.get("stop_reason"),   os.environ["M_STOPS"],       "stop_reason")
enum_ok(m.get("outcome"),       os.environ["M_OUTCOMES"],    "outcome")
enum_ok(m.get("failure_class"), os.environ["M_FAILCLASSES"], "failure_class")

for i, v in enumerate(m.get("validation") or []):
    if not isinstance(v, dict):
        errs.append(f"validation[{i}] must be an object")
        continue
    enum_ok(v.get("level_reached"), os.environ["M_LEVELS"], f"validation[{i}].level_reached")

# spine-schemas.md §2: failure_class != null forces a defect entry or an explicit waiver.
if m.get("failure_class") and not (m.get("incidents_refs") or m.get("incident_waived")):
    errs.append("failure_class is set but there is no incidents_refs entry and no incident_waived "
                "reason (spine-schemas.md §2 — the schema is the trigger, not operator memory)")

if errs:
    print(f"MANIFEST: INVALID — {fp}", file=sys.stderr)
    for e in errs:
        print(f"  ✗ {e}", file=sys.stderr)
    print("  → Fix the manifest, or delete it and re-run. This is a LOUD abort by design "
          "(spine-schemas.md §1: never a silent pass).", file=sys.stderr)
    sys.exit(1)

n   = len(m.get("files_changed") or [])
out = m.get("outcome")
stp = m.get("stop_reason")
print(f"MANIFEST: valid → {fp} ({n} files_changed, outcome={out}, stop_reason={stp})")
'
    exit $?
    ;;

  *)
    die "unknown subcommand: ${SUBCMD} (expected start|update|close|validate|dir)"
    ;;
esac
