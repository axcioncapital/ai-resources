#!/usr/bin/env bash
# check-decision-refs.sh — verify a run-manifest's `decisions_refs` entries resolve to
# real headers in logs/decisions.md (or its monthly archives).
#
# WHY THIS EXISTS
#   W3.2 R3 Pass 2's reopen gate must be measured BY PAYLOAD, never by whether the manifest
#   closed. "Did it close?" is a proxy that correlates with "is the record real" — until it
#   doesn't. That proxy is what let Pass 2's gate read as PASS while `decisions_refs` was
#   empty on every ordinary session (logs/decisions.md 2026-07-12 S4). This script is the
#   payload test, so the next session does not hand-roll it and quietly re-adopt a proxy.
#
# ADVISORY, NEVER A GATE (principles.md § OP-5). Exits 0 on an absent manifest and on a
# decision-free session. It reports; it does not block a wrap or a commit. Do not "harden"
# this — the same rule governs the manifest close it checks.
#
# USAGE
#   bash logs/scripts/check-decision-refs.sh [path/to/manifest.json]
#   (default: logs/runs/{today}-{marker}.json, resolved from the session marker oracle)
#
# EXIT CODES
#   0 — all refs resolve, OR nothing to check (absent manifest / no decisions). Advisory-clean.
#   1 — at least one ORPHAN ref (points at no real header). Surfaces loudly; blocks nothing.
#
# REF FORMAT: this script defines nothing. It IMPORTS slug() from decision_ref_slug.py —
# the one definition, shared with the generator (run-manifest.sh --decision-ref-from-header).
# There is deliberately no slug() in this file: a second copy is precisely how a validator
# drifts from its generator and starts calling valid refs orphans. Prose overview lives in
# docs/spine-schemas.md § 1, which documents the module rather than restating it.

set -uo pipefail

