---
model: sonnet
argument-hint: "[full] [cutoff=NN]"
---

Identify the **operational backbone** of the Axcíon AI system — the resources every session leans on, across **all AI-infrastructure types** (commands, agents, hooks, skills, config-and-docs) — and write a ranked, reasoned manifest split by type.

**Identify-only.** This command does not review, fix, or edit any resource. It tells you *which* resources are critical so you know which handful to think through yourself. It writes exactly one file (its own manifest) and echoes the same to chat.

> **Downstream opportunity (not built):** the manifest is the natural Tier-1-first selection input for `/pipeline-review` (which currently selects on an audit-cost lens, not blast-radius). Deferred until that consumer is wired — do not build the coupling from here.

## Usage

- `/list-critical-resources` — default: ranked manifest, one section per resource type.
- `/list-critical-resources full` — adds the per-resource signal breakdown and the full excluded-set listing.
- `/list-critical-resources cutoff=NN` — override the New threshold (default **30** days). New entries are tagged `[new]` inline. Combinable with `full`. (30 chosen because most of the corpus was built in early April 2026; a wider window lumps the founding month in with genuinely recent additions.)

## What "critical" means here

The **operational-backbone** lens: session-dependency + blast-radius. A backbone resource is one the system leans on every session, or one whose failure ripples across many other resources or projects. This is a *different* lens from `pipeline-review-registry.md` (which ranks audit-cost) — that registry is **not** read or reused.

Five resource types are ranked, because the critical infrastructure is not only commands:

| Type | Pool | Why it can be critical |
|------|------|------------------------|
| Commands | `.claude/commands/*.md` | session spine + orchestration entry points |
| Agents | `.claude/agents/*.md` | do the heavy fan-out work commands dispatch to |
| Hooks | `.claude/hooks/*` | fire automatically every session; silent failure = silent degradation |
| Skills | `skills/*/SKILL.md` | canonical methodology assets multiple commands depend on |
| Config & docs | curated load-bearing set | always-loaded rules; break them and every session shifts |

---

### Step 1 — Resolve paths + set up degradation

1. Set `AI_RESOURCES` = absolute path to the nearest `ai-resources/` directory. Resolution: from the current working directory, walk upward until a directory named `ai-resources/` is found at or above (mirrors `placement.md` Step 2 / `auto-sync-shared.sh`). If no upward match, fall back to `~/Claude Code/Axcion AI Repo/ai-resources/`.

2. Set `WORKSPACE` = parent directory of `AI_RESOURCES` (the workspace root).

3. The two backbone source docs live **outside** `ai-resources`, at:
   - `{WORKSPACE}/projects/repo-documentation/vault/architecture/risk-topology.md`
   - `{WORKSPACE}/projects/repo-documentation/vault/architecture/system-doc.md`
   Test readability of each. If **either** is unreadable (e.g. an ai-resources-only `--add-dir` session), set `VAULT_DEGRADED = true` and carry the warning `⚠ vault docs unreachable — ranking on computed signals only` into both the chat output and the manifest header. The command still runs (Step 5 degradation path).

