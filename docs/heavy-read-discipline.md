# Heavy-Read Discipline

> **When to read this file:** When a session is about to read an archive directory, an old report directory, or a superseded draft — and you want to confirm the read is load-bearing rather than habitual. Also when authoring a new audit-shaped command and deciding whether it should walk archives, or when editing one of `/prime`'s bounded-read recipes (Steps 1, 1c, 3 — see § Bounded-read recipes below).

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

## Bounded-read recipes in `/prime` — why they are shaped as they are

> **Rationale home only.** The **recipes themselves** — the greps, the offsets, the anchors, the filters — live in `.claude/commands/prime.md` Steps 1, 1c and 3, which is what executes them. This section holds only the reasoning and the incident history, so those steps stay short. Relocated from `prime.md` on 2026-07-29 (stream `2026-07-29-prime-minimum-responsibility`, Slice 4). **Never move a rule here:** a rule read from a doc either costs the tokens it was meant to save, or silently stops firing.

### Step 1 — why the last entry is located by grep, not by a line window

Several same-day entries (`S1`, `S2`, …) routinely stack in `logs/session-notes.md`, and a single entry can run 30+ lines, so any fixed "last N lines" window is unreliable — it either truncates the last entry or drags in two earlier ones. Locating the last date-header with one grep and reading from that offset to EOF captures the full entry in two calls regardless of length or how many sessions stacked that day.

The anchor is `^## [0-9]` rather than `^## `, and that matters: a `## Heading` inside an entry body or inside a fenced code block would otherwise false-match and truncate the read to a fragment. Anchoring on a leading digit means only a date header can match.

**The log-trio pre-fetch was retired 2026-07-30** (stream `2026-07-30-prime-session-entry-ownership`, S2). It came from token-audit R4, 2026-05-25: pre-fetching the `decisions.md` and `usage-log.md` tails at orientation was meant to have them in context for the eventual wrap, against a recurring Edit-before-Read failure on `session-notes.md`. But `/prime` did no reasoning over them, and a tail read many turns before its consumer is a bet on the context surviving that far — one `/clear` or one compaction and it has to be re-read anyway. The `usage-log.md` tail survives, moved **inside** the telemetry-gap nudge that is its only reader; the `decisions.md` tail is gone with no replacement. Restoring a speculative pre-fetch here needs a fresh measurement, not this paragraph.

### Step 1c — why plan position is never read with a plain `Read`

Plan files run long and grow monotonically. A full read here re-opens the exact cost class Step 3 exists to prevent (below), which is why the step greps for stage/phase headers and completion markers and reads only a bounded slice around the first incomplete one. **A future edit that "simplifies" this into a plain `Read` is a regression, not a simplification.**

The step deliberately checks `pipeline-state.md` *before* the plan spine, inverting the order of the cascade it derives from (`.claude/commands/project-next-steps.md` Step 2). The state file is small and authoritative, so it is the cheap happy path and short-circuits the expensive one. That inversion is intentional; do not "correct" it back.

The "headers but no completion markers" branch is not an edge case — it was verified on 2026-07-19 against a live 900-line project plan carrying `### Phase Vn` headers and no checkboxes at all. That is why the step anchors on the last header in that situation and says the position is inferred from plan structure rather than from an explicit marker, instead of widening the read to hunt for markers that do not exist.

### Step 3 — why the urgent scan counts instead of reading, and how its anchors got their shape

**The cost history.** `logs/friction-log.md` and `logs/improvement-log.md` are long (~400 and ~650 lines when this was fixed) and both grow monotonically. A full read of the pair cost **~50–60k tokens at every orientation in every project** — a defect named in five consecutive `usage-log` telemetry entries before it was fixed on 2026-07-13. It remains the single most expensive recurring leak the harness has had. A future edit that "simplifies" the three bounded scans back into a `Read` re-opens it.

