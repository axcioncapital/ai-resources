---
model: sonnet
argument-hint: "[full] [cutoff=NN]"
---

Identify the **operational backbone** of the Axcíon AI command system — the commands every session leans on — and write a ranked, reasoned manifest split into New vs Established entries.

**Identify-only.** This command does not review, fix, or edit any command. It tells you *which* resources are critical so you know which handful to think through yourself. It writes exactly one file (its own manifest) and echoes the same to chat.

> **Downstream opportunity (not built):** the manifest is the natural Tier-1-first selection input for `/pipeline-review` (which currently selects on an audit-cost lens, not blast-radius). Deferred until that consumer is wired — do not build the coupling from here.

## Usage

- `/list-critical-resources` — default: ranked manifest, one line per backbone command.
- `/list-critical-resources full` — adds the per-command signal breakdown and the excluded-set listing.
- `/list-critical-resources cutoff=NN` — override the New-vs-Established threshold (default **30** days). Combinable with `full`. (30 chosen because most of the corpus was built in early April 2026; a wider window lumps the founding month in with genuinely recent additions.)

## What "critical" means here

The **operational-backbone** lens: session-dependency + blast-radius. A backbone command is one the system leans on every session, or one whose failure ripples across many commands or projects. This is a *different* lens from `pipeline-review-registry.md` (which ranks audit-cost) — that registry is **not** read or reused.

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

### Step 2 — Build the candidate set

6. List every `*.md` file in `{AI_RESOURCES}/.claude/commands/`. This is the full candidate pool (~69 commands) and the denominator — more reliable than the `vault/components/commands.md` registry. Each candidate's name is its filename without `.md` (e.g. `prime.md` → `/prime`).

### Step 3 — Gather four signals per candidate

Use `Read`, `Grep`/ripgrep, and read-only `git` only. Do not write or edit any source file.

7. **Invoke-density** — for each candidate `<name>`, count how many *other* command files reference it:
   ```
   rg -Pl '/<name>(?![-A-Za-z0-9])' {AI_RESOURCES}/.claude/commands/ | grep -v 'commands/<name>.md' | wc -l
   ```
   The negative-lookahead `(?![-A-Za-z0-9])` prevents `/prime` matching `/primer` and `/new-project` matching `/new-project-x`. The `grep -v` excludes the command's own file. Record the distinct-file count.

8. **Git first-commit date** — for each candidate:
   ```
   git -C {AI_RESOURCES} log --diff-filter=A --format=%ad --date=short -- .claude/commands/<name>.md | tail -1
   ```
   `tail -1` takes the earliest (introduction) date.

9. **Blast-radius evidence** — read `risk-topology.md` (skip if `VAULT_DEGRADED`):
   - **§ 1 Load-Bearing Components** is *component-level*. Among commands it names only **`friday-checkup.md`** (Critical). The § 1 High table names agents + the `.prime-mtime` two-end contract, which binds `/prime`, `/session-start`, `/wrap-session`.
   - **§ 2 reverse map** ("Changed resource → Projects affected") names commands with measured cross-project blast radius: `/new-project`, `/qc-pass`, `/friday-checkup`, `/friday-act`.
   - Use § 1 + § 2 as the evidenced blast-radius signal. Do **not** treat § 1 as a per-command Critical/High table — it is not.

10. **Choke-point + lifecycle role** — read `system-doc.md § 4.5` (closed-loop table + one-way flows; skip if `VAULT_DEGRADED`) and `{AI_RESOURCES}/docs/session-rituals.md`. For lifecycle membership, parse three sections of `session-rituals.md`: the `## Session Start` list, the `## Phase 3` START/DURING/END diagram, and the `## Session End` list. A command is a **lifecycle command** if it appears as a step in any of these (yields `/prime`, `/session-plan`, `/session-start`, `/wrap-session`, `/improve`, `/usage-analysis`, `/coach`).

### Step 4 — Backbone inclusion filter

11. A candidate qualifies as **backbone** if **ANY** of:
    - named in `risk-topology § 1` (Critical/High) or the `§ 2` reverse map, OR
    - a session-lifecycle command per Step 10, OR
    - referenced by **≥ DENSITY_FLOOR distinct** other command files, where **`DENSITY_FLOOR = 4`** (this named constant is reused by Step 5).

    Every other candidate is **excluded** — counted, and listed only in `full` mode.

