# `useImperativeHandle`

## Core purpose

Use `useImperativeHandle` to customize what a parent receives through a ref.

```js
useImperativeHandle(ref, createHandle, dependencies?)
```

## Mental model

Normally, a ref points at a DOM node or component-exposed handle.

`useImperativeHandle` lets a component expose a **narrow imperative API** instead of exposing the whole underlying node.

Typical use:

- expose `focus()`
- expose `scrollIntoView()`
- expose a small custom action like `scrollAndFocusAddComment()`

It is not a general state management tool.

## Most important rule

Expose the smallest imperative surface necessary.

If the behavior can be expressed declaratively through props, prefer props over refs.

Good imperative cases:

- focus
- scroll
- text selection
- starting an animation
- bridging to imperative child APIs

Bad imperative cases:

- open/close state that could be a prop
- general parent-driven business logic
- broad DOM access “just in case”

## React 19 note

In React 19, `ref` is available as a prop.

In earlier React versions, this pattern required `forwardRef`.

## Use it when

- the parent needs to trigger an imperative behavior on a child
- the child should not expose its full internal DOM node
- a higher-level component needs to compose several imperative child actions behind one method

Good fits:

- focusing an input
- scrolling a list
- focusing and scrolling in one combined method
- exposing a small widget control surface

## Do not use it when

- props would express the behavior more clearly
- the parent needs to control state rather than trigger an imperative action
- you are exposing raw DOM access without a strong reason

## Smallest good example

```tsx
import { useImperativeHandle, useRef } from 'react'

function MyInput({ ref, ...props }) {
  const inputRef = useRef(null)

  useImperativeHandle(ref, () => {
    return {
      focus() {
        inputRef.current.focus()
      },
      scrollIntoView() {
        inputRef.current.scrollIntoView()
      },
    }
  }, [])

  return <input {...props} ref={inputRef} />
}
```

Why this is a good fit:

- the parent gets exactly the methods it needs
- the raw DOM node is not exposed
- the imperative API is intentionally narrow

## High-value patterns

### 1. Restrict DOM exposure

Instead of exposing the entire DOM node, expose only the safe methods you want parents to use.

This keeps the component boundary cleaner and reduces accidental coupling.

### 2. Compose child imperative actions

You can build a higher-level method by coordinating multiple refs:

```tsx
useImperativeHandle(ref, () => {
  return {
    scrollAndFocusAddComment() {
      commentsRef.current.scrollToBottom()
      addCommentRef.current.focus()
    },
  }
}, [])
```

This is a good use of imperative handles because the parent needs one explicit action, not deep knowledge of the child tree.

### 3. Bridge to imperative libraries

If a child wraps an imperative third-party widget, expose a minimal command surface rather than the whole integration object when possible.

## Dependency guidance

`createHandle` follows the usual Hook dependency rules.

Include every reactive value used inside the handle creation logic:

- props
- state
- functions declared in the component body
- variables declared in the component body

If you omit the dependency array, React recreates the handle every render.

If you include `[]`, that only stays valid if the handle does not depend on changing reactive values.

## Common mistakes

### Exposing too much

Bad:

- returning the whole DOM node plus custom helpers
- exposing internal refs broadly
- letting parents manipulate internals freely

Prefer a tiny API with explicit methods.

### Using refs for declarative state

Bad instinct:

```tsx
modalRef.current.open()
modalRef.current.close()
```

when:

```tsx
<Modal isOpen={isOpen} />
```

would be clearer.

### Forgetting that the child still needs its own internal ref

If you want to expose custom methods around a DOM node, keep the actual node in a separate internal ref:

```tsx
const inputRef = useRef(null)
```

then build the public handle from that.

### Treating it like an escape hatch for normal parent-child communication

Use it for imperative behavior only. If the parent wants to describe state, prefer props.

## Troubleshooting

### “The parent ref is `null`”

Check:

- is the child actually receiving the `ref` prop?
- is the component mounted yet?
- in older React versions, did you forget `forwardRef`?

### “My handle methods use stale values”

Your handle likely depends on reactive values that are missing from the dependency array.

Include the needed dependencies or restructure so the handle methods read current refs rather than stale captured values.

### “Why not just expose the DOM node?”

Sometimes you should. If the only need is direct DOM access and the boundary is simple, forwarding the node may be enough.

Use `useImperativeHandle` when you want to narrow or shape that API intentionally.

## Practical decision line

Use `useImperativeHandle` when a component must expose a small imperative API through a ref. Keep the API narrow, and prefer declarative props whenever the behavior can be expressed without imperative commands.
