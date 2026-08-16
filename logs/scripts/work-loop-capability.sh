#!/bin/bash
# work-loop-capability.sh — is Work Loop v2 completely deployed in this checkout,
# or is it visibly unavailable?
#
# THE PROBLEM THIS CLOSES. `/work-loop-v2` is not one file. Running a unit needs
# five separate things to be present in the same checkout, and they arrive by
# four different routes: two helpers copied from a workflow template, one skill
# symlinked through a manifest opt-in, one Codex hook plus its registration, and
# one `.gitignore` rule. Nothing checked them together. A project could pick up
# the command through the generic SessionStart symlink sweep, report itself
# "fully in sync", and then fail at a different seam on every invocation — a
# missing validator here, an unregistered compact hook there, an `.owner` file
# quietly committed somewhere else. Durable-state plan, Capability G: validator,
# owner helper, Reorient, compact hook and ignore rule travel as ONE deployable
# capability, and partial exposure is never reported as ready.
#
# WHAT IT IS NOT. It is not a deployment framework, a registry, a manifest, or a
# second state system. It holds no list of projects and no record of what was
# deployed when. It answers one question about one checkout, from that
# checkout's own files, and forgets it. It is not a lifecycle reader either:
# nothing here opens a task record or looks at `task:`, `status:` or `turn:` —
# `work-loop-state.sh` owns that and this script only checks that it is present.
#
# READ-ONLY, ABSOLUTELY. It creates, edits and deletes nothing, in the checkout
# it is pointed at or anywhere else. It never installs a missing component and
# never repairs a drifted one — it names what is missing and lets the caller
# (`/sync-workflow`, `/deploy-workflow`, or the operator) decide. A checker that
# fixed things on the way past would make "is this ready?" unanswerable.
#
# THE FIVE COMPONENTS, and the exact name each is reported under:
#
#   state-validator        logs/scripts/work-loop-state.sh
#   owner-helper           logs/scripts/work-loop-owner.sh
#   reorient-skill         .agents/skills/reorient/SKILL.md
#   compact-recovery-hook  .codex/hooks/work-loop-reorient.sh, AND a SessionStart
#                          entry in .codex/hooks.json whose matcher is `compact`
#                          and whose command runs that script. The file alone is
#                          not the component: an unregistered hook never fires,
#                          so a checkout holding it is exactly as unrecovered as
#                          one without it, and reporting it present would be a
#                          lie of the most useful-looking kind.
#   owner-ignore-rule      a live ignore rule matching logs/work-loop/.owner
#
# WHY THE IGNORE RULE IS CHECKED AS A RULE, NOT A FILE. A project `.gitignore`
# legitimately carries project-specific lines, so comparing whole files against
# a template's would report a permanent conflict and bury the one rule that
# matters. `git check-ignore` answers the question directly: does anything in
# this checkout's ignore configuration match that path? A missing rule is worse
# than a missing helper — the declaration gets committed, replicates across
# worktrees on merge, and then declares every checkout the owner, which is the
# exact failure the declaration exists to refuse.
#
# APPLICABILITY. A checkout that does not carry `.claude/commands/work-loop-v2.md`
# is not exposing Work Loop v2, so the capability is NOT_APPLICABLE — not broken,
# not missing, not a finding. That distinction is the whole point of the third
# verdict: without it, every ordinary project in the workspace would report five
# missing components forever, and the report would be worth nothing.
#
# Usage:
#   work-loop-capability.sh check --checkout PATH [--canonical PATH]
#
#   --checkout   the checkout to assess. Defaults to the Git top level of the
#                current directory.
#   --canonical  optional. A checkout or workflow template holding the canonical
#                copies. When given, the three COPIED components are additionally
#                compared byte-for-byte against it and any difference is reported
#                as `drifted:`. Omit it to check presence only. There is no
#                discovery mechanism here on purpose: a script that went looking
#                for "the canonical repository" would be inventing an authority
#                the deployment contract does not give it.
#
# Exit codes:
#   0   READY           all five components present (and byte-identical, if
#                       --canonical was given).
#   2   NOT_APPLICABLE  the checkout does not expose /work-loop-v2.
#   3   INCOMPLETE      at least one component is missing or drifted. Every one
#                       is named on its own `missing:` or `drifted:` line.
#   10  BAD_USAGE
#
# Regression coverage: logs/scripts/work-loop-capability.test.sh

