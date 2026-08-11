#!/bin/bash
# Run one verification case: $1 = case id, $2 = fixture cwd, $3 = prompt.
# Invokes the real command through the headless CLI from inside the fixture.
FX="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad/fx"
OUT="$FX/../runs"
mkdir -p "$OUT"
CASE="$1"; DIR="$2"; PROMPT="$3"
cd "$DIR" || exit 1
claude -p "$PROMPT" \
  --permission-mode bypassPermissions \
  > "$OUT/$CASE.out" 2> "$OUT/$CASE.err"
echo "exit=$? case=$CASE"
