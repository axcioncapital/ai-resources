# Permission Sweep — Full Notes

**Scan date:** 2026-06-12
**Workspace:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo
**Files scanned:** 41
**Template used:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md

---

## Files scanned

| Path | Layer | Status |
|------|-------|--------|
| ~/.claude/settings.json | A | ok |
| .claude/settings.json | B | ok |
| .claude/settings.local.json | B′ | ok |
| ai-resources/.claude/settings.json | C | ok |
| ai-resources/.claude/settings.local.json | C-local (B′ shape) | intentional-narrow (narrow bash only) |
| ai-resources/workflows/research-workflow/.claude/settings.json | D (template-class) | ok — template-class (both signals) |
| projects/project-planning/.claude/settings.json | D | ok |
| projects/project-planning/.claude/settings.local.json | D′ | ok (empty, no permissions block) |
| projects/strategic-os/.claude/settings.json | D | intentional-narrow |
| projects/strategic-os/.claude/settings.local.json | D′ | ok (empty) |
| projects/research-pe-regime-shift-advisory-gap/.claude/settings.json | D | ok |
| projects/buy-side-service-plan/.claude/settings.json | D | ok |
| projects/buy-side-service-plan/.claude/settings.local.json | D′ | ok (empty) |
| projects/nordic-pe-screening-project/.claude/settings.json | D | ok |
| projects/nordic-pe-screening-project/.claude/settings.local.json | D′ | ok |
| projects/marketing-positioning/.claude/settings.json | D | ok |
| projects/obsidian-pe-kb/.claude/settings.json | D | ok |
| projects/obsidian-pe-kb/.claude/settings.local.json | D′ | ok (empty) |
| projects/repo-documentation/.claude/settings.json | D | ok |
| projects/repo-documentation/.claude/settings.local.json | D′ | ok (empty) |
| projects/interpersonal-communication/.claude/settings.json | D | ok |
| projects/interpersonal-communication/.claude/settings.local.json | D′ | ok (no permissions block) |
| projects/positioning-research/.claude/settings.json | D | ok |
| projects/axcion-ai-system-owner/.claude/settings.json | D | ok |
| projects/axcion-ai-system-owner/.claude/settings.local.json | D′ | ok (empty) |
| projects/global-macro-analysis/.claude/settings.json | D | ok |
| projects/global-macro-analysis/.claude/settings.local.json | D′ | ok (empty) |
| projects/corporate-identity/.claude/settings.json | D | ok |
| projects/corporate-identity/.claude/settings.local.json | D′ | ok (empty) |
| projects/axcion-brand-book/.claude/settings.json | D | findings |
| projects/ai-development-lab/.claude/settings.json | D | findings |
| projects/axcion-ai-system-owner/vault/.claude/settings.json | D (nested) | ok |
| projects/interpersonal-communication/knowledge-base/.claude/settings.json | D (nested) | findings |
| projects/repo-documentation/vault/.claude/settings.json | D (nested) | ok |
| projects/repo-documentation/vault/.claude/settings.local.json | D′ (nested) | ok (empty) |
| archive/nordic-pe-macro-landscape-H1-2026/.claude/settings.json | D (archived) | ok |
| archive/nordic-pe-macro-landscape-H1-2026/.claude/settings.local.json | D′ (archived) | ok (no permissions block) |
| knowledge-bases/strategic-os/.claude/settings.json | D (KB) | findings |
| knowledge-bases/pe-kb-vault/.claude/settings.json | D (KB) | intentional-narrow |
| knowledge-bases/pe-kb-vault/.claude/settings.local.json | D′ (KB) | ok (no permissions block) |
| knowledge-bases/marketing-communication/.claude/settings.json | D (KB) | findings |

**Note:** No `settings.local.json` found for: `projects/positioning-research/`, `projects/axcion-brand-book/`, `projects/ai-development-lab/`, `projects/axcion-ai-system-owner/vault/`, `projects/interpersonal-communication/knowledge-base/`, `knowledge-bases/strategic-os/`, `knowledge-bases/marketing-communication/`. Absence is not a finding by itself when the parent `settings.json` has `defaultMode: bypassPermissions` (no shadowing risk from a missing local file).

