# Heavy-Read Discipline

> **When to read this file:** When a session is about to read an archive directory, an old report directory, or a superseded draft — and you want to confirm the read is load-bearing rather than habitual. Also when authoring a new audit-shaped command and deciding whether it should walk archives.

> **What this file is not:** Not a permission deny rule, not a `read_budget` mandate field. Both were evaluated and rejected by the system-owner advisory (Function B, 2026-05-25) — permission denies conflict with OP-2 and AP-7 and have blast radius across the four named commands below; a `read_budget` field duplicates the `[HEAVY]` guardrail, expands the mandate parse contract, and binds at mandate-time against an uncalibrated number. This is documentation-only guidance.

---

## The discipline in one line

Default to NOT reading archive, superseded, or historical material. Read it only when a specific downstream claim depends on content that lives there and cannot be obtained elsewhere.

This applies to **every** session except the four named commands below, which legitimately walk historical material as part of their job.

---

## Commands that legitimately read archives and historical directories

Four canonical commands carry an archive-read mandate as part of their function. They are exempted from the discipline above because their value is in the historical sweep itself.

| Command | What it reads | Why |
|---|---|---|
| `/log-sweep` | All `logs/` files across selected scopes, plus `*-archive-*.md` files when a Cat B rotation is in flight | Job is to inventory log files and decide which exceed thresholds; archives must be read to confirm the rotation guard correctness. |
| `/wrap-session` | `logs/coaching-data.md` (tail), `logs/improvement-log.md` (full), `logs/innovation-registry.md` (full) | Coaching capture, improvement verification, and innovation triage each require a full-file view of their respective log. |
| `/repo-dd` | `audits/repo-due-diligence-*.md` (prior dated reports), `logs/` files across the audited scope | Due diligence compares current state against prior baselines; prior reports are the baseline. |
| `/friday-checkup` | `audits/friday-checkup-*.md` (prior dated reports), `logs/decisions.md`, `logs/friction-log.md`, `logs/improvement-log.md` | Weekly cadence compares against prior weekly state and reviews logged activity since the last checkup. |

For these four, archive reads are **expected, load-bearing, and budgeted into the command's cost envelope**. Don't apply the default-skip rule here.

---

## What the default read floor looks like for normal sessions

For every other session, the default behavior is:

- Read the file the operator named (`@path` references, files in the active task).
- Read the canonical commands/agents/skills the active task invokes.
- Read the project's `CLAUDE.md` files (always-loaded; the harness does this for you).
- Read `logs/session-notes.md` if `/prime` ran (for orientation context).

**Do not, by default:**

- Read `*-archive-*.md` files (e.g., `session-notes-archive-2026-05.md`, `coaching-data-archive-2026-04.md`).
- Read prior dated audit reports (`audits/<type>-YYYY-MM-DD.md`) from sessions that already concluded.
- Read superseded drafts (e.g., `session-plan-${YYYY-MM-DD}-${MARKER}-pass2.md`) when the active `session-plan-${YYYY-MM-DD}-${MARKER}.md` (date + marker-scoped per `docs/session-marker.md`) is the live document.
- Read `logs/scratchpads/` files from prior sessions (the latest one is surfaced by `/prime` Step 1b as a carryover signal; reading older ones is rarely useful).
- Walk `audits/working/` (gitignored, subagent-only working notes — main-session reads almost never warrant this).

This is the read floor — the minimum a normal session reads. Going below this floor is fine; going above it should be justified by a specific downstream claim.

---

## When to legitimately exceed the floor

The default-skip rule is overridden in three concrete cases:

1. **A specific downstream claim requires content only present in the older file.** Example: an audit observation references a prior decision logged in `decisions-archive-2026-04.md`; the current session needs the rationale verbatim. Read the specific archive file, not the entire archive directory.

2. **An invariant check spans history.** Example: a regression-recovery session needs to confirm that a specific config value was unchanged across the last N sessions. Read the relevant entries — bounded by the invariant's actual scope, not "all prior sessions."

3. **The `[HEAVY]` guardrail fires and the operator confirms scope expansion.** `[HEAVY]` is the existing session guardrail for pre-heavy-tool-call/pre-delegation events (per `docs/session-guardrails.md`). When it fires for an archive walk, the operator can explicitly authorize the scope expansion — at which point the discipline is operator-approved, not violated.

In all three cases, the rule is **read by specific reference**, not by directory walk.

---

## Cost framing — why this matters

Sessions on Sonnet 4.6 with the 1M context still benefit from input-discipline:

- Cached input tokens are cheap, but the cache window is 5 minutes and unused content evicts (`docs/prompt-cache.md` if/when it exists; otherwise see Anthropic's prompt-caching docs). Reading something the session will not act on wastes the cache hit it would have gotten from the actually-needed content.
- Long-context retrieval quality degrades when relevant content sits next to large volumes of unrelated content (lost-in-the-middle effect). The session-quality cost of an unjustified archive walk is real even when the token cost is bounded.
- Subagent invocations multiply the read cost — every additional file a subagent reads expands its context, slows its response, and grows the summary the main session must process.

The four named commands above pay this cost because their value is in the sweep itself. Normal sessions don't get the equivalent value from speculative reads.

---

## Tie to `[HEAVY]`

`[HEAVY]` (per `docs/session-guardrails.md`) is the existing pre-heavy-tool-call advisory flag. The discipline in this file complements it:

- `[HEAVY]` fires **at the moment** of a heavy read, asking the session to confirm scope.
- This discipline says **before the moment** — default-skip archive reads so `[HEAVY]` rarely needs to fire on them in the first place.

If `[HEAVY]` is firing frequently on archive reads in normal sessions, that is a signal the discipline is not being applied — investigate the session's read pattern.

---

## What this discipline does NOT say

It does not say:

- "Never read prior session notes." (Reading the most recent `session-notes.md` entries is fine and expected.)
- "Never read audit reports." (Reading the most recent audit when its findings are the active task is fine.)
- "Block reads via permission denies." (Rejected — operator must always be able to override; permission denies have outsized blast radius on the four named commands.)
- "Add a mandate field for `read_budget`." (Rejected — duplicates `[HEAVY]`, expands parse contract.)

It says: when reading archive/historical material, ask whether a specific downstream claim depends on it. If not, skip by default.

---

## Related canonical sources

- `docs/session-guardrails.md` — the `[HEAVY]` / `[COST]` guardrail definitions.
- `docs/audit-discipline.md` — the four named archive-reading commands and their cost envelopes (referenced indirectly via their command definitions).
- `docs/compaction-protocol.md` — when reads accumulate enough to risk compaction, the named-checkpoint rules apply.
- `ai-resources/CLAUDE.md` § Subagent Contracts — subagents write full notes to disk and return short summaries, reducing the main-session re-read cost for archive walks.