### Step 5 — Two-axis tier assignment (do not collapse)

12. Assign each backbone command to exactly one tier:
    - **Tier 1 — Critical** (evidenced system / multi-project blast radius): the command is in `risk-topology § 1` Critical (`/friday-checkup`) **OR** in the `§ 2` reverse map (`/new-project`, `/qc-pass`, `/friday-checkup`, `/friday-act`).
    - **Tier 2 — High** (session-spine / computed backbone): all remaining backbone commands — session-lifecycle role, `.prime-mtime`-contract membership (`/prime`, `/session-start`, `/wrap-session`), or invoke-density ≥ `DENSITY_FLOOR` (= 4, from Step 11; e.g. `/handoff`).

13. Within each tier, sort by invoke-density descending (ties broken alphabetically).

14. Tag any command placed by **computed signals rather than a named entry in `risk-topology`/`system-doc`** (e.g. `/handoff`) with `[computed-fresh]` in its manifest line — its rank comes from measured signals, not inherited classification.

15. **Degradation path** (`VAULT_DEGRADED = true`): Tier 1 cannot be evidenced. Place `/friday-checkup` in Tier 1 by name as the sole hard-coded exception; rank every other backbone command in Tier 2 by computed signals; carry the Step 1 degradation warning at the top of the manifest in place of the staleness caveat.

### Step 6 — New vs Established split

16. Within each tier, group entries:
    - git first-commit date on/after `(TODAY − cutoff days)` → **New**.
    - older → **Established**.

### Step 7 — Staleness guard + write manifest + echo

17. **Staleness guard** (skip if `VAULT_DEGRADED`): read `risk-topology.md`'s `last_updated` frontmatter value. Count the backbone candidates whose git first-commit date is **newer** than `last_updated`. These may be high-blast-radius but cannot be evidenced in § 1/§ 2, so they are Tier-1-demoted *by construction*. Emit a **mandatory caveat line** (manifest header + chat echo) naming the date, the count, and the affected commands. Omit the caveat only when the count is 0.

18. Overwrite `{AI_RESOURCES}/audits/backbone-manifest.md` with the structure below, and echo the same content to chat. Use markdown `[/command](.claude/commands/<name>.md)` links for each command line.

**Header `⚠` line — conditional, emit exactly one of these (or none):** if `N > 0`, emit the staleness caveat shown in the template. If `N = 0`, omit the `⚠` line entirely. If `VAULT_DEGRADED`, replace it with `> ⚠ vault docs unreachable — ranking on computed signals only`. The parenthetical guidance is **not** part of the output — do not print it into the manifest.

```
# Critical Resources — Operational Backbone Manifest
_Generated: {TODAY} · New = introduced on/after {TODAY − cutoff} (cutoff: {NN} days)_
> ⚠ Tier-1 source risk-topology.md last_updated {DATE} · {N} command(s) postdate it — Tier-1 completeness not guaranteed for: /x, /y

## Tier 1 — Critical (system-wide / multi-project blast radius)
### Established
- [/command](.claude/commands/command.md) — refs: {N} · since {YYYY-MM-DD} · why: {one line, sourced from risk-topology § / system-doc}
### New
- ...

## Tier 2 — High (session-spine / invoke-density)
### Established
- [/command](.claude/commands/command.md) — refs: {N} · since {YYYY-MM-DD} · why: {lifecycle role / invoke-density} {[computed-fresh] if applicable}
### New
- ...

## Excluded from backbone
- {N} commands did not meet the inclusion filter. (Run `/list-critical-resources full` to list them.)
```

For empty subsections, print `None.` underneath. End with one summary line:
`{C} Critical + {H} High backbone resources — {New} new, {Est} established.`

### Step 8 — `full` mode

19. If `full` is set, additionally:
    - Replace the `## Excluded from backbone` count with a full listing (one line per excluded command: name + invoke-density + git date).
    - Add a per-command **signal breakdown** under each backbone entry: invoke-density, git date, lifecycle role (if any), and which source (`§ 1` / `§ 2` / lifecycle / invoke-density-only) placed it in its tier.

### Step 9 — No review, no fixes, no other writes

20. The command writes only `audits/backbone-manifest.md`. It does not review, score quality, propose fixes, edit other resources, or commit anything. Identification ends here.

$ARGUMENTS
