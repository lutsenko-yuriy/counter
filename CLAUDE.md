# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter counter app targeting all platforms (iOS, Android, macOS, Linux, Windows, Web). Dart SDK ^3.6.0.

## Common Commands

- **Run app:** `flutter run` (add `-d macos`, `-d chrome`, etc. for specific platforms)
- **Analyze:** `flutter analyze`
- **Run all tests:** `flutter test`
- **Run single test:** `flutter test test/counter_list_test.dart`
- **Get dependencies:** `flutter pub get`
- **Regenerate localizations:** `flutter gen-l10n`

## Architecture

**Models** (`lib/models/`):
- `counter.dart` — `Counter` model with integer `id`, auto-generated name (`Counter <id>`), and `increment`/`decrement`/`rename` methods; decrement floors at 0. No serialization logic — kept as a pure model.
- `counter_factory.dart` — `CounterFactory` creates `Counter` instances with auto-incrementing ids; accepts optional `initialNextId` for restoration.
- `counter_list.dart` — `CounterList` holds counters; takes a `CounterFactory` via constructor injection; supports id-based lookup (`operator []`) and removal; `CounterList.restore` constructor for loading persisted state.
- `models.dart` — barrel export.

**State** (`lib/state/`):
- `counter_list_notifier.dart` — `ChangeNotifier` owning all counter mutations (`add`, `remove`, `increment`, `decrement`, `rename`); loads persisted state on startup and auto-saves after every mutation.
- `locale_notifier.dart` — `ChangeNotifier` holding the active `Locale`; updated by the in-app language picker.

**Storage** (`lib/storage/`):
- `counter_storage.dart` — serializes/deserializes `CounterList` to JSON in `SharedPreferences`; all JSON mapping lives here, not in the models.

**UI** (`lib/ui/`):
- `counters_page.dart` — platform dispatcher; selects `CountersPageCupertino` on iOS/macOS, `CountersPageMaterial` on all other platforms.
- `cupertino/counters_page.dart` — Cupertino UI (`CupertinoPageScaffold`, `CupertinoNavigationBar`, `CupertinoButton`, `CupertinoAlertDialog`) for iOS and macOS. Language picker is in the nav bar trailing position. Counters are deleted by swiping toward the trailing edge (`Dismissible` with `endToStart`); on RTL locales (Arabic) this means swiping right.
- `material/counters_page.dart` — Material UI (`Scaffold`, `Card`, `ListTile`, `AlertDialog`) for Android, Web, Windows, and Linux. Language picker is in the app bar actions. Same swipe-to-delete behaviour.
- Both platforms: new counters are added via an "add counter" item at the bottom of the list (no FAB or nav bar button). The swipe-to-delete hint only appears when counters exist.

**Entry point** (`lib/main.dart`):
- `CountersApp` provides `CounterListNotifier` and `LocaleNotifier` via `MultiProvider`; uses `CupertinoApp` on iOS/macOS and `MaterialApp` otherwise; wires localisation delegates and supported locales.

## Localisation

ARB files live in `lib/l10n/`. Supported locales: English (`en`), German (`de`), French (`fr`), Russian (`ru`), Arabic (`ar`), Chinese (`zh`), Japanese (`ja`). Arabic uses RTL layout automatically via `GlobalWidgetsLocalizations.delegate`. The language can be changed at runtime via the globe icon in the top-right corner of the navigation bar. Run `flutter gen-l10n` after editing any ARB file.

## Linting

Uses `package:flutter_lints` (configured in `analysis_options.yaml`).

## Tests

Tests live in `test/` and are split by concern:
- `counter_manipulation_test.dart` — increment, decrement, rename
- `counter_list_test.dart` — initial state, add counter, remove counter, swipe hint
- `language_switching_test.dart` — locale switching and UI text updates

## Workflow

Follow TDD: write or update tests **before** implementing the feature or fix. Red → Green → Refactor.

1. Write failing tests that describe the expected behaviour.
2. Implement the minimum code to make the tests pass.
3. Refactor if needed.
4. Run `flutter test` and `flutter analyze` — fix any failures before proceeding.
5. Update this `CLAUDE.md` file if the architecture, UI, or conventions changed.
6. Commit all changes with a descriptive message.
7. Push to the remote.
8. Compact the context after each commit to keep the conversation lean.
9. Clear the context after the PR with the changes is merged.
