#!/usr/bin/env bash
# research-route-classify.sh — resolve a route from assessed signals.
#
# The shared entry `.claude/commands/research-route.md` owns the routing rules. This script
# holds NO copy of them: it parses the delimited `route-rules` block out of the entry file it
# is pointed at. That is deliberate — a second copy is how the executable check and the
# instruction a human reads come to disagree, and the entry must stay complete on its own so a
# project that has only the command file can still route by reading it.
#
# Usage:
#   research-route-classify.sh --entry <path> [--preference light|standard|deep|none]
#                              --signal <key>=<value> [--signal <key>=<value> ...]
#
# Prints, on success (exit 0):
#   route: light|standard|deep
#   preference-overridden: yes|no
#   floor-set-by: <rule, or "base">
#
# Exits 2 on a usage or rule-file error. Escalation is one way: a preference may raise the
# route above the floor, never lower it below.

set -u

die() { printf 'ERROR: %s\n' "$1" >&2; exit 2; }

entry=""
preference="none"
signals=()

while [ $# -gt 0 ]; do
  case "$1" in
    --entry)      [ $# -ge 2 ] || die "--entry needs a path"; entry="$2"; shift 2 ;;
    --preference) [ $# -ge 2 ] || die "--preference needs a value"; preference="$2"; shift 2 ;;
    --signal)     [ $# -ge 2 ] || die "--signal needs key=value"; signals+=("$2"); shift 2 ;;
    *)            die "unknown argument: $1" ;;
  esac
done

[ -n "$entry" ] || die "--entry is required"
[ -r "$entry" ] || die "entry file is not readable: $entry"

case "$preference" in
  light|standard|deep|none) ;;
  *) die "--preference must be light, standard, deep or none (got: $preference)" ;;
esac

required_signal_keys=(output consequence scope load_bearing_claim thesis_judgment)

signal_key_known() {
  case "$1" in
    output|consequence|scope|load_bearing_claim|thesis_judgment) return 0 ;;
    *) return 1 ;;
  esac
}

signal_value_allowed() {
  case "$1:$2" in
    output:note|output:analysis|output:report|output:unclear) return 0 ;;
    consequence:internal|consequence:external|consequence:unclear) return 0 ;;
    scope:bounded|scope:broad|scope:unclear) return 0 ;;
    load_bearing_claim:yes|load_bearing_claim:no|load_bearing_claim:unclear) return 0 ;;
    thesis_judgment:yes|thesis_judgment:no|thesis_judgment:unclear) return 0 ;;
    *) return 1 ;;
  esac
}

# The safety vector is a closed contract. Malformed input must never fall through to the
# Light base route: every key is required exactly once and every value is enumerated.
seen_signal_keys=()
for signal in ${signals+"${signals[@]}"}; do
  case "$signal" in
    *=*) ;;
    *) die "signal is not key=value: $signal" ;;
  esac
  key="${signal%%=*}"
  value="${signal#*=}"
  signal_key_known "$key" || die "unknown signal: $key"
  signal_value_allowed "$key" "$value" || die "invalid value for signal '$key': $value"
  for seen in ${seen_signal_keys+"${seen_signal_keys[@]}"}; do
    [ "$seen" != "$key" ] || die "duplicate signal: $key"
  done
  seen_signal_keys+=("$key")
done

for required in "${required_signal_keys[@]}"; do
  present=0
  for seen in ${seen_signal_keys+"${seen_signal_keys[@]}"}; do
    [ "$seen" = "$required" ] && { present=1; break; }
  done
  [ "$present" -eq 1 ] || die "missing required signal: $required"
done

rank() {
  case "$1" in
    light) printf '1\n' ;;
    standard) printf '2\n' ;;
    deep) printf '3\n' ;;
    *) printf '0\n' ;;
  esac
}
label() {
  case "$1" in
    1) printf 'light\n' ;;
    2) printf 'standard\n' ;;
    3) printf 'deep\n' ;;
    *) printf 'unknown\n' ;;
  esac
}

# --- parse the rules out of the entry ---------------------------------------
rules="$(awk '
  /<!-- route-rules:start -->/ { inside = 1; next }
  /<!-- route-rules:end -->/   { inside = 0; next }
  inside && NF                 { print }
' "$entry")"

[ -n "$rules" ] || die "no route-rules block found in $entry"

base=""
floor_rank=0
floor_by="base"

while IFS= read -r line; do
  [ -n "$line" ] || continue
  # shellcheck disable=SC2086
  set -- $line
  case "$1" in
    BASE)
      [ $# -eq 2 ] || die "malformed BASE rule: $line"
      [ "$(rank "$2")" != 0 ] || die "BASE names an unknown route: $line"
      [ -z "$base" ] || die "route-rules block declares more than one BASE route"
      base="$2"
      ;;
    FLOOR)
      # FLOOR <route> <cond> [<cond> ...] — every condition must match (AND).
      # A single-condition rule is the ordinary case; a multi-condition rule expresses a
      # floor that only a COMBINATION warrants, so that neither signal over-routes alone.
      [ $# -ge 3 ] || die "malformed FLOOR rule: $line"
      r="$(rank "$2")"
      [ "$r" != 0 ] || die "FLOOR names an unknown route: $line"
      route_word="$2"; shift 2
      conds="$*"
      matched_all=1
      for cond in $conds; do
        case "$cond" in *=*) ;; *) die "FLOOR condition is not key=value: $line" ;; esac
        cond_key="${cond%%=*}"
        cond_value="${cond#*=}"
        signal_key_known "$cond_key" || die "FLOOR condition names an unknown signal '$cond_key': $line"
        signal_value_allowed "$cond_key" "$cond_value" \
          || die "FLOOR condition has an invalid value '$cond_value' for '$cond_key': $line"
        matched_one=0
        for s in ${signals+"${signals[@]}"}; do
          [ "$s" = "$cond" ] && { matched_one=1; break; }
        done
        [ "$matched_one" -eq 1 ] || { matched_all=0; break; }
      done
      if [ "$matched_all" -eq 1 ] && [ "$r" -gt "$floor_rank" ]; then
        floor_rank="$r"
        floor_by="$(printf '%s' "$conds" | tr ' ' '+')"
      fi
      unset route_word
      ;;
    *)
      die "unknown rule verb: $line"
      ;;
  esac
done <<< "$rules"

[ -n "$base" ] || die "route-rules block declares no BASE route"

base_rank="$(rank "$base")"
[ "$floor_rank" -ge "$base_rank" ] || { floor_rank="$base_rank"; floor_by="base"; }

pref_rank="$(rank "$preference")"   # 0 when preference=none

if [ "$pref_rank" -gt "$floor_rank" ]; then
  final_rank="$pref_rank"
  overridden="no"
elif [ "$pref_rank" -gt 0 ] && [ "$pref_rank" -lt "$floor_rank" ]; then
  final_rank="$floor_rank"
  overridden="yes"
else
  final_rank="$floor_rank"
  overridden="no"
fi

printf 'route: %s\n' "$(label "$final_rank")"
printf 'preference-overridden: %s\n' "$overridden"
printf 'floor-set-by: %s\n' "$floor_by"
