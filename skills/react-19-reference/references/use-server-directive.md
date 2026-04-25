## `'use server'` Directive

`'use server'` marks async functions as server-callable functions in an RSC environment.

## What It Is For

Use it to define Server Functions that client code can invoke through the framework.

You can place it:

- inside an async function body to mark that function
- at the top of a file to mark exported async functions in that module

## Best Default

Use module-level `'use server'` when Client Components need to import the function.

Use inline function-level `'use server'` when a Server Component defines a one-off action that is passed down as a prop.

## Important Caveats

- It must be first in the function or module.
- It only works on async functions.
- It belongs in server-evaluated code, not ordinary client files.
- Arguments are fully client-controlled and must be validated.
- Arguments and return values must be serializable.
- Server Functions should generally be used for mutations, not general reads.

## Security Posture

Treat every Server Function like an authenticated server endpoint:

- validate input
- authorize the current user
- avoid trusting client state

## Relationship To Other APIs

- It is the defining directive behind Server Functions.
- Forms automatically integrate these calls into Actions.
- `useActionState` is often the most ergonomic client-side companion.
- `useTransition` matters when invoking one outside a form.

## Common Clarification

`'use server'` does not denote a Server Component. There is no directive for “this file is a Server Component.” Server Components are the default in RSC environments unless you cross into a client boundary with `'use client'`.

## What To Tell Users

- Think of `'use server'` as “make this async server endpoint callable from React client code.”
- Keep it narrow, validated, and mutation-oriented.
