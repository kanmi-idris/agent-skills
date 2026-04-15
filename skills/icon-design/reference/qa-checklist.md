# QA Checklist

Run this before finalizing a recommendation, schematic, or SVG.

## Meaning

- [ ] Is the icon's intended meaning clear in one sentence?
- [ ] Is it representing the right thing: object, action, state, or destination?
- [ ] Would a reasonable user interpret it the intended way?

## Context

- [ ] Does it make sense where it appears?
- [ ] Is it distinct from adjacent icons or actions?
- [ ] If the concept is abstract, did you recommend visible text?

## Geometry

- [ ] Is there one dominant silhouette?
- [ ] Does internal detail survive at 24, 20, and 16?
- [ ] Is negative space clear enough?
- [ ] Is the icon optically balanced, not just mathematically centered?

## System consistency

- [ ] Does it match the family's grid, stroke, radius, and terminal style?
- [ ] Does the visual weight match neighboring icons?
- [ ] Are modifiers placed consistently?

## Implementation

- [ ] Is the SVG minimal and clean?
- [ ] Is `currentColor` used when appropriate?
- [ ] Are there unnecessary paths, masks, or transforms to remove?

## Accessibility

- [ ] If decorative, is it hidden from assistive tech?
- [ ] If icon-only interactive, is there a proper accessible name on the control?
- [ ] Is meaning conveyed by more than color alone?

## Go / no-go rule

Do not approve the icon if:

- users are likely to confuse it with a nearby action
- the metaphor needs explanation to work
- the small-size version collapses
- it only becomes clear when paired with a tooltip
