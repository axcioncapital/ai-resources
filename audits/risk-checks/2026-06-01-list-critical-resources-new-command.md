# Risk Check — 2026-06-01

## Change

PLAN-TIME gate. New command `/list-critical-resources` (new-command change class). Design: a standalone, on-demand, identify-only slash command at `ai-resources/.claude/commands/list-critical-resources.md`, `model: sonnet`. It scans the ~69 command files in `ai-resources/.claude/commands/`, computes four signals per command (invoke-density via ripgrep over command bodies; git first-commit date; blast-radius evidence read from workspace-root vault docs `projects/repo-documentation/vault/architecture/risk-topology.md` §1+§2 and `system-doc.md` §4.5; lifecycle role from `ai-resources/docs/session-rituals.md`), filters to a "backbone" set, ranks them on a two-axis Critical/High split, splits each tier New vs Established by git first-commit date, and WRITES ONE output file: `ai-resources/audits/backbone-manifest.md` (overwrite each run) plus a chat echo. It does NOT review, fix, or edit any other resource. No agent definition, no hooks, no settings changes, no cadence wiring. Reads two vault docs that live outside ai-resources (workspace root) with graceful degradation if unreachable. The command is read-only against every input; its only write is its own manifest. Risk-check is firing as the mandatory plan-time gate for the new-command class.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/list-critical-resources.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/backbone-manifest.md — not yet present (runtime output)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/system-doc.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-rituals.md — exists

## Verdict

GO

**Summary:** A standalone, on-demand, read-only command whose only write is its own overwrite-each-run manifest — every risk dimension is Low except a single Medium (auto-distribution to all projects via auto-sync), well within the GO threshold of one Medium.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The change adds a new optional command file at `ai-resources/.claude/commands/list-critical-resources.md`; it is pay-as-used, not auto-loaded on any turn. CHANGE_DESCRIPTION: "standalone, on-demand, identify-only slash command."
- No hook is registered: "No agent definition, no hooks, no settings changes, no cadence wiring." So no SessionStart / PreToolUse / per-tool token cost is added.
- No `@import` chain and no subagent brief is added — the command does its own scan inline; no frequently-spawned subagent.
- `model: sonnet` is declared in frontmatter (per workspace Model Tier rule for an orchestration/scan command), incurring cost only when the operator invokes it. The scan reads ~69 command bodies plus three docs at invocation time only — a per-run cost the operator pays deliberately, not an ongoing per-session tax. Verbatim: "scans the ~69 command files." Confirmed live count: 69 files in `.claude/commands/` (grep: `ls .claude/commands/*.md | wc -l` → 69).

### Dimension 2: Permissions Surface
**Risk:** Low

- "No … settings changes" — no `allow` / `ask` / `deny` entry added, removed, or widened.
- The command's operations (ripgrep over command bodies, `git` first-commit-date reads, Read against vault docs) are all read-only and fall within already-established read/scan patterns used by existing audit commands (`/repo-dd`, `/token-audit`). No new tool family or external/cross-repo write capability is introduced.
- The only write is to `ai-resources/audits/backbone-manifest.md`, inside the repo's existing `audits/` directory (confirmed present), which existing audit commands already write to — no new Write path authorization is required.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 1 new command file (`list-critical-resources.md`) plus 1 runtime output (`backbone-manifest.md`, overwrite-each-run). No edits to any existing file.
- Existing references to either new artifact: 0. Grep `grep -rl "list-critical-resources" .claude/ docs/` → 0 files; `grep -rl "backbone-manifest" .claude/ docs/ audits/` → 0 files. Nothing currently depends on this command or its output, so no caller requires modification.
- No contract change: the command introduces no shared parse marker, no schema other components read, no heading other commands target. Its manifest is consumed by humans (chat echo + file), not by a downstream parser.
- **Auto-distribution (the Medium driver):** `/list-critical-resources` is NOT in the auto-sync exclusion list. `auto-sync-shared.sh:46` excludes only `new-project deploy-workflow run-sufficiency pipeline-review`. Per `system-doc.md` §4.4 / risk-topology §3 ("New canonical command/agent → Blast radius: All projects (auto-synced)"), this command will be symlinked into every project's `.claude/` at the next SessionStart. The symlink itself is inert (the command only runs on explicit invocation), so the effective runtime blast radius stays narrow — but the distribution mechanically touches all 7 projects' `.claude/` directories, which is what elevates this dimension to Medium rather than Low.
- Components grep'd: command directory (69 files), `docs/`, `audits/`, `auto-sync-shared.sh`. Reference counts: 0 inbound callers, 1 distribution mechanism (auto-sync), 0 contract dependents.

### Dimension 4: Reversibility
**Risk:** Low

- The command file is a single new file: `git revert` (or `git rm`) fully removes it within the working tree. No edit to an existing file to unwind.
- The manifest `backbone-manifest.md` is overwrite-each-run (not append-only) and is a generated artifact in `audits/`. Deleting the command leaves at most one stale generated file; removing it is a one-line `rm` and carries no forward state (no log appendices, no entries that propagate). It does not collide with any existing `audits/*.md` file (verified — no `backbone-manifest.md` currently present).
- No state propagates beyond git: no push, no Notion write, no external POST, no auto-commit. "No … hooks … no cadence wiring" — nothing fires automatically between landing and a potential revert. The auto-sync symlinks created in projects are regenerated each SessionStart from the canonical source, so removing the canonical command clears them at the next session start with no manual per-project cleanup.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The command depends on three named inputs, all explicitly stated in CHANGE_DESCRIPTION and all confirmed to exist: `risk-topology.md` §1+§2, `system-doc.md` §4.5, `session-rituals.md`. The dependency on the two workspace-root vault docs is real but (a) named, and (b) explicitly handled: "graceful degradation if unreachable." That converts what would otherwise be a silent cross-root coupling into a declared, fail-soft one.
- One latent convention dependency worth noting (not elevating): the design reads vault docs by section anchor (`§1`, `§2`, `§4.5`). If those section numbers are renumbered upstream the scan would silently mis-read. This is a single implicit dependency on an established doc convention with stated graceful degradation, which keeps the dimension at Low — but the operator should pin the anchors as section-title strings rather than bare numbers where feasible.
- No silent auto-firing: the command runs only on explicit invocation; it registers no hook and writes only its own manifest, so it cannot mutate shared state in an unexpected context.
- No functional overlap that creates a two-systems-one-concern hazard: it is identify-only and writes a distinct, non-canonical manifest. It does not overlap the `risk-topology.md` load-bearing tables (which remain the manually-maintained source of truth) in a way that has both writing the same file — the command consumes those docs, it does not write them.
- Note on `not yet present` files: the command file and manifest do not exist on disk; their contribution above is assessed from the described intent in CHANGE_DESCRIPTION, as required. No file tagged `not yet present` was read.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references — e.g., `auto-sync-shared.sh:46`; grep counts — 69 commands, 0 inbound references; verbatim quotes from CHANGE_DESCRIPTION and from risk-topology.md / system-doc.md; directory-existence checks for `audits/` and `audits/risk-checks/`). No training-data fallback was used on any fetch/read.
