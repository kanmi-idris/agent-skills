# `useMemo`

## Core purpose

Use `useMemo` to cache the result of a calculation between re-renders.

```js
const cachedValue = useMemo(calculateValue, dependencies)
```

## React 19 mental model

In React 19, treat `useMemo` as a targeted performance tool, not a default coding style.

Important context:

- React Compiler can automatically memoize values and functions
- this reduces the need for manual `useMemo`
- if the code only works when `useMemo` is present, there is usually a deeper problem

## Most important rule

Only rely on `useMemo` as a performance optimization.

If removing it breaks correctness rather than performance, redesign the code first.

## Mental model

`useMemo` caches the **result of a calculation**, not the function itself.

- `useMemo` caches a computed value
- `useCallback` caches a function reference

Typical use:

- skip an expensive recalculation
- preserve value identity so a memoized child can skip re-rendering
- stabilize a value that is itself a dependency of another Hook

## Use it when

- the calculation is measurably expensive and dependencies rarely change
- the computed value is passed to a child wrapped in `memo`
- the computed value is itself used as a dependency and identity stability matters

Good fits:

- filtering a large list
- expensive derived data
- stable arrays/objects passed to memoized children
- memoized dependency values in carefully chosen cases

## Do not use it when

- the calculation is cheap
- you have not verified a real identity-sensitive or performance-sensitive reason
- you are using it to avoid simpler structural fixes
- you could move an object inside an Effect or inside the memoized calculation itself

## Smallest good example

```tsx
import { useMemo } from 'react'

function TodoList({ todos, tab, theme }) {
  const visibleTodos = useMemo(() => {
    return filterTodos(todos, tab)
  }, [todos, tab])

  return <div className={theme}>{/* render visibleTodos */}</div>
}
```

Why this is a good fit:

- the calculation is the thing being memoized
- dependencies are explicit
- unrelated updates like `theme` changes can avoid recomputing the filtered list

## High-value use cases

### 1. Skip expensive recalculation

This is the clearest reason to use `useMemo`.

If a calculation is actually expensive, `useMemo` can skip re-running it when dependencies are unchanged.

### 2. Preserve value identity for `memo` children

If a child is wrapped in `memo`, but you pass it a freshly created array/object every render, the memoization may be defeated.

`useMemo` can preserve the derived value identity:

```tsx
const visibleTodos = useMemo(() => filterTodos(todos, tab), [todos, tab])
return <List items={visibleTodos} />
```

### 3. Stabilize a dependency value when absolutely necessary

Sometimes a Hook depends on an object or array. If identity matters and a simpler refactor is not better, `useMemo` can stabilize that value.

But first ask whether the object can simply be moved inside the Hook that uses it.

## Better before memoizing

Before adding `useMemo`, prefer:

- keeping rendering logic pure
- avoiding unnecessary Effects
- keeping transient state local
- passing JSX as `children` when it reduces cascading re-renders
- moving object/function creation into Effects when the value only matters there

Many performance issues are structural, not memoization problems.

## `useMemo` vs `useCallback`

- use `useMemo` when the output is a value
- use `useCallback` when the output is a function

If you find yourself writing:

```tsx
const handleSubmit = useMemo(() => {
  return (orderDetails) => {
    post(orderDetails)
  }
}, [deps])
```

that is a `useCallback` case.

## Dependency guidance

Dependencies must include every reactive value used inside the calculation:

- props
- state
- variables declared in the component body
- functions declared in the component body

If one dependency is always new, the memoization is effectively broken.

## Important caveats

- Hook rules still apply: top level only
- Strict Mode may call the calculation twice in development to expose impurity
- React may discard cached values in specific situations, so do not treat memoization as a semantic guarantee
- if you need guaranteed persistence rather than performance caching, use state or refs instead

## Common mistakes

### Adding it everywhere

This often adds noise without measurable benefit.

### Using it for correctness

If your code breaks without `useMemo`, the real issue is elsewhere.

### Memoizing a dependency that could be moved inward

Bad first move:

```tsx
const searchOptions = useMemo(() => {
  return { matchMode: 'whole-word', text }
}, [text])

const visibleItems = useMemo(() => {
  return searchItems(allItems, searchOptions)
}, [allItems, searchOptions])
```

Often better:

```tsx
const visibleItems = useMemo(() => {
  const searchOptions = { matchMode: 'whole-word', text }
  return searchItems(allItems, searchOptions)
}, [allItems, text])
```

### Using it to stabilize an Effect dependency when a simpler refactor exists

If an object only exists for an Effect, move it into the Effect instead of memoizing it first.

### Forgetting the dependency array

Without dependencies, the calculation runs every render.

### Returning `undefined` by accident

Arrow functions with braces need an explicit `return` when returning an object:

```tsx
const value = useMemo(() => {
  return { text }
}, [text])
```

## Troubleshooting

### “My memoized calculation still runs every render”

Check:

- did you forget the dependency array?
- is one dependency always new?
- are you memoizing the right thing?

Use `Object.is` to inspect dependency stability across renders.

### “My calculation runs twice in development”

That is usually Strict Mode exposing impurity. The calculation must be pure.

### “I need `useMemo` inside a loop”

You cannot call Hooks in loops. Extract a child component and memoize at that component’s top level, or memoize the child component itself.

## Practical decision line

Use `useMemo` when a calculation is expensive enough to justify caching, or when value identity must stay stable for a real optimization boundary. In React 19, default to clear code first and let the compiler reduce manual memoization where available.
