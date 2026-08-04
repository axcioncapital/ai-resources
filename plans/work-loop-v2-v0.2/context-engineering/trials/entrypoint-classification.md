# S8a — Entrypoint classification

**Session:** S8a, per `../context-engineering-implementation-plan-v0.1.md` § 7, Phase 3.
**Date of scan:** 2026-08-04. **Lead:** Claude. **Observer:** the operator (confirmation still owed — see § 6).
**Status:** provisional. The operator has not yet run the observer check or confirmed the O-3 reading.
**Revision:** corrected once against Codex's assessment (findings 1–3), 2026-08-04.

**Repository root**, written in full once and used verbatim in every command below:

```
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo
```

**O-3 reading applied: A — "the v0.2 entry protocol only."** Carried into this session by the task-state
file `logs/work-loop/context-engineering-s8a-entrypoint-classification.md`, which records the operator's
decision as governing. Under reading A only v0.2-generation paths are in the relevance population. Work
Loop v1 paths are **preserved visibly below as outside that population** — not deleted — so the narrower
claim this reading produces is explicit rather than implied.

> **The order is load-bearing.** O-3 was applied first to set the population; the relevance test then ran
> inside it. A path the reading includes cannot be classified out by the test.

**The relevance test, one condition:** a path in the population is **relevant** if plan-dependent briefing
or continuation actually happens through it.

**Two facts recorded per path decide *how* it would be wired, never *whether* it is relevant:** whether a
Codex skill is discoverable from it, and which state directory it uses. Plan § 11 states the distinction
these two facts sit on, and it governs Rows 3 and 4 below: where no `.agents/` and no `logs/work-loop/`
exist, *"no plan-dependent briefing or continuation happens through it — S8a's one relevance condition
fails, and those two absences are the evidence for **that**, not conditions in their own right."*

---

## 1. The scan

Two roots, exactly as the brief scoped them. Both commands run 2026-08-04.

```
find -L "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" \
  \( -name 'work-loop-v2.md' -o -name 'work-loop.md' \
     -o -path '*/work-loop-v2/SKILL.md' -o -path '*/work-loop/SKILL.md' \) \
  -type f -print
```

```
find -L "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects" \
  \( -name 'work-loop-v2.md' -o -name 'work-loop.md' \
     -o -path '*/work-loop-v2/SKILL.md' -o -path '*/work-loop/SKILL.md' \) \
  -type f -print
```

**Searched surface:** the two roots in full, recursively, following symlinks (`-L`). No pruning: `.git`,
`node_modules` and every dotted directory were traversed. **Filename patterns:** the five artifacts plan
§4.2 names — the v2 Claude command (`work-loop-v2.md`), the v2 Codex skill
(`*/work-loop-v2/SKILL.md`), the v1 Claude command and the v1 contract (both `work-loop.md`), and the v1
Codex skill (`*/work-loop/SKILL.md`).

**Exit status:** 0 for both. **Diagnostic output:** none. Neither run emitted a symlink-cycle warning, a
permission error, or any other message on stderr.

**Complete verbatim output — root 1 (`ai-resources`), 5 paths:**

```
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop/SKILL.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md
```

**Complete verbatim output — root 2 (`projects`), 9 paths:**

```
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/commands/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/commands/work-loop-v2.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/commands/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/.claude/commands/work-loop-v2.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/.claude/commands/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-crm/.claude/commands/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.claude/commands/work-loop.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md
```

### Count reconciliation

| | Count |
|---|---|
| Scan results, root 1 | 5 |
| Scan results, root 2 | 9 |
| **Scan results, total** | **14** |
| **Classification rows below** | **14** |
| **Reconciles** | **Yes — equal** |

No path appears twice in the scan output, and no row below lacks a scan result. § 6's observer check
re-derives both halves of this reconciliation and fails visibly if either moves.

### File identity behind the 14 paths

The 14 access paths reach **five** canonical files. Verified by resolved inode, not by filename:

```
stat -Lf '%i' <each of the 14 paths>
readlink       <each of the 14 paths>
```

| Canonical file | Inode | Access paths |
|---|---|---|
| `ai-resources/.claude/commands/work-loop-v2.md` (115 lines) | 15040234 | 4 |
| `ai-resources/.agents/skills/work-loop-v2/SKILL.md` (160 lines) | 15040219 | 2 |
| `ai-resources/.claude/commands/work-loop.md` (251 lines) | 14230662 | 6 |
| `ai-resources/.agents/skills/work-loop/SKILL.md` (119 lines) | 13541224 | 1 |
| `ai-resources/docs/work-loop.md` (260 lines) | 14232954 | 1 |

