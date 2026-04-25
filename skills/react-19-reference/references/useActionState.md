# `useActionState`

## Core purpose

Use `useActionState` to manage the state of user-triggered Actions that may perform side effects and need a pending signal.

```js
const [state, dispatchAction, isPending] = useActionState(reducerAction, initialState, permalink?)
```

## Mental model

Think of it as `useReducer` for side-effectful Actions.

- `useReducer` manages pure UI transitions.
- `useActionState` manages the result of Actions that can perform async work and side effects.

## Use it when

- A form submission should update UI from the result of an async action
- A user action needs both **result state** and **pending state**
- The next action depends on the previous completed action
- You are working with Server Functions / Actions and want state to track the result
- You want to combine a canonical async state source with `useOptimistic`

## Do not use it when

- The state is just local UI state with no side effects
- The reducer must stay pure
- The work should happen in parallel rather than sequentially
- You only need a basic loading flag around a one-off state setter

In those cases, prefer `useState`, `useReducer`, or `useTransition` directly.

## Signature and return values

```js
const [state, dispatchAction, isPending] = useActionState(reducerAction, initialState, permalink?)
```

- `state`: current action state, initially `initialState`
- `dispatchAction`: function that triggers the reducer action
- `isPending`: whether any dispatched actions for this hook are still pending

## Reducer action shape

```js
async function reducerAction(previousState, actionPayload) {
  const nextState = await submit(actionPayload)
  return nextState
}
```

Key details:

- first arg is always `previousState`
- second arg is the dispatched payload or submitted `FormData`
- it may be sync or async
- it may perform side effects
- it must return the next state value

## Key rules

1. Call `useActionState` only at the top level of a component or custom Hook.
2. Call `dispatchAction` only inside an Action context.
3. If you trigger `dispatchAction` manually, wrap it in `startTransition`.
4. If you pass `dispatchAction` to a form `action` prop or another Action prop, React handles the Transition for you.
5. Multiple dispatches are queued and run sequentially.

## Smallest good example

```tsx
import { startTransition, useActionState } from 'react'

async function incrementAction(previousCount) {
  await new Promise((resolve) => setTimeout(resolve, 300))
  return previousCount + 1
}

export default function Counter() {
  const [count, dispatchAction, isPending] = useActionState(incrementAction, 0)

  function handleClick() {
    startTransition(() => {
      dispatchAction()
    })
  }

  return (
    <button onClick={handleClick}>
      {isPending ? 'Updating...' : `Count: ${count}`}
    </button>
  )
}
```

## Multi-action pattern

Use an action payload with a `type` field when one hook handles several related actions.

```tsx
async function cartAction(previousCount, payload) {
  switch (payload.type) {
    case 'ADD':
      return previousCount + 1
    case 'REMOVE':
      return Math.max(0, previousCount - 1)
    default:
      return previousCount
  }
}
```

This is a good fit when the actions are logically related and still need sequential processing.

## Forms

When used with a form action:

- React automatically treats the submission as an Action
- you do not need to call `startTransition` yourself
- the reducer action receives `previousState` as arg 1 and `FormData` as arg 2

```tsx
const [state, dispatchAction] = useActionState(saveAction, initialState)

return <form action={dispatchAction}>...</form>
```

If the action needs to read the form values, remember:

```js
async function saveAction(previousState, formData) {
  const value = formData.get('name')
  return { ...previousState, value }
}
```

## With `useOptimistic`

Pair `useActionState` with `useOptimistic` when the server-confirmed state should remain canonical, but the UI should respond immediately.

Good fit:

- counters
- toggles
- cart steppers
- lightweight form feedback

Rule:

- `useActionState` owns the confirmed state
- `useOptimistic` owns the temporary UI preview

## Error handling

There are two categories of errors:

### Known / recoverable errors

Return them as part of state.

```js
async function saveAction(previousState, payload) {
  const result = await submit(payload)
  if (result.error) {
    return { ...previousState, error: result.error }
  }
  return { data: result.data, error: null }
}
```

### Unknown / programmer errors

Throw them and let the nearest Error Boundary handle them.

If one queued action throws, React cancels later queued actions for that hook.

## Sequential queuing

This is one of the most important caveats.

`useActionState` does **not** run multiple dispatches in parallel. It queues them. Each action receives the result of the previous one.

This is correct when:

- the next action depends on the previous result
- order matters

This is a bad fit when:

- the requests should run independently
- the latest click should win without replaying every earlier action

In those cases, prefer another pattern or explicitly manage cancellation.

## Cancellation

If you truly need to skip stale queued work, use an `AbortController` in your own action flow.

Only do this when aborting is actually safe. Aborting a request does not undo a server-side mutation that already happened.

## `permalink`

The optional `permalink` parameter matters for progressive enhancement with React Server Components / Server Functions.

Use it when:

- the form may submit before hydration
- the destination URL must be explicit

Do not overemphasize it for normal client-only usage.

## Caveats worth preserving

- `dispatchAction` has a stable identity
- `initialState` is ignored after the first dispatch
- `reducerAction` is not double-invoked in Strict Mode
- server-side payloads and initial state must be serializable
- if you update state after `await` in related transition flows, extra `startTransition` handling may still be required
- ongoing actions may batch together in current React behavior

## Common mistakes

### Calling `dispatchAction` outside a Transition

This breaks pending behavior and logs a development error.

Fix:

```js
startTransition(() => {
  dispatchAction(payload)
})
```

### Forgetting the extra `previousState` argument

Without `useActionState`:

```js
function action(formData) {}
```

With `useActionState`:

```js
function action(previousState, formData) {}
```

### Treating it like `useReducer`

Do not use it as a generic reducer replacement. The point is action state with side effects and pending behavior.

### Calling `dispatchAction` during render

This creates an update loop and is invalid.

Only dispatch from:

- event handlers
- form actions
- Action props
- other valid Action contexts

## Troubleshooting

### `isPending` never updates

You probably called `dispatchAction` outside `startTransition` and outside a form/action prop.

### Some queued actions were skipped

An earlier action likely threw. Catch recoverable errors and return error state instead.

### The state does not reset

There is no built-in reset API. Model reset as another action payload, remount with a new `key`, or rely on form reset behavior where appropriate.

### Form data is missing

You probably read `formData` from argument 1 instead of argument 2.

## Decision line

Use `useActionState` when the state you care about is the result of an Action. Do not use it as a default replacement for `useReducer`.
