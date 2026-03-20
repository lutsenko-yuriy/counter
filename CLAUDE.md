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

- `lib/models/counter.dart` — `Counter` model with integer `id`, auto-generated name (`Counter <id>`), and `increment`/`decrement`/`rename` methods; decrement floors at 0.
- `lib/models/counter_factory.dart` — `CounterFactory` creates `Counter` instances with auto-incrementing ids.
- `lib/models/counter_list.dart` — `CounterList` holds counters; takes a `CounterFactory` via constructor injection; supports id-based lookup (`operator []`) and removal.
- `lib/models/models.dart` — barrel export for the models package.
- `lib/main.dart` — `CountersPage` (stateful widget) is the sole UI component; receives a `CounterList` via constructor. `CounterFactory` and `CounterList` are wired together in `MyApp`.

## Linting

Uses `package:flutter_lints` (configured in `analysis_options.yaml`).
