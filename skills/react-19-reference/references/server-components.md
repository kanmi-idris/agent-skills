## Server Components

Server Components render in a separate server environment before client bundling, letting you do data and compute work without sending that code to the browser.

## What They Are Good For

Use Server Components when you want to:

- read from databases or the filesystem during render
- keep heavy server-only libraries out of the client bundle
- avoid client-side fetch waterfalls
- stream data and JSX across the server/client boundary

## Core Mental Model

Server Components:

- run on the server or at build time
- can be `async`
- can `await` during render
- are not interactive themselves
- can pass serializable data and JSX to Client Components

Client Components:

- opt in with `"use client"`
- can use state, effects, and browser APIs
- receive rendered output or serializable props from Server Components

## Important Boundaries

- There is no `"use server"` directive for Server Components.
- `"use server"` is for Server Functions, not for denoting Server Components.
- Async components are for Server Components, not normal Client Components.

## Best Default

In Server Components, prefer:

- `async` / `await` for direct server-side reads
- passing Promises down to Client Components only when streaming or priority splitting is intentional

This aligns with the guidance for `use`: in Server Components, `await` is usually the default unless you specifically want client-side resume behavior.

## Composition Pattern

Use Server Components for:

- data access
- heavy transformations
- server-only libraries

Use Client Components for:

- local interactivity
- browser APIs
- stateful UI controls

## What To Tell Users

- Server Components are a rendering model boundary, not just a data-fetching trick.
- Reach for them to reduce bundle weight and collapse client fetch waterfalls.
- Keep the server/client split intentional and serializable.
