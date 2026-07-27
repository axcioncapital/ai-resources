---
model: sonnet
---

Usage: /deploy-workflow [project-name]

Initialize a new project from a workflow template. Handles copying, placeholder replacement, skill symlinks, git init, and initial commit.

Arguments: `$ARGUMENTS` — optional project name in kebab-case (e.g., `market-entry-analysis`). If omitted, you will be asked.

---

## Step 1: Discover available templates

Scan for directories matching `workflows/*/` within the `ai-resources/` repo. Each subdirectory is an available workflow template.

- If **one template** found: auto-select it and tell the user which template you're using.
- If **multiple templates** found: list them and ask the user to pick one.
- If **none found**: stop and tell the user no templates are available.

Set `TEMPLATE_PATH` to the selected template directory (e.g., `ai-resources/workflows/research-workflow/`).
Set `WORKSPACE_ROOT` to the parent of the `ai-resources/` directory (the Axcíon AI workspace root containing `projects/`, etc.).

## Step 2: Get project name

If `$ARGUMENTS` contains a project name, use it. Otherwise, ask the user for a kebab-case project name.

Validate: lowercase letters, numbers, and hyphens only. No spaces, no uppercase.

Set `PROJECT_NAME` to the validated name.
Set `PROJECT_DIR` to `{WORKSPACE_ROOT}/projects/{PROJECT_NAME}`.

Verify `{PROJECT_DIR}` does not already exist. If it does, stop and tell the user.

## Step 3: Copy template, then activate the project CLAUDE.md

```bash
cp -r {TEMPLATE_PATH}/ {PROJECT_DIR}/
```

### 3a. Rename `CLAUDE.md.template` → `CLAUDE.md`

The canonical template ships its project `CLAUDE.md` under the **non-active filename** `CLAUDE.md.template`. That is deliberate: a file literally named `CLAUDE.md` inside `ai-resources/workflows/` is loaded as nested instructions by any session working under that directory, so the resource repo would inherit deployed-project rules and unresolved `{{PLACEHOLDER}}` tokens as if they were live instructions. Storing it inert and activating it here is what keeps the template out of the resource repo's own instruction load.

**This rename must happen now — before Step 5's fill-scope construction and before Step 7's placeholder replacement.** `CLAUDE.md.template` matches neither `*.md` nor `*.json`, so it is invisible to the fill scope; leaving the rename until after Step 7 would deploy a `CLAUDE.md` whose 22 Class-A placeholders are all still unresolved.

```bash
# Rename first, then confirm — the confirmation below asserts the post-rename state.
[ -f "{PROJECT_DIR}/CLAUDE.md.template" ] || { echo "ERROR: {PROJECT_DIR}/CLAUDE.md.template not found after copy — the template may not carry one, or the copy failed"; exit 1; }
mv "{PROJECT_DIR}/CLAUDE.md.template" "{PROJECT_DIR}/CLAUDE.md"
```

### 3b. Confirm the copy and the activation

Three assertions, all required:

```bash
# 1. The copy succeeded and the project CLAUDE.md is now active.
[ -f "{PROJECT_DIR}/CLAUDE.md" ] || { echo "ERROR: no CLAUDE.md in {PROJECT_DIR} after rename"; exit 1; }

# 2. No inert copy was left behind. A surviving .template would be dead weight in the
#    deployed project and a second, drifting source of the same rules.
#    Written as `if`, NOT as `[ -e … ] && { …; exit 1; }`: the `&&` form returns 1 when the
#    file is correctly absent, so as the last statement in a block it reports failure on the
#    success path. Same silent-wrong-result class as the two shell traps logged 2026-07-27.
if [ -e "{PROJECT_DIR}/CLAUDE.md.template" ]; then
  echo "ERROR: CLAUDE.md.template still present in {PROJECT_DIR} after rename"
  exit 1
fi

echo "Project CLAUDE.md activated from CLAUDE.md.template"
```

## Step 4: Enrich with shared ai-resources features

Symlink shared commands and agents from `ai-resources/.claude/` into the deployed project. The template includes a **shared manifest** (`.claude/shared-manifest.json`) that declares which files are shared (symlinked to ai-resources) vs local (template-owned copies). A SessionStart hook (`auto-sync-shared.sh`) reads this manifest to auto-create missing symlinks on every session start — so new commands added to ai-resources appear in projects automatically.

### How it works

The manifest has two sections per category (`commands`, `agents`):
- **`local`** — template-owned files. Already in the project from Step 3. Never overwritten, never symlinked.
- **`shared`** — symlinked to ai-resources. Created here in Step 4, and auto-maintained by the SessionStart hook.

### Hooks

Hooks are always **copied** (not symlinked) because they may need project-specific paths. Hooks excluded from copying:

