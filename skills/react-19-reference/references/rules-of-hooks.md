## Rules Of Hooks

Hooks are special. They must be called in places React can analyze consistently.

## Core Rules

- Call Hooks only at the top level.
- Call Hooks only from React function components or custom Hooks.

## Invalid Hook Call Sites

Do not call Hooks:

- inside loops
- inside conditions
- after conditional returns
- inside event handlers
- inside `useMemo`, `useEffect`, or reducer initializer callbacks
- inside `try` / `catch` / `finally`
- inside class components
- inside ordinary utility functions

## Why These Rules Exist

React relies on stable call ordering to associate Hook state with the right component instance.

If Hook call order changes between renders, React can no longer match state correctly.

## Common Fix Pattern

If a Hook is conditional:

- move the Hook call to the top level
- put the condition inside the logic that uses the Hook result

If a Hook is in an event handler:

- call the Hook at the top level
- use the returned values inside the handler

## Relationship To `use`

`use(resource)` is a special case and is more flexible than normal Hooks. It can appear in branches and loops, but that exception does not change the normal Rules of Hooks for `useState`, `useEffect`, and the rest.

## What To Tell Users

- When in doubt, move Hook calls outward and upward.
- The fix is almost always structural, not syntactic.
