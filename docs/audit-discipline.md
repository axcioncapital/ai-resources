# Applying Audit Recommendations

> **When to read this file:** Before applying a permission change or frontmatter change derived from an audit (`/token-audit`, `/repo-dd`, `/audit-repo`, `/audit-claude-md`, or similar); OR before landing a structural change in any of the classes listed under `Risk-check change classes` below. **Model-default changes (adding `"model"` to settings.json or a default-model line in CLAUDE.md) are prohibited — audit recommendations suggesting them must be rejected outright, not run through this discipline.** See workspace `CLAUDE.md` § Model Tier.

Audits produce recommendations based on static file counts, structural patterns, and reference-spec comparison. They do not model runtime command behavior. Recommendations are not specs — applying them verbatim can silently break live workflows.

Before applying a permission change (`permissions.allow` / `permissions.deny`) or frontmatter change derived from an audit:

1. List the top-3 commands most affected by the change (command names + the paths they routinely Read or invoke).
2. For each listed command, confirm that the planned change does not block or degrade its normal behavior. Evidence: inspect the command body, or run the command once in a smoke-test session if behavior is unclear.
3. If a conflict surfaces, narrow the change to preserve the command's behavior and note the narrowing in the commit message.

This is a bright-line rule — do not skip even when the audit tags a recommendation as "quick win" or "low risk." The friction of checking is low; the cost of silently breaking an active command is high.

## Source-of-truth: reconcile backlog candidates at read time

Backlog logs and dated audit reports go stale — an item is fixed (committed) but its log entry is never status-flipped, or a dated report freezes a finding a later commit resolves. **When a backlog/log/report candidate conflicts with live repo state (git log, filesystem), live state wins; logs are advisory.** Any issue-surfacing scan must reconcile its candidate list against live state before surfacing candidates as actionable. The canonical mechanism (merged multi-repo `git log --since=<anchor>` cross-check, conservative keyword-match, advisory demote-and-tag — never edit logs) is defined once in `backlog-reconciliation.md`; its consumers are `/prime`, `/fix-project-issues`, `/fix-repo-issues`, and `/open-items`. Edit the primitive there, not in each command.

## Absence-claims: the search instrument is not neutral

An audit's most common output is an absence-claim — *"nothing references X"*, *"no consumer exists"*, *"this hook is registered nowhere"*. Those claims are only as good as the instrument, and in a Claude Code session the instrument is shadowed.

**The fact.** The harness writes a shell snapshot that replaces `grep` with a bundled `ugrep -G --ignore-files --hidden -I --exclude-dir=.git`. `--ignore-files` honours `.gitignore`. Measured in `ai-resources` 2026-07-18: `grep -rl "Severity" .` → **122** files; `command grep -rl` → **194**. The 72-file gap is `audits/working/`, `logs/scratchpads/`, `inbox/archive/`, `/archive/`.

**Why that gap is the worst possible one.** `CLAUDE.md § Subagent Contracts` *requires* audit subagents to write their full findings into `audits/working/`. The repo's convention deposits its evidence in a directory its default search instrument cannot see.

**The scope is narrow — know it precisely, and do not over-correct.** Verified by execution 2026-07-18:

| Form | Blind? |
|---|---|
| `grep -r <term> .` or `./` | **YES** |
| `grep -r <term> <subdir>` | no |
| `grep -r <term> /abs/path` | no |
| `grep <term> <file>` (even a gitignored file) | no |
| any `grep` inside a script file (`.sh`) | no — the shadow is a shell function and does not cross a process boundary |

So the exposure is **not** in committed scan sites. Checked 2026-07-18: no site in `.claude/commands`, `.claude/agents`, `.claude/hooks` or `logs/scripts` uses the dot-rooted form. The exposure is in the **ad-hoc `grep -r <term> .` a session types while verifying something** — including the greps used to gather evidence for audits and mission threads. It is a property of how we *verify*, not of what we have *committed*. Do not "fix" immune sites; that is churn with no consequence.

**The rule.** Any claim of the form *"there is no X"* must be made with an instrument that can see everything, and must say which:

```
command grep -r <term> .   # everything, ignores .gitignore
git grep <term>            # tracked files only — honest, and states its own scope
```

**When in doubt, prove it.** `logs/scripts/search-canary.sh` plants a known-positive in a gitignored path and reports whether the ambient shell can find it. It **must be sourced, not executed** — an executed script is a child process where `grep` is already the real `grep`, so it would report "clear" in every session including blind ones:

```
. logs/scripts/search-canary.sh     # $SEARCH_CANARY = clear | blind | inconclusive
```

Advisory, not a gate — nothing blocks on `blind`. Reach for it when an absence-claim is load-bearing (a deletion, an orphan verdict, a consumer inventory), not on every scan.

**Origin:** mission `repo-health-backlog-2026-07` thread 11, 2026-07-18. The thread was filed as "every absence-claim in every past audit is unreliable"; execution narrowed it to the dot-rooted ad-hoc form and found zero committed sites affected. The narrowing is the finding — a blanket rewrite of every `grep` in the repo would have been the wrong fix.

