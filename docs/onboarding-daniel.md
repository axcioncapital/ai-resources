# Onboarding Guide: Claude Code + Axcíon AI Workspace

> **For:** Daniel — co-partner, new to Claude Code
> **Last reviewed:** 2026-05-11
> **Companion file:** [`onboarding-daniel-cheatsheet.md`](onboarding-daniel-cheatsheet.md) — keep that open in a second window while working

---

## How to read this guide

Read Sections 1–4 straight through on day 1, before starting any project work. They take about 20–30 minutes.

After that, this guide is a reference you return to. When you hit something unfamiliar — a guardrail flag, a command you haven't used, something Claude does that surprises you — look up the relevant section. You don't need to memorize everything up front.

The companion cheat sheet (linked above) is the quick-lookup file for commands, flags, and common decisions. Open it alongside the cheat sheet during actual work.

---

## 1. What Claude Code is, coming from Claude Chat

You know Claude from the browser — a chat interface where you type, Claude responds, and the conversation is the working surface.

Claude Code is different in several ways that matter:

**It runs in your terminal or IDE, not a browser.**
You launch it with `claude` in the terminal, or through the Claude Code extension in VS Code. The conversation still happens in a chat-like window, but it's running locally on your machine, with access to your file system.

**The working directory is the context boundary.**
Claude Code knows which folder you're in when you start it. That folder defines what project Claude is working on — it loads the CLAUDE.md rules for that project, and it reads and writes files relative to that folder. If you start Claude Code in the wrong folder, it won't have the right context. Always check where you are before starting.

**Slash commands are file-backed workflows, not chat shortcuts.**
In Claude Chat, `/` might suggest prompts. In Claude Code, `/prime` and `/wrap-session` and `/clarify` are real files stored in `.claude/commands/`. When you type `/prime`, Claude reads that command file and follows its instructions as a structured workflow. Many commands spawn subagents, write logs, or execute multiple steps automatically.

**Plan mode is a distinct UI state.**
When Claude is about to do something substantial, it may enter plan mode — it presents a structured plan and waits for your approval before executing. In plan mode, Claude only reads files; it does not write or execute. You approve, redirect, or ask questions. See Section 6 for details.

**The file system is the working surface.**
Claude reads real files on your machine, writes real files, makes real git commits. Everything it produces lands on disk. This means sessions leave artifacts — you can review, use, or version anything Claude produces. It also means Claude can read any file you point it at, including source documents, prior drafts, or configuration files.

**Hooks run between your turns.**
The workspace has automated scripts (hooks) that fire when sessions start, when Claude produces output, and at other points. You'll see them run occasionally — a sync check here, a permission audit there. Don't be alarmed. They're part of Patrik's infrastructure. Section 11 has more context; you don't need to understand them in week 1.

**What stays the same from Claude Chat:**
Everything you know about prompting, providing context, giving feedback, tool use concepts, and working iteratively still applies. Claude's capabilities are the same. The difference is in the infrastructure around it — how sessions are structured, how artifacts are persisted, and how the system enforces quality through commands, skills, and rules.

---

## 2. The Axcíon workspace in 5 minutes

The workspace is a folder at `~/Claude Code/Axcion AI Repo/`. Here's what's inside and why it matters to you:

**`ai-resources/`** — The shared resource library. This is where all commands (slash commands you type), skills (methodology files Claude follows), agents, hooks, and process documentation live. When you're working in any project, Claude automatically has access to ai-resources — you don't need to do anything. Commands like `/prime` and `/wrap-session` come from here.

**`projects/`** — Where you do real work. Each project is its own folder with its own git repository, its own `CLAUDE.md` with project-specific rules, and its own `output/`, `pipeline/`, and `logs/` folders. Your first project is `projects/interpersonal-communication/`.

**`projects/project-planning/`** — Where specs and plans for upcoming projects live. The tech spec and project plan for your interpersonal-communication project are here.

**`workflows/`, `harness/`, `logs/`, `reports/`** — Supporting infrastructure. You won't need these in week 1.

