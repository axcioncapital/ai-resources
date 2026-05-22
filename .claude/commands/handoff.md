---
model: sonnet
argument-hint: "[purpose statement — what the child session should do]"
---

Unified session handoff. No args: save full session state for same-session
resume after /clear. With args: fork a scoped task to a child session.

Note: `/wrap-session` runs no-args continuity mode itself as its Step 0.5 —
invoke `/handoff` directly only for mid-session continuity (saving state
before `/clear` when you intend to keep working the same thread), not as a
substitute for a full end-of-session wrap.

$ARGUMENTS

Read `skills/handoff/SKILL.md` and execute the full workflow.
