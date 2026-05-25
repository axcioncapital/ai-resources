# Session Plan — 2026-05-25

## Intent
Apply quick-win batch QW1–QW5 from the 2026-05-25 token-audit sweep (4 settings.json + 1 CLAUDE.md edits), then run `/improve` on this morning's logged friction.

## Class
execution

## Model
sonnet — → /model sonnet (active is opus; downgrade for mechanical settings.json + CLAUDE.md edits)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-ai-resources.md` — QW1, QW2 source
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-project-ai-development-lab.md` — QW1, QW4 source
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-project-axcion-ai-system-owner.md` — QW3, QW4 source
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-project-obsidian-pe-kb.md` — QW2, QW4, QW5 source
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change class reference (settings.json permission edits)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical permission shape across layers (deny rules, hook block format)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — edit target (QW1, QW2)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/settings.json` — edit target (QW1, QW4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/settings.json` — edit target (QW1, QW4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/settings.json` — edit target (QW1, QW2, QW4, QW5)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/CLAUDE.md` — edit target (QW3)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — `/improve` input (09:07 entry about `/token-audit` scope-selection UX)

## Findings / Items to Address
1. **QW1 — Read() deny gaps** (4 settings.json). All 4 audited scopes have gaps in `permissions.deny` for full-file `Read()` calls. Source: ai-resources audit R4 (log-trio pre-fetch); ai-development-lab audit R1; axcion-ai-system-owner audit R1 family; obsidian-pe-kb audit R1.
2. **QW2 — archive-pattern Read() deny bug** (2 scopes). Same infix-vs-suffix glob pattern miss fires in two different scopes. Source: ai-resources audit R2 line 369 (`Read(logs/*archive*.md)` pattern miss); obsidian-pe-kb audit R1 lines 208–209 (`logs/session-notes-archive-2026-04.md` not caught by `Read(**/*.archive.*)`).
3. **QW3 — plan-mode incompatibility note**. Add a note to `projects/axcion-ai-system-owner/CLAUDE.md` documenting the plan-mode incident pattern. Source: axcion-ai-system-owner audit line 319 (Section 5.1 / R2).
4. **QW4 — `MAX_THINKING_TOKENS` consistency** (3 project settings.json). Env var unset in 3 project scopes; ai-resources already has it. Source: ai-development-lab audit 5.1 / R10; axcion-ai-system-owner audit 5.2 / R9; obsidian-pe-kb audit R6. ai-resources reference: its own audit line 143.
5. **QW5 — register existing SessionStart hook**. Add the `check-permission-sanity.sh` SessionStart hook block to `projects/obsidian-pe-kb/.claude/settings.json` — hook file already exists at ai-resources level; only settings.json registration needed. Source: obsidian-pe-kb audit Section 5.1 / R3 (line 109).
6. **`/improve` carryover** — process this morning's friction-log entry (09:07): `/token-audit` scope-selection required 3 rounds of `AskUserQuestion`; desired UX is to list all projects numbered upfront. Source: `logs/friction-log.md` 09:07 entry; prior-wrap Next Steps explicitly authorizes this.

## Execution Sequence
1. **Switch model to sonnet** (`/model sonnet`) — mechanical work, downgrade before edits.
2. **QW1 — Read() deny rules** across the 4 settings.json files. Verify: each settings.json passes `python -m json.tool` syntax check; new deny entries cover the audit-named patterns.
3. **QW2 — archive-pattern deny fix** in `ai-resources/.claude/settings.json` AND `projects/obsidian-pe-kb/.claude/settings.json`. Verify: pattern matches both audit-named test cases (`logs/session-notes-archive-2026-04.md` AND `logs/*archive*.md`); cross-check pattern syntax against `permission-template.md`.
4. **QW3 — plan-mode note** in `projects/axcion-ai-system-owner/CLAUDE.md`. Verify: note added per audit guidance; file remains coherent (no duplicate sections).
5. **QW4 — `MAX_THINKING_TOKENS` env var** in 3 project settings.json (ai-development-lab, axcion-ai-system-owner, obsidian-pe-kb). Verify: env block present and value matches ai-resources baseline.
6. **QW5 — SessionStart hook registration** in `projects/obsidian-pe-kb/.claude/settings.json`. Verify: hook block matches the format used in sibling project settings.json files (per `permission-template.md`).
7. **Stop point — run `/risk-check`** on the bundled settings.json + CLAUDE.md edits before commit (plan-time risk gate per audit-discipline.md).
8. **Commit batch** — single batched commit titled `batch: token-audit quick-wins — QW1-QW5 from 2026-05-25 sweep`. Per workspace CLAUDE.md commit rules: commit directly, do not run pre/post-commit `git status`/`diff` checks.
9. **Stop point — review `/improve` scope** before invoking. Confirm the 09:07 friction entry is the only target; reject scope creep into other friction items.
10. **Run `/improve`** on this morning's friction. Verify: improvement-log entry created or updated; output addresses the named friction.
11. **Mark friction-log entry actioned** with status update (`resolved` / `applied` / `verified` per the convention).
12. **End-time `/risk-check` decision** — skip per the saved end-time skip rule IF plan-time covered with mitigations applied AND commits already shipped AND drift bounded; otherwise run.
13. **Wrap notification** — remind operator to push (12 unpushed commits total: 10 in ai-resources + 2 in workspace) and to run `/wrap-session`.

## Scope Alternatives
- **Min:** QW1 only (close the highest-risk Read() deny gaps in 4 settings.json) — ~15 min.
- **Recommended:** QW1–QW5 + `/improve` (the confirmed mandate) — ~1–1.5 hours.
- **Max:** Add SF1 (main↔subagent file-read duplication across 6 workflows) — **NOT recommended**, explicitly out of scope per mandate; deserves its own session with full session-plan and risk-check.

## Autonomy Posture
**Gated.**

**Stop points:**
- Before commit (Step 7): run `/risk-check` on the bundled settings.json + CLAUDE.md edits — plan-time risk gate.
- Before `/improve` invocation (Step 9): confirm friction target is bounded to the 09:07 entry only.
- If QW2 archive-pattern syntax must differ across the two scopes (per mandate's Stop If): pause for design call.
- If any settings.json edit triggers `/permission-sweep` failure: pause for diagnosis.

## Risk
Settings.json permission-edit class + CLAUDE.md edit class are both structural change classes per `audit-discipline.md`. Run `/risk-check` after the plan is approved (plan-time gate, before commit). Run it again before commit (end-time gate) UNLESS the saved end-time skip rule applies (plan-time covered with mitigations applied AND commits already shipped AND drift bounded).
