# `memo`

## Core purpose

Use `memo` to let React skip re-rendering a component when its props are unchanged.

```js
const MemoizedComponent = memo(Component, arePropsEqual?)
```

## Mental model

`memo` wraps a component in a prop-stability gate.

If the parent re-renders but the memoized component receives the same props, React can skip re-rendering that child.

Important boundary:

- `memo` is a performance optimization
- it is not a correctness primitive
- React may still re-render the component in some cases

## React 19 posture

In React 19, especially with React Compiler, manual `memo` is needed less often.

So the default stance should be:

- do not add `memo` by reflex
- use it where prop stability actually matters
- prefer structural fixes before memoization

If the compiler is enabled, many `memo` use cases become unnecessary.

## Use it when

- a component re-renders often with the same props
- the component is actually expensive to re-render
- the component sits behind a real prop identity boundary
- you have measured or strongly observed that this boundary matters

Good fits:

- slow list items
- heavy visual editors
- expensive derived child trees
- components receiving stable primitive props or intentionally memoized values

## Do not use it when

- the component is cheap
- props are always new anyway
- you are trying to fix a correctness bug
- the real problem is state placement, effects, or impure rendering

If the props change every render, `memo` buys you nothing.

## Smallest good example

```tsx
import { memo } from 'react'

const Greeting = memo(function Greeting({ name }) {
  return <h1>Hello, {name}!</h1>
})
```

If the parent re-renders but `name` has not changed, React can skip re-rendering `Greeting`.

## Biggest rule

`memo` only helps when props are stable.

If the parent keeps passing fresh objects, arrays, or functions, the memo boundary is broken.

Bad:

```tsx
const Profile = memo(function Profile({ person }) {
  // ...
})

function Page() {
  return <Profile person={{ name: 'Taylor', age: 42 }} />
}
```

That object is new on every render.

Better:

```tsx
function Page() {
  const person = useMemo(() => ({ name: 'Taylor', age: 42 }), [])
  return <Profile person={person} />
}
```

Or better still, pass simpler props:

```tsx
function Page() {
  return <Profile name="Taylor" age={42} />
}
```

## What `memo` does not block

Even memoized components still re-render when:

- their own state changes
- a context they read changes

`memo` only compares props from the parent. It does not freeze the component.

## Prefer structural fixes first

Before adding `memo`, first consider:

- moving state closer to where it is used
- passing JSX as children for wrapper components
- removing unnecessary Effects
- reducing prop churn
- simplifying prop shapes
- fixing impure render logic

These often eliminate the need for memoization entirely.

## `memo` and prop design

You get more value from `memo` when props are:

- minimal
- stable
- primitive where possible

Prefer:

- `name`, `age`, `hasGroups`

over:

- one large object with many fields
- projected values recreated every render

Prop design matters as much as the memo boundary itself.

## Custom comparison functions

`memo(Component, arePropsEqual)` is a last-mile optimization for rare cases.

Use it only when:

- you cannot practically stabilize props upstream
- the component is expensive
- the custom comparison is actually cheaper than re-rendering

And if you write one:

- compare every prop, including functions
- avoid deep equality unless the structure is tightly bounded

Bad custom comparisons can be slower and more bug-prone than just rendering.

## The most dangerous pitfall

If your custom comparator ignores function props, you can trap stale closures from older renders.

That can make event handlers behave with old props or state and produce very confusing bugs.

If you use a custom comparator, it must reflect the full behavioral contract of the component, not just visual output.

## `memo` vs `useMemo`

These are different:

- `memo` skips re-rendering a component when props are unchanged
- `useMemo` caches a value calculation inside a component

They often work together, but they solve different problems.

Typical pairing:

- parent uses `useMemo` or `useCallback` to stabilize props
- child uses `memo` to benefit from those stable props

## `memo` vs React Compiler

With React Compiler enabled, many manual `memo` cases become redundant.

That means the modern default is:

- rely on the compiler first when available
- keep `memo` only where it still earns its keep or is explicitly needed

So if someone asks “Should I add `memo` everywhere?”, the answer is no.

## Common mistakes

### Wrapping cheap components everywhere

This adds noise without meaningful benefit.

### Memoizing components whose props always change

That gives no win.

### Using `memo` to cover up bad state placement

The component graph is still doing the wrong work.

### Writing a slow or incomplete custom comparator

That can be worse than the re-render you were trying to avoid.

## Troubleshooting

### "My memoized component still re-renders"

Check whether:

- its own state changed
- a consumed context changed
- one of its props is a fresh object, array, or function
- the parent is rebuilding values every render

### "Should I use `memo` if I use React Compiler?"

Usually less often. Keep it only where it still matters after measurement or clear reasoning.

### "Do I need `useCallback` or `useMemo` too?"

Only if prop identity is the real issue and those values need to stay stable for the memo boundary to work.

## Practical guidance

Use `memo` when you have a real prop-stability boundary around an actually expensive component.

If you cannot explain which stable props make the skip possible, or why the skipped render matters, you probably do not need it.
