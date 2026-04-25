# `useReducer`

## Core purpose

Use `useReducer` when component state has enough structure or transition logic that a reducer makes updates clearer than scattered `useState` calls.

```js
const [state, dispatch] = useReducer(reducer, initialArg, init?)
```

## Mental model

`useReducer` separates:

- state shape
- allowed transitions
- event handlers that describe what happened

Instead of putting update logic inline inside every handler, handlers dispatch actions and the reducer decides the next state.

This is most useful when state transitions are related, repeated, or easier to reason about as named actions.

## Use it when

- state updates depend on the previous state in many places
- several fields change together for one interaction
- a component has many event handlers that all touch the same state
- you want explicit action names and centralized transition logic
- state logic is getting hard to read with multiple `useState` calls

Good fits:

- forms with several related fields
- editable lists
- task or cart state with add/edit/delete transitions
- local workflow state with clear action names

## Do not use it when

- state is simple and a few `useState` calls are clearer
- you are introducing reducer ceremony without real complexity
- you are trying to replace normal React data flow with a local reducer
- the reducer mostly forwards one field change at a time and adds no clarity

`useReducer` is for organizing state transitions, not for making every component look like Redux.

## Smallest good example

```tsx
import { useReducer } from 'react'

function reducer(state, action) {
  switch (action.type) {
    case 'incremented_age':
      return { ...state, age: state.age + 1 }
    case 'changed_name':
      return { ...state, name: action.nextName }
    default:
      throw new Error('Unknown action: ' + action.type)
  }
}

function ProfileForm() {
  const [state, dispatch] = useReducer(reducer, {
    name: 'Taylor',
    age: 42,
  })

  return (
    <>
      <input
        value={state.name}
        onChange={(e) => {
          dispatch({ type: 'changed_name', nextName: e.target.value })
        }}
      />
      <button
        onClick={() => {
          dispatch({ type: 'incremented_age' })
        }}
      >
        Increment age
      </button>
    </>
  )
}
```

## What `useReducer` gives you

`useReducer` returns:

1. the current state
2. a stable `dispatch` function

`dispatch(action)` does not synchronously change the `state` variable in the current call stack. It schedules the next render with the reducer result.

That means this is expected:

```tsx
dispatch({ type: 'incremented_age' })
console.log(state.age) // still the old value in this running handler
```

## Action design

Actions should describe what happened, not how to mutate state.

Prefer:

- `{ type: 'added', text }`
- `{ type: 'deleted', id }`
- `{ type: 'changed_name', nextName }`

Keep action payloads as small as the reducer needs.

## Reducer rules

Reducers must be:

- pure
- synchronous
- deterministic from `(state, action) => nextState`

Reducers must not:

- mutate existing state
- run side effects
- perform async work

If you need effects, keep them in event handlers or Effects around the reducer state.

## Immutability is not optional

Bad:

```tsx
function reducer(state, action) {
  switch (action.type) {
    case 'incremented_age':
      state.age += 1
      return state
    default:
      return state
  }
}
```

Correct:

```tsx
function reducer(state, action) {
  switch (action.type) {
    case 'incremented_age':
      return { ...state, age: state.age + 1 }
    default:
      return state
  }
}
```

For arrays, return new arrays with `map`, `filter`, or spread.

## When `useReducer` is better than `useState`

Prefer `useReducer` when:

- several state updates are coupled
- update logic is duplicated across handlers
- the next state is easier to express through named actions
- you want one auditable place to review allowed transitions

Prefer `useState` when:

- state is local and simple
- updates are straightforward
- a reducer would add boilerplate without adding clarity

## Initializer function

If initial state is expensive to build, pass an initializer as the third argument:

```tsx
function createInitialState(username) {
  return {
    draft: '',
    todos: bigDerivedListFor(username),
  }
}

const [state, dispatch] = useReducer(
  reducer,
  username,
  createInitialState
)
```

This avoids recreating expensive initial state on every render.

## Stable dispatch identity

`dispatch` has stable identity.

That is why it is usually safe to omit from Effect dependency arrays when the linter allows it.

## Strict Mode behavior

In development Strict Mode, React may call the reducer and initializer twice to surface impurity bugs.

If calling them twice changes behavior, they are impure.

## Common mistakes

### Mutating state and returning the same object

React may skip rendering because the object identity did not change.

### Forgetting to preserve existing fields

Bad:

```tsx
return { age: state.age + 1 }
```

Usually you want:

```tsx
return { ...state, age: state.age + 1 }
```

### Dispatching during render

That causes render loops and "Too many re-renders".

Dispatch from event handlers, Effects, or other callbacks, not from render.

## Troubleshooting

### "I dispatched, but logging still shows old state"

State is a snapshot for the current render. Compute the next state manually with the reducer if you need to inspect it immediately:

```tsx
const action = { type: 'incremented_age' }
dispatch(action)
const nextState = reducer(state, action)
```

### "The screen does not update"

You probably mutated state and returned the same object or array reference.

### "Part of my state became undefined"

One branch returned an incomplete object and forgot to copy the previous fields.

### "Everything became undefined"

One branch is missing a return, or your reducer fell through an unknown action type. Throw on unknown actions so this fails loudly.

## Practical guidance

Reach for `useReducer` when it makes transitions more legible, not automatically when state grows.

If you cannot point to the action vocabulary or transition complexity it clarifies, `useState` is probably the better default.
