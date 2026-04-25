## Server Functions

Server Functions let Client Components invoke async server-executed code through React Server Components infrastructure.

## What They Are For

Use Server Functions primarily for:

- mutations
- form submissions
- server-side writes that need a client trigger

They are not the default recommendation for general data fetching.

## Core Mental Model

When a function is marked with `'use server'`, the framework turns it into a server reference. Client code does not call the original function directly. It calls a network-backed reference that executes on the server and returns a serialized result.

## Where They Come From

You can create them:

- inline inside a Server Component
- at module scope in a `'use server'` file

Inline definitions are good when the function is tightly tied to one Server Component. Module-level definitions are the normal choice when client code needs to import them.

## Best Integration Patterns

### Forms

The strongest default is:

- use Server Functions with `<form action={...}>`
- pair with `useActionState` when you need pending state or the last returned result
- rely on progressive enhancement when relevant

This gives you the cleanest React 19 path for mutations.

### Outside Forms

If you call a Server Function from a click handler or other client event:

- wrap the call in a Transition
- treat the result as async
- use optimistic UI only when the UX benefits justify it

## Important Caveats

- Treat all arguments as untrusted input.
- Validate authorization on the server.
- Arguments and return values must be serializable.
- These calls are inherently async and network-backed.
- Frameworks generally process them as mutation pathways, not cacheable read APIs.

## Relationship To Other APIs

- `useActionState` is the default companion when you want pending state and server-returned status.
- `useTransition` or `startTransition` matter when calling them outside forms.
- `'use server'` marks the function or file that defines them.

## What To Tell Users

- Use Server Functions for writes, not as a generic substitute for server reads.
- Prefer form actions first.
- Keep the server boundary explicit, serialized, and authorized.
