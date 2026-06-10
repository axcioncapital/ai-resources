# Tool-Selection Heuristics

> **Tool landscape current as of 2026-06.** Named products (Framer, Webflow, Zapier, Make, Clay, Lovable, Bolt, v0, Cursor, etc.) move fast — re-verify positioning at each `/improve-skill` pass. The *decision tests* at the bottom are durable; the product specifics are the volatile part.

Practical working judgment for the consultant — *when to use what*, not tool catalogs. Claude already knows what these tools are; what follows is the decision-relevant judgment about when each earns its place and when it becomes a liability. Use these as priors, not rules — the weighted criteria in the memo still decide.

Governing bias to counter: **defaulting to fashionable or familiar tools instead of the right path.** Every heuristic below exists to resist that pull. The manual/lightweight baseline (§ below) is the antidote — always price it first.

---

## The manual / lightweight baseline (always price this first)
Before any tool, ask: *what's the simplest version of this that a person could run by hand for the first few weeks?* A spreadsheet, a shared doc, a manual email, a Calendly link. The baseline often wins for v1 because it has zero build cost, zero maintenance, and surfaces the real requirements before you commit to a stack. Recommend automation only when the manual version is demonstrably the bottleneck.

## Websites
- **Framer** — fastest path to a credible, design-led marketing site; good when the operator wants visual control without code and the site is mostly presentational. Weakens when you need deep CMS structure or complex integrations.
- **Webflow** — higher quality ceiling and real CMS power; pays off when the site grows past a few pages or needs structured content. Costs more learning time; overkill for a 3-page credibility site.
- **WordPress** — choose for content-heavy/blog-first sites or when a specific plugin ecosystem is required. Carries the most maintenance burden (updates, security) — a poor fit for a non-developer unless managed-hosted.
- **Custom code (Next.js etc.)** — only when the site is really an app, or differentiation genuinely requires it. For a marketing site it usually overbuilds the requirement.
- **Landing-page tools (Carrd, etc.)** — right for a single-purpose page or a fast validation test.

## Dashboards & internal data
- **Sheets / Airtable / Notion** — Sheets is the baseline; it turns fragile when multiple people edit concurrently, when relations between tables matter, or past a few thousand rows. Move to **Airtable** when you need real relational structure, views, and form intake; to **Notion** when the data is documents-plus-light-structure and lives next to knowledge/notes.
- **Looker Studio / Power BI** — reach for these only when there's a real reporting need over a real data source. Before that, a well-built Airtable/Sheets view is cheaper and good enough.
- **Custom web app** — last resort; justified only when no-code tools demonstrably cannot model the workflow.

## Automation
- **Zapier** — simplest, best for linear "when X, do Y" flows across mainstream apps. Costs rise with volume and multi-step zaps.
- **Make** — choose when the flow branches, loops, or needs data transformation Zapier handles awkwardly; steeper but more powerful.
- **Clay** — specialized for data enrichment / lead workflows.
- **Caution:** automation adds a failure surface (silent breakage, debugging burden on a non-developer). Automate a process only after it's stable and manually proven. An automation that breaks quietly is worse than a manual step that's visibly done.

## AI / code builders
- **Claude Code / Cursor** — earn their place when the work is genuinely code (custom logic, scripts, real apps, repo-scale changes). Not the right tool for a marketing site a no-code platform builds faster.
- **Replit / Lovable / Bolt / v0** — fast for prototypes and validation; weigh the migration cost before treating their output as production.
- **When NOT to custom-code:** if a no-code tool meets the requirement with acceptable trade-offs, custom code usually adds cost, maintenance, and key-person risk without proportional value for a non-developer operator.

## CRM / forms / email
- Start with the lightest tool that holds the data (a form → Airtable/Sheets, a simple email sequence) and graduate to a dedicated CRM only when pipeline volume or multi-stage follow-up justifies it.

---

## Recurring decision tests
- **Fragility test:** at what scale/usage does this break? If the answer is "soon," the simpler tool is a false economy.
- **Maintenance test:** who maintains this, and can a non-developer do it? Burden that lands on the operator is a real cost, weighted in the matrix.
- **Lock-in test:** how expensive is leaving? Higher lock-in needs a stronger reason.
- **Reversibility test:** if this choice is wrong, how cheaply can we change course? Favor reversible choices early, commit harder later.
