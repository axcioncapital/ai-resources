# Session Plan — 2026-06-12

## Intent
Close mission promote-rw-canonical (Phase 4 deploy-test, /sync-workflow on positioning-research, checkbox cleanup, /mission close) and flip the now-unblocked improvement-log status entries, noting operator deprioritization of the tripwire-propagation entry.

## Model
sonnet (doing-dominant: defined procedures with bounded verification judgment) — active session model is full-capability; no switch needed.

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/promote-rw-canonical.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/sync-workflow.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-12-mission-promote-rw-canonical-landing-set.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/project-20260612-c4f1a/pack.md

## Findings / Items to Address
1. Mission Open-threads checkboxes are stale — Phases 0–3 landed (positioning-research commit 3f5723b "Phases 2-5 landed", ai-resources commits 3b23878/28afed3/6b7da8a/2c7ed1e) but all 6 boxes are unchecked (promote-rw-canonical.md L56–61).
2. Phase 4 deploy-test never ran — mission validation assertion L38 requires walking SETUP.md into a scratch project: working pipeline, /workflow-status passing, placeholders unfilled. No /deploy-test command exists; this is a manual walk (context pack, missing-context #2).
3. Phase 5 sync check never ran — assertion L39 requires /sync-workflow on positioning-research reporting in-sync or intentional divergence only. Note: positioning-research's split-log.sh was re-synced to pre-tripwire canonical (0917891) while ai-resources canonical now carries the S10 tripwire — an EXPECTED divergence (tripwire propagation deprioritized by operator); classify as intentional if flagged.
4. Improvement-log flips (5 entries): collector-hardening = "2026-06-10 — Harden session-feedback-collector to append-only" (~L415, shipped by S9 commit 0ee6177); Step 17b stale-close (~L360, closed stale by S9 — consult flag reverted 2026-06-10); classification-rule entry (S8 follow-up, ~L474); preamble L9 tier-2 convention (preamble + ~L480); S6 split-log tripwire entry (~L465, shipped by S10 commit 39c2ba5 — the L483 SHIPPED entry already states it resolves the S6 entry).
5. Tripwire-propagation entry (~L492): append operator deprioritization note (2026-06-12 S11) — do NOT execute the propagation.
6. Mission file edit rule: checkboxes + status route through /mission, never hand-edit from a working session (mission.md L12); /mission close sets status: completed and moves the file to logs/missions/archive/.

## Execution Sequence
1. Read SETUP.md + mission validation contract; create scratch project dir (outside repo or gitignored path); walk SETUP.md into it. Verify: pipeline files present, placeholders unfilled (grep for {{...}} shapes intact, no Nordic/Axcíon residue), /workflow-status-equivalent check passes. Delete scratch dir after.
2. Run /sync-workflow against projects/positioning-research (dry-run report). Verify: in-sync, or every divergence classified intentional (split-log.sh tripwire gap is pre-classified intentional per Finding 3). If unintentional divergence → STOP, surface to operator before closing.
3. Flip the 5 improvement-log entries (Edit per entry, exact-anchor matches; preserve entry bodies; status flips only + verified lines where the schema wants them). Append deprioritization note to the tripwire-propagation entry. Verify: grep each flipped status reads as intended; no other lines changed (conservation).
4. Update mission Open-threads checkboxes (Phases 0–3 → checked with landed-commit references; Phase 4/5 → checked after steps 1–2 pass) and tick the validation-contract assertions that steps 1–2 verify. Then /mission close promote-rw-canonical. Verify: frontmatter status: completed, file at logs/missions/archive/promote-rw-canonical.md, no copy left in logs/missions/.
5. /qc-pass on the session's edits (improvement-log flips + mission close record). Commit per workspace commit rules (explicit paths; concurrent sessions live).

## Scope Alternatives
- Min: improvement-log flips only (defer mission close if deploy-test surfaces problems).
- Recommended: full mandate — deploy-test + sync + flips + close.
- Max: also dispose the stranded claim-permission.template.md working-tree edit if the sync check touches it (it lives in the research-workflow template tree) — only if it blocks a clean sync verdict; otherwise leave for its own item.

## Autonomy Posture
Full autonomy

**Stop points:**
- Deploy-test fails (broken pipeline, pre-filled placeholders, project residue) → surface before any mission-close step.
- /sync-workflow reports divergence not classifiable as intentional → surface before closing.

## Risk
No structural change classes apparent — log status flips, a mission lifecycle close via its own command, and a throwaway scratch-dir walk are all bounded, non-structural operations. Run /risk-check if scope changes (e.g., if the deploy-test reveals a template defect requiring command/hook edits — that fix would be a new gated scope, not this session's).