---

## Template-class files (Rules 8 and 9 silenced)

**File:** `ai-resources/workflows/research-workflow/.claude/settings.json`

Both signals fire:
- Path-class signal: path matches `**/workflows/*/.claude/settings.json`
- Value-class signal: `additionalDirectories` contains `"{{WORKSPACE_ROOT}}"`

Rules 8 and 9 are silenced entirely for this file. No findings emitted.

---

## Findings — CRITICAL

No CRITICAL findings.

---

## Findings — HIGH

### Finding 1 — Rule 9: Stale absolute path in `additionalDirectories`

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/knowledge-base/.claude/settings.json`
- **Layer:** D (nested project)
- **Evidence:** `"additionalDirectories": ["/Users/danielniklander/Axcion Claude Code/Axcion AI Repo"]` — this path does not exist on the current machine (`/Users/danielniklander/` is absent on disk).
- **Canonical value:** `additionalDirectories` should contain the workspace root for *this* machine: `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"`. Per Layer D′ rules, this grant belongs in a gitignored `settings.local.json`, not the tracked `settings.json`.
- **Proposed fix (plain English):** Replace the Daniel-machine absolute path with Patrik's workspace root, and move the grant to a `settings.local.json` at the same level.
- **Remediation hint:** apply-by-default

---

## Findings — MEDIUM

No MEDIUM findings.

---

## Findings — ADVISORY

### Finding 2 — Rule 3: Missing dotfile-path companion glob

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json`
- **Layer:** D
- **Evidence:** `allow` contains bare `"Edit"` and `"Write"` entries but does NOT contain `"Edit(**/.claude/**)"` or `"Write(**/.claude/**)"`. The file has broad `Edit` and `Write` but no dotfile-path guard.
- **Canonical value:** Layer D canonical requires `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` in `allow`.
- **Proposed fix (plain English):** Add `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` to the `allow` list.
- **Remediation hint:** apply-by-default

### Finding 3 — Rule 3: Missing dotfile-path companion glob

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/settings.json`
- **Layer:** D
- **Evidence:** `allow` contains bare `"Edit"` and `"Write"` but does NOT contain `"Edit(**/.claude/**)"` or `"Write(**/.claude/**)"`.
- **Canonical value:** Layer D canonical requires `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` in `allow`.
- **Proposed fix (plain English):** Add `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` to the `allow` list.
- **Remediation hint:** apply-by-default

### Finding 4 — Rule 2: Missing `defaultMode` entirely

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/.claude/settings.json`
- **Layer:** D (KB)
- **Evidence:** `permissions` block has no `"defaultMode"` key. The block contains `allow` and `deny` entries but will not bypass prompts without an explicit `defaultMode`.
- **Canonical value:** `"defaultMode": "bypassPermissions"`
- **Proposed fix (plain English):** Add `"defaultMode": "bypassPermissions"` to the `permissions` block.
- **Remediation hint:** apply-by-default

### Finding 5 — Rule 6: Missing `Bash(rm *)` in allow

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/.claude/settings.json`
- **Layer:** D (KB)
- **Evidence:** `allow` list does not contain `"Bash(rm *)"`. Contains `"Bash(*)"` which covers bash generally but the canonical shape requires the explicit `Bash(rm *)` entry to cover Delete/Remove prompts.
- **Canonical value:** `"Bash(rm *)"` in `allow` (alongside `"Bash(*)"`)
- **Proposed fix (plain English):** Add `"Bash(rm *)"` to the `allow` list.
- **Remediation hint:** apply-by-default

### Finding 6 — Rule 3: Missing dotfile-path companion glob

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/strategic-os/.claude/settings.json`
- **Layer:** D (KB)
- **Evidence:** `allow` contains bare `"Edit"` and `"Write"` but no `"Edit(**/.claude/**)"` or `"Write(**/.claude/**)"`.
- **Canonical value:** Layer D canonical requires `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"`.
- **Proposed fix (plain English):** Add `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` to the `allow` list.
- **Remediation hint:** apply-by-default

