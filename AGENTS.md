# AGENTS.md

Instructions for AI agents working on this repository.

## Before You Start

- Read `CLAUDE.md` for project architecture, conventions, and workflow.
- Run `flutter test` and `flutter analyze` to confirm a clean baseline before making changes.

## Workflow

Follow the workflow defined in `CLAUDE.md`. Key points:

1. **Large changes require a plan first.** Present it to the user and wait for approval before writing code.
2. **TDD.** Write or update tests before implementing features or fixes.
3. **Run `flutter test` and `flutter analyze`** after every change. Fix all failures before proceeding.
4. **Update `CLAUDE.md`** if architecture, UI, or conventions change.
5. **Commit, push, and open a PR** when the work is complete.

## Platform Considerations

This app targets six platforms. Keep these in mind:

- **Desktop (macOS, Linux, Windows):** Direct filesystem access via `dart:io`. Auto-save and recent files use original file paths.
- **Mobile (Android, iOS):** Sandboxed storage. File picker handles exports; local copies in the app's documents directory (via `path_provider`) enable auto-save and recent files. The `hasDirectFileAccess` helper in `counter_file_storage.dart` distinguishes these two modes.
- **Web:** No persistent file paths. File picker handles downloads/uploads. Auto-save and recent files are disabled.
- **iOS Simulator:** Does not render flag emojis. The Cupertino UI uses plain language names; the Material UI uses flag emojis (works on Android, web, desktop).

## Testing

- Tests use `SharedPreferences.setMockInitialValues({})` in `setUp` since the app uses SharedPreferences for recent files persistence.
- Material UI tests open the drawer via `ScaffoldState.openDrawer()` (not a tooltip or icon tap).
- Language tests use `find.textContaining(...)` to match language names that may include flag emojis.

## Branding

The app uses a mechanical tally counter theme. When adding UI:

- Use `AppFonts.typewriterStyle()` (Courier Prime) for numeric values, file names, and timestamps.
- Use `AppFonts.logoStyle()` (Raleway) for labels, buttons, and general text.
- Use the cream/metallic palette defined in `CLAUDE.md` — avoid default system colors like `CupertinoColors.secondaryLabel` or `colorScheme.inversePrimary` as they clash with the custom theme.
- Platform icons are generated from `assets/icon.svg` via `rsvg-convert`. If updating the icon, regenerate all platform PNGs.

## Localisation

- ARB files live in `lib/l10n/`. Run `flutter gen-l10n` after editing any ARB file.
- Supported locales: en, de, fr, ru, ar, zh, ja.
- All user-visible strings must be localised across all 7 locales.
