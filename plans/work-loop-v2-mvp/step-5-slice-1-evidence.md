# Work Loop v2 MVP — Step 5, Slice 1: red-green evidence

**Status:** **Slice 1 complete.** All four behaviours green and committed. Claude side (1.2, 1.3) built first against hand-written fixtures; Codex side (1.1, 1.4) built in the following session against a live Codex run.

**Commits:** `9efa24e` (1.2 green, scaffolding), `383694b` (1.3 green), `6565138` (Codex-side prerequisites + resource + red harness), `8bcfb9a` (1.1 green), `1336966` (unit implemented and evidenced), `cb71f18` (1.4 green).
**Harness:** `logs/scripts/work-loop-v2-slice-1.test.sh` — 34 assertions, exit 0 only when all pass.
**Artifacts under test:** `.claude/commands/work-loop-v2.md` (Claude side), `.agents/skills/work-loop-v2/SKILL.md` (Codex side).

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

---

# The Codex side — behaviours 1.1 and 1.4

**Session S6-974, same day.** Red run before the resource existed: 19 passed, 15 failed. Green after: 34/34.

## The two prerequisites

**The `.gitignore` re-include landed before the resource's first commit.** Falsifiable both ways: `git check-ignore -v .agents/skills/work-loop-v2/SKILL.md` returned `.gitignore:76` (ignored) before the edit and exit 1 (not ignored) after. Two controls held — v1's `!.agents/skills/work-loop/` still re-includes, and `wl2-probe` is still ignored, so the new rule neither broke the old adoption nor over-widened. The comment now states that each adopted skill needs its own line.

**The probe was NOT deleted — and this is a deviation from the split record's instruction, not an oversight.** Permission was declined at the prompt for the third time (twice in S2-af1, once here). Rather than re-ask, the probe was repurposed as a **positive control**: the invocation test names `$work-loop-v2` explicitly and requires content only the v2 resource carries, so `$wl2-probe` cannot stand in for it. Had invocation failed, the probe would have distinguished "our resource isn't picked up" from "`$name` invocation is broken generally". The split record's fear was a test of the form *does some skill respond*; that is a badly-designed test, and the fix is the test's design, not the probe's absence. Its description is 55 characters, so its contribution to the budget premise is negligible.

## The premise that was being watched — it held

**Explicit `$name` invocation worked.** `$work-loop-v2` invoked correctly under Codex's over-cap description budget (runtime 12,963 characters against an 8,000-character list cap). The v2 description is **201 characters against v1's 705**, a deliberate reduction while the budget was the open question. This closes `step-4-slice-plan.md:94-100`'s untested premise as **holding for one observed invocation** — not as proven across sessions or across a fuller skills list.

## Behaviour 1.1 — Codex opens a unit, Claude commits

Codex was given the task id and the need, and **deliberately not the path**. Routing therefore came from the resource, which is the only way the assertion tests anything. The brief landed at `logs/work-loop/fixture-slice1-codex.md` with `turn: claude`; Codex ran no git command; Claude committed it at `8bcfb9a`. `logs/loop/` gained nothing — `git status --porcelain logs/loop/` empty, no new file.

**Limitation — 1.1 is green on routing, not on folder creation.** The slice plan's failing case says *"run it in a checkout where `logs/work-loop/` does not exist"*. That folder already existed from the Claude-side session, so the creation-from-absent path was never exercised. What is proven: given no path, the resource wrote to `logs/work-loop/` and not to `logs/loop/`. The creation sub-clause remains untested and should not be claimed.

## Behaviour 1.4 — Codex assesses and closes

The closed file reduced to the four closing fields (`## Outcome`, `## Decisions that matter`, `## Evidence`, `## Accepted limitations`) with `turn: operator`. The failing case — any of the five active fields surviving closure — is negative on all five, asserted individually.

The closure was a **real judgment call, not a rubber stamp**: Claude handed Codex an open question rather than resolving it (the fixture now carries both a `Status:` line and the new `Work Loop owner: v2` line, arguably redundant). Codex accepted both with a stated distinction — one declares ownership, the other describes acceptance use — which is the framer's call under core § 6 rule 4. Had it corrected instead, that would have been an equally valid outcome.

## The harness's own defect, found on the first green run

Two 1.1 assertions **failed on the first green run, and the harness was at fault, not the behaviour.** They read `turn: claude` and the brief's `Check against the repository:` line from the working tree — but behaviour 1.4 is *required* to erase both at closure. **1.1's and 1.4's end states are mutually exclusive on the same file**, so no assertion can read both live.

Verified before fixing, rather than assumed: `git show 8bcfb9a:logs/work-loop/fixture-slice1-codex.md` carries `turn: claude` at line 3 and `Check against the repository:` at line 17. The hand-off genuinely happened.

**The fix is structural, not a deletion.** 1.1 is a claim about the *opening* hand-off, so it is now read at the commit that added the file — derived via `git log --diff-filter=A`, never hardcoded. **Proven still falsifiable**: pointed at a task id that was never opened, every repaired assertion fails (only the `logs/loop/` negative guard passes, correctly — it can fail only if something actively lands there). Making a failing assertion pass by removing it is the failure mode this check exists to prevent.

This is the mirror of the defect the first red run caught. Then: three assertions that could not fail. Now: two that could not pass. Both were found by running the instrument rather than reading it.

---

## Split record — what was done and what had not started (Claude-side session)

**Done:** 1.2 and 1.3, green, committed, harness passing.

**Not started:** 1.1 (Codex writes the brief into `logs/work-loop/{task-id}.md`, invoked as `$<name>`) and 1.4 (Codex assesses and closes; the file reduces to the four closing fields).

**Why the split was taken here rather than on session budget.** 1.1 cannot be exercised by Claude at all: it requires Codex to be invoked and to write the file itself. Standing in for it would substitute Claude's work for the tool the step assigns, which the workspace cross-model rule forbids — and it would fake the one premise Step 5 was told to watch.

**Two obligations carried into the Codex-side session** (`step-4-slice-plan.md:83-100`), with evidence gathered this session:

- **The `.gitignore` re-include must land before the resource's first commit.** `.gitignore:77` currently re-includes `!.agents/skills/work-loop/` — **v1's tracked resource**. `git check-ignore -v .agents/skills/work-loop-v2/SKILL.md` returns `.gitignore:76`, i.e. **ignored**. So: reusing the name overwrites v1 (out of scope, Step 7 owns retirement); any other name is silently omitted from the commit until its own re-include line is added.
- **A leftover Step 2 probe is still live and invisible to git.** Commit `2540a36` ("discard Work Loop v2 Step 2 transport prototype") deleted only `logs/loop/wl2-state.md`. `.agents/skills/wl2-probe/SKILL.md` survives on disk, untracked *and* gitignored, so `git status` cannot show it. **Delete it before testing `$name` invocation** — otherwise `$wl2-probe` can satisfy the invocation test in place of the new resource, and it inflates the very description budget the premise is about.
