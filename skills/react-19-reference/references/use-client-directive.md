## `'use client'` Directive

`'use client'` marks a file and its transitive dependency subtree as client-evaluated code in an RSC app.

## What It Actually Does

It creates a boundary in the module graph, not the render tree.

That distinction matters:

- a component usage can be server-rendered in one place and client-rendered in another
- parent/child render relationships do not alone define the boundary
- import structure does

## When You Need It

Use `'use client'` when the code needs:

- state
- effects
- browser APIs
- event handlers
- client-only third-party libraries

If none of those apply, default to server-rendered code.

## What It Pulls In

Once a file is marked `'use client'`, its transitive dependencies become client-evaluated for that usage path. That means the directive can enlarge the client bundle more than expected.

So the practical rule is:

- place it as low as possible
- keep client islands narrow

## Important Caveats

- It must be the first statement in the file.
- It applies at module scope.
- Code in that client subtree must respect serialization rules when crossing from server to client.
- Not every reusable component needs the directive; neutral components can often be shared.

## Default Posture

- Server by default
- client only when interactivity or browser-only capability demands it

## What To Tell Users

- `'use client'` is a module-boundary tool, not a generic “make this component interactive” flag.
- Keep the boundary narrow to avoid unnecessary client bundle expansion.