**Hooks:** `pre-commit`, `check-template-drift.sh`

### Enrichment logic

**Symlink path rule:** Always use **relative** symlinks so the workspace stays portable. From `projects/{name}/.claude/commands/` or `.claude/agents/`, the relative path back to `ai-resources/` is computed by counting directory levels between the symlink location and the workspace root. For the standard layout (`projects/{name}/.claude/commands/`), that's 4 levels up: `../../../../ai-resources/.claude/commands/{file}`. If a project is nested deeper or shallower, compute the correct depth — do not hardcode.

```bash
AI_RESOURCES="{WORKSPACE_ROOT}/ai-resources"
MANIFEST="{PROJECT_DIR}/.claude/shared-manifest.json"

# Compute relative path from project .claude/commands/ to ai-resources .claude/commands/
# For projects/{name}/.claude/commands/ → ../../../../ai-resources/.claude/commands/
REL_CMD="$(python3 -c "import os; print(os.path.relpath('$AI_RESOURCES/.claude/commands', '{PROJECT_DIR}/.claude/commands'))")"
REL_AGT="$(python3 -c "import os; print(os.path.relpath('$AI_RESOURCES/.claude/agents', '{PROJECT_DIR}/.claude/agents'))")"

# Commands — symlink shared entries from manifest
mkdir -p "{PROJECT_DIR}/.claude/commands"
for name in $(jq -r '.commands.shared[]' "$MANIFEST"); do
  src="$AI_RESOURCES/.claude/commands/${name}.md"
  target="{PROJECT_DIR}/.claude/commands/${name}.md"
  [ -f "$src" ] || continue
  [ -e "$target" ] || [ -L "$target" ] && continue
  ln -s "$REL_CMD/${name}.md" "$target"
done

# Agents — symlink shared entries from manifest
mkdir -p "{PROJECT_DIR}/.claude/agents"
for name in $(jq -r '.agents.shared[]' "$MANIFEST"); do
  src="$AI_RESOURCES/.claude/agents/${name}.md"
  target="{PROJECT_DIR}/.claude/agents/${name}.md"
  [ -f "$src" ] || continue
  [ -e "$target" ] || [ -L "$target" ] && continue
  ln -s "$REL_AGT/${name}.md" "$target"
done

# Hooks (copy — not symlinked)
EXCLUDE_HOOKS="pre-commit check-template-drift.sh auto-sync-shared.sh"
mkdir -p "{PROJECT_DIR}/.claude/hooks"
for f in "$AI_RESOURCES/.claude/hooks/"*; do
  [ ! -f "$f" ] && continue
  name=$(basename "$f")
  echo "$EXCLUDE_HOOKS" | grep -qw "$name" && continue
  [ -f "{PROJECT_DIR}/.claude/hooks/$name" ] && continue
  cp "$f" "{PROJECT_DIR}/.claude/hooks/"
done
```

### Report what was added

After copying, report what was enriched:

```
Enriched project with shared features from ai-resources:
  Commands added: [list names]
  Agents added: [list names]
  Hooks added: [list names]
  Skipped (already in template): [list names]
```

If nothing was added (template already has everything), say so.

### Hooks and settings.json

Hooks require corresponding entries in `.claude/settings.json` to be active. The template's `settings.json` already registers its own hooks. If a copied hook has no `settings.json` entry, warn the operator:

> "Hook {name} was copied but has no entry in `.claude/settings.json`. It will not fire until registered. Add it manually or run `/sync-workflow` after deployment."

Do NOT auto-modify `settings.json` — hook registration requires knowing the matcher, event type, and timeout, which varies per hook. To make the gap visible, emit the canonical hook-registration checklist below so the operator can copy the right entries into the deployed project's `settings.json`.

> **Append-only side effect.** Some hooks append entries to `<project>/logs/friction-log.md` and `logs/improvement-log.md` when they fire. Reverting the hook scripts leaves prior log entries in deployed projects — manual cleanup required per project.

#### Canonical hook-registration checklist

Generated dynamically from `ai-resources/.claude/settings.json` so the list stays in sync with the source of truth. Run after the hooks-copy step (Step 4 enrichment logic) and before reporting "Project ready".

```bash
AI_SETTINGS="$AI_RESOURCES/.claude/settings.json"
if [ -f "$AI_SETTINGS" ]; then
  echo ""
  echo "Hook-registration checklist (add to {PROJECT_DIR}/.claude/settings.json as needed):"
  echo ""
  jq -r '
    .hooks // {}
    | to_entries[]
    | .key as $event
    | .value[]
    | (.matcher // null) as $matcher
    | .hooks[]
    | ((.command | [scan("[^/\\s]+\\.sh")] | last) // .command) as $base
    | (.timeout // 5) as $timeout
    | "  \($base) → \($event)\(if $matcher then "[\($matcher)]" else "" end) (timeout \($timeout))"
  ' "$AI_SETTINGS"
  echo ""
  echo "Skip any hook that is not relevant to this project's workflow."
fi
```

