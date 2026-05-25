# Risk Check — 2026-05-25

## Change

QW1-QW5 batch edits from 2026-05-25 token-audit sweep:
- QW1: Added Read() deny rules to 4 settings.json files (ai-resources + 3 projects) — granular patterns for frozen pipeline artifacts and historical audit reports
- QW2: Added "Read(logs/*archive*.md)" to ai-resources and obsidian-pe-kb settings.json — fixes infix/suffix glob pattern miss in archive-file deny rules
- QW3: Added "Plan-Mode Constraints" section to projects/axcion-ai-system-owner/CLAUDE.md — documents the plan-mode + disk-write incompatibility pattern (5-line note, no rule changes)
- QW4: Added "env": {"MAX_THINKING_TOKENS": "10000"} to 3 project settings.json files (ai-development-lab, axcion-ai-system-owner, obsidian-pe-kb) — consistency with ai-resources baseline
- QW5: Added check-permission-sanity.sh SessionStart hook block to projects/obsidian-pe-kb/.claude/settings.json — hook already exists at ai-resources level, this only registers it

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/CLAUDE.md — exists

## Verdict

GO

**Summary:** All five QW edits are narrowing/tightening operations (added deny rules, added a documentation section, env-var consistency, registration of an existing shared hook) — no widening, no new contracts, fully reversible via git.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- QW1/QW2 add ~3-10 Read() deny entries per settings.json — settings.json is parsed by Claude Code at session start but is not part of the prompt token stream; no per-turn token cost. Evidence: ai-resources/.claude/settings.json lines 24-37 list 13 deny entries; this content does not appear in the system prompt.
- QW3 adds a 7-line "Plan-Mode Constraints" section to projects/axcion-ai-system-owner/CLAUDE.md (lines 55-61, ~75 tokens). This loads on every session opened inside axcion-ai-system-owner — bounded scope (one project), justified by the documented 100K-token regeneration cost referenced in the section itself (line 61).
- QW4 adds a 3-line `env` block (~5 tokens of JSON, zero runtime token impact — env vars do not consume context).
- QW5 registers an existing SessionStart hook (lines 66-75 of obsidian settings.json). The hook executable runs once per session and emits chat-line output only when drift is detected — no always-on token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- QW1/QW2 add **deny** rules only — these narrow the surface, never widen. Evidence: each affected settings.json shows the new entries inside the `deny` array (e.g., ai-resources/.claude/settings.json line 36 `"Read(logs/*archive*.md)"` inside deny block lines 24-37).
- QW3/QW4 do not touch the permissions block.
- QW5 registers a hook that calls a script already present at `ai-resources/.claude/hooks/check-permission-sanity.sh` (confirmed via ls). No new capability is granted — the script could already be invoked manually; registration just automates the call at SessionStart. The script is a permission-drift detector, i.e., its purpose is to tighten not widen.

### Dimension 3: Blast Radius
**Risk:** Low

- QW1: 4 files touched, all isolated settings.json. No callers depend on the deny list shape — `/permission-sweep` reads but does not require specific patterns (grep showed `/permission-sweep` references in docs/permission-template.md, not coupled to specific deny entries).
- QW2: 2 files touched (ai-resources, obsidian-pe-kb). Pattern `Read(logs/*archive*.md)` coexists with `Read(logs/*-archive-*.md)` already present in 6 other settings.json files (grep result: ai-resources, research-workflow, buy-side-service-plan, axcion-ai-system-owner, obsidian-pe-kb, nordic-pe-macro) — no contract change, the new pattern is broader-matching for files that don't conform to the hyphenated naming.
- QW3: 1 file touched (axcion-ai-system-owner/CLAUDE.md). Affects only sessions opened inside that project. No commands or agents read this CLAUDE.md programmatically (CLAUDE.md loading is the session-start mechanism only).
- QW4: 3 files touched. `MAX_THINKING_TOKENS` is already set in workspace root settings.json and ai-resources settings.json (grep confirmed 5 files total now including these 3); this brings the 3 projects into baseline conformity.
- QW5: 1 file touched. The registered hook matches the canonical shape in `docs/permission-template.md` lines 260-269 verbatim (upward-walk idiom).

### Dimension 4: Reversibility
**Risk:** Low

- All five QWs are pure file edits — no state pushed beyond local repo, no external writes, no log mutations.
- `git revert` cleanly restores prior file contents for all 5 settings.json + 1 CLAUDE.md.
- QW5's hook would stop firing immediately on revert (next SessionStart re-reads settings.json).
- No append-only logs touched; no operator muscle-memory dependencies introduced (deny rules and env vars are invisible to the operator).

### Dimension 5: Hidden Coupling
**Risk:** Low

- QW1 deny patterns target concrete file paths that the operator has confirmed are frozen pipeline artifacts or historical audit reports — no implicit dependency on file naming conventions changing.
- QW2 uses an additive infix-glob pattern alongside the existing suffix pattern — both can coexist; no caller assumes only one form exists.
- QW3 documents an existing constraint (the plan-mode + disk-write incompatibility observed 2026-05-20 per line 61 of axcion-ai-system-owner/CLAUDE.md). Adding documentation does not introduce coupling; it makes existing coupling visible.
- QW4 sets an env var already established as baseline in 2 of 5 layers (workspace root + ai-resources). Bringing 3 more layers into conformity reduces variance, not introduces it.
- QW5 hook script is a shared resource already invoked from 4+ other project settings.json files (grep result). The upward-walk idiom is documented in `docs/permission-template.md` lines 247-271. No new contract.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from the 5 referenced files, grep counts for cross-project pattern usage (`Read(logs/*archive*.md)`, `check-permission-sanity`, `MAX_THINKING_TOKENS`), and verbatim quotes from `docs/permission-template.md` canonical shapes. No training-data fallback was used.
