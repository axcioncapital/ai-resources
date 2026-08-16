#!/bin/bash
# auto-sync-shared.sh — SessionStart hook
#
# Walks ai-resources/.claude/{commands,agents}/ and symlinks every file into
# the project, EXCEPT:
#
# Agent skills (ai-resources/.agents/skills/) work the OPPOSITE way: opt-in, not
# sync-everything. A project gets a shared skill only by naming it in its
# .claude/shared-manifest.json under skills.shared. Rationale: .agents/skills/ is
# a curated per-project set, not a common toolbox — axcion-website holds 7
# site-specific skills of its own, axcion-systems-builder wants exactly one
# shared skill, and ai-resources holds migration leftovers (source-command-*)
# plus probes (wl2-probe) that belong in no downstream project. An unconditional
# sync would push all of those into all 28 projects.
#
# Why this exists at all: a git worktree inherits the tracked manifest but NOT
# the untracked symlinks, so before this a worktree got the Claude-side
# /work-loop-v2 command and silently lost the Codex-side skill (2026-08-10).
# Making membership declarative in a tracked file is what makes a worktree
# reproduce it.
#
# The command/agent rules below are unchanged:
#   1. Files listed in the project's .claude/shared-manifest.json under
#      commands.local / agents.local (project-owned, never overwritten).
#   2. Files in the baked-in EXCLUDE lists below (ai-resources-meta — never
#      belong inside a downstream project). NOT applied at the workspace root,
#      which is a valid home for these commands, not a downstream project.
#   3. Files that already exist at the target (any kind: file, symlink, or
#      broken symlink — never overwrites).
#
# Result: when you add a new command to ai-resources, every project picks it
# up automatically on next session start. No manifest edits required.
#
# Drift reconciliation: also detects targets that exist as regular files
# (not symlinks) but differ from the canonical source. Emits an
# additionalContext warning — does NOT auto-replace. Operator approves
# replacement via /sync-workflow.
# Note: check-template-drift.sh covers workflow-template drift (checking
# against ai-resources/workflows/<template>/.claude/); this script covers
# ai-resources shared-file drift (checking against ai-resources/.claude/).
# Messages use distinct prefixes so both can fire without ambiguity.

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
MANIFEST="$PROJECT_DIR/.claude/shared-manifest.json"

# Bail if no manifest — project opts out of managed symlinks entirely.
[ -f "$MANIFEST" ] || exit 0

# Find ai-resources — check current dir first, then walk up.
# At the workspace root, ai-resources/ is a child; under projects/<name>/, an ancestor's child.
d="$PROJECT_DIR"
AI_RESOURCES=""
while :; do
  if [ -d "$d/ai-resources/.claude/commands" ]; then
    AI_RESOURCES="$d/ai-resources"
    break
  fi
  [ "$d" = "/" ] && break
  d=$(dirname "$d")
done
[ -z "$AI_RESOURCES" ] && exit 0

# Workspace-root detection. The walk above stops at the first ancestor holding
# ai-resources/; if that ancestor IS $PROJECT_DIR, then ai-resources/ is a DIRECT
# child and we are syncing the workspace root itself — not a downstream project.
# The root is where the ai-resources-meta commands below are *meant* to be run
# (see new-project.md "CWD guard": running from the workspace root is valid;
# only running from inside ai-resources/ is blocked), so the exclusions must not
# apply here. Note this is correctly 0 when $PROJECT_DIR is ai-resources itself:
# ai-resources contains no ai-resources/ child, so the walk lands on the parent.
IS_WORKSPACE_ROOT=0
[ "$d" = "$PROJECT_DIR" ] && IS_WORKSPACE_ROOT=1

# Baked-in exclusions: ai-resources-meta files that never belong in a downstream
# project. Exempted at the workspace root (IS_WORKSPACE_ROOT) — see above.
#
# FORMAT CONTRACT — load-bearing, do not reflow: fix-symlinks.md:81-82 re-reads
# both lists out of this file with `sed -n 's/^EXCLUDE_COMMANDS="\(.*\)"$/\1/p'`
# to keep a single source of truth. That parse needs each list to stay a static,
# single-line, start-of-line literal assignment. Gate where these lists are
# APPLIED (the four `IS_WORKSPACE_ROOT` conditionals below), never how they are
# ASSIGNED — a computed or multi-line value parses to empty and silently
# disables the /fix-symlinks drift scan (fix-symlinks.md:88-91).
EXCLUDE_COMMANDS="new-project deploy-workflow pipeline-review scope-project lean-repo"
EXCLUDE_AGENT_GLOBS="pipeline-stage-* session-guide-generator pipeline-review-* scope-*"

