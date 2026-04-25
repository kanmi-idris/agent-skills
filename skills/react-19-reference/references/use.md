# `use`

## Core purpose

Use `use` to read a render-time resource such as:

- a Promise
- a context

```js
const value = use(resource)
```

## Mental model

`use` is a render-time resource reader.

When you pass it:

- a Promise: React will suspend until it resolves or throw to the nearest Error Boundary if it rejects
- a context: React will read the current context value, similar to `useContext`

The major distinction from normal hooks is that `use` can appear inside conditionals and loops.

## Use it when

- you need to read a Promise during render
- you want a Client Component to consume a Promise passed from a Server Component
- you want context reading inside conditionals or loops
- you are intentionally building around Suspense and Error Boundaries

Good fits:

- Client Components reading server-created Promises
- conditional or looped context access
- Suspense-enabled Promise consumption in render

## Do not use it when

- you are outside a component or custom Hook
- you want effect-based or event-based async handling
- you are in a Server Component where plain `await` is simpler and better
- you want to wrap it in `try/catch`

`use` is not a general async utility. It is a render-time React API.

## Biggest rule

In Server Components, prefer `async` / `await` over `use` unless you have a specific reason not to.

Why:

- `await` resumes from the suspension point
- `use` causes React to re-render after the Promise resolves

So the default server-side posture should be:

- Server Component data read: usually `await`
- Promise passed into Client Component or conditional resource read: often `use`

## Smallest good examples

### Read a Promise

```tsx
import { Suspense, use } from 'react'

function Message({ messagePromise }) {
  const message = use(messagePromise)
  return <p>{message}</p>
}

function MessageContainer({ messagePromise }) {
  return (
    <Suspense fallback={<p>Loading...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  )
}
```

### Read context conditionally

```tsx
import { use } from 'react'

function Divider({ show, ThemeContext }) {
  if (!show) {
    return null
  }

  const theme = use(ThemeContext)
  return <hr className={theme} />
}
```

That conditional use is valid here, which is one of the key differences from `useContext`.

## `use(Promise)` behavior

When you call `use` with a Promise:

- pending Promise: component suspends
- fulfilled Promise: resolved value is returned
- rejected Promise: rejection is thrown to the nearest Error Boundary

That means Promise-reading with `use` is tightly coupled to:

- `<Suspense>`
- Error Boundaries

Without those boundaries, you do not have a complete UX story.

## `use(context)` behavior

When you call `use` with a context object, React reads the nearest matching provider above the component, just like `useContext`.

Important rule:

- React searches upward
- it does not consider providers created later in the same component body

That part behaves the same as `useContext`.

## What makes `use` special

Unlike standard hooks, `use` may be called:

- in `if`
- in loops
- in other non-top-level branches

But the function that calls it must still be:

- a component
- or a custom Hook

That flexibility is the main reason to prefer `use` over `useContext` in branchy resource-reading code.

## Best Server Component pattern

Prefer creating Promises in Server Components and passing them down to Client Components.

Good pattern:

- Server Component creates Promise once
- Client Component reads it with `use`
- Promise identity stays stable across client re-renders

This is better than creating Promises in Client Components, where they are recreated every render unless carefully stabilized.

## Streaming server-to-client data

One of the highest-value `use` patterns is:

- Server Component starts async work
- Promise is passed to Client Component
- Client Component reads it via `use`
- Suspense shows fallback until ready

This avoids blocking the whole server render at the point where the Promise was created.

## Rejected Promise handling

You cannot use `try/catch` around `use`.

Instead, handle rejected Promises by either:

- wrapping the component in an Error Boundary
- or converting the Promise to a resolved fallback value with `.catch(...)`

Example fallback-value pattern:

```tsx
const messagePromise = fetchMessage().catch(() => {
  return 'No new message found.'
})
```

Then `use(messagePromise)` reads the fallback string instead of throwing.

## `use` vs `useContext`

Use `useContext` when:

- you just need ordinary top-level context reading
- you want the more explicit conventional hook

Use `use` when:

- the resource may be a Promise
- you need context reads inside conditionals or loops

## `use` vs `await`

Use `await` when:

- you are in a Server Component
- straightforward server data loading is the goal

Use `use` when:

- the value is being consumed in render from a Promise resource
- you are passing the Promise from server to client
- you need a shared Suspense/Error Boundary flow in render

## Common mistakes

### Calling `use` outside a component or custom Hook

That is invalid.

### Wrapping `use` in `try/catch`

That does not work. Use Error Boundaries or Promise `.catch`.

### Creating Promises in Client Components casually

That often recreates them every render and breaks stability.

### Using `use` in a Server Component where `await` is the simpler tool

That usually adds complexity without benefit.

## Troubleshooting

### "Suspense Exception: This is not a real error!"

Usually one of these is happening:

- `use` is outside a component/custom Hook
- `use` is inside a `try/catch`

Move the call into a component or Hook body and handle Promise failures with an Error Boundary or Promise `.catch`.

### "Why doesn’t my effect-based async work suspend?"

Because `use` only works with render-time resources. Effects happen after render.

### "Why should I pass Promises from server to client?"

Because they are stable and can stream data into Client Components through Suspense without recreating the Promise on each client render.

## Practical guidance

Use `use` as a render-time reader for Promises and context.

Reach for it when:

- Promise consumption should integrate with Suspense
- context reads need branch flexibility

But keep the server default conservative:

- if `await` is simpler in a Server Component, use `await`
