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

Single-file app (`lib/main.dart`) with all UI in one stateful widget. Counter state lives in `_MyHomePageState`. The FAB layout adapts to orientation (row in landscape, column in portrait) using `OrientationBuilder`. Counter has increment (+) and decrement (-) buttons; decrement floors at 0.

## Linting

Uses `package:flutter_lints` (configured in `analysis_options.yaml`).
