# Example: State Icon SVG

## User request

"Create a success state icon in SVG for our 24px outline system."

## Good response shape

Lead with the concept, then the geometry.

> I would use a **check inside a circle** for a general success state. The circle provides a stable boundary for status recognition, and the check carries the positive completion signal. In a 24px outline system, this is more stable and reusable than a loose checkmark alone.

### Technical schematic

- **Concept:** success / completed / passed
- **Type:** state
- **Primary metaphor:** checkmark
- **Container:** circular boundary for status consistency
- **Canvas:** 24×24
- **Live area:** 20×20
- **Stroke:** 2px centered, round caps and joins
- **Why it wins:** the circle makes the icon read as a status token rather than a generic action glyph
- **Rejected alternative:** standalone checkmark can look more like a selection action than a final state

### Example SVG

```svg
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
  <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2" />
  <path d="M8 12.5L10.75 15.25L16 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
</svg>
```

### Notes

- Use semantic UI color outside the asset if your product colors success states differently.
- If your system already reserves circled icons for status only, this is a strong fit.
- If you need a more lightweight success action icon rather than a state icon, remove the circle and reassess the meaning.

### Accessibility note

If this icon is purely decorative next to visible success text, keep it `aria-hidden="true"`. If it is the only visible success indicator, the surrounding UI still needs accessible text or status messaging.

## Why this is a good answer

- It distinguishes state from action.
- It gives a production-ready SVG, not just a concept.
- It explains how the same check shape can change meaning depending on containment.
