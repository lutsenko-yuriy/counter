import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:counter/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with one counter at zero', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    expect(find.text('Counter 1'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Add counter creates a new counter', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tap to add a new counter'));
    await tester.pump();

    expect(find.text('Counter 1'), findsOneWidget);
    expect(find.text('Counter 2'), findsOneWidget);
  });

  testWidgets('Swipe left removes counter', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    await tester.drag(find.text('Counter 1'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Counter 1'), findsNothing);
    expect(find.text('Tap to add a new counter'), findsOneWidget);
  });

  testWidgets('Swipe hint is shown when counters exist', (tester) async {
    await tester.pumpWidget(const CountersApp());
    await tester.pumpAndSettle();

    expect(find.text('Swipe a counter left to delete it'), findsOneWidget);
  });
}