# Resolve this script's real directory, following symlinks — `dirname` alone yields the
# symlink's dir, which would break both the repo-root walk and the module import. Same
# defect (and same fix) as run-manifest.sh; see its self-location block.
_SELF="${BASH_SOURCE[0]}"
while [ -L "$_SELF" ]; do
  _SELF_DIR="$(cd -P "$(dirname "$_SELF")" && pwd)"
  _SELF="$(readlink "$_SELF")"
  case "$_SELF" in
    /*) ;;
    *)  _SELF="$_SELF_DIR/$_SELF" ;;
  esac
done
SCRIPT_DIR="$(cd -P "$(dirname "$_SELF")" && pwd)"

# Resolve an explicit manifest argument against the CALLER's cwd, before any cd below.
MANIFEST="${1:-}"
if [ -n "$MANIFEST" ]; then
  case "$MANIFEST" in
    /*) ;;
    *)  MANIFEST="$(pwd)/$MANIFEST" ;;
  esac
fi

# REPO ROOT COMES FROM THE CALLER, NOT FROM THIS FILE.
#
# There is ONE copy of this script (in ai-resources), and EVERY repo's wrap invokes that
# same copy — `bash "$(dirname "$RM")/check-decision-refs.sh"`. Deriving the repo root from
# SCRIPT_DIR therefore made the checker always inspect **ai-resources**, whatever repo the
# caller was in. On 2026-07-13 a project-planning wrap ran concurrently with an ai-resources
# session: this script read the *ai-resources* session's still-open start-stub (same
# `2026-07-13 S1` marker, decisions_refs still empty), printed a RELATIVE path, and reported
# the caller's refs as missing. They were not missing — project-planning's own manifest
# carried all three, correctly slugged. That false report was written up as bug "P1" and
# burned ~2 sessions before anyone opened the file.
#
# So: walk up from the CALLER's cwd to the nearest ancestor that owns a logs/decisions.md.
# And print ABSOLUTE paths everywhere below, so "which file did it actually read" is never
# a guess again. (W3.2 RR-01; rationale in plans/repo-redesign-authoritative-implementation-report.md.)
REPO_ROOT=""
d="$(pwd)"
while [ "$d" != "/" ]; do
  if [ -f "$d/logs/decisions.md" ]; then REPO_ROOT="$d"; break; fi
  d="$(dirname "$d")"
done
if [ -z "$REPO_ROOT" ]; then
  echo "REFCHECK: no logs/decisions.md in any ancestor of $(pwd) — nothing to check (advisory)."
  exit 0
fi
cd "$REPO_ROOT" || exit 0
echo "REFCHECK: repo root ${REPO_ROOT}"

if [ -z "$MANIFEST" ]; then
  # Take BOTH the date and the marker from the marker file — never `date` for the date half.
  # The marker file records the session's OWN date ("2026-07-12 S5"). A session that runs
  # past midnight still owns yesterday's manifest, so deriving the date from the clock makes
  # it look for a manifest that does not exist and check nothing. (Found live: this session
  # crossed midnight and the clock-derived path missed its own manifest.)
  SESSION_STAMP=""
  if [ -n "${CLAUDE_CODE_SESSION_ID:-}" ] && [ -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" ]; then
    SESSION_STAMP="$(cat "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}")"
  elif [ -f logs/.session-marker ]; then
    SESSION_STAMP="$(cat logs/.session-marker)"
  fi
  SESSION_DATE="${SESSION_STAMP%% *}"
  MARKER="${SESSION_STAMP##* }"
  if [ -z "$MARKER" ] || [ -z "$SESSION_DATE" ] || [ "$SESSION_DATE" = "$MARKER" ]; then
    echo "REFCHECK: no usable session marker — nothing to check (advisory)."
    exit 0
  fi
  MANIFEST="${REPO_ROOT}/logs/runs/${SESSION_DATE}-${MARKER}.json"
fi

[ -f "$MANIFEST" ] || { echo "REFCHECK: manifest absent at ${MANIFEST} — nothing to check (advisory)."; exit 0; }
echo "REFCHECK: manifest ${MANIFEST}"

MANIFEST="$MANIFEST" SCRIPT_DIR="$SCRIPT_DIR" python3 - <<'PY'
import json, os, re, sys, glob

# THE slug definition is imported, never re-implemented. A second copy here is exactly
# how the validator drifts from the generator and starts calling valid refs orphans.
#
# If the module is gone, DEGRADE — do not traceback. This script runs at every wrap; a
# stack trace there is noise in the highest-traffic command in the repo, and an absent
# validator is a legitimate state (§ OP-5), not a failed wrap.
sys.path.insert(0, os.environ["SCRIPT_DIR"])
try:
    from decision_ref_slug import slug  # noqa: E402
except ImportError:
    print("REFCHECK: decision_ref_slug.py not found — cannot validate refs (advisory, not blocking).")
    print("  Expected at: " + os.path.join(os.environ["SCRIPT_DIR"], "decision_ref_slug.py"))
    sys.exit(0)

# Index every decision header — live log AND monthly archives, so a ref whose month has
# rotated still resolves (the archival-staleness known limit, spine-schemas.md § 1).
known, sources, unreadable = set(), [], []
for path in ['logs/decisions.md'] + sorted(glob.glob('logs/decisions-archive-*.md')):
    if not os.path.exists(path):
        continue
    try:
        # errors='replace': one stray non-UTF-8 byte in a log must not traceback at every
        # wrap. A mangled char in an unrelated line cannot change a header's slug; a hard
        # failure here would be noise in the highest-traffic command in the repo (§ OP-5).
        with open(path, encoding='utf-8', errors='replace') as fh:
            for line in fh:
                if re.match(r'^#{2,3}\s+\d{4}-', line):
                    known.add(slug(line))
        sources.append(path)
    except OSError as e:
        unreadable.append(f"{path} ({e.__class__.__name__})")

if unreadable:
    # Loud, but not fatal: a ref may be judged an orphan only because its source is
    # unreadable. Say so, so a false ORPHAN is never mistaken for a real one.
    print("REFCHECK: could not read " + ", ".join(unreadable)
          + " — refs from those files may show as ORPHAN (advisory).")

mf = os.environ["MANIFEST"]
try:
    refs = (json.load(open(mf, encoding='utf-8')).get('decisions_refs') or [])
except Exception as e:
    print(f"REFCHECK: manifest unreadable ({e}) — advisory, not blocking.")
    sys.exit(0)

if not refs:
    print(f"REFCHECK: decisions_refs is empty in {mf}.")
    print("  This is CORRECT for a session that recorded no decisions, and WRONG for one that did.")
    print("  The script cannot tell which — that judgment is the wrap's, not the checker's.")
    sys.exit(0)

orphans = []
for r in refs:
    anchor = r.split('#', 1)[1] if '#' in r else ''
    ok = anchor in known
    print(f"  {'RESOLVES' if ok else 'ORPHAN  '}  {r}")
    if not ok:
        orphans.append(r)

print(f"\nREFCHECK: {len(refs) - len(orphans)}/{len(refs)} refs resolve "
      f"({len(known)} headers indexed across {len(sources)} file(s)):")
for p in sources:
    print(f"  indexed: {os.path.abspath(p)}")

if orphans:
    print("\nORPHAN refs point at no real decision header. Likely causes:")
    print("  - the ref was hand-authored instead of slugged from the header (cf. S1's 2026-07-12 ref);")
    print("  - the decision header was retitled after the ref was written;")
    print("  - the slug contract in docs/spine-schemas.md § 1 changed and this script drifted from it.")
    sys.exit(1)
sys.exit(0)
PY
