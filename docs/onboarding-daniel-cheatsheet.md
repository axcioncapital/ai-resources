# Claude Code + Axcíon AI — Quick Reference

> **For:** Daniel | **Last reviewed:** 2026-05-11
> **Full guide:** [`onboarding-daniel.md`](onboarding-daniel.md)

---

## Commands — week 1–4 reference

### Session lifecycle

| Command | Purpose | When to fire |
|---|---|---|
| `/prime` | Read workspace state; brief you; wait for direction | First thing every session |
| `/session-plan` | Plan the session (approach, model tier, risk flags) before execution | Non-trivial sessions; new phases; anything complex |
| `/save-session` | Checkpoint mid-session state before a break or `/compact` | Before pausing mid-session |
| `/wrap-session` | Clean session close: log, commit final work, prompt for push | Last thing every session |

### Judgment and clarity

| Command | Purpose | When to fire |
|---|---|---|
| `/clarify` | Resolve ambiguous requirements before starting work | When a task feels unclear; before executing anything large |
| `/scope` | Produce a scope summary (in vs. out, deliverables locked) | Before execution on a multi-step task |
| `/recommend` | Have Claude proceed on its own best judgment | At a decision point when you want Claude to pick and continue |
| `/explain` | Plain-language re-explanation of the last unit of work | When Claude did something unexpected or unclear |
| `/consult` | Architectural/system questions about the Axcíon workspace | "Where does this file belong?", "Is this the right resource type?" |

### Quality

| Command | Purpose | When to fire |
|---|---|---|
| `/qc-pass` | Independent quality check on work just produced | After any significant creation or edit |
| `/triage` | Prioritize a set of proposed changes or QC findings | After Claude proposes changes or after `/qc-pass` |
| `/refinement-pass` | Independent refinement review (after QC passes) | When you want a deeper review beyond QC |
| `/resolve` | Translate QC findings into fix recommendations | After `/qc-pass` returns findings |

### Project work

| Command | Purpose | When to fire |
|---|---|---|
| `/open-items` | Scan project for unresolved items; produce a backlog | When you want to see what's pending |
| `/session-guide` | Generate a progress view for a project | To orient a new session or see where the project stands |
| `/update-claude-md` | Add or update a rule in CLAUDE.md | When you want to make a session behavior permanent |
| `/risk-check` | Evaluate a proposed structural change across 5 risk dimensions | Before hooks, permission changes, new commands or skills, cross-cutting edits |

### Project-specific (interpersonal-communication)

| Command | Purpose | When to fire |
|---|---|---|
| `/deploy-kb` | Deploy an Obsidian knowledge base vault | Phase where KB is deployed |
| `/create-skill` | Build a new skill through the canonical pipeline | Phase where role-play skill is built |
| `/request-skill` | File a skill request brief to ai-resources inbox | When you identify a skill gap mid-project |

### Logging

| Command | Purpose | When to fire |
|---|---|---|
| `/friction-log` | Log a workflow friction event | When something is slow, awkward, or broken |
| `/note` | Log a workflow observation | Any passing observation worth capturing |
| `/usage-analysis` | Log session token efficiency telemetry | End of substantive sessions (auto-prompted by `/wrap-session`) |

### Week 2+ commands (skip for now)

`/improve-skill`, `/migrate-skill`, `/graduate-resource`, `/innovation-sweep`, `/friday-checkup`, `/friday-so`, `/friday-act`, `/friday-journal`, `/repo-dd`, `/audit-repo`, `/permission-sweep`, `/token-audit`, `/audit-claude-md`, `/coach`, `/improve`

---

## The four guardrail flags

| Flag | Meaning | What to do |
|---|---|---|
| `[HEAVY]` | Heavy tool call or subagent delegation about to run | Note it; continue |
| `[SCOPE]` | Work drifting past stated scope | Decide: refocus or accept drift |
| `[AMBIGUOUS]` | Requirement unclear; Claude attempting self-resolution | If Claude asks a question, answer it directly |
| `[COST]` | Session growing large (many agents, turns, artifacts) | Consider wrapping and starting fresh |

---

## "I'm about to..." — decision table

| Situation | What happens | What you do |
|---|---|---|
| **Claude finishes approved work** | Commits automatically to local repo (no prompt) | Review inline summary; it's committed |
| **Push to GitHub** | Claude will STOP and ask for explicit approval | Say "yes push" or similar to approve |
| **Delete a file** | Claude pauses for confirmation on files it didn't create | Approve or say "don't delete that" |
| **Approve a plan in plan mode** | Nothing executes until you approve | Read carefully, then type `approved` |
| **Autonomy gate triggered** | Claude stops and explains the specific blocker | Answer the specific question asked |
| **Something runs between turns** | A hook fired (automated script) | Normal behavior; ask Patrik if it seems wrong |

---

## Key file paths — interpersonal-communication project

| What | Path |
|---|---|
| Project session rules (read first) | `projects/interpersonal-communication/CLAUDE.md` |
| Model tier setup (you create this) | `projects/interpersonal-communication/.claude/settings.local.json` |
| Your outputs go here | `projects/interpersonal-communication/output/` |
| Implementation authority | `projects/project-planning/output/interpersonal-communication/tech-spec-v2.md` |
| Project overview and rationale | `projects/project-planning/output/interpersonal-communication/project-plan-v3.md` |

---

## Process docs — load on demand

| Doc | When you need it |
|---|---|
| [`docs/session-rituals.md`](session-rituals.md) | Full session start/end checklist |
| [`docs/autonomy-rules.md`](autonomy-rules.md) | Full list of when Claude pauses |
| [`docs/session-guardrails.md`](session-guardrails.md) | Full guardrail flag details |
| [`docs/plan-mode-discipline.md`](plan-mode-discipline.md) | Plan mode full mechanics |
| [`docs/commit-discipline.md`](commit-discipline.md) | Commit and push rules |
| [`docs/file-write-discipline.md`](file-write-discipline.md) | Input file read-only rules |
| [`docs/repo-architecture.md`](repo-architecture.md) | Full workspace map and file placement rules |
| [`docs/ai-resource-creation.md`](ai-resource-creation.md) | How skills and commands are created |
