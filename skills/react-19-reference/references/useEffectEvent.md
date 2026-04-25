# `useEffectEvent`

## Core purpose

Use `useEffectEvent` to keep some logic inside the Effect world while letting that logic read the latest props and state without re-synchronizing the Effect.

```js
const onEvent = useEffectEvent(callback)
```

## Mental model

An Effect Event is an event-like callback that belongs to an Effect.

It lets you separate:

- **reactive synchronization** logic that should re-run when dependencies change
- **non-reactive event logic** that should read the latest values when invoked, but should not itself trigger re-synchronization

This is the right tool when part of the logic is “something happened inside the Effect lifecycle,” but the callback should always see the latest render values.

## Most important rule

Do **not** use `useEffectEvent` to hide real Effect dependencies.

Use it only for logic that is genuinely an event fired from an Effect.

If a value should cause the Effect to re-run, keep it in the dependency array.

## Use it when

- an Effect installs a timer, listener, or subscription callback that should read the latest values
- reconnecting or re-subscribing would be wrong or wasteful, but the callback still needs fresh render data
- a custom Hook with an internal Effect needs to call the latest callback without resetting the Effect

Good fits:

- interval ticking with latest settings
- event listeners reading the latest flags
- connection callbacks that should respect current UI preferences without reconnecting

## Do not use it when

- the callback should be called from an event handler
- the callback should be passed to child components
- the logic should run during render
- the value is a real dependency of the Effect and should trigger re-synchronization

If you need a callback for UI events or props, use a normal function or `useCallback` instead.

## Smallest good example

```tsx
import { useEffect, useEffectEvent } from 'react'

function ChatRoom({ roomId, muted }) {
  const onConnected = useEffectEvent(() => {
    if (!muted) {
      showNotification('Connected!')
    }
  })

  useEffect(() => {
    const connection = createConnection(roomId)
    connection.on('connected', () => {
      onConnected()
    })
    connection.connect()

    return () => connection.disconnect()
  }, [roomId])
}
```

Why this is a good fit:

- reconnecting depends on `roomId`
- notification behavior depends on latest `muted`
- `muted` should not force a reconnection

## Key behavior

When you call the Effect Event:

- it reads the latest committed props/state from render
- it does not itself become a dependency trigger
- it remains local to the Effect world

This is what makes it useful for “latest values without re-subscribe” cases.

## Call-site restrictions

Effect Events can only be called from:

- `useEffect`
- `useLayoutEffect`
- `useInsertionEffect`
- other Effect Events in the same component

Do **not** call them:

- during render
- from click handlers
- from component props
- from outside the component’s local Effect logic

## Identity rule

Effect Event functions do **not** have stable identity.

This is intentional.

Do not:

- include them in dependency arrays
- rely on their identity stability
- pass them around like normal callbacks

If you put an Effect Event in dependencies, the linter should complain, and the Effect would re-run every render anyway.

## High-value patterns

### 1. Timers with latest values

```tsx
const onTick = useEffectEvent(() => {
  setCount(count + increment)
})

useEffect(() => {
  const id = setInterval(() => {
    onTick()
  }, 1000)
  return () => clearInterval(id)
}, [])
```

This keeps the timer stable while `onTick` sees fresh `count` and `increment`.

### 2. Event listeners with latest flags

```tsx
const onMove = useEffectEvent((event) => {
  if (canMove) {
    setPosition({ x: event.clientX, y: event.clientY })
  }
})

useEffect(() => {
  window.addEventListener('pointermove', onMove)
  return () => window.removeEventListener('pointermove', onMove)
}, [])
```

This lets the listener stay installed while still honoring the latest `canMove`.

### 3. Custom Hooks that own Effects

```tsx
function useInterval(callback, delay) {
  const onTick = useEffectEvent(callback)

  useEffect(() => {
    if (delay === null) return
    const id = setInterval(() => onTick(), delay)
    return () => clearInterval(id)
  }, [delay])
}
```

This is one of the cleanest uses of `useEffectEvent`.

## Common mistakes

### Using it to dodge dependencies

Bad:

```tsx
const logVisit = useEffectEvent(() => {
  log(pageUrl)
})

useEffect(() => {
  logVisit()
}, [])
```

If `pageUrl` should trigger the Effect, it belongs in the Effect dependencies. This pattern hides the bug.

### Calling it during render

Bad:

```tsx
const onLog = useEffectEvent(() => {
  console.log(data)
})

onLog()
```

Effect Events are not render-phase logic.

### Passing it to children

If another component needs a callback prop, use a normal function or `useCallback`.

### Including it in dependencies

Bad:

```tsx
useEffect(() => {
  onSomething()
}, [onSomething])
```

Effect Events are intentionally excluded from dependency arrays.

## Troubleshooting

### “A function wrapped in `useEffectEvent` can't be called during rendering”

You are calling it in render. Move that call into an Effect or call plain logic directly instead.

### “Functions returned from `useEffectEvent` must not be included in the dependency array”

Remove the Effect Event from dependencies. It is intentionally non-stable and non-reactive.

### “... can only be called from Effects and Effect Events”

You are calling it from the wrong place, such as:

- an event handler
- a child prop
- general component logic

Switch to a normal callback if that is the real need.

## Practical decision line

Use `useEffectEvent` when an Effect-owned callback should read the latest render values without forcing the Effect itself to re-synchronize. Do not use it as a dependency escape hatch.
