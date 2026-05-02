# Claude Code Improvement Plan — 2026-05-01

Source: external suggestion document evaluated against current stack.

---

## Already in place — skip

Eight of the suggestion document's patterns you already operate (loop discipline, subagents, skills over CLAUDE.md stuffing, advisor pattern, thinking tokens, 1M context, compact discipline, bypass + hooks) — skipping all.

---

## High ROI — Do now

**1. Add `DISABLE_NON_ESSENTIAL_MODEL_CALLS=1` to global settings** `[NEEDS VERIFICATION: env var name unconfirmed — test by adding and observing one session]`

Not set anywhere in your stack. This kills background inference calls Claude Code makes between your turns (e.g., auto-suggestions, background context summarization). Zero change to output quality. 5-minute add to `~/.claude/settings.json` env block alongside your existing `DISABLE_AUTOUPDATER=1`.

Add only the new key to the existing `env` block in `~/.claude/settings.json` — do not replace the other two keys already there (`DISABLE_AUTOUPDATER` and `MAX_THINKING_TOKENS`). Resulting block:

```json
"env": {
  "DISABLE_AUTOUPDATER": "1",
  "MAX_THINKING_TOKENS": "20000",
  "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1"
}
```

Note: `settings.json` accepts any string in the env block — if the var name is wrong or unsupported, the file still saves and Claude won't warn you. The verification step below is the only confirmation it took effect.

After adding, run one normal session and confirm autocomplete/inline suggestions still behave as expected before relying on the change.

---

**2. MCP server audit — cull from 16 to ≤10**

You have 16 MCP servers configured. The guideline (per the source document) is ≤10 per project — each one loads its full tool-definition schema into your context window on every turn, whether you use it or not. The following 16 were verified in your actual MCP plugin config at `~/.claude/plugins/marketplaces/claude-plugins-official/external_plugins/`: asana, context7, discord, fakechat, firebase, github, gitlab, greptile, imessage, laravel-boost, linear, playwright, serena, supabase, telegram, terraform.

Most of these appear inactive for your Axcion workflow. Which do you actually use in sessions? Disabling unused ones recovers context on every turn permanently.

Action: nominate which to keep; I'll confirm the exact disable mechanism before touching anything. `[NEEDS VERIFICATION: how to disable individual plugins — the server list above is confirmed from your actual config, but whether to use the /plugins command or edit the plugin directory directly needs verification before acting.]`

---

## Medium ROI — Worth doing, not urgent

**3. Align MAX_THINKING_TOKENS globally**

Your global `~/.claude/settings.json` has MAX_THINKING_TOKENS=20,000. Your ai-resources `settings.json` has 10,000. The workspace root `settings.json` has no env block, so workspace-root sessions currently inherit the user-global 20,000.

**Confirm intent first:** this fix assumes you want workspace-root sessions capped at 10,000 to match ai-resources. If you're fine with 20,000 there, skip this item.

If you want to align: open workspace root `.claude/settings.json` and add a comma after the closing `}` of the `permissions` block, then append the `env` key before the final `}`:

```json
"env": {
  "MAX_THINKING_TOKENS": "10000"
}
```

Leave `model` and `permissions` exactly as they are — only the `env` key is new.

---

## Skip — not applicable or unverified

- **Headless mode / cron triggers** — Workflow is interactive. Not a current friction point.
- **Shifts model (claude-progress.txt artifact)** — Already covered by session-notes.md + /prime + /save-session system.
- **CLAUDE_CODE_SUBAGENT_MODEL=haiku** — Agents already declare model: explicitly in frontmatter. This env var only affects agents without a declared model, which should be zero per CLAUDE.md rules.
- **Skill portability across Claude/Codex/Cursor/Gemini** — The "open standard" claim is aspirational/marketing. SKILL.md format is not currently portable across tools. Not actionable.
- **cc-stack.md tracker** — innovation-registry.md and friday-checkup cadence already serve this function.
- **"82% token improvement" / "15,000 tokens recovered"** — External blog figures from an unknown baseline. Treat as directional, not literal.

---

## Summary

| Item | Effort | Ready? |
|---|---|---|
| DISABLE_NON_ESSENTIAL_MODEL_CALLS=1 | 5 min | Verify first, then execute |
| MCP server audit + cull | 15 min execution (after you nominate which to keep) | Needs your nominations |
| MAX_THINKING_TOKENS global alignment | 5 min | Yes — execute now |
