---
model: sonnet
---

Apply a small cosmetic tweak to a command or skill: $ARGUMENTS

Use this when the operator has a one-line, cosmetic correction for an existing slash command or skill file — wording, formatting, or a single-line instruction add. Out of scope: multi-section rewrites, scope changes, frontmatter edits, anything that could break downstream-skill interfaces. For those, the operator should run `/improve-skill` instead.

`/tweak` is the rapid-loop supplement to `/improve-skill`. Same target class, smaller scope, single inline edit, operator-confirmed before commit. Companion log lives at `logs/tweak-log.md`.

---

## Step 1: Path setup and argument parsing

1. Resolve `WORKSPACE` (ancestor containing `ai-resources/.claude`), mirroring the same idiom used by `log-sweep.md:20-29`:
   ```bash
   d="$(pwd)"
   WORKSPACE=""
   while [ "$d" != "/" ]; do
     if [ -d "$d/ai-resources/.claude" ]; then WORKSPACE="$d"; break; fi
     d=$(dirname "$d")
   done
   [ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources/ not found in any ancestor of $(pwd)"; exit 1; }
   ```
2. Set `AI_RESOURCES` = `{WORKSPACE}/ai-resources`.
3. Split `$ARGUMENTS` into `TARGET_NAME` (first whitespace-delimited token) and `FEEDBACK` (remainder, with surrounding quotes stripped if present).
4. If either is empty, STOP and tell the operator:
   ```
   /tweak requires: <target-name> "<feedback string>"
   Example: /tweak triage "remove the bold from the first line"
   ```
5. Resolve `TARGET_NAME` to a file path by checking these locations in order under `{AI_RESOURCES}`:
   1. `.claude/commands/{TARGET_NAME}.md`
   2. `skills/{TARGET_NAME}/SKILL.md`
   3. `.claude/agents/{TARGET_NAME}.md`
6. Collect every path that exists. If two or more exist, STOP and ask the operator which surface to target (present the matched paths). If none exist, STOP and tell the operator the name did not resolve.
7. Set `TARGET_PATH` = the resolved single match (absolute path).
8. **Pre-edit dirty-state check** (concurrent-session protection per `commit-discipline.md`): run `git diff --name-only HEAD -- "{TARGET_PATH}"`. If the path is already in the output, STOP and tell the operator `TARGET_PATH` has uncommitted edits from another session — they must commit or stash those before `/tweak` can safely run (rollback semantics would be ambiguous otherwise).
9. **Snapshot the pre-edit blob** so Step 4.5 can do a precise revert without `git checkout` collateral damage:
   ```bash
   PRE_EDIT_SNAPSHOT=$(mktemp -t tweak-snapshot.XXXXXX.md)
   cp "{TARGET_PATH}" "$PRE_EDIT_SNAPSHOT"
   ```
   Hold `PRE_EDIT_SNAPSHOT` for Step 4.5.

---

## Step 2: Scope gate

Before spawning the fixing subagent, classify `FEEDBACK`. STOP and tell the operator to run `/improve-skill` instead if ANY of these fires:

- `FEEDBACK` contains the words `rewrite`, `restructure`, or `reorganize` (case-insensitive).
- `FEEDBACK` names more than one section, step, or surface (e.g., "Steps 2 and 4", "the YAML and the Step 5 body").
- `FEEDBACK` proposes adding a new step, sub-step, or section.
- `FEEDBACK` changes a trigger claim, exclusion claim, or output-format claim documented in the file's YAML description.
- `FEEDBACK` targets any YAML frontmatter field (`model:`, `effort:`, `description:`, `name:`, `allowed-tools:`, or any other field within the `---` fenced block at the top of the file). Frontmatter changes shift load behavior and model declarations — route to `/improve-skill` regardless of edit size.

If none fire, proceed.

---

## Step 3: Spawn fixing subagent

Spawn a `general-purpose` subagent with fresh context via the `Agent` tool. Pass it ONLY:

- The absolute `TARGET_PATH`.
- `FEEDBACK` verbatim.
- The instructions below.

Do NOT pass prior conversation history.

**Subagent prompt (verbatim shape):**

> You have one markdown file (a slash command or skill) and one short feedback string from the operator. Read the file from `{TARGET_PATH}`. Apply the smallest possible inline edit that resolves the feedback. Do not rewrite surrounding content. Do not reorder sections. Do not "improve" adjacent text.
>
> After editing, re-read the edited region and confirm in one sentence that the change matches the feedback. If the feedback cannot be resolved with a single inline edit (it requires multi-step or structural change), do NOT edit the file — return `ESCALATE: <one-line reason>` instead.
>
> Return only:
> - The applied edit as a unified diff (target-only, no surrounding-file context).
> - The one-sentence match confirmation.
> - OR `ESCALATE: <reason>` if the feedback exceeds single-edit scope.
>
> 20-line summary cap.

---

## Step 4: Handle subagent return

- **Edit applied + confirmation present:** show the diff and the confirmation to the operator inline. Proceed to Step 4.5.
- **ESCALATE returned:** show the escalation reason. STOP. Suggest the operator run `/improve-skill {TARGET_NAME}` for the structural change.

