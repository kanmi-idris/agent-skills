# `<Suspense>`

## Core purpose

Use `<Suspense>` to declare where React may temporarily show fallback UI while a subtree is not ready to render.

```js
<Suspense fallback={<Loading />}>
  <SomeComponent />
</Suspense>
```

## Mental model

`<Suspense>` is a loading boundary.

It does not fetch data by itself.

It tells React:

- what fallback to show when something inside suspends
- which content should reveal together
- where progressive reveal can happen in stages

The important shift is architectural:

- components or framework primitives suspend
- Suspense boundaries decide the user-visible loading behavior

## Use it when

- part of the tree may suspend for code or data
- you want a controlled loading boundary instead of ad hoc spinners everywhere
- you want nested reveal sequences
- you want transitions to preserve already revealed UI during navigation-like updates

Good fits:

- route-level loading boundaries
- slow secondary panels inside already loaded pages
- progressive reveal layouts
- Suspense-enabled framework data loading
- `lazy` component loading

## Do not use it when

- the data is fetched in `useEffect` and never suspends
- you are expecting Suspense to automatically work with arbitrary async code
- you are wrapping every component at random with no intentional loading sequence
- the fallback placement does not match the UX you actually want

Suspense is only useful when the underlying source is Suspense-enabled.

## The biggest rule

Place Suspense boundaries according to loading sequences, not component boundaries.

Do not ask:

- “Which component is slow?”

Ask:

- “Which content should appear together?”
- “Which content may reveal later?”
- “What should remain visible during loading?”

That usually maps to UX sections, not individual components.

## Smallest good example

```tsx
import { Suspense } from 'react'

function ArtistPage({ artistId }) {
  return (
    <Suspense fallback={<Loading />}>
      <Albums artistId={artistId} />
    </Suspense>
  )
}
```

If `Albums` suspends, React shows `Loading` until the subtree is ready.

## What actually activates Suspense

Suspense works with Suspense-enabled sources such as:

- `lazy`
- `use` with cached Promises
- framework-integrated Suspense data sources

Suspense does **not** activate just because you fetch inside:

- `useEffect`
- event handlers
- arbitrary async code that does not suspend during render

That distinction matters. Suspense is not a generic loading detector.

## Boundary design patterns

### 1. Reveal together

Wrap multiple parts in one boundary when they should appear as one unit.

```tsx
<Suspense fallback={<Loading />}>
  <Biography />
  <Panel>
    <Albums />
  </Panel>
</Suspense>
```

This makes both pieces wait and reveal together.

### 2. Reveal progressively

Nest boundaries when some parts may load later without blocking already useful content.

```tsx
<Suspense fallback={<BigSpinner />}>
  <Biography />
  <Suspense fallback={<AlbumsGlimmer />}>
    <Albums />
  </Suspense>
</Suspense>
```

This lets `Biography` appear first and `Albums` fill in later.

### 3. Preserve revealed UI during navigation

When a revealed tree suspends again, React may show the fallback again unless the update was marked as non-urgent with a Transition or deferred value.

That is why Suspense and navigation-like updates usually pair with:

- `startTransition`
- `useTransition`
- `useDeferredValue`

## Suspense and transitions

One of the highest-value uses of transitions is preventing already visible content from being replaced by a big fallback during navigation or view switches.

Without a Transition:

- route or tab change suspends
- nearest boundary may replace visible UI with fallback

With a Transition:

- React tries to keep already revealed content visible
- new nested boundaries may still show their own fallbacks

This is why routers and framework navigation layers should generally wrap navigation updates in transitions.

## Suspense and stale content

If the better UX is “keep showing the old results while new ones load,” Suspense often pairs with `useDeferredValue`.

Pattern:

- urgent input updates immediately
- deferred query lags behind
- Suspense keeps rendering the older fulfilled subtree until the new one is ready

This is typically better than flashing a fallback for every keystroke.

## Fallback quality

A fallback should usually be:

- lightweight
- layout-aware
- visually consistent with the eventual content

Prefer:

- glimmers
- skeletons
- inline placeholders

Over:

- giant app-wide spinner replacements

unless you truly want to hide the whole section.

## State and effect caveats

Important behaviors:

- if a tree suspends before first mount completes, React does not preserve its mount-time state
- if visible content hides because of suspension, layout Effects in that tree are cleaned up
- when the content reappears, layout Effects run again

That is expected. Suspense boundaries can fully hide and later re-show subtrees.

## Resetting on navigation

Sometimes a transition should preserve already shown content.

Sometimes a change means “this is different content now” and the boundary should reset.

Use a `key` for that:

```tsx
<ProfilePage key={userId} />
```

This tells React not to preserve the previous subtree identity across parameter changes.

## Server rendering role

Suspense also participates in:

- streaming server rendering
- selective hydration
- server error fallback behavior

For example, if a server-rendered subtree errors and is wrapped in Suspense, React can emit the fallback instead of aborting the whole render.

That makes Suspense a structural rendering primitive, not just a client loading helper.

## Client-only opt-out pattern

You can intentionally force a subtree to render only on the client by throwing on the server inside a Suspense boundary.

That should be used deliberately, not casually, but it is a valid pattern for truly client-only UI.

## Common mistakes

### Wrapping every component in its own Suspense boundary

That creates noisy, fragmented loading UX.

### Expecting Suspense to work with effect-based fetching

It will not. The source must suspend during render.

### Putting the fallback too high in the tree

That can blank out too much already visible UI.

### Putting the fallback too low in the tree

That can make loading sequences feel incoherent or too granular.

### Using a generic spinner where a structural placeholder would be better

Fallback choice strongly affects perceived polish.

## Troubleshooting

### "Why does my effect-based fetch not trigger Suspense?"

Because Suspense does not observe async work started in Effects. Use a Suspense-enabled source.

### "Why is already visible UI disappearing during updates?"

The update likely suspended outside a Transition. Mark it with `startTransition` or use deferred values where appropriate.

### "Why does state reset after suspension?"

If the suspended tree had not mounted successfully yet, React retries it from scratch once ready.

### "Why are my layout effects firing again?"

Because Suspense may hide and later reveal the subtree, which requires cleaning up and re-running layout Effects.

## Practical guidance

Design Suspense boundaries around user-perceived loading moments.

Use one boundary when content should appear together.
Nest boundaries when content should progressively reveal.
Pair Suspense with transitions when navigation or background updates should not hide already revealed UI.
