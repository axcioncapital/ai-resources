# Friday Act Plan — 2026-07-03 — research-workflow

**Source report:** friday-checkup-2026-07-03.md (quarterly tier)
**Journal report:** (none)
**Generated:** 2026-07-03
**Items:** 1

## Items

### 1. [high] research-workflow: bring the 4 HIGH content-relays (W4-H1…H4) to the disk-write-and-return-path pattern
- **Source:** checkup
- **Risk-check required:** no (skill-body content edits — not a settings.json/hook/CLAUDE.md/new-command/symlink change per the canonical class list; flag for re-check at execution if the fix ends up touching a hook or shared automation)
- **W2.4 auto-draft:** no
- From token-audit Section 4 (W4-H1…H4): `evidence-to-report-writer` returns full chapter drafts through the main session; `execution-agent` returns verbatim GPT-5/Perplexity responses *and* separately writes them to disk (duplicated relay); large operand + reference-doc reads are relayed through main where the workflow's own carve-out already permits path-passing. Sibling stages (`run-synthesis`, `produce-prose-draft`) already do disk-write-and-return-path — these 4 are inconsistencies within one workflow, not a new pattern to invent. Full detail: `audits/token-audit-2026-07-03-ai-resources.md` § Section 4.
- **Recommended scope:** run as its own dedicated session (per the checkup's own framing) rather than folding into a general fix wave — this is a coherent, self-contained optimization pass across one workflow's stage definitions.

## Execution notes
- Commit separately.
- No risk-check flagged mechanically, but if the fix touches `execution-agent`'s underlying dispatch logic or any hook, re-run the change-class check before committing.
- Run `/wrap-session` when done (or when the dedicated session concludes).