*(Inode numbers are recorded as observed on 2026-08-04. They are not stable across a file being rewritten,
so § 6's check compares each path's inode to the canonical file's **current** inode rather than to these
literals — the grouping is the durable fact, the numbers are the observation.)*

This confirms plan §4.2's "one command file and one skill file, not three copies" and extends it: there is
**no duplicated content anywhere in either root.** Every project path is a symlink — either the file
itself, or a directory above it.

### Change against the plan's 2026-08-02 inventory

Plan §4.2 recorded **three** access paths to the v2 Claude command. The fresh scan finds **four**. The new
one is
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md`,
a project that did not exist in the earlier inventory. This is recorded as a fact about the surface. It
adds a row but changes no verdict elsewhere: the new path classifies exactly as `axcion-design-studio`
does, for exactly the same observed reasons (Row 4).

---

## 2. In-population rows — reading A (v0.2 generation)

Six paths. **Four relevant, two not relevant** — every verdict backed by an observed condition.

### Row 1 — `ai-resources/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes — v0.2 Claude entrypoint.
- **Access shape:** the canonical file itself (not a symlink).
- **Plan-dependent briefing or continuation through it?** **Yes — continuation, observed.** This
  classification session is itself an instance: the command was invoked here, read the executable core,
  checked the approved plan's claims, and continued the unit the plan sequences. `logs/work-loop/` holds
  19 state files. The command's own text binds it to the plan-dependent contract at line 11.
- **Codex skill discoverable:** yes — `.agents/skills/work-loop-v2/SKILL.md` present.
- **State directory:** `logs/work-loop/`, 19 files.
- **Verdict: RELEVANT** — by observed continuation.
- **Commands and their actual output:**

  ```
  $ ls -1 "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/" | wc -l
        19

  $ command grep -n 'executable-core' "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md"
  11:**Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before anything else, every invocation.** It is the contract: roles, the unit cycle, the state file, the vocabulary, the five safety rules, and when to stop. This command does the work; it does not restate the contract. Where the two disagree, the core wins and the disagreement is a defect to report.
  ```

### Row 2 — `projects/axcion-systems-builder/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** file symlink → `../../../../ai-resources/.claude/commands/work-loop-v2.md` (inode 15040234).
- **Plan-dependent briefing or continuation through it?** **Yes — continuation, observed.** The project
  holds three v2 state files, each with valid `task:`/`turn:` frontmatter, so v2 units have actually been
  opened and carried here. The executable core resolves from this root to the same inode as the canonical
  file, so the command's first mandatory read succeeds.
- **Codex skill discoverable:** yes — via the symlinked directory `.agents/skills/work-loop-v2`.
- **State directory:** `logs/work-loop/`, 3 files.
- **Verdict: RELEVANT** — by observed continuation.
- **Commands and their actual output:**

  ```
  $ command grep -H '^turn:' "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/logs/work-loop/"*.md
  /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/logs/work-loop/crm-derived-answer-authority.md:turn: operator
  /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/logs/work-loop/decision-entry-referenceability.md:turn: operator
  /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/logs/work-loop/review-packet-preservation.md:turn: operator

  $ stat -Lf '%i' "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md" \
                  "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md"
  15029379
  15029379
  ```

### Row 3 — `projects/axcion-design-studio/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** reached through a **symlinked `commands/` directory** —
  `.claude/commands` → `../../../ai-resources/.claude/commands`. The file itself is not a symlink; it is
  the canonical inode 15040234 seen through a linked parent.
