#!/bin/bash
# Run the verification matrix. Each case gets its own disposable copy so no run
# can see another run's records. All writes stay in the scratchpad.
S="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad"
FX="$S/fx"
RUNS="$S/runs"
mkdir -p "$RUNS"

mkcopy() {
  rm -rf "$FX/$1"
  cp -R "$FX/A" "$FX/$1"
}

run() {
  CASE="$1"; DIR="$2"; PROMPT="$3"
  ( cd "$DIR" && claude -p "$PROMPT" --permission-mode bypassPermissions \
      > "$RUNS/$CASE.out" 2> "$RUNS/$CASE.err" ; echo "exit=$? $CASE" >> "$RUNS/exits.txt" ) &
}

: > "$RUNS/exits.txt"

# --- C1: checkout selection from an ai-resources-shaped worktree copy.
#     Doubles as the negative control for C2 (no notes path), C3 (confirmed fault),
#     C4 (actionable fault continues), C5 (runnable path can resolve), C6 (non-small fault).
mkcopy C1
run C1 "$FX/C1" '/resolve-incident "logs/scripts/entry-count.sh reports the wrong number of incident entries — running it prints 2 but the log actually holds 4 entries, so the archival threshold check is wrong"'

# --- C1n: negative control — invoked from a project repo, must resolve to the workspace ai-resources.
rm -rf "$FX/Bn"; cp -R "$FX/B" "$FX/Bn"
run C1n "$FX/Bn/projects/proj" '/resolve-incident "logs/scripts/entry-count.sh reports the wrong number of incident entries — running it prints 2 but the log actually holds 4 entries, so the archival threshold check is wrong"'

# --- C2: triage bridge — ISSUE cites a readable MANUAL notes path.
mkcopy C2
run C2 "$FX/C2" '/resolve-incident "entry-count.sh miscounts incident entries — correct the grep pattern it counts with — triage notes: audits/working/2026-08-10-resolve-entry-count-miscounts.md"'

# --- C3: false premise — a safely disprovable fault.
mkcopy C3
run C3 "$FX/C3" '/resolve-incident "docs/healthy-doc.md has a malformed ## heading that breaks the section parser, so every section after it is silently dropped"'

wait
echo "--- batch 1 done ---"
cat "$RUNS/exits.txt"
