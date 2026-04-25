# `cache`

## Core purpose

Use `cache` in React Server Components to memoize shared work such as data fetches or expensive computations during a server render.

```js
const cachedFn = cache(fn)
```

## Mental model

`cache` creates a memoized server function.

When the cached function is called with the same arguments during the same server request, React can reuse the previous result instead of doing the work again.

This is request-scoped shared memoization, not client-side render memoization.

The important boundary:

- `cache` is for Server Components
- `useMemo` is for client render-time computation inside a component
- `memo` is for skipping re-renders of components

## Use it when

- the same server-side fetch or computation may be requested from multiple components
- you want one request-scoped snapshot of data shared across a server render
- you want to preload async work before some later component awaits it
- you want duplicate work across Server Components to collapse to one shared result

Good fits:

- data fetch wrappers
- expensive server-side metrics or report calculation
- user/profile lookup helpers shared across multiple server-rendered components
- request-scoped preload patterns

## Do not use it when

- you are in Client Components
- you need persistent caching across requests
- you are trying to memoize local render work in a client component
- you call `cache` repeatedly instead of sharing one exported cached function

`cache` is not a general app cache and it is not a CDN or database cache.

## Biggest rule

Call `cache` once at module scope and share the returned function.

Good:

```tsx
import { cache } from 'react'
import { fetchUser } from './api'

export const getUser = cache(fetchUser)
```

Bad:

```tsx
function Profile({ id }) {
  const getUser = cache(fetchUser)
  return getUser(id)
}
```

Every call to `cache` creates a new memoized function with a separate cache.

## Smallest good example

```tsx
import { cache } from 'react'
import { fetchTemperature } from './api'

const getTemperature = cache(async (city) => {
  return await fetchTemperature(city)
})

async function WeatherCard({ city }) {
  const temperature = await getTemperature(city)
  return <p>{temperature}</p>
}
```

If multiple Server Components call `getTemperature(city)` with the same `city` during one request, they can share the same result.

## Request scope matters

React invalidates these caches for each server request.

That means:

- sharing happens within one server render/request
- results are not persisted across unrelated requests

This is a feature, not a bug. It gives you consistent request-local snapshots.

## Async work and promise sharing

`cache` is especially useful for async work.

When the cached function is first called:

- it starts the async work
- the resulting Promise is cached

Later calls with the same arguments can reuse that same Promise.

That is why `cache` works well for:

- avoiding duplicate fetches
- preloading data earlier in the render tree
- keeping multiple components aligned to the same snapshot

## Preload pattern

You can kick off async work before a later component actually awaits it:

```tsx
const getUser = cache(async (id) => {
  return await db.user.query(id)
})

function Page({ id }) {
  getUser(id)
  return <Profile id={id} />
}

async function Profile({ id }) {
  const user = await getUser(id)
  return <h1>{user.name}</h1>
}
```

The first call starts the work.
The later call can reuse the same cached Promise.

## Shared snapshot behavior

When multiple components call the same cached fetch function with the same arguments, they see the same request-local data snapshot.

This is one of the biggest reasons to use `cache` around fetch helpers in RSC trees.

## Error caching

`cache` also memoizes thrown errors.

If the underlying function throws for a given argument set, the cached function will re-throw that same error for those same arguments during the same request scope.

That means failures are shared too, not just successes.

## Equality and arguments

Cache hits depend on argument identity.

For primitives, this is straightforward.

For objects and arrays, you need the same reference, not merely equivalent contents.

Bad:

```tsx
const calculateNorm = cache((vector) => {
  // ...
})

function Marker(props) {
  return calculateNorm({ x: props.x, y: props.y, z: props.z })
}
```

That creates a fresh object each time.

Better:

```tsx
const calculateNorm = cache((x, y, z) => {
  // ...
})

function Marker(props) {
  return calculateNorm(props.x, props.y, props.z)
}
```

Or pass the same shared object reference.

## Critical pitfall: outside component calls

Calling a memoized function outside component rendering does not get React’s cache context.

That means module-top-level execution like this will run the function but not participate in React’s request-scoped cache the way you expect:

```tsx
const getUser = cache(async (id) => {
  return await db.user.query(id)
})

getUser('demo-id')
```

Use cached functions from components or render-time server code where React provides cache access.

## `cache` vs `useMemo` vs `memo`

### `cache`

- Server Components only
- shares work across components during a request
- great for data fetches and server computations

### `useMemo`

- component-local
- usually client-side render optimization
- caches one component’s calculation across renders

### `memo`

- component-level render skipping based on props
- avoids re-rendering when props are unchanged

These solve different problems.

## Common mistakes

### Calling `cache` inside components

That creates fresh memoized functions and destroys sharing.

### Creating multiple memoized wrappers for the same underlying function

Those wrappers do not share a cache with each other.

### Using `cache` as if it were persistent storage

It is request-scoped, not durable.

### Expecting structurally equal objects to hit the cache

They need to be the same reference unless you switch to primitive arguments or shared references.

## Troubleshooting

### "My memoized function still runs for the same logical input"

Check whether:

- you are calling the same memoized function
- you created the cached function only once
- you are passing stable primitive or shared-reference arguments
- you are calling it from render-time server code rather than outside React’s cache context

### "Should I wrap every server fetch in cache?"

Only when shared request-scoped reuse is useful. It is a good default for reusable server data helpers, but still should be deliberate.

## Practical guidance

Use `cache` for shared request-scoped server work.

Export one cached helper at module scope.
Pass stable arguments.
Keep the distinction clear:

- shared server work: `cache`
- component render calculation: `useMemo`
- component render skipping: `memo`
