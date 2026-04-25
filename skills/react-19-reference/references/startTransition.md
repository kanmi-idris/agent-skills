# `startTransition`

## Core purpose

Use `startTransition` to mark non-urgent state updates as Transition work when you do not need the `isPending` signal from `useTransition`.

```js
startTransition(action)
```

## Mental model

`startTransition` is the standalone version of the same scheduling idea behind `useTransition`.

It tells React:

- the enclosed state updates are non-urgent
- urgent work should stay responsive
- already visible UI should not be hidden unnecessarily when paired with Suspense-aware flows

The difference from `useTransition` is simple:

- `useTransition` gives you `isPending`
- `startTransition` only marks the work

## Use it when

- you need Transition behavior but do not need pending UI state
- you are outside a component and cannot call hooks
- you are writing library or framework code
- you want to wrap navigation-like or background updates as non-urgent

Good fits:

- router navigation helpers
- external helpers that have access to a state setter
- library abstractions outside component bodies
- simple non-urgent updates where no pending indicator is needed

## Do not use it when

- you need pending UI feedback and should use `useTransition`
- the update is urgent
- you are controlling a text input value
- you expect it to solve async ordering automatically

## Smallest good example

```tsx
import { startTransition, useState } from 'react'

function TabContainer() {
  const [tab, setTab] = useState('about')

  function selectTab(nextTab) {
    startTransition(() => {
      setTab(nextTab)
    })
  }
}
```

This makes the tab switch non-urgent, so slower rendering can happen in the background without blocking more urgent interactions.

## The biggest distinction from `useTransition`

If you need:

- pending styles
- loading indicators tied to transition status
- user-visible “Updating...” state

then `useTransition` is the better fit.

If you only need to mark the work and do not care about `isPending`, `startTransition` is enough.

## Works outside components

Unlike `useTransition`, `startTransition` is not a Hook.

That means it can be used:

- outside components
- in helper modules
- in data or routing libraries

as long as the wrapped code still has access to the relevant state setter.

That is one of its main reasons to exist.

## Immediate execution

`startTransition` does not delay your callback like `setTimeout`.

The callback runs immediately.
What changes is the priority of state updates scheduled during that call.

So this:

```tsx
console.log(1)
startTransition(() => {
  console.log(2)
  setPage('/about')
})
console.log(3)
```

will log:

- `1`
- `2`
- `3`

That is correct.

## Async caveat

If you `await` inside the callback, updates after the `await` are not automatically kept inside the transition.

Bad:

```tsx
startTransition(async () => {
  await save()
  setPage('/done')
})
```

Current correct pattern:

```tsx
startTransition(async () => {
  await save()
  startTransition(() => {
    setPage('/done')
  })
})
```

That extra call is a current limitation.

## Controlled input rule

Do not use transitions to control text inputs.

Input state must stay synchronous.

If the typing should stay fast while a slower subtree updates, keep the input urgent and use:

- a separate transition-wrapped state update
- or `useDeferredValue`

## Interruptibility

Transition work is interruptible.

If React is rendering a slow transition update and the user triggers something urgent, React can pause or restart the transition so urgent interaction wins.

That is the entire point of using transitions for slower background rendering work.

## Common mistakes

### Expecting pending state from `startTransition`

It does not provide one. Use `useTransition` when you need pending UI.

### Treating it like delayed execution

The callback runs immediately.

### Updating state after `setTimeout` inside the transition

Those updates are no longer inside the `startTransition` call and will not be marked as Transition updates.

### Using it for controlled inputs

That breaks the synchronous input model.

## Troubleshooting

### "Why is my update not treated as a Transition?"

Make sure the state update happens during the `startTransition` call itself, not later in another async boundary like `setTimeout`.

### "Why do I not have an `isPending` flag?"

Because `startTransition` is the standalone API. Use `useTransition` if you need pending state.

### "Why did my post-await update become urgent?"

You crossed an async boundary. Wrap the post-`await` update in another `startTransition`.

## Practical guidance

Use `startTransition` when you need the scheduling semantics of a Transition without hook-based pending state.

If you are inside a component and need pending UI, prefer `useTransition`.
If you are outside a component or just need the priority shift, `startTransition` is the right tool.
