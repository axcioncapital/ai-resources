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

A change in any of the following classes is **high-consequence**: it takes the third row of `qc-independence.md` § The rule — one risk-aware Codex review before implementation, then the deterministic execution-time safeguards. The list is a **consequence test, not a trigger that fires a command**; no gate fires from it automatically.

- Hook edits (`.claude/hooks/*.sh`)
- Permission changes (`settings.json` `allow` / `ask` / `deny` edits)
- CLAUDE.md edits that are cross-cutting (workspace-level, project-level, or workflow-template always-loaded content that shapes every turn — workflow-template variant carries lower mitigation calibration than workspace-level; see `risk-topology.md § 1.2 — Deployable-template always-loaded`)
- New commands or skills
- New symlinks
- Automation with shared-state effects (scripts that auto-write to logs, cross-repo writes, auto-commit patterns) — INCLUDES reordering or restructuring of existing shared-state ops (e.g., changing when an archive step runs relative to a log append), not only new automation

**Class-boundary clarification — gitignored local settings (added 2026-07-03).** A gitignored, machine-local `settings.local.json` edit is **out-of-class** for the permission-change bullet above ONLY when BOTH hold: (a) the edit is a deletion or correction *mandated by an existing workspace rule* (e.g., removing a prohibited `"model"` field per workspace `CLAUDE.md` § Model Tier), AND (b) it has zero blast radius (untracked file, single machine, no consumer parses it). Such an edit proceeds without `/risk-check`, and the session must name this clarification in one line (chat + session note) when relying on it. Everything else in the class stays gated — tracked `settings.json`, any `allow`/`ask`/`deny` change, `defaultMode`/`additionalDirectories` edits, any addition. **No self-waivers:** outside this bounded shape, a session may never skip the gate on a listed class on its own materiality judgment — a one-line operator confirmation is required first, always. *(Origin: 2026-07-03 S2 silent self-waiver incident. Shaped as a class-boundary clarification per SO advisory 2026-07-03 — not a discretionary carve-out a session can self-apply. Consistent with workspace `CLAUDE.md` Autonomy Rule #9, which delegates class definitions to this section. Follow-up owed: sync the SO-vault `risk-topology.md` §3/§4 two-end contract in an SO session.)*

Inline `_*` comment keys in `settings.json` are rejected schema-side at session load — do not sanction them in risk-check reports. See `permission-template.md` § PreToolUse[Edit] decision-block pattern → Caveats for the canonical fallback (`.claude/PERMISSIONS-NOTES.md` sibling file).

A change outside this list is sized on its own consequence by the same rule. The list names what is *always* high-consequence; it does not cap the row.

### Invocation semantics

`/risk-check` is **operator-invoked only** — a manually typed slash command. No command, hook or policy fires it automatically, and there is no plan-time or end-time gate. A class match above means the change takes the risk-aware review row of `qc-independence.md` § The rule; it does not mean a command runs.

> **In transition (2026-07-29).** This states the policy, which is now authoritative. Callers that still invoke a review automatically are being removed slice by slice — `/prime` and `/session-plan` are excluded from that work and keep firing until their own follow-up lands. Where a caller still fires, the caller is stale, not this rule.

Where that review surfaces a decision the operator must take, it is surfaced as a decision, not as a verdict token. Apply what the review found before the change lands, and say plainly when a material finding is left unresolved (`qc-independence.md` § Findings).

### Overlap with the top-3 analysis

An audit-derived permission change is in-class above, so it takes the risk-aware review row **and** the top-3-commands-affected analysis (above).

These are complementary, not redundant: the top-3 analysis is a mechanical check that the audit's recommendation does not break existing commands; the risk-aware review judges the broader posture (usage cost, permissions surface, blast radius, reversibility, hidden coupling) of the change as a whole. The mechanical check runs first — it is cheaper, and its result is an input to the review.

## Subagent Proportionality

> **When to read this section:** when deciding whether a change needs a dispatched subagent (QC-pass, extra reviewer, red-team) or whether inline verification suffices — and when a mandatory gate above has fired on a change that does not warrant its full ceremony.

Default to **inline verification** — targeted grep/read, read-back, self-check against the rubric. Reserve dispatched subagents (QC-pass, extra reviewers, red-team) for changes that are genuinely architectural, high-risk, high-blast-radius, or need independent judgment. This does **not** waive QC: it picks the lightest form that actually verifies the change — inline self-check for light edits (per the `qc-independence.md` skip conditions), a dispatched independent pass for substantive or uncertain artifacts.

- **Do not stack gates.** A change already cleared by the gates it needs — `/blindspot-scan`, `/risk-check`, operator sign-off on the *exact* diffs, an inline re-grep — does not also get an independent QC-pass subagent on top. Gate ceremony scales with the task's real risk, not by default.
- **Keep a mandatory gate proportionate.** When a required gate (e.g. one of the `/risk-check` change classes above) fires on a light change, run the lightest form that satisfies it. Before dispatching a *heavy* subagent, state in one line why the main session cannot do the check inline.
- **Do not over-correct into banning subagents.** They remain the right tool for real architecture, protected doctrine, and high-blast-radius work. The failure mode is overuse, not existence.

This doctrine governs **gate ceremony**, which is why it lives here beside the change classes rather than in `qc-independence.md`: "do not stack gates" ranges over `/blindspot-scan` and every other control, not only review. For how the independent review itself works — which changes get one, context isolation, the risk-aware brief, the unreachable-reviewer fallback — see `qc-independence.md`.

*(Moved here from the workspace-root `CLAUDE.md` on 2026-07-27, migration Stage 5 §6.2. The plan deliberately left the destination open between this file and `qc-independence.md`; decided here because the operative rules are about gate proportionality, not QC mechanics.)*
