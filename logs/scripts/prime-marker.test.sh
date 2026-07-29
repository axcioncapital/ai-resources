#!/usr/bin/env bash
# prime-marker.test.sh — DIFFERENTIAL equivalence test: logs/scripts/prime-marker.sh  ==  the
# allocator block still embedded in .claude/commands/prime.md Step 8k.
#
# WHY DIFFERENTIAL, AND WHY THAT IS THE WHOLE POINT
#   logs/scripts/prime-allocator.test.sh proves the PROSE BLOCK satisfies 19 behavioural properties.
#   This suite proves the SCRIPT behaves identically to that block. Together they transfer the 19/0
#   guarantee onto the script without restating a single assertion:
#       block satisfies P1..P19   ∧   script ≡ block   ⟹   script satisfies P1..P19
#   Restating the 19 assertions here instead would create a second copy to keep in sync — the exact
#   defect this whole capability exists to remove.
#
#   This suite is what makes Slice 2's swap safe. It must stay green until prime.md Step 8k is
#   replaced by a call to the script; after that it has nothing left to compare and is retired
#   together with the awk extractor.
#
# RUNS EVERY CASE UNDER BOTH bash AND zsh. A bash-only pass has already hidden a real zsh crash in
# this exact code (the unmatched-glob NOMATCH case, 2026-07-13), so single-shell evidence is not
# evidence here.

set -u

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PRIME_MD="$REPO/.claude/commands/prime.md"
SCRIPT="$REPO/logs/scripts/prime-marker.sh"

[ -f "$PRIME_MD" ] || { echo "FATAL: cannot find prime.md at $PRIME_MD"; exit 2; }
[ -f "$SCRIPT" ]   || { echo "FATAL: cannot find prime-marker.sh at $SCRIPT"; exit 2; }

TMP="${TMPDIR:-/tmp}/prime-marker-difftest.$$"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT

# ---- Extract the live block from prime.md, using the SAME anchors the existing tripwire uses ------
BLOCK="$TMP/block.sh"
awk '
  /^[[:space:]]*```bash[[:space:]]*$/ { inblk=1; buf=""; next }
  inblk && /^[[:space:]]*```[[:space:]]*$/ {
      if (buf ~ /Allocate N = 1/) { printf "%s", buf; exit }
      inblk=0; buf=""; next
  }
  inblk { buf = buf $0 "\n" }
' "$PRIME_MD" | sed -e 's/^         //' > "$BLOCK"

if ! grep -q 'MARKER=' "$BLOCK"; then
  echo "FATAL: allocator extraction from prime.md failed (no MARKER= assignment found)."
  echo "       Either Slice 2 has landed (block replaced by a call to the script — retire this"
  echo "       suite), or the fence/anchor moved. Do NOT fall back to a copy."
  exit 2
fi
# Make the block emit the same one-line stdout contract the script does.
printf '\nprintf "%%s %%s\\n" "$TODAY" "$MARKER"\n' >> "$BLOCK"

PASS=0; FAIL=0
ok()   { PASS=$((PASS+1)); printf '  PASS  %-52s %s\n' "$1" "$2"; }
bad()  { FAIL=$((FAIL+1)); printf '  FAIL  %-52s %s\n' "$1" "$2"; }

# Build a fresh fixture repo. $1 = dir.
mkfixture() {
  rm -rf "$1"; mkdir -p "$1/logs"
  ( cd "$1" && git init -q . && git config user.email t@t && git config user.name t
    printf '# notes\n' > logs/session-notes.md
    git add -A && git commit -qm init ) >/dev/null 2>&1
}

# Run one engine in a fresh fixture and echo "<stdout>|<.session-marker contents>".
# $1=shell  $2=engine-path  $3=fixture-dir  $4=session-id ("" = unset)  $5=preseed marker ("" = none)
run_engine() {
  local sh="$1" eng="$2" dir="$3" sid="$4" seed="$5"
  mkfixture "$dir"
  [ -n "$seed" ] && printf '%s\n' "$seed" > "$dir/logs/.session-marker"
  local out
  if [ -n "$sid" ]; then
    out=$( cd "$dir" && CLAUDE_CODE_SESSION_ID="$sid" "$sh" "$eng" 2>/dev/null )
  else
    out=$( cd "$dir" && env -u CLAUDE_CODE_SESSION_ID "$sh" "$eng" 2>/dev/null )
  fi
  printf '%s|%s' "$out" "$(cat "$dir/logs/.session-marker" 2>/dev/null)"
}