### Finding 7 — Rule 2: Missing `defaultMode` entirely

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/marketing-communication/.claude/settings.json`
- **Layer:** D (KB)
- **Evidence:** `permissions` block has no `"defaultMode"` key.
- **Canonical value:** `"defaultMode": "bypassPermissions"`
- **Proposed fix (plain English):** Add `"defaultMode": "bypassPermissions"` to the `permissions` block.
- **Remediation hint:** apply-by-default

### Finding 8 — Rule 6: Missing `Bash(rm *)` in allow

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/marketing-communication/.claude/settings.json`
- **Layer:** D (KB)
- **Evidence:** `allow` list does not contain `"Bash(rm *)"`.
- **Canonical value:** `"Bash(rm *)"` in `allow`
- **Proposed fix (plain English):** Add `"Bash(rm *)"` to the `allow` list.
- **Remediation hint:** apply-by-default

### Finding 9 — Rule 3: Missing dotfile-path companion glob

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/marketing-communication/.claude/settings.json`
- **Layer:** D (KB)
- **Evidence:** `allow` contains bare `"Edit"` and `"Write"` but no `"Edit(**/.claude/**)"` or `"Write(**/.claude/**)"`.
- **Canonical value:** Layer D canonical requires `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"`.
- **Proposed fix (plain English):** Add `"Edit(**/.claude/**)"` and `"Write(**/.claude/**)"` to the `allow` list.
- **Remediation hint:** apply-by-default

### Finding 10 — Rule 7: Deny-shadows-allow (axcion-brand-book)

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json`
- **Layer:** D
- **Evidence:** `deny` contains `"Write(./brand-book/0[1-8]_*.md)"` and `"Edit(./brand-book/0[1-8]_*.md)"`. `allow` contains `"Write(./brand-book/02_color.md)"`, `"Edit(./brand-book/02_color.md)"`, `"Write(./brand-book/03_typography.md)"`, `"Edit(./brand-book/03_typography.md)"`. The deny glob `0[1-8]_*.md` matches `02_color.md` and `03_typography.md`, so the deny silently overrides the explicit allow entries for those two files.
- **Canonical value:** Deny-shadows-allow is flagged but not auto-fixed — may be intentional operator design. Operator decides which wins.
- **Proposed fix (plain English):** Verify intent: if 02_color.md and 03_typography.md should be writable/editable, either remove them from scope of the deny glob or restructure the deny to exclude them (e.g., narrow the glob or list explicit denies).
- **Remediation hint:** needs-operator-review (deny-shadows-allow)

### Finding 11 — Rule 8: `additionalDirectories` workspace-root grant in tracked `settings.json` (should relocate to `settings.local.json`)

This applies to all project-level tracked `settings.json` files that carry `additionalDirectories` with a Patrik-machine absolute path. Per the template Layer D note (changed 2026-06-03), the canonical home for this grant is `settings.local.json`. However, per the template's "Known pending-alignment item (2026-06-03)" note, `/new-project` still writes the grant into the tracked file, so these are **ADVISORY** per the template's explicit instruction — not HIGH stale-path findings.

Files affected (all carry `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"` in tracked `settings.json`):
- `projects/project-planning/.claude/settings.json`
- `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json`
- `projects/buy-side-service-plan/.claude/settings.json`
- `projects/nordic-pe-screening-project/.claude/settings.json`
- `projects/marketing-positioning/.claude/settings.json`
- `projects/obsidian-pe-kb/.claude/settings.json`
- `projects/repo-documentation/.claude/settings.json`
- `projects/interpersonal-communication/.claude/settings.json`
- `projects/positioning-research/.claude/settings.json`
- `projects/axcion-ai-system-owner/.claude/settings.json`
- `projects/global-macro-analysis/.claude/settings.json`
- `projects/corporate-identity/.claude/settings.json`
- `projects/axcion-brand-book/.claude/settings.json`
- `projects/ai-development-lab/.claude/settings.json`
- `projects/axcion-ai-system-owner/vault/.claude/settings.json`
- `projects/repo-documentation/vault/.claude/settings.json`
- `archive/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`

