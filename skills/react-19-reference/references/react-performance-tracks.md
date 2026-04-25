## React Performance Tracks

React Performance tracks expose React-specific timing data inside the browser Performance panel so you can correlate React work with JavaScript, network, and event loop activity on one timeline.

## What They Are Good For

Use them when you need to answer questions like:

- what kind of React work is taking time
- whether slow work is blocking, transitional, Suspense-related, or idle
- which components rendered during a slow interaction
- whether a render triggered expensive effects or cascading updates
- what server-side async work blocked React Server Component rendering

This is diagnosis tooling, not an optimization by itself.

## Availability

React Performance tracks are available in:

- development builds by default
- profiling builds with partial defaults

Important constraints:

- production builds do not expose this by default
- server tracks are development-only
- profiling builds enable Scheduler tracks by default, but Components coverage is more limited unless you use `<Profiler>` or React DevTools

## Profiling Build Posture

If you need profiling in a production-like environment:

- use the profiling build
- alias `react-dom/client` to `react-dom/profiling`
- remember that this still adds overhead, so treat it as a measurement build, not a normal shipping build

## Main Tracks

### Scheduler

This is the first track to read when you want to understand update priority and render phases.

It breaks work into:

- Blocking
- Transition
- Suspense
- Idle

Within a render pass, look for:

- Update
- Render
- Commit
- Remaining Effects

This gives you a clean mental model for whether the user-visible cost came from synchronous work, background transition work, fallback/reveal behavior, or post-commit effects.

### Components

Use this to see which subtrees actually rendered and how expensive they were.

It helps with:

- identifying hot component subtrees
- checking whether effects are expensive
- spotting mount/unmount activity
- understanding `Activity` reconnect/disconnect behavior
- inspecting changed props in development builds

This is especially useful when a render is happening, but it is not obvious which subtree is responsible.

### Server Requests

Use this when diagnosing React Server Component data and async I/O behavior.

It shows:

- async operations that feed Server Components
- grouped third-party async spans when React can attribute them
- stack traces for where Promises were created
- rejected Promises as explicit failures

### Server Components

Use this to see how long Server Components and awaited Promises actually took to render.

This is the right track for understanding:

- which server component subtree is slow
- whether work is concurrent
- how much time was spent awaiting Promises during render

## What To Look For

### Cascading updates

These often indicate a real performance bug.

If you see React discarding work and starting another pass, check for:

- Effects that schedule updates unnecessarily
- render-phase updates
- component structure that keeps invalidating work

### Expensive commit or effect phases

If render is not the main problem, the bottleneck may be:

- layout work in `useLayoutEffect`
- passive work in `useEffect`
- mount/unmount churn

### Transition behavior

If a user interaction feels okay but still takes time, confirm that the expensive part is actually on the Transition track rather than Blocking.

## Relationship To Other APIs

- `<Profiler>` gives programmatic measurements and also affects Components visibility in profiling builds.
- `startTransition` and `useTransition` show up conceptually in Scheduler priority lanes.
- `Suspense` behavior is visible in the Suspense lane and reveal/fallback timing.
- `Activity` can show reconnect/disconnect events in the Components track.

## Practical Guidance

- Start with Scheduler to understand the shape of the work.
- Move to Components to find the expensive subtree.
- Use changed props and effect timing to explain why the subtree was expensive.
- On the server, inspect Server Requests first for blocked I/O and Server Components second for render structure.

## What To Tell Users

- Use React Performance tracks when browser timeline context matters.
- Prefer them for “what happened when” analysis.
- Use them alongside `<Profiler>`, React DevTools, and normal browser tracing rather than instead of them.
