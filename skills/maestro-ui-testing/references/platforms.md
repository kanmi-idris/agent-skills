# Platform Reference

Use this reference when a flow depends on a specific app framework or runtime.

## React Native

Maestro needs no React Native test library. It drives the built binary through native accessibility.

Selector priorities:

1. Visible text for stable user-facing labels.
2. `testID` for stable IDs when text changes, localization matters, or controls have no text.
3. Accessibility adjustments for deeply nested iOS touch targets.

React Native example:

```tsx
<TextInput
  placeholder="Username"
  testID="username_input"
/>
```

```yaml
- tapOn:
    id: "username_input"
- inputText: "maestro_user"
```

Expo Go differs from standalone builds. In Expo Go, use `openLink` with the development URL:

```yaml
- openLink: exp://127.0.0.1:19000
```

For EAS or standalone builds, use the package name or bundle ID:

```yaml
appId: ${APP_ID}
---
- launchApp
```

For nested iOS components that are difficult to tap, recommend making the inner element accessible and the wrapper non-accessible so the accessibility tree exposes the intended target.

## Android Native

Maestro tests production-ready APKs without Gradle test dependencies.

Selectors:

- `text`: Android `text` property, including buttons and text views.
- `id`: Android resource ID.
- `description`: content description, especially for icons.
- `text`: can also match hints for empty inputs.

Examples:

```yaml
- tapOn: "Login"
- tapOn:
    id: "login_button"
- tapOn:
    description: "Settings Icon"
```

Use `scrollUntilVisible` for `RecyclerView`, `LazyColumn`, or long lists:

```yaml
- scrollUntilVisible:
    element:
      text: "Item #50"
    direction: DOWN
```

Direct `inputText` of Unicode text may be limited. If a test requires non-ASCII text input, verify the behavior locally and document the limitation.

## Jetpack Compose

Compose support depends on semantics exposed to Android accessibility. Maestro does not inspect Compose internals.

Use visible text when it is stable:

```yaml
- tapOn: "Login"
```

Use semantics for icon-only or ambiguous controls:

```kotlin
Modifier.semantics {
    contentDescription = "Login Button"
}
```

```yaml
- tapOn:
    description: "Login Button"
```

Use resource IDs where available:

```yaml
- tapOn:
    id: "login_button"
```

Tests remain resilient across XML-to-Compose migrations when visible labels and semantic IDs stay stable.

## iOS

Maestro targets iOS apps by bundle ID and drives the iOS Simulator through accessibility and native input. Local execution is for simulators; verify current Maestro support before promising physical iOS device execution.

Permissions can be handled at launch:

```yaml
- launchApp:
    appId: "com.example.app"
    permissions:
      location: allow
      notifications: allow
```

Use environment variables for cross-platform app IDs:

```yaml
appId: ${APP_ID}
---
- launchApp
```

```bash
maestro test -e APP_ID=com.example.app.ios .maestro/
```

Maestro can leave the app and interact with system UI, Safari, and native return breadcrumbs when those elements are visible in the accessibility layer.

## UIKit

For UIKit, Maestro can target visible text, accessibility labels, and accessibility identifiers.

Mapping:

- `accessibilityLabel` maps well to text-like selectors.
- `accessibilityIdentifier` maps to `id` and is the most stable selector for automation.

```swift
let button = UIButton()
button.setTitle("Submit Order", for: .normal)
button.accessibilityIdentifier = "submit_order_button"
```

```yaml
- tapOn:
    id: "submit_order_button"
```

Use `scrollUntilVisible` for `UITableView` and `UICollectionView` rather than coordinates.

## SwiftUI

Use `.accessibilityIdentifier()` for custom controls, icons, or localized text.

```swift
NavigationLink(value: Panel.donutEditor) {
    Label("Donut Editor", systemImage: "slider.horizontal.3")
}
.accessibilityIdentifier("donut_editor")
```

```yaml
- tapOn:
    id: "donut_editor"
```

Tips:

- Use Maestro Studio to inspect how SwiftUI composition appears in the accessibility tree.
- Some picker styles expose limited hierarchy. Text selection can be more reliable than ID selection for those controls.
- Toggles with labels may merge text and switch into one accessibility element.
- Use coordinate taps only for small native controls that cannot be exposed reliably.

## Web

Web support uses the same YAML concepts with `url:` instead of `appId:`.

```yaml
url: https://example.com
---
- launchApp
- tapOn: "Sign in"
- assertVisible: "Welcome"
```

Maestro interacts with the rendered page like a user rather than using DOM APIs directly. It currently focuses on Chromium-based browser automation, so verify current browser support before promising another engine.

For web apps:

- Prefer stable visible text or accessibility labels.
- Use unique labels for repeated controls.
- Use semantic markup where possible.
- For Flutter Web, ensure widgets expose Semantics so Maestro can address them.

Browser state can be retained between flows in the same run. Clear state by origin with `clearState` or `launchApp` options when repeatability matters.