**Why the `improvement-log` window is `-B6`.** The log is schema'd (`### {date} — {title}` / `- **Status:**` / `- **Severity:**`). The window is sized to carry each severity hit's **header and status lines** back with it, which is what lets the include/exclude filter apply without a second read. At `-B4` the header is lost on entries whose status runs to multiple lines.

**Two anchor widenings, and the one that must not happen.** The severity anchor began as `^- \*\*Severity:\*\*`. It was widened on 2026-07-18 to `^-? ?` to admit the **un-dashed** variant (`**Severity:** …`), which two live entries use, and again on 2026-07-19 with `\*{0,2}` to admit a **bolded value** (`- **Severity:** **high**`), which two more use. Both variants were being silently skipped. **Do not widen further to admit a delimiter before the value:** `logs/improvement-log.md:13` is the log's own schema block and reads ``- **Severity:** `low` | `medium` | … | `critical` ``. An anchor loose enough to match that vocabulary *declaration* injects a phantom urgent item into the task menu of every consumer. The backtick is what excludes it today; `\*{0,2}` matches zero asterisks and then fails on it. That exclusion is load-bearing and was verified by execution before the widening shipped.

**Why the third scan is a count and not a content read.** Entries carrying no `Severity` field cannot be reached by any severity anchor. The tempting fix is to widen the scan until it sees them; that is wrong, and it is why a backlog item asking for it was mis-scoped. An entry with no `Severity` field is not *hidden HIGH work* — it is **unclassified**, and dumping unclassified entries into the task menu would make the menu worse while multiplying the token cost the step exists to bound. So the scan reports the *number* in one line and stops: visible, bounded, honest. The operator learns the backlog has an unclassified tail without paying to read it. The real remedy is to give those entries a `Severity` field — log hygiene for `/friday-act` — not to loosen the scan.

**Why `friction-log.md` is scanned differently.** It has no severity field: its severity words are free text inside prose bullets, and its resolution stamps (`— **Resolved:**`, `[FADING-GATE] verified`) sit on the *same* line as the finding, which is why a same-line `grep -v` works there and would not work on the schema'd log. Its hits are candidates to judge, not findings — incidental matches are expected (a shell variable named `HIGH`, a quoted phrase) and are cheap to discard in-context, because only the matching lines come back.

**The `medium-high` near-miss (2026-07-24) — why the tier's menu-reach is a policy question.** Step 3's prose once read *"include only if it carries a HIGH-severity marker"* and *"exclude anything marked `LOW` or `MED`"*, naming `medium-high` in **neither** clause while the anchor matched it. That silence read as an anchor-vs-filter contradiction, and a change was proposed deleting `medium-high` from the anchor — a ~70% emit reduction — on the premise that the filter already discarded it. **It does not, and three other files say so explicitly:** `wrap-session.md` Step 12e (*"Only `high` and `medium-high` reach the `/prime` task menu"*), `.claude/agents/session-feedback-collector.md:138` (*"`high` / `medium-high` → reaches the `/prime` task menu"*), and `logs/improvement-log.md:13`, the log's own schema. The anchor was right; the prose was wrong, and was corrected rather than the anchor. the risk review returned RECONSIDER on the deletion — report at `audits/risk-checks/2026-07-24-narrow-prime-step3-severity-anchor-medium-high.md`. A large Step 3 emit is a signal that too many `medium-high` items are genuinely open; the remedy is backlog triage, not a quieter scan.

## Related canonical sources

- `docs/session-guardrails.md` — the `[HEAVY]` / `[COST]` guardrail definitions.
- `docs/audit-discipline.md` — the four named archive-reading commands and their cost envelopes (referenced indirectly via their command definitions).
- `docs/compaction-protocol.md` — when reads accumulate enough to risk compaction, the named-checkpoint rules apply.
- `ai-resources/CLAUDE.md` § Subagent Contracts — subagents write full notes to disk and return short summaries, reducing the main-session re-read cost for archive walks.
