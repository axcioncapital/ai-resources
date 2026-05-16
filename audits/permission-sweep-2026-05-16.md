# Permission Sweep — Full Notes

**Scan date:** 2026-05-16
**Workspace:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo
**Files scanned:** 25
**Template used:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md

---

## Files scanned

| Path | Layer | Status |
|------|-------|--------|
| `/Users/patrik.lindeberg/.claude/settings.json` | A | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` | B | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.local.json` | B′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` | C | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json` | C-local | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/settings.json` | D | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/settings.local.json` | D′ | ok |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/settings.json` | D | ok |

---

## Parse Errors

None. All 25 files parsed cleanly.

---

## Intentional-narrow files (excluded from auto-remediation)

None detected. The template's known narrow exception (`projects/obsidian-pe-kb/vault/.claude/settings.json`) does not exist on disk. The obsidian-pe-kb project has only a top-level `.claude/settings.json` which contains bare `Edit` and `Write` entries and therefore does not satisfy the intentional-narrow heuristic.

---

## Intentional-template files

None detected. The research-workflow settings file (`ai-resources/workflows/research-workflow/.claude/settings.json`) contains a hardcoded `additionalDirectories` path with no `{{PLACEHOLDER}}` pattern. It is treated as a deployed instance, not a template-pending file.

---

## Findings — CRITICAL

No CRITICAL findings.

---

## Findings — HIGH

### Finding 1 — Rule 6: No `Bash(rm *)` in allow

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"allow"` array does not contain `"Bash(rm *)"`. Full allow: `["Bash(*)", "Bash(rm *)"` is absent — jq `contains(["Bash(rm *)"])` returns `false`. The array contains only: `"Bash(*)"`, `"Edit"`, `"Edit(**/.claude/**)"`, `"MultiEdit"`, `"Read"`, `"WebFetch"`, `"WebSearch"`, `"Write"`, `"Write(**/.claude/**)"`.
- **Canonical value:** `"Bash(rm *)"` must appear in Layer D `permissions.allow`.
- **Proposed fix (plain English):** Add `"Bash(rm *)"` to the `permissions.allow` array.
- **Remediation hint:** apply-by-default

---

## Findings — MEDIUM

No MEDIUM findings.

---

## Findings — ADVISORY

### Finding 2 — Rule 11: User-level vs workspace divergence — deny floor absent on both layers

- **File:** `/Users/patrik.lindeberg/.claude/settings.json` (Layer A) and `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` (Layer B)
- **Layer:** A / B
- **Evidence:**
  - Layer A `permissions.deny`: `[]` (empty array). Canonical Layer A: `deny: ["Bash(rm -rf *)", "Bash(sudo *)"]`.
  - Layer B `permissions` key: no `deny` key present at all (jq `.permissions | has("deny")` returns `false`). Canonical Layer B: `deny: ["Bash(rm -rf *)", "Bash(sudo *)", "Bash(git reset --hard *)", "Bash(git checkout *)"]`.
  - Both layers deviate from their canonical deny floors in the same direction; no divergence between A and B on this point.
- **Canonical value:** Layer A deny: `["Bash(rm -rf *)", "Bash(sudo *)"]`. Layer B deny: `["Bash(rm -rf *)", "Bash(sudo *)", "Bash(git reset --hard *)", "Bash(git checkout *)"]`.
- **Proposed fix (plain English):** Add canonical deny arrays to both Layer A and Layer B settings files.
- **Remediation hint:** needs-operator-review — deny floors are safety bounds; operator decides whether to apply given `bypassPermissions` on both layers.

### Finding 3 — Rule 13: Syntax form inconsistency — `Bash(git push *)` vs `Bash(git push*)`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json`
- **Layer:** B
- **Evidence:** `"Bash(git push *)"` (space before `*`) appears in `permissions.allow`. Every other file using this command form uses `"Bash(git push*)"` (no space). Template canonical uses `Bash(git push*)` in deny lists.
- **Canonical value:** `"Bash(git push*)"` (no space before `*`).
- **Proposed fix (plain English):** Change `"Bash(git push *)"` to `"Bash(git push*)"` in the Layer B allow array.
- **Remediation hint:** apply-by-default

