#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
React Native Hidden Styles — quick support matrix

1) Linear gradients
- Use experimental_backgroundImage with a CSS-like linear-gradient(...) string
- Supports angle syntax and multi-position color stops
- Experimental prop: verify project support before relying on it

2) gap / rowGap / columnGap
- Works like CSS gap
- Use numeric pixel values, not strings like '12px'

3) boxShadow
- Requires New Architecture
- Android 9+ for outset shadows
- Android 10+ for inset shadows

4) filter
- Requires New Architecture
- Landed in React Native 0.76
- Cross-platform: brightness, opacity
- Android-only extras: blur, contrast, dropShadow, grayscale, hueRotate, invert, sepia, saturate
- blur and dropShadow require Android 12+
- Implies overflow: hidden

5) mixBlendMode
- Requires New Architecture
- Android 10+
- Often more predictable with isolation: 'isolate'

Docs
- https://reactnative.dev/docs/view-style-props
- https://reactnative.dev/docs/layout-props
- https://reactnative.dev/docs/image-style-props
EOF
