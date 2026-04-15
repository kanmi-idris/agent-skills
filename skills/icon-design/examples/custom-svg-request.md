# Example: Custom SVG Request

## User request

"Create an SVG icon for a private folder in our outline set."

## Good response shape

> Assuming no conflicting family rules, I would use a **folder** as the dominant metaphor and a **small lock** as the secondary cue. The folder should stay readable even if the lock detail softens at smaller sizes. I would keep the default `24×24` canvas, `20×20` live area, and centered `2px` outline stroke.

### Technical schematic

- **Primary metaphor:** folder
- **Secondary cue:** lock
- **Why it wins:** the folder carries the storage meaning; the lock adds privacy without replacing the base concept
- **Rejected alternative:** shield-only would imply protection but lose the folder meaning

### Example SVG

```svg
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
  <path d="M3 8C3 6.89543 3.89543 6 5 6H9L11 8H19C20.1046 8 21 8.89543 21 10V11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M3 10V17C3 18.1046 3.89543 19 5 19H11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M15 15V14C15 12.8954 15.8954 12 17 12C18.1046 12 19 12.8954 19 14V15" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="13" y="15" width="8" height="6" rx="2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

### Notes

- In a real family, adjust the folder-lock spacing by eye against neighboring icons.
- If this icon must live at `16×16`, consider simplifying the lock.
- If the control is interactive and icon-only, put the accessible name on the button, not inside the SVG.
