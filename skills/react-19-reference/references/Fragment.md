# `Fragment`

## Core purpose

Use `Fragment` to group sibling elements without adding an extra DOM wrapper.

```js
<>
  <OneChild />
  <AnotherChild />
</>
```

## Mental model

A Fragment is a structural grouping tool for React, not a DOM element.

That means:

- React treats the children as one grouped return value
- the browser does not get an extra wrapper node
- layout, selectors, and semantics stay closer to the real structure you want

Most of the time, `<>...</>` is just the cleanest way to return multiple siblings.

## Use it when

- a component must return multiple sibling elements
- you need grouping without changing the DOM structure
- adding a wrapper `div` would break layout, semantics, or styling
- you want keyed groups inside a list

Good fits:

- component return values with multiple siblings
- lists of grouped siblings
- places where wrapper nodes would break flex, grid, table, or semantic HTML structure

## Do not use it when

- you actually need a real DOM wrapper for styling, layout, semantics, or event targeting
- you need wrapper attributes that only real elements support
- you are using shorthand syntax where an explicit `Fragment` with `key` or `ref` is required

## Smallest good example

```tsx
function Post() {
  return (
    <>
      <PostTitle />
      <PostBody />
    </>
  )
}
```

This groups the two children for React without producing an extra wrapper in the DOM.

## Shorthand vs explicit syntax

Shorthand:

```tsx
<>
  <ChildA />
  <ChildB />
</>
```

Explicit:

```tsx
import { Fragment } from 'react'

<Fragment>
  <ChildA />
  <ChildB />
</Fragment>
```

Use shorthand by default.

Use explicit `Fragment` when you need:

- `key`
- canary `ref`

## Keys

If a Fragment appears in a list and needs a `key`, you must use explicit syntax:

```tsx
import { Fragment } from 'react'

function Blog({ posts }) {
  return posts.map((post) => (
    <Fragment key={post.id}>
      <PostTitle title={post.title} />
      <PostBody body={post.body} />
    </Fragment>
  ))
}
```

You cannot attach `key` to the `<>...</>` shorthand.

## Refs on Fragments

Canary React supports refs on explicit Fragments.

That gives you a `FragmentInstance` instead of a DOM node, which can expose methods for:

- focus management
- DOM observation
- event handling across first-level DOM children
- layout inspection across grouped children

Important boundary:

- this is canary-only guidance
- use explicit `<Fragment ref={...}>`, not shorthand
- this is for advanced DOM coordination without wrapper nodes

If you are not on a canary build, do not rely on Fragment refs.

## When Fragment is the better choice than a wrapper element

Prefer Fragment when the wrapper would be fake structure.

Examples:

- multiple table cells that should not be wrapped in a `div`
- list item internals where extra wrappers complicate styling
- semantic document structure where headings and sections should stay siblings

If the wrapper carries meaning or behavior, use the wrapper.

## State behavior caveat

Fragment grouping does not necessarily reset child state when you switch between equivalent shallow shapes like:

- `<><Child /></>`
- `[<Child />]`
- `<Child />`

At one level deep, React can preserve state across some of these shape changes.

Do not rely on Fragment toggling itself as a deliberate state reset tool unless you fully understand the reconciliation behavior.

## Common mistakes

### Adding wrappers just to satisfy JSX

That often pollutes the DOM unnecessarily. A Fragment is usually cleaner.

### Using shorthand when a `key` is required

This will not work. Switch to explicit `Fragment`.

### Assuming Fragment can replace all wrappers

If you need:

- class names
- styles
- ARIA attributes
- a DOM node for layout or event delegation

you need a real element, not a Fragment.

### Assuming Fragment refs are broadly available

They are canary-specific.

## Practical guidance

Use Fragment by default when the grouping is only for React’s benefit.

Use a real DOM wrapper only when the wrapper has actual semantic, layout, styling, or behavioral value.