set -uo pipefail

CMD_REL='.claude/commands/work-loop-v2.md'
VALIDATOR_REL='logs/scripts/work-loop-state.sh'
OWNER_REL='logs/scripts/work-loop-owner.sh'
SKILL_REL='.agents/skills/reorient/SKILL.md'
HOOK_REL='.codex/hooks/work-loop-reorient.sh'
HOOKS_JSON_REL='.codex/hooks.json'
OWNER_DECL_REL='logs/work-loop/.owner'

usage() { awk 'NR==1{next} /^#/{print; next} {exit}' "${BASH_SOURCE[0]}"; }

ACTION=""; CHECKOUT=""; CANONICAL=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    check)       ACTION='check'; shift ;;
    --checkout)  CHECKOUT="${2:-}"; shift 2 ;;
    --canonical) CANONICAL="${2:-}"; shift 2 ;;
    -h|--help)   usage; exit 0 ;;
    *)           printf 'BAD_USAGE [10] unknown argument: %s\n' "$1" >&2; exit 10 ;;
  esac
done

[ "$ACTION" = 'check' ] || { printf 'BAD_USAGE [10] the only action is `check`.\n' >&2; usage >&2; exit 10; }

if [ -z "$CHECKOUT" ]; then
  CHECKOUT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    printf 'BAD_USAGE [10] --checkout was not given and the current directory is not a Git checkout.\n' >&2
    exit 10
  }
fi

[ -d "$CHECKOUT" ] || { printf 'BAD_USAGE [10] --checkout is not a directory: %s\n' "$CHECKOUT" >&2; exit 10; }
if [ -n "$CANONICAL" ]; then
  [ -d "$CANONICAL" ] || { printf 'BAD_USAGE [10] --canonical is not a directory: %s\n' "$CANONICAL" >&2; exit 10; }
fi

# ------------------------------------------------------------- applicability
# Symlink counts: the generic SessionStart sweep installs the command AS a
# symlink, and a symlinked command exposes Work Loop exactly as a copied one
# does. `-e` follows the link, so a broken link falls through to `-L` and is
# still treated as exposure — a checkout holding a dangling command file has a
# problem, but pretending Work Loop is absent there is not the answer to it.
if [ ! -e "$CHECKOUT/$CMD_REL" ] && [ ! -L "$CHECKOUT/$CMD_REL" ]; then
  printf 'verdict: NOT_APPLICABLE\n'
  printf 'checkout: %s\n' "$CHECKOUT"
  printf 'reason: %s is absent — this checkout does not expose /work-loop-v2, so the capability is not applicable rather than incomplete.\n' "$CMD_REL"
  exit 2
fi

FINDINGS=""
note() { FINDINGS="${FINDINGS}$1"$'\n'; }

present() { # relative-path
  [ -f "$CHECKOUT/$1" ] && [ -r "$CHECKOUT/$1" ]
}

compare_copy() { # component relative-path
  # Only meaningful when --canonical was given AND the canonical side actually
  # holds the file. A canonical source that lacks it is not evidence of drift in
  # the deployed copy, so it is silently skipped rather than reported.
  [ -n "$CANONICAL" ] || return 0
  [ -f "$CANONICAL/$2" ] || return 0
  cmp -s "$CANONICAL/$2" "$CHECKOUT/$2" && return 0
  note "drifted: $1 — $2 differs from the canonical copy at $CANONICAL/$2. Deployed helper copies must be byte-identical; they are not parameterized."
}

# ------------------------------------------------------- 1. the state validator
if present "$VALIDATOR_REL"; then
  compare_copy 'state-validator' "$VALIDATOR_REL"
else
  note "missing: state-validator — $VALIDATOR_REL is absent or unreadable. Lifecycle classification has one authority and no fallback reading, so every Work Loop invocation here stops."
fi

# --------------------------------------------------------- 2. the owner helper
if present "$OWNER_REL"; then
  compare_copy 'owner-helper' "$OWNER_REL"
