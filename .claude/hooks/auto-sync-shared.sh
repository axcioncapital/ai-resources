#!/bin/bash
# auto-sync-shared.sh — SessionStart hook
#
# Walks ai-resources/.claude/{commands,agents}/ and symlinks every file into
# the project, EXCEPT:
#
# Agent skills (ai-resources/.agents/skills/) are opt-in except for the small
# CORE_SHARED_SKILLS set below. A project gets other shared skills only by naming
# them in .claude/shared-manifest.json under skills.shared. The core exception is
# reserved for workspace-wide capabilities that replace globally distributed
# commands; everything else remains curated per project.
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

# Keep this static and one-line: it is the explicit, reviewable exception to
# manifest opt-in for skills that must be reachable wherever shared commands are.
CORE_SHARED_SKILLS="diagnose-and-fix"

# Agent skills are core + opt-in — see the header. skills.shared is the only
# used `shared` array in the manifest; commands/agents.shared are documentation.
LOCAL_SKILLS=$(jq -r '.skills.local[]?' "$MANIFEST" 2>/dev/null)
SHARED_SKILLS="$CORE_SHARED_SKILLS $(jq -r '.skills.shared[]?' "$MANIFEST" 2>/dev/null)"

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

# Generated destinations are checkout-local products, not repository content:
# every symlink this hook manages is covered by one marked block in the
# repository's LOCAL exclude file (info/exclude — never .gitignore), rewritten
# exactly on each run. The exclude set is derived inside the same sync loops
# that generate the links, so there is no second generated-path interpretation
# to drift. Fail open throughout: a project outside any Git repository, or a
# hand-mangled block, skips maintenance rather than risking content loss.
EXCL_BEGIN="# BEGIN auto-sync-shared generated symlinks — managed block, do not edit"
EXCL_END="# END auto-sync-shared generated symlinks"
repo_top=$(git -C "$PROJECT_DIR" rev-parse --show-toplevel 2>/dev/null)
exclude_file=$(git -C "$PROJECT_DIR" rev-parse --git-path info/exclude 2>/dev/null)
case "$exclude_file" in
  '') ;;
  /*) ;;
  *) exclude_file="$PROJECT_DIR/$exclude_file" ;;
esac
managed_excludes=""
managed_pairs=""

rel_in_repo() {
  # Repository-relative path of $1, or failure when it is outside repo_top or
  # there is no repository. One owner for this conversion: the managed exclude
  # entries and the health verdicts below must name the same path for the same
  # destination, and two spellings of it is how they would come to disagree.
  local dest rel
  dest="$1"
  [ -n "$repo_top" ] || return 1
  case "$dest" in
    "$repo_top"/*) rel="${dest#"$repo_top"/}" ;;
    *)
      # PROJECT_DIR may reach the same tree through symlinked path components
      # (e.g. /var vs /private/var); retry against the physical path.
      dest="$(cd "$(dirname "$dest")" 2>/dev/null && pwd -P)/$(basename "$dest")"
      case "$dest" in
        "$repo_top"/*) rel="${dest#"$repo_top"/}" ;;
        *) return 1 ;;
      esac
      ;;
  esac
  printf '%s' "$rel"
}

note_generated() {
  # <destination> <canonical-source> <kind>. Called from inside the sync loops,
  # so both records below come from the one authoritative traversal.
  #
  # Two records, and they are deliberately NOT the same set:
  #
  #   * managed_pairs — every destination the loops traverse, whatever is at that
  #     path right now. Health validation needs the traversal itself, because
  #     "this managed name is not a symlink" is a thing it must be able to say,
  #     and a set filtered to symlinks could never say it.
  #   * managed_excludes — only a symlink at a managed name, the observable mark
  #     of a generated product. A regular file at the same name is project-owned
  #     (drift detection reports it) and must never be ignored.
  local dest rel
  dest="$1"
  managed_pairs="${managed_pairs}${3}|${dest}|${2}
"
  [ -n "$repo_top" ] && [ -L "$dest" ] || return 0
  rel=$(rel_in_repo "$dest") || return 0
  managed_excludes="${managed_excludes}/${rel}
"
}

write_exclude_block() {
  [ -n "$repo_top" ] && [ -n "$exclude_file" ] || return 0
  local tmp begins ends
  if [ -f "$exclude_file" ]; then
    begins=$(grep -cxF "$EXCL_BEGIN" "$exclude_file" 2>/dev/null || true)
    ends=$(grep -cxF "$EXCL_END" "$exclude_file" 2>/dev/null || true)
    begins=${begins:--1}; ends=${ends:--1}
    # Maintain only a well-formed file: no block, or exactly one balanced
    # block. Anything else was hand-edited — leave the file untouched.
    if ! { [ "$begins" -eq 0 ] && [ "$ends" -eq 0 ]; } &&
       ! { [ "$begins" -eq 1 ] && [ "$ends" -eq 1 ]; }; then
      return 0
    fi
  fi
  tmp=$(mktemp) || return 0
  if [ -f "$exclude_file" ]; then
    awk -v b="$EXCL_BEGIN" -v e="$EXCL_END" '
      $0 == b {inblock=1; next}
      $0 == e {inblock=0; next}
      !inblock {print}
    ' "$exclude_file" >"$tmp"
  fi
  if [ -n "$managed_excludes" ]; then
    {
      printf '%s\n' "$EXCL_BEGIN"
      printf '%s' "$managed_excludes" | LC_ALL=C sort -u
      printf '%s\n' "$EXCL_END"
    } >>"$tmp"
  fi
  if [ -f "$exclude_file" ] && cmp -s "$tmp" "$exclude_file"; then
    rm -f "$tmp"
  elif mkdir -p "$(dirname "$exclude_file")" 2>/dev/null; then
    mv -f "$tmp" "$exclude_file" 2>/dev/null || rm -f "$tmp"
  else
    rm -f "$tmp"
  fi
}

# Generated-guard installation and refresh.
#
# The commit-boundary guard that refuses staged generated destinations (Guard 3
# of .claude/hooks/pre-commit) only runs from the checkout's EXECUTING hook path,
# and until now nothing put it there — the sweep above symlinks commands, agents
# and skills, and a tracked file at .claude/hooks/pre-commit is not a hook Git
# runs. Installing it belongs HERE rather than in a general hook manager, because
# this script is already the single owner of the generated-destination contract:
# the managed exclude block written above is exactly what the guard consumes. A
# separate installer would be a second owner of one contract.
#
# Two hard limits, and their order matters:
#
#   1. A SYMLINK at the hook path is classified FIRST and is never followed,
#      replaced or chmod'ed. Real projects here point pre-commit at a
#      project-owned script; following the link would overwrite that script's
#      own contents, which is worse than not installing at all.
#   2. A differing regular body is refreshed ONLY on exact evidence that it is a
#      copy of this canonical hook — the provenance marker, or the one full
#      digest of the exact pre-marker body that shipped before the marker
#      existed. Every other marker-less body is project-owned: reported, never
#      touched. There is deliberately NO "looks like our hook" heuristic. A
#      workspace-root copy in this very repository's own lineage (canonical as of
#      3878b4de) is marker-less and is NOT the pre-marker ancestor, so it stays
#      untouched — a header-similarity test would have overwritten it.
#
# Fail open throughout, exactly like the rest of this SessionStart hook: no
# canonical body, no digest tool, an unwritable hook directory or a failed write
# skips the work and reports it. A failed write cannot corrupt an installed hook,
# because the new body is staged in a sibling temp file and only ever moved into
# place atomically — the destination holds either the old body or the whole new
# one, never a half-written one.
GUARD_MARKER="# managed-by: auto-sync-shared.sh — canonical .claude/hooks/pre-commit"
# Exactly ONE entry, and it stays exactly one: the full SHA-256 of the tracked
# pre-commit body at 638ab8cc — the last canonical body before GUARD_MARKER
# existed. This is the only marker-less body that may ever be refreshed. Do not
# grow it into a list of "known old versions": every addition widens the set of
# project-owned bodies that could collide with it, and the marker already covers
# everything shipped since.
GUARD_ANCESTOR_SHA256="6c75cb196970bf1d4867167b93dc82cf39ae6d85191a8b20f7f51681f5f5c3f5"
guard_report=""

guard_sha256() {
  local out
  if command -v shasum >/dev/null 2>&1; then
    out=$(shasum -a 256 "$1" 2>/dev/null) || return 1
  elif command -v sha256sum >/dev/null 2>&1; then
    out=$(sha256sum "$1" 2>/dev/null) || return 1
  else
    return 1
  fi
  printf '%s' "${out%% *}"
}

guard_write() {
  # <destination> <canonical-source>. Atomic, and the prior body survives every
  # failure path. Returns 1 with guard_report set when it could not write.
  local dest="$1" src="$2" tmp
  mkdir -p "$(dirname "$dest")" 2>/dev/null || {
    guard_report="could not create the hook directory for $dest; the generated-symlink commit guard was not installed and nothing was changed"
    return 1
  }
  # The temp file is a SIBLING of the destination so the mv below is a rename
  # within one filesystem rather than a copy that can fail half-written.
  tmp=$(mktemp "$(dirname "$dest")/.pre-commit.XXXXXX" 2>/dev/null) || {
    guard_report="could not stage a new pre-commit beside $dest (directory not writable); any existing hook was left untouched"
    return 1
  }
  if ! cat "$src" >"$tmp" 2>/dev/null ||
     ! chmod +x "$tmp" 2>/dev/null ||
     ! mv -f "$tmp" "$dest" 2>/dev/null; then
    rm -f "$tmp" 2>/dev/null
    guard_report="failed to write the pre-commit guard at $dest; the previous hook body was left in place"
    return 1
  fi
  return 0
}

install_generated_guard() {
  local canonical hook_path
  canonical="$AI_RESOURCES/.claude/hooks/pre-commit"
  [ -f "$canonical" ] && [ -r "$canonical" ] || return 0
  [ -n "$repo_top" ] || return 0
  # Canonical must carry the marker. Installing a marker-less body would create a
  # copy this script could never recognise again, so it would never be refreshed.
  if ! grep -Fxq "$GUARD_MARKER" "$canonical" 2>/dev/null; then
    guard_report="canonical pre-commit at $canonical carries no provenance marker; guard installation was skipped"
    return 0
  fi

  # The executing hook path — asked of Git, and never built here. Two things this
  # single call already gets right, both of which hand-rolled resolution gets
  # wrong:
  #
  #   * a LINKED WORKTREE resolves hooks/ to the SHARED common directory, which
  #     is the surface it actually runs. There is no .git directory to nest into,
  #     so constructing the path from directory layout cannot work at all.
  #   * core.hooksPath is ALREADY honoured, including its tilde form. Do not add
  #     a `git config --get core.hooksPath` branch back: with
  #     core.hooksPath='~/guard-hooks', Git executes $HOME/guard-hooks/pre-commit,
  #     while prefixing the raw config value with the repo top yields
  #     <repo-top>/~/guard-hooks/pre-commit — a literal `~` directory that Git
  #     never executes. That was measured, and it is why this is one call.
  hook_path=$(git -C "$PROJECT_DIR" rev-parse --git-path hooks/pre-commit 2>/dev/null) || return 0
  [ -n "$hook_path" ] || return 0
  case "$hook_path" in
    /*) ;;
    # --git-path answers relative to the cwd of the git call, which is
    # $PROJECT_DIR here — the same resolution the exclude path above uses. It
    # stays relative for a default .git/hooks and for a relative core.hooksPath
    # alike (`custom-hooks/pre-commit` from the root, `../custom-hooks/pre-commit`
    # from a subdirectory), so this anchoring covers both.
    *) hook_path="$PROJECT_DIR/$hook_path" ;;
  esac

  # Symlink test FIRST, before any regular-file test — see limit 1 above.
  if [ -L "$hook_path" ]; then
    guard_report="pre-commit at $hook_path is a symlink to a project-owned hook (-> $(readlink "$hook_path")); the generated-symlink commit guard was NOT installed and neither the link nor its target was touched"
    return 0
  fi

  if [ ! -e "$hook_path" ]; then
    guard_write "$hook_path" "$canonical" || return 0
    guard_report="installed the generated-symlink commit guard at $hook_path (this checkout only)"
    return 0
  fi

  if [ ! -f "$hook_path" ]; then
    guard_report="pre-commit at $hook_path is neither a regular file nor a symlink; left untouched"
    return 0
  fi

  if cmp -s "$canonical" "$hook_path"; then
    # Already current: no write at all, so bytes and mtime are both unchanged.
    # The mode is still corrected when needed — chmod does not alter mtime, and a
    # non-executable copy would silently never run.
    [ -x "$hook_path" ] || chmod +x "$hook_path" 2>/dev/null || true
    return 0
  fi

  if grep -Fxq "$GUARD_MARKER" "$hook_path" 2>/dev/null; then
    guard_write "$hook_path" "$canonical" &&
      guard_report="refreshed the managed pre-commit guard at $hook_path (this checkout only)"
    return 0
  fi

  if [ "$(guard_sha256 "$hook_path")" = "$GUARD_ANCESTOR_SHA256" ]; then
    guard_write "$hook_path" "$canonical" &&
      guard_report="refreshed the pre-marker canonical pre-commit at $hook_path to the marker-bearing body (this checkout only)"
    return 0
  fi

  guard_report="pre-commit at $hook_path is project-owned (no canonical provenance marker, and not the one known pre-marker canonical body); the generated-symlink commit guard was NOT installed and the file was left byte-for-byte untouched"
}

# Generated-link health validation.
#
# The last question this hook could not answer: are the destinations it manages
# actually HEALTHY? Existence is not health, and each of these has happened — a
# link left pointing at a resource that moved, a generated destination re-tracked
# by `git add -f`, and a destination silently outside the ignore block because an
# exclude write was skipped. So four properties are measured per destination:
# it is a symlink, it resolves to its expected canonical source, it is not
# tracked, and it is covered by the marked block.
#
# It reuses this script's own traversal and its own written block rather than
# re-reading the manifest, the exclude lists or skill membership. A second
# interpretation of membership is exactly the drift the rest of this task removed:
# $managed_pairs is recorded by note_generated inside the generating loops, and
# coverage is read back OFF DISK the same way Guard 3 of .claude/hooks/pre-commit
# consumes it — because coverage means "present in that file", and a skipped or
# refused exclude write is one of the failures this must catch.
#
# What reaching this check means, and why a non-symlink here is NOT project-owned:
# LOCAL_COMMANDS, LOCAL_AGENTS and LOCAL_SKILLS each remove a manifest-declared
# resource from its loop BEFORE note_generated records it. So every destination in
# $managed_pairs is a name the manifest left under shared management, and whatever
# occupies it that is not a symlink is an UNDECLARED collision on a generated
# name, not an owned file. Nothing else reports that: it never enters the managed
# exclude block (note_generated lists symlinks only), so the commit guard which
# consumes that block cannot see it either, and it can be committed with no
# verdict anywhere. The drift pass below does not close the gap — it reports only
# command/agent regular files whose CONTENT differs, so a byte-identical copy is
# silent, and skills deliberately have no drift pass at all.
#
# So each state gets a verdict, and none gets a repair:
#
#   * a SYMLINK at a managed name is a generated product — the four checks apply;
#   * anything else that exists there is reported as "not a symlink" with the
#     manifest-local correction, and is left byte-untouched and unignored. The
#     drift message keeps its own separate ownership of content divergence, so a
#     DIFFERING command copy is named by both: they are two different findings
#     about one file, not a duplicate.
#
# Fail open, like everything else here: no repository, no readable exclude file,
# no resolvable path — it reports what it found and the session starts anyway. It
# never repairs, re-links or deletes, and it never mutates a destination to make
# its own check pass.
health_report=""

phys_of() {
  # Physical path of what $1 finally points at, or failure if it points nowhere.
  # Resolution is by where a link LANDS, which is what lets a correct relative
  # target pass at any checkout depth without any absolute path being written
  # into repository content. Pure shell plus `readlink` with no flags on purpose:
  # `readlink -f` and `realpath` are both absent or different on some platforms
  # this hook runs on, and python3 is already the one dependency that made the
  # sync loops above need a failure branch.
  local p b d t n
  p="$1"
  b=$(basename "$p")
  d=$(cd "$(dirname "$p")" 2>/dev/null && pwd -P) || return 1
  p="$d/$b"
  n=0
  while [ -L "$p" ] && [ "$n" -lt 20 ]; do
    t=$(readlink "$p") || return 1
    case "$t" in
      /*) ;;
      *) t="$(dirname "$p")/$t" ;;
    esac
    b=$(basename "$t")
    d=$(cd "$(dirname "$t")" 2>/dev/null && pwd -P) || return 1
    p="$d/$b"
    n=$((n + 1))
  done
  [ -e "$p" ] || return 1
  if [ -d "$p" ]; then (cd "$p" 2>/dev/null && pwd -P) || return 1; else printf '%s' "$p"; fi
}

validate_generated_health() {
  [ -n "$repo_top" ] || return 0
  local pairs health_block health_tracked line kind dest src rel
  local i n reasons health_phys health_src_phys health_what
  local -a h_kinds=() h_dests=() h_srcs=() h_rels=()

  pairs=$(printf '%s' "$managed_pairs" | LC_ALL=C sort -u)
  [ -n "$pairs" ] || return 0

  health_block=""
  if [ -n "$exclude_file" ] && [ -f "$exclude_file" ]; then
    health_block=$(awk -v b="$EXCL_BEGIN" -v e="$EXCL_END" \
      '$0==e{inb=0} inb{print} $0==b{inb=1}' "$exclude_file" 2>/dev/null || true)
  fi

  while IFS= read -r line; do
    [ -n "$line" ] || continue
    kind=${line%%|*}; line=${line#*|}
    dest=${line%%|*}; src=${line#*|}
    rel=$(rel_in_repo "$dest") || continue
    h_kinds+=("$kind"); h_dests+=("$dest"); h_srcs+=("$src"); h_rels+=("$rel")
  done <<EOF
$pairs
EOF
  n=${#h_rels[@]}
  [ "$n" -gt 0 ] || return 0

  # One `git ls-files` call for the whole managed set. This runs on every session
  # start, so a per-destination invocation would add dozens of git processes to
  # something that must stay unnoticeable.
  health_tracked=$(git -C "$repo_top" ls-files -z -- "${h_rels[@]}" 2>/dev/null | tr '\0' '\n')

  i=0
  while [ "$i" -lt "$n" ]; do
    kind="${h_kinds[$i]}"; dest="${h_dests[$i]}"; src="${h_srcs[$i]}"; rel="${h_rels[$i]}"
    i=$((i + 1))
    if [ -L "$dest" ]; then
      reasons=""
      if ! health_phys=$(phys_of "$dest"); then
        reasons="dangling, it resolves to nothing (delete it and let the next session start regenerate it)"
      elif ! health_src_phys=$(phys_of "$src"); then
        reasons="its canonical source $src cannot be resolved"
      elif [ "$health_phys" != "$health_src_phys" ]; then
        reasons="it resolves to $health_phys, not to the canonical $health_src_phys"
      fi
      if printf '%s\n' "$health_tracked" | grep -Fxq "$rel"; then
        reasons="${reasons:+$reasons; }tracked by Git, so a checkout-local product is committed content (git rm --cached $rel)"
      fi
      if [ -z "$health_block" ] || ! printf '%s\n' "$health_block" | grep -Fxq "/$rel"; then
        reasons="${reasons:+$reasons; }not covered by the managed block in ${exclude_file:-the local exclude file}"
      fi
      [ -n "$reasons" ] && health_report="${health_report}[$rel: $reasons]
"
    elif [ ! -e "$dest" ]; then
      health_report="${health_report}[$rel: the managed link is absent after this run, so nothing was generated at that name]
"
    else
      # Undeclared collision on a shared-generated name — see the note above for
      # why the manifest opt-outs make that the only reading. Reported, and
      # nothing else: it stays byte-untouched, unignored, and the session starts.
      # The correction is the operator's choice between declaring it local and
      # removing it, and both are theirs to make, not this hook's.
      if [ -d "$dest" ]; then health_what="a directory"
      elif [ -f "$dest" ]; then health_what="a regular file"
      else health_what="neither a regular file nor a directory"
      fi
      health_report="${health_report}[$rel: not a symlink, $health_what occupies this shared-generated name and was left untouched; declare it under ${kind}s.local in .claude/shared-manifest.json to own it, or remove it so the next session start regenerates the link]
"
    fi
  done
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
  note_generated "$target" "$src" command
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/commands"
  if ! rel_src=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    failed="$failed ${name}.md"
    continue
  fi
  ln -s "$rel_src" "$target"  # relative target — see header comment above
  note_generated "$target" "$src" command
  synced="$synced ${name}.md"
done

# Sync agents.
for src in "$AI_RESOURCES"/.claude/agents/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  if [ "$IS_WORKSPACE_ROOT" -eq 0 ] && matches_glob "$name" "$EXCLUDE_AGENT_GLOBS"; then continue; fi
  in_list "$name" "$LOCAL_AGENTS" && continue
  target="$PROJECT_DIR/.claude/agents/${name}.md"
  note_generated "$target" "$src" agent
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/agents"
  if ! rel_src=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    failed="$failed ${name}.md"
    continue
  fi
  ln -s "$rel_src" "$target"  # relative target — see header comment above
  note_generated "$target" "$src" agent
  synced="$synced ${name}.md"
done

# Sync agent skills — core + OPT-IN via skills.shared. Each source is a DIRECTORY
# holding SKILL.md, so the symlink target is a dir, not a file. A named source
# absent from ai-resources is a manifest error, reported through "$unknown".
for name in $SHARED_SKILLS; do
  in_list "$name" "$LOCAL_SKILLS" && continue
  src="$AI_RESOURCES/.agents/skills/$name"
  if [ ! -d "$src" ]; then
    unknown="$unknown $name"
    continue
  fi
  target="$PROJECT_DIR/.agents/skills/$name"
  note_generated "$target" "$src" skill
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.agents/skills"
  if ! rel_src=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$src" "$(dirname "$target")" 2>/dev/null) || [ -z "$rel_src" ]; then
    failed="$failed skills/$name"
    continue
  fi
  ln -s "$rel_src" "$target"  # relative target — see header comment above
  note_generated "$target" "$src" skill
  synced="$synced skills/$name"
done

# Rewrite the managed local-exclude block from what the loops above actually
# generated (or found already generated) this run.
write_exclude_block

# Then make sure the commit-boundary guard that CONSUMES that block is actually
# installed where this checkout's Git will run it. Same owner, same contract.
install_generated_guard

# Finally judge the health of what the traversal above owns. It runs LAST on
# purpose: the links have been generated and the managed block has been written,
# so this is the first point at which all four properties can be measured on the
# final state rather than on a half-finished one.
validate_generated_health

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

if [ -n "$synced" ] || [ -n "$drifted" ] || [ -n "$failed" ] || [ -n "$unknown" ] || [ -n "$wl2_warning" ] || [ -n "$guard_report" ] || [ -n "$health_report" ]; then
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
  if [ -n "$guard_report" ]; then
    # Own prefix, like the two above, so this can fire alongside them without
    # ambiguity. Scoped to THIS checkout on purpose: one SessionStart run says
    # nothing about any other project's hook surface.
    guard_msg="GENERATED-GUARD: $guard_report"
    [ -n "$msg" ] && msg="$msg | $guard_msg" || msg="$guard_msg"
  fi
  if [ -n "$health_report" ]; then
    # Own prefix, one bracketed entry per affected path. Nothing was repaired and
    # nothing blocks the session: this is a report of state, and each entry names
    # the path and what is wrong with it so the operator can act on the specific
    # one rather than on a count.
    health_count=$(printf '%s' "$health_report" | grep -c . | tr -d ' ')
    health_msg="GENERATED-HEALTH: $health_count managed destination(s) are not healthy; nothing was changed or repaired: $(printf '%s' "$health_report" | tr '\n' ' ' | sed 's/ *$//')"
    [ -n "$msg" ] && msg="$msg | $health_msg" || msg="$health_msg"
  fi
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"$msg\"}}"
fi
