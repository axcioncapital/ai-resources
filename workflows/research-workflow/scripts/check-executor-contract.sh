#!/usr/bin/env bash
set -u

if [[ "$#" -ne 2 ]]; then
  printf 'Usage: %s <project-CLAUDE.md> <execution-manifest.md>\n' "${0##*/}" >&2
  exit 2
fi

project_config="$1"
execution_manifest="$2"

if [[ ! -f "$project_config" || ! -f "$execution_manifest" ]]; then
  printf 'STALE MANIFEST — regenerate Step 2.0: contract input missing\n' >&2
  exit 3
fi

extract_section_value() {
  local file="$1"
  local section="$2"
  local prefix="$3"

  awk -v section="$section" -v prefix="$prefix" '
    $0 == section { inside = 1; next }
    inside && /^## / { exit }
    inside && index($0, prefix) == 1 {
      print substr($0, length(prefix) + 1)
      exit
    }
  ' "$file"
}

normalize_value() {
  local value="$1"

  value="$(printf '%s' "$value" | sed -E 's/[[:space:]]+#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//')"
  if [[ "${#value}" -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s' "$value"
}

compare_field() {
  local field="$1"
  local config_prefix="$2"
  local manifest_prefix="$3"
  local configured
  local manifested

  configured="$(extract_section_value "$project_config" '## Project Config' "$config_prefix")"
  manifested="$(extract_section_value "$execution_manifest" '## Executor Contract' "$manifest_prefix")"
  configured="$(normalize_value "$configured")"
  manifested="$(normalize_value "$manifested")"

  if [[ -z "$configured" || -z "$manifested" || "$configured" == *'{{'* ||
        "$manifested" == *'[Project Config value]'* ||
        "$manifested" == *'[Project Config tokens]'* ||
        "$manifested" == *'[Project Config value or none]'* ]]; then
    printf 'STALE MANIFEST — regenerate Step 2.0: %s missing or unresolved\n' "$field" >&2
    return 1
  fi

  if [[ "$configured" != "$manifested" ]]; then
    printf 'STALE MANIFEST — regenerate Step 2.0: %s differs\n' "$field" >&2
    return 1
  fi
}

if ! compare_field 'Evidence executor' '**Evidence executor:**' '- **Evidence executor:**'; then
  exit 3
fi
if ! compare_field 'Evidence executor capabilities' '**Evidence executor capabilities:**' '- **Declared capabilities:**'; then
  exit 3
fi
if ! compare_field 'Supplementary lead provider' '**Supplementary lead provider:**' '- **Supplementary lead provider:**'; then
  exit 3
fi

printf 'EXECUTOR CONTRACT READY\n'