- **Plan-dependent briefing or continuation through it?** **No — observed, not ambiguous.** Three
  absences, each searched and named: `logs/work-loop/` is absent, so no v2 state file has ever existed
  here and no unit can be opened or continued; `.agents/` is absent entirely, so no Codex skill is
  reachable and no brief can be prepared; and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` does not resolve from this root, so the
  command's first mandatory instruction has nothing to read. The command is reachable, and nothing
  plan-dependent happens through it.
- **Codex skill discoverable:** no — `.agents/` absent.
- **State directory:** none — neither `logs/work-loop/` nor `logs/loop/`.
- **Verdict: NOT RELEVANT** — S8a's one relevance condition fails, on evidence.
- **Authority for reading the absences as evidence rather than as excluded grounds:** plan § 11, *"Not
  limitations, and recorded here so they are not mistaken for any"* — this exact project, this exact pair
  of absences, and the same verdict, already established there and to be *"re-derived at adoption."* The
  S8a prohibition ("do not classify a reading-A path out because it lacks a Codex skill or uses a
  different state directory") forbids treating the two facts as **conjoined conditions of relevance**; it
  does not forbid them as **evidence that briefing and continuation do not occur.** § 11 draws that line
  explicitly.
- **The verdict is conditional on the surface, and flips the moment briefing becomes possible** — if this
  project gains `.agents/` and `logs/work-loop/`, the path becomes relevant and must be wired.
- **Commands and their actual output:**

  ```
  $ readlink "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/commands"
  ../../../ai-resources/.claude/commands

  $ ls -d "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.agents" \
          "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/work-loop"
  ls: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.agents: No such file or directory
  ls: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/work-loop: No such file or directory

  $ ls "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md"
  ls: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md: No such file or directory
  ```

### Row 4 — `projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** file symlink → `../../../../ai-resources/.claude/commands/work-loop-v2.md` (inode 15040234).
- **Plan-dependent briefing or continuation through it?** **No — observed, not ambiguous.** The same one
  condition, the same three absences: no `logs/work-loop/`, no `.agents/`, no resolvable executable core.
  This project does carry `logs/loop/` with two v1 artifacts, which shows plan-dependent loop work happens
  in the project — but through **v1**, which reading A places outside the population, so it bears on no
  verdict here. Plan § 11's caveat that the two absences do not settle v1 applies to reading B only; under
  reading A v1 is not in the population to be settled.
- **Codex skill discoverable:** no — `.agents/` absent.
- **State directory:** none for v2; `logs/loop/` present with 2 files, out of population.
- **Verdict: NOT RELEVANT** — S8a's one relevance condition fails, on evidence. Same authority as Row 3;
  this project postdates § 11's text, so the reasoning is applied rather than quoted, exactly as Codex's
  correction directed.
- **The verdict flips the moment briefing becomes possible**, on the same terms as Row 3.
- **Commands and their actual output:**

  ```
  $ readlink "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md"
  ../../../../ai-resources/.claude/commands/work-loop-v2.md

  $ ls -d "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.agents" \
          "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/logs/work-loop"
  ls: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.agents: No such file or directory
  ls: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/logs/work-loop: No such file or directory

  $ ls -1 "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/logs/loop/"
  2026-07-30-writing-studio-phase9-mvp.brief.md
  2026-07-30-writing-studio-phase9-mvp.evidence.md
  ```

### Row 5 — `ai-resources/.agents/skills/work-loop-v2/SKILL.md`

- **Reading applied:** A. **In population:** yes — v0.2 Codex entrypoint.
- **Access shape:** the canonical file itself (not a symlink).
- **Plan-dependent briefing or continuation through it?** **Yes — briefing, observed, at both sites.** The
  brief in this session's own state file was prepared through it, and the skill's text carries the
  plan-dependent duties explicitly. Both of plan §4.2's sites (opening a unit and writing the brief;
  assessing and continuing) are live here.
- **Codex skill discoverable:** yes — this **is** the skill.
- **State directory:** `logs/work-loop/`, 19 files.
- **Verdict: RELEVANT** — by observed briefing.
- **Commands and their actual output** (line numbers truncated to their first 120 characters for width;
  the line numbers are the evidence):

  ```
  $ command grep -n 'approved plan' "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md" | cut -d: -f1
  65
  73
  79
  85

  $ command grep -n 'governing plan' "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md" | cut -d: -f1
  81
  ```

  Line 85 is the plan-justification duty — *"Say how this unit is justified against the approved plan."*
  Line 81 is the orientation duty — *"A fresh thread recovers its bearings inside this same preparation
  pass, never as a stage of its own: proportionately re-establish the current operator request, the
  governing plan, applicable approved workflows, authoritative current state, material settled decisions,
  unresolved blockers, and the next justified unit."*

### Row 6 — `projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md`

- **Reading applied:** A. **In population:** yes.
- **Access shape:** reached through a **symlinked skill directory**. The file is the canonical inode
  15040219. `.agents/` and `.agents/skills/` are real directories; only the skill folder is linked.
