# Counter

A multi-platform Flutter counter app with support for multiple named counters, persistence, and localisation.

## Features

- Create, rename, and delete multiple counters
- Swipe-to-delete with platform-appropriate direction (RTL-aware)
- Persistent storage via SharedPreferences
- Localised in 7 languages: English, German, French, Russian, Arabic, Chinese, and Japanese
- In-app language switching
- Platform-adaptive UI: Cupertino on iOS/macOS, Material on Android/Web/Windows/Linux

## Supported Platforms

iOS, Android, macOS, Linux, Windows, Web

## Getting Started

```bash
flutter pub get
flutter run
```

To target a specific platform:

```bash
flutter run -d macos
flutter run -d chrome
flutter run -d ios
```

## Development

```bash
flutter analyze        # Lint the codebase
flutter test           # Run all tests
flutter gen-l10n       # Regenerate localisation files after editing ARB files
```

## Project Structure

- `lib/models/` — Counter, CounterList, and CounterFactory (pure data models)
- `lib/state/` — ChangeNotifiers for counter list and locale
- `lib/storage/` — JSON serialisation and SharedPreferences persistence
- `lib/ui/` — Platform-adaptive UI (Cupertino and Material variants)
- `lib/l10n/` — ARB localisation files
