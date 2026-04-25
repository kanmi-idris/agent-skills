# `cacheSignal`

## Core purpose

Use `cacheSignal` during server rendering to get an `AbortSignal` that ends when React no longer needs the current cached render work.

```js
const signal = cacheSignal()
```

## Mental model

`cacheSignal` lets render-time async work know when the current render lifetime is over.

If React:

- finishes rendering
- aborts rendering
- or fails rendering

the signal is aborted.

This is mainly useful for cancellation-aware server work started during rendering, especially alongside `cache`.

## Use it when

- you start cancellable async work during server rendering
- the work supports `AbortSignal`
- you want in-flight fetches or computations to stop once React no longer needs them
- you want to suppress noise from errors caused only by cancellation

Good fits:

- `fetch(..., { signal })` during Server Component rendering
- expensive server computations that accept `AbortSignal`
- logging logic that should ignore cancellation-caused failures

## Do not use it when

- you are in a Client Component and expect a real signal
- the async work was started outside rendering
- the API you are calling cannot react to cancellation
- you are treating it like a persistent request lifecycle token outside React render scope

`cacheSignal` is about the current render/cache lifetime, not arbitrary async lifetimes in your app.

## Biggest rule

Call `cacheSignal()` at the point where render-time work starts.

Good:

```tsx
import { cache, cacheSignal } from 'react'

const dedupedFetch = cache(fetch)

async function Component({ url }) {
  const response = await dedupedFetch(url, {
    signal: cacheSignal(),
  })
  return <div>{response.status}</div>
}
```

Bad:

```tsx
import { cacheSignal } from 'react'

const response = fetch(url, { signal: cacheSignal() })
```

That runs outside render in the wrong scope, so the signal does not represent the actual render lifetime in the way you want.

## Return value

`cacheSignal()` returns:

- an `AbortSignal` when called during rendering
- `null` when called outside rendering

That `null` is intentional. It tells you there is no active render-scoped cache lifetime here.

## Smallest good example

```tsx
import { cacheSignal } from 'react'

async function Component({ url }) {
  const response = await fetch(url, {
    signal: cacheSignal(),
  })

  const data = await response.json()
  return <pre>{JSON.stringify(data)}</pre>
}
```

If React finishes or abandons that render, the signal can abort the in-flight fetch.

## Relationship to `cache`

`cacheSignal` is closely related to render-scoped cached work.

Typical pairing:

- `cache` deduplicates shared work for the request
- `cacheSignal` tells that work when React is done caring about it

This is why they often appear together in Server Components or shared server helpers.

## Cancellation-aware error handling

Sometimes cancellation surfaces as an error from your underlying system.

In those cases, you often want to ignore cancellation-driven errors while still logging real failures.

Example:

```tsx
import { cacheSignal } from 'react'

async function getData(id) {
  try {
    return await queryDatabase(id)
  } catch (error) {
    if (!cacheSignal()?.aborted) {
      logError(error)
    }
    return null
  }
}
```

That pattern is useful when cancellation is expected and should not pollute error reporting.

## Server-only boundary

Today, `cacheSignal` is effectively meaningful for React Server Components.

In Client Components it currently returns `null`, but you should not hardcode logic that assumes it will always stay that way forever.

The important present-day rule is still:

- use it for server render work
- treat client `null` as “no render-scoped cancellation available here”

## Common mistakes

### Starting the async work outside rendering

Then `cacheSignal` is not tied to the component render lifetime in the right way.

### Assuming a client component will get a usable signal

Right now it will not.

### Expecting cancellation for non-cancellable work

If the underlying API ignores `AbortSignal`, `cacheSignal` cannot force cancellation by magic.

### Logging every thrown error without checking for abort

That can turn normal cancellation into misleading error noise.

## Troubleshooting

### "Why is `cacheSignal()` null?"

You are probably outside rendering, or in a context where React is not providing a render-scoped cache lifetime.

### "Why did my request not abort?"

Check:

- the work actually started during rendering
- the underlying API accepts and honors `AbortSignal`
- you passed the signal to the correct call site

### "Should I use this without `cache`?"

You can, if the work is render-scoped and cancellable, but it is most naturally paired with `cache`-managed server work.

## Practical guidance

Use `cacheSignal` when render-time server work should stop once React no longer needs it.

Think of it as request/render lifetime cancellation, not as a general async control primitive.