- **Plan-dependent briefing or continuation through it?** **Yes — briefing, observed.** The three v2 state
  files in this project (Row 2's output) each carry a Codex-written brief, which is this site's output.
- **Codex skill discoverable:** yes — this is the skill, reachable from the project root.
- **State directory:** `logs/work-loop/`, 3 files.
- **Verdict: RELEVANT** — by observed briefing.
- **Command and its actual output:**

  ```
  $ readlink "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/.agents/skills/work-loop-v2"
  ../../../../ai-resources/.agents/skills/work-loop-v2
  ```

### In-population summary

| Row | Path | Verdict |
|---|---|---|
| 1 | `ai-resources/.claude/commands/work-loop-v2.md` | **Relevant** |
| 2 | `projects/axcion-systems-builder/.claude/commands/work-loop-v2.md` | **Relevant** |
| 3 | `projects/axcion-design-studio/.claude/commands/work-loop-v2.md` | Not relevant |
| 4 | `projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md` | Not relevant |
| 5 | `ai-resources/.agents/skills/work-loop-v2/SKILL.md` | **Relevant** |
| 6 | `projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md` | **Relevant** |

**Four relevant paths, reaching two canonical files** — the v2 Claude command and the v2 Codex skill.

**This is not the same pair as plan §4.2's "two files", and the two must not be conflated.** §4.2 says that
under the narrow reading *"adoption coverage reduces to two files — the Codex skill's two plan-dependent
sites and the executable core's orientation step — which makes this integration a seam edit rather than a
subsystem."* Those are **wiring targets**: the Codex skill and the executable core. The pair above is
**access-path destinations**: the Codex skill and the Claude command. The overlap is the Codex skill alone.
The executable core is not in this record at all — it was not among the five artifacts the brief scoped the
scan to, and it is not an access path. Mapping relevant access paths onto wiring targets is S8b's job; this
record classifies paths and nothing else. It wires nothing and sequences nothing.

---

## 3. Out-of-population rows — Work Loop v1

Eight paths. Under reading A these carry **no relevance verdict**: the reading places them outside the
population before the test runs. They are preserved here in full so the narrowing reading A performs is
visible rather than silent.

**These rows were not inspected as a pretext to decide wiring, retirement, or O-3 again.** Each records
only what the scan and a `readlink`/`stat` returned.

| # | Access path (under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/`) | Artifact | Access shape | Disposition |
|---|---|---|---|---|
| 7 | `ai-resources/.claude/commands/work-loop.md` | v1 Claude command (251 lines, inode 14230662) | canonical file | Outside reading A's population |
| 8 | `projects/global-macro-analysis/.claude/commands/work-loop.md` | v1 Claude command | file symlink → `../../../../ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 9 | `projects/axcion-design-studio/.claude/commands/work-loop.md` | v1 Claude command | via symlinked `commands/` directory | Outside reading A's population |
| 10 | `projects/axcion-systems-builder/.claude/commands/work-loop.md` | v1 Claude command | file symlink → `../../../../ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 11 | `projects/axcion-crm/.claude/commands/work-loop.md` | v1 Claude command | file symlink, **absolute** → `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 12 | `projects/axcion-systems-builder-email-os/.claude/commands/work-loop.md` | v1 Claude command | file symlink → `../../../../ai-resources/.claude/commands/work-loop.md` | Outside reading A's population |
| 13 | `ai-resources/.agents/skills/work-loop/SKILL.md` | v1 Codex skill (119 lines, inode 13541224) | canonical file | Outside reading A's population |
| 14 | `ai-resources/docs/work-loop.md` | v1 shared contract (260 lines, inode 14232954) | canonical file | Outside reading A's population |

**What reading A narrows away, stated plainly.** Six of these eight paths reach a live v1 command that
**authors its own plan-dependent brief**, and v1 has its own Codex skill and its own state directory,
`logs/loop/`, which holds 10 artifacts in `ai-resources`, 3 in `axcion-systems-builder` and 2 in
`axcion-systems-builder-email-os`. Under reading B every one of these would enter the population and, by
plan §4.2, classify relevant. Under reading A they do not, and plan-dependent work can continue to flow
through them without Context Engineering. **That is the gap CE-17 exists to close, and reading A leaves it
open by design.** Plan §6 requires this narrowing to be written into the adoption record rather than left
implied; this paragraph is that record's source.

The basis for "authors its own plan-dependent brief", with actual output:

```
$ command grep -n 'compose the brief yourself' "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md"
41:**If `$ARGUMENTS` is plain English**, compose the brief yourself in the contract's `BRIEF` shape. Say plainly in chat that this brief is Claude-authored, so it has had no independent framing — that is a real, recorded weakness of the unit, not a formality.
```

---

## 4. Exit condition

Session S8a's exit: *every access path carries a verdict backed by an observed condition and a named O-3
reading.*

| Requirement | Status |
|---|---|
| Every scanned access path has exactly one row | **Met** — 14 scanned, 14 rows, no duplicates |
| Every in-population path has an evidence-backed verdict | **Met** — 6 of 6, all on observed conditions: 4 relevant, 2 not relevant. No verdict rests on the fail-safe. |
| Every v1 path visibly outside reading A's population | **Met** — 8 rows preserved in § 3 with dispositions |
| Counts reconcile | **Met** — 14 = 14, stated in § 1 and re-derived by § 6 |
| Operator confirmation recorded | **NOT MET** — owed; see § 6 |

**The unit is therefore provisional, not complete.**

## 5. Limitations

1. **Scan surface is exactly the two roots the brief named** — `ai-resources` and `projects`. As a bounded
   check against a silent gap, `find -L "$HOME/.claude" -maxdepth 3` was run with the same four patterns
   and returned **no matches** (exit 0), so no user-level access path exists today and no entrypoint is
   unaccounted for. That check is recorded as an observation, not as a row, because it lies outside the
   briefed surface.
2. **No behaviour was executed through any path.** Every verdict rests on repository state — state files,
   symlink targets, resolved inodes, artifact text. That an invocation through Rows 3 or 4 would fail at
   the executable-core read is inferred from the absent file, not observed by running it. The verdict does
   not depend on that inference: it rests on the absence of any briefing or continuation surface.
3. **Rows 3 and 4 are conditional on the current project surface** and flip the moment `.agents/` and
   `logs/work-loop/` appear in those projects. Plan § 11 already requires the Row 3 verdict to be
   re-derived at adoption; Row 4 inherits the same requirement.
4. **Phase 2's exit condition remains unmet** (the S7 grouped-regression run was declined). This session
   proceeds under the operator's explicit, recorded deviation. It creates no missing evidence and supports
   no adoption claim.

*Entrypoint coverage and the O-3 reading are deliberately absent from this list — plan § 11 forbids
recording either as a limitation, because that would let wording waive what CE-17 makes a condition.*

## 6. Operator observation — owed

Per plan § 7, Phase 3, S8a, the operator is this session's observer. Two things are needed before the unit
can be called complete.

### 6.1 Run the observer check

Copy the whole block below into a terminal and run it. It re-derives **every row** of this record: the two
scans and their exit status, the 14-path reconciliation with a duplicate test, the set-equality test against
the recorded paths, the five-canonical-file grouping, each in-population row's evidence, and the
out-of-population count. It prints `PASS` or `FAIL` per check and exits non-zero if anything fails.

**It is capable of failing, and this was verified rather than assumed.** Re-run against a repository with
one access path removed, it produced:

```
FAIL  root 2 path count          expected: 9    actual: 8
FAIL  total path count           expected: 14   actual: 13
FAIL  no duplicate paths         expected: 14   actual: 13
FAIL  scanned set == recorded set
     < /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md
FAIL  paths reaching the canonical v2 command   expected: 4    actual: 3
ONE OR MORE CHECKS FAILED — the record does not match the repository.
```

A missing path is named. An unsupported row fails on its own line.

```bash
R="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"
FAILED=0
ok(){ printf 'PASS  %s\n' "$1"; }
no(){ printf 'FAIL  %s\n     expected: %s\n     actual:   %s\n' "$1" "$2" "$3"; FAILED=1; }
cmp_(){ [ "$2" = "$3" ] && ok "$1" || no "$1" "$2" "$3"; }

scan(){ find -L "$1" \( -name 'work-loop-v2.md' -o -name 'work-loop.md' \
        -o -path '*/work-loop-v2/SKILL.md' -o -path '*/work-loop/SKILL.md' \) -type f -print; }

echo "== 1. Scan and count reconciliation =="
A=$(scan "$R/ai-resources" 2>/tmp/s8a.err); AE=$?
P=$(scan "$R/projects"    2>>/tmp/s8a.err); PE=$?
cmp_ "root 1 exit status"        "0"  "$AE"
cmp_ "root 2 exit status"        "0"  "$PE"
cmp_ "no stderr from either scan" ""  "$(cat /tmp/s8a.err)"
cmp_ "root 1 path count"         "5"  "$(printf '%s\n' "$A" | grep -c .)"
cmp_ "root 2 path count"         "9"  "$(printf '%s\n' "$P" | grep -c .)"
ALL=$(printf '%s\n%s\n' "$A" "$P" | grep . | sort)
cmp_ "total path count"          "14" "$(printf '%s\n' "$ALL" | wc -l | tr -d ' ')"
cmp_ "no duplicate paths"        "14" "$(printf '%s\n' "$ALL" | sort -u | wc -l | tr -d ' ')"

echo
echo "== 2. The 14 paths are exactly the 14 rows =="
EXPECTED=$(sort <<EOF
$R/ai-resources/.agents/skills/work-loop-v2/SKILL.md
$R/ai-resources/.agents/skills/work-loop/SKILL.md
$R/ai-resources/.claude/commands/work-loop-v2.md
$R/ai-resources/.claude/commands/work-loop.md
$R/ai-resources/docs/work-loop.md
$R/projects/axcion-crm/.claude/commands/work-loop.md
$R/projects/axcion-design-studio/.claude/commands/work-loop-v2.md
$R/projects/axcion-design-studio/.claude/commands/work-loop.md
$R/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md
$R/projects/axcion-systems-builder-email-os/.claude/commands/work-loop.md
$R/projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md
$R/projects/axcion-systems-builder/.claude/commands/work-loop-v2.md
$R/projects/axcion-systems-builder/.claude/commands/work-loop.md
$R/projects/global-macro-analysis/.claude/commands/work-loop.md
EOF
)
D=$(diff <(printf '%s\n' "$EXPECTED") <(printf '%s\n' "$ALL"))
[ -z "$D" ] && ok "scanned set == recorded set (a missing or extra path shows here)" \
            || no "scanned set == recorded set" "no difference" "$D"

echo
echo "== 3. File identity: 14 paths reach 5 canonical files =="
ino(){ stat -Lf '%i' "$1" 2>/dev/null; }
C_V2CMD=$(ino "$R/ai-resources/.claude/commands/work-loop-v2.md")
C_V2SKL=$(ino "$R/ai-resources/.agents/skills/work-loop-v2/SKILL.md")
C_V1CMD=$(ino "$R/ai-resources/.claude/commands/work-loop.md")
C_V1SKL=$(ino "$R/ai-resources/.agents/skills/work-loop/SKILL.md")
C_V1DOC=$(ino "$R/ai-resources/docs/work-loop.md")
n(){ c=0; while IFS= read -r p; do [ "$(ino "$p")" = "$1" ] && c=$((c+1)); done <<< "$ALL"; echo "$c"; }
cmp_ "paths reaching the canonical v2 command" "4" "$(n "$C_V2CMD")"
cmp_ "paths reaching the canonical v2 skill"   "2" "$(n "$C_V2SKL")"
cmp_ "paths reaching the canonical v1 command" "6" "$(n "$C_V1CMD")"
cmp_ "paths reaching the canonical v1 skill"   "1" "$(n "$C_V1SKL")"
cmp_ "paths reaching the v1 contract"          "1" "$(n "$C_V1DOC")"
cmp_ "the 5 canonical files are distinct"      "5" \
     "$(printf '%s\n%s\n%s\n%s\n%s\n' "$C_V2CMD" "$C_V2SKL" "$C_V1CMD" "$C_V1SKL" "$C_V1DOC" | sort -u | wc -l | tr -d ' ')"

echo
echo "== 4. Row evidence — the 6 in-population paths =="
cnt(){ ls -1 "$1" 2>/dev/null | wc -l | tr -d ' '; }
has(){ [ -e "$1" ] && echo yes || echo no; }

echo "-- Row 1: ai-resources v2 command -> RELEVANT"
cmp_ "R1 v2 state files present"  "19"  "$(cnt "$R/ai-resources/logs/work-loop")"
cmp_ "R1 Codex skill discoverable" "yes" "$(has "$R/ai-resources/.agents/skills/work-loop-v2/SKILL.md")"
cmp_ "R1 executable core resolves" "yes" "$(has "$R/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md")"

echo "-- Row 2: axcion-systems-builder v2 command -> RELEVANT"
cmp_ "R2 v2 state files present"  "3"   "$(cnt "$R/projects/axcion-systems-builder/logs/work-loop")"
cmp_ "R2 Codex skill discoverable" "yes" "$(has "$R/projects/axcion-systems-builder/.agents/skills/work-loop-v2/SKILL.md")"
cmp_ "R2 executable core resolves" "yes" "$(has "$R/projects/axcion-systems-builder/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md")"

echo "-- Row 3: axcion-design-studio v2 command -> NOT RELEVANT"
cmp_ "R3 commands/ is a symlink"   "../../../ai-resources/.claude/commands" \
     "$(readlink "$R/projects/axcion-design-studio/.claude/commands")"
cmp_ "R3 no v2 state directory"    "no" "$(has "$R/projects/axcion-design-studio/logs/work-loop")"
cmp_ "R3 no .agents"               "no" "$(has "$R/projects/axcion-design-studio/.agents")"
cmp_ "R3 no executable core"       "no" "$(has "$R/projects/axcion-design-studio/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md")"

echo "-- Row 4: axcion-systems-builder-email-os v2 command -> NOT RELEVANT"
cmp_ "R4 file is a symlink"        "../../../../ai-resources/.claude/commands/work-loop-v2.md" \
     "$(readlink "$R/projects/axcion-systems-builder-email-os/.claude/commands/work-loop-v2.md")"
cmp_ "R4 no v2 state directory"    "no" "$(has "$R/projects/axcion-systems-builder-email-os/logs/work-loop")"
cmp_ "R4 no .agents"               "no" "$(has "$R/projects/axcion-systems-builder-email-os/.agents")"
cmp_ "R4 no executable core"       "no" "$(has "$R/projects/axcion-systems-builder-email-os/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md")"
cmp_ "R4 v1 state dir present (out of population)" "2" "$(cnt "$R/projects/axcion-systems-builder-email-os/logs/loop")"

echo "-- Row 5: ai-resources v2 Codex skill -> RELEVANT"
cmp_ "R5 plan-dependent duty lines" "65 73 79 85" \
     "$(command grep -n 'approved plan' "$R/ai-resources/.agents/skills/work-loop-v2/SKILL.md" | cut -d: -f1 | tr '\n' ' ' | sed 's/ $//')"
cmp_ "R5 orientation duty line"     "81" \
     "$(command grep -n 'governing plan' "$R/ai-resources/.agents/skills/work-loop-v2/SKILL.md" | cut -d: -f1)"

echo "-- Row 6: axcion-systems-builder v2 Codex skill -> RELEVANT"
cmp_ "R6 skill dir is a symlink"    "../../../../ai-resources/.agents/skills/work-loop-v2" \
     "$(readlink "$R/projects/axcion-systems-builder/.agents/skills/work-loop-v2")"

echo
echo "== 5. Out-of-population rows: 8 v1 paths, no relevance verdict =="
cmp_ "v1 paths in the scan" "8" "$(printf '%s\n' "$ALL" | while IFS= read -r p; do i=$(ino "$p"); \
     { [ "$i" = "$C_V1CMD" ] || [ "$i" = "$C_V1SKL" ] || [ "$i" = "$C_V1DOC" ]; } && echo x; done | grep -c x)"
cmp_ "v1 command authors its own brief (§4.2 basis)" "41" \
     "$(command grep -n 'compose the brief yourself' "$R/ai-resources/.claude/commands/work-loop.md" | cut -d: -f1)"

echo
[ "$FAILED" = 0 ] && echo "ALL CHECKS PASSED — the record is reproducible." \
                  || echo "ONE OR MORE CHECKS FAILED — the record does not match the repository."
exit "$FAILED"
```

Expected result on an unchanged repository: **26 PASS, 0 FAIL, exit 0** — which is what it produced when
run on 2026-08-04.

### 6.2 Confirm the O-3 reading

Confirm that **reading A** — "the v0.2 entry protocol only" — is the reading you chose, accepting the
consequence § 3 states: Work Loop v1 stays outside the adoption boundary, plan-dependent work can still
continue through it without Context Engineering, and that narrowing goes into the adoption record rather
than being left implied.

---

*Produced by `/work-loop-v2`, task `context-engineering-s8a-entrypoint-classification`, 2026-08-04;
corrected once against Codex's assessment the same day. This record classifies entrypoints. It wires
nothing, decides no retirement, does not reopen O-3, and makes no adoption claim.*
