# `useInsertionEffect`

## Core purpose

Use `useInsertionEffect` to insert styles before layout Effects run.

```js
useInsertionEffect(setup, dependencies?)
```

## Most important rule

This Hook is for CSS-in-JS library authors.

Unless you are implementing runtime style injection in a styling library, you probably want:

- `useEffect`
- `useLayoutEffect`

and not `useInsertionEffect`.

## Mental model

`useInsertionEffect` exists so runtime-injected styles can reach the DOM before layout-sensitive Effects run.

It is a very specialized timing hook for style insertion, not a general-purpose “earlier Effect.”

The intended use case is:

- compute or track a CSS rule
- inject the corresponding `<style>` tag at the right lifecycle moment
- let downstream layout reads happen against the up-to-date styles

## Use it when

- you are writing a CSS-in-JS library with runtime `<style>` tag injection
- style insertion timing must happen before layout Effects in consuming components
- you understand why injecting during render or later Effects is incorrect or too slow

## Do not use it when

- you are building ordinary app code
- you are trying to run logic “earlier than `useEffect`”
- you need DOM refs
- you need to update state
- you are not injecting styles

If you are styling app components, prefer:

- static CSS extraction when possible
- normal CSS files
- inline styles for truly dynamic per-element values

## Smallest good example

```tsx
import { useInsertionEffect } from 'react'

const insertedRules = new Set()

function useCSS(rule) {
  useInsertionEffect(() => {
    if (!insertedRules.has(rule)) {
      insertedRules.add(rule)
      document.head.appendChild(getStyleForRule(rule))
    }
  }, [rule])

  return rule
}
```

Why this is a good fit:

- the work is style injection
- timing matters before layout Effects
- the hook stays in library infrastructure, not feature code

## Why not render-time insertion

Injecting styles during render is especially problematic in concurrent/non-blocking rendering because style recalculation can happen repeatedly while React is still working through the tree.

That can become extremely slow.

`useInsertionEffect` avoids that specific timing problem better than:

- injecting during render
- injecting in `useLayoutEffect`
- injecting in `useEffect`

## Why not `useLayoutEffect`

By the time `useLayoutEffect` runs, other layout-sensitive work may already be depending on styles being present.

`useInsertionEffect` gives runtime style injection a dedicated earlier slot so layout calculations happen against current styles.

## Important caveats

- runs only on the client
- cannot update state from inside the hook
- refs are not attached yet when it runs
- you should not rely on the DOM being updated in a specific way when it fires
- cleanup/setup behavior is interleaved per component, unlike normal Effect phases

This means it is a poor fit for general DOM work.

## Server rendering note

`useInsertionEffect` does not run on the server.

If a CSS-in-JS library needs to know which rules were used on the server, it must collect that information during render or through explicit server-side infrastructure.

Example shape:

```tsx
if (typeof window === 'undefined') {
  collectedRules.add(rule)
}
```

Then client-side insertion can still happen with `useInsertionEffect`.

## Common mistakes

### Using it in app code because it sounds faster

This is almost always the wrong reason.

If your app code needs:

- synchronization with an external system: use `useEffect`
- pre-paint visual measurement: use `useLayoutEffect`
- styling: use CSS / extracted CSS / inline styles first

### Trying to update state inside it

That is not allowed.

### Expecting refs to be ready

Refs are not attached yet when `useInsertionEffect` runs.

### Using it for arbitrary DOM mutations

Its purpose is not “run before everything else.” Its purpose is narrowly about style insertion timing.

## Practical decision line

Use `useInsertionEffect` only when implementing runtime CSS injection in a library and you need style tags inserted before layout Effects. For normal application code, do not reach for it.
