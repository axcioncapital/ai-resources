# Risk Check — 2026-05-22

## Change

New skill `skills/handoff/SKILL.md` and new command `.claude/commands/handoff.md` added. Existing command `save-session.md` replaced with redirect notice. One reference file updated (`operational-frontmatter.md` tier table). No hook changes, no settings changes, no CLAUDE.md changes.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/handoff/SKILL.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/handoff.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/save-session.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A rename-and-rehome of an on-demand command (no token cost, no permission change, fully reversible), but two operator-facing onboarding docs still point at the old `/save-session` name and are not in the stated change scope — a hidden-coupling gap that needs one explicit fix before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new artifacts are pay-as-used. Commands load only when the operator runs `/handoff`; skills load only when invoked or pattern-matched. The existing `save-session.md` is itself on-demand only — confirmed in a prior risk-check: "`save-session.md` is on-demand only — invoked by `/save-session`, no ongoing token cost" (`audits/risk-checks/2026-04-27-this-session-added-4-hooks-and-1-command-to-ai-resources.md:31`).
- Change explicitly states "No hook changes, no settings changes, no CLAUDE.md changes" — so no SessionStart/Stop/PreToolUse/UserPromptSubmit auto-load is introduced and nothing is added to always-loaded files.
- One residual cost: the new skill's `description` field contributes to the slash-command/skill description budget on every session (per `operational-frontmatter.md:96` — `/context` truncation warnings when the budget is exceeded). This is one skill's worth of description text, well within Low. The not-yet-present `SKILL.md` cannot be inspected; if its description uses broad trigger keywords ("save", "session", "checkpoint", "before clear") it could pattern-match more sessions than intended — evaluated from described intent only. Recommend keeping the description narrow with an explicit negative trigger.
- The `save-session.md` body shrinks from ~60 lines to a short redirect notice — a small net reduction in the on-demand command corpus, not an always-loaded saving.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change explicitly states "no settings changes." No `allow`/`ask` entry added, no `deny` rule removed or narrowed, no scope escalation between settings layers.
- A skill may declare `allowed-tools` in frontmatter (`operational-frontmatter.md:51`), but that field *restricts* tool access for the skill — it does not widen the repo permission surface. The not-yet-present `SKILL.md` cannot be inspected; the described change introduces no new tool family, no shell capability, no cross-repo or external write. The predecessor `save-session.md` performs only a single project-relative `Write` to `logs/scratchpads/` (`save-session.md:11`) and explicitly forbids git/bash discovery (`save-session.md:9`); a like-for-like `/handoff` stays inside that envelope. Evaluated from described intent for the not-yet-present files.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 4 — two new (`skills/handoff/SKILL.md`, `.claude/commands/handoff.md`), one rewritten (`.claude/commands/save-session.md`), one edited (`operational-frontmatter.md`).
- Live-caller enumeration. Grep across `.claude/commands`, `.claude/hooks`, `.claude/agents`, and all `skills/**/SKILL.md` for `save-session` returns exactly **one** hit: `skills/ai-resource-builder/references/operational-frontmatter.md` — the tier-table reference file the change already says it updates. No command, hook, agent, or SKILL.md invokes `/save-session` programmatically.
- `wrap-session.md` and `prime.md` checked specifically (grep for `save-session` and `scratchpad`): **zero** hits. The two commands that bracket the save/resume cycle do not call `/save-session` by name, so they are unaffected.
- Grep for `/handoff` (command-style invocation) across `.claude`, `skills`, `docs`: **zero** hits. Grep for a skill named exactly `handoff` (`^name: handoff` in any `SKILL.md`): **zero** hits, and `skills/handoff/` does not exist. No name collision; the new command and skill names are free.
- Remaining `save-session` mentions are all non-blocking historical text: audit reports, risk-checks, and `logs/session-notes-archive-*.md` — append-only history that does not need updating and is not a contract.
- One contract-style touchpoint: the `operational-frontmatter.md:14` tier table currently lists `save-session` as a `sonnet`/`medium` example. The change updates this table — a backwards-compatible edit (renaming an example entry), not a schema change. No caller parses that table.

