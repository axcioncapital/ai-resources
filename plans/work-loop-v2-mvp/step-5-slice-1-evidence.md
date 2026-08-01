# Work Loop v2 MVP — Step 5, Slice 1: Claude side, red-green evidence

**Status:** Claude side (1.2, 1.3) green and committed. Codex side (1.1, 1.4) not started — split taken at the predefined point (`step-4-slice-plan.md:44-50`).

**Commits:** `9efa24e` (1.2 green, scaffolding), `383694b` (1.3 green).
**Harness:** `logs/scripts/work-loop-v2-slice-1.test.sh` — 18 assertions, exit 0 only when all pass.
**Artifact under test:** `.claude/commands/work-loop-v2.md`.

---

## The red-green record

| Run | Result |
|---|---|
| **Red** (before the command existed) | 12 assertions failed, 6 passed. The 6 were fixture-presence checks and three negative guards. |
| **Green** (after 1.2 and 1.3) | 18 passed, 0 failed. |

### The red run caught three assertions that could not fail

Recorded because it is the defect core § 6 rule 5 names, found in this session's own instrument:

1. `1.2b the false claim is named` passed on the untouched fixture — a whole-file grep for `false` matched the fixture's own id, `task: fixture-slice1-false`. **Fixed:** the assertion now scopes to the `## Blocker` section via an `awk` range, and requires it to no longer read `None.`
2. `1.3 result and evidence pointer written` passed on the untouched fixture — a grep for `evidence` matched the brief's own `Evidence required:` line. **Fixed:** now requires a written `^Evidence:` line, which the brief's wording cannot supply.
3. Both commit assertions would have passed the moment the fixtures were committed, proving nothing about a hand-back. **Fixed:** both now assert on committed *content* — `git show HEAD:<path>` carries `turn: codex` / carries `^Status:`.

Had the first red run been accepted, three of Slice 1's acceptance behaviours would have been marked green by checks that read identically whether or not the work happened.

---

## Behaviour 1.2 — verify premises, refuse a false premise

**(a) every claim holds — the inspection record still appears.** `fixture-slice1-true.md`. Both claims checked by inspection. The record names each claim, the surface searched and the pattern, including for the claim that holds. The absence claim (`no Status: line`) names both `logs/work-loop/fixture-target.md` and the pattern `^Status:`, per core § 6 rule 3.

**(b) one claim deliberately false — nothing is mutated.** `fixture-slice1-false.md` claims the target contains a `## Owner` section. It does not; the only headings are `# Fixture target` (line 1) and `## Body` (line 6). The run wrote the finding to `## Blocker`, set `turn: codex`, committed, and stopped. **`git diff` across the one file the brief named is empty, and the `## Owner` section was not manufactured into existence** — the specific failure core § 1 names ("Claude does not silently repair a bad brief").

## Behaviour 1.3 — execute and evidence

The evidence's failing case was built and observed first: `grep -c '^Status:' logs/work-loop/fixture-target.md` returned **0** before the work, and that 0-state is committed at `9efa24e`. After the unit, it returns **1**. The check reads differently depending on whether the work happened, which is what makes it evidence rather than decoration.

---

## Limitations

1. **Run (b)'s hand-back and its fixture landed in the same commit** (`9efa24e`), so the hand-back is not visible in git as a delta. It is evidenced by the harness's committed-content assertion instead. Run (a) does not share this limitation — its before-state is a separate commit.
2. **The command was executed by the same session that wrote it.** No fresh-session run has exercised it. That is Slice 2's behaviour 2.1 and is not claimed here.
3. **Slice 2 and Slice 3 behaviours are absent by design** — file-identity rejection (2.2) in particular, so a stale or foreign state file is *not* yet refused. The command says so in its own scope note rather than leaving a reader to assume otherwise.

## Split record — what is done and what has not started

**Done:** 1.2 and 1.3, green, committed, harness passing.

**Not started:** 1.1 (Codex writes the brief into `logs/work-loop/{task-id}.md`, invoked as `$<name>`) and 1.4 (Codex assesses and closes; the file reduces to the four closing fields).

**Why the split was taken here rather than on session budget.** 1.1 cannot be exercised by Claude at all: it requires Codex to be invoked and to write the file itself. Standing in for it would substitute Claude's work for the tool the step assigns, which the workspace cross-model rule forbids — and it would fake the one premise Step 5 was told to watch.

**Two obligations carried into the Codex-side session** (`step-4-slice-plan.md:83-100`), with evidence gathered this session:

- **The `.gitignore` re-include must land before the resource's first commit.** `.gitignore:77` currently re-includes `!.agents/skills/work-loop/` — **v1's tracked resource**. `git check-ignore -v .agents/skills/work-loop-v2/SKILL.md` returns `.gitignore:76`, i.e. **ignored**. So: reusing the name overwrites v1 (out of scope, Step 7 owns retirement); any other name is silently omitted from the commit until its own re-include line is added.
- **A leftover Step 2 probe is still live and invisible to git.** Commit `2540a36` ("discard Work Loop v2 Step 2 transport prototype") deleted only `logs/loop/wl2-state.md`. `.agents/skills/wl2-probe/SKILL.md` survives on disk, untracked *and* gitignored, so `git status` cannot show it. **Delete it before testing `$name` invocation** — otherwise `$wl2-probe` can satisfy the invocation test in place of the new resource, and it inflates the very description budget the premise is about.
