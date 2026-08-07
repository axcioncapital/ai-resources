#!/bin/bash
# Phase 1d, network half. Can WebFetch/WebSearch be denied on the headless child?
set -uo pipefail
CO="$(mktemp -d "${TMPDIR:-/tmp}/wl2-1d-web.XXXXXX")"
trap 'rm -rf "$CO"' EXIT
mkdir -p "$CO/.claude"
cat >"$CO/.claude/settings.json" <<'EOF'
{ "permissions": { "defaultMode": "bypassPermissions", "allow": [], "deny": [] } }
EOF

PROMPT="Fetch https://example.com and report the page title. If you cannot, state exactly why in one sentence."

show() { python3 -c 'import sys,json
raw=sys.stdin.read()
try: d=json.loads(raw)
except Exception: print("  <non-JSON>"); print("  "+raw[:400]); sys.exit()
print("  is_error:", d.get("is_error"))
print("  result:", str(d.get("result"))[:600])'; }

echo "=== A: --disallowedTools WebFetch WebSearch ==="
( cd "$CO" && claude -p "$PROMPT" --output-format json \
    --disallowedTools "WebFetch" "WebSearch" 2>&1 ) | show

echo
echo "=== B: --settings inline deny ==="
( cd "$CO" && claude -p "$PROMPT" --output-format json \
    --settings '{"permissions":{"deny":["WebFetch","WebSearch"]}}' 2>&1 ) | show
