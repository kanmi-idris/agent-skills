# `useEffect`

## Core purpose

Use `useEffect` to synchronize a component with an external system.

```js
useEffect(setup, dependencies?)
```

## Most important rule

If you are **not** synchronizing with an external system, you probably do not need an Effect.

External systems include:

- browser APIs
- timers
- event subscriptions
- network connections
- third-party widgets
- imperative animations

Do **not** default to `useEffect` for:

- deriving render data
- responding to user events
- transforming props into other values
- general app data flow

## Mental model

An Effect is an independent synchronization process with a setup/cleanup cycle.

Think in one cycle:

1. setup starts synchronization
2. cleanup stops or undoes that synchronization

React may run this cycle:

- on mount
- after dependency changes
- on unmount
- and once extra in development Strict Mode as a stress test

If setup and cleanup are symmetrical, the code remains correct across all of those cases.

## Use it when

- a component must connect/disconnect from something outside React
- a DOM subscription must be attached/removed
- an imperative widget or API must be kept in sync with props/state
- you are wrapping such synchronization into a custom Hook

Good fits:

- chat connection lifecycle
- `window` event listener
- `setInterval` / `clearInterval`
- `IntersectionObserver`
- dialog `showModal()` / `close()`
- third-party map or video widget synchronization

## Do not use it when

- you can compute the value during render
- you can do the work directly in an event handler
- you are mirroring props into state without an external-system reason
- you are introducing an Effect only to work around dependency confusion

## Smallest good example

```tsx
import { useEffect, useState } from 'react'
import { createConnection } from './chat'

function ChatRoom({ roomId }) {
  const [serverUrl] = useState('https://localhost:1234')

  useEffect(() => {
    const connection = createConnection(serverUrl, roomId)
    connection.connect()

    return () => {
      connection.disconnect()
    }
  }, [serverUrl, roomId])

  return <h1>Welcome to {roomId}</h1>
}
```

Why this is a good fit:

- there is a real external system
- setup and cleanup mirror each other
- dependencies match the reactive values used

## Dependency rules

You do not get to choose Effect dependencies arbitrarily.

Every reactive value used inside the Effect must be listed:

- props
- state
- variables declared in the component body
- functions declared in the component body

Bad:

```tsx
useEffect(() => {
  const connection = createConnection(serverUrl, roomId)
  connection.connect()
  return () => connection.disconnect()
}, [])
```

if `serverUrl` and `roomId` are reactive.

Good:

```tsx
useEffect(() => {
  const connection = createConnection(serverUrl, roomId)
  connection.connect()
  return () => connection.disconnect()
}, [serverUrl, roomId])
```

If you want to remove a dependency, change the code so the value is no longer reactive or no longer read by the Effect.

Do not silence the linter as a first-line solution.

## Strict Mode behavior

In development Strict Mode, React runs setup and cleanup one extra time before the real setup.

This is not a bug. It is a stress test for cleanup correctness.

Your code should behave correctly for:

- setup
- cleanup
- setup again

If the user can visibly tell the difference, the cleanup is likely incomplete.

## Cleanup symmetry

Cleanup should stop or undo what setup did.

Good:

```tsx
useEffect(() => {
  const id = setInterval(tick, 1000)
  return () => clearInterval(id)
}, [])
```

Bad:

```tsx
useEffect(() => {
  return () => {
    doSomething()
  }
}, [])
```

when there was no corresponding setup.

## Common high-value patterns

### 1. Event listeners

```tsx
useEffect(() => {
  function handleMove(event) {
    setPosition({ x: event.clientX, y: event.clientY })
  }

  window.addEventListener('pointermove', handleMove)
  return () => window.removeEventListener('pointermove', handleMove)
}, [])
```

### 2. Timers

Use state updaters to avoid depending on current state when only the next state matters.

```tsx
useEffect(() => {
  const intervalId = setInterval(() => {
    setCount((c) => c + 1)
  }, 1000)

  return () => clearInterval(intervalId)
}, [])
```

### 3. Imperative widgets

```tsx
useEffect(() => {
  if (mapRef.current == null) {
    mapRef.current = new MapWidget(containerRef.current)
  }

  mapRef.current.setZoom(zoomLevel)
}, [zoomLevel])
```

