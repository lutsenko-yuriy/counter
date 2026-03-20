# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter counter app targeting all platforms (iOS, Android, macOS, Linux, Windows, Web). Dart SDK ^3.6.0.

## Common Commands

- **Run app:** `flutter run` (add `-d macos`, `-d chrome`, etc. for specific platforms)
- **Analyze:** `flutter analyze`
- **Run all tests:** `flutter test`
- **Run single test:** `flutter test test/widget_test.dart`
- **Get dependencies:** `flutter pub get`

## Architecture

**Models** (`lib/models/`):
- `counter.dart` — `Counter` model with integer `id`, auto-generated name (`Counter <id>`), and `increment`/`decrement`/`rename` methods; decrement floors at 0.
- `counter_factory.dart` — `CounterFactory` creates `Counter` instances with auto-incrementing ids.
- `counter_list.dart` — `CounterList` holds counters; takes a `CounterFactory` via constructor injection; supports id-based lookup (`operator []`) and removal.
- `models.dart` — barrel export.

**UI** (`lib/ui/`):
- `counters_page.dart` — platform dispatcher; selects `CountersPageCupertino` on iOS/macOS, `CountersPageMaterial` on all other platforms.
- `cupertino/counters_page.dart` — Cupertino UI (`CupertinoPageScaffold`, `CupertinoNavigationBar`, `CupertinoButton`, `CupertinoAlertDialog`) for iOS and macOS.
- `material/counters_page.dart` — Material UI (`Scaffold`, `Card`, `ListTile`, `FloatingActionButton`, `AlertDialog`) for Android, Web, Windows, and Linux.

**Entry point** (`lib/main.dart`):
- `CountersApp` uses `CupertinoApp` on iOS/macOS and `MaterialApp` on all other platforms; wires `CounterFactory` and `CounterList` and passes them to `CountersPage`.

## Linting

Uses `package:flutter_lints` (configured in `analysis_options.yaml`).
