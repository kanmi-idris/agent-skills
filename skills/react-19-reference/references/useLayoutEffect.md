# `useLayoutEffect`

## Core purpose

Use `useLayoutEffect` when code must run after React updates the DOM but before the browser paints.

```js
useLayoutEffect(setup, dependencies?)
```

## Most important rule

Prefer `useEffect` unless you specifically need pre-paint layout measurement or pre-paint visual synchronization.

`useLayoutEffect` blocks painting and can hurt performance.

## Mental model

`useLayoutEffect` is the pre-paint version of `useEffect`.

Typical sequence:

1. React renders
2. React updates the DOM
3. `useLayoutEffect` runs before paint
4. you can measure layout or make a synchronous correction
5. the browser finally paints

This is useful when the user must not see the intermediate wrong layout.

## Use it when

- you must measure layout before the user sees the result
- a visual element would flicker if corrected in a normal Effect
- a tooltip, popover, or overlay needs a two-pass render before paint
- a DOM read/write must happen before paint for correctness

Good fits:

- tooltip placement
- popover positioning
- measurement before visual correction
- certain imperative visual sync cases

## Do not use it when

- `useEffect` would work fine
- the work is not visual or layout-sensitive
- you are fetching data
- you are synchronizing with an external system that does not need pre-paint timing
- you are trying to make ordinary logic “run sooner”

## Smallest good example

```tsx
import { useLayoutEffect, useRef, useState } from 'react'

function Tooltip() {
  const ref = useRef(null)
  const [height, setHeight] = useState(0)

  useLayoutEffect(() => {
    const { height } = ref.current.getBoundingClientRect()
    setHeight(height)
  }, [])

  return <div ref={ref} data-height={height} />
}
```

Why this is a good fit:

- the measurement depends on actual DOM layout
- the measured value affects visual placement
- the user should not see the wrong first pass

## When to choose `useLayoutEffect` over `useEffect`

Choose `useLayoutEffect` only if both are true:

1. the Effect does visual/layout work
2. running after paint would cause a visible glitch, jump, or flicker

If either is false, prefer `useEffect`.

## High-value pattern: two-pass positioning

This is the canonical example:

- render with an initial guess
- measure actual size in `useLayoutEffect`
- immediately re-render before paint
- show only the corrected final result to the user

This is why tooltips and overlays are classic `useLayoutEffect` candidates.

## Performance cost

Everything inside `useLayoutEffect`, plus any synchronous state updates it triggers, blocks the browser from repainting.

That means:

- too much work here makes the app feel slow
- overuse harms responsiveness
- the hook should stay narrow and purposeful

Rule:

- keep layout Effects small
- do the minimum measurement/mutation needed
- prefer ordinary Effects wherever possible

## Dependency rules

Dependency rules are the same as `useEffect`.

Include every reactive value used inside the layout Effect:

- props
- state
- variables declared in the component body
- functions declared in the component body

If you want fewer dependencies, restructure the code rather than suppressing lint rules.

## Important caveats

- client-only: it does not run during server rendering
- Strict Mode does the extra setup/cleanup stress test in development
- object/function dependencies can cause unnecessary re-runs if created during render
- state updates inside `useLayoutEffect` cause remaining Effects to run immediately

## SSR guidance

`useLayoutEffect` does nothing on the server because there is no layout to measure.

If a component depends on layout information, typical options are:

- downgrade to `useEffect` if pre-paint timing is not truly required
- render the component client-only
- delay rendering the real component until after mount
- use a non-layout-dependent fallback during SSR/hydration

This is especially common for:

- tooltips
- overlays
- client-only widgets

## Common mistakes

### Using it as a default replacement for `useEffect`

This is almost always wrong and makes performance worse.

### Doing too much work inside it

Heavy computation in `useLayoutEffect` directly delays paint.

### Using it for non-visual tasks

If the work is not about layout or visible pre-paint correction, it almost certainly belongs in `useEffect`.

### Ignoring server-rendering implications

If the component is rendered on the server, there is no layout information. The hook cannot help there.

## Troubleshooting

### “I see flicker with `useEffect`”

If the code:

- measures layout
- or visually corrects placement

and the user sees the wrong intermediate frame, upgrade that specific logic to `useLayoutEffect`.

### “The app feels slower after switching to `useLayoutEffect`”

That likely means the work is blocking paint.

Check:

- can this be `useEffect` instead?
- can the work be reduced?
- can the layout-sensitive part be isolated to a smaller component?

### “`useLayoutEffect` does nothing on the server”

That is expected. Use a client-only or post-hydration strategy if the component depends on browser layout.

## Practical decision line

Use `useLayoutEffect` only when pre-paint measurement or visual correction is necessary. Otherwise, stay with `useEffect`.
