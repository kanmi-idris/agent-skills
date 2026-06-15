---
name: boneyard-js
description: Pixel-perfect skeleton loading screens extracted from real DOM or native view trees with boneyard-js. Use when the user mentions boneyard-js, Skeleton components, fixture props, .bones.json, registry.js, generated loading placeholders, DOM-to-skeleton capture, npx boneyard-js build, Vite auto-capture plugin, or wants automatic skeleton loaders without manual measurement.
---

# boneyard-js

Use this skill when implementing automatic skeleton loading UIs that are captured from real rendered content instead of hand-built placeholders.

## Install

```bash
npm install boneyard-js
```

## Core workflow

1. Wrap real content in `<Skeleton name="..." loading={...}>`.
2. Add `fixture` when capture-time auth/data would otherwise block rendering.
3. Run `npx boneyard-js build` while your dev server is running.
4. Import generated registry once (for example `import './bones/registry'`) in your app entry.
5. Re-run build after layout changes.

## React quick start

```tsx
// app/layout.tsx
import './bones/registry'
```

```tsx
import { Skeleton } from 'boneyard-js/react'

function BlogPage() {
  const { data, isLoading } = useFetch('/api/post')

  return (
    <Skeleton
      name="blog-card"
      loading={isLoading}
      fixture={<BlogCard data={MOCK_DATA} />}
    >
      {data && <BlogCard data={data} />}
    </Skeleton>
  )
}
```

## Build command

With dev server running:

```bash
npx boneyard-js build
```

Optional explicit URL:

```bash
npx boneyard-js build http://localhost:5173
```

### CLI behavior

- Auto-detects common local dev ports.
- Auto-detects Tailwind breakpoints (fallback: 375, 768, 1280).
- Crawls internal links from root.
- Captures every `<Skeleton name="...">` at each breakpoint.
- Writes `.bones.json` files and `registry.js`.
- Uses incremental caching and skips unchanged skeletons.

Use `--force` to bypass cache and recapture all skeletons.

## `fixture` prop

`fixture` renders only during capture/build and never in production output. Use it for protected routes, user-specific data, or any state unavailable in crawler context.

```tsx
<Skeleton
  name="dashboard"
  loading={isLoading}
  fixture={
    <Dashboard
      data={{
        title: 'Sample Title',
        stats: [{ label: 'Revenue', value: '$12.3k' }],
      }}
    />
  }
>
  {data && <Dashboard data={data} />}
</Skeleton>
```

## Excluding content from capture

Use `data-no-skeleton`:

```tsx
<nav data-no-skeleton>{/* excluded from capture */}</nav>
```

Or use `snapshotConfig`:

```tsx
<Skeleton
  snapshotConfig={{
    excludeSelectors: ['.icon', '[data-no-skeleton]', 'svg'],
    excludeTags: ['nav', 'footer'],
  }}
>
```

Note: exclusions affect capture only. Content inside `<Skeleton>` is still hidden during loading by runtime behavior.

## Dark mode

Dark mode detection follows `.dark` class presence on `<html>` or any parent element (Tailwind-style). It does not use `prefers-color-scheme`.

Per component override:

```tsx
<Skeleton color="#e5e5e5" darkColor="#2a2a2a" />
```

## Main props

| Prop | Type | Default | Description |
| --- | --- | --- | --- |
| loading | boolean | required | Shows skeleton when true |
| name | string | required | Unique key used for generated bones |
| fixture | ReactNode | - | Build-time mock content only |
| initialBones | ResponsiveBones | - | Manual override for generated bones |
| color | string | `#f0f0f0` | Light mode bone color |
| darkColor | string | `#222222` | Dark mode bone color |
| animate | `"pulse" \| "shimmer" \| "solid"` | `"pulse"` | Skeleton animation mode |
| className | string | - | Wrapper class name |
| fallback | ReactNode | - | Rendered before bones are available |
| snapshotConfig | SnapshotConfig | - | Capture inclusion/exclusion tuning |

## `snapshotConfig`

| Option | Default | Description |
| --- | --- | --- |
| excludeSelectors | `[]` | CSS selectors skipped with children |
| excludeTags | `[]` | HTML tags skipped entirely |
| leafTags | `p,h1-h6,li,tr` | Treated as one solid merged block |
| captureRoundedBorders | `true` | Includes rounded bordered containers |

## Build options

```bash
npx boneyard-js build [url] [options]
  --out <dir>          Output directory (default: ./src/bones)
  --breakpoints <bp>   Viewport widths, comma-separated
  --wait <ms>          Extra wait after load (default: 800)
  --force              Recapture all (skip cache)
  --watch              Re-capture on app changes/HMR
  --no-scan            Skip filesystem route scanning
  --env-file <path>    Load env vars from file
  --native             React Native mode (capture from device)
```

## Bone format

Primary compact format: `[x, y, w, h, r]` with optional sixth value `c` for container bones.

- `x`, `w`: percentages of container width
- `y`, `h`: pixel values
- `r`: border radius (`number` or `"50%"`)
- `c`: optional container flag

Legacy object format (`{ x, y, w, h, r, c? }`) is still supported at runtime.

## Config file

Create `boneyard.config.json` in project root for build and runtime defaults:

```json
{
  "breakpoints": [375, 640, 768, 1024, 1280, 1536],
  "out": "./src/bones",
  "wait": 800,
  "color": "#e5e5e5",
  "darkColor": "#2a2a2a",
  "animate": "shimmer",
  "shimmerColor": "#ebebeb",
  "darkShimmerColor": "#333333",
  "speed": "2s",
  "shimmerAngle": 110
}
```

## Framework entry points

- `boneyard-js`: `snapshotBones`, `renderBones`, `fromElement`
- `boneyard-js/react`: `Skeleton`, `registerBones`, `configureBoneyard`
- `boneyard-js/preact`: same API as React, native Preact hooks (no compat)
- `boneyard-js/native`: React Native `Skeleton`, `registerBones`, `configureBoneyard`
- `boneyard-js/svelte`: `Skeleton`, `registerBones`
- `boneyard-js/vue`: `Skeleton`, `registerBones`, `configureBoneyard`
- `boneyard-js/angular`: `SkeletonComponent`, `registerBones`, `configureBoneyard`
- `boneyard-js/vite`: `boneyardPlugin()`

## React Native notes

```tsx
import { Skeleton } from 'boneyard-js/native'

<Skeleton name="profile" loading={isLoading}>
  <ProfileCard />
</Skeleton>
```

Generate with:

```bash
npx boneyard-js build --native --out ./bones
```

In dev, native scan inspects rendered tree and sends measurements to CLI. In production, scan behavior is inactive.

## Vite plugin

```ts
import { boneyardPlugin } from 'boneyard-js/vite'

export default defineConfig({
  plugins: [boneyardPlugin()],
})
```

This captures on dev start and on HMR updates. Useful options include `out`, `breakpoints`, `wait`, `framework`, and `skipInitial`.

## Known limitations

- Images: captures bounding boxes.
- Dynamic content: reflects layout at capture time.
- CSS transforms: affect position; sizing can differ from intent.
- Portals: content outside snapshot root is not captured.
- Breakpoint logic uses viewport width, not container width.

## Practical guidance

1. Keep skeleton `name` values stable and unique.
2. Use fixture content with realistic structure (count/shape/length), not exact production values.
3. Regenerate bones whenever layout structure changes.
4. Prefer configuring defaults in `boneyard.config.json`; override per component only when needed.
5. For auth-protected pages, combine `fixture` with auth headers/cookies config only when required.