### Ensure permissions baseline in deployed settings.json

**Scope note.** This sub-step only touches `.permissions` in the deployed `{PROJECT_DIR}/.claude/settings.json`. Hook registration remains a manual operator step per the paragraph above.

**When it runs.** After Step 3's `cp -r` brings the template over, and **before** Step 7's placeholder replacement (and Step 5's placeholder discovery), so no `{{...}}` tokens can be introduced into the JSON by this sub-step and the merged `permissions` block cannot be invalidated by a later `sed` pass.

**Why it exists.** Without a `permissions` block in the deployed settings, Claude Code prompts the operator to approve every Edit/Write/Grep/Bash call in the new project. This sub-step guarantees a tool-permissions baseline even if the template itself ships without one.

**Requires `jq` on PATH.** If `jq` is not available, stop and report the missing dependency. Do not splice JSON at the string level.

**Predicate — "already has a permissions allowlist":** parsed JSON has `.permissions.allow` *and* that array is non-empty. If true, leave `permissions` alone. Otherwise merge the canonical block below.

**Canonical permissions block.** Sourced from `ai-resources/templates/project-settings.json.template` — the single source of truth for canonical project scaffolding (see `ai-resources/templates/README.md` Consumer contract). The template carries `defaultMode: "bypassPermissions"`, an `allow` set including baseline tools plus dotfile-path globs (`Edit(**/.claude/**)`, `Write(**/.claude/**)`) and `Bash(rm *)`, and a `deny` set covering destructive ops (`Bash(rm -rf *)`, `Bash(sudo *)`) plus archival `Read(...)` patterns. **Layer D widening rationale** — the four entries that differ from a minimal allowlist (`defaultMode: bypassPermissions`, the two dotfile-path globs, and `Bash(rm *)`) — is documented at `ai-resources/docs/permission-template.md` § Layer D (lines 153–193, citing root causes #1–#3 from the same doc). These are the canonical project-layer shape, not project-specific options. To inspect or modify the canonical set, edit the template; this command reads from it at deploy time.

**No model default is set.** Model defaults in `settings.json` are prohibited workspace-wide (workspace `CLAUDE.md` § Model Tier — a declared model blocks in-session `/model` switches). The operator selects the model per session via `/model`. If a pre-existing `settings.json` contains a `model` field, the merge procedure below strips it.

**Merge procedure:**

```bash
command -v jq >/dev/null || { echo "ERROR: jq required for permissions merge"; exit 1; }

SETTINGS="{PROJECT_DIR}/.claude/settings.json"
mkdir -p "$(dirname "$SETTINGS")"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

# Locate canonical templates via walk-up to ai-resources/ (mirrors new-project.md:330–337).
# The same walk-up is repeated at the next sub-step (`additionalDirectories` grant) so each
# code block stays self-contained — they cannot share state across separate bash blocks.
d="$(cd {PROJECT_DIR} && pwd)"
AI_RES=""
while [ "$d" != "/" ]; do
  d=$(dirname "$d")
  [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break
done
[ -n "$AI_RES" ] || { echo "ERROR: ai-resources not found in any ancestor — cannot locate canonical settings template"; exit 1; }

TEMPLATE="$AI_RES/templates/project-settings.json.template"
[ -f "$TEMPLATE" ] || { echo "ERROR: canonical settings template missing at $TEMPLATE"; exit 1; }

CANONICAL_PERMS=$(jq -c '.permissions' "$TEMPLATE")

jq --argjson perms "$CANONICAL_PERMS" '
  (if (.permissions.allow // []) | length > 0 then . else .permissions = $perms end)
  | del(.model)
' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
```

Report in the enrichment output whether `permissions` was added or already present, and whether a pre-existing `model` field was stripped.

**Interaction with the research-workflow template.** The template's own `settings.json` already carries a `permissions` block (added alongside this change), so on a fresh deploy the predicate returns true and this sub-step is a no-op. The sub-step remains load-bearing for (a) any future template that ships without a `permissions` block and (b) running `/sync-workflow` on older projects that were deployed before the template fix landed.

### Grant ai-resources filesystem visibility

**Scope note.** This sub-step writes `.permissions.additionalDirectories` to the deployed project's **gitignored `{PROJECT_DIR}/.claude/settings.local.json`** — never the tracked `settings.json`. It runs **unconditionally** — not gated by the allowlist predicate — so projects whose templates ship a narrower `permissions.allow` still receive the workspace-root grant they need to read from `ai-resources/` siblings at runtime.

**Why the local file, not the tracked one.** The grant is a **machine-specific absolute path** (it differs per operator machine); a committed path is correct on the deploying machine but breaks on every other machine that pulls the repo. Per canonical Rule 8 / Layer D′ in `ai-resources/docs/permission-template.md`, the grant's only home is the gitignored `settings.local.json`. (Aligned 2026-06-27 with the `/new-project` Step 3 fix; previously this sub-step wrote to the tracked `settings.json`, re-introducing the machine-specific-path defect.)

**Why this is separate from the permissions merge above.** `additionalDirectories` grants *read access to paths outside the current project*, which is a different concern from tool permissions inside the project. Every deployed project needs to read from `ai-resources/` regardless of how narrow its tool allowlist is, so this grant is universal.

**Compute the workspace root** by walking upward from `{PROJECT_DIR}` until an ancestor contains `ai-resources/` (mirrors the idiom in `auto-sync-shared.sh`). Use an absolute path — Claude Code resolves `additionalDirectories` relative to session CWD, which varies by how the project is opened.

```bash
command -v jq >/dev/null || { echo "ERROR: jq required for additionalDirectories merge"; exit 1; }

LOCAL="{PROJECT_DIR}/.claude/settings.local.json"
[ -f "$LOCAL" ] || echo '{}' > "$LOCAL"
TRACKED="{PROJECT_DIR}/.claude/settings.json"

d="$(cd {PROJECT_DIR} && pwd)"
WORKSPACE=""
while [ "$d" != "/" ]; do
  d=$(dirname "$d")
  [ -d "$d/ai-resources" ] && WORKSPACE="$d" && break
done
[ -n "$WORKSPACE" ] || { echo "WARN: ai-resources not found in any ancestor — skipping additionalDirectories grant"; }

if [ -n "$WORKSPACE" ]; then
  # Grant goes to the gitignored local file. defaultMode is mandatory whenever the local
  # file declares a permissions block (omitting it shadows the parent's bypass — root cause #1).
  jq --arg dir "$WORKSPACE" '
    .permissions.defaultMode = (.permissions.defaultMode // "bypassPermissions")
    | .permissions.additionalDirectories = ((.permissions.additionalDirectories // [] | map(select(startswith("{{") | not))) + [$dir] | unique)
  ' "$LOCAL" > "$LOCAL.tmp" && mv "$LOCAL.tmp" "$LOCAL"

  # Defensive: strip additionalDirectories from the tracked file if an older template copy still carries it.
  if [ -f "$TRACKED" ]; then
    jq 'if .permissions.additionalDirectories then .permissions |= del(.additionalDirectories) else . end' \
      "$TRACKED" > "$TRACKED.tmp" && mv "$TRACKED.tmp" "$TRACKED"
  fi
fi
```

Ensure `{PROJECT_DIR}/.claude/settings.local.json` is gitignored (Claude Code convention — `/permission-sweep` rule 12 flags it if tracked). `unique` makes the merge idempotent; the `map(select(...))` strip removes any `{{PLACEHOLDER}}` entry before appending the real workspace path. Report whether the workspace root was added to the local file or already present.

## Step 5: Determine placeholders to fill

**The deploy-time placeholder set is DECLARED, not discovered.** The registry in 5b is the authority. A regex scan is used only as a drift cross-check (5d) — never to decide what gets filled.

**Why (verified by execution, 2026-07-13 — mission `research-workflow-deploy-fitness` thread 2).** The template holds **128** distinct `{{...}}` tokens, but only **30** are resolved at deployment. Of the rest, **94** live *only* inside the six `reference/*.template.md` files — deferred templates the operator instantiates later — and the remainder are notation inside documentation tables. The old scan-and-fill-everything approach was wrong in both directions at once: its `{{[A-Z_]*}}` pattern **missed 65** real placeholders (every digit-bearing one, including `{{CONFIDENTIAL_IDENTIFIER_1/2}}`), while **demanding values for template-internal tokens** it had no business touching — and then `sed`-rewriting the template files, destroying the shapes the operator needs later.

**Do NOT "fix" this by widening the regex.** A wider pattern finds the missing 65 *and* sweeps in the 94 template-internal ones. The regex is not the mechanism; the registry is.

### 5a. Fill scope — the only files the deploy may rewrite

FILL SCOPE = every `*.md` and `*.json` under `{PROJECT_DIR}/`, **excluding**:

| Excluded | Why |
|---|---|
| `reference/*.template.md` (6 files) | Deferred templates. The operator instantiates these per-project later. **Must survive deployment byte-identical.** |
| `SETUP.md` | The operator checklist. It *documents* placeholders — its tables name them literally — so filling it would corrupt its own reference table. Removed at Step 10 regardless. |
| `.claude/commands/produce-architecture.md` | **Only when the project does not use the parts-based document model** — see 5c. Its 4 placeholders are an unused optional component and must stay unfilled. |

### 5b. Deploy-time placeholder registry — the authority

**Class A — required (26).** Every deployment resolves all of these.

| Placeholder | Lives in | Purpose |
|---|---|---|
| `{{PROJECT_TITLE}}` | CLAUDE.md, reference/{stage-instructions,file-conventions,quality-standards,style-guide}.md | Project name in headings |
| `{{PROJECT_DESCRIPTION}}` | CLAUDE.md, reference/style-guide.md | Project scope description |
| `{{ANALYTICAL_LENS}}` | CLAUDE.md | Analytical framework |
| `{{CURRENT_SECTION}}` | CLAUDE.md | Starting section |
| `{{DOCUMENT_ARCHITECTURE}}` | CLAUDE.md | Document structure |
| `{{EVIDENCE_CALIBRATION}}` | CLAUDE.md | Evidence-availability note |
| `{{OPERATOR_NAME}}` | CLAUDE.md, reference/style-guide.md | Operator's name |
| `{{CONFIDENTIAL_IDENTIFIER_1}}` | CLAUDE.md | Confidentiality boundary 1 (use "No confidentiality constraints for this project." if none) |
| `{{CONFIDENTIAL_IDENTIFIER_2}}` | CLAUDE.md | Confidentiality boundary 2 (same) |
| `{{REPORT_SET}}` | CLAUDE.md § Project Config | Config field 1 |
| `{{SECTION_IDS}}` | CLAUDE.md § Project Config | Config field 2 |
| `{{COUNTRY_SET}}` | CLAUDE.md § Project Config | Config field 3 (canonical; source-class-hierarchy mirrors it) |
| `{{COUNTRY_SUPERSET}}` | CLAUDE.md § Project Config | Config field 4 (pan-region leakage detection) |
| `{{LANGUAGES}}` | CLAUDE.md § Project Config | Config field 5 (ISO 639-1; empty = English-only) |
| `{{DEAL_SIZE_LENS}}` | CLAUDE.md § Project Config | Config field 6 |
| `{{DOMAIN}}` | CLAUDE.md § Project Config, reference/style-guide.md | Config field 7 |
| `{{VERIFICATION_POSTURE}}` | CLAUDE.md § Project Config | Config field 8 |
| `{{SOURCE_AVAILABILITY}}` | CLAUDE.md § Project Config | Config field 9 |
| `{{RESEARCH_AREA_PHRASE}}` | CLAUDE.md § Project Config, .claude/commands/run-execution.md, reference/{style-guide,stage-instructions}.md | Config field 10 |
| `{{CURRENT_PERIOD}}` | CLAUDE.md § Project Config | Config field 11 |
| `{{DELIVERY_VAULT}}` | CLAUDE.md § Project Config | Config field 12 (optional value, but must still be resolved — write `none` if unused) |
| `{{DOCUMENT_MODEL}}` | CLAUDE.md § Project Config | Config field 13 — enum `report` \| `section`; **required, halt on missing** |
| `{{SECTION_SEQUENCE}}` | reference/stage-instructions.md | Section ordering constraints |
| `{{CLUSTER_BLOCK_THRESHOLD}}` | reference/quality-standards.md | Cluster-level QC threshold |
| `{{SECTION_BLOCK_THRESHOLD}}` | reference/quality-standards.md | Section-level QC threshold |
| `{{FACT_VERIFICATION_SYSTEM_PROMPT}}` | reference/sops/fact-verification-prompt.md | Stage-4 verification prompt (a stub to be authored) |

**Class B — conditional (4).** Fill **only** if the project uses the parts-based document model (`/produce-architecture`). Otherwise leave unfilled and exclude the file from fill scope — an unused optional component.

| Placeholder | Lives in |
|---|---|
| `{{PART_TWO_DIR}}` · `{{PART_THREE_DIR}}` · `{{PART_TWO_PROSE_DIR}}` · `{{PART_THREE_PROSE_DIR}}` | .claude/commands/produce-architecture.md |

**Class C — never fill, never prompt (notation, not placeholders).** These are *illustrations of a format*, not values.

| Token | Lives in | What it is |
|---|---|---|
| `{{Country_1}}` · `{{Country_2}}` · `{{Country_N}}` | reference/quality-standards.md:106 | Column headers in an example Country Coverage Table — generic by design |
| `{{PLACEHOLDER}}` | SETUP.md | A documentation example ("replace all `{{PLACEHOLDER}}` values"). Out of fill scope anyway. |

**Class D — template-internal (94).** Everything inside `reference/*.template.md`. Never touched at deploy time. The operator resolves them when instantiating each template.

### 5c. Resolve the conditional class [Operator]

Ask once:

> Does this project use the parts-based document model (`/produce-architecture`, with a `parts/` directory)? [y/n]

- **y** → add `.claude/commands/produce-architecture.md` to fill scope; the 4 Class-B placeholders join the required set for this deployment.
- **n** → leave it excluded. Its placeholders stay unfilled by design.

### 5d. Drift cross-check (a warning, never a prompt)

The registry is hand-maintained, so it can fall behind the template. Catch that loudly rather than silently filling nothing:

```bash
# Broad scan of FILL SCOPE ONLY — template files and SETUP.md are excluded by construction.
find "{PROJECT_DIR}" -type f \( -name "*.md" -o -name "*.json" \) \
     ! -name "*.template.md" ! -name "SETUP.md" -print0 \
  | xargs -0 grep -oh '{{[A-Za-z0-9_]*}}' 2>/dev/null | sort -u
```

Compare the result against Class A + Class B + Class C. Anything **not** in any class is an **unregistered placeholder**: report it loudly and stop — the template has gained a placeholder the registry does not know about, and the registry must be updated before this deploy proceeds. Do not silently fill it, and do not silently skip it.

**Also check the SETUP.md mirror.** `SETUP.md` § Placeholder Reference restates this registry for the operator, and it is excluded from fill scope — so the scan above cannot see it drift. Verify the mirror directly: extract the placeholder names from SETUP.md's Class A and Class B tables and compare them to the registry above.

```bash
grep -oh '{{[A-Za-z0-9_]*}}' "{PROJECT_DIR}/SETUP.md" | sort -u
```

Any name present in one list but not the other means the lockstep contract has been broken — **stop and reconcile before deploying.** This is the guard against the exact failure that caused thread 1 of the deployment-fitness mission: a declared contract that quietly stopped matching reality. The registry in 5b is the authority; SETUP.md is the mirror.

Then display the fill plan:

```
Deploy-time placeholders to fill: N
  Class A (required):     26
  Class B (conditional):   4  [included | excluded — parts-based model not in use]
Preserved untouched:
  Class C (notation):      3
  Class D (template-internal, in 6 *.template.md files): 94
```

## Step 6: Collect placeholder values [Operator]

Ask the user for values for the **Class A** set (plus **Class B** if 5c selected it). Present them as a group so the user can supply everything at once, or go one by one — follow the user's preference.

- `{{OPERATOR_NAME}}` — default to the git user's first name (`git config user.name`). State the default; let the user confirm or override.
- `{{CONFIDENTIAL_IDENTIFIER_1/2}}` — if the project has no confidentiality constraints, the CLAUDE.md section itself says to replace the list with `No confidentiality constraints for this project.` Offer that as the default for both.
- `{{DOCUMENT_MODEL}}` — enum `report` | `section`. **Halt if the user cannot supply it**; downstream Stage-5 dispatch reads it first.
- `{{DELIVERY_VAULT}}` — optional in effect, but must still be *resolved*. Default `none`.

Never prompt for Class C or Class D tokens.

## Step 7: Replace placeholders

### 7a. Hard guard — the project CLAUDE.md must already be active

**Stop the deployment if `CLAUDE.md.template` still exists.** Step 3a should have renamed it; if it did not, every placeholder below silently misses the project's most important file.

This guard is not defensive decoration — it closes a **silent** failure mode. `CLAUDE.md.template` matches neither `*.md` nor `*.json`, so it is excluded from the Step 5a fill scope *by construction*. The `sed` pass would therefore succeed, report success, and leave the deployed `CLAUDE.md.template` holding all 22 of its unresolved Class-A placeholders — and Step 5d's drift cross-check cannot catch it either, because that scan is also fill-scope-bounded. Nothing else in this command looks at the file. Without this guard the deploy is green and the project is broken.

```bash
if [ -e "{PROJECT_DIR}/CLAUDE.md.template" ]; then
  cat <<'ERR'
ERROR: deployment stopped — {PROJECT_DIR}/CLAUDE.md.template still exists at placeholder-fill time.

Step 3a must rename CLAUDE.md.template -> CLAUDE.md BEFORE this step. The fill scope built in
Step 5a covers only *.md and *.json; ".template" matches neither, so proceeding would leave every
placeholder in the project's CLAUDE.md unresolved while reporting a successful deployment.

Fix: run Step 3a's rename, then re-run from Step 5.
ERR
  exit 1
fi
```

### 7b. Apply the values

Replace each collected value across **fill scope only** (Step 5a).

```bash
# Build the fill-scope file list ONCE, NUL-delimited.
#
# Two defects fixed here (both verified by execution, 2026-07-13 — thread 2):
#   1. `-print0 | xargs -0` is LOAD-BEARING, not style. The previous `find ... | xargs`
#      word-split on spaces, and EVERY real deploy path contains one
#      ("…/Claude Code/Axcion AI Repo/…"). It fed sed a truncated path, sed exited 1,
#      and ZERO replacements were made. The step was dead code in this workspace.
#   2. `\( -name … -o -name … \)` grouping is LOAD-BEARING. Without the parens, `-o`
#      breaks `-type f`'s binding and the second branch matches directories too.
#
# The two `! -name` exclusions are the byte-identical guarantee for the deferred
# templates. Do not remove them, and do not "simplify" this back to a bare
# `find | xargs` — that reintroduces both defects at once.
#
# The scope file is named per-project, NOT a fixed /tmp path: two deploys running
# concurrently would otherwise overwrite each other's file list and each would sed
# the OTHER project's files.
SCOPE_LIST="/tmp/deploy-fill-scope-{PROJECT_NAME}.list"

find "{PROJECT_DIR}" -type f \( -name "*.md" -o -name "*.json" \) \
     ! -name "*.template.md" ! -name "SETUP.md" -print0 > "$SCOPE_LIST"

# If the parts-based model is NOT in use, also drop produce-architecture.md from the list.
```

For each placeholder/value pair, escape `/`, `&`, and `\` in the replacement, then:

```bash
xargs -0 sed -i '' "s/{{PLACEHOLDER}}/escaped_value/g" < "$SCOPE_LIST"
```

### Step 7 verification

Assert that no **deploy-time** placeholder remains in fill scope. Class C and Class D tokens are *expected* to survive and must not be reported.

```bash
# Registry placeholders only — build REGISTRY_RE from the Class A (+ Class B, if selected)
# names collected in Step 5, e.g. 'PROJECT_TITLE|PROJECT_DESCRIPTION|...|DOCUMENT_MODEL'
xargs -0 grep -l -E "\{\{(${REGISTRY_RE})\}\}" < "$SCOPE_LIST"
```

Empty output = pass. Any hit = a value was collected but not applied; report the file and the placeholder, and re-apply.

**Do NOT assert `grep -r '{{' {PROJECT_DIR}/` returns nothing.** That was the old check, and it is wrong by construction: 94 Class-D placeholders live in the preserved template files and 3 Class-C tokens live in `quality-standards.md`, so a *correct* deploy fails that assertion by ~97 counts. A check that always cries wolf gets ignored — which is exactly how a real leftover would slip through.

### Step 7 preservation check — deferred templates must be byte-identical

The six `reference/*.template.md` files are deferred templates the operator instantiates later. They must survive deployment **byte-for-byte**. This check fails the deployment if any of them changed or went missing.

**Two defects were repaired here (2026-07-27, Change 1). Do not reintroduce either.**

1. **`diff --include=` does not exist.** `--include` is a `grep` / `rsync` option; GNU `diff` spells the equivalent `--exclude`, and BSD `diff` (the macOS default, which is what runs here) has no include filter at all. The old line was not a weak check — it was **not a check**, because `diff` rejected the unknown option and exited non-zero before comparing anything.
2. **`TEMPLATE_DIR` is never defined in this command.** Step 1 sets `TEMPLATE_PATH`. `TEMPLATE_DIR` belongs to `/sync-workflow`, a different command. Under an unset variable the path collapses to `/reference`.

```bash
# Each Bash block gets a FRESH shell — nothing survives from an earlier block. Re-establish
# all three values here. These use this command's normal {BRACE} substitution: replace each
# with the value resolved in Steps 1-2 before executing the block.
TEMPLATE_PATH="{TEMPLATE_PATH}"    # Step 1 — the selected workflow template directory
PROJECT_DIR="{PROJECT_DIR}"        # Step 2 — {WORKSPACE_ROOT}/projects/{PROJECT_NAME}
PROJECT_NAME="{PROJECT_NAME}"      # Step 2 — validated kebab-case project name

# Refuse to run on an empty value. Without this, "$TEMPLATE_PATH/reference" collapses to
# "/reference": find then either errors on a nonexistent path or — if such a directory ever
# existed — silently scans the wrong tree and reports a clean PASS. A preservation check that
# passes without comparing anything is worse than no check.
for v in TEMPLATE_PATH PROJECT_DIR PROJECT_NAME; do
  eval "val=\${$v:-}"
  [ -n "$val" ] || { echo "ERROR: $v is empty — refusing to run the preservation check"; exit 1; }
done
[ -d "$TEMPLATE_PATH/reference" ] || { echo "ERROR: no reference/ under $TEMPLATE_PATH"; exit 1; }
[ -d "$PROJECT_DIR/reference" ]   || { echo "ERROR: no reference/ under $PROJECT_DIR"; exit 1; }

# Per-project temp file: two concurrent deploys must not share a drift record.
DRIFT="/tmp/deploy-template-drift-${PROJECT_NAME}.list"
: > "$DRIFT"

# -print0 / read -r -d '' is LOAD-BEARING, not style. Every real deploy path on this machine
# contains a space ("…/Claude Code/Axcion AI Repo/…"). A newline-delimited read splits those
# paths and compares files that do not exist — the same defect that made Step 7's fill pass
# dead code before 2026-07-13. `cmp -s` is byte-exact and portable across BSD and GNU.
find "$TEMPLATE_PATH/reference" -type f -name '*.template.md' -print0 \
| while IFS= read -r -d '' src; do
    rel="${src#"$TEMPLATE_PATH"/}"
    dst="$PROJECT_DIR/$rel"
    if [ ! -f "$dst" ]; then
      printf 'MISSING  %s\n' "$rel" >> "$DRIFT"
    elif ! cmp -s "$src" "$dst"; then
      printf 'CHANGED  %s\n' "$rel" >> "$DRIFT"
    fi
  done
# The loop body runs in a subshell (pipe), so it cannot export a variable — which is exactly
# why drift is recorded in a FILE and the verdict is read from the file below.

if [ -s "$DRIFT" ]; then
  echo "DEPLOY FAILED — deferred templates were modified or lost:"
  cat "$DRIFT"
  rm -f "$DRIFT"          # deleted on the failure path too
  exit 1
fi
rm -f "$DRIFT"            # ...and on the success path
echo "Deferred-template preservation: PASS — all reference/*.template.md byte-identical"
```

## Step 8: Create skill symlinks (conditional)

Only run this step if `{PROJECT_DIR}/reference/skills/` exists.

```bash
SKILLS_DIR="{WORKSPACE_ROOT}/ai-resources/skills"

for skill in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill")
  # Skip if a local copy already exists
  [ -d "{PROJECT_DIR}/reference/skills/$skill_name" ] && continue
  ln -s "$skill" "{PROJECT_DIR}/reference/skills/$skill_name"
done
```

Verify: list the created symlinks and confirm they resolve.

If `{WORKSPACE_ROOT}/ai-resources/skills/` does not exist, skip this step and warn the user that skills will need to be linked manually.

## Step 9: Initialize git

```bash
cd {PROJECT_DIR}
git init
git add -A
git commit -m "init: {PROJECT_NAME} workspace from research template"
```

## Step 10: Remove SETUP.md from project

The setup checklist has been completed — it should not remain in the deployed project.

```bash
cd {PROJECT_DIR}
git rm SETUP.md
git commit -m "remove setup checklist (setup complete)"
```

## Step 11: Validate

Run a quick validation:

1. Confirm no **deploy-time** placeholder remains in fill scope — i.e. re-run the Step 7 verification (`REGISTRY_RE` over `$SCOPE_LIST`). **Do not assert that zero `{{...}}` tokens remain anywhere:** the six `reference/*.template.md` files legitimately retain 94 Class-D placeholders and `reference/quality-standards.md` retains 3 Class-C notation tokens. A correct deploy *must* leave those in place — asserting otherwise fails every clean deployment by ~97 counts and trains the operator to ignore the check.
2. Confirm the six `reference/*.template.md` files are **byte-identical** to the source template. Re-run the Step 7 preservation check verbatim — the `find -print0` / `read -r -d ''` / `cmp -s` loop, with `TEMPLATE_PATH`, `PROJECT_DIR` and `PROJECT_NAME` re-established in this block. This is the deferred-template preservation guarantee. **Do not substitute `diff -r … --include="*.template.md"`:** `--include` is not a `diff` option, so that form never compared anything (repaired 2026-07-27, Change 1).
3. Confirm all symlinks in `reference/skills/` resolve (if the directory exists).
4. Confirm `CLAUDE.md` exists and has at least one heading, **and that no `CLAUDE.md.template` remains** in the project — the Step 3a activation must have both renamed the file and left no inert copy behind.
5. Confirm `.claude/settings.json` is valid JSON (if it exists).

Report the validation results. If all pass:

```
Project ready at: {PROJECT_DIR}

Next steps:
1. Open Claude Code in {PROJECT_DIR}/
2. Run /status to verify the project loads correctly
3. Create your first task plan draft in preparation/task-plans/
4. Run /run-preparation to begin Stage 1
```

If any validation fails, report what failed and suggest how to fix it.
