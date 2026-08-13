#!/bin/bash
# Phase 1d probe — CAN a headless child be given a narrower policy than the
# operator's interactive sessions?
#
# v0.2 § 1d: "How a headless child is given a *different* policy from the
# operator's interactive sessions has not been checked. Specifying a profile
# before knowing whether one can be scoped to that child would repeat exactly the
# failure that produced this revision."
#
# This answers the mechanism question ONLY. What policy to actually apply is the
# operator's decision, not this script's.
#
# Runs in a throwaway sandbox with a fake git remote, so a push that IS attempted
# goes nowhere real.

set -uo pipefail
ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-probe1d.XXXXXX")"
trap 'rm -rf "$ROOT"' EXIT

CO="$ROOT/co"; mkdir -p "$CO"
git init -q "$CO"
git -C "$CO" config user.email probe@example.invalid
git -C "$CO" config user.name probe
printf 'sandbox\n' >"$CO/README.md"
git -C "$CO" add README.md
git -C "$CO" commit -qm base >/dev/null
# A bare local remote: a push would "work" but reaches nothing outside this dir.
git init -q --bare "$ROOT/remote.git"
git -C "$CO" remote add origin "$ROOT/remote.git"

# Sandbox settings mirroring the real repo's posture: bypassPermissions.
mkdir -p "$CO/.claude"
cat >"$CO/.claude/settings.json" <<'EOF'
{ "permissions": { "defaultMode": "bypassPermissions", "allow": [], "deny": [] } }
EOF

run() { # label, extra-args..., then prompt as last arg
  local label="$1"; shift
  local prompt="${*: -1}"
  set -- "${@:1:$#-1}"
  echo "=================================================================="
  echo "TEST: $label"
  echo "args: $*"
  local out
  # No timeout(1) on this machine — the same fact dispatch.sh's run_bounded exists for.
  out="$(cd "$CO" && claude -p "$prompt" --output-format json "$@" 2>&1)"
  # Print just the result text and any permission-denial signal.
  printf '%s' "$out" | python3 -c '
import sys, json
raw = sys.stdin.read()
try:
    d = json.loads(raw)
except Exception:
    print("  <non-JSON output>"); print("  " + raw[:600]); sys.exit()
r = d.get("result") or d.get("error") or ""
print("  is_error:", d.get("is_error"))
print("  result:", (r if isinstance(r,str) else json.dumps(r))[:700])
'
  echo
}

echo "sandbox: $CO"
echo "claude:  $(command -v claude)  $(claude --version 2>&1 | head -1)"
echo

# --- 1. Baseline: does a headless child under bypassPermissions run Bash freely?
run "baseline — bypassPermissions, no restriction" \
  "Run exactly this shell command and report its output verbatim: echo PROBE_BASELINE_OK"

# --- 2. --disallowedTools: is Bash denied for THIS invocation only?
run "--disallowedTools Bash" \
  --disallowedTools "Bash" \
  "Run exactly this shell command and report its output verbatim: echo PROBE_DENY_BASH"

# --- 3. Scoped deny of push specifically, via --disallowedTools
run "--disallowedTools 'Bash(git push:*)'" \
  --disallowedTools "Bash(git push:*)" \
  "Run exactly this shell command and report its exact output or the exact error: git push origin HEAD"

# --- 4. Scoped deny via --settings inline JSON (the per-invocation settings path)
run "--settings inline deny Bash(git push:*)" \
  --settings '{"permissions":{"deny":["Bash(git push:*)"]}}' \
  "Run exactly this shell command and report its exact output or the exact error: git push origin HEAD"

# --- 5. Does WebFetch/WebSearch get denied the same way? (the network half of 1d)
run "--disallowedTools WebFetch WebSearch" \
  --disallowedTools "WebFetch" "WebSearch" \
  "Fetch https://example.com and tell me the page title. If you cannot, say exactly why."

echo "=================================================================="
echo "did anything actually reach the remote?"
git -C "$ROOT/remote.git" log --oneline 2>/dev/null | head -5 || echo "  (no commits in remote — nothing was pushed)"
[ -z "$(git -C "$ROOT/remote.git" log --oneline 2>/dev/null)" ] && echo "  (no commits in remote — nothing was pushed)"