- **Evidence per file:** `"additionalDirectories": ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` in tracked (git-committed) `settings.json`.
- **Canonical value:** This grant belongs in the gitignored `settings.local.json` (Layer D′). The path is correct on this machine but will break for any other operator who pulls the repo. Relocating is deferred pending `/new-project` alignment (template note).
- **Remediation hint:** ADVISORY — relocate to `settings.local.json` per Layer D′ canonical shape. Apply when `/new-project` alignment is addressed (tracked follow-up per template).

### Finding 12 — Rule 8: `additionalDirectories` absent from BOTH tracked and local files (knowledge-bases)

- **Files:**
  - `knowledge-bases/strategic-os/.claude/settings.json` (no `additionalDirectories`; no `settings.local.json`)
  - `knowledge-bases/marketing-communication/.claude/settings.json` (no `additionalDirectories`; no `settings.local.json`)
- **Layer:** D (KB)
- **Evidence:** Neither file contains `additionalDirectories`, and no corresponding `settings.local.json` exists at those paths. AI-resources symlinks (skills, commands, agents) will not resolve for sessions opened in these knowledge-bases.
- **Canonical value:** `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` in `settings.local.json` (Layer D′ shape). Alternatively, add to the tracked `settings.json` as a temporary measure per current `/new-project` behavior.
- **Proposed fix (plain English):** Create `settings.local.json` at each path with `defaultMode: bypassPermissions` and the workspace root in `additionalDirectories`.
- **Remediation hint:** apply-by-default

### Finding 13 — Rule 5: Narrow Bash-only entries without `Bash(*)` catch-all (ai-resources local)

