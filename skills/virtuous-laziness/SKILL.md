---
name: virtuous-laziness
description: Use when building, reviewing, debugging, or refactoring software where an agent might generate unnecessary code, preserve bad architecture, patch symptoms, add generic abstractions, duplicate logic, or optimize for task completion over future maintainability. Apply to keep changes simple, durable, well-scoped, and biased toward reducing long-term human maintenance cost.
---

# Virtuous Laziness

Generate less code when less code produces a better system.

## Core Principle

Optimize for future human time, not present task completion or code volume.

Do the hard thinking before writing the easy code. Your output is cheap; the codebase's future maintenance is not.

## The Three Virtues

Use the classic programmer virtues as operating checks:

- **Laziness**: Reduce total future effort. Delete, consolidate, automate, type-check, test, or document only when it prevents repeated work.
- **Impatience**: Refuse recurring friction. Fix the source of repeated errors, confusing boundaries, slow feedback, or awkward workflows.
- **Hubris**: Hold the code to a standard worth inheriting. Avoid leaving work that depends on another agent to keep patching it.

Do not confuse laziness with the smallest immediate diff. A slightly larger change is justified when it removes meaningful future burden.

## Agent-Specific Risk

You do not naturally feel maintenance cost, cognitive load, or future frustration. Guard against these default failures:

- producing more files, branches, variants, or wrappers than the problem needs
- preserving dead compatibility paths because editing around them is easier
- adding a generic abstraction for one or two concrete cases
- duplicating logic because generation is faster than understanding the existing boundary
- accepting verbose boilerplate because an agent can maintain it
- letting poor architecture survive because it can be patched indefinitely

## Before Writing Code

Answer these in your own working notes before making a non-trivial change:

- What recurring pain, defect, or maintenance cost is this solving?
- Can deletion, consolidation, or a narrower change solve it?
- What existing boundary should own this behavior?
- What future change becomes easier after this?
- What new surface area or coupling does this add?

## Operating Workflow

When implementing:

1. Identify the real recurring pain or risk.
2. Read enough surrounding code to learn the local shape before inventing a pattern.
3. Try deletion, consolidation, or simplification before addition.
4. Add the smallest abstraction that removes real repetition, prevents a recurring error, or clarifies ownership.
5. Remove generated scaffolding, unused assets, duplicate variants, and dead compatibility paths.
6. Validate the behavior and the maintenance claim with tests, types, linters, or focused manual checks.
7. In the final note, state what future burden was reduced and what new burden was added.

## Review Workflow

When reviewing code, prioritize maintainability regressions:

- unnecessary complexity
- duplicated behavior
- abstractions that do not carry their weight
- new code that preserves a bad boundary instead of fixing it
- generated leftovers such as demos, test harnesses, unused variants, or dead assets
- large diffs whose main value is code volume rather than simpler behavior

Do not spend review energy on style unless it affects correctness, clarity, or maintenance.

## Abstraction Guidance

Aim for "as simple as possible, but no simpler."

Use an abstraction when it:

- removes real repetition
- makes invalid states harder to express
- improves cross-boundary feedback, such as type safety or contract tests
- gives future code a clearer place to live
- reduces the number of decisions future maintainers must make

Avoid an abstraction when it:

- only moves complexity around
- exists to satisfy a pattern rather than a problem
- makes the call site harder to read
- creates indirection without reducing change cost
- requires extensive explanation to justify

## Quality Signals

Prefer these signals over line count:

- fewer concepts needed to understand the feature
- fewer files touched for common changes
- less duplicated behavior
- stronger type or test feedback across boundaries
- faster local and CI validation
- clearer ownership boundaries
- less documentation needed to explain accidental complexity

## Reusable Self-Instruction

Use this instruction block when you catch yourself drifting toward code volume:

```text
Make the smallest maintainable change that solves this.
Prefer deleting or simplifying existing code before adding new abstractions.
Do not introduce a new abstraction unless it removes meaningful duplication or prevents a recurring error.
After the change, explain what future maintenance burden was reduced and what new burden, if any, was added.
```

## Finish Checklist

Before finishing agent-assisted code work, verify:

- The change solves the actual problem, not a broader imagined one.
- Generated scaffolding, examples, dead code, and duplicate variants were removed.
- Tests cover the intended behavior and likely regressions.
- The codebase has fewer or clearer moving parts than before where possible.
- Any new abstraction has a concrete maintenance payoff.
- The final state would still be acceptable if a human had to maintain it without an agent.
