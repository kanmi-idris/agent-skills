---
name: elons-algorithm
description: Use when improving a product, system, codebase, workflow, requirement set, process, test plan, build pipeline, or operational procedure where the agent should question requirements, delete unnecessary parts, simplify before optimizing, accelerate cycle time, and automate only after the process is proven. Apply especially when a task starts with inherited requirements, bureaucracy, overbuilt process, slow feedback loops, or premature automation.
---

# Elon's Algorithm

Use this skill to improve systems in the right order. Do not optimize, accelerate, or automate work that should not exist.

## The Order

Follow these steps in sequence:

1. Question every requirement.
2. Delete every unnecessary part or process.
3. Simplify and optimize what remains.
4. Accelerate cycle time.
5. Automate last.

If you skip ahead, you risk making a bad requirement faster, cleaner, or more automated instead of removing it.

## 1. Question Requirements

Treat every requirement as provisional until it has an owner and a reason.

For each important requirement, identify:

- the named person or source responsible for it
- the user, business, legal, safety, technical, or operational risk it addresses
- the evidence that the requirement is still current
- what breaks if the requirement is removed or weakened
- the simpler requirement that would satisfy the real constraint

Do not accept anonymous requirements from a department, role, policy bucket, ticket label, or inherited convention. Requirements from credible or senior people still need to be questioned.

## 2. Delete Before Improving

Remove parts, process steps, checks, meetings, abstractions, states, flags, code paths, tests, docs, or automations that do not directly serve a validated requirement.

Deletion targets include:

- compatibility paths with no current caller
- workflow steps nobody can justify
- generated or duplicated variants
- checks that do not catch real failures
- abstractions that hide rather than reduce complexity
- documentation for behavior that should be made obvious or removed
- automation around a process that is no longer needed

Be willing to add back what proves necessary. If nothing needs to be restored, you probably deleted too cautiously.

## 3. Simplify And Optimize

Only simplify and optimize what survived deletion.

Prefer:

- one clear path over many configurable modes
- concrete behavior over generic framework code
- direct ownership over cross-cutting coordination
- smaller interfaces over broad extension points
- faster feedback from types, tests, logs, or runtime checks

Do not polish a part, process, or abstraction while its existence is still in question.

## 4. Accelerate Cycle Time

After the system is smaller and simpler, reduce the time required to learn whether it works.

Look for:

- slow build, test, review, deploy, or feedback loops
- repeated manual validation that can become a focused check
- unclear errors that force investigation
- long handoffs between owners
- unnecessary waiting between detection and correction

Accelerate the validated path. Do not speed up waste.

## 5. Automate Last

Automate only after requirements have been challenged, unnecessary pieces deleted, the remaining process simplified, and the bugs shaken out.

Good automation:

- encodes a stable, understood process
- reduces repeated human effort
- catches real regressions or operational risks
- is easier to maintain than the manual process it replaces

Bad automation:

- preserves a broken process
- hides unclear requirements behind tooling
- creates complex infrastructure for rare work
- runs before the team understands the failure modes

## Agent Workflow

When applying this skill:

1. List the current requirements or process steps.
2. Attach an owner and reason to each important requirement.
3. Mark what can be deleted, merged, weakened, or deferred.
4. Simplify the surviving path.
5. Improve feedback speed.
6. Automate only the stable repeated work.
7. Report what was questioned, deleted, simplified, accelerated, and automated.

## Finish Checklist

Before finishing, verify:

- Anonymous or inherited requirements were questioned.
- Deletion happened before optimization.
- Remaining complexity maps to a real constraint.
- Cycle-time improvements target the surviving process.
- Automation was not used to preserve unnecessary work.
- Any deleted item that must be restored has a named reason.