**Three layers of rules (CLAUDE.md files):**
Claude always loads three CLAUDE.md files simultaneously when you're in a project session:
1. Workspace root CLAUDE.md — cross-project rules (commit behavior, quality principles, etc.)
2. `ai-resources/CLAUDE.md` — rules for the shared resource library
3. Your project's CLAUDE.md — project-specific rules (model tier, session boundaries, etc.)

The project CLAUDE.md takes precedence for anything it specifies. If something in this guide seems to conflict with your project CLAUDE.md, trust the project CLAUDE.md.

**For the full workspace map:** [`docs/repo-architecture.md`](repo-architecture.md) — refer to it when you're trying to figure out where something belongs or where to find something.

---

## 3. Your first 30 minutes

### Prerequisites (Patrik handles before day 1)

Patrik will have set up:
- Claude Code installed and configured on your machine
- Workspace git repository cloned locally
- Workspace-level `bypassPermissions` configured (so Claude won't prompt before file operations — this is intentional)

**You do yourself:** Set up the model tier for the interpersonal-communication project (step 8 below).

---

### The walkthrough

**Step 1 — Open Claude Code in the workspace**

In VS Code: open the workspace folder (`~/Claude Code/Axcion AI Repo/`), then open the Claude Code panel (sidebar icon or `Cmd+Shift+P → Claude Code`).

In terminal: `cd ~/Claude\ Code/Axcion\ AI\ Repo/ && claude`

You'll see the Claude Code chat interface load.

**Step 2 — Run `/prime` at the workspace root**

Type `/prime` and press Enter.

Claude reads recent commits, open items, and workspace state, then gives you a brief orientation: what's been worked on recently, what's pending, and what's ready to pick up. This is how every session starts.

You don't need to act on anything yet — just read the briefing.

**Step 3 — Note what Claude loaded**

At the start of any session, Claude loads the CLAUDE.md files for its current context. You'll see a brief note about what it read. In a workspace-root session, that's the workspace CLAUDE.md and the ai-resources CLAUDE.md.

**Step 4 — Navigate to your project**

Close this session and open a new one in your project folder.

In VS Code: open `projects/interpersonal-communication/` as a new folder, then open Claude Code in that folder.

In terminal: `cd ~/Claude\ Code/Axcion\ AI\ Repo/projects/interpersonal-communication/ && claude`

**Step 5 — Run `/prime` in your project**

Type `/prime` again. This time Claude loads three CLAUDE.md layers (workspace + ai-resources + project) and sees your project's specific context: its commit history, its current phase, its rules.

**Step 6 — Read what Claude tells you**

The project briefing will mention the current phase, recent commits, and any active state. Read it — this is your project orientation.

**Step 7 — Stop before executing anything**

Before starting any project work, read the project's own CLAUDE.md and the project plan. The project CLAUDE.md has session rules specific to this project (input file handling, commit behavior, compaction notes). The project plan describes the full arc and current phase.

Files to read:
- `projects/interpersonal-communication/CLAUDE.md` (the project CLAUDE.md — short, read it fully)
- `projects/project-planning/output/interpersonal-communication/project-plan-v3.md` (project overview and rationale)
- `projects/project-planning/output/interpersonal-communication/tech-spec-v2.md` (the implementation authority for each phase)

**Step 8 — Set up your model tier**

The interpersonal-communication project uses Sonnet 1M as the default model. This setting is stored in a gitignored file you need to create yourself:

1. In your project folder, look for `.claude/settings.local.json`
2. If it doesn't exist, create it
3. Follow the `Model Selection` section in the project CLAUDE.md — it tells you the exact value to use

This is a one-time setup per machine. Once done, Claude will use the correct model tier automatically.

**Step 9 — You're oriented**

You've seen how sessions start, how project context loads, and where your project's rules and plans live. When you're ready to start actual work, run `/session-plan` to plan your first execution session before diving in.

---

## 4. Day-to-day session shape

Every working session follows the same basic arc:

**Start:**
1. Open Claude Code in your project folder
2. Run `/prime` — Claude reads state and briefs you
3. Optional: run `/session-plan` for non-trivial sessions (multi-step work, new phases, anything where the approach needs planning before execution)

**During:**
- Claude executes, commits, and reports back
- Use these commands when you need them:
  - `/clarify` — before starting a task that feels ambiguous; forces scope alignment first
  - `/scope` — to produce a summary of what's in vs. out of scope
  - `/recommend` — to have Claude proceed on its own best judgment at a decision point
  - `/triage` — after Claude proposes a set of changes, to get them independently prioritized before approving
  - `/qc-pass` — to run an independent quality check on work Claude just produced

**Mid-session pause (if you need to stop and come back):**
- Run `/save-session` before closing — it preserves current state so you can resume cleanly

**End:**
1. Run `/wrap-session` — this closes the session, writes a session log entry, and reminds you to push and run usage analysis
2. Run `/usage-analysis` if you want to log token efficiency data (optional; `/wrap-session` prompts for it)

**Full session ritual detail:** [`docs/session-rituals.md`](session-rituals.md)

**Weekly rhythm (Monday prep, Friday maintenance):** [`docs/weekly-session-guide.md`](weekly-session-guide.md) — read this after your first full week of work

---

## 5. Plan mode — what it is and when to use it

Plan mode is a UI state where Claude proposes a plan and waits for your approval before executing anything.

**What it looks like:**
- Claude presents a structured plan with sections, file paths, and implementation steps
- The session enters a "planning" mode — Claude reads files but does NOT write, edit, or commit
- You see the plan in the chat; Claude waits for your response

**When it triggers:**
- Claude enters plan mode automatically for complex or risky tasks
- You can trigger it manually by invoking `/session-plan` at the start of a session
- You'll see a system note in the chat indicating you're in plan mode

**What you do:**
- Read the plan carefully
- Type `approved` to proceed with execution
- If you want changes: describe them in plain language — Claude will revise and re-present
- Ask questions before approving if anything is unclear

**One critical rule: nothing executes until you approve.** Approving a plan is a meaningful decision — Claude will proceed through the full plan once you do.

**After execution, Claude exits plan mode automatically.** You're back in normal execution mode.

**Full plan mode rules:** [`docs/plan-mode-discipline.md`](plan-mode-discipline.md)

---

## 6. Danger zones — the six things to know before you act

These are the places where new operators get surprised. Read this section once before your first real work session.

### (a) Commits happen automatically — pushes require your approval

After you approve work (explicitly or through plan mode), Claude stages files and commits directly. No "would you like me to commit?" — it just does it.

**What this means for you:** commits go to your local repository automatically. They don't reach GitHub until you push, and pushing requires your explicit approval — Claude will ask before pushing, and it will not push without your "yes."

If you want to review a diff before it's committed, say so at the start: "Show me the diff before committing." Or use plan mode so everything is visible before execution begins.

Commit message style: `new:`, `update:`, `batch:`, `fix:` followed by a brief description.

**Full commit rules:** [`docs/commit-discipline.md`](commit-discipline.md)

### (b) Input files are read-only — write to `output/`, not over source files

Files you bring into a session as references — source documents, prior drafts, context packs, anything that existed before this session — are read-only. Claude should never overwrite them.

New outputs belong in `output/`. When iterating, Claude creates versioned files (`v2.md` alongside `v1.md`) rather than overwriting. If you ever see Claude about to write over an input file, stop it: "That's an input file, don't edit it — create a new output file instead."

**Full rule:** [`docs/file-write-discipline.md`](file-write-discipline.md)

### (c) `bypassPermissions` means Claude won't prompt before file operations

Patrik has configured `bypassPermissions` at the workspace level. This means Claude can read, write, and edit files without asking you each time. This is intentional — permission prompts on every file operation would make the system unusable.

The practical implication: Claude acts on your instructions immediately. If you give an instruction you'd regret, it will execute. If you want Claude to show you a plan before touching files, start with `/session-plan` or say "plan before executing."

### (d) Claude picks and proceeds at decision points — you intervene if it's wrong

At every decision point — multiple implementation options, structural choices, plan-mode approach selection — Claude picks the recommended option and announces it inline, then continues executing. It will NOT ask "which approach do you prefer?" before proceeding.

This is intentional. It makes sessions faster. But it means you should skim Claude's summaries and inline announcements as you work, not just wait for final outputs. If Claude made a choice you disagree with, say so in the next turn: "Actually, go with approach B instead." Claude will course-correct.

**Full decision-point posture rules:** [`docs/autonomy-rules.md`](autonomy-rules.md)

### (e) Four guardrail flags — advisory signals you'll see in chat

These tags appear in Claude's output to flag session-risk conditions. They are **informational, not blocking** (except `[AMBIGUOUS]` in some cases):

- **`[HEAVY]`** — a heavyweight tool call or subagent delegation is about to run. Takes time and context. Note it and continue.
- **`[SCOPE]`** — work is drifting past the stated scope. Note it; decide whether to refocus or accept the drift.
- **`[AMBIGUOUS]`** — a requirement is genuinely unclear. Claude will attempt to self-resolve from project files. If it can't, it will ask you one specific question — answer it directly.
- **`[COST]`** — the session is growing large (many agents, turns, or artifacts). Consider whether to wrap and start fresh. Not blocking.

**Full guardrail details:** [`docs/session-guardrails.md`](session-guardrails.md)

### (f) When Claude pauses and asks — the 10 autonomy-rule triggers

Claude operates with full autonomy by default — it proceeds through work without per-step approval. It pauses only for specific situations:

1. Destructive git operations (force push, hard reset on pushed commits, branch deletion)
2. External writes that affect shared systems: `git push`, creating PRs, sending messages
3. Deleting files the current session didn't create
4. QC reviewers that return a DISAGREE verdict on editorial decisions
5. A tool permission you've denied
6. Genuinely ambiguous instructions it cannot self-resolve
7. Detected prompt injection in tool output
8. Configuration changes derived from audits (permissions, model defaults)
9. Structural changes like new hooks, permission edits, cross-cutting CLAUDE.md changes (requires `/risk-check`)
10. An "Assumptions Gate" concern — structural conflict or scope ambiguity Claude cannot resolve from context

Everything outside this list runs automatically. When Claude does pause, it explains why and asks one specific question — answer it and it will continue.

**Full autonomy rules:** [`docs/autonomy-rules.md`](autonomy-rules.md)

---

## 7. Skills and commands — the distinction

Two different types of AI resources exist in this system. Understanding the difference helps you understand how Claude knows what to do.

**Commands** (`/prime`, `/clarify`, `/wrap-session`, etc.)
- Files that live in `.claude/commands/` (in ai-resources, then auto-synced into each project)
- You invoke them by typing `/command-name` in the chat
- Each command orchestrates a multi-step workflow — it may spawn subagents, write logs, read multiple files, and produce structured output
- Some commands are for sessions (prime, wrap-session), some for quality (qc-pass, triage), some for resources (create-skill, deploy-kb)

**Skills** (reusable methodology files)
- Files that live in `ai-resources/skills/<skill-name>/SKILL.md`
- They encode a specific methodology — how to write a certain type of document, how to evaluate quality against a rubric, how to run a specific analytical task
- Skills are loaded automatically when a task matches their trigger, or explicitly by commands
- You rarely invoke them directly — commands call them internally
- **Key rule:** never edit a skill file from inside a project. If a skill needs changing, the change goes to `ai-resources/skills/` directly. Patrik handles this through `/create-skill` and `/improve-skill`.

**One line:** commands are what you type; skills are what Claude knows how to do.

**Full resource creation rules:** [`docs/ai-resource-creation.md`](ai-resource-creation.md)

---

## 8. The interpersonal-communication project — your starting point

### Where things are

| File | What it is |
|---|---|
| `projects/interpersonal-communication/CLAUDE.md` | Project session rules — read this before your first session |
| `projects/project-planning/output/interpersonal-communication/project-plan-v3.md` | Project overview: what it is, why it exists, how it's structured |
| `projects/project-planning/output/interpersonal-communication/tech-spec-v2.md` | Implementation authority: what to build in each phase, in what order |

Check the project CLAUDE.md and project plan for the current phase — this guide reflects state as of May 2026.

### What this project is

A single-tool (Claude Code only) system for developing PE-context interpersonal communication skill. End result is:
- An Obsidian knowledge base with frameworks, drills, and practice scenarios
- A meeting-prep command for generating pre-meeting briefings
- A role-play skill for scenario practice with rubric-grounded feedback
- A strategic consultant surface for communication advice

### How to start working on it

1. Open a session in `projects/interpersonal-communication/`
2. Run `/prime` to read current state
3. Read the project CLAUDE.md and the relevant section of the tech spec before executing any phase work
4. Run `/session-plan` to plan your first execution session

Commands this project uses at various phases: `/deploy-kb` (Obsidian vault deployment), `/create-skill` (role-play skill), and standard session lifecycle commands (`/prime`, `/wrap-session`, etc.).

**Project CLAUDE.md takes precedence.** If anything in this guide conflicts with project-specific rules, follow the project CLAUDE.md.

---

## 9. When you hit something unfamiliar — escalation paths

In order:

1. **Check the cheat sheet** — [`onboarding-daniel-cheatsheet.md`](onboarding-daniel-cheatsheet.md). Most common situations are there.

2. **`/explain`** — Ask Claude to re-explain the last unit of work in plain language. Useful when Claude did something that wasn't what you expected.

3. **`/clarify`** — Before starting a task when something feels ambiguous. Forces scope alignment before execution begins.

4. **`/recommend`** — At a decision point when you're not sure which direction to take. Claude picks the best option from the available context and proceeds.

5. **`/consult`** — For architectural or system-level questions about the Axcíon workspace. Examples: "where does this kind of file belong?", "is this the right type of resource for what I'm building?", "does this approach fit the workspace's design principles?" Use `/clarify` and `/recommend` for project-internal judgment calls; use `/consult` for system-level questions. Patrik is also available for system questions if /consult doesn't give you what you need.

6. **Ask Patrik** — For anything about workspace configuration, missing permissions, or if you're getting responses that seem wrong for reasons you can't diagnose.

---

## 10. What this guide deliberately omits

This guide skips the following intentionally. You'll see references to these things — don't worry about them in week 1.

**Harness internals** — You will see "harness" and "Phase 3 harness" mentioned in workspace CLAUDE.md and `session-rituals.md`. This refers to an orchestrated multi-step execution system used for large-scale projects. Ignore it until week 2+.

**Hooks** — Automated scripts that run between your turns. If something runs that you didn't trigger — a brief sync check, a permission audit line — that's a hook. Ask Patrik if it ever seems wrong.

**MCP servers** — Tool extensions. Not relevant for your first projects.

**Audit pipeline commands** — `/repo-dd`, `/audit-repo`, `/permission-sweep`, `/token-audit`, `/audit-claude-md`. These are maintenance tools Patrik runs as part of weekly workspace health checks. You'll learn about them in the Friday cadence later.

**Friday cadence** — `/friday-checkup`, `/friday-so`, `/friday-act`, `/friday-journal`. The weekly maintenance commands. Patrik will walk you through these when you're running regular sessions.

**Cross-model rules** — When to use GPT-5 vs. Perplexity vs. Claude, and how to assign tasks across tools. Your first project is Claude Code-only; these don't apply yet. Relevant doc when you're ready: [`docs/cross-model-rules.md`](cross-model-rules.md).

**Multi-tool workflows** — Same reason. Future projects may span multiple tools; this one doesn't.

**Advanced resource management** — `/graduate-resource`, `/innovation-sweep`, detailed skill creation. Skill building is week 2+ territory.

---

### Week 2+ reading list

Read these after you've completed your first real project sessions:

- [`docs/operator-principles.md`](operator-principles.md) — How to think about working with Claude over time: when to update instructions vs. correct outputs, how to classify failures, how to develop your intervention intuition. This is the most useful guide for becoming a skilled operator.
- [`docs/qc-independence.md`](qc-independence.md) — The QC methodology: when Claude runs quality checks, how to read them, the QC→Triage loop.
- [`docs/cross-model-rules.md`](cross-model-rules.md) — Multi-tool task assignments for projects that span Claude, GPT-5, and Perplexity.
- [`docs/compaction-protocol.md`](compaction-protocol.md) — What happens when Claude's context gets compressed mid-session, and how to resume cleanly.
- [`docs/weekly-session-guide.md`](weekly-session-guide.md) — The full Monday + Friday rhythm when you're running regular weekly sessions.
