# `useTransition`

## Core purpose

Use `useTransition` when some state updates should be treated as non-urgent so urgent interactions can stay responsive.

```js
const [isPending, startTransition] = useTransition()
```

## Mental model

`useTransition` lets you mark updates as background work.

Urgent updates should happen immediately.
Transition updates can lag behind, be interrupted, and finish later.

This is primarily about scheduling priority and user experience, not about “making async code work.”

Think of it like this:

- urgent state keeps input and click feedback snappy
- transition state updates slower parts of the UI in the background
- `isPending` tells you when that background work is still in flight

## Use it when

- a slower UI update should not block more urgent interaction
- navigation-like state changes should be interruptible
- a Suspense-enabled transition should avoid hiding already revealed UI
- you want a pending visual state around background rendering work

Good fits:

- tab switches
- route navigations
- rendering slow results panes
- background updates after async actions
- framework or router-level navigation wrappers

## Do not use it when

- the update is urgent and must happen synchronously
- you are controlling a text input value
- you just need stale-while-refreshing derived UI and `useDeferredValue` fits better
- you need guaranteed request ordering across async boundaries without handling it yourself

`useTransition` is not a replacement for all loading-state logic, and it is not a request queue.

## What it returns

`useTransition()` returns:

1. `isPending`
2. `startTransition`

`startTransition(action)` immediately runs `action`, but marks state updates scheduled during that call as Transition updates.

## Smallest good example

```tsx
import { useState, useTransition } from 'react'

function TabContainer() {
  const [tab, setTab] = useState('about')
  const [isPending, startTransition] = useTransition()

  function selectTab(nextTab) {
    startTransition(() => {
      setTab(nextTab)
    })
  }

  return (
    <>
      <button onClick={() => selectTab('about')}>About</button>
      <button onClick={() => selectTab('posts')}>
        {isPending && tab !== 'posts' ? 'Loading posts...' : 'Posts'}
      </button>
    </>
  )
}
```

## The most important boundary

Transitions are for non-urgent rendering work.

They should not control input state:

```tsx
const [text, setText] = useState('')

function handleChange(e) {
  startTransition(() => {
    setText(e.target.value)
  })
}
```

That is wrong because controlled inputs must update synchronously.

If typing should stay fast while slower UI catches up, use one of these patterns instead:

- keep input state urgent and move slower updates into a Transition
- or use `useDeferredValue` so slower rendering can lag behind the urgent input value

## Actions

The function passed to `startTransition` is commonly called an Action.

By convention, callbacks intended to run inside transitions are often named:

- `action`
- `submitAction`
- `navigateAction`
- something with an `Action` suffix

This makes it clearer that the callback participates in transition work.

## Async caveat

If you `await` inside `startTransition`, state updates after the `await` are not automatically treated as Transition updates.

Bad:

```tsx
startTransition(async () => {
  await save()
  setPage('/done')
})
```

Current correct pattern:

```tsx
startTransition(async () => {
  await save()
  startTransition(() => {
    setPage('/done')
  })
})
```

That extra nested `startTransition` is a current limitation, not the conceptual goal.

## What `isPending` is good for

Use `isPending` to show lightweight feedback without blocking interaction:

- pending tab button styles
- dimmed layouts
- “Updating...” labels
- temporarily disabled non-critical buttons

`isPending` is especially useful when the transition should preserve already revealed UI while signaling background work.

## Suspense interaction

One major reason to use transitions is preventing jarring fallback replacement.

If a transition causes a Suspense boundary to suspend, React tries to keep already revealed content visible instead of immediately replacing it with a fallback.

This is why transitions are a good default for:

- navigations
- tab switches
- route-level content replacement

## Best fit: navigation-style updates

If you are building a router, framework navigation layer, or tab system, transitions are usually the right default for view changes.

Why:

- they are interruptible
- they preserve responsiveness
- they reduce unwanted loading flashes
- they pair well with Suspense-enabled data loading

## Action props

A useful pattern is exposing an `action` prop from a child component and awaiting it inside a transition.

```tsx
function TabButton({ action, children }) {
  const [isPending, startTransition] = useTransition()

  return (
    <button
      onClick={() => {
        startTransition(async () => {
          await action()
        })
      }}
    >
      {isPending ? 'Loading...' : children}
    </button>
  )
}
```

This lets parent-owned state updates still participate in a transition through the child wrapper.

## Interruptibility

Transition work is interruptible.

That means if a slow transition render is in progress and the user performs a more urgent interaction, React can pause or restart the transition work so the urgent interaction wins.

This is exactly why transitions help responsiveness.

## Known limitations

### 1. No controlled input updates

Transition updates cannot control text inputs.

### 2. Async ordering is not guaranteed for custom workflows

If you launch multiple async transition actions, earlier requests can finish after later ones.

React does not automatically infer the intended network ordering in your custom transition code.

For higher-level cases, prefer:

- `useActionState`
- `<form>` actions
- framework abstractions that already handle ordering

### 3. Multiple transitions are currently batched together

This is a current implementation limitation.

## Common mistakes

### Treating `startTransition` like `setTimeout`

The callback runs immediately. Only the scheduled state updates get lower priority.

### Expecting updates after `await` to stay in the same transition automatically

They currently do not.

### Using transitions for input state

This breaks controlled input expectations.

### Assuming request completion order is preserved

It is not automatically preserved for custom async transition flows.

## Troubleshooting

### "My state update is not treated as a Transition"

Make sure the state update happens during the `startTransition` call itself, not later in something like `setTimeout`.

### "My state update after await is not treated as a Transition"

Wrap the post-`await` state update in another `startTransition`.

### "I want to use this outside a component"

Use the standalone `startTransition` API instead of `useTransition`.

### "My updates are out of order"

You crossed async boundaries and now own the ordering problem. Use a higher-level abstraction or implement your own ordering, abort, or stale-response protection.

## Practical guidance

Reach for `useTransition` when you need user-perceived responsiveness around slower rendering work.

If the update is urgent, keep it urgent.

If the update is navigation-like, interruptible, or should avoid blowing away already visible UI with fallbacks, `useTransition` is often the right tool.
