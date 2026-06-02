# Risk Check — 2026-06-02

## Change

Rewrite the canonical command .claude/commands/list-critical-resources.md to widen its candidate pool from commands-only to all 5 AI-infrastructure types (commands, agents, hooks, skills, config-and-docs), add a hybrid blast-radius signal (risk-topology seed + computed reference-scan) and a fan-out-depth signal, and emit a split-by-type manifest. Identify-only command; writes one audit file (audits/backbone-manifest.md); no edits to inventoried resources.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/list-critical-resources.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/backbone-manifest.md — exists

## Verdict

GO

**Summary:** A self-contained rewrite of one identify-only command with no callers depending on its manifest structure, no permission changes, and clean git-revert reversibility; the only elevated factor is internal-complexity growth, which is bounded and Low-to-Medium.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The command is pay-as-used, not always-loaded. Slash commands load only when invoked; the file is not an `@import` in CLAUDE.md and registers no hook. The change adds no auto-load surface.
- Per-run cost rises (more Read/Grep/git calls): candidate pool grows from 70 commands (`ls .claude/commands/*.md` = 70) to also include 33 agents, 17 hook files, and 78 skills (`ls` counts). This is per-invocation token/tool cost, not per-session standing cost, and the command's own invoke-density is 1 (self-referenced only — confirmed below), so runs are rare.
- No content added to any always-loaded file. The rewrite stays inside the command body and the generated manifest.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change adds no `allow`/`ask` entries and removes no `deny` rule (per CHANGE_DESCRIPTION: "does not add permissions"). The existing command already declares Read/Grep/read-only-git as its only tools (current file Step 3, line 45: "Use `Read`, `Grep`/ripgrep, and read-only `git` only").
- Widening the scan to agents/hooks/skills/docs uses the same Read/Grep/git capability family already exercised, on paths already inside `{AI_RESOURCES}` and the workspace vault the command already reads (current lines 30–33). No new tool family, no new path class, no external API.
- Write surface unchanged: exactly one output file, `audits/backbone-manifest.md` (current line 133; CHANGE_DESCRIPTION confirms "writes one audit file").

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 1 (the command). The manifest is regenerated output, not a hand-maintained contract.
- Caller enumeration (`rg -l 'list-critical-resources'` across the repo, excluding the command itself and the manifest): 2 hits — `audits/risk-checks/2026-06-01-list-critical-resources-new-command-endtime.md` and `...-new-command.md`. Both are prior risk-check artifacts (historical records), not runtime callers. Zero commands/agents/hooks invoke this command.
- Manifest-structure consumers (`rg -l 'backbone-manifest'`, same exclusions): same 2 historical risk-checks, zero live consumers. The one documented downstream coupling (`/pipeline-review` as a Tier-1 selection input) is explicitly **not built** and deferred (current file line 10: "Downstream opportunity (not built) … Deferred until that consumer is wired — do not build the coupling from here"). So the split-by-type manifest restructure breaks no caller.
- Auto-sync propagation is by symlink, not copy: `auto-sync-shared.sh` lines 82–94 `ln -s` each `.claude/commands/*.md` into every project. The rewrite propagates everywhere automatically with no divergence and no per-project edit — the canonical file is the single source. This is the intended mechanism, not blast radius.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to a tracked command; `git revert` (or checkout of the prior blob) fully restores the prior command body. No sibling files or directories created by the change itself.
- The manifest (`audits/backbone-manifest.md`) is overwrite-regenerated, not append-only (current line 97: "Overwrite … with the structure below"). A revert of the command followed by one re-run restores the old manifest shape; the stale manifest is not a log that carries history forward.
- No state leaves git: no push, no external write, no auto-commit (CHANGE_DESCRIPTION: "does not auto-commit"). No hook/cron/symlink added that could fire between landing and revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new blast-radius signal seeds from `risk-topology.md` and `system-doc.md`, which the current command **already** depends on and already guards with a `VAULT_DEGRADED` fallback (current lines 30–33, 59–64, 85). Widening the seed-read does not introduce a new implicit dependency — it reuses an established, already-documented-at-the-site convention with a degradation path.
- No silent auto-firing: the command runs only on explicit `/list-critical-resources` invocation; it is not a hook and does not react to events.
- No undocumented contract foisted on callers: there are no live callers (Dimension 3), and the manifest format change is documented in the command body's own template block. The deferred `/pipeline-review` consumer is told not to couple yet, so no contract is silently established.
- Mild note: the rewrite expands one command to span 5 resource types, each with its own filename/registry conventions (e.g. agents in `.claude/agents/`, skills as `skills/*/SKILL.md`, hooks as non-`.md` files). These conventions are stable repo facts the command will read, not new contracts it imposes — coupling stays Low, but the rewrite's internal correctness across 5 heterogeneous layouts is where implementation QC should concentrate.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the current command and manifest, grep counts for callers and manifest consumers, `ls` pool counts, and `auto-sync-shared.sh` line references). No training-data fallback was used on fetch/read failures.
