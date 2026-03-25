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

    // Title shows app name when no file is open
    expect(find.text('Counters'), findsWidgets);

    // Open the drawer to access language picker
    final scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Tap Language in drawer
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Deutsch'));
    await tester.pumpAndSettle();

    // Title updates to German app name
    expect(find.text('Zähler'), findsWidgets);
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

    await tester.tap(find.textContaining('Français'));
    await tester.pumpAndSettle();

    expect(find.text('Compteurs'), findsWidgets);
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
    await tester.tap(find.textContaining('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Zähler'), findsWidgets);

    // Switch back to English
    scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sprache'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('English'));
    await tester.pumpAndSettle();

    expect(find.text('Counters'), findsWidgets);
  });
}
