# Icon System Rules

Use this when defining a family, extending a set, or drawing a new icon that must feel native to an existing system.

## Default system tokens

Unless the brief says otherwise, start here:

| Token | Default |
| --- | --- |
| Canvas | 24×24 |
| Live area | 20×20 |
| Outer padding | 2px per side |
| Stroke | 2px centered |
| Line cap | round |
| Line join | round |
| Corner radius | 2px default |
| Preferred angles | 0°, 45°, 90° |
| Minimum internal gap | 2px at 24×24 |
| Default family style | outline |
| Color strategy | inherit via `currentColor` |

These are defaults, not laws. Break them only with a clear system reason.

## Keyline logic

Use simple keylines to control optical balance:

- circle
- square
- vertical rectangle
- horizontal rectangle

Grids are guides. Optical balance wins over perfect math.

## Family grammar

Define these before designing multiple icons:

1. **Silhouette language**
   - blocky, rounded, geometric, or soft

2. **Stroke behavior**
   - uniform or variable
   - centered or edge-aligned

3. **Corner behavior**
   - sharp, small-radius, or large-radius

4. **Detail density**
   - how much interior detail is allowed at 24×24

5. **Modifier grammar**
   - where add, check, slash, lock, alert, or status marks live

6. **Directional logic**
   - whether arrows, chevrons, and send/share icons mirror in RTL

## Design order for a new family

1. Define system tokens.
2. Choose 3 to 5 benchmark icons.
3. Design the hardest icons first.
4. Extract shared primitives.
5. Build the rest from the same grammar.
6. Review the full set together at real sizes.

## Modifier rules

Use modifiers carefully.

- Prefer top-right or bottom-right placement when the dominant metaphor stays readable.
- Keep modifier scale subordinate to the base form.
- Do not bury the dominant shape under the modifier.
- Prefer shape changes before color-only state changes.

## Consistency checks

Across a family, compare:

- visual weight
- corner feel
- stroke density
- amount of empty space
- silhouette complexity
- angle language
- badge size and placement

If one icon feels louder or thinner than the rest, fix it.

## When to break the defaults

Break the default 24×24 / 2px outline system only when:

- the existing product already uses a different standard
- the icon family is filled rather than outline
- the target size is so small that the shape needs a simplified variant
- the icon is brand-specific and intentionally distinct from utility icons

State the reason explicitly when you deviate.
