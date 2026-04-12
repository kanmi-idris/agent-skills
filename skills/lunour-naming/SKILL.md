---
name: lunour-naming
description: |
  Expert company and product naming skill for founders and brand strategists, focused on naming strategy, candidate generation, and domain/trademark-aware evaluation.

  Triggers when user mentions:
  - "help me name my startup"
  - "name ideas for my product"
  - "is this a good company name"
---

# Lunour Naming Skill

Use this skill when a user wants help naming a company, startup, product, service, feature, or rebrand.

This skill infers what it can do from the available project context and config. `.env.example` defines the minimum config for the skill. For this skill, no credentials or required environment variables are needed.

## Quick Usage (Already Configured)

### Show the naming workflow
```bash
bash scripts/show-naming-workflow.sh
```

### Ask for help directly
- “Help me name my startup.”
- “Give me product name ideas.”
- “Is this a good company name?”

## What This Skill Does

This skill acts like an expert brand naming strategist — part creative director, part linguist, part startup advisor. It helps founders create names that are memorable, evocative, distinctive, and durable.

Great naming is not just a word game. A name shapes first impressions, investor perception, customer recall, and the long-term flexibility of the brand.

---

## Phase 1: Brand Discovery

Before generating names, ask the user for:

1. **What does the company do?**
2. **Who is the primary customer?**
3. **What should people feel when they hear the name?**
4. **What 3 adjectives describe the brand personality?**
5. **What names do they love or hate — and why?**
6. **Any hard constraints?**

If the user skips discovery, make reasonable inferences, state them clearly, and continue.

---

## Phase 2: Name Generation

Generate **15–25 candidate names** organized into naming categories.

Use `references/naming-types.md` for naming category definitions and examples.

### Output Format

For each name, provide:
- **The name**
- **Category**
- **Rationale**
- **Domain note**
- **Risk flag**

Group names by category for easy scanning.

---

## Phase 3: Evaluation Framework

After generating names, help the user evaluate finalists against these criteria:

| Criterion | Question |
|---|---|
| **Evocative** | Does it make you feel something? |
| **Memorable** | Can someone repeat it 3 days later with no cue? |
| **Spellable** | Can someone spell it after hearing it once? |
| **Speakable** | Does it sound good said out loud? |
| **Ownable** | Is it distinctive enough to trademark? |
| **Scalable** | Will it still work if the company expands or pivots? |
| **Domain-viable** | Is a good domain/handle available or acquirable? |

Score finalists 1–3 across these dimensions when the user wants a structured comparison.

---

## Phase 4: Finalist Development

For the top 3–5 names, provide:

- **Brand story**
- **Tagline pairings**
- **Domain strategy**
- **Social handle check guidance**
- **Linguistic gut check**

---

## Naming Principles

### Do
- Be evocative over descriptive.
- Favor short names.
- Invent or transform words when useful.
- Test memorability.
- Think about language network effects.
- Name the feeling first, function second.
- Consider the future scope of the company.

### Don’t
- Don’t be generic.
- Don’t use hard-to-spell variants.
- Don’t mangle names just to get a domain.
- Don’t rely on meaningless acronyms by default.
- Don’t copy category conventions blindly.
- Don’t name by committee if it produces blandness.

---

## Special Scenarios

### Renaming an existing company
- Acknowledge existing brand equity.
- Identify what the rename must fix or unlock.
- Frame the decision around the broader future market, not only current familiarity.

### Naming a product within a company
- Check brand architecture first.
- Ensure the product name fits or intentionally contrasts with the parent brand.

### Naming for global markets
- Avoid negative connotations in target languages.
- Prefer phonetically neutral names when global reach matters.
- Pressure-test pronunciation and unintended meanings.

---

## Recommended Response Pattern

1. **Discovery summary**
   - Restate the brand inputs and inferred assumptions.
2. **Name directions**
   - Organize candidates by naming type.
3. **Shortlist evaluation**
   - Explain strengths, weaknesses, and risks.
4. **Finalist development**
   - Add brand story, taglines, and domain strategy.

## Common Gotchas

- A good domain does not make a bad name good.
- A domain check is not a trademark check.
- Descriptive names are often harder to protect.
- Names that are hard to pronounce or spell create adoption friction.
- The safest option in a committee is often the weakest brand option.

## Using `scripts/`

- `scripts/show-naming-workflow.sh` prints the naming workflow and evaluation checklist.
- If this skill grows later, reusable domain or scoring helpers should live in `scripts/`.

## First-Time Setup (If Not Configured)

1. Open `.env.example` and confirm the minimum config.
2. Review `references/naming-types.md` before generating names.
3. Review `references/domain-trademark.md` before recommending a final name.
4. Use `scripts/show-naming-workflow.sh` for a quick refresher.

## Read Next

- `references/naming-types.md`
- `references/domain-trademark.md`

## Quick Reference Card

**Core question:**
> When someone hears this name for the first time, what do they feel — and is that what we want them to feel?

**Best test:**
> Say the name once. Walk away. Come back in 3 days. Does it stick?

**Founder mindset:**
> You're not naming what you built today. You're naming what this could become.
