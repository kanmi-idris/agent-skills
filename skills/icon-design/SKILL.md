---
name: icon-design
description: |
  Selects the best UI icon for a use case, reviews iconography for clarity,
  designs coherent icon families, and produces technical icon schematics plus
  production-ready SVG guidance. Use this when the user asks which icon fits a
  feature, wants to review or critique an icon, needs a custom SVG icon, wants
  help brainstorming icon metaphors, or needs rules for an icon set or
  iconography system.

  Triggers when user mentions:
  - "which icon should I use"
  - "what icon should I use"
  - "pick an icon"
  - "best icon for"
  - "design an icon"
  - "create an SVG icon"
  - "icon metaphor"
  - "review this icon"
  - "icon set"
  - "icon system"
  - "iconography"
---

# Icon Design

Use this skill for UI, product, and system iconography work.

This skill infers what it can do from the available project context and config. `.env.example` defines the minimum config for the skill. For this skill, no credentials or required environment variables are needed.

## Quick Usage (Already Configured)

### Show the icon workflow
```bash
bash scripts/show-icon-workflow.sh
```

### Ask for help directly
- “Which icon should I use for this feature?”
- “Review this icon.”
- “Create an SVG icon.”

## When to Use This Skill

Activate this skill when the user:

- asks which icon fits a feature, action, status, or navigation item
- asks you to critique or compare existing icons
- asks for a custom SVG icon or icon spec
- wants help brainstorming icon metaphors
- needs to extend or define an icon family, icon set, or iconography system
- uses phrases like "best icon for", "pick an icon", "design an icon", "create an SVG icon", "icon set", or "iconography"

This skill is for:
- choosing the right icon for a use case
- reviewing whether an existing icon is clear
- brainstorming safer icon metaphors
- designing custom icons before drawing them
- producing clean SVG implementation guidance
- defining a coherent icon family or icon system

This skill is not for:
- logos
- mascots
- illustrations
- large marketing graphics

## Operating Doctrine: "Iconography God" Mode

Always follow these rules:

1. **Recognizability before novelty**
   - Prefer established metaphors unless there is a strong reason not to.
   - Do not reward cleverness if comprehension drops.

2. **Context before form**
   - Ask what the icon means, where it appears, and what sits beside it.
   - Distinguish object, action, state, navigation, and brand-specific symbol.

3. **Explain the reasoning**
   - Say why a metaphor works, what it may be confused with, and when a label is needed.

4. **Default technical system**
   - Default to a `24×24` canvas.
   - Default to a `20×20` live area with `2px` outer padding.
   - Default to a centered `2px` stroke unless a different family rule is justified.

5. **Consistency is a system requirement**
   - Match grid, stroke, radius, terminals, angle language, and visual weight across the family.

6. **One dominant idea**
   - Prefer one dominant metaphor plus, at most, one secondary cue.
   - Avoid stacking many concepts into one small icon.

7. **Text beats ambiguity**
   - If the icon is abstract, overloaded, risky, or culturally unstable, recommend visible text.
   - Tooltips are supplemental, not a substitute for clarity.

8. **Small-size truth matters**
   - Judge at realistic sizes like `24`, `20`, and `16`, not only while zoomed in.

## Request Types

Classify the task first:

1. **Selection / review**
   - "Which icon should I use?"
   - "Does this icon work here?"

2. **Custom icon design**
   - "Design an icon for this feature"
   - "Create an SVG icon"

3. **Icon family / system design**
   - "Create a consistent icon set"
   - "Define our iconography rules"

## Workflow

1. **Clarify intent**
   - Start with `reference/intake-and-questions.md`.
   - If meaning or context is still fuzzy, ask targeted questions before drawing.
   - Do not jump into SVG just because the user asked for an icon.

2. **Choose the right path**
   - Selection or critique: use `reference/icon-selection-framework.md`
   - Metaphor generation: use `reference/metaphor-brainstorming.md`
   - Family rules: use `reference/icon-system-rules.md`
   - SVG output: use `reference/svg-production-rules.md`
   - Final review: use `reference/qa-checklist.md`

3. **Recommend before rendering**
   - When ambiguity is high, recommend the concept first.
   - Only jump straight to SVG when the brief is clear enough.

4. **Produce the deliverable**
   - For custom icons, use `templates/technical-schematic-template.md`.
   - For system work, define family rules before proposing individual icons.

## Fast Triage

Use this decision rule immediately:

- If the user asks **"which icon should I use"**, do **selection / review** first.
- If the user asks **"design"** or **"create"** but context is unclear, ask questions before drawing.
- If the user asks for an **icon set** or **system**, define family rules before proposing individual icons.
- If the concept is **abstract or overloaded**, recommend icon + label unless the context is exceptionally narrow.

5. **End with QA**
   - Run a meaning, confusion, small-size, accessibility, and consistency check.

## Output Contracts

### 1) Selection / Review

Structure the answer like this:

- **Meaning and context**
- **Best candidate(s)**
- **Recommended icon**
- **Why it wins**
- **Likely confusion risks**
- **Should this use a visible label?**
- **Accessibility / implementation note**

### 2) Custom Icon Design

Structure the answer like this:

- **Clarifying questions** (if still needed)
- **Recommended metaphor**
- **Rejected alternatives**
- **Technical schematic**
- **SVG code or implementation guidance**
- **QA notes**

### 3) Icon Family / System

Structure the answer like this:

- **System brief**
- **Default geometry and style tokens**
- **Icon grammar**
- **Badge / modifier rules**
- **Priority icon list**
- **QA plan**

## Guardrails

- Do not pick icons based on aesthetics alone.
- Do not assume "universal" comprehension for abstract concepts.
- Do not mix filled and outline styles unless the brief explicitly allows a dual family.
- Do not use color alone to communicate critical meaning.
- Do not overfit to one platform if the icon must work across platforms.
- Do not output a bespoke SVG when an existing system icon already solves the problem well.

## Strong Recommendations

- Prefer existing library icons when they are clear and already consistent with the product.
- Recommend icon + label for concepts like export, automation, trust, AI, sync modes, compliance, billing states, or admin-only actions unless context is extremely narrow.
- For destructive, financial, medical, legal, or irreversible actions, bias toward text-supported UI.
- If a concept is too nuanced for icon-only treatment, say so plainly.

## Reference Map

- `reference/intake-and-questions.md`
- `reference/icon-selection-framework.md`
- `reference/metaphor-brainstorming.md`
- `reference/icon-system-rules.md`
- `reference/svg-production-rules.md`
- `reference/qa-checklist.md`
- `templates/technical-schematic-template.md`
- `examples/chat-review.md`
- `examples/custom-svg-request.md`
- `examples/icon-family-brief.md`
- `examples/icon-critique.md`
- `examples/abstract-concept-needs-label.md`
- `examples/icon-comparison.md`
- `examples/state-icon-svg.md`

## Using `scripts/`

- `scripts/show-icon-workflow.sh` prints the decision flow and icon design guardrails.
- If this skill grows later, reusable review or SVG helpers should live in `scripts/`.

## First-Time Setup (If Not Configured)

1. Open `.env.example` and confirm the minimum config.
2. Review the `reference/` docs before selecting or drawing icons.
3. Use `templates/technical-schematic-template.md` for custom icon proposals.
4. Use `scripts/show-icon-workflow.sh` for a quick refresher.

## Response Style

- Be concise but opinionated.
- Lead with the recommendation, not a vague list.
- Say what would make you change the recommendation.
- When useful, provide two or three ranked options, not ten weak ones.
- When generating SVG, keep the markup minimal, readable, and implementation-ready.
