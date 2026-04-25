## Components and Hooks Must Be Pure

React assumes render is pure enough to be restarted, repeated, interrupted, and prioritized.

The practical contract is:

- same inputs, same output
- no side effects during render
- no mutation of non-local values during render

## What Purity Means In Practice

Render logic must be:

- idempotent with respect to props, state, context, and Hook arguments
- free of observable side effects
- safe to run multiple times

This is why code like these are wrong in render:

- `new Date()`
- `Math.random()`
- mutating module-level arrays or objects
- writing to the DOM
- mutating props, state snapshots, Hook arguments, or values already used in JSX

## What Is Fine

Local mutation is fine when the value is created during the same render and not retained across renders.

Good examples:

- building a local array with `push`
- creating temporary objects during render
- lazy initialization that does not affect other components

## What Usually Needs To Move

Move non-render work into:

- event handlers, if it happens because the user did something
- `useEffect` or `useLayoutEffect`, if it must synchronize after render

## Sharp Edges

- Props and state are immutable snapshots.
- Hook arguments should be treated like props: do not mutate them.
- Hook return values may be memoized, so do not mutate them either.
- Do not mutate values after they have already been used in JSX.

## What To Tell Users

- If code only works because render runs once, it is structurally wrong for React.
- If something must happen over time, in response to events, or against an external system, it belongs outside render.
- Local mutation is okay. Persistent or shared mutation in render is not.
