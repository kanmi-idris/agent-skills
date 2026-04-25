# `useDebugValue`

## Core purpose

Use `useDebugValue` inside a custom Hook to display a readable label in React DevTools.

```js
useDebugValue(value, format?)
```

## Mental model

`useDebugValue` is developer tooling metadata for custom Hooks.

- it does not affect runtime behavior
- it does not change the Hook’s return value
- it only improves what you see when inspecting Hooks in React DevTools

## Use it when

- you are writing a reusable custom Hook
- the Hook’s internal state is hard to interpret from raw values alone
- a shared library Hook would benefit from a human-readable label in DevTools

Good fits:

- connection status hooks
- async resource hooks
- subscription hooks
- library Hooks with non-obvious internal state

## Do not use it when

- the Hook is trivial and already obvious from its raw values
- the Hook is local-only and not worth extra DevTools labeling
- you are adding it to every custom Hook by default

Rule:

- use it selectively where it materially improves debugging clarity

## Smallest good example

```tsx
import { useDebugValue, useSyncExternalStore } from 'react'

export function useOnlineStatus() {
  const isOnline = useSyncExternalStore(
    subscribe,
    () => navigator.onLine,
    () => true
  )

  useDebugValue(isOnline ? 'Online' : 'Offline')

  return isOnline
}
```

This makes DevTools more readable for consumers of the custom Hook.

## Formatter function

The optional second argument lets you defer formatting work until the Hook is actually inspected in React DevTools.

```tsx
useDebugValue(date, (date) => date.toDateString())
```

Why this matters:

- expensive formatting does not need to run on every render
- DevTools calls the formatter when inspection happens

Use this when the raw value is noisy or expensive to format eagerly.

## Most important rule

Only call `useDebugValue` inside a custom Hook, and only when the debugging payoff is real.

## Common mistakes

### Adding it everywhere

This adds noise without much value.

Prefer it for Hooks whose internal state is otherwise hard to inspect.

### Treating it like user-facing state

`useDebugValue` is for DevTools, not for app logic or UI output.

### Doing expensive formatting eagerly

If formatting is non-trivial, use the second argument instead of computing the display string during every render.

## Practical decision line

Use `useDebugValue` to make reusable custom Hooks easier to inspect in React DevTools. Keep it selective, and use the formatter form when display formatting would otherwise do unnecessary work on every render.
