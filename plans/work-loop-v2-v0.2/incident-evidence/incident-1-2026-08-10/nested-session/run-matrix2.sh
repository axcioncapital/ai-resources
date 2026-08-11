#!/bin/bash
# Batch 2 of the verification matrix.
S="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad"
FX="$S/fx"; RUNS="$S/runs"; mkdir -p "$RUNS"

mkcopy() { rm -rf "$FX/$1"; cp -R "$FX/A" "$FX/$1"; }
run() {
  CASE="$1"; DIR="$2"; PROMPT="$3"
  ( cd "$DIR" && claude -p "$PROMPT" --permission-mode bypassPermissions \
      > "$RUNS/$CASE.out" 2> "$RUNS/$CASE.err" ; echo "exit=$? $CASE" >> "$RUNS/exits.txt" ) &
}

# --- C4a: 'no action justified' — confirmed, but no rung warrants a change.
mkcopy C4a
run C4a "$FX/C4a" '/resolve-incident "logs/decisions.md holds only its title line, so the Step 14 context read of its last 15 entries returns almost nothing and the diagnosis loses its decision history"'

# --- C4b: 'transferred' — confirmed, but another named capability owns it.
mkcopy C4b
run C4b "$FX/C4b" '/resolve-incident "docs/vault-link is a broken symlink — it points at ../does-not-exist/target-dir and resolves to nothing"'

# --- C5: verification floor — a logic-bearing fix whose real path cannot be exercised here.
mkcopy C5
run C5 "$FX/C5" '/resolve-incident "logs/scripts/notify-check.sh passes --level=warn but axcion-notify expects --severity=warn, so the archival notification never fires"'

# --- C6n: negative control for Direct Work — a triage-front-door run on a non-small fault.
mkcopy C6n
run C6n "$FX/C6n" '/resolve-repo-problem "logs/scripts/entry-count.sh reports the wrong number of incident entries — running it prints 2 but the log actually holds 4 entries, so the archival threshold check is wrong"'

wait
echo "--- batch 2 done ---"
cat "$RUNS/exits.txt"
