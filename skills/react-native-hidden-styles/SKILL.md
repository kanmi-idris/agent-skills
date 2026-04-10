---
name: react-native-hidden-styles
description: |
  Helps apply lesser-known React Native style props like `experimental_backgroundImage`, `boxShadow`, `filter`, `gap`, and `mixBlendMode` with the right platform caveats.

  Triggers when user mentions:
  - "react native hidden styles"
  - "boxShadow in React Native"
  - "mixBlendMode in React Native"
---

# React Native Hidden Styles

Use this skill when a user wants modern React Native styling patterns that are easy to miss in older mental models or web-to-native translations.

This skill infers what it can do from the available project context and config. `.env.example` defines the minimum config for the skill. For this skill, no credentials or required environment variables are needed.

## Quick Usage (Already Configured)

### Show the support matrix
```bash
bash scripts/show-support-matrix.sh
```

### Ask for help directly
- “Show me hidden React Native style props I can use here.”
- “Can I use `boxShadow` in this React Native screen?”
- “How do I use `mixBlendMode` or `filter` in React Native?”

## What This Skill Covers

1. **Linear gradients with `experimental_backgroundImage`**
   - Use `experimental_backgroundImage` with a CSS-like `linear-gradient(...)` string.
   - Support angle syntax like `135deg` and directional syntax like `to right`.
   - Support multi-position color stops like `orange 20% 40%` for striped effects.
   - Treat this as an experimental style prop and say so explicitly.

2. **`filter`**
   - Use `filter` only when the app supports the New Architecture.
   - Mention it landed in React Native 0.76.
   - Accept both CSS-like string syntax and array syntax.
   - Note that filters apply to the element and its descendants.
   - Note that iOS only supports `brightness` and `opacity`.
   - Note that Android supports `blur`, `contrast`, `dropShadow`, `grayscale`, `hueRotate`, `invert`, `sepia`, and `saturate`.
   - Mention that `blur` and `dropShadow` require Android 12+.
   - Always mention that `filter` implies `overflow: 'hidden'`.

3. **`boxShadow`**
   - Use the modern `boxShadow` prop when the project supports the New Architecture.
   - Use a CSS-like string instead of stitching together platform-specific shadow props.
   - Mention support for offsets, blur radius, spread, color, and multiple comma-separated shadow layers.
   - Mention Android support caveats: outset shadows require Android 9+, inset shadows require Android 10+.
   - If unsupported, suggest legacy fallbacks like iOS shadow props and Android `elevation`.

4. **Flexbox `gap`, `rowGap`, `columnGap`**
   - Prefer `gap` over child margin hacks when supported by the project.
   - Use numeric pixel values, not CSS strings like `'12px'`.
   - Keep fallbacks simple when working in older React Native versions.

5. **`mixBlendMode`**
   - Use only with the New Architecture.
   - Call out Android 10+ support requirements.
   - For predictable layering, consider `isolation: 'isolate'` when the blend result depends on stacking context.

## Working Rules

When this skill is used, follow this workflow:

1. Identify whether the request is about a **core style prop** or a **styling technique**.
2. Check whether the target project likely uses the **New Architecture** before recommending `filter`, `boxShadow`, or `mixBlendMode`.
3. Give the user the **smallest working example** for their stack.
4. Include **platform/version caveats** inline, not as an afterthought.
5. If a prop is unavailable, provide the **closest fallback** instead of forcing a brittle solution.
6. If the request is specifically about gradients from this article, prefer `experimental_backgroundImage` examples over third-party gradient wrappers.

## Recommended Response Pattern

When helping with code, structure the answer like this:

1. **Can use / cannot use**
   - State whether the prop or technique is appropriate.
2. **Why**
   - Mention architecture, platform, and version constraints.
3. **Example**
   - Provide a minimal React Native snippet.
4. **Fallback**
   - Offer a compatible alternative if needed.

## Example Guidance Snippets

### `experimental_backgroundImage`
```tsx
<View
  style={{
    experimental_backgroundImage:
      'linear-gradient(to right, red 20%, orange 20% 40%, yellow 40% 60%, green 60% 80%, blue 80%)',
  }}
/>

<View
  style={{
    experimental_backgroundImage: 'linear-gradient(135deg, orange 60%, cyan)',
  }}
/>
```

### `gap`
```tsx
<View style={{ flexDirection: 'row', gap: 12 }}>
  <Chip label="One" />
  <Chip label="Two" />
</View>
```

### `boxShadow`
```tsx
<View
  style={{
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 16,
    boxShadow: '0 8px 24px rgba(15, 23, 42, 0.16)',
  }}
/>
```

### `filter` string syntax
```tsx
<View style={{ filter: 'saturate(0.5) grayscale(0.25)' }} />
```

### `filter` array syntax
```tsx
<View style={{ filter: [{ saturate: 0.5 }, { grayscale: 0.25 }] }} />
```

### `mixBlendMode`
```tsx
<View style={{ isolation: 'isolate' }}>
  <View style={{ backgroundColor: '#FF6B6B', mixBlendMode: 'multiply' }} />
</View>
```

## Common Gotchas

- `linearGradient` is **not** a built-in React Native style prop.
- The article’s gradient pattern uses `experimental_backgroundImage`, not `linearGradient`.
- `boxShadow`, `filter`, and `mixBlendMode` are **New Architecture-sensitive**.
- `filter` is not web-complete on iOS.
- `filter` landed in React Native 0.76.
- `gap` uses numbers, not CSS length strings.
- `mixBlendMode` depends on stacking context and can look wrong without isolation.
- Do not blindly port CSS from the web without checking React Native prop support.

## Using `scripts/`

- `scripts/show-support-matrix.sh` prints a quick compatibility summary and doc links.
- If this skill grows later, keep reusable helpers in `scripts/` rather than embedding large command blocks in responses.

## First-Time Setup (If Not Configured)

1. Open `.env.example` and confirm the minimum config.
2. Verify your React Native version and whether the app uses the New Architecture.
3. If using the article’s gradient approach, verify that `experimental_backgroundImage` is supported in the target app.
4. Use `scripts/show-support-matrix.sh` for a quick refresher before editing code.

## Agent Rule

```md
# Styling instructions

- Use experimental_backgroundImage with a CSS-like string to apply linear gradients. Example: "linear-gradient(to right, red 20%, orange 20% 40%, yellow 40% 60%, green 60% 80%, blue 80%)"

- Use filter to apply visual effects like blur or color adjustments. It supports CSS-like string syntax or an array of objects. Note: full support is Android-only (blur requires Android 12+), while iOS only supports brightness and opacity.

- Use boxShadow with a CSS-like string to apply shadows. Supports offsets, blur, spread, color, and multiple layers separated by commas. Example: "0 4px 24px rgba(0,0,0,0.15)"

- Use gap, rowGap, and columnGap to control spacing between children in flex layouts. gap sets both axes, while rowGap and columnGap let you control them independently. Example: gap: 12 or rowGap: 6, columnGap: 28

- Use mixBlendMode to control how an element blends with its background (e.g. multiply, screen, overlay). Use isolation: "isolate" on a parent to limit blending to that container. Example: mixBlendMode: "multiply"
```

## References

- React Native View Style Props: https://reactnative.dev/docs/view-style-props
- React Native Layout Props: https://reactnative.dev/docs/layout-props
- React Native Image Style Props: https://reactnative.dev/docs/image-style-props
- Inspiration: Code with Beto — “5 React Native Styles You Didn't Know Existed”
