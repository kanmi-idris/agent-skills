# App Integration Reference

Use this reference when a Maestro flow needs controlled app behavior, permissions, or app-side awareness that a test is running.

## Detect Maestro in App Code

Prefer explicit launch arguments on mobile. This is reliable locally and in Maestro Cloud.

Flow:

```yaml
- launchApp:
    appId: "com.example.app"
    arguments:
      isMaestro: "true"
```

Android:

```kotlin
val isMaestro = intent.getStringExtra("isMaestro") == "true"
if (isMaestro) {
    // Disable analytics, bypass 2FA, or use mock data.
}
```

iOS:

```swift
if ProcessInfo.processInfo.arguments.contains("isMaestro") {
    // Apply test-only configuration.
}
```

React Native:

```javascript
import { LaunchArguments } from 'react-native-launch-arguments';

if (LaunchArguments.value().isMaestro === "true") {
  // Apply test-only configuration.
}
```

Flutter:

```dart
import 'package:flutter_launch_arguments/flutter_launch_arguments.dart';

Future<void> readArguments() async {
  final args = FlutterLaunchArguments();
  final isMaestro = await args.getBool('isMaestro');
}
```

For web apps, Maestro injects `window.maestro` while a test is running:

```javascript
if (window.maestro) {
  console.log("Maestro test is running");
}
```

Do not use old open-port checks such as Android port `7001` or iOS port `22087`; that approach is deprecated, unsupported in Maestro Cloud, and may disappear.

## When Test-Mode Detection Is Appropriate

Use test-mode detection sparingly and document why it exists. Good use cases:

- Bypass 2FA with fixed test codes.
- Disable analytics or production event emission.
- Route the app to mock or staging services.
- Keep short-lived banners visible long enough to assert.
- Disable custom animations that Maestro cannot stabilize with `waitForAnimationToEnd`.

Avoid hiding real product behavior that the test is supposed to validate. A Maestro flow should still prove the user journey works.

## Permissions on Launch

Configure permissions in `launchApp` to make the starting state deterministic.

```yaml
- launchApp:
    permissions:
      all: deny
      camera: allow
      location: allow
```

Maestro grants all permissions by default unless overridden. Use `all: deny` when testing denied-permission behavior.

## Permissions Mid-Flow

Use `setPermissions` to change permission state during a flow.

```yaml
- setPermissions:
    permissions:
      notifications: allow
```

Maestro manages permissions for iOS and Android apps. It does not control Chrome system permissions for web tests.

## Permission Values

- `allow`: Grant the permission. On iOS, this can also dismiss the system prompt.
- `deny`: Deny the permission. Android may still prompt when a feature requests it.
- `unset`: Reset the permission state so the OS prompts again.

iOS supports extra granular values:

- `location: always`
- `location: inuse`
- `location: never`
- `photos: limited`

Push notifications differ: iOS may show a prompt and Maestro taps Allow, while Android grants silently.

## Common Permissions

| Permission | iOS | Android |
| --- | --- | --- |
| `bluetooth` | No | Yes |
| `calendar` | Yes | Yes |
| `camera` | Yes | Yes |
| `contacts` | Yes | Yes |
| `homekit` | Yes | No |
| `location` | Yes | Yes |
| `medialibrary` | Yes | Yes |
| `microphone` | Yes | Yes |
| `motion` | Yes | No |
| `notifications` | Yes | Yes |
| `phone` | No | Yes |
| `photos` | Yes | No |
| `reminders` | Yes | No |
| `siri` | Yes | No |
| `sms` | No | Yes |
| `speech` | Yes | No |
| `storage` | No | Yes |
| `usertracking` | Yes | No |

Use a full Android permission ID for custom or special Android permissions:

```yaml
- setPermissions:
    permissions:
      com.android.voicemail.permission.ADD_VOICEMAIL: allow
```

For Android special permissions such as `android.permission.MANAGE_EXTERNAL_STORAGE`, set the full permission ID:

```yaml
- launchApp:
    clearState: true
    permissions:
      android.permission.MANAGE_EXTERNAL_STORAGE: deny
```
