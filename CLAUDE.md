# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter counter app ("Counters") targeting all platforms (iOS, Android, macOS, Linux, Windows, Web). Dart SDK ^3.6.0. Branded with a mechanical tally counter theme — metallic silver/cream color palette, Courier Prime typewriter font for numbers, and Raleway logo font for UI text.

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
- `recent_file.dart` — `RecentFile` pure model with `path`, `name`, and `lastOpened` fields; tracks recently opened/saved counter files.
- `models.dart` — barrel export.

**State** (`lib/state/`):
- `counter_list_notifier.dart` — `ChangeNotifier` owning all counter mutations (`add`, `remove`, `increment`, `decrement`, `rename`, `replaceCounters`). Receives initial state (counters + file info) at construction — no async loading or SharedPreferences dependency. Tracks the current open file (`currentFileName`, `currentFilePath`), `lastSavedAt` timestamp (initialized to `DateTime.now()` when restored from a file path), and auto-saves to the current file with a 1-second debounce after each mutation.
- `locale_notifier.dart` — `ChangeNotifier` holding the active `Locale`; updated by the in-app language picker.
- `recent_files_notifier.dart` — `ChangeNotifier` managing the recently opened files list; caps at 10 entries; persists via `RecentFilesStorage`.

**Storage** (`lib/storage/`):
- `counter_json.dart` — shared JSON serialization helpers (`counterListToJson`, `counterListFromJson`); used by `CounterFileStorage`.
- `counter_storage.dart` — legacy; no longer used by the notifier. May be removed.
- `counter_file_storage.dart` — handles reading/writing counter data to/from JSON files via `file_picker`; supports `pickAndLoad`, `pickAndSave`, `loadFromPath` (for startup restore), and `saveToPath` (for auto-save). Uses conditional imports (`file_writer_native.dart`/`file_writer_web.dart`) for cross-platform file I/O. On mobile, saves a local copy to the app's documents directory (via `path_provider`) for auto-save and recent files, since SAF/sandbox paths from the file picker aren't directly writable by `dart:io`. The `hasDirectFileAccess` helper distinguishes desktop (direct `dart:io`) from mobile (local copy needed).
- `file_writer_native.dart` / `file_writer_web.dart` / `file_writer_stub.dart` — conditional-import triad for platform-specific file reading and writing (`dart:io` on native, no-op/unsupported on web).
- `recent_files_storage.dart` — persists the recent files list as JSON in `SharedPreferences`.

**UI** (`lib/ui/`):
- `counters_page.dart` — platform dispatcher; selects `CountersPageCupertino` on iOS/macOS, `CountersPageMaterial` on all other platforms.
- `app_fonts.dart` — centralised font configuration using `google_fonts`. `AppFonts.typewriterStyle()` returns Courier Prime (for counter values, file titles, saved-ago text). `AppFonts.logoStyle()` returns Raleway with letter-spacing (for all other UI text). `AppFonts.materialTextTheme()` returns a Raleway-based `TextTheme` for the Material root.
- `splash_screen.dart` — animated splash screen showing the full tally counter SVG (`assets/tally_counter.svg`) on a cream background. Fades in, holds, then fades out over 2.4 seconds before transitioning to the main app.
- `saved_ago_text.dart` — shared widget displaying "Saved X ago" with a `Timer.periodic` that auto-updates every second; shows nothing if no save has occurred.
- `material/counters_page.dart` — Material UI with a `Drawer` (hamburger menu) containing Save to File, Open from File, Language picker, and Recent Files list with clear option. App bar title shows the current file name (or "Untitled" localized) with the saved-ago subtitle. Counters are deleted by swiping toward the trailing edge (`Dismissible` with `endToStart`). Language picker shows flag emojis next to language names.
- `cupertino/counters_page.dart` — Cupertino UI with an ellipsis-circle button in the nav bar trailing position that opens a `CupertinoActionSheet` containing Save to File, Open from File, Language, and Recent Files. Nav bar middle shows the file name and saved-ago text. Same swipe-to-delete behaviour. Language picker shows plain language names (no flag emojis — iOS Simulator strips the flag emoji font).
- Both platforms: new counters are added via an "add counter" item at the bottom of the list (no FAB or nav bar button). The swipe-to-delete hint only appears when counters exist. The empty state (no file open) shows recent files on all native platforms, allowing quick access without opening the drawer/menu.

**Assets** (`assets/`):
- `tally_counter.svg` — full mechanical tally counter illustration used on the splash screen. Digits use Courier Prime, label uses Raleway.
- `icon.svg` — square app icon showing the counter display with "0451" and "Counters" label. Source for all platform icon PNGs (generated via `rsvg-convert`).

