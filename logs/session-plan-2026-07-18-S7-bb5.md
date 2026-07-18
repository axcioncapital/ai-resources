# Session Plan — 2026-07-18

## Intent
Resolve the `/prime` 8a.d vs `/session-plan` Step 8 contract conflict by making `/session-plan` Step 8 conditional on the invoking branch, so a numbered-menu task selection keeps its post-plan approval gate instead of auto-executing.

## Model
opus — match (session is on Opus 4.8). The hard part is deciding: the fix is a contract condition that must hold correctly across four distinct callers, and the log entry explicitly warns that the obvious alternative fix would delete a real gate.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` — Step 8 (line 216), the conflicting sentence
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — Step 8a.c–8a.d (lines 488–490), 8b.c–8b.d (lines 519–520), 8c (line 729)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — Step 4, the chain-invoke that actually reaches `/session-plan` in the 8a path
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the 2026-07-18 entry stating the conflict, the correct resolution, and the forbidden fix
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes (canonical command edit)

## Findings / Items to Address

1. **The conflicting pair** (`improvement-log.md` 2026-07-18, "The conflict"). `/prime` 8a.d says *"Wait for the operator. Do NOT begin execution on your own."* `/session-plan` Step 8 says *"do NOT pause for operator confirmation… The session begins under the declared autonomy posture immediately."* Both fire on the same event: `/session-plan` completing inside a `/prime` 8a chain.

2. **`/prime` 8a is the correct reading** (same entry, "Which is correct"). The pause is deliberate and documented — `prime.md:520` names it as *"8b's structural delta vs 8a, which pauses for explicit `go` after `/session-plan`."* The defect is an unguarded absolute in `/session-plan`, not an ambiguity of intent.

3. **Recency works against the correct reading** (same entry, "Why this is more than cosmetic"). `/session-plan` is chain-invoked, so Step 8 is the freshest instruction at the decision point while 8a.d was loaded turns earlier. A session following the freshest instruction literally begins executing an unapproved plan. Step 8 even enumerates "the only gates that legitimately pause this command" — a list that does not contemplate a caller-imposed gate.

4. **Preferred fix is caller-awareness in `session-plan.md`** (same entry, "Fix direction"). Put the condition in the file carrying the conflicting sentence. The weaker alternative — having `/prime` 8a.c restate the override at the point of call — is second choice because it leaves the absolute sentence in place for every future reader.

5. **Forbidden fix, explicitly** (same entry, "Do not fix this by…"). Removing `/prime` 8a's pause is out of bounds. The 8a/8b split is intentional: a menu pick is not the operator stating the work.

6. **The real invocation path is indirect, and the plan must not assume otherwise.** `prime.md:488` (8a.c) says `/prime` invokes `/session-plan` after `/session-start` finishes — but `session-start.md` Step 4 *itself* chain-invokes `/session-plan`. So in practice the 8a path reaches `/session-plan` through `/session-start`, and any caller-declared gate must survive that hop. This is the single highest-risk unknown in the fix and is verified first at execution.

7. **Auto mode (8c) is not a caller.** `prime.md:729` shows 8c writes the plan file inline against the Step 7 schema rather than invoking the command, so it is unaffected — but its inline copy of the logic should be checked for the same absolute.

8. **Blast radius is wide but uniform.** ~17 project-level `.claude/commands/session-plan.md` paths exist; the four sampled are all symlinks to the canonical file. One edit propagates everywhere, which is why the condition must degrade safely for a direct operator invocation with no caller at all.

## Execution Sequence

1. **Ground the conflict.** Read `session-plan.md` Step 8 and `prime.md` 8a.c–8a.d, 8b.c–8b.d verbatim. *Verify:* both conflicting sentences are present as quoted in the log entry; if either has already changed, stop and re-scope.

2. **Trace the real caller chain.** Read `session-start.md` Step 4 and confirm whether the 8a path reaches `/session-plan` via `/session-start`'s chain, via 8a.c directly, or both. *Verify:* name the exact invoking step and whether any caller context is passed today. This determines whether the fix needs a new signal or can rely on one that exists.

3. **Confirm the symlink topology.** Check that all ~17 project copies are symlinks, not real files. *Verify:* a count of symlinks vs real files; any real copy is a second edit site and changes the plan.

4. **Design the condition.** Write the Step 8 replacement: begin execution immediately *unless* the invoking branch declared a post-plan gate, in which case emit the plan-ready line and stop. *Verify:* walk it against all four callers — `/prime` 8a (gate), `/prime` 8b (no gate), `/session-start` direct chain, and bare operator invocation (no gate). Each must land on the documented behaviour.

5. **Run `/risk-check`** (plan-time gate — canonical command edit is a structural class). *Verify:* verdict is GO or PROCEED-WITH-CAUTION with mitigations applied. NO-GO is a mandate stop condition.

6. **Apply the edit** to `session-plan.md` Step 8, plus the minimum caller-side declaration in `prime.md` 8a.c if step 2 shows the gate cannot otherwise be known. *Verify:* re-read the shipped files from disk (not `git diff`) and confirm the sentences read as designed.

7. **Close the log entry.** Flip the 2026-07-18 `improvement-log.md` entry to applied, citing what shipped and which fix direction was taken. *Verify:* the entry's status line no longer reads `logged (pending)`.

## Scope Alternatives

- **Min** — edit `session-plan.md` Step 8 only, with the condition keyed to a caller signal that already exists. Ships the fix; leaves nothing for `/prime` to state.
- **Recommended** — min, plus a one-line declaration in `/prime` 8a.c naming the gate at the point of call, so the condition is legible from both ends. Also check 8c's inline copy for the same absolute.
- **Max** — recommended, plus a sweep of every command that chain-invokes another for the same unguarded-absolute pattern. Deferred by default: it is a different (and larger) piece of work, and the log entry scopes this item to one conflict.

## Autonomy Posture
Gated

**Stop points:**
- After step 2 (caller-chain trace) if the 8a path turns out not to pass any usable caller signal — the fix shape changes and the operator should see that before an edit lands.
- Before step 6 (the edit), pending the `/risk-check` verdict.
- Immediately on a `/risk-check` NO-GO, or if the fix would require editing commands outside `ai-resources/.claude/commands/` — both are declared mandate stop conditions.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

Structural class: canonical command edit with wide blast radius — `/session-plan` is symlinked into ~17 project workspaces, so the change takes effect everywhere at once. The specific hazard is that the fix inverts a default: a condition written too broadly would make `/session-plan` pause for callers that legitimately should not pause (8b free-text intent, direct invocation), converting a skipped-gate defect into a stuck-session defect. The caller walk-through in step 4 is the control for this and must be done against all four callers, not just the one being fixed.

Not a launch/runtime-gated artifact — no environment-fit check applies.