### Finding 4 — Rule 13: `MultiEdit` missing from Layer B′ allow

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.local.json`
- **Layer:** B′
- **Evidence:** `"permissions": {"allow": ["Edit", "Write", "Bash(*)"], "defaultMode": "bypassPermissions"}` — `"MultiEdit"` is absent. Canonical Layer B′: `allow: ["Edit", "Write", "MultiEdit", "Bash(*)"]`.
- **Canonical value:** `["Edit", "Write", "MultiEdit", "Bash(*)"]`.
- **Proposed fix (plain English):** Add `"MultiEdit"` to the `permissions.allow` array.
- **Remediation hint:** apply-by-default

### Finding 5 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. No `.gitignore` file exists in this project directory.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Create a `.gitignore` for this project containing at minimum `archive/`.
- **Remediation hint:** apply-by-default

### Finding 6 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` exists but contains no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.gitignore`.
- **Remediation hint:** apply-by-default

### Finding 7 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` exists but contains no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/.gitignore`.
- **Remediation hint:** apply-by-default

### Finding 8 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` exists but contains no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.gitignore`.
- **Remediation hint:** apply-by-default

### Finding 9 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` contains only `.DS_Store` — no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.gitignore`.
- **Remediation hint:** apply-by-default

### Finding 10 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` exists but contains no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.gitignore`.
- **Remediation hint:** apply-by-default

### Finding 11 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` exists but contains no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/.gitignore`.
- **Remediation hint:** apply-by-default

### Finding 12 — Rule 14: `Read(archive/**)` deny without `archive/` in `.gitignore`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/settings.json`
- **Layer:** D
- **Evidence:** `"Read(archive/**)"` in `deny`. Project `.gitignore` exists but contains no `archive/` entry.
- **Canonical value:** `archive/` should appear in the project's `.gitignore`.
- **Proposed fix (plain English):** Add `archive/` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.gitignore`.
- **Remediation hint:** apply-by-default

---

## Rule-by-rule application record

**Rule 1** (settings.local.json missing defaultMode when it has a permissions block): All D′ files with a permissions block contain `defaultMode: bypassPermissions`. Files with no permissions block are clean by the alternative-omit rule. No violations.

**Rule 2** (project/workspace settings.json missing defaultMode entirely): All scanned settings.json files with a permissions block contain `defaultMode: bypassPermissions`. No violations.

**Rule 3** (broad glob Edit(X/**) without dotfile-path companion): Layer B has `Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` accompanied by `Edit(**/.claude/**)`. Layer C and all Layer D files with scoped Edit globs include `Edit(**/.claude/**)`. No violations.

**Rule 4** (missing bare-tool entries alongside scoped patterns): Layer B and all Layer D files with scoped `Edit(**/.claude/**)` patterns also include bare `Edit` and `Write`. No violations.

**Rule 5** (missing Bash(*) where only narrow bash commands are present): All files with any Bash entry include `Bash(*)`. No violations.

**Rule 6** (no Bash(rm *) in allow): Fires on `nordic-pe-landscape-mapping-4-26`. Finding 1.

**Rule 7** (deny-shadows-allow — same pattern on both lists): No allow entry matches any deny entry in any file. No violations.

**Rule 8** (missing or stale additionalDirectories in project files): All Layer D files contain `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`. No violations.

**Rule 9** (stale absolute-path allow entries): All absolute paths in allow lists (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`, `/Users/patrik.lindeberg/.claude/projects`) exist on disk. No violations.

**Rule 10** (MCP tools not covered): No `mcp__*` entries appear in any allow or deny list. No violations.

**Rule 11** (user-level vs workspace divergence in critical rules): Both Layer A and B have `bypassPermissions`. Both deviate from their canonical deny floors identically (both absent). No divergence between A and B. Finding 2 recorded as ADVISORY template deviation.

**Rule 12** (settings.local.json tracked by git): Global git config (`~/.config/git/ignore`: `**/.claude/settings.local.json`) excludes all settings.local.json files across all repos. Verified: no settings.local.json file is tracked in any of the project git repos. No violations.

**Rule 13** (typos/duplicates/syntax inconsistencies): One syntax form inconsistency in Layer B (`Bash(git push *)` vs canonical `Bash(git push*)`). Finding 3. One missing `MultiEdit` in Layer B′ vs canonical shape. Finding 4. No duplicate entries found in any allow list. No violations beyond Findings 3–4.

**Rule 14** (Read(<dir>/**) deny where <dir>/ not gitignored at same repo root): Fires on 8 project Layer D files for `Read(archive/**)` without `archive/` in project gitignore. Findings 5–12. Does NOT fire on: `global-macro-analysis` (archive/ gitignored), `buy-side-service-plan` (reports/ and usage/ gitignored), ai-resources (archive/ and inbox/archive/ gitignored), research-workflow (no concrete-dir Read denies). Does NOT fire on `logs/*-archive-*.md` deny entries (file-glob pattern, not `<dir>/**` pattern per rule definition).