- **File:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json`
- **Layer:** C-local (B′ shape)
- **Evidence:** `allow` contains only four specific `Bash(...)` entries: `"Bash(mkdir -p audits/risk-checks)"`, `"Bash(ls .claude/agents/risk-check-reviewer.md)"`, `"Bash(bash -n .claude/hooks/detect-concurrent-session.sh)"`, `"Bash(cp .claude/hooks/detect-concurrent-session.sh ...)"`. No `"Bash(*)"` catch-all.
- **Canonical value:** Layer B′ canonical `allow` includes `"Bash(*)"`. A local file with only narrow bash entries and no catch-all may cause unexpected bash permission prompts for commands not matching those exact patterns if the parent settings.json's `Bash(*)` is not effective.
- **Note:** The parent `ai-resources/.claude/settings.json` has `"Bash(*)"` and `"defaultMode": "bypassPermissions"`, and this local file also declares `"defaultMode": "bypassPermissions"`. In practice `defaultMode: bypassPermissions` itself prevents prompts. The Rule 5 concern fires structurally (narrow bash entries without catch-all) but may be low risk given `defaultMode` is set. Tagged for completeness.
- **Proposed fix (plain English):** Add `"Bash(*)"` to the `allow` list in this local file, or remove the narrow entries and rely solely on the parent file's `Bash(*)` grant plus `defaultMode`.
- **Remediation hint:** apply-by-default (low practical risk given defaultMode; include in next sweep pass)

---

## Intentional-narrow files (excluded from auto-remediation)

- `ai-resources/workflows/research-workflow/.claude/settings.json` — template-class (both path-class and value-class signals fire); Rules 8 and 9 silenced. Not intentional-narrow in the Edit/Write-scoped sense.

- `knowledge-bases/pe-kb-vault/.claude/settings.json` — INTENTIONAL-NARROW: `allow` has path-scoped `Write(wiki/**)`, `Write(templates/**)`, `Edit(wiki/**)`, `Edit(templates/**)`, `Edit(_setup-notes.md)`, etc. with no bare `Edit`/`Write` entries. `deny` has paired `Write(raw/**)`, `Edit(raw/**)`. Matches the documented intentional-narrow exception (vault-pattern for raw data protection). Note: template names `projects/obsidian-pe-kb/vault/.claude/settings.json` as the known exception but that path no longer exists; `knowledge-bases/pe-kb-vault` is the operational vault KB. Findings for this file are tagged `[INTENTIONAL-NARROW]` and excluded from auto-remediation.

  Observed characteristics that would normally fire rules (tagged but not actioned):
  - [INTENTIONAL-NARROW] Rule 2: `defaultMode` absent from `permissions` block — no `bypassPermissions` declared. This is structural to the intentional-narrow design (narrow permissions are the point).
  - [INTENTIONAL-NARROW] Rule 4: Missing bare `Edit`/`Write` entries — by design.
  - [INTENTIONAL-NARROW] Rule 6: No `Bash(rm *)` — by design (vault guards against rm).
  - [INTENTIONAL-NARROW] Rule 3: No dotfile-path companion — by design.
  - [INTENTIONAL-NARROW] Rule 8: No `additionalDirectories` — by design (vault is intentionally sandboxed).

- `projects/strategic-os/.claude/settings.json` — INTENTIONAL-NARROW: `allow` contains path-scoped `Write(projects/strategic-os/...)` and `Edit(projects/strategic-os/...)` entries with no bare `Edit`/`Write`. `deny` contains `Write(projects/strategic-os/state/live/**)`, `Edit(projects/strategic-os/state/live/**)`, `Write(projects/strategic-os/inputs/**)`, `Edit(projects/strategic-os/inputs/**)` — paired denies to the allow scopes. Both heuristic conditions satisfied.

  Tagged findings (not actioned):
  - [INTENTIONAL-NARROW] Rule 4: Missing bare `Edit`/`Write` — by design.
  - [INTENTIONAL-NARROW] Rule 5: Missing `Bash(*)` — all bash entries are narrow (`Bash(ls *)`, `Bash(git status:*)`, etc.); no catch-all.
  - [INTENTIONAL-NARROW] Rule 6: No `Bash(rm *)` — by design.
  - [INTENTIONAL-NARROW] Rule 3: No `Edit(**/.claude/**)` companion — by design.

---

## Parse errors

None. All 41 files parsed successfully.

---

## Layer-level summary

| Layer | File | defaultMode | Bash(*) | Edit(**/.claude/**) | additionalDirs | Issues |
|-------|------|-------------|---------|---------------------|----------------|--------|
| A | ~/.claude/settings.json | bypassPermissions | yes | n/a | workspace root present | clean |
| B | .claude/settings.json | bypassPermissions | yes | yes (Edit(**/.claude/**)) | workspace root in allow | clean |
| B′ | .claude/settings.local.json | bypassPermissions | yes | n/a | n/a | clean |
| C | ai-resources/.claude/settings.json | bypassPermissions | yes | yes | absolute path in allow | clean |
| C-local | ai-resources/.claude/settings.local.json | bypassPermissions | no | n/a | n/a | Finding 13 (Rule 5, low risk) |
| D-template | research-workflow/.claude/settings.json | bypassPermissions | yes | yes | {{WORKSPACE_ROOT}} placeholder | template-class, silenced |
| D | projects/* (17 files) | bypassPermissions | yes (except strategic-os) | yes (except brand-book, ai-dev-lab) | Patrik path in tracked JSON | Finding 2, 3 (Rule 3); Finding 11 (Rule 8 ADVISORY) |
| D | kb/strategic-os | MISSING | yes | no | absent | Findings 4,5,6 |
| D | kb/marketing-comm | MISSING | yes | no | absent | Findings 7,8,9 |
| D | kb/pe-kb-vault | n/a | n/a | n/a | absent | intentional-narrow |
| D (nested) | knowledge-base/.claude/settings.json | bypassPermissions | yes | yes | STALE Daniel path | Finding 1 (Rule 9, HIGH) |
