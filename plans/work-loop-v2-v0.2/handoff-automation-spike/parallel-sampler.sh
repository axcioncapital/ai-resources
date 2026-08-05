#!/bin/bash
# Parallel-run process sampler for the two-worktree proof (SPIKE, not production).
#
# ps-sampler.sh answers "how many actors are alive at this instant?" for a single
# dispatcher. This one answers the two questions a *parallel* run adds:
#
#   - did the two runs genuinely overlap, or did they merely run in sequence?
#   - did every child process actually live in the worktree it was routed to?
#
# The second question is why this samples `lsof -a -d cwd`. A source-code claim
# that `dispatch.sh` runs Claude with `cd "$CHECKOUT"` is not an observation of
# where the process ended up; the kernel's idea of the process working directory
# is. Codex is launched with `-C <checkout>` instead of a `cd`, so its own cwd is
# expected to be the dispatcher's, and its routing evidence is the `-C` argument
# on the command line. Both are recorded, unlabelled by expectation, so the
# reader can see which mechanism carried which actor.
#
# Output is one record per process per sample, plus a `t=` heartbeat line so a
# reader can see the sampler was alive across a gap rather than assume it.
#
# Usage: parallel-sampler.sh <out-file> <max-seconds>

out="${1:?out file}"
limit="${2:-3600}"
: >"$out"

# `lsof` is the only way to read another process's cwd on macOS, and it is slow
# enough (~50ms/pid) to matter at a 2s cadence with several processes. Bounded
# with -w (no warnings) and a single -p list per sample rather than one call each.
cwds_for() { # pid... -> "pid<TAB>cwd" lines
  [ "$#" -eq 0 ] && return 0
  local joined
  joined="$(printf '%s,' "$@")"
  lsof -w -a -d cwd -p "${joined%,}" -Fpn 2>/dev/null | awk '
    /^p/ { pid = substr($0, 2); next }
    /^n/ { if (pid != "") { print pid "\t" substr($0, 2); pid = "" } }
  '
}

elapsed=0
while [ "$elapsed" -lt "$limit" ]; do
  stamp="$(date '+%Y-%m-%dT%H:%M:%S')"
  snap="$(ps -eo pid,ppid,command 2>/dev/null)"

  # One combined match so a process is classified once, and the classification is
  # visible in the record rather than implied by which line it was printed on.
  rows="$(printf '%s\n' "$snap" | awk '
    /[d]ispatch\.sh --checkout/                          { print "dispatcher\t" $1 "\t" $2; next }
    /ChatGPT\.app\/Contents\/Resources\/[c]odex exec/    { print "codex\t"      $1 "\t" $2; next }
    /[c]laude -p \/work-loop-v2/                         { print "claude\t"     $1 "\t" $2; next }
  ')"

  pids="$(printf '%s\n' "$rows" | awk -F'\t' 'NF{print $2}')"
  # shellcheck disable=SC2086
  cwdmap="$(cwds_for $pids)"

  nd=$(printf '%s\n' "$rows" | grep -c '^dispatcher') || true
  ncd=$(printf '%s\n' "$rows" | grep -c '^codex') || true
  ncl=$(printf '%s\n' "$rows" | grep -c '^claude') || true
  printf 't=%04d %s dispatchers=%s codex_actors=%s claude_actors=%s\n' \
    "$elapsed" "$stamp" "$nd" "$ncd" "$ncl" >>"$out"

  printf '%s\n' "$rows" | while IFS=$'\t' read -r kind pid ppid; do
    [ -n "$kind" ] || continue
    cwd="$(printf '%s\n' "$cwdmap" | awk -F'\t' -v p="$pid" '$1==p {print $2; exit}')"
    # The routing argument, straight off the command line: --checkout for the
    # dispatcher, -C for codex, the task id for claude. Recorded verbatim.
    route="$(printf '%s\n' "$snap" | awk -v p="$pid" '$1==p {
      for (i = 1; i <= NF; i++) {
        if ($i == "--checkout" || $i == "-C") { print $(i+1); exit }
        if ($i == "-p" && $(i+1) == "/work-loop-v2") { print $(i+2); exit }
      }
    }')"
    printf '  t=%04d %-10s pid=%s ppid=%s cwd=%s route=%s\n' \
      "$elapsed" "$kind" "$pid" "$ppid" "${cwd:-unknown}" "${route:-unknown}" >>"$out"
  done

  sleep 2
  elapsed=$((elapsed + 2))
done