---

## Step 4.5: Diff-confirm gate [SO-CHANGE-1]

After showing the diff and confirmation, present the operator with a two-option pick via `AskUserQuestion` (matches the established 2-option select shape used by sibling commands like `/log-sweep`):

- Question: `Apply this edit to {TARGET_PATH}?`
- Options: `Apply` / `Discard`

Branches:

- **Apply** → proceed to Step 5. Clean up the snapshot afterwards: `rm -f "$PRE_EDIT_SNAPSHOT"`.
- **Discard** → STOP. The subagent already wrote the edit to disk in Step 3, so revert via the snapshot (NOT `git checkout`, which would wipe concurrent uncommitted edits anywhere in the working tree):
  ```bash
  cp "$PRE_EDIT_SNAPSHOT" "{TARGET_PATH}"
  rm -f "$PRE_EDIT_SNAPSHOT"
  ```
  Tell the operator the edit was discarded and suggest restating the feedback if they want to retry.

This gate exists because edits to canonical commands and skills auto-symlink to every project at next SessionStart (workspace `CLAUDE.md` Autonomy Rules; `risk-topology.md § 1`). The one-keystroke cost preserves the rapid-loop pitch; the structural protection is non-negotiable.

---

## Step 5: Commit

Per workspace `Commit behavior` and `ai-resources/CLAUDE.md` § Git Rules:

1. Compute `ONELINE` from `FEEDBACK`: truncate to ~60 characters at a word boundary if longer.
2. Stage only the explicit `TARGET_PATH` (no wildcards) — concurrent-session staging discipline per `commit-discipline.md`:
   ```bash
   git add "{TARGET_PATH}"
   ```
3. Commit with a heredoc message:
   ```bash
   git commit -m "$(cat <<EOF
   update: {TARGET_NAME} — {ONELINE}

   Applied via /tweak.

   Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
   EOF
   )"
   ```
   Note: the heredoc delimiter is unquoted (`EOF`, not `'EOF'`) so `{TARGET_NAME}` and `{ONELINE}` interpolate; substitute them as literal values at runtime.
4. **Do NOT push.** Pushes are batched and gated to the `/wrap-session` confirmation prompt (workspace `CLAUDE.md` § Push behavior). The commit stays local; `/wrap-session` counts it and asks once before pushing.
5. Capture `SHORT_SHA`:
   ```bash
   SHORT_SHA=$(git rev-parse --short HEAD)
   ```

---

## Step 5a: Append to tweak-log.md [SO-CHANGE-3, mitigation (b)]

After the push completes, append one bullet under today's dated block in `{AI_RESOURCES}/logs/tweak-log.md`. The header-spacing logic emits a leading blank line only when the file does NOT already end with one, so the file's `## ` block separators stay single-blank-line consistent with `split-log.sh`'s expectations:

```bash
DATE=$(date +%Y-%m-%d)
LOGFILE="$AI_RESOURCES/logs/tweak-log.md"
HEADER="## ${DATE} — /tweak invocations"
BULLET="- \`/tweak ${TARGET_NAME}\` — ${ONELINE} — commit ${SHORT_SHA}"

# Ensure the file ends with exactly one trailing newline before we touch it.
[ -n "$(tail -c1 "$LOGFILE")" ] && printf "\n" >> "$LOGFILE"

if ! grep -qF "$HEADER" "$LOGFILE"; then
  # New day — emit blank-line separator then header then blank line then bullet.
  printf "\n%s\n\n%s\n" "$HEADER" "$BULLET" >> "$LOGFILE"
else
  # Header already exists for today — just append the bullet at file end
  # (today's block is the last block, so end-of-file == under-today's-header).
  printf "%s\n" "$BULLET" >> "$LOGFILE"
fi
```

Substitute `${TARGET_NAME}` and `${ONELINE}` and `${SHORT_SHA}` as literal values at runtime.

Then stage `tweak-log.md` as a separate commit (do not mix log-append with the substantive command edit):

```bash
git add "$AI_RESOURCES/logs/tweak-log.md"
git commit -m "$(cat <<EOF
log: tweak-log.md — record /tweak ${TARGET_NAME}

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

**Do NOT push either commit.** Pushes are batched and gated to the `/wrap-session` confirmation prompt (workspace `CLAUDE.md` § Push behavior).

This dual-commit shape keeps the audit trail visible in the Friday cadence (the file is registered in `log-sweep.md` Cat A2 with KEEP=10 dated blocks) without overloading `maintenance-observations.md`'s single-writer contract. Per System Owner second-opinion in risk-check report `2026-05-29-tweak-command-creation.md`: one writer × one purpose × one file (`repo-architecture.md` § Q6 canonical pattern; DR-7; OP-3).

---

## Step 6: Report to operator

Tell the operator in one line:

```
Tweak applied: {TARGET_PATH} — commit {SHORT_SHA}. Logged to tweak-log.md.
```

Stop. Do not propose adjacent edits.