# Read project-local exclusions from manifest.
LOCAL_COMMANDS=$(jq -r '.commands.local[]?' "$MANIFEST" 2>/dev/null)
LOCAL_AGENTS=$(jq -r '.agents.local[]?' "$MANIFEST" 2>/dev/null)

# Agent skills are OPT-IN — see the "Agent skills" note in the header. skills.shared
# is the only *used* `shared` array in the manifest; commands/agents.shared are
# documentation and the hook ignores them.
LOCAL_SKILLS=$(jq -r '.skills.local[]?' "$MANIFEST" 2>/dev/null)
SHARED_SKILLS=$(jq -r '.skills.shared[]?' "$MANIFEST" 2>/dev/null)

in_list() {
  local needle="$1"; shift
  for item in $@; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

matches_glob() {
  local needle="$1"; shift
  for pattern in $@; do
    case "$needle" in $pattern) return 0;; esac
  done
  return 1
}

synced=""
failed=""
unknown=""

# Emit symlinks with RELATIVE targets — repo-architecture.md § Symlink topology
# rule 5 declares "Symlinks are relative", and /fix-symlinks (fix-symlinks.md
# Step 3, os.path.relpath) repairs to the same shape. Both new emission and
# corrective repair must agree. Guard the python3 call: if python3 is missing
# from the SessionStart PATH or os.path.relpath fails, skip the iteration and
# record the failure (loud failure) rather than emit `ln -s "" "$target"`
# (which succeeds at the syscall level and produces a broken empty-target
# symlink that the [ -e ] || [ -L ] idempotency guard would permanently skip).

# Sync commands.
for src in "$AI_RESOURCES"/.claude/commands/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  if [ "$IS_WORKSPACE_ROOT" -eq 0 ] && in_list "$name" "$EXCLUDE_COMMANDS"; then continue; fi
  in_list "$name" "$LOCAL_COMMANDS" && continue
  target="$PROJECT_DIR/.claude/commands/${name}.md"
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/commands"
  if ! rel_src=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    failed="$failed ${name}.md"
    continue
  fi
  ln -s "$rel_src" "$target"  # relative target — see header comment above
  synced="$synced ${name}.md"
done

# Sync agents.
for src in "$AI_RESOURCES"/.claude/agents/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  if [ "$IS_WORKSPACE_ROOT" -eq 0 ] && matches_glob "$name" "$EXCLUDE_AGENT_GLOBS"; then continue; fi
  in_list "$name" "$LOCAL_AGENTS" && continue
  target="$PROJECT_DIR/.claude/agents/${name}.md"
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/agents"
  if ! rel_src=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    failed="$failed ${name}.md"
    continue
  fi
  ln -s "$rel_src" "$target"  # relative target — see header comment above
  synced="$synced ${name}.md"
done

# Sync agent skills — OPT-IN via skills.shared, and each source is a DIRECTORY
# (holding SKILL.md), so the symlink target is a dir, not a file. A name listed in
# skills.shared but absent from ai-resources is a manifest error, reported through
# its own "$unknown" list rather than "$failed" (whose message is python3-specific).
for name in $SHARED_SKILLS; do
  in_list "$name" "$LOCAL_SKILLS" && continue
  src="$AI_RESOURCES/.agents/skills/$name"
  if [ ! -d "$src" ]; then
    unknown="$unknown $name"
    continue
  fi
  target="$PROJECT_DIR/.agents/skills/$name"
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.agents/skills"
  if ! rel_src=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    failed="$failed skills/$name"
    continue
  fi
  ln -s "$rel_src" "$target"  # relative target — see header comment above
  synced="$synced skills/$name"
done

# Drift detection: targets that exist as regular files (not symlinks) but differ
# from the canonical source. Uses "AI-RESOURCES DRIFT:" prefix to distinguish from
# check-template-drift.sh ("Template drift detected:") — both may fire independently.
drifted=""

for src in "$AI_RESOURCES"/.claude/commands/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  if [ "$IS_WORKSPACE_ROOT" -eq 0 ] && in_list "$name" "$EXCLUDE_COMMANDS"; then continue; fi
  in_list "$name" "$LOCAL_COMMANDS" && continue
  target="$PROJECT_DIR/.claude/commands/${name}.md"
  [ -f "$target" ] && [ ! -L "$target" ] || continue
  diff -q "$src" "$target" >/dev/null 2>&1 || drifted="$drifted ${name}.md"
done