### 4. Wrapping synchronization in a custom Hook

```tsx
function useChatRoom({ serverUrl, roomId }) {
  useEffect(() => {
    const connection = createConnection(serverUrl, roomId)
    connection.connect()
    return () => connection.disconnect()
  }, [serverUrl, roomId])
}
```

This is often the cleanest end state when an Effect pattern repeats.

## Data fetching guidance

Fetching in Effects is possible, but it is usually a lower-level fallback.

Prefer:

- framework data fetching
- route loaders
- Suspense-enabled data sources
- client-side caches like TanStack Query or SWR

If you fetch in an Effect, you must handle races and stale responses explicitly.

Basic pattern:

```tsx
useEffect(() => {
  let ignore = false
  setBio(null)

  fetchBio(person).then((result) => {
    if (!ignore) {
      setBio(result)
    }
  })

  return () => {
    ignore = true
  }
}, [person])
```

Important:

- Effects do not run on the server
- Effect fetching often creates waterfalls
- manual fetching in Effects becomes repetitive quickly

## Removing unnecessary dependencies

### Remove object dependencies

Bad:

```tsx
const options = { serverUrl, roomId }

useEffect(() => {
  const connection = createConnection(options)
  connection.connect()
  return () => connection.disconnect()
}, [options])
```

Better:

```tsx
useEffect(() => {
  const options = { serverUrl, roomId }
  const connection = createConnection(options)
  connection.connect()
  return () => connection.disconnect()
}, [serverUrl, roomId])
```

### Remove function dependencies

Bad:

```tsx
function createOptions() {
  return { serverUrl, roomId }
}

useEffect(() => {
  const options = createOptions()
}, [createOptions])
```

Better:

```tsx
useEffect(() => {
  function createOptions() {
    return { serverUrl, roomId }
  }

  const options = createOptions()
}, [serverUrl, roomId])
```

Rule:

- move objects/functions inside the Effect when they only exist for the Effect

## Reading latest values without reacting to them

Sometimes you want the latest value inside an Effect without making the Effect re-run for that value.

That is where `useEffectEvent` is the better tool, not dependency suppression.

Example shape:

```tsx
const onVisit = useEffectEvent((visitedUrl) => {
  logVisit(visitedUrl, shoppingCart.length)
})

useEffect(() => {
  onVisit(url)
}, [url])
```

This keeps the Effect reactive to `url` without making `shoppingCart` a trigger.

## Visual work

If the Effect is doing something visual and the user sees flicker before it runs, use `useLayoutEffect` instead.

Use `useEffect` by default.

Switch to `useLayoutEffect` only when:

- the work must happen before paint
- a visible flicker proves the timing matters

## Common mistakes

### Using Effects for pure derivation

Bad instinct:

- prop changes
- Effect runs
- Effect sets derived state

Prefer computing during render unless a true external system is involved.

### Suppressing dependency lint warnings

This often hides correctness bugs rather than fixing them.

### Infinite loops from state updates

If the Effect:

- sets state
- that state changes a dependency
- which re-runs the Effect

you have built a feedback loop.

First ask whether the Effect should exist at all.

### Missing cleanup

If setup starts something persistent, cleanup must stop it.

### Assuming Effects run on the server

They do not. Effects are client-only.

## Troubleshooting

### “My Effect runs twice on mount”

That is usually development Strict Mode. Verify cleanup symmetry.

### “My Effect runs after every render”

Check:

- did you omit the dependency array?
- is one dependency always new?
- are you depending on an object or function created during render?

### “My Effect is in an infinite loop”

Check whether:

- the Effect sets state
- that state changes one of its dependencies

Then remove the Effect, reduce dependencies structurally, or move non-reactive logic elsewhere.

### “My cleanup ran even though the component did not unmount”

Cleanup also runs before the next setup when dependencies change.

That is expected.

### “I see a visual flicker”

If the work must happen before paint, replace `useEffect` with `useLayoutEffect`.

## Practical decision line

Use `useEffect` to synchronize with external systems, not as a default place to put logic that happens “after render.” If there is no external system, reach for a simpler React pattern first.
