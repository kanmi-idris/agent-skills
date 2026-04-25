# `useOptimistic`

## Core purpose

Use `useOptimistic` to show temporary optimistic UI while an Action is in progress.

```js
const [optimisticState, setOptimistic] = useOptimistic(value, reducer?)
```

## Mental model

`useOptimistic` does not create a second permanent source of truth.

It temporarily overlays an optimistic version of a canonical value while an Action is pending.

Think of it like this:

- `value` is the canonical state or prop
- optimistic updates are shown immediately during the Action
- when the Action finishes, the UI converges back to whatever `value` is now

This makes it ideal for immediate feedback without committing to success too early.

## Most important rule

Call the optimistic setter only inside an Action or `startTransition`.

If you call it outside that context, React will warn and the optimistic state will not behave correctly.

## Use it when

- the UI should update immediately before the server confirms the change
- a pending optimistic item or state improves perceived responsiveness
- you want a temporary “Submitting...”, “Liked”, or “Adding...” state during async work
- multiple related fields need an optimistic overlay while canonical state lives elsewhere

Good fits:

- like/unlike buttons
- pending button states
- adding items to a list
- optimistic follow/unfollow
- optimistic counters or steppers

## Do not use it when

- the state should be permanently owned locally
- there is no Action/Transition boundary
- you really need canonical state management rather than temporary optimistic overlay
- you are trying to replace `useState` or `useReducer` wholesale

## Smallest good example

```tsx
import { startTransition, useOptimistic } from 'react'

function LikeButton({ isLiked, saveLike }) {
  const [optimisticIsLiked, setOptimisticIsLiked] = useOptimistic(isLiked)

  function handleClick() {
    startTransition(async () => {
      const next = !optimisticIsLiked
      setOptimisticIsLiked(next)
      await saveLike(next)
    })
  }

  return (
    <button onClick={handleClick}>
      {optimisticIsLiked ? '❤️ Unlike' : '🤍 Like'}
    </button>
  )
}
```

Why this is a good fit:

- immediate feedback matters
- canonical state lives outside the optimistic overlay
- the Action determines when optimistic UI should exist

## How it works

During an Action:

1. you call the optimistic setter
2. React immediately renders the optimistic state
3. the async Action continues
4. when canonical `value` updates, optimistic and canonical state converge in the same render

There is no separate “clear optimistic state” step. The hook simply renders `value` again once the Action is over.

## Updater vs reducer

`useOptimistic` supports two useful patterns.

### 1. Direct value or updater

Best when the next optimistic state is simple.

```tsx
const [optimisticLike, setOptimisticLike] = useOptimistic(false)

setOptimisticLike(true)
setOptimisticLike((current) => !current)
```

### 2. Reducer

Best when:

- the optimistic state is derived from current state plus an action payload
- multiple fields must update together
- base state may change while the Action is pending
- multiple action types exist

```tsx
const [optimisticCart, dispatch] = useOptimistic(
  cart,
  (currentCart, action) => {
    switch (action.type) {
      case 'add':
        return [...currentCart, action.item]
      default:
        return currentCart
    }
  }
)
```

## Choosing reducer vs updater

Use an updater when:

- the update is simple
- the setter call naturally describes the next optimistic state

Use a reducer when:

- the base value may change during the pending Action
- multiple related fields must stay in sync
- you need payload-based updates
- you want multiple action types

This matters especially for lists and shared state where canonical data may update while the optimistic overlay is still pending.

## High-value patterns

### 1. Pending button state

```tsx
const [isPending, setIsPending] = useOptimistic(false)
```

Useful for disabling controls and showing labels like “Submitting...”.

### 2. Optimistic list insertion

Reducer form is usually best:

```tsx
const [optimisticTodos, addOptimisticTodo] = useOptimistic(
  todos,
  (currentTodos, newTodo) => [
    ...currentTodos,
    { ...newTodo, pending: true },
  ]
)
```

### 3. Optimistic multi-field updates

When one action changes several fields together, update them through one reducer so the optimistic UI stays internally consistent.

## Failure behavior

If the Action fails and canonical `value` does not update, optimistic UI falls back to the current canonical value after the Action ends.

This often looks like a rollback.

If you need user feedback, catch the error and render an error message separately.

## Important caveats

- the setter must be called inside an Action or `startTransition`
- optimistic state is temporary, not canonical
- `value` determines what renders once the Action is over
- if base state changes during a pending Action, reducers are often safer than naive direct assignments

## Common mistakes

### Calling the setter outside an Action

Bad:

```tsx
function handleClick() {
  setOptimistic(nextValue)
}
```

Correct:

```tsx
function handleClick() {
  startTransition(async () => {
    setOptimistic(nextValue)
    await save()
  })
}
```

### Treating optimistic state as canonical state

The optimistic state is only a temporary overlay. The real source of truth is still `value`.

### Using direct values where a reducer is safer

If the base state can change during the pending Action, a reducer better preserves correctness against the latest canonical data.

### Updating optimistic state during render

That is invalid, just like other state updates during render.

## Pending-state strategies

If you want to know whether an optimistic update is pending, common patterns are:

### 1. Compare optimistic vs canonical value

```tsx
const isPending = optimisticValue !== value
```

### 2. Use `useTransition`

This can expose a pending signal alongside the Action itself.

### 3. Encode pending into the optimistic reducer output

For example:

```tsx
{ ...item, pending: true }
```

This is often the best option for list items because it gives per-item UI feedback.

## Troubleshooting

### “An optimistic state update occurred outside a Transition or Action”

Move the optimistic setter into `startTransition` or an Action prop.

### “Cannot update optimistic state while rendering”

You are calling the setter during render. Move it into an event handler, Effect-owned flow, or Action callback.

### “My optimistic update shows stale values”

Use:

- an updater function
- or preferably a reducer when the base state may change during the Action

### “I don’t know whether the optimistic state is pending”

Use value comparison, `useTransition`, or a reducer-level `pending` flag depending on the UI shape.

## Practical decision line

Use `useOptimistic` when canonical state lives elsewhere but the UI should reflect the likely result immediately during an Action. Treat it as a temporary overlay, not a replacement for real state ownership.
