# `lazy`

## Core purpose

Use `lazy` to defer loading a component’s code until React tries to render it for the first time.

```js
const SomeComponent = lazy(load)
```

## Mental model

`lazy` turns a dynamic import into a React component boundary.

When React first tries to render that component:

- it calls the loader
- waits for the module to resolve
- renders the module’s default export as the component

While the code is still loading, the lazy component suspends, so you need `<Suspense>` to decide what the user sees during that gap.

## Use it when

- a component is not needed on the initial path
- code-splitting a heavy or rarely used UI improves startup or route cost
- a section is conditional, secondary, or behind a user action
- you want to align code loading with a Suspense boundary

Good fits:

- preview panes
- settings panels
- large editors
- secondary route content
- infrequently used heavy widgets

## Do not use it when

- the component is always needed immediately
- the loading boundary would feel worse than the saved bundle cost
- you are declaring the lazy component inside another component
- you are expecting it to solve data loading by itself

`lazy` defers code loading, not arbitrary async application logic.

## Biggest rule

Declare lazy components at module scope, not inside components.

Good:

```tsx
import { lazy } from 'react'

const MarkdownPreview = lazy(() => import('./MarkdownPreview'))
```

Bad:

```tsx
function Editor() {
  const MarkdownPreview = lazy(() => import('./MarkdownPreview'))
}
```

Declaring it inside a component recreates the lazy component definition on re-renders and can reset state unexpectedly.

## Smallest good example

```tsx
import { Suspense, lazy, useState } from 'react'

const MarkdownPreview = lazy(() => import('./MarkdownPreview'))

function Editor() {
  const [showPreview, setShowPreview] = useState(false)

  return (
    <>
      <button onClick={() => setShowPreview((v) => !v)}>
        Toggle preview
      </button>

      {showPreview && (
        <Suspense fallback={<p>Loading preview...</p>}>
          <MarkdownPreview />
        </Suspense>
      )}
    </>
  )
}
```

## Suspense is part of the feature

`lazy` and `<Suspense>` belong together.

Without Suspense:

- the lazy component will suspend
- but you have not defined the loading boundary behavior

So in practice, treat `lazy` as a code-splitting input to a Suspense boundary, not as a standalone UX solution.

## What the loader must return

The loader should return a Promise or thenable resolving to a module object whose `.default` is a valid React component.

Typical pattern:

```tsx
const Panel = lazy(() => import('./Panel'))
```

This assumes `./Panel` has a default export.

## Caching behavior

React caches:

- the load Promise
- the resolved module value

So the loader is not called over and over for the same lazy component definition.

This is why after the first successful load, subsequent renders usually do not show the loading state again unless the environment is reset.

## What `lazy` is good for

### 1. Code-splitting rarely used UI

Only load the code if the user actually opens that area.

### 2. Keeping the initial path lighter

Move heavy secondary components off the initial bundle path.

### 3. Pairing with route or feature boundaries

Lazy components map well to route-level or section-level Suspense boundaries.

## What `lazy` is not

`lazy` is not:

- server data caching
- effect-based loading
- a replacement for `Suspense`
- a general async wrapper for any function

It is specifically about deferring component code loading.

## Common mistakes

### Declaring lazy inside a component

This is the biggest one. It can reset component identity and state.

### Forgetting Suspense

If the lazy component suspends, you need a boundary that handles it intentionally.

### Lazy-loading trivial always-visible components

The extra loading boundary and chunking overhead may not be worth it.

### Expecting named exports to work automatically

The resolved module must expose the component as `.default`, or you need to adapt the import pattern yourself.

## Relationship to Suspense

Suspense controls:

- fallback UI
- reveal timing
- boundary placement

`lazy` controls:

- when component code is loaded

So:

- `lazy` chooses when code starts loading
- Suspense chooses how loading looks and where it is contained

## Troubleshooting

### "My lazy component’s state resets unexpectedly"

You probably declared the lazy component inside another component. Move it to module scope.

### "Why do I still need Suspense?"

Because lazy loading works by suspending during render until the module resolves.

### "Should I lazy-load this component?"

Only if the bundle split and delayed loading are actually worth the added boundary and loading behavior.

## Practical guidance

Use `lazy` for code-splitting boundaries that map to real product structure.

Keep the lazy declaration at module scope.
Wrap it in an intentional Suspense boundary.
Choose lazy loading when the startup win is worth the loading transition.
