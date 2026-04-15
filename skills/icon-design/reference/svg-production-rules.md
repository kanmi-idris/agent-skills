# SVG Production Rules

Use this when the user wants code, implementation guidance, or production-quality cleanup.

## Default SVG skeleton

For outline icons, start from this pattern:

```svg
<svg
  viewBox="0 0 24 24"
  fill="none"
  xmlns="http://www.w3.org/2000/svg"
  aria-hidden="true"
>
  <path
    d="..."
    stroke="currentColor"
    stroke-width="2"
    stroke-linecap="round"
    stroke-linejoin="round"
  />
</svg>
```

## Production rules

1. **Use a clean viewBox**
   - default to `0 0 24 24`

2. **Use `currentColor` unless a fixed color is required**
   - icons should inherit text color by default

3. **Keep geometry simple**
   - use circles, lines, rects, polylines, and simple paths when possible

4. **Minimize path noise**
   - remove editor metadata, hidden layers, and unnecessary precision

5. **Avoid unnecessary transforms and masks**
   - flatten transforms where practical
   - avoid clip paths unless they solve a real problem

6. **Align strokes cleanly**
   - use integer or half-integer coordinates that suit the stroke model

7. **Keep the code legible**
   - do not output bloated, machine-noisy SVG when a clean version is possible

## Accessibility rules

- Decorative icon: use `aria-hidden="true"` and keep it out of the focus order.
- Icon-only button: put the accessible name on the button, not just in the SVG.
- Standalone meaningful icon: use `<title>` only when the SVG itself needs to expose meaning.

## Delivery format

When asked for SVG, prefer this order:

1. recommended concept
2. technical schematic summary
3. SVG code
4. accessibility note
5. any assumptions or risks

If the user wants code only, provide code only.

## Cleanup checklist

Before finalizing an SVG, check:

- valid `viewBox`
- minimal elements
- `currentColor` usage if appropriate
- consistent stroke attributes
- no accidental fills
- no stray transforms
- no editor comments/metadata
- readable at small sizes

## Important caveat

One SVG scaled everywhere is not always enough. For very small sizes or specialized software contexts, recommend simplified size-specific drawings when legibility drops.