# One differential case, run under both shells.
# $1=label  $2=session-id  $3=preseed
diffcase() {
  local label="$1" sid="$2" seed="$3" sh b s
  for sh in bash zsh; do
    command -v "$sh" >/dev/null 2>&1 || { printf '  SKIP  %-52s %s not installed\n' "$label" "$sh"; continue; }
    b=$(run_engine "$sh" "$BLOCK"  "$TMP/fx-b" "$sid" "$seed")
    s=$(run_engine "$sh" "$SCRIPT" "$TMP/fx-s" "$sid" "$seed")
    if [ "$b" = "$s" ] && [ -n "${b%%|*}" ]; then
      ok "$label [$sh]" "${b%%|*}"
    else
      bad "$label [$sh]" "block=[$b] script=[$s]"
    fi
  done
}

echo "============================================================="
echo " DIFFERENTIAL: prime-marker.sh  ==  prime.md Step 8k block"
echo "============================================================="

diffcase "fresh repo, no marker, id present      -> S1-abc" "abcdefgh" ""
diffcase "fresh repo, no marker, NO id           -> bare S1" ""         ""
diffcase "seeded same-day S1                     -> S2"      "abcdefgh" "$(date '+%Y-%m-%d') S1"
diffcase "seeded SUFFIXED S7-a4f (fail-safe parse)-> S8"     "abcdefgh" "$(date '+%Y-%m-%d') S7-a4f"
diffcase "seeded S12 (multi-digit)               -> S13"     "abcdefgh" "$(date '+%Y-%m-%d') S12"
diffcase "stale marker from ANOTHER day          -> S1"      "abcdefgh" "1999-01-01 S9"
diffcase "malformed marker (garbage)             -> S1"      "abcdefgh" "not-a-marker"
diffcase "id with punctuation is stripped to 3   -> S1-a1b"  "a-1/b#cd" ""

# --- Non-git directory: the fail-safe degrade path (no common dir => no mutex) -------------------
echo "--- fail-safe: outside a git repo ---"
for sh in bash zsh; do
  if command -v "$sh" >/dev/null 2>&1; then
    rm -rf "$TMP/ng-b" "$TMP/ng-s"; mkdir -p "$TMP/ng-b/logs" "$TMP/ng-s/logs"
    printf '%s\n' "$(date '+%Y-%m-%d') S4" > "$TMP/ng-b/logs/.session-marker"
    printf '%s\n' "$(date '+%Y-%m-%d') S4" > "$TMP/ng-s/logs/.session-marker"
    b=$( cd "$TMP/ng-b" && CLAUDE_CODE_SESSION_ID=zzz9 "$sh" "$BLOCK"  2>/dev/null )
    s=$( cd "$TMP/ng-s" && CLAUDE_CODE_SESSION_ID=zzz9 "$sh" "$SCRIPT" 2>/dev/null )
    if [ "$b" = "$s" ] && [ -n "$b" ]; then ok "non-git dir degrades identically [$sh]" "$b"
    else bad "non-git dir degrades identically [$sh]" "block=[$b] script=[$s]"; fi
  fi
done

# --- The invariant that must never invert: a seeded HIGH is never reset downward -----------------
echo "--- fail-safe invariant: HIGH is never reset below the marker file ---"
for sh in bash zsh; do
  if command -v "$sh" >/dev/null 2>&1; then
    s=$(run_engine "$sh" "$SCRIPT" "$TMP/fx-inv" "qqq1" "$(date '+%Y-%m-%d') S5")
    n="${s%%|*}"; n="${n##* S}"; n="${n%%-*}"
    if [ "$n" -gt 5 ] 2>/dev/null; then ok "seeded S5 never re-allocates <= S5 [$sh]" "got ${s%%|*}"
    else bad "seeded S5 never re-allocates <= S5 [$sh]" "got [$s]"; fi
  fi
done

echo
echo "-------------------------------------------------------------"
echo "RESULT: $PASS passed, $FAIL failed"
if [ "$FAIL" -eq 0 ]; then echo "EQUIVALENT — script is a faithful owner of the block."; exit 0
else echo "DIVERGENT — do NOT land Slice 2 until this is green."; exit 1; fi