4. Set `TODAY` from session context (today's date in `YYYY-MM-DD`). Do **not** compute it at runtime.

5. Parse `$ARGUMENTS`: `full` (case-insensitive) enables expanded mode; `cutoff=NN` overrides the New threshold (integer days). Default cutoff = 30.

### Step 2 — Build the candidate set (five pools)

6. Build one candidate list per type. Each candidate carries its `type`, display name, and file path.
   - **Commands** — every `*.md` in `{AI_RESOURCES}/.claude/commands/`. Name = filename without `.md` (`prime.md` → `/prime`).
   - **Agents** — every `*.md` in `{AI_RESOURCES}/.claude/agents/`. Name = filename without `.md` (`context-discovery.md` → `context-discovery`).
   - **Hooks** — every file in `{AI_RESOURCES}/.claude/hooks/` (`.sh` files plus extensionless hooks like `pre-commit`). Name = filename.
   - **Skills** — every `SKILL.md` under `{AI_RESOURCES}/skills/*/`. Name = the containing directory (`skills/ai-resource-builder/SKILL.md` → `ai-resource-builder`).
   - **Config & docs** — a **curated bounded set**, NOT an exhaustive crawl. Include exactly: `{WORKSPACE}/CLAUDE.md`, `{AI_RESOURCES}/CLAUDE.md`, `{WORKSPACE}/.claude/settings.json`, `{AI_RESOURCES}/.claude/settings.json`, and the load-bearing docs named in `risk-topology § 1` — `principles.md`, `references/documentation-structure.md`, `docs/audit-discipline.md`. Skip any that are unreadable; under `VAULT_DEGRADED` the vault-resident docs may be absent — fall back to the always-readable CLAUDE.md / settings.json members and note the partial set.

   The per-type pool sizes are the denominators reported in the manifest header.

### Step 3 — Gather signals per candidate

Use `Read`, `Grep`/ripgrep, and read-only `git` only. Do not write or edit any source file. Run signals per type as below; not every signal applies to every type.

7. **Reference-scan (corpus-wide blast-radius proxy)** — for each candidate, count the **distinct other files across the whole resource corpus** (`.claude/`, `skills/`, `docs/`) that reference it. This is the generalisation of the old command-only invoke-density — a resource referenced from many places has wide blast radius. The match token differs by type:
   - **Command `<n>`** — `rg -Pl '/<n>(?![-A-Za-z0-9])' {AI_RESOURCES}/.claude/ {AI_RESOURCES}/skills/ {AI_RESOURCES}/docs/ | grep -v 'commands/<n>.md' | wc -l`. The negative-lookahead `(?![-A-Za-z0-9])` prevents `/prime` matching `/primer`.
   - **Agent `<n>`** — `rg -Pl '\b<n>\b' {AI_RESOURCES}/.claude/ {AI_RESOURCES}/skills/ {AI_RESOURCES}/docs/ | grep -v 'agents/<n>.md' | wc -l`. Agent names are distinctively hyphenated (`repo-dd-auditor`, `context-discovery`), so a whole-word match has low false-positive risk; they are referenced via `subagent_type:` / `Task` / `Agent` invocations.
   - **Hook `<n>`** — `rg -Pl '<n>' {AI_RESOURCES}/.claude/ {AI_RESOURCES}/docs/ | grep -v 'hooks/<n>' | wc -l`. Most hooks are referenced by their filename in `settings.json` event wiring and in docs.
   - **Skill `<n>`** — `rg -Pl '/<n>(?![-A-Za-z0-9])|skills/<n>\b|Skill\(["'\'']?<n>' {AI_RESOURCES}/.claude/ {AI_RESOURCES}/skills/ {AI_RESOURCES}/docs/ | grep -v 'skills/<n>/' | wc -l`. Skills are invoked as `/<n>` slash commands, via `Skill(<n>)`, and referenced by `skills/<n>/` path. Where a skill shares a name with a command, the Commands entry covers the slash behaviour and the Skills entry covers the SKILL.md methodology asset — both may appear; this is not double-counting, they are different resources.
   - **Config/doc `<path>`** — distinct files that reference the path or are governed by it: `rg -Pl '<basename>' {AI_RESOURCES}/.claude/ {AI_RESOURCES}/docs/ | wc -l`.

8. **Git first-commit date** — for each candidate's file:
   ```
   git -C {AI_RESOURCES} log --diff-filter=A --format=%ad --date=short -- <relative-path> | tail -1
   ```
   `tail -1` takes the earliest (introduction) date. For config/doc members outside `AI_RESOURCES` (workspace `CLAUDE.md` / `settings.json`), run `git -C {WORKSPACE} log ...` instead.

9. **Fan-out depth (orchestration weight)** — for commands and skills, count the **distinct downstream resources the file itself invokes**: agents (`subagent_type:` / `Agent` / `Task` spawns), other commands (`/<name>`), skills (`Skill(...)`), and named pipeline stages. Pattern seed: `rg -o 'subagent_type:\s*[A-Za-z0-9-]+|Skill\([^)]+\)|pipeline-stage-[0-9a-z]+|/[a-z][a-z0-9-]+' <file> | sort -u`, then judgment-filter to genuine downstream invocations (drop self-references and prose mentions). A command that drives many agents (e.g. `/new-project` → five `pipeline-stage-*`) has high fan-out and therefore high *latent* blast radius even when its own reference-scan is low. Record the distinct downstream count and which backbone resources it drives.

10. **Blast-radius seed (hybrid — named)** — read `risk-topology.md` (skip if `VAULT_DEGRADED`). This is the curated half of the hybrid signal; the reference-scan (Step 7) and fan-out (Step 9) are the computed half.
   - **§ 1 Load-Bearing Components** names critical/high resources **across types** — Critical: `CLAUDE.md` (workspace), `ai-resources/CLAUDE.md`, `auto-sync-shared.sh`, `settings.json` (workspace), `friday-checkup.md`. High: `principles.md`, `references/documentation-structure.md`, `audit-discipline.md`, `qc-reviewer` agent, `triage-reviewer` agent, and the `.prime-mtime` two-end contract (binds `/prime`, `/session-start`, `/wrap-session`).
   - **§ 2 reverse map** ("Changed resource → Projects affected") names resources with measured cross-project blast radius: `/new-project`, `/qc-pass` (+ `qc-reviewer` + `triage-reviewer`), `/friday-checkup`, `/friday-act`, `CLAUDE.md` (workspace), `auto-sync-shared.sh`.
   - Map each named entry to its candidate (by type + name). These names are the **Tier-1 seed**.

11. **Lifecycle / fires-every-session role** — read `{AI_RESOURCES}/docs/session-rituals.md` and `system-doc.md § 4.5` (skip the latter if `VAULT_DEGRADED`).
   - **Commands:** a command is a **lifecycle command** if it appears as a step in `session-rituals.md`'s `## Session Start` list, the `## Phase 3` START/DURING/END diagram, or the `## Session End` list (yields `/prime`, `/session-plan`, `/session-start`, `/wrap-session`, `/improve`, `/usage-analysis`, `/coach`).
   - **Hooks:** a hook wired to `SessionStart` / `Stop` / `PreToolUse` in any `settings.json` **fires every session** — the hook analogue of a lifecycle role. Treat "wired in settings.json" as the membership test.

### Step 4 — Backbone inclusion filter (per-type floors + coupling)

12. Named constants (all tuning knobs live here; reused by Step 5):
    - Inclusion floors — `DENSITY_FLOOR_COMMAND = 4`, `DENSITY_FLOOR_AGENT = 2`, `DENSITY_FLOOR_SKILL = 2`
    - `FANOUT_FLOOR = 3`
    - Tier-1 reference-scan thresholds — `TIER1_COMMAND = 8`, `TIER1_AGENT = 4`, `TIER1_SKILL = 5`

13. A candidate qualifies as **backbone** if **ANY** of:
    - **Named** in the `risk-topology § 1` / `§ 2` Tier-1 seed (Step 10), OR
    - **Lifecycle / fires-every-session** (Step 11), OR
    - **Reference-scan ≥ its type floor** — commands ≥ 4, agents ≥ 2, skills ≥ 2; **hooks**: wired in any `settings.json` OR reference-scan ≥ 1 (a live hook is operationally load-bearing by definition); **config/doc**: every curated-set member is backbone by construction, OR
    - **Fan-out ≥ `FANOUT_FLOOR`** (orchestrator credit — a heavyweight pipeline like `/new-project`), OR
    - **Fan-out coupling** — the candidate is the primary invoker of a resource that is itself backbone (entry-point criticality). This is the rule that captures **context-pack generation**: `/build-context` drives the `context-discovery` agent, so even at a sub-floor reference-scan the command is backbone because it is the entry point to critical machinery. Tag these `[fanout]`.

    Every other candidate is **excluded** — counted, and listed only in `full` mode.

### Step 5 — Two-axis tier assignment, per type (do not collapse)

14. Within each type, assign each backbone resource to exactly one tier:
    - **Tier 1 — Critical** (evidenced system-wide / multi-project blast radius) if ANY of:
      - in the `risk-topology § 1` **Critical** seed or the `§ 2` reverse map, OR
      - **computed Tier-1**: reference-scan ≥ the type's Tier-1 threshold (`TIER1_COMMAND`, `TIER1_AGENT`, `TIER1_SKILL`), OR
      - **pipeline hub**: fan-out ≥ `FANOUT_FLOOR` **and** it drives two or more backbone resources (a true orchestration spine, e.g. `/new-project`), OR
      - **hooks only**: a `SessionStart` hook that distributes shared state (e.g. `auto-sync-shared.sh`) is Tier 1 by the § 1 Critical seed.
    - **Tier 2 — High**: all remaining backbone resources (passed inclusion in Step 13 but not Tier 1).
    - **By design, hooks and config/docs have no *computed* Tier-1 path** — they reach Tier 1 only via the named `risk-topology § 1`/`§ 2` seed. Reference-scan is a weak cross-project blast-radius proxy for these two types (hooks fire by event, not by fan-in count; config/docs are referenced everywhere by nature), so a high scan count must not auto-promote them. A live hook with no § 1/§ 2 entry is correctly Tier 2, not an omission.

15. Within each tier, sort by reference-scan descending (ties broken by fan-out descending, then alphabetically).

16. **Tags** on each manifest line:
    - `[computed-fresh]` — placed by computed signals (reference-scan / fan-out / lifecycle) rather than a named entry in `risk-topology`/`system-doc`. Its rank comes from measured signals, not inherited classification.
    - `[fanout]` — included via the fan-out-coupling rule (Step 13, last bullet).
    - `[new]` — git first-commit date on/after `(TODAY − cutoff days)`.
    A line may carry more than one tag.

17. **Degradation path** (`VAULT_DEGRADED = true`): the named Tier-1 seed cannot be read. Hard-code two load-bearing exceptions into Tier 1 by name — `friday-checkup.md` (command) and `auto-sync-shared.sh` (hook). Rank every other backbone resource in Tier 2 by computed signals only. Use only the always-readable config/doc members (the two `CLAUDE.md` files + two `settings.json` files). Carry the Step 1 degradation warning at the top of the manifest in place of the staleness caveat.

### Step 6 — Staleness guard + write manifest + echo

18. **Staleness guard** (skip if `VAULT_DEGRADED`): read `risk-topology.md`'s `last_updated` frontmatter value. Across **all types**, count the backbone resources whose git first-commit date is **newer** than `last_updated` AND that are **not** in the named § 1/§ 2 seed. These may be high-blast-radius but cannot be evidenced, so they are Tier-1-demoted *by construction*. Emit a **mandatory caveat line** (manifest header + chat echo) naming the date, the count, and the affected resources. Omit the caveat only when the count is 0.

19. Overwrite `{AI_RESOURCES}/audits/backbone-manifest.md` with the structure below, and echo the same content to chat. Use markdown links: `[/command](.claude/commands/<n>.md)`, `[agent](.claude/agents/<n>.md)`, `[hook](.claude/hooks/<n>)`, `[skill](skills/<n>/SKILL.md)`, `[CLAUDE.md](CLAUDE.md)` etc.

**Header `⚠` line — emit exactly one (or none):** if staleness count `N > 0`, emit the staleness caveat. If `N = 0`, omit the `⚠` line. If `VAULT_DEGRADED`, replace it with `> ⚠ vault docs unreachable — ranking on computed signals only`.

Each type section uses the same `### Tier 1 — Critical` / `### Tier 2 — High` shape. For an empty tier, print `None.` Skip a whole type section only if its pool is empty (never expected). The `why` line is one short clause sourced from the signal that placed it (named § / lifecycle / reference-scan N / fan-out drives X).

```
# Critical Resources — Operational Backbone Manifest
_Generated: {TODAY} · New (introduced on/after {TODAY − cutoff}, {NN}d) tagged [new] · pool: {C} commands, {A} agents, {H} hooks, {S} skills, {D} config-docs_
> ⚠ Tier-1 source risk-topology.md last_updated {DATE} · {N} resource(s) postdate it — Tier-1 completeness not guaranteed for: {names}

## Commands
### Tier 1 — Critical
- [/command](.claude/commands/command.md) — refs: {N} · fan-out: {M} · since {YYYY-MM-DD} · why: {clause} {tags}
### Tier 2 — High
- ...

## Agents
### Tier 1 — Critical
- [agent](.claude/agents/agent.md) — refs: {N} · since {YYYY-MM-DD} · why: {clause} {tags}
### Tier 2 — High
- ...

## Hooks
### Tier 1 — Critical
- [hook.sh](.claude/hooks/hook.sh) — refs: {N} · event: {SessionStart|Stop|PreToolUse|—} · since {YYYY-MM-DD} · why: {clause} {tags}
### Tier 2 — High
- ...

## Skills
### Tier 1 — Critical
- [skill](skills/skill/SKILL.md) — refs: {N} · fan-out: {M} · since {YYYY-MM-DD} · why: {clause} {tags}
### Tier 2 — High
- ...

## Config & Docs
### Tier 1 — Critical
- [CLAUDE.md](CLAUDE.md) — refs: {N} · since {YYYY-MM-DD} · why: {clause} {tags}
### Tier 2 — High
- ...

## Excluded from backbone
- {N} resources did not meet the inclusion filter ({c} commands, {a} agents, {h} hooks, {s} skills). (Run `/list-critical-resources full` to list them.)
```

End with one summary line (nothing after it):
`{total} backbone resources across 5 types — {T1} Tier-1, {T2} Tier-2, {new} new.`

### Step 7 — `full` mode

20. If `full` is set, additionally:
    - Replace the `## Excluded from backbone` count with a full listing grouped by type (one line per excluded resource: name + reference-scan + git date).
    - Add a per-resource **signal breakdown** under each backbone entry: reference-scan, fan-out (where applicable), git date, lifecycle/event role, and which signal (`§ 1` / `§ 2` / lifecycle / reference-scan / fan-out / fan-out-coupling) placed it in its tier.

### Step 8 — No review, no fixes, no other writes

21. The command writes only `audits/backbone-manifest.md`. It does not review, score quality, propose fixes, edit other resources, or commit anything. Identification ends here.

$ARGUMENTS
