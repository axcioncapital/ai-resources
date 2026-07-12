# settings.local.json — workspace-root visibility recovery

> **What this is for.** Project Claude Code sessions are sandboxed to their own
> directory. To read shared resources under `ai-resources/` (skills, and the
> symlinked commands/agents), a session needs the workspace root added to
> `permissions.additionalDirectories`. That path is **machine-specific and
> absolute**, so it must live ONLY in the gitignored, per-machine
> `.claude/settings.local.json` — never in the tracked `settings.json`.
> (Canonical rule: `ai-resources/docs/permission-template.md`; root-cause close:
> the `settings-path-portability` mission, 2026-06-26.)
>
> This file is the per-machine recovery snippet. Run it once per project, per
> machine, whenever a project session cannot see `ai-resources/`.

## When you need it

- A freshly cloned/scaffolded project on a new machine, where `settings.local.json`
  does not yet carry the grant.
- After the `settings-path-portability` removal, which deletes the grant from
  tracked `settings.json` as each project is reached — the first wave (11 files)
  landed 2026-06-26; a later retrofit wave (2026-06-29) caught projects deployed
  before the generator fix. Each machine that relied on the grant re-adds it
  locally with the snippet below, once per project it has cloned.
- Symptom: shared skills under `ai-resources/skills/` or symlinked
  commands/agents fail to resolve from inside a project session.

## The snippet (run from the workspace root)

Replace `<project>` with the project directory name (e.g. `strategic-os`).

```bash
command -v jq >/dev/null || { echo "ERROR: jq required"; exit 1; }

PROJECT="<project>"
LOCAL="projects/$PROJECT/.claude/settings.local.json"   # gitignored, per-machine
[ -f "$LOCAL" ] || echo '{}' > "$LOCAL"

# Walk up from the project dir to the nearest ancestor containing ai-resources/
d="$(cd "projects/$PROJECT" && pwd)"
WORKSPACE=""
while [ "$d" != "/" ]; do
  d=$(dirname "$d")
  [ -d "$d/ai-resources" ] && WORKSPACE="$d" && break
done
[ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources not found in any ancestor"; exit 1; }

# Idempotent: adds the absolute workspace root, drops any unfilled {{PLACEHOLDER}},
# preserves every other key already in settings.local.json.
# NOTE: a "model" key must never live in settings.local.json (or any settings
# layer) — workspace CLAUDE.md § Model Tier. If you find one, delete it.
jq --arg dir "$WORKSPACE" \
  '.permissions.additionalDirectories = ((.permissions.additionalDirectories // [] | map(select(startswith("{{") | not))) + [$dir] | unique)' \
  "$LOCAL" > "$LOCAL.tmp" && mv "$LOCAL.tmp" "$LOCAL"

echo "Granted $WORKSPACE in $LOCAL"
```

For a vault or knowledge-base sub-project opened on its own (e.g.
`projects/<project>/vault` or `.../knowledge-base`), point `PROJECT` at that
nested path instead — the walk-up still finds the workspace root.

## Why absolute, not relative

Claude Code resolves `additionalDirectories` relative to the session's launch
CWD, which varies by how the project is opened. A relative form (`../..`) is
therefore **not** reliably portable and can silently grant nothing. An absolute
path is unambiguous — and safe to commit-nowhere because `settings.local.json`
is gitignored on both the workspace and project `.gitignore`.

## What NOT to do

- **Do not** add `additionalDirectories` to the tracked `settings.json`. That is
  the portability defect this whole arrangement exists to prevent.
- **Do not** commit `settings.local.json`. It is gitignored by design.
