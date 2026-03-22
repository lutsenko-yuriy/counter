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

    expect(find.text('Counters'), findsOneWidget);

    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Zähler'), findsOneWidget);
    expect(find.text('Zähler nach links wischen zum Löschen'), findsOneWidget);
  });

  testWidgets('Switching to French updates UI text', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    expect(find.text('Compteurs'), findsOneWidget);
  });

  testWidgets('Switching back to English restores original text',
      (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    // Switch to German
    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Zähler'), findsOneWidget);

    // Switch back to English
    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Counters'), findsOneWidget);
  });
}
