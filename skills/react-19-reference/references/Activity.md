# `<Activity>`

## Core purpose

Use `<Activity>` to hide a subtree while preserving its internal state and DOM so it can be restored later.

```js
<Activity mode={visibility}>
  <Sidebar />
</Activity>
```

## Mental model

`<Activity>` is React’s hide-with-preserved-state boundary.

When an Activity is:

- `visible`: the subtree behaves normally
- `hidden`: React hides the subtree with `display: none`, cleans up its Effects, but keeps its state and DOM around for later restoration

So Activity is neither the same as:

- normal rendering
- nor full unmounting

It is closer to “backgrounded UI.”

## Use it when

- a UI section is likely to be shown again soon
- you want to preserve internal component state across hide/show cycles
- you want to preserve DOM state like draft text or media position
- you want to pre-render likely-next content in the background
- you want hidden content to stop running Effects while still being restorable

Good fits:

- sidebars
- tab panels
- drawers
- hidden compose forms
- pre-rendered next-view content

## Do not use it when

- the subtree should truly be destroyed when hidden
- restoring old state would be confusing or incorrect
- the hidden DOM has side effects you have not cleaned up
- conditional mount/unmount is simpler and better matches the product behavior

If hidden content should come back fresh every time, unmount it instead.

## Smallest good example

```tsx
import { Activity, useState } from 'react'

function App() {
  const [showSidebar, setShowSidebar] = useState(true)

  return (
    <>
      <button onClick={() => setShowSidebar((v) => !v)}>
        Toggle sidebar
      </button>

      <Activity mode={showSidebar ? 'visible' : 'hidden'}>
        <Sidebar />
      </Activity>
    </>
  )
}
```

If `Sidebar` has local expanded/collapsed state, that state is preserved across hide/show instead of resetting.

## Hide vs unmount

This is the most important distinction.

With conditional rendering:

```tsx
{isOpen && <Sidebar />}
```

React unmounts the subtree and its state is lost.

With Activity:

```tsx
<Activity mode={isOpen ? 'visible' : 'hidden'}>
  <Sidebar />
</Activity>
```

React hides the subtree but preserves:

- component state
- DOM state
- already prepared render output

while still cleaning up Effects.

## What Activity preserves

Activity can preserve:

- component state
- DOM state like text entered into uncontrolled fields
- expensive already-rendered UI
- pre-rendered content that may become visible later

That makes it especially useful for interfaces where the user is likely to come back soon.

## What Activity does not preserve as active work

When hidden, Activity cleans up child Effects.

That means:

- subscriptions stop
- effect-driven side effects stop if cleanup is correct
- hidden content is conceptually treated like it is unmounted from an effects perspective

This is intentional. Hidden content should not keep doing foreground work.

## Pre-rendering

A hidden Activity can render its children before they become visible.

That means content can:

- load code
- resolve Suspense-enabled data
- prepare UI in the background

so that revealing it later feels faster.

This is one of Activity’s highest-value behaviors for tabs, drawers, and likely-next panels.

## Suspense interaction

Activity pre-rendering only helps load data when the source is Suspense-enabled.

That includes things like:

- `lazy`
- `use` with cached Promises
- framework-integrated Suspense data sources

It does not make effect-based fetching happen early.

## DOM preservation and caveats

Because hidden Activity content stays in the DOM with `display: none`, DOM-backed state may survive:

- text in `<textarea>`
- element state
- media position

That is often desirable.

But it also means some DOM side effects continue unless you explicitly clean them up.

## The biggest sharp edge

Some elements behave differently when hidden vs unmounted.

Common examples:

- `<video>`
- `<audio>`
- `<iframe>`

If hiding should stop behavior like playback, you must add cleanup logic yourself.

Example:

```tsx
import { useLayoutEffect, useRef } from 'react'

function VideoPanel() {
  const ref = useRef(null)

  useLayoutEffect(() => {
    const node = ref.current

    return () => {
      node.pause()
    }
  }, [])

  return <video ref={ref} controls src="..." />
}
```

This makes the video stop when the Activity boundary hides the subtree, while still preserving the DOM node and playback position for later return.

## Why `useLayoutEffect` can matter here

If the cleanup is tied to the subtree becoming visually hidden, `useLayoutEffect` cleanup can be the better fit than ordinary `useEffect`, because it aligns more closely with visibility changes.

That is not a blanket rule, but for UI-tied DOM cleanup around Activity it is often the correct one.

## Hydration and performance

Activity also helps React split work into isolated chunks during hydration.

Even always-visible Activity boundaries can improve hydration behavior by giving React clearer subtrees to prioritize independently.

This makes Activity not just a visibility primitive, but also a performance hint for structured UI.

## Common mistakes

### Using Activity when you really want reset-on-hide behavior

If reopening should start fresh, do not preserve it with Activity.

### Assuming hidden content is fully unmounted

Effects are cleaned up, but DOM and state are preserved.

### Forgetting DOM-native side effects

Media or embedded content may keep doing work unless cleanup handles it.

### Expecting effect-based data fetching to pre-render

Activity pre-rendering only helps with Suspense-enabled loading.

## Troubleshooting

### "My hidden component still has side effects"

The DOM may still exist and some native behavior may continue. Add explicit cleanup, especially for media and embedded content.

### "My hidden component's effects are not running"

That is expected. Hidden Activity content cleans up Effects until visible again.

### "Why is my draft text preserved?"

Because the DOM node is preserved instead of destroyed.

### "Why does this feel different from conditional rendering?"

Because Activity hides and restores. Conditional rendering unmounts and resets.

## Practical guidance

Use Activity when the right UX is “hide this for now, but keep it warm.”

If the right UX is “close this and forget it,” unmount instead.

The boundary is simple:

- preserve and restore later: `Activity`
- destroy and recreate later: conditional rendering
