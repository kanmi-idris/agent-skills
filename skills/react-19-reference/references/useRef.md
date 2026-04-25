# `useRef`

## Core purpose

Use `useRef` to keep a mutable value across renders without causing re-renders.

```js
const ref = useRef(initialValue)
```

## Mental model

A ref is a stable box with one property:

```js
ref.current
```

React gives you the same ref object on every render.

That makes refs useful for values that must survive re-renders but are not part of rendered output.

The key distinction:

- state is for rendering
- refs are for persistence without rendering

## Use it when

- you need to store something between renders that should not trigger a re-render
- you need access to a DOM node
- you need to keep imperative handles like interval IDs, timeouts, media instances, or external objects
- you need a stable escape hatch for integration code

Good fits:

- interval or timeout IDs
- focused input refs
- scrolling or media control
- previous imperatively managed instance handles
- lazily created expensive objects that do not belong in render state

## Do not use it when

- the value should update the UI
- you need React to notice changes
- you are trying to replace state for rendered data
- you want to read changing values during render as part of UI logic

If the value belongs in JSX output, it belongs in state, not a ref.

## Smallest good examples

### Store a non-render value

```tsx
import { useRef } from 'react'

function Stopwatch() {
  const intervalRef = useRef(null)

  function handleStart() {
    intervalRef.current = setInterval(() => {
      console.log('tick')
    }, 1000)
  }

  function handleStop() {
    clearInterval(intervalRef.current)
  }
}
```

### Access a DOM node

```tsx
import { useRef } from 'react'

function Form() {
  const inputRef = useRef(null)

  function handleClick() {
    inputRef.current.focus()
  }

  return (
    <>
      <input ref={inputRef} />
      <button onClick={handleClick}>Focus</button>
    </>
  )
}
```

## What `useRef` gives you

`useRef(initialValue)` returns an object whose `current` property is initialized once.

After that:

- React keeps returning the same ref object
- changing `ref.current` does not trigger a render
- React only manages `current` automatically when the ref is attached to JSX via `ref={...}`

## The most important rule

Do not read or write `ref.current` during render, except for predictable one-time initialization.

Bad:

```tsx
function MyComponent() {
  myRef.current = 123
  return <div>{otherRef.current}</div>
}
```

Correct places to use refs:

- event handlers
- Effects
- imperative APIs
- initialization branches that are fully predictable

## Refs vs state

Use state when:

- the value affects what you render
- the UI must update when the value changes

Use refs when:

- the value must survive renders
- the value is only used imperatively
- changes should stay invisible to React rendering

If you put displayed data in a ref, the UI will drift because React will not re-render when it changes.

## DOM access and component refs

Passing a ref to a built-in element like `<input ref={inputRef} />` lets React place the DOM node into `inputRef.current`.

For your own components, the child must explicitly accept and forward the `ref` prop in React 19 style:

```tsx
function MyInput({ ref, ...props }) {
  return <input {...props} ref={ref} />
}
```

If you want to expose a narrower imperative API instead of the raw node, pair this with `useImperativeHandle`.

## High-value patterns

### 1. Timer handles

Store interval or timeout IDs in refs so handlers can clear them later.

### 2. DOM manipulation

Focus, scroll, play, pause, measure, or select text through DOM refs.

### 3. External instances

Keep imperative library instances or expensive objects in refs when they do not belong in render state.

### 4. Lazy ref initialization

If creating the initial object is expensive, initialize lazily:

```tsx
function Video() {
  const playerRef = useRef(null)

  if (playerRef.current === null) {
    playerRef.current = new VideoPlayer()
  }
}
```

This is one of the few acceptable render-time writes because:

- it is predictable
- it only runs for initialization
- it always produces the same result for the same render path

## Common mistakes

### Putting rendered data in a ref

Bad:

```tsx
const countRef = useRef(0)
countRef.current += 1
return <div>{countRef.current}</div>
```

This will not behave like real UI state.

Use `useState` instead if the number must appear correctly in rendered output.

### Reading refs during render

Refs are mutable escape hatches, not reactive inputs for render logic.

### Expecting ref updates to trigger renders

They do not. That is the point.

### Forgetting custom components do not expose DOM refs automatically

Your component must accept the `ref` prop and pass it down, or expose a custom handle.

## Troubleshooting

### "My ref value changes but the UI does not update"

That means the value should probably be state instead of a ref.

### "I cannot get a ref to my custom component"

The child component is not forwarding the `ref` prop to a DOM node or imperative handle.

### "I need an expensive object but do not want to recreate it every render"

Use a nullable ref and initialize it once behind a `current === null` check.

## Practical guidance

Reach for `useRef` when you need persistence without reactivity.

If React should care about the change, use state.

If only your imperative code should care about the change, a ref is usually the right tool.
