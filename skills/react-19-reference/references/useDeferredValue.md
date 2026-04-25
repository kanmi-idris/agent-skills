# `useDeferredValue`

## Core purpose

Use `useDeferredValue` to let one part of the UI lag behind another so urgent updates stay responsive.

```js
const deferredValue = useDeferredValue(value, initialValue?)
```

## Mental model

`useDeferredValue` gives React permission to show stale data briefly while a lower-priority render catches up.

Typical shape:

- the source value updates immediately
- the deferred value stays on the previous version for a moment
- React attempts a background render with the newer value
- if more urgent updates happen, React can interrupt and restart that background work

This is about **rendering priority**, not artificial waiting.

## Use it when

- typing should stay responsive while a slow subtree catches up
- stale results are better than flashing a loading fallback
- a Suspense-enabled result view should keep showing previous content until fresh content is ready
- a large list, chart, or expensive subtree should update less urgently than the input driving it

Common fits:

- search input + results list
- filter input + slow table
- text input + slow chart or preview

## Do not use it when

- the problem is network request volume rather than render cost
- you need debouncing or throttling semantics
- the subtree can be made fast enough through ordinary optimization
- the passed value is an object recreated on every render

Rule:

- use `useDeferredValue` to deprioritize rendering
- use debouncing/throttling to control side effects like network requests

## Smallest good example

```tsx
import { memo, useDeferredValue, useState } from 'react'

const SlowList = memo(function SlowList({ text }) {
  return <div>{text}</div>
})

export default function App() {
  const [text, setText] = useState('')
  const deferredText = useDeferredValue(text)

  return (
    <>
      <input value={text} onChange={(e) => setText(e.target.value)} />
      <SlowList text={deferredText} />
    </>
  )
}
```

Why this works:

- the input reflects `text` immediately
- `SlowList` receives `deferredText`
- `memo` lets the slow subtree skip the urgent render while the deferred value is still unchanged

## Most important rule

`useDeferredValue` only helps if the deferred subtree can skip the urgent render.

In practice, that usually means the child receiving the deferred value must be memoized or otherwise able to bail out.

Without that, the parent still re-renders the slow subtree immediately and the optimization mostly disappears.

## Suspense behavior

`useDeferredValue` works especially well with Suspense.

If the background render with the new deferred value suspends:

- React keeps showing the previous deferred value
- the user keeps seeing stale content instead of the fallback
- when the new data is ready, React commits the updated UI

This gives a stale-while-refreshing feel rather than a flashing loading state.

## Stale UI indicator

A common pattern is to dim or annotate the stale content:

```tsx
const deferredQuery = useDeferredValue(query)
const isStale = query !== deferredQuery

return (
  <div style={{ opacity: isStale ? 0.5 : 1 }}>
    <SearchResults query={deferredQuery} />
  </div>
)
```

This makes it explicit that the screen is catching up.

## Important caveats

### It does not reduce network requests by itself

If each keystroke triggers a fetch, those fetches still happen.

`useDeferredValue` defers what gets rendered, not which requests are issued.

If you need fewer requests, add:

- debouncing
- throttling
- caching
- framework-level request coordination

### There is no fixed built-in delay

`useDeferredValue` is not “wait 300ms before updating.”

It adapts to:

- current device speed
- current render pressure
- whether React can finish the background work

### Transitions change the behavior

If the surrounding update is already in a Transition, `useDeferredValue` returns the new value immediately and does not spawn a separate deferred render.

### Value identity matters

Pass:

- primitives
- stable object references
- objects created outside render

Avoid:

```tsx
const deferredFilters = useDeferredValue({ query, sort })
```

inside render, because that object is new every render and causes unnecessary background work.

Prefer:

```tsx
const filters = useMemo(() => ({ query, sort }), [query, sort])
const deferredFilters = useDeferredValue(filters)
```

when you truly need an object value.

## How it differs from debouncing and throttling

### `useDeferredValue`

- render-priority control
- no fixed time delay
- interruptible background rendering
- adapts to device speed

### Debouncing

- waits until activity pauses
- useful for reducing side effects like network requests
- time-based

### Throttling

- limits how often something runs
- useful for scroll/resize/network/event work
- time-based

Use the React primitive for rendering problems, and time-based techniques for side-effect rate control.

## Common mistakes

### Expecting it to prevent fetching

It does not. It only changes when new UI is shown.

### Passing unstable objects

Fresh object identity each render undermines the usefulness of the deferred value.

### Using it without memoizing the slow subtree

If the subtree still re-renders eagerly, the benefit is limited.

### Using it where a normal optimization would be simpler

Try:

- fixing impure rendering
- trimming unnecessary work
- splitting components
- using `memo`

first when appropriate.

## Troubleshooting

### “The UI is still janky”

Check:

- is the slow child wrapped in `memo`?
- is the deferred value actually what the slow subtree receives?
- are you passing an always-new object?
- is the real bottleneck outside rendering?

### “The fallback still appears”

That may mean:

- the value is not actually deferred in the place that suspends
- the update is already in a Transition
- the Suspense boundary placement does not support the stale-content pattern you expect

### “Why does the deferred value sometimes update immediately?”

Because there is no guaranteed delay. If React can finish the work quickly, it will.

## Practical decision line

Use `useDeferredValue` when urgent UI should stay responsive while a slower subtree catches up. Treat it as render-priority control, not as request suppression or a generic debounce replacement.
