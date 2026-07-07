# krishios

A Flutter application.

## Prerequisites

Before you begin, install the following on your machine:

| Tool | Purpose | Installation |
|------|---------|-------------|
| **Flutter SDK** (^3.12.2) | Core framework | [flutter.dev](https://docs.flutter.dev/get-started/install) |
| **Xcode** (macOS only) | iOS/macOS builds | Mac App Store (free) |
| **CocoaPods** (macOS only) | iOS dependency manager | `sudo gem install cocoapods` |
| **Android Studio** (optional) | Android builds | [developer.android.com/studio](https://developer.android.com/studio) |
| **Google Chrome** (optional) | Web builds | [google.com/chrome](https://www.google.com/chrome/) |

Verify everything is installed:

```sh
flutter doctor
```

Fix any issues marked with `✗` before proceeding.

## Clone & Setup

```sh
git clone <repository-url>
cd krishios_app
flutter pub get
```

## Run the App

### macOS

```sh
flutter run -d macos
```

### iOS (Simulator)

```sh
flutter run -d ios
```

If you get a CocoaPods error, run:

```sh
cd ios && pod install && cd ..
```

### iOS (Physical Device)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your team under **Signing & Capabilities**
3. Connect your iPhone and run:

```sh
flutter run -d <device-id>
```

### Android

```sh
flutter run -d android
```

Or open `android/` in Android Studio and run from there.

### Web

```sh
flutter run -d chrome
```

### List Available Devices

```sh
flutter devices
```

## Build for Distribution

```sh
flutter build apk        # Android
flutter build ios         # iOS (requires Xcode)
flutter build macos       # macOS
flutter build web         # Web
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `flutter: command not found` | Add Flutter to your PATH — see [flutter.dev](https://docs.flutter.dev/get-started/install) |
| CocoaPods not installed | `sudo gem install cocoapods` |
| `pod install` fails | `pod repo update` then retry |
| `flutter run` hangs | Run `flutter clean` then `flutter pub get` |
| iOS signing error | Open `ios/Runner.xcworkspace` in Xcode and set your team under Signing & Capabilities |
| Geolocation permission denied | Enable location services in your simulator/device settings |
| Android build fails | Open `android/` in Android Studio and sync gradle |

## Learn More

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/)
