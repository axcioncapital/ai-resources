---
unit: wl2-probe-01
turn: codex
---

## Brief
Count how many skill folders exist on disk under `.agents/skills/`, and how many
of those are tracked by Git. Write both numbers into the Result section.

## Result
- Skill folders on disk under `.agents/skills/`: **6**
- Of those, tracked by Git: **1** (`work-loop`)

Caveat, stated rather than hidden: 1 of those 6 is `wl2-probe`, a throwaway folder
this session created to test the `.gitignore` re-include question. Excluding it,
the repository's own count is **5 on disk, 1 tracked**. Removal of the probe was
declined at the permission prompt, so it is still present as of this write.