**Entry point** (`lib/main.dart`):
- `main()` is async: on native, loads the recent files list and tries to restore counters from the most recent file. Iterates through recent files in order; removes stale entries (file not found) and passes their paths to the UI for error display. On web or when no recent files exist, starts with empty state.
- `CountersApp` accepts optional `initialCounters`, `initialFileName`, `initialFilePath`, and `staleFilePaths`; provides `CounterListNotifier`, `LocaleNotifier`, and `RecentFilesNotifier` via `MultiProvider`; uses `CupertinoApp` on iOS/macOS and `MaterialApp` otherwise; wires localisation delegates and supported locales.

## Branding & Color Palette

The app uses a mechanical tally counter theme derived from `assets/tally_counter.svg`:

| Token | Hex | Usage |
|-------|-----|-------|
| Cream | `#F5F0E0` | Scaffold background, app bar (Material), display inner |
| Card cream | `#FAF6ED` | Card/counter row background |
| Metallic silver | `#B0B0B0` | Cupertino nav bar background, tally counter body |
| Steel | `#888888` | FAB, secondary icons, add-counter button |
| Dark steel | `#666666` | Primary color, +/- buttons |
| Near black | `#222222` | Primary text |

**Fonts** (via `google_fonts`, SIL Open Font License):
- **Courier Prime** — typewriter style for counter values, file titles, saved-ago text
- **Raleway** — logo style with letter-spacing for all other UI text

## File Save/Restore

The app supports a document-style workflow:
- **Startup restore**: on native platforms, the app tries to load the most recently opened file. If it no longer exists, it is removed from recents and the next file is tried. If all files are stale (or none exist), the app shows the empty welcome state. Stale file errors are shown to the user (SnackBar on Material, CupertinoAlertDialog on Cupertino).
- **Save to File**: exports the current counter list as a formatted JSON file via the system file picker.
- **Open from File**: imports counters from a previously saved JSON file, replacing the current list.
- **Auto-save**: after any counter mutation, a 1-second debounce timer auto-saves to the currently open file (all native platforms). On desktop, writes directly to the original file path. On mobile, writes to a local copy in the app's documents directory.
- **Recent Files**: tracks up to 10 recently opened/saved files; persisted in SharedPreferences. Available on all native platforms (desktop uses original paths, mobile uses local copies). Disabled on web (no persistent file paths).
- **Dynamic title**: the app bar/nav bar shows the current file name instead of "Counters"; shows the localized app title when no file is open.
- **Saved-ago indicator**: a subtitle beneath the title shows "Saved Xs ago" / "Saved Xm ago" / "just now", updating every second.

The JSON file format: `{"counters": [{"id": 1, "name": "...", "value": 0}, ...]}`.

## Localisation

ARB files live in `lib/l10n/`. Supported locales: English (`en`, "Counters"), German (`de`, "Zähler"), French (`fr`, "Compteurs"), Russian (`ru`, "Счётчики"), Arabic (`ar`, "العدادات"), Chinese (`zh`, "计数器"), Japanese (`ja`, "カウンター"). Arabic uses RTL layout automatically via `GlobalWidgetsLocalizations.delegate`. The language can be changed at runtime via the drawer (Material) or the ellipsis menu (Cupertino). Run `flutter gen-l10n` after editing any ARB file.

## Linting

Uses `package:flutter_lints` (configured in `analysis_options.yaml`).

## Tests

Tests live in `test/` and are split by concern:
- `counter_json_test.dart` — JSON serialization round-trip, empty lists, factory nextId restoration
- `counter_manipulation_test.dart` — increment, decrement, rename
- `counter_list_test.dart` — initial state, add counter, remove counter, swipe hint
- `counter_file_operations_test.dart` — replaceCounters, current file tracking, saved-at timestamp
- `recent_files_test.dart` — RecentFile model, add/remove/clear, cap at 10, persistence, notifications
- `language_switching_test.dart` — locale switching via drawer and UI text updates

## Workflow

Follow TDD: write or update tests **before** implementing the feature or fix. Red → Green → Refactor.

**For large changes** (spanning multiple files, introducing new domain entities, new dependencies, or architectural shifts): present an implementation plan to the user **before writing any code**. The plan should cover:

1. New packages / dependencies
2. New models and classes
3. Changes to existing classes
4. UI changes (for each platform)
5. Test strategy
6. Implementation order broken into phases

After that, wait for the user to review and approve (or adjust) the plan before proceeding.

1. For large changes, present the implementation plan and wait for approval.
2. Write failing tests that describe the expected behaviour.
3. Implement the minimum code to make the tests pass.
4. Refactor if needed.
5. Run `flutter test` and `flutter analyze` — fix any failures before proceeding.
6. Update this `CLAUDE.md` file if the architecture, UI, or conventions changed.
7. Commit all changes with a descriptive message.
8. Push to the remote.
9. Compact the context after each commit to keep the conversation lean.
10. After creating a PR, cancel any existing `/babysit-prs` loops and start a fresh one: `/loop 10m /babysit-prs`.
11. Clear the context after the PR with the changes is merged.