for src in "$AI_RESOURCES"/.claude/agents/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  if [ "$IS_WORKSPACE_ROOT" -eq 0 ] && matches_glob "$name" "$EXCLUDE_AGENT_GLOBS"; then continue; fi
  in_list "$name" "$LOCAL_AGENTS" && continue
  target="$PROJECT_DIR/.claude/agents/${name}.md"
  [ -f "$target" ] && [ ! -L "$target" ] || continue
  diff -q "$src" "$target" >/dev/null 2>&1 || drifted="$drifted ${name}.md"
done

# No drift pass for skills: the canonical source is a directory tree, so the
# `diff -q` file comparison above does not apply, and a real (non-symlink)
# .agents/skills/<name>/ is a legitimate project-local skill rather than drift.

# Work Loop capability: complete, or visibly unavailable.
#
# This sweep is the reason the problem exists. It symlinks EVERY shared command
# into every project, work-loop-v2.md included, and then reports "Auto-synced N
# new shared file(s)" — which reads as success. But running one Work Loop unit
# needs four more things this sweep does not install: two template-deployed
# helper copies, a skills.shared opt-in, a Codex hook plus its registration, and
# a .gitignore rule. So the sweep's own success message is exactly what presents
# a partial capability as ready. It cannot stop symlinking the command (the
# command is genuinely shared, and withholding it would silently remove Work Loop
# from projects that are complete), so it says out loud what is still missing.
#
# Fail open, always: no capability checker, no jq, an unreadable project — the
# warning is skipped and the sweep behaves exactly as before. A SessionStart hook
# that blocked a session over a deployment gap would be worse than the gap.
wl2_warning=""
CAP_BIN="$AI_RESOURCES/logs/scripts/work-loop-capability.sh"
if [ -f "$CAP_BIN" ]; then
  cap_out=$(bash "$CAP_BIN" check --checkout "$PROJECT_DIR" 2>/dev/null)
  cap_rc=$?
  # 3 is INCOMPLETE. 0 (READY) and 2 (NOT_APPLICABLE) are both silence: a project
  # that does not carry the command has nothing to be incomplete about.
  if [ "$cap_rc" -eq 3 ]; then
    cap_names=$(printf '%s\n' "$cap_out" \
      | awk -F'[:[:space:]]+' '/^(missing|drifted):/ {print $2}' \
      | sort -u | tr '\n' ' ' | sed 's/ *$//')
    wl2_warning="WORK LOOP INCOMPLETE: this project exposes /work-loop-v2 but the capability is missing or drifted on: $cap_names. Run /sync-workflow to complete it — Work Loop refuses to start at Step 0 until every component is present."
  fi
fi

if [ -n "$synced" ] || [ -n "$drifted" ] || [ -n "$failed" ] || [ -n "$unknown" ] || [ -n "$wl2_warning" ]; then
  msg=""
  if [ -n "$synced" ]; then
    count=$(echo $synced | wc -w | tr -d ' ')
    msg="Auto-synced $count new shared file(s) from ai-resources (symlinked):$synced"
  fi
  if [ -n "$drifted" ]; then
    drift_count=$(echo $drifted | wc -w | tr -d ' ')
    drift_msg="AI-RESOURCES DRIFT: $drift_count file(s) differ from canonical (regular files, not symlinks):$drifted. Run /sync-workflow or replace with symlink."
    [ -n "$msg" ] && msg="$msg | $drift_msg" || msg="$drift_msg"
  fi
  if [ -n "$failed" ]; then
    fail_count=$(echo $failed | wc -w | tr -d ' ')
    fail_msg="AUTO-SYNC FAILED: $fail_count file(s) skipped because python3 was unavailable or os.path.relpath failed; ensure python3 is on the SessionStart PATH so relative-path symlinks can be emitted:$failed"
    [ -n "$msg" ] && msg="$msg | $fail_msg" || msg="$fail_msg"
  fi
  if [ -n "$unknown" ]; then
    unknown_count=$(echo $unknown | wc -w | tr -d ' ')
    unknown_msg="MANIFEST ERROR: $unknown_count skill(s) named in skills.shared do not exist under ai-resources/.agents/skills/:$unknown. Fix the name in .claude/shared-manifest.json or remove the entry."
    [ -n "$msg" ] && msg="$msg | $unknown_msg" || msg="$unknown_msg"
  fi
  if [ -n "$wl2_warning" ]; then
    [ -n "$msg" ] && msg="$msg | $wl2_warning" || msg="$wl2_warning"
  fi
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"$msg\"}}"
fi
