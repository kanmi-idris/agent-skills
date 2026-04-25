# `useCallback`

## Core purpose

Use `useCallback` to cache a function definition between re-renders so its identity stays stable until its dependencies change.

```js
const cachedFn = useCallback(fn, dependencies)
```

## React 19 mental model

In React 19, treat `useCallback` as a targeted performance tool, not a default habit.

Important context:

- React Compiler can automatically memoize values and functions
- this reduces the need for manual `useCallback`
- if the code only works when `useCallback` is present, there is usually a deeper design problem

## Use it when

- you pass a function prop to a child wrapped in `memo`
- a returned function from a custom Hook should have stable identity for consumers
- a function itself is used as a dependency of another Hook and stabilizing it is the clearest option

## Do not use it when

- there is no measured or plausible identity-sensitive optimization need
- the child is not memoized and does not care about function identity
- the real issue is unnecessary Effects, lifted state, or impure rendering
- you can move the function inside the Effect instead of memoizing it
- React Compiler already covers the memoization need for your setup

## Mental model

`useCallback` caches the **function itself**, not the result of calling it.

- `useMemo` caches a computed value
- `useCallback` caches a function reference

Equivalent mental shortcut:

```js
function useCallback(fn, dependencies) {
  return useMemo(() => fn, dependencies)
}
```

## Smallest good example

```tsx
import { memo, useCallback } from 'react'

const ShippingForm = memo(function ShippingForm({ onSubmit }) {
  return <button onClick={() => onSubmit({ quantity: 1 })}>Submit</button>
})

export default function ProductPage({ productId, referrer, theme }) {
  const handleSubmit = useCallback(
    (orderDetails) => {
      post('/product/' + productId + '/buy', {
        referrer,
        orderDetails,
      })
    },
    [productId, referrer]
  )

  return (
    <div className={theme}>
      <ShippingForm onSubmit={handleSubmit} />
    </div>
  )
}
```

Why this is a good fit:

- the child is memoized
- the callback is a prop
- stable identity can let the child skip re-rendering

## Most important rule

Only rely on `useCallback` as a performance optimization.

If removing it breaks correctness rather than performance, fix the underlying problem first.

## Best-use cases

### 1. Pairing with `memo`

This is the most common legitimate use.

If a slow child is wrapped in `memo`, and the only prop changing is a newly created function, `useCallback` can make the memoization effective.

### 2. Returning functions from a custom Hook

Stable identities help downstream consumers optimize their own components.

```tsx
function useRouter() {
  const { dispatch } = useContext(RouterStateContext)

  const navigate = useCallback((url) => {
    dispatch({ type: 'navigate', url })
  }, [dispatch])

  const goBack = useCallback(() => {
    dispatch({ type: 'back' })
  }, [dispatch])

  return { navigate, goBack }
}
```

### 3. Stabilizing a function dependency

This is sometimes valid, but usually there is a better simplification available.

Bad first instinct:

```tsx
const createOptions = useCallback(() => ({ roomId }), [roomId])

useEffect(() => {
  const connection = createConnection(createOptions())
  connection.connect()
  return () => connection.disconnect()
}, [createOptions])
```

Better when possible:

```tsx
useEffect(() => {
  const options = { roomId }
  const connection = createConnection(options)
  connection.connect()
  return () => connection.disconnect()
}, [roomId])
```

Rule:

- prefer removing the function dependency entirely
- use `useCallback` only when that makes the code genuinely clearer or is required by the API shape

## Dependency guidance

Dependencies must include every reactive value used inside the callback.

Common dependency sources:

- props
- state
- variables declared in the component body
- functions declared in the component body

If the callback only reads state to compute next state, prefer an updater function to remove that dependency.

Instead of:

```tsx
const handleAddTodo = useCallback((text) => {
  const newTodo = { id: nextId++, text }
  setTodos([...todos, newTodo])
}, [todos])
```

Prefer:

```tsx
const handleAddTodo = useCallback((text) => {
  const newTodo = { id: nextId++, text }
  setTodos((todos) => [...todos, newTodo])
}, [])
```

## Caveats worth preserving

- call it only at the top level of a component or custom Hook
- React may discard the cache in specific situations, such as file edits in development or suspension during initial mount
- `useCallback` does not stop the function from being created during render; React simply returns the cached one when dependencies are unchanged
- one always-new dependency is enough to break the memoization

## Common mistakes

### Adding it everywhere

This makes code noisier and often buys nothing.

Use it where function identity actually matters.

### Using it to paper over architecture problems

If the app is slow because of:

- lifted transient state
- Effect loops
- impure rendering
- unnecessary parent re-renders

then `useCallback` is not the first fix.

### Memoizing a function used only inside the same component

If the function is not passed anywhere identity-sensitive, `useCallback` often provides no benefit.

### Forgetting the dependency array

Without a dependency array, you get a new function every render.

```tsx
const handleSubmit = useCallback((orderDetails) => {
  post(orderDetails)
})
```

This defeats the purpose.

### Calling it inside a loop or condition

Like any Hook, it must stay at the top level.

If you need per-item callbacks, extract a child component or memoize the child instead.

## Troubleshooting

### “`useCallback` returns a different function every render”

Check:

- did you forget the dependency array?
- is one dependency always new?
- are you depending on an object or function that changes each render?

Use `Object.is` to compare dependency values across renders when debugging.

### “I need `useCallback` for every list item”

You cannot call Hooks inside loops. Extract an item component:

```tsx
function ReportList({ items }) {
  return items.map((item) => <Report key={item.id} item={item} />)
}

function Report({ item }) {
  const handleClick = useCallback(() => {
    sendReport(item)
  }, [item])

  return <Chart onClick={handleClick} />
}
```

Or memoize the item component itself instead.

## Practical decision line

Use `useCallback` when stable function identity unlocks a real optimization or API requirement. In React 19, default to clearer code first, and let React Compiler reduce manual memoization where available.