## Risk-check change classes

If a session touches a structural change in any of the following classes, run `/risk-check` at two session boundaries (not per-change — see *When to fire* below):

- Hook edits (`.claude/hooks/*.sh`)
- Permission changes (`settings.json` `allow` / `ask` / `deny` edits)
- CLAUDE.md edits that are cross-cutting (workspace-level, project-level, or workflow-template always-loaded content that shapes every turn — workflow-template variant carries lower mitigation calibration than workspace-level; see `risk-topology.md § 1.2 — Deployable-template always-loaded`)
- New commands or skills
- New symlinks
- Automation with shared-state effects (scripts that auto-write to logs, cross-repo writes, auto-commit patterns) — INCLUDES reordering or restructuring of existing shared-state ops (e.g., changing when an archive step runs relative to a log append), not only new automation

**Class-boundary clarification — gitignored local settings (added 2026-07-03).** A gitignored, machine-local `settings.local.json` edit is **out-of-class** for the permission-change bullet above ONLY when BOTH hold: (a) the edit is a deletion or correction *mandated by an existing workspace rule* (e.g., removing a prohibited `"model"` field per workspace `CLAUDE.md` § Model Tier), AND (b) it has zero blast radius (untracked file, single machine, no consumer parses it). Such an edit proceeds without `/risk-check`, and the session must name this clarification in one line (chat + session note) when relying on it. Everything else in the class stays gated — tracked `settings.json`, any `allow`/`ask`/`deny` change, `defaultMode`/`additionalDirectories` edits, any addition. **No self-waivers:** outside this bounded shape, a session may never skip the gate on a listed class on its own materiality judgment — a one-line operator confirmation is required first, always. *(Origin: 2026-07-03 S2 silent self-waiver incident. Shaped as a class-boundary clarification per SO advisory 2026-07-03 — not a discretionary carve-out a session can self-apply. Consistent with workspace `CLAUDE.md` Autonomy Rule #9, which delegates class definitions to this section. Follow-up owed: sync the SO-vault `risk-topology.md` §3/§4 two-end contract in an SO session.)*

Inline `_*` comment keys in `settings.json` are rejected schema-side at session load — do not sanction them in risk-check reports. See `permission-template.md` § PreToolUse[Edit] decision-block pattern → Caveats for the canonical fallback (`.claude/PERMISSIONS-NOTES.md` sibling file).

For change classes outside this list, `/risk-check` is optional — operators can still invoke it when a change feels risky.

### When to fire (two-gate model)

- **Plan-time gate** — once, after the plan is approved, if the planned work touches any class above. The `$ARGUMENTS` payload describes the *design* (e.g., "edit hook X to add Y; allow Bash(rg:*) in workspace settings"). Catches design risk before tokens are spent on execution.
- **End-time gate** — once, before commit, batched across every in-class change the session actually made. The `$ARGUMENTS` payload describes the *executed* change set. Catches drift, emergent coupling, and scope creep that the plan-time gate didn't surface.

Sessions without an explicit plan (auto-mode quick fixes, single-file edits) skip the plan-time gate and run only the end-time gate. Sessions that touch no class skip both gates.

Each gate fires once per session. Mid-session re-invocation of `/risk-check` is operator-discretionary, not required by this rule. The point of the two-gate model is to avoid per-change firing — that pattern multiplied tokens without proportionate signal.

**Premise-verification precondition (both gates).** Before either gate dispatches its reviewer subagent, the invoking command runs a bounded pre-dispatch premise check on the payload: run every script it cites, open every line it cites, and re-derive every count (recording the primitive used), then correct any false claim in the payload *before* the subagent sees it. A gate that reasons from an unverified premise produces confident, expensive, wrong output — the ~360k-token miss of 2026-07-14 (`logs/improvement-log.md`). This is Problem Reality applied to the gate's **input**, symmetric with the Dimension-7 / premise checks the reviewers already apply to their **output**. Implemented in `risk-check.md` Step 2.6 and `consult.md` Step 3.6.

### Verdict semantics

- **GO** — proceed with the change as planned.
- **PROCEED-WITH-CAUTION** — proceed but apply the paired mitigations listed in the report before the change lands. Do NOT land the change without applying the mitigations. Note the mitigations in the commit message.
- **RECONSIDER** — redesign before proceeding. Re-invoke `/risk-check` after the redesign. Do NOT downgrade the verdict to push the change through.

### Invocation semantics

`/risk-check` is operator-invoked (manually typed slash command) or inline-invoked by other commands such as `/friday-act`. There is no auto-firing hook — this is a discipline enforced by this file, the workspace `CLAUDE.md` Autonomy Rules, and the commit review loop.

### Overlap with the top-3 analysis

An audit-derived permission change triggers BOTH requirements:

- the top-3-commands-affected analysis (above), AND
- `/risk-check` (this section).

These are complementary, not redundant: the top-3 analysis confirms the audit's recommendation does not break existing commands; `/risk-check` evaluates the broader risk posture (usage cost, permissions surface, blast radius, reversibility, hidden coupling) of the planned change as a whole.