else
  note "missing: owner-helper — $OWNER_REL is absent or unreadable. /work-loop-v2 Step 1.5 refuses an ownership check it cannot run, so every Work Loop invocation here fails closed."
fi

# -------------------------------------------------------- 3. the Reorient skill
# Resolved through the symlink: projects opt in via .claude/shared-manifest.json
# skills.shared, which installs a directory symlink, and `-f` follows it.
if [ ! -f "$CHECKOUT/$SKILL_REL" ] || [ ! -r "$CHECKOUT/$SKILL_REL" ]; then
  note "missing: reorient-skill — $SKILL_REL is absent or unreadable. A compacted Codex session cannot re-establish the active task from disk and would continue from its summary."
fi

# ------------------------------------------- 4. the compact hook AND its wiring
HOOK_FILE_OK=0
if present "$HOOK_REL"; then
  HOOK_FILE_OK=1
  compare_copy 'compact-recovery-hook' "$HOOK_REL"
else
  note "missing: compact-recovery-hook — $HOOK_REL is absent or unreadable. Nothing tells a compacted session to re-read the Work Loop pointers from disk."
fi

if [ "$HOOK_FILE_OK" -eq 1 ]; then
  if [ ! -f "$CHECKOUT/$HOOKS_JSON_REL" ] || [ ! -r "$CHECKOUT/$HOOKS_JSON_REL" ]; then
    note "missing: compact-recovery-hook — $HOOK_REL is present but $HOOKS_JSON_REL is absent or unreadable, so the hook is registered nowhere in this checkout and never fires."
  elif ! command -v jq >/dev/null 2>&1; then
    note "missing: compact-recovery-hook — $HOOKS_JSON_REL cannot be read because jq is not on PATH. Registration is unestablished, and this reports it rather than assuming it."
  else
    REGISTERED="$(jq -r '
      [ (.hooks.SessionStart // [])[]
        | select((.matcher // "") == "compact")
        | (.hooks // [])[]
        | (.command // "")
        | select(test("work-loop-reorient\\.sh"))
      ] | length
    ' "$CHECKOUT/$HOOKS_JSON_REL" 2>/dev/null)"
    if [ -z "$REGISTERED" ]; then
      note "missing: compact-recovery-hook — $HOOKS_JSON_REL is not valid JSON, so its registration cannot be established."
    elif [ "$REGISTERED" -eq 0 ] 2>/dev/null; then
      note "missing: compact-recovery-hook — $HOOK_REL is present but $HOOKS_JSON_REL has no SessionStart entry with matcher \"compact\" that runs it. An unregistered hook never fires, so the file alone does not make the component present."
    fi
  fi
fi

# ------------------------------------------------------- 5. the live ignore rule
if ! git -C "$CHECKOUT" rev-parse --git-dir >/dev/null 2>&1; then
  note "missing: owner-ignore-rule — $CHECKOUT is not a Git checkout, so no ignore rule can be established for $OWNER_DECL_REL."
elif ! git -C "$CHECKOUT" check-ignore -q "$OWNER_DECL_REL" 2>/dev/null; then
  note "missing: owner-ignore-rule — nothing in this checkout's ignore configuration matches $OWNER_DECL_REL. The declaration is checkout-local by construction; committed, it replicates across worktrees on merge and declares every checkout the owner."
fi

# --------------------------------------------------------------------- verdict
if [ -z "$FINDINGS" ]; then
  printf 'verdict: READY\n'
  printf 'checkout: %s\n' "$CHECKOUT"
  if [ -n "$CANONICAL" ]; then
    printf 'reason: all five Work Loop v2 components are present, and every copied component is byte-identical to %s.\n' "$CANONICAL"
  else
    printf 'reason: all five Work Loop v2 components are present in this checkout.\n'
  fi
  exit 0
fi

COUNT="$(printf '%s' "$FINDINGS" | grep -c '^')"
printf 'verdict: INCOMPLETE\n'
printf 'checkout: %s\n' "$CHECKOUT"
printf '%s' "$FINDINGS"
printf 'reason: this checkout exposes /work-loop-v2 but the capability is incomplete — %s of the five components are missing or drifted. Work Loop must not begin here until every one is resolved.\n' "$COUNT"
exit 3