### Dimension 4: Reversibility
**Risk:** Low

- All four touched files are version-controlled markdown in this working tree. `git revert` restores `save-session.md` to its full body, removes the two new files, and reverts the tier-table edit in one operation — no sibling-file or directory residue, because the new skill folder `skills/handoff/` is itself created by the change and would be removed by the revert.
- The change touches no data/log file (innovation-registry, improvement-log, session-notes), no `settings.json`, and pushes no state beyond the local repo. The redirect notice in `save-session.md` is plain text with no side effects.
- One soft, non-git residue: if the operator runs `/handoff` between landing and a revert, it writes a scratchpad to `logs/scratchpads/` (same target the old command used). That artifact is harmless and orthogonal — not a rollback blocker. Stays Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Operator-facing onboarding docs still point at the old name, and they are not in the stated change scope.** `docs/onboarding-daniel.md:167` — "Run `/save-session` before closing — it preserves current state so you can resume cleanly"; `docs/onboarding-daniel-cheatsheet.md:16` — table row "`/save-session` | Checkpoint mid-session state before a break or `/compact`". The change description lists only `operational-frontmatter.md` as the updated reference file. A new operator (the onboarding docs target a named onboardee, Daniel) would type `/save-session`, hit the redirect notice, and have to discover `/handoff` manually. The redirect notice in `save-session.md` mitigates this *if* the operator runs the command, but the docs themselves carry stale instruction.
- The redirect mechanism relies on the old `save-session.md` continuing to exist as a stub. If a future cleanup pass deletes the stub (commands with redirect-only bodies look like dead files), the redirect breaks silently and `/save-session` becomes an unknown command. The stub's load-bearing role is not self-documenting unless the notice explains why the file is retained.
- The not-yet-present `SKILL.md` and `handoff.md` cannot be inspected. Two coupling questions are evaluated from described intent only: (a) does the new skill's `description` overlap with `wrap-session`'s description such that Claude's skill selector confuses the two (`operational-frontmatter.md:99` — "Two skills with similar descriptions confuse Claude's selection")? `/save-session` (mid-session checkpoint) and `/wrap-session` (end-of-session ritual) are adjacent in purpose; renaming to `/handoff` may sharpen or blur that line depending on the description text. (b) Does `handoff.md` (the command) correctly delegate to `skills/handoff/SKILL.md`, or do the two duplicate logic? The command/skill split is a new internal contract; it must be documented at the change site (in the command file or SKILL.md), per the Medium calibration.
- No silent auto-firing: change adds no hook, so there is no hook-ordering or cross-session side-effect coupling. This keeps the dimension at Medium rather than High.

## Mitigations

- **Dimension 5 (onboarding docs):** In the same change set, update `docs/onboarding-daniel.md:167` and `docs/onboarding-daniel-cheatsheet.md:16` to reference `/handoff` instead of `/save-session`. These are the only two operator-facing surfaces that instruct on the old name; the redirect stub catches the live invocation but does not fix the documented instruction.
- **Dimension 5 (redirect-stub fragility):** Make the `save-session.md` redirect notice self-documenting — state explicitly that the file is intentionally retained as a compatibility redirect for `/handoff` and must not be deleted. This prevents a future cleanup pass from silently breaking the redirect.
- **Dimension 5 (skill-selection overlap):** When authoring `skills/handoff/SKILL.md`, give the `description` a narrow trigger and an explicit negative trigger distinguishing it from `/wrap-session` (e.g., "Use for mid-session checkpoints before `/clear` or `/compact`. Do NOT use for end-of-session wrap-up — that is `/wrap-session`."). Verify the command/skill split is documented at the change site (the new `handoff.md` should state that it delegates to `skills/handoff/SKILL.md`).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit not-yet-present flags). The two not-yet-present files (`skills/handoff/SKILL.md`, `.claude/commands/handoff.md`) were not read — their contribution to Dimensions 1, 2, and 5 is evaluated from the described intent in CHANGE_DESCRIPTION, noted explicitly under each affected dimension. No training-data fallback was used on fetch/read failures.
