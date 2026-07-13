# Session Plan — 2026-07-13

## Intent
Replace `/prime` Step 3's two full-file Reads of `logs/friction-log.md` and `logs/improvement-log.md` with a bounded grep-for-open-status + `tail`, matching how `logs/decisions.md` is already handled two lines away in the same step.

## Model
opus — match (active session is Opus 4.8).

The tier is *deciding*, not *doing*, despite the small diff. Step 3's job is to surface **unresolved HIGH/urgent** items; the full Read lets the model apply that filter in-context. A bounded scan must reproduce the same filter mechanically — include HIGH/urgent, exclude LOW/MED, exclude `resolved`/`applied`/`verified`. A careless grep silently *under-surfaces* urgent items, which is a worse failure than the token cost being fixed. Getting the filter semantics right is the hard part.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — Step 3 (the sole edit target; 665 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the 2026-07-13 HIGH entry to close; also the scan target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — the other scan target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — § Risk-check change classes (read; see Risk below)

## Findings / Items to Address

1. **The defect** (`logs/improvement-log.md`, 2026-07-13, "`/prime` Step 3 full-reads … five telemetry entries, zero action", Severity: high, Status: OPEN). Step 3 issues a full `Read` of `friction-log.md` (~412 L) and `improvement-log.md` (~643 L) at every orientation to find unresolved HIGH/urgent items. On 2026-07-13 S6 this produced a **225 KB persisted-output dump**. Named in five consecutive telemetry entries; actioned zero times. Est. saving ~50–60k tokens per session, across every session in 24 checkouts.

2. **The correct pattern already exists two lines away.** In the same Step 3 block, `logs/decisions.md` is read as a bounded `tail -n 10`. The fix is to bring the two other logs onto that footing — grep for open-status markers, plus a bounded tail — not to invent a new mechanism.

3. **Reproduced live this session.** `/prime` Step 3 fired the full Read at this session's own orientation; both files blew past the 25k-token read cap and had to be re-issued as targeted greps. This session therefore holds **ground truth** for what the correct Step-3 output is (see Execution step 3) — an unusually strong validation input that will not exist in a later session.

4. **Fork enumeration — resolved, not a blocker (mandate stop-if condition).** `find . -name prime.md -type f` returns **5** real files, not the 3 the improvement-log entry predicted. The two unexpected ones live under `ai-resources-research-workflow/`, which is a **git worktree of this same repo** (shared `.git`, branch `session/2026-07-13-research-workflow`, same commit `9992b06`, `prime.md` byte-identical). It is the same tracked file on another branch, not an independent fork — canonical stays the single edit target and the branch inherits on merge. The other 2 real files are 33-line stubs with no Step 3. **The improvement-log entry's "3 real files" claim was written before this worktree existed and should be corrected when the entry is closed.**

5. **A live concurrent session is running in that worktree.** It shares this repo's history but has its own working tree. If it also edits `prime.md`, the two branches conflict at merge — ordinary git, but worth knowing before editing.

## Execution Sequence

1. **Read Step 3 in full** (`prime.md`) and the surrounding `decisions.md` handling, so the replacement matches the existing bounded idiom exactly rather than inventing one.
   *Verify:* the exact current wording of Step 3's read instructions and its HIGH/urgent filter is quoted before any edit is drafted.

2. **Check the worktree isn't mid-edit on `prime.md`** — `git -C ../ai-resources-research-workflow status --short -- .claude/commands/prime.md`.
   *Verify:* clean → proceed. Dirty → surface to the operator before editing (lost-update risk).

3. **Draft the bounded scan and validate it against this session's ground truth.** Execute the candidate grep/tail against the two real logs and compare its output to what the full read surfaced at this session's own orientation.
   *Verify:* the bounded scan surfaces the same set of unresolved HIGH/urgent items as the full read did — specifically the two known HIGH entries (the Step-3 entry itself; the declined `~/.claude/settings.json` model-field entry, which must be **excluded** as operator-DECLINED). Falsifiability check: confirm the scan does *not* return LOW/MED or `resolved`/`applied`/`verified` items. If the bounded scan misses anything the full read caught, the pattern is wrong — fix the pattern, do not weaken the check.

4. **Apply the edit to canonical `prime.md` Step 3 only.**
   *Verify:* re-grep Step 3 — no full `Read` of either log remains; the bounded instruction is present; the HIGH/urgent filter wording is unchanged in meaning.

5. **Close the improvement-log entry** — flip the 2026-07-13 HIGH entry to `applied 2026-07-13` + `Verified:`, and correct its "3 real files" claim to reflect the worktree (finding 4).
   *Verify:* entry reads applied + Verified; the stale fork-count claim no longer misleads the next session.

6. **Commit** (no push — batched to `/wrap-session` per workspace rule).
   *Verify:* commit contains `prime.md` + `improvement-log.md` and nothing foreign.

## Scope Alternatives
Single scope — no alternatives. The fix is one bounded edit with a named exit condition; there is no meaningful min/max variant. (The adjacent temptation — rewriting Step 3's HIGH/urgent *filter* itself, or bounding other `/prime` steps — is explicitly out of scope per the mandate and would be scope creep.)

## Autonomy Posture
Full autonomy.

**Stop points:**
- If the worktree is mid-edit on `prime.md` (execution step 2) — surface before editing.
- If the bounded scan cannot reproduce the full read's HIGH/urgent set (execution step 3) — surface rather than shipping a filter that silently under-surfaces urgent items.

## Risk
**No structural change class applies — `/risk-check` not required.** Checked against `docs/audit-discipline.md` § Risk-check change classes rather than asserted from memory: this is not a hook edit, not a permission change, not a cross-cutting CLAUDE.md edit, not a new command/skill, not a new symlink. The one class worth arguing — *automation with shared-state effects, including reordering existing shared-state ops* — does **not** fire: this change touches only a **read path**. It writes nothing, and reorders no operation against shared state. (Contrast the S6 `prime.md` edit, which changed marker *allocation* — a genuine shared-state write — and correctly took a `/risk-check`.)

The real risk is **correctness, not blast radius shape**: `prime.md` runs at every session start in 24 checkouts, so a filter regression would silently under-surface urgent items everywhere, and silently is the operative word — nothing would alarm. That risk is retired empirically at execution step 3, by validating the bounded scan against this session's own full-read ground truth, which is stronger evidence than a subagent reasoning about the same question. Per workspace *Subagent Proportionality* — inline verification is the proportionate form here; a dispatched gate would be ceremony on a read-only one-file edit.

Environment-fit check: not applicable — the work product is a command file, not an executable or launcher.
