import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Switching to German updates UI text', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    // Title is now the file name — "Untitled" by default
    expect(find.text('Untitled'), findsOneWidget);

    // Open the drawer to access language picker
    final scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Tap Language in drawer
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    // Title stays "Untitled" (translated to German)
    expect(find.text('Unbenannt'), findsOneWidget);
    expect(find.text('Zähler nach links wischen zum Löschen'), findsOneWidget);
  });

  testWidgets('Switching to French updates UI text', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    // Open drawer
    final scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    expect(find.text('Sans titre'), findsOneWidget);
  });

  testWidgets('Switching back to English restores original text',
      (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    // Switch to German
    var scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Unbenannt'), findsOneWidget);

    // Switch back to English
    scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sprache'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Untitled'), findsOneWidget);
  });
}
