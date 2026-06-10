# Worked Example — Technical Solution Selection Memo

A compact, filled example showing what a *good* memo looks like — a real weighted matrix, real disqualification reasons, a real red-team. This is calibration, not a rule: a different project produces a different shape. The point is the **quality and concreteness**, not these specific tools or scores.

Case: *"I want a credibility-building website for Axcíon — something that makes us look established to prospects we're already talking to. I can't code. Small budget. I'd like it live in a few weeks."*

---

### 1. Objective
Give Axcíon a credible, professional web presence that reassures prospects already in conversation — a trust signal, not a lead engine.

### 2. Decision criteria (weighted, 1–5)
| Criterion | Weight | Why this weight |
|---|---|---|
| Time-to-live | 5 | Operator wants it live in weeks |
| Maintenance by a non-developer | 5 | No coding ability; must self-serve edits |
| Visual credibility ceiling | 4 | The whole purpose is "look established" |
| Cost (setup + ongoing) | 3 | Small budget, but trust matters more than saving $20/mo |
| Scalability headroom | 2 | Presentational site; growth need is low now |

### 3. Confirmed / Assumed / Unknown
- **Confirmed:** non-developer operator; small budget; few-week timeline; purpose is credibility, not lead capture.
- **Assumed (condition):** content (copy, logo, a few images) can be ready in ~1 week — *holds if the operator has or can quickly produce brand assets.*
- **Unknown:** whether a contact form / light lead capture is wanted later (decision-relevant for tool headroom, not for v1).

### 4. Viable solution categories
- **Solution models:** (a) single landing page, (b) small multi-page marketing site, (c) full CMS site.
- **Implementation paths:** manual baseline (a polished one-pager on a free host) · no-code builder · custom code · freelancer.
- **Manual baseline:** a single well-designed page on Carrd or a Notion-public page. Zero build cost, live in a day.

### 5. Shortlisted options
1. **Manual baseline** — Carrd one-pager.
2. **Framer** — design-led no-code multi-page site.
3. **Webflow** — higher-ceiling no-code CMS site.
4. **WordPress (managed)** — CMS site on managed hosting.

### 6. Decision matrix (weighted totals)
| Option | Time(5) | Maint(5) | Credibility(4) | Cost(3) | Scale(2) | **Total** |
|---|---|---|---|---|---|---|
| Carrd baseline | 5 | 5 | 2 | 5 | 1 | **69** |
| **Framer** | 4 | 4 | 5 | 4 | 3 | **78** |
| Webflow | 3 | 3 | 5 | 3 | 4 | **67** |
| WordPress | 2 | 2 | 3 | 3 | 4 | **49** |

*(Total = Σ score×weight.)*

### 7. Option-by-option trade-offs
- **Carrd:** wins on speed/cost; loses on credibility ceiling — reads as "a one-pager," which undercuts "established."
- **Framer:** strong credibility at a non-developer-friendly cost; modest learning curve; weak only if deep CMS structure is later needed.
- **Webflow:** higher ceiling but more to learn and maintain — pays off only past a handful of pages.
- **WordPress:** maintenance burden (updates, security) is wrong for a non-developer unless fully managed.

### 8. Disqualified options
- **Custom code (Next.js):** *overbuilds the requirement* — a presentational site doesn't justify code, cost, and key-person risk.
- **WordPress:** *maintenance burden too high for a non-developer.*
- **Webflow (for now):** *wrong project stage* — its CMS power isn't needed for a few credibility pages; revisit if the site grows.

### 9. Recommendation
**Framer**, multi-page, built by the operator. Highest weighted score, clears every must-have (time, maintenance, credibility) and loses only on scalability — which is weight-2 here.

### 10. Why it wins
Tops the two weight-5 criteria adequately *and* the weight-4 credibility criterion outright — the project's whole reason for existing. The only option that doesn't force a trade against a must-have.

### 11. Why it might be wrong (red-team)
- If the operator's design taste is limited, Framer's freedom can produce a *less* credible site than a constrained template would — the tool doesn't guarantee the outcome.
- If brand assets aren't actually ready (Assumption in §3 is false), the few-week timeline slips regardless of tool.
- If lead capture and structured content become priorities sooner than expected, Framer's lighter CMS could force an earlier migration — making Webflow the better first choice.

### 12. Runner-up + when it would win
**Webflow** — wins if the site is expected to grow past a handful of pages or needs structured/CMS content within months; its higher ceiling then justifies the steeper learning curve.

### 13. MVP vs. later architecture
- **v1 (MVP):** 3–4 Framer pages (home, about, services, contact). Contact is a **manual `mailto:` link in v1** — no form backend.
- **Later:** add a real form → Airtable if lead capture becomes a goal; add case-study pages as content matures.

### 14. Next-step execution plan
1. Confirm brand assets are ready (resolves the §3 assumption).
2. Pick a Framer template matching the desired register.
3. Proceed to Stage 4 (spec) for the 4-page structure + acceptance criteria, or stop here and hand the operator a Framer build prompt.
