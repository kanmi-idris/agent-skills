# `useId`

## Core purpose

Use `useId` to generate unique IDs for accessibility relationships in React components.

```js
const id = useId()
```

## Mental model

`useId` is for linking related DOM elements, especially for accessibility attributes.

Typical use:

- `label` ↔ `input`
- `input` ↔ `aria-describedby`
- shared prefix for several related fields

It is not a general-purpose unique ID generator.

## Most important rule

Use `useId` for accessibility and DOM relationship IDs, not for list keys or cache keys.

Do **not** use it for:

- React list `key`s
- data IDs
- cache keys
- anything that should come from your domain data

## Use it when

- a component may render multiple times on the same page and hardcoded IDs would clash
- you need a stable DOM relationship for ARIA attributes
- you want a shared ID prefix for a small group of related elements

Good fits:

- password hint text
- form field label/input pairs
- description/error message IDs
- grouped form controls with shared prefixes

## Do not use it when

- the ID should come from actual data
- you are rendering a list and need item keys
- you are generating identifiers for data fetching or caching

## Smallest good example

```tsx
import { useId } from 'react'

function PasswordField() {
  const passwordHintId = useId()

  return (
    <>
      <label>
        Password:
        <input type="password" aria-describedby={passwordHintId} />
      </label>
      <p id={passwordHintId}>
        The password should contain at least 18 characters
      </p>
    </>
  )
}
```

Why this is a good fit:

- the ID only exists to connect related DOM elements
- multiple `PasswordField` instances will not clash
- the component stays SSR-safe in normal React usage

## Shared prefix pattern

If you need several related IDs, generate one base ID and extend it:

```tsx
const id = useId()

return (
  <>
    <label htmlFor={id + '-firstName'}>First Name</label>
    <input id={id + '-firstName'} />

    <label htmlFor={id + '-lastName'}>Last Name</label>
    <input id={id + '-lastName'} />
  </>
)
```

This is often cleaner than calling `useId` repeatedly for closely related elements.

## SSR and hydration guidance

One of the main reasons to prefer `useId` over ad hoc counters is that it is designed to work with server rendering and hydration.

Important condition:

- the server and client component trees must match

If the rendered tree differs between server and client, the generated IDs may not line up.

Rule:

- if you rely on SSR + hydration, keep the tree shape consistent

## Multiple React roots

If multiple independent React apps live on the same page, use `identifierPrefix` with `createRoot`, `hydrateRoot`, and matching server APIs.

This prevents ID clashes across separate apps.

Example shape:

```js
const root = createRoot(domNode, {
  identifierPrefix: 'my-app-',
})
```

For server-rendered apps, the server and client prefixes must match.

## Common mistakes

### Using it for list keys

Bad:

```tsx
items.map((item) => <Row key={useId()} item={item} />)
```

Keys must come from your data, and Hooks cannot be called in loops anyway.

### Using it for cache keys

`useId` is not a data identity primitive. Cache keys should be derived from the data/request itself.

### Calling it conditionally

Like any Hook, it must stay at the top level.

### Forgetting SSR tree consistency

If the server/client trees diverge, IDs can mismatch during hydration.

## Practical decision line

Use `useId` when a component needs unique DOM IDs for accessibility relationships. Keep it scoped to UI identity, not data identity.
