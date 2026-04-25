# `useSyncExternalStore`

## Core purpose

Use `useSyncExternalStore` when React components need to read from and stay synchronized with data that lives outside React.

```js
const snapshot = useSyncExternalStore(
  subscribe,
  getSnapshot,
  getServerSnapshot?
)
```

## Mental model

`useSyncExternalStore` is the bridge between React and an external mutable source.

You provide:

- `subscribe`: how React should listen for changes
- `getSnapshot`: how React should read the current value
- `getServerSnapshot`: how React should get the initial value for SSR/hydration

React uses these to keep rendering consistent with the external store.

This is not a general replacement for `useState` or `useReducer`. It is specifically for integrating non-React state sources.

## Use it when

- you are integrating a third-party store that lives outside React
- you need to subscribe to a browser API with mutable external state
- you need React-safe subscription semantics for external data
- you need server-rendering support for an external store subscription

Good fits:

- browser online/offline state
- media query state if exposed through an external subscription layer
- existing app stores outside React
- external caches or data containers already owned elsewhere

## Do not use it when

- the data can just live in React state
- you are building ordinary component-local state
- you are trying to avoid `useContext` or `useReducer` for React-owned data
- the store API cannot provide a stable snapshot contract

If the source of truth is already React, keep it in React.

## Smallest good examples

### External store

```tsx
import { useSyncExternalStore } from 'react'
import { todosStore } from './todoStore'

function TodosApp() {
  const todos = useSyncExternalStore(
    todosStore.subscribe,
    todosStore.getSnapshot
  )

  return (
    <ul>
      {todos.map((todo) => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  )
}
```

### Browser API

```tsx
import { useSyncExternalStore } from 'react'

function getSnapshot() {
  return navigator.onLine
}

function subscribe(callback) {
  window.addEventListener('online', callback)
  window.addEventListener('offline', callback)
  return () => {
    window.removeEventListener('online', callback)
    window.removeEventListener('offline', callback)
  }
}

function OnlineStatus() {
  const isOnline = useSyncExternalStore(subscribe, getSnapshot)
  return <p>{isOnline ? 'Online' : 'Offline'}</p>
}
```

## The most important contract

`getSnapshot` must return the same value while the underlying store has not changed.

That means:

- if the store is immutable, return the immutable value directly
- if the store is mutable, cache and reuse the last derived immutable snapshot until the store actually changes

If `getSnapshot` returns a new object every time, React will think the store changed on every read and you can create infinite render loops.

## Snapshot rules

Snapshots should be treated as immutable values from React’s perspective.

Good:

```tsx
function getSnapshot() {
  return myStore.todos
}
```

Bad:

```tsx
function getSnapshot() {
  return { todos: myStore.todos }
}
```

The bad version creates a brand new object on every call, which breaks snapshot stability.

## Subscription rules

`subscribe` must:

- register the callback with the external source
- call the callback when the store actually changes
- return a cleanup function that unsubscribes

Prefer declaring `subscribe` outside the component so React does not think it changed every render.

Bad:

```tsx
function MyComponent() {
  function subscribe(callback) {
    // ...
  }

  const value = useSyncExternalStore(subscribe, getSnapshot)
}
```

Better:

```tsx
function subscribe(callback) {
  // ...
}

function MyComponent() {
  const value = useSyncExternalStore(subscribe, getSnapshot)
}
```

## Server rendering

If the component can render on the server, provide `getServerSnapshot`.

```tsx
const value = useSyncExternalStore(
  subscribe,
  getSnapshot,
  getServerSnapshot
)
```

`getServerSnapshot` must return the same initial value:

- on the server render
- on the client during hydration

If those do not match, hydration will be wrong.

For browser-only sources, you can:

- provide a safe placeholder server snapshot
- or intentionally keep that UI client-only if no meaningful server value exists

## Transition behavior

External store updates are not React-owned updates.

Because of that, if the store mutates during a non-blocking Transition, React may restart and promote the update to blocking so the screen stays internally consistent.

That is expected behavior.

The practical takeaway: external stores do not participate in React scheduling the same way React state does.

## Suspense warning

Do not base Suspenseful rendering decisions directly on `useSyncExternalStore` values unless you understand the UX cost.

Because external store mutations are not Transition-aware in the same way as React state, store changes can trip nearby Suspense boundaries and replace already-visible UI with fallbacks.

That usually feels worse than normal store-driven UI updates.

## Best practice: wrap in a custom Hook

Usually you do not want raw `useSyncExternalStore` calls everywhere.

Prefer:

```tsx
import { useSyncExternalStore } from 'react'

export function useOnlineStatus() {
  return useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot)
}
```

This keeps:

- subscription details
- snapshot rules
- SSR behavior

in one place.

## When it is the wrong abstraction

If you are modeling app state that React itself owns, prefer:

- `useState`
- `useReducer`
- `useContext`

`useSyncExternalStore` is not “advanced state management.” It is an integration API.

## Common mistakes

### Returning a fresh object from `getSnapshot`

This breaks caching and can cause infinite loops.

### Defining `subscribe` inline every render

That forces re-subscription churn.

### Treating mutable store data as if React can diff it safely

React needs immutable snapshot semantics even if the underlying store is mutable.

### Forgetting `getServerSnapshot` for server-rendered usage

That either breaks rendering or causes hydration mismatches.

## Troubleshooting

### "The result of `getSnapshot` should be cached"

Your snapshot identity changes every time. Return the same object/value until the actual underlying data changes.

### "My `subscribe` function gets called after every re-render"

You are probably recreating the `subscribe` function inside the component. Move it out or memoize it when parameters truly vary.

### "Should I use this for app state?"

Usually no. If React owns the state, keep it in React.

## Practical guidance

Reach for `useSyncExternalStore` only when there is a real external source of truth.

If the store is outside React, this hook gives you the correct subscription contract.

If the store is inside React, simpler hooks are almost always better.
