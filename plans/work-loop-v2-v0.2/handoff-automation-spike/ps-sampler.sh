#!/bin/bash
# Recursion / concurrency sampler for the live dispatcher run.
#
# Samples the process table every 2s and records how many dispatchers and how
# many actor processes exist at that instant. Two claims depend on it:
#   - at most one actor runs at a time;
#   - product Stop hooks firing during a child run start no extra dispatcher
#     and no extra actor.
#
# Usage: ps-sampler.sh <out-file> <max-seconds>

out="${1:?out file}"
limit="${2:-3600}"
: >"$out"

# A count alone is not enough. `ps` also shows the dispatcher's own forked
# subshells with an identical command line, so "dispatchers=3" can mean one
# script, not three. PIDs and PPIDs are recorded so a reader can tell an
# independent second dispatcher from a fork of the first.
elapsed=0
while [ "$elapsed" -lt "$limit" ]; do
  snap="$(ps -eo pid,ppid,command 2>/dev/null)"
  disp="$(printf '%s\n' "$snap" | grep '[d]ispatch\.sh --checkout' | awk '{print $1"/"$2}' | tr '\n' ',')"
  cdx="$(printf '%s\n'  "$snap" | grep 'ChatGPT\.app/Contents/Resources/[c]odex exec' | awk '{print $1"/"$2}' | tr '\n' ',')"
  cld="$(printf '%s\n'  "$snap" | grep '[c]laude -p /work-loop-v2' | awk '{print $1"/"$2}' | tr '\n' ',')"
  nd=$(printf '%s\n' "$snap" | grep -c '[d]ispatch\.sh --checkout')
  ncd=$(printf '%s\n' "$snap" | grep -c 'ChatGPT\.app/Contents/Resources/[c]odex exec')
  ncl=$(printf '%s\n' "$snap" | grep -c '[c]laude -p /work-loop-v2')
  printf 't=%04d dispatchers=%s[%s] codex_actors=%s[%s] claude_actors=%s[%s]\n' \
    "$elapsed" "$nd" "${disp%,}" "$ncd" "${cdx%,}" "$ncl" "${cld%,}" >>"$out"
  sleep 2
  elapsed=$((elapsed + 2))
done
