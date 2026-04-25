# `<Profiler>`

## Core purpose

Use `<Profiler>` to measure render performance of a specific React subtree programmatically.

```js
<Profiler id="App" onRender={onRender}>
  <App />
</Profiler>
```

## Mental model

`<Profiler>` is an instrumentation boundary.

It does not optimize rendering by itself.

Instead, it reports:

- what part of the tree rendered
- whether it mounted or updated
- how long the render took
- how expensive the subtree would be without memoization

This makes it useful for targeted measurement, not for everyday wrapping of normal components.

## Use it when

- you need programmatic render timing for a specific subtree
- you are collecting render performance telemetry
- you want to compare actual render cost against memoized baseline cost
- you need multiple measurement boundaries in one app

Good fits:

- profiling a known slow panel
- measuring a custom editor or list subtree
- comparing memoization effectiveness in a critical region
- correlating render phases with user interactions in diagnostics

## Do not use it when

- you just want to optimize blindly
- React DevTools Profiler already answers the question
- you are wrapping broad parts of the app without a measurement goal
- you expect `<Profiler>` to improve performance directly

`<Profiler>` measures. It does not fix.

## Smallest good example

```tsx
import { Profiler } from 'react'

function onRender(id, phase, actualDuration, baseDuration) {
  console.log({
    id,
    phase,
    actualDuration,
    baseDuration,
  })
}

function App() {
  return (
    <Profiler id="Sidebar" onRender={onRender}>
      <Sidebar />
    </Profiler>
  )
}
```

## What `onRender` tells you

`onRender` receives:

- `id`
- `phase`
- `actualDuration`
- `baseDuration`
- `startTime`
- `commitTime`

The two highest-signal numbers are usually:

- `actualDuration`: how long this render actually took
- `baseDuration`: estimated cost if the whole subtree had to fully render without memoization help

That comparison helps answer whether memoization is doing useful work.

## Phase meanings

Typical phases:

- `"mount"`
- `"update"`
- `"nested-update"`

This helps distinguish initial cost from repeated update cost.

## Best practice: profile intentionally

Wrap only the region you are actually investigating.

Examples:

- sidebar only
- editor only
- search results only
- one nested expensive subtree inside a larger page

Multiple profilers are fine when you need to compare regions, but each profiling boundary still adds overhead.

## Production caveat

Profiling is disabled in normal production builds by default.

If you need profiling data in production-like conditions, use a profiling-enabled production build. Otherwise, do not assume the component will emit profiling data in standard production output.

## Relationship to React DevTools

If you just need interactive inspection, React DevTools Profiler is often the simpler first step.

Use `<Profiler>` when you specifically need:

- programmatic logging
- custom aggregation
- app-owned measurement hooks
- correlation with app events or telemetry

## What it is good for

### 1. Finding expensive subtrees

Measure a suspicious region directly.

### 2. Verifying memoization impact

Compare `actualDuration` against `baseDuration`.

### 3. Tracking render regressions

Log or aggregate timings over time.

### 4. Comparing different app regions

Use multiple profilers with different `id` values.

## Common mistakes

### Wrapping everything without a question

That adds noise and overhead.

### Treating `actualDuration` as a universal truth

It is useful, but only in the context of the measured tree, build mode, hardware, and interaction path.

### Assuming profiler data from development equals production behavior

Development mode can distort timings significantly. Measure in the right build for the question you are asking.

### Expecting `<Profiler>` to optimize rendering

It only reports what happened.

## Practical guidance

Reach for `<Profiler>` when you already have a performance question and need subtree-level evidence.

If you do not yet know where the problem is, React DevTools or higher-level profiling tools are often the better first step.
